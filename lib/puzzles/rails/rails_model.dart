import '../../core/grid.dart';
import '../../core/lattice_loop.dart';

/// Train tracks: one track through cell centres, entering at [RailsPuzzle.entry]
/// from the left edge and leaving at [RailsPuzzle.exit] through the bottom
/// edge. The numbers count the track cells in each row and column.
class RailsPuzzle {
  const RailsPuzzle({
    required this.rows,
    required this.cols,
    required this.entry,
    required this.exit,
    required this.rowCounts,
    required this.colCounts,
    required this.given,
    required this.lines,
  });

  final int rows;
  final int cols;

  /// Cell in the left column where the track comes in (from the left).
  final int entry;

  /// Cell in the bottom row where the track goes out (downwards).
  final int exit;
  final List<int> rowCounts;
  final List<int> colCounts;

  /// Cells whose piece of track is shown.
  final List<bool> given;

  /// Solution, per edge between neighbouring cells (a [LatticeLoop] of rows × cols points).
  final List<bool> lines;

  GridSize get size => GridSize(rows, cols);
  int get length => rowCounts.fold(0, (a, b) => a + b);
  LatticeLoop get lattice => _lattices[this] ??= LatticeLoop(rows, cols);
  static final _lattices = Expando<LatticeLoop>();

  /// Track ends leaving the grid at cell [i] (the entry and exit stubs).
  int stubs(int i) => (i == entry ? 1 : 0) + (i == exit ? 1 : 0);

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'entry': entry,
    'exit': exit,
    'rowCounts': rowCounts,
    'colCounts': colCounts,
    'given': [
      for (var i = 0; i < given.length; i++)
        if (given[i]) i,
    ],
    'lines': [
      for (var e = 0; e < lines.length; e++)
        if (lines[e]) e,
    ],
  };

  factory RailsPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final lines = List<bool>.filled(LatticeLoop(rows, cols).edgeCount, false);
    for (final e in (j['lines'] as List).cast<int>()) {
      lines[e] = true;
    }
    final given = List<bool>.filled(rows * cols, false);
    for (final i in (j['given'] as List).cast<int>()) {
      given[i] = true;
    }
    return RailsPuzzle(
      rows: rows,
      cols: cols,
      entry: j['entry'] as int,
      exit: j['exit'] as int,
      rowCounts: (j['rowCounts'] as List).cast<int>(),
      colCounts: (j['colCounts'] as List).cast<int>(),
      given: given,
      lines: lines,
    );
  }
}

/// Track ends at cell [i]: its lines plus the entry/exit stubs.
int railsDegree(RailsPuzzle p, List<bool> lines, int i) =>
    p.stubs(i) + p.lattice.incident[i].where((e) => lines[e]).length;

/// Cells along the track from the entry, following [lines] until it stops,
/// branches or leaves through the exit (then [RailsWalk.done]).
({List<int> cells, bool done}) railsWalk(RailsPuzzle p, List<bool> lines) {
  final g = p.lattice;
  final cells = <int>[];
  var prev = -1, cur = p.entry;
  while (true) {
    cells.add(cur);
    if (railsDegree(p, lines, cur) != 2) return (cells: cells, done: false);
    if (cur == p.exit) return (cells: cells, done: prev >= 0 || p.entry == p.exit);
    final next = [
      for (final e in g.incident[cur])
        if (lines[e])
          if (g.ends(e) case (final a, final b)) a == cur ? b : a,
    ].where((q) => q != prev).toList();
    if (next.length != 1 || cells.contains(next.first)) return (cells: cells, done: false);
    prev = cur;
    cur = next.first;
  }
}

/// Whether [lines] form the track: entry to exit, nothing else drawn, and
/// every row and column count met.
bool railsValid(RailsPuzzle p, List<bool> lines) {
  final walk = railsWalk(p, lines);
  if (!walk.done) return false;
  final used = railsUsed(p, lines);
  if (used.where((u) => u).length != walk.cells.length) return false;
  return railsCountsMet(p, used);
}

/// Cells the [lines] (or a stub) pass through.
List<bool> railsUsed(RailsPuzzle p, List<bool> lines) => [
  for (var i = 0; i < p.rows * p.cols; i++) railsDegree(p, lines, i) > 0,
];

bool railsCountsMet(RailsPuzzle p, List<bool> used) {
  for (var r = 0; r < p.rows; r++) {
    if (Iterable.generate(p.cols, (c) => used[r * p.cols + c]).where((u) => u).length != p.rowCounts[r]) return false;
  }
  for (var c = 0; c < p.cols; c++) {
    if (Iterable.generate(p.rows, (r) => used[r * p.cols + c]).where((u) => u).length != p.colCounts[c]) return false;
  }
  return true;
}

/// Cell notes: none, "track goes here", "no track here".
const railsNoteNone = 0, railsNoteTrack = 1, railsNoteDot = 2;

/// The player's edge marks (0 empty, 1 track, 2 cross) and cell notes
/// ([cells] is empty when there are none, as in saves from before notes).
class RailsState {
  const RailsState(this.marks, [this.cells = const []]);

  final List<int> marks;
  final List<int> cells;

  List<bool> get lines => [for (final m in marks) m == 1];

  int note(int i) => i < cells.length ? cells[i] : railsNoteNone;

  /// Cell notes of a board with [n] cells, as a new list.
  List<int> notes(int n) => [for (var i = 0; i < n; i++) note(i)];

  Map<String, dynamic> toJson() => {'m': marks, if (cells.any((c) => c != railsNoteNone)) 'c': cells};
  factory RailsState.fromJson(Map<String, dynamic> j) =>
      RailsState((j['m'] as List).cast<int>(), (j['c'] as List?)?.cast<int>() ?? const []);
}
