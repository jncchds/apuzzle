import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/value_grid.dart';
import '../../l10n/l10n.dart';
import 'sudoku_generator.dart';
import 'sudoku_model.dart';

class SudokuType extends ValueGridType<SudokuPuzzle> {
  const SudokuType();

  @override
  String get id => 'sudoku';
  @override
  String name(AppLocalizations l) => l.sudokuName;
  @override
  String tagline(AppLocalizations l) => l.sudokuTagline;
  @override
  IconData get icon => Icons.grid_3x3_rounded;
  @override
  Color get accent => const Color(0xFF5B8DEF);

  @override
  String rulesText(AppLocalizations l) => l.sudokuRules;

  @override
  List<GridSize> get sizes => const [GridSize.square(4), GridSize.square(6), GridSize.square(9)];
  @override
  GridSize get defaultSize => const GridSize.square(9);
  @override
  GridSize dailySize(Difficulty difficulty) => const GridSize.square(9);
  @override
  List<Difficulty> get difficulties => Difficulty.values;

  @override
  InputMode get defaultInputMode => InputMode.palette;
  @override
  bool get supportsModeSwitch => false;
  @override
  bool get supportsPencil => true;
  @override
  bool get highlightSameValue => true;
  @override
  bool get highlightPeers => true;
  @override
  bool get showLockIcon => false;
  @override
  double get gapRatio => 0.04;

  // Values are laid out for the largest size; smaller puzzles use a prefix.
  static const _all = [
    ValueSpec.text('1'), ValueSpec.text('2'), ValueSpec.text('3'), //
    ValueSpec.text('4'), ValueSpec.text('5'), ValueSpec.text('6'), //
    ValueSpec.text('7'), ValueSpec.text('8'), ValueSpec.text('9'),
  ];

  @override
  List<ValueSpec> get values => _all;

  @override
  List<ValueSpec> valuesFor(SudokuPuzzle puzzle) => _all.sublist(0, puzzle.n);

  @override
  (int, int) sections(SudokuPuzzle puzzle) => sudokuBox(puzzle.n);

  @override
  Iterable<Pos> markPeers(SudokuPuzzle puzzle, Pos pos) {
    final geo = SudokuGeometry.of(puzzle.n);
    return geo.peers[puzzle.size.index(pos)].map(puzzle.size.pos);
  }

  @override
  Widget buildValue(BuildContext context, SudokuPuzzle puzzle, ValueGrid state, Pos pos, CellValue cell, double size) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      '${cell.value! + 1}',
      style: TextStyle(
        fontSize: size * 0.6,
        height: 1,
        fontWeight: cell.given ? FontWeight.w800 : FontWeight.w500,
        color: cell.given ? scheme.onSurface : _entryColor(context),
      ),
    );
  }

  @override
  SudokuPuzzle generate(GenParams params) => generateSudoku(params);

  @override
  bool isSolved(SudokuPuzzle puzzle, ValueGrid state) =>
      state.isFull && sudokuConflicts(puzzle.n, state.toFlat()).isEmpty;

  @override
  Set<Pos> conflicts(SudokuPuzzle puzzle, ValueGrid state) =>
      {for (final i in sudokuConflicts(puzzle.n, state.toFlat())) puzzle.size.pos(i)};

  @override
  Map<String, dynamic> encodePuzzle(SudokuPuzzle puzzle) => puzzle.toJson();
  @override
  SudokuPuzzle decodePuzzle(Map<String, dynamic> json) => SudokuPuzzle.fromJson(json);

  /// Player-entered numbers: a clear blue, distinct from the givens.
  static Color _entryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? const Color(0xFF7CB6FF) : const Color(0xFF1F63D6);
}
