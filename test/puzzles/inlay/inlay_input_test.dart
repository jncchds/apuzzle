import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/game_controller.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/l10n/app_localizations.dart';
import 'package:apuzzle/puzzles/inlay/inlay_board.dart';
import 'package:apuzzle/puzzles/inlay/inlay_model.dart';
import 'package:apuzzle/puzzles/inlay/inlay_tutorial.dart';
import 'package:apuzzle/puzzles/inlay/inlay_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const type = InlayType();
  // AAB / ACB / CCB: an L, a bar and another L.
  final puzzle = inlayTutorial[0].puzzle as InlayPuzzle;

  Future<GameController> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    final c = GameController(
      type: type,
      params: const GenParams(size: GridSize.square(3), difficulty: Difficulty.easy, seed: 1),
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

  InlayLayout layout(WidgetTester tester) => InlayLayout.of(puzzle, tester.getSize(find.byType(InlayBoard)));
  Offset origin(WidgetTester tester) => tester.getTopLeft(find.byType(InlayBoard));
  InlayState st(GameController c) => c.state as InlayState;

  /// The centre of the first cell of [piece] waiting in the tray.
  Offset trayCell(WidgetTester tester, GameController c, int piece) {
    final l = layout(tester);
    final (h, w) = puzzle.extent(piece, st(c).orient[piece]);
    final (r, col) = puzzle.cellsOf(piece, st(c).orient[piece]).first;
    final corner = l.slots[piece].center - Offset(w * l.tray / 2, h * l.tray / 2);
    return origin(tester) + corner + Offset((col + 0.5) * l.tray, (r + 0.5) * l.tray);
  }

  Offset boardCell(WidgetTester tester, int r, int c) {
    final l = layout(tester);
    return origin(tester) + l.board + Offset((c + 0.5) * l.cell, (r + 0.5) * l.cell);
  }

  Future<void> drag(WidgetTester tester, Offset from, Offset to) async {
    final g = await tester.startGesture(from);
    for (var k = 1; k <= 6; k++) {
      await g.moveTo(Offset.lerp(from, to, k / 6)!);
      await tester.pump();
    }
    await g.up();
    await tester.pump();
  }

  testWidgets('drag a piece onto the board, it snaps; off the board, back to the tray', (tester) async {
    final c = await pump(tester);
    // Piece 0's first cell is its top-left one: it lands on the board's corner.
    await drag(tester, trayCell(tester, c, 0), boardCell(tester, 0, 0) + const Offset(6, -5));
    expect(st(c).at[0], 0);

    // A drop where it doesn't fit (onto the bar) leaves it where it was.
    await drag(tester, trayCell(tester, c, 1), boardCell(tester, 0, 2));
    expect(st(c).at[1], 2);
    await drag(tester, boardCell(tester, 0, 0), boardCell(tester, 1, 1));
    expect(st(c).at[0], 0);

    await drag(tester, boardCell(tester, 0, 1), boardCell(tester, 0, 1) + const Offset(0, 600));
    expect(st(c).placed(0), isFalse);
    c.undo();
    expect(st(c).at[0], 0);
  });

  testWidgets('tap a piece to turn it, in the tray or on the board', (tester) async {
    final c = await pump(tester);
    await tester.tapAt(trayCell(tester, c, 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(st(c).orient[1], 1);
    // The bar turned across has no room in a three-cell column on its own:
    // lay it upright in the right column, then turn it on the board.
    await tester.tapAt(trayCell(tester, c, 1));
    await tester.pump(const Duration(milliseconds: 400));
    expect(st(c).orient[1], 2);
    await drag(tester, trayCell(tester, c, 1), boardCell(tester, 0, 2));
    expect(st(c).at[1], 2);
    // Across the top row it fits once piece 0 is not there.
    await tester.tapAt(boardCell(tester, 0, 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(st(c).orient[1], 3);
    expect(pieceCells(puzzle, st(c), 1).length, 3);
    expect(pieceCells(puzzle, st(c), 1).map((i) => i ~/ 3).toSet(), {0});
  });
}
