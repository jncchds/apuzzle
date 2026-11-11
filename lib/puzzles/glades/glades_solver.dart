import 'dart:math';

import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'glades_model.dart';

/// What a traced [GladesSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [gladesShade] or [gladesKeep]. Args name the area's cell (and its
/// number) or the cells a rule is about.
enum GladesRule {
  pool,
  box,
  full,
  grow,
  growNone,
  joinMix,
  joinBig,
  corner,
  isolated,
  escape,
  cut,
  rectIn,
  rectOut,
  orphan,
  failPool,
  failMix,
  failBig,
  failShape,
  failSize,
  failNoNum,
  failApart,
  failNoRect,
  failOrphan,
}

typedef _Set = void Function(int i, int v, GladesRule rule, List<int> premises, [List<int> args]);

/// Glades logic on cell states: -1 undecided, [gladesShade], [gladesKeep].
/// An area here is a group of unshaded cells joined side by side (it may
/// still grow). Tier 1: three shaded cells of a 2×2 block keep the fourth
/// (`pool`); an area fills the rectangle around it (`box`); an area with
/// its number of cells is closed by shade (`full`); an area that must grow
/// with one way out takes it (`grow`, `growNone`); a cell that would join
/// an area whose rectangle holds two numbers, too many cells or a shaded
/// cell is shaded (`joinMix`, `joinBig`, `corner`); cells the unshaded cells
/// can't reach through corners are shaded (`isolated`), and a group of them
/// with one way on takes it (`escape`). Tier 2: + cells whose shading would
/// cut the unshaded cells apart (`cut`), every rectangle a number's area
/// can be (`rectIn`, `rectOut`) and cells no number's rectangle can cover
/// (`orphan`). Tier 3: + probing.
class GladesSolver {
  GladesSolver(this.p, {this.disabled = const {}})
    : n = p.n,
      nb = orthNeighbors(p.n, p.n),
      kb = kingNeighbors(p.n, p.n) {
    cells = n * n;
    numbers = [
      for (var i = 0; i < cells; i++)
        if (p.clues[i] != null) i,
    ];
    _gid = List<int>.filled(cells, -1);
    _stamp = List<int>.filled(cells, 0);
    _mark = List<int>.filled(cells, 0);
    _cover = List<int>.filled(cells, 0);
  }

  final GladesPuzzle p;

  /// Rules left out (for tests and lesson boards).
  final Set<GladesRule> disabled;
  final int n;
  final List<List<int>> nb;
  final List<List<int>> kb;
  late final int cells;
  late final List<int> numbers;

  late final List<int> _gid;
  late final List<int> _stamp;
  late final List<int> _mark;
  late final List<int> _cover;
  var _tick = 0;
  var _markTick = 0;
  final _gCells = <List<int>>[];
  final _gNum = <int>[];
  final _gNumCell = <int>[];
  final _gExits = <List<int>>[];

  List<int> start() {
    final st = List<int>.filled(cells, -1);
    for (final c in numbers) {
      st[c] = gladesKeep;
    }
    return st;
  }

  /// Splits the unshaded cells into areas; false (and a recorded failure)
  /// when one holds two numbers.
  bool _groups(List<int> st, ExplainTrace? t) {
    _gid.fillRange(0, cells, -1);
    _gCells.clear();
    _gNum.clear();
    _gNumCell.clear();
    _gExits.clear();
    for (var s = 0; s < cells; s++) {
      if (st[s] != gladesKeep || _gid[s] >= 0) continue;
      final g = _gCells.length;
      final members = <int>[s];
      _gid[s] = g;
      var num = 0, numCell = -1;
      final exits = <int>[];
      _tick++;
      for (var k = 0; k < members.length; k++) {
        final i = members[k];
        final c = p.clues[i];
        if (c != null) {
          if (numCell < 0) {
            num = c;
            numCell = i;
          } else {
            t?.fail(GladesRule.failMix.index, premises: members, args: [numCell, i]);
            return false;
          }
        }
        for (final j in nb[i]) {
          if (st[j] == gladesKeep) {
            if (_gid[j] < 0) {
              _gid[j] = g;
              members.add(j);
            }
          } else if (st[j] == -1 && _stamp[j] != _tick) {
            _stamp[j] = _tick;
            exits.add(j);
          }
        }
      }
      _gCells.add(members);
      _gNum.add(num);
      _gNumCell.add(numCell);
      _gExits.add(exits);
    }
    return true;
  }

  /// A group is up to date while none of its exits was decided since
  /// [_groups] ran.
  bool _fresh(List<int> st, int g) => _gExits[g].every((e) => st[e] == -1);

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [GladesRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, GladesRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1 || disabled.contains(rule)) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      if (!_pools(st, set, t)) return false;
      if (changed) continue;
      if (!_groups(st, t)) return false;
      if (!_areas(st, set, t)) return false;
      if (changed) continue;
      _joins(st, set);
      if (changed) continue;
      if (!_links(st, tier >= 2, set, t)) return false;
      if (changed) continue;
      _escapes(st, set);
      if (changed) continue;
      if (tier >= 2) {
        if (!_rects(st, set, t)) return false;
      }
    }
    return true;
  }

  /// Three shaded cells of a 2×2 block keep the fourth.
  bool _pools(List<int> st, _Set set, ExplainTrace? t) {
    for (var y = 0; y + 1 < n; y++) {
      for (var x = 0; x + 1 < n; x++) {
        final i = y * n + x;
        final block = [i, i + 1, i + n, i + n + 1];
        var shaded = 0, open = -1;
        for (final j in block) {
          if (st[j] == gladesShade) {
            shaded++;
          } else if (st[j] == -1) {
            open = open == -1 ? j : -2;
          }
        }
        if (shaded == 4) {
          t?.fail(GladesRule.failPool.index, premises: block, args: [i]);
          return false;
        }
        if (shaded == 3 && open >= 0) {
          set(
            open,
            gladesKeep,
            GladesRule.pool,
            [
              for (final j in block)
                if (j != open) j,
            ],
            [i],
          );
        }
      }
    }
    return true;
  }

  bool _areas(List<int> st, _Set set, ExplainTrace? t) {
    for (var g = 0; g < _gCells.length; g++) {
      if (!_fresh(st, g)) continue;
      final members = _gCells[g], num = _gNum[g], size = members.length;
      final at = _gNumCell[g] >= 0 ? _gNumCell[g] : members.first;
      final (x0, y0, x1, y1) = gladesBox(n, members);
      final area = (x1 - x0 + 1) * (y1 - y0 + 1);
      if (num > 0 && area > num) {
        t?.fail(GladesRule.failBig.index, premises: members, args: [at, num]);
        return false;
      }
      if (area != size) {
        for (var y = y0; y <= y1; y++) {
          for (var x = x0; x <= x1; x++) {
            final i = y * n + x;
            if (st[i] == gladesShade) {
              t?.fail(GladesRule.failShape.index, premises: [...members, i], args: [at]);
              return false;
            }
            final c = p.clues[i];
            if (c != null && _gNumCell[g] >= 0 && i != _gNumCell[g]) {
              t?.fail(GladesRule.failMix.index, premises: members, args: [_gNumCell[g], i]);
              return false;
            }
          }
        }
        for (var y = y0; y <= y1; y++) {
          for (var x = x0; x <= x1; x++) {
            set(y * n + x, gladesKeep, GladesRule.box, members, [at]);
          }
        }
        return true; // the groups changed
      }
      final exits = _gExits[g];
      if (num > 0 && size == num) {
        for (final e in exits) {
          set(e, gladesShade, GladesRule.full, members, [at, num]);
        }
        continue;
      }
      if (exits.isEmpty) {
        if (num == 0) {
          t?.fail(GladesRule.failNoNum.index, premises: [for (final i in members) ...nb[i], ...members], args: [at]);
        } else {
          t?.fail(
            GladesRule.failSize.index,
            premises: [for (final i in members) ...nb[i], ...members],
            args: [at, num],
          );
        }
        return false;
      }
      if (exits.length == 1) {
        final around = [for (final i in members) ...nb[i], ...members];
        if (num > 0) {
          set(exits.first, gladesKeep, GladesRule.grow, around, [at, num]);
        } else {
          set(exits.first, gladesKeep, GladesRule.growNone, around, [at]);
        }
      }
    }
    return true;
  }

  /// An undecided cell beside unshaded areas would join them into one that
  /// fills the rectangle around them all: shaded when that rectangle holds
  /// two numbers, more cells than its number or a shaded cell.
  void _joins(List<int> st, _Set set) {
    for (var u = 0; u < cells; u++) {
      if (st[u] != -1) continue;
      final gs = <int>{
        for (final j in nb[u])
          if (st[j] == gladesKeep) _gid[j],
      };
      if (gs.isEmpty || !gs.every((g) => g >= 0 && _fresh(st, g))) continue;
      final premises = <int>[for (final g in gs) ..._gCells[g]];
      final (x0, y0, x1, y1) = gladesBox(n, [u, ...premises]);
      var numCell = -1, mixed = -1, shaded = -1;
      for (var y = y0; y <= y1; y++) {
        for (var x = x0; x <= x1; x++) {
          final i = y * n + x;
          if (st[i] == gladesShade && shaded < 0) shaded = i;
          if (p.clues[i] != null) {
            if (numCell < 0) {
              numCell = i;
            } else if (mixed < 0) {
              mixed = i;
            }
          }
        }
      }
      if (mixed >= 0) {
        set(u, gladesShade, GladesRule.joinMix, [...premises, numCell, mixed], [numCell, mixed]);
      } else if (numCell >= 0 && (x1 - x0 + 1) * (y1 - y0 + 1) > p.clues[numCell]!) {
        set(u, gladesShade, GladesRule.joinBig, [...premises, numCell], [numCell, p.clues[numCell]!]);
      } else if (shaded >= 0) {
        set(u, gladesShade, GladesRule.corner, [...premises, shaded], [shaded]);
      }
    }
  }

  /// Checks that the unshaded cells can still meet through sides and
  /// corners: cells they can't reach are shaded, and with [cut], so is no
  /// cell whose shading would part them (it stays unshaded).
  bool _links(List<int> st, bool cut, _Set set, ExplainTrace? t) {
    final root = st.indexOf(gladesKeep);
    if (root < 0) return true;
    final disc = List<int>.filled(cells, -1), low = List<int>.filled(cells, 0), sub = List<int>.filled(cells, 0);
    final forced = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == gladesKeep ? 1 : 0;
      for (final v in kb[u]) {
        if (st[v] == gladesShade) continue;
        if (disc[v] < 0) {
          dfs(v, u);
          sub[u] += sub[v];
          low[u] = min(low[u], low[v]);
          if (low[v] >= disc[u] && sub[v] > 0 && st[u] == -1) forced.add(u);
        } else if (v != parent) {
          low[u] = min(low[u], disc[v]);
        }
      }
    }

    dfs(root, -1);
    List<int> decided() => [
      for (var i = 0; i < cells; i++)
        if (st[i] != -1) i,
    ];
    for (var i = 0; i < cells; i++) {
      if (st[i] == gladesKeep && disc[i] < 0) {
        t?.fail(GladesRule.failApart.index, premises: decided(), args: [root, i]);
        return false;
      }
    }
    // A cell is forced when it parts kept cells from the root: the subtree
    // below it holds some, and so does the rest.
    final total = sub[root];
    for (var i = 0; i < cells; i++) {
      if (st[i] == -1 && disc[i] < 0) {
        set(i, gladesShade, GladesRule.isolated, t == null ? const [] : _wall(st, i), [root]);
      }
    }
    if (cut && forced.isNotEmpty && total > 1) {
      final premises = t == null ? const <int>[] : decided();
      for (final u in forced) {
        set(u, gladesKeep, GladesRule.cut, premises);
      }
    }
    return true;
  }

  /// The shaded cells around the piece of undecided cells holding [i].
  List<int> _wall(List<int> st, int i) {
    _markTick++;
    _mark[i] = _markTick;
    final queue = [i], wall = <int>[];
    for (var k = 0; k < queue.length; k++) {
      for (final j in kb[queue[k]]) {
        if (_mark[j] == _markTick) continue;
        _mark[j] = _markTick;
        if (st[j] == gladesShade) {
          wall.add(j);
        } else {
          queue.add(j);
        }
      }
    }
    return wall;
  }

  /// A piece of unshaded cells joined through sides and corners, with other
  /// unshaded cells elsewhere, that has one undecided cell to go on through
  /// takes it.
  void _escapes(List<int> st, _Set set) {
    final total = st.where((v) => v == gladesKeep).length;
    _markTick++;
    final seen = _markTick;
    for (var s = 0; s < cells; s++) {
      if (st[s] != gladesKeep || _mark[s] == seen) continue;
      _mark[s] = seen;
      final piece = [s];
      _tick++;
      var exit = -1, exits = 0;
      for (var k = 0; k < piece.length; k++) {
        for (final j in kb[piece[k]]) {
          if (st[j] == gladesKeep) {
            if (_mark[j] != seen) {
              _mark[j] = seen;
              piece.add(j);
            }
          } else if (st[j] == -1 && _stamp[j] != _tick) {
            _stamp[j] = _tick;
            exit = j;
            exits++;
          }
        }
      }
      if (exits == 1 && piece.length < total) {
        set(
          exit,
          gladesKeep,
          GladesRule.escape,
          [
            ...piece,
            for (final i in piece)
              for (final j in kb[i])
                if (st[j] == gladesShade) j,
          ],
          [piece.first],
        );
        if (st[exit] != -1) return;
      }
    }
  }

  /// Whether a w×h rectangle at (x0, y0) can be the area of the number at
  /// [c]: nothing shaded and no other number inside, nothing unshaded beside
  /// it, and shading the cells beside it leaves no all-shaded 2×2 block.
  bool _fits(List<int> st, int c, int x0, int y0, int w, int h) {
    for (var y = y0; y < y0 + h; y++) {
      for (var x = x0; x < x0 + w; x++) {
        final i = y * n + x;
        if (st[i] == gladesShade) return false;
        if (i != c && p.clues[i] != null) return false;
      }
    }
    final border = _border(x0, y0, w, h);
    _markTick++;
    for (final i in border) {
      if (st[i] == gladesKeep) return false;
      _mark[i] = _markTick;
    }
    for (final i in border) {
      final x = i % n, y = i ~/ n;
      for (final (dx, dy) in const [(-1, -1), (0, -1), (-1, 0), (0, 0)]) {
        final bx = x + dx, by = y + dy;
        if (bx < 0 || by < 0 || bx + 1 >= n || by + 1 >= n) continue;
        final b = by * n + bx;
        if ([b, b + 1, b + n, b + n + 1].every((j) => st[j] == gladesShade || _mark[j] == _markTick)) return false;
      }
    }
    return true;
  }

  List<int> _border(int x0, int y0, int w, int h) => [
    if (y0 > 0)
      for (var x = x0; x < x0 + w; x++) (y0 - 1) * n + x,
    if (y0 + h < n)
      for (var x = x0; x < x0 + w; x++) (y0 + h) * n + x,
    if (x0 > 0)
      for (var y = y0; y < y0 + h; y++) y * n + x0 - 1,
    if (x0 + w < n)
      for (var y = y0; y < y0 + h; y++) y * n + x0 + w,
  ];

  /// The decided cells near [c] that rules about its number look at.
  List<int> _near(List<int> st, int c, int reach) {
    final cx = c % n, cy = c ~/ n;
    return [
      for (var y = max(0, cy - reach); y <= cy + reach && y < n; y++)
        for (var x = max(0, cx - reach); x <= cx + reach && x < n; x++)
          if (st[y * n + x] != -1) y * n + x,
    ];
  }

  /// Every rectangle each number's area can be: none is a contradiction,
  /// cells all of them cover stay, cells beside all of them are shaded, and
  /// a cell no number's rectangle covers is shaded.
  bool _rects(List<int> st, _Set set, ExplainTrace? t) {
    _cover.fillRange(0, cells, 0);
    for (final c in numbers) {
      final num = p.clues[c]!;
      final cx = c % n, cy = c ~/ n;
      List<int>? inAll, besideAll;
      for (var h = 1; h <= num && h <= n; h++) {
        if (num % h != 0) continue;
        final w = num ~/ h;
        if (w > n) continue;
        for (var y0 = max(0, cy - h + 1); y0 <= cy && y0 + h <= n; y0++) {
          for (var x0 = max(0, cx - w + 1); x0 <= cx && x0 + w <= n; x0++) {
            if (!_fits(st, c, x0, y0, w, h)) continue;
            final inside = [
              for (var y = y0; y < y0 + h; y++)
                for (var x = x0; x < x0 + w; x++) y * n + x,
            ];
            for (final i in inside) {
              _cover[i] = 1;
            }
            final beside = _border(x0, y0, w, h);
            if (inAll == null) {
              inAll = inside;
              besideAll = beside;
            } else {
              inAll = [
                for (final i in inAll)
                  if (inside.contains(i)) i,
              ];
              besideAll = [
                for (final i in besideAll!)
                  if (beside.contains(i)) i,
              ];
            }
          }
        }
      }
      final reach = min(num, n);
      if (inAll == null) {
        t?.fail(GladesRule.failNoRect.index, premises: _near(st, c, reach), args: [c, num]);
        return false;
      }
      if (!inAll.any((i) => st[i] == -1) && !besideAll!.any((i) => st[i] == -1)) continue;
      final premises = t == null ? const <int>[] : _near(st, c, reach);
      var progress = false;
      for (final i in inAll) {
        if (st[i] == -1) {
          set(i, gladesKeep, GladesRule.rectIn, premises, [c, num]);
          progress |= st[i] != -1;
        }
      }
      for (final i in besideAll!) {
        if (st[i] == -1) {
          set(i, gladesShade, GladesRule.rectOut, premises, [c, num]);
          progress |= st[i] != -1;
        }
      }
      if (progress) return true; // the board changed: look again from tier 1
    }
    for (var i = 0; i < cells; i++) {
      if (_cover[i] != 0) continue;
      if (st[i] == gladesKeep) {
        t?.fail(GladesRule.failOrphan.index, premises: _near(st, i, 2), args: [i]);
        return false;
      }
      if (st[i] == -1) set(i, gladesShade, GladesRule.orphan, t == null ? const [] : _near(st, i, 2));
    }
    return true;
  }

  /// Solves in place with logic up to [tier]; false on a contradiction.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier.clamp(1, 2))) return false;
    if (tier >= 3) {
      var progress = true;
      while (progress && st.contains(-1)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != -1) continue;
          for (final v in const [gladesShade, gladesKeep]) {
            if (!propagate(List.of(st)..[i] = v)) {
              st[i] = 1 - v;
              if (!propagate(st)) return false;
              progress = true;
              break;
            }
          }
        }
      }
    }
    return true;
  }

  /// Cells logic up to [tier] leaves open from [st0] (all cells + 1 on a
  /// contradiction).
  int slack(int tier, [List<int>? st0]) {
    final st = st0 == null ? start() : List.of(st0);
    if (!solve(st, tier)) return st.length + 1;
    return st.where((x) => x == -1).length;
  }

  /// Lowest tier (1..3) that solves the board from [st0], or 4.
  int grade([List<int>? st0]) {
    for (var t = 1; t <= 3; t++) {
      if (slack(t, st0) == 0) return t;
    }
    return 4;
  }

  /// Number of solutions (up to [limit]), or -1 if the search gets too big.
  int countSolutions({int limit = 2, List<int>? from, int budget = 100000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st)) return;
      var i = -1;
      for (var k = 0; k < cells && i < 0; k++) {
        if (st[k] == -1 && nb[k].any((j) => st[j] != -1)) i = k;
      }
      if (i < 0) i = st.indexOf(-1);
      if (i < 0) {
        total++;
        return;
      }
      for (final v in const [gladesShade, gladesKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
