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
    return '${type.id}-${s.cols}x${s.rows}-${params.difficulty.name}-'
        '${params.seed.toRadixString(36).toUpperCase()}-v${type.generatorVersion}';
  }

  static String link(PuzzleType type, GenParams params) => '$linkBase?p=${format(type, params)}';

  static final _embedded = RegExp(r'\b[a-z]+-\d+x\d+-[a-z]+-[0-9a-z]+(-v\d+)?\b', caseSensitive: false);

  /// The first well-formed code inside [text] (a share message or a link).
  static String? find(String text) => _embedded.firstMatch(text)?.group(0);

  /// Parses a code, or a link or message containing one (case-insensitive,
  /// "#" and spaces ignored). Throws [FormatException] with a user-facing message.
  static PuzzleCode parse(String input, List<PuzzleType> types) {
    final parts = (find(input) ?? input).trim().replaceAll('#', '').toLowerCase().split(RegExp(r'[-\s]+'))
      ..removeWhere((p) => p.isEmpty);
    if (parts.length < 4 || parts.length > 5) {
      throw const FormatException('Expected a code like kings-8x8-hard-4FZ8K1-v1');
    }

    final type = types.where((t) => t.id == parts[0]).firstOrNull;
    if (type == null) throw FormatException('Unknown puzzle "${parts[0]}"');

    final dims = RegExp(r'^(\d+)x(\d+)$').firstMatch(parts[1]);
    final size = dims == null ? null : GridSize(int.parse(dims[2]!), int.parse(dims[1]!));
    if (size == null || !type.sizes.contains(size)) {
      throw FormatException('${type.name} has no ${parts[1]} size');
    }

    final difficulty = type.difficulties.where((d) => d.name == parts[2] || d.name[0] == parts[2]).firstOrNull;
    if (difficulty == null) throw FormatException('${type.name} has no "${parts[2]}" difficulty');

    final seed = int.tryParse(parts[3], radix: 36);
    if (seed == null || seed < 0 || seed > maxSeed) throw FormatException('Bad seed "${parts[3]}"');

    if (parts.length == 5) {
      final version = RegExp(r'^v(\d+)$').firstMatch(parts[4]);
      if (version == null) throw FormatException('Bad version "${parts[4]}"');
      if (int.parse(version[1]!) != type.generatorVersion) {
        throw const FormatException('This code comes from a different app version, so the puzzle would not match');
      }
    }

    return PuzzleCode(type, GenParams(size: size, difficulty: difficulty, seed: seed));
  }
}
