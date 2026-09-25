import 'dart:ui';

import '../l10n/l10n.dart';
import 'difficulty.dart';
import 'grid.dart';
import 'puzzle_type.dart';

/// A short, shareable code that regenerates one exact puzzle, e.g.
/// `kings-8x8-hard-4FZ8K1-v1`: type id, size (cols×rows), difficulty,
/// seed (base 36) and the type's [PuzzleType.generatorVersion].
///
/// Two players with the same code get the same board, so it doubles as the
/// key for comparing times.
class PuzzleCode {
  const PuzzleCode(this.type, this.params);

  final PuzzleType type;
  final GenParams params;

  /// Seeds are drawn from [0, maxSeed]; larger ones are rejected so that
  /// `Random(seed)` behaves the same on native and web.
  static const maxSeed = (1 << 31) - 1;

  @override
  String toString() => format(type, params);

  /// Where the web build is hosted; share links open it (or the Android app).
  static const linkBase = 'https://jncchds.github.io/apuzzle/';

  static String format(PuzzleType type, GenParams params) {
    final s = params.size;
    final options = type.resolveOptions(params.options).values;
    return '${type.id}-${s.cols}x${s.rows}-${[params.difficulty.name, ...options].join('.')}-'
        '${params.seed.toRadixString(36).toUpperCase()}-v${type.generatorVersion}';
  }

  static String link(PuzzleType type, GenParams params) => '$linkBase?p=${format(type, params)}';

  static const example = 'kings-8x8-hard-4FZ8K1-v1';

  static final _embedded = RegExp(r'\b[a-z]+-\d+x\d+-[a-z]+(\.[a-z]+)*-[0-9a-z]+(-v\d+)?\b', caseSensitive: false);

  /// The first well-formed code inside [text] (a share message or a link).
  static String? find(String text) => _embedded.firstMatch(text)?.group(0);

  /// Parses a code, or a link or message containing one (case-insensitive,
  /// "#" and spaces ignored). Throws [PuzzleCodeException].
  static PuzzleCode parse(String input, List<PuzzleType> types) {
    final parts = (find(input) ?? input).trim().replaceAll('#', '').toLowerCase().split(RegExp(r'[-\s]+'))
      ..removeWhere((p) => p.isEmpty);
    if (parts.length < 4 || parts.length > 5) {
      throw PuzzleCodeException((l) => l.codeExpected(example));
    }

    final type = types.where((t) => t.id == parts[0]).firstOrNull;
    if (type == null) throw PuzzleCodeException((l) => l.codeUnknownPuzzle(parts[0]));

    final dims = RegExp(r'^(\d+)x(\d+)$').firstMatch(parts[1]);
    final size = dims == null ? null : GridSize(int.parse(dims[2]!), int.parse(dims[1]!));
    if (size == null || !type.sizes.contains(size)) {
      throw PuzzleCodeException((l) => l.codeNoSize(type.name(l), parts[1]));
    }

    // Difficulty, then the type's options in order: "hard.std.clear".
    final [level, ...choices] = parts[2].split('.');
    final difficulty = type.difficulties.where((d) => d.name == level || d.name[0] == level).firstOrNull;
    if (difficulty == null) throw PuzzleCodeException((l) => l.codeNoDifficulty(type.name(l), level));
    final options = _parseOptions(type, choices);

    final seed = int.tryParse(parts[3], radix: 36);
    if (seed == null || seed < 0 || seed > maxSeed) throw PuzzleCodeException((l) => l.codeBadSeed(parts[3]));

    if (parts.length == 5) {
      final version = RegExp(r'^v(\d+)$').firstMatch(parts[4]);
      if (version == null) throw PuzzleCodeException((l) => l.codeBadVersion(parts[4]));
      if (int.parse(version[1]!) != type.generatorVersion) {
        throw PuzzleCodeException((l) => l.codeOtherVersion);
      }
    }

    return PuzzleCode(type, GenParams(size: size, difficulty: difficulty, seed: seed, options: options));
  }

  /// Maps positional choice ids onto [type]'s options (later options may
  /// depend on earlier ones). Missing ones get defaults.
  static Map<String, String> _parseOptions(PuzzleType type, List<String> choices) {
    var chosen = <String, String>{};
    for (var i = 0; i < choices.length; i++) {
      final options = type.optionsFor(chosen);
      if (i >= options.length) throw PuzzleCodeException((l) => l.codeNoOption(type.name(l), choices[i]));
      final o = options[i];
      if (!o.choices.contains(choices[i])) {
        throw PuzzleCodeException((l) => l.codeNoChoice(type.name(l), type.optionLabel(l, o.id), choices[i]));
      }
      chosen = type.resolveOptions({...chosen, o.id: choices[i]});
    }
    return type.resolveOptions(chosen);
  }
}

/// A code that doesn't parse. [message] is in English; show [describe].
class PuzzleCodeException extends FormatException {
  PuzzleCodeException(this.describe) : super(describe(lookupAppLocalizations(const Locale('en'))));

  final Tr describe;
}
