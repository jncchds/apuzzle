import 'shikaku_model.dart';

/// Candidate-rectangle solver.
///  Tier 1: single-candidate clues, cells coverable by only one clue, cells
///          common to all candidates of a clue.
///  Tier 2: + probing each candidate.
class ShikakuSolver {
  ShikakuSolver(this.rows, this.cols, this.clues) {
    for (var i = 0; i < rows * cols; i++) {
      if (clues[i] != null) clueCells.add(i);
    }
    for (final ci in clueCells) {
      final a = clues[ci]!, r = ci ~/ cols, c = ci % cols;
      final list = <CellRect>[];
      for (var h = 1; h <= a; h++) {
        if (a % h != 0) continue;
        final w = a ~/ h;
        if (h > rows || w > cols) continue;
        for (var r0 = r - h + 1; r0 <= r; r0++) {
          for (var c0 = c - w + 1; c0 <= c; c0++) {
            if (r0 < 0 || c0 < 0 || r0 + h > rows || c0 + w > cols) continue;
            final rect = CellRect(r0, c0, r0 + h - 1, c0 + w - 1);
            if (rect.cells(cols).every((i) => i == ci || clues[i] == null)) list.add(rect);
          }
        }
      }
      candidates.add(list);
    }
  }

  final int rows;
  final int cols;
  final List<int?> clues;
  final List<int> clueCells = [];
  final List<List<CellRect>> candidates = [];

  /// Returns the chosen rectangle per clue if solved by logic, else null.
  List<CellRect>? solveLogic(int tier) {
    final cand = [for (final c in candidates) List.of(c)];
    return _propagate(cand, tier) && cand.every((c) => c.length == 1) ? [for (final c in cand) c.single] : null;
  }

  bool _propagate(List<List<CellRect>> cand, int tier) {
    final n = rows * cols;
    while (true) {
      var progress = false;
      // Placed rectangles exclude overlapping candidates of other clues.
      for (var k = 0; k < cand.length; k++) {
        if (cand[k].isEmpty) return false;
        if (cand[k].length != 1) continue;
        final fixed = cand[k].single;
        for (var o = 0; o < cand.length; o++) {
          if (o == k) continue;
          final before = cand[o].length;
          cand[o].removeWhere((r) => r.overlaps(fixed));
          if (cand[o].isEmpty) return false;
          if (cand[o].length != before) progress = true;
        }
      }
      if (progress) continue;

      // Cell ownership.
      final coverers = List.generate(n, (_) => <int>{});
      for (var k = 0; k < cand.length; k++) {
        for (final r in cand[k]) {
          for (final i in r.cells(cols)) {
            coverers[i].add(k);
          }
        }
      }
      for (var i = 0; i < n; i++) {
        if (coverers[i].isEmpty) return false;
        if (coverers[i].length == 1) {
          final k = coverers[i].single;
          final rr = i ~/ cols, cc = i % cols;
          final before = cand[k].length;
          cand[k].removeWhere((r) => !r.contains(rr, cc));
          if (cand[k].isEmpty) return false;
          if (cand[k].length != before) progress = true;
        }
      }
      // Cells common to every candidate of a clue belong to it.
      for (var k = 0; k < cand.length; k++) {
        if (cand[k].length < 2) continue;
        final common = cand[k].first.cells(cols).toSet();
        for (final r in cand[k].skip(1)) {
          common.retainAll(r.cells(cols));
        }
        for (final i in common) {
          final rr = i ~/ cols, cc = i % cols;
          for (var o = 0; o < cand.length; o++) {
            if (o == k) continue;
            final before = cand[o].length;
            cand[o].removeWhere((r) => r.contains(rr, cc));
            if (cand[o].isEmpty) return false;
            if (cand[o].length != before) progress = true;
          }
        }
      }
      if (progress) continue;
      if (cand.every((c) => c.length == 1)) return true;
      if (tier < 2) return true;

      for (var k = 0; k < cand.length && !progress; k++) {
        if (cand[k].length < 2) continue;
        for (final r in List.of(cand[k])) {
          final trial = [for (final c in cand) List.of(c)]..[k] = [r];
          if (!_propagate(trial, 1)) {
            cand[k].remove(r);
            progress = true;
          }
        }
        if (cand[k].isEmpty) return false;
      }
      if (!progress) return true;
    }
  }

  /// Up to [limit] complete solutions.
  List<List<CellRect>> solutions({int limit = 2}) {
    final out = <List<CellRect>>[];
    final covered = List<bool>.filled(rows * cols, false);
    final chosen = List<CellRect?>.filled(cand0.length, null);
    void rec() {
      if (out.length >= limit) return;
      var best = -1;
      List<CellRect>? bestList;
      for (var k = 0; k < cand0.length; k++) {
        if (chosen[k] != null) continue;
        final ok = [for (final r in cand0[k]) if (r.cells(cols).every((i) => !covered[i])) r];
        if (ok.isEmpty) return;
        if (bestList == null || ok.length < bestList.length) {
          best = k;
          bestList = ok;
          if (ok.length == 1) break;
        }
      }
      if (best < 0) {
        out.add([for (final c in chosen) c!]);
        return;
      }
      for (final r in bestList!) {
        chosen[best] = r;
        for (final i in r.cells(cols)) {
          covered[i] = true;
        }
        rec();
        for (final i in r.cells(cols)) {
          covered[i] = false;
        }
        chosen[best] = null;
        if (out.length >= limit) return;
      }
    }

    rec();
    return out;
  }

  List<List<CellRect>> get cand0 => candidates;
}
