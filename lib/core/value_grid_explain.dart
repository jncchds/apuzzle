import 'dart:math';

import 'explain.dart';
import 'grid.dart';
import 'value_grid.dart';

/// [Explainer] for value grids whose slots are cells: corrections, reveals
/// and moves come from the solution. Subclasses say which facts place a
/// value ([placed]).
abstract class ValueGridExplainer<P extends ValueGridPuzzle, K> extends Explainer<P, ValueGrid, K> {
  const ValueGridExplainer();

  /// The value [f] puts into its cell, or null if it only rules something out.
  int? placed(P p, Fact f);

  /// Cell values that agree with the solution (-1 elsewhere).
  List<int> knownValues(P p, ValueGrid s) => [
    for (var i = 0; i < s.cells.length; i++)
      if (s.cells[i].value case final v? when v == p.solutionAt(i)) v else -1,
  ];

  @override
  GridSize size(P p) => p.size;

  @override
  ValueGrid? move(P p, ValueGrid s, Fact f) {
    final v = f.slot < 0 ? null : placed(p, f);
    if (v == null || s.cells[f.slot].value == v) return null;
    return s.set(p.size.pos(f.slot), s.cells[f.slot].withValue(v));
  }

  @override
  Set<Pos> targets(P p, Fact f) => {p.size.pos(f.slot)};

  @override
  (Pos, ValueGrid)? wrongEntry(P p, ValueGrid s) {
    for (var i = 0; i < s.cells.length; i++) {
      final c = s.cells[i];
      if (!c.given && c.value != null && c.value != p.solutionAt(i)) {
        final pos = p.size.pos(i);
        return (pos, s.set(pos, c.withValue(null)));
      }
    }
    return null;
  }

  @override
  (Pos, ValueGrid)? reveal(P p, ValueGrid s) {
    for (var i = 0; i < s.cells.length; i++) {
      if (s.cells[i].value == null) {
        final pos = p.size.pos(i);
        return (pos, s.set(pos, s.cells[i].withValue(p.solutionAt(i))));
      }
    }
    return null;
  }

  /// Solution values the board may leave out (a dot that only notes "no
  /// crown here"): the puzzle is done without them.
  Set<int> get optionalValues => const {};

  @override
  bool done(P p, ValueGrid s) {
    for (var i = 0; i < s.cells.length; i++) {
      final v = s.cells[i].value, want = p.solutionAt(i);
      if (v != want && !(v == null && optionalValues.contains(want))) return false;
    }
    return true;
  }
}

/// [ValueGridExplainer] for two-valued grids on a flat list (-1 unknown),
/// probing either value of every open cell.
abstract class BinaryGridExplainer<P extends ValueGridPuzzle> extends ValueGridExplainer<P, List<int>> {
  const BinaryGridExplainer();

  /// The board value for each solver value (0, 1).
  List<int> get boardValues => const [0, 1];

  /// The board's entries that agree with the solution, as solver values.
  List<int> knownStates(P p, ValueGrid s) => [for (final v in knownValues(p, s)) v < 0 ? -1 : boardValues.indexOf(v)];

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  Iterable<(int, int)> probeCandidates(P p, List<int> k) sync* {
    for (var i = 0; i < k.length; i++) {
      if (k[i] == -1) {
        yield (i, 0);
        yield (i, 1);
      }
    }
  }

  @override
  void assume(P p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(P p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = 1 - value;

  @override
  int? placed(P p, Fact f) => switch (f.rule) {
    ruleAssume => null,
    ruleRefuted => boardValues[1 - f.value],
    _ => boardValues[f.value],
  };
}

/// [ValueGridExplainer] for candidate masks (bit v: value v) on a flat list,
/// probing cells with the fewest candidates first.
abstract class MaskGridExplainer<P extends ValueGridPuzzle> extends ValueGridExplainer<P, List<int>> {
  const MaskGridExplainer();

  /// The rule that places the last candidate left in a cell.
  int get lastCandidateRule;

  /// Rules that place a value ([Fact.value]); the others rule bits out.
  Set<int> get placingRules;

  static bool _single(int m) => m != 0 && m & (m - 1) == 0;

  static int _count(int m) {
    var k = 0;
    for (; m != 0; m &= m - 1) {
      k++;
    }
    return k;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  Iterable<(int, int)> probeCandidates(P p, List<int> k) sync* {
    final most = k.fold(0, (m, x) => max(m, _count(x)));
    for (var want = 2; want <= most; want++) {
      for (var i = 0; i < k.length; i++) {
        if (_count(k[i]) != want) continue;
        for (var v = 0; v < k[i].bitLength; v++) {
          if (k[i] & (1 << v) != 0) yield (i, v);
        }
      }
    }
  }

  @override
  void assume(P p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = 1 << value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(P p, List<int> k, int slot, int value, ExplainTrace t) {
    k[slot] &= ~(1 << value);
    if (_single(k[slot])) t.fact(slot, k[slot].bitLength - 1, lastCandidateRule, premises: [slot]);
  }

  @override
  int? placed(P p, Fact f) => placingRules.contains(f.rule) ? f.value : null;
}
