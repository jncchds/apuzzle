// Stage 2 of the nonogram catalog build (stage 1: render.mjs). For every new
// rendered picture it picks the smallest size that still reads well and is
// uniquely solvable by the game's own solver, grades it, and appends it to
// the catalog. Existing entries never move or change, so share codes and past
// dailies stay valid. See README.md.
//   dart run tools/nonogram/build.dart --since=2026-10-01 [--dry-run] [--rebucket]
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:apuzzle/puzzles/nonogram/nonogram_solver.dart';

const toolDir = 'tools/nonogram';
const catalogPath = '$toolDir/catalog.tsv';
const paramsPath = '$toolDir/params.json';
const excludePath = '$toolDir/exclude.txt';
const candidatesPath = '$toolDir/cache/candidates.jsonl';
const judgePath = '$toolDir/cache/judge.jsonl';
const assetDir = 'assets/nonogram';

const modes = ['mono', 'color'];
const difficulties = ['easy', 'medium', 'hard', 'expert'];

/// Best size: the smallest width whose fidelity reaches [knee] × the picture's
/// best fidelity (where extra cells stop adding much), and at least [minFid].
const knee = 0.92;
const minFid = {'mono': 0.55, 'color': 0.55};

/// Filled share of the grid; outside this range clues get trivial or vague.
const minFill = 0.2;
const maxFill = 0.85;

/// Day numbers in the asset count from here.
final epoch = DateTime.utc(2026, 1, 1);

/// Source index in the asset (for the credits screen). Append only.
const sourceIds = ['game-icons', 'material-symbols', 'twemoji', 'openmoji'];

class Entry {
  Entry({
    required this.mode,
    required this.difficulty,
    required this.index,
    required this.id,
    required this.since,
    required this.width,
    required this.height,
    required this.colors,
    required this.cells,
    required this.score,
    required this.tier,
    required this.fid,
  });

  final String mode;
  String difficulty;
  int index;
  final String id;
  final String since;
  final int width;
  final int height;
  final List<String> colors;
  final List<int> cells;
  final double score;
  final int tier;
  final double fid;

  static const header = 'mode\tdifficulty\tindex\tid\tsince\tw\th\tcolors\tscore\ttier\tfid\tcells';

  String toTsv() => [
        mode, difficulty, index, id, since, width, height, colors.isEmpty ? '-' : colors.join(','), //
        score.toStringAsFixed(1), tier, fid.toStringAsFixed(3), cells.join(),
      ].join('\t');

  factory Entry.fromTsv(String line) {
    final f = line.split('\t');
    return Entry(
      mode: f[0],
      difficulty: f[1],
      index: int.parse(f[2]),
      id: f[3],
      since: f[4],
      width: int.parse(f[5]),
      height: int.parse(f[6]),
      colors: f[7] == '-' ? const [] : f[7].split(','),
      score: double.parse(f[8]),
      tier: int.parse(f[9]),
      fid: double.parse(f[10]),
      cells: [for (final c in f[11].codeUnits) c - 48],
    );
  }

  String get pictureKey => '$mode $width $height ${cells.join()}';
}

/// Difficulty score: bigger boards, longer deduction chains and probing make
/// harder puzzles. Buckets are quantiles of this, frozen in params.json.
double scoreOf(int cells, NonoSolveResult r) => cells * (1 + 0.04 * r.rounds) * (r.tier >= 2 ? 1.5 + 0.1 * r.probes : 1);

const minSide = 5;

/// Drops empty border rows and columns (inner empty lines are fine: clue 0).
(int, int, List<int>) trim(int w, int h, List<int> cells) {
  bool rowEmpty(int r) => [for (var c = 0; c < w; c++) cells[r * w + c]].every((v) => v == 0);
  bool colEmpty(int c) => [for (var r = 0; r < h; r++) cells[r * w + c]].every((v) => v == 0);
  var r0 = 0, r1 = h, c0 = 0, c1 = w;
  while (r0 < r1 && rowEmpty(r0)) {
    r0++;
  }
  while (r1 > r0 && rowEmpty(r1 - 1)) {
    r1--;
  }
  while (c0 < c1 && colEmpty(c0)) {
    c0++;
  }
  while (c1 > c0 && colEmpty(c1 - 1)) {
    c1--;
  }
  return (c1 - c0, r1 - r0, [for (var r = r0; r < r1; r++) for (var c = c0; c < c1; c++) cells[r * w + c]]);
}

Map<String, String> parseArgs(List<String> args) => {
      for (final a in args)
        if (a.startsWith('--')) a.substring(2).split('=').first: a.contains('=') ? a.substring(a.indexOf('=') + 1) : 'true',
    };

/// Stable 32-bit FNV-1a, to interleave new pictures from all sources.
int fnv(String s) {
  var h = 0x811C9DC5;
  for (final c in utf8.encode(s)) {
    h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

void main(List<String> argv) {
  final args = parseArgs(argv);
  final since = args['since'];
  if (since == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(since)) {
    stderr.writeln('Usage: dart run tools/nonogram/build.dart --since=YYYY-MM-DD [--dry-run] [--rebucket]');
    exit(64);
  }
  final dry = args['dry-run'] == 'true';

  final catalog = File(catalogPath).existsSync()
      ? [for (final l in File(catalogPath).readAsLinesSync().skip(1)) if (l.trim().isNotEmpty) Entry.fromTsv(l)]
      : <Entry>[];
  final known = {for (final e in catalog) e.id};
  final pictures = {for (final e in catalog) e.pictureKey};
  final exclude = File(excludePath).existsSync()
      ? {for (final l in File(excludePath).readAsLinesSync()) if (l.trim().isNotEmpty && !l.startsWith('#')) l.trim()}
      : <String>{};

  // Smallest recognisable width per picture, from judge.mjs (if it ran):
  // pictures it couldn't recognise are dropped, the rest start at its width.
  final judged = File(judgePath).existsSync()
      ? {
          for (final l in File(judgePath).readAsLinesSync())
            if (l.trim().isNotEmpty) (jsonDecode(l) as Map<String, dynamic>)['id'] as String: (jsonDecode(l) as Map<String, dynamic>)['pick'] as int?,
        }
      : null;

  // --- grade new pictures ---
  final fresh = <Entry>[];
  final dropped = <String, int>{};
  void drop(String why) => dropped[why] = (dropped[why] ?? 0) + 1;
  final sw = Stopwatch()..start();
  for (final line in File(candidatesPath).readAsLinesSync()) {
    final j = jsonDecode(line) as Map<String, dynamic>;
    final id = j['id'] as String;
    if (known.contains(id)) continue;
    if (exclude.contains(id) || exclude.contains(id.split(':').first) || exclude.any((x) => x.endsWith('*') && id.startsWith(x.substring(0, x.length - 1)))) {
      drop('excluded');
      continue;
    }
    final mode = j['mode'] as String;
    final colors = [for (final c in (j['colors'] as List?) ?? const []) c as String];
    final cands = [for (final c in j['cands'] as List) c as Map<String, dynamic>];
    final best = cands.map((c) => (c['fid'] as num).toDouble()).reduce(max);
    final minWidth = judged == null ? minSide : judged[id];
    if (judged != null && minWidth == null) {
      drop(judged.containsKey(id) ? 'not recognisable' : 'not judged');
      continue;
    }
    // With the judge the size is settled; fidelity only ranks variants.
    final target = judged != null ? minFid[mode]! : max(minFid[mode]!, knee * best);
    if (best < minFid[mode]!) {
      drop('low fidelity');
      continue;
    }
    final widths = {for (final c in cands) if (c['w'] as int >= minWidth!) c['w'] as int}.toList()..sort();
    Entry? pick;
    var reason = 'not unique at any size';
    for (final w in widths) {
      final atW = [
        for (final c in cands)
          if (c['w'] == w && (c['fid'] as num) >= target) c,
      ]..sort((a, b) => (b['fid'] as num).compareTo(a['fid'] as num));
      for (final c in atW) {
        final (width, height, cells) = trim(c['w'] as int, c['h'] as int, [for (final u in (c['cells'] as String).codeUnits) u - 48]);
        if (width < minWidth! || height < minSide) {
          reason = 'too small after trimming';
          continue;
        }
        final fill = cells.where((v) => v != 0).length / cells.length;
        if (fill < minFill || fill > maxFill) {
          reason = 'fill out of range';
          continue;
        }
        final nColors = mode == 'mono' ? 1 : colors.length;
        final res = NonogramSolver.forPicture(width, height, nColors, cells).solve();
        if (!res.solved) continue;
        // Colours the grid actually uses, renumbered 1..k.
        final used = {for (final v in cells) if (v > 0) v}.toList()..sort();
        if (mode == 'color' && used.length < 2) {
          reason = 'one colour left';
          continue;
        }
        final remap = {for (var i = 0; i < used.length; i++) used[i]: i + 1};
        final key = '$mode $width $height ${cells.map((v) => v == 0 ? 0 : remap[v]).join()}';
        if (pictures.contains(key)) {
          reason = 'duplicate picture';
          continue;
        }
        pictures.add(key);
        pick = Entry(
          mode: mode,
          difficulty: '',
          index: -1,
          id: id,
          since: since,
          width: width,
          height: height,
          colors: mode == 'mono' ? const [] : [for (final u in used) colors[u - 1]],
          cells: [for (final v in cells) v == 0 ? 0 : remap[v]!],
          score: scoreOf(width * height, res),
          tier: res.tier,
          fid: (c['fid'] as num).toDouble(),
        );
        break;
      }
      if (pick != null) break;
    }
    if (pick == null) {
      drop(reason);
      continue;
    }
    fresh.add(pick);
  }
  print('graded ${fresh.length} new pictures in ${(sw.elapsedMilliseconds / 1000).toStringAsFixed(1)} s');
  print('dropped: ${dropped.entries.map((e) => '${e.key} ${e.value}').join(', ')}');

  // --- difficulty buckets (quantiles, frozen once the catalog ships) ---
  final paramsFile = File(paramsPath);
  var params = paramsFile.existsSync() ? jsonDecode(paramsFile.readAsStringSync()) as Map<String, dynamic> : <String, dynamic>{};
  if (params['cuts'] == null || args['rebucket'] == 'true') {
    if (catalog.isNotEmpty && args['rebucket'] == 'true') {
      stderr.writeln('warning: --rebucket moves shipped pictures between difficulties; old share codes break.');
    }
    final all = [...catalog, ...fresh];
    params = {
      'cuts': {
        for (final m in modes)
          m: () {
            final s = [for (final e in all) if (e.mode == m) e.score]..sort();
            if (s.isEmpty) return <double>[];
            return [for (var q = 1; q < difficulties.length; q++) s[(s.length * q / difficulties.length).floor()]];
          }(),
      },
    };
    if (args['rebucket'] == 'true') {
      for (final e in catalog) {
        e.difficulty = '';
      }
    }
  }
  String bucket(Entry e) {
    final cuts = [for (final c in (params['cuts'][e.mode] as List)) (c as num).toDouble()];
    var d = 0;
    while (d < cuts.length && e.score >= cuts[d]) {
      d++;
    }
    return difficulties[d];
  }

  // Interleave sources, then append to each pool.
  fresh.sort((a, b) => fnv(a.id).compareTo(fnv(b.id)));
  for (final e in [...catalog.where((e) => e.difficulty.isEmpty), ...fresh]) {
    e.difficulty = bucket(e);
  }
  if (args['rebucket'] == 'true') {
    final next = <String, int>{};
    for (final e in catalog) {
      e.index = next.update('${e.mode}.${e.difficulty}', (v) => v + 1, ifAbsent: () => 0);
    }
  }
  final next = <String, int>{};
  for (final e in catalog) {
    final k = '${e.mode}.${e.difficulty}';
    next[k] = max(next[k] ?? 0, e.index + 1);
  }
  for (final e in fresh) {
    e.index = next.update('${e.mode}.${e.difficulty}', (v) => v + 1, ifAbsent: () => 0);
  }
  final all = [...catalog, ...fresh];

  // --- report ---
  for (final m in modes) {
    print('\n$m (cuts ${params['cuts'][m]})');
    for (final d in difficulties) {
      final es = [for (final e in all) if (e.mode == m && e.difficulty == d) e];
      if (es.isEmpty) continue;
      final sizes = <String, int>{};
      for (final e in es) {
        sizes.update('${e.width}x${e.height}', (v) => v + 1, ifAbsent: () => 1);
      }
      final top = (sizes.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).take(6);
      final probing = es.where((e) => e.tier >= 2).length;
      final bySrc = <String, int>{};
      for (final e in es) {
        bySrc.update(e.id.split(':').first, (v) => v + 1, ifAbsent: () => 1);
      }
      print('  ${d.padRight(7)} ${es.length.toString().padLeft(5)}  probing ${probing.toString().padLeft(4)}  '
          'sizes ${top.map((e) => '${e.key}:${e.value}').join(' ')}  $bySrc');
    }
  }

  writeReview(all);
  if (dry) {
    print('\ndry run: catalog and assets not written');
    return;
  }
  all.sort((a, b) => '${a.mode}.${difficulties.indexOf(a.difficulty)}'.compareTo('${b.mode}.${difficulties.indexOf(b.difficulty)}') != 0
      ? '${a.mode}.${difficulties.indexOf(a.difficulty)}'.compareTo('${b.mode}.${difficulties.indexOf(b.difficulty)}')
      : a.index.compareTo(b.index));
  File(catalogPath).writeAsStringSync('${Entry.header}\n${all.map((e) => e.toTsv()).join('\n')}\n');
  paramsFile.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(params)}\n');
  Directory(assetDir).createSync(recursive: true);
  for (final m in modes) {
    final bytes = encodeAsset([for (final e in all) if (e.mode == m) e]);
    File('$assetDir/$m.bin').writeAsBytesSync(bytes);
    print('$assetDir/$m.bin: ${(bytes.length / 1024).toStringAsFixed(1)} KB');
  }
}

/// Asset layout (little endian):
///   u8 version (1), u8 difficulty count;
///   per difficulty: u16 count, then entries in pool order:
///     u16 since (days from 2026-01-01), u8 width, u8 height, u8 source,
///     u8 colours k, k × RGB, cells row-major at ceil(log2(k + 1)) bits each.
Uint8List encodeAsset(List<Entry> entries) {
  final b = BytesBuilder();
  void u8(int v) => b.addByte(v);
  void u16(int v) => b.add([v & 0xFF, v >> 8]);
  u8(1);
  u8(difficulties.length);
  for (final d in difficulties) {
    final pool = [for (final e in entries) if (e.difficulty == d) e]..sort((a, b) => a.index.compareTo(b.index));
    u16(pool.length);
    for (final e in pool) {
      u16(DateTime.parse('${e.since}T00:00:00Z').difference(epoch).inDays);
      u8(e.width);
      u8(e.height);
      u8(sourceIds.indexOf(e.id.split(':').first));
      final k = e.colors.isEmpty ? 1 : e.colors.length;
      u8(k);
      for (final c in e.colors) {
        final v = int.parse(c.substring(1), radix: 16);
        b.add([v >> 16, (v >> 8) & 0xFF, v & 0xFF]);
      }
      final bits = (k + 1 - 1).bitLength;
      var acc = 0, n = 0;
      for (final v in e.cells) {
        acc |= v << n;
        n += bits;
        while (n >= 8) {
          u8(acc & 0xFF);
          acc >>= 8;
          n -= 8;
        }
      }
      if (n > 0) u8(acc & 0xFF);
    }
  }
  return b.toBytes();
}

/// `cache/review-<mode>.html`: every picture next to its source icon, grouped by
/// difficulty, to spot bad ones (add their ids to exclude.txt).
void writeReview(List<Entry> all) {
  final sets = <String, Map<String, dynamic>>{};
  Map<String, dynamic> setOf(String name) =>
      sets[name] ??= jsonDecode(File('$toolDir/node_modules/@iconify-json/$name/icons.json').readAsStringSync()) as Map<String, dynamic>;
  String svgOf(String fullId) {
    final [name, id] = fullId.split(':');
    final set = setOf(name);
    final ic = (set['icons'] as Map)[id] as Map;
    final w = ic['width'] ?? set['width'] ?? 16, h = ic['height'] ?? set['height'] ?? 16;
    return '<svg viewBox="${ic['left'] ?? 0} ${ic['top'] ?? 0} $w $h" width="64" height="64" style="color:var(--fg)">${ic['body']}</svg>';
  }

  String gridOf(Entry e) {
    const cell = 5;
    final sb = StringBuffer('<svg width="${e.width * cell}" height="${e.height * cell}">');
    for (var i = 0; i < e.cells.length; i++) {
      final v = e.cells[i];
      if (v == 0) continue;
      final fill = e.colors.isEmpty ? 'var(--fg)' : e.colors[v - 1];
      sb.write('<rect x="${i % e.width * cell}" y="${i ~/ e.width * cell}" width="$cell" height="$cell" fill="$fill"/>');
    }
    return '$sb</svg>';
  }

  File('$toolDir/cache/review.json').writeAsStringSync(jsonEncode([
    for (final e in all) {'id': e.id, 'mode': e.mode, 'difficulty': e.difficulty, 'w': e.width, 'h': e.height, 'colors': e.colors, 'cells': e.cells.join(), 'tier': e.tier, 'score': e.score},
  ]));
  for (final m in modes) {
    final sb = StringBuffer('''<!doctype html><meta charset="utf-8"><title>Nonogram review: $m</title>
<style>:root{--bg:#fff;--fg:#111;--mut:#777}@media(prefers-color-scheme:dark){:root{--bg:#1b1b1f;--fg:#eee;--mut:#999}}
body{background:var(--bg);color:var(--fg);font:12px system-ui;margin:16px}h2{margin:24px 0 8px}
.g{display:flex;flex-wrap:wrap;gap:8px}.c{border:1px solid #8884;border-radius:6px;padding:6px;width:150px}
.p{display:flex;gap:6px;align-items:center;min-height:100px}.i{color:var(--mut);word-break:break-all;margin-top:4px}</style>
<h1>$m</h1>''');
    for (final d in difficulties) {
      final es = [for (final e in all) if (e.mode == m && e.difficulty == d) e]..sort((a, b) => a.score.compareTo(b.score));
      sb.write('<h2>$d (${es.length})</h2><div class="g">');
      for (final e in es) {
        sb.write('<div class="c"><div class="p">${svgOf(e.id)}${gridOf(e)}</div>'
            '<div class="i">${e.id}<br>${e.width}×${e.height} · tier ${e.tier} · fid ${e.fid} · ${e.score.toStringAsFixed(0)}</div></div>');
      }
      sb.write('</div>');
    }
    File('$toolDir/cache/review-$m.html').writeAsStringSync(sb.toString());
  }
}
