@Tags(['bench'])
library;

import 'dart:io';

import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Times every generator over sizes × difficulties × seeds.
/// Filter types with BENCH_TYPES=kings,atoms and seeds with BENCH_SEEDS=8.
void main() {
  final only = Platform.environment['BENCH_TYPES']?.split(',').toSet();
  final seeds = int.tryParse(Platform.environment['BENCH_SEEDS'] ?? '') ?? 6;
  for (final type in puzzleTypes) {
    if (only != null && !only.contains(type.id)) continue;
    test('bench ${type.id}', () {
      final lines = <String>[];
      for (final size in type.sizes) {
        for (final d in type.difficulties) {
          final ms = <int>[];
          for (var seed = 1; seed <= seeds; seed++) {
            final sw = Stopwatch()..start();
            type.generate(GenParams(size: size, difficulty: d, seed: seed * 7919));
            ms.add(sw.elapsedMilliseconds);
          }
          ms.sort();
          final mean = ms.reduce((a, b) => a + b) / ms.length;
          lines.add('${type.id.padRight(8)} ${size.label.padRight(6)} ${d.name.padRight(7)} '
              'mean ${mean.toStringAsFixed(0).padLeft(6)}ms  max ${ms.last.toString().padLeft(6)}ms');
        }
      }
      // ignore: avoid_print
      print(lines.join('\n'));
    }, timeout: const Timeout(Duration(minutes: 30)));
  }
}
