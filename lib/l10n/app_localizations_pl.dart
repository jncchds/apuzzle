// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get settings => 'Ustawienia';

  @override
  String get dailyTitle => 'Wyzwania dnia';

  @override
  String get dailyCalendar => 'Kalendarz';

  @override
  String dailyProgress(int done, int total) {
    return 'Rozwiązano $done z $total';
  }

  @override
  String get dailyDayComplete => 'Dzień ukończony!';

  @override
  String get dailyNext => 'Następna';

  @override
  String get dailyToday => 'Dziś';

  @override
  String get playCode => 'Zagraj według kodu łamigłówki';

  @override
  String get playCodeMenu => 'Zagraj według kodu…';

  @override
  String get inProgress => 'W toku';

  @override
  String get size => 'Rozmiar';

  @override
  String get difficulty => 'Poziom trudności';

  @override
  String get difficultyEasy => 'Łatwy';

  @override
  String get difficultyMedium => 'Średni';

  @override
  String get difficultyHard => 'Trudny';

  @override
  String get difficultyExpert => 'Ekspert';

  @override
  String notSolvedYet(Object difficulty) {
    return 'Jeszcze nierozwiązane na poziomie „$difficulty”';
  }

  @override
  String statsScore(Object count, Object score, Object time) {
    return 'Ukończono $count× · najlepszy wynik $score · najlepszy czas $time';
  }

  @override
  String statsTime(Object average, Object best, Object count) {
    return 'Rozwiązano $count× · najlepszy $best · średnio $average';
  }

  @override
  String get continueGame => 'Kontynuuj';

  @override
  String get newPuzzle => 'Nowa łamigłówka';

  @override
  String get highlightErrors => 'Podświetlaj błędy podczas gry';

  @override
  String get highlightErrorsHint => 'Wyłączone: błędy widać dopiero po naciśnięciu „Sprawdź”';

  @override
  String get autoClearMarks => 'Automatycznie usuwaj notatki';

  @override
  String get autoClearMarksHint => 'Wpisanie liczby usuwa tę notatkę z jej wiersza, kolumny i bloku';

  @override
  String get haptics => 'Wibracje';

  @override
  String get theme => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get language => 'Język';

  @override
  String get languageSystem => 'Język systemu';

  @override
  String get aboutLicenses => 'O aplikacji i licencje';

  @override
  String get releaseNotes => 'Informacje o wydaniach';

  @override
  String get aboutCredits => 'Napisano przy pomocy Claude Code i modelu Claude Opus 5.5';

  @override
  String get linksTitle => 'Otwieraj linki do łamigłówek w aplikacji';

  @override
  String get linksOn => 'Udostępnione linki do łamigłówek otwierają się w APuzzle';

  @override
  String linksOff(Object host) {
    return 'Wyłączone: dotknij i dodaj $host w „Otwieraj obsługiwane linki”';
  }

  @override
  String linksUnknown(Object host) {
    return 'Wybierz APuzzle dla linków $host';
  }

  @override
  String get couldNotOpenSettings => 'Nie udało się otworzyć ustawień systemu';

  @override
  String get transferTitle => 'Przenieś na inne urządzenie';

  @override
  String get transferHint =>
      'Wyeksportuj tutaj, zaimportuj na drugim urządzeniu. Import łączy dane: wygrane, najlepsze czasy i wyniki dzienne z obu urządzeń zostają, a z dwóch zapisanych gier zostaje nowsza.';

  @override
  String get transferExportFile => 'Eksportuj do pliku';

  @override
  String get transferImportFile => 'Importuj z pliku';

  @override
  String get transferCopy => 'Kopiuj jako tekst';

  @override
  String get transferPaste => 'Wklej tekst';

  @override
  String get transferCopied => 'Postęp skopiowany. Wklej go na drugim urządzeniu.';

  @override
  String get transferSaved => 'Postęp zapisany do pliku';

  @override
  String transferImported(int count) {
    return 'Postęp połączony. Zaktualizowane wpisy: $count';
  }

  @override
  String get transferNothingNew => 'Nic nowego: to urządzenie ma już wszystko';

  @override
  String get transferBadData => 'To nie jest postęp APuzzle albo dane są uszkodzone';

  @override
  String get transferSaveFailed => 'Nie udało się zapisać pliku';

  @override
  String get transferCopyFailed => 'Nie udało się skopiować do schowka';

  @override
  String get installApp => 'Zainstaluj aplikację';

  @override
  String get installAppHint => 'Dodaj APuzzle do ekranu głównego; otworzy się we własnym oknie';

  @override
  String get installAppIos => 'Dotknij przycisku Udostępnij w przeglądarce, a potem „Do ekranu początkowego”.';

  @override
  String get submitConflicts => 'Niektóre pola łamią zasady';

  @override
  String get submitIncomplete => 'Jeszcze nie skończone';

  @override
  String get submitWrong => 'Nie do końca';

  @override
  String get restartTitle => 'Zacząć od nowa?';

  @override
  String get restartBody => 'Wszystkie wpisy zostaną wyczyszczone. Nadal możesz to cofnąć.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get restart => 'Od nowa';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get rules => 'Zasady';

  @override
  String get copyShareLink => 'Kopiuj link';

  @override
  String get shareLinkCopied => 'Link skopiowany';

  @override
  String get couldNotGenerate => 'Nie udało się utworzyć łamigłówki';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get generating => 'Tworzenie łamigłówki…';

  @override
  String get tapToCycle => 'Przełączanie dotknięciem';

  @override
  String get palette => 'Paleta';

  @override
  String get undo => 'Cofnij';

  @override
  String get redo => 'Ponów';

  @override
  String get hint => 'Podpowiedź';

  @override
  String get submit => 'Sprawdź';

  @override
  String get erase => 'Wymaż';

  @override
  String get pencilMarks => 'Notatki ołówkiem';

  @override
  String get solved => 'Rozwiązane!';

  @override
  String scoreValue(Object score) {
    return 'Wynik $score';
  }

  @override
  String get newBest => 'nowy rekord!';

  @override
  String bestValue(Object value) {
    return 'rekord $value';
  }

  @override
  String hintsUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count podpowiedzi',
      many: '$count podpowiedzi',
      few: '$count podpowiedzi',
      one: '$count podpowiedź',
    );
    return '$_temp0';
  }

  @override
  String get home => 'Start';

  @override
  String get copyResult => 'Kopiuj wynik';

  @override
  String get resultCopied => 'Wynik skopiowany, wyślij go znajomym';

  @override
  String shareSolved(int hints, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: '„$name”: rozwiązane w $time z $hints podpowiedzi.',
      many: '„$name”: rozwiązane w $time z $hints podpowiedziami.',
      few: '„$name”: rozwiązane w $time z $hints podpowiedziami.',
      one: '„$name”: rozwiązane w $time z $hints podpowiedzią.',
      zero: '„$name”: rozwiązane w $time.',
    );
    return '$_temp0';
  }

  @override
  String shareScored(int hints, Object score, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: '„$name”: wynik $score w $time z $hints podpowiedzi.',
      many: '„$name”: wynik $score w $time z $hints podpowiedziami.',
      few: '„$name”: wynik $score w $time z $hints podpowiedziami.',
      one: '„$name”: wynik $score w $time z $hints podpowiedzią.',
      zero: '„$name”: wynik $score w $time.',
    );
    return '$_temp0';
  }

  @override
  String get shareChallenge => 'Dasz radę lepiej?';

  @override
  String get paste => 'Wklej';

  @override
  String get play => 'Graj';

  @override
  String couldNotOpenLink(Object error) {
    return 'Nie udało się otworzyć linku: $error';
  }

  @override
  String codeExpected(Object example) {
    return 'Oczekiwano kodu w rodzaju $example';
  }

  @override
  String codeUnknownPuzzle(Object id) {
    return 'Nieznana łamigłówka „$id”';
  }

  @override
  String codeNoSize(Object name, Object size) {
    return '„$name” nie ma rozmiaru $size';
  }

  @override
  String codeNoDifficulty(Object level, Object name) {
    return '„$name” nie ma poziomu „$level”';
  }

  @override
  String codeBadSeed(Object seed) {
    return 'Nieprawidłowe ziarno „$seed”';
  }

  @override
  String codeBadVersion(Object version) {
    return 'Nieprawidłowa wersja „$version”';
  }

  @override
  String get codeOtherVersion => 'Ten kod pochodzi z innej wersji aplikacji, więc łamigłówka by się nie zgadzała';

  @override
  String codeNoOption(Object choice, Object name) {
    return '„$name” nie ma opcji „$choice”';
  }

  @override
  String codeNoChoice(Object choice, Object name, Object option) {
    return '„$name”: opcja „$option” nie ma wariantu „$choice”';
  }

  @override
  String get valueSun => 'Słońce';

  @override
  String get valueMoon => 'Księżyc';

  @override
  String get valueDot => 'Kropka';

  @override
  String get valueCrown => 'Korona';

  @override
  String get valueShade => 'Zamaluj';

  @override
  String get valueGrass => 'Trawa';

  @override
  String get valueTent => 'Namiot';

  @override
  String get valueSea => 'Morze';

  @override
  String get valueLamp => 'Lampa';

  @override
  String get colorBlue => 'Niebieski';

  @override
  String get colorPink => 'Różowy';

  @override
  String get colorYellow => 'Żółty';

  @override
  String get colorGreen => 'Zielony';

  @override
  String get outOfMoves => 'Koniec ruchów: cofnij lub zacznij od nowa';

  @override
  String movesOfLimit(Object moves, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit ruchu',
      many: '$limit ruchów',
      few: '$limit ruchy',
      one: '$limit ruch',
    );
    return '$moves / $_temp0';
  }

  @override
  String get bondsCantCross => 'Wiązania nie mogą się krzyżować';

  @override
  String get mamboName => 'Słońce i Księżyc';

  @override
  String get mamboTagline => 'Zrównoważ słońca i księżyce';

  @override
  String get mamboRules =>
      '• Wypełnij każde pole słońcem lub księżycem.\n• Najwyżej 2 takie same symbole obok siebie w wierszu lub kolumnie.\n• W każdym wierszu i kolumnie jest tyle samo słońc co księżyców.\n• „=” między dwoma polami: mają ten sam symbol.\n• „×” między dwoma polami: mają różne symbole.\n• Zablokowane pola są podane.\n\nDotknij pola, aby przełączać: puste → słońce → księżyc. Długie naciśnięcie / prawy przycisk przełącza wstecz.';

  @override
  String get sudokuName => 'Sudoku';

  @override
  String get sudokuTagline => 'Każda liczba raz w wierszu, kolumnie i bloku';

  @override
  String get sudokuRules =>
      '• Wypełnij każde pole liczbą od 1 do N (N = rozmiar siatki).\n• Każda liczba występuje dokładnie raz w każdym wierszu, każdej kolumnie i każdym bloku.\n• Podanych liczb nie można zmieniać.\n\nWybierz liczbę z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem liczby. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole.';

  @override
  String get kingsName => 'Korony';

  @override
  String get kingsTagline => 'Jedna korona w wierszu, kolumnie i obszarze';

  @override
  String get kingsRules =>
      '• Umieść dokładnie jedną koronę w każdym wierszu, każdej kolumnie i każdym kolorowym obszarze.\n• Korony nie mogą się stykać, nawet po przekątnej.\n\nDotknij pola, aby przełączać: puste → kropka (twoja notatka „tu nie ma korony”) → korona. Długie naciśnięcie / prawy przycisk przełącza wstecz.';

  @override
  String get huesName => 'Odcienie';

  @override
  String get huesTagline => 'Policz pasujące kolory wokół każdej liczby';

  @override
  String get huesRules =>
      '• Pokoloruj każde puste pole kolorami z palety.\n• Każde pole z liczbą pokazuje, ile pustych pól wokół niego (wszystkich 8 sąsiadów, także po przekątnej) będzie miało ten sam kolor co ono.\n• Liczba maleje, gdy malujesz pasujących sąsiadów, więc pokazuje, ilu jeszcze brakuje.\n• Same pola z liczbami się nie liczą.\n\nWybierz kolor z palety i dotykaj pól, aby je malować (ponowne dotknięcie czyści), albo dotykaj pola, aby przełączać kolory.';

  @override
  String get mosaicName => 'Mozaika';

  @override
  String get mosaicTagline => 'Zalej planszę jednym kolorem';

  @override
  String get mosaicRules =>
      '• Kolorowy obszar w lewym górnym rogu jest twój.\n• Wybierz kolor: twój obszar przyjmuje ten kolor i wchłania wszystkie stykające się pola tego koloru.\n• Pomaluj całą planszę jednym kolorem w limicie ruchów.\n\nDotknij koloru w palecie albo dowolnego pola, aby użyć jego koloru.';

  @override
  String get blendName => 'Fuzja';

  @override
  String get blendTagline => 'Przemalowuj plamy, aż zostanie jeden kolor';

  @override
  String get blendRules =>
      '• Plansza składa się z kolorowych plam (stykających się pól jednego koloru).\n• Wybierz kolor, a potem dotknij dowolnej plamy, aby ją przemalować. Łączy się ona ze wszystkimi stykającymi się plamami tego koloru.\n• Pomaluj całą planszę na jeden kolor w limicie ruchów.\n\nKolor w palecie pozostaje wybrany, więc możesz przemalować kilka plam z rzędu.';

  @override
  String get popName => 'Bąbelki';

  @override
  String get popTagline => 'Zbijaj duże grupy bąbelków za dużo punktów';

  @override
  String get popRules =>
      '• Dotknij grupy 2 lub więcej stykających się bąbelków jednego koloru, aby ją zaznaczyć; dotknij jeszcze raz, aby ją zbić.\n• Grupa n bąbelków daje n × (n − 1) punktów, więc opłaca się zbierać duże grupy.\n• Bąbelki powyżej spadają w dół, a puste kolumny przesuwają się w prawo.\n\nTryby\n• Standardowy: tylko tyle.\n• Przesuwanie: każdy wiersz też przesuwa się w prawo, zamykając luki.\n• Ciągły: gdy zwalnia się miejsce, z lewej wjeżdżają nowe kolumny.\n• Mega: Przesuwanie i Ciągły razem.\n\nCele\n• Wyczyść planszę: zbij wszystkie bąbelki (tylko tryb Standardowy; zawsze jest sposób).\n• Wynik docelowy: osiągnij wynik, zanim skończą się ruchy.\n• Gra swobodna: bez celu, po prostu pobij swój rekord.\n\nGra kończy się, gdy nie zostaje żadna grupa 2 bąbelków.';

  @override
  String get popMode => 'Tryb';

  @override
  String get popModeStandard => 'Standardowy';

  @override
  String get popModeStandardHint => 'Bąbelki spadają w dół; puste kolumny przesuwają się w prawo.';

  @override
  String get popModeShifter => 'Przesuwanie';

  @override
  String get popModeShifterHint => 'Wiersze też przesuwają się w prawo, zamykając każdą lukę.';

  @override
  String get popModeContinuous => 'Ciągły';

  @override
  String get popModeContinuousHint => 'Gdy zwalnia się miejsce, z lewej wjeżdżają nowe kolumny.';

  @override
  String get popModeMega => 'Mega';

  @override
  String get popModeMegaHint => 'Przesuwanie i Ciągły razem.';

  @override
  String get popGoal => 'Cel';

  @override
  String get popGoalClear => 'Wyczyść planszę';

  @override
  String get popGoalClearHint => 'Zbij wszystkie bąbelki. Zawsze jest sposób.';

  @override
  String get popGoalTarget => 'Wynik docelowy';

  @override
  String get popGoalTargetHint => 'Osiągnij cel, zanim skończą się ruchy.';

  @override
  String get popGoalFree => 'Gra swobodna';

  @override
  String get popGoalFreeHint => 'Bez celu: graj do końca i pobij swój rekord.';

  @override
  String get popCleared => 'Wyczyszczone!';

  @override
  String get popTargetReached => 'Cel osiągnięty!';

  @override
  String get popGameOver => 'Koniec gry';

  @override
  String popStuckBubbles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Brak ruchów, na planszy zostało $count bąbelka: cofnij lub zacznij od nowa',
      many: 'Brak ruchów, na planszy zostało $count bąbelków: cofnij lub zacznij od nowa',
      few: 'Brak ruchów, na planszy zostały $count bąbelki: cofnij lub zacznij od nowa',
      one: 'Brak ruchów, na planszy został $count bąbelek: cofnij lub zacznij od nowa',
    );
    return '$_temp0';
  }

  @override
  String popStuckPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Brak ruchów, brakuje $count punktu: cofnij lub zacznij od nowa',
      many: 'Brak ruchów, brakuje $count punktów: cofnij lub zacznij od nowa',
      few: 'Brak ruchów, brakuje $count punktów: cofnij lub zacznij od nowa',
      one: 'Brak ruchów, brakuje $count punktu: cofnij lub zacznij od nowa',
    );
    return '$_temp0';
  }

  @override
  String popPoints(Object score) {
    return '$score pkt';
  }

  @override
  String popLeft(Object count) {
    return 'zostało $count';
  }

  @override
  String popColumns(Object count) {
    return '+$count kol.';
  }

  @override
  String get mergeName => '2048';

  @override
  String get mergeTagline => 'Przesuwaj kafelki, łącz pary, zbuduj największy';

  @override
  String get mergeRules =>
      '• Przesuń palcem (lub naciśnij strzałkę), aby wszystkie kafelki przesunęły się w tę stronę do oporu.\n• Dwa kafelki z tą samą liczbą, które na siebie wpadną, łączą się w jeden z ich sumą. W jednym ruchu kafelek łączy się tylko raz.\n• Po każdym ruchu na pustym polu pojawia się nowa 2 (czasem 4).\n• Każde połączenie daje tyle punktów, ile wynosi nowy kafelek.\n\nCele\n• Zbuduj kafelek: osiągnij docelowy kafelek (zależy od rozmiaru planszy i poziomu trudności).\n• Gra swobodna: graj, aż plansza się zablokuje, i pobij swój rekord.\n\nGra kończy się, gdy plansza jest pełna i żadni sąsiedzi do siebie nie pasują.';

  @override
  String get mergeGoalTarget => 'Zbuduj kafelek';

  @override
  String get mergeGoalTargetHint => 'Osiągnij docelowy kafelek, zanim plansza się zablokuje.';

  @override
  String get mergeGoalFreeHint => 'Bez celu: graj, aż plansza się zablokuje, i pobij swój rekord.';

  @override
  String mergeReached(int tile) {
    return '$tile!';
  }

  @override
  String get mergeStuck => 'Brak ruchów: cofnij lub zacznij od nowa';

  @override
  String mergeBest(int tile) {
    return 'Maks. $tile';
  }

  @override
  String get pipesName => 'Rury';

  @override
  String get pipesTagline => 'Połącz każdą rurę ze źródłem';

  @override
  String get pipesRules =>
      '• Obracaj kafelki tak, aby każda rura łączyła się ze źródłem (kafelek z pierścieniem).\n• Żaden koniec rury nie może zostać otwarty, a sieć nie może mieć pętli.\n• Woda płynie przez wszystko, co jest już połączone ze źródłem.\n• Kafelki z kropką w rogu są zablokowane i już na miejscu.\n\nDotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara; długie naciśnięcie / prawy przycisk obraca go z powrotem.';

  @override
  String get shikakuName => 'Shikaku';

  @override
  String get shikakuTagline => 'Podziel siatkę na prostokąty z liczbami';

  @override
  String get shikakuRules =>
      '• Podziel całą siatkę na prostokąty (kwadraty też się liczą).\n• Każdy prostokąt zawiera dokładnie jedną liczbę.\n• Ta liczba jest równa polu prostokąta w kratkach.\n\nPrzeciągnij od jednego rogu do przeciwległego, aby narysować prostokąt. Dotknij prostokąta, aby go usunąć.';

  @override
  String get trailName => 'Ścieżka';

  @override
  String get trailTagline => 'Jedna droga przez każde pole, liczby po kolei';

  @override
  String get trailRules =>
      '• Narysuj jedną ścieżkę, która zaczyna się od 1 i przechodzi przez każde pole dokładnie raz.\n• Ścieżka biegnie w górę, w dół, w lewo lub w prawo (bez przekątnych).\n• Musi mijać liczby po kolei (1 → 2 → 3 → …) i kończyć się na ostatniej liczbie.\n\nPrzeciągaj, aby rysować. Przeciągnij z powrotem po ścieżce, aby cofnąć kroki, albo dotknij pola ścieżki, aby ją tam uciąć.';

  @override
  String get atomsName => 'Atomy';

  @override
  String get atomsTagline => 'Połącz atomy zgodnie z ich liczbami';

  @override
  String get atomsRules =>
      '• Połącz atomy poziomymi lub pionowymi wiązaniami.\n• Każdy atom potrzebuje dokładnie tylu wiązań, ile wskazuje jego liczba.\n• Dwa atomy mogą mieć jedno lub dwa wspólne wiązania.\n• Wiązania nie mogą się krzyżować ani przechodzić przez atomy.\n• Wszystkie atomy muszą tworzyć jedną cząsteczkę.\n\nPrzeciągnij od atomu w stronę sąsiada, aby dodać wiązanie (1 → 2 → brak). Możesz też dotknąć przestrzeni między dwoma atomami.';

  @override
  String get litsName => 'Tetra';

  @override
  String get litsTagline => 'Jedno tetromino w każdym obszarze';

  @override
  String get litsRules =>
      '• Zamaluj dokładnie 4 połączone pola w każdym obrysowanym obszarze, tworząc kształt L, I, T lub S (obroty i odbicia dozwolone).\n• Wszystkie zamalowane pola razem tworzą jeden spójny obszar.\n• Żaden blok 2×2 nie może być w całości zamalowany.\n• Dwa identyczne kształty nie mogą się stykać przez granicę obszaru.\n\nDotknij pola, aby przełączać: puste → zamalowane → kropka (twoja notatka „niezamalowane”).';

  @override
  String get labyrinthName => 'Labirynt';

  @override
  String get labyrinthTagline => 'Znajdź drogę z rogu do rogu';

  @override
  String get labyrinthRules =>
      '• Znajdź drogę przez labirynt od wejścia w lewym górnym rogu do wyjścia w prawym dolnym.\n• Nie można przechodzić przez ściany.\n\nPrzeciągaj od końca ścieżki, aby iść dalej. Przeciągnij z powrotem, aby się cofnąć, albo dotknij pola ścieżki, aby do niego wrócić.';

  @override
  String get campName => 'Kemping';

  @override
  String get campTagline => 'Rozbij namiot przy każdym drzewie';

  @override
  String get campRules =>
      '• Rozbij po jednym namiocie dla każdego drzewa, tuż obok niego (nad, pod, z lewej lub z prawej).\n• Każde drzewo ma swój namiot, a każdy namiot należy do jednego sąsiedniego drzewa.\n• Namioty nie stykają się ze sobą, nawet po przekątnej.\n• Liczby poza siatką mówią, ile namiotów jest w każdym wierszu i kolumnie.\n\nDotknij pola, aby przełączać: puste → trawa (twoja notatka „tu nie ma namiotu”) → namiot. Długie naciśnięcie / prawy przycisk przełącza wstecz.';

  @override
  String get islandsName => 'Wyspy';

  @override
  String get islandsTagline => 'Zalej morze wokół wysp z liczbami';

  @override
  String get islandsRules =>
      '• Zamaluj morze tak, aby niezamalowane pola tworzyły wyspy.\n• Każda wyspa zawiera dokładnie jedną liczbę, równą jej wielkości w polach.\n• Wyspy stykają się tylko z morzem, nigdy ze sobą (rogami po przekątnej mogą).\n• Całe morze jest połączone i nie ma w nim bloków 2×2.\n\nDotknij pola, aby przełączać: puste → morze → kropka (twoja notatka „ląd”). Długie naciśnięcie / prawy przycisk przełącza wstecz.';

  @override
  String get minesName => 'Miny';

  @override
  String get minesTagline => 'Znajdź wszystkie miny samą logiką';

  @override
  String get minesRules =>
      '• Odkryj wszystkie pola bez min.\n• Liczba mówi, ile min jest w 8 polach wokół niej.\n• Nigdy nie trzeba zgadywać: każdą planszę da się oczyścić logiką.\n• Odkrycie pola bez min wokół odkrywa też jego sąsiadów.\n\nDotknij pola, aby kopać, długie naciśnięcie / prawy przycisk stawia flagę (albo włącz „Flaga” poniżej). Dotknij liczby, przy której stoją już wszystkie flagi, aby odkopać resztę wokół niej. Kopnięta mina wybucha i dostaje flagę, a gra toczy się dalej.';

  @override
  String get minesDig => 'Kop';

  @override
  String get minesFlag => 'Flaga';

  @override
  String get minesBoom => 'Bum! To była mina, teraz ma flagę';

  @override
  String get lampsName => 'Lampy';

  @override
  String get lampsTagline => 'Oświetl każde pole, lampy nie świecą na siebie';

  @override
  String get lampsRules =>
      '• Stawiaj lampy na pustych polach (nie na ścianach). Lampa oświetla swoje pole oraz wiersz i kolumnę aż do ściany.\n• Każde puste pole musi być oświetlone.\n• Żadna lampa nie może świecić na inną lampę.\n• Liczba na ścianie mówi, ile lamp stoi tuż obok niej (nad, pod, z lewej lub z prawej).\n\nDotknij pola, aby przełączać: puste → kropka (twoja notatka „bez lampy”) → lampa. Długie naciśnięcie / prawy przycisk przełącza wstecz.';

  @override
  String get fenceName => 'Płot';

  @override
  String get fenceTagline => 'Jedna pętla wokół liczb';

  @override
  String get fenceRules =>
      '• Narysuj jedną zamkniętą pętlę po kropkowanych liniach.\n• Pętla nigdzie się nie krzyżuje ani nie styka sama ze sobą.\n• Liczba mówi, ile z czterech boków jej pola zajmuje pętla. Pola bez liczby mogą mieć dowolną liczbę.\n\nDotknij między dwiema kropkami, aby narysować linię, ponownie, aby oznaczyć ją krzyżykiem, i jeszcze raz, aby ją wyczyścić. Przeciągaj od kropki do kropki, aby rysować kilka linii albo je ścierać, jeśli zaczniesz na linii.';

  @override
  String get pearlsName => 'Perły';

  @override
  String get pearlsTagline => 'Przewlecz jedną pętlę przez wszystkie perły';

  @override
  String get pearlsRules =>
      '• Narysuj jedną zamkniętą pętlę przez środki pól. Nie krzyżuje się ani nie styka sama ze sobą i nie musi przechodzić przez każde pole.\n• Pętla przechodzi przez każdą perłę.\n• Na czarnej perle pętla skręca, a w polach przed nią i za nią biegnie prosto.\n• Przez białą perłę pętla biegnie prosto, a w polu przed nią lub za nią (albo w obu) skręca.\n\nPrzeciągaj po polach, aby rysować pętlę, albo wzdłuż niej, aby ją ścierać. Dotknij między dwoma polami, aby przełączać: linia → krzyżyk → puste.';

  @override
  String get railsName => 'Tory';

  @override
  String get railsTagline => 'Ułóż jeden tor od wjazdu do wyjazdu';

  @override
  String get railsRules =>
      '• Ułóż jeden tor przez środki pól, od wjazdu na lewej krawędzi do wyjazdu na dolnej.\n• Tor się nie rozgałęzia, nie krzyżuje ani nie zamyka w pętlę i nie musi przechodzić przez każde pole.\n• Liczby nad planszą i po jej prawej stronie mówią, przez ile pól każdej kolumny i wiersza biegnie tor.\n• Odcinki, które już są na planszy, są stałe: tor biegnie przez nie dokładnie tak, jak pokazano.\n\nPrzeciągaj po polach, aby układać tor, albo wzdłuż niego, aby go ścierać. Dotknij środka pola, aby przełączać: puste → notatka toru → kropka (twoja notatka „tu nie ma toru”), albo dotknij między dwoma polami, aby przełączać: tor → krzyżyk → puste.';

  @override
  String get blocksName => 'Bloki';

  @override
  String get blocksTagline => 'Liczby od 1 do k w każdym obszarze z k pól';

  @override
  String get blocksRules =>
      '• Wypełnij każde pole liczbą.\n• Obszar z k pól zawiera każdą liczbę od 1 do k dokładnie raz (obszar z jednego pola zawiera 1).\n• Równe liczby nigdy się nie stykają, nawet po przekątnej.\n• Podanych liczb nie można zmieniać.\n\nWybierz liczbę z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem liczby. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole.';

  @override
  String get pairsName => 'Pary';

  @override
  String get pairsTagline => 'Dwa zamalowane pola obok siebie w każdym obszarze';

  @override
  String get pairsRules =>
      '• Zamaluj dokładnie dwa pola w każdym obrysowanym obszarze.\n• Każde zamalowane pole styka się bokiem z dokładnie jednym innym zamalowanym polem, więc zamalowane pola tworzą pary.\n• Pary nigdy nie stykają się ze sobą bokami (rogami mogą).\n\nDotknij pola, aby przełączać: puste → zamalowane → kropka (twoja notatka „niezamalowane”). Długie naciśnięcie / prawy przycisk przełącza wstecz.';

  @override
  String get plotsName => 'Działki';

  @override
  String get plotsTagline => 'Podziel planszę na działki tak duże jak ich liczby';

  @override
  String get plotsRules =>
      '• Wypełnij każde pole liczbą.\n• Równe liczby stykające się bokami tworzą działkę, a działka ma dokładnie tyle pól, ile mówi jej liczba: 3 leży w działce z trzech pól.\n• Dwie działki tej samej wielkości nigdy nie stykają się bokami (byłyby jedną działką).\n• Niektóre działki nie mają żadnej podanej liczby.\n\nWybierz liczbę z palety i dotykaj pól, aby je wypełnić, albo najpierw dotknij pola, a potem liczby. Między różnymi liczbami pojawiają się linie, więc widać, jak powstają działki.';

  @override
  String get linksName => 'Połączenia';

  @override
  String get linksTagline => 'Połącz pary i wypełnij planszę';

  @override
  String get linksRules =>
      '• Połącz każdą parę jednakowych kółek ścieżką przez sąsiednie pola (nie po przekątnej).\n• Ścieżki się nie krzyżują, nie rozgałęziają i nie dzielą pól.\n• Razem ścieżki wypełniają każde pole planszy.\n\nPrzeciągnij od kółka, aby narysować jego ścieżkę; ścieżka poprowadzona przez inną przecina ją. Dotknij kółka, aby wyczyścić jego ścieżkę, albo pola ścieżki, aby ją tam przyciąć.';

  @override
  String get arrowsName => 'Strzałki';

  @override
  String get arrowsTagline => 'Zamaluj, co liczą strzałki, a resztę obejdź pętlą';

  @override
  String get arrowsRules =>
      '• Zamaluj niektóre pola. Zamalowane pola nigdy nie stykają się bokami.\n• Narysuj jedną zamkniętą pętlę przez środki wszystkich pozostałych pól. Nie rozgałęzia się ani nie krzyżuje.\n• Pola ze wskazówkami (liczba i strzałka) nie są zamalowane ani na pętli. Liczba wskazówki liczy zamalowane pola w kierunku jej strzałki, aż do krawędzi.\n\nPrzeciągaj po polach, aby rysować pętlę, albo wzdłuż niej, aby ją ścierać. Dotknij środka pola, aby przełączać: puste → zamalowane → kropka (twoja notatka „na pętli”), albo dotknij między dwoma polami, aby przełączać: linia → krzyżyk → puste.';

  @override
  String get learnTitle => 'Jak grać';

  @override
  String get learnIntro =>
      'Krótkie interaktywne lekcje: każdy krok to mała plansza, która pokazuje jedną zasadę lub sztuczkę.';

  @override
  String learnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kroku',
      many: '$count kroków',
      few: '$count kroki',
      one: '$count krok',
    );
    return '$_temp0';
  }

  @override
  String get learnDone => 'Opanowane';

  @override
  String tutorialOfferTitle(String name) {
    return 'Pierwszy raz grasz w „$name”?';
  }

  @override
  String get tutorialOfferBody => 'Najpierw krótka interaktywna lekcja? Kilka małych plansz pokaże wszystkie zasady.';

  @override
  String get tutorialOfferNo => 'Nie, dziękuję';

  @override
  String get tutorialOfferYes => 'Pokaż';

  @override
  String tutorialTitle(String name) {
    return 'Jak grać: $name';
  }

  @override
  String tutorialStep(int step, int total) {
    return 'Krok $step z $total';
  }

  @override
  String get tutorialNice => 'Świetnie!';

  @override
  String get tutorialNext => 'Dalej';

  @override
  String get tutorialFinish => 'Gotowe';

  @override
  String get tutorialShowMe => 'Pokaż';

  @override
  String get tutorialPrevious => 'Poprzedni krok';

  @override
  String get tutorialReset => 'Zacznij krok od nowa';

  @override
  String get tutorialFinishedTitle => 'Już umiesz!';

  @override
  String tutorialFinishedBody(String name) {
    return 'To wszystko, czego potrzebujesz, żeby grać w „$name”.';
  }

  @override
  String get tutorialPlay => 'Graj';

  @override
  String get tutorialAgain => 'Od początku';

  @override
  String get tutorialClose => 'Zamknij';

  @override
  String get tutorialStrategies => 'Poznaj strategie';

  @override
  String strategiesTitle(String name) {
    return '$name: strategie';
  }

  @override
  String strategiesFinishedBody(String name) {
    return 'Znasz już główne techniki rozwiązywania gry $name.';
  }

  @override
  String get learnBasicsTab => 'Podstawy';

  @override
  String get learnStrategiesTab => 'Strategie';

  @override
  String get learnStrategiesIntro =>
      'Dla znających zasady: każda lekcja pokazuje technikę doświadczonych graczy na planszy, która jej wymaga.';

  @override
  String get tutMambo1 =>
      'Wypełnij każde pole słońcem lub księżycem. Nigdy trzy takie same obok siebie: po dwóch słońcach obok siebie przychodzi księżyc. Dotknij zaznaczonego pola, aby przełączać: puste → słońce → księżyc.';

  @override
  String get tutMambo2 =>
      'W każdym wierszu i kolumnie jest tyle samo słońc co księżyców. Górny wiersz ma już oba słońca, więc reszta jego pól to księżyce. Prawa kolumna działa tak samo.';

  @override
  String get tutMambo3 =>
      '„=” między dwoma polami oznacza, że mają ten sam symbol. Wstaw w zaznaczone pola to samo, co mają sąsiedzi.';

  @override
  String get tutMambo4 => '„×” oznacza, że pola są różne: jedno słońce, jeden księżyc.';

  @override
  String get tutMambo5 =>
      'Teraz cała plansza: użyj wszystkich zasad naraz. Wskazówka: przycisk palety u góry pozwala stawiać jeden symbol na wielu polach, a długie naciśnięcie (lub prawy przycisk) przełącza wstecz.';

  @override
  String get tutMamboS1 =>
      'Gdy żadna zasada nie działa wprost, zapytaj „a co, jeśli?”. Zaznaczona para jest połączona znakiem =, więc oba pola mają ten sam symbol. Dwa słońca dałyby górnemu wierszowi trzy słońca na cztery pola, więc oba to księżyce.';

  @override
  String get tutMamboS2 =>
      'Trudniejsza plansza, na której ta sztuczka przyda się często: spróbuj symbolu w polu i pójdź kilka kroków za zasadami. Jeśli coś się psuje, właściwy jest drugi symbol. Para z × zawsze ma po jednym, więc w swoim wierszu liczy się jako jedno słońce i jeden księżyc.';

  @override
  String get tutSudoku1 =>
      'W każdym wierszu, kolumnie i bloku (grube ramki) każda liczba od 1 do 4 występuje raz. W tym wierszu brakuje jednej liczby: wybierz ją w palecie i dotknij pustego pola.';

  @override
  String get tutSudoku2 =>
      'Według wiersza te dwa pola mogą mieć 3 lub 4. Rozstrzygają kolumny: w każdej brakuje tylko jednej liczby.';

  @override
  String get tutSudoku3 => 'Bloki też się liczą: w każdym bloku 1–4 występują raz. Dokończ ostatni blok.';

  @override
  String get tutSudoku4 =>
      'Nie masz pewności? Rób notatki. Włącz ołówek obok palety, wybierz zaznaczone pole i zanotuj wszystkie liczby, które mogą się tam jeszcze znaleźć.';

  @override
  String get tutSudoku5 =>
      'Teraz cała łamigłówka. Wybrane pole podświetla swój wiersz, kolumnę i blok oraz tę samą liczbę gdzie indziej. W ustawieniach możesz włączyć automatyczne usuwanie notatek.';

  @override
  String get tutSudokuS1 =>
      'Patrz na jedną liczbę zamiast na jedno pole. Zaznaczony blok potrzebuje 1: jedynki w jego kolumnach i w drugim wierszu wykluczają wszystkie pola oprócz jednego. Potem dokończ planszę w ten sam sposób.';

  @override
  String get tutSudokuS2 =>
      'Dwie nowe sztuczki. Pary: dwa pola linii lub bloku, w których pasują tylko te same dwie liczby, zabierają je dla siebie. Wskazywanie: jeśli miejsca na liczbę w bloku leżą na jednej linii, reszta tej linii jej nie ma.';

  @override
  String get tutKings1 =>
      'Umieść dokładnie jedną koronę w każdym wierszu, każdej kolumnie i każdym kolorowym obszarze. Trzy już stoją, a na ostatnią zostało jedno miejsce. Dotknij go dwa razy: najpierw kropka, potem korona.';

  @override
  String get tutKings2 =>
      'Korony nigdy się nie stykają, nawet rogami. Dotknij raz, aby postawić kropkę (notatkę „tu nie ma korony”) na każdym polu wokół tej korony.';

  @override
  String get tutKings3 =>
      'Wiersze koron i zasada stykania zostawiają w zaznaczonym obszarze tylko jedno pole bez kropki. Postaw tam koronę.';

  @override
  String get tutKings4 =>
      'Teraz cała plansza. Stawiaj kropki tam, gdzie korony być nie może, i szukaj wierszy, kolumn lub obszarów z jednym wolnym polem.';

  @override
  String get tutKingsS1 =>
      'Szukaj regionu, który mieści się w jednym wierszu lub kolumnie. Zaznaczony region leży cały w dolnym wierszu, więc korona tego wiersza jest w nim: postaw kropki na pozostałych polach dolnego wiersza i działaj dalej.';

  @override
  String get tutKingsS2 =>
      'Kolejna sztuczka: jeśli korona w polu wykluczyłaby wszystkie pola innego regionu (swoim wierszem, kolumną lub stykaniem), to pole nie może mieć korony. Postaw kropkę. Tak samo działa z dwoma regionami wciśniętymi w dwa wiersze.';

  @override
  String get tutHues1 =>
      'Pomaluj każde puste pole. Liczba mówi, ile pustych pól wokół niej (także po przekątnej) będzie miało jej kolor. Niebieska 3 ma dokładnie trzech pustych sąsiadów, więc wszyscy są niebiescy. Wybierz kolor w palecie i dotykaj pól.';

  @override
  String get tutHues2 =>
      'Liczby maleją, gdy malujesz: pokazują, ilu pasujących pól jeszcze brakuje. 0 oznacza, że żaden pusty sąsiad nie ma jej koloru, a pola z liczbami się nie liczą. Zacznij od niebieskiej 3, potem zobacz, czego jeszcze brakuje różowej 2.';

  @override
  String get tutHues3 =>
      'Teraz prawdziwa plansza. Zacznij od liczb, które potrzebują wszystkich pustych sąsiadów albo żadnego.';

  @override
  String get tutHuesS1 =>
      'Wykluczaj kolory. Każde zaznaczone pole styka się z niebieskim 0, więc nie może być niebieskie, i z różowym 0, więc nie może być różowe. Zostaje tylko żółty.';

  @override
  String get tutHuesS2 =>
      'Trudniejsza plansza. Porównuj liczby, które mają wspólnych pustych sąsiadów: to, czego brakuje jednej, mogła już wyczerpać druga. Gdy utkniesz, spróbuj koloru w polu i sprawdź, czy jakaś liczba się nie psuje.';

  @override
  String get tutMosaic1 =>
      'Plama w lewym górnym rogu jest twoja. Wybierz kolor na dole: plama go przyjmie i wchłonie wszystkie stykające się pola tego koloru. Pomaluj całą planszę na jeden kolor.';

  @override
  String get tutMosaic2 =>
      'Uważaj na limit ruchów: wybieraj kolor, który najbardziej powiększy plamę. Dotknięcie pola na planszy też wybiera jego kolor.';

  @override
  String get tutMosaic3 => 'Teraz prawdziwa plansza, z kilkoma zapasowymi ruchami.';

  @override
  String get tutMosaicS1 =>
      'Planuj z wyprzedzeniem. Wcześnie dotrzyj do środka planszy, bo wtedy twoja plama styka się z większą liczbą kolorów, a gdy możesz, wybieraj kolor, który całkiem znika z planszy.';

  @override
  String get tutBlend1 =>
      'Plansza składa się z plam: stykających się pól jednego koloru. Wybierz kolor na dole i dotknij plamy, aby ją przemalować. Połączy się ze stykającymi plamami tego koloru. Przemaluj środkową plamę.';

  @override
  String get tutBlend2 =>
      'Jeden ruch może połączyć wiele plam. Środkowa plama styka się z czterema innymi: przemaluj ją, aby je połączyć, a potem dokończ. Masz tylko 2 ruchy.';

  @override
  String get tutBlend3 => 'Teraz prawdziwa plansza. Wybrany kolor zostaje, więc możesz malować kilka plam z rzędu.';

  @override
  String get tutBlendS1 =>
      'Wybierz jedną plamę na środku i przemalowuj właśnie ją: każdy ruch pochłania wtedy wszystkie stykające się plamy nowego koloru. Wybieraj kolor, który ma większość jej sąsiadów.';

  @override
  String get tutPop1 =>
      'Dotknij grupy dwóch lub więcej stykających się bąbelków jednego koloru, aby ją zaznaczyć, i jeszcze raz, aby ją zbić. Wyczyść planszę.';

  @override
  String get tutPop2 =>
      'Bąbelki z góry spadają w luki, więc tworzą się nowe grupy. Kolejność ma znaczenie: najpierw zbij zaznaczoną grupę.';

  @override
  String get tutPop3 =>
      'Gdy kolumna się opróżni, kolumny na lewo od niej przesuwają się w prawo. Zbij środek, aby połączyć boki.';

  @override
  String get tutPop4 =>
      'Grupa n bąbelków daje n × (n − 1) punktów: 2 bąbelki to 2 punkty, 5 to 20. Zbierz dużą grupę, aby zdobyć 20 punktów.';

  @override
  String get tutPop5 =>
      'Inne tryby: w Przesuwaniu każdy wiersz też przesuwa się w prawo, w Ciągłym z lewej wjeżdżają nowe kolumny, a Mega łączy oba. Cele: wyczyść planszę, osiągnij wynik docelowy albo graj swobodnie o rekord. Gra kończy się, gdy nie zostaje żadna grupa 2.';

  @override
  String get tutPopS1 =>
      'Czyszczenie planszy wymaga planu. Zanim pękniesz grupę, pomyśl, co spadnie w lukę: pękaj grupy, które łączą bąbelki jednego koloru, i nigdy nie zostawiaj samotnego bąbelka jakiegoś koloru.';

  @override
  String get tutPopS2 =>
      'Pogoń za punktami: grupa n bąbelków daje n × (n − 1), więc jedna grupa 8 (56) bije cztery grupy po 2 (8). Najpierw pękaj inne kolory, by zebrać jeden kolor w dużą grupę.';

  @override
  String get tutMerge1 =>
      'Przesuń palcem (lub naciśnij strzałkę), aby przesunąć wszystkie kafelki do oporu. Dwa równe kafelki, które na siebie wpadną, łączą się w sumę. Zrób 4.';

  @override
  String get tutMerge2 =>
      'W jednym ruchu kafelek łączy się tylko raz: 4, 4, 8 zmienia się w 8, 8, a nie 16. Po każdym ruchu pojawia się nowa 2 (czasem 4). Zbuduj 16.';

  @override
  String get tutMerge3 => 'Trzymaj największy kafelek w rogu i dokarmiaj go krok po kroku. Zbuduj 32.';

  @override
  String get tutMergeS1 =>
      'Buduj łańcuch: trzymaj kafelki po kolei wzdłuż jednego wiersza, największy w rogu, jak 64, 32, 16, 8. Wtedy jedna nowa 8 na końcu toczy się aż do początku. Zbuduj 128.';

  @override
  String get tutPipes1 =>
      'Dotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara (długie naciśnięcie lub prawy przycisk obraca z powrotem). Połącz wszystkie rury ze źródłem, kafelkiem z pierścieniem. Woda pokazuje, co już jest połączone.';

  @override
  String get tutPipes2 =>
      'Żaden koniec rury nie może zostać otwarty, więc żadna rura nie może wychodzić poza planszę. Kafelki z kropką w rogu są zablokowane i już dobrze ustawione. Zacznij od brzegów i rogów, gdzie kafelki mają najmniej możliwości.';

  @override
  String get tutPipes3 => 'Teraz prawdziwa plansza. Sieć nie może tworzyć pętli.';

  @override
  String get tutPipesS1 =>
      'Działaj od brzegu do środka. Prosta na krawędzi musi biec wzdłuż niej, w rogu pasuje tylko kolanko skierowane do środka, a trójnik na krawędzi odwraca się płaskim bokiem do krawędzi. Każdy ustawiony kafelek ogranicza sąsiadów.';

  @override
  String get tutPipesS2 =>
      'Trudna plansza. Sieć nie może mieć pętli: jeśli obrót kafelka zamknąłby pętlę, musi on wskazywać gdzie indziej. A dwa ślepe końce nigdy nie patrzą na siebie, bo tworzyłyby parę odciętą od reszty.';

  @override
  String get tutShikaku1 =>
      'Podziel siatkę na prostokąty. Każdy zawiera dokładnie jedną liczbę, równą jego polu w kratkach. Przeciągnij od jednego rogu do przeciwległego, aby narysować prostokąt.';

  @override
  String get tutShikaku2 =>
      '1 to prostokąt sam w sobie: po prostu go dotknij. Dotknij narysowanego prostokąta, aby go usunąć. Tutaj 6 pasuje tylko na jeden sposób.';

  @override
  String get tutShikaku3 => 'Teraz prawdziwa plansza. Duże liczby przy brzegach zwykle mają najmniej możliwości.';

  @override
  String get tutShikakuS1 =>
      'Pytaj, które liczby mogą sięgnąć pola. Lewy dolny róg jest za daleko, by 4 lub 6 pokryły go prostokątem swojej wielkości, więc należy do 2.';

  @override
  String get tutShikakuS2 =>
      'Trudna plansza. Wypisz kilka prostokątów, których może użyć duża liczba: pola pokryte przez wszystkie należą do niej, a pole, do którego sięga tylko jedna liczba, należy do tej liczby.';

  @override
  String get tutTrail1 =>
      'Przeciągnij od 1, aby narysować jedną ścieżkę przez każde pole: w górę, w dół, w lewo lub w prawo. Kończy się na ostatniej liczbie.';

  @override
  String get tutTrail2 =>
      'Ścieżka musi mijać liczby po kolei: 1 → 2 → 3 → 4. Przeciągnij po ścieżce z powrotem, aby cofnąć kroki, albo dotknij jej pola, aby ją tam uciąć.';

  @override
  String get tutTrail3 =>
      'Teraz prawdziwa plansza. Do pola w rogu prowadzą tylko dwie drogi, więc ścieżka musi użyć obu.';

  @override
  String get tutTrailS1 =>
      'Pola z tylko dwoma wolnymi sąsiadami trzeba przejść na wylot: ścieżka wchodzi jedną stroną i wychodzi drugą. Uważaj na pola, które twoja ścieżka właśnie osaczyła.';

  @override
  String get tutTrailS2 =>
      'Trudna plansza. Nigdy nie dziel wolnych pól na dwie części: ścieżka nie wróci po drugą. A pole z tylko jednym wolnym sąsiadem to ślepy zaułek, dozwolony tylko dla ostatniej liczby.';

  @override
  String get tutLabyrinth1 =>
      'Przeciągnij od startu w lewym górnym rogu do flagi w prawym dolnym. Ściany blokują drogę.';

  @override
  String get tutLabyrinth2 =>
      'Większy labirynt. Ślepy zaułek? Przeciągnij z powrotem po swojej ścieżce albo dotknij dowolnego jej pola, aby tam wrócić. Szybkie przeciągnięcie biegnie prostymi korytarzami.';

  @override
  String get tutLabyrinthS1 =>
      'Zgubiony? Trzymaj się ręką ściany: zawsze wybieraj skrajne prawe przejście. W takim labiryncie to zawsze wyprowadza, choć nie najkrótszą drogą.';

  @override
  String get tutLabyrinthS2 =>
      'Albo idź od końca: prześledź drogę od flagi w stronę startu i szukaj, gdzie spotkają się obie trasy. Tak ślepe zaułki przy fladze szybko odpadają.';

  @override
  String get tutAtoms1 =>
      'Połącz atomy wiązaniami. Każdy atom potrzebuje tylu wiązań, ile wynosi jego liczba, a dwa atomy mogą mieć jedno lub dwa wspólne. Przeciągnij od atomu w stronę sąsiada, aby dodać wiązanie (1 → 2 → brak).';

  @override
  String get tutAtoms2 =>
      'Wszystkie atomy muszą tworzyć jedną cząsteczkę, a wiązania się nie krzyżują. Wiązanie od lewej górnej 1 w dół zostawiłoby dwie osobne pary. Gdzie więc idzie?';

  @override
  String get tutAtoms3 =>
      'Teraz prawdziwa plansza. Zacznij od atomów, które mogą dostać wiązania tylko na jeden sposób.';

  @override
  String get tutAtomsS1 =>
      'Porównuj liczbę atomu z jego sąsiadami. 4 w rogu ma tylko dwóch sąsiadów, a para może mieć najwyżej dwa wiązania, więc oba wiązania są podwójne. Podobnie 3 z dwoma sąsiadami dostaje co najmniej jedno wiązanie z każdym.';

  @override
  String get tutAtomsS2 =>
      'Trudna plansza. Utrzymuj cząsteczkę w jednym kawałku: dwie jedynki nigdy nie łączą się ze sobą, a dwie dwójki nie mają podwójnego wiązania, chyba że to jedyne atomy. Gdy utkniesz, spróbuj wiązania i zobacz, czy część planszy się nie odcina.';

  @override
  String get tutLits1 =>
      'Zamaluj dokładnie 4 pola w każdym obrysowanym obszarze, tworząc L, I, T lub S. Górny obszar ma dokładnie 4 pola, więc zamaluj wszystkie. Dotknij pola, aby je zamalować.';

  @override
  String get tutLits2 =>
      'Żaden blok 2×2 nie może być w całości zamalowany, a identyczne kształty nie stykają się przez granicę. Lewy obszar dopełnia tylko jedno pole. Które?';

  @override
  String get tutLits3 =>
      'Teraz prawdziwa plansza. Wszystkie zamalowane pola muszą być połączone. Dotknij dwa razy, aby postawić kropkę, notatkę, że pole zostaje puste.';

  @override
  String get tutLitsS1 =>
      'Wypisz kształty, które każdy region jeszcze pomieści. Pola pokryte przez każdy możliwy kształt są zamalowane, a te, których nie pokrywa żaden, zostają puste. Najmniej opcji mają małe regiony i te ściśnięte zasadą 2×2.';

  @override
  String get tutLitsS2 =>
      'Trudniejsza plansza. Gdy utkniesz, spróbuj jednego kształtu w regionie: jeśli tworzy blok 2×2, rozcina zamalowany obszar na dwoje albo stawia obok siebie dwa jednakowe kształty, jest zły.';

  @override
  String get tutCamp1 =>
      'Rozbij namiot obok każdego drzewa: nad, pod, z lewej lub z prawej, nigdy po przekątnej. Liczby na zewnątrz mówią, ile namiotów jest w wierszu i kolumnie. Dotknij pola dwa razy: trawa, potem namiot.';

  @override
  String get tutCamp2 =>
      'Namioty nigdy się nie stykają, nawet po przekątnej. Jeden namiot już stoi. Gdzie może stanąć namiot drugiego drzewa?';

  @override
  String get tutCamp3 =>
      'Teraz prawdziwa plansza. 0 oznacza, że cały wiersz lub kolumna to trawa, a każde drzewo ma swój namiot.';

  @override
  String get tutCampS1 =>
      'Licz luki. Górny wiersz potrzebuje 2 namiotów, a zmieszczą się tylko w trzech zaznaczonych polach. Dwa namioty w trzech polach, które nie mogą się stykać, zajmują oba końce.';

  @override
  String get tutCampS2 =>
      'Trudna plansza, a część liczb jest ukryta. Gdy utkniesz, spróbuj postawić namiot: jeśli jakieś drzewo zostaje bez miejsca na własny namiot, tam jest trawa.';

  @override
  String get tutIslands1 =>
      'Zamaluj morze tak, aby niezamalowane pola tworzyły wyspy. Każda liczba to wyspa z dokładnie tylu pól. Tu 1 jest wyspą sama w sobie: dotknij pozostałych pól, aby zrobić z nich morze.';

  @override
  String get tutIslands2 =>
      'Wyspy nigdy się nie stykają. Pole między dwiema liczbami musi być morzem, inaczej połączyłoby je w jedną wyspę.';

  @override
  String get tutIslands3 =>
      'Morze musi być połączone i nie może tworzyć basenów 2×2. Powiększ 3 tak, aby nie złamać żadnej z tych zasad. Dotknij dwa razy, aby postawić kropkę, notatkę „ląd”.';

  @override
  String get tutIslands4 => 'Teraz prawdziwa plansza. Każda wyspa ma dokładnie jedną liczbę.';

  @override
  String get tutIslandsS1 =>
      'Szukaj pól, do których nie sięga żadna wyspa. 3 rośnie najwyżej o dwa kroki od swojej liczby, 2 o jeden, a 1 wcale. Zaznaczone pola są poza zasięgiem wszystkich wysp, więc to morze.';

  @override
  String get tutIslandsS2 =>
      'Trudna plansza. Pamiętaj o morzu: musi pozostać połączone, więc pole morza z jednym wyjściem ciągnie się w tę stronę, i nie może tworzyć sadzawki 2×2. Gdy utkniesz, spróbuj pola jako lądu i zobacz, czy coś się nie psuje.';

  @override
  String get tutLamps1 =>
      'Stawiaj lampy na pustych polach: dotknij dwa razy (kropka, potem lampa). Ciemne pola to ściany. Lampa oświetla swój wiersz i kolumnę aż do ścian. Oświetl wszystkie puste pola.';

  @override
  String get tutLamps2 =>
      'Liczba na ścianie mówi, ile lamp jej dotyka (nad, pod, z lewej lub z prawej). Ta 3 potrzebuje lampy z każdej wolnej strony.';

  @override
  String get tutLamps3 =>
      'Lampy nigdy nie świecą na siebie, a 0 oznacza brak lampy tuż obok. Gdzie stanie druga lampa?';

  @override
  String get tutLamps4 => 'Teraz prawdziwa plansza. Kropkami zaznaczaj pola, na których nie może stać lampa.';

  @override
  String get tutLampsS1 =>
      'Niektóre pola da się oświetlić tylko w jeden sposób. Lewy górny róg może oświetlić tylko lampa w nim lub u jednego z dwóch sąsiadów, a 0 wyklucza sąsiadów: lampa stoi w rogu. Potem spójrz na 1.';

  @override
  String get tutLampsS2 =>
      'Trudna plansza. Gdy utkniesz, spróbuj lampy w polu i prześledź skutki: jeśli jakiegoś pola nie da się już oświetlić albo liczby spełnić, to pole dostaje kropkę.';

  @override
  String get tutFence1 =>
      'Narysuj jedną zamkniętą pętlę po kropkowanych liniach. Liczba mówi, ile boków jej pola zajmuje pętla. Dotknij między dwiema kropkami, aby narysować linię, albo przeciągaj od kropki do kropki.';

  @override
  String get tutFence2 =>
      'Wokół 0 nie ma linii. Dotknij linii jeszcze raz, aby zmienić ją w krzyżyk, notatkę, że linii tam nie ma. Pola bez liczby mogą mieć dowolną liczbę.';

  @override
  String get tutFence3 =>
      'Pętla nie rozgałęzia się ani nie krzyżuje: w każdej kropce jest zero lub dwie linie. Liczby przy brzegu planszy to dobry początek.';

  @override
  String get tutFence4 => 'Teraz prawdziwa plansza. Zacznij od 0 i 3.';

  @override
  String get tutFenceS1 =>
      'Poznaj kilka wzorów. Dwie trójki obok siebie zawsze mają linię między sobą i po linii na dalszych bokach: inaczej jednej z nich zabraknie. 0 nad nimi też pomaga.';

  @override
  String get tutFenceS2 =>
      'Rogi dużo mówią. 1 w rogu nigdy nie używa swoich dwóch zewnętrznych boków: pętla musiałaby tam skręcić i zająć oba. 3 w rogu zawsze używa obu.';

  @override
  String get tutFenceS3 =>
      'Trudna plansza. Gdy utkniesz, spróbuj linii na jednej krawędzi i prześledź ją: jeśli prowadzi w ślepy zaułek, do liczby nie do spełnienia albo do małej pętli, która zostawia inne poza sobą, ta krawędź dostaje krzyżyk.';

  @override
  String get tutPearls1 =>
      'Przeciągaj po polach, aby narysować jedną zamkniętą pętlę. Na czarnej perle pętla skręca, a potem biegnie prosto przez następne pole po obu stronach.';

  @override
  String get tutPearls2 =>
      'Przez białą perłę pętla biegnie prosto i skręca w polu tuż przed nią lub za nią (albo w obu).';

  @override
  String get tutPearls3 =>
      'Teraz prawdziwa plansza. Pętla nie musi przechodzić przez każde pole i nigdy się nie krzyżuje ani nie styka ze sobą.';

  @override
  String get tutPearlsS1 =>
      'Czarna perła nie skręci ku zbyt bliskiej krawędzi: pętla potrzebuje dwóch prostych pól z każdej strony. Obie czarne perły są tu za blisko dwóch krawędzi, więc ich kierunki są ustalone.';

  @override
  String get tutPearlsS2 =>
      'Trudna plansza. Trzy białe perły w rzędzie nie mogą leżeć na jednym prostym odcinku (środkowa potrzebuje skrętu obok), więc pętla przecina je w poprzek. Gdy utkniesz, spróbuj linii i zobacz, czy jakaś perła się nie psuje.';

  @override
  String get tutRails1 =>
      'Przeciągaj po polach, aby ułożyć jeden tor od wjazdu po lewej do wyjazdu na dole. Liczby u góry i po prawej liczą pola toru w każdej kolumnie i wierszu.';

  @override
  String get tutRails2 =>
      'Odcinki, które już są na planszy, są stałe: tor biegnie przez nie dokładnie tak, jak pokazano. 0 oznacza, że w tym wierszu lub kolumnie nie ma toru wcale.';

  @override
  String get tutRails3 =>
      'Teraz prawdziwa plansza. Tor się nie rozgałęzia ani nie krzyżuje i nie musi przechodzić przez każde pole.';

  @override
  String get tutRailsS1 =>
      'Zacznij od linii, w których liczba nie zostawia wyboru. Drugi wiersz potrzebuje 4 pól toru i ma ich tylko 4, prawa kolumna tak samo. Potem połącz końce.';

  @override
  String get tutRailsS2 =>
      'Trudna plansza. Wyczerpana liczba blokuje resztę swojej linii, a pole toru zawsze potrzebuje dokładnie dwóch sąsiadów z torem. Gdy utkniesz, spróbuj kawałka toru i sprawdź, czy liczby wciąż się zgadzają.';

  @override
  String get tutBlocks1 =>
      'Każdy obszar z k pól zawiera liczby od 1 do k po jednym razie. Każde podświetlone pole to ostatnia luka w swoim obszarze: wybierz brakującą liczbę z palety i dotknij pola.';

  @override
  String get tutBlocks2 =>
      'Równe liczby nigdy się nie stykają, nawet rogami. Obszar w lewym górnym rogu potrzebuje 1 i 2, a jedno z jego pól już styka się z dwójką. Tak samo wypełnij dolny wiersz.';

  @override
  String get tutBlocks3 =>
      'Teraz prawdziwa plansza. Zacznij od małych obszarów i pól, których sąsiedzi wykluczają większość liczb. Notatki ołówkiem pomagają.';

  @override
  String get tutBlocksS1 =>
      'Wskazywanie: zanotuj, gdzie każdy region może jeszcze postawić liczbę. Gdy wszystkie te pola stykają się z tym samym polem poza regionem, to pole nie może mieć tej liczby, bo by się z nią stykało. Notatki ołówkiem pomagają to zobaczyć.';

  @override
  String get tutBlocksS2 =>
      'Trudna plansza. Gdy nic innego nie działa, wybierz pole z tylko dwiema możliwymi liczbami i spróbuj jednej: jeśli wkrótce jakiś region nie ma miejsca na liczbę, właściwa jest druga.';

  @override
  String get tutPairs1 =>
      'Zamaluj dokładnie dwa pola w każdym obszarze tak, aby każde zamalowane stykało się z dokładnie jednym innym: zamalowane pola tworzą pary. Podświetlony obszar ma tylko dwa pola, więc zamaluj oba.';

  @override
  String get tutPairs2 =>
      'Pary nigdy nie stykają się ze sobą bokami. Górna para jest gotowa, więc zaznaczone pola obok niej zostają niezamalowane: postaw na nich kropki (dotknij dwa razy), a potem dokończ planszę.';

  @override
  String get tutPairs3 => 'Teraz prawdziwa plansza. Małe obszary i pola otoczone kropkami to dobre miejsca na start.';

  @override
  String get tutPairsS1 =>
      'Przejrzyj wszystkie sposoby dokończenia małego regionu: pole zamalowane w każdym z nich jest zamalowane, a pole niezamalowane w żadnym dostaje kropkę. Na przykład w literze L z trzech pól zawsze zamalowany jest róg.';

  @override
  String get tutPairsS2 =>
      'Trudna plansza. Gdy utkniesz, zamaluj pole i idź za zasadami: jeśli jakiś region nie może już dostać swoich dwóch pól albo dwie pary by się stykały, to pole zostaje niezamalowane.';

  @override
  String get tutPlots1 =>
      'Wypełnij każde pole liczbą. Równe liczby stykające się bokami tworzą działkę z dokładnie tylu pól. Podświetlona trójka potrzebuje jeszcze dwóch pól do swojej działki.';

  @override
  String get tutPlots2 =>
      'Dwie działki tej samej wielkości nie mogą się stykać: połączyłyby się w jedną, za dużą. Podświetlone pole styka się z dwiema działkami po 2, więc nie może być dwójką.';

  @override
  String get tutPlots3 =>
      'Teraz prawdziwa plansza. Niektóre działki nie mają żadnej liczby: ustal ich wielkość z miejsca, które zostało.';

  @override
  String get tutPlotsS1 =>
      'Szukaj kieszeni. Dwa zaznaczone pola otaczają gotowe działki, więc mogą połączyć się tylko ze sobą. Dwie jedynki nie mogą się stykać, więc razem tworzą działkę 2.';

  @override
  String get tutPlotsS2 =>
      'Trudna plansza. Gdy nic nie jest pewne, wybierz pole z tylko dwiema lub trzema możliwymi liczbami i sprawdź każdą: liczba, przez którą jakaś działka nie może osiągnąć swojego rozmiaru, odpada.';

  @override
  String get tutLinks1 =>
      'Przeciągnij od kółka do jego pary, aby je połączyć. Ścieżki biegną przez sąsiednie pola, nigdy po przekątnej.';

  @override
  String get tutLinks2 => 'Ścieżki się nie krzyżują, a razem wypełniają każde pole, więc niektóre muszą iść naokoło.';

  @override
  String get tutLinks3 => 'Teraz prawdziwa plansza. W rogach i przy krawędziach jest najmniej dróg, więc zacznij tam.';

  @override
  String get tutLinksS1 =>
      'Najpierw wypełniaj ciasne miejsca. Pusty róg ma tylko dwóch sąsiadów, więc ścieżka przez niego używa obu. Tak samo z każdym polem, któremu zostało dwóch wolnych sąsiadów.';

  @override
  String get tutLinksS2 =>
      'Trudna plansza. W łamigłówce z jedną odpowiedzią ścieżka nigdy nie zawraca tuż obok siebie (mogłaby pójść na skróty), więc żaden kwadrat 2×2 nie należy do jednej ścieżki. I nie zostawiaj pustego pola, do którego żadna ścieżka już nie dotrze.';

  @override
  String get tutArrows1 =>
      'Narysuj jedną pętlę przez środki wszystkich pustych pól: przeciągaj od pola do pola. Pole ze wskazówką pośrodku nigdy nie jest na pętli. Jego 0 mówi, że nad nim nic nie jest zamalowane, więc tu nic nie zamalowujesz.';

  @override
  String get tutArrows2 =>
      'Teraz dwa pola trzeba zamalować. Każda wskazówka liczy zamalowane pola w kierunku swojej strzałki: znajdź je i dotknij ich środków, aby je zamalować. Zamalowane pola nie stykają się bokami. Potem narysuj pętlę przez wszystkie pozostałe pola.';

  @override
  String get tutArrows3 =>
      'Teraz prawdziwa plansza. Pola obok zamalowanego są zawsze na pętli, a pole pętli potrzebuje dwóch wyjść.';

  @override
  String get tutArrowsS1 =>
      'Szukaj ciasnych wskazówek. 2 w środkowym wierszu ma po prawej tylko trzy pola, a jej dwa zamalowane pola nie mogą się stykać, więc zajmują pierwsze i ostatnie. Z 2 w górnym wierszu jest jeszcze łatwiej: ma tylko dwa wolne pola.';

  @override
  String get tutArrowsS2 =>
      'Trudna plansza. Każde pole, które nie jest zamalowane ani wskazówką, leży na pętli, więc pole z tylko dwoma wolnymi sąsiadami ma ustaloną drogę. Gdy utkniesz, spróbuj zamalować pole i zobacz, czy jakiemuś polu pętli nie zostało mniej niż dwa wyjścia.';

  @override
  String get tutMines1 =>
      'Liczba mówi, ile min jest w 8 polach wokół niej. Każda 1 tutaj dotyka tylko jednego zakrytego pola, więc tam jest mina. Postaw flagę: długie naciśnięcie lub prawy przycisk, albo włącz „Flaga” poniżej i dotknij.';

  @override
  String get tutMines2 =>
      'Mina tej 1 ma już flagę, więc wszystkie inne pola wokół są bezpieczne. Odkop je albo dotknij samej 1, aby odkopać wszystkie naraz.';

  @override
  String get tutMines3 => 'Pole bez min wokół samo odkrywa swoich sąsiadów. Kop w zaznaczonym rogu.';

  @override
  String get tutMines4 =>
      'Teraz prawdziwa plansza. Nigdy nie musisz zgadywać. Jeśli przez pomyłkę kopniesz minę, po prostu dostanie flagę, a gra toczy się dalej.';

  @override
  String get tutMinesS1 =>
      'Porównuj sąsiednie liczby. 2 widzi trzy zakryte pola, a 1 po jej lewej tylko dwa pierwsze, więc trzecie to mina. To samo działa z prawej. Wtedy środkowe pole jest bezpieczne.';

  @override
  String get tutMinesS2 =>
      'Trudna plansza. Dalej porównuj liczby, które mają wspólne zakryte pola. Pod koniec policz, co zostało: licznik min może rozstrzygnąć ostatnie zakryte pola.';

  @override
  String get explain => 'Wyjaśnij';

  @override
  String get explainTooltip => 'Wyjaśnij następny krok';

  @override
  String get explainClose => 'Zamknij';

  @override
  String get explainApply => 'Zrób to';

  @override
  String get explainWhy => 'Dlaczego?';

  @override
  String get explainNone => 'Nie ma już czego wyjaśniać.';

  @override
  String exWrong(Object cell) {
    return '$cell nie zgadza się z rozwiązaniem. Najpierw wyczyść to pole.';
  }

  @override
  String exFallback(Object cell) {
    return 'Nie ma tu logicznego kroku, więc $cell wypełniono z rozwiązania.';
  }

  @override
  String exSuppose(Object cell, Object value) {
    return 'Załóżmy, że w $cell jest $value.';
  }

  @override
  String exRefutedBinary(Object cell, Object value, Object other) {
    return 'W $cell musi być $value: $other prowadzi tam do sprzeczności.';
  }

  @override
  String exRefuted(Object cell, Object value) {
    return 'W $cell nie może być $value: to prowadzi do sprzeczności.';
  }

  @override
  String exMamboPair(Object cell, Object value, Object a, Object b, Object other) {
    return 'W $cell musi być $value: inaczej $a, $b i $cell byłyby trzema $other z rzędu.';
  }

  @override
  String exMamboGap(Object cell, Object value, Object a, Object b, Object other) {
    return 'W $cell musi być $value: leży między $a i $b, gdzie oba są $other.';
  }

  @override
  String exMamboHalfRow(Object cell, Object value, Object row, Object count, Object other) {
    return 'W $cell musi być $value: wiersz $row ma już wszystkie $count $other.';
  }

  @override
  String exMamboHalfCol(Object cell, Object value, Object col, Object count, Object other) {
    return 'W $cell musi być $value: kolumna $col ma już wszystkie $count $other.';
  }

  @override
  String exMamboSame(Object cell, Object value, Object a) {
    return 'W $cell musi być $value: znak = łączy je z $a, gdzie jest $value.';
  }

  @override
  String exMamboDiff(Object cell, Object value, Object a, Object other) {
    return 'W $cell musi być $value: znak × łączy je z $a, gdzie jest $other.';
  }

  @override
  String exMamboFailThree(Object a, Object b, Object c, Object value) {
    return 'Ale wtedy $a, $b i $c to trzy $value z rzędu.';
  }

  @override
  String exMamboFailHalfRow(Object row, Object count, Object value) {
    return 'Ale wtedy wiersz $row ma więcej niż $count $value.';
  }

  @override
  String exMamboFailHalfCol(Object col, Object count, Object value) {
    return 'Ale wtedy kolumna $col ma więcej niż $count $value.';
  }

  @override
  String exMamboFailSame(Object a, Object b) {
    return 'Ale wtedy $a i $b się różnią, choć łączy je znak =.';
  }

  @override
  String exMamboFailDiff(Object a, Object b) {
    return 'Ale wtedy $a i $b są takie same, choć łączy je znak ×.';
  }

  @override
  String exSudokuNaked(Object cell, Object value) {
    return 'W $cell musi być $value: wszystkie inne cyfry są już w jego wierszu, kolumnie lub bloku.';
  }

  @override
  String exSudokuHiddenRow(Object cell, Object value, Object row) {
    return 'W $cell musi być $value: to jedyne miejsce na $value w wierszu $row.';
  }

  @override
  String exSudokuHiddenCol(Object cell, Object value, Object col) {
    return 'W $cell musi być $value: to jedyne miejsce na $value w kolumnie $col.';
  }

  @override
  String exSudokuHiddenBox(Object cell, Object value, Object box) {
    return 'W $cell musi być $value: to jedyne miejsce na $value w bloku $box.';
  }

  @override
  String exSudokuPointingRow(Object box, Object value, Object row) {
    return 'W bloku $box cyfra $value może stać tylko w wierszu $row, więc w reszcie wiersza $row jej nie będzie.';
  }

  @override
  String exSudokuPointingCol(Object box, Object value, Object col) {
    return 'W bloku $box cyfra $value może stać tylko w kolumnie $col, więc w reszcie kolumny $col jej nie będzie.';
  }

  @override
  String exSudokuClaimingRow(Object row, Object value, Object box) {
    return 'W wierszu $row cyfra $value może stać tylko w bloku $box, więc w reszcie tego bloku jej nie będzie.';
  }

  @override
  String exSudokuClaimingCol(Object col, Object value, Object box) {
    return 'W kolumnie $col cyfra $value może stać tylko w bloku $box, więc w reszcie tego bloku jej nie będzie.';
  }

  @override
  String exSudokuPairRow(Object a, Object b, Object v1, Object v2, Object row) {
    return 'W $a i $b mogą być tylko $v1 i $v2, więc w reszcie wiersza $row tych cyfr nie będzie.';
  }

  @override
  String exSudokuPairCol(Object a, Object b, Object v1, Object v2, Object col) {
    return 'W $a i $b mogą być tylko $v1 i $v2, więc w reszcie kolumny $col tych cyfr nie będzie.';
  }

  @override
  String exSudokuPairBox(Object a, Object b, Object v1, Object v2, Object box) {
    return 'W $a i $b mogą być tylko $v1 i $v2, więc w reszcie bloku $box tych cyfr nie będzie.';
  }

  @override
  String exSudokuFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żadna cyfra.';
  }

  @override
  String exSudokuFailNoPlaceRow(Object value, Object row) {
    return 'Ale wtedy $value nie ma już miejsca w wierszu $row.';
  }

  @override
  String exSudokuFailNoPlaceCol(Object value, Object col) {
    return 'Ale wtedy $value nie ma już miejsca w kolumnie $col.';
  }

  @override
  String exSudokuFailNoPlaceBox(Object value, Object box) {
    return 'Ale wtedy $value nie ma już miejsca w bloku $box.';
  }

  @override
  String exSudokuFailClash(Object a, Object b, Object value) {
    return 'Ale wtedy i w $a, i w $b jest $value.';
  }

  @override
  String exKingsSuppose(Object cell) {
    return 'Załóżmy, że w $cell jest korona.';
  }

  @override
  String exKingsRefuted(Object cell) {
    return 'W $cell kropka: korona prowadzi tam do sprzeczności.';
  }

  @override
  String exKingsSingleRow(Object cell, Object row) {
    return 'W $cell korona: to ostatnie wolne pole w wierszu $row.';
  }

  @override
  String exKingsSingleCol(Object cell, Object col) {
    return 'W $cell korona: to ostatnie wolne pole w kolumnie $col.';
  }

  @override
  String exKingsSingleRegion(Object cell) {
    return 'W $cell korona: to ostatnie wolne pole jego obszaru.';
  }

  @override
  String exKingsRuledOut(Object cell, Object a) {
    return 'W $cell kropka: styka się z koroną w $a albo dzieli z nią wiersz, kolumnę lub obszar.';
  }

  @override
  String exKingsConfineRow(Object cell, Object row, Object region) {
    return 'W $cell kropka: korona wiersza $row musi być w obszarze z $region, więc innej korony w tym obszarze nie ma.';
  }

  @override
  String exKingsConfineCol(Object cell, Object col, Object region) {
    return 'W $cell kropka: korona kolumny $col musi być w obszarze z $region, więc innej korony w tym obszarze nie ma.';
  }

  @override
  String exKingsConfineRegionRow(Object cell, Object region, Object row) {
    return 'W $cell kropka: korona obszaru z $region musi być w wierszu $row, więc innej korony w wierszu $row nie ma.';
  }

  @override
  String exKingsConfineRegionCol(Object cell, Object region, Object col) {
    return 'W $cell kropka: korona obszaru z $region musi być w kolumnie $col, więc innej korony w kolumnie $col nie ma.';
  }

  @override
  String exKingsAttackRow(Object cell, Object row) {
    return 'W $cell kropka: korona tam nie zostawiłaby wolnego pola w wierszu $row.';
  }

  @override
  String exKingsAttackCol(Object cell, Object col) {
    return 'W $cell kropka: korona tam nie zostawiłaby wolnego pola w kolumnie $col.';
  }

  @override
  String exKingsAttackRegion(Object cell, Object region) {
    return 'W $cell kropka: korona tam nie zostawiłaby wolnego pola w obszarze z $region.';
  }

  @override
  String exKingsFailRow(Object row) {
    return 'Ale wtedy w wierszu $row nie zostaje miejsca na koronę.';
  }

  @override
  String exKingsFailCol(Object col) {
    return 'Ale wtedy w kolumnie $col nie zostaje miejsca na koronę.';
  }

  @override
  String exKingsFailRegion(Object region) {
    return 'Ale wtedy w obszarze z $region nie zostaje miejsca na koronę.';
  }

  @override
  String exKingsFailClash(Object a, Object b) {
    return 'Ale wtedy korony w $a i $b się wykluczają.';
  }

  @override
  String exHuesFull(Object cell, Object value, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkich $count sąsiada w kolorze $value',
      many: 'wszystkich $count sąsiadów w kolorze $value',
      few: 'wszystkich $count sąsiadów w kolorze $value',
      one: 'swojego jedynego sąsiada w kolorze $value',
    );
    return '$cell nie może być $value: $clue ma już $_temp0.';
  }

  @override
  String exHuesNeed(Object cell, Object value, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sąsiadów w kolorze $value',
      one: 'jednego sąsiada w kolorze $value',
    );
    return '$cell musi być $value: $clue potrzebuje $_temp0, i dokładnie tyle pól może go jeszcze mieć.';
  }

  @override
  String exHuesSingle(Object cell, Object value) {
    return '$cell musi być $value: wszystkie inne kolory są tu wykluczone.';
  }

  @override
  String exHuesFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żaden kolor.';
  }

  @override
  String exHuesFailMany(Object clue, Object value) {
    return 'Ale wtedy $clue ma za dużo sąsiadów w kolorze $value.';
  }

  @override
  String exHuesFailFew(Object clue, Object value) {
    return 'Ale wtedy $clue nie uzbiera dość sąsiadów w kolorze $value.';
  }

  @override
  String exBlocksNaked(Object cell, Object value) {
    return 'W $cell musi być $value: wszystkie inne liczby są już w jego obszarze albo w polach, których dotyka.';
  }

  @override
  String exBlocksHidden(Object cell, Object value) {
    return 'W $cell musi być $value: to jedyne miejsce na $value w jego obszarze.';
  }

  @override
  String exBlocksPointing(Object cell, Object value, Object region) {
    return 'W $cell nie może być $value: dotyka wszystkich pól, w których obszar z $region może jeszcze mieć $value.';
  }

  @override
  String exBlocksPair(Object a, Object b, Object v1, Object v2) {
    return '$a i $b dzielą między siebie $v1 i $v2, więc inne pola ich obszaru ich nie mają.';
  }

  @override
  String exBlocksFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żadna liczba.';
  }

  @override
  String exBlocksFailNoPlace(Object region, Object value) {
    return 'Ale wtedy w obszarze z $region nie zostaje miejsca na $value.';
  }

  @override
  String exBlocksAlone(Object cell) {
    return 'W $cell musi być 1: jego obszar to tylko to jedno pole.';
  }

  @override
  String exPlotsClosed(Object cell, Object value, Object group) {
    return 'W $cell nie może być $value: działka $value z $group jest już pełna.';
  }

  @override
  String exPlotsExit(Object cell, Object value, Object group) {
    return 'W $cell musi być $value: działce $value z $group brakuje pól, a to jej jedyne wyjście.';
  }

  @override
  String exPlotsMerge(Object cell, Object value) {
    return 'W $cell nie może być $value: połączyłoby działki $value w jedną, za dużą.';
  }

  @override
  String exPlotsRoom(Object cell, Object value) {
    return 'W $cell nie może być $value: wokół nie ma miejsca na działkę z $value pól.';
  }

  @override
  String exPlotsOnly(Object cell, Object value) {
    return 'W $cell musi być $value: wszystkie inne liczby są tu wykluczone.';
  }

  @override
  String exPlotsFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żadna liczba.';
  }

  @override
  String exPlotsFailBig(Object value, Object group) {
    return 'Ale wtedy działka $value z $group ma za dużo pól.';
  }

  @override
  String exPlotsFailShut(Object value, Object group) {
    return 'Ale wtedy działka $value z $group jest zamknięta, zanim się zapełni.';
  }

  @override
  String exPlotsFailRoom(Object value, Object group) {
    return 'Ale wtedy działka $value z $group nie ma gdzie rosnąć.';
  }

  @override
  String exPairsSupposeShade(Object cell) {
    return 'Załóżmy, że $cell jest zamalowane.';
  }

  @override
  String exPairsSupposeDot(Object cell) {
    return 'Załóżmy, że $cell nie jest zamalowane.';
  }

  @override
  String exPairsRefutedShade(Object cell) {
    return '$cell jest zamalowane: pozostawienie go pustym prowadzi do sprzeczności.';
  }

  @override
  String exPairsRefutedDot(Object cell) {
    return 'W $cell kropka: zamalowanie go prowadzi do sprzeczności.';
  }

  @override
  String exPairsRegionDone(Object cell, Object region) {
    return 'W $cell kropka: obszar z $region ma już swoje dwa zamalowane pola.';
  }

  @override
  String exPairsRegionNeed(Object cell, Object region) {
    return '$cell jest zamalowane: w obszarze z $region zostały tylko dwa pola, które można zamalować.';
  }

  @override
  String exPairsPartnered(Object cell, Object a) {
    return 'W $cell kropka: sąsiednie $a ma już parę, a pary się nie stykają.';
  }

  @override
  String exPairsOneWay(Object cell, Object a) {
    return '$cell jest zamalowane: tylko tu $a może jeszcze znaleźć parę.';
  }

  @override
  String exPairsCrowd(Object cell) {
    return 'W $cell kropka: styka się z dwoma zamalowanymi, a zamalowanie go dałoby więcej niż parę.';
  }

  @override
  String exPairsAlone(Object cell) {
    return 'W $cell kropka: obok nie zostało pole, z którym utworzyłoby parę.';
  }

  @override
  String exPairsEveryShade(Object cell, Object region) {
    return '$cell jest zamalowane: zamalowuje je każdy sposób dokończenia obszaru z $region.';
  }

  @override
  String exPairsEveryDot(Object cell, Object region) {
    return 'W $cell kropka: żaden sposób dokończenia obszaru z $region go nie zamalowuje.';
  }

  @override
  String exPairsFailMany(Object region) {
    return 'Ale wtedy obszar z $region ma więcej niż dwa zamalowane pola.';
  }

  @override
  String exPairsFailFew(Object region) {
    return 'Ale wtedy obszar z $region nie uzbiera dwóch zamalowanych pól.';
  }

  @override
  String exPairsFailCrowd(Object cell) {
    return 'Ale wtedy zamalowane $cell styka się z dwoma zamalowanymi.';
  }

  @override
  String exPairsFailAlone(Object cell) {
    return 'Ale wtedy zamalowanemu $cell nie zostaje para.';
  }

  @override
  String exPairsFailNoWay(Object region) {
    return 'Ale wtedy obszaru z $region nie da się już dokończyć.';
  }

  @override
  String exCampSupposeTent(Object cell) {
    return 'Załóżmy, że w $cell jest namiot.';
  }

  @override
  String exCampSupposeGrass(Object cell) {
    return 'Załóżmy, że w $cell jest trawa.';
  }

  @override
  String exCampRefutedTent(Object cell) {
    return 'W $cell namiot: trawa prowadzi tam do sprzeczności.';
  }

  @override
  String exCampRefutedGrass(Object cell) {
    return 'W $cell trawa: namiot prowadzi tam do sprzeczności.';
  }

  @override
  String exCampNearTent(Object cell, Object a) {
    return 'W $cell trawa: styka się z namiotem w $a, a namioty się nie stykają.';
  }

  @override
  String exCampRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count namiotu',
      many: 'wszystkie $count namiotów',
      few: 'wszystkie $count namioty',
      one: 'swój namiot',
    );
    return 'W $cell trawa: wiersz $row ma już $_temp0.';
  }

  @override
  String exCampColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count namiotu',
      many: 'wszystkie $count namiotów',
      few: 'wszystkie $count namioty',
      one: 'swój namiot',
    );
    return 'W $cell trawa: kolumna $col ma już $_temp0.';
  }

  @override
  String exCampRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count namiotów',
      one: 'jednego namiotu',
    );
    return 'W $cell namiot: wiersz $row potrzebuje $_temp0, a zostało dokładnie tyle pól.';
  }

  @override
  String exCampColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count namiotów',
      one: 'jednego namiotu',
    );
    return 'W $cell namiot: kolumna $col potrzebuje $_temp0, a zostało dokładnie tyle pól.';
  }

  @override
  String exCampTotalDone(Object cell) {
    return 'W $cell trawa: każde drzewo ma już swój namiot.';
  }

  @override
  String exCampTotalNeed(Object cell) {
    return 'W $cell namiot: drzewa potrzebują wszystkich pozostałych pól.';
  }

  @override
  String exCampTreeOnly(Object cell, Object tree) {
    return 'W $cell namiot: to jedyne wolne pole obok drzewa w $tree.';
  }

  @override
  String exCampFailTouch(Object a, Object b) {
    return 'Ale wtedy namioty w $a i $b się stykają.';
  }

  @override
  String exCampFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count namiotu',
      many: '$count namiotów',
      few: '$count namioty',
      one: 'jeden namiot',
    );
    return 'Ale wtedy wiersz $row ma więcej niż $_temp0.';
  }

  @override
  String exCampFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count namiotu',
      many: '$count namiotów',
      few: '$count namioty',
      one: 'jeden namiot',
    );
    return 'Ale wtedy kolumna $col ma więcej niż $_temp0.';
  }

  @override
  String exCampFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count namiotów',
      one: 'swojego namiotu',
    );
    return 'Ale wtedy wiersz $row nie zmieści $_temp0.';
  }

  @override
  String exCampFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count namiotów',
      one: 'swojego namiotu',
    );
    return 'Ale wtedy kolumna $col nie zmieści $_temp0.';
  }

  @override
  String get exCampFailTotal => 'Ale wtedy namiotów nie będzie tyle co drzew.';

  @override
  String exCampFailTree(Object tree) {
    return 'Ale wtedy drzewu w $tree nie zostaje wolne pole na namiot.';
  }

  @override
  String get exCampFailPairing => 'Ale wtedy drzew i namiotów nie da się połączyć w pary.';

  @override
  String exIslandsSupposeSea(Object cell) {
    return 'Załóżmy, że $cell to morze.';
  }

  @override
  String exIslandsSupposeLand(Object cell) {
    return 'Załóżmy, że $cell to ląd.';
  }

  @override
  String exIslandsRefutedSea(Object cell) {
    return '$cell to morze: ląd prowadzi tam do sprzeczności.';
  }

  @override
  String exIslandsRefutedLand(Object cell) {
    return '$cell to ląd: morze prowadzi tam do sprzeczności.';
  }

  @override
  String exIslandsTotalSea(Object cell) {
    return '$cell to morze: wyspy mają już cały swój ląd.';
  }

  @override
  String exIslandsTotalLand(Object cell) {
    return '$cell to ląd: morze nie może mieć więcej pól.';
  }

  @override
  String exIslandsPool(Object cell) {
    return '$cell to ląd: morze utworzyłoby tam blok 2×2.';
  }

  @override
  String exIslandsComplete(Object cell, Object island, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola',
      many: 'wszystkie $count pól',
      few: 'wszystkie $count pola',
      one: 'swoje jedno pole',
    );
    return '$cell to morze: wyspa z $island ma już $_temp0.';
  }

  @override
  String exIslandsExit(Object cell, Object island) {
    return '$cell to ląd: wyspie z $island brakuje pól, a to jej jedyne wyjście.';
  }

  @override
  String exIslandsBetween(Object cell) {
    return '$cell to morze: styka się z dwiema różnymi wyspami z liczbami.';
  }

  @override
  String exIslandsUnreachable(Object cell) {
    return '$cell to morze: żadna wyspa do niego nie sięga.';
  }

  @override
  String exIslandsSeaExit(Object cell, Object sea) {
    return '$cell to morze: morze z $sea nie ma innego wyjścia, a całe morze jest połączone.';
  }

  @override
  String get exIslandsFailTotal => 'Ale wtedy ląd i morze się nie zgadzają.';

  @override
  String get exIslandsFailInvalid => 'Ale wtedy wypełniona plansza łamie regułę.';

  @override
  String exIslandsFailPool(Object cell) {
    return 'Ale wtedy morze tworzy blok 2×2 w $cell.';
  }

  @override
  String exIslandsFailTwoClues(Object a, Object b) {
    return 'Ale wtedy liczby w $a i $b trafiają na jedną wyspę.';
  }

  @override
  String exIslandsFailBig(Object island, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: 'jedno pole',
    );
    return 'Ale wtedy wyspa z $island ma więcej niż $_temp0.';
  }

  @override
  String exIslandsFailShut(Object island) {
    return 'Ale wtedy wyspa z $island jest zamknięta, zanim się zapełni.';
  }

  @override
  String exIslandsFailOrphan(Object island) {
    return 'Ale wtedy ląd z $island jest odcięty od wszystkich liczb.';
  }

  @override
  String exIslandsFailUnreachable(Object cell) {
    return 'Ale wtedy żadna wyspa nie sięga lądu w $cell.';
  }

  @override
  String exIslandsFailSeaShut(Object sea) {
    return 'Ale wtedy morze z $sea jest odcięte od reszty.';
  }

  @override
  String exLampsSupposeLamp(Object cell) {
    return 'Załóżmy, że w $cell jest lampa.';
  }

  @override
  String exLampsSupposeDot(Object cell) {
    return 'Załóżmy, że w $cell nie ma lampy.';
  }

  @override
  String exLampsRefutedLamp(Object cell) {
    return 'W $cell lampa: bez niej powstaje sprzeczność.';
  }

  @override
  String exLampsRefutedDot(Object cell) {
    return 'W $cell kropka: lampa prowadzi tam do sprzeczności.';
  }

  @override
  String exLampsLit(Object cell, Object a) {
    return 'W $cell kropka: świeci na nie lampa w $a, a lampy nie świecą na siebie.';
  }

  @override
  String exLampsWallDone(Object cell, Object wall) {
    return 'W $cell kropka: przy ścianie $wall stoi już tyle lamp, ile mówi jej liczba.';
  }

  @override
  String exLampsWallNeed(Object cell, Object wall) {
    return 'W $cell lampa: ściana $wall potrzebuje lampy w każdym wolnym polu obok.';
  }

  @override
  String exLampsOnlySource(Object cell, Object a) {
    return 'W $cell lampa: to jedyne pole, które może jeszcze oświetlić $a.';
  }

  @override
  String exLampsSelf(Object cell) {
    return 'W $cell lampa: nic innego go nie oświetli.';
  }

  @override
  String exLampsFailSee(Object a, Object b) {
    return 'Ale wtedy lampy w $a i $b świecą na siebie.';
  }

  @override
  String exLampsFailMany(Object wall) {
    return 'Ale wtedy przy ścianie $wall jest za dużo lamp.';
  }

  @override
  String exLampsFailFew(Object wall) {
    return 'Ale wtedy przy ścianie $wall nie zmieści się dość lamp.';
  }

  @override
  String exLampsFailDark(Object cell) {
    return 'Ale wtedy nic nie oświetli $cell.';
  }

  @override
  String exLitsSuppose(Object region, Object cells) {
    return 'Załóżmy, że w obszarze z $region zamalowano $cells.';
  }

  @override
  String exLitsRefuted(Object region, Object cells) {
    return 'W obszarze z $region nie można zamalować $cells: to prowadzi do sprzeczności.';
  }

  @override
  String exLitsOverEmpty(Object region) {
    return 'Kształty w obszarze z $region zakrywające puste pole odpadają.';
  }

  @override
  String exLitsMisses(Object region) {
    return 'Kształty w obszarze z $region omijające jego zamalowane pole odpadają.';
  }

  @override
  String exLitsPool(Object region) {
    return 'Kształty w obszarze z $region, które dałyby zamalowany blok 2×2, odpadają.';
  }

  @override
  String exLitsClash(Object region, Object other) {
    return 'Kształty w obszarze z $region kolidujące z każdą opcją obszaru z $other odpadają.';
  }

  @override
  String exLitsCut(Object region) {
    return 'Kształty w obszarze z $region, które rozcięłyby zamalowanie na części, odpadają.';
  }

  @override
  String exLitsTwin(Object region, Object other) {
    return 'Kształty w obszarze z $region stykające się z takim samym kształtem w obszarze z $other odpadają.';
  }

  @override
  String exLitsAll(Object cell, Object region) {
    return '$cell jest zamalowane: zakrywa je każdy możliwy kształt obszaru z $region.';
  }

  @override
  String exLitsNone(Object cell, Object region) {
    return 'W $cell kropka: żaden możliwy kształt obszaru z $region go nie zakrywa.';
  }

  @override
  String exLitsFailNoShape(Object region) {
    return 'Ale wtedy w obszarze z $region nie mieści się żaden kształt.';
  }

  @override
  String get exLitsFailCut => 'Ale wtedy zamalowane pola nie łączą się w całość.';

  @override
  String exLoopSupposeLine(Object edge) {
    return 'Załóżmy, że $edge to linia.';
  }

  @override
  String exLoopSupposeCross(Object edge) {
    return 'Załóżmy, że $edge jest skreślona.';
  }

  @override
  String exLoopRefutedLine(Object edge) {
    return '$edge to linia: skreślenie jej prowadzi do sprzeczności.';
  }

  @override
  String exLoopRefutedCross(Object edge) {
    return '$edge skreślamy: linia prowadzi tam do sprzeczności.';
  }

  @override
  String exLoopFull(Object edge) {
    return '$edge skreślamy: na jej końcu spotykają się już dwie linie, a pętla się nie rozgałęzia.';
  }

  @override
  String exLoopDeadEnd(Object edge) {
    return '$edge skreślamy: z jej końca linia nie miałaby dokąd iść.';
  }

  @override
  String exLoopOnlyWay(Object edge) {
    return '$edge to linia: linia, która dotarła do jej końca, może iść dalej tylko tędy.';
  }

  @override
  String exLoopCloseEarly(Object edge) {
    return '$edge skreślamy: zamknęłaby pętlę, zanim łamigłówka jest rozwiązana.';
  }

  @override
  String exLoopDone(Object edge) {
    return '$edge skreślamy: pętla jest już zamknięta.';
  }

  @override
  String get exLoopFailBranch => 'Ale wtedy w jednym punkcie spotykają się trzy linie.';

  @override
  String get exLoopFailDeadEnd => 'Ale wtedy linia trafia w ślepy zaułek.';

  @override
  String get exLoopFailSubloop => 'Ale wtedy linie tworzą więcej niż jedną pętlę.';

  @override
  String get exLoopFailClues => 'Ale wtedy zamknięta pętla łamie wskazówkę.';

  @override
  String exFenceDone(Object edge, Object cell) {
    return '$edge skreślamy: wokół $cell jest już tyle linii, ile mówi jego liczba.';
  }

  @override
  String exFenceNeed(Object edge, Object cell) {
    return '$edge to linia: $cell potrzebuje linii na każdym boku, który jest jeszcze otwarty.';
  }

  @override
  String exFenceFailMany(Object cell) {
    return 'Ale wtedy wokół $cell jest więcej linii, niż mówi jego liczba.';
  }

  @override
  String exFenceFailFew(Object cell) {
    return 'Ale wtedy wokół $cell nie zmieści się tyle linii, ile mówi jego liczba.';
  }

  @override
  String exLoopFailClash(Object edge) {
    return 'Ale wtedy $edge musiałaby być jednocześnie linią i skreślona.';
  }

  @override
  String get exLoopFailOffBoard => 'Ale wtedy pętla musiałaby wyjść poza planszę.';

  @override
  String exPearlsPass(Object edge, Object cell) {
    return '$edge to linia: pętla przechodzi przez perłę w $cell, a zostały tam tylko dwie drogi.';
  }

  @override
  String exPearlsBlackFar(Object edge, Object cell) {
    return '$edge skreślamy: od czarnej perły w $cell pętla nie przeszłaby tędy dwóch pól prosto.';
  }

  @override
  String exPearlsBlackStraight(Object edge, Object cell) {
    return '$edge to linia: za czarną perłą w $cell pętla biegnie prosto jeszcze jedno pole.';
  }

  @override
  String exPearlsBlackThrough(Object edge, Object cell) {
    return '$edge skreślamy: na czarnej perle w $cell pętla skręca, więc nie przejdzie prosto.';
  }

  @override
  String exPearlsBlackTurn(Object edge, Object cell) {
    return '$edge to linia: na czarnej perle w $cell pętla skręca, a druga strona jest skreślona.';
  }

  @override
  String exPearlsWhiteLine(Object edge, Object cell) {
    return '$edge to linia: pętla przechodzi prosto przez białą perłę w $cell właśnie tędy.';
  }

  @override
  String exPearlsWhiteCross(Object edge, Object cell) {
    return '$edge skreślamy: pętla przechodzi prosto przez białą perłę w $cell w drugą stronę.';
  }

  @override
  String exPearlsWhiteTurnLine(Object edge, Object cell) {
    return '$edge to linia: pętla musi skręcić tuż przed białą perłą w $cell albo tuż za nią.';
  }

  @override
  String exPearlsWhiteTurnCross(Object edge, Object cell) {
    return '$edge skreślamy: pętla musi skręcić tuż przed białą perłą w $cell albo tuż za nią.';
  }

  @override
  String exPearlsFailPass(Object cell) {
    return 'Ale wtedy pętla nie przejdzie przez perłę w $cell.';
  }

  @override
  String exRailsSupposeOn(Object cell) {
    return 'Załóżmy, że tor biegnie przez $cell.';
  }

  @override
  String exRailsSupposeOff(Object cell) {
    return 'Załóżmy, że w $cell nie ma toru.';
  }

  @override
  String exRailsRefutedOn(Object cell) {
    return 'Tor biegnie przez $cell: bez niego powstaje sprzeczność.';
  }

  @override
  String exRailsRefutedOff(Object cell) {
    return 'W $cell nie ma toru: tor prowadzi tam do sprzeczności.';
  }

  @override
  String exRailsCellUsed(Object cell) {
    return 'Tor biegnie przez $cell: dochodzi już do niego kawałek toru.';
  }

  @override
  String exRailsCellEmpty(Object cell) {
    return 'W $cell nie ma toru: tor nie mógłby przez nie przejść.';
  }

  @override
  String exRailsPieceFull(Object edge, Object cell) {
    return '$edge skreślamy: tor już wchodzi do $cell i z niego wychodzi.';
  }

  @override
  String exRailsPieceEmpty(Object edge, Object cell) {
    return '$edge skreślamy: w $cell nie ma toru.';
  }

  @override
  String exRailsPieceNeed(Object edge, Object cell) {
    return '$edge to tor: tor przez $cell nie ma innej drogi.';
  }

  @override
  String exRailsRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola toru',
      many: 'wszystkie $count pól toru',
      few: 'wszystkie $count pola toru',
      one: 'swoje jedno pole toru',
    );
    return 'W $cell nie ma toru: wiersz $row ma już $_temp0.';
  }

  @override
  String exRailsColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola toru',
      many: 'wszystkie $count pól toru',
      few: 'wszystkie $count pola toru',
      one: 'swoje jedno pole toru',
    );
    return 'W $cell nie ma toru: kolumna $col ma już $_temp0.';
  }

  @override
  String exRailsRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól toru',
      one: 'jednego pola toru',
    );
    return 'Tor biegnie przez $cell: wiersz $row potrzebuje $_temp0, a zostało dokładnie tyle.';
  }

  @override
  String exRailsColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól toru',
      one: 'jednego pola toru',
    );
    return 'Tor biegnie przez $cell: kolumna $col potrzebuje $_temp0, a zostało dokładnie tyle.';
  }

  @override
  String exRailsDoneEdge(Object edge) {
    return '$edge skreślamy: tor jest już kompletny.';
  }

  @override
  String exRailsDoneOn(Object cell) {
    return 'Tor biegnie przez $cell: to część gotowego toru.';
  }

  @override
  String exRailsDoneOff(Object cell) {
    return 'W $cell nie ma toru: tor jest już kompletny.';
  }

  @override
  String exRailsCloseEarly(Object edge) {
    return '$edge skreślamy: zamknęłaby pętlę albo skończyła tor za wcześnie.';
  }

  @override
  String exRailsFailBranch(Object cell) {
    return 'Ale wtedy tor rozgałęzia się w $cell.';
  }

  @override
  String exRailsFailDeadEnd(Object cell) {
    return 'Ale wtedy tor trafia w ślepy zaułek w $cell.';
  }

  @override
  String exRailsFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola toru',
      many: '$count pól toru',
      few: '$count pola toru',
      one: 'jedno pole toru',
    );
    return 'Ale wtedy wiersz $row ma więcej niż $_temp0.';
  }

  @override
  String exRailsFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola toru',
      many: '$count pól toru',
      few: '$count pola toru',
      one: 'jedno pole toru',
    );
    return 'Ale wtedy kolumna $col ma więcej niż $_temp0.';
  }

  @override
  String exRailsFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count pól toru',
      one: 'swojego pola toru',
    );
    return 'Ale wtedy wiersz $row nie uzbiera $_temp0.';
  }

  @override
  String exRailsFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count pól toru',
      one: 'swojego pola toru',
    );
    return 'Ale wtedy kolumna $col nie uzbiera $_temp0.';
  }

  @override
  String get exRailsFailLoop => 'Ale wtedy poza torem powstaje pętla.';

  @override
  String get exRailsFailClosed => 'Ale wtedy tor kończy się za wcześnie.';

  @override
  String exRailsFailClash(Object cell) {
    return 'Ale wtedy $cell musiałoby mieć tor i go nie mieć.';
  }

  @override
  String exArrowsSupposeShade(Object cell) {
    return 'Załóżmy, że $cell jest zamalowane.';
  }

  @override
  String exArrowsSupposeOn(Object cell) {
    return 'Załóżmy, że pętla przechodzi przez $cell.';
  }

  @override
  String exArrowsRefutedShade(Object cell) {
    return '$cell jest zamalowane: pętla przez nie prowadzi do sprzeczności.';
  }

  @override
  String exArrowsRefutedOn(Object cell) {
    return 'Pętla przechodzi przez $cell: zamalowanie go prowadzi do sprzeczności.';
  }

  @override
  String exArrowsCellOn(Object cell) {
    return 'Pętla przechodzi przez $cell: dochodzi już do niego linia.';
  }

  @override
  String exArrowsCellShaded(Object cell) {
    return '$cell jest zamalowane: pętla nie mogłaby przez nie przejść, a wszystkie inne pola są na pętli.';
  }

  @override
  String exArrowsShadeNoLine(Object edge, Object cell) {
    return '$edge skreślamy: $cell jest zamalowane, więc pętla je omija.';
  }

  @override
  String exArrowsShadeNeighbours(Object cell, Object a) {
    return 'Pętla przechodzi przez $cell: styka się z zamalowanym $a, a zamalowane pola się nie stykają.';
  }

  @override
  String exArrowsOnNeed(Object edge, Object cell) {
    return '$edge to linia: pętla przez $cell nie ma innej drogi.';
  }

  @override
  String exArrowsClueDone(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count zamalowanego pola',
      many: 'wszystkie $count zamalowanych pól',
      few: 'wszystkie $count zamalowane pola',
      one: 'swoje jedno zamalowane pole',
      zero: 'zero zamalowanych pól, tak jak trzeba',
    );
    return 'Pętla przechodzi przez $cell: strzałka w $clue widzi już $_temp0.';
  }

  @override
  String exArrowsClueNeedShade(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zamalowanych pól',
      one: 'jednego zamalowanego pola',
    );
    return '$cell jest zamalowane: strzałka w $clue potrzebuje $_temp0, a mieszczą się tylko co drugie pole.';
  }

  @override
  String exArrowsClueNeedOn(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zamalowanych pól',
      one: 'jednego zamalowanego pola',
    );
    return 'Pętla przechodzi przez $cell: strzałka w $clue potrzebuje $_temp0, a mieszczą się tylko co drugie pole.';
  }

  @override
  String exArrowsFailStuck(Object cell) {
    return 'Ale wtedy pętla utyka w $cell.';
  }

  @override
  String exArrowsFailClueMany(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zamalowanego pola',
      many: '$count zamalowanych pól',
      few: '$count zamalowane pola',
      one: 'jedno zamalowane pole',
      zero: 'zero zamalowanych pól',
    );
    return 'Ale wtedy strzałka w $clue widzi więcej niż $_temp0.';
  }

  @override
  String exArrowsFailClueFew(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count zamalowanych pól',
      one: 'swojego zamalowanego pola',
    );
    return 'Ale wtedy strzałka w $clue nie uzbiera $_temp0.';
  }

  @override
  String exArrowsFailClash(Object cell) {
    return 'Ale wtedy $cell musiałoby być zamalowane i na pętli.';
  }
}
