import 'dart:math';

/// Grows regions from seed cells over the rest of an n×n grid, favouring the
/// currently smallest regions so sizes stay balanced (but shapes stay organic).
/// [regions] holds seed ids (>= 0) and -1 for unassigned cells; filled in place.
void growBalancedRegions(int n, List<int> regions, Random rng, {double bias = 2.0}) {
  List<int> nb(int i) {
    final r = i ~/ n, c = i % n;
    return [if (r > 0) i - n, if (r < n - 1) i + n, if (c > 0) i - 1, if (c < n - 1) i + 1];
  }

  final count = regions.reduce(max) + 1;
  final size = List<int>.filled(count, 0);
  for (final r in regions) {
    if (r >= 0) size[r]++;
  }
  var left = regions.where((r) => r < 0).length;
  while (left > 0) {
    // Frontier cells per region.
    final frontier = List.generate(count, (_) => <int>[]);
    for (var i = 0; i < n * n; i++) {
      if (regions[i] >= 0) continue;
      for (final j in nb(i)) {
        if (regions[j] >= 0) frontier[regions[j]].add(i);
      }
    }
    final weights = [for (var k = 0; k < count; k++) frontier[k].isEmpty ? 0.0 : 1 / pow(size[k], bias)];
    var t = rng.nextDouble() * weights.fold(0.0, (a, b) => a + b);
    var pick = 0;
    for (var k = 0; k < count; k++) {
      t -= weights[k];
      if (t <= 0 && weights[k] > 0) {
        pick = k;
        break;
      }
      if (weights[k] > 0) pick = k;
    }
    final cell = frontier[pick][rng.nextInt(frontier[pick].length)];
    regions[cell] = pick;
    size[pick]++;
    left--;
  }
}
