import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'slabs_model.dart';

/// What a traced [SlabsSolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [slabsShade] or [slabsKeep]. Args name the area's cell (and its
/// number) or the cells a rule is about.
enum SlabsRule {
  box,
  full,
  grow,
  growRect,
  joinBig,
  joinMix,
  corner,
  small,
  noRect,
  rectIn,
  rectOut,
  reach,
  reachAll,
  failMix,
  failBig,
  failSize,
  failShape,
  failRect,
  failNoRect,
  failReach,
}

typedef _Set = void Function(int i, int v, SlabsRule rule, List<int> premises, [List<int> args]);

/// Slabs logic on cell states: -1 undecided, [slabsShade], [slabsKeep].
/// An area here is a group of decided cells of one shade joined side by
/// side (it may still grow). Tier 1: a shaded area fills the rectangle
/// round it (`box`); an area with all its cells has its other neighbours
/// in the other shade (`full`); an area that must grow and has one way out
/// takes it (`grow`, and `growRect` for an unshaded rectangle); a cell
/// that would join areas into one too big, with two numbers, or a shaded
/// shape whose rectangle takes in an unshaded cell gets the other shade
/// (`joinBig`, `joinMix`, `corner`); a 1 or a 2 is shaded (`small`).
/// Tier 2: + every rectangle a number's shaded area can be (`noRect`,
/// `rectIn`, `rectOut`) and the cells an unshaded number's area can reach
/// (`reach`, `reachAll`). Tier 3: + probing.
class SlabsSolver {
  SlabsSolver(this.p) : n = p.n, nb = orthNeighbors(p.n, p.n) {
    cells = n * n;
    numbers = [
      for (var i = 0; i < cells; i++)
        if (p.clues[i] != null) i,
    ];
    _gid = List<int>.filled(cells, -1);
    _stamp = List<int>.filled(cells, 0);
    _dist = List<int>.filled(cells, -1);
  }

  final SlabsPuzzle p;
  final int n;
  final List<List<int>> nb;
  late final int cells;
  late final List<int> numbers;

  late final List<int> _gid;
  late final List<int> _stamp;
  late final List<int> _dist;
  var _tick = 0;
  final _gCells = <List<int>>[];
  final _gColor = <int>[];
  final _gNum = <int>[];
  final _gNumCell = <int>[];
  final _gExits = <List<int>>[];

  List<int> start() => List<int>.filled(cells, -1);

  /// Splits the decided cells into areas; false (and a recorded failure)
  /// when one holds two different numbers.
  bool _groups(List<int> st, ExplainTrace? t) {
    _gid.fillRange(0, cells, -1);
    _gCells.clear();
    _gColor.clear();
    _gNum.clear();
    _gNumCell.clear();
    _gExits.clear();
    for (var s = 0; s < cells; s++) {
      if (st[s] == -1 || _gid[s] >= 0) continue;
      final g = _gCells.length, color = st[s];
      final members = <int>[s];
      _gid[s] = g;
      var num = 0, numCell = -1;
      final exits = <int>[];
      _tick++;
      for (var k = 0; k < members.length; k++) {
        final i = members[k];
        final c = p.clues[i];
        if (c != null) {
          if (num == 0) {
            num = c;
            numCell = i;
          } else if (c != num) {
            t?.fail(SlabsRule.failMix.index, premises: members, args: [numCell, i]);
            return false;
          }
        }
        for (final j in nb[i]) {
          if (st[j] == color) {
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
      // A clue met after the group grew past the first one is checked above.
      _gCells.add(members);
      _gColor.add(color);
      _gNum.add(num);
      _gNumCell.add(numCell);
      _gExits.add(exits);
    }
    return true;
  }

  /// A group is up to date while none of its exits was decided since
  /// [_groups] ran.
  bool _fresh(List<int> st, int g) => _gExits[g].every((e) => st[e] == -1);

  /// The bounding box of [cells] as (x0, y0, x1, y1).
  (int, int, int, int) _box(Iterable<int> members) {
    var x0 = n, y0 = n, x1 = -1, y1 = -1;
    for (final i in members) {
      final x = i % n, y = i ~/ n;
      if (x < x0) x0 = x;
      if (x > x1) x1 = x;
      if (y < y0) y0 = y;
      if (y > y1) y1 = y;
    }
    return (x0, y0, x1, y1);
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [SlabsRule]).
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t]) {
    var changed = true;
    void set(int i, int v, SlabsRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      for (final c in numbers) {
        if (p.clues[c]! <= 2) set(c, slabsShade, SlabsRule.small, const [], [p.clues[c]!]);
      }
      if (!_groups(st, t)) return false;
      if (!_areas(st, set, t)) return false;
      if (changed) continue;
      if (!_joins(st, set)) return false;
      if (changed) continue;
      if (tier >= 2) {
        for (final c in numbers) {
          if (!_rects(st, c, set, t)) return false;
          if (changed) break;
          if (!_reach(st, c, set, t)) return false;
          if (changed) break;
        }
      }
    }
    return true;
  }

  bool _areas(List<int> st, _Set set, ExplainTrace? t) {
    for (var g = 0; g < _gCells.length; g++) {
      if (!_fresh(st, g)) continue;
      final members = _gCells[g], color = _gColor[g], num = _gNum[g], size = members.length;
      final at = members.first;
      if (num > 0 && size > num) {
        t?.fail(SlabsRule.failBig.index, premises: members, args: [_gNumCell[g], num]);
        return false;
      }
      if (color == slabsShade) {
        final (x0, y0, x1, y1) = _box(members);
        if ((x1 - x0 + 1) * (y1 - y0 + 1) != size) {
          for (var y = y0; y <= y1; y++) {
            for (var x = x0; x <= x1; x++) {
              final i = y * n + x;
              if (st[i] == slabsKeep) {
                t?.fail(SlabsRule.failShape.index, premises: [...members, i], args: [at]);
                return false;
              }
            }
          }
          for (var y = y0; y <= y1; y++) {
            for (var x = x0; x <= x1; x++) {
              set(y * n + x, slabsShade, SlabsRule.box, members, [at]);
            }
          }
          return true; // the groups changed
        }
      }
      final exits = _gExits[g];
      if (exits.isEmpty) {
        if (num > 0 && size != num) {
          t?.fail(SlabsRule.failSize.index, premises: members, args: [_gNumCell[g], num]);
          return false;
        }
        if (color == slabsKeep && slabsIsRect(n, members)) {
          t?.fail(SlabsRule.failRect.index, premises: [for (final i in members) ...nb[i], ...members], args: [at]);
          return false;
        }
        continue;
      }
      if (num > 0 && size == num) {
        for (final e in exits) {
          set(e, 1 - color, SlabsRule.full, members, [_gNumCell[g], num]);
        }
      } else if (exits.length == 1) {
        final around = [for (final i in members) ...nb[i], ...members];
        if (num > 0) {
          set(exits.first, color, SlabsRule.grow, around, [_gNumCell[g], num]);
        } else if (color == slabsKeep && slabsIsRect(n, members)) {
          set(exits.first, color, SlabsRule.growRect, around, [at]);
        }
      }
    }
    return true;
  }

  /// An undecided cell can't take a shade that would join its neighbours'
  /// areas into one with two numbers, more cells than its number, or (when
  /// shaded) a rectangle round it that takes in an unshaded cell.
  bool _joins(List<int> st, _Set set) {
    for (var u = 0; u < cells; u++) {
      if (st[u] != -1) continue;
      for (final c in const [slabsShade, slabsKeep]) {
        if (st[u] != -1) break;
        final gs = <int>{
          for (final j in nb[u])
            if (st[j] == c) _gid[j],
        };
        if (!gs.every((g) => g >= 0 && _fresh(st, g))) continue;
        var size = 1, num = p.clues[u] ?? 0, numCell = num > 0 ? u : -1;
        final premises = <int>[];
        int? mixed;
        for (final g in gs) {
          size += _gCells[g].length;
          premises.addAll(_gCells[g]);
          final gn = _gNum[g];
          if (gn == 0) continue;
          if (num == 0) {
            num = gn;
            numCell = _gNumCell[g];
          } else if (gn != num) {
            mixed = _gNumCell[g];
          }
        }
        if (mixed != null) {
          set(u, 1 - c, SlabsRule.joinMix, premises, [numCell, mixed]);
        } else if (num > 0 && size > num) {
          set(u, 1 - c, SlabsRule.joinBig, premises, [numCell, num]);
        } else if (c == slabsShade && gs.isNotEmpty) {
          final (x0, y0, x1, y1) = _box([u, ...premises]);
          search:
          for (var y = y0; y <= y1; y++) {
            for (var x = x0; x <= x1; x++) {
              final i = y * n + x;
              if (st[i] == slabsKeep) {
                set(u, slabsKeep, SlabsRule.corner, [...premises, i], [i]);
                break search;
              }
            }
          }
        }
      }
    }
    return true;
  }

  /// The decided cells near [c] that rules about its number look at.
  List<int> _near(List<int> st, int c, int reach) {
    final cx = c % n, cy = c ~/ n;
    return [
      for (var y = cy - reach < 0 ? 0 : cy - reach; y <= cy + reach && y < n; y++)
        for (var x = cx - reach < 0 ? 0 : cx - reach; x <= cx + reach && x < n; x++)
          if (st[y * n + x] != -1) y * n + x,
    ];
  }

  /// Every rectangle of the right size the shaded area of number [c] can
  /// be: none → [c] stays unshaded; once [c] is shaded, cells every one
  /// covers are shaded and cells beside every one stay.
  bool _rects(List<int> st, int c, _Set set, ExplainTrace? t) {
    if (st[c] == slabsKeep) return true;
    final num = p.clues[c]!;
    final cx = c % n, cy = c ~/ n;
    List<int>? inAll, besideAll;
    for (var h = 1; h <= num && h <= n; h++) {
      if (num % h != 0) continue;
      final w = num ~/ h;
      if (w > n) continue;
      for (var y0 = cy - h + 1; y0 <= cy; y0++) {
        if (y0 < 0 || y0 + h > n) continue;
        for (var x0 = cx - w + 1; x0 <= cx; x0++) {
          if (x0 < 0 || x0 + w > n) continue;
          if (!_fits(st, num, x0, y0, w, h)) continue;
          final inside = [
            for (var y = y0; y < y0 + h; y++)
              for (var x = x0; x < x0 + w; x++) y * n + x,
          ];
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
    final reach = num > n ? n : num;
    if (inAll == null) {
      if (st[c] == slabsShade) {
        t?.fail(SlabsRule.failNoRect.index, premises: _near(st, c, reach), args: [c, num]);
        return false;
      }
      set(c, slabsKeep, SlabsRule.noRect, _near(st, c, reach), [num]);
      return true;
    }
    if (st[c] != slabsShade) return true;
    if (!inAll.any((i) => st[i] == -1) && !besideAll!.any((i) => st[i] == -1)) return true;
    final premises = t == null ? const <int>[] : _near(st, c, reach);
    for (final i in inAll) {
      set(i, slabsShade, SlabsRule.rectIn, premises, [c, num]);
    }
    for (final i in besideAll!) {
      set(i, slabsKeep, SlabsRule.rectOut, premises, [c, num]);
    }
    return true;
  }

  bool _fits(List<int> st, int num, int x0, int y0, int w, int h) {
    for (var y = y0; y < y0 + h; y++) {
      for (var x = x0; x < x0 + w; x++) {
        final i = y * n + x;
        if (st[i] == slabsKeep) return false;
        final c = p.clues[i];
        if (c != null && c != num) return false;
      }
    }
    for (final i in _border(x0, y0, w, h)) {
      if (st[i] == slabsShade) return false;
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

  /// The cells an unshaded area of number [c] can reach: within as many
  /// steps as it still needs cells, never through shaded cells or cells
  /// with another number. Too few → [c] is shaded; just enough → they all
  /// stay.
  bool _reach(List<int> st, int c, _Set set, ExplainTrace? t) {
    if (st[c] == slabsShade) return true;
    final num = p.clues[c]!;
    final group = st[c] == slabsKeep ? _gCells[_gid[c]] : [c];
    if (st[c] == slabsKeep && !_fresh(st, _gid[c])) return true;
    if (group.length >= num) return true;
    _dist.fillRange(0, cells, -1);
    final queue = <int>[];
    for (final i in group) {
      _dist[i] = 0;
      queue.add(i);
    }
    final limit = num - group.length;
    bool blocked(int j) {
      if (st[j] == slabsShade) return true;
      final cl = p.clues[j];
      if (cl != null && cl != num) return true;
      if (st[j] == slabsKeep) {
        final gn = _gNum[_gid[j]];
        if (gn != 0 && gn != num) return true;
      }
      return false;
    }

    for (var k = 0; k < queue.length; k++) {
      final i = queue[k];
      if (_dist[i] >= limit) continue;
      for (final j in nb[i]) {
        if (_dist[j] >= 0 || blocked(j)) continue;
        _dist[j] = _dist[i] + 1;
        queue.add(j);
      }
    }
    if (queue.length > num) return true;
    final premises = t == null
        ? const <int>[]
        : [
            ...group,
            for (final i in queue)
              for (final j in nb[i])
                if (_dist[j] < 0 && st[j] != -1) j,
          ];
    if (queue.length < num) {
      if (st[c] == slabsKeep) {
        t?.fail(SlabsRule.failReach.index, premises: premises, args: [c, num]);
        return false;
      }
      set(c, slabsShade, SlabsRule.reach, premises, [num]);
      return true;
    }
    if (st[c] != slabsKeep) return true;
    for (final i in queue) {
      set(i, slabsKeep, SlabsRule.reachAll, premises, [c, num]);
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
          for (final v in const [slabsShade, slabsKeep]) {
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
      for (final v in const [slabsShade, slabsKeep]) {
        rec(List.of(st)..[i] = v);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
