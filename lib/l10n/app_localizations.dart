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
  /// **'• Rotate the tiles so that every pipe connects back to the source (the ringed tile).\n• No pipe end may be left open, and the network may not contain loops.\n• Water flows through everything already connected to the source.\n• Tiles with a lock are already in place.\n\nTap a tile to rotate it clockwise; long-press / right-click rotates it back.'**
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
  /// **'• Place lamps in white cells. A lamp lights its own cell and its row and column until a wall.\n• Every white cell must be lit.\n• No lamp may shine on another lamp.\n• A number on a wall tells how many lamps are right next to it (up, down, left or right).\n\nTap a cell to cycle empty → dot (your \"no lamp\" note) → lamp. Long-press / right-click cycles back.'**
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
