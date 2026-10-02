import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'lamps_model.dart';

/// What a traced [LampsSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [lampsDot] or [lampsLamp], the arg the lamp, wall or dark cell it's about.
enum LampsRule { lit, wallDone, wallNeed, onlySource, failSee, failMany, failFew, failDark }

const int _unk = -1;

/// Cell states: -1 unknown, [lampsDot] (no lamp), [lampsLamp]; walls hold
/// [lampsWall].
/// Tier 1: lamps darken their lines, wall counts, cells with one possible
/// light source. Tier 2: + probing (try a value, refute it by propagation).
class LampsSolver {
  LampsSolver(this.rows, this.cols, this.walls, this.numbers)
    : sight = lampsSight(rows, cols, walls),
      nb = orthNeighbors(rows, cols);

  final int rows;
  final int cols;
  final List<bool> walls;
  final List<int?> numbers;
  final List<List<int>> sight;
  final List<List<int>> nb;

  List<int> initial() => [for (var i = 0; i < walls.length; i++) walls[i] ? lampsWall : _unk];

  /// Applies tier-1 rules until nothing changes. False on a contradiction.
  /// With [t], every deduction is recorded (see [LampsRule]).
  bool propagate(List<int> st, [ExplainTrace? t]) {
    var changed = true;
    while (changed) {
      changed = false;
      final lit = List<bool>.filled(st.length, false);
      for (var i = 0; i < st.length; i++) {
        if (st[i] != lampsLamp) continue;
        lit[i] = true;
        for (final j in sight[i]) {
          if (st[j] == lampsLamp) {
            t?.fail(LampsRule.failSee.index, premises: [i, j], args: [i, j]);
            return false;
          }
          lit[j] = true;
          if (st[j] == _unk) {
            st[j] = lampsDot;
            t?.fact(j, lampsDot, LampsRule.lit.index, premises: [i], args: [i]);
            changed = true;
          }
        }
      }
      for (var i = 0; i < st.length; i++) {
        final want = numbers[i];
        if (want == null) continue;
        var have = 0;
        final open = <int>[];
        for (final j in nb[i]) {
          if (st[j] == lampsLamp) have++;
          if (st[j] == _unk) open.add(j);
        }
        if (have > want || have + open.length < want) {
          t?.fail((have > want ? LampsRule.failMany : LampsRule.failFew).index, premises: [i, ...nb[i]], args: [i]);
          return false;
        }
        if (open.isEmpty) continue;
        if (have == want || have + open.length == want) {
          for (final j in open) {
            st[j] = have == want ? lampsDot : lampsLamp;
            t?.fact(
              j,
              st[j],
              (have == want ? LampsRule.wallDone : LampsRule.wallNeed).index,
              premises: [i, ...nb[i]],
              args: [i],
            );
          }
          changed = true;
        }
      }
      if (changed) continue;
      for (var i = 0; i < st.length; i++) {
        if (walls[i] || lit[i]) continue;
        var source = -1, sources = 0;
        if (st[i] == _unk) {
          source = i;
          sources++;
        }
        for (final j in sight[i]) {
          if (st[j] == _unk) {
            source = j;
            sources++;
          }
        }
        if (sources == 0) {
          t?.fail(LampsRule.failDark.index, premises: [i, ...sight[i]], args: [i]);
          return false;
        }
        if (sources == 1) {
          st[source] = lampsLamp;
          t?.fact(source, lampsLamp, LampsRule.onlySource.index, premises: [i, ...sight[i]], args: [i]);
          changed = true;
          break;
        }
      }
    }
    return true;
  }

  bool solved(List<int> st) => !st.contains(_unk);

  /// Fills in [st] using logic up to [tier]; true if it gets fully determined.
  bool solve(List<int> st, int tier) {
    if (!propagate(st)) return false;
    if (tier >= 2) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != _unk) continue;
          for (final v in const [lampsLamp, lampsDot]) {
            final t = List.of(st)..[i] = v;
            if (!propagate(t)) {
              st[i] = v == lampsLamp ? lampsDot : lampsLamp;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return solved(st);
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t)) return 0;
    final i = t.indexOf(_unk);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [lampsLamp, lampsDot]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[i] = v, limit: limit - total);
    }
    return total;
  }
}
