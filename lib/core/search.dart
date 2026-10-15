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
  compare,
  place,
  pieces,
  connect,
  colors,
  guess,
  slide,
  arcade,
  symmetry,
  binary,
  maze,
  ships,
  water,
  memory,
  drive,
  sight,
  arrow,
  charge,
  temperature,
  switches,
}

String tagLabel(AppLocalizations l, GameTag tag) => switch (tag) {
  GameTag.shade => l.tagShade,
  GameTag.loop => l.tagLoop,
  GameTag.path => l.tagPath,
  GameTag.numbers => l.tagNumbers,
  GameTag.regions => l.tagRegions,
  GameTag.sums => l.tagSums,
  GameTag.latin => l.tagLatin,
  GameTag.compare => l.tagCompare,
  GameTag.place => l.tagPlace,
  GameTag.pieces => l.tagPieces,
  GameTag.connect => l.tagConnect,
  GameTag.colors => l.tagColors,
  GameTag.guess => l.tagGuess,
  GameTag.slide => l.tagSlide,
  GameTag.arcade => l.tagArcade,
  GameTag.symmetry => l.tagSymmetry,
  GameTag.binary => l.tagBinary,
  GameTag.maze => l.tagMaze,
  GameTag.ships => l.tagShips,
  GameTag.water => l.tagWater,
  GameTag.memory => l.tagMemory,
  GameTag.drive => l.tagDrive,
  GameTag.sight => l.tagSight,
  GameTag.arrow => l.tagArrow,
  GameTag.charge => l.tagCharge,
  GameTag.temperature => l.tagTemperature,
  GameTag.switches => l.tagSwitch,
};

/// Tags of every type, by id.
const Map<String, List<GameTag>> gameTags = {
  'mambo': [GameTag.binary, GameTag.place],
  'sudoku': [GameTag.numbers, GameTag.latin],
  'pockets': [GameTag.numbers, GameTag.latin, GameTag.sums, GameTag.regions],
  'skyline': [GameTag.numbers, GameTag.latin],
  'cages': [GameTag.numbers, GameTag.latin, GameTag.sums, GameTag.regions],
  'totals': [GameTag.numbers, GameTag.sums],
  'signs': [GameTag.numbers, GameTag.latin, GameTag.compare],
  'kings': [GameTag.place, GameTag.regions],
  'blocks': [GameTag.numbers, GameTag.regions],
  'tally': [GameTag.shade, GameTag.sums],
  'solo': [GameTag.shade, GameTag.numbers, GameTag.latin],
  'domino': [GameTag.numbers, GameTag.regions],
  'formula': [GameTag.sums, GameTag.guess],
  'pairs': [GameTag.shade, GameTag.regions],
  'hues': [GameTag.colors, GameTag.shade],
  'mosaic': [GameTag.colors],
  'blend': [GameTag.colors],
  'pop': [GameTag.colors],
  'merge': [GameTag.slide, GameTag.numbers],
  'nightfall': [GameTag.switches],
  'snake': [GameTag.arcade],
  'junction': [GameTag.arcade, GameTag.path],
  'turnabout': [GameTag.arcade, GameTag.maze],
  'glimpse': [GameTag.memory],
  'vanish': [GameTag.memory, GameTag.numbers],
  'hopper': [GameTag.memory],
  'rebound': [GameTag.memory],
  'pipes': [GameTag.connect],
  'channel': [GameTag.connect, GameTag.path, GameTag.water],
  'shikaku': [GameTag.regions],
  'plots': [GameTag.regions, GameTag.numbers],
  'orbits': [GameTag.regions, GameTag.symmetry],
  'inlay': [GameTag.pieces, GameTag.place],
  'trail': [GameTag.path],
  'links': [GameTag.path, GameTag.connect],
  'waymarks': [GameTag.path, GameTag.numbers, GameTag.arrow],
  'labyrinth': [GameTag.path, GameTag.maze],
  'homeward': [GameTag.drive, GameTag.path],
  'blockade': [GameTag.ships, GameTag.path],
  'atoms': [GameTag.connect],
  'lits': [GameTag.shade, GameTag.regions],
  'camp': [GameTag.place],
  'fleet': [GameTag.place, GameTag.ships],
  'basins': [GameTag.water, GameTag.regions],
  'mercury': [GameTag.temperature, GameTag.water],
  'poles': [GameTag.place, GameTag.charge],
  'pebbles': [GameTag.shade, GameTag.binary, GameTag.connect],
  'chambers': [GameTag.shade, GameTag.regions],
  'lookout': [GameTag.shade, GameTag.sight],
  'rampart': [GameTag.shade, GameTag.numbers, GameTag.connect],
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
  'pockets': [
    'Killer Sudoku',
    'Killer',
    'Sum Doku',
    'Sumdoku',
    'Samunamupure',
    'Add-up Sudoku',
    'Киллер-судоку',
    'Кілер-судоку',
  ],
  'skyline': ['Skyscrapers', 'Skyscraper', 'Towers', 'Buildings', 'Хмарочоси', 'Drapacze chmur', 'Wolkenkratzer'],
  'totals': ['Kakuro', 'Cross Sums', 'Cross Sum', 'Kreuzsummen', 'Какуро'],
  'cages': ['KenKen', 'Ken Ken', 'Calcudoku', 'Mathdoku', 'KenDoku', 'Inky', 'Кенкен', 'Калькудоку'],
  'signs': [
    'Futoshiki',
    'Hutoshiki',
    'Unequal',
    'Inequality',
    'Greater Than',
    'More or Less',
    'Футошики',
    'Футосікі',
    'Нерівності',
  ],
  'kings': ['Queens', 'Star Battle', 'Two not touch'],
  'blocks': ['Suguru', 'Tectonic'],
  'tally': ['Sumplete', 'Rullo'],
  'solo': ['Hitori', 'Singles', 'Хітори', 'Хитори', 'Хіторі'],
  'domino': ['Dominosa', 'Доміноса', 'Доминоса'],
  'formula': ['Nerdle', 'Mathler'],
  'pairs': ['Norinori'],
  'mosaic': ['Flood-it', 'Flood fill'],
  'blend': ['Flood-it', 'Free flood'],
  'pop': ['SameGame', 'Same game', 'Bubble breaker', 'Jawbreaker', 'Clickomania'],
  'nightfall': [
    'Lights Out',
    'Lights Off',
    'Merlin',
    'Flip',
    'Lichter aus',
    'Світло вимкнено',
    'Вимкни світло',
    'Выключи свет',
    'Погаси свет',
    'Zgaś światło',
  ],
  'snake': ['Nibbles'],
  'junction': ['Train of Thought', 'Lumosity'],
  'turnabout': ['Penguin Pursuit', 'Lumosity'],
  'glimpse': ['Memory Matrix', 'Lumosity', 'Visual memory'],
  'vanish': ['Top Chimp', 'Chimp test', 'Lumosity'],
  'hopper': ['Follow that Frog', 'Corsi blocks', 'Simon', 'Lumosity'],
  'rebound': ['Pinball Recall', 'Lumosity'],
  'pipes': ['Net', 'NetWalk'],
  'channel': ['Disconnection'],
  'shikaku': ['Rectangles'],
  'plots': ['Fillomino'],
  'orbits': ['Tentai Show', 'Galaxies', 'Spiral Galaxies'],
  'inlay': ['Masterpiece', 'Tangram', 'Pentomino', 'Pentominoes', 'Polyomino', 'Katamino', 'Ubongo'],
  'trail': ['Zip', 'Hamiltonian path'],
  'links': ['Numberlink', 'Arukone', 'Flow'],
  'waymarks': ['Signpost', 'Arrow Path', 'Pfeilpfad', 'Hebi'],
  'labyrinth': ['Maze'],
  'homeward': ['Pet Detective', 'Pet taxi'],
  'blockade': ['Pirate Passage'],
  'atoms': ['Hashi', 'Hashiwokakero', 'Bridges'],
  'lits': ['LITS', 'Nuruomino'],
  'camp': ['Tents', 'Tents and Trees'],
  'fleet': [
    'Battleships',
    'Battleship',
    'Bimaru',
    'Solitaire Battleship',
    'Sea Battle',
    'Морський бій',
    'Морской бой',
    'Statki',
    'Schiffe versenken',
  ],
  'basins': ['Aquarium', 'Акваріум', 'Аквариум', 'Akwarium'],
  'mercury': [
    'Thermometers',
    'Thermometer',
    'Thermometer puzzle',
    'Thermometer-Rätsel',
    'Thermometerrätsel',
    'Termometry',
    'Termometr',
    'Термометри',
    'Термометр',
    'Термометры',
  ],
  'poles': ['Magnets', 'Magnetic', 'Magnetplatten', 'Elektrik', 'Magnete', 'Magnesy', 'Магніти', 'Магниты'],
  'lookout': ['Kurodoko', 'Kuromasu', 'Where is Black Cells', 'Куродоко', 'Куромасу'],
  'rampart': ['Tapa', 'Тапа'],
  'chambers': ['Heyawake', 'Heya-wake', 'Heya wake', 'Room division', 'Хеяваке', 'Хэявакэ'],
  'pebbles': ['Yin-Yang', 'Yin Yang', 'Shiromaru-Kuromaru', 'Інь-Ян', 'Инь-Янь', 'Инь-Ян'],
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
  if (found.isNotEmpty || alternatives.isNotEmpty) {
    return (found: found, alternatives: alternatives, similar: const <PuzzleType>[]);
  }
  return (found: found, alternatives: alternatives, similar: similar.isNotEmpty ? similar : _closest(q));
}

/// Edits that turn [q] into some part of [w] (the rest of [w] is free), so a
/// query found inside a word costs nothing.
int _partDistance(String q, String w) {
  var prev = List.filled(w.length + 1, 0);
  for (var i = 1; i <= q.length; i++) {
    final cur = List.filled(w.length + 1, i);
    for (var j = 1; j <= w.length; j++) {
      final cost = q[i - 1] == w[j - 1] ? 0 : 1;
      cur[j] = [prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + cost].reduce((x, y) => x < y ? x : y);
    }
    prev = cur;
  }
  return prev.reduce((x, y) => x < y ? x : y);
}

/// The games whose words come closest to [q] (partial words count, names
/// beat taglines, tags and other names), so a search never comes back empty.
List<PuzzleType> _closest(List<String> q) {
  int best(String w, List<String> words) => words.fold(1 << 30, (m, n) {
    final d = _partDistance(w, n);
    return d < m ? d : m;
  });
  final scored = <(PuzzleType, int)>[];
  for (final c in puzzleCategories) {
    for (final f in c.families) {
      for (final t in f.types) {
        final names = {
          for (final l in _languages) ...[...searchWords(t.name(l)), if (!f.single) ...searchWords(f.name(l))],
        }.toList();
        final rest = {
          for (final l in _languages) ...searchWords(t.tagline(l)),
          for (final tag in gameTags[t.id] ?? const <GameTag>[])
            for (final l in _languages) ...searchWords(tagLabel(l, tag)),
          for (final a in gameAliases[t.id] ?? const <String>[]) ...searchWords(a),
        }.toList();
        var score = 0;
        for (final w in q) {
          final byName = 2 * best(w, names), byRest = 2 * best(w, rest) + 1;
          score += byName < byRest ? byName : byRest;
        }
        scored.add((t, score));
      }
    }
  }
  final top = scored.map((s) => s.$2).reduce((x, y) => x < y ? x : y);
  return [
    for (final (t, s) in scored)
      if (s == top) t,
  ].take(5).toList();
}
