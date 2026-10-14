import '../l10n/app_localizations.dart';
import 'puzzle_type.dart';
import 'registry.dart';

/// What a game is about, for search only. The labels are `tag*` texts, which
/// may list several synonyms, since they are never shown.
enum GameTag {
  shade,
  loop,
  path,
  numbers,
  regions,
  sums,
  latin,
  place,
  connect,
  colors,
  guess,
  slide,
  arcade,
  symmetry,
  binary,
  maze,
}

String tagLabel(AppLocalizations l, GameTag tag) => switch (tag) {
  GameTag.shade => l.tagShade,
  GameTag.loop => l.tagLoop,
  GameTag.path => l.tagPath,
  GameTag.numbers => l.tagNumbers,
  GameTag.regions => l.tagRegions,
  GameTag.sums => l.tagSums,
  GameTag.latin => l.tagLatin,
  GameTag.place => l.tagPlace,
  GameTag.connect => l.tagConnect,
  GameTag.colors => l.tagColors,
  GameTag.guess => l.tagGuess,
  GameTag.slide => l.tagSlide,
  GameTag.arcade => l.tagArcade,
  GameTag.symmetry => l.tagSymmetry,
  GameTag.binary => l.tagBinary,
  GameTag.maze => l.tagMaze,
};

/// Tags of every type, by id.
const Map<String, List<GameTag>> gameTags = {
  'mambo': [GameTag.binary, GameTag.place],
  'sudoku': [GameTag.numbers, GameTag.latin],
  'kings': [GameTag.place, GameTag.regions],
  'blocks': [GameTag.numbers, GameTag.regions],
  'tally': [GameTag.shade, GameTag.sums],
  'formula': [GameTag.sums, GameTag.guess],
  'pairs': [GameTag.shade, GameTag.regions],
  'hues': [GameTag.colors, GameTag.shade],
  'mosaic': [GameTag.colors],
  'blend': [GameTag.colors],
  'pop': [GameTag.colors],
  'merge': [GameTag.slide, GameTag.numbers],
  'snake': [GameTag.arcade],
  'pipes': [GameTag.connect],
  'shikaku': [GameTag.regions],
  'plots': [GameTag.regions, GameTag.numbers],
  'orbits': [GameTag.regions, GameTag.symmetry],
  'trail': [GameTag.path],
  'links': [GameTag.path, GameTag.connect],
  'labyrinth': [GameTag.path, GameTag.maze],
  'atoms': [GameTag.connect],
  'lits': [GameTag.shade, GameTag.regions],
  'camp': [GameTag.place],
  'islands': [GameTag.shade],
  'lamps': [GameTag.place],
  'fence': [GameTag.loop],
  'pearls': [GameTag.loop],
  'rails': [GameTag.path, GameTag.loop],
  'arrows': [GameTag.shade, GameTag.loop],
  'mines': [GameTag.place],
};

/// Other names a game is known by. Only matched, never shown (search echoes
/// what the player typed instead), and kept out of store listings.
const Map<String, List<String>> gameAliases = {
  'mambo': ['Takuzu', 'Binairo', 'Tango', 'Binary puzzle', 'Unruly', '0h h1'],
  'sudoku': ['Number place'],
  'kings': ['Queens', 'Star Battle', 'Two not touch'],
  'blocks': ['Suguru', 'Tectonic'],
  'tally': ['Sumplete', 'Rullo'],
  'formula': ['Nerdle', 'Mathler'],
  'pairs': ['Norinori'],
  'mosaic': ['Flood-it', 'Flood fill'],
  'blend': ['Flood-it', 'Free flood'],
  'pop': ['SameGame', 'Same game', 'Bubble breaker', 'Jawbreaker', 'Clickomania'],
  'snake': ['Nibbles'],
  'pipes': ['Net', 'NetWalk'],
  'shikaku': ['Rectangles'],
  'plots': ['Fillomino'],
  'orbits': ['Tentai Show', 'Galaxies', 'Spiral Galaxies'],
  'trail': ['Zip', 'Hamiltonian path'],
  'links': ['Numberlink', 'Arukone', 'Flow'],
  'labyrinth': ['Maze'],
  'atoms': ['Hashi', 'Hashiwokakero', 'Bridges'],
  'lits': ['LITS', 'Nuruomino'],
  'camp': ['Tents', 'Tents and Trees'],
  'islands': ['Nurikabe'],
  'lamps': ['Light Up', 'Akari'],
  'fence': ['Slitherlink', 'Loopy', 'Fences'],
  'pearls': ['Masyu'],
  'rails': ['Train Tracks', 'Tracks'],
  'arrows': ['Yajilin'],
  'mines': ['Minesweeper'],
};

/// [found] matched by their own names, taglines or tags; [alternatives] only
/// by another name, so the screen says we don't have the game asked for.
/// When neither matched, [similar] are games whose name or other name is
/// close to the query (a typo).
typedef SearchResults = ({List<PuzzleType> found, List<PuzzleType> alternatives, List<PuzzleType> similar});

const _fold = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a', 'ą': 'a', //
  'ç': 'c', 'ć': 'c', 'č': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ę': 'e', 'ě': 'e',
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ł': 'l', 'ñ': 'n', 'ń': 'n', 'ň': 'n',
  'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o', 'ř': 'r', 'ś': 's', 'š': 's', 'ß': 'ss',
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ů': 'u', 'ý': 'y', 'ÿ': 'y', 'ź': 'z', 'ż': 'z', 'ž': 'z',
  'ё': 'е', 'є': 'е', 'ї': 'і', 'й': 'и', 'ґ': 'г', 'ʼ': '', '’': '', "'": '',
};

final _separator = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

/// Lower case, accents dropped, split into words.
List<String> searchWords(String text) {
  final lower = text.toLowerCase();
  final b = StringBuffer();
  for (final r in lower.runes) {
    final c = String.fromCharCode(r);
    b.write(_fold[c] ?? c);
  }
  return b.toString().split(_separator).where((w) => w.isNotEmpty).toList();
}

final _languages = [for (final locale in AppLocalizations.supportedLocales) lookupAppLocalizations(locale)];

bool _covers(List<String> query, Iterable<String> words) => query.every((q) => words.any((w) => w.startsWith(q)));

/// Edits (insert, delete, change, swap two neighbours) between [a] and [b].
int _distance(String a, String b) {
  final d = List.generate(a.length + 1, (i) => List.filled(b.length + 1, 0));
  for (var i = 0; i <= a.length; i++) {
    d[i][0] = i;
  }
  for (var j = 0; j <= b.length; j++) {
    d[0][j] = j;
  }
  for (var i = 1; i <= a.length; i++) {
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      var v = [d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost].reduce((x, y) => x < y ? x : y);
      if (i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1] && d[i - 2][j - 2] + 1 < v) {
        v = d[i - 2][j - 2] + 1;
      }
      d[i][j] = v;
    }
  }
  return d[a.length][b.length];
}

/// [q] starts [w] up to a typo: one for words of 4–6 letters, two from 7.
/// Shorter words must match exactly.
bool _nearly(String q, String w) {
  if (w.startsWith(q)) return true;
  if (q.length < 4) return false;
  final allowed = q.length >= 7 ? 2 : 1;
  for (var len = q.length - allowed; len <= q.length + allowed; len++) {
    if (len < 1 || len > w.length) continue;
    if (_distance(q, w.substring(0, len)) <= allowed) return true;
  }
  return false;
}

/// Games matching [query], in home-screen order with name matches first.
/// Every query word must start a word of the game's name, tagline or tags (in
/// any of the app's languages), or, for [SearchResults.alternatives], of
/// another name; failing both, [SearchResults.similar] allows typos.
SearchResults searchGames(String query) {
  final q = searchWords(query);
  if (q.isEmpty) return (found: const [], alternatives: const [], similar: const []);
  final byName = <PuzzleType>[], other = <PuzzleType>[], alternatives = <PuzzleType>[], similar = <PuzzleType>[];
  for (final c in puzzleCategories) {
    for (final f in c.families) {
      for (final t in f.types) {
        final names = [
          for (final s in {
            for (final l in _languages) ...[t.name(l), if (!f.single) f.name(l)],
          })
            ...searchWords(s),
        ];
        final visible = [
          ...names,
          for (final s in {for (final l in _languages) t.tagline(l)}) ...searchWords(s),
          for (final tag in gameTags[t.id] ?? const <GameTag>[])
            for (final s in {for (final l in _languages) tagLabel(l, tag)}) ...searchWords(s),
        ];
        final aliases = [for (final a in gameAliases[t.id] ?? const <String>[]) ...searchWords(a)];
        if (_covers(q, names)) {
          byName.add(t);
        } else if (_covers(q, visible)) {
          other.add(t);
        } else if (_covers(q, [...visible, ...aliases])) {
          alternatives.add(t);
        } else if (q.every((w) => [...names, ...aliases].any((n) => _nearly(w, n)))) {
          similar.add(t);
        }
      }
    }
  }
  final found = [...byName, ...other];
  return (
    found: found,
    alternatives: alternatives,
    similar: found.isEmpty && alternatives.isEmpty ? similar : const <PuzzleType>[],
  );
}
