import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'fleet_model.dart';

/// What a traced [FleetSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [fleetShip] or [fleetWater].
enum FleetRule {
  /// A shown piece goes on (ship) or ends (water) on that side. Args: the piece.
  pieceShip,
  pieceWater,

  /// A shown middle piece blocked one way runs the other way. Args: the piece.
  middle,

  /// Ships never touch diagonally. Args: the ship cell.
  diagonal,

  /// A line has all its ship cells / needs all its open cells. Args: line, count.
  lineDone,
  lineNeed,

  /// Every ship is found: the rest is water.
  allFound,

  /// A ship as long as the longest one missing ends here. Args: a cell of it, length.
  longest,

  /// A ship here would grow longer than the longest one missing. Args: length.
  tooLong,

  /// No missing ship fits through this cell.
  noFit,

  /// Every ship that fits through a ship cell covers this cell. Args: that cell.
  extend,

  /// Every place left for the one missing ship of a length covers it. Args: length.
  mustCover,

  /// The places left for the ships of a length are just enough. Args: length.
  onlySpots,
  failTouch,
  failLineMany,
  failLineFew,
  failPiece,
  failLong,
  failFleet,
  failNoRoom,
  failStray,
}

/// The logic tier a difficulty is built for: 1 pieces, counts and lengths,
/// 2 + where the missing ships still fit, 3 + probing.
int fleetTier(Difficulty d) => switch (d) {
  Difficulty.easy => 1,
  Difficulty.medium => 2,
  _ => 3,
};

const int _unk = -1;
const List<int> _sides = [sideUp, sideRight, sideDown, sideLeft];

/// A place for one ship: its cells, and the cells around it.
class _Spot {
  _Spot(this.cells, this.halo);
  final List<int> cells;
  final List<int> halo;
}

/// Cell states: -1 unknown, [fleetShip], [fleetWater].
class FleetSolver {
  FleetSolver(this.rows, this.cols, this.rowCounts, this.colCounts, this.fleet, this.pieces)
    : kn = kingNeighbors(rows, cols),
      lines = fleetLines(rows, cols) {
    for (final len in fleet) {
      want[len] = (want[len] ?? 0) + 1;
    }
    for (final len in want.keys) {
      _spots[len] = _allSpots(len);
    }
  }

  factory FleetSolver.of(FleetPuzzle p) => FleetSolver(p.rows, p.cols, p.rowCounts, p.colCounts, p.fleet, p.pieces);

  final int rows;
  final int cols;
  final List<int?> rowCounts;
  final List<int?> colCounts;
  final List<int> fleet;

  /// Shown ship pieces and their shapes ([FleetPuzzle.shapeOf]).
  final Map<int, int> pieces;
  final List<List<int>> kn;
  final List<List<int>> lines;

  /// Ships of each length.
  final Map<int, int> want = {};

  /// Every place on the board for a ship of each length.
  final Map<int, List<_Spot>> _spots = {};

  int? countOf(int line) => line < rows ? rowCounts[line] : colCounts[line - rows];

  List<_Spot> _allSpots(int len) {
    final out = <_Spot>[];
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        for (final across in len == 1 ? const [true] : const [true, false]) {
          if (across ? c + len > cols : r + len > rows) continue;
          final cells = [for (var k = 0; k < len; k++) across ? r * cols + c + k : (r + k) * cols + c];
          final inside = cells.toSet();
          final halo = {
            for (final i in cells)
              for (final j in kn[i])
                if (!inside.contains(j)) j,
          }.toList();
          out.add(_Spot(cells, halo));
        }
      }
    }
    return out;
  }

  /// The start: shown cells set from [given] (cell → value).
  List<int> start([Map<int, int> given = const {}]) {
    final st = List.filled(rows * cols, _unk);
    given.forEach((i, v) => st[i] = v);
    return st;
  }

  /// Applies the rules up to [tier] (1 or 2) until nothing changes. False on
  /// a contradiction. With [tr], every deduction is recorded (see [FleetRule]).
  bool propagate(List<int> st, int tier, [ExplainTrace? tr]) {
    List<int> known() => [
      for (var i = 0; i < st.length; i++)
        if (st[i] != _unk) i,
    ];
    var failed = false;

    // Sets [i] to [v]; a clash records [fail] and stops.
    bool put(int i, int v, FleetRule rule, List<int> premises, List<int> args) {
      if (st[i] == v) return false;
      if (st[i] != _unk) {
        tr?.fail(FleetRule.failPiece.index, premises: premises, args: args.isEmpty ? [i] : args);
        failed = true;
        return false;
      }
      st[i] = v;
      tr?.fact(i, v, rule.index, premises: premises, args: args);
      return true;
    }

    var changed = true;
    while (changed && !failed) {
      changed = false;

      // Shown pieces.
      for (final MapEntry(key: g, value: shape) in pieces.entries) {
        if (shape == pieceMiddle) {
          bool closed(int s) {
            final j = stepTo(rows, cols, g, s);
            return j < 0 || st[j] == fleetWater;
          }

          for (final (a, b, c, d) in const [
            (sideUp, sideDown, sideLeft, sideRight),
            (sideLeft, sideRight, sideUp, sideDown),
          ]) {
            if (!closed(a) && !closed(b)) continue;
            for (final s in [c, d]) {
              final j = stepTo(rows, cols, g, s);
              if (j < 0) {
                tr?.fail(FleetRule.failPiece.index, premises: [g, ...kn[g]], args: [g]);
                return false;
              }
              if (put(j, fleetShip, FleetRule.middle, [g, ...kn[g]], [g])) changed = true;
            }
          }
          if (failed) return false;
          continue;
        }
        for (final s in _sides) {
          final j = stepTo(rows, cols, g, s);
          if (j < 0) continue;
          final on = shape & s != 0;
          if (put(j, on ? fleetShip : fleetWater, on ? FleetRule.pieceShip : FleetRule.pieceWater, [g], [g])) {
            changed = true;
          }
        }
        if (failed) return false;
      }

      // Diagonals of ship cells.
      for (var i = 0; i < st.length; i++) {
        if (st[i] != fleetShip) continue;
        final r = i ~/ cols, c = i % cols;
        for (final j in kn[i]) {
          if (j ~/ cols == r || j % cols == c) continue;
          if (st[j] == fleetShip) {
            tr?.fail(FleetRule.failTouch.index, premises: [i, j], args: [i, j]);
            return false;
          }
          if (st[j] == _unk) {
            st[j] = fleetWater;
            tr?.fact(j, fleetWater, FleetRule.diagonal.index, premises: [i], args: [i]);
            changed = true;
          }
        }
      }

      // Line counts.
      for (var li = 0; li < lines.length; li++) {
        final want = countOf(li);
        if (want == null) continue;
        final cells = lines[li];
        var t = 0;
        final u = <int>[];
        for (final i in cells) {
          if (st[i] == fleetShip) t++;
          if (st[i] == _unk) u.add(i);
        }
        if (t > want || t + u.length < want) {
          tr?.fail(
            (t > want ? FleetRule.failLineMany : FleetRule.failLineFew).index,
            premises: cells,
            args: [li, want],
          );
          return false;
        }
        if (u.isEmpty || (t != want && t + u.length != want)) continue;
        for (final i in u) {
          st[i] = t == want ? fleetWater : fleetShip;
          tr?.fact(
            i,
            st[i],
            (t == want ? FleetRule.lineDone : FleetRule.lineNeed).index,
            premises: cells,
            args: [li, want],
          );
        }
        changed = true;
      }
      if (changed) continue;

      // Lengths: the ships found so far, the longest one missing.
      final missing = Map.of(want);
      final closed = closedShips(rows, cols, st);
      for (final run in closed) {
        final left = (missing[run.length] ?? 0) - 1;
        if (left < 0) {
          tr?.fail(FleetRule.failFleet.index, premises: known(), args: [run.length]);
          return false;
        }
        missing[run.length] = left;
      }
      var most = 0;
      missing.forEach((len, k) {
        if (k > 0 && len > most) most = len;
      });
      if (most == 0) {
        for (var i = 0; i < st.length; i++) {
          if (st[i] != _unk) continue;
          st[i] = fleetWater;
          tr?.fact(i, fleetWater, FleetRule.allFound.index, premises: known());
          changed = true;
        }
        continue;
      }
      final done = {for (final run in closed) ...run};
      for (final run in shipRuns(rows, cols, [for (final x in st) x == fleetShip])) {
        if (done.contains(run.first)) continue;
        if (run.length > most) {
          tr?.fail(FleetRule.failLong.index, premises: known(), args: [run.first, most]);
          return false;
        }
        if (run.length < most) continue;
        final ends = run.length == 1
            ? [for (final s in _sides) stepTo(rows, cols, run.first, s)]
            : run[1] - run[0] == 1
            ? [stepTo(rows, cols, run.first, sideLeft), stepTo(rows, cols, run.last, sideRight)]
            : [stepTo(rows, cols, run.first, sideUp), stepTo(rows, cols, run.last, sideDown)];
        for (final j in ends) {
          if (j < 0 || st[j] != _unk) continue;
          st[j] = fleetWater;
          tr?.fact(j, fleetWater, FleetRule.longest.index, premises: [...run, ...known()], args: [run.first, most]);
          changed = true;
        }
      }
      if (changed) continue;
      for (var i = 0; i < st.length; i++) {
        if (st[i] != _unk) continue;
        int reach(int side) {
          var k = 0;
          for (var j = stepTo(rows, cols, i, side); j >= 0 && st[j] == fleetShip; j = stepTo(rows, cols, j, side)) {
            k++;
          }
          return k;
        }

        final across = reach(sideLeft) + reach(sideRight), down = reach(sideUp) + reach(sideDown);
        if ((across > 0 && across + 1 > most) || (down > 0 && down + 1 > most)) {
          st[i] = fleetWater;
          tr?.fact(i, fleetWater, FleetRule.tooLong.index, premises: known(), args: [most]);
          changed = true;
        }
      }
      if (changed || tier < 2) continue;
      if (!_places(st, missing, done, tr, known)) return false;
      changed = st.contains(_unk) && _lastChange;
    }
    return !failed;
  }

  bool _lastChange = false;

  /// Where the missing ships still fit (tier 2). Sets [_lastChange].
  bool _places(
    List<int> st,
    Map<int, int> missing,
    Set<int> done,
    ExplainTrace? tr,
    List<int> Function() known,
  ) {
    _lastChange = false;
    final room = [
      for (var li = 0; li < lines.length; li++)
        if (countOf(li) case final want?) want - lines[li].where((i) => st[i] == fleetShip).length else 1 << 20,
    ];
    bool fits(_Spot s) {
      for (final i in s.cells) {
        if (st[i] == fleetWater || done.contains(i)) return false;
      }
      for (final j in s.halo) {
        if (st[j] == fleetShip) return false;
      }
      // New ship cells per line must fit its count.
      final need = <int, int>{};
      for (final i in s.cells) {
        if (st[i] != _unk) continue;
        for (final line in [i ~/ cols, rows + i % cols]) {
          final k = (need[line] ?? 0) + 1;
          if (k > room[line]) return false;
          need[line] = k;
        }
      }
      return true;
    }

    final fitting = <int, List<_Spot>>{};
    final cover = List.filled(st.length, false);
    for (final MapEntry(key: len, value: k) in missing.entries) {
      if (k == 0) continue;
      final list = [
        for (final s in _spots[len]!)
          if (fits(s)) s,
      ];
      if (list.length < k) {
        tr?.fail(FleetRule.failNoRoom.index, premises: known(), args: [len]);
        return false;
      }
      fitting[len] = list;
      for (final s in list) {
        for (final i in s.cells) {
          cover[i] = true;
        }
      }
    }
    for (var i = 0; i < st.length; i++) {
      if (st[i] == fleetShip && !cover[i] && !done.contains(i)) {
        tr?.fail(FleetRule.failStray.index, premises: known(), args: [i]);
        return false;
      }
    }
    for (var i = 0; i < st.length; i++) {
      if (st[i] == _unk && !cover[i]) {
        st[i] = fleetWater;
        tr?.fact(i, fleetWater, FleetRule.noFit.index, premises: known());
        _lastChange = true;
      }
    }
    if (_lastChange) return true;

    // A ship cell: the cells every ship through it covers.
    for (var x = 0; x < st.length; x++) {
      if (st[x] != fleetShip || done.contains(x)) continue;
      Set<int>? common;
      for (final list in fitting.values) {
        for (final s in list) {
          if (!s.cells.contains(x)) continue;
          common = common == null ? s.cells.toSet() : common.intersection(s.cells.toSet());
        }
      }
      for (final i in common ?? const <int>{}) {
        if (st[i] != _unk) continue;
        st[i] = fleetShip;
        tr?.fact(i, fleetShip, FleetRule.extend.index, premises: known(), args: [x]);
        _lastChange = true;
      }
      if (_lastChange) return true;
    }

    // A length whose places left are just enough.
    for (final MapEntry(key: len, value: list) in fitting.entries) {
      final k = missing[len]!;
      Iterable<int> cells;
      FleetRule rule;
      if (k == 1) {
        cells = list.map((s) => s.cells.toSet()).reduce((a, b) => a.intersection(b));
        rule = FleetRule.mustCover;
      } else if (list.length == k) {
        // They must all be ships, so they can't overlap or touch.
        final used = <int>{};
        for (final s in list) {
          if (s.cells.any(used.contains) || s.halo.any(used.contains)) {
            tr?.fail(FleetRule.failNoRoom.index, premises: known(), args: [len]);
            return false;
          }
          used.addAll(s.cells);
        }
        cells = used;
        rule = FleetRule.onlySpots;
      } else {
        continue;
      }
      for (final i in cells) {
        if (st[i] != _unk) continue;
        st[i] = fleetShip;
        tr?.fact(i, fleetShip, rule.index, premises: known(), args: [len]);
        _lastChange = true;
      }
      if (_lastChange) return true;
    }
    return true;
  }

  bool solved(List<int> st) => !st.contains(_unk);

  /// True if [st] gets fully determined using logic up to [tier] (3 probes).
  bool solve(List<int> st, int tier) {
    final level = tier < 2 ? 1 : 2;
    if (!propagate(st, level)) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && !solved(st)) {
        progress = false;
        for (var i = 0; i < st.length && !progress; i++) {
          if (st[i] != _unk) continue;
          for (final v in const [fleetShip, fleetWater]) {
            final t = List.of(st)..[i] = v;
            if (propagate(t, 2)) continue;
            st[i] = 1 - v;
            if (!propagate(st, 2)) return false;
            progress = true;
            break;
          }
        }
      }
    }
    return solved(st);
  }

  /// The lowest tier that solves [st] (4: none does).
  int grade(List<int> st) {
    for (var t = 1; t <= 3; t++) {
      if (solve(List.of(st), t)) return t;
    }
    return 4;
  }

  int countSolutions(List<int> st, {int limit = 2}) {
    final t = List.of(st);
    if (!propagate(t, 2)) return 0;
    final i = t.indexOf(_unk);
    if (i < 0) return 1;
    var total = 0;
    for (final v in const [fleetShip, fleetWater]) {
      if (total >= limit) break;
      total += countSolutions(List.of(t)..[i] = v, limit: limit - total);
    }
    return total;
  }
}

/// [FleetSolver.start] with the shown cells of [p].
List<int> fleetStart(FleetSolver s, FleetPuzzle p) => s.start({for (final g in p.givens) g: p.solutionAt(g)});
