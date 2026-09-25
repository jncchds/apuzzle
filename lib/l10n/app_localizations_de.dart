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
  String get highlightErrorsHint =>
      'Aus: Fehler werden erst nach „Prüfen“ angezeigt';

  @override
  String get autoClearMarks => 'Notizen automatisch entfernen';

  @override
  String get autoClearMarksHint =>
      'Eine gesetzte Zahl löscht diese Notiz aus Zeile, Spalte und Block';

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
  String get couldNotOpenSettings =>
      'Die Systemeinstellungen konnten nicht geöffnet werden';

  @override
  String get submitConflicts => 'Einige Felder verletzen die Regeln';

  @override
  String get submitIncomplete => 'Noch nicht fertig';

  @override
  String get submitWrong => 'Nicht ganz richtig';

  @override
  String get restartTitle => 'Rätsel neu starten?';

  @override
  String get restartBody =>
      'Alle Eingaben werden gelöscht. Du kannst es noch rückgängig machen.';

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
      other:
          'Ich habe in „$name“ $score Punkte in $time mit $hints Tipps erreicht.',
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
  String get outOfMoves =>
      'Keine Züge mehr: rückgängig machen oder neu starten';

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
  String get popModeStandardHint =>
      'Blasen fallen nach unten; leere Spalten rücken nach rechts zusammen.';

  @override
  String get popModeShifter => 'Schieber';

  @override
  String get popModeShifterHint =>
      'Zeilen rutschen außerdem nach rechts und schließen jede Lücke.';

  @override
  String get popModeContinuous => 'Endlos';

  @override
  String get popModeContinuousHint =>
      'Neue Spalten rollen von links herein, sobald Platz frei wird.';

  @override
  String get popModeMega => 'Mega';

  @override
  String get popModeMegaHint => 'Schieber und Endlos zusammen.';

  @override
  String get popGoal => 'Ziel';

  @override
  String get popGoalClear => 'Brett leeren';

  @override
  String get popGoalClearHint =>
      'Lass alle Blasen platzen. Es gibt immer einen Weg.';

  @override
  String get popGoalTarget => 'Zielpunktzahl';

  @override
  String get popGoalTargetHint =>
      'Erreiche das Ziel, bevor keine Züge mehr übrig sind.';

  @override
  String get popGoalFree => 'Freies Spiel';

  @override
  String get popGoalFreeHint =>
      'Kein Ziel: Spiel bis zum Ende und schlag deinen Rekord.';

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
      other:
          'Keine Züge mehr, $count Blasen sind übrig: rückgängig machen oder neu starten',
      one:
          'Keine Züge mehr, $count Blase ist übrig: rückgängig machen oder neu starten',
    );
    return '$_temp0';
  }

  @override
  String popStuckPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Keine Züge mehr, $count Punkte fehlen: rückgängig machen oder neu starten',
      one:
          'Keine Züge mehr, $count Punkt fehlt: rückgängig machen oder neu starten',
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
  String get mergeTagline =>
      'Schieb die Kacheln, verschmelze Paare, bau die große';

  @override
  String get mergeRules =>
      '• Wische (oder drück eine Pfeiltaste), um alle Kacheln so weit wie möglich in diese Richtung zu schieben.\n• Zwei Kacheln mit derselben Zahl, die aufeinandertreffen, verschmelzen zu einer mit ihrer Summe. Pro Zug verschmilzt eine Kachel nur einmal.\n• Nach jedem Zug erscheint auf einem leeren Feld eine neue 2 (manchmal eine 4).\n• Jede Verschmelzung bringt so viele Punkte, wie auf der neuen Kachel steht.\n\nZiele\n• Bau die Kachel: Erreiche die Zielkachel (sie hängt von Feldgröße und Schwierigkeit ab).\n• Freies Spiel: Spiel, bis das Feld blockiert ist, und schlag deinen Rekord.\n\nDas Spiel endet, wenn das Feld voll ist und keine Nachbarn zusammenpassen.';

  @override
  String get mergeGoalTarget => 'Bau die Kachel';

  @override
  String get mergeGoalTargetHint =>
      'Erreiche die Zielkachel, bevor das Feld blockiert ist.';

  @override
  String get mergeGoalFreeHint =>
      'Ohne Ziel: Spiel, bis das Feld blockiert ist, und schlag deinen Rekord.';

  @override
  String mergeReached(int tile) {
    return '$tile!';
  }

  @override
  String get mergeStuck =>
      'Keine Züge mehr: rückgängig machen oder neu starten';

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
      '• Drehe die Kacheln so, dass jedes Rohr mit der Quelle (der Kachel mit Ring) verbunden ist.\n• Kein Rohrende darf offen bleiben, und das Netz darf keine Schleifen enthalten.\n• Wasser fließt durch alles, was bereits mit der Quelle verbunden ist.\n• Kacheln mit Schloss sind schon an ihrem Platz.\n\nTippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen; langes Drücken / Rechtsklick dreht sie zurück.';

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
  String get lampsTagline =>
      'Beleuchte jedes Feld, Lampen scheinen nie aufeinander';

  @override
  String get lampsRules =>
      '• Setze Lampen auf weiße Felder. Eine Lampe beleuchtet ihr Feld sowie ihre Zeile und Spalte bis zur nächsten Wand.\n• Jedes weiße Feld muss beleuchtet sein.\n• Keine Lampe darf auf eine andere Lampe scheinen.\n• Eine Zahl auf einer Wand gibt an, wie viele Lampen direkt daneben stehen (oben, unten, links oder rechts).\n\nTippe auf ein Feld, um zu wechseln: leer → Punkt (deine Notiz „keine Lampe“) → Lampe. Langes Drücken / Rechtsklick wechselt zurück.';

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
  String get tutorialOfferBody =>
      'Erst eine kurze interaktive Lektion? Ein paar kleine Felder zeigen dir alle Regeln.';

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
  String get tutMambo1 =>
      'Fülle jedes Feld mit einer Sonne oder einem Mond. Nie drei gleiche nebeneinander: Auf zwei Sonnen nebeneinander folgt ein Mond. Tippe auf ein markiertes Feld, um zu wechseln: leer → Sonne → Mond.';

  @override
  String get tutMambo2 =>
      'Jede Zeile und Spalte hat gleich viele Sonnen und Monde. Die obere Zeile hat ihre zwei Sonnen schon, also sind ihre anderen Felder Monde. Die rechte Spalte funktioniert genauso.';

  @override
  String get tutMambo3 =>
      'Ein „=“ zwischen zwei Feldern heißt: Sie enthalten dasselbe Symbol. Gib den markierten Feldern das Symbol ihrer Nachbarn.';

  @override
  String get tutMambo4 =>
      'Ein „×“ heißt: Die beiden Felder sind verschieden, eine Sonne und ein Mond.';

  @override
  String get tutMambo5 =>
      'Jetzt ein ganzes Brett: Nutze alle Regeln zusammen. Tipp: Mit der Palette oben setzt du ein Symbol auf viele Felder, und langes Drücken (oder Rechtsklick) wechselt rückwärts.';

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
  String get tutHues1 =>
      'Färbe jedes leere Feld. Eine Zahl zählt die leeren Felder um sie herum (auch diagonal), die am Ende ihre Farbe haben. Die blaue 3 hat genau drei leere Nachbarn, also sind alle blau. Wähle eine Farbe in der Palette und tippe auf Felder.';

  @override
  String get tutHues2 =>
      'Die Zahlen zählen beim Färben herunter: Sie zeigen, wie viele passende Felder noch fehlen. Eine 0 heißt, dass kein leerer Nachbar ihre Farbe bekommt, und Zahlenfelder zählen nie mit. Fang mit der blauen 3 an und schau dann, was der rosa 2 noch fehlt.';

  @override
  String get tutHues3 =>
      'Jetzt ein echtes Brett. Fang mit Zahlen an, die alle leeren Nachbarn brauchen oder keinen.';

  @override
  String get tutMosaic1 =>
      'Der Fleck in der oberen linken Ecke gehört dir. Wähle unten eine Farbe: Dein Fleck nimmt sie an und schluckt alle angrenzenden Felder dieser Farbe. Färbe das ganze Brett in einer Farbe.';

  @override
  String get tutMosaic2 =>
      'Achte auf das Zuglimit: Wähle die Farbe, die deinen Fleck am meisten wachsen lässt. Ein Tipp auf ein Feld des Bretts wählt ebenfalls dessen Farbe.';

  @override
  String get tutMosaic3 =>
      'Jetzt ein echtes Brett, mit ein paar Zügen Reserve.';

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
  String get tutMerge1 =>
      'Wische (oder drück eine Pfeiltaste), um alle Kacheln so weit wie möglich zu schieben. Zwei gleiche Kacheln, die aufeinandertreffen, verschmelzen zu ihrer Summe. Mach eine 4.';

  @override
  String get tutMerge2 =>
      'Eine Kachel verschmilzt pro Zug nur einmal: Aus 4, 4, 8 wird 8, 8, nicht 16. Nach jedem Zug erscheint eine neue 2 (manchmal eine 4). Bau eine 16.';

  @override
  String get tutMerge3 =>
      'Halte deine größte Kachel in einer Ecke und füttere sie Schritt für Schritt. Bau eine 32.';

  @override
  String get tutPipes1 =>
      'Tippe auf eine Kachel, um sie im Uhrzeigersinn zu drehen (langes Drücken oder Rechtsklick dreht zurück). Verbinde jedes Rohr mit der Quelle, der Kachel mit Ring. Das Wasser zeigt, was schon verbunden ist.';

  @override
  String get tutPipes2 =>
      'Kein Rohrende darf offen bleiben, also darf kein Rohr über den Rand zeigen. Kacheln mit Schloss stimmen schon. Fang an den Rändern und Ecken an, wo Kacheln die wenigsten Möglichkeiten haben.';

  @override
  String get tutPipes3 =>
      'Jetzt ein echtes Brett. Das Netz darf keine Schleifen bilden.';

  @override
  String get tutShikaku1 =>
      'Teile das Gitter in Rechtecke. Jedes enthält genau eine Zahl, die seiner Fläche in Feldern entspricht. Ziehe von einer Ecke zur gegenüberliegenden, um ein Rechteck zu zeichnen.';

  @override
  String get tutShikaku2 =>
      'Eine 1 ist allein schon ein Rechteck: Tippe einfach darauf. Tippe auf ein gezeichnetes Rechteck, um es zu entfernen. Hier passt die 6 nur auf eine Art.';

  @override
  String get tutShikaku3 =>
      'Jetzt ein echtes Brett. Große Zahlen am Rand haben meist die wenigsten Möglichkeiten.';

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
  String get tutLabyrinth1 =>
      'Ziehe vom Start in der linken oberen Ecke zur Flagge in der rechten unteren Ecke. Wände versperren den Weg.';

  @override
  String get tutLabyrinth2 =>
      'Ein größeres Labyrinth. In einer Sackgasse? Ziehe auf deinem Weg zurück oder tippe auf eines seiner Felder, um dorthin zurückzukehren. Ein schneller Zug folgt geraden Gängen.';

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
  String get tutLits1 =>
      'Schattiere in jedem umrandeten Bereich genau 4 Felder, die ein L, I, T oder S bilden. Der obere Bereich hat genau 4 Felder, also schattiere alle. Tippe auf ein Feld, um es zu schattieren.';

  @override
  String get tutLits2 =>
      'Kein 2×2-Block darf ganz schattiert sein, und gleiche Formen dürfen sich über eine Grenze nicht berühren. Nur ein Feld vervollständigt den linken Bereich. Welches?';

  @override
  String get tutLits3 =>
      'Jetzt ein echtes Brett. Alle schattierten Felder müssen zusammenhängen. Tippe zweimal für einen Punkt, deine Notiz, dass ein Feld leer bleibt.';

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
  String get tutIslands1 =>
      'Schattiere das Meer so, dass die freien Felder Inseln bilden. Jede Zahl ist eine Insel aus genau so vielen Feldern. Hier ist die 1 eine Insel für sich: Tippe auf alle anderen Felder, um sie zu Meer zu machen.';

  @override
  String get tutIslands2 =>
      'Inseln berühren sich nie. Ein Feld zwischen zwei Zahlen muss Meer sein, sonst würde es sie zu einer Insel verbinden.';

  @override
  String get tutIslands3 =>
      'Das Meer muss zusammenhängen und darf nie ein 2×2-Becken bilden. Lass die 3 so wachsen, dass beides eingehalten wird. Tippe zweimal für einen Punkt, deine Notiz für Land.';

  @override
  String get tutIslands4 =>
      'Jetzt ein echtes Brett. Jede Insel enthält genau eine Zahl.';

  @override
  String get tutLamps1 =>
      'Setze Lampen auf weiße Felder: zweimal tippen (Punkt, dann Lampe). Eine Lampe beleuchtet ihre Zeile und Spalte bis zu den Wänden. Beleuchte jedes weiße Feld.';

  @override
  String get tutLamps2 =>
      'Eine Zahl auf einer Wand gibt an, wie viele Lampen sie berühren (oben, unten, links oder rechts). Diese 3 braucht auf jeder freien Seite eine Lampe.';

  @override
  String get tutLamps3 =>
      'Lampen dürfen nie aufeinander scheinen, und eine 0 heißt: keine Lampe direkt daneben. Wo steht die zweite Lampe?';

  @override
  String get tutLamps4 =>
      'Jetzt ein echtes Brett. Mit Punkten markierst du Felder, auf denen keine Lampe stehen kann.';

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
  String get tutFence4 =>
      'Jetzt ein echtes Brett. Fang mit den 0en und 3en an.';

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
  String get tutMines1 =>
      'Eine Zahl zählt die Minen in den 8 Feldern um sie herum. Jede 1 hier berührt nur ein geschlossenes Feld, also liegt dort eine Mine. Markiere sie: langes Drücken oder Rechtsklick, oder wechsle unten zu „Flagge“ und tippe darauf.';

  @override
  String get tutMines2 =>
      'Die Mine dieser 1 ist schon markiert, also sind alle anderen Felder ringsum sicher. Grab sie auf oder tippe auf die 1 selbst, um alle auf einmal aufzugraben.';

  @override
  String get tutMines3 =>
      'Ein Feld ohne Minen ringsum öffnet seine Nachbarn von selbst. Grab in der markierten Ecke.';

  @override
  String get tutMines4 =>
      'Jetzt ein echtes Brett. Raten ist nie nötig. Gräbst du aus Versehen eine Mine aus, bekommt sie einfach eine Flagge, und das Spiel geht weiter.';
}
