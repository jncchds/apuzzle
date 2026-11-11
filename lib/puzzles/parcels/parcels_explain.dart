import '../../core/explain.dart';
import '../../core/grid.dart';
import '../../core/lattice_loop.dart';
import '../../core/loop_explain.dart';
import 'parcels_model.dart';
import 'parcels_solver.dart';

final _solvers = Expando<ParcelsSolver>();

ParcelsSolver parcelsSolver(ParcelsPuzzle p) => _solvers[p] ??= ParcelsSolver(p);

/// Explains a board with [ParcelsSolver]: the knowledge is one entry per
/// lattice edge (-1 open, 0 no border, 1 border). Borders are shown before
/// crosses, and a cross inside a region the borders already close off goes
/// without saying.
class ParcelsExplainer extends Explainer<ParcelsPuzzle, LoopMarks, List<int>> {
  const ParcelsExplainer();

  @override
  GridSize size(ParcelsPuzzle p) => p.size;

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  List<int> seed(ParcelsPuzzle p, LoopMarks s) {
    final st = parcelsSolver(p).start();
    final sol = p.borders;
    for (final e in p.geo.inner) {
      if (s.marks[e] == 1 && sol[e]) st[e] = 1;
      if (s.marks[e] == 2 && !sol[e]) st[e] = 0;
    }
    return st;
  }

  @override
  List<int> copy(List<int> k) => List.of(k);

  @override
  bool propagate(ParcelsPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      parcelsSolver(p).propagate(k, level < 2 ? level : 2, t);

  @override
  Iterable<(int, int)> probeCandidates(ParcelsPuzzle p, List<int> k) sync* {
    for (var e = 0; e < k.length; e++) {
      if (k[e] == -1) {
        yield (e, 1);
        yield (e, 0);
      }
    }
  }

  @override
  void assume(ParcelsPuzzle p, List<int> k, int slot, int value, ExplainTrace? t) {
    k[slot] = value;
    t?.fact(slot, value, ruleAssume);
  }

  @override
  void refute(ParcelsPuzzle p, List<int> k, int slot, int value, ExplainTrace t) => k[slot] = 1 - value;

  /// The edge state [f] leaves (1 border, 0 none), or null.
  int? edgeValue(Fact f) => f.slot < 0 || f.rule == ruleAssume ? null : (f.rule == ruleRefuted ? 1 - f.value : f.value);

  /// Whether the borders on the board already close off a region of k cells
  /// holding both cells of edge [e].
  bool _closed(ParcelsPuzzle p, LoopMarks s, int e) {
    final geo = p.geo;
    final (of, groups) = geo.groups((x) => s.marks[x] == 1);
    final (a, b) = geo.cellsOf[e];
    return of[a] == of[b] && groups[of[a]].length == p.k;
  }

  @override
  LoopMarks? move(ParcelsPuzzle p, LoopMarks s, Fact f) {
    final v = edgeValue(f);
    if (v == null || p.geo.isOutline(f.slot)) return null;
    final mark = v == 1 ? 1 : 2;
    if (s.marks[f.slot] == mark || (v == 0 && _closed(p, s, f.slot))) return null;
    return LoopMarks(List.of(s.marks)..[f.slot] = mark);
  }

  @override
  int rank(ParcelsPuzzle p, Fact f) => edgeValue(f) == 1 ? 0 : 1;

  @override
  Set<Pos> targets(ParcelsPuzzle p, Fact f) => cornerEdgeCells(p.lattice, p.rows, p.cols, f.slot);

  @override
  Set<int> targetEdges(ParcelsPuzzle p, Fact f) => {f.slot};

  @override
  (Pos, LoopMarks)? wrongEntry(ParcelsPuzzle p, LoopMarks s) {
    final sol = p.borders;
    for (final e in p.geo.inner) {
      if ((s.marks[e] == 1 && !sol[e]) || (s.marks[e] == 2 && sol[e])) {
        return (_cells(p, e).first, LoopMarks(List.of(s.marks)..[e] = 0));
      }
    }
    return null;
  }

  @override
  (Pos, LoopMarks)? reveal(ParcelsPuzzle p, LoopMarks s) {
    final sol = p.borders;
    for (final e in p.geo.inner) {
      if (sol[e] && s.marks[e] != 1) return (_cells(p, e).first, LoopMarks(List.of(s.marks)..[e] = 1));
    }
    return null;
  }

  @override
  bool done(ParcelsPuzzle p, LoopMarks s) {
    final sol = p.borders;
    for (final e in p.geo.inner) {
      if ((s.marks[e] == 1) != sol[e]) return false;
    }
    return true;
  }

  /// The four cells around lattice point [pt] (inside the board).
  Set<Pos> _around(ParcelsPuzzle p, int pt) {
    final r = pt ~/ (p.cols + 1), c = pt % (p.cols + 1);
    return {Pos(r - 1, c - 1), Pos(r - 1, c), Pos(r, c - 1), Pos(r, c)};
  }

  Set<Pos> _cells(ParcelsPuzzle p, int e) => cornerEdgeCells(p.lattice, p.rows, p.cols, e);

  @override
  ExplainLine? describe(ParcelsPuzzle p, Fact f) {
    final g = p.lattice;
    final at = f.slot >= 0 ? cornerEdgeTok(g, p.rows, p.cols, f.slot) : '';
    final here = f.slot >= 0 ? _cells(p, f.slot) : <Pos>{};
    final border = f.value == 1;
    switch (f.rule) {
      case ruleAssume:
        return ExplainLine((l) => border ? l.exParcelsSupposeBorder(at) : l.exParcelsSupposeOpen(at), here);
      case ruleRefuted:
        return ExplainLine((l) => border ? l.exParcelsRefutedBorder(at) : l.exParcelsRefutedOpen(at), here);
    }
    Pos cell(int i) => p.size.pos(i);
    final k = p.k;
    final piece = [
      for (final i in f.args.takeWhile((x) => x >= 0)) cell(i),
    ];
    return switch (ParcelsRule.values[f.rule]) {
      ParcelsRule.clueDone => ExplainLine(
        (l) => l.exParcelsClueDone(at, cellTok(cell(f.args[0])), p.clues[f.args[0]]!),
        {...here, cell(f.args[0])},
      ),
      ParcelsRule.clueNeed => ExplainLine(
        (l) => l.exParcelsClueNeed(at, cellTok(cell(f.args[0])), p.clues[f.args[0]]!),
        {...here, cell(f.args[0])},
      ),
      ParcelsRule.samePiece => ExplainLine(
        (l) => l.exParcelsSamePiece(at, cellTok(cell(f.args[0])), cellTok(cell(f.args[1]))),
        here,
      ),
      ParcelsRule.pieceFull => ExplainLine((l) => l.exParcelsPieceFull(at, cellsTok(piece), k), {...here, ...piece}),
      ParcelsRule.goOn => ExplainLine(
        (l) => l.exParcelsGoOn(at, cornerEdgeTok(g, p.rows, p.cols, f.args[1])),
        {...here, ..._around(p, f.args[0])},
      ),
      ParcelsRule.noEnd => ExplainLine((l) => l.exParcelsNoEnd(at), {...here, ..._around(p, f.args[0])}),
      ParcelsRule.failEnd => ExplainLine(
        (l) => l.exParcelsFailEnd(cellsTok(_around(p, f.args[0]))),
        _around(p, f.args[0]),
      ),
      ParcelsRule.tooBig => () {
        final a = [for (final i in f.args.skip(1).takeWhile((x) => x >= 0)) cell(i)];
        final b = [for (final i in f.args.skip(2 + a.length)) cell(i)];
        return ExplainLine(
          (l) => l.exParcelsTooBig(at, cellsTok(a), cellsTok(b), f.args[0], k),
          {...here, ...a, ...b},
        );
      }(),
      ParcelsRule.oneWayOut => ExplainLine((l) => l.exParcelsOneWayOut(at, cellsTok(piece), k), {...here, ...piece}),
      ParcelsRule.everyWay => ExplainLine(
        (l) => border
            ? l.exParcelsEveryWayBorder(at, cellsTok(piece), k)
            : l.exParcelsEveryWayOpen(at, cellsTok(piece), k),
        {...here, ...piece},
      ),
      ParcelsRule.failClue => ExplainLine((l) => l.exParcelsFailClue(cellTok(cell(f.args[0]))), {cell(f.args[0])}),
      ParcelsRule.failBig => ExplainLine((l) => l.exParcelsFailBig(cellsTok(piece), k), piece.toSet()),
      ParcelsRule.failInside => ExplainLine(
        (l) => l.exParcelsFailInside(cellTok(cell(f.args[0])), cellTok(cell(f.args[1]))),
        {cell(f.args[0]), cell(f.args[1])},
      ),
      ParcelsRule.failArea => ExplainLine(
        (l) => l.exParcelsFailArea(cellTok(cell(f.args[1])), f.args[0], k),
        {for (final i in f.args.skip(1)) cell(i)},
      ),
      ParcelsRule.failNoWay => ExplainLine((l) => l.exParcelsFailNoWay(cellsTok(piece), k), piece.toSet()),
    };
  }
}
