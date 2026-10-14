import 'package:apuzzle/core/difficulty.dart';
import 'package:apuzzle/core/grid.dart';
import 'package:apuzzle/core/puzzle_code.dart';
import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/puzzles/junction/junction_generator.dart';
import 'package:apuzzle/puzzles/junction/junction_model.dart';
import 'package:apuzzle/puzzles/junction/junction_tutorial.dart';
import 'package:apuzzle/puzzles/junction/junction_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/timing.dart';

/// One switch on 5×5 (cell 12): up to station 0 (cell 4), down to station 1 (cell 24).
JunctionPuzzle _fork({List<int> trains = const [0, 1], int gap = 3}) => junctionPractice(
  5,
  5,
  10,
  const [
    [10, 11, 12, 7, 2, 3, 4],
    [12, 17, 22, 23, 24],
  ],
  stations: const [4, 24],
  trains: trains,
  start: const [0],
  gap: gap,
);

JunctionState _run(JunctionPuzzle p, JunctionState s, int steps) {
  for (var k = 0; k < steps; k++) {
    s = junctionStep(p, s);
  }
  return s;
}

/// Plays the perfect player to the end.
JunctionState _auto(JunctionPuzzle p) {
  var s = JunctionState.initial(p);
  for (var k = 0; k < 100000; k++) {
    final next = junctionAuto(p, s);
    if (next == null) return s;
    s = next;
  }
  fail('did not finish');
}

void main() {
  const type = JunctionType();

  test('trains leave the depot on schedule and follow the track', () {
    final p = _fork();
    var s = JunctionState.initial(p);
    expect(s.trains, isEmpty);
    s = junctionStep(p, s);
    expect(s.trains.single.cell, 10);
    expect(s.trains.single.from, -1);
    expect(s.trains.single.color, 0);
    s = _run(p, s, 2);
    expect(s.trains.single.cell, 12, reason: 'on the switch');
    expect(s.trains.length, 1, reason: 'the next one leaves 3 steps later');
    s = junctionStep(p, s);
    expect(s.trains.first.cell, 7, reason: 'setting 0 is the first branch, up');
    expect(s.trains.last.cell, 10);
    expect(s.trains.last.color, 1);
  });

  test('a switch routes a train the way it is set as the train leaves it', () {
    final p = _fork(trains: const [1]);
    var s = _run(p, JunctionState.initial(p), 3);
    expect(s.trains.single.cell, 12);
    s = junctionFlip(p, s, 0);
    expect(s.settings, [1]);
    s = junctionStep(p, s);
    expect(s.trains.single.cell, 17);
    // Flipping back once it has left changes nothing for it.
    s = junctionFlip(p, s, 0);
    s = _run(p, s, 3);
    expect(s.trains, isEmpty);
    expect(s.arrived.single.station, 1);
    expect(s.arrived.single.ok, isTrue);
    expect(s.score, 1);
    expect(junctionOver(p, s), isTrue);
    expect(type.isSolved(p, s), isTrue);
  });

  test('a wrong station is a miss, and ends a practice board unsolved', () {
    final p = _fork(trains: const [1, 0]);
    final s = _run(p, JunctionState.initial(p), 7);
    expect(s.arrived.single.station, 0);
    expect(s.arrived.single.ok, isFalse);
    expect(s.misses, 1);
    expect(s.score, 0);
    expect(type.isComplete(p, s), isTrue);
    expect(type.isSolved(p, s), isFalse);
    expect(junctionStep(p, s), same(s), reason: 'over');
  });

  test('a real game goes on after a miss, and is a finish at the end', () {
    final p = type.generate(const GenParams(size: GridSize.square(8), difficulty: Difficulty.easy, seed: 3));
    var s = type.initialState(p);
    while (!type.isComplete(p, s)) {
      s = junctionStep(p, s); // never touching a switch
    }
    expect(s.arrived.length, junctionTrainCount);
    expect(s.misses, greaterThan(0));
    expect(s.score + s.misses, junctionTrainCount);
    expect(type.isSolved(p, s), isTrue);
    expect(type.score(p, s), s.score);
  });

  test('a timed round ends when the time is up', () {
    final p = type.generate(
      const GenParams(size: GridSize.square(8), difficulty: Difficulty.medium, seed: 4, options: {'goal': 'timed'}),
    );
    expect(p.goal, JunctionGoal.timed);
    expect(p.ticks * p.stepMs, closeTo(junctionRoundSeconds * 1000, p.stepMs));
    final s = _auto(p);
    expect(s.tick, p.ticks);
    expect(s.misses, 0);
    expect(s.score, greaterThan(10));
  });

  for (final size in type.sizes) {
    for (final d in Difficulty.values) {
      test('${size.label} ${d.name}: a valid network, the perfect player scores every train', () {
        for (var seed = 1; seed <= 6; seed++) {
          final params = GenParams(size: size, difficulty: d, seed: seed);
          final p = type.generate(params);
          if (seed == 1) expect(type.generate(params).toJson(), p.toJson(), reason: 'deterministic');
          _checkNetwork(p, junctionStations(size, d));
          final s = _auto(p);
          expect(s.score, junctionTrainCount, reason: 'seed $seed');
          expect(s.misses, 0);
          expect(_auto(p).toJson(), s.toJson(), reason: 'replays the same trains');
        }
      });
    }
  }

  test('bigger boards and harder levels get more stations, faster and closer trains', () {
    expect(junctionStations(const GridSize.square(7), Difficulty.easy), 3);
    expect(junctionStations(const GridSize.square(12), Difficulty.hard), 8);
    expect(junctionSpeed(Difficulty.hard), lessThan(junctionSpeed(Difficulty.easy)));
    expect(junctionGaps(Difficulty.hard).$2, lessThan(junctionGaps(Difficulty.easy).$2));
    for (final d in Difficulty.values) {
      final size = type.dailySize(d);
      expect(type.sizes, contains(size));
      expect(size.rows * type.minCellSize, lessThanOrEqualTo(360));
    }
  });

  test('generation is fast', () {
    final watch = Stopwatch()..start();
    var n = 0;
    for (final size in type.sizes) {
      for (final d in Difficulty.values) {
        for (var seed = 20; seed < 23; seed++) {
          type.generate(GenParams(size: size, difficulty: d, seed: seed));
          n++;
        }
      }
    }
    expect(watch.elapsedMilliseconds / n, lessThan(timeLimit(150)));
  });

  test('state survives a save round trip', () {
    final p = type.generate(const GenParams(size: GridSize.square(10), difficulty: Difficulty.hard, seed: 9));
    var s = type.initialState(p);
    for (var k = 0; k < 60; k++) {
      s = type.hint(p, s)!.state;
    }
    expect(s.trains, isNotEmpty);
    expect(s.arrived, isNotEmpty);
    expect(type.decodeState(type.encodeState(s)).toJson(), s.toJson());
    expect(type.decodePuzzle(type.encodePuzzle(p)).toJson(), p.toJson());
    final t = tutorialPuzzle();
    expect(type.decodePuzzle(type.encodePuzzle(t)).toJson(), t.toJson());
  });

  test('share codes carry the goal', () {
    const params = GenParams(
      size: GridSize.square(9),
      difficulty: Difficulty.easy,
      seed: 77,
      options: {'goal': 'timed'},
    );
    final code = PuzzleCode.format(type, params);
    expect(PuzzleCode.parse(code, puzzleTypes).params.options, {'goal': 'timed'});
  });
}

JunctionPuzzle tutorialPuzzle() => const JunctionType().tutorial().first.puzzle as JunctionPuzzle;

/// A tree from the depot on the edge: every switch has two branches, every
/// station is a leaf reached by setting the switches on its way, tracks only
/// touch along the track, and switches keep their distance.
void _checkNetwork(JunctionPuzzle p, int stations) {
  final rows = p.rows, cols = p.cols;
  expect(p.parent.length, rows * cols);
  final d = p.depot;
  expect(d, greaterThanOrEqualTo(0));
  final r = d ~/ cols, c = d % cols;
  expect(r == 0 || c == 0 || r == rows - 1 || c == cols - 1, isTrue, reason: 'the depot is on the edge');
  final first = p.children[d].single;
  final fr = first ~/ cols, fc = first % cols;
  expect(fr > 0 && fc > 0 && fr < rows - 1 && fc < cols - 1, isTrue, reason: 'the track leaves the edge at once');
  expect(p.stations.length, stations);
  expect(p.switches.length, stations - 1);
  expect(p.start.length, p.switches.length);
  final track = {
    for (var i = 0; i < p.cells; i++)
      if (p.parent[i] != junctionOff) i,
  };
  for (final i in track) {
    final kids = p.children[i];
    final leaf = p.stationAt[i] >= 0;
    expect(kids.length, leaf ? 0 : anyOf(1, 2), reason: 'cell $i');
    if (p.parent[i] >= 0) {
      final a = p.parent[i];
      expect((a ~/ cols - i ~/ cols).abs() + (a % cols - i % cols).abs(), 1, reason: 'neighbours');
    }
    // Track cells only touch the cells before and after them.
    for (final (dr, dc) in junctionDirs) {
      final rr = i ~/ cols + dr, cc = i % cols + dc;
      if (rr < 0 || cc < 0 || rr >= rows || cc >= cols) continue;
      final m = rr * cols + cc;
      if (track.contains(m)) expect(p.parent[m] == i || p.parent[i] == m, isTrue, reason: '$i touches $m');
    }
  }
  for (final s in p.switches) {
    expect(p.depth(s), greaterThanOrEqualTo(junctionFirstSwitch));
    for (final k in p.children[s]) {
      expect(p.children[k].length, 1, reason: 'branches are at least two cells long');
    }
  }
  // Every station is reached by setting the switches its way.
  for (var k = 0; k < stations; k++) {
    final settings = [for (var j = 0; j < p.switches.length; j++) p.route[k][j] < 0 ? 0 : p.route[k][j]];
    var at = p.depot;
    for (var n = 0; n < p.cells && p.stationAt[at] < 0; n++) {
      at = p.nextCell(at, settings);
    }
    expect(at, p.stations[k]);
  }
}
