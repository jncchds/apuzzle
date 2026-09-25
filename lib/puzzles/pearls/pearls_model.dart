import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

const int pearlNone = 0;
const int pearlWhite = 1;
const int pearlBlack = 2;

/// Masyu: one loop through cell centres, passing every pearl. It goes straight
/// through white pearls (turning next to them) and turns on black pearls
/// (going straight next to them).
class PearlsPuzzle {
  const PearlsPuzzle({required this.rows, required this.cols, required this.pearls, required this.lines});

  final int rows;
  final int cols;

  /// Per cell: [pearlNone], [pearlWhite] or [pearlBlack].
  final List<int> pearls;

  /// Solution, per edge between neighbouring cells (a [LatticeLoop] of rows × cols points).
  final List<bool> lines;

  GridSize get size => GridSize(rows, cols);
  LatticeLoop get lattice => _lattices[this] ??= LatticeLoop(rows, cols);
  static final _lattices = Expando<LatticeLoop>();

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'pearls': pearls,
        'lines': [for (var e = 0; e < lines.length; e++) if (lines[e]) e],
      };

  factory PearlsPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final lines = List<bool>.filled(LatticeLoop(rows, cols).edgeCount, false);
    for (final e in (j['lines'] as List).cast<int>()) {
      lines[e] = true;
    }
    return PearlsPuzzle(rows: rows, cols: cols, pearls: (j['pearls'] as List).cast<int>(), lines: lines);
  }
}

const pearlDirs = [(-1, 0), (1, 0), (0, -1), (0, 1)];

/// Whether the loop through cell [p] turns there ([lines] passes it).
bool pearlTurns(LatticeLoop g, List<bool> lines, int p) {
  bool on(int e) => e >= 0 && lines[e];
  final vertical = on(g.step(p, -1, 0)) || on(g.step(p, 1, 0));
  final horizontal = on(g.step(p, 0, -1)) || on(g.step(p, 0, 1));
  return vertical && horizontal;
}

/// Whether pearl [p]'s rule holds for a finished loop.
bool pearlMet(LatticeLoop g, List<bool> lines, int p, int kind) {
  bool on(int e) => e >= 0 && lines[e];
  final used = [for (final (dr, dc) in pearlDirs) on(g.step(p, dr, dc))];
  if (used.where((u) => u).length != 2) return false;
  final turns = pearlTurns(g, lines, p);
  if (kind == pearlBlack) {
    if (!turns) return false;
    for (var k = 0; k < 4; k++) {
      if (!used[k]) continue;
      final (dr, dc) = pearlDirs[k];
      final next = p + dr * g.vc + dc;
      if (!on(g.step(next, dr, dc))) return false;
    }
    return true;
  }
  if (turns) return false;
  // Straight through: one of the two cells along it must turn.
  for (var k = 0; k < 4; k++) {
    if (!used[k]) continue;
    final (dr, dc) = pearlDirs[k];
    if (pearlTurns(g, lines, p + dr * g.vc + dc)) return true;
  }
  return false;
}

/// Pearls whose rule is broken by the [lines] ([complete]: the loop is closed).
Set<int> pearlsBad(PearlsPuzzle p, LatticeLoop g, List<bool> lines, {required bool complete}) {
  final bad = <int>{};
  for (var i = 0; i < p.pearls.length; i++) {
    if (p.pearls[i] == pearlNone) continue;
    if (complete ? !pearlMet(g, lines, i, p.pearls[i]) : g.incident[i].where((e) => lines[e]).length > 2) bad.add(i);
  }
  return bad;
}
