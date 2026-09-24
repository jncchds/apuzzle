import 'grid.dart';

enum Difficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard'),
  expert('Expert');

  const Difficulty(this.label);
  final String label;
}

/// Everything needed to (re)generate a puzzle deterministically.
class GenParams {
  const GenParams({required this.size, required this.difficulty, required this.seed});

  final GridSize size;
  final Difficulty difficulty;
  final int seed;

  GenParams withSeed(int seed) => GenParams(size: size, difficulty: difficulty, seed: seed);

  Map<String, dynamic> toJson() => {'size': size.toJson(), 'difficulty': difficulty.name, 'seed': seed};

  factory GenParams.fromJson(Map<String, dynamic> j) => GenParams(
        size: GridSize.fromJson(j['size'] as Map<String, dynamic>),
        difficulty: Difficulty.values.byName(j['difficulty'] as String),
        seed: j['seed'] as int,
      );
}
