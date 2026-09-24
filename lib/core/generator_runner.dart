import 'package:flutter/foundation.dart';

import 'difficulty.dart';
import 'puzzle_type.dart';
import 'registry.dart';

class _GenRequest {
  const _GenRequest(this.typeId, this.params);
  final String typeId;
  final GenParams params;
}

Object _runGeneration(_GenRequest r) => puzzleTypeById(r.typeId).generate(r.params) as Object;

/// Generates a puzzle off the UI thread (isolate on native, same thread on web).
Future<Object> generatePuzzle(PuzzleType type, GenParams params) =>
    compute(_runGeneration, _GenRequest(type.id, params), debugLabel: 'generate ${type.id}');
