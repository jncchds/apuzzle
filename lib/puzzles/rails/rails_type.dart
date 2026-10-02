import 'package:flutter/material.dart';

import '../../core/day.dart';
import '../../core/difficulty.dart';
import '../../core/explain.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../core/tutorial.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/explain_overlay.dart';
import '../../ui/board/loop_board.dart';
import 'rails_explain.dart';
import 'rails_generator.dart';
import 'rails_model.dart';
import 'rails_tutorial.dart';

/// Train tracks: lay one track from the entry to the exit, matching the
/// row and column counts.
class RailsType extends PuzzleType<RailsPuzzle, RailsState> {
  const RailsType();

  static const railColor = Color(0xFFB88A6A);

  @override
  String get id => 'rails';
  @override
  String name(AppLocalizations l) => l.railsName;
  @override
  String tagline(AppLocalizations l) => l.railsTagline;
  @override
  IconData get icon => Icons.train_rounded;
  @override
  Color get accent => railColor;

  @override
  String rulesText(AppLocalizations l) => l.railsRules;

  @override
  List<TutorialStep> tutorial() => railsTutorial;
  @override
  List<TutorialStep> strategies() => railsStrategies;

  @override
  List<GridSize> get sizes => [for (var n = 5; n <= 10; n++) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  GridSize dailySize(Difficulty difficulty) => switch (difficulty) {
    Difficulty.easy => const GridSize.square(6),
    Difficulty.medium => const GridSize.square(7),
    _ => const GridSize.square(8),
  };
  @override
  Day get dailySince => const Day(2026, 9, 28);
  @override
  double get controlsHeight => 40;

  @override
  RailsPuzzle generate(GenParams params) => generateRails(params);

  /// Edges next to a given piece (fixed for the player).
  static List<bool> locked(RailsPuzzle p) {
    final g = p.lattice;
    return [
      for (var e = 0; e < g.edgeCount; e++)
        if (g.ends(e) case (final a, final b)) p.given[a] || p.given[b],
    ];
  }

  @override
  RailsState initialState(RailsPuzzle puzzle) {
    final fixed = locked(puzzle);
    return RailsState([for (var e = 0; e < fixed.length; e++) fixed[e] && puzzle.lines[e] ? 1 : 0]);
  }

  @override
  bool isComplete(RailsPuzzle puzzle, RailsState state) => railsWalk(puzzle, state.lines).done;

  @override
  bool isSolved(RailsPuzzle puzzle, RailsState state) => railsValid(puzzle, state.lines);

  @override
  Set<Pos> conflicts(RailsPuzzle puzzle, RailsState state) {
    final lines = state.lines;
    final n = puzzle.rows * puzzle.cols;
    final bad = {
      for (var i = 0; i < n; i++)
        if (railsDegree(puzzle, lines, i) > 2) i,
    };
    final walk = railsWalk(puzzle, lines);
    if (walk.done) {
      final used = railsUsed(puzzle, lines);
      final onTrack = walk.cells.toSet();
      for (var i = 0; i < n; i++) {
        if (used[i] && !onTrack.contains(i)) bad.add(i);
      }
      for (var r = 0; r < puzzle.rows; r++) {
        final cells = [for (var c = 0; c < puzzle.cols; c++) r * puzzle.cols + c];
        if (cells.where((i) => used[i]).length != puzzle.rowCounts[r]) bad.addAll(cells.where((i) => used[i]));
      }
      for (var c = 0; c < puzzle.cols; c++) {
        final cells = [for (var r = 0; r < puzzle.rows; r++) r * puzzle.cols + c];
        if (cells.where((i) => used[i]).length != puzzle.colCounts[c]) bad.addAll(cells.where((i) => used[i]));
      }
    }
    return {for (final i in bad) puzzle.size.pos(i)};
  }

  @override
  HintResult<RailsState>? hint(RailsPuzzle puzzle, RailsState state) {
    final g = puzzle.lattice;
    HintResult<RailsState> fix(int e, int v) {
      final (a, b) = g.ends(e);
      return HintResult(RailsState(List.of(state.marks)..[e] = v, state.cells), {
        puzzle.size.pos(a),
        puzzle.size.pos(b),
      });
    }

    // Wrong cell notes first.
    final track = railsUsed(puzzle, puzzle.lines);
    for (var i = 0; i < track.length; i++) {
      final note = state.note(i);
      if (note == railsNoteTrack && !track[i] || note == railsNoteDot && track[i]) {
        return HintResult(RailsState(state.marks, state.notes(track.length)..[i] = railsNoteNone), {
          puzzle.size.pos(i),
        });
      }
    }

    for (var e = 0; e < g.edgeCount; e++) {
      if (state.marks[e] == 1 && !puzzle.lines[e]) return fix(e, 2);
    }
    // Missing track, next to what's already laid first.
    final used = railsUsed(puzzle, state.lines);
    for (final nextToTrack in const [true, false]) {
      for (var e = 0; e < g.edgeCount; e++) {
        if (!puzzle.lines[e] || state.marks[e] == 1) continue;
        final (a, b) = g.ends(e);
        if (nextToTrack && !used[a] && !used[b]) continue;
        return fix(e, 1);
      }
    }
    return null;
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) {
    final p = controller.puzzle as RailsPuzzle;
    final s = controller.state as RailsState;
    final scheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.bodyLarge!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFD9CFC4) : const Color(0xFF4A3B30);
    final tie = dark ? const Color(0xFF6B5647) : const Color(0xFF8A6A52);
    final g = p.lattice;
    final used = railsUsed(p, s.lines);
    final n = p.rows * p.cols;
    // Track notes count toward the row and column numbers too.
    final counted = [for (var i = 0; i < n; i++) used[i] || s.note(i) == railsNoteTrack];

    void tapCell(Pos pos, bool secondary) {
      final i = p.size.index(pos);
      if (p.given[i]) return;
      final cur = s.note(i);
      final next = secondary
          ? (cur == railsNoteDot ? railsNoteNone : railsNoteDot)
          : switch (cur) {
              railsNoteNone => railsNoteTrack,
              railsNoteTrack => railsNoteDot,
              _ => railsNoteNone,
            };
      final marks = List.of(s.marks);
      // "No track here" clears the track through the cell.
      if (next == railsNoteDot) {
        final fixed = locked(p);
        for (final e in g.incident[i]) {
          if (marks[e] == 1 && !fixed[e]) marks[e] = 0;
        }
      }
      controller.apply(RailsState(marks, s.notes(n)..[i] = next));
    }

    return LoopBoard(
      g: g,
      rows: p.rows,
      cols: p.cols,
      centered: true,
      cellBackground: true,
      cluesOnTop: true,
      margins: const EdgeInsets.fromLTRB(0.4, 0.7, 0.7, 0.4),
      locked: locked(p),
      marks: s.marks,
      enabled: !controller.solved,
      win: controller.winAnimation,
      lineColor: railColor,
      hintCells: controller.flashHints,
      explain: ExplainView.of(controller),
      errorCells: controller.errorCells,
      onCellTap: tapCell,
      // Notes stay under the track and show again once it's gone.
      onCommit: (m) => controller.apply(RailsState(m, s.cells)),
      paintNotes: (canvas, geo) {
        final cell = geo.cell;
        for (var i = 0; i < n; i++) {
          final rect = geo.cellRect(i ~/ p.cols, i % p.cols);
          switch (s.note(i)) {
            case railsNoteTrack:
              canvas.drawRRect(
                RRect.fromRectAndRadius(rect.deflate(cell * 0.14), Radius.circular(cell * 0.1)),
                Paint()..color = railColor.withValues(alpha: 0.28),
              );
            case railsNoteDot when !used[i]:
              canvas.drawCircle(rect.center, cell * 0.07, Paint()..color = ink.withValues(alpha: 0.5));
          }
        }
      },
      paintClues: (canvas, geo) {
        final cell = geo.cell;
        // Sleepers across every piece of track, so lines read as rails.
        final sleeper = Paint()
          ..color = tie
          ..strokeWidth = cell * 0.06
          ..strokeCap = StrokeCap.round;
        void sleepers(Offset a, Offset b) {
          final d = b - a;
          final across = Offset(-d.dy, d.dx) / d.distance * cell * 0.17;
          for (final t in const [0.25, 0.75]) {
            final m = a + d * t;
            canvas.drawLine(m - across, m + across, sleeper);
          }
        }

        final entry = geo.point(p.entry ~/ p.cols, p.entry % p.cols);
        final exit = geo.point(p.exit ~/ p.cols, p.exit % p.cols);
        final stubs = [
          (entry, Offset(geo.origin.dx - cell * 0.4, entry.dy)),
          (exit, Offset(exit.dx, geo.origin.dy + (p.rows + 0.4) * cell)),
        ];
        for (var e = 0; e < g.edgeCount; e++) {
          if (s.marks[e] != 1) continue;
          final (a, b) = g.ends(e);
          sleepers(geo.point(a ~/ p.cols, a % p.cols), geo.point(b ~/ p.cols, b % p.cols));
        }
        // Given pieces and the two ends, in ink.
        final fixed = Paint()
          ..color = ink
          ..strokeWidth = cell * 0.16
          ..strokeCap = StrokeCap.round;
        for (final (a, b) in stubs) {
          sleepers(a, b);
          canvas.drawLine(a, b, fixed);
        }
        for (var i = 0; i < p.given.length; i++) {
          if (!p.given[i]) continue;
          // Up to the cell's border: the rest of the edge is the player's.
          final c = geo.point(i ~/ p.cols, i % p.cols);
          for (final e in g.incident[i]) {
            if (!p.lines[e]) continue;
            final (a, b) = g.ends(e);
            final o = a == i ? b : a;
            canvas.drawLine(c, (c + geo.point(o ~/ p.cols, o % p.cols)) / 2, fixed);
          }
          canvas.drawCircle(c, cell * 0.1, Paint()..color = ink);
        }
        // Counts: columns above the grid, rows on the right.
        void label(int want, int have, Offset at) {
          final tp = TextPainter(
            text: TextSpan(
              text: '$want',
              style: textStyle.copyWith(
                fontSize: cell * 0.4,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withValues(alpha: have == want ? 0.3 : 0.85),
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
          tp.dispose();
        }

        for (var c = 0; c < p.cols; c++) {
          final have = [for (var r = 0; r < p.rows; r++) counted[r * p.cols + c]].where((u) => u).length;
          label(p.colCounts[c], have, Offset(geo.point(0, c).dx, geo.origin.dy - cell * 0.35));
        }
        for (var r = 0; r < p.rows; r++) {
          final have = [for (var c = 0; c < p.cols; c++) counted[r * p.cols + c]].where((u) => u).length;
          label(p.rowCounts[r], have, Offset(geo.origin.dx + (p.cols + 0.35) * cell, geo.point(r, 0).dy));
        }
      },
    );
  }

  @override
  bool get canExplain => true;

  @override
  Explanation? explain(RailsPuzzle puzzle, RailsState state) => explainStep(const RailsExplainer(), puzzle, state);

  @override
  Map<String, dynamic> encodePuzzle(RailsPuzzle puzzle) => puzzle.toJson();
  @override
  RailsPuzzle decodePuzzle(Map<String, dynamic> json) => RailsPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(RailsState state) => state.toJson();
  @override
  RailsState decodeState(Map<String, dynamic> json) => RailsState.fromJson(json);
}
