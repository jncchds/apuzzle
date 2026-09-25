import '../l10n/l10n.dart';
import 'grid.dart';

/// One step of a puzzle type's interactive tutorial: a tiny board that shows
/// one rule, trick or control. Played in a practice session (nothing is
/// saved or counted).
class TutorialStep {
  TutorialStep({
    required this.text,
    required Object puzzle,
    this.state,
    this.focus = const {},
    this.done,
    this.answer,
    this.look = false,
    this.openEnded = false,
  })  : _make = (() => puzzle),
        assert(done == null || answer != null, 'a custom goal needs an answer');

  /// A step on a board made by [make] (usually the type's generator), built
  /// only when the step opens.
  TutorialStep.generated({required this.text, required Object Function() make, this.look = false})
      : _make = (() => make()),
        state = null,
        focus = const {},
        done = null,
        answer = null,
        openEnded = false;

  /// What to read (and do) at this step.
  final Tr text;

  final Object Function() _make;
  Object? _puzzle;

  /// The board, a puzzle of the type (it can be smaller than the type's sizes).
  Object get puzzle => _puzzle ??= _make();

  /// Starting state, or null for the type's initial state.
  final Object? state;

  /// Cells to point at while the step is open.
  final Set<Pos> focus;

  /// The step's goal, or null to solve the board.
  final bool Function(Object state)? done;

  /// A state that meets [done] ("Show me" applies it; tests check it).
  final Object? answer;

  /// Only to look at: the board ignores input and the step is done at once.
  final bool look;

  /// Several solutions are fine (the step shows a rule, not a deduction).
  final bool openEnded;
}
