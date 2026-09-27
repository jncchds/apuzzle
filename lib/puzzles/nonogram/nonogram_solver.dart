import 'dart:typed_data';

/// One clue number: a run of [length] cells of [color] (1-based; black-and-white
/// pictures only use colour 1).
class NonoBlock {
  const NonoBlock(this.color, this.length);

  final int color;
  final int length;

  @override
  bool operator ==(Object other) => other is NonoBlock && other.color == color && other.length == length;

  @override
  int get hashCode => color * 1000 + length;

  @override
  String toString() => '$color:$length';
}

/// Clues of one line of cell values (0 empty, 1.. colours).
List<NonoBlock> lineClue(List<int> line) {
  final out = <NonoBlock>[];
  var i = 0;
  while (i < line.length) {
    final c = line[i];
    if (c == 0) {
      i++;
      continue;
    }
    var j = i;
    while (j < line.length && line[j] == c) {
      j++;
    }
    out.add(NonoBlock(c, j - i));
    i = j;
  }
  return out;
}

/// Row and column clues of a [width]×[height] picture (row-major values).
({List<List<NonoBlock>> rows, List<List<NonoBlock>> cols}) cluesOf(int width, int height, List<int> cells) => (
      rows: [for (var r = 0; r < height; r++) lineClue(cells.sublist(r * width, (r + 1) * width))],
      cols: [
        for (var c = 0; c < width; c++) lineClue([for (var r = 0; r < height; r++) cells[r * width + c]]),
      ],
    );

/// Complete logic for one line: every value each cell can still take in some
/// placement of [clue] consistent with [cells]. Cells are bit masks (bit 0 =
/// empty, bit c = colour c). Null if no placement fits. Runs of the same
/// colour need a gap between them, runs of different colours don't.
List<int>? solveLine(List<NonoBlock> clue, List<int> cells) {
  final n = cells.length;
  final m = clue.length;
  var maxColor = 0;
  for (final b in clue) {
    if (b.color > maxColor) maxColor = b.color;
  }
  // bad[c][i]: cells in [0, i) that can't be colour c.
  final bad = [
    for (var c = 0; c <= maxColor; c++)
      () {
        final p = Int32List(n + 1);
        for (var i = 0; i < n; i++) {
          p[i + 1] = p[i] + ((cells[i] >> c) & 1 == 0 ? 1 : 0);
        }
        return p;
      }(),
  ];
  // A block followed by one of the same colour takes its gap with it.
  final sep = [for (var j = 0; j < m; j++) j + 1 < m && clue[j + 1].color == clue[j].color];
  final span = [for (var j = 0; j < m; j++) clue[j].length + (sep[j] ? 1 : 0)];
  bool fits(int j, int i) {
    final b = clue[j];
    final end = i + b.length;
    if (i + span[j] > n) return false;
    if (bad[b.color][end] - bad[b.color][i] != 0) return false;
    return !sep[j] || cells[end] & 1 != 0;
  }

  final w = n + 1;
  // f[j * w + i]: the first i cells hold exactly the first j blocks.
  final f = Uint8List((m + 1) * w);
  f[0] = 1;
  for (var i = 0; i <= n; i++) {
    for (var j = 0; j <= m; j++) {
      if (f[j * w + i] == 0) continue;
      if (i < n && cells[i] & 1 != 0) f[j * w + i + 1] = 1;
      if (j < m && fits(j, i)) f[(j + 1) * w + i + span[j]] = 1;
    }
  }
  if (f[m * w + n] == 0) return null;
  // b[j * w + i]: cells from i on hold exactly blocks j..m-1.
  final b = Uint8List((m + 1) * w);
  b[m * w + n] = 1;
  for (var i = n; i >= 0; i--) {
    for (var j = m; j >= 0; j--) {
      if (i < n && cells[i] & 1 != 0 && b[j * w + i + 1] != 0) {
        b[j * w + i] = 1;
      } else if (j < m && fits(j, i) && b[(j + 1) * w + i + span[j]] != 0) {
        b[j * w + i] = 1;
      }
    }
  }
  final empty = Uint8List(n);
  final diff = [for (var c = 0; c <= maxColor; c++) Int32List(n + 1)];
  for (var i = 0; i <= n; i++) {
    for (var j = 0; j <= m; j++) {
      if (f[j * w + i] == 0) continue;
      if (i < n && cells[i] & 1 != 0 && b[j * w + i + 1] != 0) empty[i] = 1;
      if (j < m && fits(j, i) && b[(j + 1) * w + i + span[j]] != 0) {
        final blk = clue[j];
        diff[blk.color][i]++;
        diff[blk.color][i + blk.length]--;
        if (sep[j]) empty[i + blk.length] = 1;
      }
    }
  }
  final out = List<int>.filled(n, 0);
  for (var c = 1; c <= maxColor; c++) {
    var run = 0;
    for (var i = 0; i < n; i++) {
      run += diff[c][i];
      if (run > 0) out[i] |= 1 << c;
    }
  }
  for (var i = 0; i < n; i++) {
    out[i] |= empty[i];
    if (out[i] == 0) return null;
  }
  return out;
}

/// How far [NonogramSolver.solve] got and how hard it was.
class NonoSolveResult {
  const NonoSolveResult({required this.cells, required this.solved, required this.tier, required this.rounds, required this.probes});

  /// Final cell masks (a single bit per cell when [solved]).
  final List<int> cells;
  final bool solved;

  /// 1: line logic alone, 2: needed probing. 0 if unsolved.
  final int tier;

  /// Sweeps over all changed lines until the line logic settled (summed over
  /// every probing restart): a rough depth of the deduction chain.
  final int rounds;

  /// Values refuted by probing.
  final int probes;
}

/// Tier 1: complete line logic on every row and column until nothing changes.
/// Tier 2: + probing (try a value, refute it by tier-1 propagation).
/// Deductions are sound, so a solved result is the only solution.
class NonogramSolver {
  NonogramSolver(this.width, this.height, this.colors, this.rowClues, this.colClues);

  factory NonogramSolver.forPicture(int width, int height, int colors, List<int> cells) {
    final c = cluesOf(width, height, cells);
    return NonogramSolver(width, height, colors, c.rows, c.cols);
  }

  final int width;
  final int height;
  final int colors;
  final List<List<NonoBlock>> rowClues;
  final List<List<NonoBlock>> colClues;

  /// Every value open: empty plus the colours that appear in the line's clues.
  List<int> initial() {
    int maskOf(List<NonoBlock> clue) {
      var m = 1;
      for (final b in clue) {
        m |= 1 << b.color;
      }
      return m;
    }

    final rowMask = [for (final c in rowClues) maskOf(c)];
    final colMask = [for (final c in colClues) maskOf(c)];
    return [
      for (var r = 0; r < height; r++)
        for (var c = 0; c < width; c++) rowMask[r] & colMask[c],
    ];
  }

  List<int> _row(List<int> st, int r) => st.sublist(r * width, (r + 1) * width);
  List<int> _col(List<int> st, int c) => [for (var r = 0; r < height; r++) st[r * width + c]];

  /// Line logic until nothing changes. Returns the number of sweeps, or -1 on
  /// a contradiction. Only lines marked dirty (all at first) are re-solved.
  int propagate(List<int> st, {Uint8List? dirtyRows, Uint8List? dirtyCols}) {
    final dr = dirtyRows ?? (Uint8List(height)..fillRange(0, height, 1));
    final dc = dirtyCols ?? (Uint8List(width)..fillRange(0, width, 1));
    var rounds = 0;
    var any = true;
    while (any) {
      any = false;
      var changed = false;
      for (var r = 0; r < height; r++) {
        if (dr[r] == 0) continue;
        dr[r] = 0;
        final res = solveLine(rowClues[r], _row(st, r));
        if (res == null) return -1;
        for (var c = 0; c < width; c++) {
          if (res[c] != st[r * width + c]) {
            st[r * width + c] = res[c];
            dc[c] = 1;
            changed = true;
          }
        }
      }
      for (var c = 0; c < width; c++) {
        if (dc[c] == 0) continue;
        dc[c] = 0;
        final res = solveLine(colClues[c], _col(st, c));
        if (res == null) return -1;
        for (var r = 0; r < height; r++) {
          if (res[r] != st[r * width + c]) {
            st[r * width + c] = res[r];
            dr[r] = 1;
            changed = true;
          }
        }
      }
      if (changed) {
        rounds++;
        any = dr.contains(1) || dc.contains(1);
      }
    }
    return rounds;
  }

  static bool _single(int m) => m & (m - 1) == 0;

  NonoSolveResult solve({int maxTier = 2}) {
    final st = initial();
    var rounds = propagate(st);
    if (rounds < 0) return NonoSolveResult(cells: st, solved: false, tier: 0, rounds: 0, probes: 0);
    var tier = 1;
    var probes = 0;
    while (maxTier >= 2 && !st.every(_single)) {
      final refuted = _probeOnce(st);
      if (refuted == null) break;
      tier = 2;
      probes++;
      st[refuted.$1] &= ~(1 << refuted.$2);
      final r = propagate(st,
          dirtyRows: Uint8List(height)..[refuted.$1 ~/ width] = 1, dirtyCols: Uint8List(width)..[refuted.$1 % width] = 1);
      if (r < 0) return NonoSolveResult(cells: st, solved: false, tier: 0, rounds: rounds, probes: probes);
      rounds += r;
    }
    final solved = st.every(_single);
    return NonoSolveResult(cells: st, solved: solved, tier: solved ? tier : 0, rounds: rounds, probes: probes);
  }

  /// First (cell, value) whose assumption leads to a contradiction.
  (int, int)? _probeOnce(List<int> st) {
    for (var i = 0; i < st.length; i++) {
      final m = st[i];
      if (_single(m)) continue;
      for (var v = 0; v <= colors; v++) {
        if ((m >> v) & 1 == 0) continue;
        final t = List<int>.of(st);
        t[i] = 1 << v;
        final r = propagate(t, dirtyRows: Uint8List(height)..[i ~/ width] = 1, dirtyCols: Uint8List(width)..[i % width] = 1);
        if (r < 0) return (i, v);
      }
    }
    return null;
  }

  /// Number of solutions, stopping at [limit] (line logic + branching).
  int countSolutions({int limit = 2}) {
    var found = 0;
    void go(List<int> st) {
      if (found >= limit) return;
      if (propagate(st) < 0) return;
      var best = -1;
      for (var i = 0; i < st.length; i++) {
        if (!_single(st[i]) && (best < 0 || _bits(st[i]) < _bits(st[best]))) best = i;
      }
      if (best < 0) {
        found++;
        return;
      }
      for (var v = 0; v <= colors; v++) {
        if ((st[best] >> v) & 1 == 0) continue;
        go(List<int>.of(st)..[best] = 1 << v);
      }
    }

    go(initial());
    return found;
  }

  static int _bits(int m) {
    var n = 0;
    while (m != 0) {
      m &= m - 1;
      n++;
    }
    return n;
  }

  /// Cell values (0 empty, 1.. colours) of a solved mask grid.
  static List<int> valuesOf(List<int> masks) => [for (final m in masks) m.bitLength - 1];
}
