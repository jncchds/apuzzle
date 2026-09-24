import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('format and parse round-trip for every type, size and difficulty', () {
    for (final type in puzzleTypes) {
      for (final size in type.sizes) {
        for (final d in type.difficulties) {
          for (final seed in [0, 12345, PuzzleCode.maxSeed]) {
            final params = GenParams(size: size, difficulty: d, seed: seed);
            final parsed = PuzzleCode.parse(PuzzleCode.format(type, params), puzzleTypes);
            expect(parsed.type, same(type));
            expect(parsed.params.size, size);
            expect(parsed.params.difficulty, d);
            expect(parsed.params.seed, seed);
          }
        }
      }
    }
  });

  test('format is readable', () {
    final kings = puzzleTypeById('kings');
    final params = GenParams(size: kings.sizes.first, difficulty: Difficulty.hard, seed: 36 * 36 + 35);
    final s = kings.sizes.first;
    expect(PuzzleCode.format(kings, params), 'kings-${s.cols}x${s.rows}-hard-10Z-v1');
  });

  test('parse is lenient about case, spaces, # and a missing version', () {
    final kings = puzzleTypeById('kings');
    final s = kings.sizes.first;
    final c = PuzzleCode.parse('  KINGS ${s.cols}x${s.rows} h #10z ', puzzleTypes);
    expect(c.params.seed, 36 * 36 + 35);
    expect(c.params.difficulty, Difficulty.hard);
    expect(c.params.size, s);
  });

  test('parse rejects bad codes', () {
    final kings = puzzleTypeById('kings');
    final s = '${kings.sizes.first.cols}x${kings.sizes.first.rows}';
    for (final bad in [
      '',
      'nope-$s-hard-1-v1',
      'kings-99x99-hard-1-v1',
      'kings-$s-ultra-1-v1',
      'kings-$s-hard-!!-v1',
      'kings-$s-hard-ZZZZZZZ-v1', // above maxSeed
      'kings-$s-hard-1-v999',
    ]) {
      expect(() => PuzzleCode.parse(bad, puzzleTypes), throwsFormatException, reason: bad);
    }
  });

  test('non-square sizes keep cols×rows order', () {
    final params = GenParams(size: const GridSize(5, 7), difficulty: Difficulty.easy, seed: 1);
    expect(PuzzleCode.format(puzzleTypes.first, params), contains('-7x5-'));
  });

  test('links and share messages parse back to the code', () {
    final kings = puzzleTypeById('kings');
    final params = GenParams(size: kings.sizes.last, difficulty: Difficulty.medium, seed: 987654);
    final link = PuzzleCode.link(kings, params);
    expect(link, startsWith(PuzzleCode.linkBase));
    for (final text in [link, '/apuzzle/?p=${PuzzleCode.format(kings, params)}', 'I solved this Crowns in 1:02. Can you beat it? $link']) {
      final c = PuzzleCode.parse(text, puzzleTypes);
      expect(c.type, same(kings), reason: text);
      expect(c.params.seed, 987654, reason: text);
    }
    expect(PuzzleCode.find('https://jncchds.github.io/apuzzle/'), isNull);
  });
}
