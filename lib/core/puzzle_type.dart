import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'daily.dart' show dailyLaunch;
import 'day.dart';
import 'difficulty.dart';
import 'game_controller.dart';
import 'grid.dart';

enum InputMode { cycle, palette }

/// A type-specific setting picked on the new-game sheet (game mode, goal...).
/// Texts come from [PuzzleType.optionLabel] and friends.
class GameOption {
  const GameOption(this.id, this.choices);

  final String id;

  /// Choice ids, the first one is the default. Short lowercase letters: they
  /// become part of share codes and stats keys.
  final List<String> choices;
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
  String name(AppLocalizations l);
  String tagline(AppLocalizations l);
  String rulesText(AppLocalizations l);
  IconData get icon;
  Color get accent;

  List<GridSize> get sizes;
  GridSize get defaultSize;
  List<Difficulty> get difficulties => const [Difficulty.easy, Difficulty.medium, Difficulty.hard];

  /// Fixed grid size of the daily puzzle at [difficulty] (one of [sizes],
  /// fitting a small phone).
  GridSize dailySize(Difficulty difficulty);

  /// First day this type can appear in daily challenges. A new type
  /// overrides it with its release date, so earlier days keep their games.
  Day get dailySince => dailyLaunch;

  /// Extra choices for a new game, given the current (possibly incomplete)
  /// ones, so an option's choices can depend on another (a goal per mode).
  List<GameOption> optionsFor(Map<String, String> chosen) => const [];

  /// Heading of [option] on the new-game sheet.
  String optionLabel(AppLocalizations l, String option) => option;

  /// Name of [choice] of [option].
  String choiceLabel(AppLocalizations l, String option, String choice) => choice;

  /// One-line explanation of [choice], shown under the choices.
  String? choiceDescription(AppLocalizations l, String option, String choice) => null;

  /// [wanted] with invalid or missing choices replaced by defaults, in
  /// [optionsFor] order.
  Map<String, String> resolveOptions(Map<String, String> wanted) {
    var out = wanted;
    for (var pass = 0; pass < 4; pass++) {
      final next = {
        for (final o in optionsFor(out))
          o.id: o.choices.contains(out[o.id]) ? out[o.id]! : o.choices.first,
      };
      if (_sameOrder(next, out)) return next;
      out = next;
    }
    return out;
  }

  /// "Standard · Target score" for [params]' options (empty if none).
  String optionsLabel(AppLocalizations l, GenParams params) {
    final chosen = resolveOptions(params.options);
    return [for (final o in optionsFor(chosen)) choiceLabel(l, o.id, chosen[o.id]!)].join(' · ');
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
  String finishTitle(AppLocalizations l, P puzzle, S state) => l.solved;

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
