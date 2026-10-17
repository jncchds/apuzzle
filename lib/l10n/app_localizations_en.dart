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
  String get dailyChoose => 'Choose games';

  @override
  String dailyChooseHint(int count) {
    return 'Each day draws $count of the chosen games. A change counts from today; earlier days keep their games.';
  }

  @override
  String dailyChooseMin(int count) {
    return 'Choose at least $count games';
  }

  @override
  String get dailyChooseAll => 'All games';

  @override
  String get save => 'Save';

  @override
  String get playCode => 'Play a puzzle code';

  @override
  String get playCodeMenu => 'Play a puzzle code…';

  @override
  String get inProgress => 'In progress';

  @override
  String get catNumbers => 'Numbers';

  @override
  String get catGrids => 'Logic grids';

  @override
  String get catPaths => 'Paths & loops';

  @override
  String get catCasual => 'Casual';

  @override
  String get searchHint => 'Search games';

  @override
  String get searchNone => 'No games found. Browse the categories:';

  @override
  String searchSimilar(String query) {
    return 'Nothing called “$query”. Did you mean:';
  }

  @override
  String searchAlternatives(String query) {
    return 'We don’t have “$query”, but you might like:';
  }

  @override
  String get yourGames => 'Your games';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '$count game',
    );
    return '$_temp0';
  }

  @override
  String get pinGame => 'Pin to your games';

  @override
  String get unpinGame => 'Unpin from your games';

  @override
  String pinnedToast(String name) {
    return '$name is pinned to your games';
  }

  @override
  String unpinnedToast(String name) {
    return '$name is unpinned';
  }

  @override
  String get famFlood => 'Flood';

  @override
  String get famFloodAbout => 'Paint the board until it is one color, in as few moves as you can';

  @override
  String get tagShade => 'shade cells, black out';

  @override
  String get tagLoop => 'draw a loop, cycle';

  @override
  String get tagPath => 'draw a path, line, route';

  @override
  String get tagNumbers => 'place numbers, digits';

  @override
  String get tagRegions => 'split into regions, areas, divide';

  @override
  String get tagSums => 'sums, add up, arithmetic, math, maths';

  @override
  String get tagLatin => 'Latin square';

  @override
  String get tagCompare => 'compare, greater, less, bigger, smaller, more, fewer, inequality, signs';

  @override
  String get tagPlace => 'place objects';

  @override
  String get tagPieces => 'pieces, shapes, tiles, blocks, fit, pack, jigsaw';

  @override
  String get tagConnect => 'connect, join, link, bridges';

  @override
  String get tagColors => 'colors, colours, paint';

  @override
  String get tagGuess => 'guess, word game';

  @override
  String get tagSlide => 'slide tiles, merge';

  @override
  String get tagArcade => 'arcade, action, reflexes';

  @override
  String get tagSymmetry => 'symmetry, symmetric';

  @override
  String get tagBinary => 'two symbols, binary';

  @override
  String get tagMaze => 'maze';

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
  String get highlightErrorsHint => 'Off: mistakes are only shown when you press Submit';

  @override
  String get autoClearMarks => 'Auto-remove pencil marks';

  @override
  String get autoClearMarksHint => 'Placing a number clears that note from its row, column and box';

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
  String get releaseNotes => 'Release notes';

  @override
  String get aboutCredits => 'Written with Claude Code, using Claude Opus 5.5';

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
  String get transferTitle => 'Move to another device';

  @override
  String get transferHint =>
      'Export here, import on the other device. Importing merges: wins, best times and daily results of both devices are kept, and the newer saved game wins.';

  @override
  String get transferExportFile => 'Export to a file';

  @override
  String get transferImportFile => 'Import from a file';

  @override
  String get transferCopy => 'Copy as text';

  @override
  String get transferPaste => 'Paste text';

  @override
  String get transferCopied => 'Progress copied. Paste it on the other device.';

  @override
  String get transferSaved => 'Progress saved to a file';

  @override
  String transferImported(int count) {
    return 'Progress merged. Updated records: $count';
  }

  @override
  String get transferNothingNew => 'Nothing new: this device already has it all';

  @override
  String get transferBadData => 'This is not APuzzle progress, or it is damaged';

  @override
  String get transferSaveFailed => 'Could not save the file';

  @override
  String get transferCopyFailed => 'Could not copy to the clipboard';

  @override
  String get installApp => 'Install app';

  @override
  String get installAppHint => 'Add APuzzle to your home screen; it opens in its own window';

  @override
  String get installAppIos => 'Tap Share in the browser, then “Add to Home Screen”.';

  @override
  String get submitConflicts => 'Some cells break the rules';

  @override
  String get submitIncomplete => 'Not finished yet';

  @override
  String get submitWrong => 'Not quite right';

  @override
  String get restartTitle => 'Restart puzzle?';

  @override
  String get restartBody => 'All your entries will be cleared. You can still undo.';

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
  String get generatingSlow => 'Good boards can take a few seconds to find.';

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
  String get codeOtherVersion => 'This code comes from a different app version, so the puzzle would not match';

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
      '• Place exactly one crown in every row, every column and every colored region.\n• Crowns may not touch each other, not even diagonally.\n\nTap a cell to cycle empty → dot (your \"no crown here\" note) → crown. Right-click cycles back. Slide across cells to mark them all in one go. A long press puts a dot on every cell the placed crowns rule out.';

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
  String get popModeStandardHint => 'Bubbles fall down; empty columns close up to the right.';

  @override
  String get popModeShifter => 'Shifter';

  @override
  String get popModeShifterHint => 'Rows also slide right to close every gap.';

  @override
  String get popModeContinuous => 'Continuous';

  @override
  String get popModeContinuousHint => 'New columns roll in from the left as space frees up.';

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
  String get popGoalFreeHint => 'No target: play it out and beat your best score.';

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
  String get mergeTagline => 'Slide the tiles, merge the twins, build the big one';

  @override
  String get mergeRules =>
      '• Swipe (or press an arrow key) to slide every tile as far as it goes that way.\n• Two tiles with the same number that run into each other merge into one with their sum. A tile merges only once per move.\n• After every move a new 2 (sometimes a 4) appears on an empty cell.\n• Each merge scores the new tile\'s value.\n\nGoals\n• Build the tile: reach the target tile (it depends on the board size and difficulty).\n• Free play: keep going until the board locks up, and beat your best score.\n\nThe game ends when the board is full and no two neighbours match.';

  @override
  String get mergeGoalTarget => 'Build the tile';

  @override
  String get mergeGoalTargetHint => 'Reach the target tile before the board locks up.';

  @override
  String get mergeGoalFreeHint => 'No target: play until the board locks up and beat your best score.';

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
  String get snakeName => 'Snake';

  @override
  String get snakeTagline => 'Eat the apples, grow longer, don\'t bite your tail';

  @override
  String get snakeRules =>
      '• The snake moves on its own. Swipe (or press an arrow key) to turn it.\n• Each apple makes it one cell longer and scores a point. It gets a little faster as it grows.\n• Running into a wall or into itself ends the run.\n• Tap the board (or press space) to pause, and swipe to go on.\n\nGoals\n• Free play: eat as many apples as you can, and beat your best score.\n• Apple target: eat the set number of apples (more on bigger boards and harder levels) without crashing.\n\nThe difficulty sets the speed.';

  @override
  String get snakeGoalTarget => 'Apple target';

  @override
  String get snakeGoalTargetHint => 'Eat a set number of apples without crashing.';

  @override
  String get snakeGoalFreeHint => 'No target: eat as many apples as you can before you crash.';

  @override
  String snakeFed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apples!',
      one: '1 apple!',
    );
    return '$_temp0';
  }

  @override
  String get snakeFull => 'The board is full!';

  @override
  String snakeApples(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apples',
      one: '1 apple',
    );
    return '$_temp0';
  }

  @override
  String snakeLength(int count) {
    return 'Length $count';
  }

  @override
  String get snakeStart => 'Swipe to start';

  @override
  String get snakePaused => 'Paused: swipe to go on';

  @override
  String get snakeCrashed => 'Crashed! Tap to try again';

  @override
  String get junctionName => 'Junction';

  @override
  String get junctionTagline => 'Flip the switches and send every train to its own station';

  @override
  String get junctionRules =>
      '• Trains come out of the tunnel one by one and run along the track on their own.\n• Every train carries a symbol, and its station has the same one.\n• At a switch the track splits in two. Tap a switch to flip it: the lever points at the branch the next train takes. A train takes the branch the switch is set to as it passes.\n• A train that reaches its own station scores; one that reaches another station is a miss.\n• Tap anywhere else on the board (or press space) to pause, and tap to go on.\n\nGoals\n• 20 trains: route a set number of trains and get as many as you can to their stations.\n• Timed: get as many trains to their stations as you can in two minutes.\n\nThe difficulty sets the speed, how often trains leave and how many stations there are; bigger boards have more switches.';

  @override
  String junctionGoalTrains(int count) {
    return '$count trains';
  }

  @override
  String get junctionGoalTrainsHint => 'Route a set number of trains and get as many as you can to their stations.';

  @override
  String junctionGoalTimed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String get junctionGoalTimedHint => 'Get as many trains to their stations as you can before the time runs out.';

  @override
  String junctionFinished(int count, int total) {
    return '$count of $total trains made it';
  }

  @override
  String get junctionTimeUp => 'Time\'s up!';

  @override
  String junctionArrived(int count) {
    return 'Arrived: $count';
  }

  @override
  String junctionMisses(int count) {
    return 'Missed: $count';
  }

  @override
  String get junctionStart => 'Tap to start';

  @override
  String get junctionPaused => 'Paused: tap to go on';

  @override
  String get junctionWrong => 'Wrong station! Tap to try again';

  @override
  String get turnaboutName => 'Turnabout';

  @override
  String get turnaboutTagline => 'Race a rival to the star through a maze that keeps turning';

  @override
  String get turnaboutRules =>
      '• You and a rival start in opposite corners of a maze, with a star between you, just as far from both.\n• Swipe (or press an arrow key) to move one cell; keep the swipe going to move on. The rival runs the shortest way at its own pace.\n• Every few seconds the whole maze makes a quarter turn (on hard sometimes a half turn). An arrow warns you just before. Your moves stay on screen: up is always up on the screen.\n• Whoever reaches the star first wins the round. Every round is a new maze.\n• Tap the board (or press space) to pause.\n\nGoals\n• 5 rounds: win as many rounds as you can.\n• 3 lives: play on until the rival has won three rounds; it gets a little faster as you win.\n\nThe difficulty sets the rival\'s pace, the mazes and how often they turn.';

  @override
  String get turnaboutGoalRoundsHint => 'Race a set number of rounds and win as many as you can.';

  @override
  String turnaboutGoalLivesHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rounds',
      one: 'a round',
    );
    return 'Race on until the rival has won $_temp0; it gets faster as you win. Beat your best score.';
  }

  @override
  String turnaboutFinished(int count, int total) {
    return 'You won $count of $total rounds';
  }

  @override
  String turnaboutStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rounds won',
      one: '1 round won',
      zero: 'No rounds won',
    );
    return '$_temp0';
  }

  @override
  String turnaboutRound(int round) {
    return 'Round $round';
  }

  @override
  String turnaboutScore(int wins, int losses) {
    return 'You $wins : $losses Rival';
  }

  @override
  String get turnaboutStart => 'Swipe to start';

  @override
  String get turnaboutPaused => 'Paused: swipe to go on';

  @override
  String get turnaboutWon => 'The star is yours! Swipe for the next round';

  @override
  String get turnaboutLost => 'The rival got there first. Swipe for the next round';

  @override
  String get turnaboutLostPractice => 'The rival got there first! Tap to try again';

  @override
  String get pipesName => 'Pipes';

  @override
  String get pipesTagline => 'Connect every pipe to the source';

  @override
  String get pipesRules =>
      '• Rotate the tiles so that every pipe connects back to the source (the ringed tile).\n• No pipe end may be left open, and the network may not contain loops.\n• Water flows through everything already connected to the source.\n• Tiles with a dot in the corner are fixed and already in place.\n\nTap a tile to rotate it clockwise; long-press / right-click rotates it back.';

  @override
  String get famPlumbing => 'Plumbing';

  @override
  String get famPlumbingAbout => 'Turn the pipe tiles until the water flows where it should';

  @override
  String get channelName => 'Channel';

  @override
  String get channelTagline => 'Lead the water from the source to the drain';

  @override
  String get channelRules =>
      '• Turn the tiles so that one pipe carries the water from the source (the ringed tile) to the drain (the tile with the square).\n• The other tiles don\'t matter, and pipe ends may stay open.\n• Water leaves a tile by all its other ends, but it goes straight across a bridge (a crossing), so the pipe can pass a bridge twice.\n• Tiles with a dot in the corner are fixed and already in place.\n\nTap a tile to rotate it clockwise; long-press / right-click rotates it back.';

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
  String get tagDrive => 'drive, car, taxi, pick up, deliver, pets, animals, fuel, route planning';

  @override
  String get homewardName => 'Homeward';

  @override
  String get homewardTagline => 'Drive every pet home before the fuel runs out';

  @override
  String get homewardRules =>
      '• Drive the car along the roads. Every road between two crossings takes one unit of fuel.\n• Drive to a pet to pick it up, then drive to the home with the same symbol to drop it off. Both happen by themselves.\n• The car has only so many seats: a pet you reach while every seat is taken keeps waiting. With a seat free, it always gets in.\n• Bring every pet home before the fuel runs out.\n\nTap a crossing next to the car, or one further along a straight road, to drive there. Or drag along the roads. If the fuel runs out, undo or restart.';

  @override
  String homewardFuel(int left, int limit) {
    return 'Fuel $left / $limit';
  }

  @override
  String get homewardOutOfFuel => 'Out of fuel: undo or restart';

  @override
  String get tutHomeward1 =>
      'Tap a crossing next to the car to drive there. Every road costs one unit of fuel. Drive to the pet to pick it up, then bring it to the home with the same symbol.';

  @override
  String get tutHomeward2 =>
      'This car has one seat. A pet you reach while the seat is taken keeps waiting, so take one pet home before you fetch the next. Bring both home.';

  @override
  String get tutHomeward3 =>
      'Now there\'s no fuel to spare, and the car has two seats. Rushing to the nearest pet isn\'t always best: plan a drive that picks up both pets and then passes both homes.';

  @override
  String get tutHomeward4 =>
      'Now a real board. Before you set off, look where each pet lives, and plan a drive that passes pets and homes on the way.';

  @override
  String get tutHomewardS1 =>
      'Chain the trips: plan so that each drop-off lies on the way to the next pet, and pick up a pet early when its home lies along a road you will drive anyway. This board has no fuel to spare.';

  @override
  String get tutHomewardS2 =>
      'Hard boards leave no fuel to spare and give the car only two seats. Plan the whole drive before the first road: a seat taken too early makes you drive past a pet you need, so sometimes take another road around a pet.';

  @override
  String get blockadeName => 'Blockade';

  @override
  String get blockadeTagline => 'Slip past the patrol ships into the harbour';

  @override
  String get blockadeRules =>
      '• Sail the boat to the harbour. Each turn the boat moves one cell (up, down, left or right) or waits where it is. Rocks block the way.\n• After every turn, each patrol ship sails one cell along its beat: back and forth along a line, or round and round a loop. Its beat is drawn on the board, and a ring shows where the ship will be after your next turn.\n• Don\'t get caught: never end a turn on a ship\'s cell, and never swap places with a ship. No ship ever enters the start or the harbour.\n• Reach the harbour within the turns you have.\n\nTap a cell next to the boat to sail there, or drag. Tap the boat or Wait to stay put for a turn. On a keyboard, use the arrow keys and the space bar. If you\'re caught or out of turns, undo or restart.';

  @override
  String blockadeTurn(int turn, int limit) {
    return 'Turn $turn / $limit';
  }

  @override
  String get blockadeWait => 'Wait';

  @override
  String get blockadeCaught => 'Caught by a patrol ship: undo or restart';

  @override
  String get blockadeOutOfTurns => 'Out of turns: undo or restart';

  @override
  String get tutBlockade1 =>
      'Tap a cell next to the boat to sail there, one cell per turn. Rocks block the way. Sail to the harbour.';

  @override
  String get tutBlockade2 =>
      'After each of your turns, every patrol ship sails one cell along its beat, and the ring shows where it goes next. Don\'t end a turn where a ship will be, and don\'t swap places with one. Tap the boat or Wait to stay put for a turn.';

  @override
  String get tutBlockade3 =>
      'This ship sails round and round the island, and there are no turns to spare: the counter shows how many you have. The short way runs head-on into the ship, and there\'s no time to wait. Go round the island the other way, right behind the ship.';

  @override
  String get tutBlockade4 =>
      'Now a real board. Before you set off, watch where each ship goes and plan when to pass each one.';

  @override
  String get tutBlockadeS1 =>
      'A ship never surprises you: its dots show its whole beat, and the ring shows where it will be after your turn. You may sail into a cell a ship is just leaving, as long as it isn\'t coming to the cell you leave. Here there are no turns to spare: count the ships\' beats and slip through the gaps.';

  @override
  String get tutBlockadeS2 =>
      'Hard boards leave no turns to spare. Plan the whole passage before the first turn: if you must wait, wait where no ship comes, and a detour right behind a ship often beats waiting for it.';

  @override
  String get campName => 'Campsite';

  @override
  String get campTagline => 'Pitch a tent next to every tree';

  @override
  String get campRules =>
      '• Pitch one tent for every tree, right next to it (up, down, left or right).\n• Every tree gets its own tent, and every tent belongs to one tree next to it.\n• Tents never touch each other, not even diagonally.\n• The numbers outside the grid tell how many tents are in each row and column.\n\nTap a cell to cycle empty → grass (your \"no tent here\" note) → tent. Right-click cycles back. Slide across cells to mark them all in one go. A long press puts grass on every cell where the placed tents leave no room for another.';

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
      '• Place lamps in the empty cells (not on walls). A lamp lights its own cell and its row and column until a wall.\n• Every empty cell must be lit.\n• No lamp may shine on another lamp.\n• A number on a wall tells how many lamps are right next to it (up, down, left or right).\n\nTap a cell to cycle empty → dot (your \"no lamp\" note) → lamp. Long-press / right-click cycles back.';

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
  String get railsName => 'Rails';

  @override
  String get railsTagline => 'Lay one track from the entry to the exit';

  @override
  String get railsRules =>
      '• Lay one track through the centers of the cells, from the entry on the left edge to the exit on the bottom edge.\n• The track never branches, crosses itself or closes into a loop, and it doesn\'t have to visit every cell.\n• The numbers above and to the right of the grid tell how many cells of each column and row the track passes through.\n• Pieces already on the board are fixed: the track runs through them exactly as shown.\n\nDrag through cells to lay track, or drag along it to erase. Tap the center of a cell to cycle empty → track note → dot (your \"no track here\" note), or tap between two cells to cycle track → cross → empty.';

  @override
  String get blocksName => 'Blocks';

  @override
  String get blocksTagline => 'Numbers 1 to k in every region of k cells';

  @override
  String get blocksRules =>
      '• Fill every cell with a number.\n• A region of k cells holds each number from 1 to k exactly once (a region of one cell holds a 1).\n• Equal numbers never touch, not even diagonally.\n• Given numbers are fixed.\n\nPick a number in the palette and tap cells to place it, or tap a cell first and then a number. The pencil button toggles small notes. Long-press / right-click clears a cell.';

  @override
  String get pairsName => 'Pairs';

  @override
  String get pairsTagline => 'Two shaded cells in every region, side by side';

  @override
  String get pairsRules =>
      '• Shade exactly two cells in every outlined region.\n• Every shaded cell touches exactly one other shaded cell side by side, so the shading is all pairs.\n• Pairs never touch each other side by side (corners are fine).\n\nTap a cell to cycle empty → shaded → dot (your \"not shaded\" note). Right-click cycles back. Slide across cells to mark them all in one go. A long press puts a dot on every cell the finished pairs rule out.';

  @override
  String get plotsName => 'Plots';

  @override
  String get plotsTagline => 'Split the grid into plots as big as their numbers';

  @override
  String get plotsRules =>
      '• Fill every cell with a number.\n• Equal numbers that touch side by side form a plot, and a plot has exactly as many cells as its number: a 3 lies in a plot of three cells.\n• Two plots of the same size never touch side by side (they would be one plot).\n• Some plots show no number at all.\n\nPick a number in the palette and tap cells to fill them, or tap a cell first and then a number. Lines appear between different numbers, so you can see the plots take shape.';

  @override
  String get linksName => 'Links';

  @override
  String get linksTagline => 'Join the pairs and fill the grid';

  @override
  String get linksRules =>
      '• Join each pair of equal dots with a path through neighbouring cells (no diagonals).\n• Paths never cross, branch or share a cell.\n• Together the paths fill every cell of the grid.\n\nDrag from a dot to draw its path; drawing across another path cuts it. Tap a dot to clear its path, or a cell of a path to cut the path there.';

  @override
  String get arrowsName => 'Arrows';

  @override
  String get arrowsTagline => 'Shade what the arrows count, loop through the rest';

  @override
  String get arrowsRules =>
      '• Shade some cells. Shaded cells never touch side by side.\n• Draw one closed loop through the centers of all the other cells. It never branches or crosses itself.\n• Clue cells (a number and an arrow) are neither shaded nor on the loop. A clue\'s number counts the shaded cells in its arrow\'s direction, all the way to the edge.\n\nDrag through cells to draw the loop, or along it to erase. Tap the center of a cell to cycle empty → shaded → dot (your \"on the loop\" note), or tap between two cells to cycle line → cross → empty.';

  @override
  String get learnTitle => 'How to play';

  @override
  String get learnIntro => 'Short interactive lessons: every step is a tiny board that shows one rule or trick.';

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
  String get tutorialOfferBody => 'Take a quick interactive lesson first? A few tiny boards show you every rule.';

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
  String get tutorialStrategies => 'Learn strategies';

  @override
  String strategiesTitle(String name) {
    return '$name strategies';
  }

  @override
  String strategiesFinishedBody(String name) {
    return 'You know the main techniques for solving $name.';
  }

  @override
  String get learnBasicsTab => 'Basics';

  @override
  String get learnStrategiesTab => 'Strategies';

  @override
  String get learnStrategiesIntro =>
      'For when you know the rules: each lesson shows a technique that strong players use, on a board that needs it.';

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
  String get tutMambo4 => 'A × means the two cells are different: one sun, one moon.';

  @override
  String get tutMambo5 =>
      'Now a whole board: use every rule together. Tip: the palette button at the top lets you stamp one symbol on many cells, and a long press (or right-click) cycles backwards.';

  @override
  String get tutMamboS1 =>
      'When no rule applies directly, ask “what if?”. The highlighted pair is joined by =, so both cells hold the same symbol. Two suns would give the top row three suns out of four, so both are moons.';

  @override
  String get tutMamboS2 =>
      'A harder board, where you\'ll need that trick often: try a symbol in a cell and follow the rules a few steps. If something breaks, the other symbol is right. A × pair always holds one of each, so it counts as one sun and one moon in its row.';

  @override
  String get tutSudoku1 =>
      'Each row, column and box (the thick outlines) holds every number from 1 to 4 once. This row is missing one number: pick it in the palette, then tap the empty cell.';

  @override
  String get tutSudoku2 =>
      'By their row, these two cells could be 3 or 4. Their columns decide: each column is missing just one number.';

  @override
  String get tutSudoku3 => 'The boxes count too: every box needs 1 to 4 once. Finish the last box.';

  @override
  String get tutSudoku4 =>
      'Not sure yet? Take notes. Turn on the pencil next to the palette, select the highlighted cell and note every number it could still hold.';

  @override
  String get tutSudoku5 =>
      'Now a whole puzzle. Selecting a cell tints its row, column and box, and highlights the same number elsewhere. Settings can remove notes for you when you place a number.';

  @override
  String get tutSudokuS1 =>
      'Look at one number instead of one cell. The highlighted box needs a 1: the 1s in its columns and in its second row rule out every cell but one. Then finish the board the same way.';

  @override
  String get tutSudokuS2 =>
      'Two more tricks. Pairs: two cells of a line or box that can only hold the same two numbers claim them. Pointing: if a box\'s spots for a number share a line, the rest of that line can\'t have it.';

  @override
  String get tutSudokuS3 =>
      'Hidden pairs: when two numbers fit only in the same two cells of a row, column or box, those cells belong to them, so every other note there can go. The same works for three numbers in three cells.';

  @override
  String get tutSudokuS4 =>
      'X-Wing: in two rows a number fits only in the same two columns. One row takes the left spot and the other the right one, so the rest of both columns can\'t have it. With three rows and columns it\'s a Swordfish.';

  @override
  String get tutSudokuS5 =>
      'Y-Wing: a cell that holds x or y sees one cell of x or z and one of y or z. Whatever the first one is, one of the others is z, so z is ruled out wherever both of them see.';

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
  String get tutKingsS1 =>
      'Look for a region that fits in one row or column. The highlighted region lies entirely in the bottom row, so that row\'s crown is in it: dot the other cells of the bottom row, then carry on.';

  @override
  String get tutKingsS2 =>
      'Another trick: if a crown in a cell would rule out every cell of another region (by its row, its column or by touching), that cell can\'t hold a crown. Dot it. The same works for two regions squeezed into two rows.';

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
  String get tutHuesS1 =>
      'Rule out colors. Each highlighted cell touches the blue 0, so it can\'t be blue, and the pink 0, so it can\'t be pink. Only yellow is left.';

  @override
  String get tutHuesS2 =>
      'A harder board. Compare numbers that share blank neighbors: what one still needs may already be used up by the other. When stuck, try a color in a cell and see whether some number breaks.';

  @override
  String get tutMosaic1 =>
      'The patch in the top-left corner is yours. Pick a color below: your patch takes it and swallows every touching cell of that color. Turn the whole board one color.';

  @override
  String get tutMosaic2 =>
      'Mind the move limit: pick the color that grows your patch the most. Tapping a cell on the board also picks its color.';

  @override
  String get tutMosaic3 => 'Now a real board, with a few moves to spare.';

  @override
  String get tutMosaicS1 =>
      'Plan ahead. Reach the middle of the board early, since your patch then touches more colors, and whenever you can, pick a color that wipes that color off the board.';

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
  String get tutBlendS1 =>
      'Pick one patch in the middle and keep repainting it: each move then swallows every touching patch of the new color. Choose the color that most of its neighbors share.';

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
  String get tutPopS1 =>
      'Clearing a board takes planning. Before popping, ask what falls into the gap: pop groups that bring bubbles of one color together, and never leave a single bubble of a color on its own.';

  @override
  String get tutPopS2 =>
      'Chasing points: a group of n scores n × (n − 1), so one group of 8 (56) beats four groups of 2 (8). Pop the other colors first to merge a color into one big group.';

  @override
  String get tutMerge1 =>
      'Swipe (or press an arrow key) to slide every tile as far as it goes. Two equal tiles that meet merge into their sum. Make a 4.';

  @override
  String get tutMerge2 =>
      'A tile merges only once per move: 4, 4, 8 slides into 8, 8, not 16. After every move a new 2 (sometimes a 4) appears. Build a 16.';

  @override
  String get tutMerge3 => 'Keep your biggest tile in a corner and feed it step by step. Build a 32.';

  @override
  String get tutMergeS1 =>
      'Build a chain: keep your tiles in order along one row with the biggest in the corner, like 64, 32, 16, 8. Then one new 8 at the end rolls all the way up. Make 128.';

  @override
  String get tutSnake1 =>
      'The snake moves on its own: swipe (or press an arrow key) to turn it. It can\'t turn right back. Lead it to the apple.';

  @override
  String get tutSnake2 =>
      'Every apple makes the snake one cell longer. Don\'t run into a wall or into your own body. Eat 3 apples.';

  @override
  String get tutSnake3 => 'A real board: eat 5 apples. Tap the board to pause, and swipe to go on.';

  @override
  String get tutSnakeS1 =>
      'A long snake needs room. Before you grab an apple, make sure you can get out again: the cells your tail leaves are always free, so following your tail is the safe way. Eat 3 apples.';

  @override
  String get tutJunction1 =>
      'Trains come out of the tunnel and run on their own. Tap the switch to flip it: the lever points where the next train goes. Send each train to the station with its symbol. Tap the board to start.';

  @override
  String get tutJunction2 =>
      'A train takes the branch a switch is set to as it passes, so set each switch before the train gets there, and flip it back for the next one if needed. Tap the board away from the switches to pause.';

  @override
  String get tutJunction3 =>
      'A real board: get 6 trains to their stations. Watch the trains coming out of the tunnel and set the switches ahead of them.';

  @override
  String get tutTurnabout1 =>
      'Swipe (or press an arrow key) to move your runner, the round piece, one cell. Keep the swipe going to move on. Walls block the way. Reach the star.';

  @override
  String get tutTurnabout2 =>
      'Every few seconds the whole maze turns, and a round arrow warns you just before. Your swipes stay on screen: up is always up, so the way to the star may now lie in another direction. Reach the star.';

  @override
  String get tutTurnabout3 =>
      'A race: the rival, the diamond, runs to the star the shortest way. Get there first! The round starts with your first move; tap the board to pause.';

  @override
  String get tutPipes1 =>
      'Tap a tile to turn it clockwise (a long press or right-click turns it back). Connect every pipe to the source, the ringed tile. Water shows what\'s already connected.';

  @override
  String get tutPipes2 =>
      'No pipe end may stay open, so no pipe can point off the board. Tiles with a dot in the corner are fixed and already right. Start at the edges and corners, where tiles have the fewest ways to turn.';

  @override
  String get tutPipes3 => 'Now a real board. The network may not form loops.';

  @override
  String get tutPipesS1 =>
      'Work inward from the rim. A straight on the edge must run along it, a corner holds only an elbow pointing inward, and a T on the edge turns its flat side to the edge. Every tile you settle limits its neighbors.';

  @override
  String get tutPipesS2 =>
      'A hard board. The network may not form a loop: if turning a tile would close one, it must point elsewhere. And two dead ends never face each other, or they\'d form a pair cut off from the rest.';

  @override
  String get tutChannel1 =>
      'Tap a tile to turn it clockwise (a long press or right-click turns it back). Lead the water from the source, the ringed tile, to the drain, the tile with the square.';

  @override
  String get tutChannel2 =>
      'Only the pipe from the source to the drain counts: other tiles may point anywhere, and ends may stay open. Water leaves a tile by all its other ends, so a T carries it on even if its third end leads nowhere.';

  @override
  String get tutChannel3 =>
      'A crossing is a bridge: water goes straight across it and never turns there, so the pipe can pass it twice, once along and once across.';

  @override
  String get tutChannel4 => 'Now a real board. Many tiles are there only to lead you astray.';

  @override
  String get tutChannelS1 =>
      'Work from both ends. The drain is fixed too, so follow the pipe back from it as well: a straight must go on, a bend must turn, and the edge cuts off ways. Join the two stretches where they can meet.';

  @override
  String get tutChannelS2 =>
      'A hard board, with bridges. When a way runs into a dead end, off the board or into tiles that can\'t take the water, go back to the last tile where you had a choice and try another way.';

  @override
  String get tutShikaku1 =>
      'Split the grid into rectangles. Each holds exactly one number, equal to its area in cells. Drag from one corner to the opposite one to draw a rectangle.';

  @override
  String get tutShikaku2 =>
      'A 1 is a rectangle on its own: just tap it. Tap a drawn rectangle to remove it. Here the 6 fits only one way.';

  @override
  String get tutShikaku3 => 'Now a real board. Big numbers near the edges usually have the fewest ways to fit.';

  @override
  String get tutShikakuS1 =>
      'Ask which numbers can reach a cell. The bottom-left corner is too far for the 4 and the 6 to cover with a rectangle of their size, so it belongs to the 2.';

  @override
  String get tutShikakuS2 =>
      'A hard board. List the few rectangles a big number could use: cells that all of them cover belong to it, and a cell only one number can reach belongs to that number.';

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
  String get tutTrailS1 =>
      'Cells with only two free neighbors must be passed straight through: the path comes in one side and leaves by the other. Watch for cells your own path has just boxed in.';

  @override
  String get tutTrailS2 =>
      'A hard board. Never cut the free cells into two parts: the path can\'t come back for the other part. And a cell with only one free neighbor is a dead end, allowed only for the last number.';

  @override
  String get tutLabyrinth1 =>
      'Drag from the start in the top-left corner and walk to the flag in the bottom-right corner. Walls block the way.';

  @override
  String get tutLabyrinth2 =>
      'A bigger maze. Hit a dead end? Drag back along your path, or tap any cell of it to return there. A quick drag follows straight corridors.';

  @override
  String get tutLabyrinthS1 =>
      'Lost? Keep one hand on a wall: always take the rightmost opening. In a maze like this it always leads out, though not by the shortest way.';

  @override
  String get tutLabyrinthS2 =>
      'Or work backwards: trace the way from the flag toward the start, and look for where the two routes meet. Dead ends near the flag are ruled out fast that way.';

  @override
  String get tutAtoms1 =>
      'Connect the atoms with bonds. Each atom needs as many bonds as its number, and two atoms can share one or two. Drag from an atom toward a neighbour to add a bond (1 → 2 → none).';

  @override
  String get tutAtoms2 =>
      'All atoms must join into one molecule, and bonds can\'t cross. Bonding the top-left 1 downwards would leave two separate pairs, so where does its bond go?';

  @override
  String get tutAtoms3 => 'Now a real board. Start with atoms that have only one way to get their bonds.';

  @override
  String get tutAtomsS1 =>
      'Compare an atom\'s number with its neighbors. The 4 in the corner has just two neighbors, and a pair can share at most two bonds, so both bonds are double. Likewise a 3 with two neighbors gets at least one bond to each.';

  @override
  String get tutAtomsS2 =>
      'A hard board. Keep the molecule in one piece: two 1s never bond to each other, and two 2s never share a double bond, unless they\'re the only atoms. When stuck, try a bond and see if part of the board gets cut off.';

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
  String get tutLitsS1 =>
      'List the shapes each region can still hold. Cells that every possible shape covers are shaded, and cells that none covers stay empty. Small regions and regions squeezed by the 2×2 rule have the fewest options.';

  @override
  String get tutLitsS2 =>
      'A harder board. When stuck, try one shape in a region: if it makes a 2×2 block, cuts the shaded area in two or puts two equal shapes side by side, it\'s wrong.';

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
  String get tutCampS1 =>
      'Count the gaps. The top row needs 2 tents, and only its three highlighted cells can hold one. Two tents in three cells that may not touch must take both ends.';

  @override
  String get tutCampS2 =>
      'A hard board, and some counts are hidden. When stuck, try a tent on a spot: if some tree is left with no place for its own tent, that spot is grass.';

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
  String get tutIslands4 => 'Now a real board. Every island holds exactly one number.';

  @override
  String get tutIslandsS1 =>
      'Find cells no island can reach. The 3 grows at most two steps from its number, the 2 one step and the 1 none. The highlighted cells are out of every island\'s reach, so they\'re sea.';

  @override
  String get tutIslandsS2 =>
      'A hard board. Keep the sea in mind: it must stay connected, so a sea cell with one way out continues that way, and it may not form a 2×2 pool. When stuck, try a cell as land and see whether something breaks.';

  @override
  String get tutLamps1 =>
      'Put lamps in the empty cells: tap twice (a dot, then a lamp). The dark cells are walls. A lamp lights its own row and column up to the walls. Light up every empty cell.';

  @override
  String get tutLamps2 =>
      'A number on a wall tells how many lamps touch it (up, down, left or right). This 3 needs a lamp on each of its free sides.';

  @override
  String get tutLamps3 =>
      'Lamps may never shine on each other, and a 0 means no lamp right next to it. Where does the second lamp go?';

  @override
  String get tutLamps4 => 'Now a real board. Dots help you mark cells that can\'t hold a lamp.';

  @override
  String get tutLampsS1 =>
      'Some cells have just one way to get light. The top-left corner can only be lit from itself or its two neighbors, and the 0 rules the neighbors out: the lamp goes in the corner. Then look at the 1.';

  @override
  String get tutLampsS2 =>
      'A hard board. When stuck, try a lamp on a cell and follow what it forces: if some cell can no longer be lit, or a number can\'t be met, that cell gets a dot.';

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
  String get tutFenceS1 =>
      'Learn a few patterns. Two 3s side by side always have a line between them and a line on each far side: any other way leaves one of them short. The 0 above helps too.';

  @override
  String get tutFenceS2 =>
      'Corners are strong. A 1 in a corner never uses its two outer sides: the loop would have to turn right there and use both. A 3 in a corner always uses both.';

  @override
  String get tutFenceS3 =>
      'A hard board. When stuck, try a line on one edge and follow it: if it leads to a dead end, a number it can\'t satisfy, or a small loop that leaves others out, that edge gets a cross.';

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
  String get tutPearlsS1 =>
      'A black pearl can\'t turn toward an edge that\'s too close: the loop needs two straight cells on each side. Both black pearls here are too close to two edges, so their directions are fixed.';

  @override
  String get tutPearlsS2 =>
      'A hard board. Three white pearls in a row can\'t all lie on one straight stretch (the middle one needs a turn next to it), so the loop crosses them. When stuck, try a line and see if some pearl breaks.';

  @override
  String get tutRails1 =>
      'Drag through the cells to lay one track from the entry on the left to the exit at the bottom. The numbers above and to the right count the track cells in each column and row.';

  @override
  String get tutRails2 =>
      'Pieces already on the board are fixed: the track runs through them exactly as shown. A 0 means no track in that row or column at all.';

  @override
  String get tutRails3 =>
      'Now a real board. The track never branches or crosses itself, and it doesn\'t have to visit every cell.';

  @override
  String get tutRailsS1 =>
      'Start with lines whose count leaves no choice. The second row needs 4 track cells and has only 4, and so does the right column. Then join the ends.';

  @override
  String get tutRailsS2 =>
      'A hard board. A count that\'s already used up blocks the rest of its line, and a track cell always needs exactly two track neighbors. When stuck, try a piece and check that the counts still fit.';

  @override
  String get tutBlocks1 =>
      'Every region of k cells holds the numbers 1 to k once each. Each highlighted cell is the last gap in its region: pick the missing number in the palette, then tap the cell.';

  @override
  String get tutBlocks2 =>
      'Equal numbers never touch, not even at the corners. The top-left region needs a 1 and a 2, and one of its cells already touches a 2. Fill the bottom row the same way.';

  @override
  String get tutBlocks3 =>
      'Now a real board. Start with small regions and with cells whose neighbours rule out most numbers. Pencil notes help.';

  @override
  String get tutBlocksS1 =>
      'Pointing: note where each region can still put a number. When all those cells touch the same outside cell, that cell can\'t hold the number, since it would touch it. Pencil notes help you see it.';

  @override
  String get tutBlocksS2 =>
      'A hard board. When nothing else works, pick a cell with just two possible numbers and try one: if it soon leaves a region with no place for a number, the other one is right.';

  @override
  String get tutPairs1 =>
      'Shade exactly two cells in every region, so that each shaded cell touches exactly one other: the shading comes in pairs. The highlighted region has just two cells, so shade both.';

  @override
  String get tutPairs2 =>
      'Pairs never touch each other side by side. The top pair is finished, so the highlighted cells next to it stay unshaded: put a dot there (tap twice), then finish the board.';

  @override
  String get tutPairs3 => 'Now a real board. Small regions and cells boxed in by dots are good places to start.';

  @override
  String get tutPairsS1 =>
      'Try every way to finish a small region: a cell shaded in all of them is shaded, and a cell shaded in none gets a dot. An L of three cells, for example, always shades its corner.';

  @override
  String get tutPairsS2 =>
      'A hard board. When stuck, shade a cell and follow the rules: if some region can no longer get its two cells, or two pairs would touch, that cell stays unshaded.';

  @override
  String get tutPlots1 =>
      'Fill every cell with a number. Equal numbers that touch side by side form a plot with exactly that many cells. The highlighted 3 needs two more cells for its plot.';

  @override
  String get tutPlots2 =>
      'Two plots of the same size can\'t touch: they would join into one plot that is too big. The highlighted cell touches two plots of 2, so it can\'t be a 2.';

  @override
  String get tutPlots3 =>
      'Now a real board. Some plots show no number at all: work out their size from the room that\'s left.';

  @override
  String get tutPlotsS1 =>
      'Look for pockets. The two highlighted cells are fenced in by finished plots, so they can only join each other. Two 1s may not touch, so together they are a plot of 2.';

  @override
  String get tutPlotsS2 =>
      'A hard board. When nothing is certain, pick a cell with only two or three possible numbers and test each one: a number that leaves some plot unable to reach its size is out.';

  @override
  String get tutLinks1 =>
      'Drag from a dot to its twin to join them. Paths go through neighbouring cells, never diagonally.';

  @override
  String get tutLinks2 =>
      'Paths never cross, and together they fill every cell, so some have to take the long way round.';

  @override
  String get tutLinks3 => 'Now a real board. Corners and edges leave the fewest ways to go, so start there.';

  @override
  String get tutLinksS1 =>
      'Fill the tight spots first. An empty corner has only two neighbors, so the path through it uses both. The same goes for any cell squeezed down to two free neighbors.';

  @override
  String get tutLinksS2 =>
      'A hard board. In a puzzle with one answer, a path never folds back beside itself (it could take a shortcut), so no 2×2 square belongs to a single path. And never leave an empty cell that no path can still reach.';

  @override
  String get tutArrows1 =>
      'Draw one loop through the centers of all the empty cells: drag from cell to cell. The clue cell in the middle is never on the loop. Its 0 says no cell above it is shaded, so here nothing is.';

  @override
  String get tutArrows2 =>
      'Now two cells must be shaded. Each clue counts the shaded cells in its arrow\'s direction: find them and tap their centers to shade them. Shaded cells never touch side by side. Then draw the loop through all the other cells.';

  @override
  String get tutArrows3 =>
      'Now a real board. Cells next to a shaded cell are always on the loop, and a loop cell needs two ways out.';

  @override
  String get tutArrowsS1 =>
      'Look for tight clues. The 2 in the middle row has just three cells to its right, and its two shaded cells may not touch, so they take the first and the last. The 2 in the top row is even easier: it has only two free cells.';

  @override
  String get tutArrowsS2 =>
      'A hard board. Every cell that isn\'t shaded or a clue is on the loop, so a cell with only two free neighbors has its path fixed. When stuck, try shading a cell and see if a loop cell is left with fewer than two ways out.';

  @override
  String get tutMines1 =>
      'A number counts the mines in the 8 cells around it. Each 1 here touches just one closed cell, so that cell is a mine. Flag it: long-press or right-click it, or switch to Flag below and tap it.';

  @override
  String get tutMines2 =>
      'This 1 already has its mine flagged, so every other cell around it is safe. Dig them, or tap the 1 itself to dig them all at once.';

  @override
  String get tutMines3 => 'A cell with no mines around it opens its neighbours for you. Dig the highlighted corner.';

  @override
  String get tutMines4 =>
      'Now a real board. You never need to guess. If you dig a mine by mistake, it just gets flagged and the game goes on.';

  @override
  String get tutMinesS1 =>
      'Compare neighboring numbers. The 2 sees three closed cells, the 1 on its left sees only the first two, so the third one is a mine. The same works from the right. Then the middle cell is safe.';

  @override
  String get tutMinesS2 =>
      'A hard board. Keep comparing numbers that share closed cells. Near the end, count what\'s left: the mine counter can settle the last closed cells.';

  @override
  String get explain => 'Explain';

  @override
  String get explainTooltip => 'Explain the next step';

  @override
  String get explainClose => 'Close';

  @override
  String get explainApply => 'Do it';

  @override
  String get explainWhy => 'Why?';

  @override
  String get explainNone => 'Nothing left to explain.';

  @override
  String exWrong(Object cell) {
    return '$cell doesn\'t match the solution. Clear it first.';
  }

  @override
  String exFallback(Object cell) {
    return 'No logical step found here, so $cell is filled in from the solution.';
  }

  @override
  String exSuppose(Object cell, Object value) {
    return 'Suppose $cell were $value.';
  }

  @override
  String exRefutedBinary(Object cell, Object value, Object other) {
    return '$cell must be $value: $other there leads to a contradiction.';
  }

  @override
  String exRefuted(Object cell, Object value) {
    return '$cell can\'t be $value: it leads to a contradiction.';
  }

  @override
  String exMamboPair(Object cell, Object value, Object a, Object b, Object other) {
    return '$cell must be $value: otherwise $a, $b and $cell would be three $other in a row.';
  }

  @override
  String exMamboGap(Object cell, Object value, Object a, Object b, Object other) {
    return '$cell must be $value: it sits between $a and $b, which are both $other.';
  }

  @override
  String exMamboHalfRow(Object cell, Object value, Object row, Object count, Object other) {
    return '$cell must be $value: row $row already has all its $count $other.';
  }

  @override
  String exMamboHalfCol(Object cell, Object value, Object col, Object count, Object other) {
    return '$cell must be $value: column $col already has all its $count $other.';
  }

  @override
  String exMamboSame(Object cell, Object value, Object a) {
    return '$cell must be $value: the = sign links it to $a, which is $value.';
  }

  @override
  String exMamboDiff(Object cell, Object value, Object a, Object other) {
    return '$cell must be $value: the × sign links it to $a, which is $other.';
  }

  @override
  String exMamboFailThree(Object a, Object b, Object c, Object value) {
    return 'But then $a, $b and $c are three $value in a row.';
  }

  @override
  String exMamboFailHalfRow(Object row, Object count, Object value) {
    return 'But then row $row has more than $count $value.';
  }

  @override
  String exMamboFailHalfCol(Object col, Object count, Object value) {
    return 'But then column $col has more than $count $value.';
  }

  @override
  String exMamboFailSame(Object a, Object b) {
    return 'But then $a and $b differ, despite the = sign between them.';
  }

  @override
  String exMamboFailDiff(Object a, Object b) {
    return 'But then $a and $b match, despite the × sign between them.';
  }

  @override
  String exSudokuNaked(Object cell, Object value) {
    return '$cell must be $value: every other digit is already in its row, column or box.';
  }

  @override
  String exSudokuHiddenRow(Object cell, Object value, Object row) {
    return '$cell must be $value: it\'s the only place left for $value in row $row.';
  }

  @override
  String exSudokuHiddenCol(Object cell, Object value, Object col) {
    return '$cell must be $value: it\'s the only place left for $value in column $col.';
  }

  @override
  String exSudokuHiddenBox(Object cell, Object value, Object box) {
    return '$cell must be $value: it\'s the only place left for $value in box $box.';
  }

  @override
  String exSudokuPointingRow(Object box, Object value, Object row) {
    return 'In box $box, $value can only go in row $row, so it\'s ruled out in the rest of row $row.';
  }

  @override
  String exSudokuPointingCol(Object box, Object value, Object col) {
    return 'In box $box, $value can only go in column $col, so it\'s ruled out in the rest of column $col.';
  }

  @override
  String exSudokuClaimingRow(Object row, Object value, Object box) {
    return 'In row $row, $value can only go in box $box, so it\'s ruled out in the rest of that box.';
  }

  @override
  String exSudokuClaimingCol(Object col, Object value, Object box) {
    return 'In column $col, $value can only go in box $box, so it\'s ruled out in the rest of that box.';
  }

  @override
  String exSudokuPair(Object a, Object b, Object v1, Object v2, String kind, Object unit) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'row $unit',
        'col': 'column $unit',
        'other': 'box $unit',
      },
    );
    return '$a and $b can only hold $v1 and $v2, so those digits are ruled out in the rest of $_temp0.';
  }

  @override
  String exSudokuTriple(Object cells, Object v1, Object v2, Object v3, String kind, Object unit) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'row $unit',
        'col': 'column $unit',
        'other': 'box $unit',
      },
    );
    return '$cells can only hold $v1, $v2 and $v3 between them, so those digits are ruled out in the rest of $_temp0.';
  }

  @override
  String exSudokuHiddenPair(Object a, Object b, Object v1, Object v2, String kind, Object unit) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'row $unit',
        'col': 'column $unit',
        'other': 'box $unit',
      },
    );
    return 'In $_temp0, $v1 and $v2 can only go in $a and $b, so those two cells can\'t hold anything else.';
  }

  @override
  String exSudokuHiddenTriple(Object cells, Object v1, Object v2, Object v3, String kind, Object unit) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'row $unit',
        'col': 'column $unit',
        'other': 'box $unit',
      },
    );
    return 'In $_temp0, $v1, $v2 and $v3 can only go in $cells, so those cells can\'t hold anything else.';
  }

  @override
  String exSudokuXWing(Object value, String kind, Object b1, Object b2, Object c1, Object c2) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row':
            'In rows $b1 and $b2, $value can only go in columns $c1 and $c2. Each of those columns gets one of them, so $value is ruled out in the rest of columns $c1 and $c2.',
        'other':
            'In columns $b1 and $b2, $value can only go in rows $c1 and $c2. Each of those rows gets one of them, so $value is ruled out in the rest of rows $c1 and $c2.',
      },
    );
    return '$_temp0';
  }

  @override
  String exSudokuSwordfish(
    Object value,
    String kind,
    Object b1,
    Object b2,
    Object b3,
    Object c1,
    Object c2,
    Object c3,
  ) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row':
            'In rows $b1, $b2 and $b3, $value can only go in columns $c1, $c2 and $c3. Those three rows fill all three columns, so $value is ruled out in the rest of them.',
        'other':
            'In columns $b1, $b2 and $b3, $value can only go in rows $c1, $c2 and $c3. Those three columns fill all three rows, so $value is ruled out in the rest of them.',
      },
    );
    return '$_temp0';
  }

  @override
  String exSudokuXyWing(Object pivot, Object x, Object y, Object a, Object b, Object z) {
    return '$pivot is $x or $y. If it\'s $x, $a is $z; if it\'s $y, $b is $z. Either way one of them is $z, so a cell that sees both can\'t be $z.';
  }

  @override
  String exSudokuXyzWing(Object pivot, Object x, Object y, Object a, Object b, Object z) {
    return '$pivot is $x, $y or $z, $a is $x or $z, and $b is $y or $z. One of the three is $z whatever happens, so a cell that sees all three can\'t be $z.';
  }

  @override
  String exSudokuFailEmpty(Object cell) {
    return 'But then no digit is left for $cell.';
  }

  @override
  String exSudokuFailNoPlaceRow(Object value, Object row) {
    return 'But then $value has no place left in row $row.';
  }

  @override
  String exSudokuFailNoPlaceCol(Object value, Object col) {
    return 'But then $value has no place left in column $col.';
  }

  @override
  String exSudokuFailNoPlaceBox(Object value, Object box) {
    return 'But then $value has no place left in box $box.';
  }

  @override
  String exSudokuFailClash(Object a, Object b, Object value) {
    return 'But then $a and $b both hold $value.';
  }

  @override
  String exKingsSuppose(Object cell) {
    return 'Suppose $cell had a crown.';
  }

  @override
  String exKingsRefuted(Object cell) {
    return '$cell gets a dot: a crown there leads to a contradiction.';
  }

  @override
  String exKingsSingleRow(Object cell, Object row) {
    return '$cell gets a crown: it\'s the last free cell in row $row.';
  }

  @override
  String exKingsSingleCol(Object cell, Object col) {
    return '$cell gets a crown: it\'s the last free cell in column $col.';
  }

  @override
  String exKingsSingleRegion(Object cell) {
    return '$cell gets a crown: it\'s the last free cell in its region.';
  }

  @override
  String exKingsRuledOut(Object cell, Object a) {
    return '$cell gets a dot: it touches the crown in $a or shares its row, column or region.';
  }

  @override
  String exKingsConfineRow(Object cell, Object row, Object region) {
    return '$cell gets a dot: the crown of row $row must be in the region at $region, so that region has no other crown.';
  }

  @override
  String exKingsConfineCol(Object cell, Object col, Object region) {
    return '$cell gets a dot: the crown of column $col must be in the region at $region, so that region has no other crown.';
  }

  @override
  String exKingsConfineRegionRow(Object cell, Object region, Object row) {
    return '$cell gets a dot: the crown of the region at $region must be in row $row, so row $row has no other crown.';
  }

  @override
  String exKingsConfineRegionCol(Object cell, Object region, Object col) {
    return '$cell gets a dot: the crown of the region at $region must be in column $col, so column $col has no other crown.';
  }

  @override
  String exKingsAttackRow(Object cell, Object row) {
    return '$cell gets a dot: a crown there would leave no free cell in row $row.';
  }

  @override
  String exKingsAttackCol(Object cell, Object col) {
    return '$cell gets a dot: a crown there would leave no free cell in column $col.';
  }

  @override
  String exKingsAttackRegion(Object cell, Object region) {
    return '$cell gets a dot: a crown there would leave no free cell in the region at $region.';
  }

  @override
  String exKingsFailRow(Object row) {
    return 'But then row $row has no free cell left for its crown.';
  }

  @override
  String exKingsFailCol(Object col) {
    return 'But then column $col has no free cell left for its crown.';
  }

  @override
  String exKingsFailRegion(Object region) {
    return 'But then the region at $region has no free cell left for its crown.';
  }

  @override
  String exKingsFailClash(Object a, Object b) {
    return 'But then the crowns in $a and $b clash.';
  }

  @override
  String exHuesFull(Object cell, Object value, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all $count of its $value neighbours',
      one: 'its one $value neighbour',
    );
    return '$cell can\'t be $value: $clue already has $_temp0.';
  }

  @override
  String exHuesNeed(Object cell, Object value, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $value neighbours',
      one: 'one $value neighbour',
    );
    return '$cell must be $value: $clue needs $_temp0, and only that many cells can still be $value.';
  }

  @override
  String exHuesSingle(Object cell, Object value) {
    return '$cell must be $value: every other color is ruled out there.';
  }

  @override
  String exHuesFailEmpty(Object cell) {
    return 'But then no color is left for $cell.';
  }

  @override
  String exHuesFailMany(Object clue, Object value) {
    return 'But then $clue has too many $value neighbours.';
  }

  @override
  String exHuesFailFew(Object clue, Object value) {
    return 'But then $clue can\'t get enough $value neighbours.';
  }

  @override
  String exBlocksNaked(Object cell, Object value) {
    return '$cell must be $value: every other number is already in its region or in a cell it touches.';
  }

  @override
  String exBlocksHidden(Object cell, Object value) {
    return '$cell must be $value: it\'s the only place left for $value in its region.';
  }

  @override
  String exBlocksPointing(Object cell, Object value, Object region) {
    return '$cell can\'t be $value: it touches every cell where the region at $region can still put its $value.';
  }

  @override
  String exBlocksPair(Object a, Object b, Object v1, Object v2) {
    return '$a and $b share $v1 and $v2, so no other cell of their region can hold them.';
  }

  @override
  String exBlocksFailEmpty(Object cell) {
    return 'But then no number is left for $cell.';
  }

  @override
  String exBlocksFailNoPlace(Object region, Object value) {
    return 'But then the region at $region has no place left for $value.';
  }

  @override
  String exBlocksAlone(Object cell) {
    return '$cell must be 1: its region is just this one cell.';
  }

  @override
  String exPlotsClosed(Object cell, Object value, Object group) {
    return '$cell can\'t be $value: the plot of $value at $group is already complete.';
  }

  @override
  String exPlotsExit(Object cell, Object value, Object group) {
    return '$cell must be $value: the plot of $value at $group still needs cells, and this is its only way out.';
  }

  @override
  String exPlotsMerge(Object cell, Object value) {
    return '$cell can\'t be $value: it would join plots of $value into one that is too big.';
  }

  @override
  String exPlotsRoom(Object cell, Object value) {
    return '$cell can\'t be $value: there\'s no room around it for a plot of $value cells.';
  }

  @override
  String exPlotsOnly(Object cell, Object value) {
    return '$cell must be $value: every other number is ruled out there.';
  }

  @override
  String exPlotsFailEmpty(Object cell) {
    return 'But then no number is left for $cell.';
  }

  @override
  String exPlotsFailBig(Object value, Object group) {
    return 'But then the plot of $value at $group has too many cells.';
  }

  @override
  String exPlotsFailShut(Object value, Object group) {
    return 'But then the plot of $value at $group is shut in before it\'s complete.';
  }

  @override
  String exPlotsFailRoom(Object value, Object group) {
    return 'But then the plot of $value at $group has no room to grow.';
  }

  @override
  String exPairsSupposeShade(Object cell) {
    return 'Suppose $cell were shaded.';
  }

  @override
  String exPairsSupposeDot(Object cell) {
    return 'Suppose $cell weren\'t shaded.';
  }

  @override
  String exPairsRefutedShade(Object cell) {
    return '$cell is shaded: leaving it unshaded leads to a contradiction.';
  }

  @override
  String exPairsRefutedDot(Object cell) {
    return '$cell gets a dot: shading it leads to a contradiction.';
  }

  @override
  String exPairsRegionDone(Object cell, Object region) {
    return '$cell gets a dot: the region at $region already has its two shaded cells.';
  }

  @override
  String exPairsRegionNeed(Object cell, Object region) {
    return '$cell is shaded: the region at $region has just two cells left that can be shaded.';
  }

  @override
  String exPairsPartnered(Object cell, Object a) {
    return '$cell gets a dot: $a next to it already has its partner, and pairs never touch.';
  }

  @override
  String exPairsOneWay(Object cell, Object a) {
    return '$cell is shaded: it\'s the only cell left where $a can find its partner.';
  }

  @override
  String exPairsCrowd(Object cell) {
    return '$cell gets a dot: it touches two shaded cells, and shading it would join them into more than a pair.';
  }

  @override
  String exPairsAlone(Object cell) {
    return '$cell gets a dot: no cell next to it is left to pair it with.';
  }

  @override
  String exPairsEveryShade(Object cell, Object region) {
    return '$cell is shaded: every way to finish the region at $region shades it.';
  }

  @override
  String exPairsEveryDot(Object cell, Object region) {
    return '$cell gets a dot: no way to finish the region at $region shades it.';
  }

  @override
  String exPairsFailMany(Object region) {
    return 'But then the region at $region has more than two shaded cells.';
  }

  @override
  String exPairsFailFew(Object region) {
    return 'But then the region at $region can\'t get two shaded cells.';
  }

  @override
  String exPairsFailCrowd(Object cell) {
    return 'But then the shaded $cell touches two shaded cells.';
  }

  @override
  String exPairsFailAlone(Object cell) {
    return 'But then the shaded $cell has no partner left.';
  }

  @override
  String exPairsFailNoWay(Object region) {
    return 'But then there\'s no way left to finish the region at $region.';
  }

  @override
  String exCampSupposeTent(Object cell) {
    return 'Suppose $cell held a tent.';
  }

  @override
  String exCampSupposeGrass(Object cell) {
    return 'Suppose $cell were grass.';
  }

  @override
  String exCampRefutedTent(Object cell) {
    return '$cell is a tent: grass there leads to a contradiction.';
  }

  @override
  String exCampRefutedGrass(Object cell) {
    return '$cell is grass: a tent there leads to a contradiction.';
  }

  @override
  String exCampNearTent(Object cell, Object a) {
    return '$cell is grass: it touches the tent in $a, and tents never touch.';
  }

  @override
  String exCampRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count tents',
      one: 'its tent',
    );
    return '$cell is grass: row $row already has $_temp0.';
  }

  @override
  String exCampColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count tents',
      one: 'its tent',
    );
    return '$cell is grass: column $col already has $_temp0.';
  }

  @override
  String exCampRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tents',
      one: 'a tent',
    );
    return '$cell is a tent: row $row needs $_temp0, and only that many cells are left.';
  }

  @override
  String exCampColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tents',
      one: 'a tent',
    );
    return '$cell is a tent: column $col needs $_temp0, and only that many cells are left.';
  }

  @override
  String exCampTotalDone(Object cell) {
    return '$cell is grass: every tree already has its tent.';
  }

  @override
  String exCampTotalNeed(Object cell) {
    return '$cell is a tent: the trees still need every cell that\'s left.';
  }

  @override
  String exCampTreeOnly(Object cell, Object tree) {
    return '$cell is a tent: it\'s the only free cell next to the tree in $tree.';
  }

  @override
  String exCampFailTouch(Object a, Object b) {
    return 'But then the tents in $a and $b touch.';
  }

  @override
  String exCampFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tents',
      one: 'one tent',
    );
    return 'But then row $row has more than $_temp0.';
  }

  @override
  String exCampFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tents',
      one: 'one tent',
    );
    return 'But then column $col has more than $_temp0.';
  }

  @override
  String exCampFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count tents',
      one: 'its tent',
    );
    return 'But then row $row can\'t get $_temp0.';
  }

  @override
  String exCampFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count tents',
      one: 'its tent',
    );
    return 'But then column $col can\'t get $_temp0.';
  }

  @override
  String get exCampFailTotal => 'But then the tents can\'t match the trees in number.';

  @override
  String exCampFailTree(Object tree) {
    return 'But then the tree in $tree has no free cell left for its tent.';
  }

  @override
  String get exCampFailPairing => 'But then the trees and tents can\'t all be paired up.';

  @override
  String exIslandsSupposeSea(Object cell) {
    return 'Suppose $cell were sea.';
  }

  @override
  String exIslandsSupposeLand(Object cell) {
    return 'Suppose $cell were land.';
  }

  @override
  String exIslandsRefutedSea(Object cell) {
    return '$cell is sea: land there leads to a contradiction.';
  }

  @override
  String exIslandsRefutedLand(Object cell) {
    return '$cell is land: sea there leads to a contradiction.';
  }

  @override
  String exIslandsTotalSea(Object cell) {
    return '$cell is sea: the islands already have all their land.';
  }

  @override
  String exIslandsTotalLand(Object cell) {
    return '$cell is land: the sea can\'t take any more cells.';
  }

  @override
  String exIslandsPool(Object cell) {
    return '$cell is land: sea there would make a 2×2 pool.';
  }

  @override
  String exIslandsComplete(Object cell, Object island, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count cells',
      one: 'its one cell',
    );
    return '$cell is sea: the island at $island already has $_temp0.';
  }

  @override
  String exIslandsExit(Object cell, Object island) {
    return '$cell is land: the island at $island still needs cells, and this is its only way out.';
  }

  @override
  String exIslandsBetween(Object cell) {
    return '$cell is sea: it touches two different numbered islands.';
  }

  @override
  String exIslandsUnreachable(Object cell) {
    return '$cell is sea: no island can reach it.';
  }

  @override
  String exIslandsSeaExit(Object cell, Object sea) {
    return '$cell is sea: the sea at $sea has no other way out, and the whole sea is connected.';
  }

  @override
  String get exIslandsFailTotal => 'But then the land and sea can\'t add up.';

  @override
  String get exIslandsFailInvalid => 'But then the finished board breaks a rule.';

  @override
  String exIslandsFailPool(Object cell) {
    return 'But then the sea makes a 2×2 pool at $cell.';
  }

  @override
  String exIslandsFailTwoClues(Object a, Object b) {
    return 'But then the numbers in $a and $b end up on one island.';
  }

  @override
  String exIslandsFailBig(Object island, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'one cell',
    );
    return 'But then the island at $island has more than $_temp0.';
  }

  @override
  String exIslandsFailShut(Object island) {
    return 'But then the island at $island is shut in before it\'s complete.';
  }

  @override
  String exIslandsFailOrphan(Object island) {
    return 'But then the land at $island is cut off from every number.';
  }

  @override
  String exIslandsFailUnreachable(Object cell) {
    return 'But then no island can reach the land in $cell.';
  }

  @override
  String exIslandsFailSeaShut(Object sea) {
    return 'But then the sea at $sea is cut off from the rest.';
  }

  @override
  String exLampsSupposeLamp(Object cell) {
    return 'Suppose $cell had a lamp.';
  }

  @override
  String exLampsSupposeDot(Object cell) {
    return 'Suppose $cell had no lamp.';
  }

  @override
  String exLampsRefutedLamp(Object cell) {
    return '$cell has a lamp: leaving it dark leads to a contradiction.';
  }

  @override
  String exLampsRefutedDot(Object cell) {
    return '$cell gets a dot: a lamp there leads to a contradiction.';
  }

  @override
  String exLampsLit(Object cell, Object a) {
    return '$cell gets a dot: the lamp in $a shines on it, and lamps never shine on each other.';
  }

  @override
  String exLampsWallDone(Object cell, Object wall) {
    return '$cell gets a dot: the wall $wall already has as many lamps next to it as its number says.';
  }

  @override
  String exLampsWallNeed(Object cell, Object wall) {
    return '$cell has a lamp: the wall $wall needs a lamp in every free cell next to it.';
  }

  @override
  String exLampsOnlySource(Object cell, Object a) {
    return '$cell has a lamp: it\'s the only cell left that can light $a.';
  }

  @override
  String exLampsSelf(Object cell) {
    return '$cell has a lamp: nothing else can light it.';
  }

  @override
  String exLampsFailSee(Object a, Object b) {
    return 'But then the lamps in $a and $b shine on each other.';
  }

  @override
  String exLampsFailMany(Object wall) {
    return 'But then the wall $wall has too many lamps next to it.';
  }

  @override
  String exLampsFailFew(Object wall) {
    return 'But then the wall $wall can\'t get enough lamps next to it.';
  }

  @override
  String exLampsFailDark(Object cell) {
    return 'But then nothing can light $cell.';
  }

  @override
  String exLitsSuppose(Object region, Object cells) {
    return 'Suppose the region at $region were shaded at $cells.';
  }

  @override
  String exLitsRefuted(Object region, Object cells) {
    return 'The region at $region can\'t be shaded at $cells: that leads to a contradiction.';
  }

  @override
  String exLitsOverEmpty(Object region) {
    return 'Shapes in the region at $region that cover a cell staying empty are out.';
  }

  @override
  String exLitsMisses(Object region) {
    return 'Shapes in the region at $region that miss one of its shaded cells are out.';
  }

  @override
  String exLitsPool(Object region) {
    return 'Shapes in the region at $region that would finish a 2×2 shaded block are out.';
  }

  @override
  String exLitsClash(Object region, Object other) {
    return 'Shapes in the region at $region that clash with every option left for the region at $other are out.';
  }

  @override
  String exLitsCut(Object region) {
    return 'Shapes in the region at $region that would cut the shading in two are out.';
  }

  @override
  String exLitsTwin(Object region, Object other) {
    return 'Shapes in the region at $region that would touch the same shape in the region at $other are out.';
  }

  @override
  String exLitsAll(Object cell, Object region) {
    return '$cell is shaded: every shape still possible for the region at $region covers it.';
  }

  @override
  String exLitsNone(Object cell, Object region) {
    return '$cell gets a dot: no shape still possible for the region at $region covers it.';
  }

  @override
  String exLitsFailNoShape(Object region) {
    return 'But then no shape fits the region at $region.';
  }

  @override
  String get exLitsFailCut => 'But then the shaded cells can\'t all connect.';

  @override
  String exLoopSupposeLine(Object edge) {
    return 'Suppose $edge were a line.';
  }

  @override
  String exLoopSupposeCross(Object edge) {
    return 'Suppose $edge were crossed out.';
  }

  @override
  String exLoopRefutedLine(Object edge) {
    return '$edge is a line: crossing it out leads to a contradiction.';
  }

  @override
  String exLoopRefutedCross(Object edge) {
    return '$edge gets a cross: a line there leads to a contradiction.';
  }

  @override
  String exLoopFull(Object edge) {
    return '$edge gets a cross: two lines already meet at its end, and the loop never branches.';
  }

  @override
  String exLoopDeadEnd(Object edge) {
    return '$edge gets a cross: the line couldn\'t go on from its end.';
  }

  @override
  String exLoopOnlyWay(Object edge) {
    return '$edge is a line: the line reaching its end can only go on this way.';
  }

  @override
  String exLoopCloseEarly(Object edge) {
    return '$edge gets a cross: it would close a loop before the puzzle is done.';
  }

  @override
  String exLoopDone(Object edge) {
    return '$edge gets a cross: the loop is already closed.';
  }

  @override
  String get exLoopFailBranch => 'But then three lines meet in one point.';

  @override
  String get exLoopFailDeadEnd => 'But then a line runs into a dead end.';

  @override
  String get exLoopFailSubloop => 'But then the lines make more than one loop.';

  @override
  String get exLoopFailClues => 'But then the closed loop breaks a clue.';

  @override
  String exFenceDone(Object edge, Object cell) {
    return '$edge gets a cross: $cell already has as many lines around it as its number.';
  }

  @override
  String exFenceNeed(Object edge, Object cell) {
    return '$edge is a line: $cell needs a line on every side still open.';
  }

  @override
  String exFenceFailMany(Object cell) {
    return 'But then $cell has more lines around it than its number.';
  }

  @override
  String exFenceFailFew(Object cell) {
    return 'But then $cell can\'t get as many lines as its number.';
  }

  @override
  String exLoopFailClash(Object edge) {
    return 'But then $edge would have to be both a line and crossed out.';
  }

  @override
  String get exLoopFailOffBoard => 'But then the loop would have to leave the board.';

  @override
  String exPearlsPass(Object edge, Object cell) {
    return '$edge is a line: the loop passes the pearl in $cell, and only two ways are left there.';
  }

  @override
  String exPearlsBlackFar(Object edge, Object cell) {
    return '$edge gets a cross: from the black pearl in $cell the loop couldn\'t go two cells straight this way.';
  }

  @override
  String exPearlsBlackStraight(Object edge, Object cell) {
    return '$edge is a line: after the black pearl in $cell the loop goes on straight for one more cell.';
  }

  @override
  String exPearlsBlackThrough(Object edge, Object cell) {
    return '$edge gets a cross: the loop turns at the black pearl in $cell, so it can\'t go straight through.';
  }

  @override
  String exPearlsBlackTurn(Object edge, Object cell) {
    return '$edge is a line: the loop turns at the black pearl in $cell, and the other way is crossed out.';
  }

  @override
  String exPearlsWhiteLine(Object edge, Object cell) {
    return '$edge is a line: the loop goes straight through the white pearl in $cell this way.';
  }

  @override
  String exPearlsWhiteCross(Object edge, Object cell) {
    return '$edge gets a cross: the loop goes straight through the white pearl in $cell the other way.';
  }

  @override
  String exPearlsWhiteTurnLine(Object edge, Object cell) {
    return '$edge is a line: the loop must turn right before or after the white pearl in $cell.';
  }

  @override
  String exPearlsWhiteTurnCross(Object edge, Object cell) {
    return '$edge gets a cross: the loop must turn right before or after the white pearl in $cell.';
  }

  @override
  String exPearlsFailPass(Object cell) {
    return 'But then the loop can\'t pass the pearl in $cell.';
  }

  @override
  String exRailsSupposeOn(Object cell) {
    return 'Suppose the track ran through $cell.';
  }

  @override
  String exRailsSupposeOff(Object cell) {
    return 'Suppose $cell had no track.';
  }

  @override
  String exRailsRefutedOn(Object cell) {
    return 'The track runs through $cell: leaving it out leads to a contradiction.';
  }

  @override
  String exRailsRefutedOff(Object cell) {
    return '$cell has no track: track there leads to a contradiction.';
  }

  @override
  String exRailsCellUsed(Object cell) {
    return 'The track runs through $cell: a piece of track already reaches it.';
  }

  @override
  String exRailsCellEmpty(Object cell) {
    return '$cell has no track: the track couldn\'t pass through it.';
  }

  @override
  String exRailsPieceFull(Object edge, Object cell) {
    return '$edge gets a cross: the track already enters and leaves $cell.';
  }

  @override
  String exRailsPieceEmpty(Object edge, Object cell) {
    return '$edge gets a cross: $cell has no track.';
  }

  @override
  String exRailsPieceNeed(Object edge, Object cell) {
    return '$edge is track: the track through $cell has no other way to go.';
  }

  @override
  String exRailsRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count track cells',
      one: 'its one track cell',
    );
    return '$cell has no track: row $row already has $_temp0.';
  }

  @override
  String exRailsColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count track cells',
      one: 'its one track cell',
    );
    return '$cell has no track: column $col already has $_temp0.';
  }

  @override
  String exRailsRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count track cells',
      one: 'one track cell',
    );
    return 'The track runs through $cell: row $row needs $_temp0, and only that many are left.';
  }

  @override
  String exRailsColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count track cells',
      one: 'one track cell',
    );
    return 'The track runs through $cell: column $col needs $_temp0, and only that many are left.';
  }

  @override
  String exRailsDoneEdge(Object edge) {
    return '$edge gets a cross: the track is already complete.';
  }

  @override
  String exRailsDoneOn(Object cell) {
    return 'The track runs through $cell: it\'s part of the finished track.';
  }

  @override
  String exRailsDoneOff(Object cell) {
    return '$cell has no track: the track is already complete.';
  }

  @override
  String exRailsCloseEarly(Object edge) {
    return '$edge gets a cross: it would close a loop or finish the track too early.';
  }

  @override
  String exRailsFailBranch(Object cell) {
    return 'But then the track branches in $cell.';
  }

  @override
  String exRailsFailDeadEnd(Object cell) {
    return 'But then the track runs into a dead end in $cell.';
  }

  @override
  String exRailsFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count track cells',
      one: 'one track cell',
    );
    return 'But then row $row has more than $_temp0.';
  }

  @override
  String exRailsFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count track cells',
      one: 'one track cell',
    );
    return 'But then column $col has more than $_temp0.';
  }

  @override
  String exRailsFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count track cells',
      one: 'its track cell',
    );
    return 'But then row $row can\'t get $_temp0.';
  }

  @override
  String exRailsFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count track cells',
      one: 'its track cell',
    );
    return 'But then column $col can\'t get $_temp0.';
  }

  @override
  String get exRailsFailLoop => 'But then a loop forms apart from the track.';

  @override
  String get exRailsFailClosed => 'But then the track is finished too early.';

  @override
  String exRailsFailClash(Object cell) {
    return 'But then $cell would have to have track and no track.';
  }

  @override
  String exArrowsSupposeShade(Object cell) {
    return 'Suppose $cell were shaded.';
  }

  @override
  String exArrowsSupposeOn(Object cell) {
    return 'Suppose the loop went through $cell.';
  }

  @override
  String exArrowsRefutedShade(Object cell) {
    return '$cell is shaded: the loop through it leads to a contradiction.';
  }

  @override
  String exArrowsRefutedOn(Object cell) {
    return 'The loop goes through $cell: shading it leads to a contradiction.';
  }

  @override
  String exArrowsCellOn(Object cell) {
    return 'The loop goes through $cell: a line already reaches it.';
  }

  @override
  String exArrowsCellShaded(Object cell) {
    return '$cell is shaded: the loop couldn\'t pass through it, and every other cell is on the loop.';
  }

  @override
  String exArrowsShadeNoLine(Object edge, Object cell) {
    return '$edge gets a cross: $cell is shaded, so the loop stays out of it.';
  }

  @override
  String exArrowsShadeNeighbours(Object cell, Object a) {
    return 'The loop goes through $cell: it touches the shaded $a, and shaded cells never touch.';
  }

  @override
  String exArrowsOnNeed(Object edge, Object cell) {
    return '$edge is a line: the loop through $cell has no other way to go.';
  }

  @override
  String exArrowsClueDone(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count shaded cells',
      one: 'its one shaded cell',
      zero: 'no shaded cells, as it should',
    );
    return 'The loop goes through $cell: the arrow in $clue already sees $_temp0.';
  }

  @override
  String exArrowsClueNeedShade(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: 'a shaded cell',
    );
    return '$cell is shaded: the arrow in $clue needs $_temp0, and they only fit by shading every other cell.';
  }

  @override
  String exArrowsClueNeedOn(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: 'a shaded cell',
    );
    return 'The loop goes through $cell: the arrow in $clue needs $_temp0, and they only fit by shading every other cell.';
  }

  @override
  String exArrowsFailStuck(Object cell) {
    return 'But then the loop gets stuck in $cell.';
  }

  @override
  String exArrowsFailClueMany(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: 'one shaded cell',
      zero: 'no shaded cells',
    );
    return 'But then the arrow in $clue sees more than $_temp0.';
  }

  @override
  String exArrowsFailClueFew(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count shaded cells',
      one: 'its shaded cell',
    );
    return 'But then the arrow in $clue can\'t see $_temp0.';
  }

  @override
  String exArrowsFailClash(Object cell) {
    return 'But then $cell would have to be shaded and on the loop.';
  }

  @override
  String exMinesSupposeMine(Object cell) {
    return 'Suppose $cell were a mine.';
  }

  @override
  String exMinesSupposeSafe(Object cell) {
    return 'Suppose $cell were safe.';
  }

  @override
  String exMinesRefutedMine(Object cell) {
    return '$cell is safe: a mine there leads to a contradiction.';
  }

  @override
  String exMinesRefutedSafe(Object cell) {
    return '$cell is a mine: if it were safe, that would lead to a contradiction.';
  }

  @override
  String exMinesNumberSafe(Object cell, Object number) {
    return '$cell is safe: the number in $number already has all its mines around it.';
  }

  @override
  String exMinesNumberMine(Object cell, Object number) {
    return '$cell is a mine: the number in $number needs a mine in every closed cell around it.';
  }

  @override
  String exMinesTotalSafe(Object cell) {
    return '$cell is safe: every mine has been found.';
  }

  @override
  String exMinesTotalMine(Object cell) {
    return '$cell is a mine: the mines left fill every closed cell.';
  }

  @override
  String exMinesPairSafe(Object cell, Object a, Object b) {
    return '$cell is safe: comparing the numbers in $a and $b, their mines must lie elsewhere.';
  }

  @override
  String exMinesPairMine(Object cell, Object a, Object b) {
    return '$cell is a mine: comparing the numbers in $a and $b, the extra mines must lie here.';
  }

  @override
  String exMinesFailNumber(Object number) {
    return 'But then the number in $number can\'t be right.';
  }

  @override
  String get exMinesFailTotal => 'But then the number of mines doesn\'t add up.';

  @override
  String exMinesFailPair(Object a, Object b) {
    return 'But then the numbers in $a and $b can\'t both be right.';
  }

  @override
  String exShikakuSuppose(Object clue, Object rect) {
    return 'Suppose the number in $clue took $rect.';
  }

  @override
  String exShikakuRefuted(Object clue, Object rect) {
    return 'The number in $clue can\'t take $rect: it leads to a contradiction.';
  }

  @override
  String exShikakuOverlap(Object clue, Object other) {
    return 'Rectangles for $clue that overlap the one of $other are out.';
  }

  @override
  String exShikakuOwner(Object clue, Object cell) {
    return 'Only the number in $clue can still cover $cell, so its rectangle must include it.';
  }

  @override
  String exShikakuCommon(Object clue, Object cell, Object other) {
    return 'Every rectangle left for $clue covers $cell, so rectangles for $other that cover it are out.';
  }

  @override
  String exShikakuFixed(Object clue, Object rect) {
    return 'The number in $clue takes $rect: it\'s the only rectangle left for it.';
  }

  @override
  String exShikakuFailNone(Object clue) {
    return 'But then no rectangle is left for the number in $clue.';
  }

  @override
  String exShikakuFailUncovered(Object cell) {
    return 'But then nothing can cover $cell.';
  }

  @override
  String exAtomsSuppose(Object edge, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bonds',
      one: 'one bond',
      zero: 'no bonds',
    );
    return 'Suppose $edge had $_temp0.';
  }

  @override
  String exAtomsRefutedMore(Object edge, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bonds',
      one: 'one bond',
    );
    return '$edge gets at least $_temp0: fewer leads to a contradiction.';
  }

  @override
  String exAtomsRefutedLess(int count, Object edge) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$edge gets at most $count bonds: more leads to a contradiction.',
      one: '$edge gets at most one bond: more leads to a contradiction.',
      zero: '$edge gets no bonds: any bond there leads to a contradiction.',
    );
    return '$_temp0';
  }

  @override
  String exAtomsAtLeast(Object edge, int count, Object atom) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bonds',
      one: 'one bond',
    );
    return '$edge gets at least $_temp0: the atom in $atom can\'t reach its number otherwise.';
  }

  @override
  String exAtomsAtMost(int count, Object edge, Object atom) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$edge gets at most $count bonds: more would overshoot the number of the atom in $atom.',
      one: '$edge gets at most one bond: more would overshoot the number of the atom in $atom.',
      zero: '$edge gets no bonds: any would overshoot the number of the atom in $atom.',
    );
    return '$_temp0';
  }

  @override
  String exAtomsCross(Object edge, Object other) {
    return '$edge gets no bonds: they would cross the bond $other.';
  }

  @override
  String exAtomsFailSum(Object atom) {
    return 'But then the atom in $atom can\'t get its number of bonds.';
  }

  @override
  String exAtomsFailCross(Object a, Object b) {
    return 'But then the bonds $a and $b cross.';
  }

  @override
  String get exAtomsFailConnect => 'But then the atoms can\'t all join into one molecule.';

  @override
  String exTrailSupposeOn(Object edge) {
    return 'Suppose the path took $edge.';
  }

  @override
  String exTrailSupposeOff(Object edge) {
    return 'Suppose the path didn\'t take $edge.';
  }

  @override
  String exTrailRefutedOn(Object edge) {
    return 'The path takes $edge: leaving it out leads to a contradiction.';
  }

  @override
  String exTrailRefutedOff(Object edge) {
    return 'The path doesn\'t take $edge: taking it leads to a contradiction.';
  }

  @override
  String exTrailDegreeDone(Object edge, Object cell) {
    return 'The path doesn\'t take $edge: it already enters and leaves $cell.';
  }

  @override
  String exTrailEndDone(Object edge, Object cell) {
    return 'The path doesn\'t take $edge: its end in $cell is already joined.';
  }

  @override
  String exTrailDegreeNeed(Object edge, Object cell) {
    return 'The path takes $edge: the path through $cell has no other way.';
  }

  @override
  String exTrailLoop(Object edge) {
    return 'The path doesn\'t take $edge: it would close a loop.';
  }

  @override
  String exTrailOrder(Object edge) {
    return 'The path doesn\'t take $edge: it would join the numbers out of order.';
  }

  @override
  String exTrailEarly(Object edge) {
    return 'The path doesn\'t take $edge: it would join the start to the end before every cell is visited.';
  }

  @override
  String exTrailFailBranch(Object cell) {
    return 'But then the path branches in $cell.';
  }

  @override
  String exTrailFailStuck(Object cell) {
    return 'But then the path gets stuck in $cell.';
  }

  @override
  String get exTrailFailOrder => 'But then the numbers come out of order.';

  @override
  String get exTrailFailLoop => 'But then some cells close into a loop of their own.';

  @override
  String get exTrailFailConnect => 'But then the path can\'t reach every cell.';

  @override
  String exLinksSupposeOn(Object edge) {
    return 'Suppose a path ran along $edge.';
  }

  @override
  String exLinksSupposeOff(Object edge) {
    return 'Suppose no path ran along $edge.';
  }

  @override
  String exLinksRefutedOn(Object edge) {
    return 'A path runs along $edge: leaving it out leads to a contradiction.';
  }

  @override
  String exLinksRefutedOff(Object edge) {
    return 'No path runs along $edge: a path there leads to a contradiction.';
  }

  @override
  String exLinksDegreeDone(Object edge, Object cell) {
    return 'No path runs along $edge: a path already enters and leaves $cell.';
  }

  @override
  String exLinksDotDone(Object edge, Object cell) {
    return 'No path runs along $edge: the path from the dot in $cell already leaves it.';
  }

  @override
  String exLinksDegreeNeed(Object edge, Object cell) {
    return 'A path runs along $edge: the path through $cell has no other way.';
  }

  @override
  String exLinksDotNeed(Object edge, Object cell) {
    return 'A path runs along $edge: it\'s the only way left out of the dot in $cell.';
  }

  @override
  String exLinksLoop(Object edge) {
    return 'No path runs along $edge: it would close a loop.';
  }

  @override
  String exLinksMixed(Object edge) {
    return 'No path runs along $edge: it would join paths of two different pairs.';
  }

  @override
  String exLinksFailBranch(Object cell) {
    return 'But then a path branches in $cell.';
  }

  @override
  String exLinksFailStuck(Object cell) {
    return 'But then a path gets stuck in $cell.';
  }

  @override
  String get exLinksFailLoop => 'But then a path closes into a loop.';

  @override
  String get exLinksFailMixed => 'But then one path joins two different pairs.';

  @override
  String get tallyName => 'Tally';

  @override
  String get tallyTagline => 'Cross out numbers until every line adds up';

  @override
  String get tallyRules =>
      '• Every cell holds a number. Cross some of them out.\n• The numbers left in each row and column must add up to the number outside the grid.\n\nTap a cell to cycle: crossed out → circled (your \"this one stays\" note) → empty. Long-press / right-click cycles back. Circles are optional: the puzzle is done once the right numbers are crossed out.';

  @override
  String get tutTally1 =>
      'Cross out numbers so that the ones left in each row and column add up to the number outside. Tap a number once to cross it out. A 7 can\'t stay in a row that adds up to 2.';

  @override
  String get tutTally2 =>
      'A number bigger than its row\'s or column\'s sum always goes. The highlighted 8 sits in a row that adds up to 6: cross it out, then finish the board.';

  @override
  String get tutTally3 =>
      'The top row\'s numbers make 15, but it needs 12, so only the 3 can go: the 8 and the 4 must stay. Tap twice to circle a number that stays, then finish the board.';

  @override
  String get tutTally4 =>
      'Now a real board. Start with lines whose sum is small, or close to the total of all their numbers.';

  @override
  String get tutTallyS1 =>
      'Try every way to make a line\'s sum. A number used in every way stays, one used in none goes: 7 from 5, 4 and 3 can only be 4 + 3, so the 5 goes.';

  @override
  String get tutTallyS2 =>
      'A hard board. When stuck, cross a number out and follow the sums: if some row or column can no longer add up, that number stays.';

  @override
  String exTallySupposeKeep(Object cell) {
    return 'Suppose $cell stayed.';
  }

  @override
  String exTallySupposeCross(Object cell) {
    return 'Suppose $cell were crossed out.';
  }

  @override
  String exTallyRefutedKeep(Object cell) {
    return '$cell stays: crossing it out leads to a contradiction.';
  }

  @override
  String exTallyRefutedCross(Object cell) {
    return '$cell is crossed out: keeping it leads to a contradiction.';
  }

  @override
  String exTallyRowTooBig(Object cell, Object row, int digit, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'its $digit is more than the $left row $row still needs',
      zero: 'row $row already adds up to its number',
    );
    return '$cell is crossed out: $_temp0.';
  }

  @override
  String exTallyColTooBig(Object cell, Object col, int digit, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'its $digit is more than the $left column $col still needs',
      zero: 'column $col already adds up to its number',
    );
    return '$cell is crossed out: $_temp0.';
  }

  @override
  String exTallyRowNeeded(Object cell, Object row, int digit, int sum) {
    return '$cell stays: without its $digit, row $row can\'t reach $sum.';
  }

  @override
  String exTallyColNeeded(Object cell, Object col, int digit, int sum) {
    return '$cell stays: without its $digit, column $col can\'t reach $sum.';
  }

  @override
  String exTallyRowEveryKeep(Object cell, Object row, int sum) {
    return '$cell stays: every way to make $sum in row $row uses it.';
  }

  @override
  String exTallyColEveryKeep(Object cell, Object col, int sum) {
    return '$cell stays: every way to make $sum in column $col uses it.';
  }

  @override
  String exTallyRowEveryCross(Object cell, Object row, int sum) {
    return '$cell is crossed out: no way to make $sum in row $row uses it.';
  }

  @override
  String exTallyColEveryCross(Object cell, Object col, int sum) {
    return '$cell is crossed out: no way to make $sum in column $col uses it.';
  }

  @override
  String exTallyFailRowOver(Object row, int sum) {
    return 'But then row $row adds up to more than $sum.';
  }

  @override
  String exTallyFailColOver(Object col, int sum) {
    return 'But then column $col adds up to more than $sum.';
  }

  @override
  String exTallyFailRowShort(Object row, int sum) {
    return 'But then row $row can\'t reach $sum any more.';
  }

  @override
  String exTallyFailColShort(Object col, int sum) {
    return 'But then column $col can\'t reach $sum any more.';
  }

  @override
  String exTallyFailRowNoWay(Object row, int sum) {
    return 'But then no choice of numbers in row $row adds up to $sum.';
  }

  @override
  String exTallyFailColNoWay(Object col, int sum) {
    return 'But then no choice of numbers in column $col adds up to $sum.';
  }

  @override
  String get formulaName => 'Formula';

  @override
  String get formulaTagline => 'Guess the hidden equation';

  @override
  String get formulaRules =>
      '• An equation is hidden. Find it in six guesses.\n• Every guess must be a true equation that fills the row: a calculation, then = and its value.\n• Each tile of a guess gets a mark. Filled: the right symbol in the right place. Outlined: in the equation, but somewhere else. Faded: not in the equation, or not that many times.\n• The usual order: brackets first, then powers, then × and ÷, then + and −.\n\nEasy equations only add and subtract, medium ones multiply or divide too, hard ones have brackets or powers (3² = 3 × 3, 2³ = 2 × 2 × 2). The keys remember the marks. Tap a tile to type there. A guess can\'t be taken back; when the rows run out, restart to try again.';

  @override
  String get formulaIncomplete => 'Fill the whole row first';

  @override
  String get formulaMalformed => 'Not an equation: a calculation, then = and a number';

  @override
  String get formulaUntrue => 'The two sides aren\'t equal';

  @override
  String get formulaOutOfGuesses => 'Out of guesses: restart to try again';

  @override
  String formulaSolvedIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Solved in $count guesses',
      one: 'Solved in one guess!',
    );
    return '$_temp0';
  }

  @override
  String get tutFormula1 =>
      'An equation is hidden behind this board. Every guess is a true equation that fills a row. Type 1+4=5 (or any other) and press Submit.';

  @override
  String get tutFormula2 =>
      'A guess marks its tiles. Filled: right symbol, right place. Outlined: in the equation, but elsewhere. Faded: not in it. Here = is in place, 4, 5 and 9 belong elsewhere and there is no +. Find the equation.';

  @override
  String get tutFormula3 =>
      'The first 2 is in place, but the second one is faded: the equation has only one 2. The keys below remember every mark. Finish the board.';

  @override
  String get tutFormula4 => 'Now a real board: six guesses for an equation of six tiles. It only adds or subtracts.';

  @override
  String get tutFormulaS1 =>
      'Open with a guess that tests many different symbols: the more tiles get a mark, the more you learn. Enter an equation with at least seven different symbols, like 9×8−7=65.';

  @override
  String get tutFormulaS2 =>
      'Hard boards add brackets and powers: 3² is 3 × 3, 2³ is 2 × 2 × 2. Brackets are worked out first, then powers, then × and ÷, then + and −. Find the equation.';

  @override
  String get tutFormulaS3 =>
      'The big one: ten tiles with a bracket or a power. Start by finding where = stands: it tells how long the result is.';

  @override
  String get orbitsName => 'Orbits';

  @override
  String get orbitsTagline => 'Give every star a region that turns around it';

  @override
  String get orbitsRules =>
      '• Split the whole grid into regions, one for each star.\n• A region is one connected piece with its star in the exact middle.\n• Half a turn around the star leaves the region looking the same: every cell has a twin on the opposite side of the star.\n\nDrag from a star, or from a cell of its region, over the cells to add; each one brings its twin along. Or tap a star to pick it, then tap the cells to give it, even ones away from its region. Tap a cell of the picked star (or any filled cell when no star is picked) to clear it and its twin.';

  @override
  String get tutOrbits1 =>
      'Split the grid into regions, one for each star. The star sits in the exact middle of its region, so every cell has a twin on the opposite side. Drag from the star in the right column to the cell above it: the twin below is filled in too.';

  @override
  String get tutOrbits2 =>
      'A star can sit inside a cell, on the line between two cells, or on a corner where four meet. The cells it touches are its own from the start. Give every remaining cell to a star: drag from the star, or tap the star and then the cells. Tap a cell of the picked star to clear it and its twin.';

  @override
  String get tutOrbits3 =>
      'A region can have any shape, as long as it is one piece and looks the same after half a turn around its star. A cell can\'t join a star if its twin would fall off the board or onto another star\'s cell.';

  @override
  String get tutOrbits4 =>
      'Now a real board. Start with cells that only one star can take: the corners and edges are good places to look.';

  @override
  String get tutOrbitsS1 =>
      'Keep regions in one piece. When a cell belongs to a star but isn\'t joined to it yet, look at the ways to connect them: a cell that every way passes through belongs to the star too, and so does its twin.';

  @override
  String get tutOrbitsS2 =>
      'A hard board. When nothing is certain, pick a cell that only two stars can take and try one: if some cell is then left with no star at all, the cell belongs to the other star.';

  @override
  String exOrbitsOnly(Object cell, Object star) {
    return '$cell belongs to the star at $star: no other star can take it.';
  }

  @override
  String exOrbitsTwin(Object cell, Object star, Object other) {
    return '$cell belongs to the star at $star: it\'s the twin of $other.';
  }

  @override
  String exOrbitsBridge(Object cell, Object star, Object other) {
    return '$cell belongs to the star at $star: without it, $other would be cut off from that star.';
  }

  @override
  String exOrbitsTwinOut(Object cell, Object star, Object other) {
    return '$cell can\'t belong to the star at $star: its twin $other can\'t.';
  }

  @override
  String exOrbitsReach(Object cell, Object star) {
    return '$cell can\'t belong to the star at $star: no way is left to join it to that star.';
  }

  @override
  String exOrbitsFailEmpty(Object cell) {
    return 'But then no star is left for $cell.';
  }

  @override
  String exOrbitsSuppose(Object cell, Object star) {
    return 'Suppose $cell belonged to the star at $star.';
  }

  @override
  String exOrbitsRefuted(Object cell, Object star) {
    return '$cell can\'t belong to the star at $star: it leads to a contradiction.';
  }

  @override
  String get inlayName => 'Inlay';

  @override
  String get inlayTagline => 'Fit every piece into the shape';

  @override
  String get inlayRules =>
      '• Fill the shape with all the pieces from the tray. Every cell of the shape gets covered, and pieces never overlap.\n• Any way that fits them all wins.\n• Pieces may be turned. On hard boards they may be flipped over too.\n\nDrag a piece onto the shape: it snaps to the cells. Drag a laid piece to move it, or off the shape to put it back in the tray. Tap a piece to turn it a quarter. On hard boards, Flip mirrors the piece you touched last (on a computer, right-click a piece).';

  @override
  String get inlayFlip => 'Flip';

  @override
  String get inlayNoRoom => 'No room to turn it here';

  @override
  String get tutInlay1 =>
      'Drag each piece from the tray onto the shape. It snaps to the cells. Cover the whole shape with the pieces.';

  @override
  String get tutInlay2 =>
      'Tap a piece to turn it a quarter, in the tray or on the board. Turn these pieces so they fit.';

  @override
  String get tutInlay3 =>
      'The bar on the board leaves no room for the other pieces. Drag a laid piece to move it, or drag it off the shape to put it back in the tray.';

  @override
  String get tutInlay4 =>
      'On hard boards a piece can also be flipped over. Touch a piece, then tap Flip (on a computer, right-click it). One piece here only fits flipped.';

  @override
  String get tutInlay5 => 'Now a real board. Any way that fits all the pieces wins.';

  @override
  String get tutInlayS1 =>
      'Start where the pieces have the fewest ways in: the corners, narrow arms and small pockets. The cell at the tip of the arm has a single neighbour: find the piece that fits there, and lay it first.';

  @override
  String get tutInlayS2 =>
      'Lay the biggest and most awkward pieces first, while there is still room for them; small pieces fill the last gaps. Watch for pockets: a gap smaller than every piece left means a piece must move. On hard boards some pieces only fit flipped.';

  @override
  String get skylineName => 'Skyline';

  @override
  String get skylineTagline => 'How many towers can you see from each side?';

  @override
  String get skylineRules =>
      '• Put a tower in every cell, 1 to N floors tall (N = grid size).\n• Every row and column holds each height exactly once.\n• A number outside the grid tells how many towers you can see from there, looking along its row or column: a tower hides every shorter one behind it.\n\nPick a height in the palette and tap cells to place it, or tap a cell first and then a height. The pencil button toggles small notes. Long-press / right-click clears a cell.';

  @override
  String get tutSkyline1 =>
      'Build a skyline: every row and column holds one tower of each height from 1 to 4. One is missing here: pick its height in the palette, then tap the empty cell.';

  @override
  String get tutSkyline2 =>
      'A clue counts the towers you can see from its side: each tower hides the shorter ones behind it. The clue left of the top row says 2. Fill the empty cells so that only two towers show from there.';

  @override
  String get tutSkyline3 =>
      'A 1 means the tallest tower stands right at the clue and hides all the rest. A 4 means every tower is in sight, so they climb 1, 2, 3, 4. Fill the row.';

  @override
  String get tutSkyline4 =>
      'Now a whole board. Note the heights a cell can still hold with the pencil, and let the clues narrow them down.';

  @override
  String get tutSkylineS1 =>
      'The tallest tower hides everything behind it, so a 3 keeps it out of the first two cells. In general, a big clue needs short towers near it: next to a 3 on a board of 5, at most 3 floors.';

  @override
  String get tutSkylineS2 =>
      'Stuck? Take a row or column with clues and go through every way to fill it that fits your notes and its clues. A height that never lands in a cell can be crossed off there.';

  @override
  String get tutSkylineS3 =>
      'The hardest boards need a guess you can disprove. Suppose a cell holds one of its last two or three heights and follow on; if that runs into a contradiction, cross the height off.';

  @override
  String exLatinNaked(Object cell, Object value) {
    return '$cell must be $value: every other number is ruled out there.';
  }

  @override
  String exLatinHiddenRow(Object cell, Object value, Object row) {
    return '$cell must be $value: it\'s the only place left for $value in row $row.';
  }

  @override
  String exLatinHiddenCol(Object cell, Object value, Object col) {
    return '$cell must be $value: it\'s the only place left for $value in column $col.';
  }

  @override
  String exLatinPairRow(Object a, Object b, Object v1, Object v2, Object row) {
    return '$a and $b can only hold $v1 and $v2, so those numbers are ruled out in the rest of row $row.';
  }

  @override
  String exLatinPairCol(Object a, Object b, Object v1, Object v2, Object col) {
    return '$a and $b can only hold $v1 and $v2, so those numbers are ruled out in the rest of column $col.';
  }

  @override
  String exLatinFailEmpty(Object cell) {
    return 'But then no number is left for $cell.';
  }

  @override
  String exLatinFailNoPlaceRow(Object value, Object row) {
    return 'But then $value has no place left in row $row.';
  }

  @override
  String exLatinFailNoPlaceCol(Object value, Object col) {
    return 'But then $value has no place left in column $col.';
  }

  @override
  String exSkylineBound(Object clue, Object side, Object cell, Object max) {
    return 'The $clue at $side needs that many towers in sight, so $cell can be at most $max.';
  }

  @override
  String exSkylineTallest(Object cell, Object value, Object side) {
    return '$cell must be $value: the 1 at $side sees only the tallest tower.';
  }

  @override
  String exSkylineLineRow(Object cell, Object value, Object row) {
    return '$cell can\'t be $value: no way to fill row $row that matches its clues puts it there.';
  }

  @override
  String exSkylineLineCol(Object cell, Object value, Object col) {
    return '$cell can\'t be $value: no way to fill column $col that matches its clues puts it there.';
  }

  @override
  String exSkylineFailRow(Object row) {
    return 'But then row $row can\'t be filled to match its clues.';
  }

  @override
  String exSkylineFailCol(Object col) {
    return 'But then column $col can\'t be filled to match its clues.';
  }

  @override
  String get famLatin => 'Latin squares';

  @override
  String get famLatinAbout => 'Every row and column holds each number once, and the clues tell you more';

  @override
  String get cagesName => 'Cages';

  @override
  String get cagesTagline => 'Add, take away, multiply and divide to fill each cage';

  @override
  String get cagesRules =>
      '• Fill the grid with the numbers 1 to N (N = grid size), each once in every row and column.\n• Thick outlines split the grid into cages. The numbers in a cage make the clue in its corner with the sign shown: added up (+), multiplied (×), or, in a cage of two cells, the bigger minus the smaller (−) or the bigger divided by the smaller (÷). A cage of one cell simply holds its number.\n• A number may repeat in a cage, as long as not in the same row or column.\n\nPick a number in the palette and tap cells to place it, or tap a cell first and then a number. The pencil button toggles small notes. Long-press / right-click clears a cell.';

  @override
  String get tutCages1 =>
      'Every row and column holds 1 to 4 once. The outlines group cells into cages, and the numbers in a cage make its clue: in a 7+ cage they add up to 7. Fill the empty cells.';

  @override
  String get tutCages2 =>
      'In a cage of two cells, − is the bigger number minus the smaller, and ÷ the bigger divided by the smaller; either cell can hold the bigger one. Fill the top two rows.';

  @override
  String get tutCages3 =>
      '× multiplies. A number may repeat in a cage as long as it\'s not twice in a row or column, like 1 × 2 × 1 for a 2×. Rows and columns alone allow two ways here: let the cages pick one.';

  @override
  String get tutCages4 =>
      'Now a whole board. Start with the cages that can be made in few ways, note what a cell can still hold with the pencil, and let rows and columns narrow it down.';

  @override
  String get tutCagesS1 =>
      'Go through the ways to make a cage. Two cells making 3+ can only be 1 and 2; a 4− on a board of 5 is 1 and 5. A number that no way puts into a cell can be crossed off there.';

  @override
  String get tutCagesS2 =>
      'If every way to fill a cage puts some number into its cells of one row, no other cell of that row can have it. A 2÷ in a row on a board of 5 is 1 and 2 or 2 and 4: a 2 either way. And when two cells of a row can only hold the same two numbers, those two are theirs.';

  @override
  String get tutCagesS3 =>
      'The hardest boards need a guess you can disprove. Suppose a cell holds one of its last two or three numbers and follow on; if that runs into a contradiction, cross the number off.';

  @override
  String exCagesSingle(Object cell, Object value) {
    return '$cell must be $value: its cage is that one cell.';
  }

  @override
  String exCagesCombo(Object clue, Object cage, Object values, Object cell) {
    return 'No way to fill the $clue cage at $cage puts $values into $cell.';
  }

  @override
  String exCagesRequiredRow(Object clue, Object cage, Object values, Object row, Object cell) {
    return 'Every way to fill the $clue cage at $cage puts $values into its cells in row $row, so not into $cell.';
  }

  @override
  String exCagesRequiredCol(Object clue, Object cage, Object values, Object col, Object cell) {
    return 'Every way to fill the $clue cage at $cage puts $values into its cells in column $col, so not into $cell.';
  }

  @override
  String exCagesFail(Object clue, Object cage) {
    return 'But then the $clue cage at $cage can\'t be filled.';
  }

  @override
  String get signsName => 'Signs';

  @override
  String get signsTagline => 'Follow the signs: which number is bigger?';

  @override
  String get signsRules =>
      '• Fill the grid with the numbers 1 to N (N = grid size), each once in every row and column.\n• A sign between two neighbouring cells points at the smaller number, like 2 < 3: its open side faces the bigger one. Signs work along rows and down columns.\n• A few numbers may be given.\n\nPick a number in the palette and tap cells to place it, or tap a cell first and then a number. The pencil button toggles small notes. Long-press / right-click clears a cell.';

  @override
  String get tutSigns1 =>
      'Every row and column holds 1 to 4 once. A sign between two cells points at the smaller number, like 1 < 2, and works up and down too. Rows and columns alone allow two ways here: let the signs pick one.';

  @override
  String get tutSigns2 =>
      'Signs can form a chain: every cell of the third row is bigger than the next. The first one has three smaller cells after it, so it must be 4, and the last must be 1. Fill the bottom two rows.';

  @override
  String get tutSigns3 =>
      'The second cell of the second row is bigger than both its neighbours. They need two different smaller numbers, so it can\'t be 1 or 2. Fill the top two rows.';

  @override
  String get tutSigns4 =>
      'Now a whole board. Start where signs bunch up or a number is given, note what a cell can still hold with the pencil, and let rows and columns narrow it down.';

  @override
  String get tutSignsS1 =>
      'Follow the signs. A cell smaller than its neighbour can\'t reach the biggest number the neighbour can still hold, and a bigger one can\'t go down to its smallest. Along a chain a < b < c the first is at most N − 2. Cross off what the signs rule out.';

  @override
  String get tutSignsS2 =>
      'A cell bigger than both its neighbours in a row needs two different numbers below it, so it is at least 3; a run of signs counts the same way. And when two cells of a row can only hold the same two numbers, those two are theirs.';

  @override
  String get tutSignsS3 =>
      'The hardest boards need a guess you can disprove. Suppose a cell holds one of its last two or three numbers and follow on; if that runs into a contradiction, cross the number off.';

  @override
  String exSignsLess(Object cell, Object other, Object limit, Object values) {
    return '$cell is smaller than $other, which is at most $limit, so $cell can\'t be $values.';
  }

  @override
  String exSignsMore(Object cell, Object other, Object limit, Object values) {
    return '$cell is bigger than $other, which is at least $limit, so $cell can\'t be $values.';
  }

  @override
  String exSignsBelowRow(Object cell, Object cells, Object row, Object values) {
    return '$cell is smaller than each of $cells, all in row $row: they need different numbers bigger than it, so $cell can\'t be $values.';
  }

  @override
  String exSignsBelowCol(Object cell, Object cells, Object col, Object values) {
    return '$cell is smaller than each of $cells, all in column $col: they need different numbers bigger than it, so $cell can\'t be $values.';
  }

  @override
  String exSignsAboveRow(Object cell, Object cells, Object row, Object values) {
    return '$cell is bigger than each of $cells, all in row $row: they need different numbers smaller than it, so $cell can\'t be $values.';
  }

  @override
  String exSignsAboveCol(Object cell, Object cells, Object col, Object values) {
    return '$cell is bigger than each of $cells, all in column $col: they need different numbers smaller than it, so $cell can\'t be $values.';
  }

  @override
  String get soloName => 'Solo';

  @override
  String get soloTagline => 'Shade the repeats until every number stands alone';

  @override
  String get soloRules =>
      '• Every cell holds a number. Shade some of them so that no number shows twice in a row or column.\n• Shaded cells never touch side by side.\n• The cells left form one connected area.\n• Only shade a number that still shows, unshaded, somewhere in its row or column.\n\nTap a cell to cycle: shaded → circled (your \"this one stays\" note) → empty. Long-press / right-click cycles back. Circles are optional: the puzzle is done once the right numbers are shaded.';

  @override
  String get tutSolo1 =>
      'Shade numbers so that none shows twice in a row or column. Shaded cells never touch side by side, and the cells left stay in one piece. Only shade a number that repeats. Tap a cell to shade it.';

  @override
  String get tutSolo2 =>
      'Shaded cells never touch, so the numbers next to a shaded cell stay. The top-left 1 is shaded: tap the highlighted numbers twice to circle them (your note that they stay), then finish the board.';

  @override
  String get tutSolo3 =>
      'Two equal numbers with one cell between them: one of them is shaded, and either one would touch the middle cell, so the middle number stays. Circle the highlighted 1, then finish the board.';

  @override
  String get tutSolo4 =>
      'The cells left must form one piece. Once the 1 next to the top-left 1 is shaded, the 2 below it is that corner\'s only way out, so it stays. Finish the board.';

  @override
  String get tutSolo5 =>
      'Now a real board. Start with numbers that show only once in their row and column, and with equal numbers close together.';

  @override
  String get tutSoloS1 =>
      'Two equal numbers side by side can\'t both be shaded, so one of them stays, and every other copy of that number in their row or column is shaded. The top row has two 4s side by side: shade the highlighted 4.';

  @override
  String get tutSoloS2 =>
      'Keep the cells left in one piece: if shading a cell would cut them in two, with numbers that stay on both sides, that cell stays. Watch for shaded cells lining up diagonally toward an edge.';

  @override
  String get tutSoloS3 =>
      'A hard board. When stuck, shade a number and follow on: if two equal numbers end up left in one line, or some cells get cut off, that number stays.';

  @override
  String exSoloSupposeShade(Object cell) {
    return 'Suppose $cell were shaded.';
  }

  @override
  String exSoloSupposeKeep(Object cell) {
    return 'Suppose $cell stayed.';
  }

  @override
  String exSoloRefutedShade(Object cell) {
    return '$cell stays: shading it leads to a contradiction.';
  }

  @override
  String exSoloRefutedKeep(Object cell) {
    return '$cell is shaded: keeping it leads to a contradiction.';
  }

  @override
  String exSoloUnique(Object cell, int digit) {
    return '$cell stays: its $digit shows nowhere else in its row or column.';
  }

  @override
  String exSoloLastCopy(Object cell, int digit) {
    return '$cell stays: every other $digit in its row and column is shaded, and a shaded number must still show somewhere.';
  }

  @override
  String exSoloTwiceRow(Object cell, Object other, int digit, Object row) {
    return '$cell is shaded: the $digit at $other stays in row $row.';
  }

  @override
  String exSoloTwiceCol(Object cell, Object other, int digit, Object col) {
    return '$cell is shaded: the $digit at $other stays in column $col.';
  }

  @override
  String exSoloTouch(Object cell, Object other) {
    return '$cell stays: it touches the shaded $other.';
  }

  @override
  String exSoloShows(Object cell, Object other, int digit) {
    return '$cell stays: $other is shaded, and its $digit must still show in its row or column.';
  }

  @override
  String exSoloBetween(Object cell, Object a, Object b, int digit) {
    return '$cell stays: one of the ${digit}s at $a and $b is shaded, and both touch it.';
  }

  @override
  String exSoloPair(Object cell, Object a, Object b, int digit) {
    return '$cell is shaded: the ${digit}s at $a and $b sit side by side, so one of them stays.';
  }

  @override
  String exSoloWalled(Object cell, Object other) {
    return '$cell stays: it is the last way out for $other.';
  }

  @override
  String exSoloCut(Object cell) {
    return '$cell stays: shading it would cut the cells left in two.';
  }

  @override
  String exSoloFailTwice(Object a, Object b, int digit) {
    return 'But then $a and $b both keep a $digit in one line.';
  }

  @override
  String exSoloFailTouch(Object a, Object b) {
    return 'But then the shaded cells $a and $b touch.';
  }

  @override
  String exSoloFailLonely(Object a, int digit) {
    return 'But then the $digit at $a is shaded and shows nowhere else in its row or column.';
  }

  @override
  String exSoloFailWalled(Object a) {
    return 'But then $a is walled in.';
  }

  @override
  String exSoloFailApart(Object a, Object b) {
    return 'But then $a and $b are cut off from each other.';
  }

  @override
  String get dominoName => 'Dominoes';

  @override
  String get dominoTagline => 'Find where every domino of the set lies';

  @override
  String get dominoRules =>
      '• The grid is a full set of dominoes with the outlines rubbed off: every pair of numbers, from 0–0 up to the highest double, is on exactly one domino.\n• Split the grid into dominoes of two neighbouring cells, so that every pair shows up once.\n\nTap the line between two cells to join them into a domino; tap again for a cross (your \"no domino here\" note) and once more to clear it. Drag across cells to lay dominoes along the way. A new domino takes its cells away from the dominoes that had them.';

  @override
  String get tutDomino1 =>
      'The grid is a set of dominoes with the outlines rubbed off, and every pair of numbers is on exactly one domino. This small set has 0–0, 0–1 and 1–1. Join two neighbouring cells by tapping the line between them, or drag from one cell to the other.';

  @override
  String get tutDomino2 =>
      'A pair of numbers that sits side by side in only one place must be a domino there. The highlighted 0 and 0 are the only two 0s next to each other: join them, then finish the board.';

  @override
  String get tutDomino3 =>
      'Every cell is in a domino. The 2–2 is placed, so the highlighted 0 has only one neighbour left to pair with. Join them, then finish the board.';

  @override
  String get tutDomino4 =>
      'Every pair is used once. The 2–3 domino is placed already, so the two other 2–3s in the top corner can\'t be dominoes: tap the line between each of them twice to cross it out. Then see which neighbour the corner 2 has left, and finish the board.';

  @override
  String get tutDomino5 =>
      'Now a real board. Start with pairs that fit in one place only, and with cells that have one neighbour left. Cross out the places of every pair you have placed.';

  @override
  String get tutDominoS1 =>
      'When every place left for a pair covers the same cell, that cell belongs to that pair, so it can\'t pair with any other neighbour. Every place left for the 3–3 covers the highlighted cell: cross out its other neighbours, then finish the board.';

  @override
  String get tutDominoS2 =>
      'When every domino a cell can be in is the same pair, that pair lies at this cell, so cross out its places elsewhere. The highlighted 3 can only be in a 1–3, either way: cross out the other 1–3s.';

  @override
  String get tutDominoS3 =>
      'A hard board. Watch for open cells walled into a group of an odd size: dominoes can\'t fill it. When stuck, try a domino and follow on: if a cell or a pair ends up with no place, or an odd group appears, that domino is wrong.';

  @override
  String exDominoOnlySpot(Object a, Object b, Object link) {
    return '$a–$b fits only at $link, so that is a domino.';
  }

  @override
  String exDominoOnlyWay(Object cell, Object link) {
    return '$cell has one neighbour left to pair with, so $link is a domino.';
  }

  @override
  String exDominoCovered(Object cell, Object link) {
    return '$cell is in a domino already, so $link is not one.';
  }

  @override
  String exDominoUsed(Object a, Object b, Object placed, Object link) {
    return '$a–$b lies at $placed, so $link is not a domino.';
  }

  @override
  String exDominoPairAtCell(Object a, Object b, Object cell, Object link) {
    return 'Every place left for $a–$b covers $cell, so $cell belongs to it and $link is not a domino.';
  }

  @override
  String exDominoCellOnePair(Object a, Object b, Object cell, Object link) {
    return '$cell can only be in a $a–$b, so that domino lies at $cell and $link is not one.';
  }

  @override
  String exDominoFailCell(Object cell) {
    return 'But then no domino can cover $cell.';
  }

  @override
  String exDominoFailPair(Object a, Object b) {
    return 'But then $a–$b has no place left.';
  }

  @override
  String exDominoFailCellTwice(Object cell) {
    return 'But then $cell is in two dominoes.';
  }

  @override
  String exDominoFailPairTwice(Object a, Object b) {
    return 'But then $a–$b is placed twice.';
  }

  @override
  String exDominoFailOdd(Object cell, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: '1 cell',
    );
    return 'But then the open cells with $cell are walled in as a group of $_temp0, an odd number, which dominoes can\'t fill.';
  }

  @override
  String exDominoSupposeLine(Object link) {
    return 'Suppose $link were a domino.';
  }

  @override
  String exDominoSupposeCross(Object link) {
    return 'Suppose $link were not a domino.';
  }

  @override
  String exDominoRefutedLine(Object link) {
    return '$link is not a domino: making it one leads to a contradiction.';
  }

  @override
  String exDominoRefutedCross(Object link) {
    return '$link is a domino: leaving it out leads to a contradiction.';
  }

  @override
  String get tagShips => 'ships, boats, fleet, sea, navy, hidden';

  @override
  String get fleetName => 'Fleet';

  @override
  String get fleetTagline => 'Find the hidden ships from the counts at the edge';

  @override
  String get fleetRules =>
      '• A fleet of ships hides in the grid; the ships it has are shown below the grid. Each ship is a straight line of cells, across or down.\n• Ships never touch each other, not even diagonally.\n• The numbers outside the grid tell how many ship cells each row and column holds.\n• Some cells are shown from the start: water, or a piece of a ship. A rounded end shows where its ship ends, a square piece sits in the middle of a ship, and a round piece is a whole ship of one cell.\n\nTap a cell to cycle: ship → water (your \"no ship here\" note) → empty. Right-click cycles back. Slide across cells to mark them all in one go. A long press puts water on every cell where the placed ships leave no room for another. Water is optional: the puzzle is done once every ship is in place. Ships you finish fade in the list below the grid once water or the edge closes them in.';

  @override
  String get tutFleet1 =>
      'A fleet of ships hides in the grid, and the list below it shows its ships. The numbers outside tell how many ship cells each row and column holds. Here the fleet is three ships of one cell. Tap a cell to put a ship there, tap again for water.';

  @override
  String get tutFleet2 =>
      'Ships are straight lines of cells, and they never touch, not even diagonally. The bottom row needs two ship cells, but this fleet has no ship of two cells, so they are two separate ships with a gap between them. Finish the board.';

  @override
  String get tutFleet3 =>
      'Some pieces are shown from the start. A rounded end means its ship goes on the other way: the piece in the corner is rounded at the top, so the cell below it is a ship too. Finish the board.';

  @override
  String get tutFleet4 =>
      'Now a real board. Start with rows and columns whose count is zero or full, put water around the ships you know, and keep an eye on which ships are still missing.';

  @override
  String get tutFleetS1 =>
      'Look for where the missing ships still fit. A cell no missing ship can pass through is water, and when the longest missing ship has only a few places left, the cells they all share are ship. Count the places in the rows and columns with room for it.';

  @override
  String get tutFleetS2 =>
      'A hard board: some counts are hidden. When stuck, suppose a cell is a ship and follow on: if a row overflows, ships touch or a ship has nowhere to go, that cell is water.';

  @override
  String exFleetSupposeShip(Object cell) {
    return 'Suppose $cell were part of a ship.';
  }

  @override
  String exFleetSupposeWater(Object cell) {
    return 'Suppose $cell were water.';
  }

  @override
  String exFleetRefutedShip(Object cell) {
    return '$cell is water: a ship there leads to a contradiction.';
  }

  @override
  String exFleetRefutedWater(Object cell) {
    return '$cell is part of a ship: water there leads to a contradiction.';
  }

  @override
  String exFleetPieceShip(Object cell, Object other) {
    return '$cell is part of a ship: the piece at $other goes on that way.';
  }

  @override
  String exFleetPieceWater(Object cell, Object other) {
    return '$cell is water: the piece at $other ends on that side.';
  }

  @override
  String exFleetMiddle(Object cell, Object other) {
    return '$cell is part of a ship: the middle piece at $other can\'t run the other way.';
  }

  @override
  String exFleetDiagonal(Object cell, Object other) {
    return '$cell is water: it touches the ship at $other diagonally.';
  }

  @override
  String exFleetRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count ship cells',
      one: 'its ship cell',
    );
    return '$cell is water: row $row already has $_temp0.';
  }

  @override
  String exFleetColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count ship cells',
      one: 'its ship cell',
    );
    return '$cell is water: column $col already has $_temp0.';
  }

  @override
  String exFleetRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ship cells',
      one: 'a ship cell',
    );
    return '$cell is part of a ship: row $row needs $_temp0, and only that many cells are left.';
  }

  @override
  String exFleetColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ship cells',
      one: 'a ship cell',
    );
    return '$cell is part of a ship: column $col needs $_temp0, and only that many cells are left.';
  }

  @override
  String exFleetAllFound(Object cell) {
    return '$cell is water: every ship of the fleet is found.';
  }

  @override
  String exFleetLongest(Object cell, Object other, int length) {
    return '$cell is water: the ship at $other already has length $length, as long as the longest ship still missing.';
  }

  @override
  String exFleetTooLong(Object cell, int length) {
    return '$cell is water: a ship there would be longer than $length, the length of the longest ship still missing.';
  }

  @override
  String exFleetNoFit(Object cell) {
    return '$cell is water: none of the missing ships fits through it.';
  }

  @override
  String exFleetExtend(Object cell, Object other) {
    return '$cell is part of a ship: every ship that fits through $other covers it.';
  }

  @override
  String exFleetMustCover(Object cell, int length) {
    return '$cell is part of a ship: every place left for the missing ship of length $length covers it.';
  }

  @override
  String exFleetOnlySpots(Object cell, int length) {
    return '$cell is part of a ship: the ships of length $length have just enough places left.';
  }

  @override
  String exFleetFailTouch(Object a, Object b) {
    return 'But then the ships at $a and $b touch.';
  }

  @override
  String exFleetFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ship cells',
      one: 'one ship cell',
    );
    return 'But then row $row has more than $_temp0.';
  }

  @override
  String exFleetFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ship cells',
      one: 'one ship cell',
    );
    return 'But then column $col has more than $_temp0.';
  }

  @override
  String exFleetFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count ship cells',
      one: 'its ship cell',
    );
    return 'But then row $row can\'t get $_temp0.';
  }

  @override
  String exFleetFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'its $count ship cells',
      one: 'its ship cell',
    );
    return 'But then column $col can\'t get $_temp0.';
  }

  @override
  String exFleetFailPiece(Object a) {
    return 'But then the piece at $a doesn\'t fit.';
  }

  @override
  String exFleetFailLong(Object a, int length) {
    return 'But then the ship at $a is longer than $length, the longest ship still missing.';
  }

  @override
  String exFleetFailFleet(int length) {
    return 'But then there are too many ships of length $length.';
  }

  @override
  String exFleetFailNoRoom(int length) {
    return 'But then the ships of length $length don\'t all fit.';
  }

  @override
  String exFleetFailStray(Object a) {
    return 'But then the ship cell $a can\'t belong to any missing ship.';
  }

  @override
  String get tagWater => 'water, fill, liquid, pour, level, tank, pool, flood';

  @override
  String get basinsName => 'Basins';

  @override
  String get basinsTagline => 'Fill the basins with level water to match the counts';

  @override
  String get basinsRules =>
      '• The grid is cut into basins. Fill some cells with water.\n• Water settles: in every basin it fills from the bottom up to one level, the same across the whole basin. Every cell of the basin at that height or lower holds water, every cell above it stays dry. A basin may also stay empty or fill to the top.\n• The numbers outside the grid tell how many water cells each row and column holds.\n\nTap a cell to cycle: water → dry (your note) → empty. Right-click cycles back. Slide across cells to fill them all in one go. A long press lets the water settle: it fills every cell of a basin below your water, and marks dry the cells above your dry marks and in rows and columns that have all their water. Dry marks are optional: the puzzle is done once all the water is in place.';

  @override
  String get tutBasins1 =>
      'The grid is cut into basins, and water settles in each one from the bottom up. The numbers outside tell how many water cells each row and column holds. Column A holds 2, so its basin fills its two lowest cells. Tap a cell to fill it with water, tap again to mark it dry.';

  @override
  String get tutBasins2 =>
      'Water lies level across the whole basin: when one cell of a basin holds water, so does every cell of that basin as low or lower. Row 2 needs just one water cell, so the wide basin can\'t reach that high. Finish the board.';

  @override
  String get tutBasins3 =>
      'Think ahead: water in a cell fills everything below it in its basin. Once the bottom row is full, column A needs just one more water cell, but water in its top cell would fill two. So the top cell stays dry. Finish the board.';

  @override
  String get tutBasins4 =>
      'Now a real board. Start with rows and columns that are empty or full, let the water settle, and before you fill a cell, count how much water it brings along.';

  @override
  String get tutBasinsS1 =>
      'Water in a row comes in pieces: the cells of one basin in that row fill together. When only some sets of pieces add up to the row\'s count, a piece that is in all of them holds water, and a piece in none of them stays dry.';

  @override
  String get tutBasinsS2 =>
      'Try every water level of a basin, from empty to full, against the counts of the rows and columns it touches. Cells that come out the same in every level that fits are settled.';

  @override
  String get tutBasinsS3 =>
      'A hard board: some counts are hidden. When stuck, suppose a cell holds water and let it settle: if a row or column overflows or can\'t reach its count, that cell stays dry.';

  @override
  String exBasinsSupposeWater(Object cell) {
    return 'Suppose $cell held water.';
  }

  @override
  String exBasinsSupposeDry(Object cell) {
    return 'Suppose $cell stayed dry.';
  }

  @override
  String exBasinsRefutedWater(Object cell) {
    return '$cell stays dry: water there leads to a contradiction.';
  }

  @override
  String exBasinsRefutedDry(Object cell) {
    return '$cell holds water: leaving it dry leads to a contradiction.';
  }

  @override
  String exBasinsWaterBelow(Object cell, Object other) {
    return '$cell holds water: the water at $other fills its basin up to that height.';
  }

  @override
  String exBasinsDryAbove(Object cell, Object other) {
    return '$cell stays dry: $other in the same basin is dry, so the water stays lower.';
  }

  @override
  String exBasinsRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count water cells',
      one: 'its water cell',
    );
    return '$cell stays dry: row $row already has $_temp0.';
  }

  @override
  String exBasinsColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'all its $count water cells',
      one: 'its water cell',
    );
    return '$cell stays dry: column $col already has $_temp0.';
  }

  @override
  String exBasinsRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count water cells',
      one: 'a water cell',
    );
    return '$cell holds water: row $row needs $_temp0, and only that many cells are left.';
  }

  @override
  String exBasinsColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count water cells',
      one: 'a water cell',
    );
    return '$cell holds water: column $col needs $_temp0, and only that many cells are left.';
  }

  @override
  String exBasinsTooMuchRow(Object cell, Object row, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'needs only $need more',
      one: 'needs only one more',
      zero: 'already has all its water',
    );
    return '$cell stays dry: water there would fill $_temp0 of row $row, which $_temp1.';
  }

  @override
  String exBasinsTooMuchCol(Object cell, Object col, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'needs only $need more',
      one: 'needs only one more',
      zero: 'already has all its water',
    );
    return '$cell stays dry: water there would fill $_temp0 of column $col, which $_temp1.';
  }

  @override
  String exBasinsTooLittleRow(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    return '$cell holds water: dry, it would keep $_temp0 of row $row dry, and the row could no longer reach its count.';
  }

  @override
  String exBasinsTooLittleCol(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    return '$cell holds water: dry, it would keep $_temp0 of column $col dry, and the column could no longer reach its count.';
  }

  @override
  String exBasinsWaysWater(Object cell, Object row, int count) {
    return '$cell holds water: every way to make $count in row $row from its basins\' pieces needs this one.';
  }

  @override
  String exBasinsWaysDry(Object cell, Object row, int count) {
    return '$cell stays dry: no way to make $count in row $row from its basins\' pieces uses this one.';
  }

  @override
  String exBasinsLevelsWater(Object cell) {
    return '$cell holds water: every water level of its basin that leaves it dry breaks the count of a row or column.';
  }

  @override
  String exBasinsLevelsDry(Object cell) {
    return '$cell stays dry: every water level of its basin that reaches it breaks the count of a row or column.';
  }

  @override
  String exBasinsFailLevel(Object wet, Object dry) {
    return 'But then $wet holds water while $dry, as low or lower in the same basin, stays dry.';
  }

  @override
  String exBasinsFailRowMany(Object row, int count) {
    return 'But then row $row gets more than $count water cells.';
  }

  @override
  String exBasinsFailColMany(Object col, int count) {
    return 'But then column $col gets more than $count water cells.';
  }

  @override
  String exBasinsFailRowFew(Object row, int count) {
    return 'But then row $row can no longer get $count water cells.';
  }

  @override
  String exBasinsFailColFew(Object col, int count) {
    return 'But then column $col can no longer get $count water cells.';
  }

  @override
  String exBasinsFailWays(Object row, int count) {
    return 'But then no set of the basins\' pieces in row $row adds up to $count.';
  }

  @override
  String exBasinsFailLevels(Object cell) {
    return 'But then no water level of the basin at $cell fits the counts.';
  }

  @override
  String recallGoalRounds(int count) {
    return '$count rounds';
  }

  @override
  String get recallGoalRoundsHint => 'Play a set number of rounds and score as many points as you can.';

  @override
  String recallGoalLives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lives',
      one: '1 life',
    );
    return '$_temp0';
  }

  @override
  String recallGoalLivesHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: 'once',
    );
    return 'Play on until you miss $_temp0, and beat your best score.';
  }

  @override
  String recallRound(int round, int count) {
    return 'Round $round/$count';
  }

  @override
  String get recallReady => 'Ready';

  @override
  String get recallStart => 'Tap to start';

  @override
  String get recallWatch => 'Remember…';

  @override
  String recallRight(int points) {
    return 'Right! +$points';
  }

  @override
  String get recallMissed => 'Missed';

  @override
  String recallRoundsRight(int correct, int count) {
    return '$correct of $count rounds right';
  }

  @override
  String get tagMemory => 'memory, remember, recall, brain training, concentration, attention';

  @override
  String get glimpseName => 'Glimpse';

  @override
  String get glimpseTagline => 'Cells light up for a moment: tap them all from memory';

  @override
  String get glimpseRules =>
      '• Some cells light up for a moment, then go dark. Tap every cell that lit up, in any order.\n• Tap Ready to hide them sooner.\n• A tap on a cell that didn\'t light up ends the round.\n• A round you get right scores a point per cell, and the next one lights one more cell. After a miss, it lights one fewer.\n\nGoals\n• Rounds: play 10 rounds for a best score.\n• Lives: play on until your third miss.\n\nThe difficulty sets how many cells the first round lights and how long they stay lit.';

  @override
  String get glimpsePrompt => 'Tap every cell that lit up';

  @override
  String get tutGlimpse1 =>
      'Tap the board to start. Three cells light up for a moment: remember them, and once they go dark, tap all three.';

  @override
  String get tutGlimpse2 =>
      'Tap Ready as soon as you have the cells, to hide them sooner. A tap on a cell that didn\'t light up ends the round; here the round then plays again. Get both rounds right.';

  @override
  String get tutGlimpse3 =>
      'A real board: each round you get right lights one more cell next time, and a miss lights one fewer. Get 3 rounds right.';

  @override
  String get famMemory => 'Memory';

  @override
  String get famMemoryAbout =>
      'Look closely, then answer from memory. Every round you get right makes the next one harder';

  @override
  String get vanishName => 'Vanish';

  @override
  String get vanishTagline => 'Tap 1 and the numbers hide: tap the rest in order from memory';

  @override
  String get vanishRules =>
      '• Numbers from 1 up appear on the grid. Take your time: they stay until you tap 1.\n• As soon as you tap 1, the other numbers hide. Tap their cells in order: 2, 3, 4…\n• A tap on the wrong cell ends the round.\n• A round you get right scores a point per number, and the next one shows one number more. After a miss, it shows one fewer.\n\nGoals\n• Rounds: play 10 rounds for a best score.\n• Lives: play on until your third miss.\n\nThe difficulty sets how many numbers the first round shows.';

  @override
  String get vanishWatch => 'Tap 1 when you\'re ready';

  @override
  String get vanishPrompt => 'Tap the numbers in order';

  @override
  String get tutVanish1 =>
      'Tap the board to start. Numbers appear: tap 1, and the others hide. Then tap where 2 and 3 were.';

  @override
  String get tutVanish2 =>
      'Look as long as you like: the numbers stay until you tap 1. A tap on the wrong cell ends the round; here the round then plays again. Get both rounds right.';

  @override
  String get tutVanish3 =>
      'A real board: each round you get right shows one number more next time, and a miss one fewer. Get 3 rounds right.';

  @override
  String get hopperName => 'Hopper';

  @override
  String get hopperTagline => 'Watch the frog hop from pad to pad, then retrace its jumps';

  @override
  String get hopperRules =>
      '• A frog hops from pad to pad, one jump at a time. When it stops, tap the pads it landed on, in the same order.\n• A pad can come up more than once: tap it again each time.\n• A wrong tap ends the round.\n• A round you get right scores a point per jump, and the next one has one jump more. After a miss, it has one fewer.\n\nOrder\n• Same order: from the first jump to the last.\n• Backwards: from the last jump back to the first.\n\nGoals\n• Rounds: play 10 rounds for a best score.\n• Lives: play on until your third miss.\n\nThe difficulty sets how many jumps the first round has and how fast the frog hops.';

  @override
  String get hopperOrder => 'Order';

  @override
  String get hopperForward => 'Same order';

  @override
  String get hopperForwardHint => 'Tap the pads in the order the frog jumped.';

  @override
  String get hopperReverse => 'Backwards';

  @override
  String get hopperReverseHint => 'Tap the pads from the frog\'s last jump back to its first.';

  @override
  String get hopperWatch => 'Watch the frog…';

  @override
  String get hopperPrompt => 'Tap the pads in order';

  @override
  String get hopperPromptReverse => 'Tap the pads backwards, last jump first';

  @override
  String get tutHopper1 =>
      'Tap the board to start. The frog hops from pad to pad. When it stops, tap the pads it landed on, in the same order.';

  @override
  String get tutHopper2 =>
      'A pad can come up more than once: tap it again each time. A wrong tap ends the round; here the round then plays again. Get both rounds right.';

  @override
  String get tutHopper3 =>
      'With the Backwards option, tap the same pads from the last jump back to the first. Try it once.';

  @override
  String get tutHopper4 =>
      'A real board: each round you get right adds a jump next time, and a miss takes one away. Get 3 rounds right.';

  @override
  String get reboundName => 'Rebound';

  @override
  String get reboundTagline => 'Remember the bumpers, then tell where the ball comes out';

  @override
  String get reboundRules =>
      '• Bumpers sit on the grid, and a ball waits at an arrow on the edge. Remember the bumpers: after a moment (or when you tap Ready) they hide.\n• The ball rolls in at the arrow, and every bumper it meets turns it a quarter turn, the way the bumper slants. Tap the edge where it will leave the board.\n• A round you get right scores a point per bumper, and the next one has one bumper more. After a miss, it has one fewer.\n\nGoals\n• Rounds: play 10 rounds for a best score.\n• Lives: play on until your third miss.\n\nThe difficulty sets how many bumpers the first round has and how long they stay.';

  @override
  String get reboundPrompt => 'Tap where the ball leaves the board';

  @override
  String get tutRebound1 =>
      'Tap the board to start. The ball rolls in at the arrow and bounces off the bumper, the way it slants. Remember it; when it hides, tap the edge where the ball comes out.';

  @override
  String get tutRebound2 =>
      'The ball may meet several bumpers and miss others. Tap Ready as soon as you have them. A wrong edge ends the round; here the round then plays again.';

  @override
  String get tutRebound3 =>
      'A real board: each round you get right adds a bumper next time, and a miss takes one away. Get 3 rounds right.';

  @override
  String get pebblesName => 'Pebbles';

  @override
  String get pebblesTagline => 'Two kinds of stones, each kind all in one piece';

  @override
  String get pebblesRules =>
      '• Put a stone in every cell: filled or hollow.\n• All filled stones form one group, joined side by side, and so do all hollow stones.\n• No 2×2 block holds four stones of one kind.\n• Some stones are shown from the start.\n\nTap a cell to cycle: filled → hollow → empty. Long-press / right-click cycles back. Slide across cells to put the same stone in all of them. Stones of one kind side by side are drawn joined, so you can see the groups.';

  @override
  String get tutPebbles1 =>
      'Put a stone in every cell. All filled stones must form one group, joined side by side, and so must all hollow stones. Tap an empty cell once for a filled stone, twice for a hollow one. Fill in this board.';

  @override
  String get tutPebbles2 =>
      'No 2×2 block may hold four stones of one kind. The highlighted block already has three hollow stones, so its last cell gets a filled one. Finish the board the same way.';

  @override
  String get tutPebbles3 =>
      'Every group must reach the rest of its kind. The hollow stone in the corner is walled in but for one cell, so that cell gets a hollow stone too. Follow the hollow stones until they meet the others.';

  @override
  String get tutPebbles4 =>
      'A cell surrounded by filled stones can\'t hold a hollow one: it would be cut off from the other hollow stones. The same goes the other way round. Fill the highlighted cell, then finish the board.';

  @override
  String get tutPebbles5 =>
      'Now a real board. Look for blocks with three stones alike, and for groups with only one way out.';

  @override
  String get tutPebblesS1 =>
      'Going round the edge of the board, the filled stones form one unbroken run and the hollow stones another: if the edge switched kinds four times, the two groups would have to cross. A1 and D4 hold filled stones and C4 a hollow one, so the edge from A1 along the top and down to D4 is all filled.';

  @override
  String get tutPebblesS2 =>
      'A 2×2 block never alternates, with filled stones on one diagonal and hollow ones on the other: the filled pair could only meet by going round one of the hollow stones and cutting it off. So when one diagonal holds two stones alike and the other one stone of the other kind, the last cell matches the diagonal.';

  @override
  String get tutPebblesS3 =>
      'Some cells hold a kind together: if the other kind took such a cell, the stones on either side of it could no longer meet. Such a cell gets the kind it holds together. Look for narrow passages between the groups.';

  @override
  String exPebblesBlock(Object cell, Object stone, Object other) {
    return '$cell holds $stone: the rest of its 2×2 block holds $other, and a block never holds four alike.';
  }

  @override
  String exPebblesEnclosed(Object cell, Object stone, Object other) {
    return '$cell holds $stone: it is walled in by $stone, so $other there would be cut off from the rest of its kind.';
  }

  @override
  String exPebblesExit(Object cell, Object stone, Object group) {
    return '$cell holds $stone: it is the only way out for the group at $group.';
  }

  @override
  String exPebblesEdge(Object cell, Object stone, Object other, Object a, Object b, Object c) {
    return '$cell holds $stone: round the edge each kind forms one run. $a and $b hold $stone and $c holds $other, so the stretch from $a to $b through $cell holds $stone.';
  }

  @override
  String exPebblesChecker(Object cell, Object stone, Object other, Object a, Object b, Object c) {
    return '$cell holds $stone: $a and $b hold $stone on one diagonal of a 2×2 block and $c holds $other, and a block never alternates.';
  }

  @override
  String exPebblesCut(Object cell, Object stone, Object other) {
    return '$cell holds $stone: $other there would split the $stone stones into parts that can\'t meet.';
  }

  @override
  String exPebblesFailBlock(Object cell) {
    return 'But then the 2×2 block at $cell holds four alike.';
  }

  @override
  String exPebblesFailClosed(Object cell) {
    return 'But then the group at $cell is walled in, cut off from the rest of its kind.';
  }

  @override
  String exPebblesFailEdge(Object a, Object b, Object c, Object d) {
    return 'But then the edge switches kinds at $a, $b, $c and $d, and the two kinds would have to cross.';
  }

  @override
  String exPebblesFailChecker(Object cell) {
    return 'But then the 2×2 block at $cell alternates.';
  }

  @override
  String exPebblesFailApart(Object a, Object b) {
    return 'But then $a and $b are cut off from each other.';
  }

  @override
  String get totalsName => 'Totals';

  @override
  String get totalsTagline => 'A crossword of digits that add up across and down';

  @override
  String get totalsRules =>
      '• Fill every empty cell with a digit from 1 to 9.\n• The clue cells give sums: the number above the diagonal is the sum of the run of cells to its right, the number below the diagonal the sum of the run below it. A run ends at the next clue cell or the edge.\n• A run never holds a digit twice.\n\nPick a digit in the palette and tap cells to place it, or tap a cell first and then a digit. The pencil button toggles small notes. Long-press / right-click clears a cell. A sum fades once its run is full and adds up.';

  @override
  String get tutTotals1 =>
      'Fill the empty cells with digits 1 to 9. In a clue cell, the number above the diagonal is the sum of the run to its right, the number below it the sum of the run below. 3 in two cells can only be 1 + 2, and 4 only 1 + 3: the corner cell is in both runs, so it takes the 1.';

  @override
  String get tutTotals2 => 'A run never holds a digit twice: 4 in two cells is 1 + 3, never 2 + 2. Fill in this board.';

  @override
  String get tutTotals3 =>
      'Some sums can be made only one way: 24 in three cells needs 7, 8 and 9, and 7 in three cells needs 1, 2 and 4. Each cell takes a digit that both its runs allow.';

  @override
  String get tutTotals4 =>
      'Now a real board. Start with the runs whose sum can be made only one way, then look where runs cross.';

  @override
  String get tutTotalsS1 =>
      'List the sets of different digits that make a run\'s sum. A digit that is in every set has to go somewhere in the run: if only one cell of the run can take it, it goes there.';

  @override
  String get tutTotalsS2 =>
      'Sometimes every digit fits a cell on its own, but not together with the others: if two cells of a run can only hold 1 or 3, they take both, and no other cell of the run can. Try every way to fill a short run with different digits.';

  @override
  String get tutTotalsS3 =>
      'The hardest boards need a guess you can disprove. Suppose a cell holds one of its last two or three digits and follow on; if a run can no longer make its sum, cross the digit off.';

  @override
  String exTotalsCombo(Object sum, Object run, Object digits, Object cell, Object gone) {
    return 'To make $sum in $run, the open cells can only hold $digits, so $cell can\'t be $gone.';
  }

  @override
  String exTotalsMust(Object sum, Object run, Object value, Object cell) {
    return '$cell must be $value: every way to make $sum in $run uses $value, and no other cell there can take it.';
  }

  @override
  String exTotalsFill(Object sum, Object run, Object gone, Object cell) {
    return 'No way to fill $run with different digits that make $sum puts $gone into $cell.';
  }

  @override
  String exTotalsNaked(Object cell, Object value) {
    return '$cell must be $value: every other digit is ruled out there.';
  }

  @override
  String exTotalsFailEmpty(Object cell) {
    return 'But then no digit is left for $cell.';
  }

  @override
  String exTotalsFailRun(Object sum, Object run) {
    return 'But then $run can no longer make $sum.';
  }

  @override
  String get famSudoku => 'Sudoku';

  @override
  String get famSudokuAbout => 'Every digit once per row, column and box, with more clues on top';

  @override
  String get pocketsName => 'Pockets';

  @override
  String get pocketsTagline => 'Sudoku whose dashed pockets add up to their sums';

  @override
  String get pocketsRules =>
      '• Fill every cell with a digit from 1 to N (N = grid size): each digit once in every row, every column and every box, as in Sudoku.\n• The grid is also cut into pockets with dashed outlines. The digits of a pocket add up to the number in its corner, and a pocket never holds a digit twice.\n• There are no given digits: the sums tell you everything.\n\nPick a digit in the palette and tap cells to place it, or tap a cell first and then a digit. The pencil button toggles small notes. Long-press / right-click clears a cell. A sum fades once its pocket is full and adds up.';

  @override
  String get tutPockets1 =>
      'As in Sudoku, every row, column and box (the thick outlines) holds each digit from 1 to 4 once. The dashed pockets add more: their digits add up to the number in the corner. 3 in two cells can only be 1 + 2, and 7 only 3 + 4; the columns tell you which goes where.';

  @override
  String get tutPockets2 =>
      'A pocket never holds a digit twice, even where its cells sit in different rows and columns. So three cells of a 4 × 4 leave out just one digit: 6 is 1 + 2 + 3, and 8 is 1 + 3 + 4.';

  @override
  String get tutPockets3 =>
      'This board has no digits at all. Start with the pockets whose sum can be made only one way, then go on as in Sudoku.';

  @override
  String get tutPockets4 =>
      'Now a real board. Note the digits a pocket can hold, and remember: a whole row, column or box adds up to 1 + 2 + … + 6 = 21.';

  @override
  String get tutPocketsS1 =>
      'A whole row, column or box always adds up to the same total: 21 on a 6 × 6, 45 on a 9 × 9. Take away the sums of the pockets lying wholly inside it, and what is left is the sum of its other cells. When one or two cells are left over, that often settles them.';

  @override
  String get tutPocketsS2 =>
      'It works the other way round too. Add up the pockets that reach into a row, column or box, take away its total, and you have the sum of their cells sticking out of it. Bands of whole boxes work just the same.';

  @override
  String get tutPocketsS3 =>
      'The hardest boards need a guess you can disprove. Suppose a cell holds one of its last two or three digits and follow on; if a pocket can no longer make its sum, or a digit has no place left, cross the digit off.';

  @override
  String exPocketsCombo(Object sum, Object pocket, Object digits, Object cell, Object gone) {
    return 'To make $sum in the pocket at $pocket, its open cells can only hold $digits, so $cell can\'t be $gone.';
  }

  @override
  String exPocketsMust(Object sum, Object pocket, Object value, Object cell) {
    return '$cell must be $value: every way to make $sum in the pocket at $pocket uses $value, and no other cell there can take it.';
  }

  @override
  String exPocketsFill(Object sum, Object pocket, Object gone, Object cell) {
    return 'No way to fill the pocket at $pocket with different digits that make $sum puts $gone into $cell.';
  }

  @override
  String exPocketsLineRow(Object sum, Object pocket, Object value, Object row) {
    return 'Every way to make $sum in the pocket at $pocket uses $value, and there it can only go in row $row, so $value is ruled out in the rest of row $row.';
  }

  @override
  String exPocketsLineCol(Object sum, Object pocket, Object value, Object col) {
    return 'Every way to make $sum in the pocket at $pocket uses $value, and there it can only go in column $col, so $value is ruled out in the rest of column $col.';
  }

  @override
  String exPocketsLineBox(Object sum, Object pocket, Object value, Object box) {
    return 'Every way to make $sum in the pocket at $pocket uses $value, and there it can only go in box $box, so $value is ruled out in the rest of box $box.';
  }

  @override
  String exPocketsFailSum(Object pocket, Object sum) {
    return 'But then the pocket at $pocket can no longer make $sum.';
  }

  @override
  String exPocketsFailCells(Object cells, Object sum) {
    return 'But then $cells can no longer add up to $sum.';
  }

  @override
  String exPocketsRegionRow(Object row) {
    return 'row $row';
  }

  @override
  String exPocketsRegionCol(Object col) {
    return 'column $col';
  }

  @override
  String exPocketsRegionBox(Object box) {
    return 'box $box';
  }

  @override
  String exPocketsRegionRows(Object from, Object to) {
    return 'rows $from–$to';
  }

  @override
  String exPocketsRegionCols(Object from, Object to) {
    return 'columns $from–$to';
  }

  @override
  String exPocketsInnie(Object region, Object total, Object inside, Object cells, Object sum) {
    return 'The digits in $region add up to $total and the pockets wholly inside it to $inside, so $cells add up to $sum';
  }

  @override
  String exPocketsOutie(Object region, Object total, Object reach, Object cells, Object sum) {
    return 'The digits in $region add up to $total and the pockets reaching into it to $reach, so $cells, outside it, add up to $sum';
  }

  @override
  String exPocketsAreaCombo(Object lead, Object digits, Object cell, Object gone) {
    return '$lead. These cells can only hold $digits, so $cell can\'t be $gone.';
  }

  @override
  String exPocketsAreaMust(Object lead, Object value, Object cell) {
    return '$lead. Every way to do that uses $value, and of these cells only $cell can take it.';
  }

  @override
  String exPocketsAreaFill(Object lead, Object gone, Object cell) {
    return '$lead. No way to do that with different digits puts $gone into $cell.';
  }

  @override
  String get chambersName => 'Chambers';

  @override
  String get chambersTagline => 'Shade each room\'s count, and keep the lines between rooms short';

  @override
  String get chambersRules =>
      '• The grid is cut into rooms. A number in a room tells how many of its cells are shaded; a room without a number may hold any count.\n• Shaded cells never touch side by side.\n• The unshaded cells form one connected area.\n• A straight line of unshaded cells, across or down, never crosses two room borders: it reaches into two rooms at most.\n\nTap a cell to cycle: shaded → dot (your \"this one stays\" note) → empty. Right-click cycles back. A long press dots the cells next to shaded ones and the rest of every room that has all its shaded cells. Dots are optional: the puzzle is done once the right cells are shaded.';

  @override
  String get tutChambers1 =>
      'The grid is cut into rooms, and a number tells how many cells of its room are shaded. Shaded cells never touch side by side. A room with 0 stays empty, and a one-cell room with 1 is shaded. Tap a cell to shade it.';

  @override
  String get tutChambers2 =>
      'A straight line of unshaded cells may not cross two room borders. The highlighted row runs through three rooms, and two of them hold no shaded cell, so the third one must break the line. Finish the board.';

  @override
  String get tutChambers3 =>
      'The unshaded cells must stay in one piece. Once its neighbour is shaded, the top-left cell\'s only way out is the cell below it, so that cell stays. Tap a cell twice to dot it (your note that it stays), then finish the board.';

  @override
  String get tutChambers4 =>
      'Now a real board. Start with 0 rooms, rooms that need every cell they have left, and long lines through several rooms.';

  @override
  String get tutChambersS1 =>
      'Count the ways a room can hold its shaded cells. The highlighted room is three cells long and holds 2, and shaded cells never touch, so only its two ends can be shaded. Shade them, then finish the board.';

  @override
  String get tutChambersS2 =>
      'Try every way to fit a room\'s shaded cells: none may touch, and every long line through the room that only it can break must be broken. A cell shaded in every way is shaded, one never shaded stays. Also, a cell whose shading would cut the unshaded cells in two stays.';

  @override
  String get tutChambersS3 =>
      'A hard board. When stuck, shade a cell and follow on: if a room gets too many shaded cells, a long line can\'t be broken, or some cells get cut off, that cell stays.';

  @override
  String exChambersFull(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all $count of its shaded cells',
      one: 'already has its 1 shaded cell',
      zero: 'holds no shaded cells',
    );
    return '$cell stays: room $room $_temp0.';
  }

  @override
  String exChambersNeed(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: '1 shaded cell',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'them',
      one: 'it',
    );
    return '$cell is shaded: room $room needs $_temp0, and no other cells are left for $_temp1.';
  }

  @override
  String exChambersSpan(Object cell, Object a, Object b) {
    return '$cell is shaded: otherwise every cell from $a to $b would stay, a straight line across two room borders.';
  }

  @override
  String exChambersWaysShade(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: '1 shaded cell',
    );
    return '$cell is shaded: every way to fit $_temp0 into room $room, with none touching and every long line broken, shades it.';
  }

  @override
  String exChambersWaysKeep(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: '1 shaded cell',
    );
    return '$cell stays: no way to fit $_temp0 into room $room, with none touching and every long line broken, shades it.';
  }

  @override
  String exChambersFailMany(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: '1 shaded cell',
    );
    return 'But then room $room has more than $_temp0.';
  }

  @override
  String exChambersFailFew(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: '1 shaded cell',
    );
    return 'But then room $room can\'t get $_temp0.';
  }

  @override
  String exChambersFailSpan(Object a, Object b) {
    return 'But then every cell from $a to $b stays, a straight line across two room borders.';
  }

  @override
  String exChambersFailWays(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shaded cells',
      one: '1 shaded cell',
    );
    return 'But then there\'s no way to fit $_temp0 into room $room.';
  }

  @override
  String get lookoutName => 'Lookout';

  @override
  String get lookoutTagline => 'Shade cells so each number sees exactly as many as it says';

  @override
  String get lookoutRules =>
      '• Each number tells how many cells it sees across and down, itself included: along its row and column, out to the first shaded cell or the edge.\n• Numbered cells are never shaded.\n• Shaded cells never touch side by side.\n• The unshaded cells form one connected area.\n\nTap a cell to cycle: shaded → dot (your \"this one stays\" note) → empty. Right-click cycles back. A long press dots the cells next to shaded ones and every cell a number sees once shaded cells close its view at its count. Dots are optional: the puzzle is done once the right cells are shaded.';

  @override
  String get tutLookout1 =>
      'Each number counts the cells it sees along its row and column, itself included, up to a shaded cell or the edge. Shaded cells never touch side by side, and numbered cells are never shaded. The bottom 2 already sees itself and the 4 above it, so its view must stop everywhere else: shade the cells beside it and the one beyond the 4.';

  @override
  String get tutLookout2 =>
      'Count how far a number could see at most. The 5 could see five cells at most: itself, the two beside it and the two above it. So it sees all of them, and they all stay. Finish the board.';

  @override
  String get tutLookout3 =>
      'The unshaded cells must stay in one piece. Once the cell under the 3 is shaded, the bottom-right corner can only reach the others through the cell to its left, so that cell stays. Tap a cell twice to dot it (your note that it stays), then finish the board.';

  @override
  String get tutLookout4 =>
      'Now a real board. Start with numbers that already see all they may in some direction, and big numbers that can barely see far enough.';

  @override
  String get tutLookoutS1 =>
      'A number\'s view ends at the edge or at a shaded cell, never at another number. The 2 sees one cell besides itself. To the left its view can\'t stop after one cell, because the next one is the 3, so it sees the cell below it instead: the cell to its left and the second cell down are shaded.';

  @override
  String get tutLookoutS2 =>
      'Try every way to split a number\'s count among its four directions, each view ending at the edge or at a cell that can be shaded. A cell every way sees stays, a cell where every way stops is shaded. Also, a cell whose shading would cut the unshaded cells in two stays.';

  @override
  String get tutLookoutS3 =>
      'A hard board. When stuck, shade a cell and follow on: if a number then sees too many or too few cells, two shaded cells touch, or some cells get cut off, that cell stays.';

  @override
  String get tagSight => 'sight, see, view, visible, look, line of sight, watch';

  @override
  String exLookoutReach(Object cell, Object clue, int count) {
    return '$cell stays: the $count at $clue can\'t see enough cells in the other directions, so it sees at least this far.';
  }

  @override
  String exLookoutClose(Object cell, Object clue, int count) {
    return '$cell is shaded: the $count at $clue already sees as many cells as it may this way, so its view stops here.';
  }

  @override
  String exLookoutWaysShade(Object cell, Object clue, int count) {
    return '$cell is shaded: every way for the $count at $clue to see exactly $count cells stops its view here.';
  }

  @override
  String exLookoutWaysKeep(Object cell, Object clue, int count) {
    return '$cell stays: every way for the $count at $clue to see exactly $count cells sees it.';
  }

  @override
  String exLookoutFailMany(Object clue, int count) {
    return 'But then the $count at $clue sees more than $count cells.';
  }

  @override
  String exLookoutFailFew(Object clue, int count) {
    return 'But then the $count at $clue can\'t see $count cells.';
  }

  @override
  String exLookoutFailWays(Object clue, int count) {
    return 'But then the $count at $clue can\'t see exactly $count cells: no view of the right length ends at the edge or at a cell that can be shaded.';
  }

  @override
  String get rampartName => 'Rampart';

  @override
  String get rampartTagline => 'Build one winding wall that fits the clues around it';

  @override
  String get rampartRules =>
      '• Shade cells so that all shaded cells form one wall, joined side by side.\n• No 2×2 block is all shaded.\n• Clue cells are never shaded. A clue lists the runs of shaded cells among its eight neighbours, diagonals included, read round the clue: \"3 1\" means a run of three cells in a row and a separate single cell, in either order. A 0 means none of them is shaded.\n\nTap a cell to cycle: shaded → dot (your \"this one stays\" note) → empty. Right-click cycles back. A long press dots the last cell of a 2×2 block with three cells shaded and the cells round every clue the shaded cells already make. Dots are optional: the puzzle is done once the right cells are shaded.';

  @override
  String get tutRampart1 =>
      'Shade cells to build one wall. Each clue tells which of its eight neighbours, diagonals included, are shaded: a 3 is a run of three in a row round it, and a 0 means none of them is. Clue cells are never shaded.';

  @override
  String get tutRampart2 =>
      'No 2×2 block may be all shaded. Shade what the clues ask for, and the top-left cell must stay, or its block fills up. Tap a cell twice to dot it (your note that it stays).';

  @override
  String get tutRampart3 =>
      'A clue of several numbers has that many separate runs: 2 2 is two runs of two, with cells that stay between them. All shaded cells join into one wall, so the two runs meet round the left side.';

  @override
  String get tutRampart4 =>
      'Now a real board. Start with clues that leave one way to place their runs, like big numbers and 0s, and keep the wall in one piece.';

  @override
  String get tutRampartS1 =>
      'Every run round a clue must still join the rest of the wall. The 1 1 needs two single shaded cells apart. A top corner shaded alone would be shut in by the clue and the cells that stay round it, so both corners stay, and the only pair left is the cells either side of the middle.';

  @override
  String get tutRampartS2 =>
      'Weigh each way of making a clue against the other rules: a way that fills a 2×2 block or shuts part of the wall in is out. Also, a cell that would cut the wall in two if it stayed is shaded, and cells the wall can\'t reach stay.';

  @override
  String get tutRampartS3 =>
      'A hard board. When stuck, shade a cell and follow on: if a clue can\'t be made, a 2×2 block fills up or the wall falls apart, that cell stays.';

  @override
  String exRampartClueShade(Object cell, Object clue) {
    return '$cell is shaded: every way to make the clue at $clue shades it.';
  }

  @override
  String exRampartClueKeep(Object cell, Object clue) {
    return '$cell stays: no way to make the clue at $clue shades it.';
  }

  @override
  String exRampartWaysShade(Object cell, Object clue) {
    return '$cell is shaded: every way to make the clue at $clue without a shaded 2×2 block or a shut-in part of the wall shades it.';
  }

  @override
  String exRampartWaysKeep(Object cell, Object clue) {
    return '$cell stays: no way to make the clue at $clue without a shaded 2×2 block or a shut-in part of the wall shades it.';
  }

  @override
  String exRampartPool(Object cell, Object area) {
    return '$cell stays: the rest of the 2×2 block $area is shaded.';
  }

  @override
  String exRampartEscape(Object cell, Object other) {
    return '$cell is shaded: it is the only way out for the part of the wall at $other.';
  }

  @override
  String exRampartCut(Object cell) {
    return '$cell is shaded: if it stayed, the wall would be cut in two.';
  }

  @override
  String exRampartAway(Object cell) {
    return '$cell stays: the wall can\'t reach it.';
  }

  @override
  String exRampartFailClue(Object clue) {
    return 'But then the clue at $clue can\'t be made.';
  }

  @override
  String exRampartFailPool(Object area) {
    return 'But then the 2×2 block $area is all shaded.';
  }

  @override
  String exRampartFailShut(Object cell) {
    return 'But then the part of the wall at $cell is shut in.';
  }

  @override
  String exRampartFailWays(Object clue) {
    return 'But then the clue at $clue can\'t be made without a shaded 2×2 block or a shut-in part of the wall.';
  }

  @override
  String exRampartFailApart(Object a, Object b) {
    return 'But then the shaded cells $a and $b can\'t join up.';
  }

  @override
  String get waymarksName => 'Waymarks';

  @override
  String get waymarksTagline => 'Each sign points the way to the next number';

  @override
  String get waymarksRules =>
      '• Every cell has an arrow, except the last one, which has a ring.\n• Number the cells 1, 2, 3, … up to the last, so that each arrow points at the cell with the next number. That cell can be any distance away along the arrow\'s line, with other cells in between.\n• Some numbers are shown, always 1 and the last.\n\nDrag from a cell to the cell it leads on to, or tap one and then the other, to link them. Linked cells count on from a shown number in their chain; a chain without one gets a letter (a, a+1, …) until it joins one. Tap a picked cell again to undo its link, or long-press (right-click) a cell to cut all its links.';

  @override
  String get tutWaymarks1 =>
      'Number the cells from 1 to the ring: each arrow points at the next number, any distance along its line. An arrow with only one free cell in its way leads there. Drag from a cell to the next one to link them, or tap one and then the other.';

  @override
  String get tutWaymarks2 =>
      'Look backwards too: every cell except 1 needs a cell before it. If only one free arrow points at a cell, that cell comes right after the arrow\'s cell.';

  @override
  String get tutWaymarks3 =>
      'Linked cells count on from a shown number, and a chain without one gets a letter: a, a+1, … Two shown numbers one apart, like 12 and 13, are always linked, and cells whose numbers aren\'t one apart never are.';

  @override
  String get tutWaymarks4 =>
      'A chain never leads back to its own first cell: that would close a loop, and the numbers only go up. So the end of a chain can\'t link to the start of the same chain.';

  @override
  String get tutWaymarks5 =>
      'Now a real board. Link the cells with only one way on or one way in, count on from the shown numbers, and keep every chain from looping back to its start.';

  @override
  String get tutWaymarksS1 =>
      'Think about which numbers a cell can still be. Its number is one more than a number of a cell that can lead to it, and one less than a number of a cell it can lead to, and no number is used twice. Narrow the cells down this way until a link is left with only one choice.';

  @override
  String get tutWaymarksS2 =>
      'Two cells can only be linked if their numbers can be one apart. When no number the second cell can be is one more than a number the first can be, cross that link off, and look for what is left.';

  @override
  String get tutWaymarksS3 =>
      'A hard board. When stuck, suppose a link and follow on: if a cell is left with no way on, no way in or no number, that link is wrong.';

  @override
  String exWaymarksOnlyOut(Object from, Object to) {
    return '$from can only lead on to $to: its arrow has no other cell left.';
  }

  @override
  String exWaymarksOnlyIn(Object from, Object to) {
    return 'Only $from can still lead to $to, so $to comes right after it.';
  }

  @override
  String exWaymarksTaken(Object from, Object to) {
    return '$from leads on to $to, so no other link leaves $from or reaches $to.';
  }

  @override
  String exWaymarksConsecutive(Object from, Object to, Object a, Object b) {
    return '$from is $a and $to is $b, so $to comes right after $from.';
  }

  @override
  String exWaymarksApart(Object from, Object to, Object a, Object b) {
    return '$from is $a and $to is $b, not the next number, so $from doesn\'t lead on to $to.';
  }

  @override
  String exWaymarksLoop(Object from, Object to) {
    return '$from can\'t lead on to $to: the chain through $from starts at $to, so that would close a loop.';
  }

  @override
  String exWaymarksNoFit(Object from, Object to) {
    return '$from can\'t lead on to $to: no number $to can be is one more than a number $from can be.';
  }

  @override
  String exWaymarksNumberOn(Object cell, Object nums) {
    return '$cell is $nums: its chain counts on from a shown number.';
  }

  @override
  String exWaymarksFailStuck(Object cell) {
    return 'But then $cell has no cell left to lead on to.';
  }

  @override
  String exWaymarksFailNoPrev(Object cell) {
    return 'But then no cell can lead to $cell.';
  }

  @override
  String exWaymarksFailNumber(Object cell) {
    return 'But then no number fits $cell.';
  }

  @override
  String exWaymarksFailLoop(Object cell) {
    return 'But then the chain through $cell closes a loop.';
  }

  @override
  String exWaymarksFailLink(Object from, Object to) {
    return 'But then the links at $from and $to clash.';
  }

  @override
  String exWaymarksSupposeOn(Object from, Object to) {
    return 'Suppose $from led on to $to.';
  }

  @override
  String exWaymarksSupposeOff(Object from, Object to) {
    return 'Suppose $from didn\'t lead on to $to.';
  }

  @override
  String exWaymarksRefutedOff(Object from, Object to) {
    return 'So $from doesn\'t lead on to $to.';
  }

  @override
  String exWaymarksRefutedOn(Object from, Object to) {
    return 'So $from leads on to $to.';
  }

  @override
  String get tagArrow => 'arrow, arrows, pointer, direction';

  @override
  String exWaymarksNumbers(Object cell, Object nums) {
    return '$cell can only be $nums.';
  }

  @override
  String get polesName => 'Poles';

  @override
  String get polesTagline => 'Give each tile a + and a − end, or none, to match the edge counts';

  @override
  String get polesRules =>
      '• The grid is cut into dominoes. Each domino is either charged, with a + at one end and a − at the other, or blank.\n• Two + cells never touch side by side, and neither do two − cells.\n• The numbers left of and above the grid tell how many + cells each row and column holds; the numbers right of and below it count the − cells. On hard boards some numbers are hidden.\n\nTap a cell to cycle: + → − → dot (blank) → empty. Right-click cycles back. Slide across cells to set them all in one go. A long press fills in the other end of every domino you started (a − across from a +, a dot across from a dot) and dots the rest of each line that has all its + and − cells. Dots are optional: the puzzle is done once every + and − is in place. A number fades once its line has that many.';

  @override
  String get tutPoles1 =>
      'The grid is cut into dominoes. Each one is either charged, with a + at one end and a − at the other, or blank. The numbers left and above count the + cells of each row and column, the numbers right and below count the − cells. Tap a cell to cycle +, −, dot (blank).';

  @override
  String get tutPoles2 =>
      'Two + cells never touch side by side, and neither do two − cells. That tells you which way round a domino goes: its + can\'t sit next to another +. Finish the board.';

  @override
  String get tutPoles3 =>
      'Add a line\'s two numbers: that many of its cells are charged. When the line already has that many, its other cells are blank; when it needs every cell that can still be charged, none of those is blank. Finish the board.';

  @override
  String get tutPoles4 =>
      'Now a real board. Start with lines whose numbers are zero, or that need every cell they have, and remember that the other end of a domino is always the opposite.';

  @override
  String get tutPolesS1 =>
      'Think through every way to fill one line: its numbers, its dominoes and the rule that like ends never touch leave only a few. A value that no way puts into a cell is ruled out there. Look at the long rows of this board.';

  @override
  String get tutPolesS2 =>
      'A hard board: some numbers are hidden. When stuck, suppose a cell holds a + and follow on: if a line can\'t get its numbers or two like ends meet, that cell holds no +.';

  @override
  String get tagCharge => 'plus, minus, positive, negative, charge, electric, polarity, attract, repel';

  @override
  String exPolesPartner(Object cell, Object value, Object other, Object opposite) {
    return '$cell is $value: the other end of its domino, $other, is $opposite.';
  }

  @override
  String exPolesPartnerOut(Object cell, Object value, Object other, Object opposite) {
    return '$cell can\'t be $value: the other end of its domino, $other, can\'t be $opposite.';
  }

  @override
  String exPolesRepel(Object cell, Object value, Object other) {
    return '$cell can\'t be $value: it touches the $value at $other.';
  }

  @override
  String exPolesRowDone(Object value, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all its $count $value cells, so no other cell is $value',
      one: 'already has its $value cell, so no other cell is $value',
      zero: 'has no $value cells',
    );
    return 'Row $row $_temp0.';
  }

  @override
  String exPolesColDone(Object value, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all its $count $value cells, so no other cell is $value',
      one: 'already has its $value cell, so no other cell is $value',
      zero: 'has no $value cells',
    );
    return 'Column $col $_temp0.';
  }

  @override
  String exPolesRowNeed(Object cell, Object value, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $value cells, and only that many cells can still be $value',
      one: 'a $value cell, and only one cell can still be $value',
    );
    return '$cell is $value: row $row needs $_temp0.';
  }

  @override
  String exPolesColNeed(Object cell, Object value, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count $value cells, and only that many cells can still be $value',
      one: 'a $value cell, and only one cell can still be $value',
    );
    return '$cell is $value: column $col needs $_temp0.';
  }

  @override
  String exPolesRowBlank(Object cell, Object row, int count, Object plus, Object minus) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all its $count cells with $plus or $minus',
      one: 'already has its one cell with $plus or $minus',
      zero: 'has no cells with $plus or $minus',
    );
    return '$cell is blank: row $row $_temp0.';
  }

  @override
  String exPolesColBlank(Object cell, Object col, int count, Object plus, Object minus) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all its $count cells with $plus or $minus',
      one: 'already has its one cell with $plus or $minus',
      zero: 'has no cells with $plus or $minus',
    );
    return '$cell is blank: column $col $_temp0.';
  }

  @override
  String exPolesRowCharged(Object row, int count, Object plus, Object minus) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells with $plus or $minus, and only that many can still hold one: none of them is blank',
      one: 'a cell with $plus or $minus, and only one cell can still hold one: it isn\'t blank',
    );
    return 'Row $row needs $_temp0.';
  }

  @override
  String exPolesColCharged(Object col, int count, Object plus, Object minus) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells with $plus or $minus, and only that many can still hold one: none of them is blank',
      one: 'a cell with $plus or $minus, and only one cell can still hold one: it isn\'t blank',
    );
    return 'Column $col needs $_temp0.';
  }

  @override
  String exPolesLast(Object cell, Object value) {
    return '$cell is $value: nothing else is left for it.';
  }

  @override
  String exPolesRowFill(Object cell, Object value, Object row) {
    return '$cell can\'t be $value: no way of filling row $row that fits its numbers puts it there.';
  }

  @override
  String exPolesColFill(Object cell, Object value, Object col) {
    return '$cell can\'t be $value: no way of filling column $col that fits its numbers puts it there.';
  }

  @override
  String exPolesFailEmpty(Object cell) {
    return 'But then nothing fits in $cell.';
  }

  @override
  String exPolesFailRowMany(Object row, Object value, int count) {
    return 'But then row $row has too many $value cells (it needs $count).';
  }

  @override
  String exPolesFailColMany(Object col, Object value, int count) {
    return 'But then column $col has too many $value cells (it needs $count).';
  }

  @override
  String exPolesFailRowFew(Object row, Object value, int count) {
    return 'But then row $row can\'t get enough $value cells (it needs $count).';
  }

  @override
  String exPolesFailColFew(Object col, Object value, int count) {
    return 'But then column $col can\'t get enough $value cells (it needs $count).';
  }

  @override
  String exPolesFailRowFill(Object row) {
    return 'But then row $row can\'t be filled to fit its numbers.';
  }

  @override
  String exPolesFailColFill(Object col) {
    return 'But then column $col can\'t be filled to fit its numbers.';
  }

  @override
  String get mercuryName => 'Mercury';

  @override
  String get mercuryTagline => 'Fill the tubes from the bulb up to match the counts';

  @override
  String get mercuryRules =>
      '• The grid is covered with tubes, straight or bent, each starting at a round bulb.\n• Fill some cells with mercury. In every tube it starts at the bulb and goes on without gaps, as far as you like: a tube may stay empty, fill part of the way or fill up to its tip.\n• The numbers outside the grid tell how many filled cells each row and column holds. On harder boards some are hidden.\n\nTap a cell to cycle: mercury → empty (your note) → unmarked. Right-click cycles back. Slide across cells to fill them all in one go. A long press fills every cell between your mercury and its bulb, and marks empty the cells past your empty marks and in rows and columns that have all their mercury. Empty marks are optional: the puzzle is done once all the mercury is in place.';

  @override
  String get famFilling => 'Filling';

  @override
  String get famFillingAbout => 'Fill each container from one end up to a level so that the counts outside come out';

  @override
  String get tagTemperature => 'temperature, heat, fever, degrees, gauge, tube, bulb, mercury, fill, level';

  @override
  String get tutMercury1 =>
      'The grid is covered with tubes, and mercury fills each one from its round bulb. The numbers outside tell how many filled cells each row and column holds. Tap a cell to fill it, tap again to mark it empty.';

  @override
  String get tutMercury2 =>
      'Mercury always starts at the bulb and leaves no gaps: when a cell is filled, so is every cell between it and the bulb, even round a bend. And a cell left empty keeps the rest of its tube empty, up to the tip. Finish the board.';

  @override
  String get tutMercury3 =>
      'Think ahead: filling a cell fills everything back to its bulb. When that would put more filled cells into a row or column than its number allows, the cell stays empty. Leaving a cell empty empties its tube up to the tip, so when that would leave a line short, the cell is filled. Finish the board.';

  @override
  String get tutMercury4 =>
      'Now a real board. Start with rows and columns that are empty or full, fill back to the bulbs, and before you fill a cell, count how much mercury it brings along.';

  @override
  String get tutMercuryS1 =>
      'Two lines that share several tubes are worth counting together: each shared tube fills them in a set order from its bulb, so not every split of mercury between them is possible. Here columns D and E share three tubes. Try the ways those tubes can make both numbers at once: a cell that comes out the same every time is settled.';

  @override
  String get tutMercuryS2 =>
      'A medium board: some counts are hidden, and some steps need two lines counted together. Look for rows and columns that share tubes, such as a tube that bends from one into the other.';

  @override
  String get tutMercuryS3 =>
      'A hard board: more counts are hidden. When stuck, suppose a cell is filled and fill back to its bulb: if a row or column overflows or can no longer reach its count, that cell stays empty.';

  @override
  String exMercurySupposeFull(Object cell) {
    return 'Suppose $cell were filled.';
  }

  @override
  String exMercurySupposeEmpty(Object cell) {
    return 'Suppose $cell stayed empty.';
  }

  @override
  String exMercuryRefutedFull(Object cell) {
    return '$cell stays empty: filling it leads to a contradiction.';
  }

  @override
  String exMercuryRefutedEmpty(Object cell) {
    return '$cell is filled: leaving it empty leads to a contradiction.';
  }

  @override
  String exMercuryToBulb(Object cell, Object other) {
    return '$cell is filled: the mercury at $other reaches it from the bulb, with no gaps.';
  }

  @override
  String exMercuryPastEmpty(Object cell, Object other) {
    return '$cell stays empty: $other, nearer the bulb of the same tube, is empty, and the mercury never jumps a gap.';
  }

  @override
  String exMercuryRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all its $count filled cells',
      one: 'already has its filled cell',
      zero: 'holds no filled cells',
    );
    return '$cell stays empty: row $row $_temp0.';
  }

  @override
  String exMercuryColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'already has all its $count filled cells',
      one: 'already has its filled cell',
      zero: 'holds no filled cells',
    );
    return '$cell stays empty: column $col $_temp0.';
  }

  @override
  String exMercuryRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filled cells',
      one: 'a filled cell',
    );
    return '$cell is filled: row $row needs $_temp0, and only that many cells are left.';
  }

  @override
  String exMercuryColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filled cells',
      one: 'a filled cell',
    );
    return '$cell is filled: column $col needs $_temp0, and only that many cells are left.';
  }

  @override
  String exMercuryTooMuchRow(Object cell, Object row, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'needs only $need more',
      one: 'needs only one more',
      zero: 'already has all its filled cells',
    );
    return '$cell stays empty: filling it back to its bulb would fill $_temp0 of row $row, which $_temp1.';
  }

  @override
  String exMercuryTooMuchCol(Object cell, Object col, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'needs only $need more',
      one: 'needs only one more',
      zero: 'already has all its filled cells',
    );
    return '$cell stays empty: filling it back to its bulb would fill $_temp0 of column $col, which $_temp1.';
  }

  @override
  String exMercuryTooLittleRow(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    return '$cell is filled: empty, it would keep $_temp0 of row $row empty up to the tip, and the row could no longer reach its count.';
  }

  @override
  String exMercuryTooLittleCol(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cells',
      one: 'a cell',
    );
    return '$cell is filled: empty, it would keep $_temp0 of column $col empty up to the tip, and the column could no longer reach its count.';
  }

  @override
  String exMercuryLinesRows(Object a, Object b) {
    return 'rows $a and $b';
  }

  @override
  String exMercuryLinesCols(Object a, Object b) {
    return 'columns $a and $b';
  }

  @override
  String exMercuryLinesRowCol(Object row, Object col) {
    return 'row $row and column $col';
  }

  @override
  String exMercuryPairFull(Object cell, Object lines) {
    return '$cell is filled: $lines share tubes, and counted together, their numbers can only both come out with this cell filled.';
  }

  @override
  String exMercuryPairEmpty(Object cell, Object lines) {
    return '$cell stays empty: $lines share tubes, and counted together, their numbers can only both come out with this cell empty.';
  }

  @override
  String exMercuryFailOrder(Object full, Object empty) {
    return 'But then $full is filled while $empty, nearer the bulb of the same tube, stays empty.';
  }

  @override
  String exMercuryFailRowMany(Object row, int count) {
    return 'But then row $row gets more than $count filled cells.';
  }

  @override
  String exMercuryFailColMany(Object col, int count) {
    return 'But then column $col gets more than $count filled cells.';
  }

  @override
  String exMercuryFailRowFew(Object row, int count) {
    return 'But then row $row can no longer get $count filled cells.';
  }

  @override
  String exMercuryFailColFew(Object col, int count) {
    return 'But then column $col can no longer get $count filled cells.';
  }

  @override
  String exMercuryFailPair(Object lines) {
    return 'But then the numbers of $lines can no longer both come out.';
  }

  @override
  String get nightfallName => 'Nightfall';

  @override
  String get nightfallTagline => 'Tap the windows until the whole house goes dark';

  @override
  String get nightfallRules =>
      '• Every cell is a window, lit or dark.\n• Tapping a window flips it and its neighbours above, below, left and right: lit windows go dark, dark ones light up.\n• Make every window dark, within the move limit if the game has one.\n\nThe order of taps never matters, and tapping a window twice changes nothing. When the edges wrap around, a window on the edge also flips the one across the board.';

  @override
  String get nightfallEdges => 'Edges';

  @override
  String get nightfallEdgesFlat => 'Flat';

  @override
  String get nightfallEdgesFlatHint => 'Windows on the edge have fewer neighbours.';

  @override
  String get nightfallEdgesWrap => 'Wrap around';

  @override
  String get nightfallEdgesWrapHint => 'The edges join up: a window on the edge also flips the one across the board.';

  @override
  String get nightfallGoalMoves => 'Move limit';

  @override
  String get nightfallGoalMovesHint => 'Make it dark within a few moves more than the fewest (none more on hard).';

  @override
  String get nightfallGoalFree => 'Free play';

  @override
  String get nightfallGoalFreeHint => 'No limit: take as many moves as you need.';

  @override
  String nightfallMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moves',
      one: '$count move',
    );
    return '$_temp0';
  }

  @override
  String get nightfallFewest => 'Dark in the fewest moves!';

  @override
  String get tutNightfall1 =>
      'A tap flips a window and its neighbours above, below, left and right: lit windows go dark, dark ones light up. Tap the middle window to make every window dark.';

  @override
  String get tutNightfall2 =>
      'A window on the edge or in a corner has fewer neighbours, so a tap there flips fewer windows. Make every window dark.';

  @override
  String get tutNightfall3 =>
      'Two taps that flip the same window leave it as it was. The order of taps never matters, and tapping a window twice changes nothing, so each window needs one tap or none.';

  @override
  String get tutNightfall4 =>
      'A real board. The counter shows your moves and the limit: a few more than the fewest that make every window dark. Undo gives a move back.';

  @override
  String get tutNightfallS1 =>
      'Chase the lights down: for each lit window in the top row, tap the window right below it, and the top row goes dark. Do the same for each row in turn, down to the bottom.';

  @override
  String get tutNightfallS2 =>
      'Here a chase leaves lit windows in the bottom row: the top row needs a tap too. Tap the marked window first, then chase the lights down again.';

  @override
  String get tutNightfallS3 =>
      'A real board with no move limit. Chase the lights down; if some stay lit in the bottom row, start over with a tap or two in the top row and chase again, until the bottom row goes dark too.';

  @override
  String get tagSwitch => 'lights, switch, toggle, on and off, dark, night, windows, flip, invert';

  @override
  String get glideName => 'Glide';

  @override
  String get glideTagline => 'Slide the tiles through the gap until they are back in order';

  @override
  String get glideRules =>
      '• The frame holds numbered tiles and one gap.\n• Tap a tile next to the gap to slide it in. Tapping a tile further along the gap\'s row or column slides it and every tile between at once. You can also swipe, or use the arrow keys.\n• Put the tiles in order: 1, 2, 3, … along each row from the top, with the gap in the bottom right corner.\n\nEvery tile that moves counts as a move. With colored tiles, rebuild the gradient instead: each tile belongs where its color fits.';

  @override
  String get glideFace => 'Tiles';

  @override
  String get glideFaceNumbers => 'Numbers';

  @override
  String get glideFaceNumbersHint => 'Numbered tiles, 1 in the top left corner.';

  @override
  String get glideFaceColors => 'Colors';

  @override
  String get glideFaceColorsHint => 'Tiles of a gradient: put each color where it fits.';

  @override
  String get glideGoalFree => 'Free play';

  @override
  String get glideGoalFreeHint => 'No limit: take as many moves as you need.';

  @override
  String get glideGoalMoves => 'Move limit';

  @override
  String get glideGoalMovesHint =>
      'Finish within a limit: twice the best way out on easy, 1.5 times on medium, 1.25 times on hard.';

  @override
  String glideMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moves',
      one: '$count move',
    );
    return '$_temp0';
  }

  @override
  String get glideFewest => 'In order in the fewest moves!';

  @override
  String get tutGlide1 =>
      'The frame has one gap. Tap the marked tile next to it to slide it into the gap. The goal: the tiles in order, 1, 2, 3, … row by row, with the gap at the end.';

  @override
  String get tutGlide2 =>
      'A tile further along the gap\'s row or column slides too: tap the marked tile, and it moves along with every tile between it and the gap.';

  @override
  String get tutGlide3 =>
      'You can also swipe a tile toward the gap, or swipe anywhere to slide the tile that can go that way. Swipe the marked tile up, then the tile below it.';

  @override
  String get tutGlide4 =>
      'Now a few tiles are out of place. Put them back in order: tiles only ever move into the gap, so think about where the gap has to go.';

  @override
  String get tutGlide5 =>
      'A real board. The counter shows your moves and the limit; every tile that moves counts. Undo gives moves back.';

  @override
  String get tutGlideS1 =>
      'Big boards go row by row: put 1, 2, 3 and 4 into the top row, then leave that row alone. What is left is a smaller board; solve it the same way.';

  @override
  String get tutGlideS2 =>
      'The end of a row is the tricky part: 1, 2 and 3 are home, but 4 can\'t get past 3 without moving it. Put 4 where 3 belongs first and 3 right below it, then slide both in together: 4 to the right, 3 up.';

  @override
  String get tutGlideS3 =>
      'A real board. Place the top row, then the left column, then the next row, so the board keeps shrinking. The last two tiles of a column go in together, like the end of a row turned on its side. A small corner is left at the end: circle its tiles round until they fall into place.';

  @override
  String get layersName => 'Layers';

  @override
  String get layersTagline => 'Strokes over strokes: the last one shows';

  @override
  String get layersRules =>
      '• Every row and every column was painted once, from end to end, in the color of the stroke at its start.\n• The strokes came one after another, in an order you don\'t know. A later stroke covers an earlier one, so each cell has the color of whichever of its row and column came last.\n• Some cells are shown from the start (with a dot). Paint the rest.\n• A stroke with a question mark hides its color: work it out.\n\nPick a color in the palette and tap cells to paint them (tap again to clear), or tap a cell to cycle through the colors. Slide across cells to paint them all.';

  @override
  String get tutLayers1 =>
      'Every row and every column was painted once, end to end, in the color of the stroke at its start. The strokes came one after another, and the last one over a cell is the one you see. When a cell\'s row and column have the same color, the cell can only be that color. Pick a color in the palette and paint the empty cells.';

  @override
  String get tutLayers2 =>
      'A shown cell tells you which of its two strokes came later. A1 has row 1\'s color, so row 1 was painted after column A. A3 has column A\'s color: column A came after row 3. C3 has row 3\'s: row 3 came after column C. So row 1 came after column C too, and C1 gets row 1\'s color. Finish the board.';

  @override
  String get tutLayers3 =>
      'A stroke with a question mark hides its color. A1 doesn\'t have column A\'s color, so row 1 was painted after column A, and A1 shows row 1\'s color. Now B1\'s row and column have the same color. Finish the board.';

  @override
  String get tutLayers4 =>
      'Now a real board. Paint the cells whose row and column share a color, then follow the order around rectangles of shown cells.';

  @override
  String get tutLayersS1 =>
      'The order also runs through cells that don\'t show it. If row 2 came after column B and column B after row 5, then row 2 came after row 5, even if no cell says so. Chains like that settle cells no single rectangle reaches. Some strokes hide their color here: read it from a cell where that line came last.';

  @override
  String get tutLayersS2 =>
      'When nothing else helps, try a color: suppose a hidden stroke had one color, or a cell one of its two, and follow the order until it runs in a circle (a stroke would come after itself) or a cell has no color left. Then it\'s the other way.';

  @override
  String exLayersSame(Object cell, Object value, Object row, Object col) {
    return '$cell is $value: row $row and column $col both have $value, so it doesn\'t matter which came last.';
  }

  @override
  String exLayersOptions(Object cell, Object value, Object row, Object col) {
    return '$cell is $value: of the colors row $row and column $col can have, only $value is left for it.';
  }

  @override
  String exLayersSeen(Object cell, Object a, String aKind, Object b, String bKind) {
    String _temp0 = intl.Intl.selectLogic(
      bKind,
      {
        'row': 'row $b',
        'other': 'column $b',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      aKind,
      {
        'row': 'row $a',
        'other': 'column $a',
      },
    );
    return '$cell doesn\'t have the color of $_temp0, so $_temp1 was painted after it.';
  }

  @override
  String exLayersLater(Object cell, Object value, Object a, String aKind, Object b, String bKind) {
    String _temp0 = intl.Intl.selectLogic(
      aKind,
      {
        'row': 'row $a',
        'other': 'column $a',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      bKind,
      {
        'row': 'row $b',
        'other': 'column $b',
      },
    );
    return '$cell is $value: $_temp0 was painted after $_temp1, so its $value covers the cell.';
  }

  @override
  String exLayersLineColor(Object line, String kind, Object value, Object cell, Object other, String otherKind) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'Row $line',
        'other': 'Column $line',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      otherKind,
      {
        'row': 'row $other',
        'other': 'column $other',
      },
    );
    return '$_temp0 has $value: it came after $_temp1, so it shows at $cell, which is $value.';
  }

  @override
  String exLayersRectangle(Object cell, Object value, Object a, String aKind, Object b, Object c, Object d) {
    String _temp0 = intl.Intl.selectLogic(
      aKind,
      {
        'row':
            'row $a was painted after column $b, column $b after row $c, and row $c after column $d, so row $a came after column $d',
        'other':
            'column $a was painted after row $b, row $b after column $c, and column $c after row $d, so column $a came after row $d',
      },
    );
    return '$cell is $value: $_temp0.';
  }

  @override
  String exLayersChain(Object a, String aKind, Object b, String bKind, Object c, String cKind) {
    String _temp0 = intl.Intl.selectLogic(
      aKind,
      {
        'row': 'Row $a',
        'other': 'Column $a',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      bKind,
      {
        'row': 'row $b',
        'other': 'column $b',
      },
    );
    String _temp2 = intl.Intl.selectLogic(
      bKind,
      {
        'row': 'row $b',
        'other': 'column $b',
      },
    );
    String _temp3 = intl.Intl.selectLogic(
      cKind,
      {
        'row': 'row $c',
        'other': 'column $c',
      },
    );
    String _temp4 = intl.Intl.selectLogic(
      aKind,
      {
        'row': 'row $a',
        'other': 'column $a',
      },
    );
    String _temp5 = intl.Intl.selectLogic(
      cKind,
      {
        'row': 'row $c',
        'other': 'column $c',
      },
    );
    return '$_temp0 was painted after $_temp1, and $_temp2 after $_temp3, so $_temp4 came after $_temp5 too.';
  }

  @override
  String exLayersOnly(Object cell, Object value) {
    return '$cell is $value: every other color leads to a contradiction.';
  }

  @override
  String exLayersOnlyLine(Object line, String kind, Object value) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'Row $line',
        'other': 'Column $line',
      },
    );
    return '$_temp0 has $value: every other color leads to a contradiction.';
  }

  @override
  String exLayersSupposeLine(Object line, String kind, Object value) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'row $line',
        'other': 'column $line',
      },
    );
    return 'Suppose $_temp0 had $value.';
  }

  @override
  String exLayersRefutedLine(Object line, String kind, Object value) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'Row $line',
        'other': 'Column $line',
      },
    );
    return '$_temp0 can\'t have $value: it leads to a contradiction.';
  }

  @override
  String exLayersFailEmpty(Object cell) {
    return 'But then no color fits $cell.';
  }

  @override
  String exLayersFailLine(Object line, String kind) {
    String _temp0 = intl.Intl.selectLogic(
      kind,
      {
        'row': 'row $line',
        'other': 'column $line',
      },
    );
    return 'But then no color fits $_temp0.';
  }

  @override
  String exLayersFailCycle(Object a, String aKind, Object b, String bKind) {
    String _temp0 = intl.Intl.selectLogic(
      aKind,
      {
        'row': 'row $a',
        'other': 'column $a',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      bKind,
      {
        'row': 'row $b',
        'other': 'column $b',
      },
    );
    return 'But then $_temp0 and $_temp1 would each have been painted after the other.';
  }
}
