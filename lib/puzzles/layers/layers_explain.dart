import '../../core/explain.dart';
import '../../core/value_grid.dart';
import '../../core/value_grid_explain.dart';
import 'layers_model.dart';
import 'layers_solver.dart';

final _solvers = Expando<LayersSolver>();

/// Explains Layers with [LayersSolver]: shared colors, order read from
/// cells and rectangles, then hidden colors and chains, then probing. The
/// knowledge is the solver's flat list: cell masks, line masks, then the
/// order facts (never shown on the board).
class LayersExplainer extends MaskGridExplainer<LayersPuzzle> {
  const LayersExplainer();

  LayersSolver _solver(LayersPuzzle p) => _solvers[p] ??= LayersSolver(p);

  @override
  int get levels => 3;

  @override
  bool probes(int level) => level == 3;

  @override
  int get lastCandidateRule => LayersRule.only.index;

  @override
  Set<int> get placingRules => const {};

  @override
  int? placed(LayersPuzzle p, Fact f) => f.rule >= 0 && f.slot < p.cells && f.value >= 0 ? f.value : null;

  @override
  ValueGrid? move(LayersPuzzle p, ValueGrid s, Fact f) => f.slot >= p.cells ? null : super.move(p, s, f);

  @override
  List<int> seed(LayersPuzzle p, ValueGrid s) => _solver(p).start(knownValues(p, s));

  @override
  bool propagate(LayersPuzzle p, List<int> k, int level, ExplainTrace? t) =>
      _solver(p).propagate(k, level.clamp(1, 2), t);

  /// Facts that narrow a cell without settling it go without saying.
  @override
  bool quiet(LayersPuzzle p, Fact f) => f.rule == LayersRule.options.index && f.value < 0;

  /// Painting a cell first, then what only adds to the story.
  @override
  int rank(LayersPuzzle p, Fact f) => f.slot < p.cells ? 0 : 1;

  @override
  ExplainLine? describe(LayersPuzzle p, Fact f) {
    final size = p.size;
    final n = p.cells;
    final isCell = f.slot >= 0 && f.slot < n;
    final isLine = f.slot >= n && f.slot < n + p.lines;
    final at = isCell ? cellTok(size.pos(f.slot)) : '';
    final me = {if (isCell) size.pos(f.slot)};
    final value = valTok(f.value);
    String line(int l) => l < p.rows ? rowTok(l) : colTok(l - p.rows);
    String kind(int l) => l < p.rows ? 'row' : 'col';
    final cells = {
      ...me,
      for (final i in f.premises)
        if (i < n) size.pos(i),
    };

    switch (f.rule) {
      case ruleAssume:
        if (isLine) {
          final l = f.slot - n;
          return ExplainLine((x) => x.exLayersSupposeLine(line(l), kind(l), value));
        }
        return ExplainLine((x) => x.exSuppose(at, value), me);
      case ruleRefuted:
        if (isLine) {
          final l = f.slot - n;
          return ExplainLine((x) => x.exLayersRefutedLine(line(l), kind(l), value));
        }
        return ExplainLine((x) => x.exRefuted(at, value), me);
    }
    final a = f.args;
    switch (LayersRule.values[f.rule]) {
      case LayersRule.same:
        return ExplainLine((x) => x.exLayersSame(at, value, rowTok(a[0]), colTok(a[1] - p.rows)), me);
      case LayersRule.options:
        if (f.value < 0) return null;
        final (r, c) = p.linesOf(f.slot);
        return ExplainLine((x) => x.exLayersOptions(at, value, rowTok(r), colTok(c - p.rows)), me);
      case LayersRule.seen:
        final i = a[0];
        return ExplainLine(
          (x) => x.exLayersSeen(cellTok(size.pos(i)), line(a[1]), kind(a[1]), line(a[2]), kind(a[2])),
          {size.pos(i)},
        );
      case LayersRule.later:
        return ExplainLine((x) => x.exLayersLater(at, value, line(a[0]), kind(a[0]), line(a[1]), kind(a[1])), me);
      case LayersRule.lineColor:
        final cell = cellTok(size.pos(a[0]));
        if (f.value < 0) return null;
        return ExplainLine(
          (x) => x.exLayersLineColor(line(a[1]), kind(a[1]), value, cell, line(a[2]), kind(a[2])),
          {size.pos(a[0])},
        );
      case LayersRule.rectangle:
        return ExplainLine(
          (x) => x.exLayersRectangle(at, value, line(a[0]), kind(a[0]), line(a[1]), line(a[2]), line(a[3])),
          cells,
        );
      case LayersRule.chain:
        return ExplainLine(
          (x) => x.exLayersChain(line(a[0]), kind(a[0]), line(a[1]), kind(a[1]), line(a[2]), kind(a[2])),
        );
      case LayersRule.only:
        if (isLine) {
          final l = f.slot - n;
          return ExplainLine((x) => x.exLayersOnlyLine(line(l), kind(l), value));
        }
        return ExplainLine((x) => x.exLayersOnly(at, value), me);
      case LayersRule.failEmpty:
        return ExplainLine((x) => x.exLayersFailEmpty(cellTok(size.pos(a[0]))), {size.pos(a[0])});
      case LayersRule.failLine:
        return ExplainLine((x) => x.exLayersFailLine(line(a[0]), kind(a[0])));
      case LayersRule.failCycle:
        return ExplainLine((x) => x.exLayersFailCycle(line(a[0]), kind(a[0]), line(a[1]), kind(a[1])));
    }
  }
}
