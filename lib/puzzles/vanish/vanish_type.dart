import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/grid.dart';
import '../../core/recall.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'vanish_tutorial.dart';

/// Vanish: numbers 1..k appear on the grid; the moment the player taps 1,
/// the rest hide, and they are tapped in order from memory. A round is the
/// cells of 1, 2, 3...; its level is k.
class VanishType extends RecallType {
  const VanishType();

  @override
  String get id => 'vanish';
  @override
  String name(AppLocalizations l) => l.vanishName;
  @override
  String tagline(AppLocalizations l) => l.vanishTagline;
  @override
  String rulesText(AppLocalizations l) => l.vanishRules;
  @override
  IconData get icon => Icons.format_list_numbered_rounded;
  @override
  Color get accent => const Color(0xFFF2A541);

  @override
  List<TutorialStep> tutorial() => vanishTutorial;

  @override
  List<GridSize> get sizes => const [
    GridSize.square(4),
    GridSize.square(5),
    GridSize.square(6),
    GridSize.square(7),
    GridSize.square(8),
  ];
  @override
  GridSize get defaultSize => const GridSize.square(5);
  @override
  GridSize dailySize(Difficulty difficulty) =>
      difficulty == Difficulty.hard ? const GridSize.square(6) : const GridSize.square(5);
  @override
  Day get dailySince => const Day(2026, 10, 15);

  /// From 3 numbers up to 60% of the board (at most 20).
  @override
  (int, int) levels(GridSize size) => (3, min(20, size.rows * size.cols * 3 ~/ 5));

  @override
  int startLevel(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => 4,
    Difficulty.medium => 5,
    _ => 6,
  };

  @override
  List<int> makeRound(RecallPuzzle p, int level, Random rng) => recallCells(p, level, rng);

  /// The numbers stay until the first tap.
  @override
  int? showMs(RecallPuzzle p, List<int> round) => null;
  @override
  bool get answerWhileShown => true;
  @override
  bool get hasReady => false;

  /// Only the cells that held a number, each once.
  @override
  bool accepts(RecallPuzzle p, List<int> round, List<int> taps, int target) =>
      round.contains(target) && !taps.contains(target);

  @override
  RecallVerdict verdict(RecallPuzzle p, List<int> round, List<int> taps) {
    if (taps.last != round[taps.length - 1]) return RecallVerdict.failed;
    return taps.length == round.length ? RecallVerdict.passed : RecallVerdict.going;
  }

  @override
  int nextTap(RecallPuzzle p, List<int> round, List<int> taps) => round[taps.length];

  @override
  String watchText(AppLocalizations l, RecallPuzzle p) => l.vanishWatch;
  @override
  String prompt(AppLocalizations l, RecallPuzzle p) => l.vanishPrompt;

  @override
  void paint(Canvas canvas, RecallView v) {
    v.paintTiles(canvas);
    if (v.waiting) return;
    final taps = v.state.taps;
    final passed = v.state.passed;
    final white = Colors.white;
    for (var k = 0; k < v.round.length; k++) {
      final i = v.round[k];
      final tile = v.tileOf(i);
      final rect = v.rectOf(i);
      final label = '${k + 1}';
      switch (v.phase) {
        case RecallPhase.show:
          canvas.drawRRect(tile, Paint()..color = v.accent);
          v.paintText(canvas, label, rect, white);
        case RecallPhase.answer:
          if (taps.contains(i)) {
            v.paintText(canvas, label, rect, v.scheme.onSurfaceVariant.withValues(alpha: 0.6), size: 0.4);
          } else {
            canvas.drawRRect(tile, Paint()..color = v.accent);
          }
        case RecallPhase.result:
          final right = k < taps.length && taps[k] == i;
          final wrong = !passed && taps.last == i;
          final color = passed || right
              ? v.good
              : wrong
              ? v.bad
              : Color.lerp(v.tile, v.accent, 0.45)!;
          canvas.drawRRect(tile, Paint()..color = color);
          v.paintText(canvas, label, rect, white);
          // Where the right number was.
          if (!passed && k == taps.length - 1) {
            canvas.drawRRect(
              tile.deflate(v.cell * 0.04),
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = v.cell * 0.07
                ..color = v.good,
            );
          }
        default:
      }
    }
  }
}
