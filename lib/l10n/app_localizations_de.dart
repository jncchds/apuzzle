// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get settings => 'Einstellungen';

  @override
  String get dailyTitle => 'Tägliche Rätsel';

  @override
  String get dailyCalendar => 'Kalender';

  @override
  String dailyProgress(int done, int total) {
    return '$done von $total gelöst';
  }

  @override
  String get dailyDayComplete => 'Tag geschafft!';

  @override
  String get dailyNext => 'Nächstes Rätsel';

  @override
  String get dailyToday => 'Heute';

  @override
  String get dailyChoose => 'Spiele auswählen';

  @override
  String dailyChooseHint(int count) {
    return 'Jeden Tag werden $count der gewählten Spiele gezogen. Eine Änderung gilt ab heute, frühere Tage behalten ihre Spiele.';
  }

  @override
  String dailyChooseMin(int count) {
    return 'Wähle mindestens $count Spiele';
  }

  @override
  String get dailyChooseAll => 'Alle Spiele';

  @override
  String get save => 'Speichern';

  @override
  String get playCode => 'Rätselcode spielen';

  @override
  String get playCodeMenu => 'Rätselcode spielen…';

  @override
  String get inProgress => 'Läuft';

  @override
  String get catNumbers => 'Zahlen';

  @override
  String get catGrids => 'Logikgitter';

  @override
  String get catPaths => 'Wege & Schleifen';

  @override
  String get catCasual => 'Zum Entspannen';

  @override
  String get searchHint => 'Spiele suchen';

  @override
  String get searchNone => 'Keine Spiele gefunden. Stöbere in den Kategorien:';

  @override
  String searchSimilar(String query) {
    return 'Nichts namens „$query“. Meintest du:';
  }

  @override
  String searchAlternatives(String query) {
    return '„$query“ haben wir nicht, aber vielleicht gefällt dir:';
  }

  @override
  String get yourGames => 'Deine Spiele';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spiele',
      one: '$count Spiel',
    );
    return '$_temp0';
  }

  @override
  String get pinGame => 'An deine Spiele anheften';

  @override
  String get unpinGame => 'Von deinen Spielen lösen';

  @override
  String pinnedToast(String name) {
    return '$name ist an deine Spiele angeheftet';
  }

  @override
  String unpinnedToast(String name) {
    return '$name ist nicht mehr angeheftet';
  }

  @override
  String get famFlood => 'Farbflut';

  @override
  String get famFloodAbout => 'Färbe das Brett um, bis es einfarbig ist, mit so wenigen Zügen wie möglich';

  @override
  String get tagShade => 'Felder schwärzen, schattieren, ausmalen';

  @override
  String get tagLoop => 'Schleife zeichnen, Rundweg, Kreis';

  @override
  String get tagPath => 'Weg zeichnen, Linie, Pfad, Route';

  @override
  String get tagNumbers => 'Zahlen eintragen, Ziffern';

  @override
  String get tagRegions => 'in Gebiete teilen, Bereiche, Regionen';

  @override
  String get tagSums => 'Summen, addieren, Rechnen, Mathe';

  @override
  String get tagLatin => 'lateinisches Quadrat';

  @override
  String get tagCompare => 'vergleichen, Vergleich, größer, kleiner, mehr, weniger, Ungleichung, Zeichen';

  @override
  String get tagPlace => 'Objekte platzieren';

  @override
  String get tagPieces => 'Teile, Formen, Plättchen, Klötze, Legespiel';

  @override
  String get tagConnect => 'verbinden, Brücken';

  @override
  String get tagColors => 'Farben, malen';

  @override
  String get tagGuess => 'raten, Ratespiel';

  @override
  String get tagSlide => 'Steine schieben, verschmelzen';

  @override
  String get tagArcade => 'Arcade, Action, Reaktion';

  @override
  String get tagSymmetry => 'Symmetrie, symmetrisch';

  @override
  String get tagBinary => 'zwei Symbole, binär';

  @override
  String get tagMaze => 'Labyrinth, Irrgarten';

  @override
  String get size => 'Größe';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get difficultyEasy => 'Leicht';

  @override
  String get difficultyMedium => 'Mittel';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String get difficultyExpert => 'Experte';

  @override
  String notSolvedYet(Object difficulty) {
    return 'Auf „$difficulty“ noch nicht gelöst';
  }

  @override
  String statsScore(Object count, Object score, Object time) {
    return '$count× gespielt · Bestpunktzahl $score · Bestzeit $time';
  }

  @override
  String statsTime(Object average, Object best, Object count) {
    return '$count× gelöst · Bestzeit $best · Schnitt $average';
  }

  @override
  String get continueGame => 'Fortsetzen';

  @override
  String get newPuzzle => 'Neues Rätsel';

  @override
  String get highlightErrors => 'Fehler beim Spielen hervorheben';

  @override
  String get highlightErrorsHint => 'Aus: Fehler werden erst nach „Prüfen“ angezeigt';

  @override
  String get autoClearMarks => 'Notizen automatisch entfernen';

  @override
  String get autoClearMarksHint => 'Eine gesetzte Zahl löscht diese Notiz aus Zeile, Spalte und Block';

  @override
  String get haptics => 'Haptisches Feedback';

  @override
  String get theme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get aboutLicenses => 'Info & Lizenzen';

  @override
  String get releaseNotes => 'Versionshinweise';

  @override
  String get aboutCredits => 'Geschrieben mit Claude Code und dem Modell Claude Opus 5.5';

  @override
  String get linksTitle => 'Rätsel-Links in der App öffnen';

  @override
  String get linksOn => 'Geteilte Rätsel-Links öffnen sich in APuzzle';

  @override
  String linksOff(Object host) {
    return 'Aus: Tippen und $host unter „Unterstützte Links öffnen“ hinzufügen';
  }

  @override
  String linksUnknown(Object host) {
    return 'APuzzle für Links von $host wählen';
  }

  @override
  String get couldNotOpenSettings => 'Die Systemeinstellungen konnten nicht geöffnet werden';

  @override
  String get transferTitle => 'Auf ein anderes Gerät übertragen';

  @override
  String get transferHint =>
      'Hier exportieren, auf dem anderen Gerät importieren. Der Import führt zusammen: Siege, Bestzeiten und Tagesergebnisse beider Geräte bleiben erhalten, von zwei gespeicherten Spielen gewinnt das neuere.';

  @override
  String get transferExportFile => 'In eine Datei exportieren';

  @override
  String get transferImportFile => 'Aus einer Datei importieren';

  @override
  String get transferCopy => 'Als Text kopieren';

  @override
  String get transferPaste => 'Text einfügen';

  @override
  String get transferCopied => 'Fortschritt kopiert. Füge ihn auf dem anderen Gerät ein.';

  @override
  String get transferSaved => 'Fortschritt in einer Datei gespeichert';

  @override
  String transferImported(int count) {
    return 'Fortschritt zusammengeführt. Aktualisierte Einträge: $count';
  }

  @override
  String get transferNothingNew => 'Nichts Neues: Dieses Gerät hat schon alles';

  @override
  String get transferBadData => 'Das ist kein APuzzle-Fortschritt, oder die Daten sind beschädigt';

  @override
  String get transferSaveFailed => 'Die Datei konnte nicht gespeichert werden';

  @override
  String get transferCopyFailed => 'Kopieren in die Zwischenablage fehlgeschlagen';

  @override
  String get installApp => 'App installieren';

  @override
  String get installAppHint => 'APuzzle zum Home-Bildschirm hinzufügen; es öffnet sich in einem eigenen Fenster';

  @override
  String get installAppIos => 'Tippe im Browser auf „Teilen“ und dann auf „Zum Home-Bildschirm“.';

  @override
  String get submitConflicts => 'Einige Felder verletzen die Regeln';

  @override
  String get submitIncomplete => 'Noch nicht fertig';

  @override
  String get submitWrong => 'Nicht ganz richtig';

  @override
  String get restartTitle => 'Rätsel neu starten?';

  @override
  String get restartBody => 'Alle Eingaben werden gelöscht. Du kannst es noch rückgängig machen.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get restart => 'Neu starten';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get rules => 'Regeln';

  @override
  String get copyShareLink => 'Link kopieren';

  @override
  String get shareLinkCopied => 'Link kopiert';

  @override
  String get couldNotGenerate => 'Das Rätsel konnte nicht erstellt werden';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get generating => 'Rätsel wird erstellt…';

  @override
  String get generatingSlow => 'Ein gutes Feld zu finden kann ein paar Sekunden dauern.';

  @override
  String get tapToCycle => 'Durchtippen';

  @override
  String get palette => 'Palette';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String get hint => 'Tipp';

  @override
  String get submit => 'Prüfen';

  @override
  String get erase => 'Löschen';

  @override
  String get pencilMarks => 'Notizen';

  @override
  String get solved => 'Gelöst!';

  @override
  String scoreValue(Object score) {
    return 'Punkte: $score';
  }

  @override
  String get newBest => 'neuer Rekord!';

  @override
  String bestValue(Object value) {
    return 'Rekord $value';
  }

  @override
  String hintsUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tipps',
      one: '$count Tipp',
    );
    return '$_temp0';
  }

  @override
  String get home => 'Start';

  @override
  String get copyResult => 'Ergebnis zum Teilen kopieren';

  @override
  String get resultCopied => 'Ergebnis kopiert, schick es einem Freund';

  @override
  String shareSolved(int hints, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: 'Ich habe „$name“ in $time mit $hints Tipps gelöst.',
      one: 'Ich habe „$name“ in $time mit 1 Tipp gelöst.',
      zero: 'Ich habe „$name“ in $time gelöst.',
    );
    return '$_temp0';
  }

  @override
  String shareScored(int hints, Object score, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: 'Ich habe in „$name“ $score Punkte in $time mit $hints Tipps erreicht.',
      one: 'Ich habe in „$name“ $score Punkte in $time mit 1 Tipp erreicht.',
      zero: 'Ich habe in „$name“ $score Punkte in $time erreicht.',
    );
    return '$_temp0';
  }

  @override
  String get shareChallenge => 'Schaffst du es besser?';

  @override
  String get paste => 'Einfügen';

  @override
  String get play => 'Spielen';

  @override
  String couldNotOpenLink(Object error) {
    return 'Der Link konnte nicht geöffnet werden: $error';
  }

  @override
  String codeExpected(Object example) {
    return 'Erwartet wird ein Code wie $example';
  }

  @override
  String codeUnknownPuzzle(Object id) {
    return 'Unbekanntes Rätsel „$id“';
  }

  @override
  String codeNoSize(Object name, Object size) {
    return '„$name“ hat keine Größe $size';
  }

  @override
  String codeNoDifficulty(Object level, Object name) {
    return '„$name“ hat keine Schwierigkeit „$level“';
  }

  @override
  String codeBadSeed(Object seed) {
    return 'Ungültiger Seed „$seed“';
  }

  @override
  String codeBadVersion(Object version) {
    return 'Ungültige Version „$version“';
  }

  @override
  String get codeOtherVersion =>
      'Dieser Code stammt aus einer anderen App-Version, das Rätsel würde nicht übereinstimmen';

  @override
  String codeNoOption(Object choice, Object name) {
    return '„$name“ hat keine Option „$choice“';
  }

  @override
  String codeNoChoice(Object choice, Object name, Object option) {
    return '„$name“: $option hat keine Auswahl „$choice“';
  }

  @override
  String get valueSun => 'Sonne';

  @override
  String get valueMoon => 'Mond';

  @override
  String get valueDot => 'Punkt';

  @override
  String get valueCrown => 'Krone';

  @override
  String get valueShade => 'Schattieren';

  @override
  String get valueGrass => 'Gras';

  @override
  String get valueTent => 'Zelt';

  @override
  String get valueSea => 'Meer';

  @override
  String get valueLamp => 'Lampe';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorPink => 'Rosa';

  @override
  String get colorYellow => 'Gelb';

  @override
  String get colorGreen => 'Grün';

  @override
  String get outOfMoves => 'Keine Züge mehr: rückgängig machen oder neu starten';

  @override
  String movesOfLimit(Object moves, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit Züge',
      one: '$limit Zug',
    );
    return '$moves / $_temp0';
  }

  @override
  String get bondsCantCross => 'Bindungen dürfen sich nicht kreuzen';

  @override
  String get mamboName => 'Sonne & Mond';

  @override
  String get mamboTagline => 'Bring Sonnen und Monde ins Gleichgewicht';

  @override
  String get mamboRules =>
      '• Fülle jedes Feld mit einer Sonne oder einem Mond.\n• Höchstens 2 gleiche Symbole nebeneinander in einer Zeile oder Spalte.\n• Jede Zeile und Spalte hat gleich viele Sonnen und Monde.\n• „=“ zwischen zwei Feldern: Sie enthalten dasselbe Symbol.\n• „×“ zwischen zwei Feldern: Sie enthalten verschiedene Symbole.\n• Gesperrte Felder sind vorgegeben.\n\nTippe auf ein Feld, um zu wechseln: leer → Sonne → Mond. Langes Drücken / Rechtsklick wechselt zurück.';

  @override
  String get sudokuName => 'Sudoku';

  @override
  String get sudokuTagline => 'Jede Zahl einmal pro Zeile, Spalte und Block';

  @override
  String get sudokuRules =>
      '• Fülle jedes Feld mit einer Zahl von 1 bis N (N = Gittergröße).\n• Jede Zahl kommt in jeder Zeile, jeder Spalte und jedem Block genau einmal vor.\n• Vorgegebene Zahlen sind fest.\n\nWähle eine Zahl in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Zahl. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld.';

  @override
  String get kingsName => 'Kronen';

  @override
  String get kingsTagline => 'Eine Krone pro Zeile, Spalte und Bereich';

  @override
  String get kingsRules =>
      '• Setze genau eine Krone in jede Zeile, jede Spalte und jeden farbigen Bereich.\n• Kronen dürfen sich nicht berühren, auch nicht diagonal.\n\nTippe auf ein Feld, um zu wechseln: leer → Punkt (deine Notiz „keine Krone hier“) → Krone. Rechtsklick wechselt zurück. Wische über Felder, um sie alle auf einmal zu markieren. Langes Drücken setzt Punkte in alle Felder, in denen wegen der gesetzten Kronen keine Krone mehr stehen kann.';

  @override
  String get huesName => 'Farbtöne';

  @override
  String get huesTagline => 'Zähle passende Farben um jede Zahl';

  @override
  String get huesRules =>
      '• Färbe jedes leere Feld mit den Farben der Palette.\n• Jedes Zahlenfeld zeigt, wie viele der leeren Felder um es herum (alle 8 Nachbarn, auch diagonal) am Ende dieselbe Farbe wie das Zahlenfeld haben.\n• Die Zahl zählt herunter, während du passende Nachbarn färbst, und zeigt so, wie viele noch fehlen.\n• Zahlenfelder selbst zählen nie mit.\n\nWähle eine Farbe in der Palette und tippe auf Felder, um sie zu färben (erneutes Tippen leert sie), oder tippe auf ein Feld, um die Farben durchzugehen.';

  @override
  String get mosaicName => 'Mosaik';

  @override
  String get mosaicTagline => 'Flute das Brett mit einer Farbe';

  @override
  String get mosaicRules =>
      '• Der farbige Bereich in der oberen linken Ecke gehört dir.\n• Wähle eine Farbe: Dein Bereich nimmt diese Farbe an und schluckt alle angrenzenden Felder derselben Farbe.\n• Färbe das ganze Brett innerhalb des Zuglimits in einer Farbe.\n\nTippe auf eine Farbe in der Palette oder auf ein beliebiges Feld, um dessen Farbe zu nutzen.';

  @override
  String get blendName => 'Fusion';

  @override
  String get blendTagline => 'Übermale Flecken, bis eine Farbe bleibt';

  @override
  String get blendRules =>
      '• Das Brett besteht aus farbigen Flecken (angrenzende Felder derselben Farbe).\n• Wähle eine Farbe und tippe auf einen beliebigen Fleck, um ihn zu übermalen. Er verschmilzt mit allen angrenzenden Flecken dieser Farbe.\n• Färbe das ganze Brett innerhalb des Zuglimits in einer Farbe.\n\nDie Farbe in der Palette bleibt ausgewählt, sodass du mehrere Flecken hintereinander übermalen kannst.';

  @override
  String get popName => 'Blasen';

  @override
  String get popTagline => 'Große Blasengruppen bringen viele Punkte';

  @override
  String get popRules =>
      '• Tippe auf eine Gruppe von 2 oder mehr angrenzenden Blasen einer Farbe, um sie auszuwählen; tippe erneut, um sie platzen zu lassen.\n• Eine Gruppe von n Blasen bringt n × (n − 1) Punkte, große Gruppen lohnen sich also.\n• Blasen darüber fallen nach unten, und leere Spalten rücken nach rechts zusammen.\n\nModi\n• Standard: nur das.\n• Schieber: Jede Zeile rutscht außerdem nach rechts, um Lücken zu schließen.\n• Endlos: Neue Spalten rollen von links herein, sobald Platz frei wird.\n• Mega: Schieber und Endlos zusammen.\n\nZiele\n• Brett leeren: Lass alle Blasen platzen (nur Standard; es gibt immer einen Weg).\n• Zielpunktzahl: Erreiche die Punktzahl, bevor keine Züge mehr übrig sind.\n• Freies Spiel: kein Ziel, schlag einfach deinen Rekord.\n\nDas Spiel endet, wenn keine Zweiergruppe mehr übrig ist.';

  @override
  String get popMode => 'Modus';

  @override
  String get popModeStandard => 'Standard';

  @override
  String get popModeStandardHint => 'Blasen fallen nach unten; leere Spalten rücken nach rechts zusammen.';

  @override
  String get popModeShifter => 'Schieber';

  @override
  String get popModeShifterHint => 'Zeilen rutschen außerdem nach rechts und schließen jede Lücke.';

  @override
  String get popModeContinuous => 'Endlos';

  @override
  String get popModeContinuousHint => 'Neue Spalten rollen von links herein, sobald Platz frei wird.';

  @override
  String get popModeMega => 'Mega';

  @override
  String get popModeMegaHint => 'Schieber und Endlos zusammen.';

  @override
  String get popGoal => 'Ziel';

  @override
  String get popGoalClear => 'Brett leeren';

  @override
  String get popGoalClearHint => 'Lass alle Blasen platzen. Es gibt immer einen Weg.';

  @override
  String get popGoalTarget => 'Zielpunktzahl';

  @override
  String get popGoalTargetHint => 'Erreiche das Ziel, bevor keine Züge mehr übrig sind.';

  @override
  String get popGoalFree => 'Freies Spiel';

  @override
  String get popGoalFreeHint => 'Kein Ziel: Spiel bis zum Ende und schlag deinen Rekord.';

  @override
  String get popCleared => 'Geleert!';

  @override
  String get popTargetReached => 'Ziel erreicht!';

  @override
  String get popGameOver => 'Spiel vorbei';

  @override
  String popStuckBubbles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Keine Züge mehr, $count Blasen sind übrig: rückgängig machen oder neu starten',
      one: 'Keine Züge mehr, $count Blase ist übrig: rückgängig machen oder neu starten',
    );
    return '$_temp0';
  }

  @override
  String popStuckPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Keine Züge mehr, $count Punkte fehlen: rückgängig machen oder neu starten',
      one: 'Keine Züge mehr, $count Punkt fehlt: rückgängig machen oder neu starten',
    );
    return '$_temp0';
  }

  @override
  String popPoints(Object score) {
    return '$score Pkt.';
  }

  @override
  String popLeft(Object count) {
    return '$count übrig';
  }

  @override
  String popColumns(Object count) {
    return '+$count Sp.';
  }

  @override
  String get mergeName => '2048';

  @override
  String get mergeTagline => 'Schieb die Kacheln, verschmelze Paare, bau die große';

  @override
  String get mergeRules =>
      '• Wische (oder drück eine Pfeiltaste), um alle Kacheln so weit wie möglich in diese Richtung zu schieben.\n• Zwei Kacheln mit derselben Zahl, die aufeinandertreffen, verschmelzen zu einer mit ihrer Summe. Pro Zug verschmilzt eine Kachel nur einmal.\n• Nach jedem Zug erscheint auf einem leeren Feld eine neue 2 (manchmal eine 4).\n• Jede Verschmelzung bringt so viele Punkte, wie auf der neuen Kachel steht.\n\nZiele\n• Bau die Kachel: Erreiche die Zielkachel (sie hängt von Feldgröße und Schwierigkeit ab).\n• Freies Spiel: Spiel, bis das Feld blockiert ist, und schlag deinen Rekord.\n\nDas Spiel endet, wenn das Feld voll ist und keine Nachbarn zusammenpassen.';

  @override
  String get mergeGoalTarget => 'Bau die Kachel';

  @override
  String get mergeGoalTargetHint => 'Erreiche die Zielkachel, bevor das Feld blockiert ist.';

  @override
  String get mergeGoalFreeHint => 'Ohne Ziel: Spiel, bis das Feld blockiert ist, und schlag deinen Rekord.';

  @override
  String mergeReached(int tile) {
    return '$tile!';
  }

  @override
  String get mergeStuck => 'Keine Züge mehr: rückgängig machen oder neu starten';

  @override
  String mergeBest(int tile) {
    return 'Max. $tile';
  }

  @override
  String get snakeName => 'Schlange';

  @override
  String get snakeTagline => 'Friss die Äpfel, wachse und beiß dir nicht in den Schwanz';

  @override
  String get snakeRules =>
      '• Die Schlange bewegt sich von selbst. Wische (oder drück eine Pfeiltaste), um sie zu lenken.\n• Jeder Apfel macht sie ein Feld länger und bringt einen Punkt. Mit der Länge wird sie etwas schneller.\n• Ein Zusammenstoß mit einer Wand oder mit sich selbst beendet das Spiel.\n• Tippe aufs Feld (oder drück die Leertaste) für eine Pause und wische, um weiterzuspielen.\n\nZiele\n• Freies Spiel: Friss so viele Äpfel wie möglich und schlag deinen Rekord.\n• Apfelziel: Friss die vorgegebene Zahl an Äpfeln (mehr auf größeren Feldern und höheren Stufen), ohne zu verunglücken.\n\nDie Schwierigkeit bestimmt das Tempo.';

  @override
  String get snakeGoalTarget => 'Apfelziel';

  @override
  String get snakeGoalTargetHint => 'Friss eine vorgegebene Zahl an Äpfeln, ohne zu verunglücken.';

  @override
  String get snakeGoalFreeHint => 'Ohne Ziel: Friss so viele Äpfel wie möglich, bevor du verunglückst.';

  @override
  String snakeFed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Äpfel!',
      one: '$count Apfel!',
    );
    return '$_temp0';
  }

  @override
  String get snakeFull => 'Das Feld ist voll!';

  @override
  String snakeApples(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Äpfel',
      one: '$count Apfel',
    );
    return '$_temp0';
  }

  @override
  String snakeLength(int count) {
    return 'Länge $count';
  }

  @override
  String get snakeStart => 'Wische zum Starten';

  @override
  String get snakePaused => 'Pause: Wische zum Weiterspielen';

  @override
  String get snakeCrashed => 'Zusammenstoß! Tippe für einen neuen Versuch';

  @override
  String get junctionName => 'Weichensteller';

  @override
  String get junctionTagline => 'Stell die Weichen und schick jeden Zug zu seinem Bahnhof';

  @override
  String get junctionRules =>
      '• Die Züge kommen einer nach dem anderen aus dem Tunnel und fahren von selbst über die Gleise.\n• Jeder Zug trägt ein Symbol, sein Bahnhof dasselbe.\n• An einer Weiche teilt sich das Gleis. Tippe auf eine Weiche, um sie umzustellen: Der Hebel zeigt auf den Zweig, den der nächste Zug nimmt. Ein Zug nimmt den Zweig, auf den die Weiche steht, wenn er über sie fährt.\n• Ein Zug an seinem eigenen Bahnhof bringt einen Punkt, einer an einem fremden Bahnhof ist ein Fehler.\n• Tippe woanders aufs Feld (oder drück die Leertaste) für eine Pause, und tippe, um weiterzuspielen.\n\nZiele\n• 20 Züge: Leite eine feste Zahl Züge und bring so viele wie möglich zu ihrem Bahnhof.\n• Auf Zeit: Bring in zwei Minuten so viele Züge wie möglich zu ihrem Bahnhof.\n\nDer Schwierigkeitsgrad bestimmt das Tempo, wie oft Züge abfahren und wie viele Bahnhöfe es gibt; größere Felder haben mehr Weichen.';

  @override
  String junctionGoalTrains(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Züge',
      one: '$count Zug',
    );
    return '$_temp0';
  }

  @override
  String get junctionGoalTrainsHint => 'Leite eine feste Zahl Züge und bring so viele wie möglich zu ihrem Bahnhof.';

  @override
  String junctionGoalTimed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '$count Minute',
    );
    return '$_temp0';
  }

  @override
  String get junctionGoalTimedHint => 'Bring so viele Züge wie möglich zu ihrem Bahnhof, bevor die Zeit abläuft.';

  @override
  String junctionFinished(int count, int total) {
    return '$count von $total Zügen am Ziel';
  }

  @override
  String get junctionTimeUp => 'Die Zeit ist um!';

  @override
  String junctionArrived(int count) {
    return 'Am Ziel: $count';
  }

  @override
  String junctionMisses(int count) {
    return 'Fehler: $count';
  }

  @override
  String get junctionStart => 'Tippe zum Starten';

  @override
  String get junctionPaused => 'Pause: Tippe zum Weiterspielen';

  @override
  String get junctionWrong => 'Falscher Bahnhof! Tippe für einen neuen Versuch';

  @override
  String get turnaboutName => 'Karussell';

  @override
  String get turnaboutTagline => 'Sei vor dem Rivalen am Stern, in einem Labyrinth, das sich ständig dreht';

  @override
  String get turnaboutRules =>
      '• Du und ein Rivale startet in gegenüberliegenden Ecken eines Labyrinths, dazwischen liegt ein Stern, von beiden gleich weit entfernt.\n• Wische (oder drücke eine Pfeiltaste), um ein Feld weiterzugehen; wische weiter, um weiterzulaufen. Der Rivale läuft den kürzesten Weg in seinem eigenen Tempo.\n• Alle paar Sekunden macht das ganze Labyrinth eine Vierteldrehung (auf schwer manchmal eine halbe). Ein Pfeil warnt kurz vorher. Die Richtungen bleiben am Bildschirm: Oben ist immer oben auf dem Bildschirm.\n• Wer zuerst am Stern ist, gewinnt die Runde. Jede Runde ist ein neues Labyrinth.\n• Tippe aufs Feld (oder drücke die Leertaste), um zu pausieren.\n\nZiele\n• 5 Runden: Gewinne so viele Runden wie möglich.\n• 3 Leben: Spiele, bis der Rivale drei Runden gewonnen hat; mit deinen Siegen wird er etwas schneller.\n\nDer Schwierigkeitsgrad bestimmt das Tempo des Rivalen, die Labyrinthe und wie oft sie sich drehen.';

  @override
  String get turnaboutGoalRoundsHint => 'Spiele eine feste Zahl von Runden und gewinne so viele wie möglich.';

  @override
  String turnaboutGoalLivesHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Runden',
      one: 'eine Runde',
    );
    return 'Spiele, bis der Rivale $_temp0 gewonnen hat; mit deinen Siegen wird er schneller. Schlag deinen Rekord.';
  }

  @override
  String turnaboutFinished(int count, int total) {
    return '$count von $total Runden gewonnen';
  }

  @override
  String turnaboutStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Runden gewonnen',
      one: '1 Runde gewonnen',
      zero: 'Keine Runde gewonnen',
    );
    return '$_temp0';
  }

  @override
  String turnaboutRound(int round) {
    return 'Runde $round';
  }

  @override
  String turnaboutScore(int wins, int losses) {
    return 'Du $wins : $losses Rivale';
  }

  @override
  String get turnaboutStart => 'Wische, um zu starten';

  @override
  String get turnaboutPaused => 'Pause: Wische, um weiterzumachen';

  @override
  String get turnaboutWon => 'Der Stern gehört dir! Wische für die nächste Runde';

  @override
  String get turnaboutLost => 'Der Rivale war schneller. Wische für die nächste Runde';

  @override
  String get turnaboutLostPractice => 'Der Rivale war schneller! Tippe für einen neuen Versuch';

  @override
  String get pipesName => 'Rohre';

  @override
  String get pipesTagline => 'Verbinde jedes Rohr mit der Quelle';

  @override
  String get pipesRules =>
      '• Drehe die Kacheln so, dass jedes Rohr mit der Quelle (der Kachel mit Ring) verbunden ist.\n• Kein Rohrende darf offen bleiben, und das Netz darf keine Schleifen enthalten.\n• Wasser fließt durch alles, was bereits mit der Quelle verbunden ist.\n• Kacheln mit einem Punkt in der Ecke sind fest und schon an ihrem Platz.\n\nTippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen; langes Drücken / Rechtsklick dreht sie zurück.';

  @override
  String get famPlumbing => 'Wasserleitungen';

  @override
  String get famPlumbingAbout => 'Drehe die Rohrkacheln, bis das Wasser fließt, wohin es soll';

  @override
  String get channelName => 'Kanal';

  @override
  String get channelTagline => 'Leite das Wasser von der Quelle zum Abfluss';

  @override
  String get channelRules =>
      '• Drehe die Kacheln so, dass ein Rohr das Wasser von der Quelle (der Kachel mit Ring) zum Abfluss (der Kachel mit Quadrat) leitet.\n• Die übrigen Kacheln spielen keine Rolle, und Rohrenden dürfen offen bleiben.\n• Wasser verlässt eine Kachel durch alle anderen Enden, über eine Brücke (eine Kreuzung) aber nur geradeaus, sodass das Rohr eine Brücke zweimal passieren kann.\n• Kacheln mit einem Punkt in der Ecke sind fest und schon an ihrem Platz.\n\nTippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen; langes Drücken / Rechtsklick dreht sie zurück.';

  @override
  String get shikakuName => 'Shikaku';

  @override
  String get shikakuTagline => 'Teile das Gitter in nummerierte Rechtecke';

  @override
  String get shikakuRules =>
      '• Teile das ganze Gitter in Rechtecke (Quadrate zählen auch).\n• Jedes Rechteck enthält genau eine Zahl.\n• Diese Zahl ist die Fläche des Rechtecks in Feldern.\n\nZiehe von einer Ecke zur gegenüberliegenden, um ein Rechteck zu zeichnen. Tippe auf ein Rechteck, um es zu entfernen.';

  @override
  String get trailName => 'Pfad';

  @override
  String get trailTagline => 'Ein Weg durch jedes Feld, Zahlen der Reihe nach';

  @override
  String get trailRules =>
      '• Zeichne einen einzigen Pfad, der bei 1 beginnt und jedes Feld genau einmal besucht.\n• Der Pfad verläuft nach oben, unten, links oder rechts (nicht diagonal).\n• Er muss die Zahlen der Reihe nach passieren (1 → 2 → 3 → …) und auf der letzten Zahl enden.\n\nZiehe, um zu zeichnen. Ziehe auf dem Pfad zurück, um Schritte rückgängig zu machen, oder tippe auf ein Feld des Pfads, um ihn dort abzuschneiden.';

  @override
  String get atomsName => 'Atome';

  @override
  String get atomsTagline => 'Verbinde jedes Atom passend zu seiner Zahl';

  @override
  String get atomsRules =>
      '• Verbinde die Atome mit waagerechten oder senkrechten Bindungen.\n• Jedes Atom braucht genau so viele Bindungen, wie seine Zahl angibt.\n• Zwei Atome können eine oder zwei Bindungen teilen.\n• Bindungen dürfen sich nicht kreuzen und nicht durch Atome verlaufen.\n• Alle Atome müssen am Ende zu einem Molekül verbunden sein.\n\nZiehe von einem Atom zu einem Nachbarn, um eine Bindung hinzuzufügen (1 → 2 → keine). Du kannst auch auf den Raum zwischen zwei Atomen tippen.';

  @override
  String get litsName => 'Tetra';

  @override
  String get litsTagline => 'Ein Tetromino in jedem Bereich';

  @override
  String get litsRules =>
      '• Schattiere in jedem umrandeten Bereich genau 4 verbundene Felder, die eine L-, I-, T- oder S-Form bilden (Drehungen und Spiegelungen erlaubt).\n• Alle schattierten Felder bilden zusammen eine zusammenhängende Fläche.\n• Kein 2×2-Block darf vollständig schattiert sein.\n• Zwei gleiche Formen dürfen sich nicht über eine Bereichsgrenze hinweg berühren.\n\nTippe auf ein Feld, um zu wechseln: leer → schattiert → Punkt (deine Notiz „nicht schattiert“).';

  @override
  String get labyrinthName => 'Labyrinth';

  @override
  String get labyrinthTagline => 'Finde den Weg von Ecke zu Ecke';

  @override
  String get labyrinthRules =>
      '• Finde den Weg durch das Labyrinth vom Eingang in der linken oberen Ecke zum Ausgang in der rechten unteren Ecke.\n• Durch Wände kommst du nicht hindurch.\n\nZiehe vom Ende deines Wegs aus, um weiterzugehen. Ziehe zurück, um umzukehren, oder tippe auf ein Feld des Wegs, um dorthin zurückzugehen.';

  @override
  String get tagDrive => 'fahren, Auto, Taxi, abholen, liefern, Haustiere, Tiere, Benzin, Tank, Route';

  @override
  String get homewardName => 'Heimwärts';

  @override
  String get homewardTagline => 'Bring alle Tiere nach Hause, bevor das Benzin ausgeht';

  @override
  String get homewardRules =>
      '• Fahre mit dem Auto über die Straßen. Jedes Straßenstück zwischen zwei Kreuzungen kostet eine Einheit Benzin.\n• Fahre zu einem Tier, um es abzuholen, und dann zum Haus mit demselben Symbol, um es abzusetzen. Beides geschieht von selbst.\n• Das Auto hat nur wenige Plätze: Ein Tier, das du erreichst, während alle Plätze besetzt sind, wartet weiter. Ist ein Platz frei, steigt es immer ein.\n• Bring alle Tiere nach Hause, bevor das Benzin ausgeht.\n\nTippe auf eine Kreuzung neben dem Auto oder weiter entlang einer geraden Straße, um dorthin zu fahren. Oder ziehe entlang der Straßen. Geht das Benzin aus, mache Züge rückgängig oder starte neu.';

  @override
  String homewardFuel(int left, int limit) {
    return 'Benzin $left / $limit';
  }

  @override
  String get homewardOutOfFuel => 'Kein Benzin mehr: rückgängig machen oder neu starten';

  @override
  String get tutHomeward1 =>
      'Tippe auf eine Kreuzung neben dem Auto, um dorthin zu fahren. Jedes Straßenstück kostet eine Einheit Benzin. Fahre zum Tier, um es abzuholen, und bring es zum Haus mit demselben Symbol.';

  @override
  String get tutHomeward2 =>
      'Dieses Auto hat einen Platz. Ein Tier, das du erreichst, während der Platz besetzt ist, wartet weiter. Bring also erst ein Tier nach Hause, bevor du das nächste holst. Bring beide nach Hause.';

  @override
  String get tutHomeward3 =>
      'Jetzt ist kein Benzin übrig, und das Auto hat zwei Plätze. Zum nächsten Tier zu eilen ist nicht immer am besten: Plane eine Fahrt, die erst beide Tiere abholt und dann an beiden Häusern vorbeikommt.';

  @override
  String get tutHomeward4 =>
      'Jetzt ein echtes Brett. Sieh vor der Abfahrt nach, wo jedes Tier wohnt, und plane eine Fahrt, die unterwegs an Tieren und Häusern vorbeikommt.';

  @override
  String get tutHomewardS1 =>
      'Verbinde die Fahrten: Plane so, dass jedes Absetzen auf dem Weg zum nächsten Tier liegt, und hole ein Tier früh ab, wenn sein Haus an einer Strecke liegt, die du ohnehin fährst. Auf diesem Brett ist kein Benzin übrig.';

  @override
  String get tutHomewardS2 =>
      'Schwere Bretter lassen kein Benzin übrig, und das Auto hat nur zwei Plätze. Plane die ganze Fahrt vor dem ersten Straßenstück: Ein zu früh besetzter Platz lässt dich an einem Tier vorbeifahren, das du brauchst. Fahre deshalb manchmal auf einer anderen Straße um ein Tier herum.';

  @override
  String get blockadeName => 'Blockade';

  @override
  String get blockadeTagline => 'Schlüpf an den Patrouillenschiffen vorbei in den Hafen';

  @override
  String get blockadeRules =>
      '• Bring das Boot in den Hafen. In jedem Zug fährt das Boot ein Feld weit (nach oben, unten, links oder rechts) oder wartet, wo es ist. Felsen versperren den Weg.\n• Nach jedem Zug fährt jedes Patrouillenschiff ein Feld auf seiner Route weiter: auf einer Linie hin und her oder immer im Kreis. Die Route ist auf dem Brett eingezeichnet, und ein Ring zeigt, wo das Schiff nach deinem nächsten Zug sein wird.\n• Lass dich nicht erwischen: Beende nie einen Zug auf dem Feld eines Schiffs, und tausche nie mit einem Schiff die Plätze. Kein Schiff fährt je auf den Start oder in den Hafen.\n• Erreiche den Hafen mit den Zügen, die du hast.\n\nTippe auf ein Feld neben dem Boot, um dorthin zu fahren, oder ziehe. Tippe auf das Boot oder auf „Warten“, um einen Zug auszusetzen. Auf der Tastatur: Pfeiltasten und Leertaste. Wenn du erwischt wirst oder keine Züge mehr hast, mach rückgängig oder starte neu.';

  @override
  String blockadeTurn(int turn, int limit) {
    return 'Zug $turn / $limit';
  }

  @override
  String get blockadeWait => 'Warten';

  @override
  String get blockadeCaught => 'Von einer Patrouille erwischt: rückgängig machen oder neu starten';

  @override
  String get blockadeOutOfTurns => 'Keine Züge mehr: rückgängig machen oder neu starten';

  @override
  String get tutBlockade1 =>
      'Tippe auf ein Feld neben dem Boot, um dorthin zu fahren: ein Feld pro Zug. Felsen versperren den Weg. Fahr in den Hafen.';

  @override
  String get tutBlockade2 =>
      'Nach jedem deiner Züge fährt jedes Patrouillenschiff ein Feld auf seiner Route weiter, und der Ring zeigt, wohin es als Nächstes fährt. Beende keinen Zug dort, wo ein Schiff sein wird, und tausche nicht mit einem die Plätze. Tippe auf das Boot oder auf „Warten“, um einen Zug auszusetzen.';

  @override
  String get tutBlockade3 =>
      'Dieses Schiff fährt immer um die Insel herum, und es gibt keinen Zug zu viel: Der Zähler zeigt, wie viele du hast. Der kurze Weg führt dem Schiff direkt entgegen, und zum Warten ist keine Zeit. Fahr auf der anderen Seite um die Insel, dicht hinter dem Schiff her.';

  @override
  String get tutBlockade4 =>
      'Jetzt ein echtes Brett. Sieh vor dem Ablegen nach, wohin jedes Schiff fährt, und plane, wann du an jedem vorbeikommst.';

  @override
  String get tutBlockadeS1 =>
      'Ein Schiff überrascht dich nie: Die Punkte zeigen seine ganze Route und der Ring, wo es nach deinem Zug sein wird. In ein Feld, das ein Schiff gerade verlässt, darfst du fahren, solange es nicht auf das Feld fährt, das du verlässt. Hier gibt es keinen Zug zu viel: Zähle den Takt der Schiffe und schlüpf durch die Lücken.';

  @override
  String get tutBlockadeS2 =>
      'Schwere Bretter lassen keinen Zug übrig. Plane die ganze Fahrt vor dem ersten Zug: Wenn du warten musst, warte dort, wo kein Schiff hinkommt, und ein Umweg dicht hinter einem Schiff ist oft besser, als auf es zu warten.';

  @override
  String get campName => 'Zeltplatz';

  @override
  String get campTagline => 'Stell neben jeden Baum ein Zelt';

  @override
  String get campRules =>
      '• Stell für jeden Baum ein Zelt direkt daneben auf (oben, unten, links oder rechts).\n• Jeder Baum bekommt sein eigenes Zelt, und jedes Zelt gehört zu einem Baum daneben.\n• Zelte berühren sich nie, auch nicht diagonal.\n• Die Zahlen außerhalb des Gitters geben an, wie viele Zelte in jeder Zeile und Spalte stehen.\n\nTippe auf ein Feld, um zu wechseln: leer → Gras (deine Notiz „kein Zelt hier“) → Zelt. Rechtsklick wechselt zurück. Wische über Felder, um sie alle auf einmal zu markieren. Langes Drücken legt Gras auf alle Felder, auf denen wegen der aufgestellten Zelte kein Zelt mehr stehen kann.';

  @override
  String get islandsName => 'Inseln';

  @override
  String get islandsTagline => 'Flute das Meer um die nummerierten Inseln';

  @override
  String get islandsRules =>
      '• Schattiere das Meer so, dass die freien Felder Inseln bilden.\n• Jede Insel enthält genau eine Zahl, und die ist ihre Größe in Feldern.\n• Inseln grenzen nur ans Meer, nie aneinander (diagonale Ecken sind erlaubt).\n• Das ganze Meer hängt zusammen und hat keine 2×2-Becken.\n\nTippe auf ein Feld, um zu wechseln: leer → Meer → Punkt (deine Notiz „Land“). Langes Drücken / Rechtsklick wechselt zurück.';

  @override
  String get minesName => 'Minen';

  @override
  String get minesTagline => 'Finde alle Minen, nur mit Logik';

  @override
  String get minesRules =>
      '• Öffne jedes Feld ohne Mine.\n• Eine Zahl gibt an, wie viele Minen in den 8 Feldern um sie herum liegen.\n• Raten ist nie nötig: Jedes Feld lässt sich mit Logik räumen.\n• Ein geöffnetes Feld ohne Minen ringsum öffnet auch seine Nachbarn.\n\nTippe auf ein Feld, um zu graben, langes Drücken / Rechtsklick setzt eine Flagge (oder wechsle unten zu „Flagge“). Tippe auf eine Zahl, deren Flaggen alle gesetzt sind, um den Rest ringsum aufzugraben. Eine ausgegrabene Mine knallt und bekommt eine Flagge, dann geht das Spiel weiter.';

  @override
  String get minesDig => 'Graben';

  @override
  String get minesFlag => 'Flagge';

  @override
  String get minesBoom => 'Bumm! Das war eine Mine, jetzt hat sie eine Flagge';

  @override
  String get lampsName => 'Lampen';

  @override
  String get lampsTagline => 'Beleuchte jedes Feld, Lampen scheinen nie aufeinander';

  @override
  String get lampsRules =>
      '• Setze Lampen auf leere Felder (nicht auf Wände). Eine Lampe beleuchtet ihr Feld sowie ihre Zeile und Spalte bis zur nächsten Wand.\n• Jedes leere Feld muss beleuchtet sein.\n• Keine Lampe darf auf eine andere Lampe scheinen.\n• Eine Zahl auf einer Wand gibt an, wie viele Lampen direkt daneben stehen (oben, unten, links oder rechts).\n\nTippe auf ein Feld, um zu wechseln: leer → Punkt (deine Notiz „keine Lampe“) → Lampe. Langes Drücken / Rechtsklick wechselt zurück.';

  @override
  String get fenceName => 'Zaun';

  @override
  String get fenceTagline => 'Eine Schleife, die um die Zahlen passt';

  @override
  String get fenceRules =>
      '• Zeichne eine geschlossene Schleife entlang der gepunkteten Linien.\n• Die Schleife kreuzt und berührt sich nirgends selbst.\n• Eine Zahl gibt an, wie viele der vier Seiten ihres Feldes die Schleife benutzt. Felder ohne Zahl dürfen beliebig viele haben.\n\nTippe zwischen zwei Punkte, um eine Linie zu ziehen, noch einmal für ein Kreuz und ein drittes Mal zum Löschen. Ziehe von Punkt zu Punkt, um mehrere Linien zu zeichnen, oder um sie zu löschen, wenn du auf einer Linie beginnst.';

  @override
  String get pearlsName => 'Perlen';

  @override
  String get pearlsTagline => 'Fädle eine Schleife durch alle Perlen';

  @override
  String get pearlsRules =>
      '• Zeichne eine geschlossene Schleife durch die Mitten der Felder. Sie kreuzt und berührt sich nicht selbst und muss nicht durch jedes Feld laufen.\n• Die Schleife läuft durch jede Perle.\n• An einer schwarzen Perle biegt sie ab und läuft in den Feldern davor und danach geradeaus.\n• Durch eine weiße Perle läuft sie geradeaus und biegt im Feld davor oder danach (oder in beiden) ab.\n\nZiehe durch Felder, um die Schleife zu zeichnen, oder an ihr entlang, um sie zu löschen. Tippe zwischen zwei Felder, um zu wechseln: Linie → Kreuz → leer.';

  @override
  String get railsName => 'Gleise';

  @override
  String get railsTagline => 'Verlege ein Gleis von der Einfahrt zur Ausfahrt';

  @override
  String get railsRules =>
      '• Verlege ein Gleis durch die Mitten der Felder, von der Einfahrt am linken Rand zur Ausfahrt am unteren Rand.\n• Das Gleis verzweigt sich nicht, kreuzt sich nicht und schließt sich nicht zu einer Schleife. Es muss nicht durch jedes Feld laufen.\n• Die Zahlen über und rechts neben dem Gitter geben an, durch wie viele Felder jeder Spalte und Zeile das Gleis läuft.\n• Stücke, die schon auf dem Gitter liegen, sind fest: Das Gleis läuft genau so hindurch, wie gezeigt.\n\nZiehe durch Felder, um Gleis zu verlegen, oder an ihm entlang, um es zu löschen. Tippe auf die Mitte eines Felds, um zu wechseln: leer → Gleisnotiz → Punkt (deine Notiz „hier kein Gleis“), oder zwischen zwei Felder, um zu wechseln: Gleis → Kreuz → leer.';

  @override
  String get blocksName => 'Blöcke';

  @override
  String get blocksTagline => 'Zahlen von 1 bis k in jedem Bereich aus k Feldern';

  @override
  String get blocksRules =>
      '• Fülle jedes Feld mit einer Zahl.\n• Ein Bereich aus k Feldern enthält jede Zahl von 1 bis k genau einmal (ein Bereich aus einem Feld enthält eine 1).\n• Gleiche Zahlen berühren sich nie, auch nicht diagonal.\n• Vorgegebene Zahlen sind fest.\n\nWähle eine Zahl in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Zahl. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld.';

  @override
  String get pairsName => 'Paare';

  @override
  String get pairsTagline => 'Zwei schattierte Felder nebeneinander in jedem Bereich';

  @override
  String get pairsRules =>
      '• Schattiere in jedem umrandeten Bereich genau zwei Felder.\n• Jedes schattierte Feld berührt seitlich genau ein anderes schattiertes Feld, die Schattierung besteht also aus Paaren.\n• Paare berühren einander nie seitlich (an den Ecken schon).\n\nTippe auf ein Feld, um zu wechseln: leer → schattiert → Punkt (deine Notiz „nicht schattiert“). Rechtsklick wechselt zurück. Wische über Felder, um sie alle auf einmal zu markieren. Langes Drücken setzt Punkte in alle Felder, die wegen der fertigen Paare nicht mehr schattiert werden können.';

  @override
  String get plotsName => 'Parzellen';

  @override
  String get plotsTagline => 'Teile das Gitter in Parzellen so groß wie ihre Zahlen';

  @override
  String get plotsRules =>
      '• Fülle jedes Feld mit einer Zahl.\n• Gleiche Zahlen, die sich seitlich berühren, bilden eine Parzelle, und eine Parzelle hat genau so viele Felder wie ihre Zahl: Eine 3 liegt in einer Parzelle aus drei Feldern.\n• Zwei gleich große Parzellen berühren sich nie seitlich (sonst wären sie eine).\n• Manche Parzellen zeigen gar keine Zahl.\n\nWähle eine Zahl in der Palette und tippe auf Felder, um sie zu füllen, oder tippe zuerst auf ein Feld und dann auf eine Zahl. Zwischen verschiedenen Zahlen erscheinen Linien, so siehst du die Parzellen entstehen.';

  @override
  String get linksName => 'Verbindungen';

  @override
  String get linksTagline => 'Verbinde die Paare und fülle das Gitter';

  @override
  String get linksRules =>
      '• Verbinde jedes Paar gleicher Punkte mit einem Weg durch benachbarte Felder (nicht diagonal).\n• Wege kreuzen sich nicht, verzweigen sich nicht und teilen sich keine Felder.\n• Zusammen füllen die Wege jedes Feld des Gitters.\n\nZiehe von einem Punkt aus, um seinen Weg zu zeichnen; ein Weg quer über einen anderen schneidet diesen ab. Tippe auf einen Punkt, um seinen Weg zu löschen, oder auf ein Feld eines Wegs, um ihn dort zu kürzen.';

  @override
  String get arrowsName => 'Pfeile';

  @override
  String get arrowsTagline => 'Schattiere, was die Pfeile zählen, und umrunde den Rest';

  @override
  String get arrowsRules =>
      '• Schattiere einige Felder. Schattierte Felder berühren sich nie seitlich.\n• Zeichne eine geschlossene Schleife durch die Mitten aller anderen Felder. Sie verzweigt und kreuzt sich nicht.\n• Hinweisfelder (Zahl und Pfeil) sind weder schattiert noch auf der Schleife. Die Zahl eines Hinweises zählt die schattierten Felder in Pfeilrichtung bis zum Rand.\n\nZiehe durch Felder, um die Schleife zu zeichnen, oder an ihr entlang, um sie zu löschen. Tippe auf die Mitte eines Felds, um zu wechseln: leer → schattiert → Punkt (deine Notiz „auf der Schleife“), oder zwischen zwei Felder, um zu wechseln: Linie → Kreuz → leer.';

  @override
  String get learnTitle => 'So wird gespielt';

  @override
  String get learnIntro =>
      'Kurze interaktive Lektionen: Jeder Schritt ist ein kleines Feld, das eine Regel oder einen Kniff zeigt.';

  @override
  String learnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schritte',
      one: '1 Schritt',
    );
    return '$_temp0';
  }

  @override
  String get learnDone => 'Gelernt';

  @override
  String tutorialOfferTitle(String name) {
    return 'Neu bei $name?';
  }

  @override
  String get tutorialOfferBody => 'Erst eine kurze interaktive Lektion? Ein paar kleine Felder zeigen dir alle Regeln.';

  @override
  String get tutorialOfferNo => 'Nein, danke';

  @override
  String get tutorialOfferYes => 'Zeig\'s mir';

  @override
  String tutorialTitle(String name) {
    return 'So spielt man $name';
  }

  @override
  String tutorialStep(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String get tutorialNice => 'Super!';

  @override
  String get tutorialNext => 'Weiter';

  @override
  String get tutorialFinish => 'Fertig';

  @override
  String get tutorialShowMe => 'Zeig\'s mir';

  @override
  String get tutorialPrevious => 'Voriger Schritt';

  @override
  String get tutorialReset => 'Schritt neu starten';

  @override
  String get tutorialFinishedTitle => 'Du hast es drauf!';

  @override
  String tutorialFinishedBody(String name) {
    return 'Das ist alles, was du für $name wissen musst.';
  }

  @override
  String get tutorialPlay => 'Jetzt spielen';

  @override
  String get tutorialAgain => 'Von vorn';

  @override
  String get tutorialClose => 'Schließen';

  @override
  String get tutorialStrategies => 'Strategien lernen';

  @override
  String strategiesTitle(String name) {
    return '$name: Strategien';
  }

  @override
  String strategiesFinishedBody(String name) {
    return 'Du kennst die wichtigsten Techniken für $name.';
  }

  @override
  String get learnBasicsTab => 'Grundlagen';

  @override
  String get learnStrategiesTab => 'Strategien';

  @override
  String get learnStrategiesIntro =>
      'Für alle, die die Regeln kennen: Jede Lektion zeigt eine Technik erfahrener Spieler auf einem Gitter, das sie braucht.';

  @override
  String get tutMambo1 =>
      'Fülle jedes Feld mit einer Sonne oder einem Mond. Nie drei gleiche nebeneinander: Auf zwei Sonnen nebeneinander folgt ein Mond. Tippe auf ein markiertes Feld, um zu wechseln: leer → Sonne → Mond.';

  @override
  String get tutMambo2 =>
      'Jede Zeile und Spalte hat gleich viele Sonnen und Monde. Die obere Zeile hat ihre zwei Sonnen schon, also sind ihre anderen Felder Monde. Die rechte Spalte funktioniert genauso.';

  @override
  String get tutMambo3 =>
      'Ein „=“ zwischen zwei Feldern heißt: Sie enthalten dasselbe Symbol. Gib den markierten Feldern das Symbol ihrer Nachbarn.';

  @override
  String get tutMambo4 => 'Ein „×“ heißt: Die beiden Felder sind verschieden, eine Sonne und ein Mond.';

  @override
  String get tutMambo5 =>
      'Jetzt ein ganzes Brett: Nutze alle Regeln zusammen. Tipp: Mit der Palette oben setzt du ein Symbol auf viele Felder, und langes Drücken (oder Rechtsklick) wechselt rückwärts.';

  @override
  String get tutMamboS1 =>
      'Wenn keine Regel direkt greift, frag dich: „Was wäre, wenn?“ Das markierte Paar ist mit = verbunden, beide Felder sind also gleich. Zwei Sonnen gäben der oberen Zeile drei Sonnen von vier, also sind beide Monde.';

  @override
  String get tutMamboS2 =>
      'Ein schwereres Gitter, auf dem du den Trick oft brauchst: Probier ein Symbol in einem Feld und folge den Regeln ein paar Schritte. Geht etwas kaputt, ist das andere Symbol richtig. Ein ×-Paar hat immer eins von jedem, zählt in seiner Zeile also als eine Sonne und ein Mond.';

  @override
  String get tutSudoku1 =>
      'Jede Zeile, Spalte und jeder Block (die dicken Rahmen) enthält jede Zahl von 1 bis 4 einmal. In dieser Zeile fehlt eine Zahl: Wähle sie in der Palette und tippe auf das leere Feld.';

  @override
  String get tutSudoku2 =>
      'Nach ihrer Zeile könnten diese beiden Felder 3 oder 4 sein. Die Spalten entscheiden: In jeder fehlt nur eine Zahl.';

  @override
  String get tutSudoku3 =>
      'Die Blöcke zählen auch: Jeder Block braucht 1 bis 4 einmal. Vervollständige den letzten Block.';

  @override
  String get tutSudoku4 =>
      'Noch unsicher? Mach Notizen. Schalte den Stift neben der Palette ein, wähle das markierte Feld und notiere jede Zahl, die dort noch möglich ist.';

  @override
  String get tutSudoku5 =>
      'Jetzt ein ganzes Rätsel. Ein ausgewähltes Feld tönt seine Zeile, Spalte und seinen Block ein und hebt dieselbe Zahl anderswo hervor. In den Einstellungen können Notizen automatisch entfernt werden.';

  @override
  String get tutSudokuS1 =>
      'Schau auf eine Zahl statt auf ein Feld. Der markierte Block braucht eine 1: Die Einsen in seinen Spalten und in seiner zweiten Zeile schließen alle Felder bis auf eins aus. Löse dann das Gitter genauso weiter.';

  @override
  String get tutSudokuS2 =>
      'Zwei neue Tricks. Paare: Zwei Felder einer Linie oder eines Blocks, in die nur dieselben zwei Zahlen passen, beanspruchen sie. Zeigen: Liegen die Plätze eines Blocks für eine Zahl auf einer Linie, fehlt sie im Rest dieser Linie.';

  @override
  String get tutKings1 =>
      'Setze genau eine Krone in jede Zeile, jede Spalte und jeden farbigen Bereich. Drei stehen schon, und für die letzte ist nur ein Platz frei. Tippe zweimal darauf: erst ein Punkt, dann eine Krone.';

  @override
  String get tutKings2 =>
      'Kronen berühren sich nie, auch nicht an den Ecken. Tippe einmal, um einen Punkt (deine Notiz „keine Krone hier“) auf jedes Feld um diese Krone zu setzen.';

  @override
  String get tutKings3 =>
      'Die Zeilen der Kronen und die Berührungsregel lassen im markierten Bereich nur ein Feld ohne Punkt übrig. Setze dort seine Krone.';

  @override
  String get tutKings4 =>
      'Jetzt ein ganzes Brett. Setze Punkte, wo keine Krone hin kann, und suche Zeilen, Spalten oder Bereiche mit nur einem freien Feld.';

  @override
  String get tutKingsS1 =>
      'Such eine Region, die in eine Zeile oder Spalte passt. Die markierte Region liegt ganz in der unteren Zeile, also steht die Krone dieser Zeile in ihr: Setz Punkte in die anderen Felder der unteren Zeile und mach weiter.';

  @override
  String get tutKingsS2 =>
      'Noch ein Trick: Würde eine Krone in einem Feld alle Felder einer anderen Region ausschließen (über Zeile, Spalte oder Berühren), kann dort keine Krone stehen. Setz einen Punkt. Genauso bei zwei Regionen, die in zwei Zeilen passen.';

  @override
  String get tutHues1 =>
      'Färbe jedes leere Feld. Eine Zahl zählt die leeren Felder um sie herum (auch diagonal), die am Ende ihre Farbe haben. Die blaue 3 hat genau drei leere Nachbarn, also sind alle blau. Wähle eine Farbe in der Palette und tippe auf Felder.';

  @override
  String get tutHues2 =>
      'Die Zahlen zählen beim Färben herunter: Sie zeigen, wie viele passende Felder noch fehlen. Eine 0 heißt, dass kein leerer Nachbar ihre Farbe bekommt, und Zahlenfelder zählen nie mit. Fang mit der blauen 3 an und schau dann, was der rosa 2 noch fehlt.';

  @override
  String get tutHues3 => 'Jetzt ein echtes Brett. Fang mit Zahlen an, die alle leeren Nachbarn brauchen oder keinen.';

  @override
  String get tutHuesS1 =>
      'Schließ Farben aus. Jedes markierte Feld berührt die blaue 0, kann also nicht blau sein, und die rosa 0, kann also nicht rosa sein. Bleibt nur Gelb.';

  @override
  String get tutHuesS2 =>
      'Ein schwereres Gitter. Vergleiche Zahlen mit gemeinsamen leeren Nachbarn: Was der einen noch fehlt, hat die andere vielleicht schon aufgebraucht. Wenn du feststeckst, probier eine Farbe in einem Feld und schau, ob eine Zahl nicht mehr passt.';

  @override
  String get tutMosaic1 =>
      'Der Fleck in der oberen linken Ecke gehört dir. Wähle unten eine Farbe: Dein Fleck nimmt sie an und schluckt alle angrenzenden Felder dieser Farbe. Färbe das ganze Brett in einer Farbe.';

  @override
  String get tutMosaic2 =>
      'Achte auf das Zuglimit: Wähle die Farbe, die deinen Fleck am meisten wachsen lässt. Ein Tipp auf ein Feld des Bretts wählt ebenfalls dessen Farbe.';

  @override
  String get tutMosaic3 => 'Jetzt ein echtes Brett, mit ein paar Zügen Reserve.';

  @override
  String get tutMosaicS1 =>
      'Plan voraus. Erreich früh die Mitte des Bretts, denn dann berührt dein Fleck mehr Farben, und wähl wann immer möglich eine Farbe, die damit ganz vom Brett verschwindet.';

  @override
  String get tutBlend1 =>
      'Das Brett besteht aus Flecken: angrenzenden Feldern einer Farbe. Wähle unten eine Farbe und tippe auf einen Fleck, um ihn zu übermalen. Er verschmilzt mit angrenzenden Flecken dieser Farbe. Übermale den mittleren Fleck.';

  @override
  String get tutBlend2 =>
      'Ein Zug kann viele Flecken verschmelzen. Der mittlere Fleck grenzt an vier andere: Übermale ihn, um sie zu verbinden, und mach dann fertig. Du hast nur 2 Züge.';

  @override
  String get tutBlend3 =>
      'Jetzt ein echtes Brett. Die gewählte Farbe bleibt ausgewählt, sodass du mehrere Flecken hintereinander übermalen kannst.';

  @override
  String get tutBlendS1 =>
      'Nimm einen Fleck in der Mitte und färb immer ihn um: Jeder Zug schluckt dann alle angrenzenden Flecken der neuen Farbe. Wähl die Farbe, die die meisten seiner Nachbarn haben.';

  @override
  String get tutPop1 =>
      'Tippe auf eine Gruppe von zwei oder mehr angrenzenden Blasen einer Farbe, um sie auszuwählen, und noch einmal, um sie platzen zu lassen. Leere das Brett.';

  @override
  String get tutPop2 =>
      'Blasen darüber fallen in die Lücken, so entstehen neue Gruppen. Die Reihenfolge zählt: Lass zuerst die markierte Gruppe platzen.';

  @override
  String get tutPop3 =>
      'Wenn eine Spalte leer wird, rücken die Spalten links davon nach rechts. Lass die Mitte platzen, um die Seiten zusammenzubringen.';

  @override
  String get tutPop4 =>
      'Eine Gruppe von n Blasen bringt n × (n − 1) Punkte: 2 Blasen bringen 2, 5 bringen 20. Spar dir eine große Gruppe auf, um 20 Punkte zu erreichen.';

  @override
  String get tutPop5 =>
      'Weitere Modi: Bei Schieber rutscht auch jede Zeile nach rechts, bei Endlos rollen neue Spalten von links herein, und Mega macht beides. Ziele: Brett leeren, eine Zielpunktzahl erreichen oder frei um den Rekord spielen. Das Spiel endet, wenn keine Zweiergruppe mehr übrig ist.';

  @override
  String get tutPopS1 =>
      'Ein Brett zu leeren braucht einen Plan. Überleg vor dem Platzen, was in die Lücke fällt: Lass Gruppen platzen, die Blasen einer Farbe zusammenbringen, und lass nie eine einzelne Blase einer Farbe allein.';

  @override
  String get tutPopS2 =>
      'Jagd auf Punkte: Eine Gruppe aus n Blasen bringt n × (n − 1), also schlägt eine Gruppe aus 8 (56) vier Gruppen aus 2 (8). Lass erst die anderen Farben platzen, um eine Farbe zu einer großen Gruppe zu vereinen.';

  @override
  String get tutMerge1 =>
      'Wische (oder drück eine Pfeiltaste), um alle Kacheln so weit wie möglich zu schieben. Zwei gleiche Kacheln, die aufeinandertreffen, verschmelzen zu ihrer Summe. Mach eine 4.';

  @override
  String get tutMerge2 =>
      'Eine Kachel verschmilzt pro Zug nur einmal: Aus 4, 4, 8 wird 8, 8, nicht 16. Nach jedem Zug erscheint eine neue 2 (manchmal eine 4). Bau eine 16.';

  @override
  String get tutMerge3 => 'Halte deine größte Kachel in einer Ecke und füttere sie Schritt für Schritt. Bau eine 32.';

  @override
  String get tutMergeS1 =>
      'Bau eine Kette: Halt deine Kacheln der Reihe nach in einer Zeile, die größte in der Ecke, etwa 64, 32, 16, 8. Dann rollt eine neue 8 am Ende ganz nach vorn. Bau eine 128.';

  @override
  String get tutSnake1 =>
      'Die Schlange bewegt sich von selbst: Wische (oder drück eine Pfeiltaste), um sie zu lenken. Direkt umkehren kann sie nicht. Führe sie zum Apfel.';

  @override
  String get tutSnake2 =>
      'Jeder Apfel macht die Schlange ein Feld länger. Stoß nicht gegen eine Wand oder deinen eigenen Körper. Friss 3 Äpfel.';

  @override
  String get tutSnake3 =>
      'Ein echtes Feld: Friss 5 Äpfel. Tippe aufs Feld für eine Pause und wische, um weiterzuspielen.';

  @override
  String get tutSnakeS1 =>
      'Eine lange Schlange braucht Platz. Bevor du einen Apfel holst, sorg dafür, dass du wieder herauskommst: Die Felder, die dein Schwanz verlässt, sind immer frei, also ist es sicher, ihm zu folgen. Friss 3 Äpfel.';

  @override
  String get tutJunction1 =>
      'Die Züge kommen aus dem Tunnel und fahren von selbst. Tippe auf die Weiche, um sie umzustellen: Der Hebel zeigt, wohin der nächste Zug fährt. Schick jeden Zug zum Bahnhof mit seinem Symbol. Tippe aufs Feld, um zu starten.';

  @override
  String get tutJunction2 =>
      'Ein Zug nimmt den Zweig, auf den die Weiche steht, wenn er über sie fährt. Stell also jede Weiche, bevor der Zug dort ankommt, und für den nächsten Zug bei Bedarf wieder zurück. Tippe abseits der Weichen aufs Feld für eine Pause.';

  @override
  String get tutJunction3 =>
      'Ein echtes Feld: Bring 6 Züge zu ihren Bahnhöfen. Achte auf die Züge aus dem Tunnel und stell die Weichen vor ihnen.';

  @override
  String get tutTurnabout1 =>
      'Wische (oder drücke eine Pfeiltaste), um deinen Läufer, die runde Figur, ein Feld weiterzuziehen. Wische weiter, um weiterzulaufen. Wände versperren den Weg. Erreiche den Stern.';

  @override
  String get tutTurnabout2 =>
      'Alle paar Sekunden dreht sich das ganze Labyrinth, und kurz vorher erscheint ein runder Pfeil. Die Richtungen am Bildschirm bleiben gleich: Oben ist immer oben, also kann der Weg zum Stern jetzt in eine andere Richtung führen. Erreiche den Stern.';

  @override
  String get tutTurnabout3 =>
      'Ein Wettrennen: Der Rivale, die Raute, läuft auf dem kürzesten Weg zum Stern. Sei vor ihm da! Die Runde beginnt mit deinem ersten Zug; tippe aufs Feld, um zu pausieren.';

  @override
  String get tutPipes1 =>
      'Tippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen (langes Drücken oder Rechtsklick dreht zurück). Verbinde jedes Rohr mit der Quelle, der Kachel mit Ring. Das Wasser zeigt, was schon verbunden ist.';

  @override
  String get tutPipes2 =>
      'Kein Rohrende darf offen bleiben, also darf kein Rohr über den Rand zeigen. Kacheln mit einem Punkt in der Ecke sind fest und stimmen schon. Fang an den Rändern und Ecken an, wo Kacheln die wenigsten Möglichkeiten haben.';

  @override
  String get tutPipes3 => 'Jetzt ein echtes Brett. Das Netz darf keine Schleifen bilden.';

  @override
  String get tutPipesS1 =>
      'Arbeite dich vom Rand nach innen. Ein gerades Stück am Rand muss an ihm entlanglaufen, in eine Ecke passt nur ein nach innen zeigender Bogen, und ein T am Rand dreht seine flache Seite zum Rand. Jede feste Kachel schränkt ihre Nachbarn ein.';

  @override
  String get tutPipesS2 =>
      'Ein schweres Gitter. Das Netz darf keine Schleife bilden: Würde eine Drehung eine schließen, muss die Kachel anders zeigen. Und zwei Endstücke zeigen nie aufeinander, sonst wären sie ein vom Rest abgeschnittenes Paar.';

  @override
  String get tutChannel1 =>
      'Tippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen (langes Drücken oder Rechtsklick dreht zurück). Leite das Wasser von der Quelle, der Kachel mit Ring, zum Abfluss, der Kachel mit Quadrat.';

  @override
  String get tutChannel2 =>
      'Nur das Rohr von der Quelle zum Abfluss zählt: Andere Kacheln dürfen irgendwohin zeigen, und Enden dürfen offen bleiben. Wasser verlässt eine Kachel durch alle anderen Enden, also leitet ein T es weiter, auch wenn sein drittes Ende ins Leere führt.';

  @override
  String get tutChannel3 =>
      'Eine Kreuzung ist eine Brücke: Das Wasser fließt geradeaus darüber und biegt dort nie ab, also kann das Rohr sie zweimal passieren, einmal längs und einmal quer.';

  @override
  String get tutChannel4 => 'Jetzt ein echtes Brett. Viele Kacheln sind nur da, um dich in die Irre zu führen.';

  @override
  String get tutChannelS1 =>
      'Arbeite von beiden Enden. Der Abfluss ist auch fest, also verfolge das Rohr auch von ihm aus zurück: Ein gerades Stück muss weiterlaufen, ein Bogen muss abbiegen, und der Rand schneidet Wege ab. Verbinde die beiden Stücke dort, wo sie sich treffen können.';

  @override
  String get tutChannelS2 =>
      'Ein schweres Brett, mit Brücken. Wenn ein Weg in eine Sackgasse, über den Rand oder in Kacheln führt, die das Wasser nicht aufnehmen, geh zurück zur letzten Kachel mit einer Wahl und versuche einen anderen Weg.';

  @override
  String get tutShikaku1 =>
      'Teile das Gitter in Rechtecke. Jedes enthält genau eine Zahl, die seiner Fläche in Feldern entspricht. Ziehe von einer Ecke zur gegenüberliegenden, um ein Rechteck zu zeichnen.';

  @override
  String get tutShikaku2 =>
      'Eine 1 ist allein schon ein Rechteck: Tippe einfach darauf. Tippe auf ein gezeichnetes Rechteck, um es zu entfernen. Hier passt die 6 nur auf eine Art.';

  @override
  String get tutShikaku3 => 'Jetzt ein echtes Brett. Große Zahlen am Rand haben meist die wenigsten Möglichkeiten.';

  @override
  String get tutShikakuS1 =>
      'Frag, welche Zahlen ein Feld erreichen können. Die untere linke Ecke ist zu weit weg, als dass die 4 oder die 6 sie mit einem Rechteck ihrer Größe abdecken könnten, also gehört sie zur 2.';

  @override
  String get tutShikakuS2 =>
      'Ein schweres Gitter. Überleg, welche wenigen Rechtecke eine große Zahl nutzen kann: Felder, die alle davon abdecken, gehören ihr, und ein Feld, das nur eine Zahl erreicht, gehört dieser Zahl.';

  @override
  String get tutTrail1 =>
      'Ziehe von der 1 aus einen Pfad durch jedes Feld, nach oben, unten, links oder rechts. Er endet auf der letzten Zahl.';

  @override
  String get tutTrail2 =>
      'Der Pfad muss die Zahlen der Reihe nach passieren: 1 → 2 → 3 → 4. Ziehe auf deinem Pfad zurück, um Schritte zurückzunehmen, oder tippe auf eines seiner Felder, um ihn dort abzuschneiden.';

  @override
  String get tutTrail3 =>
      'Jetzt ein echtes Brett. Ein Eckfeld hat nur zwei Wege hinein und hinaus, also nutzt der Pfad beide.';

  @override
  String get tutTrailS1 =>
      'Felder mit nur zwei freien Nachbarn musst du durchqueren: Der Pfad kommt auf einer Seite hinein und geht auf der anderen hinaus. Achte auf Felder, die dein eigener Pfad gerade eingeengt hat.';

  @override
  String get tutTrailS2 =>
      'Ein schweres Gitter. Teil die freien Felder nie in zwei Teile: Der Pfad kann für den anderen Teil nicht zurückkommen. Und ein Feld mit nur einem freien Nachbarn ist eine Sackgasse, die nur die letzte Zahl haben darf.';

  @override
  String get tutLabyrinth1 =>
      'Ziehe vom Start in der linken oberen Ecke zur Flagge in der rechten unteren Ecke. Wände versperren den Weg.';

  @override
  String get tutLabyrinth2 =>
      'Ein größeres Labyrinth. In einer Sackgasse? Ziehe auf deinem Weg zurück oder tippe auf eines seiner Felder, um dorthin zurückzukehren. Ein schneller Zug folgt geraden Gängen.';

  @override
  String get tutLabyrinthS1 =>
      'Verlaufen? Halt eine Hand an der Wand: Nimm immer die Öffnung ganz rechts. In so einem Labyrinth führt das immer hinaus, wenn auch nicht auf dem kürzesten Weg.';

  @override
  String get tutLabyrinthS2 =>
      'Oder arbeite rückwärts: Verfolg den Weg von der Flagge zum Start und such, wo sich die beiden Routen treffen. So fallen Sackgassen nahe der Flagge schnell weg.';

  @override
  String get tutAtoms1 =>
      'Verbinde die Atome mit Bindungen. Jedes Atom braucht so viele Bindungen, wie seine Zahl angibt, und zwei Atome können sich eine oder zwei teilen. Ziehe von einem Atom zu einem Nachbarn, um eine Bindung hinzuzufügen (1 → 2 → keine).';

  @override
  String get tutAtoms2 =>
      'Alle Atome müssen ein Molekül bilden, und Bindungen dürfen sich nicht kreuzen. Eine Bindung von der 1 oben links nach unten ließe zwei getrennte Paare übrig. Wohin geht sie also?';

  @override
  String get tutAtoms3 =>
      'Jetzt ein echtes Brett. Fang mit Atomen an, die ihre Bindungen nur auf eine Art bekommen können.';

  @override
  String get tutAtomsS1 =>
      'Vergleich die Zahl eines Atoms mit seinen Nachbarn. Die 4 in der Ecke hat nur zwei Nachbarn, und ein Paar kann höchstens zwei Bindungen teilen, also sind beide doppelt. Ebenso bekommt eine 3 mit zwei Nachbarn zu jedem mindestens eine Bindung.';

  @override
  String get tutAtomsS2 =>
      'Ein schweres Gitter. Halt das Molekül zusammen: Zwei 1en binden nie aneinander, und zwei 2en teilen keine Doppelbindung, außer sie sind die einzigen Atome. Wenn du feststeckst, probier eine Bindung und schau, ob ein Teil des Gitters abgeschnitten wird.';

  @override
  String get tutLits1 =>
      'Schattiere in jedem umrandeten Bereich genau 4 Felder, die ein L, I, T oder S bilden. Der obere Bereich hat genau 4 Felder, also schattiere alle. Tippe auf ein Feld, um es zu schattieren.';

  @override
  String get tutLits2 =>
      'Kein 2×2-Block darf ganz schattiert sein, und gleiche Formen dürfen sich über eine Grenze nicht berühren. Nur ein Feld vervollständigt den linken Bereich. Welches?';

  @override
  String get tutLits3 =>
      'Jetzt ein echtes Brett. Alle schattierten Felder müssen zusammenhängen. Tippe zweimal für einen Punkt, deine Notiz, dass ein Feld leer bleibt.';

  @override
  String get tutLitsS1 =>
      'Überleg, welche Formen jede Region noch aufnehmen kann. Felder, die jede mögliche Form abdeckt, werden schattiert, Felder, die keine abdeckt, bleiben leer. Kleine Regionen und solche, die die 2×2-Regel einengt, haben die wenigsten Möglichkeiten.';

  @override
  String get tutLitsS2 =>
      'Ein schwereres Gitter. Wenn du feststeckst, probier eine Form in einer Region: Entsteht dadurch ein 2×2-Block, zerfällt die schattierte Fläche in zwei Teile oder liegen zwei gleiche Formen nebeneinander, ist sie falsch.';

  @override
  String get tutCamp1 =>
      'Stell neben jeden Baum ein Zelt: oben, unten, links oder rechts, nie diagonal. Die Zahlen außen geben an, wie viele Zelte in jeder Zeile und Spalte stehen. Tippe zweimal auf ein Feld: Gras, dann Zelt.';

  @override
  String get tutCamp2 =>
      'Zelte berühren sich nie, auch nicht diagonal. Ein Zelt steht schon. Wo kann das Zelt des anderen Baums hin?';

  @override
  String get tutCamp3 =>
      'Jetzt ein echtes Brett. Eine 0 heißt, dass die ganze Zeile oder Spalte Gras ist, und jeder Baum bekommt sein eigenes Zelt.';

  @override
  String get tutCampS1 =>
      'Zähl die Lücken. Die obere Zeile braucht 2 Zelte, und nur ihre drei markierten Felder kommen infrage. Zwei Zelte in drei Feldern, die sich nicht berühren dürfen, stehen an beiden Enden.';

  @override
  String get tutCampS2 =>
      'Ein schweres Gitter, und manche Zahlen sind verdeckt. Wenn du feststeckst, probier ein Zelt auf einem Feld: Bleibt dann ein Baum ohne Platz für sein eigenes Zelt, ist dort Gras.';

  @override
  String get tutIslands1 =>
      'Schattiere das Meer so, dass die freien Felder Inseln bilden. Jede Zahl ist eine Insel aus genau so vielen Feldern. Hier ist die 1 eine Insel für sich: Tippe auf alle anderen Felder, um sie zu Meer zu machen.';

  @override
  String get tutIslands2 =>
      'Inseln berühren sich nie. Ein Feld zwischen zwei Zahlen muss Meer sein, sonst würde es sie zu einer Insel verbinden.';

  @override
  String get tutIslands3 =>
      'Das Meer muss zusammenhängen und darf nie ein 2×2-Becken bilden. Lass die 3 so wachsen, dass beides eingehalten wird. Tippe zweimal für einen Punkt, deine Notiz für Land.';

  @override
  String get tutIslands4 => 'Jetzt ein echtes Brett. Jede Insel enthält genau eine Zahl.';

  @override
  String get tutIslandsS1 =>
      'Such Felder, die keine Insel erreicht. Die 3 wächst höchstens zwei Schritte von ihrer Zahl weg, die 2 einen und die 1 keinen. Die markierten Felder erreicht keine Insel, also sind sie Meer.';

  @override
  String get tutIslandsS2 =>
      'Ein schweres Gitter. Denk ans Meer: Es muss zusammenhängen, also setzt sich ein Meerfeld mit nur einem Ausweg dorthin fort, und es darf keinen 2×2-Teich bilden. Wenn du feststeckst, probier ein Feld als Land und schau, ob etwas nicht mehr passt.';

  @override
  String get tutLamps1 =>
      'Setze Lampen auf leere Felder: zweimal tippen (Punkt, dann Lampe). Die dunklen Felder sind Wände. Eine Lampe beleuchtet ihre Zeile und Spalte bis zu den Wänden. Beleuchte jedes leere Feld.';

  @override
  String get tutLamps2 =>
      'Eine Zahl auf einer Wand gibt an, wie viele Lampen sie berühren (oben, unten, links oder rechts). Diese 3 braucht auf jeder freien Seite eine Lampe.';

  @override
  String get tutLamps3 =>
      'Lampen dürfen nie aufeinander scheinen, und eine 0 heißt: keine Lampe direkt daneben. Wo steht die zweite Lampe?';

  @override
  String get tutLamps4 => 'Jetzt ein echtes Brett. Mit Punkten markierst du Felder, auf denen keine Lampe stehen kann.';

  @override
  String get tutLampsS1 =>
      'Manche Felder können nur auf eine Art Licht bekommen. Die obere linke Ecke kann nur von sich selbst oder ihren zwei Nachbarn beleuchtet werden, und die 0 schließt die Nachbarn aus: Die Lampe kommt in die Ecke. Dann schau auf die 1.';

  @override
  String get tutLampsS2 =>
      'Ein schweres Gitter. Wenn du feststeckst, probier eine Lampe in einem Feld und verfolge die Folgen: Kann dann ein Feld nicht mehr beleuchtet oder eine Zahl nicht erfüllt werden, bekommt das Feld einen Punkt.';

  @override
  String get tutFence1 =>
      'Zeichne eine geschlossene Schleife entlang der gepunkteten Linien. Eine Zahl gibt an, wie viele Seiten ihres Feldes die Schleife benutzt. Tippe zwischen zwei Punkte, um eine Linie zu ziehen, oder ziehe von Punkt zu Punkt.';

  @override
  String get tutFence2 =>
      'Um eine 0 herum gibt es keine Linie. Tippe noch einmal auf eine Linie, um sie in ein Kreuz zu verwandeln, deine Notiz, dass dort keine Linie verläuft. Felder ohne Zahl dürfen beliebig viele haben.';

  @override
  String get tutFence3 =>
      'Die Schleife verzweigt und kreuzt sich nie: An jedem Punkt liegen null oder zwei Linien. Zahlen am Rand des Bretts sind ein guter Anfang.';

  @override
  String get tutFence4 => 'Jetzt ein echtes Brett. Fang mit den 0en und 3en an.';

  @override
  String get tutFenceS1 =>
      'Lern ein paar Muster. Zwei 3en nebeneinander haben immer eine Linie dazwischen und je eine auf ihrer äußeren Seite: Sonst fehlt einer von beiden etwas. Die 0 darüber hilft auch.';

  @override
  String get tutFenceS2 =>
      'Ecken verraten viel. Eine 1 in einer Ecke nutzt nie ihre zwei Außenseiten: Die Schleife müsste dort abbiegen und beide nehmen. Eine 3 in einer Ecke nutzt immer beide.';

  @override
  String get tutFenceS3 =>
      'Ein schweres Gitter. Wenn du feststeckst, probier eine Linie an einer Kante und verfolge sie: Führt sie in eine Sackgasse, zu einer unerfüllbaren Zahl oder zu einer kleinen Schleife, die andere ausschließt, bekommt die Kante ein Kreuz.';

  @override
  String get tutPearls1 =>
      'Ziehe durch die Felder, um eine geschlossene Schleife zu zeichnen. An einer schwarzen Perle biegt die Schleife ab und läuft dann auf beiden Seiten geradeaus durch das nächste Feld.';

  @override
  String get tutPearls2 =>
      'Durch eine weiße Perle läuft die Schleife geradeaus und biegt im Feld direkt davor oder danach (oder in beiden) ab.';

  @override
  String get tutPearls3 =>
      'Jetzt ein echtes Brett. Die Schleife muss nicht durch jedes Feld laufen und kreuzt oder berührt sich nie selbst.';

  @override
  String get tutPearlsS1 =>
      'Eine schwarze Perle kann nicht zu einem zu nahen Rand abbiegen: Die Schleife braucht auf jeder Seite zwei gerade Felder. Beide schwarzen Perlen hier sind zu nah an zwei Rändern, ihre Richtungen stehen also fest.';

  @override
  String get tutPearlsS2 =>
      'Ein schweres Gitter. Drei weiße Perlen in einer Reihe können nicht auf einem geraden Stück liegen (die mittlere braucht daneben eine Kurve), also kreuzt die Schleife sie quer. Wenn du feststeckst, probier eine Linie und schau, ob eine Perle nicht mehr passt.';

  @override
  String get tutRails1 =>
      'Ziehe durch die Felder, um ein Gleis von der Einfahrt links zur Ausfahrt unten zu verlegen. Die Zahlen oben und rechts zählen die Gleisfelder jeder Spalte und Zeile.';

  @override
  String get tutRails2 =>
      'Stücke, die schon auf dem Gitter liegen, sind fest: Das Gleis läuft genau so hindurch, wie gezeigt. Eine 0 heißt: In dieser Zeile oder Spalte liegt gar kein Gleis.';

  @override
  String get tutRails3 =>
      'Jetzt ein echtes Gitter. Das Gleis verzweigt und kreuzt sich nie und muss nicht durch jedes Feld laufen.';

  @override
  String get tutRailsS1 =>
      'Fang mit Linien an, deren Zahl keine Wahl lässt. Die zweite Zeile braucht 4 Gleisfelder und hat nur 4, die rechte Spalte ebenso. Dann verbinde die Enden.';

  @override
  String get tutRailsS2 =>
      'Ein schweres Gitter. Eine aufgebrauchte Zahl sperrt den Rest ihrer Linie, und ein Gleisfeld braucht immer genau zwei Gleisnachbarn. Wenn du feststeckst, probier ein Stück und prüf, ob die Zahlen noch passen.';

  @override
  String get tutBlocks1 =>
      'Jeder Bereich aus k Feldern enthält die Zahlen 1 bis k je einmal. Jedes markierte Feld ist die letzte Lücke in seinem Bereich: Wähle die fehlende Zahl in der Palette und tippe auf das Feld.';

  @override
  String get tutBlocks2 =>
      'Gleiche Zahlen berühren sich nie, auch nicht an den Ecken. Der Bereich oben links braucht eine 1 und eine 2, und eines seiner Felder berührt schon eine 2. Fülle die untere Zeile genauso.';

  @override
  String get tutBlocks3 =>
      'Jetzt ein echtes Gitter. Fang mit kleinen Bereichen an und mit Feldern, deren Nachbarn die meisten Zahlen ausschließen. Stift-Notizen helfen.';

  @override
  String get tutBlocksS1 =>
      'Zeigen: Notiere, wo jede Region eine Zahl noch setzen kann. Berühren all diese Felder dasselbe Feld außerhalb, kann dort diese Zahl nicht stehen, denn sie würde sie berühren. Bleistiftnotizen helfen, das zu sehen.';

  @override
  String get tutBlocksS2 =>
      'Ein schweres Gitter. Wenn sonst nichts geht, nimm ein Feld mit nur zwei möglichen Zahlen und probier eine: Hat bald eine Region keinen Platz mehr für eine Zahl, ist die andere richtig.';

  @override
  String get tutPairs1 =>
      'Schattiere in jedem Bereich genau zwei Felder, sodass jedes schattierte Feld genau ein anderes berührt: Die Schattierung besteht aus Paaren. Der markierte Bereich hat nur zwei Felder, also schattiere beide.';

  @override
  String get tutPairs2 =>
      'Paare berühren einander nie seitlich. Das obere Paar ist fertig, also bleiben die markierten Felder daneben unschattiert: Setze dort Punkte (zweimal tippen) und löse dann das Gitter zu Ende.';

  @override
  String get tutPairs3 =>
      'Jetzt ein echtes Gitter. Kleine Bereiche und von Punkten eingeschlossene Felder sind gute Startpunkte.';

  @override
  String get tutPairsS1 =>
      'Geh alle Wege durch, eine kleine Region fertigzumachen: Ein Feld, das in allen schattiert ist, wird schattiert, eines, das in keinem schattiert ist, bekommt einen Punkt. Ein L aus drei Feldern etwa schattiert immer seine Ecke.';

  @override
  String get tutPairsS2 =>
      'Ein schweres Gitter. Wenn du feststeckst, schattiere ein Feld und folge den Regeln: Kann eine Region dann ihre zwei Felder nicht mehr bekommen oder würden sich zwei Paare berühren, bleibt das Feld unschattiert.';

  @override
  String get tutPlots1 =>
      'Fülle jedes Feld mit einer Zahl. Gleiche Zahlen, die sich seitlich berühren, bilden eine Parzelle aus genau so vielen Feldern. Die markierte 3 braucht noch zwei Felder für ihre Parzelle.';

  @override
  String get tutPlots2 =>
      'Zwei gleich große Parzellen dürfen sich nicht berühren: Sie würden zu einer zu großen Parzelle verschmelzen. Das markierte Feld berührt zwei Parzellen aus 2, also kann es keine 2 sein.';

  @override
  String get tutPlots3 =>
      'Jetzt ein echtes Gitter. Manche Parzellen zeigen gar keine Zahl: Leite ihre Größe aus dem übrigen Platz ab.';

  @override
  String get tutPlotsS1 =>
      'Such nach Taschen. Die zwei markierten Felder sind von fertigen Parzellen umgeben, sie können sich also nur miteinander verbinden. Zwei Einsen dürfen sich nicht berühren, also bilden sie zusammen eine Parzelle aus 2.';

  @override
  String get tutPlotsS2 =>
      'Ein schweres Gitter. Wenn nichts sicher ist, nimm ein Feld mit nur zwei oder drei möglichen Zahlen und prüf jede: Eine Zahl, mit der eine Parzelle ihre Größe nicht mehr erreichen kann, fällt weg.';

  @override
  String get tutLinks1 =>
      'Ziehe von einem Punkt zu seinem Partner, um sie zu verbinden. Wege laufen durch benachbarte Felder, nie diagonal.';

  @override
  String get tutLinks2 =>
      'Wege kreuzen sich nie und füllen zusammen jedes Feld, also müssen manche einen Umweg nehmen.';

  @override
  String get tutLinks3 =>
      'Jetzt ein echtes Gitter. Ecken und Ränder lassen die wenigsten Wege offen, also fang dort an.';

  @override
  String get tutLinksS1 =>
      'Füll zuerst die engen Stellen. Eine leere Ecke hat nur zwei Nachbarn, der Pfad hindurch nutzt also beide. Genauso bei jedem Feld, dem nur zwei freie Nachbarn bleiben.';

  @override
  String get tutLinksS2 =>
      'Ein schweres Gitter. In einem Rätsel mit einer Lösung faltet sich ein Pfad nie neben sich selbst zurück (er könnte abkürzen), also gehört kein 2×2-Quadrat zu einem einzigen Pfad. Und lass kein leeres Feld übrig, das kein Pfad mehr erreichen kann.';

  @override
  String get tutArrows1 =>
      'Zeichne eine Schleife durch die Mitten aller leeren Felder: Ziehe von Feld zu Feld. Das Hinweisfeld in der Mitte ist nie auf der Schleife. Seine 0 sagt, dass darüber kein Feld schattiert ist, hier also keins.';

  @override
  String get tutArrows2 =>
      'Jetzt müssen zwei Felder schattiert werden. Jeder Hinweis zählt die schattierten Felder in Pfeilrichtung: Finde sie und tippe auf ihre Mitten, um sie zu schattieren. Schattierte Felder berühren sich nie seitlich. Dann zeichne die Schleife durch alle anderen Felder.';

  @override
  String get tutArrows3 =>
      'Jetzt ein echtes Gitter. Felder neben einem schattierten Feld liegen immer auf der Schleife, und ein Schleifenfeld braucht zwei Ausgänge.';

  @override
  String get tutArrowsS1 =>
      'Such enge Hinweise. Die 2 in der mittleren Zeile hat rechts nur drei Felder, und ihre zwei schattierten Felder dürfen sich nicht berühren, also nehmen sie das erste und das letzte. Die 2 in der oberen Zeile ist noch leichter: Sie hat nur zwei freie Felder.';

  @override
  String get tutArrowsS2 =>
      'Ein schweres Gitter. Jedes Feld, das weder schattiert noch Hinweis ist, liegt auf der Schleife, also steht der Weg durch ein Feld mit nur zwei freien Nachbarn fest. Wenn du feststeckst, schattiere probeweise ein Feld und schau, ob ein Schleifenfeld weniger als zwei Ausgänge behält.';

  @override
  String get tutMines1 =>
      'Eine Zahl zählt die Minen in den 8 Feldern um sie herum. Jede 1 hier berührt nur ein geschlossenes Feld, also liegt dort eine Mine. Markiere sie: langes Drücken oder Rechtsklick, oder wechsle unten zu „Flagge“ und tippe darauf.';

  @override
  String get tutMines2 =>
      'Die Mine dieser 1 ist schon markiert, also sind alle anderen Felder ringsum sicher. Grab sie auf oder tippe auf die 1 selbst, um alle auf einmal aufzugraben.';

  @override
  String get tutMines3 => 'Ein Feld ohne Minen ringsum öffnet seine Nachbarn von selbst. Grab in der markierten Ecke.';

  @override
  String get tutMines4 =>
      'Jetzt ein echtes Brett. Raten ist nie nötig. Gräbst du aus Versehen eine Mine aus, bekommt sie einfach eine Flagge, und das Spiel geht weiter.';

  @override
  String get tutMinesS1 =>
      'Vergleich benachbarte Zahlen. Die 2 sieht drei geschlossene Felder, die 1 links daneben nur die ersten zwei, also ist das dritte eine Mine. Von rechts geht es genauso. Dann ist das mittlere Feld sicher.';

  @override
  String get tutMinesS2 =>
      'Ein schweres Gitter. Vergleich weiter Zahlen mit gemeinsamen geschlossenen Feldern. Gegen Ende zähl, was übrig ist: Der Minenzähler kann die letzten geschlossenen Felder entscheiden.';

  @override
  String get explain => 'Erklären';

  @override
  String get explainTooltip => 'Den nächsten Schritt erklären';

  @override
  String get explainClose => 'Schließen';

  @override
  String get explainApply => 'Ausführen';

  @override
  String get explainWhy => 'Warum?';

  @override
  String get explainNone => 'Hier gibt es nichts mehr zu erklären.';

  @override
  String exWrong(Object cell) {
    return '$cell passt nicht zur Lösung. Leere das Feld zuerst.';
  }

  @override
  String exFallback(Object cell) {
    return 'Hier gibt es keinen logischen Schritt, also wird $cell aus der Lösung gefüllt.';
  }

  @override
  String exSuppose(Object cell, Object value) {
    return 'Angenommen, in $cell wäre $value.';
  }

  @override
  String exRefutedBinary(Object cell, Object value, Object other) {
    return 'In $cell muss $value stehen: $other führt dort zu einem Widerspruch.';
  }

  @override
  String exRefuted(Object cell, Object value) {
    return 'In $cell kann kein $value stehen: das führt zu einem Widerspruch.';
  }

  @override
  String exMamboPair(Object cell, Object value, Object a, Object b, Object other) {
    return 'In $cell muss $value stehen: sonst wären $a, $b und $cell drei $other in einer Reihe.';
  }

  @override
  String exMamboGap(Object cell, Object value, Object a, Object b, Object other) {
    return 'In $cell muss $value stehen: es liegt zwischen $a und $b, die beide $other sind.';
  }

  @override
  String exMamboHalfRow(Object cell, Object value, Object row, Object count, Object other) {
    return 'In $cell muss $value stehen: Zeile $row hat schon alle $count $other.';
  }

  @override
  String exMamboHalfCol(Object cell, Object value, Object col, Object count, Object other) {
    return 'In $cell muss $value stehen: Spalte $col hat schon alle $count $other.';
  }

  @override
  String exMamboSame(Object cell, Object value, Object a) {
    return 'In $cell muss $value stehen: das =-Zeichen verbindet es mit $a, wo $value steht.';
  }

  @override
  String exMamboDiff(Object cell, Object value, Object a, Object other) {
    return 'In $cell muss $value stehen: das ×-Zeichen verbindet es mit $a, wo $other steht.';
  }

  @override
  String exMamboFailThree(Object a, Object b, Object c, Object value) {
    return 'Dann wären $a, $b und $c aber drei $value in einer Reihe.';
  }

  @override
  String exMamboFailHalfRow(Object row, Object count, Object value) {
    return 'Dann hätte Zeile $row aber mehr als $count $value.';
  }

  @override
  String exMamboFailHalfCol(Object col, Object count, Object value) {
    return 'Dann hätte Spalte $col aber mehr als $count $value.';
  }

  @override
  String exMamboFailSame(Object a, Object b) {
    return 'Dann wären $a und $b aber verschieden, obwohl ein = zwischen ihnen steht.';
  }

  @override
  String exMamboFailDiff(Object a, Object b) {
    return 'Dann wären $a und $b aber gleich, obwohl ein × zwischen ihnen steht.';
  }

  @override
  String exSudokuNaked(Object cell, Object value) {
    return 'In $cell muss $value stehen: alle anderen Ziffern stehen schon in seiner Zeile, Spalte oder seinem Block.';
  }

  @override
  String exSudokuHiddenRow(Object cell, Object value, Object row) {
    return 'In $cell muss $value stehen: es ist der einzige Platz für $value in Zeile $row.';
  }

  @override
  String exSudokuHiddenCol(Object cell, Object value, Object col) {
    return 'In $cell muss $value stehen: es ist der einzige Platz für $value in Spalte $col.';
  }

  @override
  String exSudokuHiddenBox(Object cell, Object value, Object box) {
    return 'In $cell muss $value stehen: es ist der einzige Platz für $value im Block $box.';
  }

  @override
  String exSudokuPointingRow(Object box, Object value, Object row) {
    return 'Im Block $box kann $value nur in Zeile $row stehen, also nirgends sonst in Zeile $row.';
  }

  @override
  String exSudokuPointingCol(Object box, Object value, Object col) {
    return 'Im Block $box kann $value nur in Spalte $col stehen, also nirgends sonst in Spalte $col.';
  }

  @override
  String exSudokuClaimingRow(Object row, Object value, Object box) {
    return 'In Zeile $row kann $value nur im Block $box stehen, also nirgends sonst in diesem Block.';
  }

  @override
  String exSudokuClaimingCol(Object col, Object value, Object box) {
    return 'In Spalte $col kann $value nur im Block $box stehen, also nirgends sonst in diesem Block.';
  }

  @override
  String exSudokuPairRow(Object a, Object b, Object v1, Object v2, Object row) {
    return 'In $a und $b können nur $v1 und $v2 stehen, also kommen diese Ziffern sonst nirgends in Zeile $row vor.';
  }

  @override
  String exSudokuPairCol(Object a, Object b, Object v1, Object v2, Object col) {
    return 'In $a und $b können nur $v1 und $v2 stehen, also kommen diese Ziffern sonst nirgends in Spalte $col vor.';
  }

  @override
  String exSudokuPairBox(Object a, Object b, Object v1, Object v2, Object box) {
    return 'In $a und $b können nur $v1 und $v2 stehen, also kommen diese Ziffern sonst nirgends im Block $box vor.';
  }

  @override
  String exSudokuFailEmpty(Object cell) {
    return 'Dann bliebe für $cell aber keine Ziffer übrig.';
  }

  @override
  String exSudokuFailNoPlaceRow(Object value, Object row) {
    return 'Dann hätte $value in Zeile $row aber keinen Platz mehr.';
  }

  @override
  String exSudokuFailNoPlaceCol(Object value, Object col) {
    return 'Dann hätte $value in Spalte $col aber keinen Platz mehr.';
  }

  @override
  String exSudokuFailNoPlaceBox(Object value, Object box) {
    return 'Dann hätte $value im Block $box aber keinen Platz mehr.';
  }

  @override
  String exSudokuFailClash(Object a, Object b, Object value) {
    return 'Dann stünde $value aber in $a und in $b.';
  }

  @override
  String exKingsSuppose(Object cell) {
    return 'Angenommen, in $cell stünde eine Krone.';
  }

  @override
  String exKingsRefuted(Object cell) {
    return '$cell bekommt einen Punkt: eine Krone dort führt zu einem Widerspruch.';
  }

  @override
  String exKingsSingleRow(Object cell, Object row) {
    return '$cell bekommt eine Krone: es ist das letzte freie Feld in Zeile $row.';
  }

  @override
  String exKingsSingleCol(Object cell, Object col) {
    return '$cell bekommt eine Krone: es ist das letzte freie Feld in Spalte $col.';
  }

  @override
  String exKingsSingleRegion(Object cell) {
    return '$cell bekommt eine Krone: es ist das letzte freie Feld seines Bereichs.';
  }

  @override
  String exKingsRuledOut(Object cell, Object a) {
    return '$cell bekommt einen Punkt: es berührt die Krone in $a oder teilt mit ihr Zeile, Spalte oder Bereich.';
  }

  @override
  String exKingsConfineRow(Object cell, Object row, Object region) {
    return '$cell bekommt einen Punkt: die Krone von Zeile $row muss im Bereich bei $region liegen, also hat dieser Bereich keine andere Krone.';
  }

  @override
  String exKingsConfineCol(Object cell, Object col, Object region) {
    return '$cell bekommt einen Punkt: die Krone von Spalte $col muss im Bereich bei $region liegen, also hat dieser Bereich keine andere Krone.';
  }

  @override
  String exKingsConfineRegionRow(Object cell, Object region, Object row) {
    return '$cell bekommt einen Punkt: die Krone des Bereichs bei $region muss in Zeile $row liegen, also hat Zeile $row keine andere Krone.';
  }

  @override
  String exKingsConfineRegionCol(Object cell, Object region, Object col) {
    return '$cell bekommt einen Punkt: die Krone des Bereichs bei $region muss in Spalte $col liegen, also hat Spalte $col keine andere Krone.';
  }

  @override
  String exKingsAttackRow(Object cell, Object row) {
    return '$cell bekommt einen Punkt: eine Krone dort ließe in Zeile $row kein freies Feld übrig.';
  }

  @override
  String exKingsAttackCol(Object cell, Object col) {
    return '$cell bekommt einen Punkt: eine Krone dort ließe in Spalte $col kein freies Feld übrig.';
  }

  @override
  String exKingsAttackRegion(Object cell, Object region) {
    return '$cell bekommt einen Punkt: eine Krone dort ließe im Bereich bei $region kein freies Feld übrig.';
  }

  @override
  String exKingsFailRow(Object row) {
    return 'Dann bliebe in Zeile $row aber kein Feld für ihre Krone.';
  }

  @override
  String exKingsFailCol(Object col) {
    return 'Dann bliebe in Spalte $col aber kein Feld für ihre Krone.';
  }

  @override
  String exKingsFailRegion(Object region) {
    return 'Dann bliebe im Bereich bei $region aber kein Feld für seine Krone.';
  }

  @override
  String exKingsFailClash(Object a, Object b) {
    return 'Dann kämen sich die Kronen in $a und $b aber ins Gehege.';
  }

  @override
  String exHuesFull(Object cell, Object value, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle $count Nachbarn in $value',
      one: 'seinen einen Nachbarn in $value',
    );
    return '$cell kann nicht $value sein: $clue hat schon $_temp0.';
  }

  @override
  String exHuesNeed(Object cell, Object value, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Nachbarn in $value',
      one: 'einen Nachbarn in $value',
    );
    return '$cell muss $value sein: $clue braucht $_temp0, und genau so viele Felder können es noch werden.';
  }

  @override
  String exHuesSingle(Object cell, Object value) {
    return '$cell muss $value sein: alle anderen Farben sind dort ausgeschlossen.';
  }

  @override
  String exHuesFailEmpty(Object cell) {
    return 'Dann bliebe für $cell aber keine Farbe übrig.';
  }

  @override
  String exHuesFailMany(Object clue, Object value) {
    return 'Dann hätte $clue aber zu viele Nachbarn in $value.';
  }

  @override
  String exHuesFailFew(Object clue, Object value) {
    return 'Dann käme $clue aber nicht auf genug Nachbarn in $value.';
  }

  @override
  String exBlocksNaked(Object cell, Object value) {
    return 'In $cell muss $value stehen: alle anderen Zahlen stehen schon in seinem Bereich oder in einem Feld, das es berührt.';
  }

  @override
  String exBlocksHidden(Object cell, Object value) {
    return 'In $cell muss $value stehen: es ist der einzige Platz für $value in seinem Bereich.';
  }

  @override
  String exBlocksPointing(Object cell, Object value, Object region) {
    return 'In $cell kann keine $value stehen: es berührt jedes Feld, in dem der Bereich bei $region seine $value noch haben kann.';
  }

  @override
  String exBlocksPair(Object a, Object b, Object v1, Object v2) {
    return '$a und $b teilen sich $v1 und $v2, also kann kein anderes Feld ihres Bereichs sie haben.';
  }

  @override
  String exBlocksFailEmpty(Object cell) {
    return 'Dann bliebe für $cell aber keine Zahl übrig.';
  }

  @override
  String exBlocksFailNoPlace(Object region, Object value) {
    return 'Dann hätte der Bereich bei $region aber keinen Platz mehr für $value.';
  }

  @override
  String exBlocksAlone(Object cell) {
    return 'In $cell muss 1 stehen: sein Bereich besteht nur aus diesem Feld.';
  }

  @override
  String exPlotsClosed(Object cell, Object value, Object group) {
    return 'In $cell kann keine $value stehen: die Parzelle der $value bei $group ist schon vollständig.';
  }

  @override
  String exPlotsExit(Object cell, Object value, Object group) {
    return 'In $cell muss $value stehen: der Parzelle der $value bei $group fehlen noch Felder, und das ist ihr einziger Ausweg.';
  }

  @override
  String exPlotsMerge(Object cell, Object value) {
    return 'In $cell kann keine $value stehen: es würde Parzellen der $value zu einer zu großen verbinden.';
  }

  @override
  String exPlotsRoom(Object cell, Object value) {
    return 'In $cell kann keine $value stehen: um es herum ist kein Platz für eine Parzelle aus $value Feldern.';
  }

  @override
  String exPlotsOnly(Object cell, Object value) {
    return 'In $cell muss $value stehen: alle anderen Zahlen sind dort ausgeschlossen.';
  }

  @override
  String exPlotsFailEmpty(Object cell) {
    return 'Dann bliebe für $cell aber keine Zahl übrig.';
  }

  @override
  String exPlotsFailBig(Object value, Object group) {
    return 'Dann hätte die Parzelle der $value bei $group aber zu viele Felder.';
  }

  @override
  String exPlotsFailShut(Object value, Object group) {
    return 'Dann wäre die Parzelle der $value bei $group aber eingeschlossen, bevor sie vollständig ist.';
  }

  @override
  String exPlotsFailRoom(Object value, Object group) {
    return 'Dann hätte die Parzelle der $value bei $group aber keinen Platz zum Wachsen.';
  }

  @override
  String exPairsSupposeShade(Object cell) {
    return 'Angenommen, $cell wäre schattiert.';
  }

  @override
  String exPairsSupposeDot(Object cell) {
    return 'Angenommen, $cell wäre nicht schattiert.';
  }

  @override
  String exPairsRefutedShade(Object cell) {
    return '$cell ist schattiert: es frei zu lassen führt zu einem Widerspruch.';
  }

  @override
  String exPairsRefutedDot(Object cell) {
    return '$cell bekommt einen Punkt: es zu schattieren führt zu einem Widerspruch.';
  }

  @override
  String exPairsRegionDone(Object cell, Object region) {
    return '$cell bekommt einen Punkt: der Bereich bei $region hat schon seine zwei schattierten Felder.';
  }

  @override
  String exPairsRegionNeed(Object cell, Object region) {
    return '$cell ist schattiert: im Bereich bei $region sind nur noch zwei Felder übrig, die schattiert werden können.';
  }

  @override
  String exPairsPartnered(Object cell, Object a) {
    return '$cell bekommt einen Punkt: $a daneben hat schon seinen Partner, und Paare berühren sich nie.';
  }

  @override
  String exPairsOneWay(Object cell, Object a) {
    return '$cell ist schattiert: nur hier kann $a noch seinen Partner finden.';
  }

  @override
  String exPairsCrowd(Object cell) {
    return '$cell bekommt einen Punkt: es berührt zwei schattierte Felder, und schattiert gäbe es mehr als ein Paar.';
  }

  @override
  String exPairsAlone(Object cell) {
    return '$cell bekommt einen Punkt: daneben ist kein Feld mehr übrig, mit dem es ein Paar bilden könnte.';
  }

  @override
  String exPairsEveryShade(Object cell, Object region) {
    return '$cell ist schattiert: jede Art, den Bereich bei $region zu vervollständigen, schattiert es.';
  }

  @override
  String exPairsEveryDot(Object cell, Object region) {
    return '$cell bekommt einen Punkt: keine Art, den Bereich bei $region zu vervollständigen, schattiert es.';
  }

  @override
  String exPairsFailMany(Object region) {
    return 'Dann hätte der Bereich bei $region aber mehr als zwei schattierte Felder.';
  }

  @override
  String exPairsFailFew(Object region) {
    return 'Dann käme der Bereich bei $region aber nicht auf zwei schattierte Felder.';
  }

  @override
  String exPairsFailCrowd(Object cell) {
    return 'Dann berührte das schattierte $cell aber zwei schattierte Felder.';
  }

  @override
  String exPairsFailAlone(Object cell) {
    return 'Dann bliebe dem schattierten $cell aber kein Partner.';
  }

  @override
  String exPairsFailNoWay(Object region) {
    return 'Dann ließe sich der Bereich bei $region aber nicht mehr vervollständigen.';
  }

  @override
  String exCampSupposeTent(Object cell) {
    return 'Angenommen, in $cell stünde ein Zelt.';
  }

  @override
  String exCampSupposeGrass(Object cell) {
    return 'Angenommen, $cell wäre Gras.';
  }

  @override
  String exCampRefutedTent(Object cell) {
    return '$cell ist ein Zelt: Gras dort führt zu einem Widerspruch.';
  }

  @override
  String exCampRefutedGrass(Object cell) {
    return '$cell ist Gras: ein Zelt dort führt zu einem Widerspruch.';
  }

  @override
  String exCampNearTent(Object cell, Object a) {
    return '$cell ist Gras: es berührt das Zelt in $a, und Zelte berühren sich nie.';
  }

  @override
  String exCampRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle ihre $count Zelte',
      one: 'ihr Zelt',
    );
    return '$cell ist Gras: Zeile $row hat schon $_temp0.';
  }

  @override
  String exCampColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle ihre $count Zelte',
      one: 'ihr Zelt',
    );
    return '$cell ist Gras: Spalte $col hat schon $_temp0.';
  }

  @override
  String exCampRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zelte',
      one: 'ein Zelt',
    );
    return '$cell ist ein Zelt: Zeile $row braucht $_temp0, und genau so viele Felder sind übrig.';
  }

  @override
  String exCampColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zelte',
      one: 'ein Zelt',
    );
    return '$cell ist ein Zelt: Spalte $col braucht $_temp0, und genau so viele Felder sind übrig.';
  }

  @override
  String exCampTotalDone(Object cell) {
    return '$cell ist Gras: jeder Baum hat schon sein Zelt.';
  }

  @override
  String exCampTotalNeed(Object cell) {
    return '$cell ist ein Zelt: die Bäume brauchen jedes übrige Feld.';
  }

  @override
  String exCampTreeOnly(Object cell, Object tree) {
    return '$cell ist ein Zelt: es ist das einzige freie Feld neben dem Baum in $tree.';
  }

  @override
  String exCampFailTouch(Object a, Object b) {
    return 'Dann berührten sich die Zelte in $a und $b aber.';
  }

  @override
  String exCampFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zelte',
      one: 'ein Zelt',
    );
    return 'Dann hätte Zeile $row aber mehr als $_temp0.';
  }

  @override
  String exCampFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zelte',
      one: 'ein Zelt',
    );
    return 'Dann hätte Spalte $col aber mehr als $_temp0.';
  }

  @override
  String exCampFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ihre $count Zelte',
      one: 'ihr Zelt',
    );
    return 'Dann käme Zeile $row aber nicht auf $_temp0.';
  }

  @override
  String exCampFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ihre $count Zelte',
      one: 'ihr Zelt',
    );
    return 'Dann käme Spalte $col aber nicht auf $_temp0.';
  }

  @override
  String get exCampFailTotal => 'Dann gäbe es aber nicht gleich viele Zelte wie Bäume.';

  @override
  String exCampFailTree(Object tree) {
    return 'Dann bliebe dem Baum in $tree aber kein freies Feld für sein Zelt.';
  }

  @override
  String get exCampFailPairing => 'Dann ließen sich Bäume und Zelte aber nicht alle zu Paaren ordnen.';

  @override
  String exIslandsSupposeSea(Object cell) {
    return 'Angenommen, $cell wäre Meer.';
  }

  @override
  String exIslandsSupposeLand(Object cell) {
    return 'Angenommen, $cell wäre Land.';
  }

  @override
  String exIslandsRefutedSea(Object cell) {
    return '$cell ist Meer: Land dort führt zu einem Widerspruch.';
  }

  @override
  String exIslandsRefutedLand(Object cell) {
    return '$cell ist Land: Meer dort führt zu einem Widerspruch.';
  }

  @override
  String exIslandsTotalSea(Object cell) {
    return '$cell ist Meer: die Inseln haben schon ihr ganzes Land.';
  }

  @override
  String exIslandsTotalLand(Object cell) {
    return '$cell ist Land: das Meer kann keine Felder mehr aufnehmen.';
  }

  @override
  String exIslandsPool(Object cell) {
    return '$cell ist Land: Meer dort ergäbe ein 2×2-Becken.';
  }

  @override
  String exIslandsComplete(Object cell, Object island, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle ihre $count Felder',
      one: 'ihr eines Feld',
    );
    return '$cell ist Meer: die Insel bei $island hat schon $_temp0.';
  }

  @override
  String exIslandsExit(Object cell, Object island) {
    return '$cell ist Land: der Insel bei $island fehlen noch Felder, und das ist ihr einziger Ausweg.';
  }

  @override
  String exIslandsBetween(Object cell) {
    return '$cell ist Meer: es berührt zwei verschiedene Inseln mit Zahl.';
  }

  @override
  String exIslandsUnreachable(Object cell) {
    return '$cell ist Meer: keine Insel kann es erreichen.';
  }

  @override
  String exIslandsSeaExit(Object cell, Object sea) {
    return '$cell ist Meer: das Meer bei $sea hat keinen anderen Ausweg, und das ganze Meer hängt zusammen.';
  }

  @override
  String get exIslandsFailTotal => 'Dann gingen Land und Meer aber nicht auf.';

  @override
  String get exIslandsFailInvalid => 'Dann bräche das fertige Feld aber eine Regel.';

  @override
  String exIslandsFailPool(Object cell) {
    return 'Dann bildete das Meer bei $cell aber ein 2×2-Becken.';
  }

  @override
  String exIslandsFailTwoClues(Object a, Object b) {
    return 'Dann lägen die Zahlen in $a und $b aber auf einer Insel.';
  }

  @override
  String exIslandsFailBig(Object island, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    return 'Dann hätte die Insel bei $island aber mehr als $_temp0.';
  }

  @override
  String exIslandsFailShut(Object island) {
    return 'Dann wäre die Insel bei $island aber eingeschlossen, bevor sie vollständig ist.';
  }

  @override
  String exIslandsFailOrphan(Object island) {
    return 'Dann wäre das Land bei $island aber von jeder Zahl abgeschnitten.';
  }

  @override
  String exIslandsFailUnreachable(Object cell) {
    return 'Dann könnte keine Insel das Land in $cell aber erreichen.';
  }

  @override
  String exIslandsFailSeaShut(Object sea) {
    return 'Dann wäre das Meer bei $sea aber vom Rest abgeschnitten.';
  }

  @override
  String exLampsSupposeLamp(Object cell) {
    return 'Angenommen, in $cell stünde eine Lampe.';
  }

  @override
  String exLampsSupposeDot(Object cell) {
    return 'Angenommen, in $cell stünde keine Lampe.';
  }

  @override
  String exLampsRefutedLamp(Object cell) {
    return 'In $cell steht eine Lampe: ohne sie entsteht ein Widerspruch.';
  }

  @override
  String exLampsRefutedDot(Object cell) {
    return '$cell bekommt einen Punkt: eine Lampe dort führt zu einem Widerspruch.';
  }

  @override
  String exLampsLit(Object cell, Object a) {
    return '$cell bekommt einen Punkt: die Lampe in $a scheint darauf, und Lampen scheinen nie aufeinander.';
  }

  @override
  String exLampsWallDone(Object cell, Object wall) {
    return '$cell bekommt einen Punkt: neben der Wand $wall stehen schon so viele Lampen, wie ihre Zahl sagt.';
  }

  @override
  String exLampsWallNeed(Object cell, Object wall) {
    return 'In $cell steht eine Lampe: die Wand $wall braucht in jedem freien Feld daneben eine Lampe.';
  }

  @override
  String exLampsOnlySource(Object cell, Object a) {
    return 'In $cell steht eine Lampe: es ist das einzige Feld, das $a noch beleuchten kann.';
  }

  @override
  String exLampsSelf(Object cell) {
    return 'In $cell steht eine Lampe: nichts anderes kann es beleuchten.';
  }

  @override
  String exLampsFailSee(Object a, Object b) {
    return 'Dann schienen die Lampen in $a und $b aber aufeinander.';
  }

  @override
  String exLampsFailMany(Object wall) {
    return 'Dann stünden neben der Wand $wall aber zu viele Lampen.';
  }

  @override
  String exLampsFailFew(Object wall) {
    return 'Dann kämen neben der Wand $wall aber nicht genug Lampen zusammen.';
  }

  @override
  String exLampsFailDark(Object cell) {
    return 'Dann könnte $cell aber nichts mehr beleuchten.';
  }

  @override
  String exLitsSuppose(Object region, Object cells) {
    return 'Angenommen, im Bereich bei $region wären $cells schattiert.';
  }

  @override
  String exLitsRefuted(Object region, Object cells) {
    return 'Im Bereich bei $region können $cells nicht schattiert sein: das führt zu einem Widerspruch.';
  }

  @override
  String exLitsOverEmpty(Object region) {
    return 'Formen im Bereich bei $region, die ein leeres Feld bedecken, fallen weg.';
  }

  @override
  String exLitsMisses(Object region) {
    return 'Formen im Bereich bei $region, die eines seiner schattierten Felder auslassen, fallen weg.';
  }

  @override
  String exLitsPool(Object region) {
    return 'Formen im Bereich bei $region, die einen schattierten 2×2-Block ergäben, fallen weg.';
  }

  @override
  String exLitsClash(Object region, Object other) {
    return 'Formen im Bereich bei $region, die sich mit jeder Möglichkeit des Bereichs bei $other beißen, fallen weg.';
  }

  @override
  String exLitsCut(Object region) {
    return 'Formen im Bereich bei $region, die die Schattierung zerteilen würden, fallen weg.';
  }

  @override
  String exLitsTwin(Object region, Object other) {
    return 'Formen im Bereich bei $region, die dieselbe Form im Bereich bei $other berühren würden, fallen weg.';
  }

  @override
  String exLitsAll(Object cell, Object region) {
    return '$cell ist schattiert: jede noch mögliche Form des Bereichs bei $region bedeckt es.';
  }

  @override
  String exLitsNone(Object cell, Object region) {
    return '$cell bekommt einen Punkt: keine noch mögliche Form des Bereichs bei $region bedeckt es.';
  }

  @override
  String exLitsFailNoShape(Object region) {
    return 'Dann passte aber keine Form mehr in den Bereich bei $region.';
  }

  @override
  String get exLitsFailCut => 'Dann ließen sich die schattierten Felder aber nicht mehr verbinden.';

  @override
  String exLoopSupposeLine(Object edge) {
    return 'Angenommen, $edge wäre eine Linie.';
  }

  @override
  String exLoopSupposeCross(Object edge) {
    return 'Angenommen, $edge wäre durchgestrichen.';
  }

  @override
  String exLoopRefutedLine(Object edge) {
    return '$edge ist eine Linie: sie durchzustreichen führt zu einem Widerspruch.';
  }

  @override
  String exLoopRefutedCross(Object edge) {
    return '$edge wird durchgestrichen: eine Linie dort führt zu einem Widerspruch.';
  }

  @override
  String exLoopFull(Object edge) {
    return '$edge wird durchgestrichen: an ihrem Ende treffen sich schon zwei Linien, und die Schleife verzweigt sich nie.';
  }

  @override
  String exLoopDeadEnd(Object edge) {
    return '$edge wird durchgestrichen: von ihrem Ende aus käme die Linie nicht weiter.';
  }

  @override
  String exLoopOnlyWay(Object edge) {
    return '$edge ist eine Linie: die Linie, die ihr Ende erreicht, kann nur hier weiter.';
  }

  @override
  String exLoopCloseEarly(Object edge) {
    return '$edge wird durchgestrichen: sie schlösse eine Schleife, bevor das Rätsel gelöst ist.';
  }

  @override
  String exLoopDone(Object edge) {
    return '$edge wird durchgestrichen: die Schleife ist schon geschlossen.';
  }

  @override
  String get exLoopFailBranch => 'Dann träfen sich aber drei Linien in einem Punkt.';

  @override
  String get exLoopFailDeadEnd => 'Dann liefe eine Linie aber in eine Sackgasse.';

  @override
  String get exLoopFailSubloop => 'Dann ergäben die Linien aber mehr als eine Schleife.';

  @override
  String get exLoopFailClues => 'Dann bräche die geschlossene Schleife aber einen Hinweis.';

  @override
  String exFenceDone(Object edge, Object cell) {
    return '$edge wird durchgestrichen: um $cell liegen schon so viele Linien, wie seine Zahl sagt.';
  }

  @override
  String exFenceNeed(Object edge, Object cell) {
    return '$edge ist eine Linie: $cell braucht an jeder noch offenen Seite eine Linie.';
  }

  @override
  String exFenceFailMany(Object cell) {
    return 'Dann lägen um $cell aber mehr Linien, als seine Zahl sagt.';
  }

  @override
  String exFenceFailFew(Object cell) {
    return 'Dann kämen um $cell aber nicht so viele Linien zusammen, wie seine Zahl sagt.';
  }

  @override
  String exLoopFailClash(Object edge) {
    return 'Dann müsste $edge aber zugleich Linie und durchgestrichen sein.';
  }

  @override
  String get exLoopFailOffBoard => 'Dann müsste die Schleife aber das Feld verlassen.';

  @override
  String exPearlsPass(Object edge, Object cell) {
    return '$edge ist eine Linie: die Schleife läuft durch die Perle in $cell, und dort sind nur noch zwei Wege frei.';
  }

  @override
  String exPearlsBlackFar(Object edge, Object cell) {
    return '$edge wird durchgestrichen: von der schwarzen Perle in $cell käme die Schleife hier nicht zwei Felder geradeaus.';
  }

  @override
  String exPearlsBlackStraight(Object edge, Object cell) {
    return '$edge ist eine Linie: nach der schwarzen Perle in $cell läuft die Schleife noch ein Feld geradeaus.';
  }

  @override
  String exPearlsBlackThrough(Object edge, Object cell) {
    return '$edge wird durchgestrichen: an der schwarzen Perle in $cell biegt die Schleife ab, also nicht geradeaus hindurch.';
  }

  @override
  String exPearlsBlackTurn(Object edge, Object cell) {
    return '$edge ist eine Linie: an der schwarzen Perle in $cell biegt die Schleife ab, und die andere Seite ist durchgestrichen.';
  }

  @override
  String exPearlsWhiteLine(Object edge, Object cell) {
    return '$edge ist eine Linie: die Schleife läuft genau so geradeaus durch die weiße Perle in $cell.';
  }

  @override
  String exPearlsWhiteCross(Object edge, Object cell) {
    return '$edge wird durchgestrichen: die Schleife läuft in der anderen Richtung geradeaus durch die weiße Perle in $cell.';
  }

  @override
  String exPearlsWhiteTurnLine(Object edge, Object cell) {
    return '$edge ist eine Linie: die Schleife muss direkt vor oder nach der weißen Perle in $cell abbiegen.';
  }

  @override
  String exPearlsWhiteTurnCross(Object edge, Object cell) {
    return '$edge wird durchgestrichen: die Schleife muss direkt vor oder nach der weißen Perle in $cell abbiegen.';
  }

  @override
  String exPearlsFailPass(Object cell) {
    return 'Dann käme die Schleife aber nicht durch die Perle in $cell.';
  }

  @override
  String exRailsSupposeOn(Object cell) {
    return 'Angenommen, das Gleis liefe durch $cell.';
  }

  @override
  String exRailsSupposeOff(Object cell) {
    return 'Angenommen, $cell hätte kein Gleis.';
  }

  @override
  String exRailsRefutedOn(Object cell) {
    return 'Das Gleis läuft durch $cell: ohne es entsteht ein Widerspruch.';
  }

  @override
  String exRailsRefutedOff(Object cell) {
    return '$cell hat kein Gleis: ein Gleis dort führt zu einem Widerspruch.';
  }

  @override
  String exRailsCellUsed(Object cell) {
    return 'Das Gleis läuft durch $cell: ein Stück Gleis reicht schon hinein.';
  }

  @override
  String exRailsCellEmpty(Object cell) {
    return '$cell hat kein Gleis: das Gleis käme nicht hindurch.';
  }

  @override
  String exRailsPieceFull(Object edge, Object cell) {
    return '$edge wird durchgestrichen: das Gleis läuft schon in $cell hinein und wieder hinaus.';
  }

  @override
  String exRailsPieceEmpty(Object edge, Object cell) {
    return '$edge wird durchgestrichen: $cell hat kein Gleis.';
  }

  @override
  String exRailsPieceNeed(Object edge, Object cell) {
    return '$edge ist Gleis: das Gleis durch $cell hat keinen anderen Weg.';
  }

  @override
  String exRailsRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle ihre $count Gleisfelder',
      one: 'ihr eines Gleisfeld',
    );
    return '$cell hat kein Gleis: Zeile $row hat schon $_temp0.';
  }

  @override
  String exRailsColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle ihre $count Gleisfelder',
      one: 'ihr eines Gleisfeld',
    );
    return '$cell hat kein Gleis: Spalte $col hat schon $_temp0.';
  }

  @override
  String exRailsRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gleisfelder',
      one: 'ein Gleisfeld',
    );
    return 'Das Gleis läuft durch $cell: Zeile $row braucht $_temp0, und genau so viele sind übrig.';
  }

  @override
  String exRailsColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gleisfelder',
      one: 'ein Gleisfeld',
    );
    return 'Das Gleis läuft durch $cell: Spalte $col braucht $_temp0, und genau so viele sind übrig.';
  }

  @override
  String exRailsDoneEdge(Object edge) {
    return '$edge wird durchgestrichen: das Gleis ist schon vollständig.';
  }

  @override
  String exRailsDoneOn(Object cell) {
    return 'Das Gleis läuft durch $cell: es gehört zum fertigen Gleis.';
  }

  @override
  String exRailsDoneOff(Object cell) {
    return '$cell hat kein Gleis: das Gleis ist schon vollständig.';
  }

  @override
  String exRailsCloseEarly(Object edge) {
    return '$edge wird durchgestrichen: sie schlösse eine Schleife oder beendete das Gleis zu früh.';
  }

  @override
  String exRailsFailBranch(Object cell) {
    return 'Dann verzweigte sich das Gleis aber in $cell.';
  }

  @override
  String exRailsFailDeadEnd(Object cell) {
    return 'Dann liefe das Gleis aber in $cell in eine Sackgasse.';
  }

  @override
  String exRailsFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gleisfelder',
      one: 'ein Gleisfeld',
    );
    return 'Dann hätte Zeile $row aber mehr als $_temp0.';
  }

  @override
  String exRailsFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gleisfelder',
      one: 'ein Gleisfeld',
    );
    return 'Dann hätte Spalte $col aber mehr als $_temp0.';
  }

  @override
  String exRailsFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ihre $count Gleisfelder',
      one: 'ihr Gleisfeld',
    );
    return 'Dann käme Zeile $row aber nicht auf $_temp0.';
  }

  @override
  String exRailsFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ihre $count Gleisfelder',
      one: 'ihr Gleisfeld',
    );
    return 'Dann käme Spalte $col aber nicht auf $_temp0.';
  }

  @override
  String get exRailsFailLoop => 'Dann entstünde abseits des Gleises aber eine Schleife.';

  @override
  String get exRailsFailClosed => 'Dann wäre das Gleis aber zu früh fertig.';

  @override
  String exRailsFailClash(Object cell) {
    return 'Dann müsste $cell aber zugleich Gleis haben und keins.';
  }

  @override
  String exArrowsSupposeShade(Object cell) {
    return 'Angenommen, $cell wäre schattiert.';
  }

  @override
  String exArrowsSupposeOn(Object cell) {
    return 'Angenommen, die Schleife liefe durch $cell.';
  }

  @override
  String exArrowsRefutedShade(Object cell) {
    return '$cell ist schattiert: die Schleife hindurch führt zu einem Widerspruch.';
  }

  @override
  String exArrowsRefutedOn(Object cell) {
    return 'Die Schleife läuft durch $cell: es zu schattieren führt zu einem Widerspruch.';
  }

  @override
  String exArrowsCellOn(Object cell) {
    return 'Die Schleife läuft durch $cell: eine Linie reicht schon hinein.';
  }

  @override
  String exArrowsCellShaded(Object cell) {
    return '$cell ist schattiert: die Schleife käme nicht hindurch, und alle anderen Felder liegen auf ihr.';
  }

  @override
  String exArrowsShadeNoLine(Object edge, Object cell) {
    return '$edge wird durchgestrichen: $cell ist schattiert, also bleibt die Schleife draußen.';
  }

  @override
  String exArrowsShadeNeighbours(Object cell, Object a) {
    return 'Die Schleife läuft durch $cell: es berührt das schattierte $a, und schattierte Felder berühren sich nie.';
  }

  @override
  String exArrowsOnNeed(Object edge, Object cell) {
    return '$edge ist eine Linie: die Schleife durch $cell hat keinen anderen Weg.';
  }

  @override
  String exArrowsClueDone(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle seine $count schattierten Felder',
      one: 'sein eines schattiertes Feld',
      zero: 'keine schattierten Felder, wie es sein soll',
    );
    return 'Die Schleife läuft durch $cell: der Pfeil in $clue sieht schon $_temp0.';
  }

  @override
  String exArrowsClueNeedShade(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count schattierte Felder',
      one: 'ein schattiertes Feld',
    );
    return '$cell ist schattiert: der Pfeil in $clue braucht $_temp0, und die passen nur, wenn jedes zweite Feld schattiert ist.';
  }

  @override
  String exArrowsClueNeedOn(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count schattierte Felder',
      one: 'ein schattiertes Feld',
    );
    return 'Die Schleife läuft durch $cell: der Pfeil in $clue braucht $_temp0, und die passen nur, wenn jedes zweite Feld schattiert ist.';
  }

  @override
  String exArrowsFailStuck(Object cell) {
    return 'Dann säße die Schleife in $cell aber fest.';
  }

  @override
  String exArrowsFailClueMany(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count schattierte Felder',
      one: 'ein schattiertes Feld',
      zero: 'null schattierte Felder',
    );
    return 'Dann sähe der Pfeil in $clue aber mehr als $_temp0.';
  }

  @override
  String exArrowsFailClueFew(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'seine $count schattierten Felder',
      one: 'sein schattiertes Feld',
    );
    return 'Dann käme der Pfeil in $clue aber nicht auf $_temp0.';
  }

  @override
  String exArrowsFailClash(Object cell) {
    return 'Dann müsste $cell aber schattiert und zugleich auf der Schleife sein.';
  }

  @override
  String exMinesSupposeMine(Object cell) {
    return 'Angenommen, in $cell läge eine Mine.';
  }

  @override
  String exMinesSupposeSafe(Object cell) {
    return 'Angenommen, $cell wäre sicher.';
  }

  @override
  String exMinesRefutedMine(Object cell) {
    return '$cell ist sicher: eine Mine dort führt zu einem Widerspruch.';
  }

  @override
  String exMinesRefutedSafe(Object cell) {
    return 'In $cell liegt eine Mine: wäre es sicher, entstünde ein Widerspruch.';
  }

  @override
  String exMinesNumberSafe(Object cell, Object number) {
    return '$cell ist sicher: die Zahl in $number hat schon alle ihre Minen um sich.';
  }

  @override
  String exMinesNumberMine(Object cell, Object number) {
    return 'In $cell liegt eine Mine: die Zahl in $number braucht in jedem geschlossenen Feld um sich eine Mine.';
  }

  @override
  String exMinesTotalSafe(Object cell) {
    return '$cell ist sicher: alle Minen sind gefunden.';
  }

  @override
  String exMinesTotalMine(Object cell) {
    return 'In $cell liegt eine Mine: die übrigen Minen füllen jedes geschlossene Feld.';
  }

  @override
  String exMinesPairSafe(Object cell, Object a, Object b) {
    return '$cell ist sicher: vergleicht man die Zahlen in $a und $b, liegen ihre Minen woanders.';
  }

  @override
  String exMinesPairMine(Object cell, Object a, Object b) {
    return 'In $cell liegt eine Mine: vergleicht man die Zahlen in $a und $b, müssen die übrigen Minen hier liegen.';
  }

  @override
  String exMinesFailNumber(Object number) {
    return 'Dann könnte die Zahl in $number aber nicht stimmen.';
  }

  @override
  String get exMinesFailTotal => 'Dann ginge die Zahl der Minen aber nicht auf.';

  @override
  String exMinesFailPair(Object a, Object b) {
    return 'Dann könnten die Zahlen in $a und $b aber nicht beide stimmen.';
  }

  @override
  String exShikakuSuppose(Object clue, Object rect) {
    return 'Angenommen, die Zahl in $clue nähme $rect.';
  }

  @override
  String exShikakuRefuted(Object clue, Object rect) {
    return 'Die Zahl in $clue kann $rect nicht nehmen: das führt zu einem Widerspruch.';
  }

  @override
  String exShikakuOverlap(Object clue, Object other) {
    return 'Rechtecke für $clue, die das von $other überlappen, fallen weg.';
  }

  @override
  String exShikakuOwner(Object clue, Object cell) {
    return 'Nur die Zahl in $clue kann $cell noch abdecken, also muss ihr Rechteck es einschließen.';
  }

  @override
  String exShikakuCommon(Object clue, Object cell, Object other) {
    return 'Jedes Rechteck, das für $clue bleibt, deckt $cell ab, also fallen Rechtecke für $other, die es abdecken, weg.';
  }

  @override
  String exShikakuFixed(Object clue, Object rect) {
    return 'Die Zahl in $clue nimmt $rect: es ist das einzige Rechteck, das ihr bleibt.';
  }

  @override
  String exShikakuFailNone(Object clue) {
    return 'Dann bliebe für die Zahl in $clue aber kein Rechteck übrig.';
  }

  @override
  String exShikakuFailUncovered(Object cell) {
    return 'Dann könnte $cell aber nichts mehr abdecken.';
  }

  @override
  String exAtomsSuppose(Object edge, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bindungen',
      one: 'eine Bindung',
      zero: 'keine Bindung',
    );
    return 'Angenommen, $edge hätte $_temp0.';
  }

  @override
  String exAtomsRefutedMore(Object edge, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bindungen',
      one: 'eine Bindung',
    );
    return '$edge bekommt mindestens $_temp0: weniger führt zu einem Widerspruch.';
  }

  @override
  String exAtomsRefutedLess(int count, Object edge) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$edge bekommt höchstens $count Bindungen: mehr führt zu einem Widerspruch.',
      one: '$edge bekommt höchstens eine Bindung: mehr führt zu einem Widerspruch.',
      zero: '$edge bekommt keine Bindung: jede Bindung dort führt zu einem Widerspruch.',
    );
    return '$_temp0';
  }

  @override
  String exAtomsAtLeast(Object edge, int count, Object atom) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bindungen',
      one: 'eine Bindung',
    );
    return '$edge bekommt mindestens $_temp0: sonst erreicht das Atom in $atom seine Zahl nicht.';
  }

  @override
  String exAtomsAtMost(int count, Object edge, Object atom) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$edge bekommt höchstens $count Bindungen: mehr überschritte die Zahl des Atoms in $atom.',
      one: '$edge bekommt höchstens eine Bindung: mehr überschritte die Zahl des Atoms in $atom.',
      zero: '$edge bekommt keine Bindung: jede überschritte die Zahl des Atoms in $atom.',
    );
    return '$_temp0';
  }

  @override
  String exAtomsCross(Object edge, Object other) {
    return '$edge bekommt keine Bindung: sie kreuzte die Bindung $other.';
  }

  @override
  String exAtomsFailSum(Object atom) {
    return 'Dann bekäme das Atom in $atom aber nicht seine Zahl an Bindungen.';
  }

  @override
  String exAtomsFailCross(Object a, Object b) {
    return 'Dann kreuzten sich die Bindungen $a und $b aber.';
  }

  @override
  String get exAtomsFailConnect => 'Dann ließen sich die Atome aber nicht zu einem Molekül verbinden.';

  @override
  String exTrailSupposeOn(Object edge) {
    return 'Angenommen, der Pfad nähme $edge.';
  }

  @override
  String exTrailSupposeOff(Object edge) {
    return 'Angenommen, der Pfad nähme $edge nicht.';
  }

  @override
  String exTrailRefutedOn(Object edge) {
    return 'Der Pfad nimmt $edge: sonst entsteht ein Widerspruch.';
  }

  @override
  String exTrailRefutedOff(Object edge) {
    return 'Der Pfad nimmt $edge nicht: sonst entsteht ein Widerspruch.';
  }

  @override
  String exTrailDegreeDone(Object edge, Object cell) {
    return 'Der Pfad nimmt $edge nicht: er läuft schon in $cell hinein und wieder hinaus.';
  }

  @override
  String exTrailEndDone(Object edge, Object cell) {
    return 'Der Pfad nimmt $edge nicht: sein Ende in $cell ist schon angeschlossen.';
  }

  @override
  String exTrailDegreeNeed(Object edge, Object cell) {
    return 'Der Pfad nimmt $edge: der Pfad durch $cell hat keinen anderen Weg.';
  }

  @override
  String exTrailLoop(Object edge) {
    return 'Der Pfad nimmt $edge nicht: das schlösse eine Schleife.';
  }

  @override
  String exTrailOrder(Object edge) {
    return 'Der Pfad nimmt $edge nicht: das verbände die Zahlen in falscher Reihenfolge.';
  }

  @override
  String exTrailEarly(Object edge) {
    return 'Der Pfad nimmt $edge nicht: das verbände Anfang und Ende, bevor jedes Feld besucht ist.';
  }

  @override
  String exTrailFailBranch(Object cell) {
    return 'Dann verzweigte sich der Pfad aber in $cell.';
  }

  @override
  String exTrailFailStuck(Object cell) {
    return 'Dann säße der Pfad in $cell aber fest.';
  }

  @override
  String get exTrailFailOrder => 'Dann kämen die Zahlen aber in falscher Reihenfolge.';

  @override
  String get exTrailFailLoop => 'Dann schlössen sich einige Felder aber zu einer eigenen Schleife.';

  @override
  String get exTrailFailConnect => 'Dann erreichte der Pfad aber nicht jedes Feld.';

  @override
  String exLinksSupposeOn(Object edge) {
    return 'Angenommen, ein Pfad liefe über $edge.';
  }

  @override
  String exLinksSupposeOff(Object edge) {
    return 'Angenommen, kein Pfad liefe über $edge.';
  }

  @override
  String exLinksRefutedOn(Object edge) {
    return 'Ein Pfad läuft über $edge: sonst entsteht ein Widerspruch.';
  }

  @override
  String exLinksRefutedOff(Object edge) {
    return 'Kein Pfad läuft über $edge: ein Pfad dort führt zu einem Widerspruch.';
  }

  @override
  String exLinksDegreeDone(Object edge, Object cell) {
    return 'Kein Pfad läuft über $edge: ein Pfad läuft schon in $cell hinein und wieder hinaus.';
  }

  @override
  String exLinksDotDone(Object edge, Object cell) {
    return 'Kein Pfad läuft über $edge: der Pfad vom Punkt in $cell verlässt ihn schon.';
  }

  @override
  String exLinksDegreeNeed(Object edge, Object cell) {
    return 'Ein Pfad läuft über $edge: der Pfad durch $cell hat keinen anderen Weg.';
  }

  @override
  String exLinksDotNeed(Object edge, Object cell) {
    return 'Ein Pfad läuft über $edge: es ist der einzige Weg, der vom Punkt in $cell noch bleibt.';
  }

  @override
  String exLinksLoop(Object edge) {
    return 'Kein Pfad läuft über $edge: das schlösse eine Schleife.';
  }

  @override
  String exLinksMixed(Object edge) {
    return 'Kein Pfad läuft über $edge: das verbände Pfade zweier verschiedener Paare.';
  }

  @override
  String exLinksFailBranch(Object cell) {
    return 'Dann verzweigte sich ein Pfad aber in $cell.';
  }

  @override
  String exLinksFailStuck(Object cell) {
    return 'Dann säße ein Pfad in $cell aber fest.';
  }

  @override
  String get exLinksFailLoop => 'Dann schlösse sich ein Pfad aber zu einer Schleife.';

  @override
  String get exLinksFailMixed => 'Dann verbände ein Pfad aber zwei verschiedene Paare.';

  @override
  String get tallyName => 'Summen';

  @override
  String get tallyTagline => 'Streich Zahlen, bis jede Reihe aufgeht';

  @override
  String get tallyRules =>
      '• In jedem Feld steht eine Zahl. Streich einige davon durch.\n• Die übrigen Zahlen jeder Zeile und Spalte ergeben zusammen die Zahl außerhalb des Gitters.\n\nTippe auf ein Feld, um zu wechseln: durchgestrichen → eingekreist (deine Notiz „bleibt“) → leer. Langes Drücken / Rechtsklick wechselt zurück. Kreise sind freiwillig: Das Rätsel ist gelöst, sobald die richtigen Zahlen durchgestrichen sind.';

  @override
  String get tutTally1 =>
      'Streich Zahlen durch, sodass die übrigen in jeder Zeile und Spalte zusammen die Zahl außen ergeben. Tippe einmal auf eine Zahl, um sie durchzustreichen. Eine 7 kann nicht in einer Zeile mit der Summe 2 bleiben.';

  @override
  String get tutTally2 =>
      'Eine Zahl, die größer ist als die Summe ihrer Zeile oder Spalte, muss immer weg. Die markierte 8 steht in einer Zeile mit der Summe 6: Streich sie durch und löse dann das Gitter.';

  @override
  String get tutTally3 =>
      'Die Zahlen der oberen Zeile ergeben 15, sie braucht aber 12, also darf nur die 3 weg: Die 8 und die 4 bleiben. Tippe zweimal, um eine bleibende Zahl einzukreisen, und löse dann das Gitter.';

  @override
  String get tutTally4 =>
      'Jetzt ein echtes Gitter. Fang mit Reihen an, deren Summe klein ist oder fast so groß wie alle ihre Zahlen zusammen.';

  @override
  String get tutTallyS1 =>
      'Probier alle Wege, die Summe einer Reihe zu bilden. Eine Zahl, die in jedem Weg vorkommt, bleibt; eine, die in keinem vorkommt, muss weg: 7 aus 5, 4 und 3 geht nur als 4 + 3, also muss die 5 weg.';

  @override
  String get tutTallyS2 =>
      'Ein schweres Gitter. Wenn du feststeckst, streich eine Zahl durch und folge den Summen: Kann eine Zeile oder Spalte dann nicht mehr aufgehen, bleibt diese Zahl.';

  @override
  String exTallySupposeKeep(Object cell) {
    return 'Angenommen, $cell bliebe.';
  }

  @override
  String exTallySupposeCross(Object cell) {
    return 'Angenommen, $cell wäre durchgestrichen.';
  }

  @override
  String exTallyRefutedKeep(Object cell) {
    return '$cell bleibt: Durchstreichen führt zu einem Widerspruch.';
  }

  @override
  String exTallyRefutedCross(Object cell) {
    return '$cell wird durchgestrichen: Behalten führt zu einem Widerspruch.';
  }

  @override
  String exTallyRowTooBig(Object cell, Object row, int digit, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'die $digit ist mehr als die $left, die Zeile $row noch fehlen',
      zero: 'Zeile $row hat ihre Summe schon erreicht',
    );
    return '$cell wird durchgestrichen: $_temp0.';
  }

  @override
  String exTallyColTooBig(Object cell, Object col, int digit, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'die $digit ist mehr als die $left, die Spalte $col noch fehlen',
      zero: 'Spalte $col hat ihre Summe schon erreicht',
    );
    return '$cell wird durchgestrichen: $_temp0.';
  }

  @override
  String exTallyRowNeeded(Object cell, Object row, int digit, int sum) {
    return '$cell bleibt: Ohne die $digit erreicht Zeile $row ihre $sum nicht.';
  }

  @override
  String exTallyColNeeded(Object cell, Object col, int digit, int sum) {
    return '$cell bleibt: Ohne die $digit erreicht Spalte $col ihre $sum nicht.';
  }

  @override
  String exTallyRowEveryKeep(Object cell, Object row, int sum) {
    return '$cell bleibt: Jeder Weg, in Zeile $row $sum zu bilden, nutzt diese Zahl.';
  }

  @override
  String exTallyColEveryKeep(Object cell, Object col, int sum) {
    return '$cell bleibt: Jeder Weg, in Spalte $col $sum zu bilden, nutzt diese Zahl.';
  }

  @override
  String exTallyRowEveryCross(Object cell, Object row, int sum) {
    return '$cell wird durchgestrichen: Kein Weg, in Zeile $row $sum zu bilden, nutzt diese Zahl.';
  }

  @override
  String exTallyColEveryCross(Object cell, Object col, int sum) {
    return '$cell wird durchgestrichen: Kein Weg, in Spalte $col $sum zu bilden, nutzt diese Zahl.';
  }

  @override
  String exTallyFailRowOver(Object row, int sum) {
    return 'Dann ergäbe Zeile $row aber mehr als $sum.';
  }

  @override
  String exTallyFailColOver(Object col, int sum) {
    return 'Dann ergäbe Spalte $col aber mehr als $sum.';
  }

  @override
  String exTallyFailRowShort(Object row, int sum) {
    return 'Dann erreicht Zeile $row ihre $sum aber nicht mehr.';
  }

  @override
  String exTallyFailColShort(Object col, int sum) {
    return 'Dann erreicht Spalte $col ihre $sum aber nicht mehr.';
  }

  @override
  String exTallyFailRowNoWay(Object row, int sum) {
    return 'Dann ergibt aber keine Auswahl der Zahlen in Zeile $row $sum.';
  }

  @override
  String exTallyFailColNoWay(Object col, int sum) {
    return 'Dann ergibt aber keine Auswahl der Zahlen in Spalte $col $sum.';
  }

  @override
  String get formulaName => 'Formel';

  @override
  String get formulaTagline => 'Errate die versteckte Gleichung';

  @override
  String get formulaRules =>
      '• Eine Gleichung ist versteckt. Finde sie in sechs Versuchen.\n• Jeder Versuch muss eine wahre Gleichung sein, die die Zeile füllt: eine Rechnung, dann = und ihr Ergebnis.\n• Jedes Feld eines Versuchs wird markiert. Gefüllt: richtiges Zeichen am richtigen Platz. Umrandet: kommt in der Gleichung vor, aber woanders. Blass: kommt nicht vor (oder nicht so oft).\n• Die übliche Reihenfolge: erst Klammern, dann Potenzen, dann × und ÷, dann + und −.\n\nLeichte Gleichungen addieren und subtrahieren nur, mittlere multiplizieren oder dividieren auch, schwere haben Klammern oder Potenzen (3² = 3 × 3, 2³ = 2 × 2 × 2). Die Tasten merken sich die Markierungen. Tippe ein Feld an, um dort zu schreiben. Ein Versuch lässt sich nicht zurücknehmen; sind die Zeilen voll, starte neu.';

  @override
  String get formulaIncomplete => 'Fülle erst die ganze Zeile';

  @override
  String get formulaMalformed => 'Keine Gleichung: eine Rechnung, dann = und eine Zahl';

  @override
  String get formulaUntrue => 'Die beiden Seiten sind nicht gleich';

  @override
  String get formulaOutOfGuesses => 'Keine Versuche mehr: starte neu';

  @override
  String formulaSolvedIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count Versuchen gelöst',
      one: 'Beim ersten Versuch!',
    );
    return '$_temp0';
  }

  @override
  String get tutFormula1 =>
      'Hinter diesem Brett steckt eine Gleichung. Jeder Versuch ist eine wahre Gleichung, die eine Zeile füllt. Tippe 1+4=5 (oder eine andere) und drücke „Prüfen“.';

  @override
  String get tutFormula2 =>
      'Ein Versuch markiert seine Felder. Gefüllt: richtiges Zeichen am richtigen Platz. Umrandet: kommt vor, aber woanders. Blass: kommt nicht vor. Hier steht = richtig, 4, 5 und 9 gehören woandershin, und ein + gibt es nicht. Finde die Gleichung.';

  @override
  String get tutFormula3 =>
      'Die erste 2 steht richtig, die zweite ist blass: Die Gleichung hat nur eine 2. Die Tasten unten merken sich jede Markierung. Löse das Brett.';

  @override
  String get tutFormula4 =>
      'Jetzt ein echtes Brett: sechs Versuche für eine Gleichung aus sechs Feldern. Sie addiert oder subtrahiert nur.';

  @override
  String get tutFormulaS1 =>
      'Beginne mit einem Versuch, der viele verschiedene Zeichen prüft: Je mehr Felder markiert werden, desto mehr erfährst du. Gib eine Gleichung mit mindestens sieben verschiedenen Zeichen ein, etwa 9×8−7=65.';

  @override
  String get tutFormulaS2 =>
      'Schwere Bretter haben Klammern und Potenzen: 3² ist 3 × 3, 2³ ist 2 × 2 × 2. Erst werden Klammern gerechnet, dann Potenzen, dann × und ÷, dann + und −. Finde die Gleichung.';

  @override
  String get tutFormulaS3 =>
      'Das große: zehn Felder mit einer Klammer oder Potenz. Finde zuerst, wo das = steht: Es verrät, wie lang das Ergebnis ist.';

  @override
  String get orbitsName => 'Orbits';

  @override
  String get orbitsTagline => 'Gib jedem Stern ein Gebiet, das sich um ihn dreht';

  @override
  String get orbitsRules =>
      '• Teile das ganze Gitter in Gebiete, eines für jeden Stern.\n• Ein Gebiet ist ein zusammenhängendes Stück mit seinem Stern genau in der Mitte.\n• Nach einer halben Drehung um den Stern sieht das Gebiet gleich aus: Jedes Feld hat einen Zwilling auf der gegenüberliegenden Seite des Sterns.\n\nZiehe von einem Stern oder von einem Feld seines Gebiets über die Felder, die dazukommen sollen; jedes bringt seinen Zwilling mit. Oder tippe auf einen Stern, um ihn auszuwählen, und dann auf die Felder, die er bekommen soll, auch abseits seines Gebiets. Tippe auf ein Feld des ausgewählten Sterns (oder auf ein beliebiges gefülltes Feld, wenn kein Stern ausgewählt ist), um es und seinen Zwilling zu leeren.';

  @override
  String get tutOrbits1 =>
      'Teile das Gitter in Gebiete, eines für jeden Stern. Der Stern liegt genau in der Mitte seines Gebiets, also hat jedes Feld einen Zwilling auf der gegenüberliegenden Seite. Ziehe vom Stern in der rechten Spalte zum Feld darüber: Der Zwilling darunter wird mit gefüllt.';

  @override
  String get tutOrbits2 =>
      'Ein Stern kann in einem Feld liegen, auf der Linie zwischen zwei Feldern oder auf einer Ecke, an der vier zusammentreffen. Die Felder, die er berührt, gehören ihm von Anfang an. Gib jedes übrige Feld einem Stern: Ziehe vom Stern aus oder tippe auf den Stern und dann auf die Felder. Tippe auf ein Feld des ausgewählten Sterns, um es und seinen Zwilling zu leeren.';

  @override
  String get tutOrbits3 =>
      'Ein Gebiet kann jede Form haben, solange es ein Stück ist und nach einer halben Drehung um seinen Stern gleich aussieht. Ein Feld kann nicht zu einem Stern gehören, wenn sein Zwilling außerhalb des Gitters oder auf dem Feld eines anderen Sterns läge.';

  @override
  String get tutOrbits4 =>
      'Jetzt ein echtes Gitter. Beginne mit Feldern, die nur ein Stern nehmen kann: Ecken und Ränder sind gute Stellen dafür.';

  @override
  String get tutOrbitsS1 =>
      'Halte Gebiete in einem Stück. Gehört ein Feld zu einem Stern, ist aber noch nicht mit ihm verbunden, dann sieh dir die Wege dorthin an: Ein Feld, durch das jeder Weg führt, gehört ebenfalls zum Stern, genau wie sein Zwilling.';

  @override
  String get tutOrbitsS2 =>
      'Ein schweres Gitter. Wenn nichts sicher ist, wähle ein Feld, das nur zwei Sterne nehmen können, und probiere einen aus: Bleibt dann irgendein Feld ganz ohne Stern, gehört das Feld dem anderen Stern.';

  @override
  String exOrbitsOnly(Object cell, Object star) {
    return '$cell gehört zum Stern bei $star: Kein anderer Stern kann es nehmen.';
  }

  @override
  String exOrbitsTwin(Object cell, Object star, Object other) {
    return '$cell gehört zum Stern bei $star: Es ist der Zwilling von $other.';
  }

  @override
  String exOrbitsBridge(Object cell, Object star, Object other) {
    return '$cell gehört zum Stern bei $star: Ohne es wäre $other von diesem Stern abgeschnitten.';
  }

  @override
  String exOrbitsTwinOut(Object cell, Object star, Object other) {
    return '$cell kann nicht zum Stern bei $star gehören: Sein Zwilling $other kann es nicht.';
  }

  @override
  String exOrbitsReach(Object cell, Object star) {
    return '$cell kann nicht zum Stern bei $star gehören: Es lässt sich nicht mehr mit diesem Stern verbinden.';
  }

  @override
  String exOrbitsFailEmpty(Object cell) {
    return 'Dann bliebe für $cell aber kein Stern übrig.';
  }

  @override
  String exOrbitsSuppose(Object cell, Object star) {
    return 'Angenommen, $cell gehörte zum Stern bei $star.';
  }

  @override
  String exOrbitsRefuted(Object cell, Object star) {
    return '$cell kann nicht zum Stern bei $star gehören: Das führt zu einem Widerspruch.';
  }

  @override
  String get inlayName => 'Intarsie';

  @override
  String get inlayTagline => 'Füge jedes Teil in die Form';

  @override
  String get inlayRules =>
      '• Fülle die Form mit allen Teilen aus der Ablage. Jedes Feld der Form wird bedeckt, und Teile überlappen sich nie.\n• Jede Lösung, bei der alle Teile passen, gewinnt.\n• Teile dürfen gedreht werden. Auf schweren Gittern dürfen sie auch gespiegelt werden.\n\nZieh ein Teil auf die Form: Es rastet an den Feldern ein. Zieh ein gelegtes Teil, um es zu verschieben, oder aus der Form heraus, um es in die Ablage zurückzulegen. Tippe auf ein Teil, um es eine Vierteldrehung zu drehen. Auf schweren Gittern spiegelt „Spiegeln“ das zuletzt berührte Teil (am Computer: Rechtsklick auf ein Teil).';

  @override
  String get inlayFlip => 'Spiegeln';

  @override
  String get inlayNoRoom => 'Hier ist kein Platz zum Drehen';

  @override
  String get tutInlay1 =>
      'Zieh jedes Teil aus der Ablage auf die Form. Es rastet an den Feldern ein. Bedecke die ganze Form mit den Teilen.';

  @override
  String get tutInlay2 =>
      'Tippe auf ein Teil, um es eine Vierteldrehung zu drehen, in der Ablage oder auf dem Gitter. Dreh diese Teile so, dass sie passen.';

  @override
  String get tutInlay3 =>
      'Der Balken auf dem Gitter lässt den anderen Teilen keinen Platz. Zieh ein gelegtes Teil, um es zu verschieben, oder aus der Form heraus, um es in die Ablage zurückzulegen.';

  @override
  String get tutInlay4 =>
      'Auf schweren Gittern lässt sich ein Teil auch spiegeln. Berühre ein Teil und tippe dann auf „Spiegeln“ (am Computer: Rechtsklick darauf). Ein Teil passt hier nur gespiegelt.';

  @override
  String get tutInlay5 => 'Jetzt ein echtes Gitter. Jede Lösung, bei der alle Teile passen, gewinnt.';

  @override
  String get tutInlayS1 =>
      'Beginne dort, wo die Teile am wenigsten Wege haben: in Ecken, schmalen Armen und kleinen Nischen. Das Feld an der Spitze des Arms hat nur einen Nachbarn: Finde das Teil, das dort passt, und lege es zuerst.';

  @override
  String get tutInlayS2 =>
      'Lege die größten und sperrigsten Teile zuerst, solange noch Platz für sie ist; kleine Teile füllen die letzten Lücken. Achte auf Nischen: Eine Lücke, die kleiner ist als jedes übrige Teil, heißt, dass ein Teil umziehen muss. Auf schweren Gittern passen manche Teile nur gespiegelt.';

  @override
  String get skylineName => 'Skyline';

  @override
  String get skylineTagline => 'Wie viele Türme siehst du von jeder Seite?';

  @override
  String get skylineRules =>
      '• Stell in jedes Feld einen Turm mit 1 bis N Stockwerken (N = Gittergröße).\n• Jede Zeile und jede Spalte enthält jede Höhe genau einmal.\n• Eine Zahl außerhalb des Gitters gibt an, wie viele Türme man von dort aus entlang der Zeile oder Spalte sieht: Ein Turm verdeckt alle niedrigeren dahinter.\n\nWähle eine Höhe in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Höhe. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld.';

  @override
  String get tutSkyline1 =>
      'Bau eine Skyline: Jede Zeile und Spalte hat je einen Turm jeder Höhe von 1 bis 4. Hier fehlt einer: Wähle seine Höhe in der Palette und tippe auf das leere Feld.';

  @override
  String get tutSkyline2 =>
      'Ein Hinweis zählt die Türme, die man von seiner Seite sieht: Jeder Turm verdeckt die niedrigeren dahinter. Links von der obersten Zeile steht 2. Füll die leeren Felder so, dass von dort nur zwei Türme zu sehen sind.';

  @override
  String get tutSkyline3 =>
      'Eine 1 heißt: Der höchste Turm steht direkt am Hinweis und verdeckt alle anderen. Eine 4 heißt: Alle Türme sind zu sehen, also steigen sie an: 1, 2, 3, 4. Füll die Zeile.';

  @override
  String get tutSkyline4 =>
      'Jetzt ein ganzes Gitter. Notier mit dem Stift die Höhen, die in einem Feld noch gehen, und lass die Hinweise sie eingrenzen.';

  @override
  String get tutSkylineS1 =>
      'Der höchste Turm verdeckt alles dahinter, also steht er bei einer 3 nicht in den ersten beiden Feldern. Allgemein brauchen große Hinweise niedrige Türme in ihrer Nähe: neben einer 3 auf einem 5×5-Gitter höchstens 3 Stockwerke.';

  @override
  String get tutSkylineS2 =>
      'Kommst du nicht weiter? Nimm eine Zeile oder Spalte mit Hinweisen und geh alle Arten durch, sie passend zu deinen Notizen und ihren Hinweisen zu füllen. Eine Höhe, die nie in einem Feld landet, kannst du dort streichen.';

  @override
  String get tutSkylineS3 =>
      'Die schwersten Gitter brauchen eine Annahme, die sich widerlegen lässt. Nimm an, ein Feld hat eine seiner letzten zwei oder drei Höhen, und denk weiter; führt das zu einem Widerspruch, streich die Höhe.';

  @override
  String exLatinNaked(Object cell, Object value) {
    return 'In $cell muss $value stehen: alle anderen Zahlen sind dort ausgeschlossen.';
  }

  @override
  String exLatinHiddenRow(Object cell, Object value, Object row) {
    return 'In $cell muss $value stehen: es ist der einzige Platz für $value in Zeile $row.';
  }

  @override
  String exLatinHiddenCol(Object cell, Object value, Object col) {
    return 'In $cell muss $value stehen: es ist der einzige Platz für $value in Spalte $col.';
  }

  @override
  String exLatinPairRow(Object a, Object b, Object v1, Object v2, Object row) {
    return 'In $a und $b können nur $v1 und $v2 stehen, also kommen diese Zahlen sonst nirgends in Zeile $row vor.';
  }

  @override
  String exLatinPairCol(Object a, Object b, Object v1, Object v2, Object col) {
    return 'In $a und $b können nur $v1 und $v2 stehen, also kommen diese Zahlen sonst nirgends in Spalte $col vor.';
  }

  @override
  String exLatinFailEmpty(Object cell) {
    return 'Dann bliebe für $cell aber keine Zahl übrig.';
  }

  @override
  String exLatinFailNoPlaceRow(Object value, Object row) {
    return 'Dann hätte $value in Zeile $row aber keinen Platz mehr.';
  }

  @override
  String exLatinFailNoPlaceCol(Object value, Object col) {
    return 'Dann hätte $value in Spalte $col aber keinen Platz mehr.';
  }

  @override
  String exSkylineBound(Object clue, Object side, Object cell, Object max) {
    return 'Die $clue bei $side braucht so viele sichtbare Türme, also steht in $cell höchstens $max.';
  }

  @override
  String exSkylineTallest(Object cell, Object value, Object side) {
    return 'In $cell muss $value stehen: Die 1 bei $side sieht nur den höchsten Turm.';
  }

  @override
  String exSkylineLineRow(Object cell, Object value, Object row) {
    return 'In $cell kann kein $value stehen: Keine Art, Zeile $row passend zu ihren Hinweisen zu füllen, setzt es dorthin.';
  }

  @override
  String exSkylineLineCol(Object cell, Object value, Object col) {
    return 'In $cell kann kein $value stehen: Keine Art, Spalte $col passend zu ihren Hinweisen zu füllen, setzt es dorthin.';
  }

  @override
  String exSkylineFailRow(Object row) {
    return 'Dann ließe sich Zeile $row aber nicht passend zu ihren Hinweisen füllen.';
  }

  @override
  String exSkylineFailCol(Object col) {
    return 'Dann ließe sich Spalte $col aber nicht passend zu ihren Hinweisen füllen.';
  }

  @override
  String get famLatin => 'Lateinische Quadrate';

  @override
  String get famLatinAbout => 'Jede Zahl einmal in jeder Zeile und Spalte, und die Hinweise verraten mehr';

  @override
  String get cagesName => 'Käfige';

  @override
  String get cagesTagline => 'Addiere, subtrahiere, multipliziere und teile, um jeden Käfig zu füllen';

  @override
  String get cagesRules =>
      '• Füll das Gitter mit den Zahlen 1 bis N (N = Gittergröße), jede einmal in jeder Zeile und Spalte.\n• Dicke Umrisse teilen das Gitter in Käfige. Die Zahlen eines Käfigs ergeben den Hinweis in seiner Ecke mit dem gezeigten Zeichen: addiert (+), multipliziert (×) oder, in einem Käfig aus zwei Feldern, die größere minus die kleinere (−) oder die größere geteilt durch die kleinere (÷). Ein Käfig aus einem Feld enthält einfach seine Zahl.\n• Eine Zahl darf sich in einem Käfig wiederholen, nur nicht in derselben Zeile oder Spalte.\n\nWähle eine Zahl in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Zahl. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld.';

  @override
  String get tutCages1 =>
      'Jede Zeile und Spalte enthält 1 bis 4 je einmal. Die Umrisse fassen Felder zu Käfigen zusammen, und die Zahlen eines Käfigs ergeben seinen Hinweis: In einem 7+-Käfig ist ihre Summe 7. Füll die leeren Felder.';

  @override
  String get tutCages2 =>
      'In einem Käfig aus zwei Feldern heißt − die größere Zahl minus die kleinere und ÷ die größere geteilt durch die kleinere; die größere darf in jedem der beiden stehen. Füll die oberen zwei Zeilen.';

  @override
  String get tutCages3 =>
      '× multipliziert. Eine Zahl darf sich in einem Käfig wiederholen, solange sie nicht zweimal in einer Zeile oder Spalte steht, etwa 1 × 2 × 1 für 2×. Zeilen und Spalten allein lassen hier zwei Möglichkeiten: Die Käfige wählen eine.';

  @override
  String get tutCages4 =>
      'Jetzt ein ganzes Gitter. Fang mit Käfigen an, die sich auf wenige Arten bilden lassen, notier mit dem Stift, was in einem Feld noch geht, und lass Zeilen und Spalten es eingrenzen.';

  @override
  String get tutCagesS1 =>
      'Geh die Arten durch, einen Käfig zu bilden. Zwei Felder mit 3+ sind nur 1 und 2; ein 4− auf einem 5×5-Gitter ist 1 und 5. Eine Zahl, die keine Art in ein Feld setzt, kannst du dort streichen.';

  @override
  String get tutCagesS2 =>
      'Setzt jede Art, einen Käfig zu füllen, eine Zahl in seine Felder einer Zeile, kann kein anderes Feld der Zeile sie haben. Ein 2÷ in einer Zeile auf einem 5×5-Gitter ist 1 und 2 oder 2 und 4: so oder so eine 2. Und wenn zwei Felder einer Zeile nur dieselben zwei Zahlen haben können, gehören diese ihnen.';

  @override
  String get tutCagesS3 =>
      'Die schwersten Gitter brauchen eine Annahme, die sich widerlegen lässt. Nimm an, ein Feld hat eine seiner letzten zwei oder drei Zahlen, und denk weiter; führt das zu einem Widerspruch, streich die Zahl.';

  @override
  String exCagesSingle(Object cell, Object value) {
    return 'In $cell muss $value stehen: Sein Käfig ist nur dieses eine Feld.';
  }

  @override
  String exCagesCombo(Object clue, Object cage, Object values, Object cell) {
    return 'Keine Art, den $clue-Käfig bei $cage zu füllen, setzt $values in $cell.';
  }

  @override
  String exCagesRequiredRow(Object clue, Object cage, Object values, Object row, Object cell) {
    return 'Jede Art, den $clue-Käfig bei $cage zu füllen, setzt $values in seine Felder in Zeile $row, also nicht in $cell.';
  }

  @override
  String exCagesRequiredCol(Object clue, Object cage, Object values, Object col, Object cell) {
    return 'Jede Art, den $clue-Käfig bei $cage zu füllen, setzt $values in seine Felder in Spalte $col, also nicht in $cell.';
  }

  @override
  String exCagesFail(Object clue, Object cage) {
    return 'Dann ließe sich der $clue-Käfig bei $cage aber nicht füllen.';
  }

  @override
  String get signsName => 'Zeichen';

  @override
  String get signsTagline => 'Folge den Zeichen: Welche Zahl ist größer?';

  @override
  String get signsRules =>
      '• Füll das Gitter mit den Zahlen 1 bis N (N = Gittergröße), jede einmal in jeder Zeile und Spalte.\n• Ein Zeichen zwischen zwei benachbarten Feldern zeigt mit der Spitze auf die kleinere Zahl, wie bei 2 < 3: Die offene Seite zeigt zur größeren. Zeichen gelten in Zeilen und in Spalten.\n• Ein paar Zahlen können vorgegeben sein.\n\nWähle eine Zahl in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Zahl. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld.';

  @override
  String get tutSigns1 =>
      'Jede Zeile und Spalte enthält 1 bis 4 je einmal. Ein Zeichen zwischen zwei Feldern zeigt auf die kleinere Zahl, wie bei 1 < 2, auch von oben nach unten. Zeilen und Spalten allein erlauben hier zwei Wege: Lass die Zeichen einen wählen.';

  @override
  String get tutSigns2 =>
      'Zeichen können eine Kette bilden: Jedes Feld der dritten Zeile ist größer als das nächste. Das erste hat drei kleinere hinter sich, also ist es 4, und das letzte ist 1. Füll die unteren zwei Zeilen.';

  @override
  String get tutSigns3 =>
      'Das zweite Feld der zweiten Zeile ist größer als seine beiden Nachbarn. Die brauchen zwei verschiedene kleinere Zahlen, also kann es nicht 1 oder 2 sein. Füll die oberen zwei Zeilen.';

  @override
  String get tutSigns4 =>
      'Jetzt ein ganzes Gitter. Fang dort an, wo sich Zeichen häufen oder eine Zahl vorgegeben ist, notier mit dem Stift, was in ein Feld noch passt, und lass Zeilen und Spalten die Auswahl eingrenzen.';

  @override
  String get tutSignsS1 =>
      'Folge den Zeichen. Ein Feld, das kleiner als sein Nachbar ist, erreicht nicht dessen größte noch mögliche Zahl, und ein größeres sinkt nicht auf dessen kleinste. In einer Kette a < b < c ist das erste höchstens N − 2. Streich, was die Zeichen ausschließen.';

  @override
  String get tutSignsS2 =>
      'Ein Feld, das größer als beide Nachbarn in einer Zeile ist, braucht zwei verschiedene Zahlen darunter, also ist es mindestens 3; eine Reihe von Zeichen zählt genauso. Und wenn zwei Felder einer Zeile nur dieselben zwei Zahlen haben können, gehören die beiden Zahlen ihnen.';

  @override
  String get tutSignsS3 =>
      'Die schwersten Gitter brauchen eine Annahme, die sich widerlegen lässt. Nimm an, ein Feld hat eine seiner letzten zwei oder drei Zahlen, und denk weiter; führt das zu einem Widerspruch, streich die Zahl.';

  @override
  String exSignsLess(Object cell, Object other, Object limit, Object values) {
    return '$cell ist kleiner als $other, wo höchstens $limit steht, also kann $cell nicht $values sein.';
  }

  @override
  String exSignsMore(Object cell, Object other, Object limit, Object values) {
    return '$cell ist größer als $other, wo mindestens $limit steht, also kann $cell nicht $values sein.';
  }

  @override
  String exSignsBelowRow(Object cell, Object cells, Object row, Object values) {
    return '$cell ist kleiner als jedes von $cells, alle in Zeile $row: Sie brauchen verschiedene Zahlen über ihm, also kann $cell nicht $values sein.';
  }

  @override
  String exSignsBelowCol(Object cell, Object cells, Object col, Object values) {
    return '$cell ist kleiner als jedes von $cells, alle in Spalte $col: Sie brauchen verschiedene Zahlen über ihm, also kann $cell nicht $values sein.';
  }

  @override
  String exSignsAboveRow(Object cell, Object cells, Object row, Object values) {
    return '$cell ist größer als jedes von $cells, alle in Zeile $row: Sie brauchen verschiedene Zahlen unter ihm, also kann $cell nicht $values sein.';
  }

  @override
  String exSignsAboveCol(Object cell, Object cells, Object col, Object values) {
    return '$cell ist größer als jedes von $cells, alle in Spalte $col: Sie brauchen verschiedene Zahlen unter ihm, also kann $cell nicht $values sein.';
  }

  @override
  String get soloName => 'Solo';

  @override
  String get soloTagline => 'Schwärze Doppelte, bis jede Zahl allein steht';

  @override
  String get soloRules =>
      '• In jedem Feld steht eine Zahl. Schwärze einige davon, sodass keine Zahl in einer Zeile oder Spalte doppelt vorkommt.\n• Geschwärzte Felder berühren sich nie mit einer Seite.\n• Die übrigen Felder bilden ein zusammenhängendes Gebiet.\n• Schwärze nur eine Zahl, die ungeschwärzt noch irgendwo in ihrer Zeile oder Spalte steht.\n\nTippe auf ein Feld, um zu wechseln: geschwärzt → eingekreist (deine Notiz „bleibt“) → leer. Langes Drücken / Rechtsklick wechselt zurück. Kreise sind freiwillig: Das Rätsel ist gelöst, sobald die richtigen Zahlen geschwärzt sind.';

  @override
  String get tutSolo1 =>
      'Schwärze Zahlen, sodass keine in einer Zeile oder Spalte doppelt vorkommt. Geschwärzte Felder berühren sich nicht mit einer Seite, und die übrigen bleiben ein Stück. Schwärze nur Zahlen, die sich wiederholen. Tippe auf ein Feld, um es zu schwärzen.';

  @override
  String get tutSolo2 =>
      'Geschwärzte Felder berühren sich nicht, also bleiben die Zahlen neben einem geschwärzten Feld. Die 1 oben links ist geschwärzt: Tippe die markierten Zahlen zweimal an, um sie einzukreisen (deine Notiz, dass sie bleiben), und löse dann das Gitter.';

  @override
  String get tutSolo3 =>
      'Zwei gleiche Zahlen mit einem Feld dazwischen: Eine davon ist geschwärzt, und jede würde das mittlere Feld berühren, also bleibt die mittlere Zahl. Kreise die markierte 1 ein und löse dann das Gitter.';

  @override
  String get tutSolo4 =>
      'Die übrigen Felder müssen ein Stück bilden. Sobald die 1 neben der 1 oben links geschwärzt ist, ist die 2 darunter der einzige Weg aus der Ecke, also bleibt sie. Löse das Gitter.';

  @override
  String get tutSolo5 =>
      'Jetzt ein echtes Gitter. Fang mit Zahlen an, die in ihrer Zeile und Spalte nur einmal vorkommen, und mit gleichen Zahlen, die nah beieinander stehen.';

  @override
  String get tutSoloS1 =>
      'Zwei gleiche Zahlen nebeneinander können nicht beide geschwärzt sein, also bleibt eine davon, und jede weitere gleiche Zahl in ihrer Zeile oder Spalte wird geschwärzt. In der oberen Zeile stehen zwei 4en nebeneinander: Schwärze die markierte 4.';

  @override
  String get tutSoloS2 =>
      'Halte die übrigen Felder zusammen: Würde das Schwärzen eines Feldes sie in zwei Teile schneiden, mit bleibenden Zahlen auf beiden Seiten, dann bleibt dieses Feld. Achte auf geschwärzte Felder, die sich schräg zu einem Rand hin aufreihen.';

  @override
  String get tutSoloS3 =>
      'Ein schweres Gitter. Wenn du feststeckst, schwärze eine Zahl und verfolge die Folgen: Bleiben zwei gleiche Zahlen in einer Linie übrig oder werden Felder abgeschnitten, dann bleibt diese Zahl.';

  @override
  String exSoloSupposeShade(Object cell) {
    return 'Angenommen, $cell wäre geschwärzt.';
  }

  @override
  String exSoloSupposeKeep(Object cell) {
    return 'Angenommen, $cell bliebe.';
  }

  @override
  String exSoloRefutedShade(Object cell) {
    return '$cell bleibt: Schwärzen führt zu einem Widerspruch.';
  }

  @override
  String exSoloRefutedKeep(Object cell) {
    return '$cell ist geschwärzt: Stehenlassen führt zu einem Widerspruch.';
  }

  @override
  String exSoloUnique(Object cell, int digit) {
    return '$cell bleibt: Seine $digit kommt in seiner Zeile und Spalte sonst nicht vor.';
  }

  @override
  String exSoloLastCopy(Object cell, int digit) {
    return '$cell bleibt: Jede andere $digit in seiner Zeile und Spalte ist geschwärzt, und eine geschwärzte Zahl muss noch irgendwo stehen.';
  }

  @override
  String exSoloTwiceRow(Object cell, Object other, int digit, Object row) {
    return '$cell ist geschwärzt: Die $digit in $other bleibt in Zeile $row.';
  }

  @override
  String exSoloTwiceCol(Object cell, Object other, int digit, Object col) {
    return '$cell ist geschwärzt: Die $digit in $other bleibt in Spalte $col.';
  }

  @override
  String exSoloTouch(Object cell, Object other) {
    return '$cell bleibt: Es berührt das geschwärzte $other.';
  }

  @override
  String exSoloShows(Object cell, Object other, int digit) {
    return '$cell bleibt: $other ist geschwärzt, und seine $digit muss in Zeile oder Spalte noch stehen.';
  }

  @override
  String exSoloBetween(Object cell, Object a, Object b, int digit) {
    return '$cell bleibt: Eine der ${digit}en in $a und $b ist geschwärzt, und beide berühren es.';
  }

  @override
  String exSoloPair(Object cell, Object a, Object b, int digit) {
    return '$cell ist geschwärzt: Die ${digit}en in $a und $b stehen nebeneinander, also bleibt eine davon.';
  }

  @override
  String exSoloWalled(Object cell, Object other) {
    return '$cell bleibt: Es ist der letzte Ausweg für $other.';
  }

  @override
  String exSoloCut(Object cell) {
    return '$cell bleibt: Schwärzen würde die übrigen Felder in zwei Teile schneiden.';
  }

  @override
  String exSoloFailTwice(Object a, Object b, int digit) {
    return 'Aber dann behalten $a und $b beide eine $digit in einer Linie.';
  }

  @override
  String exSoloFailTouch(Object a, Object b) {
    return 'Aber dann berühren sich die geschwärzten Felder $a und $b.';
  }

  @override
  String exSoloFailLonely(Object a, int digit) {
    return 'Aber dann ist die $digit in $a geschwärzt und steht sonst nirgends in ihrer Zeile oder Spalte.';
  }

  @override
  String exSoloFailWalled(Object a) {
    return 'Aber dann ist $a eingemauert.';
  }

  @override
  String exSoloFailApart(Object a, Object b) {
    return 'Aber dann sind $a und $b voneinander abgeschnitten.';
  }

  @override
  String get dominoName => 'Domino';

  @override
  String get dominoTagline => 'Finde, wo jeder Stein des Satzes liegt';

  @override
  String get dominoRules =>
      '• Das Gitter ist ein voller Satz Dominosteine ohne Umrisse: Jedes Zahlenpaar, von 0–0 bis zum höchsten Pasch, ist auf genau einem Stein.\n• Teile das Gitter in Steine aus zwei benachbarten Feldern, sodass jedes Paar einmal vorkommt.\n\nTippe auf die Linie zwischen zwei Feldern, um sie zu einem Stein zu verbinden; tippe noch einmal für ein Kreuz (deine Notiz „hier kein Stein“) und noch einmal zum Löschen. Wische über Felder, um unterwegs Steine zu legen. Ein neuer Stein nimmt seine Felder den Steinen weg, die sie hatten.';

  @override
  String get tutDomino1 =>
      'Das Gitter ist ein Satz Dominosteine ohne Umrisse, und jedes Zahlenpaar ist auf genau einem Stein. Dieser kleine Satz hat 0–0, 0–1 und 1–1. Verbinde zwei benachbarte Felder, indem du auf die Linie zwischen ihnen tippst, oder wische von einem Feld zum anderen.';

  @override
  String get tutDomino2 =>
      'Ein Zahlenpaar, das nur an einer Stelle nebeneinander steht, muss dort ein Stein sein. Die markierten 0 und 0 sind die einzigen zwei Nullen nebeneinander: Verbinde sie und löse dann das Gitter.';

  @override
  String get tutDomino3 =>
      'Jedes Feld gehört zu einem Stein. Die 2–2 liegt schon, also hat die markierte 0 nur noch einen Nachbarn für ein Paar. Verbinde die beiden und löse dann das Gitter.';

  @override
  String get tutDomino4 =>
      'Jedes Paar kommt einmal vor. Der Stein 2–3 liegt schon, also können die zwei anderen 2–3 in der oberen Ecke keine Steine sein: Tippe die Linie zwischen ihnen jeweils zweimal an, um sie anzukreuzen. Dann sieh, welcher Nachbar der 2 in der Ecke bleibt, und löse das Gitter.';

  @override
  String get tutDomino5 =>
      'Jetzt ein echtes Gitter. Fang mit Paaren an, die nur an eine Stelle passen, und mit Feldern, denen nur ein Nachbar bleibt. Kreuze die übrigen Stellen jedes gelegten Paares an.';

  @override
  String get tutDominoS1 =>
      'Wenn jede Stelle, die einem Paar bleibt, dasselbe Feld bedeckt, gehört dieses Feld zu dem Paar und kann mit keinem anderen Nachbarn ein Paar bilden. Jede Stelle, die der 3–3 bleibt, bedeckt das markierte Feld: Kreuze seine anderen Nachbarn an und löse dann das Gitter.';

  @override
  String get tutDominoS2 =>
      'Wenn jeder Stein, zu dem ein Feld gehören kann, dasselbe Paar ist, liegt dieses Paar an diesem Feld, also kreuze seine Stellen anderswo an. Die markierte 3 kann nur in einer 1–3 liegen, so oder so: Kreuze die anderen 1–3 an.';

  @override
  String get tutDominoS3 =>
      'Ein schweres Gitter. Achte auf offene Felder, die in einer Gruppe ungerader Größe eingeschlossen sind: Steine können sie nicht füllen. Wenn du feststeckst, probiere einen Stein und verfolge die Folgen: Bleibt für ein Feld oder ein Paar kein Platz oder entsteht eine ungerade Gruppe, ist dieser Stein falsch.';

  @override
  String exDominoOnlySpot(Object a, Object b, Object link) {
    return '$a–$b passt nur an $link, also ist das ein Stein.';
  }

  @override
  String exDominoOnlyWay(Object cell, Object link) {
    return '$cell hat nur noch einen Nachbarn für ein Paar, also ist $link ein Stein.';
  }

  @override
  String exDominoCovered(Object cell, Object link) {
    return '$cell liegt schon in einem Stein, also ist $link keiner.';
  }

  @override
  String exDominoUsed(Object a, Object b, Object placed, Object link) {
    return '$a–$b liegt an $placed, also ist $link kein Stein.';
  }

  @override
  String exDominoPairAtCell(Object a, Object b, Object cell, Object link) {
    return 'Jede Stelle, die $a–$b bleibt, bedeckt $cell, also gehört $cell dazu, und $link ist kein Stein.';
  }

  @override
  String exDominoCellOnePair(Object a, Object b, Object cell, Object link) {
    return '$cell kann nur in einer $a–$b liegen, also liegt dieser Stein an $cell, und $link ist er nicht.';
  }

  @override
  String exDominoFailCell(Object cell) {
    return 'Aber dann kann kein Stein $cell bedecken.';
  }

  @override
  String exDominoFailPair(Object a, Object b) {
    return 'Aber dann bleibt für $a–$b kein Platz.';
  }

  @override
  String exDominoFailCellTwice(Object cell) {
    return 'Aber dann liegt $cell in zwei Steinen.';
  }

  @override
  String exDominoFailPairTwice(Object a, Object b) {
    return 'Aber dann liegt $a–$b zweimal.';
  }

  @override
  String exDominoFailOdd(Object cell, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Feldern',
      one: '1 Feld',
    );
    return 'Aber dann sind die offenen Felder mit $cell in einer Gruppe aus $_temp0 eingeschlossen, einer ungeraden Zahl, die Steine nicht füllen können.';
  }

  @override
  String exDominoSupposeLine(Object link) {
    return 'Angenommen, $link wäre ein Stein.';
  }

  @override
  String exDominoSupposeCross(Object link) {
    return 'Angenommen, $link wäre kein Stein.';
  }

  @override
  String exDominoRefutedLine(Object link) {
    return '$link ist kein Stein: Sonst ergibt sich ein Widerspruch.';
  }

  @override
  String exDominoRefutedCross(Object link) {
    return '$link ist ein Stein: Ohne ihn ergibt sich ein Widerspruch.';
  }

  @override
  String get tagShips => 'Schiffe, Boote, Flotte, Meer, Seeschlacht, versteckt';

  @override
  String get fleetName => 'Flotte';

  @override
  String get fleetTagline => 'Finde die versteckten Schiffe anhand der Zahlen am Rand';

  @override
  String get fleetRules =>
      '• Im Gitter versteckt sich eine Flotte; welche Schiffe dazugehören, steht unter dem Gitter. Jedes Schiff ist eine gerade Linie von Feldern, waagerecht oder senkrecht.\n• Schiffe berühren sich nie, auch nicht diagonal.\n• Die Zahlen außerhalb des Gitters sagen, wie viele Schiffsfelder jede Zeile und Spalte enthält.\n• Manche Felder sind von Anfang an gezeigt: Wasser oder ein Schiffsteil. Ein abgerundetes Ende zeigt, wo sein Schiff endet, ein eckiges Teil liegt in der Mitte eines Schiffs, und ein rundes Teil ist ein ganzes Schiff aus einem Feld.\n\nTippe auf ein Feld zum Wechseln: Schiff → Wasser (deine Notiz „hier kein Schiff“) → leer. Rechtsklick wechselt zurück. Wische über Felder, um sie alle auf einmal zu markieren. Langes Drücken setzt Wasser auf jedes Feld, auf dem die gesetzten Schiffe keinen Platz für ein weiteres lassen. Wasser ist freiwillig: Das Rätsel ist gelöst, sobald alle Schiffe stehen. Fertige Schiffe verblassen in der Liste unter dem Gitter, sobald Wasser oder der Rand sie ringsum abschließt.';

  @override
  String get tutFleet1 =>
      'Im Gitter versteckt sich eine Flotte, und die Liste darunter zeigt ihre Schiffe. Die Zahlen außen sagen, wie viele Schiffsfelder jede Zeile und Spalte enthält. Hier besteht die Flotte aus drei Schiffen mit je einem Feld. Tippe auf ein Feld für ein Schiff, noch einmal für Wasser.';

  @override
  String get tutFleet2 =>
      'Schiffe sind gerade Linien von Feldern und berühren sich nie, auch nicht diagonal. Die untere Zeile braucht zwei Schiffsfelder, aber die Flotte hat kein Schiff mit zwei Feldern, also sind es zwei getrennte Schiffe mit einer Lücke dazwischen. Löse das Rätsel zu Ende.';

  @override
  String get tutFleet3 =>
      'Manche Teile sind von Anfang an gezeigt. Ein abgerundetes Ende heißt, dass sein Schiff in die andere Richtung weitergeht: Das Teil in der Ecke ist oben abgerundet, also ist das Feld darunter auch ein Schiff. Löse das Rätsel zu Ende.';

  @override
  String get tutFleet4 =>
      'Jetzt ein echtes Rätsel. Beginne mit Zeilen und Spalten, deren Zahl null oder voll ist, setze Wasser um bekannte Schiffe und behalte im Blick, welche Schiffe noch fehlen.';

  @override
  String get tutFleetS1 =>
      'Suche, wo die fehlenden Schiffe noch hinpassen. Ein Feld, durch das keines von ihnen passt, ist Wasser, und hat das längste fehlende Schiff nur noch wenige Plätze, sind die Felder, die alle gemeinsam haben, Schiff. Zähle die Plätze in den Zeilen und Spalten, die noch Raum dafür haben.';

  @override
  String get tutFleetS2 =>
      'Ein schweres Rätsel: Manche Zahlen sind verborgen. Wenn du feststeckst, nimm an, ein Feld sei Schiff, und folge den Schlüssen: Läuft eine Zeile über, berühren sich Schiffe oder findet ein Schiff keinen Platz, ist dort Wasser.';

  @override
  String exFleetSupposeShip(Object cell) {
    return 'Angenommen, $cell wäre Teil eines Schiffs.';
  }

  @override
  String exFleetSupposeWater(Object cell) {
    return 'Angenommen, auf $cell wäre Wasser.';
  }

  @override
  String exFleetRefutedShip(Object cell) {
    return 'Auf $cell ist Wasser: Ein Schiff dort führt zu einem Widerspruch.';
  }

  @override
  String exFleetRefutedWater(Object cell) {
    return '$cell ist Teil eines Schiffs: Wasser dort führt zu einem Widerspruch.';
  }

  @override
  String exFleetPieceShip(Object cell, Object other) {
    return '$cell ist Teil eines Schiffs: Das Teil auf $other geht in diese Richtung weiter.';
  }

  @override
  String exFleetPieceWater(Object cell, Object other) {
    return 'Auf $cell ist Wasser: Das Teil auf $other endet auf dieser Seite.';
  }

  @override
  String exFleetMiddle(Object cell, Object other) {
    return '$cell ist Teil eines Schiffs: Das Mittelteil auf $other kann nicht in die andere Richtung laufen.';
  }

  @override
  String exFleetDiagonal(Object cell, Object other) {
    return 'Auf $cell ist Wasser: Es berührt das Schiff auf $other diagonal.';
  }

  @override
  String exFleetRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle $count Schiffsfelder',
      one: 'ihr Schiffsfeld',
    );
    return 'Auf $cell ist Wasser: Zeile $row hat schon $_temp0.';
  }

  @override
  String exFleetColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle $count Schiffsfelder',
      one: 'ihr Schiffsfeld',
    );
    return 'Auf $cell ist Wasser: Spalte $col hat schon $_temp0.';
  }

  @override
  String exFleetRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schiffsfelder',
      one: 'ein Schiffsfeld',
    );
    return '$cell ist Teil eines Schiffs: Zeile $row braucht $_temp0, und genau so viele Felder sind übrig.';
  }

  @override
  String exFleetColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schiffsfelder',
      one: 'ein Schiffsfeld',
    );
    return '$cell ist Teil eines Schiffs: Spalte $col braucht $_temp0, und genau so viele Felder sind übrig.';
  }

  @override
  String exFleetAllFound(Object cell) {
    return 'Auf $cell ist Wasser: Alle Schiffe der Flotte sind gefunden.';
  }

  @override
  String exFleetLongest(Object cell, Object other, int length) {
    return 'Auf $cell ist Wasser: Das Schiff auf $other hat schon die Länge $length, so lang wie das längste fehlende Schiff.';
  }

  @override
  String exFleetTooLong(Object cell, int length) {
    return 'Auf $cell ist Wasser: Ein Schiff dort wäre länger als $length, die Länge des längsten fehlenden Schiffs.';
  }

  @override
  String exFleetNoFit(Object cell) {
    return 'Auf $cell ist Wasser: Keines der fehlenden Schiffe passt hindurch.';
  }

  @override
  String exFleetExtend(Object cell, Object other) {
    return '$cell ist Teil eines Schiffs: Jedes Schiff, das durch $other passt, bedeckt es.';
  }

  @override
  String exFleetMustCover(Object cell, int length) {
    return '$cell ist Teil eines Schiffs: Jeder Platz, der für das fehlende Schiff der Länge $length bleibt, bedeckt es.';
  }

  @override
  String exFleetOnlySpots(Object cell, int length) {
    return '$cell ist Teil eines Schiffs: Für die Schiffe der Länge $length bleiben genau so viele Plätze wie nötig.';
  }

  @override
  String exFleetFailTouch(Object a, Object b) {
    return 'Aber dann berühren sich die Schiffe auf $a und $b.';
  }

  @override
  String exFleetFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schiffsfelder',
      one: 'ein Schiffsfeld',
    );
    return 'Aber dann hat Zeile $row mehr als $_temp0.';
  }

  @override
  String exFleetFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schiffsfelder',
      one: 'ein Schiffsfeld',
    );
    return 'Aber dann hat Spalte $col mehr als $_temp0.';
  }

  @override
  String exFleetFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ihre $count Schiffsfelder',
      one: 'ihr Schiffsfeld',
    );
    return 'Aber dann kann Zeile $row $_temp0 nicht bekommen.';
  }

  @override
  String exFleetFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ihre $count Schiffsfelder',
      one: 'ihr Schiffsfeld',
    );
    return 'Aber dann kann Spalte $col $_temp0 nicht bekommen.';
  }

  @override
  String exFleetFailPiece(Object a) {
    return 'Aber dann passt das Teil auf $a nicht.';
  }

  @override
  String exFleetFailLong(Object a, int length) {
    return 'Aber dann ist das Schiff auf $a länger als $length, das längste fehlende Schiff.';
  }

  @override
  String exFleetFailFleet(int length) {
    return 'Aber dann gibt es zu viele Schiffe der Länge $length.';
  }

  @override
  String exFleetFailNoRoom(int length) {
    return 'Aber dann passen nicht alle Schiffe der Länge $length.';
  }

  @override
  String exFleetFailStray(Object a) {
    return 'Aber dann kann das Schiffsfeld $a zu keinem fehlenden Schiff gehören.';
  }

  @override
  String get tagWater => 'Wasser, füllen, Flüssigkeit, gießen, Pegel, Tank, Becken, Pool';

  @override
  String get basinsName => 'Becken';

  @override
  String get basinsTagline => 'Fülle die Becken mit ebenem Wasser passend zu den Zahlen';

  @override
  String get basinsRules =>
      '• Das Gitter ist in Becken geteilt. Fülle einige Felder mit Wasser.\n• Wasser setzt sich ab: In jedem Becken füllt es von unten bis zu einer Höhe, die im ganzen Becken gleich ist. Jedes Feld des Beckens auf dieser Höhe oder tiefer hat Wasser, jedes darüber bleibt trocken. Ein Becken kann auch leer bleiben oder bis oben voll sein.\n• Die Zahlen außen sagen, wie viele Wasserfelder jede Zeile und Spalte enthält.\n\nTippe auf ein Feld zum Durchschalten: Wasser → trocken (deine Notiz) → leer. Rechtsklick schaltet zurück. Wische über Felder, um sie alle auf einmal zu füllen. Langes Drücken lässt das Wasser sich setzen: Es füllt jedes Feld eines Beckens unter deinem Wasser und markiert die Felder über deinen Trocken-Notizen sowie in Zeilen und Spalten mit all ihrem Wasser als trocken. Trocken-Notizen sind freiwillig: Das Rätsel ist gelöst, sobald alles Wasser an seinem Platz ist.';

  @override
  String get tutBasins1 =>
      'Das Gitter ist in Becken geteilt, und in jedem setzt sich das Wasser von unten nach oben. Die Zahlen außen sagen, wie viele Wasserfelder jede Zeile und Spalte enthält. Spalte A hat 2, also füllt ihr Becken die zwei untersten Felder. Tippe auf ein Feld für Wasser, noch einmal, um es als trocken zu markieren.';

  @override
  String get tutBasins2 =>
      'Wasser steht im ganzen Becken gleich hoch: Hat ein Feld eines Beckens Wasser, dann auch jedes Feld dieses Beckens auf gleicher Höhe oder tiefer. Zeile 2 braucht nur ein Wasserfeld, also kann das breite Becken nicht so hoch reichen. Löse das Feld.';

  @override
  String get tutBasins3 =>
      'Denk voraus: Wasser in einem Feld füllt alles darunter in seinem Becken. Ist die unterste Zeile voll, braucht Spalte A nur noch ein Wasserfeld, aber Wasser im obersten Feld würde zwei füllen. Also bleibt das oberste Feld trocken. Löse das Feld.';

  @override
  String get tutBasins4 =>
      'Jetzt ein echtes Feld. Beginne mit leeren oder vollen Zeilen und Spalten, lass das Wasser sich setzen und zähle, bevor du ein Feld füllst, wie viel Wasser es mit sich bringt.';

  @override
  String get tutBasinsS1 =>
      'Wasser kommt in einer Zeile stückweise: Die Felder eines Beckens in dieser Zeile füllen sich gemeinsam. Ergeben nur manche Sätze von Stücken die Zahl der Zeile, hat ein Stück, das in allen vorkommt, Wasser, und eines, das in keinem vorkommt, bleibt trocken.';

  @override
  String get tutBasinsS2 =>
      'Probiere jede Wasserhöhe eines Beckens, von leer bis voll, gegen die Zahlen der Zeilen und Spalten, die es berührt. Felder, die in jeder passenden Höhe gleich ausfallen, stehen fest.';

  @override
  String get tutBasinsS3 =>
      'Ein schweres Feld: Manche Zahlen sind verborgen. Wenn du feststeckst, nimm an, dass ein Feld Wasser hat, und lass es sich setzen: Läuft eine Zeile oder Spalte über oder erreicht ihre Zahl nicht, bleibt das Feld trocken.';

  @override
  String exBasinsSupposeWater(Object cell) {
    return 'Angenommen, $cell hätte Wasser.';
  }

  @override
  String exBasinsSupposeDry(Object cell) {
    return 'Angenommen, $cell bliebe trocken.';
  }

  @override
  String exBasinsRefutedWater(Object cell) {
    return '$cell bleibt trocken: Wasser dort führt zu einem Widerspruch.';
  }

  @override
  String exBasinsRefutedDry(Object cell) {
    return '$cell hat Wasser: Bliebe es trocken, gäbe es einen Widerspruch.';
  }

  @override
  String exBasinsWaterBelow(Object cell, Object other) {
    return '$cell hat Wasser: Das Wasser auf $other füllt sein Becken bis zu dieser Höhe.';
  }

  @override
  String exBasinsDryAbove(Object cell, Object other) {
    return '$cell bleibt trocken: $other im selben Becken ist trocken, also steht das Wasser tiefer.';
  }

  @override
  String exBasinsRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle $count Wasserfelder',
      one: 'ihr Wasserfeld',
    );
    return '$cell bleibt trocken: Zeile $row hat schon $_temp0.';
  }

  @override
  String exBasinsColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle $count Wasserfelder',
      one: 'ihr Wasserfeld',
    );
    return '$cell bleibt trocken: Spalte $col hat schon $_temp0.';
  }

  @override
  String exBasinsRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wasserfelder',
      one: 'ein Wasserfeld',
    );
    return '$cell hat Wasser: Zeile $row braucht $_temp0, und nur so viele Felder sind übrig.';
  }

  @override
  String exBasinsColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wasserfelder',
      one: 'ein Wasserfeld',
    );
    return '$cell hat Wasser: Spalte $col braucht $_temp0, und nur so viele Felder sind übrig.';
  }

  @override
  String exBasinsTooMuchRow(Object cell, Object row, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'nur noch $need braucht',
      one: 'nur noch eins braucht',
      zero: 'schon all ihr Wasser hat',
    );
    return '$cell bleibt trocken: Wasser dort würde $_temp0 von Zeile $row füllen, die $_temp1.';
  }

  @override
  String exBasinsTooMuchCol(Object cell, Object col, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'nur noch $need braucht',
      one: 'nur noch eins braucht',
      zero: 'schon all ihr Wasser hat',
    );
    return '$cell bleibt trocken: Wasser dort würde $_temp0 von Spalte $col füllen, die $_temp1.';
  }

  @override
  String exBasinsTooLittleRow(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    return '$cell hat Wasser: Trocken hielte es $_temp0 von Zeile $row trocken, und die Zeile käme nicht mehr auf ihre Zahl.';
  }

  @override
  String exBasinsTooLittleCol(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    return '$cell hat Wasser: Trocken hielte es $_temp0 von Spalte $col trocken, und die Spalte käme nicht mehr auf ihre Zahl.';
  }

  @override
  String exBasinsWaysWater(Object cell, Object row, int count) {
    return '$cell hat Wasser: Jede Art, in Zeile $row aus den Stücken ihrer Becken $count zu bilden, braucht dieses Stück.';
  }

  @override
  String exBasinsWaysDry(Object cell, Object row, int count) {
    return '$cell bleibt trocken: Keine Art, in Zeile $row aus den Stücken ihrer Becken $count zu bilden, nutzt dieses Stück.';
  }

  @override
  String exBasinsLevelsWater(Object cell) {
    return '$cell hat Wasser: Jede Wasserhöhe seines Beckens, bei der es trocken bleibt, verletzt die Zahl einer Zeile oder Spalte.';
  }

  @override
  String exBasinsLevelsDry(Object cell) {
    return '$cell bleibt trocken: Jede Wasserhöhe seines Beckens, die es erreicht, verletzt die Zahl einer Zeile oder Spalte.';
  }

  @override
  String exBasinsFailLevel(Object wet, Object dry) {
    return 'Aber dann hat $wet Wasser, während $dry, gleich hoch oder tiefer im selben Becken, trocken bleibt.';
  }

  @override
  String exBasinsFailRowMany(Object row, int count) {
    return 'Aber dann hat Zeile $row mehr als $count Wasserfelder.';
  }

  @override
  String exBasinsFailColMany(Object col, int count) {
    return 'Aber dann hat Spalte $col mehr als $count Wasserfelder.';
  }

  @override
  String exBasinsFailRowFew(Object row, int count) {
    return 'Aber dann kommt Zeile $row nicht mehr auf $count Wasserfelder.';
  }

  @override
  String exBasinsFailColFew(Object col, int count) {
    return 'Aber dann kommt Spalte $col nicht mehr auf $count Wasserfelder.';
  }

  @override
  String exBasinsFailWays(Object row, int count) {
    return 'Aber dann ergibt kein Satz von Beckenstücken in Zeile $row zusammen $count.';
  }

  @override
  String exBasinsFailLevels(Object cell) {
    return 'Aber dann passt keine Wasserhöhe des Beckens bei $cell zu den Zahlen.';
  }

  @override
  String recallGoalRounds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Runden',
      one: '$count Runde',
    );
    return '$_temp0';
  }

  @override
  String get recallGoalRoundsHint => 'Spiele eine feste Zahl von Runden und hol so viele Punkte wie möglich.';

  @override
  String recallGoalLives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Leben',
      one: '$count Leben',
    );
    return '$_temp0';
  }

  @override
  String recallGoalLivesHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-mal',
      one: 'einmal',
    );
    return 'Spiele, bis du dich $_temp0 vertust, und schlag deinen Rekord.';
  }

  @override
  String recallRound(int round, int count) {
    return 'Runde $round/$count';
  }

  @override
  String get recallReady => 'Bereit';

  @override
  String get recallStart => 'Tippen zum Starten';

  @override
  String get recallWatch => 'Merk es dir…';

  @override
  String recallRight(int points) {
    return 'Richtig! +$points';
  }

  @override
  String get recallMissed => 'Daneben';

  @override
  String recallRoundsRight(int correct, int count) {
    return '$correct von $count Runden richtig';
  }

  @override
  String get tagMemory => 'Gedächtnis, merken, erinnern, Gehirntraining, Konzentration, Aufmerksamkeit';

  @override
  String get glimpseName => 'Blitz';

  @override
  String get glimpseTagline => 'Felder leuchten kurz auf: tippe sie alle aus dem Gedächtnis an';

  @override
  String get glimpseRules =>
      '• Einige Felder leuchten kurz auf und werden wieder dunkel. Tippe jedes Feld an, das aufgeleuchtet hat, in beliebiger Reihenfolge.\n• Tippe auf „Bereit“, um sie früher zu verbergen.\n• Ein Tipp auf ein Feld, das nicht aufgeleuchtet hat, beendet die Runde.\n• Eine richtige Runde bringt einen Punkt pro Feld, und die nächste lässt ein Feld mehr aufleuchten. Nach einem Fehler eines weniger.\n\nZiele\n• Runden: spiele 10 Runden um einen Rekord.\n• Leben: spiele bis zum dritten Fehler.\n\nDer Schwierigkeitsgrad bestimmt, wie viele Felder die erste Runde zeigt und wie lange sie leuchten.';

  @override
  String get glimpsePrompt => 'Tippe alle Felder an, die aufgeleuchtet haben';

  @override
  String get tutGlimpse1 =>
      'Tippe aufs Brett, um zu starten. Drei Felder leuchten kurz auf: merk sie dir, und wenn sie dunkel werden, tippe alle drei an.';

  @override
  String get tutGlimpse2 =>
      'Tippe auf „Bereit“, sobald du die Felder kennst, um sie früher zu verbergen. Ein Tipp auf ein Feld, das nicht aufgeleuchtet hat, beendet die Runde; hier wird sie dann wiederholt. Schaffe beide Runden.';

  @override
  String get tutGlimpse3 =>
      'Ein echtes Brett: jede richtige Runde lässt beim nächsten Mal ein Feld mehr aufleuchten, ein Fehler eines weniger. Schaffe 3 Runden.';

  @override
  String get famMemory => 'Gedächtnis';

  @override
  String get famMemoryAbout =>
      'Schau genau hin und antworte dann aus dem Gedächtnis. Jede richtige Runde macht die nächste schwerer';

  @override
  String get vanishName => 'Verschwunden';

  @override
  String get vanishTagline =>
      'Tippe die 1, und die Zahlen verschwinden: tippe den Rest der Reihe nach aus dem Gedächtnis';

  @override
  String get vanishRules =>
      '• Zahlen ab 1 erscheinen auf dem Brett. Lass dir Zeit: sie bleiben, bis du die 1 antippst.\n• Sobald du die 1 antippst, verschwinden die anderen Zahlen. Tippe ihre Felder der Reihe nach an: 2, 3, 4…\n• Ein Tipp auf das falsche Feld beendet die Runde.\n• Eine richtige Runde bringt einen Punkt pro Zahl, und die nächste zeigt eine Zahl mehr. Nach einem Fehler eine weniger.\n\nZiele\n• Runden: spiele 10 Runden um einen Rekord.\n• Leben: spiele bis zum dritten Fehler.\n\nDer Schwierigkeitsgrad bestimmt, wie viele Zahlen die erste Runde zeigt.';

  @override
  String get vanishWatch => 'Tippe die 1, wenn du so weit bist';

  @override
  String get vanishPrompt => 'Tippe die Zahlen der Reihe nach an';

  @override
  String get tutVanish1 =>
      'Tippe aufs Brett, um zu starten. Zahlen erscheinen: tippe die 1, und die anderen verschwinden. Tippe dann dorthin, wo 2 und 3 waren.';

  @override
  String get tutVanish2 =>
      'Schau so lange, wie du willst: die Zahlen bleiben, bis du die 1 antippst. Ein Tipp auf das falsche Feld beendet die Runde; hier wird sie dann wiederholt. Schaffe beide Runden.';

  @override
  String get tutVanish3 =>
      'Ein echtes Brett: jede richtige Runde zeigt beim nächsten Mal eine Zahl mehr, ein Fehler eine weniger. Schaffe 3 Runden.';

  @override
  String get hopperName => 'Hüpfer';

  @override
  String get hopperTagline => 'Sieh zu, wie der Frosch von Blatt zu Blatt hüpft, und wiederhole seine Sprünge';

  @override
  String get hopperRules =>
      '• Ein Frosch hüpft von Blatt zu Blatt, einen Sprung nach dem anderen. Wenn er anhält, tippe die Blätter, auf denen er gelandet ist, in derselben Reihenfolge an.\n• Ein Blatt kann mehrmals vorkommen: tippe es jedes Mal an.\n• Ein falscher Tipp beendet die Runde.\n• Eine richtige Runde bringt einen Punkt pro Sprung, und die nächste hat einen Sprung mehr. Nach einem Fehler einen weniger.\n\nReihenfolge\n• Gleiche Reihenfolge: vom ersten Sprung bis zum letzten.\n• Rückwärts: vom letzten Sprung zurück zum ersten.\n\nZiele\n• Runden: spiele 10 Runden um einen Rekord.\n• Leben: spiele bis zum dritten Fehler.\n\nDer Schwierigkeitsgrad bestimmt, wie viele Sprünge die erste Runde hat und wie schnell der Frosch hüpft.';

  @override
  String get hopperOrder => 'Reihenfolge';

  @override
  String get hopperForward => 'Gleiche Reihenfolge';

  @override
  String get hopperForwardHint => 'Tippe die Blätter in der Reihenfolge an, in der der Frosch gesprungen ist.';

  @override
  String get hopperReverse => 'Rückwärts';

  @override
  String get hopperReverseHint => 'Tippe die Blätter vom letzten Sprung des Frosches bis zum ersten an.';

  @override
  String get hopperWatch => 'Beobachte den Frosch…';

  @override
  String get hopperPrompt => 'Tippe die Blätter der Reihe nach an';

  @override
  String get hopperPromptReverse => 'Tippe die Blätter rückwärts an, letzter Sprung zuerst';

  @override
  String get tutHopper1 =>
      'Tippe aufs Brett, um zu starten. Der Frosch hüpft von Blatt zu Blatt. Wenn er anhält, tippe die Blätter, auf denen er gelandet ist, in derselben Reihenfolge an.';

  @override
  String get tutHopper2 =>
      'Ein Blatt kann mehrmals vorkommen: tippe es jedes Mal an. Ein falscher Tipp beendet die Runde; hier wird sie dann wiederholt. Schaffe beide Runden.';

  @override
  String get tutHopper3 =>
      'Mit der Option „Rückwärts“ tippst du dieselben Blätter vom letzten Sprung zurück zum ersten an. Probier es einmal.';

  @override
  String get tutHopper4 =>
      'Ein echtes Brett: jede richtige Runde bringt beim nächsten Mal einen Sprung mehr, ein Fehler einen weniger. Schaffe 3 Runden.';

  @override
  String get reboundName => 'Abpraller';

  @override
  String get reboundTagline => 'Merk dir die Abweiser und sag, wo die Kugel herauskommt';

  @override
  String get reboundRules =>
      '• Auf dem Brett stehen Abweiser, und an einem Pfeil am Rand wartet eine Kugel. Merk dir die Abweiser: nach einem Moment (oder wenn du auf „Bereit“ tippst) verschwinden sie.\n• Die Kugel rollt am Pfeil hinein, und jeder Abweiser, auf den sie trifft, lenkt sie um eine Vierteldrehung ab, so wie er schräg steht. Tippe auf den Rand, an dem sie das Brett verlässt.\n• Eine richtige Runde bringt einen Punkt pro Abweiser, und die nächste hat einen Abweiser mehr. Nach einem Fehler einen weniger.\n\nZiele\n• Runden: spiele 10 Runden um einen Rekord.\n• Leben: spiele bis zum dritten Fehler.\n\nDer Schwierigkeitsgrad bestimmt, wie viele Abweiser die erste Runde hat und wie lange sie zu sehen sind.';

  @override
  String get reboundPrompt => 'Tippe auf den Rand, an dem die Kugel das Brett verlässt';

  @override
  String get tutRebound1 =>
      'Tippe aufs Brett, um zu starten. Die Kugel rollt am Pfeil hinein und prallt am Abweiser ab, so wie er schräg steht. Merk ihn dir, und wenn er verschwindet, tippe auf den Rand, an dem die Kugel herauskommt.';

  @override
  String get tutRebound2 =>
      'Die Kugel kann auf mehrere Abweiser treffen und andere verfehlen. Tippe auf „Bereit“, sobald du sie dir gemerkt hast. Ein falscher Rand beendet die Runde; hier wird sie dann wiederholt.';

  @override
  String get tutRebound3 =>
      'Ein echtes Brett: jede richtige Runde bringt beim nächsten Mal einen Abweiser mehr, ein Fehler einen weniger. Schaffe 3 Runden.';

  @override
  String get pebblesName => 'Kiesel';

  @override
  String get pebblesTagline => 'Zwei Sorten Steine, jede Sorte in einem Stück';

  @override
  String get pebblesRules =>
      '• Lege in jedes Feld einen Stein: voll oder hohl.\n• Alle vollen Steine bilden eine Gruppe, über Seiten verbunden, und ebenso alle hohlen.\n• Kein 2×2-Block enthält vier Steine einer Sorte.\n• Einige Steine sind von Anfang an zu sehen.\n\nTippe auf ein Feld zum Wechseln: voll → hohl → leer. Langes Drücken / Rechtsklick wechselt zurück. Wische über Felder, um in alle denselben Stein zu legen. Benachbarte Steine einer Sorte sind verbunden gezeichnet, damit du die Gruppen siehst.';

  @override
  String get tutPebbles1 =>
      'Lege in jedes Feld einen Stein. Alle vollen Steine müssen eine Gruppe bilden, über Seiten verbunden, und ebenso alle hohlen. Tippe einmal auf ein leeres Feld für einen vollen Stein, zweimal für einen hohlen. Fülle dieses Feld.';

  @override
  String get tutPebbles2 =>
      'Kein 2×2-Block darf vier Steine einer Sorte enthalten. Der markierte Block hat schon drei hohle Steine, also kommt in sein letztes Feld ein voller. Löse den Rest genauso.';

  @override
  String get tutPebbles3 =>
      'Jede Gruppe muss den Rest ihrer Sorte erreichen. Der hohle Stein in der Ecke ist bis auf ein Feld eingeschlossen, also kommt dorthin auch ein hohler. Folge den hohlen Steinen, bis sie die anderen treffen.';

  @override
  String get tutPebbles4 =>
      'Ein Feld, das von vollen Steinen umgeben ist, kann keinen hohlen enthalten: Er wäre von den anderen hohlen Steinen abgeschnitten. Umgekehrt genauso. Fülle das markierte Feld, dann löse den Rest.';

  @override
  String get tutPebbles5 =>
      'Jetzt ein echtes Rätsel. Achte auf Blöcke mit drei gleichen Steinen und auf Gruppen mit nur einem Ausweg.';

  @override
  String get tutPebblesS1 =>
      'Am Rand des Rätsels entlang bilden die vollen Steine einen durchgehenden Abschnitt und die hohlen einen anderen: Wechselte der Rand viermal die Sorte, müssten sich die beiden Gruppen kreuzen. A1 und D4 haben volle Steine und C4 einen hohlen, also ist der Rand von A1 oben entlang und hinunter bis D4 ganz voll.';

  @override
  String get tutPebblesS2 =>
      'Ein 2×2-Block wechselt nie ab, mit vollen Steinen auf einer Diagonale und hohlen auf der anderen: Das volle Paar könnte sich nur treffen, indem es einen der hohlen Steine umrundet und abschneidet. Hat also eine Diagonale zwei gleiche Steine und die andere einen Stein der anderen Sorte, passt das letzte Feld zur Diagonale.';

  @override
  String get tutPebblesS3 =>
      'Manche Felder halten eine Sorte zusammen: Nähme die andere Sorte ein solches Feld, könnten sich die Steine auf beiden Seiten nicht mehr treffen. Ein solches Feld bekommt die Sorte, die es zusammenhält. Achte auf schmale Durchgänge zwischen den Gruppen.';

  @override
  String exPebblesBlock(Object cell, Object stone, Object other) {
    return '$cell hat $stone: Der Rest seines 2×2-Blocks hat $other, und ein Block hat nie vier gleiche.';
  }

  @override
  String exPebblesEnclosed(Object cell, Object stone, Object other) {
    return '$cell hat $stone: Es ist von $stone umgeben, also wäre $other dort vom Rest seiner Sorte abgeschnitten.';
  }

  @override
  String exPebblesExit(Object cell, Object stone, Object group) {
    return '$cell hat $stone: Es ist der einzige Ausweg für die Gruppe bei $group.';
  }

  @override
  String exPebblesEdge(Object cell, Object stone, Object other, Object a, Object b, Object c) {
    return '$cell hat $stone: Am Rand bildet jede Sorte einen Abschnitt. $a und $b haben $stone und $c hat $other, also hat der Abschnitt von $a bis $b über $cell $stone.';
  }

  @override
  String exPebblesChecker(Object cell, Object stone, Object other, Object a, Object b, Object c) {
    return '$cell hat $stone: $a und $b haben $stone auf einer Diagonale eines 2×2-Blocks und $c hat $other, und ein Block wechselt nie ab.';
  }

  @override
  String exPebblesCut(Object cell, Object stone, Object other) {
    return '$cell hat $stone: $other dort würde die Steine $stone in Teile trennen, die sich nicht treffen können.';
  }

  @override
  String exPebblesFailBlock(Object cell) {
    return 'Aber dann hat der 2×2-Block bei $cell vier gleiche.';
  }

  @override
  String exPebblesFailClosed(Object cell) {
    return 'Aber dann ist die Gruppe bei $cell eingeschlossen, vom Rest ihrer Sorte abgeschnitten.';
  }

  @override
  String exPebblesFailEdge(Object a, Object b, Object c, Object d) {
    return 'Aber dann wechselt der Rand bei $a, $b, $c und $d die Sorte, und die beiden Sorten müssten sich kreuzen.';
  }

  @override
  String exPebblesFailChecker(Object cell) {
    return 'Aber dann wechselt der 2×2-Block bei $cell ab.';
  }

  @override
  String exPebblesFailApart(Object a, Object b) {
    return 'Aber dann sind $a und $b voneinander abgeschnitten.';
  }

  @override
  String get totalsName => 'Summen';

  @override
  String get totalsTagline => 'Ein Kreuzworträtsel aus Ziffern, die sich waagrecht und senkrecht addieren';

  @override
  String get totalsRules =>
      '• Füll jedes leere Feld mit einer Ziffer von 1 bis 9.\n• Die Hinweisfelder geben Summen vor: Die Zahl über der Diagonale ist die Summe der Reihe von Feldern rechts davon, die Zahl unter der Diagonale die Summe der Reihe darunter. Eine Reihe endet am nächsten Hinweisfeld oder am Rand.\n• In einer Reihe kommt keine Ziffer doppelt vor.\n\nWähle eine Ziffer in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Ziffer. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld. Eine Summe verblasst, sobald ihre Reihe voll ist und aufgeht.';

  @override
  String get tutTotals1 =>
      'Füll die leeren Felder mit Ziffern von 1 bis 9. In einem Hinweisfeld ist die Zahl über der Diagonale die Summe der Reihe rechts davon, die Zahl darunter die Summe der Reihe unten. 3 in zwei Feldern geht nur als 1 + 2, 4 nur als 1 + 3: Das Eckfeld gehört zu beiden Reihen, also kommt dort die 1 hin.';

  @override
  String get tutTotals2 =>
      'In einer Reihe kommt keine Ziffer doppelt vor: 4 in zwei Feldern ist 1 + 3, nie 2 + 2. Füll dieses Gitter.';

  @override
  String get tutTotals3 =>
      'Manche Summen gehen nur auf eine Art: 24 in drei Feldern braucht 7, 8 und 9, und 7 in drei Feldern braucht 1, 2 und 4. Jedes Feld bekommt eine Ziffer, die beide seiner Reihen erlauben.';

  @override
  String get tutTotals4 =>
      'Jetzt ein echtes Gitter. Fang mit den Reihen an, deren Summe nur auf eine Art geht, und schau dann, wo sich Reihen kreuzen.';

  @override
  String get tutTotalsS1 =>
      'Zähl die Sätze verschiedener Ziffern auf, die die Summe einer Reihe ergeben. Eine Ziffer, die in jedem Satz steckt, muss irgendwo in die Reihe: Kann nur ein Feld der Reihe sie aufnehmen, kommt sie dorthin.';

  @override
  String get tutTotalsS2 =>
      'Manchmal passt jede Ziffer für sich in ein Feld, aber nicht zusammen mit den anderen: Können zwei Felder einer Reihe nur 1 oder 3 haben, nehmen sie beide, und kein anderes Feld der Reihe hat sie. Probier jede Art, eine kurze Reihe mit verschiedenen Ziffern zu füllen.';

  @override
  String get tutTotalsS3 =>
      'Die schwersten Gitter brauchen eine Annahme, die sich widerlegen lässt. Nimm an, ein Feld hat eine seiner letzten zwei oder drei Ziffern, und denk weiter; kann eine Reihe ihre Summe nicht mehr erreichen, streich die Ziffer.';

  @override
  String exTotalsCombo(Object sum, Object run, Object digits, Object cell, Object gone) {
    return 'Um $sum in $run zu bilden, können die freien Felder nur $digits haben, also ist $cell nicht $gone.';
  }

  @override
  String exTotalsMust(Object sum, Object run, Object value, Object cell) {
    return '$cell muss $value sein: Jede Art, $sum in $run zu bilden, braucht $value, und kein anderes Feld dort kann sie aufnehmen.';
  }

  @override
  String exTotalsFill(Object sum, Object run, Object gone, Object cell) {
    return 'Keine Art, $run mit verschiedenen Ziffern zur Summe $sum zu füllen, setzt $gone in $cell.';
  }

  @override
  String exTotalsNaked(Object cell, Object value) {
    return '$cell muss $value sein: Alle anderen Ziffern sind dort ausgeschlossen.';
  }

  @override
  String exTotalsFailEmpty(Object cell) {
    return 'Dann bleibt aber für $cell keine Ziffer übrig.';
  }

  @override
  String exTotalsFailRun(Object sum, Object run) {
    return 'Dann kann $run aber $sum nicht mehr erreichen.';
  }

  @override
  String get famSudoku => 'Sudoku';

  @override
  String get famSudokuAbout => 'Jede Ziffer einmal pro Zeile, Spalte und Block, dazu weitere Hinweise';

  @override
  String get pocketsName => 'Taschen';

  @override
  String get pocketsTagline => 'Sudoku, dessen gestrichelte Taschen ihre Summen ergeben';

  @override
  String get pocketsRules =>
      '• Füll jedes Feld mit einer Ziffer von 1 bis N (N = Gittergröße): jede Ziffer einmal in jeder Zeile, jeder Spalte und jedem Block, wie beim Sudoku.\n• Das Gitter ist außerdem in Taschen mit gestrichelten Rahmen geteilt. Die Ziffern einer Tasche ergeben zusammen die Zahl in ihrer Ecke, und in einer Tasche kommt keine Ziffer doppelt vor.\n• Es gibt keine vorgegebenen Ziffern: Die Summen verraten alles.\n\nWähle eine Ziffer in der Palette und tippe auf Felder, um sie zu setzen, oder tippe zuerst auf ein Feld und dann auf eine Ziffer. Die Stift-Taste schaltet kleine Notizen um. Langes Drücken / Rechtsklick leert ein Feld. Eine Summe verblasst, sobald ihre Tasche voll ist und aufgeht.';

  @override
  String get tutPockets1 =>
      'Wie beim Sudoku enthält jede Zeile, Spalte und jeder Block (die dicken Rahmen) jede Ziffer von 1 bis 4 einmal. Die gestrichelten Taschen kommen dazu: Ihre Ziffern ergeben zusammen die Zahl in der Ecke. 3 in zwei Feldern geht nur als 1 + 2, 7 nur als 3 + 4; was wohin gehört, verraten die Spalten.';

  @override
  String get tutPockets2 =>
      'In einer Tasche kommt keine Ziffer doppelt vor, auch wenn ihre Felder in verschiedenen Zeilen und Spalten liegen. Drei Felder im 4 × 4 lassen also nur eine Ziffer aus: 6 ist 1 + 2 + 3, und 8 ist 1 + 3 + 4.';

  @override
  String get tutPockets3 =>
      'Dieses Gitter hat gar keine Ziffern. Fang mit den Taschen an, deren Summe sich nur auf eine Art bilden lässt, und mach dann weiter wie beim Sudoku.';

  @override
  String get tutPockets4 =>
      'Jetzt ein echtes Gitter. Notiere, welche Ziffern eine Tasche haben kann, und denk daran: Eine ganze Zeile, Spalte oder ein Block ergibt 1 + 2 + … + 6 = 21.';

  @override
  String get tutPocketsS1 =>
      'Eine ganze Zeile, Spalte oder ein Block ergibt immer dieselbe Summe: 21 im 6 × 6, 45 im 9 × 9. Zieh die Summen der Taschen ab, die ganz darin liegen, und es bleibt die Summe der übrigen Felder. Bleiben ein oder zwei Felder übrig, steht damit oft schon fest, was hineingehört.';

  @override
  String get tutPocketsS2 =>
      'Es geht auch andersherum. Zähl die Summen der Taschen zusammen, die in eine Zeile, Spalte oder einen Block hineinreichen, zieh deren Summe ab, und du hast die Summe ihrer Felder, die herausragen. Streifen aus ganzen Blöcken funktionieren genauso.';

  @override
  String get tutPocketsS3 =>
      'Die schwersten Gitter brauchen eine Annahme, die sich widerlegen lässt. Nimm an, ein Feld hat eine seiner letzten zwei oder drei Ziffern, und denk weiter; kann eine Tasche ihre Summe nicht mehr erreichen oder hat eine Ziffer keinen Platz mehr, streich die Ziffer.';

  @override
  String exPocketsCombo(Object sum, Object pocket, Object digits, Object cell, Object gone) {
    return 'Um $sum in der Tasche bei $pocket zu bilden, können die freien Felder nur $digits haben, also ist $cell nicht $gone.';
  }

  @override
  String exPocketsMust(Object sum, Object pocket, Object value, Object cell) {
    return '$cell muss $value sein: Jede Art, $sum in der Tasche bei $pocket zu bilden, braucht $value, und kein anderes Feld dort kann sie aufnehmen.';
  }

  @override
  String exPocketsFill(Object sum, Object pocket, Object gone, Object cell) {
    return 'Keine Art, die Tasche bei $pocket mit verschiedenen Ziffern zur Summe $sum zu füllen, setzt $gone in $cell.';
  }

  @override
  String exPocketsLineRow(Object sum, Object pocket, Object value, Object row) {
    return 'Jede Art, $sum in der Tasche bei $pocket zu bilden, braucht $value, und dort kann sie nur in Zeile $row stehen, also kommt $value sonst nirgends in Zeile $row vor.';
  }

  @override
  String exPocketsLineCol(Object sum, Object pocket, Object value, Object col) {
    return 'Jede Art, $sum in der Tasche bei $pocket zu bilden, braucht $value, und dort kann sie nur in Spalte $col stehen, also kommt $value sonst nirgends in Spalte $col vor.';
  }

  @override
  String exPocketsLineBox(Object sum, Object pocket, Object value, Object box) {
    return 'Jede Art, $sum in der Tasche bei $pocket zu bilden, braucht $value, und dort kann sie nur im Block $box stehen, also kommt $value sonst nirgends im Block $box vor.';
  }

  @override
  String exPocketsFailSum(Object pocket, Object sum) {
    return 'Dann kann die Tasche bei $pocket aber $sum nicht mehr erreichen.';
  }

  @override
  String exPocketsFailCells(Object cells, Object sum) {
    return 'Dann können $cells aber zusammen nicht mehr $sum ergeben.';
  }

  @override
  String exPocketsRegionRow(Object row) {
    return 'in Zeile $row';
  }

  @override
  String exPocketsRegionCol(Object col) {
    return 'in Spalte $col';
  }

  @override
  String exPocketsRegionBox(Object box) {
    return 'im Block $box';
  }

  @override
  String exPocketsRegionRows(Object from, Object to) {
    return 'in den Zeilen $from–$to';
  }

  @override
  String exPocketsRegionCols(Object from, Object to) {
    return 'in den Spalten $from–$to';
  }

  @override
  String exPocketsInnie(Object region, Object total, Object inside, Object cells, Object sum) {
    return 'Die Ziffern $region ergeben zusammen $total und die Taschen, die ganz darin liegen, $inside, also ergeben $cells zusammen $sum';
  }

  @override
  String exPocketsOutie(Object region, Object total, Object reach, Object cells, Object sum) {
    return 'Die Ziffern $region ergeben zusammen $total und die Taschen, die hineinreichen, $reach, also ergeben $cells außerhalb davon zusammen $sum';
  }

  @override
  String exPocketsAreaCombo(Object lead, Object digits, Object cell, Object gone) {
    return '$lead. Diese Felder können nur $digits haben, also ist $cell nicht $gone.';
  }

  @override
  String exPocketsAreaMust(Object lead, Object value, Object cell) {
    return '$lead. Jede Art, das zu schaffen, braucht $value, und von diesen Feldern kann nur $cell sie aufnehmen.';
  }

  @override
  String exPocketsAreaFill(Object lead, Object gone, Object cell) {
    return '$lead. Keine Art, das mit verschiedenen Ziffern zu schaffen, setzt $gone in $cell.';
  }

  @override
  String get chambersName => 'Kammern';

  @override
  String get chambersTagline => 'Schwärze in jeder Kammer so viele Felder wie angegeben, ohne lange Linien';

  @override
  String get chambersRules =>
      '• Das Gitter ist in Kammern geteilt. Eine Zahl in einer Kammer sagt, wie viele ihrer Felder geschwärzt sind; eine Kammer ohne Zahl darf beliebig viele haben.\n• Geschwärzte Felder berühren sich nie mit einer Seite.\n• Die nicht geschwärzten Felder bilden ein zusammenhängendes Gebiet.\n• Eine gerade Linie nicht geschwärzter Felder, waagrecht oder senkrecht, überquert nie zwei Kammergrenzen: Sie reicht höchstens in zwei Kammern.\n\nTippe auf ein Feld, um zu wechseln: geschwärzt → Punkt (deine Notiz „bleibt“) → leer. Rechtsklick wechselt zurück. Langes Drücken setzt Punkte neben geschwärzte Felder und in den Rest jeder Kammer, die schon alle ihre geschwärzten Felder hat. Punkte sind freiwillig: Das Rätsel ist gelöst, sobald die richtigen Felder geschwärzt sind.';

  @override
  String get tutChambers1 =>
      'Das Gitter ist in Kammern geteilt, und eine Zahl sagt, wie viele Felder ihrer Kammer geschwärzt sind. Geschwärzte Felder berühren sich nie mit einer Seite. Eine Kammer mit 0 bleibt leer, und eine Kammer aus einem Feld mit 1 ist geschwärzt. Tippe auf ein Feld, um es zu schwärzen.';

  @override
  String get tutChambers2 =>
      'Eine gerade Linie nicht geschwärzter Felder darf nicht zwei Kammergrenzen überqueren. Die markierte Zeile läuft durch drei Kammern, und zwei davon haben kein geschwärztes Feld, also muss die dritte die Linie unterbrechen. Löse dann das Gitter.';

  @override
  String get tutChambers3 =>
      'Die nicht geschwärzten Felder müssen ein Stück bleiben. Sobald sein Nachbar geschwärzt ist, ist der einzige Ausweg des Felds oben links das Feld darunter, also bleibt es. Tippe ein Feld zweimal an, um einen Punkt zu setzen (deine Notiz, dass es bleibt), und löse dann das Gitter.';

  @override
  String get tutChambers4 =>
      'Jetzt ein echtes Gitter. Beginne mit Kammern mit 0, Kammern, die jedes ihrer übrigen Felder brauchen, und langen Linien durch mehrere Kammern.';

  @override
  String get tutChambersS1 =>
      'Zähle, wie eine Kammer ihre geschwärzten Felder unterbringen kann. Die markierte Kammer ist drei Felder lang und hat eine 2, und geschwärzte Felder berühren sich nie, also können nur ihre beiden Enden geschwärzt sein. Schwärze sie und löse dann das Gitter.';

  @override
  String get tutChambersS2 =>
      'Probiere jede Art, die geschwärzten Felder einer Kammer unterzubringen: Keine zwei berühren sich, und jede lange Linie durch die Kammer, die nur sie unterbrechen kann, wird unterbrochen. Ein Feld, das jede Art schwärzt, ist geschwärzt, eines, das keine schwärzt, bleibt. Außerdem bleibt ein Feld, dessen Schwärzen die übrigen Felder in zwei Teile schneiden würde.';

  @override
  String get tutChambersS3 =>
      'Ein schweres Gitter. Wenn du feststeckst, schwärze ein Feld und folge den Folgen: Bekommt eine Kammer zu viele geschwärzte Felder, lässt sich eine lange Linie nicht unterbrechen oder werden Felder abgeschnitten, dann bleibt dieses Feld.';

  @override
  String exChambersFull(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat schon alle $count geschwärzten Felder',
      one: 'hat schon ihr 1 geschwärztes Feld',
      zero: 'hat keine geschwärzten Felder',
    );
    return '$cell bleibt: Kammer $room $_temp0.';
  }

  @override
  String exChambersNeed(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geschwärzte Felder',
      one: '1 geschwärztes Feld',
    );
    return '$cell ist geschwärzt: Kammer $room braucht $_temp0, und andere freie Felder hat sie nicht mehr.';
  }

  @override
  String exChambersSpan(Object cell, Object a, Object b) {
    return '$cell ist geschwärzt: Sonst blieben alle Felder von $a bis $b, eine gerade Linie über zwei Kammergrenzen.';
  }

  @override
  String exChambersWaysShade(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: '1 Feld',
    );
    return '$cell ist geschwärzt: Das tut jede Art, in Kammer $room $_temp0 zu schwärzen, ohne dass sie sich berühren und mit jeder langen Linie unterbrochen.';
  }

  @override
  String exChambersWaysKeep(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: '1 Feld',
    );
    return '$cell bleibt: Keine Art, in Kammer $room $_temp0 zu schwärzen, ohne dass sie sich berühren und mit jeder langen Linie unterbrochen, schwärzt es.';
  }

  @override
  String exChambersFailMany(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geschwärzte Felder',
      one: '1 geschwärztes Feld',
    );
    return 'Aber dann hat Kammer $room mehr als $_temp0.';
  }

  @override
  String exChambersFailFew(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geschwärzten Felder',
      one: '1 geschwärztes Feld',
    );
    return 'Aber dann kann Kammer $room keine $_temp0 mehr bekommen.';
  }

  @override
  String exChambersFailSpan(Object a, Object b) {
    return 'Aber dann bleiben alle Felder von $a bis $b, eine gerade Linie über zwei Kammergrenzen.';
  }

  @override
  String exChambersFailWays(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: '1 Feld',
    );
    return 'Aber dann lassen sich in Kammer $room keine $_temp0 schwärzen, ohne dass sie sich berühren und jede lange Linie unterbrochen ist.';
  }

  @override
  String get lookoutName => 'Ausguck';

  @override
  String get lookoutTagline => 'Schwärze Felder, sodass jede Zahl genau so viele sieht, wie sie sagt';

  @override
  String get lookoutRules =>
      '• Jede Zahl sagt, wie viele Felder sie waagrecht und senkrecht sieht, sich selbst mitgezählt: entlang ihrer Zeile und Spalte bis zum ersten geschwärzten Feld oder zum Rand.\n• Felder mit Zahlen werden nie geschwärzt.\n• Geschwärzte Felder berühren sich nie mit einer Seite.\n• Die nicht geschwärzten Felder bilden ein zusammenhängendes Gebiet.\n\nTippe auf ein Feld, um zu wechseln: geschwärzt → Punkt (deine Notiz „bleibt“) → leer. Rechtsklick wechselt zurück. Langes Drücken setzt Punkte neben geschwärzte Felder und in jedes Feld, das eine Zahl sieht, sobald geschwärzte Felder ihren Blick genau bei ihrer Zahl abschließen. Punkte sind freiwillig: Das Rätsel ist gelöst, sobald die richtigen Felder geschwärzt sind.';

  @override
  String get tutLookout1 =>
      'Jede Zahl zählt die Felder, die sie entlang ihrer Zeile und Spalte sieht, sich selbst mitgezählt, bis zu einem geschwärzten Feld oder zum Rand. Geschwärzte Felder berühren sich nie mit einer Seite, und Felder mit Zahlen werden nie geschwärzt. Die untere 2 sieht schon sich selbst und die 4 darüber, also muss ihr Blick überall sonst enden: Schwärze die Felder neben ihr und das Feld hinter der 4.';

  @override
  String get tutLookout2 =>
      'Zähle, wie weit eine Zahl höchstens sehen könnte. Die 5 könnte höchstens fünf Felder sehen: sich selbst, die zwei daneben und die zwei darüber. Also sieht sie alle, und alle bleiben. Löse dann das Gitter.';

  @override
  String get tutLookout3 =>
      'Die nicht geschwärzten Felder müssen ein Stück bleiben. Sobald das Feld unter der 3 geschwärzt ist, erreicht die Ecke unten rechts die anderen nur noch über das Feld links von ihr, also bleibt dieses. Tippe ein Feld zweimal an, um einen Punkt zu setzen (deine Notiz, dass es bleibt), und löse dann das Gitter.';

  @override
  String get tutLookout4 =>
      'Jetzt ein echtes Gitter. Beginne mit Zahlen, die in einer Richtung schon alles sehen, was sie dürfen, und mit großen Zahlen, die gerade so weit genug sehen können.';

  @override
  String get tutLookoutS1 =>
      'Der Blick einer Zahl endet am Rand oder an einem geschwärzten Feld, nie an einer anderen Zahl. Die 2 sieht ein Feld außer sich selbst. Nach links kann ihr Blick nicht nach einem Feld enden, weil das nächste die 3 ist, also sieht sie das Feld unter sich: Das Feld links von ihr und das zweite Feld nach unten sind geschwärzt.';

  @override
  String get tutLookoutS2 =>
      'Probiere jede Art, die Zahl auf ihre vier Richtungen aufzuteilen, wobei jeder Blick am Rand oder an einem Feld endet, das geschwärzt werden kann. Ein Feld, das jede Art sieht, bleibt, ein Feld, an dem jede Art endet, ist geschwärzt. Außerdem bleibt ein Feld, dessen Schwärzen die übrigen Felder in zwei Teile schneiden würde.';

  @override
  String get tutLookoutS3 =>
      'Ein schweres Gitter. Wenn du feststeckst, schwärze ein Feld und folge den Folgen: Sieht eine Zahl dann zu viele oder zu wenige Felder, berühren sich zwei geschwärzte Felder oder werden Felder abgeschnitten, dann bleibt dieses Feld.';

  @override
  String get tagSight => 'sehen, Sicht, Blick, sichtbar, schauen, Sichtlinie, Aussicht';

  @override
  String exLookoutReach(Object cell, Object clue, int count) {
    return '$cell bleibt: Die $count in $clue sieht in den anderen Richtungen nicht genug Felder, also sieht sie mindestens bis hierher.';
  }

  @override
  String exLookoutClose(Object cell, Object clue, int count) {
    return '$cell ist geschwärzt: Die $count in $clue sieht in dieser Richtung schon so viele Felder, wie sie darf, also endet ihr Blick hier.';
  }

  @override
  String exLookoutWaysShade(Object cell, Object clue, int count) {
    return '$cell ist geschwärzt: Jede Art, wie die $count in $clue genau $count Felder sieht, endet hier.';
  }

  @override
  String exLookoutWaysKeep(Object cell, Object clue, int count) {
    return '$cell bleibt: Jede Art, wie die $count in $clue genau $count Felder sieht, sieht dieses Feld.';
  }

  @override
  String exLookoutFailMany(Object clue, int count) {
    return 'Aber dann sieht die $count in $clue mehr als $count Felder.';
  }

  @override
  String exLookoutFailFew(Object clue, int count) {
    return 'Aber dann kann die $count in $clue keine $count Felder sehen.';
  }

  @override
  String exLookoutFailWays(Object clue, int count) {
    return 'Aber dann kann die $count in $clue nicht genau $count Felder sehen: Kein Blick der richtigen Länge endet am Rand oder an einem Feld, das geschwärzt werden kann.';
  }

  @override
  String get rampartName => 'Wall';

  @override
  String get rampartTagline => 'Baue eine gewundene Mauer, die zu den Hinweisen ringsum passt';

  @override
  String get rampartRules =>
      '• Schwärze Felder so, dass alle geschwärzten Felder eine Mauer bilden, über Seiten verbunden.\n• Kein 2×2-Block ist ganz geschwärzt.\n• Hinweisfelder werden nie geschwärzt. Ein Hinweis nennt die Reihen geschwärzter Felder unter seinen acht Nachbarn, diagonale mitgezählt, rund um ihn gelesen: „3 1“ heißt eine Reihe aus drei Feldern am Stück und ein einzelnes Feld getrennt davon, in beliebiger Reihenfolge. Eine 0 heißt, dass keines davon geschwärzt ist.\n\nTippe auf ein Feld, um zu wechseln: geschwärzt → Punkt (deine Notiz „bleibt“) → leer. Rechtsklick wechselt zurück. Langes Drücken setzt einen Punkt in das letzte Feld eines 2×2-Blocks mit drei geschwärzten Feldern und rund um jeden Hinweis, den die geschwärzten Felder schon erfüllen. Punkte sind freiwillig: Das Rätsel ist gelöst, sobald die richtigen Felder geschwärzt sind.';

  @override
  String get tutRampart1 =>
      'Schwärze Felder, um eine Mauer zu bauen. Jeder Hinweis sagt, welche seiner acht Nachbarn, diagonale mitgezählt, geschwärzt sind: Eine 3 ist eine Reihe aus drei am Stück rund um ihn, und eine 0 heißt, dass keiner geschwärzt ist. Hinweisfelder werden nie geschwärzt.';

  @override
  String get tutRampart2 =>
      'Kein 2×2-Block darf ganz geschwärzt sein. Schwärze, was die Hinweise verlangen, und das Feld oben links muss bleiben, sonst füllt sich sein Block. Tippe ein Feld zweimal an, um einen Punkt zu setzen (deine Notiz, dass es bleibt).';

  @override
  String get tutRampart3 =>
      'Ein Hinweis aus mehreren Zahlen hat ebenso viele getrennte Reihen: 2 2 sind zwei Reihen aus zwei Feldern, mit Feldern dazwischen, die bleiben. Alle geschwärzten Felder bilden eine Mauer, also treffen sich die beiden Reihen links herum.';

  @override
  String get tutRampart4 =>
      'Jetzt ein echtes Gitter. Beginne mit Hinweisen, die ihren Reihen nur einen Platz lassen, wie große Zahlen und Nullen, und halte die Mauer in einem Stück.';

  @override
  String get tutRampartS1 =>
      'Jede Reihe um einen Hinweis muss sich noch mit dem Rest der Mauer verbinden können. Die 1 1 braucht zwei getrennte einzelne geschwärzte Felder. Eine obere Ecke, allein geschwärzt, wäre vom Hinweis und den bleibenden Feldern ringsum eingeschlossen, also bleiben beide Ecken, und als einziges Paar bleiben die Felder links und rechts der Mitte.';

  @override
  String get tutRampartS2 =>
      'Wäge jeden Weg, einen Hinweis zu erfüllen, gegen die anderen Regeln ab: Ein Weg, der einen 2×2-Block füllt oder einen Teil der Mauer einschließt, fällt weg. Außerdem ist ein Feld geschwärzt, ohne das die Mauer in zwei Teile zerfiele, und Felder, die die Mauer nicht erreicht, bleiben.';

  @override
  String get tutRampartS3 =>
      'Ein schweres Gitter. Wenn du feststeckst, schwärze ein Feld und folge den Folgen: Lässt sich dann ein Hinweis nicht erfüllen, füllt sich ein 2×2-Block oder zerfällt die Mauer, dann bleibt dieses Feld.';

  @override
  String exRampartClueShade(Object cell, Object clue) {
    return '$cell ist geschwärzt: Jeder Weg, den Hinweis in $clue zu erfüllen, schwärzt es.';
  }

  @override
  String exRampartClueKeep(Object cell, Object clue) {
    return '$cell bleibt: Kein Weg, den Hinweis in $clue zu erfüllen, schwärzt es.';
  }

  @override
  String exRampartWaysShade(Object cell, Object clue) {
    return '$cell ist geschwärzt: Jeder Weg, den Hinweis in $clue ohne geschwärzten 2×2-Block und ohne eingeschlossenen Teil der Mauer zu erfüllen, schwärzt es.';
  }

  @override
  String exRampartWaysKeep(Object cell, Object clue) {
    return '$cell bleibt: Kein Weg, den Hinweis in $clue ohne geschwärzten 2×2-Block und ohne eingeschlossenen Teil der Mauer zu erfüllen, schwärzt es.';
  }

  @override
  String exRampartPool(Object cell, Object area) {
    return '$cell bleibt: Der Rest des 2×2-Blocks $area ist geschwärzt.';
  }

  @override
  String exRampartEscape(Object cell, Object other) {
    return '$cell ist geschwärzt: Es ist der einzige Ausweg für den Teil der Mauer bei $other.';
  }

  @override
  String exRampartCut(Object cell) {
    return '$cell ist geschwärzt: Bliebe es, zerfiele die Mauer in zwei Teile.';
  }

  @override
  String exRampartAway(Object cell) {
    return '$cell bleibt: Die Mauer kann es nicht erreichen.';
  }

  @override
  String exRampartFailClue(Object clue) {
    return 'Aber dann lässt sich der Hinweis in $clue nicht erfüllen.';
  }

  @override
  String exRampartFailPool(Object area) {
    return 'Aber dann ist der 2×2-Block $area ganz geschwärzt.';
  }

  @override
  String exRampartFailShut(Object cell) {
    return 'Aber dann ist der Teil der Mauer bei $cell eingeschlossen.';
  }

  @override
  String exRampartFailWays(Object clue) {
    return 'Aber dann lässt sich der Hinweis in $clue nicht ohne geschwärzten 2×2-Block oder eingeschlossenen Teil der Mauer erfüllen.';
  }

  @override
  String exRampartFailApart(Object a, Object b) {
    return 'Aber dann können sich die geschwärzten Felder $a und $b nicht verbinden.';
  }

  @override
  String get waymarksName => 'Wegmarken';

  @override
  String get waymarksTagline => 'Jedes Zeichen weist den Weg zur nächsten Zahl';

  @override
  String get waymarksRules =>
      '• In jedem Feld steht ein Pfeil, außer im letzten, das einen Ring hat.\n• Nummeriere die Felder 1, 2, 3, … bis zum letzten so, dass jeder Pfeil auf das Feld mit der nächsten Zahl zeigt. Dieses Feld kann beliebig weit entfernt auf der Linie des Pfeils liegen, mit anderen Feldern dazwischen.\n• Einige Zahlen sind vorgegeben, immer die 1 und die letzte.\n\nZiehe von einem Feld zu dem Feld, das darauf folgt, oder tippe erst das eine, dann das andere an, um sie zu verbinden. Verbundene Felder zählen von einer vorgegebenen Zahl in ihrer Kette weiter; eine Kette ohne eine bekommt einen Buchstaben (a, a+1, …), bis sie sich einer anschließt. Tippe ein gewähltes Feld noch einmal an, um seine Verbindung zu lösen, oder halte ein Feld gedrückt (Rechtsklick), um alle seine Verbindungen zu trennen.';

  @override
  String get tutWaymarks1 =>
      'Nummeriere die Felder von 1 bis zum Ring: Jeder Pfeil zeigt auf die nächste Zahl, beliebig weit entlang seiner Linie. Ein Pfeil mit nur einem freien Feld vor sich führt dorthin. Ziehe von einem Feld zum nächsten, um sie zu verbinden, oder tippe erst das eine, dann das andere an.';

  @override
  String get tutWaymarks2 =>
      'Schau auch rückwärts: Jedes Feld außer der 1 braucht ein Feld davor. Zeigt nur ein freier Pfeil auf ein Feld, folgt dieses Feld direkt auf das Feld des Pfeils.';

  @override
  String get tutWaymarks3 =>
      'Verbundene Felder zählen von einer vorgegebenen Zahl weiter, und eine Kette ohne eine bekommt einen Buchstaben: a, a+1, … Zwei vorgegebene Zahlen, die eins auseinander liegen, wie 12 und 13, sind immer verbunden, und Felder, deren Zahlen nicht eins auseinander liegen, nie.';

  @override
  String get tutWaymarks4 =>
      'Eine Kette führt nie zu ihrem eigenen ersten Feld zurück: Das schlösse eine Schleife, und die Zahlen steigen nur. Das Ende einer Kette kann sich also nicht mit dem Anfang derselben Kette verbinden.';

  @override
  String get tutWaymarks5 =>
      'Jetzt ein echtes Brett. Verbinde Felder mit nur einem Weg weiter oder nur einem Weg hinein, zähle von den vorgegebenen Zahlen weiter und lass keine Kette zu ihrem Anfang zurückführen.';

  @override
  String get tutWaymarksS1 =>
      'Überlege, welche Zahlen ein Feld noch sein kann. Seine Zahl ist eins mehr als eine Zahl eines Feldes, das zu ihm führen kann, und eins weniger als eine Zahl eines Feldes, zu dem es führen kann, und keine Zahl kommt zweimal vor. Grenze die Felder so ein, bis für eine Verbindung nur eine Wahl bleibt.';

  @override
  String get tutWaymarksS2 =>
      'Zwei Felder können nur verbunden sein, wenn ihre Zahlen eins auseinander liegen können. Ist keine mögliche Zahl des zweiten Feldes eins mehr als eine mögliche Zahl des ersten, streiche diese Verbindung und schau, was übrig bleibt.';

  @override
  String get tutWaymarksS3 =>
      'Ein schweres Brett. Wenn du feststeckst, nimm eine Verbindung an und folge ihr: Bleibt einem Feld kein Weg weiter, kein Weg hinein oder keine Zahl, ist die Verbindung falsch.';

  @override
  String exWaymarksOnlyOut(Object from, Object to) {
    return '$from kann nur zu $to führen: Vor seinem Pfeil ist kein anderes Feld übrig.';
  }

  @override
  String exWaymarksOnlyIn(Object from, Object to) {
    return 'Nur $from kann noch zu $to führen, also folgt $to direkt darauf.';
  }

  @override
  String exWaymarksTaken(Object from, Object to) {
    return '$from führt zu $to, also verlässt keine andere Verbindung $from oder erreicht $to.';
  }

  @override
  String exWaymarksConsecutive(Object from, Object to, Object a, Object b) {
    return '$from ist $a und $to ist $b, also folgt $to direkt auf $from.';
  }

  @override
  String exWaymarksApart(Object from, Object to, Object a, Object b) {
    return '$from ist $a und $to ist $b, nicht die nächste Zahl, also führt $from nicht zu $to.';
  }

  @override
  String exWaymarksLoop(Object from, Object to) {
    return '$from kann nicht zu $to führen: Die Kette durch $from beginnt bei $to, das schlösse eine Schleife.';
  }

  @override
  String exWaymarksNoFit(Object from, Object to) {
    return '$from kann nicht zu $to führen: Keine mögliche Zahl von $to ist eins mehr als eine mögliche Zahl von $from.';
  }

  @override
  String exWaymarksNumberOn(Object cell, Object nums) {
    return '$cell ist $nums: Seine Kette zählt von einer vorgegebenen Zahl weiter.';
  }

  @override
  String exWaymarksFailStuck(Object cell) {
    return 'Aber dann hat $cell kein Feld mehr, zu dem es weiterführen kann.';
  }

  @override
  String exWaymarksFailNoPrev(Object cell) {
    return 'Aber dann kann kein Feld zu $cell führen.';
  }

  @override
  String exWaymarksFailNumber(Object cell) {
    return 'Aber dann passt keine Zahl zu $cell.';
  }

  @override
  String exWaymarksFailLoop(Object cell) {
    return 'Aber dann schließt die Kette durch $cell eine Schleife.';
  }

  @override
  String exWaymarksFailLink(Object from, Object to) {
    return 'Aber dann widersprechen sich die Verbindungen bei $from und $to.';
  }

  @override
  String exWaymarksSupposeOn(Object from, Object to) {
    return 'Angenommen, $from führte zu $to.';
  }

  @override
  String exWaymarksSupposeOff(Object from, Object to) {
    return 'Angenommen, $from führte nicht zu $to.';
  }

  @override
  String exWaymarksRefutedOff(Object from, Object to) {
    return 'Also führt $from nicht zu $to.';
  }

  @override
  String exWaymarksRefutedOn(Object from, Object to) {
    return 'Also führt $from zu $to.';
  }

  @override
  String get tagArrow => 'Pfeil, Pfeile, Richtung, Zeiger';

  @override
  String exWaymarksNumbers(Object cell, Object nums) {
    return '$cell kann nur $nums sein.';
  }

  @override
  String get polesName => 'Pole';

  @override
  String get polesTagline => 'Gib jedem Stein ein Plus- und ein Minusende, oder keins, passend zu den Zahlen am Rand';

  @override
  String get polesRules =>
      '• Das Gitter ist in Dominos geteilt. Jedes Domino ist entweder geladen, mit + an einem Ende und − am anderen, oder neutral.\n• Zwei Felder mit + berühren sich nie seitlich, ebenso wenig zwei Felder mit −.\n• Die Zahlen links und über dem Gitter sagen, wie viele Felder mit + jede Zeile und Spalte hat; die Zahlen rechts und unter dem Gitter zählen die Felder mit −. Auf schweren Rätseln sind manche Zahlen verborgen.\n\nTippe auf ein Feld zum Wechseln: + → − → Punkt (neutral) → leer. Rechtsklick wechselt zurück. Wische über Felder, um sie alle auf einmal zu setzen. Langes Drücken ergänzt das andere Ende jedes begonnenen Dominos (− gegenüber +, Punkt gegenüber Punkt) und setzt Punkte in den Rest jeder Linie, die schon alle ihre + und − hat. Punkte sind freiwillig: Das Rätsel ist gelöst, sobald alle + und − stehen. Eine Zahl verblasst, sobald ihre Linie so viele hat.';

  @override
  String get tutPoles1 =>
      'Das Gitter ist in Dominos geteilt. Jedes ist entweder geladen, mit + an einem Ende und − am anderen, oder neutral. Die Zahlen links und oben zählen die Felder mit + jeder Zeile und Spalte, die Zahlen rechts und unten die Felder mit −. Tippe auf ein Feld zum Wechseln: +, −, Punkt (neutral).';

  @override
  String get tutPoles2 =>
      'Zwei Felder mit + berühren sich nie seitlich, ebenso wenig zwei mit −. Das verrät, wie herum ein Domino liegt: Sein + kann nicht neben einem anderen + stehen. Löse das Rätsel zu Ende.';

  @override
  String get tutPoles3 =>
      'Zähle die beiden Zahlen einer Linie zusammen: So viele ihrer Felder sind geladen. Hat die Linie schon so viele, sind ihre übrigen Felder neutral; braucht sie jedes Feld, das noch geladen sein kann, ist keines davon neutral. Löse das Rätsel zu Ende.';

  @override
  String get tutPoles4 =>
      'Jetzt ein echtes Rätsel. Beginne mit Linien, deren Zahlen null sind oder die jedes Feld brauchen, und denk daran: Am anderen Ende eines Dominos steht immer das Gegenteil.';

  @override
  String get tutPolesS1 =>
      'Geh alle Arten durch, eine Linie zu füllen: Ihre Zahlen, ihre Dominos und die Regel, dass gleiche Enden sich nie berühren, lassen nur wenige übrig. Ein Wert, den keine Art in ein Feld setzt, ist dort ausgeschlossen. Sieh dir die langen Zeilen dieses Rätsels an.';

  @override
  String get tutPolesS2 =>
      'Ein schweres Rätsel: Manche Zahlen sind verborgen. Wenn du feststeckst, nimm an, in einem Feld stehe +, und folge den Schlüssen: Bekommt eine Linie ihre Zahlen nicht oder treffen gleiche Enden aufeinander, steht dort kein +.';

  @override
  String get tagCharge => 'Plus, Minus, positiv, negativ, Ladung, elektrisch, Polarität, anziehen, abstoßen';

  @override
  String exPolesPartner(Object cell, Object value, Object other, Object opposite) {
    return 'In $cell steht $value: Am anderen Ende des Dominos, in $other, steht $opposite.';
  }

  @override
  String exPolesPartnerOut(Object cell, Object value, Object other, Object opposite) {
    return 'In $cell kann kein $value stehen: Am anderen Ende des Dominos, in $other, kann kein $opposite stehen.';
  }

  @override
  String exPolesRepel(Object cell, Object value, Object other) {
    return 'In $cell kann kein $value stehen: Das Feld berührt das $value in $other.';
  }

  @override
  String exPolesRowDone(Object value, Object row, int count) {
    return 'Zeile $row hat schon so viele $value, wie sie braucht ($count): Weitere $value hat sie nicht.';
  }

  @override
  String exPolesColDone(Object value, Object col, int count) {
    return 'Spalte $col hat schon so viele $value, wie sie braucht ($count): Weitere $value hat sie nicht.';
  }

  @override
  String exPolesRowNeed(Object cell, Object value, Object row, int count) {
    return 'In $cell steht $value: Zeile $row braucht so viele $value ($count), wie Felder sie noch haben können.';
  }

  @override
  String exPolesColNeed(Object cell, Object value, Object col, int count) {
    return 'In $cell steht $value: Spalte $col braucht so viele $value ($count), wie Felder sie noch haben können.';
  }

  @override
  String exPolesRowBlank(Object cell, Object row, int count, Object plus, Object minus) {
    return '$cell ist neutral: Zeile $row hat schon alle Felder mit $plus oder $minus ($count).';
  }

  @override
  String exPolesColBlank(Object cell, Object col, int count, Object plus, Object minus) {
    return '$cell ist neutral: Spalte $col hat schon alle Felder mit $plus oder $minus ($count).';
  }

  @override
  String exPolesRowCharged(Object row, int count, Object plus, Object minus) {
    return 'Zeile $row braucht so viele Felder mit $plus oder $minus ($count), wie sie noch haben können: Keines davon ist neutral.';
  }

  @override
  String exPolesColCharged(Object col, int count, Object plus, Object minus) {
    return 'Spalte $col braucht so viele Felder mit $plus oder $minus ($count), wie sie noch haben können: Keines davon ist neutral.';
  }

  @override
  String exPolesLast(Object cell, Object value) {
    return 'In $cell steht $value: Nichts anderes bleibt übrig.';
  }

  @override
  String exPolesRowFill(Object cell, Object value, Object row) {
    return 'In $cell kann kein $value stehen: Keine Art, Zeile $row passend zu ihren Zahlen zu füllen, setzt es dorthin.';
  }

  @override
  String exPolesColFill(Object cell, Object value, Object col) {
    return 'In $cell kann kein $value stehen: Keine Art, Spalte $col passend zu ihren Zahlen zu füllen, setzt es dorthin.';
  }

  @override
  String exPolesFailEmpty(Object cell) {
    return 'Aber dann passt nichts in $cell.';
  }

  @override
  String exPolesFailRowMany(Object row, Object value, int count) {
    return 'Aber dann hat Zeile $row zu viele $value (sie braucht $count).';
  }

  @override
  String exPolesFailColMany(Object col, Object value, int count) {
    return 'Aber dann hat Spalte $col zu viele $value (sie braucht $count).';
  }

  @override
  String exPolesFailRowFew(Object row, Object value, int count) {
    return 'Aber dann bekommt Zeile $row nicht genug $value (sie braucht $count).';
  }

  @override
  String exPolesFailColFew(Object col, Object value, int count) {
    return 'Aber dann bekommt Spalte $col nicht genug $value (sie braucht $count).';
  }

  @override
  String exPolesFailRowFill(Object row) {
    return 'Aber dann lässt sich Zeile $row nicht passend zu ihren Zahlen füllen.';
  }

  @override
  String exPolesFailColFill(Object col) {
    return 'Aber dann lässt sich Spalte $col nicht passend zu ihren Zahlen füllen.';
  }

  @override
  String get mercuryName => 'Quecksilber';

  @override
  String get mercuryTagline => 'Fülle die Röhren ab der Kugel passend zu den Zahlen';

  @override
  String get mercuryRules =>
      '• Das Gitter ist mit Röhren bedeckt, gerade oder geknickt, jede beginnt an einer runden Kugel.\n• Fülle einige Felder mit Quecksilber. In jeder Röhre beginnt es an der Kugel und geht ohne Lücke weiter, so weit du willst: Eine Röhre kann leer bleiben, teilweise oder bis zur Spitze gefüllt sein.\n• Die Zahlen außen sagen, wie viele gefüllte Felder jede Zeile und Spalte enthält. Auf schwereren Feldern sind manche verborgen.\n\nTippe auf ein Feld zum Durchschalten: Quecksilber → leer (deine Notiz) → unmarkiert. Rechtsklick schaltet zurück. Wische über Felder, um sie alle auf einmal zu füllen. Langes Drücken füllt jedes Feld zwischen deinem Quecksilber und seiner Kugel und markiert die Felder hinter deinen Leer-Notizen sowie in Zeilen und Spalten mit all ihrem Quecksilber als leer. Leer-Notizen sind freiwillig: Das Rätsel ist gelöst, sobald alles Quecksilber an seinem Platz ist.';

  @override
  String get famFilling => 'Füllen';

  @override
  String get famFillingAbout => 'Fülle jedes Gefäß von einem Ende bis zu einer Höhe, sodass die Zahlen außen stimmen';

  @override
  String get tagTemperature => 'Temperatur, Wärme, Fieber, Grad, Skala, Röhre, Kugel, Quecksilber, füllen, Pegel';

  @override
  String get tutMercury1 =>
      'Das Gitter ist mit Röhren bedeckt, und Quecksilber füllt jede von ihrer runden Kugel aus. Die Zahlen außen sagen, wie viele gefüllte Felder jede Zeile und Spalte enthält. Tippe auf ein Feld, um es zu füllen, noch einmal, um es als leer zu markieren.';

  @override
  String get tutMercury2 =>
      'Quecksilber beginnt immer an der Kugel und lässt keine Lücke: Ist ein Feld gefüllt, dann auch jedes Feld zwischen ihm und der Kugel, sogar um einen Knick. Und ein leeres Feld lässt den Rest seiner Röhre bis zur Spitze leer. Löse das Feld.';

  @override
  String get tutMercury3 =>
      'Denk voraus: Ein gefülltes Feld füllt alles bis zu seiner Kugel. Kämen so in eine Zeile oder Spalte mehr gefüllte Felder, als ihre Zahl erlaubt, bleibt das Feld leer. Ein leeres Feld leert seine Röhre bis zur Spitze; fehlen einer Linie dann Felder, ist das Feld gefüllt. Löse das Feld.';

  @override
  String get tutMercury4 =>
      'Jetzt ein echtes Feld. Beginne mit leeren oder vollen Zeilen und Spalten, fülle bis zu den Kugeln und zähle, bevor du ein Feld füllst, wie viel Quecksilber es mit sich bringt.';

  @override
  String get tutMercuryS1 =>
      'Zwei Linien mit mehreren gemeinsamen Röhren lohnt es sich zusammen zu zählen: Jede gemeinsame Röhre füllt sie in fester Reihenfolge von ihrer Kugel aus, also ist nicht jede Aufteilung des Quecksilbers zwischen ihnen möglich. Hier teilen sich die Spalten D und E drei Röhren. Probiere die Arten, wie diese Röhren beide Zahlen zugleich ergeben: Ein Feld, das jedes Mal gleich ausfällt, steht fest.';

  @override
  String get tutMercuryS2 =>
      'Ein mittleres Feld: Manche Zahlen sind verborgen, und manche Schritte brauchen zwei Linien zusammen gezählt. Suche Zeilen und Spalten mit gemeinsamen Röhren, etwa eine Röhre, die von der einen in die andere abbiegt.';

  @override
  String get tutMercuryS3 =>
      'Ein schweres Feld: Mehr Zahlen sind verborgen. Wenn du feststeckst, nimm an, dass ein Feld gefüllt ist, und fülle bis zu seiner Kugel: Läuft eine Zeile oder Spalte über oder erreicht ihre Zahl nicht mehr, bleibt das Feld leer.';

  @override
  String exMercurySupposeFull(Object cell) {
    return 'Angenommen, $cell wäre gefüllt.';
  }

  @override
  String exMercurySupposeEmpty(Object cell) {
    return 'Angenommen, $cell bliebe leer.';
  }

  @override
  String exMercuryRefutedFull(Object cell) {
    return '$cell bleibt leer: Es zu füllen führt zu einem Widerspruch.';
  }

  @override
  String exMercuryRefutedEmpty(Object cell) {
    return '$cell ist gefüllt: Es leer zu lassen führt zu einem Widerspruch.';
  }

  @override
  String exMercuryToBulb(Object cell, Object other) {
    return '$cell ist gefüllt: Das Quecksilber auf $other reicht ohne Lücke von der Kugel bis dorthin.';
  }

  @override
  String exMercuryPastEmpty(Object cell, Object other) {
    return '$cell bleibt leer: $other, näher an der Kugel derselben Röhre, ist leer, und Quecksilber überspringt keine Lücke.';
  }

  @override
  String exMercuryRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat schon alle $count gefüllten Felder',
      one: 'hat schon ihr gefülltes Feld',
      zero: 'hat keine gefüllten Felder',
    );
    return '$cell bleibt leer: Zeile $row $_temp0.';
  }

  @override
  String exMercuryColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat schon alle $count gefüllten Felder',
      one: 'hat schon ihr gefülltes Feld',
      zero: 'hat keine gefüllten Felder',
    );
    return '$cell bleibt leer: Spalte $col $_temp0.';
  }

  @override
  String exMercuryRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gefüllte Felder',
      one: 'ein gefülltes Feld',
    );
    return '$cell ist gefüllt: Zeile $row braucht $_temp0, und genau so viele Felder sind übrig.';
  }

  @override
  String exMercuryColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gefüllte Felder',
      one: 'ein gefülltes Feld',
    );
    return '$cell ist gefüllt: Spalte $col braucht $_temp0, und genau so viele Felder sind übrig.';
  }

  @override
  String exMercuryTooMuchRow(Object cell, Object row, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'nur noch $need braucht',
      one: 'nur noch eins braucht',
      zero: 'schon all ihre gefüllten Felder hat',
    );
    return '$cell bleibt leer: Bis zur Kugel gefüllt, würde es $_temp0 von Zeile $row füllen, die $_temp1.';
  }

  @override
  String exMercuryTooMuchCol(Object cell, Object col, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'nur noch $need braucht',
      one: 'nur noch eins braucht',
      zero: 'schon all ihre gefüllten Felder hat',
    );
    return '$cell bleibt leer: Bis zur Kugel gefüllt, würde es $_temp0 von Spalte $col füllen, die $_temp1.';
  }

  @override
  String exMercuryTooLittleRow(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    return '$cell ist gefüllt: Leer hielte es $_temp0 von Zeile $row bis zur Spitze leer, und die Zeile käme nicht mehr auf ihre Zahl.';
  }

  @override
  String exMercuryTooLittleCol(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Felder',
      one: 'ein Feld',
    );
    return '$cell ist gefüllt: Leer hielte es $_temp0 von Spalte $col bis zur Spitze leer, und die Spalte käme nicht mehr auf ihre Zahl.';
  }

  @override
  String exMercuryLinesRows(Object a, Object b) {
    return 'Zeilen $a und $b';
  }

  @override
  String exMercuryLinesCols(Object a, Object b) {
    return 'Spalten $a und $b';
  }

  @override
  String exMercuryLinesRowCol(Object row, Object col) {
    return 'Zeile $row und Spalte $col';
  }

  @override
  String exMercuryPairFull(Object cell, Object lines) {
    return '$cell ist gefüllt: $lines teilen sich Röhren, und zusammen gezählt gehen ihre Zahlen nur mit diesem Feld gefüllt beide auf.';
  }

  @override
  String exMercuryPairEmpty(Object cell, Object lines) {
    return '$cell bleibt leer: $lines teilen sich Röhren, und zusammen gezählt gehen ihre Zahlen nur mit diesem Feld leer beide auf.';
  }

  @override
  String exMercuryFailOrder(Object full, Object empty) {
    return 'Aber dann ist $full gefüllt, während $empty, näher an der Kugel derselben Röhre, leer bleibt.';
  }

  @override
  String exMercuryFailRowMany(Object row, int count) {
    return 'Aber dann bekommt Zeile $row mehr als $count gefüllte Felder.';
  }

  @override
  String exMercuryFailColMany(Object col, int count) {
    return 'Aber dann bekommt Spalte $col mehr als $count gefüllte Felder.';
  }

  @override
  String exMercuryFailRowFew(Object row, int count) {
    return 'Aber dann kommt Zeile $row nicht mehr auf $count gefüllte Felder.';
  }

  @override
  String exMercuryFailColFew(Object col, int count) {
    return 'Aber dann kommt Spalte $col nicht mehr auf $count gefüllte Felder.';
  }

  @override
  String exMercuryFailPair(Object lines) {
    return 'Aber dann können die Zahlen der $lines nicht mehr beide aufgehen.';
  }

  @override
  String get nightfallName => 'Dämmerung';

  @override
  String get nightfallTagline => 'Tippe auf die Fenster, bis das ganze Haus dunkel ist';

  @override
  String get nightfallRules =>
      '• Jedes Feld ist ein Fenster, hell oder dunkel.\n• Ein Tipp auf ein Fenster schaltet es um und dazu seine Nachbarn darüber, darunter, links und rechts: helle werden dunkel, dunkle werden hell.\n• Mach alle Fenster dunkel, innerhalb des Zuglimits, falls das Spiel eines hat.\n\nDie Reihenfolge der Tipps spielt nie eine Rolle, und zweimal auf dasselbe Fenster tippen ändert nichts. Wenn die Ränder verbunden sind, schaltet ein Fenster am Rand auch das gegenüber auf der anderen Seite um.';

  @override
  String get nightfallEdges => 'Ränder';

  @override
  String get nightfallEdgesFlat => 'Offen';

  @override
  String get nightfallEdgesFlatHint => 'Fenster am Rand haben weniger Nachbarn.';

  @override
  String get nightfallEdgesWrap => 'Verbunden';

  @override
  String get nightfallEdgesWrapHint =>
      'Die Ränder hängen zusammen: Ein Fenster am Rand schaltet auch das gegenüber auf der anderen Seite um.';

  @override
  String get nightfallGoalMoves => 'Zuglimit';

  @override
  String get nightfallGoalMovesHint =>
      'Mach alles dunkel mit ein paar Zügen mehr als den wenigsten (auf schwer ohne Reserve).';

  @override
  String get nightfallGoalFree => 'Freies Spiel';

  @override
  String get nightfallGoalFreeHint => 'Kein Limit: Nimm so viele Züge, wie du brauchst.';

  @override
  String nightfallMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Züge',
      one: '$count Zug',
    );
    return '$_temp0';
  }

  @override
  String get nightfallFewest => 'Dunkel mit den wenigsten Zügen!';

  @override
  String get tutNightfall1 =>
      'Ein Tipp schaltet ein Fenster um und dazu seine Nachbarn darüber, darunter, links und rechts: helle werden dunkel, dunkle werden hell. Tippe auf das mittlere Fenster, um alle Fenster dunkel zu machen.';

  @override
  String get tutNightfall2 =>
      'Ein Fenster am Rand oder in einer Ecke hat weniger Nachbarn, also schaltet ein Tipp dort weniger Fenster um. Mach alle Fenster dunkel.';

  @override
  String get tutNightfall3 =>
      'Zwei Tipps, die dasselbe Fenster umschalten, lassen es, wie es war. Die Reihenfolge der Tipps spielt nie eine Rolle, und zweimal auf dasselbe Fenster tippen ändert nichts, also braucht jedes Fenster einen Tipp oder keinen.';

  @override
  String get tutNightfall4 =>
      'Ein echtes Brett. Der Zähler zeigt deine Züge und das Limit: ein paar mehr als die wenigsten, die alle Fenster dunkel machen. Rückgängig gibt einen Zug zurück.';

  @override
  String get tutNightfallS1 =>
      'Treib das Licht nach unten: Tippe unter jedem hellen Fenster der obersten Reihe auf das Fenster direkt darunter, dann wird die oberste Reihe dunkel. Mach dasselbe mit jeder Reihe der Reihe nach, bis ganz unten.';

  @override
  String get tutNightfallS2 =>
      'Hier lässt das Treiben helle Fenster in der untersten Reihe: Auch die oberste Reihe braucht einen Tipp. Tippe zuerst auf das markierte Fenster und treib das Licht dann wieder nach unten.';

  @override
  String get tutNightfallS3 =>
      'Ein echtes Brett ohne Zuglimit. Treib das Licht nach unten; bleibt in der untersten Reihe etwas hell, fang neu an mit ein, zwei Tipps in der obersten Reihe und treib es wieder, bis auch die unterste Reihe dunkel ist.';

  @override
  String get tagSwitch => 'Licht, Lichter, Schalter, umschalten, an und aus, dunkel, Nacht, Fenster';

  @override
  String get glideName => 'Gleiten';

  @override
  String get glideTagline => 'Schiebe die Plättchen durch die Lücke, bis sie wieder in Reihenfolge sind';

  @override
  String get glideRules =>
      '• Im Rahmen liegen nummerierte Plättchen und eine Lücke.\n• Tippe ein Plättchen neben der Lücke an, um es hineinzuschieben. Ein Plättchen weiter hinten in der Zeile oder Spalte der Lücke schiebt sich mit allen Plättchen dazwischen auf einmal. Du kannst auch wischen oder die Pfeiltasten nehmen.\n• Bring die Plättchen in Reihenfolge: 1, 2, 3, … Zeile für Zeile von oben, die Lücke unten rechts.\n\nJedes Plättchen, das sich bewegt, zählt als ein Zug. Mit farbigen Plättchen baust du stattdessen den Farbverlauf nach: jedes Plättchen gehört dorthin, wo seine Farbe passt.';

  @override
  String get glideFace => 'Plättchen';

  @override
  String get glideFaceNumbers => 'Zahlen';

  @override
  String get glideFaceNumbersHint => 'Nummerierte Plättchen, die 1 oben links.';

  @override
  String get glideFaceColors => 'Farben';

  @override
  String get glideFaceColorsHint => 'Plättchen eines Farbverlaufs: Leg jede Farbe dorthin, wo sie passt.';

  @override
  String get glideGoalFree => 'Freies Spiel';

  @override
  String get glideGoalFreeHint => 'Kein Limit: Nimm so viele Züge, wie du brauchst.';

  @override
  String get glideGoalMoves => 'Zuglimit';

  @override
  String get glideGoalMovesHint =>
      'Schaff es im Limit: doppelt so viele Züge wie der beste Weg auf leicht, das 1,5-Fache auf mittel, das 1,25-Fache auf schwer.';

  @override
  String glideMoves(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Züge',
      one: '$count Zug',
    );
    return '$_temp0';
  }

  @override
  String get glideFewest => 'Geordnet mit den wenigsten Zügen!';

  @override
  String get tutGlide1 =>
      'Der Rahmen hat eine Lücke. Tippe das markierte Plättchen daneben an, um es in die Lücke zu schieben. Das Ziel: die Plättchen in Reihenfolge, 1, 2, 3, … Zeile für Zeile, die Lücke am Ende.';

  @override
  String get tutGlide2 =>
      'Auch ein Plättchen weiter hinten in der Zeile oder Spalte der Lücke bewegt sich: Tippe das markierte Plättchen an, und es rückt mit allen Plättchen zwischen ihm und der Lücke auf.';

  @override
  String get tutGlide3 =>
      'Du kannst ein Plättchen auch zur Lücke hin wischen, oder irgendwo wischen, um das Plättchen zu schieben, das in diese Richtung kann. Wisch das markierte Plättchen nach oben, dann das darunter.';

  @override
  String get tutGlide4 =>
      'Jetzt liegen ein paar Plättchen falsch. Bring sie zurück in Reihenfolge: Plättchen rücken nur in die Lücke, also überleg, wohin die Lücke muss.';

  @override
  String get tutGlide5 =>
      'Ein echtes Brett. Der Zähler zeigt deine Züge und das Limit; jedes Plättchen, das sich bewegt, zählt. Rückgängig gibt Züge zurück.';

  @override
  String get tutGlideS1 =>
      'Große Bretter löst du Zeile für Zeile: Bring 1, 2, 3 und 4 in die oberste Zeile und lass sie dann in Ruhe. Was übrig bleibt, ist ein kleineres Brett; lös es genauso.';

  @override
  String get tutGlideS2 =>
      'Das Ende einer Zeile ist der knifflige Teil: 1, 2 und 3 sind daheim, aber die 4 kommt nicht an der 3 vorbei, ohne sie zu bewegen. Setz zuerst die 4 dorthin, wo die 3 hingehört, und die 3 direkt darunter, dann schieb beide zusammen hinein: die 4 nach rechts, die 3 nach oben.';

  @override
  String get tutGlideS3 =>
      'Ein echtes Brett. Leg die oberste Zeile, dann die linke Spalte, dann die nächste Zeile, sodass das Brett immer kleiner wird. Die letzten zwei Plättchen einer Spalte kommen zusammen hinein, wie das Ende einer Zeile, auf die Seite gedreht. Am Ende bleibt eine kleine Ecke: Lass ihre Plättchen im Kreis wandern, bis sie an ihrem Platz sind.';
}
