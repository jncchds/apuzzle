import '../../core/grid.dart';
import '../../core/grid_graph.dart';
import '../../core/value_grid.dart';

const int fleetShip = 0;
const int fleetWater = 1;

/// Sides of a cell, as bits of a piece's shape: the sides where the ship goes on.
const int sideUp = 1, sideRight = 2, sideDown = 4, sideLeft = 8;

/// The shape of a shown middle piece: it doesn't say which way the ship runs.
const int pieceMiddle = 16;

/// The fleet hidden on a board of [rows] × [cols]: ship lengths, longest first.
List<int> fleetFor(int rows, int cols) => switch (rows < cols ? rows : cols) {
  <= 5 => const [3, 2, 1, 1],
  6 => const [3, 2, 2, 1, 1, 1],
  7 => const [4, 3, 2, 2, 1, 1, 1],
  8 => const [4, 3, 3, 2, 2, 1, 1, 1],
  9 => const [4, 3, 3, 2, 2, 2, 1, 1, 1],
  _ => const [4, 3, 3, 2, 2, 2, 1, 1, 1, 1],
};

/// Fleet: a fleet of straight ships hides in the grid. Ships never touch,
/// not even diagonally; the numbers outside say how many ship cells each row
/// and column holds; some cells are shown from the start (water, or a ship
/// piece whose shape tells where its ship goes on).
class FleetPuzzle implements ValueGridPuzzle {
  FleetPuzzle({
    required this.rows,
    required this.cols,
    required this.ships,
    required this.rowCounts,
    required this.colCounts,
    this.givens = const [],
  }) : fleet = shipLengths(rows, cols, ships);

  final int rows;
  final int cols;

  /// Solution.
  final List<bool> ships;

  /// Ship cells per row/column, null where the count is hidden.
  final List<int?> rowCounts;
  final List<int?> colCounts;

  /// Cells shown from the start.
  final List<int> givens;

  /// Ship lengths, longest first.
  final List<int> fleet;

  int get shipCells => fleet.fold(0, (a, b) => a + b);
  int get longest => fleet.first;

  @override
  GridSize get size => GridSize(rows, cols);
  @override
  int? givenAt(int index) => givens.contains(index) ? solutionAt(index) : null;
  @override
  int solutionAt(int index) => ships[index] ? fleetShip : fleetWater;

  /// The sides of ship cell [i] where its ship goes on (in the solution).
  int joins(int i) {
    final r = i ~/ cols, c = i % cols;
    return (r > 0 && ships[i - cols] ? sideUp : 0) |
        (c < cols - 1 && ships[i + 1] ? sideRight : 0) |
        (r < rows - 1 && ships[i + cols] ? sideDown : 0) |
        (c > 0 && ships[i - 1] ? sideLeft : 0);
  }

  /// What a shown ship piece looks like: [joins], or [pieceMiddle] for a
  /// piece with ship on two opposite sides.
  int shapeOf(int i) {
    final j = joins(i);
    return j == sideUp | sideDown || j == sideLeft | sideRight ? pieceMiddle : j;
  }

  /// Shown ship pieces and their shapes.
  Map<int, int> get pieces => {
    for (final i in givens)
      if (ships[i]) i: shapeOf(i),
  };

  Map<String, dynamic> toJson() => {
    'rows': rows,
    'cols': cols,
    'ships': [
      for (var i = 0; i < ships.length; i++)
        if (ships[i]) i,
    ],
    'rc': rowCounts,
    'cc': colCounts,
    if (givens.isNotEmpty) 'given': givens,
  };

  factory FleetPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    final ships = List<bool>.filled(rows * cols, false);
    for (final i in (j['ships'] as List).cast<int>()) {
      ships[i] = true;
    }
    return FleetPuzzle(
      rows: rows,
      cols: cols,
      ships: ships,
      rowCounts: (j['rc'] as List).cast<int?>(),
      colCounts: (j['cc'] as List).cast<int?>(),
      givens: ((j['given'] as List?) ?? const []).cast<int>(),
    );
  }
}

/// The line of cells left to right / top to bottom: rows first, then columns.
List<List<int>> fleetLines(int rows, int cols) => [
  for (var r = 0; r < rows; r++) [for (var c = 0; c < cols; c++) r * cols + c],
  for (var c = 0; c < cols; c++) [for (var r = 0; r < rows; r++) r * cols + c],
];

/// Lengths of the ships in a valid layout, longest first.
List<int> shipLengths(int rows, int cols, List<bool> ships) {
  final out = <int>[];
  for (final run in shipRuns(rows, cols, ships)) {
    out.add(run.length);
  }
  return out..sort((a, b) => b - a);
}

/// Maximal straight runs of ship cells: horizontal runs of two or more,
/// vertical runs of two or more, and single cells with no ship beside them.
List<List<int>> shipRuns(int rows, int cols, List<bool> ships) {
  final runs = <List<int>>[];
  final on = orthNeighbors(rows, cols);
  for (final line in fleetLines(rows, cols)) {
    var run = <int>[];
    for (final i in [...line, -1]) {
      if (i >= 0 && ships[i]) {
        run.add(i);
        continue;
      }
      if (run.length >= 2) runs.add(run);
      run = [];
    }
  }
  for (var i = 0; i < ships.length; i++) {
    if (ships[i] && !on[i].any((j) => ships[j])) runs.add([i]);
  }
  return runs;
}

/// Cell values -1 (empty), [fleetShip] or [fleetWater]: is the cell beyond
/// [i] towards [side] water or off the board?
bool closedSide(int rows, int cols, List<int> v, int i, int side) {
  final j = stepTo(rows, cols, i, side);
  return j < 0 || v[j] == fleetWater;
}

/// The cell next to [i] towards [side], or -1 off the board.
int stepTo(int rows, int cols, int i, int side) {
  final r = i ~/ cols, c = i % cols;
  return switch (side) {
    sideUp => r > 0 ? i - cols : -1,
    sideRight => c < cols - 1 ? i + 1 : -1,
    sideDown => r < rows - 1 ? i + cols : -1,
    _ => c > 0 ? i - 1 : -1,
  };
}

/// Runs of [shipRuns] closed at both ends (by water or the edge, and on all
/// four sides for a single cell): ships the board shows as finished.
List<List<int>> closedShips(int rows, int cols, List<int> v) {
  final ships = [for (final x in v) x == fleetShip];
  return [
    for (final run in shipRuns(rows, cols, ships))
      if (run.length == 1
          ? [sideUp, sideRight, sideDown, sideLeft].every((s) => closedSide(rows, cols, v, run.first, s))
          : _endsClosed(rows, cols, v, run))
        run,
  ];
}

bool _endsClosed(int rows, int cols, List<int> v, List<int> run) {
  final across = run[1] - run[0] == 1;
  return closedSide(rows, cols, v, run.first, across ? sideLeft : sideUp) &&
      closedSide(rows, cols, v, run.last, across ? sideRight : sideDown);
}

/// Cells breaking a rule on a board of values (-1 empty). Before the board
/// is [complete] only what more input can't fix is flagged: touching ships,
/// too many ship cells in a line, ships too long, too many finished ships of
/// one length, and shown pieces whose sides got the wrong value.
Set<int> fleetConflicts(FleetPuzzle p, List<int> v, {required bool complete}) {
  final rows = p.rows, cols = p.cols, bad = <int>{};
  final ships = [for (final x in v) x == fleetShip];
  final kn = kingNeighbors(rows, cols);
  for (var i = 0; i < v.length; i++) {
    if (!ships[i]) continue;
    final r = i ~/ cols, c = i % cols;
    for (final j in kn[i]) {
      if (ships[j] && j ~/ cols != r && j % cols != c) bad.addAll([i, j]);
    }
  }
  final lines = fleetLines(rows, cols);
  for (var li = 0; li < lines.length; li++) {
    final want = li < rows ? p.rowCounts[li] : p.colCounts[li - rows];
    if (want == null) continue;
    final have = [
      for (final i in lines[li])
        if (ships[i]) i,
    ];
    if (have.length > want || (complete && have.length != want)) bad.addAll(have.isEmpty ? lines[li] : have);
  }
  final runs = shipRuns(rows, cols, ships);
  for (final run in runs) {
    if (run.length > p.longest) bad.addAll(run);
  }
  final finished = complete ? runs : closedShips(rows, cols, v);
  final want = <int, int>{};
  for (final len in p.fleet) {
    want[len] = (want[len] ?? 0) + 1;
  }
  final byLen = <int, List<List<int>>>{};
  for (final run in finished) {
    (byLen[run.length] ??= []).add(run);
  }
  for (final MapEntry(key: len, value: list) in byLen.entries) {
    if (list.length > (want[len] ?? 0)) bad.addAll(list.expand((r) => r));
  }
  p.pieces.forEach((g, shape) {
    for (final side in const [sideUp, sideRight, sideDown, sideLeft]) {
      final j = stepTo(rows, cols, g, side);
      if (j < 0 || v[j] < 0) continue;
      if (shape == pieceMiddle) continue;
      if ((shape & side != 0) != (v[j] == fleetShip)) bad.add(g);
    }
    if (shape == pieceMiddle) {
      bool blocked(int a, int b) => closedSide(rows, cols, v, g, a) || closedSide(rows, cols, v, g, b);
      if (blocked(sideUp, sideDown) && blocked(sideLeft, sideRight)) bad.add(g);
    }
  });
  return bad;
}
