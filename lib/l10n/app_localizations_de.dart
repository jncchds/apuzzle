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
  String get playCode => 'Rätselcode spielen';

  @override
  String get playCodeMenu => 'Rätselcode spielen…';

  @override
  String get inProgress => 'Läuft';

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
      '• Setze genau eine Krone in jede Zeile, jede Spalte und jeden farbigen Bereich.\n• Kronen dürfen sich nicht berühren, auch nicht diagonal.\n\nTippe auf ein Feld, um zu wechseln: leer → Punkt (deine Notiz „keine Krone hier“) → Krone. Langes Drücken / Rechtsklick wechselt zurück.';

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
  String get pipesName => 'Rohre';

  @override
  String get pipesTagline => 'Verbinde jedes Rohr mit der Quelle';

  @override
  String get pipesRules =>
      '• Drehe die Kacheln so, dass jedes Rohr mit der Quelle (der Kachel mit Ring) verbunden ist.\n• Kein Rohrende darf offen bleiben, und das Netz darf keine Schleifen enthalten.\n• Wasser fließt durch alles, was bereits mit der Quelle verbunden ist.\n• Kacheln mit einem Punkt in der Ecke sind fest und schon an ihrem Platz.\n\nTippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen; langes Drücken / Rechtsklick dreht sie zurück.';

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
  String get campName => 'Zeltplatz';

  @override
  String get campTagline => 'Stell neben jeden Baum ein Zelt';

  @override
  String get campRules =>
      '• Stell für jeden Baum ein Zelt direkt daneben auf (oben, unten, links oder rechts).\n• Jeder Baum bekommt sein eigenes Zelt, und jedes Zelt gehört zu einem Baum daneben.\n• Zelte berühren sich nie, auch nicht diagonal.\n• Die Zahlen außerhalb des Gitters geben an, wie viele Zelte in jeder Zeile und Spalte stehen.\n\nTippe auf ein Feld, um zu wechseln: leer → Gras (deine Notiz „kein Zelt hier“) → Zelt. Langes Drücken / Rechtsklick wechselt zurück.';

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
      '• Schattiere in jedem umrandeten Bereich genau zwei Felder.\n• Jedes schattierte Feld berührt seitlich genau ein anderes schattiertes Feld, die Schattierung besteht also aus Paaren.\n• Paare berühren einander nie seitlich (an den Ecken schon).\n\nTippe auf ein Feld, um zu wechseln: leer → schattiert → Punkt (deine Notiz „nicht schattiert“). Langes Drücken / Rechtsklick wechselt zurück.';

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
}
