import 'package:flutter/material.dart';

import '../../core/difficulty.dart';
import '../../core/game_controller.dart';
import '../../core/grid.dart';
import '../../core/puzzle_type.dart';
import '../../ui/board/cell_grid_board.dart';
import 'atoms_generator.dart';
import 'atoms_model.dart';

/// Hashiwokakero: connect atoms with single/double bonds.
class AtomsType extends PuzzleType<AtomsPuzzle, AtomsState> {
  const AtomsType();

  static const bondColor = Color(0xFFE8ECF6);

  @override
  String get id => 'atoms';
  @override
  String get name => 'Atoms';
  @override
  String get tagline => 'Bond every atom to match its number';
  @override
  IconData get icon => Icons.hub_outlined;
  @override
  Color get accent => const Color(0xFF7FB8A4);

  @override
  String get rulesText => '''
• Connect the atoms with horizontal or vertical bonds.
• Each atom needs exactly as many bonds as its number.
• Two atoms can share one or two bonds.
• Bonds can't cross each other or pass through atoms.
• All atoms must end up connected into one molecule.

Drag from an atom towards a neighbour to add a bond (1 → 2 → none). You can also tap the space between two atoms.''';

  @override
  List<GridSize> get sizes => [for (final n in [5, 6, 7, 8, 9, 10]) GridSize.square(n)];
  @override
  GridSize get defaultSize => const GridSize.square(7);
  @override
  double get controlsHeight => 40;

  @override
  AtomsPuzzle generate(GenParams params) => generateAtoms(params);
  @override
  AtomsState initialState(AtomsPuzzle puzzle) => AtomsState(List.filled(puzzle.edges.length, 0));

  List<int> _sums(AtomsPuzzle p, List<int> bonds) {
    final s = List<int>.filled(p.islands.length, 0);
    for (var e = 0; e < p.edges.length; e++) {
      s[p.edges[e].a] += bonds[e];
      s[p.edges[e].b] += bonds[e];
    }
    return s;
  }

  @override
  bool isComplete(AtomsPuzzle puzzle, AtomsState state) {
    final s = _sums(puzzle, state.bonds);
    for (var k = 0; k < s.length; k++) {
      if (s[k] != puzzle.numbers[k]) return false;
    }
    return true;
  }

  @override
  bool isSolved(AtomsPuzzle puzzle, AtomsState state) => atomsSolved(puzzle, state.bonds);

  @override
  Set<Pos> conflicts(AtomsPuzzle puzzle, AtomsState state) {
    final bad = atomsConflicts(puzzle, state.bonds);
    if (bad.isEmpty && isComplete(puzzle, state) && !atomsConnected(puzzle, state.bonds)) {
      bad.addAll(List.generate(puzzle.islands.length, (k) => k));
    }
    return {for (final k in bad) puzzle.size.pos(puzzle.islands[k])};
  }

  @override
  HintResult<AtomsState>? hint(AtomsPuzzle puzzle, AtomsState state) {
    for (var e = 0; e < puzzle.edges.length; e++) {
      if (state.bonds[e] != puzzle.solution[e]) {
        final b = List.of(state.bonds)..[e] = puzzle.solution[e];
        final ed = puzzle.edges[e];
        return HintResult(AtomsState(b), {puzzle.size.pos(puzzle.islands[ed.a]), puzzle.size.pos(puzzle.islands[ed.b])});
      }
    }
    return null;
  }

  static void cycle(GameController ctrl, int e) {
    final p = ctrl.puzzle as AtomsPuzzle;
    final s = ctrl.state as AtomsState;
    final next = (s.bonds[e] + 1) % 3;
    if (s.bonds[e] == 0) {
      final crossing = atomCrossings(p.cols, p.islands, p.edges)[e].any((f) => s.bonds[f] > 0);
      if (crossing) {
        ctrl.showToast("Bonds can't cross");
        return;
      }
    }
    ctrl.apply(AtomsState(List.of(s.bonds)..[e] = next));
  }

  @override
  Widget buildBoard(BuildContext context, GameController controller) => _AtomsBoard(controller: controller);

  @override
  Map<String, dynamic> encodePuzzle(AtomsPuzzle puzzle) => puzzle.toJson();
  @override
  AtomsPuzzle decodePuzzle(Map<String, dynamic> json) => AtomsPuzzle.fromJson(json);
  @override
  Map<String, dynamic> encodeState(AtomsState state) => state.toJson();
  @override
  AtomsState decodeState(Map<String, dynamic> json) => AtomsState.fromJson(json);
}

class _AtomsBoard extends StatefulWidget {
  const _AtomsBoard({required this.controller});
  final GameController controller;

  @override
  State<_AtomsBoard> createState() => _AtomsBoardState();
}

class _AtomsBoardState extends State<_AtomsBoard> {
  int? _fromIsland;
  Offset? _startPx;
  Offset? _lastPx;

  GameController get ctrl => widget.controller;
  AtomsPuzzle get p => ctrl.puzzle as AtomsPuzzle;

  int? _islandAt(Pos pos) {
    final k = p.islands.indexOf(p.size.index(pos));
    return k < 0 ? null : k;
  }

  /// Edge from island [k] in direction (dr, dc).
  int? _edgeFrom(int k, int dr, int dc) {
    for (var e = 0; e < p.edges.length; e++) {
      final ed = p.edges[e];
      if (ed.horizontal != (dr == 0)) continue;
      final forward = dr > 0 || dc > 0;
      if ((forward && ed.a == k) || (!forward && ed.b == k)) return e;
    }
    return null;
  }

  /// Edge whose open segment covers [pos].
  List<int> _edgesThrough(Pos pos) {
    final out = <int>[];
    for (var e = 0; e < p.edges.length; e++) {
      final ed = p.edges[e];
      final a = p.size.pos(p.islands[ed.a]), b = p.size.pos(p.islands[ed.b]);
      if (ed.horizontal && pos.r == a.r && pos.c > a.c && pos.c < b.c) out.add(e);
      if (!ed.horizontal && pos.c == a.c && pos.r > a.r && pos.r < b.r) out.add(e);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final s = ctrl.state as AtomsState;
    final sums = List<int>.filled(p.islands.length, 0);
    for (var e = 0; e < p.edges.length; e++) {
      sums[p.edges[e].a] += s.bonds[e];
      sums[p.edges[e].b] += s.bonds[e];
    }
    final errors = ctrl.errorCells;

    return CellGridBoard(
      rows: p.rows,
      cols: p.cols,
      gapRatio: 0,
      maxCell: 80,
      win: ctrl.winAnimation,
      onTap: ctrl.solved
          ? null
          : (pos) {
              if (_islandAt(pos) != null) return;
              final through = _edgesThrough(pos);
              final withBond = through.where((e) => s.bonds[e] > 0).toList();
              final pick = withBond.isNotEmpty ? withBond : through;
              if (pick.length == 1) AtomsType.cycle(ctrl, pick.single);
            },
      onDragStart: ctrl.solved
          ? null
          : (pos, local) {
              _fromIsland = _islandAt(pos);
              _startPx = local;
              _lastPx = local;
            },
      onDragUpdate: (_, local) => _lastPx = local,
      onDragEnd: () {
        final k = _fromIsland, a = _startPx, b = _lastPx;
        _fromIsland = null;
        if (k == null || a == null || b == null) return;
        final d = b - a;
        if (d.distance < 12) return;
        final (dr, dc) = d.dx.abs() > d.dy.abs() ? (0, d.dx > 0 ? 1 : -1) : (d.dy > 0 ? 1 : -1, 0);
        final e = _edgeFrom(k, dr, dc);
        if (e != null) AtomsType.cycle(ctrl, e);
      },
      underlayBuilder: (context, m) => [
        Positioned.fill(
          child: CustomPaint(
            painter: _BondPainter(
              p: p,
              bonds: s.bonds,
              m: m,
              grid: scheme.outlineVariant.withValues(alpha: 0.35),
              bond: scheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
      cellBuilder: (context, pos, m) {
        final k = _islandAt(pos);
        if (k == null) return const SizedBox.expand();
        final done = sums[k] == p.numbers[k];
        final err = errors.contains(pos);
        final hinted = ctrl.flashHints.contains(pos);
        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: m.cell * 0.78,
            height: m.cell * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? scheme.onSurface : scheme.surface,
              border: Border.all(
                color: err
                    ? scheme.error
                    : hinted
                        ? scheme.tertiary
                        : scheme.onSurface,
                width: err || hinted ? 3.5 : 2.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '${p.numbers[k]}',
              style: TextStyle(
                fontSize: m.cell * 0.38,
                fontWeight: FontWeight.w800,
                color: done ? scheme.surface : scheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BondPainter extends CustomPainter {
  _BondPainter({required this.p, required this.bonds, required this.m, required this.grid, required this.bond});

  final AtomsPuzzle p;
  final List<int> bonds;
  final BoardMetrics m;
  final Color grid;
  final Color bond;

  @override
  void paint(Canvas canvas, Size size) {
    final gp = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var r = 0; r < m.rows; r++) {
      final y = m.center(Pos(r, 0)).dy;
      canvas.drawLine(Offset(m.cell / 2, y), Offset(m.width - m.cell / 2, y), gp);
    }
    for (var c = 0; c < m.cols; c++) {
      final x = m.center(Pos(0, c)).dx;
      canvas.drawLine(Offset(x, m.cell / 2), Offset(x, m.height - m.cell / 2), gp);
    }
    final bp = Paint()
      ..color = bond
      ..strokeWidth = m.cell * 0.09
      ..strokeCap = StrokeCap.round;
    for (var e = 0; e < p.edges.length; e++) {
      final count = bonds[e];
      if (count == 0) continue;
      final ed = p.edges[e];
      final a = m.center(p.size.pos(p.islands[ed.a])), b = m.center(p.size.pos(p.islands[ed.b]));
      final off = ed.horizontal ? Offset(0, m.cell * 0.12) : Offset(m.cell * 0.12, 0);
      if (count == 1) {
        canvas.drawLine(a, b, bp);
      } else {
        canvas.drawLine(a + off, b + off, bp);
        canvas.drawLine(a - off, b - off, bp);
      }
    }
  }

  @override
  bool shouldRepaint(_BondPainter old) => true;
}
