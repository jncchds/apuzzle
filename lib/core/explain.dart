import '../l10n/l10n.dart';
import 'grid.dart';

// ---- traces ----

/// One deduction recorded by a traced solver: [slot] (a solver-specific
/// piece of knowledge, usually a cell) got [value] by [rule]. A contradiction
/// has slot -1. [deps] are the earlier facts it rests on (by id).
class Fact {
  const Fact(this.id, this.slot, this.value, this.rule, this.premises, this.args, this.deps);

  final int id;
  final int slot;
  final int value;
  final int rule;

  /// Slots the rule read.
  final List<int> premises;

  /// Whatever the text template needs (a row, a count, other cells...).
  final List<int> args;
  final List<int> deps;
}

/// Records what a solver deduces, and from what. Solvers take an optional
/// trace and call [fact] / [fail] as `trace?.fact(...)`, so the arguments
/// aren't even built when nobody is listening.
class ExplainTrace {
  ExplainTrace();

  ExplainTrace.fork(ExplainTrace o)
    : facts = List.of(o.facts),
      _bySlot = {for (final e in o._bySlot.entries) e.key: List.of(e.value)};

  List<Fact> facts = [];
  Map<int, List<int>> _bySlot = {};

  /// The first contradiction, if any.
  Fact? failure;

  List<int> _deps(List<int> premises) => {for (final s in premises) ...?_bySlot[s]}.toList();

  void fact(int slot, int value, int rule, {List<int> premises = const [], List<int> args = const []}) =>
      factWithDeps(slot, value, rule, _deps(premises), premises: premises, args: args);

  void factWithDeps(
    int slot,
    int value,
    int rule,
    List<int> deps, {
    List<int> premises = const [],
    List<int> args = const [],
  }) {
    final f = Fact(facts.length, slot, value, rule, premises, args, deps);
    facts.add(f);
    (_bySlot[slot] ??= []).add(f.id);
  }

  void fail(int rule, {List<int> premises = const [], List<int> args = const []}) =>
      failure ??= Fact(-1, -1, 0, rule, premises, args, _deps(premises));

  /// Every fact [f] rests on, oldest first.
  List<Fact> chainOf(Fact f) {
    final seen = <int>{};
    final todo = [...f.deps];
    while (todo.isNotEmpty) {
      final id = todo.removeLast();
      if (seen.add(id)) todo.addAll(facts[id].deps);
    }
    return [for (final id in seen.toList()..sort()) facts[id]];
  }
}

// ---- explanations ----

/// One sentence of an explanation and the cells it talks about. The text
/// holds tokens (see [cellTok] and friends) that the UI draws as chips.
class ExplainLine {
  const ExplainLine(this.text, [this.cells = const {}]);

  final Tr text;
  final Set<Pos> cells;
}

/// The next step: what to do ([headline], [next]) and why ([why], and for a
/// refuted assumption [suppose] and [probe], ending in the contradiction).
class Explanation {
  const Explanation({
    required this.size,
    required this.headline,
    this.why = const [],
    this.suppose,
    this.probe = const [],
    this.next,
    this.targets = const {},
    this.involved = const {},
    this.edges = const {},
    this.fix = false,
    this.fallback = false,
  });

  final GridSize size;
  final ExplainLine headline;
  final List<ExplainLine> why;
  final ExplainLine? suppose;
  final List<ExplainLine> probe;

  /// The state after the step, or null for a pointer only.
  final Object? next;

  /// Cells the step changes, and cells its reason looks at.
  final Set<Pos> targets;
  final Set<Pos> involved;

  /// Loop edges the step changes (types drawn with lines).
  final Set<int> edges;

  /// Removes a wrong entry.
  final bool fix;

  /// Logic found nothing: the step is revealed from the solution.
  final bool fallback;

  bool get hasDetails => why.isNotEmpty || suppose != null || probe.isNotEmpty;
}

/// A type's bridge between its solver and explanations. [K] is the solver's
/// knowledge (copied for probing). Slots, rules and values in [Fact]s are the
/// solver's own; [describe] turns them into text.
abstract class Explainer<P, S, K> {
  const Explainer();

  GridSize size(P p);

  /// Rule levels, easiest first.
  int get levels;

  /// Whether [level] probes (assume, propagate the level below, refute).
  bool probes(int level) => false;

  /// Knowledge from the board: only entries that agree with the solution.
  K seed(P p, S s);
  K copy(K k);

  /// Records what [k] knows from the start without the board saying so (a
  /// one-cell region holds a 1), so those cells can be steps too.
  void start(P p, K k, ExplainTrace t) {}

  /// Applies the rules of [level] until nothing changes; false on a contradiction.
  bool propagate(P p, K k, int level, ExplainTrace? t);

  /// Assumptions worth probing: (slot, value).
  Iterable<(int, int)> probeCandidates(P p, K k) => const [];

  /// Puts the assumption into [k] (recorded in [t] as rule [ruleAssume]).
  void assume(P p, K k, int slot, int value, ExplainTrace? t) {}

  /// Records in [k] that [slot] can't be [value] (the assumption failed,
  /// already recorded in [t]); follow-ups the solver wouldn't notice by
  /// itself (a single color left) go to [t] too.
  void refute(P p, K k, int slot, int value, ExplainTrace t) {}

  /// The board after [f], or null if the board can't show it (an
  /// elimination, say). Only called for facts that changed [k].
  S? move(P p, S s, Fact f);

  /// Cells [move] changes.
  Set<Pos> targets(P p, Fact f);

  /// Loop edges [move] changes, for boards drawn with lines.
  Set<int> targetEdges(P p, Fact f) => const {};

  /// Facts that go without saying in a chain of reasons (a cell ruled out
  /// next to a placed crown), though they can still be a step of their own.
  bool quiet(P p, Fact f) => false;

  /// Which shown facts to prefer (lower first), e.g. placing a crown over
  /// marking a dot it implies.
  int rank(P p, Fact f) => 0;

  /// The text for a fact, or null for one that goes without saying (a value
  /// ruled out next to a placed one). [ruleAssume] and [ruleRefuted] facts
  /// come here too, as does the [ExplainTrace.failure].
  ExplainLine? describe(P p, Fact f);

  /// The first entry that disagrees with the solution: its cell and the
  /// board without it.
  (Pos, S)? wrongEntry(P p, S s);

  /// The board with one more cell from the solution, or null when full.
  (Pos, S)? reveal(P p, S s);

  /// Whether the board needs nothing more (then there is nothing to explain).
  bool done(P p, S s);
}

/// Rule ids the engine itself records (types use 0 and up).
const int ruleAssume = -2;
const int ruleRefuted = -3;

/// How many refuting probes get traced to pick the shortest story.
const int _probeTries = 6;

/// The next step for [s], or null when there is nothing left to do.
Explanation? explainStep<P, S, K>(Explainer<P, S, K> x, P p, S s) {
  if (x.done(p, s)) return null;
  final size = x.size(p);
  final wrong = x.wrongEntry(p, s);
  if (wrong != null) {
    final (pos, next) = wrong;
    return Explanation(
      size: size,
      headline: ExplainLine((l) => l.exWrong(cellTok(pos)), {pos}),
      next: next,
      targets: {pos},
      fix: true,
    );
  }

  final k = x.seed(p, s);
  final t = ExplainTrace();
  x.start(p, k, t);
  // Refuted assumptions: fact id → (the probe's trace, where it forked).
  final refutedBy = <int, (ExplainTrace, int)>{};
  for (var level = 1; level <= x.levels; level++) {
    final probing = x.probes(level);
    final inner = probing ? level - 1 : level;
    while (true) {
      final ok = x.propagate(p, k, inner, t);
      final best = _best(x, p, s, t);
      if (best != null) return _build(x, p, s, t, best, refutedBy);
      if (!ok || !probing) break;
      final probe = _probe(x, p, k, inner, t);
      if (probe == null) break;
      final (slot, value, fork) = probe;
      final base = t.facts.length;
      final chain = fork.chainOf(fork.failure!);
      t.factWithDeps(slot, value, ruleRefuted, [
        for (final f in chain)
          if (f.id < base) f.id,
      ]);
      refutedBy[t.facts.last.id] = (fork, base);
      x.refute(p, k, slot, value, t);
    }
  }
  final r = x.reveal(p, s);
  if (r == null) return null;
  final (pos, next) = r;
  return Explanation(
    size: size,
    headline: ExplainLine((l) => l.exFallback(cellTok(pos)), {pos}),
    next: next,
    targets: {pos},
    fallback: true,
  );
}

/// The shown fact of the best [Explainer.rank] with the shortest story (then
/// the earliest).
Fact? _best<P, S, K>(Explainer<P, S, K> x, P p, S s, ExplainTrace t) {
  Fact? best;
  var bestRank = 0, bestLen = 0;
  for (final f in t.facts) {
    if (f.rule == ruleAssume || x.move(p, s, f) == null) continue;
    final rank = x.rank(p, f);
    if (best != null && rank > bestRank) continue;
    final len = t.chainOf(f).length;
    if (best == null || rank < bestRank || len < bestLen) {
      best = f;
      bestRank = rank;
      bestLen = len;
    }
  }
  return best;
}

/// A refuting assumption with the shortest contradiction: (slot, value, its trace).
(int, int, ExplainTrace)? _probe<P, S, K>(Explainer<P, S, K> x, P p, K k, int level, ExplainTrace t) {
  (int, int, ExplainTrace)? best;
  var bestLen = 0, tries = 0;
  for (final (slot, value) in x.probeCandidates(p, k)) {
    final kk = x.copy(k);
    x.assume(p, kk, slot, value, null);
    if (x.propagate(p, kk, level, null)) continue;
    final fork = ExplainTrace.fork(t);
    final kt = x.copy(k);
    x.assume(p, kt, slot, value, fork);
    x.propagate(p, kt, level, fork);
    if (fork.failure == null) continue; // shouldn't happen: the same rules ran
    final len = fork.chainOf(fork.failure!).length;
    if (best == null || len < bestLen) {
      best = (slot, value, fork);
      bestLen = len;
    }
    if (++tries >= _probeTries) break;
  }
  return best;
}

Explanation _build<P, S, K>(
  Explainer<P, S, K> x,
  P p,
  S s,
  ExplainTrace t,
  Fact f,
  Map<int, (ExplainTrace, int)> refutedBy,
) {
  final headline = x.describe(p, f) ?? const ExplainLine(_empty);
  final chain = t.chainOf(f);
  final why = [
    for (final c in chain)
      if (!x.quiet(p, c)) ?x.describe(p, c),
  ];
  // The assumption behind the step: its own, or the latest one it rests on.
  final refuted = refutedBy[f.id] ?? [for (final c in chain.reversed) ?refutedBy[c.id]].firstOrNull;
  ExplainLine? suppose;
  var probe = <ExplainLine>[];
  if (refuted != null) {
    final (fork, base) = refuted;
    for (final c in fork.chainOf(fork.failure!)) {
      if (c.id < base) continue; // known before the assumption: told in [why]
      if (c.rule != ruleAssume && x.quiet(p, c)) continue;
      final line = x.describe(p, c);
      if (line == null) continue;
      if (c.rule == ruleAssume) {
        suppose = line;
      } else {
        probe.add(line);
      }
    }
    final fail = x.describe(p, fork.failure!);
    probe = [...probe, ?fail];
  }
  final targets = x.targets(p, f);
  return Explanation(
    size: x.size(p),
    headline: headline,
    why: why,
    suppose: suppose,
    probe: probe,
    next: x.move(p, s, f),
    targets: targets,
    involved: {...headline.cells, for (final l in why) ...l.cells}.difference(targets),
    edges: x.targetEdges(p, f),
  );
}

String _empty(AppLocalizations l) => '';

// ---- tokens ----
// Placeholders in explanation texts are tokens like ⟦c:3:4⟧, so translations
// place them freely and the UI draws them as chips.

/// A cell, shown as "E4" (column letter, row number).
String cellTok(Pos p) => '⟦c:${p.r}:${p.c}⟧';

/// A row number ("4").
String rowTok(int r) => '⟦r:$r⟧';

/// A column letter ("E").
String colTok(int c) => '⟦k:$c⟧';

/// A value, drawn with the board's own symbol.
String valTok(int v) => '⟦v:$v⟧';

/// A rectangle of cells, shown as "A1–C3".
String areaTok(Pos from, Pos to) => '⟦a:${from.r}:${from.c}:${to.r}:${to.c}⟧';

/// One side of a cell ([dir]: 0 top, 1 bottom, 2 left, 3 right), shown as "C4↑".
String sideTok(Pos cell, int dir) => '⟦s:${cell.r}:${cell.c}:$dir⟧';

/// The link between two neighbouring cells' centres, shown as "C3–C4".
String linkTok(Pos a, Pos b) => '⟦j:${a.r}:${a.c}:${b.r}:${b.c}⟧';

/// A few cells (a piece's shape), shown as "A1 A2 B2".
String cellsTok(Iterable<Pos> cells) => '⟦l:${[for (final p in cells) '${p.r}:${p.c}'].join(':')}⟧';

String colName(int c) => String.fromCharCode(0x41 + c);
String cellName(Pos p) => '${colName(p.c)}${p.r + 1}';

sealed class ExplainPart {
  const ExplainPart();
}

class ExplainWords extends ExplainPart {
  const ExplainWords(this.text);
  final String text;
}

class ExplainChip extends ExplainPart {
  const ExplainChip(this.kind, this.args);

  /// c (cell), r (row), k (column), v (value), a (area), l (cell list),
  /// s (cell side), j (link between cells).
  final String kind;
  final List<int> args;

  String get label => switch (kind) {
    'c' => cellName(Pos(args[0], args[1])),
    'r' => '${args[0] + 1}',
    'k' => colName(args[0]),
    'a' => '${cellName(Pos(args[0], args[1]))}–${cellName(Pos(args[2], args[3]))}',
    'l' => [for (var k = 0; k + 1 < args.length; k += 2) cellName(Pos(args[k], args[k + 1]))].join(' '),
    's' => '${cellName(Pos(args[0], args[1]))}${const ['↑', '↓', '←', '→'][args[2]]}',
    'j' => '${cellName(Pos(args[0], args[1]))}–${cellName(Pos(args[2], args[3]))}',
    _ => '',
  };

  /// The cells the chip stands for.
  Set<Pos> cells(GridSize size) => switch (kind) {
    'c' => {Pos(args[0], args[1])},
    'r' => {for (var c = 0; c < size.cols; c++) Pos(args[0], c)},
    'k' => {for (var r = 0; r < size.rows; r++) Pos(r, args[0])},
    'a' => {
      for (var r = args[0]; r <= args[2]; r++)
        for (var c = args[1]; c <= args[3]; c++) Pos(r, c),
    },
    'l' => {for (var k = 0; k + 1 < args.length; k += 2) Pos(args[k], args[k + 1])},
    's' => {Pos(args[0], args[1])},
    'j' => {Pos(args[0], args[1]), Pos(args[2], args[3])},
    _ => const {},
  };
}

final _token = RegExp(r'⟦([a-z]):([-0-9:]*)⟧');

/// Splits an explanation text into words and chips.
List<ExplainPart> parseExplainText(String text) {
  final parts = <ExplainPart>[];
  var at = 0;
  for (final m in _token.allMatches(text)) {
    if (m.start > at) parts.add(ExplainWords(text.substring(at, m.start)));
    parts.add(ExplainChip(m[1]!, [for (final a in m[2]!.split(':')) int.parse(a)]));
    at = m.end;
  }
  if (at < text.length) parts.add(ExplainWords(text.substring(at)));
  return parts;
}
