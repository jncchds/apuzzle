import 'dart:typed_data';

import 'inlay_model.dart';

/// One orientation of a piece for the search: its cells relative to its
/// first cell in reading order (so it can be laid with that cell on the
/// first empty cell of the board).
class _Form {
  _Form(this.o, List<Cell> cells) {
    var first = cells.first;
    for (final cell in cells) {
      if (cell.$1 < first.$1 || cell.$1 == first.$1 && cell.$2 < first.$2) first = cell;
    }
    fr = first.$1;
    fc = first.$2;
    dr = [for (final (r, _) in cells) r - fr];
    dc = [for (final (_, c) in cells) c - fc];
  }

  final int o;
  late final int fr, fc;
  late final List<int> dr, dc;
}

/// Exact cover search: always fill the first empty cell in reading order
/// (the piece that covers it has it as its own first cell), using one piece
/// of each group of equal pieces at a time, and dropping branches that wall
/// in a pocket smaller than every piece left.
class InlaySolver {
  InlaySolver(this.p) {
    final n = p.pieces.length;
    _forms = List.generate(n, (k) {
      final seen = <String>{};
      return [
        for (var o = 0; o < p.orientations; o++)
          if (seen.add(cellsKey(p.cellsOf(k, o)))) _Form(o, p.cellsOf(k, o)),
      ];
    });
    // Equal pieces (the same under the allowed orientations) are one group.
    final keyOf = [
      for (var k = 0; k < n; k++) ([for (final f in _forms[k]) cellsKey(p.cellsOf(k, f.o))]..sort()).first,
    ];
    _group = List.filled(n, 0);
    final ids = <String, int>{};
    for (var k = 0; k < n; k++) {
      _group[k] = ids.putIfAbsent(keyOf[k], () => ids.length);
    }
  }

  final InlayPuzzle p;
  late final List<List<_Form>> _forms;
  late final List<int> _group;

  late Int8List _grid; // 1: not to fill (outside, hole or covered)
  late List<bool> _used;
  late List<(int, int)?> _place;
  late Int32List _seen;
  int _stamp = 0;
  int _nodes = 0;
  int _cap = 0;
  bool _aborted = false;

  /// Search nodes of the last call.
  int get nodes => _nodes;

  void _reset(List<(int, int)?> fixed, int cap) {
    _grid = Int8List(p.cells);
    for (var i = 0; i < p.cells; i++) {
      if (!p.shape[i]) _grid[i] = 1;
    }
    _used = List.filled(p.pieces.length, false);
    _place = List.filled(p.pieces.length, null);
    _seen = Int32List(p.cells);
    _stamp = 0;
    _nodes = 0;
    _cap = cap;
    _aborted = false;
    for (var k = 0; k < fixed.length; k++) {
      final f = fixed[k];
      if (f == null) continue;
      _used[k] = true;
      _place[k] = f;
      for (final i in p.cover(k, f.$1, f.$2 ~/ p.cols, f.$2 % p.cols)!) {
        _grid[i] = 1;
      }
    }
  }

  int _minLeft() {
    var m = 1 << 20;
    for (var k = 0; k < p.pieces.length; k++) {
      if (!_used[k] && p.pieces[k].length < m) m = p.pieces[k].length;
    }
    return m;
  }

  /// Size of the empty pocket around [start], counted up to [enough].
  int _pocket(int start, int enough) {
    _stamp++;
    final stack = [start];
    _seen[start] = _stamp;
    var size = 0;
    while (stack.isNotEmpty) {
      final i = stack.removeLast();
      if (++size >= enough) return size;
      final r = i ~/ p.cols, c = i % p.cols;
      void visit(int j) {
        if (_grid[j] == 0 && _seen[j] != _stamp) {
          _seen[j] = _stamp;
          stack.add(j);
        }
      }

      if (r > 0) visit(i - p.cols);
      if (r < p.rows - 1) visit(i + p.cols);
      if (c > 0) visit(i - 1);
      if (c < p.cols - 1) visit(i + 1);
    }
    return size;
  }

  /// Whether some empty cell next to [cells] lies in a pocket too small for
  /// any piece left.
  bool _walledIn(List<int> cells) {
    final min = _minLeft();
    if (min <= 1) return false;
    for (final i in cells) {
      final r = i ~/ p.cols, c = i % p.cols;
      for (final j in [
        if (r > 0) i - p.cols,
        if (r < p.rows - 1) i + p.cols,
        if (c > 0) i - 1,
        if (c < p.cols - 1) i + 1,
      ]) {
        if (_grid[j] == 0 && _pocket(j, min) < min) return true;
      }
    }
    return false;
  }

  /// Calls [found] for each cover; it returns false to stop.
  bool _search(int from, bool Function() found) {
    if (++_nodes > _cap) {
      _aborted = true;
      return false;
    }
    var e = from;
    while (e < p.cells && _grid[e] != 0) {
      e++;
    }
    if (e == p.cells) return found();
    final er = e ~/ p.cols, ec = e % p.cols;
    final tried = <int>{};
    for (var k = 0; k < p.pieces.length; k++) {
      if (_used[k] || !tried.add(_group[k])) continue;
      for (final f in _forms[k]) {
        final cells = <int>[];
        var ok = true;
        for (var j = 0; j < f.dr.length; j++) {
          final r = er + f.dr[j], c = ec + f.dc[j];
          if (r < 0 || c < 0 || r >= p.rows || c >= p.cols || _grid[r * p.cols + c] != 0) {
            ok = false;
            break;
          }
          cells.add(r * p.cols + c);
        }
        if (!ok) continue;
        for (final i in cells) {
          _grid[i] = 1;
        }
        _used[k] = true;
        _place[k] = (f.o, (er - f.fr) * p.cols + ec - f.fc);
        final go = _walledIn(cells) || _search(e + 1, found);
        _used[k] = false;
        _place[k] = null;
        for (final i in cells) {
          _grid[i] = 0;
        }
        if (!go) return false;
      }
    }
    return true;
  }

  /// A cover that keeps the [fixed] pieces where they are (orientation and
  /// top-left cell, null for the rest), or null if there is none or the
  /// search took more than [cap] nodes (then [aborted] is set).
  List<(int, int)>? complete(List<(int, int)?> fixed, {int cap = 200000}) {
    _reset(fixed, cap);
    List<(int, int)>? out;
    _search(0, () {
      out = [for (final x in _place) x!];
      return false;
    });
    return out;
  }

  /// Whether the last search stopped at its node cap.
  bool get aborted => _aborted;

  /// Covers of the empty board, counted up to [limit] (pieces of one group
  /// swapping places count once), or null if the search took more than
  /// [cap] nodes before that.
  int? count({int limit = 2, int cap = 200000}) {
    _reset(List.filled(p.pieces.length, null), cap);
    var n = 0;
    _search(0, () => ++n < limit);
    return _aborted ? null : n;
  }
}
