import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('pl'),
    Locale('uk'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily challenges'**
  String get dailyTitle;

  /// No description provided for @dailyCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get dailyCalendar;

  /// No description provided for @dailyProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} solved'**
  String dailyProgress(int done, int total);

  /// No description provided for @dailyDayComplete.
  ///
  /// In en, this message translates to:
  /// **'Day complete!'**
  String get dailyDayComplete;

  /// No description provided for @dailyNext.
  ///
  /// In en, this message translates to:
  /// **'Next puzzle'**
  String get dailyNext;

  /// No description provided for @dailyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dailyToday;

  /// No description provided for @playCode.
  ///
  /// In en, this message translates to:
  /// **'Play a puzzle code'**
  String get playCode;

  /// No description provided for @playCodeMenu.
  ///
  /// In en, this message translates to:
  /// **'Play a puzzle code…'**
  String get playCodeMenu;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get difficultyExpert;

  /// No description provided for @notSolvedYet.
  ///
  /// In en, this message translates to:
  /// **'Not solved yet on {difficulty}'**
  String notSolvedYet(Object difficulty);

  /// No description provided for @statsScore.
  ///
  /// In en, this message translates to:
  /// **'Finished {count}× · best score {score} · best time {time}'**
  String statsScore(Object count, Object score, Object time);

  /// No description provided for @statsTime.
  ///
  /// In en, this message translates to:
  /// **'Solved {count}× · best {best} · avg {average}'**
  String statsTime(Object average, Object best, Object count);

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// No description provided for @newPuzzle.
  ///
  /// In en, this message translates to:
  /// **'New puzzle'**
  String get newPuzzle;

  /// No description provided for @highlightErrors.
  ///
  /// In en, this message translates to:
  /// **'Highlight errors while playing'**
  String get highlightErrors;

  /// No description provided for @highlightErrorsHint.
  ///
  /// In en, this message translates to:
  /// **'Off: mistakes are only shown when you press Submit'**
  String get highlightErrorsHint;

  /// No description provided for @autoClearMarks.
  ///
  /// In en, this message translates to:
  /// **'Auto-remove pencil marks'**
  String get autoClearMarks;

  /// No description provided for @autoClearMarksHint.
  ///
  /// In en, this message translates to:
  /// **'Placing a number clears that note from its row, column and box'**
  String get autoClearMarksHint;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get haptics;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @aboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'About & licenses'**
  String get aboutLicenses;

  /// No description provided for @linksTitle.
  ///
  /// In en, this message translates to:
  /// **'Open puzzle links in the app'**
  String get linksTitle;

  /// No description provided for @linksOn.
  ///
  /// In en, this message translates to:
  /// **'Shared puzzle links open in APuzzle'**
  String get linksOn;

  /// No description provided for @linksOff.
  ///
  /// In en, this message translates to:
  /// **'Off: tap, then add {host} under \"Open supported links\"'**
  String linksOff(Object host);

  /// No description provided for @linksUnknown.
  ///
  /// In en, this message translates to:
  /// **'Choose APuzzle for {host} links'**
  String linksUnknown(Object host);

  /// No description provided for @couldNotOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Could not open the system settings'**
  String get couldNotOpenSettings;

  /// No description provided for @submitConflicts.
  ///
  /// In en, this message translates to:
  /// **'Some cells break the rules'**
  String get submitConflicts;

  /// No description provided for @submitIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Not finished yet'**
  String get submitIncomplete;

  /// No description provided for @submitWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite right'**
  String get submitWrong;

  /// No description provided for @restartTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart puzzle?'**
  String get restartTitle;

  /// No description provided for @restartBody.
  ///
  /// In en, this message translates to:
  /// **'All your entries will be cleared. You can still undo.'**
  String get restartBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @copyShareLink.
  ///
  /// In en, this message translates to:
  /// **'Copy share link'**
  String get copyShareLink;

  /// No description provided for @shareLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Share link copied'**
  String get shareLinkCopied;

  /// No description provided for @couldNotGenerate.
  ///
  /// In en, this message translates to:
  /// **'Could not generate a puzzle'**
  String get couldNotGenerate;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating puzzle…'**
  String get generating;

  /// No description provided for @tapToCycle.
  ///
  /// In en, this message translates to:
  /// **'Tap to cycle'**
  String get tapToCycle;

  /// No description provided for @palette.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get palette;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @erase.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get erase;

  /// No description provided for @pencilMarks.
  ///
  /// In en, this message translates to:
  /// **'Pencil marks'**
  String get pencilMarks;

  /// No description provided for @solved.
  ///
  /// In en, this message translates to:
  /// **'Solved!'**
  String get solved;

  /// No description provided for @scoreValue.
  ///
  /// In en, this message translates to:
  /// **'Score {score}'**
  String scoreValue(Object score);

  /// No description provided for @newBest.
  ///
  /// In en, this message translates to:
  /// **'new best!'**
  String get newBest;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'best {value}'**
  String bestValue(Object value);

  /// No description provided for @hintsUsed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} hint} other{{count} hints}}'**
  String hintsUsed(int count);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @copyResult.
  ///
  /// In en, this message translates to:
  /// **'Copy result to share'**
  String get copyResult;

  /// No description provided for @resultCopied.
  ///
  /// In en, this message translates to:
  /// **'Result copied, paste it to a friend'**
  String get resultCopied;

  /// No description provided for @shareSolved.
  ///
  /// In en, this message translates to:
  /// **'{hints, plural, =0{I solved this {name} in {time}.} one{I solved this {name} in {time} with 1 hint.} other{I solved this {name} in {time} with {hints} hints.}}'**
  String shareSolved(int hints, Object name, Object time);

  /// No description provided for @shareScored.
  ///
  /// In en, this message translates to:
  /// **'{hints, plural, =0{I scored {score} in this {name} in {time}.} one{I scored {score} in this {name} in {time} with 1 hint.} other{I scored {score} in this {name} in {time} with {hints} hints.}}'**
  String shareScored(int hints, Object score, Object name, Object time);

  /// No description provided for @shareChallenge.
  ///
  /// In en, this message translates to:
  /// **'Can you beat it?'**
  String get shareChallenge;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link: {error}'**
  String couldNotOpenLink(Object error);

  /// No description provided for @codeExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected a code like {example}'**
  String codeExpected(Object example);

  /// No description provided for @codeUnknownPuzzle.
  ///
  /// In en, this message translates to:
  /// **'Unknown puzzle \"{id}\"'**
  String codeUnknownPuzzle(Object id);

  /// No description provided for @codeNoSize.
  ///
  /// In en, this message translates to:
  /// **'{name} has no {size} size'**
  String codeNoSize(Object name, Object size);

  /// No description provided for @codeNoDifficulty.
  ///
  /// In en, this message translates to:
  /// **'{name} has no \"{level}\" difficulty'**
  String codeNoDifficulty(Object level, Object name);

  /// No description provided for @codeBadSeed.
  ///
  /// In en, this message translates to:
  /// **'Bad seed \"{seed}\"'**
  String codeBadSeed(Object seed);

  /// No description provided for @codeBadVersion.
  ///
  /// In en, this message translates to:
  /// **'Bad version \"{version}\"'**
  String codeBadVersion(Object version);

  /// No description provided for @codeOtherVersion.
  ///
  /// In en, this message translates to:
  /// **'This code comes from a different app version, so the puzzle would not match'**
  String get codeOtherVersion;

  /// No description provided for @codeNoOption.
  ///
  /// In en, this message translates to:
  /// **'{name} has no option \"{choice}\"'**
  String codeNoOption(Object choice, Object name);

  /// No description provided for @codeNoChoice.
  ///
  /// In en, this message translates to:
  /// **'{name}: {option} has no choice \"{choice}\"'**
  String codeNoChoice(Object choice, Object name, Object option);

  /// No description provided for @valueSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get valueSun;

  /// No description provided for @valueMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get valueMoon;

  /// No description provided for @valueDot.
  ///
  /// In en, this message translates to:
  /// **'Dot'**
  String get valueDot;

  /// No description provided for @valueCrown.
  ///
  /// In en, this message translates to:
  /// **'Crown'**
  String get valueCrown;

  /// No description provided for @valueShade.
  ///
  /// In en, this message translates to:
  /// **'Shade'**
  String get valueShade;

  /// No description provided for @valueGrass.
  ///
  /// In en, this message translates to:
  /// **'Grass'**
  String get valueGrass;

  /// No description provided for @valueTent.
  ///
  /// In en, this message translates to:
  /// **'Tent'**
  String get valueTent;

  /// No description provided for @valueSea.
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get valueSea;

  /// No description provided for @valueLamp.
  ///
  /// In en, this message translates to:
  /// **'Lamp'**
  String get valueLamp;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @outOfMoves.
  ///
  /// In en, this message translates to:
  /// **'Out of moves: undo or restart'**
  String get outOfMoves;

  /// No description provided for @movesOfLimit.
  ///
  /// In en, this message translates to:
  /// **'{moves} / {limit, plural, one{{limit} move} other{{limit} moves}}'**
  String movesOfLimit(Object moves, int limit);

  /// No description provided for @bondsCantCross.
  ///
  /// In en, this message translates to:
  /// **'Bonds can\'t cross'**
  String get bondsCantCross;

  /// No description provided for @mamboName.
  ///
  /// In en, this message translates to:
  /// **'Sun & Moon'**
  String get mamboName;

  /// No description provided for @mamboTagline.
  ///
  /// In en, this message translates to:
  /// **'Balance suns and moons'**
  String get mamboTagline;

  /// No description provided for @mamboRules.
  ///
  /// In en, this message translates to:
  /// **'• Fill every cell with a sun or a moon.\n• No more than 2 identical symbols next to each other in a row or column.\n• Each row and column has the same number of suns and moons.\n• \"=\" between two cells: they hold the same symbol.\n• \"×\" between two cells: they hold different symbols.\n• Locked cells are given.\n\nTap a cell to cycle empty → sun → moon. Long-press / right-click cycles back.'**
  String get mamboRules;

  /// No description provided for @sudokuName.
  ///
  /// In en, this message translates to:
  /// **'Sudoku'**
  String get sudokuName;

  /// No description provided for @sudokuTagline.
  ///
  /// In en, this message translates to:
  /// **'Every number once per row, column and box'**
  String get sudokuTagline;

  /// No description provided for @sudokuRules.
  ///
  /// In en, this message translates to:
  /// **'• Fill every cell with a number from 1 to N (N = grid size).\n• Each number appears exactly once in every row, every column and every box.\n• Given numbers are fixed.\n\nPick a number in the palette and tap cells to place it, or tap a cell first and then a number. The pencil button toggles small notes. Long-press / right-click clears a cell.'**
  String get sudokuRules;

  /// No description provided for @kingsName.
  ///
  /// In en, this message translates to:
  /// **'Crowns'**
  String get kingsName;

  /// No description provided for @kingsTagline.
  ///
  /// In en, this message translates to:
  /// **'One crown per row, column and region'**
  String get kingsTagline;

  /// No description provided for @kingsRules.
  ///
  /// In en, this message translates to:
  /// **'• Place exactly one crown in every row, every column and every colored region.\n• Crowns may not touch each other, not even diagonally.\n\nTap a cell to cycle empty → dot (your \"no crown here\" note) → crown. Long-press / right-click cycles back.'**
  String get kingsRules;

  /// No description provided for @huesName.
  ///
  /// In en, this message translates to:
  /// **'Hues'**
  String get huesName;

  /// No description provided for @huesTagline.
  ///
  /// In en, this message translates to:
  /// **'Count the matching colors around each number'**
  String get huesTagline;

  /// No description provided for @huesRules.
  ///
  /// In en, this message translates to:
  /// **'• Color every blank cell using the palette colors.\n• Each numbered cell shows how many of the blank cells around it (all 8 neighbours, including diagonals) end up in the same color as the numbered cell.\n• The number counts down as you paint matching neighbours, so it shows how many are still missing.\n• Numbered cells themselves never count.\n\nPick a color in the palette and tap cells to paint them (tap again to clear), or tap a cell to cycle through the colors.'**
  String get huesRules;

  /// No description provided for @mosaicName.
  ///
  /// In en, this message translates to:
  /// **'Mosaic'**
  String get mosaicName;

  /// No description provided for @mosaicTagline.
  ///
  /// In en, this message translates to:
  /// **'Flood the board with one color'**
  String get mosaicTagline;

  /// No description provided for @mosaicRules.
  ///
  /// In en, this message translates to:
  /// **'• The colored area in the top-left corner is yours.\n• Pick a color: your area takes that color and absorbs every touching cell of the same color.\n• Paint the whole board in one color within the move limit.\n\nTap a palette color, or tap any cell to use its color.'**
  String get mosaicRules;

  /// No description provided for @blendName.
  ///
  /// In en, this message translates to:
  /// **'Blend'**
  String get blendName;

  /// No description provided for @blendTagline.
  ///
  /// In en, this message translates to:
  /// **'Repaint any patch until one color remains'**
  String get blendTagline;

  /// No description provided for @blendRules.
  ///
  /// In en, this message translates to:
  /// **'• The board is made of colored patches (touching cells of the same color).\n• Pick a color, then tap any patch to repaint it. It merges with every touching patch of that color.\n• Make the whole board one color within the move limit.\n\nThe palette color stays selected, so you can paint several patches in a row.'**
  String get blendRules;

  /// No description provided for @popName.
  ///
  /// In en, this message translates to:
  /// **'Pop'**
  String get popName;

  /// No description provided for @popTagline.
  ///
  /// In en, this message translates to:
  /// **'Pop big bubble groups for big points'**
  String get popTagline;

  /// No description provided for @popRules.
  ///
  /// In en, this message translates to:
  /// **'• Tap a group of 2 or more touching bubbles of one color to select it; tap it again to pop it.\n• A group of n bubbles scores n × (n − 1), so saving up for big groups pays off.\n• Bubbles above fall down, and empty columns close up to the right.\n\nModes\n• Standard: just that.\n• Shifter: every row also slides right to close its gaps.\n• Continuous: new columns roll in from the left as space frees up.\n• Mega: Shifter and Continuous together.\n\nGoals\n• Clear the board: pop every bubble (Standard only; there is always a way).\n• Target score: reach the score before no moves are left.\n• Free play: no target, just beat your best score.\n\nThe game ends when no group of 2 is left.'**
  String get popRules;

  /// No description provided for @popMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get popMode;

  /// No description provided for @popModeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get popModeStandard;

  /// No description provided for @popModeStandardHint.
  ///
  /// In en, this message translates to:
  /// **'Bubbles fall down; empty columns close up to the right.'**
  String get popModeStandardHint;

  /// No description provided for @popModeShifter.
  ///
  /// In en, this message translates to:
  /// **'Shifter'**
  String get popModeShifter;

  /// No description provided for @popModeShifterHint.
  ///
  /// In en, this message translates to:
  /// **'Rows also slide right to close every gap.'**
  String get popModeShifterHint;

  /// No description provided for @popModeContinuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get popModeContinuous;

  /// No description provided for @popModeContinuousHint.
  ///
  /// In en, this message translates to:
  /// **'New columns roll in from the left as space frees up.'**
  String get popModeContinuousHint;

  /// No description provided for @popModeMega.
  ///
  /// In en, this message translates to:
  /// **'Mega'**
  String get popModeMega;

  /// No description provided for @popModeMegaHint.
  ///
  /// In en, this message translates to:
  /// **'Shifter and Continuous together.'**
  String get popModeMegaHint;

  /// No description provided for @popGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get popGoal;

  /// No description provided for @popGoalClear.
  ///
  /// In en, this message translates to:
  /// **'Clear board'**
  String get popGoalClear;

  /// No description provided for @popGoalClearHint.
  ///
  /// In en, this message translates to:
  /// **'Pop every bubble. There is always a way.'**
  String get popGoalClearHint;

  /// No description provided for @popGoalTarget.
  ///
  /// In en, this message translates to:
  /// **'Target score'**
  String get popGoalTarget;

  /// No description provided for @popGoalTargetHint.
  ///
  /// In en, this message translates to:
  /// **'Reach the target before no moves are left.'**
  String get popGoalTargetHint;

  /// No description provided for @popGoalFree.
  ///
  /// In en, this message translates to:
  /// **'Free play'**
  String get popGoalFree;

  /// No description provided for @popGoalFreeHint.
  ///
  /// In en, this message translates to:
  /// **'No target: play it out and beat your best score.'**
  String get popGoalFreeHint;

  /// No description provided for @popCleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared!'**
  String get popCleared;

  /// No description provided for @popTargetReached.
  ///
  /// In en, this message translates to:
  /// **'Target reached!'**
  String get popTargetReached;

  /// No description provided for @popGameOver.
  ///
  /// In en, this message translates to:
  /// **'Game over'**
  String get popGameOver;

  /// No description provided for @popStuckBubbles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{No moves left with {count} bubble on the board: undo or restart} other{No moves left with {count} bubbles on the board: undo or restart}}'**
  String popStuckBubbles(int count);

  /// No description provided for @popStuckPoints.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{No moves left, {count} point short: undo or restart} other{No moves left, {count} points short: undo or restart}}'**
  String popStuckPoints(int count);

  /// No description provided for @popPoints.
  ///
  /// In en, this message translates to:
  /// **'{score} pts'**
  String popPoints(Object score);

  /// No description provided for @popLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String popLeft(Object count);

  /// No description provided for @popColumns.
  ///
  /// In en, this message translates to:
  /// **'+{count} cols'**
  String popColumns(Object count);

  /// No description provided for @mergeName.
  ///
  /// In en, this message translates to:
  /// **'2048'**
  String get mergeName;

  /// No description provided for @mergeTagline.
  ///
  /// In en, this message translates to:
  /// **'Slide the tiles, merge the twins, build the big one'**
  String get mergeTagline;

  /// No description provided for @mergeRules.
  ///
  /// In en, this message translates to:
  /// **'• Swipe (or press an arrow key) to slide every tile as far as it goes that way.\n• Two tiles with the same number that run into each other merge into one with their sum. A tile merges only once per move.\n• After every move a new 2 (sometimes a 4) appears on an empty cell.\n• Each merge scores the new tile\'s value.\n\nGoals\n• Build the tile: reach the target tile (it depends on the board size and difficulty).\n• Free play: keep going until the board locks up, and beat your best score.\n\nThe game ends when the board is full and no two neighbours match.'**
  String get mergeRules;

  /// No description provided for @mergeGoalTarget.
  ///
  /// In en, this message translates to:
  /// **'Build the tile'**
  String get mergeGoalTarget;

  /// No description provided for @mergeGoalTargetHint.
  ///
  /// In en, this message translates to:
  /// **'Reach the target tile before the board locks up.'**
  String get mergeGoalTargetHint;

  /// No description provided for @mergeGoalFreeHint.
  ///
  /// In en, this message translates to:
  /// **'No target: play until the board locks up and beat your best score.'**
  String get mergeGoalFreeHint;

  /// No description provided for @mergeReached.
  ///
  /// In en, this message translates to:
  /// **'{tile}!'**
  String mergeReached(int tile);

  /// No description provided for @mergeStuck.
  ///
  /// In en, this message translates to:
  /// **'No moves left: undo or restart'**
  String get mergeStuck;

  /// No description provided for @mergeBest.
  ///
  /// In en, this message translates to:
  /// **'Best {tile}'**
  String mergeBest(int tile);

  /// No description provided for @pipesName.
  ///
  /// In en, this message translates to:
  /// **'Pipes'**
  String get pipesName;

  /// No description provided for @pipesTagline.
  ///
  /// In en, this message translates to:
  /// **'Connect every pipe to the source'**
  String get pipesTagline;

  /// No description provided for @pipesRules.
  ///
  /// In en, this message translates to:
  /// **'• Rotate the tiles so that every pipe connects back to the source (the ringed tile).\n• No pipe end may be left open, and the network may not contain loops.\n• Water flows through everything already connected to the source.\n• Tiles with a dot in the corner are fixed and already in place.\n\nTap a tile to rotate it clockwise; long-press / right-click rotates it back.'**
  String get pipesRules;

  /// No description provided for @shikakuName.
  ///
  /// In en, this message translates to:
  /// **'Shikaku'**
  String get shikakuName;

  /// No description provided for @shikakuTagline.
  ///
  /// In en, this message translates to:
  /// **'Split the grid into numbered rectangles'**
  String get shikakuTagline;

  /// No description provided for @shikakuRules.
  ///
  /// In en, this message translates to:
  /// **'• Divide the whole grid into rectangles (squares count too).\n• Every rectangle contains exactly one number.\n• That number equals the rectangle\'s area in cells.\n\nDrag from one corner to the opposite corner to draw a rectangle. Tap a rectangle to remove it.'**
  String get shikakuRules;

  /// No description provided for @trailName.
  ///
  /// In en, this message translates to:
  /// **'Trail'**
  String get trailName;

  /// No description provided for @trailTagline.
  ///
  /// In en, this message translates to:
  /// **'One path through every cell, numbers in order'**
  String get trailTagline;

  /// No description provided for @trailRules.
  ///
  /// In en, this message translates to:
  /// **'• Draw a single path that starts at 1 and visits every cell exactly once.\n• The path moves up, down, left or right (no diagonals).\n• It must pass the numbers in order (1 → 2 → 3 → …) and finish on the last number.\n\nDrag to draw. Drag back over the path to undo steps, or tap a cell of the path to cut it there.'**
  String get trailRules;

  /// No description provided for @atomsName.
  ///
  /// In en, this message translates to:
  /// **'Atoms'**
  String get atomsName;

  /// No description provided for @atomsTagline.
  ///
  /// In en, this message translates to:
  /// **'Bond every atom to match its number'**
  String get atomsTagline;

  /// No description provided for @atomsRules.
  ///
  /// In en, this message translates to:
  /// **'• Connect the atoms with horizontal or vertical bonds.\n• Each atom needs exactly as many bonds as its number.\n• Two atoms can share one or two bonds.\n• Bonds can\'t cross each other or pass through atoms.\n• All atoms must end up connected into one molecule.\n\nDrag from an atom towards a neighbour to add a bond (1 → 2 → none). You can also tap the space between two atoms.'**
  String get atomsRules;

  /// No description provided for @litsName.
  ///
  /// In en, this message translates to:
  /// **'Tetra'**
  String get litsName;

  /// No description provided for @litsTagline.
  ///
  /// In en, this message translates to:
  /// **'One tetromino in every region'**
  String get litsTagline;

  /// No description provided for @litsRules.
  ///
  /// In en, this message translates to:
  /// **'• Shade exactly 4 connected cells in every outlined region, forming an L, I, T or S shape (rotations and mirror images allowed).\n• All shaded cells together form one connected area.\n• No 2×2 block may be fully shaded.\n• Two identical shapes may not touch each other across a region border.\n\nTap a cell to cycle empty → shaded → dot (your \"not shaded\" note).'**
  String get litsRules;

  /// No description provided for @labyrinthName.
  ///
  /// In en, this message translates to:
  /// **'Labyrinth'**
  String get labyrinthName;

  /// No description provided for @labyrinthTagline.
  ///
  /// In en, this message translates to:
  /// **'Find the way from corner to corner'**
  String get labyrinthTagline;

  /// No description provided for @labyrinthRules.
  ///
  /// In en, this message translates to:
  /// **'• Find the way through the maze from the entrance in the top-left corner to the exit in the bottom-right corner.\n• You can\'t pass through walls.\n\nDrag from the end of your path to walk on. Drag back to retrace your steps, or tap a cell of the path to go back there.'**
  String get labyrinthRules;

  /// No description provided for @campName.
  ///
  /// In en, this message translates to:
  /// **'Campsite'**
  String get campName;

  /// No description provided for @campTagline.
  ///
  /// In en, this message translates to:
  /// **'Pitch a tent next to every tree'**
  String get campTagline;

  /// No description provided for @campRules.
  ///
  /// In en, this message translates to:
  /// **'• Pitch one tent for every tree, right next to it (up, down, left or right).\n• Every tree gets its own tent, and every tent belongs to one tree next to it.\n• Tents never touch each other, not even diagonally.\n• The numbers outside the grid tell how many tents are in each row and column.\n\nTap a cell to cycle empty → grass (your \"no tent here\" note) → tent. Long-press / right-click cycles back.'**
  String get campRules;

  /// No description provided for @islandsName.
  ///
  /// In en, this message translates to:
  /// **'Islands'**
  String get islandsName;

  /// No description provided for @islandsTagline.
  ///
  /// In en, this message translates to:
  /// **'Flood the sea around the numbered islands'**
  String get islandsTagline;

  /// No description provided for @islandsRules.
  ///
  /// In en, this message translates to:
  /// **'• Shade the sea so that the unshaded cells form islands.\n• Every island contains exactly one number, which equals its size in cells.\n• Islands only touch the sea, never each other (diagonal corners are fine).\n• The whole sea is connected, and it has no 2×2 pools.\n\nTap a cell to cycle empty → sea → dot (your \"land\" note). Long-press / right-click cycles back.'**
  String get islandsRules;

  /// No description provided for @minesName.
  ///
  /// In en, this message translates to:
  /// **'Mines'**
  String get minesName;

  /// No description provided for @minesTagline.
  ///
  /// In en, this message translates to:
  /// **'Find every mine, logic only'**
  String get minesTagline;

  /// No description provided for @minesRules.
  ///
  /// In en, this message translates to:
  /// **'• Open every cell that has no mine.\n• A number tells how many mines are in the 8 cells around it.\n• You never need to guess: every board can be cleared by logic.\n• Opening a cell with no mines around it opens its neighbours too.\n\nTap a cell to dig, long-press / right-click to flag it (or switch to Flag below). Tap a number whose flags are all placed to dig the rest around it. Digging a mine flags it with a bang, and the game goes on.'**
  String get minesRules;

  /// No description provided for @minesDig.
  ///
  /// In en, this message translates to:
  /// **'Dig'**
  String get minesDig;

  /// No description provided for @minesFlag.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get minesFlag;

  /// No description provided for @minesBoom.
  ///
  /// In en, this message translates to:
  /// **'Boom! That was a mine, so it\'s flagged now'**
  String get minesBoom;

  /// No description provided for @lampsName.
  ///
  /// In en, this message translates to:
  /// **'Lamps'**
  String get lampsName;

  /// No description provided for @lampsTagline.
  ///
  /// In en, this message translates to:
  /// **'Light up every cell, lamps never face each other'**
  String get lampsTagline;

  /// No description provided for @lampsRules.
  ///
  /// In en, this message translates to:
  /// **'• Place lamps in the empty cells (not on walls). A lamp lights its own cell and its row and column until a wall.\n• Every empty cell must be lit.\n• No lamp may shine on another lamp.\n• A number on a wall tells how many lamps are right next to it (up, down, left or right).\n\nTap a cell to cycle empty → dot (your \"no lamp\" note) → lamp. Long-press / right-click cycles back.'**
  String get lampsRules;

  /// No description provided for @fenceName.
  ///
  /// In en, this message translates to:
  /// **'Fence'**
  String get fenceName;

  /// No description provided for @fenceTagline.
  ///
  /// In en, this message translates to:
  /// **'One loop that fits around the numbers'**
  String get fenceTagline;

  /// No description provided for @fenceRules.
  ///
  /// In en, this message translates to:
  /// **'• Draw one closed loop along the dotted lines.\n• The loop never crosses or touches itself.\n• A number tells how many of its cell\'s four sides the loop uses. Cells without a number can have any count.\n\nTap between two dots to draw a line, tap again to mark it with a cross, and once more to clear it. Drag from dot to dot to draw several lines, or to erase them if you start on a line.'**
  String get fenceRules;

  /// No description provided for @pearlsName.
  ///
  /// In en, this message translates to:
  /// **'Pearls'**
  String get pearlsName;

  /// No description provided for @pearlsTagline.
  ///
  /// In en, this message translates to:
  /// **'Thread one loop through all the pearls'**
  String get pearlsTagline;

  /// No description provided for @pearlsRules.
  ///
  /// In en, this message translates to:
  /// **'• Draw one closed loop through the centers of the cells. It never crosses or touches itself, and it doesn\'t have to visit every cell.\n• The loop passes through every pearl.\n• At a black pearl it turns, and it goes straight on through the cells before and after.\n• At a white pearl it goes straight, and it turns in the cell before or after (or both).\n\nDrag through cells to draw the loop, or drag along it to erase. Tap between two cells to cycle line → cross → empty.'**
  String get pearlsRules;

  /// No description provided for @railsName.
  ///
  /// In en, this message translates to:
  /// **'Rails'**
  String get railsName;

  /// No description provided for @railsTagline.
  ///
  /// In en, this message translates to:
  /// **'Lay one track from the entry to the exit'**
  String get railsTagline;

  /// No description provided for @railsRules.
  ///
  /// In en, this message translates to:
  /// **'• Lay one track through the centers of the cells, from the entry on the left edge to the exit on the bottom edge.\n• The track never branches, crosses itself or closes into a loop, and it doesn\'t have to visit every cell.\n• The numbers above and to the right of the grid tell how many cells of each column and row the track passes through.\n• Pieces already on the board are fixed: the track runs through them exactly as shown.\n\nDrag through cells to lay track, or drag along it to erase. Tap between two cells to cycle track → cross → empty.'**
  String get railsRules;

  /// No description provided for @blocksName.
  ///
  /// In en, this message translates to:
  /// **'Blocks'**
  String get blocksName;

  /// No description provided for @blocksTagline.
  ///
  /// In en, this message translates to:
  /// **'Numbers 1 to k in every region of k cells'**
  String get blocksTagline;

  /// No description provided for @blocksRules.
  ///
  /// In en, this message translates to:
  /// **'• Fill every cell with a number.\n• A region of k cells holds each number from 1 to k exactly once (a region of one cell holds a 1).\n• Equal numbers never touch, not even diagonally.\n• Given numbers are fixed.\n\nPick a number in the palette and tap cells to place it, or tap a cell first and then a number. The pencil button toggles small notes. Long-press / right-click clears a cell.'**
  String get blocksRules;

  /// No description provided for @pairsName.
  ///
  /// In en, this message translates to:
  /// **'Pairs'**
  String get pairsName;

  /// No description provided for @pairsTagline.
  ///
  /// In en, this message translates to:
  /// **'Two shaded cells in every region, side by side'**
  String get pairsTagline;

  /// No description provided for @pairsRules.
  ///
  /// In en, this message translates to:
  /// **'• Shade exactly two cells in every outlined region.\n• Every shaded cell touches exactly one other shaded cell side by side, so the shading is all pairs.\n• Pairs never touch each other side by side (corners are fine).\n\nTap a cell to cycle empty → shaded → dot (your \"not shaded\" note). Long-press / right-click cycles back.'**
  String get pairsRules;

  /// No description provided for @plotsName.
  ///
  /// In en, this message translates to:
  /// **'Plots'**
  String get plotsName;

  /// No description provided for @plotsTagline.
  ///
  /// In en, this message translates to:
  /// **'Split the grid into plots as big as their numbers'**
  String get plotsTagline;

  /// No description provided for @plotsRules.
  ///
  /// In en, this message translates to:
  /// **'• Fill every cell with a number.\n• Equal numbers that touch side by side form a plot, and a plot has exactly as many cells as its number: a 3 lies in a plot of three cells.\n• Two plots of the same size never touch side by side (they would be one plot).\n• Some plots show no number at all.\n\nPick a number in the palette and tap cells to fill them, or tap a cell first and then a number. Lines appear between different numbers, so you can see the plots take shape.'**
  String get plotsRules;

  /// No description provided for @linksName.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get linksName;

  /// No description provided for @linksTagline.
  ///
  /// In en, this message translates to:
  /// **'Join the pairs and fill the grid'**
  String get linksTagline;

  /// No description provided for @linksRules.
  ///
  /// In en, this message translates to:
  /// **'• Join each pair of equal dots with a path through neighbouring cells (no diagonals).\n• Paths never cross, branch or share a cell.\n• Together the paths fill every cell of the grid.\n\nDrag from a dot to draw its path; drawing across another path cuts it. Tap a dot to clear its path, or a cell of a path to cut the path there.'**
  String get linksRules;

  /// No description provided for @arrowsName.
  ///
  /// In en, this message translates to:
  /// **'Arrows'**
  String get arrowsName;

  /// No description provided for @arrowsTagline.
  ///
  /// In en, this message translates to:
  /// **'Shade what the arrows count, loop through the rest'**
  String get arrowsTagline;

  /// No description provided for @arrowsRules.
  ///
  /// In en, this message translates to:
  /// **'• Shade some cells. Shaded cells never touch side by side.\n• Draw one closed loop through the centers of all the other cells. It never branches or crosses itself.\n• Clue cells (a number and an arrow) are neither shaded nor on the loop. A clue\'s number counts the shaded cells in its arrow\'s direction, all the way to the edge.\n\nDrag through cells to draw the loop, or along it to erase. Tap the center of a cell to cycle empty → shaded → dot (your \"on the loop\" note), or tap between two cells to cycle line → cross → empty.'**
  String get arrowsRules;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get learnTitle;

  /// No description provided for @learnIntro.
  ///
  /// In en, this message translates to:
  /// **'Short interactive lessons: every step is a tiny board that shows one rule or trick.'**
  String get learnIntro;

  /// No description provided for @learnSteps.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 step} other{{count} steps}}'**
  String learnSteps(int count);

  /// No description provided for @learnDone.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get learnDone;

  /// No description provided for @tutorialOfferTitle.
  ///
  /// In en, this message translates to:
  /// **'New to {name}?'**
  String tutorialOfferTitle(String name);

  /// No description provided for @tutorialOfferBody.
  ///
  /// In en, this message translates to:
  /// **'Take a quick interactive lesson first? A few tiny boards show you every rule.'**
  String get tutorialOfferBody;

  /// No description provided for @tutorialOfferNo.
  ///
  /// In en, this message translates to:
  /// **'No, thanks'**
  String get tutorialOfferNo;

  /// No description provided for @tutorialOfferYes.
  ///
  /// In en, this message translates to:
  /// **'Show me how'**
  String get tutorialOfferYes;

  /// No description provided for @tutorialTitle.
  ///
  /// In en, this message translates to:
  /// **'How to play {name}'**
  String tutorialTitle(String name);

  /// No description provided for @tutorialStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String tutorialStep(int step, int total);

  /// No description provided for @tutorialNice.
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get tutorialNice;

  /// No description provided for @tutorialNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tutorialNext;

  /// No description provided for @tutorialFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get tutorialFinish;

  /// No description provided for @tutorialShowMe.
  ///
  /// In en, this message translates to:
  /// **'Show me'**
  String get tutorialShowMe;

  /// No description provided for @tutorialPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous step'**
  String get tutorialPrevious;

  /// No description provided for @tutorialReset.
  ///
  /// In en, this message translates to:
  /// **'Start this step over'**
  String get tutorialReset;

  /// No description provided for @tutorialFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve got it!'**
  String get tutorialFinishedTitle;

  /// No description provided for @tutorialFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'That\'s everything you need to play {name}.'**
  String tutorialFinishedBody(String name);

  /// No description provided for @tutorialPlay.
  ///
  /// In en, this message translates to:
  /// **'Play now'**
  String get tutorialPlay;

  /// No description provided for @tutorialAgain.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get tutorialAgain;

  /// No description provided for @tutorialClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get tutorialClose;

  /// No description provided for @tutorialStrategies.
  ///
  /// In en, this message translates to:
  /// **'Learn strategies'**
  String get tutorialStrategies;

  /// No description provided for @strategiesTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} strategies'**
  String strategiesTitle(String name);

  /// No description provided for @strategiesFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'You know the main techniques for solving {name}.'**
  String strategiesFinishedBody(String name);

  /// No description provided for @learnBasicsTab.
  ///
  /// In en, this message translates to:
  /// **'Basics'**
  String get learnBasicsTab;

  /// No description provided for @learnStrategiesTab.
  ///
  /// In en, this message translates to:
  /// **'Strategies'**
  String get learnStrategiesTab;

  /// No description provided for @learnStrategiesIntro.
  ///
  /// In en, this message translates to:
  /// **'For when you know the rules: each lesson shows a technique that strong players use, on a board that needs it.'**
  String get learnStrategiesIntro;

  /// No description provided for @tutMambo1.
  ///
  /// In en, this message translates to:
  /// **'Fill every cell with a sun or a moon. Never three of the same in a row: after two suns side by side comes a moon. Tap a highlighted cell to cycle empty → sun → moon.'**
  String get tutMambo1;

  /// No description provided for @tutMambo2.
  ///
  /// In en, this message translates to:
  /// **'Every row and column holds as many suns as moons. The top row already has its two suns, so its other cells are moons. The right column works the same way.'**
  String get tutMambo2;

  /// No description provided for @tutMambo3.
  ///
  /// In en, this message translates to:
  /// **'An = between two cells means they hold the same symbol. Match the highlighted cells to their neighbours.'**
  String get tutMambo3;

  /// No description provided for @tutMambo4.
  ///
  /// In en, this message translates to:
  /// **'A × means the two cells are different: one sun, one moon.'**
  String get tutMambo4;

  /// No description provided for @tutMambo5.
  ///
  /// In en, this message translates to:
  /// **'Now a whole board: use every rule together. Tip: the palette button at the top lets you stamp one symbol on many cells, and a long press (or right-click) cycles backwards.'**
  String get tutMambo5;

  /// No description provided for @tutMamboS1.
  ///
  /// In en, this message translates to:
  /// **'When no rule applies directly, ask “what if?”. The highlighted pair is joined by =, so both cells hold the same symbol. Two suns would give the top row three suns out of four, so both are moons.'**
  String get tutMamboS1;

  /// No description provided for @tutMamboS2.
  ///
  /// In en, this message translates to:
  /// **'A harder board, where you\'ll need that trick often: try a symbol in a cell and follow the rules a few steps. If something breaks, the other symbol is right. A × pair always holds one of each, so it counts as one sun and one moon in its row.'**
  String get tutMamboS2;

  /// No description provided for @tutSudoku1.
  ///
  /// In en, this message translates to:
  /// **'Each row, column and box (the thick outlines) holds every number from 1 to 4 once. This row is missing one number: pick it in the palette, then tap the empty cell.'**
  String get tutSudoku1;

  /// No description provided for @tutSudoku2.
  ///
  /// In en, this message translates to:
  /// **'By their row, these two cells could be 3 or 4. Their columns decide: each column is missing just one number.'**
  String get tutSudoku2;

  /// No description provided for @tutSudoku3.
  ///
  /// In en, this message translates to:
  /// **'The boxes count too: every box needs 1 to 4 once. Finish the last box.'**
  String get tutSudoku3;

  /// No description provided for @tutSudoku4.
  ///
  /// In en, this message translates to:
  /// **'Not sure yet? Take notes. Turn on the pencil next to the palette, select the highlighted cell and note every number it could still hold.'**
  String get tutSudoku4;

  /// No description provided for @tutSudoku5.
  ///
  /// In en, this message translates to:
  /// **'Now a whole puzzle. Selecting a cell tints its row, column and box, and highlights the same number elsewhere. Settings can remove notes for you when you place a number.'**
  String get tutSudoku5;

  /// No description provided for @tutSudokuS1.
  ///
  /// In en, this message translates to:
  /// **'Look at one number instead of one cell. The highlighted box needs a 1: the 1s in its columns and in its second row rule out every cell but one. Then finish the board the same way.'**
  String get tutSudokuS1;

  /// No description provided for @tutSudokuS2.
  ///
  /// In en, this message translates to:
  /// **'Two more tricks. Pairs: two cells of a line or box that can only hold the same two numbers claim them. Pointing: if a box\'s spots for a number share a line, the rest of that line can\'t have it.'**
  String get tutSudokuS2;

  /// No description provided for @tutKings1.
  ///
  /// In en, this message translates to:
  /// **'Put exactly one crown in every row, every column and every colored region. Three are placed, and the last one has just one spot left. Tap it twice: first a dot, then a crown.'**
  String get tutKings1;

  /// No description provided for @tutKings2.
  ///
  /// In en, this message translates to:
  /// **'Crowns never touch, not even at the corners. Tap once to put a dot (your \"no crown here\" note) on each cell around this crown.'**
  String get tutKings2;

  /// No description provided for @tutKings3.
  ///
  /// In en, this message translates to:
  /// **'The crowns\' rows and the touching rule leave just one cell of the highlighted region without a dot. Place its crown.'**
  String get tutKings3;

  /// No description provided for @tutKings4.
  ///
  /// In en, this message translates to:
  /// **'Now a whole board. Dot the cells you can rule out, and look for rows, columns or regions with a single free cell.'**
  String get tutKings4;

  /// No description provided for @tutKingsS1.
  ///
  /// In en, this message translates to:
  /// **'Look for a region that fits in one row or column. The highlighted region lies entirely in the bottom row, so that row\'s crown is in it: dot the other cells of the bottom row, then carry on.'**
  String get tutKingsS1;

  /// No description provided for @tutKingsS2.
  ///
  /// In en, this message translates to:
  /// **'Another trick: if a crown in a cell would rule out every cell of another region (by its row, its column or by touching), that cell can\'t hold a crown. Dot it. The same works for two regions squeezed into two rows.'**
  String get tutKingsS2;

  /// No description provided for @tutHues1.
  ///
  /// In en, this message translates to:
  /// **'Paint every blank cell. A number counts the blank cells around it (diagonals too) that end up in its own color. The blue 3 has exactly three blank neighbours, so all of them are blue. Pick a color in the palette and tap cells to paint them.'**
  String get tutHues1;

  /// No description provided for @tutHues2.
  ///
  /// In en, this message translates to:
  /// **'Numbers count down as you paint: they show how many matching cells are still missing. A 0 means no blank neighbour takes its color, and numbered cells never count. Start with the blue 3, then see what the pink 2 still needs.'**
  String get tutHues2;

  /// No description provided for @tutHues3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Start with numbers that need all of their blank neighbours, or none of them.'**
  String get tutHues3;

  /// No description provided for @tutHuesS1.
  ///
  /// In en, this message translates to:
  /// **'Rule out colors. Each highlighted cell touches the blue 0, so it can\'t be blue, and the pink 0, so it can\'t be pink. Only yellow is left.'**
  String get tutHuesS1;

  /// No description provided for @tutHuesS2.
  ///
  /// In en, this message translates to:
  /// **'A harder board. Compare numbers that share blank neighbors: what one still needs may already be used up by the other. When stuck, try a color in a cell and see whether some number breaks.'**
  String get tutHuesS2;

  /// No description provided for @tutMosaic1.
  ///
  /// In en, this message translates to:
  /// **'The patch in the top-left corner is yours. Pick a color below: your patch takes it and swallows every touching cell of that color. Turn the whole board one color.'**
  String get tutMosaic1;

  /// No description provided for @tutMosaic2.
  ///
  /// In en, this message translates to:
  /// **'Mind the move limit: pick the color that grows your patch the most. Tapping a cell on the board also picks its color.'**
  String get tutMosaic2;

  /// No description provided for @tutMosaic3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board, with a few moves to spare.'**
  String get tutMosaic3;

  /// No description provided for @tutMosaicS1.
  ///
  /// In en, this message translates to:
  /// **'Plan ahead. Reach the middle of the board early, since your patch then touches more colors, and whenever you can, pick a color that wipes that color off the board.'**
  String get tutMosaicS1;

  /// No description provided for @tutBlend1.
  ///
  /// In en, this message translates to:
  /// **'The board is made of patches: touching cells of one color. Pick a color below, then tap a patch to repaint it. It merges with the touching patches of that color. Repaint the middle patch.'**
  String get tutBlend1;

  /// No description provided for @tutBlend2.
  ///
  /// In en, this message translates to:
  /// **'One move can merge many patches. The middle patch touches four others: paint it to join them, then finish. You have only 2 moves.'**
  String get tutBlend2;

  /// No description provided for @tutBlend3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. The chosen color stays selected, so you can paint several patches in a row.'**
  String get tutBlend3;

  /// No description provided for @tutBlendS1.
  ///
  /// In en, this message translates to:
  /// **'Pick one patch in the middle and keep repainting it: each move then swallows every touching patch of the new color. Choose the color that most of its neighbors share.'**
  String get tutBlendS1;

  /// No description provided for @tutPop1.
  ///
  /// In en, this message translates to:
  /// **'Tap a group of two or more touching bubbles of one color to select it, then tap it again to pop it. Clear the board.'**
  String get tutPop1;

  /// No description provided for @tutPop2.
  ///
  /// In en, this message translates to:
  /// **'Bubbles above fall into the gaps, so new groups can form. Order matters: pop the highlighted group first.'**
  String get tutPop2;

  /// No description provided for @tutPop3.
  ///
  /// In en, this message translates to:
  /// **'When a column empties, the columns to its left slide right to close the gap. Pop the middle to bring the sides together.'**
  String get tutPop3;

  /// No description provided for @tutPop4.
  ///
  /// In en, this message translates to:
  /// **'A group of n bubbles scores n × (n − 1): 2 bubbles score 2, 5 score 20. Save up for a big group to reach 20 points.'**
  String get tutPop4;

  /// No description provided for @tutPop5.
  ///
  /// In en, this message translates to:
  /// **'Other modes: in Shifter every row also slides right to close its gaps, in Continuous new columns roll in from the left, and Mega does both. Goals: clear the board, reach a target score, or play freely for your best. The game ends when no group of 2 is left.'**
  String get tutPop5;

  /// No description provided for @tutPopS1.
  ///
  /// In en, this message translates to:
  /// **'Clearing a board takes planning. Before popping, ask what falls into the gap: pop groups that bring bubbles of one color together, and never leave a single bubble of a color on its own.'**
  String get tutPopS1;

  /// No description provided for @tutPopS2.
  ///
  /// In en, this message translates to:
  /// **'Chasing points: a group of n scores n × (n − 1), so one group of 8 (56) beats four groups of 2 (8). Pop the other colors first to merge a color into one big group.'**
  String get tutPopS2;

  /// No description provided for @tutMerge1.
  ///
  /// In en, this message translates to:
  /// **'Swipe (or press an arrow key) to slide every tile as far as it goes. Two equal tiles that meet merge into their sum. Make a 4.'**
  String get tutMerge1;

  /// No description provided for @tutMerge2.
  ///
  /// In en, this message translates to:
  /// **'A tile merges only once per move: 4, 4, 8 slides into 8, 8, not 16. After every move a new 2 (sometimes a 4) appears. Build a 16.'**
  String get tutMerge2;

  /// No description provided for @tutMerge3.
  ///
  /// In en, this message translates to:
  /// **'Keep your biggest tile in a corner and feed it step by step. Build a 32.'**
  String get tutMerge3;

  /// No description provided for @tutMergeS1.
  ///
  /// In en, this message translates to:
  /// **'Build a chain: keep your tiles in order along one row with the biggest in the corner, like 64, 32, 16, 8. Then one new 8 at the end rolls all the way up. Make 128.'**
  String get tutMergeS1;

  /// No description provided for @tutPipes1.
  ///
  /// In en, this message translates to:
  /// **'Tap a tile to turn it clockwise (a long press or right-click turns it back). Connect every pipe to the source, the ringed tile. Water shows what\'s already connected.'**
  String get tutPipes1;

  /// No description provided for @tutPipes2.
  ///
  /// In en, this message translates to:
  /// **'No pipe end may stay open, so no pipe can point off the board. Tiles with a dot in the corner are fixed and already right. Start at the edges and corners, where tiles have the fewest ways to turn.'**
  String get tutPipes2;

  /// No description provided for @tutPipes3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. The network may not form loops.'**
  String get tutPipes3;

  /// No description provided for @tutPipesS1.
  ///
  /// In en, this message translates to:
  /// **'Work inward from the rim. A straight on the edge must run along it, a corner holds only an elbow pointing inward, and a T on the edge turns its flat side to the edge. Every tile you settle limits its neighbors.'**
  String get tutPipesS1;

  /// No description provided for @tutPipesS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. The network may not form a loop: if turning a tile would close one, it must point elsewhere. And two dead ends never face each other, or they\'d form a pair cut off from the rest.'**
  String get tutPipesS2;

  /// No description provided for @tutShikaku1.
  ///
  /// In en, this message translates to:
  /// **'Split the grid into rectangles. Each holds exactly one number, equal to its area in cells. Drag from one corner to the opposite one to draw a rectangle.'**
  String get tutShikaku1;

  /// No description provided for @tutShikaku2.
  ///
  /// In en, this message translates to:
  /// **'A 1 is a rectangle on its own: just tap it. Tap a drawn rectangle to remove it. Here the 6 fits only one way.'**
  String get tutShikaku2;

  /// No description provided for @tutShikaku3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Big numbers near the edges usually have the fewest ways to fit.'**
  String get tutShikaku3;

  /// No description provided for @tutShikakuS1.
  ///
  /// In en, this message translates to:
  /// **'Ask which numbers can reach a cell. The bottom-left corner is too far for the 4 and the 6 to cover with a rectangle of their size, so it belongs to the 2.'**
  String get tutShikakuS1;

  /// No description provided for @tutShikakuS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. List the few rectangles a big number could use: cells that all of them cover belong to it, and a cell only one number can reach belongs to that number.'**
  String get tutShikakuS2;

  /// No description provided for @tutTrail1.
  ///
  /// In en, this message translates to:
  /// **'Drag from 1 to draw one path through every cell, moving up, down, left or right. It ends on the last number.'**
  String get tutTrail1;

  /// No description provided for @tutTrail2.
  ///
  /// In en, this message translates to:
  /// **'The path must pass the numbers in order: 1 → 2 → 3 → 4. Drag back over your path to undo steps, or tap a cell of it to cut it there.'**
  String get tutTrail2;

  /// No description provided for @tutTrail3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Cells in corners have only two ways in and out, so the path must use both.'**
  String get tutTrail3;

  /// No description provided for @tutTrailS1.
  ///
  /// In en, this message translates to:
  /// **'Cells with only two free neighbors must be passed straight through: the path comes in one side and leaves by the other. Watch for cells your own path has just boxed in.'**
  String get tutTrailS1;

  /// No description provided for @tutTrailS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. Never cut the free cells into two parts: the path can\'t come back for the other part. And a cell with only one free neighbor is a dead end, allowed only for the last number.'**
  String get tutTrailS2;

  /// No description provided for @tutLabyrinth1.
  ///
  /// In en, this message translates to:
  /// **'Drag from the start in the top-left corner and walk to the flag in the bottom-right corner. Walls block the way.'**
  String get tutLabyrinth1;

  /// No description provided for @tutLabyrinth2.
  ///
  /// In en, this message translates to:
  /// **'A bigger maze. Hit a dead end? Drag back along your path, or tap any cell of it to return there. A quick drag follows straight corridors.'**
  String get tutLabyrinth2;

  /// No description provided for @tutLabyrinthS1.
  ///
  /// In en, this message translates to:
  /// **'Lost? Keep one hand on a wall: always take the rightmost opening. In a maze like this it always leads out, though not by the shortest way.'**
  String get tutLabyrinthS1;

  /// No description provided for @tutLabyrinthS2.
  ///
  /// In en, this message translates to:
  /// **'Or work backwards: trace the way from the flag toward the start, and look for where the two routes meet. Dead ends near the flag are ruled out fast that way.'**
  String get tutLabyrinthS2;

  /// No description provided for @tutAtoms1.
  ///
  /// In en, this message translates to:
  /// **'Connect the atoms with bonds. Each atom needs as many bonds as its number, and two atoms can share one or two. Drag from an atom toward a neighbour to add a bond (1 → 2 → none).'**
  String get tutAtoms1;

  /// No description provided for @tutAtoms2.
  ///
  /// In en, this message translates to:
  /// **'All atoms must join into one molecule, and bonds can\'t cross. Bonding the top-left 1 downwards would leave two separate pairs, so where does its bond go?'**
  String get tutAtoms2;

  /// No description provided for @tutAtoms3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Start with atoms that have only one way to get their bonds.'**
  String get tutAtoms3;

  /// No description provided for @tutAtomsS1.
  ///
  /// In en, this message translates to:
  /// **'Compare an atom\'s number with its neighbors. The 4 in the corner has just two neighbors, and a pair can share at most two bonds, so both bonds are double. Likewise a 3 with two neighbors gets at least one bond to each.'**
  String get tutAtomsS1;

  /// No description provided for @tutAtomsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. Keep the molecule in one piece: two 1s never bond to each other, and two 2s never share a double bond, unless they\'re the only atoms. When stuck, try a bond and see if part of the board gets cut off.'**
  String get tutAtomsS2;

  /// No description provided for @tutLits1.
  ///
  /// In en, this message translates to:
  /// **'Shade exactly 4 cells in every outlined region, forming an L, I, T or S. The top region has exactly 4 cells, so shade them all. Tap a cell to shade it.'**
  String get tutLits1;

  /// No description provided for @tutLits2.
  ///
  /// In en, this message translates to:
  /// **'No 2×2 block may be fully shaded, and two identical shapes may not touch across a border. Just one cell completes the left region. Which one?'**
  String get tutLits2;

  /// No description provided for @tutLits3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. All shaded cells must form one connected area. Tap twice for a dot, your note that a cell stays empty.'**
  String get tutLits3;

  /// No description provided for @tutLitsS1.
  ///
  /// In en, this message translates to:
  /// **'List the shapes each region can still hold. Cells that every possible shape covers are shaded, and cells that none covers stay empty. Small regions and regions squeezed by the 2×2 rule have the fewest options.'**
  String get tutLitsS1;

  /// No description provided for @tutLitsS2.
  ///
  /// In en, this message translates to:
  /// **'A harder board. When stuck, try one shape in a region: if it makes a 2×2 block, cuts the shaded area in two or puts two equal shapes side by side, it\'s wrong.'**
  String get tutLitsS2;

  /// No description provided for @tutCamp1.
  ///
  /// In en, this message translates to:
  /// **'Pitch one tent next to every tree: up, down, left or right, never diagonal. The numbers outside tell how many tents each row and column holds. Tap a cell twice: grass, then a tent.'**
  String get tutCamp1;

  /// No description provided for @tutCamp2.
  ///
  /// In en, this message translates to:
  /// **'Tents never touch each other, not even diagonally. One tent is pitched already. Where can the other tree\'s tent go?'**
  String get tutCamp2;

  /// No description provided for @tutCamp3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. A 0 means the whole row or column is grass, and every tree gets its own tent.'**
  String get tutCamp3;

  /// No description provided for @tutCampS1.
  ///
  /// In en, this message translates to:
  /// **'Count the gaps. The top row needs 2 tents, and only its three highlighted cells can hold one. Two tents in three cells that may not touch must take both ends.'**
  String get tutCampS1;

  /// No description provided for @tutCampS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board, and some counts are hidden. When stuck, try a tent on a spot: if some tree is left with no place for its own tent, that spot is grass.'**
  String get tutCampS2;

  /// No description provided for @tutIslands1.
  ///
  /// In en, this message translates to:
  /// **'Shade the sea so that the unshaded cells form islands. Each number is an island of exactly that many cells. Here the 1 is an island by itself: tap every other cell to make it sea.'**
  String get tutIslands1;

  /// No description provided for @tutIslands2.
  ///
  /// In en, this message translates to:
  /// **'Islands never touch each other. A cell between two numbers must be sea, or it would join them into one island.'**
  String get tutIslands2;

  /// No description provided for @tutIslands3.
  ///
  /// In en, this message translates to:
  /// **'The sea must stay connected and may never form a 2×2 pool. Grow the 3 so that neither happens. Tap twice for a dot, your note for land.'**
  String get tutIslands3;

  /// No description provided for @tutIslands4.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Every island holds exactly one number.'**
  String get tutIslands4;

  /// No description provided for @tutIslandsS1.
  ///
  /// In en, this message translates to:
  /// **'Find cells no island can reach. The 3 grows at most two steps from its number, the 2 one step and the 1 none. The highlighted cells are out of every island\'s reach, so they\'re sea.'**
  String get tutIslandsS1;

  /// No description provided for @tutIslandsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. Keep the sea in mind: it must stay connected, so a sea cell with one way out continues that way, and it may not form a 2×2 pool. When stuck, try a cell as land and see whether something breaks.'**
  String get tutIslandsS2;

  /// No description provided for @tutLamps1.
  ///
  /// In en, this message translates to:
  /// **'Put lamps in the empty cells: tap twice (a dot, then a lamp). The dark cells are walls. A lamp lights its own row and column up to the walls. Light up every empty cell.'**
  String get tutLamps1;

  /// No description provided for @tutLamps2.
  ///
  /// In en, this message translates to:
  /// **'A number on a wall tells how many lamps touch it (up, down, left or right). This 3 needs a lamp on each of its free sides.'**
  String get tutLamps2;

  /// No description provided for @tutLamps3.
  ///
  /// In en, this message translates to:
  /// **'Lamps may never shine on each other, and a 0 means no lamp right next to it. Where does the second lamp go?'**
  String get tutLamps3;

  /// No description provided for @tutLamps4.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Dots help you mark cells that can\'t hold a lamp.'**
  String get tutLamps4;

  /// No description provided for @tutLampsS1.
  ///
  /// In en, this message translates to:
  /// **'Some cells have just one way to get light. The top-left corner can only be lit from itself or its two neighbors, and the 0 rules the neighbors out: the lamp goes in the corner. Then look at the 1.'**
  String get tutLampsS1;

  /// No description provided for @tutLampsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. When stuck, try a lamp on a cell and follow what it forces: if some cell can no longer be lit, or a number can\'t be met, that cell gets a dot.'**
  String get tutLampsS2;

  /// No description provided for @tutFence1.
  ///
  /// In en, this message translates to:
  /// **'Draw one closed loop along the dotted lines. A number tells how many sides of its cell the loop uses. Tap between two dots to draw a line, or drag from dot to dot.'**
  String get tutFence1;

  /// No description provided for @tutFence2.
  ///
  /// In en, this message translates to:
  /// **'A 0 has no line around it. Tap a line again to turn it into a cross, your note that no line goes there. Cells without a number can have any count.'**
  String get tutFence2;

  /// No description provided for @tutFence3.
  ///
  /// In en, this message translates to:
  /// **'The loop never branches or crosses itself: every dot has either no line or two. Numbers next to the board\'s edge are a good place to start.'**
  String get tutFence3;

  /// No description provided for @tutFence4.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Start with the 0s and 3s.'**
  String get tutFence4;

  /// No description provided for @tutFenceS1.
  ///
  /// In en, this message translates to:
  /// **'Learn a few patterns. Two 3s side by side always have a line between them and a line on each far side: any other way leaves one of them short. The 0 above helps too.'**
  String get tutFenceS1;

  /// No description provided for @tutFenceS2.
  ///
  /// In en, this message translates to:
  /// **'Corners are strong. A 1 in a corner never uses its two outer sides: the loop would have to turn right there and use both. A 3 in a corner always uses both.'**
  String get tutFenceS2;

  /// No description provided for @tutFenceS3.
  ///
  /// In en, this message translates to:
  /// **'A hard board. When stuck, try a line on one edge and follow it: if it leads to a dead end, a number it can\'t satisfy, or a small loop that leaves others out, that edge gets a cross.'**
  String get tutFenceS3;

  /// No description provided for @tutPearls1.
  ///
  /// In en, this message translates to:
  /// **'Drag through the cells to draw one closed loop. At a black pearl the loop turns, then runs straight through the next cell on both sides.'**
  String get tutPearls1;

  /// No description provided for @tutPearls2.
  ///
  /// In en, this message translates to:
  /// **'At a white pearl the loop goes straight through, and it turns in the cell just before or after it (or both).'**
  String get tutPearls2;

  /// No description provided for @tutPearls3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. The loop doesn\'t have to visit every cell, and it never crosses or touches itself.'**
  String get tutPearls3;

  /// No description provided for @tutPearlsS1.
  ///
  /// In en, this message translates to:
  /// **'A black pearl can\'t turn toward an edge that\'s too close: the loop needs two straight cells on each side. Both black pearls here are too close to two edges, so their directions are fixed.'**
  String get tutPearlsS1;

  /// No description provided for @tutPearlsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. Three white pearls in a row can\'t all lie on one straight stretch (the middle one needs a turn next to it), so the loop crosses them. When stuck, try a line and see if some pearl breaks.'**
  String get tutPearlsS2;

  /// No description provided for @tutRails1.
  ///
  /// In en, this message translates to:
  /// **'Drag through the cells to lay one track from the entry on the left to the exit at the bottom. The numbers above and to the right count the track cells in each column and row.'**
  String get tutRails1;

  /// No description provided for @tutRails2.
  ///
  /// In en, this message translates to:
  /// **'Pieces already on the board are fixed: the track runs through them exactly as shown. A 0 means no track in that row or column at all.'**
  String get tutRails2;

  /// No description provided for @tutRails3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. The track never branches or crosses itself, and it doesn\'t have to visit every cell.'**
  String get tutRails3;

  /// No description provided for @tutRailsS1.
  ///
  /// In en, this message translates to:
  /// **'Start with lines whose count leaves no choice. The second row needs 4 track cells and has only 4, and so does the right column. Then join the ends.'**
  String get tutRailsS1;

  /// No description provided for @tutRailsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. A count that\'s already used up blocks the rest of its line, and a track cell always needs exactly two track neighbors. When stuck, try a piece and check that the counts still fit.'**
  String get tutRailsS2;

  /// No description provided for @tutBlocks1.
  ///
  /// In en, this message translates to:
  /// **'Every region of k cells holds the numbers 1 to k once each. Each highlighted cell is the last gap in its region: pick the missing number in the palette, then tap the cell.'**
  String get tutBlocks1;

  /// No description provided for @tutBlocks2.
  ///
  /// In en, this message translates to:
  /// **'Equal numbers never touch, not even at the corners. The top-left region needs a 1 and a 2, and one of its cells already touches a 2. Fill the bottom row the same way.'**
  String get tutBlocks2;

  /// No description provided for @tutBlocks3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Start with small regions and with cells whose neighbours rule out most numbers. Pencil notes help.'**
  String get tutBlocks3;

  /// No description provided for @tutBlocksS1.
  ///
  /// In en, this message translates to:
  /// **'Pointing: note where each region can still put a number. When all those cells touch the same outside cell, that cell can\'t hold the number, since it would touch it. Pencil notes help you see it.'**
  String get tutBlocksS1;

  /// No description provided for @tutBlocksS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. When nothing else works, pick a cell with just two possible numbers and try one: if it soon leaves a region with no place for a number, the other one is right.'**
  String get tutBlocksS2;

  /// No description provided for @tutPairs1.
  ///
  /// In en, this message translates to:
  /// **'Shade exactly two cells in every region, so that each shaded cell touches exactly one other: the shading comes in pairs. The highlighted region has just two cells, so shade both.'**
  String get tutPairs1;

  /// No description provided for @tutPairs2.
  ///
  /// In en, this message translates to:
  /// **'Pairs never touch each other side by side. The top pair is finished, so the highlighted cells next to it stay unshaded: put a dot there (tap twice), then finish the board.'**
  String get tutPairs2;

  /// No description provided for @tutPairs3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Small regions and cells boxed in by dots are good places to start.'**
  String get tutPairs3;

  /// No description provided for @tutPairsS1.
  ///
  /// In en, this message translates to:
  /// **'Try every way to finish a small region: a cell shaded in all of them is shaded, and a cell shaded in none gets a dot. An L of three cells, for example, always shades its corner.'**
  String get tutPairsS1;

  /// No description provided for @tutPairsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. When stuck, shade a cell and follow the rules: if some region can no longer get its two cells, or two pairs would touch, that cell stays unshaded.'**
  String get tutPairsS2;

  /// No description provided for @tutPlots1.
  ///
  /// In en, this message translates to:
  /// **'Fill every cell with a number. Equal numbers that touch side by side form a plot with exactly that many cells. The highlighted 3 needs two more cells for its plot.'**
  String get tutPlots1;

  /// No description provided for @tutPlots2.
  ///
  /// In en, this message translates to:
  /// **'Two plots of the same size can\'t touch: they would join into one plot that is too big. The highlighted cell touches two plots of 2, so it can\'t be a 2.'**
  String get tutPlots2;

  /// No description provided for @tutPlots3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Some plots show no number at all: work out their size from the room that\'s left.'**
  String get tutPlots3;

  /// No description provided for @tutPlotsS1.
  ///
  /// In en, this message translates to:
  /// **'Look for pockets. The two highlighted cells are fenced in by finished plots, so they can only join each other. Two 1s may not touch, so together they are a plot of 2.'**
  String get tutPlotsS1;

  /// No description provided for @tutPlotsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. When nothing is certain, pick a cell with only two or three possible numbers and test each one: a number that leaves some plot unable to reach its size is out.'**
  String get tutPlotsS2;

  /// No description provided for @tutLinks1.
  ///
  /// In en, this message translates to:
  /// **'Drag from a dot to its twin to join them. Paths go through neighbouring cells, never diagonally.'**
  String get tutLinks1;

  /// No description provided for @tutLinks2.
  ///
  /// In en, this message translates to:
  /// **'Paths never cross, and together they fill every cell, so some have to take the long way round.'**
  String get tutLinks2;

  /// No description provided for @tutLinks3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Corners and edges leave the fewest ways to go, so start there.'**
  String get tutLinks3;

  /// No description provided for @tutLinksS1.
  ///
  /// In en, this message translates to:
  /// **'Fill the tight spots first. An empty corner has only two neighbors, so the path through it uses both. The same goes for any cell squeezed down to two free neighbors.'**
  String get tutLinksS1;

  /// No description provided for @tutLinksS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. In a puzzle with one answer, a path never folds back beside itself (it could take a shortcut), so no 2×2 square belongs to a single path. And never leave an empty cell that no path can still reach.'**
  String get tutLinksS2;

  /// No description provided for @tutArrows1.
  ///
  /// In en, this message translates to:
  /// **'Draw one loop through the centers of all the empty cells: drag from cell to cell. The clue cell in the middle is never on the loop. Its 0 says no cell above it is shaded, so here nothing is.'**
  String get tutArrows1;

  /// No description provided for @tutArrows2.
  ///
  /// In en, this message translates to:
  /// **'Now two cells must be shaded. Each clue counts the shaded cells in its arrow\'s direction: find them and tap their centers to shade them. Shaded cells never touch side by side. Then draw the loop through all the other cells.'**
  String get tutArrows2;

  /// No description provided for @tutArrows3.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. Cells next to a shaded cell are always on the loop, and a loop cell needs two ways out.'**
  String get tutArrows3;

  /// No description provided for @tutArrowsS1.
  ///
  /// In en, this message translates to:
  /// **'Look for tight clues. The 2 in the middle row has just three cells to its right, and its two shaded cells may not touch, so they take the first and the last. The 2 in the top row is even easier: it has only two free cells.'**
  String get tutArrowsS1;

  /// No description provided for @tutArrowsS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. Every cell that isn\'t shaded or a clue is on the loop, so a cell with only two free neighbors has its path fixed. When stuck, try shading a cell and see if a loop cell is left with fewer than two ways out.'**
  String get tutArrowsS2;

  /// No description provided for @tutMines1.
  ///
  /// In en, this message translates to:
  /// **'A number counts the mines in the 8 cells around it. Each 1 here touches just one closed cell, so that cell is a mine. Flag it: long-press or right-click it, or switch to Flag below and tap it.'**
  String get tutMines1;

  /// No description provided for @tutMines2.
  ///
  /// In en, this message translates to:
  /// **'This 1 already has its mine flagged, so every other cell around it is safe. Dig them, or tap the 1 itself to dig them all at once.'**
  String get tutMines2;

  /// No description provided for @tutMines3.
  ///
  /// In en, this message translates to:
  /// **'A cell with no mines around it opens its neighbours for you. Dig the highlighted corner.'**
  String get tutMines3;

  /// No description provided for @tutMines4.
  ///
  /// In en, this message translates to:
  /// **'Now a real board. You never need to guess. If you dig a mine by mistake, it just gets flagged and the game goes on.'**
  String get tutMines4;

  /// No description provided for @tutMinesS1.
  ///
  /// In en, this message translates to:
  /// **'Compare neighboring numbers. The 2 sees three closed cells, the 1 on its left sees only the first two, so the third one is a mine. The same works from the right. Then the middle cell is safe.'**
  String get tutMinesS1;

  /// No description provided for @tutMinesS2.
  ///
  /// In en, this message translates to:
  /// **'A hard board. Keep comparing numbers that share closed cells. Near the end, count what\'s left: the mine counter can settle the last closed cells.'**
  String get tutMinesS2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
