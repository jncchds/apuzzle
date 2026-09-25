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
  String get litsName => 'LITS';

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
}
