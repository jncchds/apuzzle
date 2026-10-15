import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<String> found(String q) => [for (final t in searchGames(q).found) t.id];
  List<String> alt(String q) => [for (final t in searchGames(q).alternatives) t.id];

  test('words are folded: case, accents, punctuation', () {
    expect(searchWords('Sun & Moon'), ['sun', 'moon']);
    expect(searchWords('Ŝtraße—ÄÖÜ'), ['ŝtrasse', 'aou']);
    expect(searchWords('Łódź'), ['lodz']);
    expect(searchWords('  '), isEmpty);
  });

  test('names match by word prefix, case- and accent-insensitive', () {
    expect(found('sudoku'), ['sudoku', 'pockets']);
    expect(alt('killer'), ['pockets']);
    expect(found('SUD'), contains('sudoku'));
    expect(found('moon'), contains('mambo'));
    expect(found('sun moo'), ['mambo']);
    expect(found('oku'), isEmpty, reason: 'only word starts');
    expect(found(''), isEmpty);
  });

  test('name matches come first', () {
    final r = found('pearl');
    expect(r.first, 'pearls');
  });

  test('names, taglines and tags match in every language', () {
    expect(found('loop'), containsAll(['fence', 'pearls', 'arrows']));
    expect(found('tetromino'), contains('lits'));
    expect(found('петлю'), containsAll(['fence', 'pearls']));
    expect(found('schleife'), contains('fence'));
    expect(found('petle'), contains('fence'), reason: 'accents are optional');
    expect(found('latin'), contains('sudoku'));
    expect(found('острови'), ['islands']);
    expect(found('Inseln'), ['islands']);
  });

  test('other names only lead to alternatives', () {
    expect(found('nurikabe'), isEmpty);
    expect(alt('nurikabe'), ['islands']);
    expect(alt('Tentai show'), ['orbits']);
    expect(alt('galaxies'), ['orbits']);
    expect(alt('hashiwokakero'), ['atoms']);
    expect(alt('Hashi'), ['atoms']);
    expect(alt('slitherlink'), ['fence']);
    expect(alt('masyu'), ['pearls']);
    expect(alt('numberlink'), ['links']);
    expect(alt('fillomino'), ['plots']);
    expect(alt('norinori'), ['pairs']);
    expect(alt('suguru'), ['blocks']);
    expect(alt('akari'), ['lamps']);
    expect(alt('yajilin'), ['arrows']);
    expect(alt('takuzu'), ['mambo']);
    expect(alt('binairo'), ['mambo']);
    expect(alt('star battle'), ['kings']);
    expect(alt('sumplete'), ['tally']);
    expect(alt('hitori'), ['solo']);
    expect(alt('heyawake'), ['chambers']);
    expect(alt('kurodoko'), ['lookout']);
    expect(alt('tapa'), ['rampart']);
    expect(alt('dominosa'), ['domino']);
    expect(alt('bimaru'), ['fleet']);
    expect(alt('battleships'), ['fleet']);
    expect(alt('aquarium'), ['basins']);
    expect(alt('yin yang'), ['pebbles']);
    expect(alt('kakuro'), ['totals']);
    expect(found('cross sums').first, 'totals');
    expect(alt('pet detective'), ['homeward']);
    expect(alt('katamino'), ['inlay']);
    expect(alt('disconnection'), ['channel']);
    expect(alt('pentomino'), ['inlay']);
    expect(alt('pirate passage'), ['blockade']);
    expect(alt('nerdle'), ['formula']);
    expect(alt('train tracks'), ['rails']);
    expect(alt('minesweeper'), ['mines']);
    expect(alt('samegame'), ['pop']);
    expect(alt('train of thought'), ['junction']);
    expect(alt('penguin pursuit'), ['turnabout']);
  });

  List<String> similar(String q) => [for (final t in searchGames(q).similar) t.id];

  test('typos lead to similar games, only when nothing else matched', () {
    expect(similar('sudoko'), ['sudoku', 'pockets']);
    expect(similar('nurikabi'), ['islands']);
    expect(similar('slitherlnk'), ['fence']);
    expect(similar('peralrs'), contains('pearls'), reason: 'swapped letters');
    expect(similar('sudoku'), isEmpty, reason: 'found exactly');
    expect(similar('nurikabe'), isEmpty, reason: 'an alternative');
    expect(similar('pip'), isEmpty, reason: 'found by its start');
  });

  test('failing that, the closest games, also by part of a word', () {
    expect(similar('ipes'), ['pipes']);
    expect(similar('abyrint'), ['labyrinth']);
    expect(similar('udok'), ['sudoku', 'pockets']);
    for (final q in ['qwxzv', 'x', 'zzzzzzzzzzzzzzzz', 'ъ', '42']) {
      expect(similar(q), isNotEmpty, reason: q);
      expect(similar(q).length, lessThanOrEqualTo(5), reason: q);
    }
  });

  test('a family name finds all of its games', () {
    final flood = familyById('flood')!;
    expect(found('flood'), containsAll(flood.types.map((t) => t.id)));
  });
}
