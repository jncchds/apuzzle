import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import 'inlay_board.dart';
import 'inlay_generator.dart';
import 'inlay_model.dart';
import 'inlay_solver.dart';
import 'inlay_tutorial.dart';

/// Fit every piece from the tray into the shape: any exact cover wins.
class InlayType extends PuzzleType<InlayPuzzle, InlayState> {
  const InlayType();

  static const wood = Color(0xFFD9A25F);

  @override
  String get id => 'inlay';
  @override
  String name(AppLocalizations l) => l.inlayName;
  @override
  String tagline(AppLocalizations l) => l.inlayTagline;
  @override
  IconData get icon => Icons.extension_rounded;
  @override
  Color get accent => wood;

  @override
  String rulesText(AppLocalizations l) => l.inlayRules;

  @override
  List<TutorialStep> tutorial() => inlayTutorial;
  @override
  List<TutorialStep> strategies() => inlayStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 8; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(6);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(5),
    Difficulty.medium => const GridSize.square(6),
    _ => const GridSize.square(7),
  };
  @override
  Day get dailySince => const Day(2026, 10, 15);
  @override
  double get minCellSize => 36;

  /// The tray shares the board's room (under it, or beside it in landscape).
  @override
  double get controlsHeight => 200;
  @override
  bool get showSubmit => false;

  @override
  InlayPuzzle generate(GenParams params) => generateInlay(params);
  @override
  InlayState initialState(InlayPuzzle puzzle) =>
      InlayState(List.filled(puzzle.pieces.length, 0), List.filled(puzzle.pieces.length, -1));

  @override
  bool isComplete(InlayPuzzle puzzle, InlayState state) => state.at.every((a) => a >= 0);
  @override
  bool isSolved(InlayPuzzle puzzle, InlayState state) => inlaySolved(puzzle, state);
  @override
  Set<Pos> conflicts(InlayPuzzle puzzle, InlayState state) => const {};

  /// Lays one more piece of a cover that keeps the pieces already laid. If
  /// there is none, first takes back a piece that is in the way.
  @override
  HintResult<InlayState>? hint(InlayPuzzle puzzle, InlayState state) => inlayHint(puzzle, state);

  @override
  Widget buildBoard(BuildContext context, GameController controller) => InlayBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(InlayPuzzle puzzle) => puzzle.toJson();
  @override
  InlayPuzzle decodePuzzle(Map<String, dynamic> json) => InlayPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(InlayState state) => state.toJson();
  @override
  InlayState decodeState(Map<String, dynamic> json) => InlayState.fromJson(json);
}

/// Node cap of one cover search for a hint.
const _hintCap = 60000;

/// See [InlayType.hint].
HintResult<InlayState>? inlayHint(InlayPuzzle p, InlayState s) {
  if (inlaySolved(p, s)) return null;
  final solver = InlaySolver(p);
  final n = p.pieces.length;
  List<(int, int)?> fixedOf(int? without) => [
    for (var k = 0; k < n; k++)
      if (k != without && s.placed(k) && s.orient[k] < p.orientations) (s.orient[k], s.at[k]) else null,
  ];
  Set<Pos> cellsOf(int k) => {for (final i in pieceCells(p, s, k)) p.size.pos(i)};

  // A piece in a mirrored orientation that isn't allowed goes back first.
  for (var k = 0; k < n; k++) {
    if (s.placed(k) && s.orient[k] >= p.orientations) return HintResult(s.withPiece(k, at: -1), cellsOf(k));
  }
  final cover = solver.complete(fixedOf(null), cap: _hintCap);
  if (cover != null) {
    // The piece on the first empty cell of the shape.
    final owner = inlayOwners(p, s);
    final empty = [for (var i = 0; i < p.cells; i++) p.shape[i] && owner[i] < 0].indexOf(true);
    for (var k = 0; k < n; k++) {
      if (s.placed(k)) continue;
      final (o, at) = cover[k];
      final cells = p.cover(k, o, at ~/ p.cols, at % p.cols)!;
      if (empty < 0 || cells.contains(empty)) {
        return HintResult(s.withPiece(k, orient: o, at: at), {for (final i in cells) p.size.pos(i)});
      }
    }
  }
  // Take back a piece without which the rest still fits.
  for (var k = n - 1; k >= 0; k--) {
    if (s.placed(k) && solver.complete(fixedOf(k), cap: _hintCap) != null) {
      return HintResult(s.withPiece(k, at: -1), cellsOf(k));
    }
  }
  // Else the first piece that isn't where any piece of the known cover lies.
  final known = {
    for (var k = 0; k < n; k++)
      cellsKey([
        for (final i in p.cover(k, p.solution[k].$1, p.solution[k].$2 ~/ p.cols, p.solution[k].$2 % p.cols)!)
          (i ~/ p.cols, i % p.cols),
      ]),
  };
  for (var k = 0; k < n; k++) {
    if (s.placed(k) && !known.contains(cellsKey([for (final i in pieceCells(p, s, k)) (i ~/ p.cols, i % p.cols)]))) {
      return HintResult(s.withPiece(k, at: -1), cellsOf(k));
    }
  }
  // Every laid piece lies as in the known cover: lay the next one from it.
  for (var k = 0; k < n; k++) {
    if (!s.placed(k)) {
      final (o, at) = p.solution[k];
      final cells = p.cover(k, o, at ~/ p.cols, at % p.cols)!;
      final owner = inlayOwners(p, s);
      if (cells.every((i) => owner[i] < 0)) {
        return HintResult(s.withPiece(k, orient: o, at: at), {for (final i in cells) p.size.pos(i)});
      }
    }
  }
  return null;
}
