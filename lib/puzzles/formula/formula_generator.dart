import 'dart:math';

import '../../core/difficulty.dart';
import 'formula_model.dart';

/// Operators by difficulty: easy adds and subtracts, medium also multiplies
/// or divides, hard has a bracket or a power (the "maxi" game).
int formulaLevel(Difficulty d) => switch (d) {
  Difficulty.easy => 0,
  Difficulty.medium => 1,
  _ => 2,
};

/// A random true equation of the board's width. The calculation is drawn as
/// a template of the right length (`d` a digit 1–9, `D` any digit), filled
/// with digits until its value is a number that completes the row.
FormulaPuzzle generateFormula(GenParams params) {
  final rng = Random(params.seed);
  final cols = params.size.cols, level = formulaLevel(params.difficulty);
  for (var attempt = 0; attempt < 20000; attempt++) {
    // Digits right of the "=": mostly two or three.
    final result = const [1, 1, 2, 2, 2, 2, 3, 3, 3, 4][rng.nextInt(cols >= 9 ? 10 : 9)];
    final len = cols - 1 - result;
    if (len < 3) continue;
    final template = _Shape(rng, level).calc(len);
    if (template == null || !_fitsLevel(template, level)) continue;
    for (var fill = 0; fill < 40; fill++) {
      final calc = _fill(rng, template);
      final value = formulaValue(calc, nice: true);
      if (value == null || '$value'.length != result) continue;
      return FormulaPuzzle(rows: params.size.rows, answer: '$calc=$value', level: level);
    }
  }
  throw StateError('no equation of width $cols');
}

/// A level's answers use what the level adds, so the levels stay apart.
bool _fitsLevel(String template, int level) => switch (level) {
  0 => true,
  1 => template.contains(RegExp(r'[*/]')),
  _ => template.contains(RegExp('[($formulaSquare$formulaCube]')),
};

String _fill(Random rng, String template) {
  final out = StringBuffer();
  for (var i = 0; i < template.length; i++) {
    out.write(switch (template[i]) {
      'd' => 1 + rng.nextInt(9),
      'D' => rng.nextInt(10),
      final ch => ch,
    });
  }
  return out.toString();
}

/// Draws calculation templates of an exact length. Every method returns
/// null when the length can't be met.
class _Shape {
  _Shape(this.rng, this.level);

  final Random rng;
  final int level;

  String? _number(int len) => len < 1 || len > 3 ? null : 'd${'D' * (len - 1)}';

  String _power() => rng.nextInt(3) == 0 ? formulaCube : formulaSquare;

  /// [len] split into [parts] positive lengths, leaving one symbol between
  /// neighbours, or null.
  List<int>? _split(int len, int parts) {
    final free = len - (parts - 1);
    if (free < parts) return null;
    final cuts = (List.generate(free - 1, (i) => i + 1)..shuffle(rng)).take(parts - 1).toList()..sort();
    return [for (var k = 0; k < parts; k++) (k < cuts.length ? cuts[k] : free) - (k == 0 ? 0 : cuts[k - 1])];
  }

  /// Parts made by [part], joined by a random one of [ops].
  String? _join(List<int>? lens, String ops, String? Function(int len, int index, String before) part) {
    if (lens == null) return null;
    final out = StringBuffer();
    var op = '';
    for (var k = 0; k < lens.length; k++) {
      if (k > 0) out.write(op = ops[rng.nextInt(ops.length)]);
      final p = part(lens[k], k, op);
      if (p == null) return null;
      out.write(p);
    }
    return out.toString();
  }

  /// The whole left side: one to four terms.
  String? calc(int len) {
    final most = len >= 8 ? 4 : 3;
    final terms = level == 0 ? 2 + rng.nextInt(most - 1) : 1 + rng.nextInt(most);
    return _join(_split(len, terms), '+-', (n, _, before) => _term(n, afterMinus: before == '-'));
  }

  /// A factor, or factors multiplied and divided.
  String? _term(int len, {required bool afterMinus}) {
    final factors = level == 0 ? 1 : const [1, 1, 2, 2, 2, 3][rng.nextInt(6)];
    if (factors == 1) return _factor(len, tight: afterMinus);
    return _join(_split(len, factors), '*/', (n, _, _) => _factor(n, tight: true));
  }

  /// A number, a power, or a bracketed sum. Brackets alone only where they
  /// change the value ([tight]: next to × ÷ or after a minus).
  String? _factor(int len, {required bool tight}) {
    if (level < 2) return _number(len);
    String? wrap(String? inner, String before, String after) => inner == null ? null : '$before$inner$after';
    final options = <String? Function()>[
      () => _number(len),
      // Small bases, so powers stay readable.
      if (len == 2 || len == 3) () => wrap(_number(len - 1), '', _power()),
      if (len >= 6) () => wrap(_sum(len - 3), '(', ')${_power()}'),
      if (len >= 5 && tight) () => wrap(_sum(len - 2), '(', ')'),
      if (len >= 5 && tight) () => wrap(_sum(len - 2), '(', ')'),
    ];
    return options[rng.nextInt(options.length)]();
  }

  /// Numbers added and subtracted, for inside brackets.
  String? _sum(int len) => _join(_split(len, len >= 7 && rng.nextBool() ? 3 : 2), '+-', (n, _, _) => _number(n));
}
