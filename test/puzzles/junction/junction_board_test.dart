import 'package:apuzzle/l10n/l10n.dart';
import 'package:apuzzle/puzzles/junction/junction_board.dart';
import 'package:apuzzle/puzzles/junction/junction_model.dart';
import 'package:apuzzle/puzzles/junction/junction_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // One switch at cell 12 (the middle of 5×5): up to station 0, down to station 1.
  final p = junctionPractice(
    5,
    5,
    10,
    const [
      [10, 11, 12, 7, 2, 3, 4],
      [12, 17, 22, 23, 24],
    ],
    stations: const [4, 24],
    trains: const [1, 1],
    start: const [0],
  );

  Future<List<JunctionState>> run(WidgetTester tester) async {
    var state = JunctionState.initial(p);
    final seen = <JunctionState>[];
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => JunctionBoard(
            puzzle: p,
            state: state,
            onStep: () => setState(() => seen.add(state = junctionStep(p, state))),
            onFlip: (k) => setState(() => seen.add(state = junctionFlip(p, state, k))),
            onRestart: () => setState(() => state = JunctionState.initial(p)),
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

  testWidgets('waits for the first tap, then steps on its own clock', (tester) async {
    final seen = await run(tester);
    await wait(tester, 1000);
    expect(seen, isEmpty);
    expect(find.text('Tap to start'), findsOneWidget);
    await tester.tapAt(tester.getCenter(find.byType(JunctionBoard)) + const Offset(-128, -128));
    await wait(tester, 2000);
    expect(seen, isNotEmpty);
    expect(seen.last.trains, isNotEmpty);
    expect(find.text('Tap to start'), findsNothing);
  });

  testWidgets('a tap on a switch flips it, a tap elsewhere pauses', (tester) async {
    final seen = await run(tester);
    final board = tester.getCenter(find.byType(JunctionBoard));
    // The switch is the middle cell (64 px cells); a tap in a corner starts.
    await tester.tapAt(tester.getCenter(find.byType(JunctionBoard)) + const Offset(-128, -128));
    await wait(tester, 1000);
    await tester.tapAt(board);
    await tester.pump();
    expect(seen.last.settings, [1]);
    await tester.tapAt(tester.getCenter(find.byType(JunctionBoard)) + const Offset(128, 128));
    await tester.pump();
    final steps = seen.length;
    await wait(tester, 3000);
    expect(seen.length, steps, reason: 'paused');
    expect(find.text('Paused: tap to go on'), findsOneWidget);
  });

  testWidgets('a wrong station on a practice board stops, a tap restarts', (tester) async {
    final seen = await run(tester);
    await tester.tapAt(tester.getCenter(find.byType(JunctionBoard)) + const Offset(-128, -128));
    await wait(tester, 8000);
    expect(seen.last.misses, 1);
    expect(find.text('Wrong station! Tap to try again'), findsOneWidget);
    await tester.tapAt(tester.getCenter(find.byType(JunctionBoard)) + const Offset(-128, -128));
    await tester.pump();
    expect(find.text('Tap to start'), findsOneWidget);
  });
}
