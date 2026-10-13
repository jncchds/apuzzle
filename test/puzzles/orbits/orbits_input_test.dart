import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/game_controller.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/l10n/app_localizations.dart';
import 'package:apuzzle/puzzles/orbits/orbits_model.dart';
import 'package:apuzzle/puzzles/orbits/orbits_tutorial.dart';
import 'package:apuzzle/puzzles/orbits/orbits_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const type = OrbitsType();
  // aaab / cddb / cddb / ceeb: star 0 sits in the top row's second cell.
  final puzzle = orbitsTutorial[1].puzzle as OrbitsPuzzle;

  Future<GameController> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    final c = GameController(
      type: type,
      params: const GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 1),
      puzzle: puzzle,
      state: type.initialState(puzzle),
      settings: Settings(store.prefs),
      store: store,
      practice: true,
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

  Offset cell(WidgetTester tester, int r, int c) => tester.getCenter(find.byType(AnimatedContainer).at(r * 4 + c));
  List<int> owner(GameController c) => (c.state as OrbitsState).owner;

  testWidgets('tap a star, then cells: they join it with their twins, also away from the region', (tester) async {
    final c = await pump(tester);
    await tester.tapAt(cell(tester, 0, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(owner(c)[0], -1, reason: 'no star picked yet');

    await tester.tapAt(cell(tester, 0, 1)); // pick the star
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tapAt(cell(tester, 0, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(owner(c).sublist(0, 3), [0, 0, 0]);

    await tester.tapAt(cell(tester, 0, 2)); // a cell of the picked star: cleared with its twin
    await tester.pump(const Duration(milliseconds: 400));
    expect(owner(c).sublist(0, 3), [-1, 0, -1]);

    // The star in the left column (cell 2,0) takes the bottom-left corner: not next to anything drawn by a drag.
    final left = puzzle.geo.home[8];
    await tester.tapAt(cell(tester, 2, 0));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tapAt(cell(tester, 3, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect([owner(c)[4], owner(c)[12]], [left, left]);

    await tester.tapAt(cell(tester, 2, 0)); // let go of the star: a tap clears again
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tapAt(cell(tester, 3, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect([owner(c)[4], owner(c)[12]], [-1, -1]);
  });

  testWidgets('a drag paints from a region and leaves its star picked', (tester) async {
    final c = await pump(tester);
    final g = await tester.startGesture(cell(tester, 0, 1));
    await g.moveTo(cell(tester, 0, 0));
    await g.up();
    await tester.pump(const Duration(milliseconds: 400));
    expect(owner(c).sublist(0, 3), [0, 0, 0]);
    c.undo();
    await tester.pump(const Duration(milliseconds: 400));
    expect(owner(c).sublist(0, 3), [-1, 0, -1]);
    await tester.tapAt(cell(tester, 0, 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(owner(c).sublist(0, 3), [0, 0, 0]);
  });
}
