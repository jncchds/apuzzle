import 'package:apuzzle/core/lattice_loop.dart';
import 'package:apuzzle/ui/board/loop_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 6×6 cells, points at corners; 400×400 → cell 58, origin 23.
  final g = LatticeLoop(7, 7);
  late List<int> marks;

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: StatefulBuilder(
              builder: (context, setState) => LoopBoard(
                g: g,
                rows: 6,
                cols: 6,
                centered: false,
                marks: marks,
                lineColor: Colors.blue,
                paintClues: (_, _) {},
                onCommit: (m) => setState(() => marks = m),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Offset point(WidgetTester tester, int r, int c) {
    final box = tester.getTopLeft(find.byType(CustomPaint).last);
    const cell = 400 / 6.8;
    return box + Offset((0.4 + c) * cell.floorToDouble(), (0.4 + r) * cell.floorToDouble());
  }

  setUp(() => marks = List.filled(g.edgeCount, 0));

  testWidgets('tap cycles an edge: line, cross, empty', (tester) async {
    await pump(tester);
    final mid = (point(tester, 0, 0) + point(tester, 0, 1)) / 2;
    for (final want in [1, 2, 0]) {
      await tester.tapAt(mid);
      await tester.pump(const Duration(milliseconds: 400));
      expect(marks[g.h(0, 0)], want);
    }
  });

  testWidgets('a fast drag still draws every edge it passes', (tester) async {
    await pump(tester);
    await tester.dragFrom(point(tester, 0, 0), point(tester, 0, 3) - point(tester, 0, 0));
    await tester.pump();
    expect([for (var c = 0; c < 3; c++) marks[g.h(0, c)]], [1, 1, 1]);
  });

  for (final (name, from, to, edges) in [
    ('right along the top row', (0, 0), (0, 2), [g.h(0, 0), g.h(0, 1)]),
    ('left along the top row', (0, 6), (0, 4), [g.h(0, 5), g.h(0, 4)]),
    ('down a column', (0, 3), (2, 3), [g.v(0, 3), g.v(1, 3)]),
  ]) {
    testWidgets('drag $name draws, dragging again erases', (tester) async {
      await pump(tester);
      for (final want in [1, 0]) {
        await tester.timedDragFrom(
          point(tester, from.$1, from.$2),
          point(tester, to.$1, to.$2) - point(tester, from.$1, from.$2),
          const Duration(milliseconds: 300),
        );
        await tester.pump();
        for (final e in edges) {
          expect(marks[e], want, reason: 'edge $e');
        }
        expect(marks.where((m) => m != 0).length, want == 1 ? edges.length : 0);
      }
    });
  }
}
