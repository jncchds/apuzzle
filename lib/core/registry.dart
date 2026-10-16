import 'package:flutter/material.dart';

import '../puzzles/arrows/arrows_type.dart';
import '../puzzles/atoms/atoms_type.dart';
import '../puzzles/blockade/blockade_type.dart';
import '../puzzles/blocks/blocks_type.dart';
import '../puzzles/cages/cages_type.dart';
import '../puzzles/chambers/chambers_type.dart';
import '../puzzles/lookout/lookout_type.dart';
import '../puzzles/rampart/rampart_type.dart';
import '../puzzles/channel/channel_type.dart';
import '../puzzles/blend/blend_type.dart';
import '../puzzles/basins/basins_type.dart';
import '../puzzles/camp/camp_type.dart';
import '../puzzles/domino/domino_type.dart';
import '../puzzles/fence/fence_type.dart';
import '../puzzles/fleet/fleet_type.dart';
import '../puzzles/formula/formula_type.dart';
import '../puzzles/glimpse/glimpse_type.dart';
import '../puzzles/hopper/hopper_type.dart';
import '../puzzles/homeward/homeward_type.dart';
import '../puzzles/glide/glide_type.dart';
import '../puzzles/hues/hues_type.dart';
import '../puzzles/inlay/inlay_type.dart';
import '../puzzles/islands/islands_type.dart';
import '../puzzles/junction/junction_type.dart';
import '../puzzles/kings/kings_type.dart';
import '../puzzles/labyrinth/labyrinth_type.dart';
import '../puzzles/lamps/lamps_type.dart';
import '../puzzles/layers/layers_type.dart';
import '../puzzles/links/links_type.dart';
import '../puzzles/lits/lits_type.dart';
import '../puzzles/mambo/mambo_type.dart';
import '../puzzles/merge/merge_type.dart';
import '../puzzles/mines/mines_type.dart';
import '../puzzles/mosaic/mosaic_type.dart';
import '../puzzles/nightfall/nightfall_type.dart';
import '../puzzles/orbits/orbits_type.dart';
import '../puzzles/pebbles/pebbles_type.dart';
import '../puzzles/pairs/pairs_type.dart';
import '../puzzles/pearls/pearls_type.dart';
import '../puzzles/plots/plots_type.dart';
import '../puzzles/pockets/pockets_type.dart';
import '../puzzles/mercury/mercury_type.dart';
import '../puzzles/poles/poles_type.dart';
import '../puzzles/pop/pop_type.dart';
import '../puzzles/pipes/pipes_type.dart';
import '../puzzles/rails/rails_type.dart';
import '../puzzles/rebound/rebound_type.dart';
import '../puzzles/shikaku/shikaku_type.dart';
import '../puzzles/signs/signs_type.dart';
import '../puzzles/skyline/skyline_type.dart';
import '../puzzles/snake/snake_type.dart';
import '../puzzles/solo/solo_type.dart';
import '../puzzles/sudoku/sudoku_type.dart';
import '../puzzles/tally/tally_type.dart';
import '../puzzles/totals/totals_type.dart';
import '../puzzles/trail/trail_type.dart';
import '../puzzles/turnabout/turnabout_type.dart';
import '../puzzles/vanish/vanish_type.dart';
import '../puzzles/waymarks/waymarks_type.dart';
import '../l10n/app_localizations.dart';
import 'puzzle_type.dart';

/// All puzzle types, in home-screen order. Add new types here.
const List<PuzzleType> puzzleTypes = [
  MamboType(),
  SudokuType(),
  PocketsType(),
  SkylineType(),
  CagesType(),
  SignsType(),
  TotalsType(),
  KingsType(),
  BlocksType(),
  TallyType(),
  SoloType(),
  DominoType(),
  FormulaType(),
  PairsType(),
  HuesType(),
  MosaicType(),
  BlendType(),
  PopType(),
  MergeType(),
  NightfallType(),
  GlideType(),
  SnakeType(),
  JunctionType(),
  TurnaboutType(),
  GlimpseType(),
  VanishType(),
  HopperType(),
  ReboundType(),
  PipesType(),
  ChannelType(),
  ShikakuType(),
  PlotsType(),
  OrbitsType(),
  InlayType(),
  TrailType(),
  LinksType(),
  LabyrinthType(),
  HomewardType(),
  BlockadeType(),
  AtomsType(),
  LitsType(),
  CampType(),
  FleetType(),
  BasinsType(),
  MercuryType(),
  PolesType(),
  PebblesType(),
  LayersType(),
  ChambersType(),
  LookoutType(),
  RampartType(),
  WaymarksType(),
  IslandsType(),
  LampsType(),
  FenceType(),
  PearlsType(),
  RailsType(),
  ArrowsType(),
  MinesType(),
];

/// Games that share a board idea. Most are families of one, which open their
/// game directly; a family with several variants has its own page (`/f/<id>`).
class PuzzleFamily {
  const PuzzleFamily(this.id, this.types);

  /// Stable: it is part of the address. A family of one uses its game's id.
  final String id;
  final List<PuzzleType> types;

  bool get single => types.length == 1;

  String name(AppLocalizations l) => switch (id) {
    'flood' => l.famFlood,
    'latin' => l.famLatin,
    'sudokus' => l.famSudoku,
    'memory' => l.famMemory,
    'plumbing' => l.famPlumbing,
    'filling' => l.famFilling,
    _ => types.first.name(l),
  };

  /// What the variants share, under the family's name.
  String about(AppLocalizations l) => switch (id) {
    'flood' => l.famFloodAbout,
    'latin' => l.famLatinAbout,
    'sudokus' => l.famSudokuAbout,
    'memory' => l.famMemoryAbout,
    'plumbing' => l.famPlumbingAbout,
    'filling' => l.famFillingAbout,
    _ => types.first.tagline(l),
  };

  IconData get icon => types.first.icon;
  Color get accent => types.first.accent;
}

/// A home-screen category: a tile that opens its families (`/c/<id>`).
class PuzzleCategory {
  const PuzzleCategory(this.id, this.families, {required this.icon, required this.accent});

  /// Stable: it is part of the address.
  final String id;
  final List<PuzzleFamily> families;
  final IconData icon;
  final Color accent;

  List<PuzzleType> get types => [for (final f in families) ...f.types];

  String name(AppLocalizations l) => switch (id) {
    'numbers' => l.catNumbers,
    'grids' => l.catGrids,
    'paths' => l.catPaths,
    _ => l.catCasual,
  };
}

/// Every type of [puzzleTypes], in exactly one family of one category.
const List<PuzzleCategory> puzzleCategories = [
  PuzzleCategory(
    'numbers',
    icon: Icons.calculate_rounded,
    accent: Color(0xFF6FA8FF),
    [
      PuzzleFamily('sudokus', [SudokuType(), PocketsType()]),
      PuzzleFamily('latin', [SkylineType(), CagesType(), SignsType()]),
      PuzzleFamily('totals', [TotalsType()]),
      PuzzleFamily('blocks', [BlocksType()]),
      PuzzleFamily('tally', [TallyType()]),
      PuzzleFamily('solo', [SoloType()]),
      PuzzleFamily('domino', [DominoType()]),
      PuzzleFamily('formula', [FormulaType()]),
      PuzzleFamily('plots', [PlotsType()]),
      PuzzleFamily('shikaku', [ShikakuType()]),
    ],
  ),
  PuzzleCategory(
    'grids',
    icon: Icons.grid_on_rounded,
    accent: Color(0xFFFFB86B),
    [
      PuzzleFamily('mambo', [MamboType()]),
      PuzzleFamily('kings', [KingsType()]),
      PuzzleFamily('pairs', [PairsType()]),
      PuzzleFamily('hues', [HuesType()]),
      PuzzleFamily('lits', [LitsType()]),
      PuzzleFamily('camp', [CampType()]),
      PuzzleFamily('fleet', [FleetType()]),
      PuzzleFamily('filling', [BasinsType(), MercuryType()]),
      PuzzleFamily('poles', [PolesType()]),
      PuzzleFamily('pebbles', [PebblesType()]),
      PuzzleFamily('layers', [LayersType()]),
      PuzzleFamily('chambers', [ChambersType()]),
      PuzzleFamily('lookout', [LookoutType()]),
      PuzzleFamily('rampart', [RampartType()]),
      PuzzleFamily('islands', [IslandsType()]),
      PuzzleFamily('lamps', [LampsType()]),
      PuzzleFamily('orbits', [OrbitsType()]),
      PuzzleFamily('inlay', [InlayType()]),
      PuzzleFamily('mines', [MinesType()]),
    ],
  ),
  PuzzleCategory(
    'paths',
    icon: Icons.route_rounded,
    accent: Color(0xFF7BD88F),
    [
      PuzzleFamily('trail', [TrailType()]),
      PuzzleFamily('links', [LinksType()]),
      PuzzleFamily('waymarks', [WaymarksType()]),
      PuzzleFamily('labyrinth', [LabyrinthType()]),
      PuzzleFamily('homeward', [HomewardType()]),
      PuzzleFamily('blockade', [BlockadeType()]),
      PuzzleFamily('plumbing', [PipesType(), ChannelType()]),
      PuzzleFamily('atoms', [AtomsType()]),
      PuzzleFamily('fence', [FenceType()]),
      PuzzleFamily('pearls', [PearlsType()]),
      PuzzleFamily('rails', [RailsType()]),
      PuzzleFamily('arrows', [ArrowsType()]),
    ],
  ),
  PuzzleCategory(
    'casual',
    icon: Icons.sports_esports_rounded,
    accent: Color(0xFFFF7EB6),
    [
      PuzzleFamily('flood', [MosaicType(), BlendType()]),
      PuzzleFamily('pop', [PopType()]),
      PuzzleFamily('merge', [MergeType()]),
      PuzzleFamily('nightfall', [NightfallType()]),
      PuzzleFamily('glide', [GlideType()]),
      PuzzleFamily('snake', [SnakeType()]),
      PuzzleFamily('junction', [JunctionType()]),
      PuzzleFamily('turnabout', [TurnaboutType()]),
      PuzzleFamily('memory', [GlimpseType(), VanishType(), HopperType(), ReboundType()]),
    ],
  ),
];

PuzzleType puzzleTypeById(String id) => puzzleTypes.firstWhere((t) => t.id == id);

PuzzleCategory? categoryById(String? id) => puzzleCategories.where((c) => c.id == id).firstOrNull;

/// Only families with several variants have a page.
PuzzleFamily? familyById(String? id) =>
    [for (final c in puzzleCategories) ...c.families].where((f) => f.id == id && !f.single).firstOrNull;

PuzzleCategory categoryOf(PuzzleType type) => puzzleCategories.firstWhere((c) => c.types.any((t) => t.id == type.id));

PuzzleCategory categoryOfFamily(PuzzleFamily family) => puzzleCategories.firstWhere((c) => c.families.contains(family));
