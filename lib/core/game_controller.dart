import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../l10n/l10n.dart';
import 'day.dart';
import 'difficulty.dart';
import 'grid.dart';
import 'persistence.dart';
import 'puzzle_code.dart';
import 'puzzle_type.dart';
import 'settings.dart';

enum SubmitOutcome { solved, conflicts, incomplete, wrong }

/// Generic game session: current state, undo/redo, timer, input tools,
/// submit/hint, save/resume and win detection. Puzzle and state are opaque
/// objects owned by [type].
class GameController extends ChangeNotifier {
  GameController({
    required this.type,
    required this.params,
    required this.puzzle,
    required Object state,
    required this.settings,
    required this.store,
    Duration elapsed = Duration.zero,
    this.hintsUsed = 0,
    this.daily,
    this.practice = false,
  })  : _state = state, // ignore: prefer_initializing_formals
        _banked = elapsed,
        inputMode = type.defaultInputMode;

  final PuzzleType type;
  final GenParams params;
  final Object puzzle;
  final Settings settings;
  final GameStore store;

  /// The day whose daily challenge this puzzle belongs to, or null.
  final Day? daily;

  /// A tutorial board: nothing is saved and wins don't count.
  final bool practice;

  /// Where this game is saved: daily puzzles don't replace the free game.
  String get saveSlot => daily == null ? type.id : GameStore.dailySlot(code);

  /// Shareable code that regenerates this exact puzzle.
  String get code => PuzzleCode.format(type, params);
  String get link => PuzzleCode.link(type, params);

  Object _state;
  Object get state => _state;

  final List<Object> _undo = [];
  final List<Object> _redo = [];
  bool get canUndo => _undo.isNotEmpty && !solved;
  bool get canRedo => _redo.isNotEmpty && !solved;

  // ---- input tools (used by value-grid types) ----
  InputMode inputMode;

  /// Selected palette tool: a value index, [eraser], or null.
  int? tool;
  static const int eraser = -1;
  bool pencil = false;
  Pos? selectedCell;

  // ---- feedback ----
  Set<Pos> flashErrors = const {};
  Set<Pos> flashHints = const {};
  int flashTick = 0;
  int shakeTick = 0;

  /// Short message for the game screen to show (e.g. "Out of moves").
  Tr? toast;
  int toastTick = 0;

  /// Set by the game screen; drives the win ripple on the board.
  Animation<double>? winAnimation;

  bool solved = false;
  int hintsUsed;
  PuzzleStats? winStats;

  // ---- timer ----
  Duration _banked;
  DateTime? _since;

  Duration get elapsed => _banked + (_since == null ? Duration.zero : DateTime.now().difference(_since!));

  void resume() {
    if (solved || _since != null) return;
    _since = DateTime.now();
  }

  void pause() {
    if (_since == null) return;
    _banked = elapsed;
    _since = null;
  }

  Set<Pos> get liveConflicts => settings.highlightErrors && !solved ? type.conflicts(puzzle, _state) : const {};

  /// Union of everything that should be drawn as an error right now.
  Set<Pos> get errorCells => {...flashErrors, ...liveConflicts};

  // ---- state changes ----
  void apply(Object next) {
    if (solved || identical(next, _state)) return;
    _undo.add(_state);
    _redo.clear();
    _state = next;
    if (settings.haptics) HapticFeedback.selectionClick();
    _afterChange();
  }

  void undo() {
    if (!canUndo) return;
    _redo.add(_state);
    _state = _undo.removeLast();
    _afterChange();
  }

  void redo() {
    if (!canRedo) return;
    _undo.add(_state);
    _state = _redo.removeLast();
    _afterChange();
  }

  void restart() {
    if (solved) return;
    apply(type.initialState(puzzle));
  }

  void hint() {
    if (solved) return;
    final h = type.hint(puzzle, _state);
    if (h == null) return;
    hintsUsed++;
    flashHints = h.cells;
    flashTick++;
    if (identical(h.state, _state)) {
      notifyListeners(); // a pointer-only hint
    } else {
      apply(h.state);
    }
  }

  SubmitOutcome submit() {
    if (solved) return SubmitOutcome.solved;
    final complete = type.isComplete(puzzle, _state);
    if (complete && type.isSolved(puzzle, _state)) {
      _win();
      return SubmitOutcome.solved;
    }
    final c = type.conflicts(puzzle, _state);
    if (settings.haptics) HapticFeedback.heavyImpact();
    if (c.isNotEmpty) {
      flashErrors = c;
      flashTick++;
      notifyListeners();
      return SubmitOutcome.conflicts;
    }
    shakeTick++;
    notifyListeners();
    return complete ? SubmitOutcome.wrong : SubmitOutcome.incomplete;
  }

  void showToast(Tr message) {
    toast = message;
    toastTick++;
    notifyListeners();
  }

  /// Marks [cells] like a hint, until the next flash or [clearFlash].
  void pointAt(Set<Pos> cells) {
    flashHints = cells;
    notifyListeners();
  }

  void clearFlash() {
    if (flashErrors.isEmpty && flashHints.isEmpty) return;
    flashErrors = const {};
    flashHints = const {};
    notifyListeners();
  }

  void setInputMode(InputMode m) {
    inputMode = m;
    tool = null;
    selectedCell = null;
    notifyListeners();
  }

  void setTool(int? t) {
    tool = t;
    notifyListeners();
  }

  void togglePencil() {
    pencil = !pencil;
    notifyListeners();
  }

  void select(Pos? p) {
    selectedCell = p;
    notifyListeners();
  }

  void _afterChange() {
    if (flashErrors.isNotEmpty) flashErrors = const {};
    if (type.isComplete(puzzle, _state) && type.isSolved(puzzle, _state)) {
      _win();
      return;
    }
    save();
    notifyListeners();
  }

  Future<void> _win() async {
    solved = true;
    selectedCell = null;
    pause();
    if (settings.haptics) HapticFeedback.mediumImpact();
    notifyListeners();
    if (practice) return;
    await store.clearSave(saveSlot);
    winStats = await store.recordWin(type.id, params.variant, elapsed, score: type.score(puzzle, _state));
    if (daily case final day?) await store.recordDaily(day, type.id, params.difficulty, code, elapsed, hintsUsed);
    notifyListeners();
  }

  // ---- persistence ----
  Map<String, dynamic> toSave() => {
        'params': params.toJson(),
        'puzzle': type.encodePuzzle(puzzle),
        'state': type.encodeState(_state),
        'elapsed': elapsed.inMilliseconds,
        'hints': hintsUsed,
        if (daily != null) 'daily': daily.toString(),
      };

  Future<void> save() async {
    if (solved || practice) return;
    await store.writeSave(saveSlot, toSave());
  }

  static GameController fromSave({
    required PuzzleType type,
    required Map<String, dynamic> json,
    required Settings settings,
    required GameStore store,
  }) {
    final puzzle = type.decodePuzzle(json['puzzle'] as Map<String, dynamic>);
    return GameController(
      type: type,
      params: GenParams.fromJson(json['params'] as Map<String, dynamic>),
      puzzle: puzzle as Object,
      state: type.decodeState(json['state'] as Map<String, dynamic>) as Object,
      settings: settings,
      store: store,
      elapsed: Duration(milliseconds: json['elapsed'] as int? ?? 0),
      hintsUsed: json['hints'] as int? ?? 0,
      daily: Day.tryParse(json['daily'] as String?),
    );
  }
}
