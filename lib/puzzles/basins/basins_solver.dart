import '../../core/difficulty.dart';
import '../../core/explain.dart';
import 'basins_model.dart';

/// What a traced [BasinsSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [basinsWater] or [basinsDry].
enum BasinsRule {
  /// Water settles: a wet cell fills its basin up to its height. Args: the wet cell.
  waterBelow,

  /// A dry cell keeps its basin's water lower. Args: the dry cell.
  dryAbove,

  /// A line has all its water / needs all its open cells. Args: line, count.
  lineDone,
  lineNeed,

  /// Water here would fill more cells of a line than it has left. Args: line,
  /// cells it would fill there, water the line still needs.
  tooMuch,

  /// Dry here, too many cells of a line would stay dry. Args: line, cells
  /// that would stay dry there, water the line still needs.
  tooLittle,

  /// Every way to make a row's count from its basins' parts agrees here. Args: line, count.
  lineWays,

  /// Every water level of the basin that the counts allow agrees here.
  levels,
  failLevel,
  failLineMany,
  failLineFew,
  failWays,
  failLevels,
}

/// The logic tier a difficulty is built for: 1 settling water and counts,
/// 2 + every way to fill a row and every level of a basin, 3 + probing.
int basinsTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

const int _unk = -1;

/// Cell states: -1 unknown, [basinsWater], [basinsDry].
class BasinsSolver {
  BasinsSolver(this.rows, this.cols, this.regions, this.rowCounts, this.colCounts) : lines = basinsLines(rows, cols) {
    final (b, a) = basinsLevels(cols, regions);
    below = b;
    above = a;
    final count = regions.reduce((a, b) => a > b ? a : b) + 1;
    basins = List.generate(count, (_) => <int>[]);
    for (var i = 0; i < regions.length; i++) {
      basins[regions[i]].add(i);
    }
  }

  factory BasinsSolver.of(BasinsPuzzle p) => BasinsSolver(p.rows, p.cols, p.regions, p.rowCounts, p.colCounts);

  final int rows;
  final int cols;
  final List<int> regions;
  final List<int?> rowCounts;
  final List<int?> colCounts;
  final List<List<int>> lines;
  late final List<List<int>> below;
  late final List<List<int>> above;

  /// Cells of every basin.
  late final List<List<int>> basins;

  int? countOf(int line) => line < rows ? rowCounts[line] : colCounts[line - rows];

  /// The lines through cell [i]: its row, then its column.
  List<int> linesOf(int i) => [i ~/ cols, rows + i % cols];

  /// The start: shown cells set from [given] (cell → value).
  List<int> start([Map<int, int> given = const {}]) {
    final st = List.filled(rows * cols, _unk);
    given.forEach((i, v) => st[i] = v);
    return st;
  }

  /// Applies the rules up to [tier] (1 or 2) until nothing changes. False on
  /// a contradiction. With [tr], every deduction is recorded (see [BasinsRule]).
  bool propagate(List<int> st, int tier, [ExplainTrace? tr]) {
    List<int> known() => [
      for (var i = 0; i < st.length; i++)
        if (st[i] != _unk) i,
    ];
    var changed = true;
    while (changed) {
      changed = false;

      // Water settles.
      for (var i = 0; i < st.length; i++) {
        if (st[i] == _unk) continue;
        final wet = st[i] == basinsWater;
        for (final j in wet ? below[i] : above[i]) {
          if (st[j] == st[i]) continue;
          if (st[j] != _unk) {
            tr?.fail(BasinsRule.failLevel.index, premises: [i, j], args: wet ? [i, j] : [j, i]);
            return false;
          }
          st[j] = st[i];
          tr?.fact(j, st[j], (wet ? BasinsRule.waterBelow : BasinsRule.dryAbove).index, premises: [i], args: [i]);
          changed = true;
        }
      }

      // Line counts.
      for (var li = 0; li < lines.length; li++) {
        final want = countOf(li);
        if (want == null) continue;
        final cells = lines[li];
        var t = 0;
        final u = <int>[];
        for (final i in cells) {
          if (st[i] == basinsWater) t++;
          if (st[i] == _unk) u.add(i);
        }
        if (t > want || t + u.length < want) {
          tr?.fail(
            (t > want ? BasinsRule.failLineMany : BasinsRule.failLineFew).index,
            premises: cells,
            args: [li, want],
          );
          return false;
        }
        if (u.isEmpty || (t != want && t + u.length != want)) continue;
        for (final i in u) {
          st[i] = t == want ? basinsDry : basinsWater;
          tr?.fact(
            i,
            st[i],
            (t == want ? BasinsRule.lineDone : BasinsRule.lineNeed).index,
            premises: cells,
            args: [li, want],
          );
        }
        changed = true;
      }
      if (changed) continue;

      // What water (or none) in one cell would do to a line.
      final room = [for (var li = 0; li < lines.length; li++) _room(st, li)];
      final open = [for (final l in lines) l.where((i) => st[i] == _unk).length];
      final per = List.filled(lines.length, 0);
      final hit = <int>[];
      for (var x = 0; x < st.length; x++) {
        if (st[x] != _unk) continue;
        for (final wet in const [true, false]) {
          void count(int j) {
            for (final li in [j ~/ cols, rows + j % cols]) {
              if (per[li]++ == 0) hit.add(li);
            }
          }

          count(x);
          for (final j in wet ? below[x] : above[x]) {
            if (st[j] == _unk) count(j);
          }
          for (final li in hit) {
            final k = per[li], need = room[li];
            if (need == null || st[x] != _unk) continue;
            if (wet ? k <= need : open[li] - k >= need) continue;
            st[x] = wet ? basinsDry : basinsWater;
            tr?.fact(
              x,
              st[x],
              (wet ? BasinsRule.tooMuch : BasinsRule.tooLittle).index,
              premises: lines[li],
              args: [li, k, need],
            );
            for (final l in linesOf(x)) {
              open[l]--;
              if (!wet && room[l] != null) room[l] = room[l]! - 1;
            }
            changed = true;
          }
          for (final li in hit) {
            per[li] = 0;
          }
          hit.clear();
          if (st[x] != _unk) break;
        }
      }
      if (changed || tier < 2) continue;

      // Every way to make a row's count.
      for (var li = 0; li < rows; li++) {
        final want = _room(st, li);
        if (want == null) continue;
        final chunks = <int, List<int>>{};
        for (final i in lines[li]) {
          if (st[i] == _unk) (chunks[regions[i]] ??= []).add(i);
        }
        if (chunks.length < 2) continue;
        final parts = chunks.values.toList();
        final sizes = [for (final p in parts) p.length];
        for (var g = 0; g < parts.length; g++) {
          final others = [...sizes.sublist(0, g), ...sizes.sublist(g + 1)];
          final sums = _sums(others);
          final withIt = want >= sizes[g] && sums & (1 << (want - sizes[g])) != 0;
          final without = sums & (1 << want) != 0;
          if (withIt && without) continue;
          if (!withIt && !without) {
            tr?.fail(BasinsRule.failWays.index, premises: [...lines[li], ...known()], args: [li, countOf(li)!]);
            return false;
          }
          for (final i in parts[g]) {
            st[i] = withIt ? basinsWater : basinsDry;
            tr?.fact(i, st[i], BasinsRule.lineWays.index, premises: lines[li], args: [li, countOf(li)!]);
          }
          changed = true;
          break;
        }
      }
      if (changed) continue;

      // Every level of a basin.
      for (final cells in basins) {
        final open = cells.where((i) => st[i] == _unk).toList();
        if (open.isEmpty) continue;
        final heights = {for (final i in open) i ~/ cols}.toList()..sort();
        final touched = {for (final i in open) ...linesOf(i)};
        // Level k: the open cells at heights[k] and below hold water.
        int? wetAll, dryAll;
        var any = false;
        for (var k = 0; k <= heights.length; k++) {
          final top = k < heights.length ? heights[k] : rows;
          var mask = 0;
          for (var b = 0; b < open.length; b++) {
            final wet = open[b] ~/ cols >= top;
            st[open[b]] = wet ? basinsWater : basinsDry;
            if (wet) mask |= 1 << b;
          }
          final fits = _linesFit(st, touched);
          for (final i in open) {
            st[i] = _unk;
          }
          if (!fits) continue;
          any = true;
          wetAll = (wetAll ?? mask) & mask;
          dryAll = (dryAll ?? ~mask) & ~mask;
        }
        if (!any) {
          tr?.fail(BasinsRule.failLevels.index, premises: known(), args: [cells.first]);
          return false;
        }
        for (var b = 0; b < open.length; b++) {
          final v = wetAll! & (1 << b) != 0
              ? basinsWater
              : dryAll! & (1 << b) != 0
              ? basinsDry
              : _unk;
          if (v == _unk) continue;
          st[open[b]] = v;
          tr?.fact(open[b], v, BasinsRule.levels.index, premises: known());
          changed = true;
        }
      }
    }
    return true;
  }

  /// Water line [li] still needs, or null without a count.
  int? _room(List<int> st, int li) {
    final want = countOf(li);
    if (want == null) return null;
    return want - lines[li].where((i) => st[i] == basinsWater).length;
  }

  /// Bit s set: some of [sizes] add up to s.
  static int _sums(List<int> sizes) {
    var m = 1;
    for (final s in sizes) {
      m |= m << s;
    }
    return m;
  }

  /// Whether every line of [check] can still get its count: columns by
  /// counting, rows by adding up their basins' parts.
  bool _linesFit(List<int> st, Set<int> check) {
    for (final li in check) {
      final need = _room(st, li);
      if (need == null) continue;
      if (need < 0) return false;
      if (li >= rows) {
        if (lines[li].where((i) => st[i] == _unk).length < need) return false;
        continue;
      }
      final chunks = <int, int>{};
      for (final i in lines[li]) {
        if (st[i] == _unk) chunks[regions[i]] = (chunks[regions[i]] ?? 0) + 1;
      }
      if (_sums(chunks.values.toList()) & (1 << need) == 0) return false;
    }
    return true;
  }

  bool solved(List<int> st) => !st.contains(_unk);

  /// True if [st] gets fully determined using logic up to [tier] (3 probes).
  bool solve(List<int> st, int tier) {
    final level = tier < 2 ? 1 : 2;
    if (!propagate(st, level)) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != _unk) continue;
          for (final v in const [basinsWater, basinsDry]) {
            final t = List.of(st)..[i] = v;
            if (propagate(t, 2)) continue;
            st[i] = 1 - v;
            if (!propagate(st, 2)) return false;
            progress = true;
            break;
          }
        }
      }
    }
    return solved(st);
  }

  /// The lowest tier that solves [st] (4: none does).
  int grade(List<int> st) {
    for (var t = 1; t <= 3; t++) {
      if (solve(List.of(st), t)) return t;
    }
    return 4;
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t, 2)) return 0;
    final i = t.indexOf(_unk);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [basinsWater, basinsDry]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[i] = v, limit: limit - total);
    }
    return total;
  }
}

/// [BasinsSolver.start] with the shown cells of [p].
List<int> basinsStart(BasinsSolver s, BasinsPuzzle p) => s.start({for (final g in p.givens) g: p.solutionAt(g)});
