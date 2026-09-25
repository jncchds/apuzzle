import '../puzzles/atoms/atoms_type.dart';
import '../puzzles/blend/blend_type.dart';
import '../puzzles/camp/camp_type.dart';
import '../puzzles/fence/fence_type.dart';
import '../puzzles/hues/hues_type.dart';
import '../puzzles/islands/islands_type.dart';
import '../puzzles/kings/kings_type.dart';
import '../puzzles/labyrinth/labyrinth_type.dart';
import '../puzzles/lamps/lamps_type.dart';
import '../puzzles/lits/lits_type.dart';
import '../puzzles/mambo/mambo_type.dart';
import '../puzzles/merge/merge_type.dart';
import '../puzzles/mines/mines_type.dart';
import '../puzzles/mosaic/mosaic_type.dart';
import '../puzzles/pearls/pearls_type.dart';
import '../puzzles/pop/pop_type.dart';
import '../puzzles/pipes/pipes_type.dart';
import '../puzzles/shikaku/shikaku_type.dart';
import '../puzzles/sudoku/sudoku_type.dart';
import '../puzzles/trail/trail_type.dart';
import 'puzzle_type.dart';

/// All puzzle types, in home-screen order. Add new types here.
const List<PuzzleType> puzzleTypes = [
  MamboType(),
  SudokuType(),
  KingsType(),
  HuesType(),
  MosaicType(),
  BlendType(),
  PopType(),
  MergeType(),
  PipesType(),
  ShikakuType(),
  TrailType(),
  LabyrinthType(),
  AtomsType(),
  LitsType(),
  CampType(),
  IslandsType(),
  LampsType(),
  FenceType(),
  PearlsType(),
  MinesType(),
];

PuzzleType puzzleTypeById(String id) => puzzleTypes.firstWhere((t) => t.id == id);
