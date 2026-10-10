import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'formula_board.dart';
import 'formula_generator.dart';
import 'formula_model.dart';
import 'formula_tutorial.dart';

/// Guess the hidden equation: every guess is a true equation, and its tiles
/// are marked right place / wrong place / not there. The width is the
/// equation's length, the height the number of guesses; hard boards have
/// brackets and powers.
class FormulaType extends PuzzleType<FormulaPuzzle, FormulaState> {
  const FormulaType();

  @override
  String get id => 'formula';
  @override
  String name(AppLocalizations l) => l.formulaName;
  @override
  String tagline(AppLocalizations l) => l.formulaTagline;
  @override
  IconData get icon => Icons.calculate_outlined;
  @override
  Color get accent => formulaCorrectColor;

  @override
  String rulesText(AppLocalizations l) => l.formulaRules;

  @override
  List<TutorialStep> tutorial() => formulaTutorial;
  @override
  List<TutorialStep> strategies() => formulaStrategies;

  @override
  List<GridSize> get sizes => const [GridSize(6, 6), GridSize(6, 8), GridSize(6, 10)];
  @override
  GridSize get defaultSize => const GridSize(6, 8);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize(6, 6),
    Difficulty.medium => const GridSize(6, 8),
    _ => const GridSize(6, 10),
  };
  @override
  Day get dailySince => const Day(2026, 10, 10);
  @override
  double get minCellSize => 30;
  @override
  double get controlsHeight => 3 * FormulaKeys.keyHeight + 28;
  @override
  bool get showSubmit => false;

  @override
  FormulaPuzzle generate(GenParams params) => generateFormula(params);

  @override
  FormulaState initialState(FormulaPuzzle puzzle) => FormulaState.initial(puzzle);

  @override
  bool isComplete(FormulaPuzzle puzzle, FormulaState state) => formulaOver(puzzle, state);

  @override
  bool isSolved(FormulaPuzzle puzzle, FormulaState state) => formulaSolved(puzzle, state);

  @override
  Set<Pos> conflicts(FormulaPuzzle puzzle, FormulaState state) => const {};

  @override
  HintResult<FormulaState>? hint(FormulaPuzzle puzzle, FormulaState state) {
    final h = formulaHint(puzzle, state);
    return h == null ? null : HintResult(h.$1, {Pos(state.guesses.length, h.$2)});
  }

  @override
  String finishTitle(AppLocalizations l, FormulaPuzzle puzzle, FormulaState state) =>
      l.formulaSolvedIn(state.guesses.length);

  void _symbol(GameController ctrl, String symbol) => ctrl.apply((ctrl.state as FormulaState).type(symbol));

  void _backspace(GameController ctrl) => ctrl.apply((ctrl.state as FormulaState).backspace());

  /// Enters the typed row if it is a true equation. A guess can't be undone.
  void _enter(GameController ctrl) {
    final p = ctrl.puzzle as FormulaPuzzle, s = ctrl.state as FormulaState;
    final Tr? problem = !s.full
        ? (l) => l.formulaIncomplete
        : switch (formulaCheck(s.row)) {
            FormulaCheck.malformed => (l) => l.formulaMalformed,
            FormulaCheck.untrue => (l) => l.formulaUntrue,
            FormulaCheck.ok => null,
          };
    if (problem != null) {
      ctrl.shakeTick++;
      ctrl.showToast(problem);
      return;
    }
    final next = s.enter();
    ctrl.advance(next, forget: true);
    if (!ctrl.solved && formulaOver(p, next)) ctrl.showToast((l) => l.formulaOutOfGuesses);
  }

  bool _playing(GameController ctrl) =>
      !ctrl.solved && !formulaOver(ctrl.puzzle as FormulaPuzzle, ctrl.state as FormulaState);

  @override
  Widget buildBoard(BuildContext context, GameController ctrl) {
    final playing = _playing(ctrl);
    return FormulaBoard(
      puzzle: ctrl.puzzle as FormulaPuzzle,
      state: ctrl.state as FormulaState,
      hinted: ctrl.flashHints,
      win: ctrl.winAnimation,
      onSymbol: playing ? (symbol) => _symbol(ctrl, symbol) : null,
      onBackspace: playing ? () => _backspace(ctrl) : null,
      onEnter: playing ? () => _enter(ctrl) : null,
      // Moving the cursor is not a step to undo.
      onMove: playing ? (col) => ctrl.advance((ctrl.state as FormulaState).moveTo(col), persist: false) : null,
    );
  }

  @override
  Widget? buildControls(BuildContext context, GameController ctrl) {
    if (!_playing(ctrl)) return null;
    return FormulaKeys(
      puzzle: ctrl.puzzle as FormulaPuzzle,
      state: ctrl.state as FormulaState,
      onSymbol: (symbol) => _symbol(ctrl, symbol),
      onBackspace: () => _backspace(ctrl),
      onEnter: () => _enter(ctrl),
    );
  }

  @override
  Map<String, dynamic> encodePuzzle(FormulaPuzzle puzzle) => puzzle.toJson();
  @override
  FormulaPuzzle decodePuzzle(Map<String, dynamic> json) => FormulaPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(FormulaState state) => state.toJson();
  @override
  FormulaState decodeState(Map<String, dynamic> json) => FormulaState.fromJson(json);
}
