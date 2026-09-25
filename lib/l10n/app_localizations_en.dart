// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get playCode => 'Play a puzzle code';

  @override
  String get playCodeMenu => 'Play a puzzle code…';

  @override
  String get inProgress => 'In progress';

  @override
  String get size => 'Size';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String notSolvedYet(Object difficulty) {
    return 'Not solved yet on $difficulty';
  }

  @override
  String statsScore(Object count, Object score, Object time) {
    return 'Finished $count× · best score $score · best time $time';
  }

  @override
  String statsTime(Object average, Object best, Object count) {
    return 'Solved $count× · best $best · avg $average';
  }

  @override
  String get continueGame => 'Continue';

  @override
  String get newPuzzle => 'New puzzle';

  @override
  String get highlightErrors => 'Highlight errors while playing';

  @override
  String get highlightErrorsHint =>
      'Off: mistakes are only shown when you press Submit';

  @override
  String get autoClearMarks => 'Auto-remove pencil marks';

  @override
  String get autoClearMarksHint =>
      'Placing a number clears that note from its row, column and box';

  @override
  String get haptics => 'Haptic feedback';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get aboutLicenses => 'About & licenses';

  @override
  String get linksTitle => 'Open puzzle links in the app';

  @override
  String get linksOn => 'Shared puzzle links open in APuzzle';

  @override
  String linksOff(Object host) {
    return 'Off: tap, then add $host under \"Open supported links\"';
  }

  @override
  String linksUnknown(Object host) {
    return 'Choose APuzzle for $host links';
  }

  @override
  String get couldNotOpenSettings => 'Could not open the system settings';

  @override
  String get submitConflicts => 'Some cells break the rules';

  @override
  String get submitIncomplete => 'Not finished yet';

  @override
  String get submitWrong => 'Not quite right';

  @override
  String get restartTitle => 'Restart puzzle?';

  @override
  String get restartBody =>
      'All your entries will be cleared. You can still undo.';

  @override
  String get cancel => 'Cancel';

  @override
  String get restart => 'Restart';

  @override
  String get gotIt => 'Got it';

  @override
  String get rules => 'Rules';

  @override
  String get copyShareLink => 'Copy share link';

  @override
  String get shareLinkCopied => 'Share link copied';

  @override
  String get couldNotGenerate => 'Could not generate a puzzle';

  @override
  String get tryAgain => 'Try again';

  @override
  String get generating => 'Generating puzzle…';

  @override
  String get tapToCycle => 'Tap to cycle';

  @override
  String get palette => 'Palette';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get hint => 'Hint';

  @override
  String get submit => 'Submit';

  @override
  String get erase => 'Erase';

  @override
  String get pencilMarks => 'Pencil marks';

  @override
  String get solved => 'Solved!';

  @override
  String scoreValue(Object score) {
    return 'Score $score';
  }

  @override
  String get newBest => 'new best!';

  @override
  String bestValue(Object value) {
    return 'best $value';
  }

  @override
  String hintsUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hints',
      one: '$count hint',
    );
    return '$_temp0';
  }

  @override
  String get home => 'Home';

  @override
  String get copyResult => 'Copy result to share';

  @override
  String get resultCopied => 'Result copied, paste it to a friend';

  @override
  String shareSolved(int hints, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: 'I solved this $name in $time with $hints hints.',
      one: 'I solved this $name in $time with 1 hint.',
      zero: 'I solved this $name in $time.',
    );
    return '$_temp0';
  }

  @override
  String shareScored(int hints, Object score, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: 'I scored $score in this $name in $time with $hints hints.',
      one: 'I scored $score in this $name in $time with 1 hint.',
      zero: 'I scored $score in this $name in $time.',
    );
    return '$_temp0';
  }

  @override
  String get shareChallenge => 'Can you beat it?';

  @override
  String get paste => 'Paste';

  @override
  String get play => 'Play';

  @override
  String couldNotOpenLink(Object error) {
    return 'Could not open the link: $error';
  }

  @override
  String codeExpected(Object example) {
    return 'Expected a code like $example';
  }

  @override
  String codeUnknownPuzzle(Object id) {
    return 'Unknown puzzle \"$id\"';
  }

  @override
  String codeNoSize(Object name, Object size) {
    return '$name has no $size size';
  }

  @override
  String codeNoDifficulty(Object level, Object name) {
    return '$name has no \"$level\" difficulty';
  }

  @override
  String codeBadSeed(Object seed) {
    return 'Bad seed \"$seed\"';
  }

  @override
  String codeBadVersion(Object version) {
    return 'Bad version \"$version\"';
  }

  @override
  String get codeOtherVersion =>
      'This code comes from a different app version, so the puzzle would not match';

  @override
  String codeNoOption(Object choice, Object name) {
    return '$name has no option \"$choice\"';
  }

  @override
  String codeNoChoice(Object choice, Object name, Object option) {
    return '$name: $option has no choice \"$choice\"';
  }

  @override
  String get valueSun => 'Sun';

  @override
  String get valueMoon => 'Moon';

  @override
  String get valueDot => 'Dot';

  @override
  String get valueCrown => 'Crown';

  @override
  String get valueShade => 'Shade';

  @override
  String get valueGrass => 'Grass';

  @override
  String get valueTent => 'Tent';

  @override
  String get valueSea => 'Sea';

  @override
  String get valueLamp => 'Lamp';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorGreen => 'Green';

  @override
  String get outOfMoves => 'Out of moves: undo or restart';

  @override
  String movesOfLimit(Object moves, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit moves',
      one: '$limit move',
    );
    return '$moves / $_temp0';
  }

  @override
  String get bondsCantCross => 'Bonds can\'t cross';

  @override
  String get mamboName => 'Sun & Moon';

  @override
  String get mamboTagline => 'Balance suns and moons';

  @override
  String get mamboRules =>
      '• Fill every cell with a sun or a moon.\n• No more than 2 identical symbols next to each other in a row or column.\n• Each row and column has the same number of suns and moons.\n• \"=\" between two cells: they hold the same symbol.\n• \"×\" between two cells: they hold different symbols.\n• Locked cells are given.\n\nTap a cell to cycle empty → sun → moon. Long-press / right-click cycles back.';

  @override
  String get sudokuName => 'Sudoku';

  @override
  String get sudokuTagline => 'Every number once per row, column and box';

  @override
  String get sudokuRules =>
      '• Fill every cell with a number from 1 to N (N = grid size).\n• Each number appears exactly once in every row, every column and every box.\n• Given numbers are fixed.\n\nPick a number in the palette and tap cells to place it, or tap a cell first and then a number. The pencil button toggles small notes. Long-press / right-click clears a cell.';

  @override
  String get kingsName => 'Crowns';

  @override
  String get kingsTagline => 'One crown per row, column and region';

  @override
  String get kingsRules =>
      '• Place exactly one crown in every row, every column and every colored region.\n• Crowns may not touch each other, not even diagonally.\n\nTap a cell to cycle empty → dot (your \"no crown here\" note) → crown. Long-press / right-click cycles back.';

  @override
  String get huesName => 'Hues';

  @override
  String get huesTagline => 'Count the matching colors around each number';

  @override
  String get huesRules =>
      '• Color every blank cell using the palette colors.\n• Each numbered cell shows how many of the blank cells around it (all 8 neighbours, including diagonals) end up in the same color as the numbered cell.\n• The number counts down as you paint matching neighbours, so it shows how many are still missing.\n• Numbered cells themselves never count.\n\nPick a color in the palette and tap cells to paint them (tap again to clear), or tap a cell to cycle through the colors.';

  @override
  String get mosaicName => 'Mosaic';

  @override
  String get mosaicTagline => 'Flood the board with one color';

  @override
  String get mosaicRules =>
      '• The colored area in the top-left corner is yours.\n• Pick a color: your area takes that color and absorbs every touching cell of the same color.\n• Paint the whole board in one color within the move limit.\n\nTap a palette color, or tap any cell to use its color.';

  @override
  String get blendName => 'Blend';

  @override
  String get blendTagline => 'Repaint any patch until one color remains';

  @override
  String get blendRules =>
      '• The board is made of colored patches (touching cells of the same color).\n• Pick a color, then tap any patch to repaint it. It merges with every touching patch of that color.\n• Make the whole board one color within the move limit.\n\nThe palette color stays selected, so you can paint several patches in a row.';

  @override
  String get popName => 'Pop';

  @override
  String get popTagline => 'Pop big bubble groups for big points';

  @override
  String get popRules =>
      '• Tap a group of 2 or more touching bubbles of one color to select it; tap it again to pop it.\n• A group of n bubbles scores n × (n − 1), so saving up for big groups pays off.\n• Bubbles above fall down, and empty columns close up to the right.\n\nModes\n• Standard: just that.\n• Shifter: every row also slides right to close its gaps.\n• Continuous: new columns roll in from the left as space frees up.\n• Mega: Shifter and Continuous together.\n\nGoals\n• Clear the board: pop every bubble (Standard only; there is always a way).\n• Target score: reach the score before no moves are left.\n• Free play: no target, just beat your best score.\n\nThe game ends when no group of 2 is left.';

  @override
  String get popMode => 'Mode';

  @override
  String get popModeStandard => 'Standard';

  @override
  String get popModeStandardHint =>
      'Bubbles fall down; empty columns close up to the right.';

  @override
  String get popModeShifter => 'Shifter';

  @override
  String get popModeShifterHint => 'Rows also slide right to close every gap.';

  @override
  String get popModeContinuous => 'Continuous';

  @override
  String get popModeContinuousHint =>
      'New columns roll in from the left as space frees up.';

  @override
  String get popModeMega => 'Mega';

  @override
  String get popModeMegaHint => 'Shifter and Continuous together.';

  @override
  String get popGoal => 'Goal';

  @override
  String get popGoalClear => 'Clear board';

  @override
  String get popGoalClearHint => 'Pop every bubble. There is always a way.';

  @override
  String get popGoalTarget => 'Target score';

  @override
  String get popGoalTargetHint => 'Reach the target before no moves are left.';

  @override
  String get popGoalFree => 'Free play';

  @override
  String get popGoalFreeHint =>
      'No target: play it out and beat your best score.';

  @override
  String get popCleared => 'Cleared!';

  @override
  String get popTargetReached => 'Target reached!';

  @override
  String get popGameOver => 'Game over';

  @override
  String popStuckBubbles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No moves left with $count bubbles on the board: undo or restart',
      one: 'No moves left with $count bubble on the board: undo or restart',
    );
    return '$_temp0';
  }

  @override
  String popStuckPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No moves left, $count points short: undo or restart',
      one: 'No moves left, $count point short: undo or restart',
    );
    return '$_temp0';
  }

  @override
  String popPoints(Object score) {
    return '$score pts';
  }

  @override
  String popLeft(Object count) {
    return '$count left';
  }

  @override
  String popColumns(Object count) {
    return '+$count cols';
  }

  @override
  String get pipesName => 'Pipes';

  @override
  String get pipesTagline => 'Connect every pipe to the source';

  @override
  String get pipesRules =>
      '• Rotate the tiles so that every pipe connects back to the source (the ringed tile).\n• No pipe end may be left open, and the network may not contain loops.\n• Water flows through everything already connected to the source.\n• Tiles with a lock are already in place.\n\nTap a tile to rotate it clockwise; long-press / right-click rotates it back.';

  @override
  String get shikakuName => 'Shikaku';

  @override
  String get shikakuTagline => 'Split the grid into numbered rectangles';

  @override
  String get shikakuRules =>
      '• Divide the whole grid into rectangles (squares count too).\n• Every rectangle contains exactly one number.\n• That number equals the rectangle\'s area in cells.\n\nDrag from one corner to the opposite corner to draw a rectangle. Tap a rectangle to remove it.';

  @override
  String get trailName => 'Trail';

  @override
  String get trailTagline => 'One path through every cell, numbers in order';

  @override
  String get trailRules =>
      '• Draw a single path that starts at 1 and visits every cell exactly once.\n• The path moves up, down, left or right (no diagonals).\n• It must pass the numbers in order (1 → 2 → 3 → …) and finish on the last number.\n\nDrag to draw. Drag back over the path to undo steps, or tap a cell of the path to cut it there.';

  @override
  String get atomsName => 'Atoms';

  @override
  String get atomsTagline => 'Bond every atom to match its number';

  @override
  String get atomsRules =>
      '• Connect the atoms with horizontal or vertical bonds.\n• Each atom needs exactly as many bonds as its number.\n• Two atoms can share one or two bonds.\n• Bonds can\'t cross each other or pass through atoms.\n• All atoms must end up connected into one molecule.\n\nDrag from an atom towards a neighbour to add a bond (1 → 2 → none). You can also tap the space between two atoms.';

  @override
  String get litsName => 'LITS';

  @override
  String get litsTagline => 'One tetromino in every region';

  @override
  String get litsRules =>
      '• Shade exactly 4 connected cells in every outlined region, forming an L, I, T or S shape (rotations and mirror images allowed).\n• All shaded cells together form one connected area.\n• No 2×2 block may be fully shaded.\n• Two identical shapes may not touch each other across a region border.\n\nTap a cell to cycle empty → shaded → dot (your \"not shaded\" note).';

  @override
  String get labyrinthName => 'Labyrinth';

  @override
  String get labyrinthTagline => 'Find the way from corner to corner';

  @override
  String get labyrinthRules =>
      '• Find the way through the maze from the entrance in the top-left corner to the exit in the bottom-right corner.\n• You can\'t pass through walls.\n\nDrag from the end of your path to walk on. Drag back to retrace your steps, or tap a cell of the path to go back there.';

  @override
  String get campName => 'Campsite';

  @override
  String get campTagline => 'Pitch a tent next to every tree';

  @override
  String get campRules =>
      '• Pitch one tent for every tree, right next to it (up, down, left or right).\n• Every tree gets its own tent, and every tent belongs to one tree next to it.\n• Tents never touch each other, not even diagonally.\n• The numbers outside the grid tell how many tents are in each row and column.\n\nTap a cell to cycle empty → grass (your \"no tent here\" note) → tent. Long-press / right-click cycles back.';

  @override
  String get islandsName => 'Islands';

  @override
  String get islandsTagline => 'Flood the sea around the numbered islands';

  @override
  String get islandsRules =>
      '• Shade the sea so that the unshaded cells form islands.\n• Every island contains exactly one number, which equals its size in cells.\n• Islands only touch the sea, never each other (diagonal corners are fine).\n• The whole sea is connected, and it has no 2×2 pools.\n\nTap a cell to cycle empty → sea → dot (your \"land\" note). Long-press / right-click cycles back.';

  @override
  String get minesName => 'Mines';

  @override
  String get minesTagline => 'Find every mine, logic only';

  @override
  String get minesRules =>
      '• Open every cell that has no mine.\n• A number tells how many mines are in the 8 cells around it.\n• You never need to guess: every board can be cleared by logic.\n• Opening a cell with no mines around it opens its neighbours too.\n\nTap a cell to dig, long-press / right-click to flag it (or switch to Flag below). Tap a number whose flags are all placed to dig the rest around it. Digging a mine flags it with a bang, and the game goes on.';

  @override
  String get minesDig => 'Dig';

  @override
  String get minesFlag => 'Flag';

  @override
  String get minesBoom => 'Boom! That was a mine, so it\'s flagged now';

  @override
  String get lampsName => 'Lamps';

  @override
  String get lampsTagline => 'Light up every cell, lamps never face each other';

  @override
  String get lampsRules =>
      '• Place lamps in white cells. A lamp lights its own cell and its row and column until a wall.\n• Every white cell must be lit.\n• No lamp may shine on another lamp.\n• A number on a wall tells how many lamps are right next to it (up, down, left or right).\n\nTap a cell to cycle empty → dot (your \"no lamp\" note) → lamp. Long-press / right-click cycles back.';

  @override
  String get fenceName => 'Fence';

  @override
  String get fenceTagline => 'One loop that fits around the numbers';

  @override
  String get fenceRules =>
      '• Draw one closed loop along the dotted lines.\n• The loop never crosses or touches itself.\n• A number tells how many of its cell\'s four sides the loop uses. Cells without a number can have any count.\n\nTap between two dots to draw a line, tap again to mark it with a cross, and once more to clear it. Drag from dot to dot to draw several lines, or to erase them if you start on a line.';

  @override
  String get pearlsName => 'Pearls';

  @override
  String get pearlsTagline => 'Thread one loop through all the pearls';

  @override
  String get pearlsRules =>
      '• Draw one closed loop through the centers of the cells. It never crosses or touches itself, and it doesn\'t have to visit every cell.\n• The loop passes through every pearl.\n• At a black pearl it turns, and it goes straight on through the cells before and after.\n• At a white pearl it goes straight, and it turns in the cell before or after (or both).\n\nDrag through cells to draw the loop, or drag along it to erase. Tap between two cells to cycle line → cross → empty.';
}
