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
  String get dailyTitle => 'Daily challenges';

  @override
  String get dailyCalendar => 'Calendar';

  @override
  String dailyProgress(int done, int total) {
    return '$done of $total solved';
  }

  @override
  String get dailyDayComplete => 'Day complete!';

  @override
  String get dailyNext => 'Next puzzle';

  @override
  String get dailyToday => 'Today';

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
  String get mergeName => '2048';

  @override
  String get mergeTagline =>
      'Slide the tiles, merge the twins, build the big one';

  @override
  String get mergeRules =>
      '• Swipe (or press an arrow key) to slide every tile as far as it goes that way.\n• Two tiles with the same number that run into each other merge into one with their sum. A tile merges only once per move.\n• After every move a new 2 (sometimes a 4) appears on an empty cell.\n• Each merge scores the new tile\'s value.\n\nGoals\n• Build the tile: reach the target tile (it depends on the board size and difficulty).\n• Free play: keep going until the board locks up, and beat your best score.\n\nThe game ends when the board is full and no two neighbours match.';

  @override
  String get mergeGoalTarget => 'Build the tile';

  @override
  String get mergeGoalTargetHint =>
      'Reach the target tile before the board locks up.';

  @override
  String get mergeGoalFreeHint =>
      'No target: play until the board locks up and beat your best score.';

  @override
  String mergeReached(int tile) {
    return '$tile!';
  }

  @override
  String get mergeStuck => 'No moves left: undo or restart';

  @override
  String mergeBest(int tile) {
    return 'Best $tile';
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
  String get litsName => 'Tetra';

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

  @override
  String get learnTitle => 'How to play';

  @override
  String get learnIntro =>
      'Short interactive lessons: every step is a tiny board that shows one rule or trick.';

  @override
  String learnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '1 step',
    );
    return '$_temp0';
  }

  @override
  String get learnDone => 'Learned';

  @override
  String tutorialOfferTitle(String name) {
    return 'New to $name?';
  }

  @override
  String get tutorialOfferBody =>
      'Take a quick interactive lesson first? A few tiny boards show you every rule.';

  @override
  String get tutorialOfferNo => 'No, thanks';

  @override
  String get tutorialOfferYes => 'Show me how';

  @override
  String tutorialTitle(String name) {
    return 'How to play $name';
  }

  @override
  String tutorialStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get tutorialNice => 'Nice!';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialFinish => 'Finish';

  @override
  String get tutorialShowMe => 'Show me';

  @override
  String get tutorialPrevious => 'Previous step';

  @override
  String get tutorialReset => 'Start this step over';

  @override
  String get tutorialFinishedTitle => 'You\'ve got it!';

  @override
  String tutorialFinishedBody(String name) {
    return 'That\'s everything you need to play $name.';
  }

  @override
  String get tutorialPlay => 'Play now';

  @override
  String get tutorialAgain => 'Start over';

  @override
  String get tutorialClose => 'Close';

  @override
  String get tutMambo1 =>
      'Fill every cell with a sun or a moon. Never three of the same in a row: after two suns side by side comes a moon. Tap a highlighted cell to cycle empty → sun → moon.';

  @override
  String get tutMambo2 =>
      'Every row and column holds as many suns as moons. The top row already has its two suns, so its other cells are moons. The right column works the same way.';

  @override
  String get tutMambo3 =>
      'An = between two cells means they hold the same symbol. Match the highlighted cells to their neighbours.';

  @override
  String get tutMambo4 =>
      'A × means the two cells are different: one sun, one moon.';

  @override
  String get tutMambo5 =>
      'Now a whole board: use every rule together. Tip: the palette button at the top lets you stamp one symbol on many cells, and a long press (or right-click) cycles backwards.';

  @override
  String get tutSudoku1 =>
      'Each row, column and box (the thick outlines) holds every number from 1 to 4 once. This row is missing one number: pick it in the palette, then tap the empty cell.';

  @override
  String get tutSudoku2 =>
      'By their row, these two cells could be 3 or 4. Their columns decide: each column is missing just one number.';

  @override
  String get tutSudoku3 =>
      'The boxes count too: every box needs 1 to 4 once. Finish the last box.';

  @override
  String get tutSudoku4 =>
      'Not sure yet? Take notes. Turn on the pencil next to the palette, select the highlighted cell and note every number it could still hold.';

  @override
  String get tutSudoku5 =>
      'Now a whole puzzle. Selecting a cell tints its row, column and box, and highlights the same number elsewhere. Settings can remove notes for you when you place a number.';

  @override
  String get tutKings1 =>
      'Put exactly one crown in every row, every column and every colored region. Three are placed, and the last one has just one spot left. Tap it twice: first a dot, then a crown.';

  @override
  String get tutKings2 =>
      'Crowns never touch, not even at the corners. Tap once to put a dot (your \"no crown here\" note) on each cell around this crown.';

  @override
  String get tutKings3 =>
      'The crowns\' rows and the touching rule leave just one cell of the highlighted region without a dot. Place its crown.';

  @override
  String get tutKings4 =>
      'Now a whole board. Dot the cells you can rule out, and look for rows, columns or regions with a single free cell.';

  @override
  String get tutHues1 =>
      'Paint every blank cell. A number counts the blank cells around it (diagonals too) that end up in its own color. The blue 3 has exactly three blank neighbours, so all of them are blue. Pick a color in the palette and tap cells to paint them.';

  @override
  String get tutHues2 =>
      'Numbers count down as you paint: they show how many matching cells are still missing. A 0 means no blank neighbour takes its color, and numbered cells never count. Start with the blue 3, then see what the pink 2 still needs.';

  @override
  String get tutHues3 =>
      'Now a real board. Start with numbers that need all of their blank neighbours, or none of them.';

  @override
  String get tutMosaic1 =>
      'The patch in the top-left corner is yours. Pick a color below: your patch takes it and swallows every touching cell of that color. Turn the whole board one color.';

  @override
  String get tutMosaic2 =>
      'Mind the move limit: pick the color that grows your patch the most. Tapping a cell on the board also picks its color.';

  @override
  String get tutMosaic3 => 'Now a real board, with a few moves to spare.';

  @override
  String get tutBlend1 =>
      'The board is made of patches: touching cells of one color. Pick a color below, then tap a patch to repaint it. It merges with the touching patches of that color. Repaint the middle patch.';

  @override
  String get tutBlend2 =>
      'One move can merge many patches. The middle patch touches four others: paint it to join them, then finish. You have only 2 moves.';

  @override
  String get tutBlend3 =>
      'Now a real board. The chosen color stays selected, so you can paint several patches in a row.';

  @override
  String get tutPop1 =>
      'Tap a group of two or more touching bubbles of one color to select it, then tap it again to pop it. Clear the board.';

  @override
  String get tutPop2 =>
      'Bubbles above fall into the gaps, so new groups can form. Order matters: pop the highlighted group first.';

  @override
  String get tutPop3 =>
      'When a column empties, the columns to its left slide right to close the gap. Pop the middle to bring the sides together.';

  @override
  String get tutPop4 =>
      'A group of n bubbles scores n × (n − 1): 2 bubbles score 2, 5 score 20. Save up for a big group to reach 20 points.';

  @override
  String get tutPop5 =>
      'Other modes: in Shifter every row also slides right to close its gaps, in Continuous new columns roll in from the left, and Mega does both. Goals: clear the board, reach a target score, or play freely for your best. The game ends when no group of 2 is left.';

  @override
  String get tutMerge1 =>
      'Swipe (or press an arrow key) to slide every tile as far as it goes. Two equal tiles that meet merge into their sum. Make a 4.';

  @override
  String get tutMerge2 =>
      'A tile merges only once per move: 4, 4, 8 slides into 8, 8, not 16. After every move a new 2 (sometimes a 4) appears. Build a 16.';

  @override
  String get tutMerge3 =>
      'Keep your biggest tile in a corner and feed it step by step. Build a 32.';

  @override
  String get tutPipes1 =>
      'Tap a tile to turn it clockwise (a long press or right-click turns it back). Connect every pipe to the source, the ringed tile. Water shows what\'s already connected.';

  @override
  String get tutPipes2 =>
      'No pipe end may stay open, so no pipe can point off the board. Tiles with a lock are already right. Start at the edges and corners, where tiles have the fewest ways to turn.';

  @override
  String get tutPipes3 => 'Now a real board. The network may not form loops.';

  @override
  String get tutShikaku1 =>
      'Split the grid into rectangles. Each holds exactly one number, equal to its area in cells. Drag from one corner to the opposite one to draw a rectangle.';

  @override
  String get tutShikaku2 =>
      'A 1 is a rectangle on its own: just tap it. Tap a drawn rectangle to remove it. Here the 6 fits only one way.';

  @override
  String get tutShikaku3 =>
      'Now a real board. Big numbers near the edges usually have the fewest ways to fit.';

  @override
  String get tutTrail1 =>
      'Drag from 1 to draw one path through every cell, moving up, down, left or right. It ends on the last number.';

  @override
  String get tutTrail2 =>
      'The path must pass the numbers in order: 1 → 2 → 3 → 4. Drag back over your path to undo steps, or tap a cell of it to cut it there.';

  @override
  String get tutTrail3 =>
      'Now a real board. Cells in corners have only two ways in and out, so the path must use both.';

  @override
  String get tutLabyrinth1 =>
      'Drag from the start in the top-left corner and walk to the flag in the bottom-right corner. Walls block the way.';

  @override
  String get tutLabyrinth2 =>
      'A bigger maze. Hit a dead end? Drag back along your path, or tap any cell of it to return there. A quick drag follows straight corridors.';

  @override
  String get tutAtoms1 =>
      'Connect the atoms with bonds. Each atom needs as many bonds as its number, and two atoms can share one or two. Drag from an atom toward a neighbour to add a bond (1 → 2 → none).';

  @override
  String get tutAtoms2 =>
      'All atoms must join into one molecule, and bonds can\'t cross. Bonding the top-left 1 downwards would leave two separate pairs, so where does its bond go?';

  @override
  String get tutAtoms3 =>
      'Now a real board. Start with atoms that have only one way to get their bonds.';

  @override
  String get tutLits1 =>
      'Shade exactly 4 cells in every outlined region, forming an L, I, T or S. The top region has exactly 4 cells, so shade them all. Tap a cell to shade it.';

  @override
  String get tutLits2 =>
      'No 2×2 block may be fully shaded, and two identical shapes may not touch across a border. Just one cell completes the left region. Which one?';

  @override
  String get tutLits3 =>
      'Now a real board. All shaded cells must form one connected area. Tap twice for a dot, your note that a cell stays empty.';

  @override
  String get tutCamp1 =>
      'Pitch one tent next to every tree: up, down, left or right, never diagonal. The numbers outside tell how many tents each row and column holds. Tap a cell twice: grass, then a tent.';

  @override
  String get tutCamp2 =>
      'Tents never touch each other, not even diagonally. One tent is pitched already. Where can the other tree\'s tent go?';

  @override
  String get tutCamp3 =>
      'Now a real board. A 0 means the whole row or column is grass, and every tree gets its own tent.';

  @override
  String get tutIslands1 =>
      'Shade the sea so that the unshaded cells form islands. Each number is an island of exactly that many cells. Here the 1 is an island by itself: tap every other cell to make it sea.';

  @override
  String get tutIslands2 =>
      'Islands never touch each other. A cell between two numbers must be sea, or it would join them into one island.';

  @override
  String get tutIslands3 =>
      'The sea must stay connected and may never form a 2×2 pool. Grow the 3 so that neither happens. Tap twice for a dot, your note for land.';

  @override
  String get tutIslands4 =>
      'Now a real board. Every island holds exactly one number.';

  @override
  String get tutLamps1 =>
      'Put lamps in the white cells: tap twice (a dot, then a lamp). A lamp lights its own row and column up to the walls. Light up every white cell.';

  @override
  String get tutLamps2 =>
      'A number on a wall tells how many lamps touch it (up, down, left or right). This 3 needs a lamp on each of its free sides.';

  @override
  String get tutLamps3 =>
      'Lamps may never shine on each other, and a 0 means no lamp right next to it. Where does the second lamp go?';

  @override
  String get tutLamps4 =>
      'Now a real board. Dots help you mark cells that can\'t hold a lamp.';

  @override
  String get tutFence1 =>
      'Draw one closed loop along the dotted lines. A number tells how many sides of its cell the loop uses. Tap between two dots to draw a line, or drag from dot to dot.';

  @override
  String get tutFence2 =>
      'A 0 has no line around it. Tap a line again to turn it into a cross, your note that no line goes there. Cells without a number can have any count.';

  @override
  String get tutFence3 =>
      'The loop never branches or crosses itself: every dot has either no line or two. Numbers next to the board\'s edge are a good place to start.';

  @override
  String get tutFence4 => 'Now a real board. Start with the 0s and 3s.';

  @override
  String get tutPearls1 =>
      'Drag through the cells to draw one closed loop. At a black pearl the loop turns, then runs straight through the next cell on both sides.';

  @override
  String get tutPearls2 =>
      'At a white pearl the loop goes straight through, and it turns in the cell just before or after it (or both).';

  @override
  String get tutPearls3 =>
      'Now a real board. The loop doesn\'t have to visit every cell, and it never crosses or touches itself.';

  @override
  String get tutMines1 =>
      'A number counts the mines in the 8 cells around it. Each 1 here touches just one closed cell, so that cell is a mine. Flag it: long-press or right-click it, or switch to Flag below and tap it.';

  @override
  String get tutMines2 =>
      'This 1 already has its mine flagged, so every other cell around it is safe. Dig them, or tap the 1 itself to dig them all at once.';

  @override
  String get tutMines3 =>
      'A cell with no mines around it opens its neighbours for you. Dig the highlighted corner.';

  @override
  String get tutMines4 =>
      'Now a real board. You never need to guess. If you dig a mine by mistake, it just gets flagged and the game goes on.';
}
