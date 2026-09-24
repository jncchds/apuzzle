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
    expect(store.stats(type.id, params.difficulty).solved, 1);
    expect(store.hasSave(type.id), isFalse);
  });

  test('hint fills a correct value', () {
    final c = make();
    c.hint();
    expect(c.hintsUsed, 1);
    final p = c.flashHints.single;
    expect((c.state as ValueGrid).valueAt(p), puzzle.solution[puzzle.size.index(p)]);
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
}
