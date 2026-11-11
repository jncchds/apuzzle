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
    this.teaches = const {},
    this.how,
  }) : _make = (() => puzzle),
       assert(done == null || answer != null, 'a custom goal needs an answer'),
       assert(answer == null || how != null, 'an answer needs a text saying how');

  /// A step on a board made by [make] (usually the type's generator), built
  /// only when the step opens.
  TutorialStep.generated({
    required this.text,
    required Object Function() make,
    this.focus = const {},
    this.look = false,
    this.teaches = const {},
  }) : _make = (() => make()),
       state = null,
       done = null,
       answer = null,
       how = null,
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

  /// The explain rules a strategy lesson teaches (the type's rule enum
  /// indices, or [ruleRefuted] for probing): "Show me" says so when its
  /// step uses one, and a test checks that the board needs one.
  final Set<int> teaches;

  /// For a step with an [answer]: how to get there (the gesture or move it
  /// asks for), shown by "Show me" before it plays the answer.
  final Tr? how;
}
