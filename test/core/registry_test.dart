import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/search.dart';
import 'package:apuzzle/ui/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every game is in exactly one family of one category', () {
    final grouped = [for (final c in puzzleCategories) ...c.types.map((t) => t.id)];
    expect(grouped.toSet().length, grouped.length);
    expect(grouped.toSet(), puzzleTypes.map((t) => t.id).toSet());
    expect(puzzleCategories.map((c) => c.id).toSet().length, puzzleCategories.length);
    final families = [for (final c in puzzleCategories) ...c.families];
    expect(families.map((f) => f.id).toSet().length, families.length);
    for (final f in families) {
      expect(f.types, isNotEmpty, reason: f.id);
      if (f.single) expect(f.id, f.types.single.id, reason: 'a family of one is named after its game');
    }
  });

  test('every game has search tags, and aliases name real games', () {
    for (final t in puzzleTypes) {
      expect(gameTags[t.id], isNotEmpty, reason: t.id);
    }
    final ids = puzzleTypes.map((t) => t.id).toSet();
    expect(ids.containsAll(gameTags.keys), isTrue);
    expect(ids.containsAll(gameAliases.keys), isTrue);
  });

  group('routes', () {
    AppRoute parse(String s) => AppRoute.parse(Uri.parse(s));

    test('categories, families and search round-trip', () {
      for (final c in puzzleCategories) {
        final r = parse('/c/${c.id}');
        expect(r.category, same(c));
        expect(r.uri.toString(), '/c/${c.id}');
        for (final f in c.families.where((f) => !f.single)) {
          final r = parse('/f/${f.id}');
          expect(r.family, same(f));
          expect(r.category, same(c));
          expect(r.uri.toString(), '/f/${f.id}');
        }
      }
      expect(parse('/?q=tents').query, 'tents');
      expect(parse('/?q=tents').uri.toString(), '/?q=tents');
    });

    test('a family of one shows its category', () {
      final r = parse('/f/islands');
      expect(r.family, isNull);
      expect(r.category?.id, 'grids');
    });

    test('a game keeps the page it was opened on', () {
      final code = 'kings-8x8-hard-4FZ8K1-v1';
      final r = parse('/c/grids?p=$code');
      expect(r.category?.id, 'grids');
      expect(r.game.toString(), code);
      expect(r.uri.toString(), '/c/grids?p=$code');
      expect(parse('/f/flood?p=$code').family?.id, 'flood');
      expect(parse('/?q=crown&p=$code').query, 'crown');
      expect(parse('/apuzzle/?p=$code').game.toString(), code);
    });

    test('settings and unknown pages', () {
      expect(parse('/settings').settings, isTrue);
      expect(parse('/c/nothing').category, isNull);
    });
  });
}
