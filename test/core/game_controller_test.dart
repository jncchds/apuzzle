import 'package:apuzzle/core/daily.dart';
import 'package:apuzzle/core/day.dart';
import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/game_controller.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_type.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/core/value_grid.dart';
import 'package:apuzzle/puzzles/mambo/mambo_model.dart';
import 'package:apuzzle/puzzles/mambo/mambo_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const type = MamboType();
  const params = GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 11);
  late GameStore store;
  late Settings settings;
  late MamboPuzzle puzzle;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = await GameStore.open();
    settings = Settings(store.prefs);
    puzzle = type.generate(params);
  });

  GameController make() => GameController(
    type: type,
    params: params,
    puzzle: puzzle,
    state: type.initialState(puzzle),
    settings: settings,
    store: store,
  );

  Pos firstEmpty(GameController c) =>
      puzzle.size.positions.firstWhere((p) => (c.state as ValueGrid).at(p).value == null);

  test('cycle input, undo, redo', () {
    final c = make();
    final p = firstEmpty(c);
    type.onCellTap(c, p);
    expect((c.state as ValueGrid).valueAt(p), sun);
    type.onCellTap(c, p);
    expect((c.state as ValueGrid).valueAt(p), moon);
    type.onCellTap(c, p);
    expect((c.state as ValueGrid).valueAt(p), isNull);
    c.undo();
    expect((c.state as ValueGrid).valueAt(p), moon);
    c.undo();
    c.redo();
    expect((c.state as ValueGrid).valueAt(p), moon);
    type.onCellSecondary(c, p); // cycles back
    expect((c.state as ValueGrid).valueAt(p), sun);
  });

  test('given cells cannot be changed', () {
    final c = make();
    final g = puzzle.size.positions.firstWhere((p) => puzzle.givenAt(puzzle.size.index(p)) != null);
    final before = c.state;
    type.onCellTap(c, g);
    expect(identical(c.state, before), isTrue);
  });

  test('palette: value-first stamping, cell-first, eraser', () {
    final c = make()..setInputMode(InputMode.palette);
    final p = firstEmpty(c);
    type.onPaletteTap(c, moon); // latch moon
    type.onCellTap(c, p);
    expect((c.state as ValueGrid).valueAt(p), moon);
    type.onCellTap(c, p); // same value again toggles off
    expect((c.state as ValueGrid).valueAt(p), isNull);
    type.onPaletteTap(c, moon); // unlatch
    expect(c.tool, isNull);
    type.onCellTap(c, p); // select
    expect(c.selectedCell, p);
    type.onPaletteTap(c, sun); // apply to selected cell
    expect((c.state as ValueGrid).valueAt(p), sun);
    type.onPaletteTap(c, GameController.eraser);
    expect((c.state as ValueGrid).valueAt(p), isNull);
  });

  test('submit: incomplete, conflicts, then solved with stats', () async {
    final c = make();
    expect(c.submit(), SubmitOutcome.incomplete);

    // Fill everything wrongly-flipped where possible to force conflicts.
    var s = c.state as ValueGrid;
    for (var i = 0; i < 36; i++) {
      final pos = puzzle.size.pos(i);
      if (s.at(pos).given) continue;
      s = s.set(pos, s.at(pos).withValue(1 - puzzle.solution[i]));
    }
    c.apply(s);
    expect(c.submit(), SubmitOutcome.conflicts);
    expect(c.flashErrors, isNotEmpty);

    // Now solve.
    s = c.state as ValueGrid;
    for (var i = 0; i < 36; i++) {
      final pos = puzzle.size.pos(i);
      s = s.set(pos, s.at(pos).withValue(puzzle.solution[i]));
    }
    c.apply(s);
    expect(c.solved, isTrue);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(store.stats(type.id, params.variant).solved, 1);
    expect(store.hasSave(type.id), isFalse);
  });

  test('hint fills a correct value', () {
    final c = make();
    c.hint();
    expect(c.hintsUsed, 1);
    final p = c.flashHints.single;
    expect((c.state as ValueGrid).valueAt(p), puzzle.solution[puzzle.size.index(p)]);
  });

  test('hint plays the explained step', () {
    final c = make();
    final e = type.explain(puzzle, c.state as ValueGrid)!;
    c.hint();
    expect(c.flashHints, e.targets);
    expect((c.state as ValueGrid).toFlat(), (e.next! as ValueGrid).toFlat());
  });

  test('explain mode: keeps the board, counts entering and each step', () {
    final c = make();
    final p = firstEmpty(c);
    type.onCellTap(c, p);
    final before = c.state;
    c.toggleExplain();
    expect(c.explaining, isTrue);
    expect(c.hintsUsed, 1);
    expect(identical(c.state, before), isTrue);
    expect(c.explanation, isNotNull);
    c.toggleExplain();
    expect(c.explaining, isFalse);
    expect(c.explanation, isNull);
    expect(identical(c.state, before), isTrue);

    c.toggleExplain();
    expect(c.hintsUsed, 2);
    final e = c.explanation!;
    c.applyExplanation();
    expect(c.hintsUsed, 3);
    expect((c.state as ValueGrid).toFlat(), (e.next! as ValueGrid).toFlat());
    expect(identical(c.explanation, e), isFalse, reason: 'the explanation follows the board');
    c.undo();
    expect(identical(c.state, before), isTrue);
  });

  test('save and resume', () async {
    final c = make();
    final p = firstEmpty(c);
    type.onCellTap(c, p);
    await c.save();
    final r = GameController.fromSave(type: type, json: store.readSave(type.id)!, settings: settings, store: store);
    expect((r.state as ValueGrid).valueAt(p), sun);
    expect((r.puzzle as MamboPuzzle).toJson(), puzzle.toJson());
  });

  test('a daily game has its own save slot and records the day', () async {
    const day = Day(2026, 9, 12);
    final free = make();
    type.onCellTap(free, firstEmpty(free));
    await free.save();

    final c = GameController(
      type: type,
      params: params,
      puzzle: puzzle,
      state: type.initialState(puzzle),
      settings: settings,
      store: store,
      daily: day,
    );
    await c.save();
    expect(store.hasSave(GameStore.dailySlot(c.code)), isTrue);
    expect(
      GameController.fromSave(type: type, json: store.readSave(c.saveSlot)!, settings: settings, store: store).daily,
      day,
    );

    var s = c.state as ValueGrid;
    for (var i = 0; i < 36; i++) {
      final pos = puzzle.size.pos(i);
      s = s.set(pos, s.at(pos).withValue(puzzle.solution[i]));
    }
    c.apply(s);
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(store.hasSave(c.saveSlot), isFalse);
    expect(store.hasSave(type.id), isTrue, reason: 'the free game is untouched');
    expect(store.dailyResults(day)[GameStore.dailyEntry(type.id, params.difficulty)]?.code, c.code);
    expect(store.stats(type.id, params.variant).solved, 1, reason: 'daily wins count in the stats');
  });

  test('a free game that is a daily puzzle counts for its day', () async {
    var day = dailyLaunch;
    while (!dailyGames(day).contains(type)) {
      day = day.addDays(1);
    }
    final daily = dailyParams(day, type, Difficulty.medium);
    final p = type.generate(daily);
    final c = GameController(
      type: type,
      params: daily,
      puzzle: p,
      state: type.initialState(p),
      settings: settings,
      store: store,
    );
    expect(c.saveSlot, type.id, reason: 'a free game');
    var s = c.state as ValueGrid;
    for (var i = 0; i < p.size.cellCount; i++) {
      final pos = p.size.pos(i);
      s = s.set(pos, s.at(pos).withValue(p.solution[i]));
    }
    c.apply(s);
    for (var i = 0; i < 4; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(c.solved, isTrue);
    expect(store.dailyResults(day)[GameStore.dailyEntry(type.id, Difficulty.medium)]?.code, c.code);
  });
}
