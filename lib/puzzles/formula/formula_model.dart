import '../../core/grid.dart';

/// Symbols are single characters: digits, `+ - * /`, brackets, `²`, `³`
/// and `=`. A blank tile of the row being typed is a space.
const formulaDigits = '1234567890';
const formulaSquare = '²';
const formulaCube = '³';
const formulaBlank = ' ';

/// The operator keys of each level: plus and minus, the four operations,
/// and brackets and powers on top.
const formulaOps = ['+-', '+-*/', '+-*/()²³'];

/// How a symbol is shown on tiles and keys.
String formulaGlyph(String symbol) => switch (symbol) {
  '-' => '−',
  '*' => '×',
  '/' => '÷',
  _ => symbol,
};

/// Marks of a guessed tile, worst to best.
enum FormulaMark { absent, present, correct }

/// An exact fraction (denominator > 0, lowest terms).
typedef _Frac = (int n, int d);

/// Past this, a value is too big to compare exactly on the web.
const _huge = 1e15;

/// Parses and evaluates a calculation. Null from any method means "not a
/// calculation" (bad syntax, a leading zero, division by zero, a huge
/// value), or in [nice] mode a calculation no answer should have: a
/// zero, a negative or fractional step, ×1, ÷1, a quotient of 1 or a power
/// of 1.
class _Parser {
  _Parser(this.s, {this.nice = false});

  final String s;
  final bool nice;
  int i = 0;

  /// Operations seen (a bare number is not a calculation).
  int ops = 0;

  String? get _peek => i < s.length ? s[i] : null;

  static _Frac? _make(int n, int d) {
    if (d == 0) return null;
    if (n.abs() > _huge || d.abs() > _huge) return null;
    final g = n.gcd(d);
    if (g > 1) {
      n ~/= g;
      d ~/= g;
    }
    return d < 0 ? (-n, -d) : (n, d);
  }

  static bool _fits(int a, int b) => a.abs().toDouble() * b.abs() <= _huge;

  _Frac? _checked(_Frac? v) => v == null || (nice && (v.$2 != 1 || v.$1 < 1)) ? null : v;

  _Frac? _mul(_Frac a, _Frac b) =>
      _fits(a.$1, b.$1) && _fits(a.$2, b.$2) ? _checked(_make(a.$1 * b.$1, a.$2 * b.$2)) : null;

  _Frac? _add(_Frac a, _Frac b, int sign) {
    if (!_fits(a.$1, b.$2) || !_fits(b.$1, a.$2) || !_fits(a.$2, b.$2)) return null;
    return _checked(_make(a.$1 * b.$2 + sign * b.$1 * a.$2, a.$2 * b.$2));
  }

  bool _unit(_Frac v) => v.$1 == 1 && v.$2 == 1;

  _Frac? expr() {
    var v = term();
    while (v != null && (_peek == '+' || _peek == '-')) {
      final sign = s[i++] == '+' ? 1 : -1;
      ops++;
      final u = term();
      if (u == null) return null;
      v = _add(v, u, sign);
    }
    return v;
  }

  _Frac? term() {
    var v = factor();
    while (v != null && (_peek == '*' || _peek == '/')) {
      final times = s[i++] == '*';
      ops++;
      final u = factor();
      if (u == null || u.$1 == 0 && !times) return null;
      if (nice && (_unit(u) || (times && _unit(v)))) return null;
      v = times ? _mul(v, u) : _mul(v, (u.$2 * u.$1.sign, u.$1.abs()));
      // A quotient of 1 says nothing.
      if (nice && !times && v != null && _unit(v)) return null;
    }
    return v;
  }

  _Frac? factor() {
    var v = primary();
    while (v != null && (_peek == formulaSquare || _peek == formulaCube)) {
      final cube = s[i++] == formulaCube;
      ops++;
      if (nice && _unit(v)) return null;
      final sq = _mul(v, v);
      v = sq == null || !cube ? sq : _mul(sq, v);
    }
    return v;
  }

  _Frac? primary() {
    if (_peek == '(') {
      i++;
      final v = expr();
      if (v == null || _peek != ')') return null;
      i++;
      return v;
    }
    final n = number();
    return n == null || (nice && n == 0) ? null : (n, 1);
  }

  /// A whole number without a leading zero.
  int? number() {
    final start = i;
    while (i < s.length && s.codeUnitAt(i) >= 0x30 && s.codeUnitAt(i) <= 0x39) {
      i++;
    }
    final len = i - start;
    if (len == 0 || len > 12 || (len > 1 && s[start] == '0')) return null;
    return int.parse(s.substring(start, i));
  }
}

/// The whole-number value of [calc], or null if it has none (see [_Parser]
/// for [nice]).
int? formulaValue(String calc, {bool nice = false}) {
  final p = _Parser(calc, nice: nice);
  final v = p.expr();
  if (v == null || p.i != calc.length || v.$2 != 1 || (nice && p.ops == 0)) return null;
  return v.$1;
}

/// What is wrong with a guess, if anything.
enum FormulaCheck { ok, malformed, untrue }

/// Checks a full row: a calculation, one `=`, then a plain number that is
/// its value. [nice] also rejects what a generated answer never has (see
/// [_Parser]).
FormulaCheck formulaCheck(String row, {bool nice = false}) {
  final eq = row.indexOf('=');
  if (eq <= 0 || eq != row.lastIndexOf('=')) return FormulaCheck.malformed;
  final left = _Parser(row.substring(0, eq), nice: nice);
  final value = left.expr();
  final right = _Parser(row.substring(eq + 1));
  final number = right.number();
  if (value == null || left.i != left.s.length || number == null || right.i != right.s.length) {
    return FormulaCheck.malformed;
  }
  if (nice && left.ops == 0) return FormulaCheck.malformed;
  return value.$2 == 1 && value.$1 == number ? FormulaCheck.ok : FormulaCheck.untrue;
}

/// The mark of every tile of [guess] against [answer]. A symbol is marked
/// (correct first, then present from the left) at most as many times as the
/// answer has it.
List<FormulaMark> formulaMarks(String answer, String guess) {
  final marks = List.filled(guess.length, FormulaMark.absent);
  final spare = <String, int>{};
  for (var i = 0; i < answer.length; i++) {
    if (guess[i] == answer[i]) {
      marks[i] = FormulaMark.correct;
    } else {
      spare[answer[i]] = (spare[answer[i]] ?? 0) + 1;
    }
  }
  for (var i = 0; i < guess.length; i++) {
    if (marks[i] == FormulaMark.correct) continue;
    final left = spare[guess[i]] ?? 0;
    if (left > 0) {
      marks[i] = FormulaMark.present;
      spare[guess[i]] = left - 1;
    }
  }
  return marks;
}

class FormulaPuzzle {
  const FormulaPuzzle({required this.rows, required this.answer, required this.level});

  /// Guesses allowed.
  final int rows;

  /// The hidden equation.
  final String answer;

  /// Index into [formulaOps]: which operators the answer (and the keys) use.
  final int level;

  int get cols => answer.length;
  GridSize get size => GridSize(rows, cols);

  /// Operator keys, without `=`.
  String get ops => formulaOps[level];

  Map<String, dynamic> toJson() => {'rows': rows, 'answer': answer, 'level': level};

  factory FormulaPuzzle.fromJson(Map<String, dynamic> j) =>
      FormulaPuzzle(rows: j['rows'] as int, answer: j['answer'] as String, level: j['level'] as int);
}

class FormulaState {
  const FormulaState({required this.guesses, required this.row, required this.cursor});

  FormulaState.initial(FormulaPuzzle p) : this(guesses: const [], row: formulaBlank * p.cols, cursor: 0);

  /// Entered rows, oldest first.
  final List<String> guesses;

  /// The row being typed, [formulaBlank] where nothing is yet.
  final String row;

  /// The tile the next symbol goes to (the row's length: none).
  final int cursor;

  bool get full => !row.contains(formulaBlank);

  FormulaState _typing(String row, int cursor) => FormulaState(guesses: guesses, row: row, cursor: cursor);

  String _with(int at, String symbol) => row.replaceRange(at, at + 1, symbol);

  /// [symbol] on the cursor's tile; the cursor steps right.
  FormulaState type(String symbol) => cursor >= row.length ? this : _typing(_with(cursor, symbol), cursor + 1);

  /// Clears the cursor's tile, or the one before it when that is blank already.
  FormulaState backspace() {
    if (cursor < row.length && row[cursor] != formulaBlank) return _typing(_with(cursor, formulaBlank), cursor);
    if (cursor == 0) return this;
    return _typing(_with(cursor - 1, formulaBlank), cursor - 1);
  }

  FormulaState moveTo(int col) => col == cursor ? this : _typing(row, col);

  /// The typed row becomes a guess.
  FormulaState enter() => FormulaState(guesses: [...guesses, row], row: formulaBlank * row.length, cursor: 0);

  Map<String, dynamic> toJson() => {'guesses': guesses, 'row': row, 'cursor': cursor};

  factory FormulaState.fromJson(Map<String, dynamic> j) => FormulaState(
    guesses: (j['guesses'] as List).cast<String>(),
    row: j['row'] as String,
    cursor: j['cursor'] as int,
  );
}

bool formulaSolved(FormulaPuzzle p, FormulaState s) => s.guesses.isNotEmpty && s.guesses.last == p.answer;

/// Out of guesses (or solved): nothing more can be typed.
bool formulaOver(FormulaPuzzle p, FormulaState s) => formulaSolved(p, s) || s.guesses.length >= p.rows;

/// The best mark each symbol got in the guesses so far.
Map<String, FormulaMark> formulaKnown(FormulaPuzzle p, FormulaState s) {
  final known = <String, FormulaMark>{};
  for (final g in s.guesses) {
    final marks = formulaMarks(p.answer, g);
    for (var i = 0; i < g.length; i++) {
      final old = known[g[i]];
      if (old == null || marks[i].index > old.index) known[g[i]] = marks[i];
    }
  }
  return known;
}

/// A hint: the answer's symbol on one tile of the typed row, a tile no guess
/// had right if there is one. Returns the state and the tile, or null when
/// the game is over. A row that becomes the answer is entered.
(FormulaState, int)? formulaHint(FormulaPuzzle p, FormulaState s) {
  if (formulaOver(p, s)) return null;
  final wrong = [
    for (var i = 0; i < p.cols; i++)
      if (s.row[i] != p.answer[i]) i,
  ];
  if (wrong.isEmpty) return (s.enter(), 0);
  final at = wrong.firstWhere((i) => s.guesses.every((g) => g[i] != p.answer[i]), orElse: () => wrong.first);
  final row = s.row.replaceRange(at, at + 1, p.answer[at]);
  final blank = row.indexOf(formulaBlank);
  final next = FormulaState(guesses: s.guesses, row: row, cursor: blank < 0 ? p.cols : blank);
  return (row == p.answer ? next.enter() : next, at);
}

/// Different symbols in [text] (an opening guess wants many).
int formulaVariety(String text) => text.split('').toSet().length;
