import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/game_controller.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:apuzzle/puzzles/formula/formula_board.dart';
import 'package:apuzzle/puzzles/formula/formula_generator.dart';
import 'package:apuzzle/puzzles/formula/formula_model.dart';
import 'package:apuzzle/puzzles/formula/formula_type.dart';
import 'package:apuzzle/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/timing.dart';

const _c = FormulaMark.correct, _p = FormulaMark.present, _a = FormulaMark.absent;

FormulaState _typed(FormulaState s, String text) => text.split('').fold(s, (s, ch) => s.type(ch));

void main() {
  const type = FormulaType();

  test('a guess is a calculation, one "=" and its value', () {
    for (final ok in ['1+2=3', '2+3*4=14', '(2+3)*4=20', '2³-1=7', '(1+2)²=9', '8/4/2=1', '1/2*4=2', '3-5+9=7']) {
      expect(formulaCheck(ok), FormulaCheck.ok, reason: ok);
    }
    for (final untrue in ['1+2=4', '7/2=3', '2-5=3', '2*3²=36']) {
      expect(formulaCheck(untrue), FormulaCheck.untrue, reason: untrue);
    }
    for (final bad in ['3=1+2', '1+2=3=3', '01+2=3', '1+=1', '2(3)=6', '(1+2=3', '-1+4=3', '5/0=0', '=5', '12345']) {
      expect(formulaCheck(bad), FormulaCheck.malformed, reason: bad);
    }
  });

  test('values keep the order of operations and stay exact', () {
    expect(formulaValue('2+3*4'), 14);
    expect(formulaValue('2*3²'), 18);
    expect(formulaValue('(2*3)²'), 36);
    expect(formulaValue('2³²'), 64);
    expect(formulaValue('10/4*2'), 5);
    expect(formulaValue('7/2'), isNull);
    expect(formulaValue('999999³³'), isNull, reason: 'too big to compare exactly');
  });

  test('marks count a symbol only as often as the answer has it', () {
    expect(formulaMarks('9-4=5', '4+5=9'), [_p, _a, _p, _c, _p]);
    expect(formulaMarks('2+7=9', '2+2=4'), [_c, _c, _a, _c, _a]);
    expect(formulaMarks('1+1=2', '2-1=1'), [_p, _a, _c, _c, _p]);
    expect(formulaMarks('3²-2=7', '2³-1=7'), [_p, _a, _c, _a, _c, _c]);
  });

  test('typing, the cursor and backspace', () {
    const p = FormulaPuzzle(rows: 6, answer: '2+3=5', level: 0);
    var s = _typed(type.initialState(p), '1+4=');
    expect((s.row, s.cursor, s.full), ('1+4= ', 4, false));
    s = s.backspace();
    expect((s.row, s.cursor), ('1+4  ', 3));
    s = s.moveTo(0).type('9');
    expect((s.row, s.cursor), ('9+4  ', 1));
    s = s.moveTo(0).backspace();
    expect((s.row, s.cursor), (' +4  ', 0));
    expect(identical(s.backspace(), s), isTrue);
    s = _typed(s, '2+3=5');
    expect(identical(s.type('1'), s), isTrue, reason: 'the row is full');
    expect(type.isSolved(p, s), isFalse, reason: 'not entered yet');
    s = s.enter();
    expect(s.guesses, ['2+3=5']);
    expect((s.row, s.cursor), ('     ', 0));
    expect(type.isComplete(p, s) && type.isSolved(p, s), isTrue);
    expect(type.decodeState(type.encodeState(s)).guesses, s.guesses);
  });

  test('hints fill in the answer, unknown tiles first, and enter it', () {
    const p = FormulaPuzzle(rows: 6, answer: '9-4=5', level: 0);
    var s = _typed(type.initialState(p), '4+5=9').enter();
    final first = type.hint(p, s)!;
    expect(first.cells, {const Pos(1, 0)});
    expect(first.state.row, '9    ');
    s = _typed(first.state, '+');
    final fixed = type.hint(p, s)!;
    expect(fixed.state.row, '9-   ', reason: 'a wrong tile is corrected');
    s = fixed.state;
    for (var k = 0; k < 3; k++) {
      s = type.hint(p, s)!.state;
    }
    expect(s.guesses.last, p.answer);
    expect(type.hint(p, s), isNull);
  });

  test('generated answers are true equations of the right width and level', () {
    for (final size in type.sizes) {
      for (final d in type.difficulties) {
        final seen = <String>{};
        for (var seed = 0; seed < 200; seed++) {
          final p = type.generate(GenParams(size: size, difficulty: d, seed: seed));
          final a = p.answer;
          final reason = '${size.label} ${d.name} #$seed: $a';
          expect(a.length, size.cols, reason: reason);
          expect(p.rows, size.rows);
          expect(formulaCheck(a, nice: true), FormulaCheck.ok, reason: reason);
          expect(a.split('').every('$formulaDigits${p.ops}='.contains), isTrue, reason: reason);
          switch (d) {
            case Difficulty.easy:
              expect(p.ops, '+-');
            case Difficulty.medium:
              expect(a.contains(RegExp(r'[*/]')), isTrue, reason: reason);
            default:
              expect(a.contains(RegExp('[($formulaSquare$formulaCube]')), isTrue, reason: reason);
          }
          expect(type.encodePuzzle(type.decodePuzzle(type.encodePuzzle(p))), type.encodePuzzle(p));
          seen.add(a);
        }
        expect(seen.length, greaterThan(40), reason: '${size.label} ${d.name}');
      }
    }
  });

  test('generation is deterministic and fast', () {
    const params = GenParams(size: GridSize(6, 10), difficulty: Difficulty.hard, seed: 42);
    expect(generateFormula(params).answer, generateFormula(params).answer);
    final sw = Stopwatch()..start();
    for (var seed = 0; seed < 100; seed++) {
      generateFormula(params.withSeed(seed));
    }
    expect(sw.elapsedMilliseconds, lessThan(timeLimit(2000)));
    final code = PuzzleCode.format(type, params);
    expect(PuzzleCode.parse(code, puzzleTypes).params.size, params.size);
  });

  group('in a game', () {
    late GameController ctrl;
    const p = FormulaPuzzle(rows: 3, answer: '2+3=5', level: 0);

    Future<void> pump(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final store = await GameStore.open();
      ctrl = GameController(
        type: type,
        params: const GenParams(size: GridSize(3, 5), difficulty: Difficulty.easy, seed: 1),
        puzzle: p,
        state: type.initialState(p),
        settings: Settings(store.prefs),
        store: store,
        practice: true,
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListenableBuilder(
              listenable: ctrl,
              builder: (context, _) => Column(
                children: [
                  Expanded(child: type.buildBoard(context, ctrl)),
                  type.buildControls(context, ctrl) ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Future<void> tapKeys(WidgetTester tester, String symbols) async {
      for (final ch in symbols.split('')) {
        await tester.tap(find.descendant(of: find.byType(FormulaKeys), matching: find.text(formulaGlyph(ch))));
      }
      await tester.pump();
    }

    Future<void> submit(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();
    }

    FormulaState state() => ctrl.state as FormulaState;

    testWidgets('only true equations are entered, and a guess is final', (tester) async {
      await pump(tester);
      await tapKeys(tester, '1+4');
      await submit(tester);
      expect(state().guesses, isEmpty, reason: 'row not full');
      expect((ctrl.shakeTick, ctrl.toast != null), (1, true));
      await tapKeys(tester, '=6');
      await submit(tester);
      expect(state().guesses, isEmpty, reason: 'not true');
      expect(ctrl.shakeTick, 2);
      expect(ctrl.canUndo, isTrue);
      await tester.tap(find.byIcon(Icons.backspace_outlined));
      await tapKeys(tester, '5');
      await submit(tester);
      expect(state().guesses, ['1+4=5']);
      expect(ctrl.canUndo, isFalse, reason: 'a guess is not taken back');
      // The keys carry the marks.
      FormulaMark? keyMark(String symbol) => tester
          .widget<FormulaTile>(
            find.descendant(
              of: find.byType(FormulaKeys),
              matching: find.widgetWithText(FormulaTile, formulaGlyph(symbol)),
            ),
          )
          .mark;
      expect([keyMark('1'), keyMark('+'), keyMark('5'), keyMark('2')], [_a, _c, _c, null]);
    });

    testWidgets('running out of rows ends the typing; the answer wins', (tester) async {
      await pump(tester);
      for (var k = 0; k < 2; k++) {
        await tapKeys(tester, '1+4=5');
        await submit(tester);
      }
      await tapKeys(tester, '3+2=5');
      await submit(tester);
      expect(state().guesses.length, 3);
      expect(ctrl.solved, isFalse);
      expect(find.byType(FormulaKeys), findsNothing);
      ctrl.restart();
      await tester.pumpAndSettle();
      await tapKeys(tester, '2+3=5');
      await submit(tester);
      expect(ctrl.solved, isTrue);
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('a tap moves the cursor', (tester) async {
      await pump(tester);
      await tapKeys(tester, '1+4');
      await tester.tap(find.descendant(of: find.byType(FormulaBoard), matching: find.text('1')));
      await tester.pump();
      expect(state().cursor, 0);
      await tapKeys(tester, '9');
      expect(state().row, '9+4  ');
    });
  });
}
