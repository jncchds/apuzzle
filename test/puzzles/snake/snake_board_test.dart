import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/snake/snake_board.dart';
import 'package:apuzzle/puzzles/snake/snake_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const p = SnakePuzzle(
    rows: 8,
    cols: 8,
    goal: SnakeGoal.free,
    target: 0,
    seed: 3,
    stepMs: 200,
    start: [34, 33, 32],
    dir: SnakeDir.right,
    food: 0,
  );

  Future<List<SnakeState>> run(WidgetTester tester, Future<void> Function() drive) async {
    var state = SnakeState.initial(p);
    final seen = <SnakeState>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => SnakeBoard(
            rows: p.rows,
            cols: p.cols,
            state: state,
            interval: p.stepMs,
            onStep: (d) => setState(() => seen.add(state = snakeStep(p, state, d))),
            onRestart: () => setState(() => state = SnakeState.initial(p)),
          ),
        ),
      ),
    );
    await drive();
    return seen;
  }

  testWidgets('waits for the first move, then steps on its own clock', (tester) async {
    final seen = await run(tester, () async {
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Swipe to start'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      for (var k = 0; k < 10; k++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    });
    expect(seen, isNotEmpty);
    expect(seen.first.dir, SnakeDir.up);
    expect(seen.first.body.first, 26);
    expect(find.text('Swipe to start'), findsNothing);
  });

  testWidgets('a swipe turns, a tap pauses', (tester) async {
    final seen = await run(tester, () async {
      await tester.drag(find.byType(SnakeBoard), const Offset(0, 120));
      for (var k = 0; k < 6; k++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.tapAt(tester.getCenter(find.byType(SnakeBoard)));
      await tester.pump(const Duration(milliseconds: 50));
    });
    expect(seen.first.dir, SnakeDir.down);
    final steps = seen.length;
    await tester.pump(const Duration(seconds: 2));
    expect(seen.length, steps, reason: 'paused');
    expect(find.text('Paused: swipe to go on'), findsOneWidget);
  });

  testWidgets('a crash stops the clock and a tap restarts', (tester) async {
    final seen = await run(tester, () async {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      for (var k = 0; k < 40; k++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    });
    expect(seen.last.dead, isTrue);
    expect(find.text('Crashed! Tap to try again'), findsOneWidget);
    await tester.tapAt(tester.getCenter(find.byType(SnakeBoard)));
    await tester.pump();
    expect(find.text('Swipe to start'), findsOneWidget);
  });
}
