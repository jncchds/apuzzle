import '../../core/lattice_loop.dart';
import 'fence_model.dart';

/// Loop logic plus the cell counts.
class FenceSolver extends LoopSolver {
  FenceSolver(this.rows, this.cols, this.numbers) : super(LatticeLoop(rows + 1, cols + 1)) {
    for (var i = 0; i < numbers.length; i++) {
      if (numbers[i] != null) {
        _cells.add(i);
        _sides.add(fenceSides(g, i ~/ cols, i % cols));
      }
    }
  }

  final int rows;
  final int cols;
  final List<int?> numbers;
  final List<int> _cells = [];
  final List<List<int>> _sides = [];

  @override
  bool clues(List<int> st) {
    for (var k = 0; k < _cells.length; k++) {
      final want = numbers[_cells[k]]!;
      var lines = 0, open = 0;
      for (final e in _sides[k]) {
        if (st[e] == 1) lines++;
        if (st[e] == -1) open++;
      }
      if (lines > want || lines + open < want) return false;
      if (open == 0) continue;
      if (lines == want || lines + open == want) {
        for (final e in _sides[k]) {
          if (st[e] == -1) set(st, e, lines == want ? 0 : 1);
        }
      }
    }
    return true;
  }

  @override
  bool cluesMet(List<bool> lines) {
    for (var k = 0; k < _cells.length; k++) {
      if (_sides[k].where((e) => lines[e]).length != numbers[_cells[k]]) return false;
    }
    return true;
  }
}
