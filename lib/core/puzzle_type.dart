import 'package:flutter/material.dart';

import 'difficulty.dart';
import 'game_controller.dart';
import 'grid.dart';

enum InputMode { cycle, palette }

class HintResult<S> {
  const HintResult(this.state, this.cells);
  final S state;
  final Set<Pos> cells;
}

/// Plug-in contract for one puzzle type.
///
/// [P] is the immutable puzzle definition (clues + solution), [S] the immutable
/// player state. Implementations must be stateless (const) so they can be used
/// from a background isolate for generation.
abstract class PuzzleType<P, S> {
  const PuzzleType();

  String get id;
  String get name;
  String get tagline;
  String get rulesText;
  IconData get icon;
  Color get accent;

  List<GridSize> get sizes;
  GridSize get defaultSize;
  List<Difficulty> get difficulties => const [Difficulty.easy, Difficulty.medium, Difficulty.hard];

  /// Pure and deterministic for a given [params] (same seed → same puzzle).
  P generate(GenParams params);

  /// Part of the shareable puzzle code. Bump it whenever a change to [generate]
  /// makes an old seed produce a different puzzle, so stale codes are rejected.
  int get generatorVersion => 1;

  S initialState(P puzzle);
  bool isComplete(P puzzle, S state);

  /// Rule-based validation (any valid solution is accepted).
  bool isSolved(P puzzle, S state);

  /// Cells that break a rule. Shown on submit, or live if the setting is on.
  Set<Pos> conflicts(P puzzle, S state);

  HintResult<S>? hint(P puzzle, S state);

  Map<String, dynamic> encodePuzzle(P puzzle);
  P decodePuzzle(Map<String, dynamic> json);
  Map<String, dynamic> encodeState(S state);
  S decodeState(Map<String, dynamic> json);

  Widget buildBoard(BuildContext context, GameController controller);

  /// Optional controls under the toolbar (e.g. a value palette).
  Widget? buildControls(BuildContext context, GameController controller) => null;

  bool get supportsModeSwitch => false;

  /// Smallest comfortable cell size for this type (used to cap grid sizes).
  double get minCellSize => 34;

  /// Extra vertical space (px) the controls under the board need.
  double get controlsHeight => 140;

  /// Whether the toolbar shows a Submit button (types that auto-detect the end can hide it).
  bool get showSubmit => true;
  InputMode get defaultInputMode => InputMode.cycle;
}
