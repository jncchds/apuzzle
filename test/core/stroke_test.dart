import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/game_controller.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/core/value_grid.dart';
import 'package:apuzzle/l10n/app_localizations.dart';
import 'package:apuzzle/puzzles/camp/camp_model.dart';
import 'package:apuzzle/puzzles/camp/camp_type.dart';
import 'package:apuzzle/puzzles/kings/kings_model.dart';
import 'package:apuzzle/puzzles/kings/kings_type.dart';
import 'package:apuzzle/puzzles/pairs/pairs_model.dart';
import 'package:apuzzle/puzzles/pairs/pairs_type.dart';
import 'package:apuzzle/ui/board/cell_tile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const type = KingsType();
  const params = GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 3);

  Future<GameController> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    final puzzle = type.generate(params);
    final c = GameController(
      type: type,
      params: params,
      puzzle: puzzle,
      state: type.initialState(puzzle),
      settings: Settings(store.prefs),
      store: store,
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: ListenableBuilder(listenable: c, builder: (context, _) => type.buildBoard(context, c)),
        ),
      ),
    );
    return c;
  }

  Offset cell(WidgetTester tester, int r, int c) => tester.getCenter(find.byType(CellTile).at(r * 6 + c));
  List<int?> row(GameController c, int r) => [for (var k = 0; k < 6; k++) (c.state as ValueGrid).valueAt(Pos(r, k))];

  testWidgets('a slide gives every cell it crosses the first cell\'s change, as one undo step', (tester) async {
    final c = await pump(tester);
    await tester.tapAt(cell(tester, 2, 5));
    await tester.tapAt(cell(tester, 2, 5)); // a crown in the way
    await tester.pump(const Duration(milliseconds: 400));

    final g = await tester.startGesture(cell(tester, 2, 0));
    await g.moveTo(cell(tester, 2, 1));
    await g.moveTo(cell(tester, 2, 5)); // a fast move still fills the cells between
    await g.up();
    await tester.pump();
    expect(row(c, 2), [kDot, kDot, kDot, kDot, kDot, kKing]);

    c.undo();
    expect(row(c, 2), [null, null, null, null, null, kKing]);
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a long press dots the cells the crowns rule out, a right click cycles back', (tester) async {
    final c = await pump(tester);
    final puzzle = c.puzzle as KingsPuzzle;
    await tester.tapAt(cell(tester, 0, 0));
    await tester.tapAt(cell(tester, 0, 0));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.longPressAt(cell(tester, 4, 4));
    await tester.pump();

    final s = c.state as ValueGrid;
    for (var i = 1; i < 36; i++) {
      final ruledOut = i ~/ 6 == 0 || i % 6 == 0 || i == 7 || puzzle.regions[i] == puzzle.regions[0];
      expect(s.cells[i].value, ruledOut ? kDot : null, reason: 'cell $i');
    }
    c.undo();
    expect((c.state as ValueGrid).cells.where((x) => x.value != null).length, 1);

    await tester.tapAt(cell(tester, 4, 4), buttons: kSecondaryButton);
    await tester.pump();
    expect((c.state as ValueGrid).valueAt(const Pos(4, 4)), kKing);
    await tester.pump(const Duration(seconds: 1));
  });

  test('Campsite and Pairs know their ruled-out cells', () {
    const camp = CampType();
    final cp = camp.generate(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 1));
    var cs = camp.initialState(cp);
    final tent = cp.tents.indexOf(true);
    cs = cs.set(cp.size.pos(tent), cs.cells[tent].withValue(campTent));
    final dotted = camp.markForbidden(cp, cs);
    for (var i = 0; i < 36; i++) {
      final near = (i ~/ 6 - tent ~/ 6).abs() <= 1 && (i % 6 - tent % 6).abs() <= 1;
      if (near && cs.cells[i].value == null) expect(dotted.cells[i].value, campGrass);
      if (dotted.cells[i].value == campGrass) expect(cp.tents[i], isFalse, reason: 'cell $i');
    }

    const pairs = PairsType();
    final pp = pairs.generate(const GenParams(size: GridSize.square(6), difficulty: Difficulty.easy, seed: 1));
    var ps = pairs.initialState(pp);
    final a = pp.shaded.indexOf(true);
    final b = [a + 1, a + 6].firstWhere((j) => j < 36 && pp.shaded[j] && (j != a + 1 || j % 6 != 0));
    ps = ps.set(pp.size.pos(a), ps.cells[a].withValue(pairsShade));
    expect(identical(pairs.markForbidden(pp, ps), ps), isTrue); // a lone cell rules nothing out yet
    ps = ps.set(pp.size.pos(b), ps.cells[b].withValue(pairsShade));
    final pd = pairs.markForbidden(pp, ps);
    expect(pd.cells.where((x) => x.value == pairsDot), isNotEmpty);
    for (var i = 0; i < 36; i++) {
      if (pd.cells[i].value == pairsDot) expect(pp.shaded[i], isFalse, reason: 'cell $i');
    }
  });
}
