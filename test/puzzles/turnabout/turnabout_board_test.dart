import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_board.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_model.dart';
import 'package:apuzzle/puzzles/turnabout/turnabout_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A slow race on 6×6 that turns a quarter at step 30.
  final p = turnaboutPractice(6, 5, rivalTicks: 20, turns: const [(30, 1)]);

  Future<List<TurnaboutState>> run(WidgetTester tester) async {
    var state = TurnaboutState.start(p, 0);
    final seen = <TurnaboutState>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => TurnaboutBoard(
            puzzle: p,
            state: state,
            onStep: () => setState(() => seen.add(state = turnaboutStep(p, state))),
            onMove: (dir) {
              if (!turnaboutCanMove(state)) return TurnaboutMoveResult.wait;
              final next = turnaboutMove(p, state, dir);
              if (identical(next, state)) return TurnaboutMoveResult.blocked;
              setState(() => seen.add(state = next));
              return TurnaboutMoveResult.moved;
            },
            onNext: () => setState(() => state = turnaboutNext(p, state)),
            onRestart: () => setState(() => state = TurnaboutState.start(p, 0)),
          ),
        ),
      ),
    );
    return seen;
  }

  Future<void> wait(WidgetTester tester, int ms) async {
    for (var t = 0; t < ms; t += 50) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  /// A key toward the runner's best way (screen-relative).
  LogicalKeyboardKey best(TurnaboutState s) => const [
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.arrowLeft,
  ][turnaboutBestDir(p, s)];

  testWidgets('waits for the first move, then runs on its own clock', (tester) async {
    final seen = await run(tester);
    await wait(tester, 1000);
    expect(seen, isEmpty);
    expect(find.text('Swipe to start'), findsOneWidget);
    await tester.sendKeyEvent(best(TurnaboutState.start(p, 0)));
    await tester.pump();
    expect(seen.single.player, isNot(p.round(0).player), reason: 'the first move is played at once');
    await wait(tester, 1000);
    expect(seen.last.tick, greaterThanOrEqualTo(9));
    expect(find.text('Swipe to start'), findsNothing);
  });

  testWidgets('a swipe moves the runner, a tap pauses', (tester) async {
    final seen = await run(tester);
    final board = tester.getCenter(find.byType(TurnaboutBoard));
    final start = TurnaboutState.start(p, 0);
    final dir = turnaboutBestDir(p, start);
    final delta = const [Offset(0, -40), Offset(40, 0), Offset(0, 40), Offset(-40, 0)][dir];
    await tester.dragFrom(board, delta);
    await tester.pump();
    expect(seen.first.player, isNot(start.player));
    await wait(tester, 500);
    await tester.tapAt(board);
    await tester.pump();
    final steps = seen.length;
    await wait(tester, 2000);
    expect(seen.length, steps, reason: 'paused');
    expect(find.text('Paused: swipe to go on'), findsOneWidget);
  });

  testWidgets('keys follow the turned maze to the star', (tester) async {
    final seen = await run(tester);
    var s = TurnaboutState.start(p, 0);
    for (var k = 0; k < 400 && s.result == TurnaboutResult.running; k++) {
      await tester.sendKeyEvent(best(s));
      await wait(tester, 250);
      s = seen.isEmpty ? s : seen.last;
    }
    expect(s.result, TurnaboutResult.won);
  });

  testWidgets('a lost practice race says so, and a tap starts over', (tester) async {
    final seen = await run(tester);
    final board = tester.getCenter(find.byType(TurnaboutBoard));
    await tester.tapAt(board);
    await wait(tester, 30000);
    expect(seen.last.result, TurnaboutResult.lost);
    expect(find.text('The rival got there first! Tap to try again'), findsOneWidget);
    await tester.tapAt(board);
    await tester.pump();
    expect(find.text('Swipe to start'), findsOneWidget);
  });
}
