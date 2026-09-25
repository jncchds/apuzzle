import 'package:flutter/material.dart';

import 'difficulty.dart';
import 'game_controller.dart';
import 'grid.dart';

enum InputMode { cycle, palette }

/// One choice of a [GameOption], e.g. the "Shifter" game mode.
class OptionChoice {
  const OptionChoice(this.id, this.label, [this.description]);

  /// Short lowercase letters: it becomes part of share codes and stats keys.
  final String id;
  final String label;
  final String? description;
}

/// A type-specific setting picked on the new-game sheet (game mode, goal...).
class GameOption {
  const GameOption(this.id, this.label, this.choices);

  final String id;
  final String label;

  /// The first one is the default.
  final List<OptionChoice> choices;
}

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

  /// Extra choices for a new game, given the current (possibly incomplete)
  /// ones, so an option's choices can depend on another (a goal per mode).
  List<GameOption> optionsFor(Map<String, String> chosen) => const [];

  /// [wanted] with invalid or missing choices replaced by defaults, in
  /// [optionsFor] order.
  Map<String, String> resolveOptions(Map<String, String> wanted) {
    var out = wanted;
    for (var pass = 0; pass < 4; pass++) {
      final next = {
        for (final o in optionsFor(out))
          o.id: o.choices.any((c) => c.id == out[o.id]) ? out[o.id]! : o.choices.first.id,
      };
      if (_sameOrder(next, out)) return next;
      out = next;
    }
    return out;
  }

  /// "Standard · Target score" for [params]' options (empty if none).
  String optionsLabel(GenParams params) {
    final chosen = resolveOptions(params.options);
    return [
      for (final o in optionsFor(chosen))
        for (final c in o.choices)
          if (c.id == chosen[o.id]) c.label,
    ].join(' · ');
  }

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

  /// The next state, or [state] itself to only point at [HintResult.cells].
  HintResult<S>? hint(P puzzle, S state);

  /// Score of a score-based game (kept as a best score in stats), or null.
  int? score(P puzzle, S state) => null;

  /// Heading of the win card.
  String finishTitle(P puzzle, S state) => 'Solved!';

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

/// Same entries in the same order.
bool _sameOrder(Map<String, String> a, Map<String, String> b) =>
    a.length == b.length && a.entries.map((e) => '${e.key}=${e.value}').join(',') == b.entries.map((e) => '${e.key}=${e.value}').join(',');
