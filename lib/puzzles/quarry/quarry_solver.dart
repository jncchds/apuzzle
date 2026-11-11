import '../../core/explain.dart';
import '../../core/grid_graph.dart';
import 'quarry_model.dart';

/// What a traced [QuarrySolver.propagate] records ([Fact.rule]); [Fact.value]
/// is [quarryShade] or [quarryKeep]. Args name the stone (its index in
/// [QuarryPuzzle.pieces]) and the cells a rule is about.
enum QuarryRule {
  /// Every place the stone still fits covers the cell. Args: stone.
  fits,

  /// Every place the stone still fits touches the cell. Args: stone.
  beside,

  /// Only the stone can cover the shaded cell `a`, and every such place
  /// covers the cell. Args: stone, a.
  only,

  /// As [only], every such place touches the cell. Args: stone, a.
  onlyBeside,

  /// No stone fits over the cell.
  orphan,

  /// The cell is walled off from the kept cell `a`. Args: a.
  isolated,

  /// The cell is the last way out for the kept cells at `a`. Args: a.
  walled,

  /// Shading the cell would cut the cells left apart.
  cut,

  /// Every place the stone fits that leaves room for every other stone
  /// covers the cell. Args: stone.
  room,

  /// As [room], every such place touches the cell. Args: stone.
  roomBeside,

  /// Fail: the stone fits nowhere. Args: stone.
  failNoRoom,

  /// Fail: no stone fits over the shaded cell `a`. Args: a.
  failNoPiece,

  /// Fail: the kept cells `a` and `b` are cut apart. Args: a, b.
  failApart,
}

typedef _Set = void Function(int i, int v, QuarryRule rule, List<int> premises, [List<int> args]);

/// Bits per mask word: web-safe (JS bitwise operations are 32-bit).
const _bits = 30;

/// Quarry logic on cell states (-1 undecided, [quarryShade], [quarryKeep])
/// over every placement of every stone. A placement is still possible while
/// none of its cells stays and none of the cells around it is shaded.
///
/// Tier 1: a shaded cell only one stone can reach ties that stone to it
/// (`only`); cells every possible place of a stone covers are shaded and
/// cells beside all of them stay (`fits`, `beside`); cells no stone fits
/// over stay (`orphan`); cells walled off from the kept cells are shaded
/// (`isolated`), and kept cells with one way out take it (`walled`).
/// Tier 2: + cells whose shading would cut the kept cells apart stay
/// (`cut`), and places of a stone that leave another stone no room are out
/// (`room`, `roomBeside`). Tier 3: + probing.
class QuarrySolver {
  QuarrySolver(this.p, {this.disabled = const {}}) : n = p.n, nb = orthNeighbors(p.n, p.n) {
    cells = n * n;
    words = (cells + _bits - 1) ~/ _bits;
    pieceCount = p.pieces.length;
    final cover = List.generate(cells, (_) => <int>[]);
    for (var k = 0; k < pieceCount; k++) {
      final mine = <int>[];
      for (final o in quarryOrientations(quarryShapes[p.pieces[k]].cells)) {
        final (h, w) = quarryExtent(o);
        for (var r0 = 0; r0 + h <= n; r0++) {
          for (var c0 = 0; c0 + w <= n; c0++) {
            final q = pPiece.length;
            final cs = [for (final (r, c) in o) (r0 + r) * n + c0 + c];
            final inside = cs.toSet();
            final border = <int>{
              for (final i in cs)
                for (final j in nb[i])
                  if (!inside.contains(j)) j,
            }.toList();
            pPiece.add(k);
            pCells.add(cs);
            pBorder.add(border);
            for (var w = 0; w < words; w++) {
              cellMask.add(0);
              closedMask.add(0);
            }
            for (final i in cs) {
              cellMask[q * words + i ~/ _bits] |= 1 << (i % _bits);
              closedMask[q * words + i ~/ _bits] |= 1 << (i % _bits);
              cover[i].add(q);
            }
            for (final i in border) {
              closedMask[q * words + i ~/ _bits] |= 1 << (i % _bits);
            }
            mine.add(q);
          }
        }
      }
      byPiece.add(mine);
    }
    covering = cover;
    _witness = List<int>.filled(pPiece.length * pieceCount, -1);
    _inUse = List<int>.filled(pPiece.length, 0);
    _roomDead = List<bool>.filled(pPiece.length, false);
    _cnt = List<int>.filled(cells, 0);
    _cntB = List<int>.filled(cells, 0);
    _stamp = List<int>.filled(cells, 0);
  }

  final QuarryPuzzle p;

  /// Rules left out (for tests and lesson boards).
  final Set<QuarryRule> disabled;
  final int n;
  final List<List<int>> nb;
  late final int cells;
  late final int words;
  late final int pieceCount;

  /// Every placement: its stone, cells and the cells around it.
  final pPiece = <int>[];
  final pCells = <List<int>>[];
  final pBorder = <List<int>>[];
  final cellMask = <int>[];
  final closedMask = <int>[];

  /// Placements of each stone.
  final byPiece = <List<int>>[];

  /// Placements covering each cell.
  late final List<List<int>> covering;

  late final List<int> _witness;
  late final List<int> _inUse;
  late final List<bool> _roomDead;
  late final List<int> _cnt;
  late final List<int> _cntB;
  late final List<int> _stamp;
  var _useTick = 0;
  var _tick = 0;

  /// The placements each stone may still take after the last [propagate].
  List<List<int>> use = const [];

  /// The placements of each stone the cells still allow, after the last
  /// [propagate].
  List<List<int>> alive = const [];

  List<int> start() => [for (final c in p.clues) c ?? -1];

  bool _ok(List<int> st, int q) {
    for (final i in pCells[q]) {
      if (st[i] == quarryKeep) return false;
    }
    for (final i in pBorder[q]) {
      if (st[i] == quarryShade) return false;
    }
    return true;
  }

  /// A decided cell that rules placement [q] out, or -1.
  int _blocker(List<int> st, int q) {
    for (final i in pCells[q]) {
      if (st[i] == quarryKeep) return i;
    }
    for (final i in pBorder[q]) {
      if (st[i] == quarryShade) return i;
    }
    return -1;
  }

  bool _covers(int q, int i) => cellMask[q * words + i ~/ _bits] & (1 << (i % _bits)) != 0;

  /// Whether placements [a] and [b] can both be taken: apart, not touching.
  bool _compatible(int a, int b) {
    final x = a * words, y = b * words;
    for (var w = 0; w < words; w++) {
      if (cellMask[x + w] & closedMask[y + w] != 0) return false;
    }
    return true;
  }

  /// Applies logic up to [tier] (1 or 2) in place; false on a contradiction.
  /// With [t], every deduction is recorded (see [QuarryRule]).
  ///
  /// [from] (placements per stone, from [alive] after an earlier call on a
  /// state this one extends) saves rebuilding them.
  bool propagate(List<int> st, [int tier = 2, ExplainTrace? t, List<List<int>>? from]) {
    final alive = [for (final b in from ?? byPiece) List.of(b)];
    this.alive = alive;
    _roomDead.fillRange(0, _roomDead.length, false);
    final roomed = List<bool>.filled(pieceCount, false);
    var changed = true;
    void set(int i, int v, QuarryRule rule, List<int> premises, [List<int> args = const []]) {
      if (st[i] != -1 || disabled.contains(rule)) return;
      st[i] = v;
      changed = true;
      t?.fact(i, v, rule.index, premises: premises, args: args);
    }

    while (changed) {
      changed = false;
      for (final a in alive) {
        a.removeWhere((q) => !_ok(st, q));
      }
      if (!_pieces(st, alive, roomed, set, t)) return false;
      if (changed) continue;
      if (!_connect(st, set, t)) return false;
      if (changed) continue;
      if (tier >= 2) {
        if (!disabled.contains(QuarryRule.cut)) {
          _cut(st, set);
          if (changed) continue;
        }
        if (!disabled.contains(QuarryRule.room) && _room(roomed)) changed = true;
      }
    }
    return true;
  }

  /// Claims, then what every place of a stone shares, then cells no stone
  /// reaches. Sets [use].
  bool _pieces(List<int> st, List<List<int>> alive, List<bool> roomed, _Set set, ExplainTrace? t) {
    final u = [
      for (final a in alive)
        [
          for (final q in a)
            if (!_roomDead[q]) q,
        ],
    ];
    use = u;
    final claim = List<int>.filled(pieceCount, -1);
    final cov = List<int>.filled(cells, 0);
    final shaded = [
      for (var i = 0; i < cells; i++)
        if (st[i] == quarryShade) i,
    ];
    var progress = true;
    while (progress) {
      progress = false;
      cov.fillRange(0, cells, 0);
      for (var k = 0; k < pieceCount; k++) {
        if (u[k].isEmpty) {
          t?.fail(QuarryRule.failNoRoom.index, premises: _blockers(st, byPiece[k]), args: [k]);
          return false;
        }
        for (final q in u[k]) {
          for (final i in pCells[q]) {
            cov[i] |= 1 << k;
          }
        }
      }
      for (final s in shaded) {
        final m = cov[s];
        if (m == 0) {
          t?.fail(QuarryRule.failNoPiece.index, premises: _blockers(st, covering[s]), args: [s]);
          return false;
        }
        if (m & (m - 1) != 0) continue;
        final k = _bit(m);
        if (disabled.contains(QuarryRule.only)) continue;
        final before = u[k].length;
        u[k].removeWhere((q) => !_covers(q, s));
        if (u[k].length != before) {
          progress = true;
          if (claim[k] < 0) claim[k] = s;
        }
      }
    }

    for (var k = 0; k < pieceCount; k++) {
      final list = u[k];
      _tick++;
      for (final q in list) {
        for (final i in pCells[q]) {
          if (_stamp[i] != _tick) {
            _stamp[i] = _tick;
            _cnt[i] = 0;
            _cntB[i] = 0;
          }
          _cnt[i]++;
        }
        for (final i in pBorder[q]) {
          if (_stamp[i] != _tick) {
            _stamp[i] = _tick;
            _cnt[i] = 0;
            _cntB[i] = 0;
          }
          _cntB[i]++;
        }
      }
      final q0 = list.first;
      final inAll = [
        for (final i in pCells[q0])
          if (st[i] == -1 && _cnt[i] == list.length) i,
      ];
      final besideAll = [
        for (final i in pBorder[q0])
          if (st[i] == -1 && _cntB[i] == list.length) i,
      ];
      if (inAll.isEmpty && besideAll.isEmpty) continue;
      final (inRule, outRule) = roomed[k]
          ? (QuarryRule.room, QuarryRule.roomBeside)
          : claim[k] >= 0
          ? (QuarryRule.only, QuarryRule.onlyBeside)
          : (QuarryRule.fits, QuarryRule.beside);
      final premises = t == null ? const <int>[] : [..._blockers(st, byPiece[k]), if (claim[k] >= 0) claim[k]];
      final args = [k, if (claim[k] >= 0 && !roomed[k]) claim[k]];
      for (final i in inAll) {
        set(i, quarryShade, inRule, premises, args);
      }
      for (final i in besideAll) {
        set(i, quarryKeep, outRule, premises, args);
      }
    }

    for (var i = 0; i < cells; i++) {
      if (st[i] != -1 || cov[i] != 0) continue;
      set(i, quarryKeep, QuarryRule.orphan, t == null ? const [] : _blockers(st, covering[i]));
    }
    return true;
  }

  static int _bit(int m) {
    var k = 0;
    while (m > 1) {
      m >>= 1;
      k++;
    }
    return k;
  }

  /// One decided cell per placement of [qs] that rules it out.
  List<int> _blockers(List<int> st, List<int> qs) {
    final out = <int>{};
    for (final q in qs) {
      final b = _blocker(st, q);
      if (b >= 0) out.add(b);
    }
    return out.toList();
  }

  /// The cells left (not shaded) must form one area.
  bool _connect(List<int> st, _Set set, ExplainTrace? t) {
    final comps = components(nb, (i) => st[i] != quarryShade);
    final withKeep = <List<int>>[];
    for (final c in comps) {
      if (c.any((i) => st[i] == quarryKeep)) withKeep.add(c);
    }
    if (withKeep.isEmpty) return true;
    List<int> wall(List<int> area) => {
      for (final i in area)
        for (final j in nb[i])
          if (st[j] == quarryShade) j,
    }.toList();
    if (withKeep.length > 1) {
      final a = withKeep[0].firstWhere((i) => st[i] == quarryKeep);
      final b = withKeep[1].firstWhere((i) => st[i] == quarryKeep);
      t?.fail(QuarryRule.failApart.index, premises: [...wall(withKeep[0]), a, b], args: [a, b]);
      return false;
    }
    final main = withKeep.first;
    final anchor = main.firstWhere((i) => st[i] == quarryKeep);
    for (final c in comps) {
      if (identical(c, main)) continue;
      final premises = t == null ? const <int>[] : [...wall(c), anchor];
      for (final i in c) {
        set(i, quarryShade, QuarryRule.isolated, premises, [anchor]);
      }
    }
    // Groups of kept cells with one way out, while kept cells lie elsewhere.
    final keeps = main.where((i) => st[i] == quarryKeep).length;
    for (final g in components(nb, (i) => st[i] == quarryKeep)) {
      if (g.length == keeps) break;
      final exits = <int>{
        for (final i in g)
          for (final j in nb[i])
            if (st[j] == -1) j,
      };
      if (exits.length != 1 || disabled.contains(QuarryRule.walled)) continue;
      set(exits.first, quarryKeep, QuarryRule.walled, t == null ? const [] : [...g, ...wall(g)], [g.first]);
      return true; // the groups changed
    }
    return true;
  }

  /// Cells whose shading would cut kept cells apart stay (articulation
  /// points of the cells not shaded, by one DFS from a kept cell).
  void _cut(List<int> st, _Set set) {
    final root = st.indexOf(quarryKeep);
    if (root < 0) return;
    final disc = List<int>.filled(cells, -1);
    final low = List<int>.filled(cells, 0);
    final sub = List<int>.filled(cells, 0);
    final total = st.where((v) => v == quarryKeep).length;
    final found = <int>[];
    var time = 0;
    void dfs(int u, int parent) {
      disc[u] = low[u] = time++;
      sub[u] = st[u] == quarryKeep ? 1 : 0;
      var cutsOff = false;
      for (final v in nb[u]) {
        if (st[v] == quarryShade) continue;
        if (disc[v] < 0) {
          dfs(v, u);
          sub[u] += sub[v];
          if (low[v] < low[u]) low[u] = low[v];
          if (low[v] >= disc[u] && sub[v] > 0) cutsOff = true;
        } else if (v != parent && disc[v] < low[u]) {
          low[u] = disc[v];
        }
      }
      if (u != root && st[u] == -1 && cutsOff) found.add(u);
    }

    dfs(root, -1);
    for (final u in found) {
      // A child part with kept cells hangs on u, and the root side keeps the
      // root itself, so shading u splits them.
      if (total > 0) set(u, quarryKeep, QuarryRule.cut, _near(st, u));
    }
  }

  /// Shaded cells around [u] (two steps in any direction).
  List<int> _near(List<int> st, int u) {
    final ux = u % n, uy = u ~/ n;
    return [
      for (var y = uy - 2; y <= uy + 2; y++)
        for (var x = ux - 2; x <= ux + 2; x++)
          if (x >= 0 && y >= 0 && x < n && y < n && st[y * n + x] == quarryShade) y * n + x,
    ];
  }

  /// Places of a stone that leave another stone no room are out; true when
  /// any went.
  bool _room(List<bool> roomed) {
    _useTick++;
    for (final list in use) {
      for (final q in list) {
        _inUse[q] = _useTick;
      }
    }
    var any = false;
    for (var k = 0; k < pieceCount; k++) {
      for (final q in use[k]) {
        if (_roomDead[q]) continue;
        for (var j = 0; j < pieceCount; j++) {
          if (j == k) continue;
          final w = _witness[q * pieceCount + j];
          if (w >= 0 && _inUse[w] == _useTick && !_roomDead[w] && _compatible(q, w)) continue;
          var ok = false;
          for (final r in use[j]) {
            if (!_roomDead[r] && _compatible(q, r)) {
              _witness[q * pieceCount + j] = r;
              ok = true;
              break;
            }
          }
          if (!ok) {
            _roomDead[q] = true;
            roomed[k] = true;
            any = true;
            break;
          }
        }
      }
    }
    return any;
  }

  /// Solves in place with logic up to [tier]; false on a contradiction.
  /// Probing (tier 3) tries both values of each open cell with tier 1.
  bool solve(List<int> st, int tier) {
    if (!propagate(st, tier.clamp(1, 2))) return false;
    if (tier >= 3) {
      var base = alive;
      var progress = true;
      while (progress && st.contains(-1)) {
        progress = false;
        for (var i = 0; i < st.length; i++) {
          if (st[i] != -1) continue;
          for (final v in const [quarryShade, quarryKeep]) {
            if (!propagate(List.of(st)..[i] = v, 1, null, base)) {
              st[i] = 1 - v;
              if (!propagate(st, 2, null, base)) return false;
              base = alive;
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
  /// Branches on the places of the stone with the fewest left.
  int countSolutions({int limit = 2, List<int>? from, int budget = 20000}) {
    var nodes = 0, total = 0;
    void rec(List<int> st, [List<List<int>>? from0]) {
      if (total >= limit || ++nodes > budget) return;
      if (!propagate(st, 1, null, from0)) return;
      final mine = alive;
      if (!st.contains(-1)) {
        total++;
        return;
      }
      var best = -1;
      for (var k = 0; k < pieceCount; k++) {
        if (use[k].length > 1 && (best < 0 || use[k].length < use[best].length)) best = k;
      }
      if (best < 0) {
        final i = st.indexOf(-1);
        for (final v in const [quarryShade, quarryKeep]) {
          rec(List.of(st)..[i] = v, mine);
        }
        return;
      }
      for (final q in List.of(use[best])) {
        final next = List.of(st);
        for (final i in pCells[q]) {
          next[i] = quarryShade;
        }
        for (final i in pBorder[q]) {
          next[i] = quarryKeep;
        }
        rec(next, mine);
      }
    }

    rec(from == null ? start() : List.of(from));
    return nodes > budget ? -1 : total;
  }
}
