import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/grid.dart';
import '../../l10n/l10n.dart';
import '../../ui/board/cell_grid_board.dart';
import 'formula_model.dart';

/// Marks are told apart by shape as well as color: filled, outlined, faded.
const formulaCorrectColor = Color(0xFF2E9E6B);
const formulaPresentColor = Color(0xFFE9A621);

/// A symbol typed on the keys or a keyboard.
typedef FormulaInput = void Function(String symbol);

/// The rows of guesses with their marks, then the row being typed. Also
/// takes a hardware keyboard.
class FormulaBoard extends StatefulWidget {
  const FormulaBoard({
    super.key,
    required this.puzzle,
    required this.state,
    this.hinted = const {},
    this.win,
    this.onSymbol,
    this.onBackspace,
    this.onEnter,
    this.onMove,
  });

  final FormulaPuzzle puzzle;
  final FormulaState state;
  final Set<Pos> hinted;
  final Animation<double>? win;

  /// Null callbacks: the board only shows.
  final FormulaInput? onSymbol;
  final VoidCallback? onBackspace;
  final VoidCallback? onEnter;

  /// Moves the cursor to a column of the typed row.
  final void Function(int col)? onMove;

  @override
  State<FormulaBoard> createState() => _FormulaBoardState();
}

class _FormulaBoardState extends State<FormulaBoard> {
  final _focus = FocusNode(debugLabel: 'formula board');

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  /// The symbol a typed character stands for, if the board has its key.
  String? _symbolOf(String? character) {
    final symbol = switch (character?.toLowerCase()) {
      'x' => '*',
      ':' => '/',
      's' || '^' => formulaSquare,
      'c' => formulaCube,
      final ch => ch,
    };
    if (symbol == null || symbol.length != 1) return null;
    return '$formulaDigits${widget.puzzle.ops}='.contains(symbol) ? symbol : null;
  }

  KeyEventResult _key(FocusNode _, KeyEvent e) {
    final w = widget;
    if (e is! KeyDownEvent && e is! KeyRepeatEvent || w.onSymbol == null) return KeyEventResult.ignored;
    switch (e.logicalKey) {
      case LogicalKeyboardKey.enter || LogicalKeyboardKey.numpadEnter:
        w.onEnter?.call();
      case LogicalKeyboardKey.backspace || LogicalKeyboardKey.delete:
        w.onBackspace?.call();
      case LogicalKeyboardKey.arrowLeft:
        w.onMove?.call(max(0, w.state.cursor - 1));
      case LogicalKeyboardKey.arrowRight:
        w.onMove?.call(min(w.puzzle.cols - 1, w.state.cursor + 1));
      default:
        final symbol = _symbolOf(e.character);
        if (symbol == null) return KeyEventResult.ignored;
        w.onSymbol!(symbol);
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.puzzle, s = widget.state;
    final marks = [for (final g in s.guesses) formulaMarks(p.answer, g)];
    final typing = widget.onSymbol != null;
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _key,
      child: CellGridBoard(
        rows: p.rows,
        cols: p.cols,
        win: widget.win,
        maxCell: 64,
        onTap: (pos) {
          _focus.requestFocus();
          if (pos.r == s.guesses.length) widget.onMove?.call(pos.c);
        },
        cellBuilder: (context, pos, m) {
          final guessed = pos.r < s.guesses.length;
          final current = pos.r == s.guesses.length;
          final symbol = guessed ? s.guesses[pos.r][pos.c] : (current ? s.row[pos.c] : formulaBlank);
          return FormulaTile(
            size: m.cell,
            symbol: symbol,
            mark: guessed ? marks[pos.r][pos.c] : null,
            idle: !guessed && !(current && typing),
            cursor: current && typing && pos.c == s.cursor,
            hinted: widget.hinted.contains(pos),
          );
        },
      ),
    );
  }
}

/// One tile of the board or key of the keyboard.
class FormulaTile extends StatelessWidget {
  const FormulaTile({
    super.key,
    required this.size,
    required this.symbol,
    this.mark,
    this.idle = false,
    this.cursor = false,
    this.hinted = false,
    this.height,
  });

  final double size;
  final String symbol;

  /// Null: not guessed yet.
  final FormulaMark? mark;

  /// A row that isn't played yet.
  final bool idle;
  final bool cursor;
  final bool hinted;

  /// Keys are taller than wide.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final power = symbol == formulaSquare || symbol == formulaCube;
    final (bg, fg, border, width) = switch (mark) {
      FormulaMark.correct => (formulaCorrectColor, Colors.white, formulaCorrectColor, 1.2),
      FormulaMark.present => (
        Color.alphaBlend(formulaPresentColor.withValues(alpha: 0.16), scheme.surfaceContainer),
        scheme.onSurface,
        formulaPresentColor,
        max(2.0, size * 0.08),
      ),
      FormulaMark.absent => (
        scheme.surfaceContainer.withValues(alpha: 0.45),
        scheme.onSurface.withValues(alpha: 0.34),
        scheme.outlineVariant.withValues(alpha: 0.3),
        1.2,
      ),
      null => (
        idle ? scheme.surfaceContainer.withValues(alpha: 0.5) : scheme.surfaceContainerHigh,
        scheme.onSurface,
        cursor
            ? scheme.primary
            : hinted
            ? scheme.tertiary
            : scheme.outlineVariant.withValues(alpha: idle ? 0.35 : 0.8),
        cursor || hinted ? max(2.0, size * 0.07) : 1.2,
      ),
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(color: border, width: width),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Text(
          symbol == formulaBlank ? '' : formulaGlyph(symbol),
          key: ValueKey(symbol),
          // The raised ² and ³ are small glyphs.
          style: TextStyle(fontSize: size * (power ? 0.8 : 0.52), height: 1, fontWeight: FontWeight.w600, color: fg),
        ),
      ),
    );
  }
}

/// The on-screen keys: digits, the level's operators and "=", then
/// backspace and enter. Each key carries the best mark its symbol has got.
class FormulaKeys extends StatelessWidget {
  const FormulaKeys({
    super.key,
    required this.puzzle,
    required this.state,
    required this.onSymbol,
    required this.onBackspace,
    required this.onEnter,
  });

  final FormulaPuzzle puzzle;
  final FormulaState state;
  final FormulaInput onSymbol;
  final VoidCallback onBackspace;
  final VoidCallback onEnter;

  static const double keyHeight = 42;
  static const double _gap = 5;

  /// Keys are narrow: their symbols are sized by this, not by the width.
  static const double _keyGlyph = 36;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final known = formulaKnown(puzzle, state);
    return LayoutBuilder(
      builder: (context, cons) {
        final width = min(cons.maxWidth, 440.0);
        final key = ((width - 9 * _gap) / 10).floorToDouble();

        Widget row(String symbols, double keyWidth) => Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _gap,
          children: [
            for (final symbol in symbols.split(''))
              SizedBox(
                width: keyWidth,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSymbol(symbol),
                  child: FormulaTile(size: _keyGlyph, height: keyHeight, symbol: symbol, mark: known[symbol]),
                ),
              ),
          ],
        );

        final ops = '${puzzle.ops}=';
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: _gap,
          children: [
            row(formulaDigits, key),
            // Few operators get wider keys.
            row(ops, min(key * 1.6, ((width - (ops.length - 1) * _gap) / ops.length).floorToDouble())),
            SizedBox(
              width: key * 10 + _gap * 9,
              height: keyHeight,
              child: Row(
                spacing: _gap,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBackspace,
                      style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Icon(Icons.backspace_outlined, size: 20),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: onEnter,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(l.submit, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
