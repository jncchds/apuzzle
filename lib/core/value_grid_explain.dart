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
    if (f.slot < 0) return null;
    final v = placed(p, f);
    final cell = s.cells[f.slot];
    if (v == null || cell.value == v) return null;
    return s.set(p.size.pos(f.slot), cell.withValue(v));
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

  @override
  bool done(P p, ValueGrid s) {
    for (var i = 0; i < s.cells.length; i++) {
      if (s.cells[i].value != p.solutionAt(i)) return false;
    }
    return true;
  }
}

/// [ValueGridExplainer] for two-valued grids on a flat list (-1 unknown),
/// probing either value of every open cell.
abstract class BinaryGridExplainer<P extends ValueGridPuzzle> extends ValueGridExplainer<P, List<int>> {
  const BinaryGridExplainer();

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
  void refute(P p, List<int> k, int slot, int value) => k[slot] = 1 - value;

  @override
  int? placed(P p, Fact f) => switch (f.rule) {
    ruleAssume => null,
    ruleRefuted => 1 - f.value,
    _ => f.value,
  };
}
