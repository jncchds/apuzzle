import 'dart:math';

import '../../core/difficulty.dart';
import 'nightfall_model.dart';

/// Share of the cells a fewest-taps solution aims for.
double _tapShare(Difficulty d) => switch (d) {
  Difficulty.easy => 0.12,
  Difficulty.medium => 0.25,
  _ => 0.5,
};

/// Taps allowed beyond the fewest.
int nightfallSlack(Difficulty d) => switch (d) {
  Difficulty.easy => 4,
  Difficulty.medium => 2,
  _ => 0,
};

/// A board whose fewest taps come close to the difficulty's share of the
/// cells: random taps (each cell tapped or not on hard), the lights they
/// leave, then the fewest taps that put those out (fewer than drawn when
/// some taps cancel out). The best of a few draws by that count.
NightfallPuzzle generateNightfall({
  required int rows,
  required int cols,
  required Difficulty difficulty,
  required int seed,
  bool wrap = false,
  bool limited = true,
}) {
  final rng = Random(seed);
  final g = NightfallGeometry.of(rows, cols, wrap);
  final n = rows * cols;
  final share = _tapShare(difficulty);
  final want = max(3, (n * share).round());
  List<bool>? bestStart;
  List<bool>? bestPlan;
  for (var attempt = 0; attempt < 12; attempt++) {
    final taps = List.filled(n, false);
    if (share >= 0.5) {
      for (var i = 0; i < n; i++) {
        taps[i] = rng.nextBool();
      }
    } else {
      final order = List.generate(n, (i) => i)..shuffle(rng);
      for (final i in order.take(want)) {
        taps[i] = true;
      }
    }
    final start = nightfallLights(g, List.filled(n, false), taps);
    if (!start.contains(true)) continue;
    final plan = g.fewest(start)!;
    int count(List<bool> v) => v.where((b) => b).length;
    if (bestPlan == null || (count(plan) - want).abs() < (count(bestPlan) - want).abs()) {
      bestStart = start;
      bestPlan = plan;
    }
    if (share >= 0.5 || count(plan) == want) break;
  }
  final plan = [
    for (var i = 0; i < n; i++)
      if (bestPlan![i]) i,
  ];
  return NightfallPuzzle(
    rows: rows,
    cols: cols,
    wrap: wrap,
    start: bestStart!,
    plan: plan,
    limit: limited ? plan.length + nightfallSlack(difficulty) : null,
  );
}
