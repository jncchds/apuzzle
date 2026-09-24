import '../../core/grid.dart';
import '../../core/value_grid.dart';

const int litsShade = 0;
const int litsDot = 1;

enum Tetro { l, i, t, s }

/// Classifies 4 orthogonally connected cells (null if not a valid L/I/T/S).
Tetro? classify(List<int> cells, int cols) {
  if (cells.length != 4) return null;
  final set = cells.toSet();
  int deg(int i) {
    final r = i ~/ cols, c = i % cols;
    var d = 0;
    for (final (dr, dc) in const [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
      final rr = r + dr, cc = c + dc;
      if (cc < 0 || cc >= cols) continue;
      if (set.contains(rr * cols + cc)) d++;
    }
    return d;
  }

  final degs = [for (final i in cells) deg(i)];
  if (degs.reduce((a, b) => a + b) < 6) return null; // not connected
  final rows = cells.map((i) => i ~/ cols).toSet(), colsSet = cells.map((i) => i % cols).toSet();
  if (rows.length == 2 && colsSet.length == 2) return null; // O block
  if (rows.length == 1 || colsSet.length == 1) return Tetro.i;
  if (degs.contains(3)) return Tetro.t;
  // L has three collinear consecutive cells; S doesn't.
  for (final i in cells) {
    final c = i % cols;
    if (set.contains(i + 1) && set.contains(i + 2) && (i + 2) % cols == c + 2) return Tetro.l;
    if (set.contains(i + cols) && set.contains(i + 2 * cols)) return Tetro.l;
  }
  return Tetro.s;
}

class LitsPuzzle implements ValueGridPuzzle {
  const LitsPuzzle({required this.n, required this.regions, required this.shaded});

  final int n;
  final List<int> regions;

  /// Solution shading.
  final List<bool> shaded;

  int get regionCount => regions.reduce((a, b) => a > b ? a : b) + 1;

  @override
  GridSize get size => GridSize.square(n);
  @override
  int? givenAt(int index) => null;
  @override
  int solutionAt(int index) => shaded[index] ? litsShade : litsDot;

  Map<String, dynamic> toJson() => {'n': n, 'regions': regions, 'shaded': [for (final s in shaded) s ? 1 : 0]};
  factory LitsPuzzle.fromJson(Map<String, dynamic> j) => LitsPuzzle(
        n: j['n'] as int,
        regions: (j['regions'] as List).cast<int>(),
        shaded: [for (final v in j['shaded'] as List) v == 1],
      );
}

/// Rule check on a shading. Returns offending cells (empty = valid so far).
/// With [complete] also checks counts and connectivity.
Set<int> litsConflicts(int n, List<int> regions, List<bool> shaded, {bool complete = false}) {
  final bad = <int>{};
  final regionCount = regions.reduce((a, b) => a > b ? a : b) + 1;
  final byRegion = List.generate(regionCount, (_) => <int>[]);
  for (var i = 0; i < n * n; i++) {
    if (shaded[i]) byRegion[regions[i]].add(i);
  }
  final shape = List<Tetro?>.filled(regionCount, null);
  for (var r = 0; r < regionCount; r++) {
    final cells = byRegion[r];
    if (cells.length > 4) bad.addAll(cells);
    if (cells.length == 4) {
      shape[r] = classify(cells, n);
      if (shape[r] == null) bad.addAll(cells);
    } else if (complete && cells.length != 4) {
      bad.addAll(cells.isEmpty ? [for (var i = 0; i < n * n; i++) if (regions[i] == r) i] : cells);
    }
  }
  // No 2×2 shaded blocks.
  for (var r = 0; r + 1 < n; r++) {
    for (var c = 0; c + 1 < n; c++) {
      final i = r * n + c;
      if (shaded[i] && shaded[i + 1] && shaded[i + n] && shaded[i + n + 1]) bad.addAll([i, i + 1, i + n, i + n + 1]);
    }
  }
  // Same shapes may not touch across regions.
  for (var i = 0; i < n * n; i++) {
    if (!shaded[i]) continue;
    for (final j in [if (i % n < n - 1) i + 1, if (i + n < n * n) i + n]) {
      if (!shaded[j] || regions[i] == regions[j]) continue;
      final a = shape[regions[i]], b = shape[regions[j]];
      if (a != null && a == b) {
        bad
          ..addAll(byRegion[regions[i]])
          ..addAll(byRegion[regions[j]]);
      }
    }
  }
  if (complete && bad.isEmpty) {
    final all = [for (var i = 0; i < n * n; i++) if (shaded[i]) i];
    if (all.isNotEmpty) {
      final seen = {all.first};
      final stack = [all.first];
      while (stack.isNotEmpty) {
        final i = stack.removeLast();
        final r = i ~/ n, c = i % n;
        for (final j in [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1]) {
          if (shaded[j] && seen.add(j)) stack.add(j);
        }
      }
      if (seen.length != all.length) bad.addAll(all.where((i) => !seen.contains(i)));
    }
  }
  return bad;
}
