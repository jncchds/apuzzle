import '../../core/grid.dart';
import '../../core/grid_graph.dart';

/// Minesweeper without guessing: the starting cells are chosen so that logic
/// alone clears the board.
class MinesPuzzle {
  const MinesPuzzle({required this.rows, required this.cols, required this.mines, required this.opened});

  final int rows;
  final int cols;
  final List<bool> mines;

  /// Cells open at the start.
  final List<bool> opened;

  GridSize get size => GridSize(rows, cols);
  int get mineCount => mines.where((m) => m).length;

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'mines': [for (var i = 0; i < mines.length; i++) if (mines[i]) i],
        'open': [for (var i = 0; i < opened.length; i++) if (opened[i]) i],
      };

  factory MinesPuzzle.fromJson(Map<String, dynamic> j) {
    final rows = j['rows'] as int, cols = j['cols'] as int;
    List<bool> mask(String k) {
      final m = List<bool>.filled(rows * cols, false);
      for (final i in (j[k] as List).cast<int>()) {
        m[i] = true;
      }
      return m;
    }

    return MinesPuzzle(rows: rows, cols: cols, mines: mask('mines'), opened: mask('open'));
  }
}

class MinesState {
  const MinesState({required this.open, required this.flags, this.booms = const []});

  final List<bool> open;
  final List<bool> flags;

  /// Mines the player dug into (they get flagged and the game goes on).
  final List<int> booms;

  Map<String, dynamic> toJson() => {
        'n': open.length,
        'open': [for (var i = 0; i < open.length; i++) if (open[i]) i],
        'flags': [for (var i = 0; i < flags.length; i++) if (flags[i]) i],
        if (booms.isNotEmpty) 'booms': booms,
      };

  factory MinesState.fromJson(Map<String, dynamic> j) {
    final n = j['n'] as int;
    List<bool> mask(String k) {
      final m = List<bool>.filled(n, false);
      for (final i in (j[k] as List).cast<int>()) {
        m[i] = true;
      }
      return m;
    }

    return MinesState(open: mask('open'), flags: mask('flags'), booms: ((j['booms'] as List?) ?? const []).cast<int>());
  }
}

/// Number of mines around each cell.
List<int> mineCounts(MinesPuzzle p) {
  final kn = kingNeighbors(p.rows, p.cols);
  return [for (var i = 0; i < p.mines.length; i++) kn[i].where((j) => p.mines[j]).length];
}

/// Opens [cells] in [open] (in place), spreading through cells with no mines
/// around them. Mines are never opened.
void openCells(List<bool> open, Iterable<int> cells, List<bool> mines, List<int> counts, List<List<int>> kn) {
  final queue = <int>[];
  for (final i in cells) {
    if (!open[i] && !mines[i]) {
      open[i] = true;
      queue.add(i);
    }
  }
  for (var q = 0; q < queue.length; q++) {
    final i = queue[q];
    if (counts[i] != 0) continue;
    for (final j in kn[i]) {
      if (!open[j] && !mines[j]) {
        open[j] = true;
        queue.add(j);
      }
    }
  }
}

bool minesCleared(MinesPuzzle p, List<bool> open) {
  for (var i = 0; i < open.length; i++) {
    if (!p.mines[i] && !open[i]) return false;
  }
  return true;
}
