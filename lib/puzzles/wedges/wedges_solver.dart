import '../../core/explain.dart';
import 'wedges_model.dart';

/// What a traced [WedgesSolver.propagate] records ([Fact.rule]). Placing
/// rules ([done], [last]) record the value placed, the others the value
/// ruled out ([Fact.value]); [point], [pair] and [ring] rule out all the
/// values one look at a cell's surroundings does in one fact, with their mask
/// as the last arg.
///
/// Args: [point] and [failPoint] the point; [done], [need], [ring],
/// [failClue] and [failRing] the wall; [pair] and [failPair] the two points;
/// [failEmpty] the cell.
enum WedgesRule { point, done, need, last, pair, ring, failEmpty, failPoint, failClue, failPair, failRing }

/// Every value of an open cell: the four wedges and no wedge.
const int wedgesOpenMask = 0x1F;
const int _wallBit = 1 << wedgeWall;
const int _dotBit = 1 << wedgeDot;
const int _wedgeBits = 0x0F;

/// The values in each 6-bit mask.
final List<List<int>> _bitsOf = [
  for (var m = 0; m < 64; m++)
    [
      for (var v = 0; v < 6; v++)
        if (m & (1 << v) != 0) v,
    ],
];

bool _single(int m) => m != 0 && m & (m - 1) == 0;
int _valueOf(int m) => m.bitLength - 1;

bool _ok(int a, int b, int c, int d) => wedgesPointTable[((a * 6 + b) * 6 + c) * 6 + d] == 1;

/// Solver for "wedges in open cells, every open area a rectangle (upright or
/// turned 45°), numbers count the wedges beside their wall", on candidate
/// masks per cell (bit v: value v; walls hold [wedgeWall] only).
///
/// Every open area is a rectangle exactly when at every lattice point the
/// open sectors round it come in runs of 90° or 180° (or all 360°), so the
/// rules are all about points:
///  1. every value of a cell is checked against the cells round each of its
///     corners (`point`: some way to fill the other three cells keeps the
///     point fine), numbers with all their wedges leave the other cells
///     beside them open (`done`), numbers needing every cell left fill them
///     (`need`);
///  2. + two points along one side read together (they share the two cells
///     on either side of it: `pair`), and every way to fill the cells round
///     a numbered wall that meets its number with all four of its corners
///     fine (`ring`);
///  3. + probing (assume a value, run tier 1, reject on a contradiction).
class WedgesSolver {
  WedgesSolver(this.p, {this.disabled = const {}}) {
    final g = p.geo;
    for (var i = 0; i < g.cells; i++) {
      if (p.clues[i] >= 0) clued.add(i);
    }
    for (var r = 0; r <= g.rows; r++) {
      for (var c = 0; c <= g.cols; c++) {
        final k = r * g.w + c;
        // Along a horizontal side: the cells above and below it.
        if (c < g.cols) segments.add((k, k + 1));
        // Along a vertical side: the cells left and right of it.
        if (r < g.rows) segments.add((k, k + g.w));
      }
    }
  }

  final WedgesPuzzle p;

  /// Rules left out, for tests and lesson checks ([WedgesRule.pair],
  /// [WedgesRule.ring]).
  final Set<WedgesRule> disabled;

  /// Walls with a number.
  final List<int> clued = [];

  /// Neighbouring points (one cell side apart).
  final List<(int, int)> segments = [];

  /// Walls fixed, givens settled, every other cell open to anything.
  List<int> start() => [
    for (var i = 0; i < p.rows * p.cols; i++)
      if (p.isWall(i)) _wallBit else if (p.givens.contains(i)) 1 << p.solution[i] else wedgesOpenMask,
  ];

  /// The values if logic up to [tier] solves the board, else null.
  List<int>? solveLogic(int tier) {
    final st = start();
    if (!propagate(st, tier)) return null;
    if (!st.every(_single)) return null;
    return [for (final m in st) _valueOf(m)];
  }

  /// Candidates logic up to [tier] leaves beyond one per cell (0 = solved).
  int slack(int tier) {
    final st = start();
    if (!propagate(st, tier)) return 1 << 28;
    var n = 0;
    for (final m in st) {
      n += _bitsOf[m].length - 1;
    }
    return n;
  }

  /// Hardest tier needed (1..3), or 4 when guessing is required.
  int grade() {
    for (var t = 1; t <= 3; t++) {
      if (solveLogic(t) != null) return t;
    }
    return 4;
  }

  /// Logic up to [tier] (1..3) in place; false on a contradiction. With [t],
  /// every deduction is recorded (see [WedgesRule]).
  bool propagate(List<int> st, int tier, [ExplainTrace? t]) {
    final g = p.geo;
    final dirty = List<bool>.filled(g.points, true);
    final queue = [for (var k = 0; k < g.points; k++) k];
    var changed = false;

    int maskAt(int i) => i < 0 ? _wallBit : st[i];

    void touch(int i) {
      changed = true;
      for (final k in g.cellPoints[i]) {
        if (!dirty[k]) {
          dirty[k] = true;
          queue.add(k);
        }
      }
    }

    // Rules [v] out of [i]; false when nothing is left.
    bool remove(int i, int v, WedgesRule rule, List<int> premises, List<int> args) {
      final bit = 1 << v;
      if (st[i] & bit == 0) return true;
      st[i] &= ~bit;
      touch(i);
      if (t != null) {
        t.fact(i, v, rule.index, premises: premises, args: args);
        if (_single(st[i])) t.fact(i, _valueOf(st[i]), WedgesRule.last.index, premises: [i]);
        if (st[i] == 0) t.fail(WedgesRule.failEmpty.index, premises: [i], args: [i]);
      }
      return st[i] != 0;
    }

    // Leaves only the bits of [keep] in [i]; false when nothing is left. Recorded
    // in one fact (its value the lowest one ruled out, the mask of them all
    // appended to its args).
    bool keepOnly(int i, int keep, WedgesRule rule, List<int> premises, List<int> args) {
      final gone = st[i] & ~keep;
      if (gone == 0) return true;
      st[i] &= keep;
      touch(i);
      if (t != null) {
        t.fact(i, _bitsOf[gone].first, rule.index, premises: premises, args: [...args, gone]);
        if (_single(st[i])) t.fact(i, _valueOf(st[i]), WedgesRule.last.index, premises: [i]);
        if (st[i] == 0) t.fail(WedgesRule.failEmpty.index, premises: [i], args: [i]);
      }
      return st[i] != 0;
    }

    // Settles [i] to [v] in one fact.
    bool place(int i, int v, WedgesRule rule, List<int> premises, List<int> args) {
      final bit = 1 << v;
      if (st[i] == bit) return true;
      if (st[i] & bit == 0) {
        t?.fail(WedgesRule.failEmpty.index, premises: [i, ...premises], args: [i]);
        return false;
      }
      st[i] = bit;
      touch(i);
      t?.fact(i, v, rule.index, premises: premises, args: args);
      return true;
    }

    List<int> others(List<int> cells, [int skip = -1]) => [
      for (final i in cells)
        if (i >= 0 && i != skip) i,
    ];

    // Every value of the cells round point [k] against the others.
    bool point(int k) {
      final cs = g.pointCells[k];
      final m0 = maskAt(cs[0]), m1 = maskAt(cs[1]), m2 = maskAt(cs[2]), m3 = maskAt(cs[3]);
      var s0 = 0, s1 = 0, s2 = 0, s3 = 0;
      for (final a in _bitsOf[m0]) {
        for (final b in _bitsOf[m1]) {
          for (final c in _bitsOf[m2]) {
            for (final d in _bitsOf[m3]) {
              if (!_ok(a, b, c, d)) continue;
              s0 |= 1 << a;
              s1 |= 1 << b;
              s2 |= 1 << c;
              s3 |= 1 << d;
            }
          }
        }
      }
      if (s0 == 0) {
        t?.fail(WedgesRule.failPoint.index, premises: others(cs), args: [k]);
        return false;
      }
      final sup = [s0, s1, s2, s3];
      for (var j = 0; j < 4; j++) {
        final i = cs[j];
        if (i < 0 || st[i] & ~sup[j] == 0) continue;
        if (!keepOnly(i, sup[j], WedgesRule.point, t == null ? const [] : others(cs, i), [k])) return false;
      }
      return true;
    }

    while (true) {
      changed = false;
      // Numbers: done, or needing every cell left.
      for (final w in clued) {
        final want = p.clues[w];
        var sure = 0, may = 0;
        for (final j in g.sides[w]) {
          if (st[j] & _wedgeBits != 0) may++;
          if (st[j] & _dotBit == 0 && st[j] & _wedgeBits != 0) sure++;
        }
        if (sure > want || may < want) {
          t?.fail(WedgesRule.failClue.index, premises: g.sides[w], args: [w]);
          return false;
        }
        if (sure != want && may != want) continue;
        final known = t == null
            ? const <int>[]
            : [
                for (final j in g.sides[w])
                  if (st[j] & _dotBit == 0 || st[j] & _wedgeBits == 0) j,
              ];
        for (final j in g.sides[w]) {
          final m = st[j];
          if (m & _dotBit == 0 || m & _wedgeBits == 0) continue;
          if (sure == want) {
            if (!place(j, wedgeDot, WedgesRule.done, known, [w])) return false;
          } else if (!remove(j, wedgeDot, WedgesRule.need, known, [w])) {
            return false;
          }
        }
      }
      // Points, first in first out: deductions come in waves, so their
      // stories stay short.
      for (var q = 0; q < queue.length; q++) {
        final k = queue[q];
        dirty[k] = false;
        if (!point(k)) return false;
      }
      queue.clear();
      if (changed) continue;
      if (tier < 2) return true;

      if (!disabled.contains(WedgesRule.pair)) {
        for (final (a, b) in segments) {
          if (_pair(st, a, b, keepOnly, t) == null) return false;
          if (changed) break;
        }
        if (changed) continue;
      }
      if (!disabled.contains(WedgesRule.ring)) {
        for (final w in clued) {
          if (_ring(st, w, keepOnly, t) == null) return false;
          if (changed) break;
        }
        if (changed) continue;
      }
      if (tier < 3) return true;

      // Probing.
      for (var i = 0; i < st.length && !changed; i++) {
        final m = st[i];
        if (_single(m)) continue;
        for (final v in _bitsOf[m]) {
          final w = List.of(st)..[i] = 1 << v;
          if (!propagate(w, 1)) {
            if (!remove(i, v, WedgesRule.pair, const [], const [])) return false;
            break;
          }
        }
      }
      if (!changed) return true;
    }
  }

  /// Points [a] and [b], one side apart, read together: false for no
  /// progress, true for some, null on a contradiction.
  bool? _pair(
    List<int> st,
    int a,
    int b,
    bool Function(int, int, WedgesRule, List<int>, List<int>) keepOnly,
    ExplainTrace? t,
  ) {
    final g = p.geo;
    final ca = g.pointCells[a], cb = g.pointCells[b];
    // The shared cells, by position in each point.
    final shared = [
      for (final i in ca)
        if (i >= 0 && cb.contains(i)) i,
    ];
    if (shared.isEmpty) return false;
    int maskAt(int i) => i < 0 ? _wallBit : st[i];
    if (shared.every((i) => _single(st[i]))) return false;
    final x = shared[0], y = shared.length > 1 ? shared[1] : -1;
    final mx = maskAt(x), my = maskAt(y);
    final supA = [0, 0, 0, 0], supB = [0, 0, 0, 0];
    var sx = 0, sy = 0;

    // The values of the other cells of point [cs] with x = vx and y = vy
    // that keep it fine, added to [sup] (when [into]); whether there are any.
    bool fits(List<int> cs, int vx, int vy, List<int>? sup) {
      final opts = [
        for (final i in cs)
          i == x
              ? [vx]
              : i == y && y >= 0
              ? [vy]
              : _bitsOf[maskAt(i)],
      ];
      var any = false;
      for (final v0 in opts[0]) {
        for (final v1 in opts[1]) {
          for (final v2 in opts[2]) {
            for (final v3 in opts[3]) {
              if (!_ok(v0, v1, v2, v3)) continue;
              if (sup == null) return true;
              any = true;
              sup[0] |= 1 << v0;
              sup[1] |= 1 << v1;
              sup[2] |= 1 << v2;
              sup[3] |= 1 << v3;
            }
          }
        }
      }
      return any;
    }

    for (final vx in _bitsOf[mx]) {
      for (final vy in _bitsOf[my]) {
        if (!fits(ca, vx, vy, null) || !fits(cb, vx, vy, null)) continue;
        sx |= 1 << vx;
        sy |= 1 << vy;
        fits(ca, vx, vy, supA);
        fits(cb, vx, vy, supB);
      }
    }
    final premises = t == null
        ? const <int>[]
        : {
            for (final i in ca)
              if (i >= 0) i,
            for (final i in cb)
              if (i >= 0) i,
          }.toList();
    if (sx == 0) {
      t?.fail(WedgesRule.failPair.index, premises: premises, args: [a, b]);
      return null;
    }
    var progress = false;
    bool cut(int i, int sup) {
      if (i < 0 || st[i] & ~sup == 0) return true;
      progress = true;
      return keepOnly(
        i,
        sup,
        WedgesRule.pair,
        [
          for (final j in premises)
            if (j != i) j,
        ],
        [a, b],
      );
    }

    if (!cut(x, sx) || !cut(y, sy)) return null;
    for (var j = 0; j < 4; j++) {
      if (!shared.contains(ca[j]) && !cut(ca[j], supA[j])) return null;
      if (!shared.contains(cb[j]) && !cut(cb[j], supB[j])) return null;
    }
    return progress;
  }

  /// Every way to fill the cells beside numbered wall [w] that meets its
  /// number with its four corners fine: false for no progress, true for
  /// some, null on a contradiction.
  bool? _ring(
    List<int> st,
    int w,
    bool Function(int, int, WedgesRule, List<int>, List<int>) keepOnly,
    ExplainTrace? t,
  ) {
    final g = p.geo;
    final r = w ~/ g.cols, c = w % g.cols;
    int at(int rr, int cc) => rr >= 0 && rr < g.rows && cc >= 0 && cc < g.cols ? rr * g.cols + cc : -1;
    // Beside: N, E, S, W; diagonal: NW, NE, SE, SW.
    final side = [at(r - 1, c), at(r, c + 1), at(r + 1, c), at(r, c - 1)];
    final diag = [at(r - 1, c - 1), at(r - 1, c + 1), at(r + 1, c + 1), at(r + 1, c - 1)];
    int maskAt(int i) => i < 0 ? _wallBit : st[i];
    final ring = [...side, ...diag];
    if (ring.every((i) => i < 0 || _single(st[i]))) return false;
    final want = p.clues[w];
    const wall = wedgeWall;
    final supS = [0, 0, 0, 0], supD = [0, 0, 0, 0];
    final dOpts = [for (final i in diag) _bitsOf[maskAt(i)]];
    final dSup = [0, 0, 0, 0];
    // The diagonal values that keep corner [j] fine, given the sides.
    int corner(int j, int n, int e, int s, int wv) {
      var m = 0;
      for (final d in dOpts[j]) {
        final ok = switch (j) {
          0 => _ok(d, n, wall, wv),
          1 => _ok(n, d, e, wall),
          2 => _ok(wall, e, d, s),
          _ => _ok(wv, wall, s, d),
        };
        if (ok) m |= 1 << d;
      }
      return m;
    }

    for (final n in _bitsOf[maskAt(side[0])]) {
      for (final e in _bitsOf[maskAt(side[1])]) {
        for (final s in _bitsOf[maskAt(side[2])]) {
          for (final wv in _bitsOf[maskAt(side[3])]) {
            if ([n, e, s, wv].where(isWedge).length != want) continue;
            var fine = true;
            for (var j = 0; j < 4 && fine; j++) {
              dSup[j] = corner(j, n, e, s, wv);
              fine = dSup[j] != 0;
            }
            if (!fine) continue;
            supS[0] |= 1 << n;
            supS[1] |= 1 << e;
            supS[2] |= 1 << s;
            supS[3] |= 1 << wv;
            for (var j = 0; j < 4; j++) {
              supD[j] |= dSup[j];
            }
          }
        }
      }
    }
    final premises = t == null
        ? const <int>[]
        : [
            for (final i in ring)
              if (i >= 0) i,
          ];
    if (supS[0] == 0) {
      t?.fail(WedgesRule.failRing.index, premises: premises, args: [w]);
      return null;
    }
    var progress = false;
    bool cut(int i, int sup) {
      if (i < 0 || st[i] & ~sup == 0) return true;
      progress = true;
      return keepOnly(
        i,
        sup,
        WedgesRule.ring,
        [
          for (final j in premises)
            if (j != i) j,
        ],
        [w],
      );
    }

    for (var j = 0; j < 4; j++) {
      if (!cut(side[j], supS[j]) || !cut(diag[j], supD[j])) return null;
    }
    return progress;
  }

  /// Up to [limit] solutions, each as the value per cell.
  List<List<int>> solutions({int limit = 2}) {
    final out = <List<int>>[];
    void rec(List<int> st) {
      if (out.length >= limit) return;
      if (!propagate(st, 1)) return;
      var best = -1, bestN = 99;
      for (var i = 0; i < st.length; i++) {
        final n = _bitsOf[st[i]].length;
        if (n > 1 && n < bestN) {
          best = i;
          bestN = n;
        }
      }
      if (best < 0) {
        out.add([for (final m in st) _valueOf(m)]);
        return;
      }
      for (final v in _bitsOf[st[best]]) {
        rec(List.of(st)..[best] = 1 << v);
      }
    }

    rec(start());
    return out;
  }

  /// Number of solutions, up to [limit].
  int countSolutions({int limit = 2}) => solutions(limit: limit).length;
}
