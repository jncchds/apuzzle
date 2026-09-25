import '../../core/grid.dart';

/// How the board settles after a pop.
enum PopMode {
  /// Bubbles fall down; empty columns close up to the right.
  standard('std'),

  /// Also, every row slides right to close its gaps.
  shifter('shift'),

  /// Standard, and fresh columns roll in from the left as space frees up.
  continuous('cont'),

  /// Shifter plus fresh columns.
  mega('mega');

  const PopMode(this.id);
  final String id;

  bool get shifts => this == shifter || this == mega;
  bool get refills => this == continuous || this == mega;

  static PopMode byId(String? id) => values.firstWhere((m) => m.id == id, orElse: () => standard);
}

/// What counts as a win.
enum PopGoal {
  /// Pop every bubble (the board is built to be clearable).
  clear('clear'),

  /// Reach a target score before the moves run out.
  target('target'),

  /// No target: play until no moves are left and chase a best score.
  free('free');

  const PopGoal(this.id);
  final String id;

  static PopGoal byId(String? id) => values.firstWhere((g) => g.id == id, orElse: () => target);
}

class PopPuzzle {
  const PopPuzzle({
    required this.rows,
    required this.cols,
    required this.colors,
    required this.mode,
    required this.goal,
    required this.start,
    required this.reserve,
    required this.target,
    required this.plan,
  });

  final int rows;
  final int cols;
  final int colors;
  final PopMode mode;
  final PopGoal goal;

  /// Color per cell (row-major, all filled).
  final List<int> start;

  /// Columns that roll in later (continuous modes), bottom-up colors.
  final List<List<int>> reserve;

  /// Score to reach ([PopGoal.target]), else 0.
  final int target;

  /// A known line of play: the id of one bubble of each group to pop. It
  /// clears the board ([PopGoal.clear]) or scores at least [target].
  final List<int> plan;

  GridSize get size => GridSize(rows, cols);

  /// Id of the bubble at [j] (from the bottom) of reserve column [k].
  int reserveId(int k, int j) => rows * cols + k * rows + j;

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'colors': colors,
        'mode': mode.id,
        'goal': goal.id,
        'start': start,
        'reserve': reserve,
        'target': target,
        'plan': plan,
      };

  factory PopPuzzle.fromJson(Map<String, dynamic> j) => PopPuzzle(
        rows: j['rows'] as int,
        cols: j['cols'] as int,
        colors: j['colors'] as int,
        mode: PopMode.byId(j['mode'] as String?),
        goal: PopGoal.byId(j['goal'] as String?),
        start: (j['start'] as List).cast<int>(),
        reserve: [for (final c in j['reserve'] as List) (c as List).cast<int>()],
        target: j['target'] as int,
        plan: (j['plan'] as List).cast<int>(),
      );
}

class PopState {
  const PopState({required this.cells, required this.ids, required this.score, required this.moves, required this.used});

  factory PopState.initial(PopPuzzle p) =>
      PopState(cells: p.start, ids: List.generate(p.start.length, (i) => i), score: 0, moves: 0, used: 0);

  /// Color per cell, -1 when empty.
  final List<int> cells;

  /// Stable bubble ids per cell (for animation and plans), -1 when empty.
  final List<int> ids;
  final int score;
  final int moves;

  /// Reserve columns already rolled in.
  final int used;

  int get left => cells.where((c) => c >= 0).length;

  Map<String, dynamic> toJson() => {'cells': cells, 'ids': ids, 'score': score, 'moves': moves, 'used': used};

  factory PopState.fromJson(Map<String, dynamic> j) => PopState(
        cells: (j['cells'] as List).cast<int>(),
        ids: (j['ids'] as List).cast<int>(),
        score: j['score'] as int,
        moves: j['moves'] as int,
        used: j['used'] as int,
      );
}

/// Points for popping a group of [n].
int popPoints(int n) => n * (n - 1);

/// The same-colored group containing [i] (just [i] when alone, empty on a hole).
List<int> popGroup(List<int> cells, int rows, int cols, int i) {
  final color = cells[i];
  if (color < 0) return const [];
  final seen = <int>{i};
  final out = <int>[i];
  for (var k = 0; k < out.length; k++) {
    final j = out[k];
    final r = j ~/ cols, c = j % cols;
    for (final n in [if (r > 0) j - cols, if (r < rows - 1) j + cols, if (c > 0) j - 1, if (c < cols - 1) j + 1]) {
      if (cells[n] == color && seen.add(n)) out.add(n);
    }
  }
  return out;
}

/// All groups of 2+ (each as its cells).
List<List<int>> popGroups(List<int> cells, int rows, int cols) {
  final seen = List<bool>.filled(cells.length, false);
  final out = <List<int>>[];
  for (var i = 0; i < cells.length; i++) {
    if (seen[i] || cells[i] < 0) continue;
    final g = popGroup(cells, rows, cols, i);
    for (final j in g) {
      seen[j] = true;
    }
    if (g.length > 1) out.add(g);
  }
  return out;
}

bool popHasMoves(List<int> cells, int rows, int cols) {
  for (var i = 0; i < cells.length; i++) {
    final v = cells[i];
    if (v < 0) continue;
    if (i % cols < cols - 1 && cells[i + 1] == v) return true;
    if (i ~/ cols < rows - 1 && cells[i + cols] == v) return true;
  }
  return false;
}

/// Pops the group at [i] and settles the board, or returns null when it's
/// not a group of 2+.
PopState? popAt(PopPuzzle p, PopState s, int i) {
  final rows = p.rows, cols = p.cols;
  final group = popGroup(s.cells, rows, cols, i);
  if (group.length < 2) return null;
  final gone = group.toSet();

  // Columns bottom-up as (color, id); empty columns close up to the right.
  final filled = <List<(int, int)>>[];
  for (var c = 0; c < cols; c++) {
    final col = <(int, int)>[
      for (var r = rows - 1; r >= 0; r--)
        if (s.cells[r * cols + c] >= 0 && !gone.contains(r * cols + c)) (s.cells[r * cols + c], s.ids[r * cols + c]),
    ];
    if (col.isNotEmpty) filled.add(col);
  }
  var columns = [for (var c = filled.length; c < cols; c++) <(int, int)>[], ...filled];

  if (p.mode.shifts) {
    // Each row slides right. Row lengths shrink going up, so nothing floats.
    final next = [for (var c = 0; c < cols; c++) <(int, int)>[]];
    for (var h = 0; h < rows; h++) {
      final row = [for (final col in columns) if (col.length > h) col[h]];
      for (var k = 0; k < row.length; k++) {
        next[cols - row.length + k].add(row[k]);
      }
    }
    columns = next;
  }

  var used = s.used;
  if (p.mode.refills) {
    var slot = 0;
    while (slot < cols && columns[slot].isEmpty) {
      slot++;
    }
    for (slot--; slot >= 0 && used < p.reserve.length; slot--, used++) {
      columns[slot] = [for (var j = 0; j < p.reserve[used].length; j++) (p.reserve[used][j], p.reserveId(used, j))];
    }
  }

  final cells = List<int>.filled(rows * cols, -1);
  final ids = List<int>.filled(rows * cols, -1);
  for (var c = 0; c < cols; c++) {
    for (var h = 0; h < columns[c].length; h++) {
      final i = (rows - 1 - h) * cols + c;
      final (color, id) = columns[c][h];
      cells[i] = color;
      ids[i] = id;
    }
  }
  return PopState(cells: cells, ids: ids, score: s.score + popPoints(group.length), moves: s.moves + 1, used: used);
}
