import '../l10n/l10n.dart';
import 'grid.dart';

enum Difficulty {
  easy,
  medium,
  hard,
  expert;

  String label(AppLocalizations l) => switch (this) {
        easy => l.difficultyEasy,
        medium => l.difficultyMedium,
        hard => l.difficultyHard,
        expert => l.difficultyExpert,
      };
}

/// Everything needed to (re)generate a puzzle deterministically.
class GenParams {
  const GenParams({required this.size, required this.difficulty, required this.seed, this.options = const {}});

  final GridSize size;
  final Difficulty difficulty;
  final int seed;

  /// Type-specific choices (option id → choice id), e.g. a game mode. See
  /// [PuzzleType.optionsFor]; types fill in defaults for missing ones.
  final Map<String, String> options;

  GenParams withSeed(int seed) => GenParams(size: size, difficulty: difficulty, seed: seed, options: options);

  /// Stats bucket: difficulty plus the chosen options, e.g. `hard.std.clear`.
  String get variant => [difficulty.name, ...options.values].join('.');

  Map<String, dynamic> toJson() => {
        'size': size.toJson(),
        'difficulty': difficulty.name,
        'seed': seed,
        if (options.isNotEmpty) 'options': options,
      };

  factory GenParams.fromJson(Map<String, dynamic> j) => GenParams(
        size: GridSize.fromJson(j['size'] as Map<String, dynamic>),
        difficulty: Difficulty.values.byName(j['difficulty'] as String),
        seed: j['seed'] as int,
        options: (j['options'] as Map<String, dynamic>?)?.cast<String, String>() ?? const {},
      );
}
