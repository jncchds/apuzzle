import 'dart:math';

import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/tutorial.dart';
import 'layers_generator.dart';
import 'layers_model.dart';

/// A board from its line colors and picture. [lines]: a letter per row,
/// then '/', then one per column (a, b, c are the colors, upper case for a
/// hidden one). [board]: rows separated by |, a letter per cell (upper case
/// when shown from the start), '.' outside the shape.
LayersPuzzle layersBoard(String lines, String board) {
  final [rowPart, colPart] = lines.split('/');
  final letters = (rowPart + colPart).split('');
  final rows = board.split('|');
  final cells = rows.join().split('');
  int color(String ch) => 'abc'.indexOf(ch.toLowerCase());
  final lineColors = [for (final ch in letters) color(ch)];
  return LayersPuzzle(
    rows: rows.length,
    cols: rows.first.length,
    colors: max(2, lineColors.reduce(max) + 1),
    lineColors: lineColors,
    picture: [for (final ch in cells) ch == '.' ? layersHole : color(ch)],
    givens: [
      for (var i = 0; i < cells.length; i++)
        if (cells[i] != '.' && cells[i] != cells[i].toLowerCase()) i,
    ],
    hidden: [
      for (var l = 0; l < letters.length; l++)
        if (letters[l] != letters[l].toLowerCase()) l,
    ],
  );
}

final List<TutorialStep> layersTutorial = [
  // Cells whose row and column share a color can only be that color.
  TutorialStep(text: (l) => l.tutLayers1, puzzle: layersBoard('aba/aab', 'aaB|AAb|aaB')),
  // Round a rectangle: row 1 after column A, column A after row 3, row 3
  // after column C, so row 1 after column C.
  TutorialStep(
    text: (l) => l.tutLayers2,
    puzzle: layersBoard('aba/bab', 'Aaa|bBb|BaA'),
    focus: {const Pos(0, 0), const Pos(2, 0), const Pos(2, 2), const Pos(0, 2)},
  ),
  // Row 1 hides its color, but A1 shows it.
  TutorialStep(
    text: (l) => l.tutLayers3,
    puzzle: layersBoard('Abb/bab', 'AaB|bBb|bBb'),
    focus: {const Pos(0, 0), const Pos(0, 1)},
  ),
  TutorialStep.generated(
    text: (l) => l.tutLayers4,
    make: () => generateLayers(const GenParams(size: GridSize.square(5), difficulty: Difficulty.easy, seed: 1)),
  ),
];

final List<TutorialStep> layersStrategies = [
  TutorialStep.generated(
    text: (l) => l.tutLayersS1,
    make: () => generateLayers(const GenParams(size: GridSize.square(6), difficulty: Difficulty.medium, seed: 1)),
  ),
  TutorialStep.generated(
    text: (l) => l.tutLayersS2,
    make: () => generateLayers(const GenParams(size: GridSize.square(6), difficulty: Difficulty.hard, seed: 1)),
  ),
];
