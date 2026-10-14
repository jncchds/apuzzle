import 'dart:math';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/game_controller.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/recall.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/glimpse/glimpse_type.dart';
import 'package:apuzzle/ui/board/recall_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const type = GlimpseType();

  Future<GameController> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    const params = GenParams(size: GridSize.square(4), difficulty: Difficulty.easy, seed: 4);
    final puzzle = type.generate(params);
    final c = GameController(
      type: type,
      params: params,
      puzzle: puzzle,
      state: type.initialState(puzzle),
      settings: Settings(store.prefs),
      store: store,
      practice: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: RecallBoard(type: type, controller: c),
              ),
              RecallControls(type: type, controller: c),
            ],
          ),
        ),
      ),
    );
    return c;
  }

  /// Taps cell [i] of the 4×4 board.
  Future<void> tapCell(WidgetTester tester, int i) async {
    final box = tester.getRect(find.byType(RecallBoard));
    final cell = min(min(box.width / 4, box.height / 4), 80.0).floorToDouble();
    final topLeft = box.center - Offset(cell * 2, cell * 2);
    await tester.tapAt(topLeft + Offset((i % 4 + 0.5) * cell, (i ~/ 4 + 0.5) * cell));
    await tester.pump();
  }

  testWidgets('waits for a tap, shows the round, hides it and takes the answer', (tester) async {
    final c = await pump(tester);
    RecallState s() => c.state as RecallState;
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Tap to start'), findsOneWidget);
    expect(s().phase, RecallPhase.show);

    await tester.tap(find.byType(RecallBoard));
    await tester.pump();
    expect(find.text('Tap to start'), findsNothing);
    expect(find.text('Ready'), findsOneWidget);
    final round = type.roundOf(c.puzzle as RecallPuzzle, s());
    await tester.pump(Duration(milliseconds: type.showMs(c.puzzle as RecallPuzzle, round)! + 50));
    expect(s().phase, RecallPhase.answer);
    expect(find.text('Tap every cell that lit up'), findsOneWidget);

    for (final i in round) {
      await tapCell(tester, i);
    }
    expect(s().phase, RecallPhase.result);
    expect(s().passed, isTrue);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    // The next round starts at once, one cell more.
    expect((s().round, s().level, s().phase), (1, round.length + 1, RecallPhase.show));
    expect(find.text('Tap to start'), findsNothing);

    // Ready hides it early; a wrong tap misses.
    await tester.tap(find.text('Ready'));
    await tester.pump();
    expect(s().phase, RecallPhase.answer);
    final next = type.roundOf(c.puzzle as RecallPuzzle, s());
    await tapCell(tester, List.generate(16, (i) => i).firstWhere((i) => !next.contains(i)));
    expect((s().phase, s().passed), (RecallPhase.result, false));
    expect(find.text('Missed'), findsOneWidget);
    // A tap skips the result.
    await tester.tap(find.byType(RecallBoard));
    await tester.pump();
    expect((s().round, s().level), (2, round.length));
  });

  testWidgets('a round on show waits again after the app was away', (tester) async {
    final c = await pump(tester);
    await tester.tap(find.byType(RecallBoard));
    await tester.pump(const Duration(milliseconds: 300));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 10));
    expect((c.state as RecallState).phase, RecallPhase.show);
    expect(find.text('Tap to start'), findsOneWidget);
  });
}
