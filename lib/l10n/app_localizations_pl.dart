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
  String get dailyChoose => 'Wybierz gry';

  @override
  String dailyChooseHint(int count) {
    return 'Każdego dnia losowane są $count z wybranych gier. Zmiana działa od dziś, wcześniejsze dni zachowują swoje gry.';
  }

  @override
  String dailyChooseMin(int count) {
    return 'Wybierz co najmniej $count gry';
  }

  @override
  String get dailyChooseAll => 'Wszystkie gry';

  @override
  String get save => 'Zapisz';

  @override
  String get playCode => 'Zagraj według kodu łamigłówki';

  @override
  String get playCodeMenu => 'Zagraj według kodu…';

  @override
  String get inProgress => 'W toku';

  @override
  String get catNumbers => 'Liczby';

  @override
  String get catGrids => 'Siatki logiczne';

  @override
  String get catPaths => 'Ścieżki i pętle';

  @override
  String get catCasual => 'Na luzie';

  @override
  String get searchHint => 'Szukaj gier';

  @override
  String get searchNone => 'Nie znaleziono gier. Przejrzyj kategorie:';

  @override
  String searchSimilar(String query) {
    return 'Nic o nazwie „$query”. Czy chodziło o:';
  }

  @override
  String searchAlternatives(String query) {
    return 'Nie mamy „$query”, ale może spodoba ci się:';
  }

  @override
  String get yourGames => 'Twoje gry';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gry',
      many: '$count gier',
      few: '$count gry',
      one: '$count gra',
    );
    return '$_temp0';
  }

  @override
  String get pinGame => 'Przypnij do twoich gier';

  @override
  String get unpinGame => 'Odepnij od twoich gier';

  @override
  String pinnedToast(String name) {
    return '$name przypięto do twoich gier';
  }

  @override
  String unpinnedToast(String name) {
    return '$name odpięto';
  }

  @override
  String get famFlood => 'Zalewanie';

  @override
  String get famFloodAbout => 'Przemalowuj planszę, aż będzie jednego koloru, w jak najmniejszej liczbie ruchów';

  @override
  String get tagShade => 'zamaluj pola, zaczernij';

  @override
  String get tagLoop => 'narysuj pętlę, cykl';

  @override
  String get tagPath => 'narysuj ścieżkę, linia, trasa';

  @override
  String get tagNumbers => 'wpisz liczby, cyfry';

  @override
  String get tagRegions => 'podziel na obszary, regiony';

  @override
  String get tagSums => 'sumy, dodawanie, arytmetyka, matematyka';

  @override
  String get tagLatin => 'kwadrat łaciński';

  @override
  String get tagCompare => 'porównanie, porównać, większy, mniejszy, więcej, mniej, nierówność, znaki';

  @override
  String get tagPlace => 'rozmieść obiekty';

  @override
  String get tagPieces => 'elementy, kształty, klocki, kafelki, dopasuj, układanka';

  @override
  String get tagConnect => 'połącz, łącz, mosty';

  @override
  String get tagColors => 'kolory, malowanie';

  @override
  String get tagGuess => 'zgadywanie, zgadnij';

  @override
  String get tagSlide => 'przesuwanie płytek, łączenie';

  @override
  String get tagArcade => 'zręcznościowa, akcja, refleks';

  @override
  String get tagSymmetry => 'symetria, symetryczny';

  @override
  String get tagBinary => 'dwa symbole, binarna';

  @override
  String get tagMaze => 'labirynt';

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
  String get generatingSlow => 'Znalezienie dobrej planszy może potrwać kilka sekund.';

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
      '• Umieść dokładnie jedną koronę w każdym wierszu, każdej kolumnie i każdym kolorowym obszarze.\n• Korony nie mogą się stykać, nawet po przekątnej.\n\nDotknij pola, aby przełączać: puste → kropka (twoja notatka „tu nie ma korony”) → korona. Prawy przycisk przełącza wstecz. Przesuń palcem po polach, aby oznaczyć je wszystkie naraz. Długie naciśnięcie stawia kropki na wszystkich polach, na których przez postawione korony nie może już być korony.';

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
  String get snakeName => 'Wąż';

  @override
  String get snakeTagline => 'Jedz jabłka, rośnij i nie gryź własnego ogona';

  @override
  String get snakeRules =>
      '• Wąż porusza się sam. Przesuń palcem (lub naciśnij strzałkę), aby go skręcić.\n• Każde jabłko wydłuża go o jedno pole i daje punkt. Gdy rośnie, trochę przyspiesza.\n• Uderzenie w ścianę lub w siebie kończy grę.\n• Dotknij planszy (lub naciśnij spację), aby zatrzymać grę, i przesuń palcem, aby grać dalej.\n\nCele\n• Gra swobodna: zjedz jak najwięcej jabłek i pobij swój rekord.\n• Cel w jabłkach: zjedz zadaną liczbę jabłek (więcej na większych planszach i wyższych poziomach), nie rozbijając się.\n\nPoziom trudności ustala prędkość.';

  @override
  String get snakeGoalTarget => 'Cel w jabłkach';

  @override
  String get snakeGoalTargetHint => 'Zjedz zadaną liczbę jabłek, nie rozbijając się.';

  @override
  String get snakeGoalFreeHint => 'Bez celu: zjedz jak najwięcej jabłek, zanim się rozbijesz.';

  @override
  String snakeFed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jabłka!',
      many: '$count jabłek!',
      few: '$count jabłka!',
      one: '$count jabłko!',
    );
    return '$_temp0';
  }

  @override
  String get snakeFull => 'Plansza jest pełna!';

  @override
  String snakeApples(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jabłka',
      many: '$count jabłek',
      few: '$count jabłka',
      one: '$count jabłko',
    );
    return '$_temp0';
  }

  @override
  String snakeLength(int count) {
    return 'Długość $count';
  }

  @override
  String get snakeStart => 'Przesuń palcem, aby zacząć';

  @override
  String get snakePaused => 'Pauza: przesuń palcem, aby grać dalej';

  @override
  String get snakeCrashed => 'Kraksa! Dotknij, aby spróbować ponownie';

  @override
  String get junctionName => 'Zwrotniczy';

  @override
  String get junctionTagline => 'Przestawiaj zwrotnice i kieruj każdy pociąg na jego stację';

  @override
  String get junctionRules =>
      '• Pociągi wyjeżdżają z tunelu jeden po drugim i same jadą po torach.\n• Każdy pociąg ma symbol, a jego stacja ma taki sam.\n• Na zwrotnicy tor rozchodzi się na dwa. Dotknij zwrotnicy, aby ją przestawić: dźwignia wskazuje odgałęzienie, którym pojedzie następny pociąg. Pociąg jedzie tym odgałęzieniem, na które zwrotnica jest ustawiona, gdy przez nią przejeżdża.\n• Pociąg, który dojedzie do swojej stacji, daje punkt; pociąg na cudzej stacji to pudło.\n• Dotknij planszy w innym miejscu (lub naciśnij spację), aby wstrzymać grę, i dotknij, aby grać dalej.\n\nCele\n• 20 pociągów: poprowadź zadaną liczbę pociągów i doprowadź jak najwięcej do ich stacji.\n• Na czas: doprowadź jak najwięcej pociągów do ich stacji w dwie minuty.\n\nPoziom trudności ustala prędkość, jak często odjeżdżają pociągi i ile jest stacji; większe plansze mają więcej zwrotnic.';

  @override
  String junctionGoalTrains(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pociągu',
      many: '$count pociągów',
      few: '$count pociągi',
      one: '$count pociąg',
    );
    return '$_temp0';
  }

  @override
  String get junctionGoalTrainsHint => 'Poprowadź zadaną liczbę pociągów i doprowadź jak najwięcej do ich stacji.';

  @override
  String junctionGoalTimed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuty',
      many: '$count minut',
      few: '$count minuty',
      one: '$count minuta',
    );
    return '$_temp0';
  }

  @override
  String get junctionGoalTimedHint => 'Doprowadź jak najwięcej pociągów do ich stacji, zanim skończy się czas.';

  @override
  String junctionFinished(int count, int total) {
    return '$count z $total pociągów na swoich stacjach';
  }

  @override
  String get junctionTimeUp => 'Koniec czasu!';

  @override
  String junctionArrived(int count) {
    return 'Dojechały: $count';
  }

  @override
  String junctionMisses(int count) {
    return 'Pudła: $count';
  }

  @override
  String get junctionStart => 'Dotknij, aby zacząć';

  @override
  String get junctionPaused => 'Pauza: dotknij, aby grać dalej';

  @override
  String get junctionWrong => 'Zła stacja! Dotknij, aby spróbować ponownie';

  @override
  String get turnaboutName => 'Karuzela';

  @override
  String get turnaboutTagline => 'Wyprzedź rywala do gwiazdy w labiryncie, który ciągle się obraca';

  @override
  String get turnaboutRules =>
      '• Ty i rywal startujecie w przeciwległych rogach labiryntu, a między wami jest gwiazda, tak samo daleko od obu.\n• Przesuń palcem (lub naciśnij strzałkę), aby przejść o jedno pole; prowadź palec dalej, aby iść dalej. Rywal biegnie najkrótszą drogą we własnym tempie.\n• Co kilka sekund cały labirynt obraca się o ćwierć obrotu (na trudnym poziomie czasem o pół). Strzałka ostrzega tuż przed obrotem. Kierunki pozostają ekranowe: w górę to zawsze w górę ekranu.\n• Kto pierwszy dotrze do gwiazdy, wygrywa rundę. Każda runda to nowy labirynt.\n• Dotknij planszy (lub naciśnij spację), aby wstrzymać.\n\nCele\n• 5 rund: wygraj jak najwięcej rund.\n• 3 życia: graj, dopóki rywal nie wygra trzech rund; z każdą twoją wygraną staje się nieco szybszy.\n\nPoziom trudności ustala szybkość rywala, labirynty i to, jak często się obracają.';

  @override
  String get turnaboutGoalRoundsHint => 'Rozegraj ustaloną liczbę rund i wygraj jak najwięcej.';

  @override
  String turnaboutGoalLivesHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rundy',
      many: '$count rund',
      few: '$count rund',
      one: 'jednej rundy',
    );
    return 'Graj, dopóki rywal nie wygra $_temp0; gdy wygrywasz, przyspiesza. Pobij swój rekord.';
  }

  @override
  String turnaboutFinished(int count, int total) {
    return 'Wygrane rundy: $count z $total';
  }

  @override
  String turnaboutStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wygranej rundy',
      many: '$count wygranych rund',
      few: '$count wygrane rundy',
      one: '$count wygrana runda',
      zero: 'Brak wygranych rund',
    );
    return '$_temp0';
  }

  @override
  String turnaboutRound(int round) {
    return 'Runda $round';
  }

  @override
  String turnaboutScore(int wins, int losses) {
    return 'Ty $wins : $losses Rywal';
  }

  @override
  String get turnaboutStart => 'Przesuń palcem, aby zacząć';

  @override
  String get turnaboutPaused => 'Pauza: przesuń palcem, aby kontynuować';

  @override
  String get turnaboutWon => 'Gwiazda twoja! Przesuń palcem, aby zagrać następną rundę';

  @override
  String get turnaboutLost => 'Rywal był szybszy. Przesuń palcem, aby zagrać następną rundę';

  @override
  String get turnaboutLostPractice => 'Rywal był szybszy! Dotknij, aby spróbować ponownie';

  @override
  String get pipesName => 'Rury';

  @override
  String get pipesTagline => 'Połącz każdą rurę ze źródłem';

  @override
  String get pipesRules =>
      '• Obracaj kafelki tak, aby każda rura łączyła się ze źródłem (kafelek z pierścieniem).\n• Żaden koniec rury nie może zostać otwarty, a sieć nie może mieć pętli.\n• Woda płynie przez wszystko, co jest już połączone ze źródłem.\n• Kafelki z kropką w rogu są zablokowane i już na miejscu.\n\nDotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara; długie naciśnięcie / prawy przycisk obraca go z powrotem.';

  @override
  String get famPlumbing => 'Hydraulika';

  @override
  String get famPlumbingAbout => 'Obracaj kafelki z rurami, aż woda popłynie tam, gdzie trzeba';

  @override
  String get channelName => 'Kanał';

  @override
  String get channelTagline => 'Doprowadź wodę ze źródła do odpływu';

  @override
  String get channelRules =>
      '• Obracaj kafelki tak, aby jedna rura prowadziła wodę ze źródła (kafelek z pierścieniem) do odpływu (kafelek z kwadratem).\n• Pozostałe kafelki nie mają znaczenia, a końce rur mogą zostać otwarte.\n• Woda wypływa z kafelka wszystkimi pozostałymi końcami, ale przez most (skrzyżowanie) płynie tylko prosto, więc rura może przejść przez most dwa razy.\n• Kafelki z kropką w rogu są zablokowane i już na miejscu.\n\nDotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara; długie naciśnięcie / prawy przycisk obraca go z powrotem.';

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
  String get tagDrive => 'jazda, auto, samochód, taksówka, zabrać, dowieźć, zwierzęta, zwierzaki, paliwo, trasa';

  @override
  String get homewardName => 'Do domu';

  @override
  String get homewardTagline => 'Odwieź wszystkie zwierzaki do domu, zanim skończy się paliwo';

  @override
  String get homewardRules =>
      '• Jedź autem po drogach. Każdy odcinek drogi między dwoma skrzyżowaniami kosztuje jedną jednostkę paliwa.\n• Podjedź do zwierzaka, aby go zabrać, a potem do domu z tym samym symbolem, aby go wysadzić. Jedno i drugie dzieje się samo.\n• Auto ma niewiele miejsc: zwierzak, do którego dojedziesz, gdy wszystkie miejsca są zajęte, czeka dalej. Gdy jest wolne miejsce, zawsze wsiada.\n• Odwieź wszystkie zwierzaki do domu, zanim skończy się paliwo.\n\nDotknij skrzyżowania obok auta albo dalej na prostej drodze, aby tam pojechać. Możesz też przeciągać wzdłuż dróg. Gdy skończy się paliwo, cofnij lub zacznij od nowa.';

  @override
  String homewardFuel(int left, int limit) {
    return 'Paliwo $left / $limit';
  }

  @override
  String get homewardOutOfFuel => 'Koniec paliwa: cofnij lub zacznij od nowa';

  @override
  String get tutHomeward1 =>
      'Dotknij skrzyżowania obok auta, aby tam pojechać. Każdy odcinek drogi kosztuje jedną jednostkę paliwa. Podjedź do zwierzaka, aby go zabrać, i zawieź go do domu z tym samym symbolem.';

  @override
  String get tutHomeward2 =>
      'To auto ma jedno miejsce. Zwierzak, do którego dojedziesz, gdy miejsce jest zajęte, czeka dalej, więc odwieź jednego do domu, zanim pojedziesz po następnego. Odwieź oba do domu.';

  @override
  String get tutHomeward3 =>
      'Teraz paliwa jest na styk, a auto ma dwa miejsca. Pędzenie do najbliższego zwierzaka nie zawsze się opłaca: zaplanuj trasę, która zabiera oba, a potem mija oba domy.';

  @override
  String get tutHomeward4 =>
      'Teraz prawdziwa plansza. Zanim ruszysz, sprawdź, gdzie mieszka każdy zwierzak, i zaplanuj trasę, która po drodze mija zwierzaki i domy.';

  @override
  String get tutHomewardS1 =>
      'Łącz kursy: planuj tak, aby każde wysadzenie wypadało po drodze do następnego zwierzaka, i zabieraj zwierzaka wcześniej, jeśli jego dom leży na trasie, którą i tak pojedziesz. Na tej planszy paliwa jest na styk.';

  @override
  String get tutHomewardS2 =>
      'Na trudnych planszach paliwa jest na styk, a auto ma tylko dwa miejsca. Zaplanuj całą trasę przed pierwszym odcinkiem: miejsce zajęte za wcześnie zmusi cię do minięcia potrzebnego zwierzaka, więc czasem objedź zwierzaka inną drogą.';

  @override
  String get blockadeName => 'Blokada';

  @override
  String get blockadeTagline => 'Przemknij obok okrętów patrolowych do portu';

  @override
  String get blockadeRules =>
      '• Doprowadź łódź do portu. W każdej turze łódź przesuwa się o jedno pole (w górę, w dół, w lewo lub w prawo) albo czeka w miejscu. Skały zagradzają drogę.\n• Po każdej turze każdy okręt patrolowy płynie o jedno pole swoją trasą: tam i z powrotem wzdłuż linii albo w kółko po pętli. Trasa jest narysowana na planszy, a pierścień pokazuje, gdzie okręt będzie po twojej następnej turze.\n• Nie daj się złapać: nigdy nie kończ tury na polu okrętu i nie zamieniaj się z okrętem miejscami. Żaden okręt nie wpływa na start ani do portu.\n• Dotrzyj do portu w dostępnej liczbie tur.\n\nDotknij pola obok łodzi, aby tam popłynąć, albo przeciągnij. Dotknij łodzi lub „Czekaj”, aby przeczekać turę. Na klawiaturze: strzałki i spacja. Jeśli cię złapią albo skończą się tury, cofnij lub zacznij od nowa.';

  @override
  String blockadeTurn(int turn, int limit) {
    return 'Tura $turn / $limit';
  }

  @override
  String get blockadeWait => 'Czekaj';

  @override
  String get blockadeCaught => 'Patrol złapał łódź: cofnij lub zacznij od nowa';

  @override
  String get blockadeOutOfTurns => 'Koniec tur: cofnij lub zacznij od nowa';

  @override
  String get tutBlockade1 =>
      'Dotknij pola obok łodzi, aby tam popłynąć: jedno pole na turę. Skały zagradzają drogę. Dopłyń do portu.';

  @override
  String get tutBlockade2 =>
      'Po każdej twojej turze każdy okręt patrolowy płynie o jedno pole swoją trasą, a pierścień pokazuje, dokąd popłynie dalej. Nie kończ tury tam, gdzie będzie okręt, i nie zamieniaj się z nim miejscami. Dotknij łodzi lub „Czekaj”, aby przeczekać turę.';

  @override
  String get tutBlockade3 =>
      'Ten okręt krąży wokół wyspy, a tur nie ma w zapasie: licznik pokazuje, ile ich masz. Krótka droga prowadzi wprost na okręt, a na czekanie nie ma czasu. Opłyń wyspę z drugiej strony, tuż za okrętem.';

  @override
  String get tutBlockade4 =>
      'Teraz prawdziwa plansza. Zanim ruszysz, sprawdź, dokąd płynie każdy okręt, i zaplanuj, kiedy minąć każdy z nich.';

  @override
  String get tutBlockadeS1 =>
      'Okręt nigdy cię nie zaskoczy: kropki pokazują całą jego trasę, a pierścień, gdzie będzie po twojej turze. Na pole, które okręt właśnie opuszcza, możesz wpłynąć, o ile nie płynie on na pole, które opuszczasz ty. Tu tur nie ma w zapasie: licz rytm okrętów i przemykaj w lukach.';

  @override
  String get tutBlockadeS2 =>
      'Na trudnych planszach tur nie ma w zapasie. Zaplanuj całą drogę przed pierwszą turą: jeśli trzeba czekać, czekaj tam, gdzie nie dopływa żaden okręt, a objazd tuż za okrętem często jest lepszy niż czekanie na niego.';

  @override
  String get campName => 'Kemping';

  @override
  String get campTagline => 'Rozbij namiot przy każdym drzewie';

  @override
  String get campRules =>
      '• Rozbij po jednym namiocie dla każdego drzewa, tuż obok niego (nad, pod, z lewej lub z prawej).\n• Każde drzewo ma swój namiot, a każdy namiot należy do jednego sąsiedniego drzewa.\n• Namioty nie stykają się ze sobą, nawet po przekątnej.\n• Liczby poza siatką mówią, ile namiotów jest w każdym wierszu i kolumnie.\n\nDotknij pola, aby przełączać: puste → trawa (twoja notatka „tu nie ma namiotu”) → namiot. Prawy przycisk przełącza wstecz. Przesuń palcem po polach, aby oznaczyć je wszystkie naraz. Długie naciśnięcie kładzie trawę na wszystkich polach, na których przez postawione namioty nie może już być namiotu.';

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
      '• Zamaluj dokładnie dwa pola w każdym obrysowanym obszarze.\n• Każde zamalowane pole styka się bokiem z dokładnie jednym innym zamalowanym polem, więc zamalowane pola tworzą pary.\n• Pary nigdy nie stykają się ze sobą bokami (rogami mogą).\n\nDotknij pola, aby przełączać: puste → zamalowane → kropka (twoja notatka „niezamalowane”). Prawy przycisk przełącza wstecz. Przesuń palcem po polach, aby oznaczyć je wszystkie naraz. Długie naciśnięcie stawia kropki na wszystkich polach, których przez gotowe pary nie można już zamalować.';

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
  String get tutSnake1 =>
      'Wąż porusza się sam: przesuń palcem (lub naciśnij strzałkę), aby go skręcić. Nie zawróci w miejscu. Doprowadź go do jabłka.';

  @override
  String get tutSnake2 =>
      'Każde jabłko wydłuża węża o jedno pole. Nie wjedź w ścianę ani we własne ciało. Zjedz 3 jabłka.';

  @override
  String get tutSnake3 =>
      'Prawdziwa plansza: zjedz 5 jabłek. Dotknij planszy, aby zatrzymać grę, i przesuń palcem, aby grać dalej.';

  @override
  String get tutSnakeS1 =>
      'Długi wąż potrzebuje miejsca. Zanim złapiesz jabłko, upewnij się, że zdołasz się wydostać: pola zwalniane przez ogon są zawsze wolne, więc podążanie za ogonem jest bezpieczne. Zjedz 3 jabłka.';

  @override
  String get tutJunction1 =>
      'Pociągi wyjeżdżają z tunelu i jadą same. Dotknij zwrotnicy, aby ją przestawić: dźwignia wskazuje, dokąd pojedzie następny pociąg. Wyślij każdy pociąg na stację z jego symbolem. Dotknij planszy, aby zacząć.';

  @override
  String get tutJunction2 =>
      'Pociąg jedzie tym odgałęzieniem, na które zwrotnica jest ustawiona, gdy przez nią przejeżdża, więc przestawiaj każdą zawczasu, a dla następnego pociągu w razie potrzeby z powrotem. Dotknij planszy z dala od zwrotnic, aby wstrzymać grę.';

  @override
  String get tutJunction3 =>
      'Prawdziwa plansza: doprowadź 6 pociągów do ich stacji. Obserwuj pociągi wyjeżdżające z tunelu i przestawiaj zwrotnice przed nimi.';

  @override
  String get tutTurnabout1 =>
      'Przesuń palcem (lub naciśnij strzałkę), aby przesunąć swojego biegacza, okrągły pionek, o jedno pole. Prowadź palec dalej, aby iść dalej. Ściany zagradzają drogę. Dotrzyj do gwiazdy.';

  @override
  String get tutTurnabout2 =>
      'Co kilka sekund cały labirynt się obraca, a tuż przed obrotem pojawia się okrągła strzałka. Kierunki na ekranie się nie zmieniają: w górę to zawsze w górę, więc droga do gwiazdy może teraz prowadzić w inną stronę. Dotrzyj do gwiazdy.';

  @override
  String get tutTurnabout3 =>
      'Wyścig: rywal, romb, biegnie do gwiazdy najkrótszą drogą. Dotrzyj tam przed nim! Runda zaczyna się od twojego pierwszego ruchu; dotknij planszy, aby wstrzymać.';

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
  String get tutChannel1 =>
      'Dotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara (długie naciśnięcie lub prawy przycisk obraca z powrotem). Doprowadź wodę ze źródła, kafelka z pierścieniem, do odpływu, kafelka z kwadratem.';

  @override
  String get tutChannel2 =>
      'Liczy się tylko rura od źródła do odpływu: inne kafelki mogą wskazywać dokądkolwiek, a końce mogą zostać otwarte. Woda wypływa z kafelka wszystkimi pozostałymi końcami, więc trójnik poprowadzi ją dalej, nawet gdy jego trzeci koniec prowadzi donikąd.';

  @override
  String get tutChannel3 =>
      'Skrzyżowanie to most: woda płynie przez nie prosto i nigdy tam nie skręca, więc rura może przejść przez nie dwa razy, raz wzdłuż i raz w poprzek.';

  @override
  String get tutChannel4 => 'Teraz prawdziwa plansza. Wiele kafelków jest tu tylko po to, by cię zmylić.';

  @override
  String get tutChannelS1 =>
      'Działaj z obu końców. Odpływ też jest zablokowany, więc prowadź rurę również wstecz od niego: prosta musi biec dalej, kolanko musi skręcić, a brzeg planszy odcina drogi. Połącz oba odcinki tam, gdzie mogą się spotkać.';

  @override
  String get tutChannelS2 =>
      'Trudna plansza, z mostami. Gdy droga kończy się ślepo, wychodzi poza planszę albo trafia na kafelki, które nie przyjmą wody, wróć do ostatniego kafelka, gdzie był wybór, i spróbuj innej drogi.';

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

  @override
  String exMinesSupposeMine(Object cell) {
    return 'Załóżmy, że w $cell jest mina.';
  }

  @override
  String exMinesSupposeSafe(Object cell) {
    return 'Załóżmy, że $cell jest bezpieczne.';
  }

  @override
  String exMinesRefutedMine(Object cell) {
    return '$cell jest bezpieczne: mina prowadzi tam do sprzeczności.';
  }

  @override
  String exMinesRefutedSafe(Object cell) {
    return 'W $cell jest mina: gdyby było bezpieczne, powstałaby sprzeczność.';
  }

  @override
  String exMinesNumberSafe(Object cell, Object number) {
    return '$cell jest bezpieczne: liczba w $number ma już wokół wszystkie swoje miny.';
  }

  @override
  String exMinesNumberMine(Object cell, Object number) {
    return 'W $cell jest mina: liczba w $number potrzebuje miny w każdym zakrytym polu wokół.';
  }

  @override
  String exMinesTotalSafe(Object cell) {
    return '$cell jest bezpieczne: wszystkie miny są już znalezione.';
  }

  @override
  String exMinesTotalMine(Object cell) {
    return 'W $cell jest mina: pozostałe miny zajmują wszystkie zakryte pola.';
  }

  @override
  String exMinesPairSafe(Object cell, Object a, Object b) {
    return '$cell jest bezpieczne: z porównania liczb w $a i $b wynika, że ich miny leżą gdzie indziej.';
  }

  @override
  String exMinesPairMine(Object cell, Object a, Object b) {
    return 'W $cell jest mina: z porównania liczb w $a i $b wynika, że brakujące miny leżą właśnie tu.';
  }

  @override
  String exMinesFailNumber(Object number) {
    return 'Ale wtedy liczba w $number nie może się zgadzać.';
  }

  @override
  String get exMinesFailTotal => 'Ale wtedy liczba min się nie zgadza.';

  @override
  String exMinesFailPair(Object a, Object b) {
    return 'Ale wtedy liczby w $a i $b nie mogą się obie zgadzać.';
  }

  @override
  String exShikakuSuppose(Object clue, Object rect) {
    return 'Załóżmy, że liczba w $clue zajmuje $rect.';
  }

  @override
  String exShikakuRefuted(Object clue, Object rect) {
    return 'Liczba w $clue nie może zajmować $rect: to prowadzi do sprzeczności.';
  }

  @override
  String exShikakuOverlap(Object clue, Object other) {
    return 'Prostokąty dla $clue, które nachodzą na prostokąt $other, odpadają.';
  }

  @override
  String exShikakuOwner(Object clue, Object cell) {
    return 'Tylko liczba w $clue może jeszcze pokryć $cell, więc jej prostokąt musi je objąć.';
  }

  @override
  String exShikakuCommon(Object clue, Object cell, Object other) {
    return 'Każdy prostokąt pozostały dla $clue pokrywa $cell, więc prostokąty dla $other, które je pokrywają, odpadają.';
  }

  @override
  String exShikakuFixed(Object clue, Object rect) {
    return 'Liczba w $clue zajmuje $rect: to jedyny prostokąt, jaki jej został.';
  }

  @override
  String exShikakuFailNone(Object clue) {
    return 'Ale wtedy dla liczby w $clue nie zostaje żaden prostokąt.';
  }

  @override
  String exShikakuFailUncovered(Object cell) {
    return 'Ale wtedy nic nie pokryje $cell.';
  }

  @override
  String exAtomsSuppose(Object edge, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wiązania',
      many: '$count wiązań',
      few: '$count wiązania',
      one: 'jedno wiązanie',
      zero: 'zero wiązań',
    );
    return 'Załóżmy, że $edge ma $_temp0.';
  }

  @override
  String exAtomsRefutedMore(Object edge, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wiązania',
      many: '$count wiązań',
      few: '$count wiązania',
      one: 'jedno wiązanie',
    );
    return '$edge ma co najmniej $_temp0: mniej prowadzi do sprzeczności.';
  }

  @override
  String exAtomsRefutedLess(int count, Object edge) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$edge ma co najwyżej $count wiązania: więcej prowadzi do sprzeczności.',
      many: '$edge ma co najwyżej $count wiązań: więcej prowadzi do sprzeczności.',
      few: '$edge ma co najwyżej $count wiązania: więcej prowadzi do sprzeczności.',
      one: '$edge ma co najwyżej jedno wiązanie: więcej prowadzi do sprzeczności.',
      zero: '$edge nie ma wiązań: każde wiązanie prowadzi tam do sprzeczności.',
    );
    return '$_temp0';
  }

  @override
  String exAtomsAtLeast(Object edge, int count, Object atom) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wiązania',
      many: '$count wiązań',
      few: '$count wiązania',
      one: 'jedno wiązanie',
    );
    return '$edge ma co najmniej $_temp0: inaczej atom w $atom nie osiągnie swojej liczby.';
  }

  @override
  String exAtomsAtMost(int count, Object edge, Object atom) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$edge ma co najwyżej $count wiązania: więcej przekroczyłoby liczbę atomu w $atom.',
      many: '$edge ma co najwyżej $count wiązań: więcej przekroczyłoby liczbę atomu w $atom.',
      few: '$edge ma co najwyżej $count wiązania: więcej przekroczyłoby liczbę atomu w $atom.',
      one: '$edge ma co najwyżej jedno wiązanie: więcej przekroczyłoby liczbę atomu w $atom.',
      zero: '$edge nie ma wiązań: każde przekroczyłoby liczbę atomu w $atom.',
    );
    return '$_temp0';
  }

  @override
  String exAtomsCross(Object edge, Object other) {
    return '$edge nie ma wiązań: przecięłyby wiązanie $other.';
  }

  @override
  String exAtomsFailSum(Object atom) {
    return 'Ale wtedy atom w $atom nie dostanie swojej liczby wiązań.';
  }

  @override
  String exAtomsFailCross(Object a, Object b) {
    return 'Ale wtedy wiązania $a i $b się krzyżują.';
  }

  @override
  String get exAtomsFailConnect => 'Ale wtedy atomy nie połączą się w jedną cząsteczkę.';

  @override
  String exTrailSupposeOn(Object edge) {
    return 'Załóżmy, że ścieżka przechodzi $edge.';
  }

  @override
  String exTrailSupposeOff(Object edge) {
    return 'Załóżmy, że ścieżka nie przechodzi $edge.';
  }

  @override
  String exTrailRefutedOn(Object edge) {
    return 'Ścieżka przechodzi $edge: inaczej powstaje sprzeczność.';
  }

  @override
  String exTrailRefutedOff(Object edge) {
    return 'Ścieżka nie przechodzi $edge: inaczej powstaje sprzeczność.';
  }

  @override
  String exTrailDegreeDone(Object edge, Object cell) {
    return 'Ścieżka nie przechodzi $edge: już wchodzi do $cell i z niego wychodzi.';
  }

  @override
  String exTrailEndDone(Object edge, Object cell) {
    return 'Ścieżka nie przechodzi $edge: jej koniec w $cell jest już połączony.';
  }

  @override
  String exTrailDegreeNeed(Object edge, Object cell) {
    return 'Ścieżka przechodzi $edge: ścieżka przez $cell nie ma innej drogi.';
  }

  @override
  String exTrailLoop(Object edge) {
    return 'Ścieżka nie przechodzi $edge: zamknęłoby to pętlę.';
  }

  @override
  String exTrailOrder(Object edge) {
    return 'Ścieżka nie przechodzi $edge: połączyłoby to liczby nie po kolei.';
  }

  @override
  String exTrailEarly(Object edge) {
    return 'Ścieżka nie przechodzi $edge: połączyłoby to początek z końcem, zanim odwiedzi wszystkie pola.';
  }

  @override
  String exTrailFailBranch(Object cell) {
    return 'Ale wtedy ścieżka rozgałęzia się w $cell.';
  }

  @override
  String exTrailFailStuck(Object cell) {
    return 'Ale wtedy ścieżka utyka w $cell.';
  }

  @override
  String get exTrailFailOrder => 'Ale wtedy liczby idą nie po kolei.';

  @override
  String get exTrailFailLoop => 'Ale wtedy część pól zamyka się w osobną pętlę.';

  @override
  String get exTrailFailConnect => 'Ale wtedy ścieżka nie dotrze do każdego pola.';

  @override
  String exLinksSupposeOn(Object edge) {
    return 'Załóżmy, że ścieżka biegnie $edge.';
  }

  @override
  String exLinksSupposeOff(Object edge) {
    return 'Załóżmy, że żadna ścieżka nie biegnie $edge.';
  }

  @override
  String exLinksRefutedOn(Object edge) {
    return 'Ścieżka biegnie $edge: inaczej powstaje sprzeczność.';
  }

  @override
  String exLinksRefutedOff(Object edge) {
    return 'Żadna ścieżka nie biegnie $edge: ścieżka tam prowadzi do sprzeczności.';
  }

  @override
  String exLinksDegreeDone(Object edge, Object cell) {
    return 'Żadna ścieżka nie biegnie $edge: ścieżka już wchodzi do $cell i z niego wychodzi.';
  }

  @override
  String exLinksDotDone(Object edge, Object cell) {
    return 'Żadna ścieżka nie biegnie $edge: ścieżka z kropki w $cell już z niej wychodzi.';
  }

  @override
  String exLinksDegreeNeed(Object edge, Object cell) {
    return 'Ścieżka biegnie $edge: ścieżka przez $cell nie ma innej drogi.';
  }

  @override
  String exLinksDotNeed(Object edge, Object cell) {
    return 'Ścieżka biegnie $edge: to jedyne wyjście, jakie zostało z kropki w $cell.';
  }

  @override
  String exLinksLoop(Object edge) {
    return 'Żadna ścieżka nie biegnie $edge: zamknęłoby to pętlę.';
  }

  @override
  String exLinksMixed(Object edge) {
    return 'Żadna ścieżka nie biegnie $edge: połączyłoby to ścieżki dwóch różnych par.';
  }

  @override
  String exLinksFailBranch(Object cell) {
    return 'Ale wtedy ścieżka rozgałęzia się w $cell.';
  }

  @override
  String exLinksFailStuck(Object cell) {
    return 'Ale wtedy ścieżka utyka w $cell.';
  }

  @override
  String get exLinksFailLoop => 'Ale wtedy ścieżka zamyka się w pętlę.';

  @override
  String get exLinksFailMixed => 'Ale wtedy jedna ścieżka łączy dwie różne pary.';

  @override
  String get tallyName => 'Sumy';

  @override
  String get tallyTagline => 'Skreślaj liczby, aż każda linia się zsumuje';

  @override
  String get tallyRules =>
      '• W każdym polu jest liczba. Skreśl niektóre z nich.\n• Liczby, które zostaną w każdym wierszu i kolumnie, muszą dać w sumie liczbę poza siatką.\n\nDotknij pola, aby przełączać: skreślone → w kółku (twoja notatka „zostaje”) → puste. Długie naciśnięcie / prawy przycisk przełącza wstecz. Kółka są opcjonalne: zagadka jest rozwiązana, gdy właściwe liczby są skreślone.';

  @override
  String get tutTally1 =>
      'Skreślaj liczby tak, aby pozostałe w każdym wierszu i kolumnie dawały w sumie liczbę na zewnątrz. Dotknij liczby raz, aby ją skreślić. Siódemka nie może zostać w wierszu o sumie 2.';

  @override
  String get tutTally2 =>
      'Liczba większa niż suma jej wiersza lub kolumny zawsze odpada. Zaznaczona 8 stoi w wierszu o sumie 6: skreśl ją, a potem dokończ planszę.';

  @override
  String get tutTally3 =>
      'Liczby górnego wiersza dają razem 15, a potrzeba 12, więc odpaść może tylko 3: 8 i 4 muszą zostać. Dotknij dwa razy, aby wziąć w kółko liczbę, która zostaje, a potem dokończ planszę.';

  @override
  String get tutTally4 =>
      'Teraz prawdziwa plansza. Zacznij od linii o małej sumie albo bliskiej sumie wszystkich ich liczb.';

  @override
  String get tutTallyS1 =>
      'Wypróbuj każdy sposób na uzyskanie sumy linii. Liczba użyta w każdym sposobie zostaje, a nieużyta w żadnym odpada: 7 z 5, 4 i 3 to tylko 4 + 3, więc 5 odpada.';

  @override
  String get tutTallyS2 =>
      'Trudna plansza. Gdy utkniesz, skreśl liczbę i śledź sumy: jeśli jakiś wiersz lub kolumna nie może się już zgodzić, ta liczba zostaje.';

  @override
  String exTallySupposeKeep(Object cell) {
    return 'Załóżmy, że $cell zostaje.';
  }

  @override
  String exTallySupposeCross(Object cell) {
    return 'Załóżmy, że $cell jest skreślone.';
  }

  @override
  String exTallyRefutedKeep(Object cell) {
    return '$cell zostaje: skreślenie prowadzi do sprzeczności.';
  }

  @override
  String exTallyRefutedCross(Object cell) {
    return '$cell jest skreślone: pozostawienie prowadzi do sprzeczności.';
  }

  @override
  String exTallyRowTooBig(Object cell, Object row, int digit, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'jego $digit to więcej, niż wierszowi $row jeszcze brakuje ($left)',
      zero: 'wiersz $row ma już swoją sumę',
    );
    return '$cell jest skreślone: $_temp0.';
  }

  @override
  String exTallyColTooBig(Object cell, Object col, int digit, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: 'jego $digit to więcej, niż kolumnie $col jeszcze brakuje ($left)',
      zero: 'kolumna $col ma już swoją sumę',
    );
    return '$cell jest skreślone: $_temp0.';
  }

  @override
  String exTallyRowNeeded(Object cell, Object row, int digit, int sum) {
    return '$cell zostaje: bez jego $digit wiersz $row nie osiągnie $sum.';
  }

  @override
  String exTallyColNeeded(Object cell, Object col, int digit, int sum) {
    return '$cell zostaje: bez jego $digit kolumna $col nie osiągnie $sum.';
  }

  @override
  String exTallyRowEveryKeep(Object cell, Object row, int sum) {
    return '$cell zostaje: każdy sposób na $sum w wierszu $row go używa.';
  }

  @override
  String exTallyColEveryKeep(Object cell, Object col, int sum) {
    return '$cell zostaje: każdy sposób na $sum w kolumnie $col go używa.';
  }

  @override
  String exTallyRowEveryCross(Object cell, Object row, int sum) {
    return '$cell jest skreślone: żaden sposób na $sum w wierszu $row go nie używa.';
  }

  @override
  String exTallyColEveryCross(Object cell, Object col, int sum) {
    return '$cell jest skreślone: żaden sposób na $sum w kolumnie $col go nie używa.';
  }

  @override
  String exTallyFailRowOver(Object row, int sum) {
    return 'Ale wtedy wiersz $row daje więcej niż $sum.';
  }

  @override
  String exTallyFailColOver(Object col, int sum) {
    return 'Ale wtedy kolumna $col daje więcej niż $sum.';
  }

  @override
  String exTallyFailRowShort(Object row, int sum) {
    return 'Ale wtedy wiersz $row nie osiągnie już $sum.';
  }

  @override
  String exTallyFailColShort(Object col, int sum) {
    return 'Ale wtedy kolumna $col nie osiągnie już $sum.';
  }

  @override
  String exTallyFailRowNoWay(Object row, int sum) {
    return 'Ale wtedy żaden wybór liczb z wiersza $row nie daje $sum.';
  }

  @override
  String exTallyFailColNoWay(Object col, int sum) {
    return 'Ale wtedy żaden wybór liczb z kolumny $col nie daje $sum.';
  }

  @override
  String get formulaName => 'Formuła';

  @override
  String get formulaTagline => 'Odgadnij ukryte równanie';

  @override
  String get formulaRules =>
      '• Ukryte jest równanie. Znajdź je w sześciu próbach.\n• Każda próba musi być prawdziwym równaniem na cały rząd: działanie, potem = i jego wynik.\n• Każda płytka próby dostaje oznaczenie. Wypełniona: właściwy symbol na właściwym miejscu. W ramce: jest w równaniu, ale gdzie indziej. Wyblakła: nie ma go w równaniu (albo nie aż tyle razy).\n• Zwykła kolejność działań: najpierw nawiasy, potem potęgi, potem × i ÷, potem + i −.\n\nŁatwe równania tylko dodają i odejmują, średnie także mnożą lub dzielą, trudne mają nawiasy lub potęgi (3² = 3 × 3, 2³ = 2 × 2 × 2). Klawisze pamiętają oznaczenia. Dotknij płytki, by w niej pisać. Próby nie da się cofnąć; gdy skończą się rzędy, zacznij od nowa.';

  @override
  String get formulaIncomplete => 'Najpierw wypełnij cały rząd';

  @override
  String get formulaMalformed => 'To nie równanie: działanie, potem = i liczba';

  @override
  String get formulaUntrue => 'Strony nie są równe';

  @override
  String get formulaOutOfGuesses => 'Koniec prób: zacznij od nowa';

  @override
  String formulaSolvedIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rozwiązano w $count próbach',
      one: 'Za pierwszym razem!',
    );
    return '$_temp0';
  }

  @override
  String get tutFormula1 =>
      'Za tą planszą kryje się równanie. Każda próba to prawdziwe równanie na cały rząd. Wpisz 1+4=5 (albo dowolne inne) i naciśnij „Sprawdź”.';

  @override
  String get tutFormula2 =>
      'Próba oznacza swoje płytki. Wypełniona: właściwy symbol na właściwym miejscu. W ramce: jest w równaniu, ale gdzie indziej. Wyblakła: nie ma go. Tutaj = jest na miejscu, 4, 5 i 9 stoją gdzie indziej, a + nie ma. Znajdź równanie.';

  @override
  String get tutFormula3 =>
      'Pierwsza 2 jest na miejscu, a druga wyblakła: w równaniu jest tylko jedna 2. Klawisze na dole pamiętają każde oznaczenie. Dokończ planszę.';

  @override
  String get tutFormula4 =>
      'Teraz prawdziwa plansza: sześć prób na równanie z sześciu płytek. Jest w nim tylko dodawanie lub odejmowanie.';

  @override
  String get tutFormulaS1 =>
      'Zacznij od próby, która sprawdza wiele różnych symboli: im więcej płytek dostanie oznaczenie, tym więcej wiesz. Wpisz równanie z co najmniej siedmioma różnymi symbolami, na przykład 9×8−7=65.';

  @override
  String get tutFormulaS2 =>
      'Trudne plansze mają nawiasy i potęgi: 3² to 3 × 3, 2³ to 2 × 2 × 2. Najpierw liczy się nawiasy, potem potęgi, potem × i ÷, potem + i −. Znajdź równanie.';

  @override
  String get tutFormulaS3 =>
      'Największa: dziesięć płytek z nawiasem lub potęgą. Najpierw znajdź miejsce znaku =: zdradza długość wyniku.';

  @override
  String get orbitsName => 'Orbity';

  @override
  String get orbitsTagline => 'Daj każdej gwieździe obszar, który obraca się wokół niej';

  @override
  String get orbitsRules =>
      '• Podziel całą planszę na obszary, po jednym dla każdej gwiazdy.\n• Obszar to jeden spójny kawałek z gwiazdą dokładnie pośrodku.\n• Po półobrocie wokół gwiazdy obszar wygląda tak samo: każde pole ma bliźniaka po przeciwnej stronie gwiazdy.\n\nPrzeciągaj od gwiazdy albo od pola jej obszaru po polach, które chcesz dodać; każde zabiera ze sobą bliźniaka. Albo dotknij gwiazdy, aby ją wybrać, a potem pól, które chcesz jej dać, także tych z dala od jej obszaru. Dotknij pola wybranej gwiazdy (albo dowolnego wypełnionego pola, gdy żadna gwiazda nie jest wybrana), aby wyczyścić je i jego bliźniaka.';

  @override
  String get tutOrbits1 =>
      'Podziel planszę na obszary, po jednym dla każdej gwiazdy. Gwiazda leży dokładnie pośrodku swojego obszaru, więc każde pole ma bliźniaka po przeciwnej stronie. Przeciągnij od gwiazdy w prawej kolumnie do pola nad nią: bliźniak poniżej też się wypełni.';

  @override
  String get tutOrbits2 =>
      'Gwiazda może leżeć wewnątrz pola, na linii między dwoma polami albo na rogu, gdzie stykają się cztery. Pola, których dotyka, należą do niej od początku. Przydziel każde pozostałe pole jakiejś gwieździe: przeciągnij od gwiazdy albo dotknij gwiazdy, a potem pól. Dotknij pola wybranej gwiazdy, aby wyczyścić je i jego bliźniaka.';

  @override
  String get tutOrbits3 =>
      'Obszar może mieć dowolny kształt, o ile jest w jednym kawałku i po półobrocie wokół gwiazdy wygląda tak samo. Pole nie może dołączyć do gwiazdy, jeśli jego bliźniak wypadłby poza planszę albo na pole innej gwiazdy.';

  @override
  String get tutOrbits4 =>
      'Teraz prawdziwa plansza. Zacznij od pól, które może wziąć tylko jedna gwiazda: warto szukać w rogach i przy krawędziach.';

  @override
  String get tutOrbitsS1 =>
      'Pilnuj, by obszary były w jednym kawałku. Gdy pole należy do gwiazdy, ale nie jest z nią jeszcze połączone, sprawdź, jak można je połączyć: pole, przez które prowadzi każda droga, też należy do gwiazdy, tak jak jego bliźniak.';

  @override
  String get tutOrbitsS2 =>
      'Trudna plansza. Gdy nic nie jest pewne, wybierz pole, które mogą wziąć tylko dwie gwiazdy, i wypróbuj jedną: jeśli jakieś pole zostaje wtedy bez żadnej gwiazdy, pole należy do drugiej gwiazdy.';

  @override
  String exOrbitsOnly(Object cell, Object star) {
    return '$cell należy do gwiazdy na $star: żadna inna gwiazda nie może go wziąć.';
  }

  @override
  String exOrbitsTwin(Object cell, Object star, Object other) {
    return '$cell należy do gwiazdy na $star: to bliźniak $other.';
  }

  @override
  String exOrbitsBridge(Object cell, Object star, Object other) {
    return '$cell należy do gwiazdy na $star: bez niego $other byłoby odcięte od tej gwiazdy.';
  }

  @override
  String exOrbitsTwinOut(Object cell, Object star, Object other) {
    return '$cell nie może należeć do gwiazdy na $star: jego bliźniak $other nie może.';
  }

  @override
  String exOrbitsReach(Object cell, Object star) {
    return '$cell nie może należeć do gwiazdy na $star: nie da się go już połączyć z tą gwiazdą.';
  }

  @override
  String exOrbitsFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żadna gwiazda.';
  }

  @override
  String exOrbitsSuppose(Object cell, Object star) {
    return 'Załóżmy, że $cell należy do gwiazdy na $star.';
  }

  @override
  String exOrbitsRefuted(Object cell, Object star) {
    return '$cell nie może należeć do gwiazdy na $star: to prowadzi do sprzeczności.';
  }

  @override
  String get inlayName => 'Intarsja';

  @override
  String get inlayTagline => 'Dopasuj każdy element do kształtu';

  @override
  String get inlayRules =>
      '• Wypełnij kształt wszystkimi elementami z tacki. Każde pole kształtu musi być zakryte, a elementy nie mogą na siebie nachodzić.\n• Wygrywa każdy sposób, w jaki mieszczą się wszystkie elementy.\n• Elementy można obracać. Na trudnych planszach można je też odwracać.\n\nPrzeciągnij element na kształt: przyciągnie się do pól. Przeciągnij ułożony element, by go przesunąć, albo poza kształt, by odłożyć go na tackę. Dotknij elementu, by obrócić go o ćwierć obrotu. Na trudnych planszach „Odwróć” robi lustrzane odbicie elementu, którego dotknąłeś ostatnio (na komputerze kliknij element prawym przyciskiem).';

  @override
  String get inlayFlip => 'Odwróć';

  @override
  String get inlayNoRoom => 'Brak miejsca, by go tu obrócić';

  @override
  String get tutInlay1 =>
      'Przeciągnij każdy element z tacki na kształt. Przyciągnie się do pól. Zakryj elementami cały kształt.';

  @override
  String get tutInlay2 =>
      'Dotknij elementu, by obrócić go o ćwierć obrotu, na tacce albo na planszy. Obróć te elementy tak, żeby się zmieściły.';

  @override
  String get tutInlay3 =>
      'Belka na planszy nie zostawia miejsca innym elementom. Przeciągnij ułożony element, by go przesunąć, albo poza kształt, by odłożyć go na tackę.';

  @override
  String get tutInlay4 =>
      'Na trudnych planszach element można też odwrócić. Dotknij elementu, a potem „Odwróć” (na komputerze kliknij go prawym przyciskiem). Jeden element mieści się tu tylko odwrócony.';

  @override
  String get tutInlay5 => 'Teraz prawdziwa plansza. Wygrywa każdy sposób, w jaki mieszczą się wszystkie elementy.';

  @override
  String get tutInlayS1 =>
      'Zacznij tam, gdzie elementy mają najmniej dróg: w rogach, wąskich wypustkach i małych zakamarkach. Pole na końcu wypustki ma tylko jednego sąsiada: znajdź element, który się tam mieści, i połóż go najpierw.';

  @override
  String get tutInlayS2 =>
      'Najpierw układaj największe i najbardziej nieporęczne elementy, póki jest na nie miejsce; małe wypełnią ostatnie luki. Uważaj na zakamarki: luka mniejsza niż każdy pozostały element oznacza, że któryś element trzeba przesunąć. Na trudnych planszach niektóre elementy mieszczą się tylko odwrócone.';

  @override
  String get skylineName => 'Panorama';

  @override
  String get skylineTagline => 'Ile wież widać z każdej strony?';

  @override
  String get skylineRules =>
      '• Postaw w każdym polu wieżę o wysokości od 1 do N pięter (N = rozmiar siatki).\n• W każdym wierszu i kolumnie każda wysokość występuje dokładnie raz.\n• Liczba poza siatką mówi, ile wież widać z tego miejsca, patrząc wzdłuż wiersza lub kolumny: wieża zasłania wszystkie niższe za nią.\n\nWybierz wysokość z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem wysokości. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole.';

  @override
  String get tutSkyline1 =>
      'Zbuduj panoramę: w każdym wierszu i kolumnie stoi po jednej wieży każdej wysokości od 1 do 4. Tu jednej brakuje: wybierz jej wysokość w palecie i dotknij pustego pola.';

  @override
  String get tutSkyline2 =>
      'Wskazówka liczy wieże widoczne z jej strony: każda wieża zasłania niższe za nią. Wskazówka z lewej strony górnego wiersza to 2. Wypełnij puste pola tak, by widać było stamtąd tylko dwie wieże.';

  @override
  String get tutSkyline3 =>
      '1 znaczy, że najwyższa wieża stoi tuż przy wskazówce i zasłania wszystkie inne. 4 znaczy, że widać wszystkie wieże, więc rosną po kolei: 1, 2, 3, 4. Wypełnij wiersz.';

  @override
  String get tutSkyline4 =>
      'Teraz cała plansza. Zapisuj ołówkiem wysokości, które jeszcze pasują do pola, a wskazówki niech je zawężają.';

  @override
  String get tutSkylineS1 =>
      'Najwyższa wieża zasłania wszystko za sobą, więc przy 3 nie stoi w dwóch pierwszych polach. Ogólnie przy dużej wskazówce wieże muszą być niskie: obok 3 na planszy 5×5 najwyżej 3 piętra.';

  @override
  String get tutSkylineS2 =>
      'Utknąłeś? Weź wiersz lub kolumnę ze wskazówkami i przejrzyj wszystkie sposoby wypełnienia, które pasują do twoich notatek i wskazówek. Wysokość, która nigdy nie trafia do pola, można tam skreślić.';

  @override
  String get tutSkylineS3 =>
      'Najtrudniejsze plansze wymagają założenia, które da się obalić. Załóż, że w polu jest jedna z dwóch lub trzech ostatnich wysokości, i rozumuj dalej; jeśli dojdziesz do sprzeczności, skreśl tę wysokość.';

  @override
  String exLatinNaked(Object cell, Object value) {
    return 'W $cell musi być $value: wszystkie inne liczby są tam wykluczone.';
  }

  @override
  String exLatinHiddenRow(Object cell, Object value, Object row) {
    return 'W $cell musi być $value: to jedyne miejsce na $value w wierszu $row.';
  }

  @override
  String exLatinHiddenCol(Object cell, Object value, Object col) {
    return 'W $cell musi być $value: to jedyne miejsce na $value w kolumnie $col.';
  }

  @override
  String exLatinPairRow(Object a, Object b, Object v1, Object v2, Object row) {
    return 'W $a i $b mogą być tylko $v1 i $v2, więc w reszcie wiersza $row tych liczb nie będzie.';
  }

  @override
  String exLatinPairCol(Object a, Object b, Object v1, Object v2, Object col) {
    return 'W $a i $b mogą być tylko $v1 i $v2, więc w reszcie kolumny $col tych liczb nie będzie.';
  }

  @override
  String exLatinFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żadna liczba.';
  }

  @override
  String exLatinFailNoPlaceRow(Object value, Object row) {
    return 'Ale wtedy $value nie ma już miejsca w wierszu $row.';
  }

  @override
  String exLatinFailNoPlaceCol(Object value, Object col) {
    return 'Ale wtedy $value nie ma już miejsca w kolumnie $col.';
  }

  @override
  String exSkylineBound(Object clue, Object side, Object cell, Object max) {
    return 'Wskazówka $clue przy $side wymaga tylu widocznych wież, więc w $cell jest najwyżej $max.';
  }

  @override
  String exSkylineTallest(Object cell, Object value, Object side) {
    return 'W $cell musi być $value: wskazówka 1 przy $side widzi tylko najwyższą wieżę.';
  }

  @override
  String exSkylineLineRow(Object cell, Object value, Object row) {
    return 'W $cell nie może być $value: żaden sposób wypełnienia wiersza $row zgodny z jego wskazówkami jej tam nie stawia.';
  }

  @override
  String exSkylineLineCol(Object cell, Object value, Object col) {
    return 'W $cell nie może być $value: żaden sposób wypełnienia kolumny $col zgodny z jej wskazówkami jej tam nie stawia.';
  }

  @override
  String exSkylineFailRow(Object row) {
    return 'Ale wtedy wiersza $row nie da się wypełnić zgodnie z jego wskazówkami.';
  }

  @override
  String exSkylineFailCol(Object col) {
    return 'Ale wtedy kolumny $col nie da się wypełnić zgodnie z jej wskazówkami.';
  }

  @override
  String get famLatin => 'Kwadraty łacińskie';

  @override
  String get famLatinAbout => 'Każda liczba raz w każdym wierszu i kolumnie, a wskazówki mówią więcej';

  @override
  String get cagesName => 'Klatki';

  @override
  String get cagesTagline => 'Dodawaj, odejmuj, mnóż i dziel, by wypełnić każdą klatkę';

  @override
  String get cagesRules =>
      '• Wypełnij siatkę liczbami od 1 do N (N = rozmiar siatki), każdą raz w każdym wierszu i kolumnie.\n• Grube kontury dzielą siatkę na klatki. Liczby w klatce dają wskazówkę z jej rogu wskazanym działaniem: suma (+), iloczyn (×), a w klatce z dwóch pól większa minus mniejsza (−) albo większa podzielona przez mniejszą (÷). Klatka z jednego pola po prostu zawiera swoją liczbę.\n• Liczba może się powtarzać w klatce, jeśli nie w tym samym wierszu ani kolumnie.\n\nWybierz liczbę z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem liczby. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole.';

  @override
  String get tutCages1 =>
      'W każdym wierszu i kolumnie liczby od 1 do 4 występują raz. Kontury łączą pola w klatki, a liczby w klatce dają jej wskazówkę: w klatce 7+ sumują się do 7. Wypełnij puste pola.';

  @override
  String get tutCages2 =>
      'W klatce z dwóch pól − to większa liczba minus mniejsza, a ÷ większa podzielona przez mniejszą; większa może stać w dowolnym z nich. Wypełnij dwa górne wiersze.';

  @override
  String get tutCages3 =>
      '× mnoży. Liczba może się powtarzać w klatce, jeśli nie występuje dwa razy w wierszu ani kolumnie, jak 1 × 2 × 1 dla 2×. Same wiersze i kolumny pozwalają tu na dwa sposoby: niech klatki wybiorą jeden.';

  @override
  String get tutCages4 =>
      'Teraz cała plansza. Zacznij od klatek, które da się złożyć na niewiele sposobów, zapisuj ołówkiem, co jeszcze pasuje do pola, a wiersze i kolumny niech to zawężają.';

  @override
  String get tutCagesS1 =>
      'Przejrzyj sposoby złożenia klatki. Dwa pola dające 3+ to tylko 1 i 2; 4− na planszy 5×5 to 1 i 5. Liczbę, której żaden sposób nie stawia w polu, można tam skreślić.';

  @override
  String get tutCagesS2 =>
      'Jeśli każdy sposób wypełnienia klatki stawia jakąś liczbę w jej polach jednego wiersza, w reszcie wiersza tej liczby nie będzie. 2÷ w wierszu na planszy 5×5 to 1 i 2 albo 2 i 4: dwójka tak czy inaczej. A gdy dwa pola wiersza mogą mieć tylko te same dwie liczby, te liczby są ich.';

  @override
  String get tutCagesS3 =>
      'Najtrudniejsze plansze wymagają założenia, które da się obalić. Załóż, że w polu jest jedna z dwóch lub trzech ostatnich liczb, i rozumuj dalej; jeśli dojdziesz do sprzeczności, skreśl tę liczbę.';

  @override
  String exCagesSingle(Object cell, Object value) {
    return 'W $cell musi być $value: jego klatka to tylko to jedno pole.';
  }

  @override
  String exCagesCombo(Object clue, Object cage, Object values, Object cell) {
    return 'Żaden sposób wypełnienia klatki $clue w $cage nie stawia $values w $cell.';
  }

  @override
  String exCagesRequiredRow(Object clue, Object cage, Object values, Object row, Object cell) {
    return 'Każdy sposób wypełnienia klatki $clue w $cage stawia $values w jej polach w wierszu $row, a więc nie w $cell.';
  }

  @override
  String exCagesRequiredCol(Object clue, Object cage, Object values, Object col, Object cell) {
    return 'Każdy sposób wypełnienia klatki $clue w $cage stawia $values w jej polach w kolumnie $col, a więc nie w $cell.';
  }

  @override
  String exCagesFail(Object clue, Object cage) {
    return 'Ale wtedy klatki $clue w $cage nie da się wypełnić.';
  }

  @override
  String get signsName => 'Znaki';

  @override
  String get signsTagline => 'Idź za znakami: która liczba jest większa?';

  @override
  String get signsRules =>
      '• Wypełnij siatkę liczbami od 1 do N (N = rozmiar siatki), każdą raz w każdym wierszu i kolumnie.\n• Znak między dwoma sąsiednimi polami wskazuje ostrzem mniejszą liczbę, jak w 2 < 3: otwartą stroną zwrócony jest ku większej. Znaki działają w wierszach i w kolumnach.\n• Kilka liczb może być podanych.\n\nWybierz liczbę z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem liczby. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole.';

  @override
  String get tutSigns1 =>
      'Każdy wiersz i kolumna zawiera 1–4 po razie. Znak między dwoma polami wskazuje mniejszą liczbę, jak w 1 < 2, i działa też w pionie. Same wiersze i kolumny dopuszczają tu dwa sposoby: niech znaki wybiorą jeden.';

  @override
  String get tutSigns2 =>
      'Znaki mogą tworzyć łańcuch: każde pole trzeciego wiersza jest większe od następnego. Pierwsze ma za sobą trzy mniejsze, więc to 4, a ostatnie to 1. Wypełnij dwa dolne wiersze.';

  @override
  String get tutSigns3 =>
      'Drugie pole drugiego wiersza jest większe od obu sąsiadów. Potrzebują one dwóch różnych mniejszych liczb, więc nie może to być 1 ani 2. Wypełnij dwa górne wiersze.';

  @override
  String get tutSigns4 =>
      'Teraz cała plansza. Zacznij tam, gdzie jest dużo znaków albo podana liczba, notuj ołówkiem, co jeszcze może być w polu, i pozwól wierszom i kolumnom zawęzić wybór.';

  @override
  String get tutSignsS1 =>
      'Idź za znakami. Pole mniejsze od sąsiada nie sięga największej liczby, jaka może jeszcze być u sąsiada, a większe nie schodzi do jego najmniejszej. W łańcuchu a < b < c pierwsze jest co najwyżej N − 2. Skreślaj to, co wykluczają znaki.';

  @override
  String get tutSignsS2 =>
      'Pole większe od obu sąsiadów w wierszu potrzebuje pod sobą dwóch różnych liczb, więc ma co najmniej 3; ciąg znaków liczy się tak samo. A gdy dwa pola wiersza mogą zawierać tylko te same dwie liczby, te liczby są ich.';

  @override
  String get tutSignsS3 =>
      'Najtrudniejsze plansze wymagają założenia, które da się obalić. Załóż, że w polu jest jedna z dwóch lub trzech ostatnich liczb, i rozumuj dalej; jeśli dojdziesz do sprzeczności, skreśl tę liczbę.';

  @override
  String exSignsLess(Object cell, Object other, Object limit, Object values) {
    return '$cell jest mniejsze od $other, gdzie jest co najwyżej $limit, więc w $cell nie może być $values.';
  }

  @override
  String exSignsMore(Object cell, Object other, Object limit, Object values) {
    return '$cell jest większe od $other, gdzie jest co najmniej $limit, więc w $cell nie może być $values.';
  }

  @override
  String exSignsBelowRow(Object cell, Object cells, Object row, Object values) {
    return '$cell jest mniejsze od każdego z $cells, wszystkich w wierszu $row: potrzebują różnych liczb większych od niego, więc w $cell nie może być $values.';
  }

  @override
  String exSignsBelowCol(Object cell, Object cells, Object col, Object values) {
    return '$cell jest mniejsze od każdego z $cells, wszystkich w kolumnie $col: potrzebują różnych liczb większych od niego, więc w $cell nie może być $values.';
  }

  @override
  String exSignsAboveRow(Object cell, Object cells, Object row, Object values) {
    return '$cell jest większe od każdego z $cells, wszystkich w wierszu $row: potrzebują różnych liczb mniejszych od niego, więc w $cell nie może być $values.';
  }

  @override
  String exSignsAboveCol(Object cell, Object cells, Object col, Object values) {
    return '$cell jest większe od każdego z $cells, wszystkich w kolumnie $col: potrzebują różnych liczb mniejszych od niego, więc w $cell nie może być $values.';
  }

  @override
  String get soloName => 'Solo';

  @override
  String get soloTagline => 'Zamaluj powtórki, aż każda liczba zostanie sama';

  @override
  String get soloRules =>
      '• W każdym polu jest liczba. Zamaluj niektóre z nich tak, aby żadna liczba nie powtarzała się w wierszu ani kolumnie.\n• Zamalowane pola nigdy nie stykają się bokami.\n• Pozostałe pola tworzą jeden spójny obszar.\n• Zamalować można tylko liczbę, która nadal widnieje niezamalowana gdzieś w jej wierszu lub kolumnie.\n\nDotknij pola, aby przełączać: zamalowane → w kółku (twoja notatka „zostaje”) → puste. Długie naciśnięcie / prawy przycisk przełącza wstecz. Kółka są opcjonalne: zagadka jest rozwiązana, gdy właściwe liczby są zamalowane.';

  @override
  String get tutSolo1 =>
      'Zamaluj liczby tak, aby żadna nie powtarzała się w wierszu ani kolumnie. Zamalowane pola nie stykają się bokami, a pozostałe tworzą jedną całość. Zamalowuj tylko liczby, które się powtarzają. Dotknij pola, aby je zamalować.';

  @override
  String get tutSolo2 =>
      'Zamalowane pola się nie stykają, więc liczby obok zamalowanego pola zostają. Lewa górna 1 jest zamalowana: dotknij dwa razy zaznaczonych liczb, aby wziąć je w kółko (twoja notatka, że zostają), a potem dokończ planszę.';

  @override
  String get tutSolo3 =>
      'Dwie równe liczby z jednym polem pomiędzy: jedna z nich jest zamalowana, a każda z nich dotykałaby środkowego pola, więc środkowa liczba zostaje. Weź w kółko zaznaczoną 1, a potem dokończ planszę.';

  @override
  String get tutSolo4 =>
      'Pozostałe pola muszą tworzyć jedną całość. Gdy 1 obok lewej górnej 1 jest zamalowana, 2 pod nią to jedyne wyjście z rogu, więc zostaje. Dokończ planszę.';

  @override
  String get tutSolo5 =>
      'Teraz prawdziwa plansza. Zacznij od liczb, które występują w swoim wierszu i kolumnie tylko raz, oraz od równych liczb stojących blisko siebie.';

  @override
  String get tutSoloS1 =>
      'Dwie równe liczby obok siebie nie mogą być obie zamalowane, więc jedna z nich zostaje, a każda inna taka sama liczba w ich wierszu lub kolumnie jest zamalowana. W górnym wierszu dwie 4 stoją obok siebie: zamaluj zaznaczoną 4.';

  @override
  String get tutSoloS2 =>
      'Utrzymuj pozostałe pola w jednym kawałku: jeśli zamalowanie pola przecięłoby je na dwie części, a po obu stronach są liczby, które zostają, to pole zostaje. Uważaj na zamalowane pola układające się po skosie w stronę krawędzi.';

  @override
  String get tutSoloS3 =>
      'Trudna plansza. Gdy utkniesz, zamaluj liczbę i śledź skutki: jeśli w jednej linii zostaną dwie równe liczby albo jakieś pola zostaną odcięte, ta liczba zostaje.';

  @override
  String exSoloSupposeShade(Object cell) {
    return 'Załóżmy, że $cell jest zamalowane.';
  }

  @override
  String exSoloSupposeKeep(Object cell) {
    return 'Załóżmy, że $cell zostaje.';
  }

  @override
  String exSoloRefutedShade(Object cell) {
    return '$cell zostaje: zamalowanie prowadzi do sprzeczności.';
  }

  @override
  String exSoloRefutedKeep(Object cell) {
    return '$cell jest zamalowane: pozostawienie prowadzi do sprzeczności.';
  }

  @override
  String exSoloUnique(Object cell, int digit) {
    return '$cell zostaje: jego $digit nie występuje nigdzie indziej w wierszu ani kolumnie.';
  }

  @override
  String exSoloLastCopy(Object cell, int digit) {
    return '$cell zostaje: każda inna $digit w jego wierszu i kolumnie jest zamalowana, a zamalowana liczba musi gdzieś pozostać widoczna.';
  }

  @override
  String exSoloTwiceRow(Object cell, Object other, int digit, Object row) {
    return '$cell jest zamalowane: $digit w $other zostaje w wierszu $row.';
  }

  @override
  String exSoloTwiceCol(Object cell, Object other, int digit, Object col) {
    return '$cell jest zamalowane: $digit w $other zostaje w kolumnie $col.';
  }

  @override
  String exSoloTouch(Object cell, Object other) {
    return '$cell zostaje: styka się z zamalowanym $other.';
  }

  @override
  String exSoloShows(Object cell, Object other, int digit) {
    return '$cell zostaje: $other jest zamalowane, a jego $digit musi pozostać widoczna w wierszu lub kolumnie.';
  }

  @override
  String exSoloBetween(Object cell, Object a, Object b, int digit) {
    return '$cell zostaje: jedna z liczb $digit w $a i $b jest zamalowana, a obie go dotykają.';
  }

  @override
  String exSoloPair(Object cell, Object a, Object b, int digit) {
    return '$cell jest zamalowane: liczby $digit w $a i $b stoją obok siebie, więc jedna z nich zostaje.';
  }

  @override
  String exSoloWalled(Object cell, Object other) {
    return '$cell zostaje: to ostatnie wyjście dla $other.';
  }

  @override
  String exSoloCut(Object cell) {
    return '$cell zostaje: jego zamalowanie przecięłoby pozostałe pola na dwie części.';
  }

  @override
  String exSoloFailTwice(Object a, Object b, int digit) {
    return 'Ale wtedy $a i $b zostawiają tę samą $digit w jednej linii.';
  }

  @override
  String exSoloFailTouch(Object a, Object b) {
    return 'Ale wtedy zamalowane $a i $b się stykają.';
  }

  @override
  String exSoloFailLonely(Object a, int digit) {
    return 'Ale wtedy $digit w $a jest zamalowana i nie widnieje nigdzie indziej w wierszu ani kolumnie.';
  }

  @override
  String exSoloFailWalled(Object a) {
    return 'Ale wtedy $a jest zamknięte.';
  }

  @override
  String exSoloFailApart(Object a, Object b) {
    return 'Ale wtedy $a i $b są od siebie odcięte.';
  }

  @override
  String get dominoName => 'Domino';

  @override
  String get dominoTagline => 'Znajdź, gdzie leży każda kostka kompletu';

  @override
  String get dominoRules =>
      '• Plansza to pełny komplet domina z zatartymi obrysami: każda para liczb, od 0–0 do najwyższego dubletu, jest na dokładnie jednej kostce.\n• Podziel planszę na kostki z dwóch sąsiednich pól tak, aby każda para wystąpiła raz.\n\nDotknij linii między dwoma polami, aby połączyć je w kostkę; dotknij jeszcze raz, aby postawić krzyżyk (twoja notatka „tu nie ma kostki”), i jeszcze raz, aby wyczyścić. Przeciągnij po polach, aby układać kostki po drodze. Nowa kostka zabiera swoje pola kostkom, które je miały.';

  @override
  String get tutDomino1 =>
      'Plansza to komplet domina z zatartymi obrysami, a każda para liczb jest na dokładnie jednej kostce. Ten mały komplet ma 0–0, 0–1 i 1–1. Połącz dwa sąsiednie pola, dotykając linii między nimi, albo przeciągnij od jednego pola do drugiego.';

  @override
  String get tutDomino2 =>
      'Para liczb, która stoi obok siebie tylko w jednym miejscu, musi tam być kostką. Zaznaczone 0 i 0 to jedyne dwa zera obok siebie: połącz je, a potem dokończ planszę.';

  @override
  String get tutDomino3 =>
      'Każde pole należy do kostki. 2–2 już leży, więc zaznaczonemu 0 został tylko jeden sąsiad do pary. Połącz je, a potem dokończ planszę.';

  @override
  String get tutDomino4 =>
      'Każda para jest użyta raz. Kostka 2–3 już leży, więc dwie inne 2–3 w górnym rogu nie mogą być kostkami: dotknij dwa razy linii między polami każdej z nich, aby postawić krzyżyk. Potem zobacz, jaki sąsiad został narożnej 2, i dokończ planszę.';

  @override
  String get tutDomino5 =>
      'Teraz prawdziwa plansza. Zacznij od par, które mieszczą się tylko w jednym miejscu, i od pól, którym został jeden sąsiad. Skreślaj pozostałe miejsca każdej położonej pary.';

  @override
  String get tutDominoS1 =>
      'Gdy każde miejsce, które zostało dla pary, obejmuje to samo pole, to pole należy do tej pary i nie może utworzyć pary z innym sąsiadem. Każde miejsce, które zostało dla 3–3, obejmuje zaznaczone pole: skreśl jego pozostałych sąsiadów, a potem dokończ planszę.';

  @override
  String get tutDominoS2 =>
      'Gdy każda kostka, do której może należeć pole, to ta sama para, ta para leży przy tym polu, więc skreśl jej miejsca gdzie indziej. Zaznaczona 3 może być tylko w 1–3, tak czy inaczej: skreśl pozostałe 1–3.';

  @override
  String get tutDominoS3 =>
      'Trudna plansza. Uważaj na otwarte pola zamknięte w grupie o nieparzystej liczbie pól: kostki jej nie wypełnią. Gdy utkniesz, spróbuj kostki i śledź skutki: jeśli dla pola lub pary nie zostaje miejsce albo pojawia się nieparzysta grupa, ta kostka jest błędna.';

  @override
  String exDominoOnlySpot(Object a, Object b, Object link) {
    return '$a–$b mieści się tylko na $link, więc to jest kostka.';
  }

  @override
  String exDominoOnlyWay(Object cell, Object link) {
    return '$cell ma jednego sąsiada do pary, więc $link to kostka.';
  }

  @override
  String exDominoCovered(Object cell, Object link) {
    return '$cell jest już w kostce, więc $link nie jest kostką.';
  }

  @override
  String exDominoUsed(Object a, Object b, Object placed, Object link) {
    return '$a–$b leży na $placed, więc $link nie jest kostką.';
  }

  @override
  String exDominoPairAtCell(Object a, Object b, Object cell, Object link) {
    return 'Każde miejsce, które zostało dla $a–$b, obejmuje $cell, więc $cell należy do niej, a $link nie jest kostką.';
  }

  @override
  String exDominoCellOnePair(Object a, Object b, Object cell, Object link) {
    return '$cell może być tylko w $a–$b, więc ta kostka leży przy $cell, a $link nią nie jest.';
  }

  @override
  String exDominoFailCell(Object cell) {
    return 'Ale wtedy żadna kostka nie pokryje $cell.';
  }

  @override
  String exDominoFailPair(Object a, Object b) {
    return 'Ale wtedy dla $a–$b nie zostaje miejsce.';
  }

  @override
  String exDominoFailCellTwice(Object cell) {
    return 'Ale wtedy $cell jest w dwóch kostkach.';
  }

  @override
  String exDominoFailPairTwice(Object a, Object b) {
    return 'Ale wtedy $a–$b leży dwa razy.';
  }

  @override
  String exDominoFailOdd(Object cell, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól',
      one: '1 pola',
    );
    return 'Ale wtedy otwarte pola razem z $cell są zamknięte w grupie $_temp0, nieparzystej, której kostki nie wypełnią.';
  }

  @override
  String exDominoSupposeLine(Object link) {
    return 'Załóżmy, że $link to kostka.';
  }

  @override
  String exDominoSupposeCross(Object link) {
    return 'Załóżmy, że $link nie jest kostką.';
  }

  @override
  String exDominoRefutedLine(Object link) {
    return '$link nie jest kostką: inaczej dochodzi do sprzeczności.';
  }

  @override
  String exDominoRefutedCross(Object link) {
    return '$link to kostka: bez niej dochodzi do sprzeczności.';
  }

  @override
  String get tagShips => 'statki, łodzie, flota, morze, ukryte';

  @override
  String get fleetName => 'Flota';

  @override
  String get fleetTagline => 'Znajdź ukryte statki według liczb na brzegach';

  @override
  String get fleetRules =>
      '• W siatce ukrywa się flota; pod siatką widać, z jakich statków się składa. Każdy statek to prosta linia pól, poziomo lub pionowo.\n• Statki nigdy się nie stykają, nawet po przekątnej.\n• Liczby poza siatką mówią, ile pól statków jest w każdym wierszu i kolumnie.\n• Niektóre pola są pokazane od początku: woda albo część statku. Zaokrąglony koniec pokazuje, gdzie statek się kończy, kwadratowa część leży w środku statku, a okrągła to cały statek z jednego pola.\n\nDotknij pola, by przełączać: statek → woda (twoja notatka „tu nie ma statku”) → puste. Prawy klik przełącza wstecz. Przesuń po polach, by oznaczyć je wszystkie naraz. Długie przytrzymanie stawia wodę na każdym polu, gdzie postawione statki nie zostawiają miejsca na inny. Woda jest opcjonalna: łamigłówka jest rozwiązana, gdy wszystkie statki są na miejscu. Ukończone statki blakną na liście pod siatką, gdy woda lub krawędź zamyka je ze wszystkich stron.';

  @override
  String get tutFleet1 =>
      'W siatce ukrywa się flota, a lista pod nią pokazuje jej statki. Liczby na zewnątrz mówią, ile pól statków jest w każdym wierszu i kolumnie. Tutaj flota to trzy statki z jednego pola. Dotknij pola, by postawić statek, jeszcze raz – by postawić wodę.';

  @override
  String get tutFleet2 =>
      'Statki to proste linie pól i nigdy się nie stykają, nawet po przekątnej. Dolny wiersz potrzebuje dwóch pól statków, ale we flocie nie ma statku z dwóch pól, więc to dwa osobne statki z przerwą między nimi. Dokończ planszę.';

  @override
  String get tutFleet3 =>
      'Niektóre części są pokazane od początku. Zaokrąglony koniec oznacza, że statek ciągnie się w drugą stronę: część w rogu jest zaokrąglona u góry, więc pole pod nią też jest statkiem. Dokończ planszę.';

  @override
  String get tutFleet4 =>
      'Teraz prawdziwa plansza. Zacznij od wierszy i kolumn z zerem lub pełną liczbą, stawiaj wodę wokół znanych statków i pilnuj, których statków jeszcze brakuje.';

  @override
  String get tutFleetS1 =>
      'Szukaj miejsc, gdzie brakujące statki jeszcze się mieszczą. Pole, przez które nie przejdzie żaden z nich, to woda, a gdy najdłuższy brakujący statek ma już niewiele miejsc, pola wspólne dla nich wszystkich to statek. Licz miejsca w wierszach i kolumnach, które mają na niego miejsce.';

  @override
  String get tutFleetS2 =>
      'Trudna plansza: niektóre liczby są ukryte. Gdy utkniesz, załóż, że pole jest statkiem, i idź dalej: jeśli wiersz się przepełni, statki się zetkną albo statek nie ma gdzie stanąć, na tym polu jest woda.';

  @override
  String exFleetSupposeShip(Object cell) {
    return 'Załóżmy, że $cell jest częścią statku.';
  }

  @override
  String exFleetSupposeWater(Object cell) {
    return 'Załóżmy, że na $cell jest woda.';
  }

  @override
  String exFleetRefutedShip(Object cell) {
    return 'Na $cell jest woda: statek tam prowadzi do sprzeczności.';
  }

  @override
  String exFleetRefutedWater(Object cell) {
    return '$cell jest częścią statku: woda tam prowadzi do sprzeczności.';
  }

  @override
  String exFleetPieceShip(Object cell, Object other) {
    return '$cell jest częścią statku: część na $other ciągnie się w tę stronę.';
  }

  @override
  String exFleetPieceWater(Object cell, Object other) {
    return 'Na $cell jest woda: część na $other kończy się z tej strony.';
  }

  @override
  String exFleetMiddle(Object cell, Object other) {
    return '$cell jest częścią statku: środkowa część na $other nie może biec w drugą stronę.';
  }

  @override
  String exFleetDiagonal(Object cell, Object other) {
    return 'Na $cell jest woda: styka się po przekątnej ze statkiem na $other.';
  }

  @override
  String exFleetRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola statków',
      many: 'wszystkie $count pól statków',
      few: 'wszystkie $count pola statków',
      one: 'swoje pole statku',
    );
    return 'Na $cell jest woda: wiersz $row ma już $_temp0.';
  }

  @override
  String exFleetColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola statków',
      many: 'wszystkie $count pól statków',
      few: 'wszystkie $count pola statków',
      one: 'swoje pole statku',
    );
    return 'Na $cell jest woda: kolumna $col ma już $_temp0.';
  }

  @override
  String exFleetRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól statków',
      one: 'jednego pola statku',
    );
    return '$cell jest częścią statku: wiersz $row potrzebuje $_temp0, a tyle właśnie pól zostało.';
  }

  @override
  String exFleetColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól statków',
      one: 'jednego pola statku',
    );
    return '$cell jest częścią statku: kolumna $col potrzebuje $_temp0, a tyle właśnie pól zostało.';
  }

  @override
  String exFleetAllFound(Object cell) {
    return 'Na $cell jest woda: wszystkie statki floty są już znalezione.';
  }

  @override
  String exFleetLongest(Object cell, Object other, int length) {
    return 'Na $cell jest woda: statek na $other ma już długość $length, tyle co najdłuższy brakujący statek.';
  }

  @override
  String exFleetTooLong(Object cell, int length) {
    return 'Na $cell jest woda: statek tam byłby dłuższy niż $length, długość najdłuższego brakującego statku.';
  }

  @override
  String exFleetNoFit(Object cell) {
    return 'Na $cell jest woda: nie przechodzi przez nie żaden brakujący statek.';
  }

  @override
  String exFleetExtend(Object cell, Object other) {
    return '$cell jest częścią statku: każdy statek, który mieści się przez $other, je obejmuje.';
  }

  @override
  String exFleetMustCover(Object cell, int length) {
    return '$cell jest częścią statku: każde miejsce, które zostało dla brakującego statku o długości $length, je obejmuje.';
  }

  @override
  String exFleetOnlySpots(Object cell, int length) {
    return '$cell jest częścią statku: statkom o długości $length zostało dokładnie tyle miejsc, ile trzeba.';
  }

  @override
  String exFleetFailTouch(Object a, Object b) {
    return 'Ale wtedy statki na $a i $b się stykają.';
  }

  @override
  String exFleetFailRowMany(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola statków',
      many: '$count pól statków',
      few: '$count pola statków',
      one: 'jedno pole statku',
    );
    return 'Ale wtedy wiersz $row ma więcej niż $_temp0.';
  }

  @override
  String exFleetFailColMany(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola statków',
      many: '$count pól statków',
      few: '$count pola statków',
      one: 'jedno pole statku',
    );
    return 'Ale wtedy kolumna $col ma więcej niż $_temp0.';
  }

  @override
  String exFleetFailRowFew(Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count pól statków',
      one: 'swojego pola statku',
    );
    return 'Ale wtedy wiersz $row nie zdobędzie $_temp0.';
  }

  @override
  String exFleetFailColFew(Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'swoich $count pól statków',
      one: 'swojego pola statku',
    );
    return 'Ale wtedy kolumna $col nie zdobędzie $_temp0.';
  }

  @override
  String exFleetFailPiece(Object a) {
    return 'Ale wtedy część na $a nie pasuje.';
  }

  @override
  String exFleetFailLong(Object a, int length) {
    return 'Ale wtedy statek na $a jest dłuższy niż $length, najdłuższy brakujący statek.';
  }

  @override
  String exFleetFailFleet(int length) {
    return 'Ale wtedy jest za dużo statków o długości $length.';
  }

  @override
  String exFleetFailNoRoom(int length) {
    return 'Ale wtedy statki o długości $length nie zmieszczą się wszystkie.';
  }

  @override
  String exFleetFailStray(Object a) {
    return 'Ale wtedy pole statku $a nie może należeć do żadnego brakującego statku.';
  }

  @override
  String get tagWater => 'woda, napełnić, ciecz, nalać, poziom, zbiornik, basen';

  @override
  String get basinsName => 'Baseny';

  @override
  String get basinsTagline => 'Napełnij baseny równą wodą zgodnie z liczbami';

  @override
  String get basinsRules =>
      '• Siatka jest podzielona na baseny. Napełnij niektóre pola wodą.\n• Woda opada: w każdym basenie wypełnia go od dna do jednego poziomu, takiego samego w całym basenie. Każde pole basenu na tej wysokości lub niżej ma wodę, każde wyżej zostaje suche. Basen może też zostać pusty albo wypełnić się po brzegi.\n• Liczby na zewnątrz mówią, ile pól z wodą jest w każdym wierszu i kolumnie.\n\nDotknij pola, by przełączać: woda → suche (twoja notatka) → puste. Prawy klik przełącza wstecz. Przeciągnij po polach, by napełnić je wszystkie naraz. Długie przytrzymanie pozwala wodzie opaść: wypełnia każde pole basenu poniżej twojej wody i oznacza jako suche pola nad twoimi suchymi znacznikami oraz w wierszach i kolumnach, które mają już całą wodę. Suche znaczniki są opcjonalne: zagadka jest rozwiązana, gdy cała woda jest na miejscu.';

  @override
  String get tutBasins1 =>
      'Siatka jest podzielona na baseny, a woda w każdym opada od dna w górę. Liczby na zewnątrz mówią, ile pól z wodą jest w każdym wierszu i kolumnie. Kolumna A ma 2, więc jej basen wypełnia dwa najniższe pola. Dotknij pola, by nalać do niego wody, jeszcze raz – by oznaczyć je jako suche.';

  @override
  String get tutBasins2 =>
      'Woda leży równo w całym basenie: gdy jedno pole basenu ma wodę, ma ją też każde jego pole na tej samej wysokości lub niżej. Wiersz 2 potrzebuje tylko jednego pola z wodą, więc szeroki basen nie może sięgać tak wysoko. Dokończ planszę.';

  @override
  String get tutBasins3 =>
      'Myśl naprzód: woda w polu wypełnia wszystko pod nim w jego basenie. Gdy dolny wiersz jest pełny, kolumna A potrzebuje jeszcze tylko jednego pola z wodą, a woda w jej górnym polu wypełniłaby dwa. Więc górne pole zostaje suche. Dokończ planszę.';

  @override
  String get tutBasins4 =>
      'Teraz prawdziwa plansza. Zacznij od pustych lub pełnych wierszy i kolumn, pozwól wodzie opaść, a zanim napełnisz pole, policz, ile wody pociągnie za sobą.';

  @override
  String get tutBasinsS1 =>
      'Woda w wierszu przychodzi kawałkami: pola jednego basenu w tym wierszu napełniają się razem. Gdy tylko niektóre zestawy kawałków sumują się do liczby wiersza, kawałek obecny we wszystkich ma wodę, a kawałek, którego nie ma w żadnym, zostaje suchy.';

  @override
  String get tutBasinsS2 =>
      'Wypróbuj każdy poziom wody w basenie, od pustego do pełnego, z liczbami wierszy i kolumn, których dotyka. Pola, które wychodzą tak samo w każdym pasującym poziomie, są ustalone.';

  @override
  String get tutBasinsS3 =>
      'Trudna plansza: niektóre liczby są ukryte. Gdy utkniesz, załóż, że pole ma wodę, i pozwól jej opaść: jeśli wiersz lub kolumna się przepełni albo nie osiągnie swojej liczby, to pole zostaje suche.';

  @override
  String exBasinsSupposeWater(Object cell) {
    return 'Załóżmy, że na $cell jest woda.';
  }

  @override
  String exBasinsSupposeDry(Object cell) {
    return 'Załóżmy, że $cell jest suche.';
  }

  @override
  String exBasinsRefutedWater(Object cell) {
    return '$cell jest suche: woda tam prowadzi do sprzeczności.';
  }

  @override
  String exBasinsRefutedDry(Object cell) {
    return 'Na $cell jest woda: zostawienie go suchym prowadzi do sprzeczności.';
  }

  @override
  String exBasinsWaterBelow(Object cell, Object other) {
    return 'Na $cell jest woda: woda na $other wypełnia basen do tej wysokości.';
  }

  @override
  String exBasinsDryAbove(Object cell, Object other) {
    return '$cell jest suche: $other w tym samym basenie jest suche, więc woda jest niżej.';
  }

  @override
  String exBasinsRowDone(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola z wodą',
      many: 'wszystkie $count pól z wodą',
      few: 'wszystkie $count pola z wodą',
      one: 'swoje pole z wodą',
    );
    return '$cell jest suche: wiersz $row ma już $_temp0.';
  }

  @override
  String exBasinsColDone(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wszystkie $count pola z wodą',
      many: 'wszystkie $count pól z wodą',
      few: 'wszystkie $count pola z wodą',
      one: 'swoje pole z wodą',
    );
    return '$cell jest suche: kolumna $col ma już $_temp0.';
  }

  @override
  String exBasinsRowNeed(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól z wodą',
      one: 'jednego pola z wodą',
    );
    return 'Na $cell jest woda: wiersz $row potrzebuje $_temp0, a tylko tyle pól zostało.';
  }

  @override
  String exBasinsColNeed(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pól z wodą',
      one: 'jednego pola z wodą',
    );
    return 'Na $cell jest woda: kolumna $col potrzebuje $_temp0, a tylko tyle pól zostało.';
  }

  @override
  String exBasinsTooMuchRow(Object cell, Object row, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: 'jedno pole',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'potrzebuje jeszcze tylko $need',
      one: 'potrzebuje jeszcze tylko jednego',
      zero: 'ma już całą wodę',
    );
    return '$cell jest suche: woda tam wypełniłaby $_temp0 wiersza $row, który $_temp1.';
  }

  @override
  String exBasinsTooMuchCol(Object cell, Object col, int count, int need) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: 'jedno pole',
    );
    String _temp1 = intl.Intl.pluralLogic(
      need,
      locale: localeName,
      other: 'potrzebuje jeszcze tylko $need',
      one: 'potrzebuje jeszcze tylko jednego',
      zero: 'ma już całą wodę',
    );
    return '$cell jest suche: woda tam wypełniłaby $_temp0 kolumny $col, która $_temp1.';
  }

  @override
  String exBasinsTooLittleRow(Object cell, Object row, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: 'jedno pole',
    );
    return 'Na $cell jest woda: suche zostawiłoby suchymi $_temp0 wiersza $row, a wiersz nie osiągnąłby już swojej liczby.';
  }

  @override
  String exBasinsTooLittleCol(Object cell, Object col, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: 'jedno pole',
    );
    return 'Na $cell jest woda: suche zostawiłoby suchymi $_temp0 kolumny $col, a kolumna nie osiągnęłaby już swojej liczby.';
  }

  @override
  String exBasinsWaysWater(Object cell, Object row, int count) {
    return 'Na $cell jest woda: każdy sposób, by złożyć $count w wierszu $row z kawałków jego basenów, wymaga tego kawałka.';
  }

  @override
  String exBasinsWaysDry(Object cell, Object row, int count) {
    return '$cell jest suche: żaden sposób, by złożyć $count w wierszu $row z kawałków jego basenów, nie używa tego kawałka.';
  }

  @override
  String exBasinsLevelsWater(Object cell) {
    return 'Na $cell jest woda: każdy poziom wody w jego basenie, przy którym jest suche, łamie liczbę wiersza lub kolumny.';
  }

  @override
  String exBasinsLevelsDry(Object cell) {
    return '$cell jest suche: każdy poziom wody w jego basenie, który do niego sięga, łamie liczbę wiersza lub kolumny.';
  }

  @override
  String exBasinsFailLevel(Object wet, Object dry) {
    return 'Ale wtedy $wet ma wodę, a $dry, na tej samej wysokości lub niżej w tym samym basenie, jest suche.';
  }

  @override
  String exBasinsFailRowMany(Object row, int count) {
    return 'Ale wtedy wiersz $row ma więcej niż $count pól z wodą.';
  }

  @override
  String exBasinsFailColMany(Object col, int count) {
    return 'Ale wtedy kolumna $col ma więcej niż $count pól z wodą.';
  }

  @override
  String exBasinsFailRowFew(Object row, int count) {
    return 'Ale wtedy wiersz $row nie zbierze już $count pól z wodą.';
  }

  @override
  String exBasinsFailColFew(Object col, int count) {
    return 'Ale wtedy kolumna $col nie zbierze już $count pól z wodą.';
  }

  @override
  String exBasinsFailWays(Object row, int count) {
    return 'Ale wtedy żaden zestaw kawałków basenów w wierszu $row nie sumuje się do $count.';
  }

  @override
  String exBasinsFailLevels(Object cell) {
    return 'Ale wtedy żaden poziom wody w basenie z $cell nie pasuje do liczb.';
  }

  @override
  String recallGoalRounds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rundy',
      many: '$count rund',
      few: '$count rundy',
      one: '$count runda',
    );
    return '$_temp0';
  }

  @override
  String get recallGoalRoundsHint => 'Zagraj ustaloną liczbę rund i zdobądź jak najwięcej punktów.';

  @override
  String recallGoalLives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count życia',
      many: '$count żyć',
      few: '$count życia',
      one: '$count życie',
    );
    return '$_temp0';
  }

  @override
  String recallGoalLivesHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count razy',
      many: '$count razy',
      few: '$count razy',
      one: 'raz',
    );
    return 'Graj, aż pomylisz się $_temp0, i pobij swój rekord.';
  }

  @override
  String recallRound(int round, int count) {
    return 'Runda $round/$count';
  }

  @override
  String get recallReady => 'Gotowe';

  @override
  String get recallStart => 'Dotknij, aby zacząć';

  @override
  String get recallWatch => 'Zapamiętaj…';

  @override
  String recallRight(int points) {
    return 'Dobrze! +$points';
  }

  @override
  String get recallMissed => 'Pudło';

  @override
  String recallRoundsRight(int correct, int count) {
    return 'Dobrze: $correct z $count rund';
  }

  @override
  String get tagMemory => 'pamięć, zapamiętywanie, przypominanie, trening mózgu, koncentracja, uwaga';

  @override
  String get glimpseName => 'Błysk';

  @override
  String get glimpseTagline => 'Pola rozbłyskują na chwilę: dotknij ich wszystkich z pamięci';

  @override
  String get glimpseRules =>
      '• Kilka pól rozbłyska na chwilę i gaśnie. Dotknij każdego pola, które rozbłysło, w dowolnej kolejności.\n• Dotknij „Gotowe”, aby ukryć je wcześniej.\n• Dotknięcie pola, które nie rozbłysło, kończy rundę.\n• Dobra runda daje punkt za każde pole, a następna zapala o jedno pole więcej. Po pomyłce — o jedno mniej.\n\nCele\n• Rundy: zagraj 10 rund o rekord.\n• Życia: graj do trzeciej pomyłki.\n\nPoziom trudności ustala, ile pól zapala pierwsza runda i jak długo świecą.';

  @override
  String get glimpsePrompt => 'Dotknij wszystkich pól, które rozbłysły';

  @override
  String get tutGlimpse1 =>
      'Dotknij planszy, aby zacząć. Trzy pola rozbłysną na chwilę: zapamiętaj je, a gdy zgasną, dotknij wszystkich trzech.';

  @override
  String get tutGlimpse2 =>
      'Dotknij „Gotowe”, gdy tylko zapamiętasz pola, aby ukryć je wcześniej. Dotknięcie pola, które nie rozbłysło, kończy rundę; tutaj zagrasz ją wtedy jeszcze raz. Zalicz obie rundy.';

  @override
  String get tutGlimpse3 =>
      'Prawdziwa plansza: każda dobra runda zapala następnym razem o jedno pole więcej, a pomyłka o jedno mniej. Zalicz 3 rundy.';

  @override
  String get famMemory => 'Pamięć';

  @override
  String get famMemoryAbout => 'Przyjrzyj się, a potem odpowiadaj z pamięci. Każda dobra runda utrudnia następną';

  @override
  String get vanishName => 'Znikanie';

  @override
  String get vanishTagline => 'Dotknij 1, a liczby się schowają: resztę dotykaj po kolei z pamięci';

  @override
  String get vanishRules =>
      '• Na planszy pojawiają się liczby od 1. Nie spiesz się: są widoczne, dopóki nie dotkniesz 1.\n• Gdy tylko dotkniesz 1, pozostałe liczby się chowają. Dotykaj ich pól po kolei: 2, 3, 4…\n• Dotknięcie złego pola kończy rundę.\n• Dobra runda daje punkt za każdą liczbę, a następna pokazuje o jedną liczbę więcej. Po pomyłce — o jedną mniej.\n\nCele\n• Rundy: zagraj 10 rund o rekord.\n• Życia: graj do trzeciej pomyłki.\n\nPoziom trudności ustala, ile liczb pokazuje pierwsza runda.';

  @override
  String get vanishWatch => 'Dotknij 1, gdy zapamiętasz';

  @override
  String get vanishPrompt => 'Dotykaj liczb po kolei';

  @override
  String get tutVanish1 =>
      'Dotknij planszy, aby zacząć. Pojawią się liczby: dotknij 1, a reszta się schowa. Potem dotknij miejsc, gdzie były 2 i 3.';

  @override
  String get tutVanish2 =>
      'Patrz, ile chcesz: liczby są widoczne, dopóki nie dotkniesz 1. Dotknięcie złego pola kończy rundę; tutaj zagrasz ją wtedy jeszcze raz. Zalicz obie rundy.';

  @override
  String get tutVanish3 =>
      'Prawdziwa plansza: każda dobra runda pokazuje następnym razem o jedną liczbę więcej, a pomyłka o jedną mniej. Zalicz 3 rundy.';

  @override
  String get hopperName => 'Skoczek';

  @override
  String get hopperTagline => 'Patrz, jak żabka skacze z liścia na liść, i powtórz jej skoki';

  @override
  String get hopperRules =>
      '• Żabka skacze z liścia na liść, po jednym skoku. Gdy się zatrzyma, dotknij liści, na które skakała, w tej samej kolejności.\n• Liść może się powtórzyć: dotknij go za każdym razem.\n• Złe dotknięcie kończy rundę.\n• Dobra runda daje punkt za każdy skok, a następna ma o jeden skok więcej. Po pomyłce — o jeden mniej.\n\nKolejność\n• Ta sama: od pierwszego skoku do ostatniego.\n• Od końca: od ostatniego skoku do pierwszego.\n\nCele\n• Rundy: zagraj 10 rund o rekord.\n• Życia: graj do trzeciej pomyłki.\n\nPoziom trudności ustala, ile skoków ma pierwsza runda i jak szybko skacze żabka.';

  @override
  String get hopperOrder => 'Kolejność';

  @override
  String get hopperForward => 'Ta sama';

  @override
  String get hopperForwardHint => 'Dotykaj liści w kolejności skoków żabki.';

  @override
  String get hopperReverse => 'Od końca';

  @override
  String get hopperReverseHint => 'Dotykaj liści od ostatniego skoku żabki do pierwszego.';

  @override
  String get hopperWatch => 'Patrz na żabkę…';

  @override
  String get hopperPrompt => 'Dotykaj liści po kolei';

  @override
  String get hopperPromptReverse => 'Dotykaj liści od końca, od ostatniego skoku';

  @override
  String get tutHopper1 =>
      'Dotknij planszy, aby zacząć. Żabka skacze z liścia na liść. Gdy się zatrzyma, dotknij liści, na które skakała, w tej samej kolejności.';

  @override
  String get tutHopper2 =>
      'Liść może się powtórzyć: dotknij go za każdym razem. Złe dotknięcie kończy rundę; tutaj zagrasz ją wtedy jeszcze raz. Zalicz obie rundy.';

  @override
  String get tutHopper3 =>
      'Z opcją „Od końca” dotykaj tych samych liści od ostatniego skoku do pierwszego. Spróbuj raz.';

  @override
  String get tutHopper4 =>
      'Prawdziwa plansza: każda dobra runda dodaje następnym razem jeden skok, a pomyłka zabiera jeden. Zalicz 3 rundy.';

  @override
  String get reboundName => 'Rykoszet';

  @override
  String get reboundTagline => 'Zapamiętaj odbijacze i wskaż, gdzie wyleci piłka';

  @override
  String get reboundRules =>
      '• Na planszy stoją odbijacze, a przy strzałce na krawędzi czeka piłka. Zapamiętaj odbijacze: po chwili (albo gdy dotkniesz „Gotowe”) się schowają.\n• Piłka toczy się od strzałki, a każdy odbijacz na jej drodze skręca ją o ćwierć obrotu, tak jak jest pochylony. Dotknij krawędzi, przez którą piłka opuści planszę.\n• Dobra runda daje punkt za każdy odbijacz, a następna ma o jeden odbijacz więcej. Po pomyłce — o jeden mniej.\n\nCele\n• Rundy: zagraj 10 rund o rekord.\n• Życia: graj do trzeciej pomyłki.\n\nPoziom trudności ustala, ile odbijaczy ma pierwsza runda i jak długo są widoczne.';

  @override
  String get reboundPrompt => 'Dotknij krawędzi, przez którą wyleci piłka';

  @override
  String get tutRebound1 =>
      'Dotknij planszy, aby zacząć. Piłka toczy się od strzałki i odbija od odbijacza tak, jak jest pochylony. Zapamiętaj go, a gdy się schowa, dotknij krawędzi, przez którą wyleci piłka.';

  @override
  String get tutRebound2 =>
      'Piłka może trafić na kilka odbijaczy, a inne ominąć. Dotknij „Gotowe”, gdy tylko je zapamiętasz. Zła krawędź kończy rundę; tutaj zagrasz ją wtedy jeszcze raz.';

  @override
  String get tutRebound3 =>
      'Prawdziwa plansza: każda dobra runda dodaje następnym razem jeden odbijacz, a pomyłka zabiera jeden. Zalicz 3 rundy.';

  @override
  String get pebblesName => 'Kamyki';

  @override
  String get pebblesTagline => 'Dwa rodzaje kamyków, każdy rodzaj w jednym kawałku';

  @override
  String get pebblesRules =>
      '• Połóż kamyk w każdym polu: pełny albo drążony.\n• Wszystkie pełne kamyki tworzą jedną grupę, połączoną bokami, i tak samo wszystkie drążone.\n• Żaden kwadrat 2×2 nie zawiera czterech kamyków jednego rodzaju.\n• Niektóre kamyki są widoczne od początku.\n\nDotknij pola, aby przełączać: pełny → drążony → puste. Długie przytrzymanie / prawy przycisk przełącza wstecz. Przeciągnij po polach, aby położyć we wszystkich ten sam kamyk. Sąsiednie kamyki jednego rodzaju są narysowane jako połączone, więc grupy są widoczne.';

  @override
  String get tutPebbles1 =>
      'Połóż kamyk w każdym polu. Wszystkie pełne kamyki muszą tworzyć jedną grupę, połączoną bokami, i tak samo wszystkie drążone. Dotknij pustego pola raz, aby położyć pełny kamyk, dwa razy – drążony. Wypełnij tę planszę.';

  @override
  String get tutPebbles2 =>
      'Żaden kwadrat 2×2 nie może zawierać czterech kamyków jednego rodzaju. Zaznaczony kwadrat ma już trzy drążone kamyki, więc w ostatnim polu leży pełny. Dokończ planszę w ten sam sposób.';

  @override
  String get tutPebbles3 =>
      'Każda grupa musi dotrzeć do reszty swojego rodzaju. Drążony kamyk w rogu jest zamknięty z wyjątkiem jednego pola, więc tam też leży drążony. Prowadź drążone kamyki, aż spotkają pozostałe.';

  @override
  String get tutPebbles4 =>
      'W polu otoczonym pełnymi kamykami nie może leżeć drążony: zostałby odcięty od pozostałych drążonych. I na odwrót tak samo. Wypełnij zaznaczone pole, a potem dokończ planszę.';

  @override
  String get tutPebbles5 =>
      'Teraz prawdziwa plansza. Szukaj kwadratów z trzema jednakowymi kamykami i grup, które mają tylko jedno wyjście.';

  @override
  String get tutPebblesS1 =>
      'Idąc wzdłuż brzegu planszy, pełne kamyki tworzą jeden nieprzerwany odcinek, a drążone drugi: gdyby brzeg czterokrotnie zmieniał rodzaj, obie grupy musiałyby się przeciąć. W A1 i D4 leżą pełne kamyki, a w C4 drążony, więc brzeg od A1 górą i w dół do D4 jest cały pełny.';

  @override
  String get tutPebblesS2 =>
      'Kwadrat 2×2 nigdy nie jest naprzemienny, z pełnymi kamykami na jednej przekątnej i drążonymi na drugiej: pełna para mogłaby się spotkać tylko, obchodząc jeden z drążonych kamyków i odcinając go. Gdy więc jedna przekątna ma dwa jednakowe kamyki, a druga jeden kamyk innego rodzaju, ostatnie pole jest takie jak przekątna.';

  @override
  String get tutPebblesS3 =>
      'Niektóre pola trzymają rodzaj razem: gdyby takie pole zajął drugi rodzaj, kamyki po obu jego stronach nie mogłyby się już spotkać. Takie pole dostaje rodzaj, który trzyma razem. Szukaj wąskich przejść między grupami.';

  @override
  String exPebblesBlock(Object cell, Object stone, Object other) {
    return 'W $cell jest $stone: reszta jego kwadratu 2×2 to $other, a kwadrat nigdy nie zawiera czterech jednakowych.';
  }

  @override
  String exPebblesEnclosed(Object cell, Object stone, Object other) {
    return 'W $cell jest $stone: otaczają je $stone, więc $other byłby tam odcięty od reszty swojego rodzaju.';
  }

  @override
  String exPebblesExit(Object cell, Object stone, Object group) {
    return 'W $cell jest $stone: to jedyne wyjście dla grupy w $group.';
  }

  @override
  String exPebblesEdge(Object cell, Object stone, Object other, Object a, Object b, Object c) {
    return 'W $cell jest $stone: wzdłuż brzegu każdy rodzaj tworzy jeden odcinek. W $a i $b jest $stone, a w $c $other, więc odcinek od $a do $b przez $cell to $stone.';
  }

  @override
  String exPebblesChecker(Object cell, Object stone, Object other, Object a, Object b, Object c) {
    return 'W $cell jest $stone: $a i $b to $stone na jednej przekątnej kwadratu 2×2, a $c to $other, a kwadrat nigdy nie jest naprzemienny.';
  }

  @override
  String exPebblesCut(Object cell, Object stone, Object other) {
    return 'W $cell jest $stone: $other tam podzieliłby kamyki $stone na części, które nie mogą się spotkać.';
  }

  @override
  String exPebblesFailBlock(Object cell) {
    return 'Ale wtedy kwadrat 2×2 w $cell zawiera cztery jednakowe.';
  }

  @override
  String exPebblesFailClosed(Object cell) {
    return 'Ale wtedy grupa w $cell jest zamknięta i odcięta od reszty swojego rodzaju.';
  }

  @override
  String exPebblesFailEdge(Object a, Object b, Object c, Object d) {
    return 'Ale wtedy brzeg zmienia rodzaj w $a, $b, $c i $d, i oba rodzaje musiałyby się przeciąć.';
  }

  @override
  String exPebblesFailChecker(Object cell) {
    return 'Ale wtedy kwadrat 2×2 w $cell jest naprzemienny.';
  }

  @override
  String exPebblesFailApart(Object a, Object b) {
    return 'Ale wtedy $a i $b są od siebie odcięte.';
  }

  @override
  String get totalsName => 'Sumy';

  @override
  String get totalsTagline => 'Krzyżówka z cyfr, które sumują się wzdłuż i w poprzek';

  @override
  String get totalsRules =>
      '• Wpisz w każde puste pole cyfrę od 1 do 9.\n• Pola ze wskazówkami podają sumy: liczba nad przekątną to suma ciągu pól na prawo od niego, liczba pod przekątną – suma ciągu pod nim. Ciąg kończy się na następnym polu ze wskazówką albo na krawędzi.\n• W ciągu żadna cyfra się nie powtarza.\n\nWybierz cyfrę z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem cyfry. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole. Suma blednie, gdy jej ciąg jest pełny i się zgadza.';

  @override
  String get tutTotals1 =>
      'Wpisz w puste pola cyfry od 1 do 9. W polu ze wskazówką liczba nad przekątną to suma ciągu na prawo, liczba pod nią – suma ciągu poniżej. 3 w dwóch polach to tylko 1 + 2, a 4 tylko 1 + 3: pole w rogu należy do obu ciągów, więc jest w nim 1.';

  @override
  String get tutTotals2 =>
      'W ciągu żadna cyfra się nie powtarza: 4 w dwóch polach to 1 + 3, nigdy 2 + 2. Wypełnij tę planszę.';

  @override
  String get tutTotals3 =>
      'Niektóre sumy da się ułożyć tylko na jeden sposób: 24 w trzech polach wymaga 7, 8 i 9, a 7 w trzech polach – 1, 2 i 4. W każdym polu stoi cyfra, na którą pozwalają oba jego ciągi.';

  @override
  String get tutTotals4 =>
      'Teraz prawdziwa plansza. Zacznij od ciągów, których sumę da się ułożyć tylko na jeden sposób, a potem patrz, gdzie ciągi się krzyżują.';

  @override
  String get tutTotalsS1 =>
      'Wypisz zestawy różnych cyfr, które dają sumę ciągu. Cyfra, która jest w każdym zestawie, musi stać gdzieś w ciągu: jeśli może ją przyjąć tylko jedno pole ciągu, stoi właśnie tam.';

  @override
  String get tutTotalsS2 =>
      'Czasem każda cyfra pasuje do pola sama, ale nie razem z innymi: jeśli dwa pola ciągu mogą mieć tylko 1 albo 3, zabierają obie, i żadne inne pole ciągu ich nie ma. Sprawdź każdy sposób wypełnienia krótkiego ciągu różnymi cyframi.';

  @override
  String get tutTotalsS3 =>
      'Najtrudniejsze plansze wymagają założenia, które da się obalić. Załóż, że w polu jest jedna z dwóch lub trzech ostatnich cyfr, i rozumuj dalej; jeśli jakiś ciąg nie może już dać swojej sumy, skreśl tę cyfrę.';

  @override
  String exTotalsCombo(Object sum, Object run, Object digits, Object cell, Object gone) {
    return 'Aby ułożyć $sum w $run, wolne pola mogą mieć tylko $digits, więc w $cell nie może być $gone.';
  }

  @override
  String exTotalsMust(Object sum, Object run, Object value, Object cell) {
    return 'W $cell musi być $value: każdy sposób ułożenia $sum w $run używa $value, a żadne inne pole tam go nie przyjmie.';
  }

  @override
  String exTotalsFill(Object sum, Object run, Object gone, Object cell) {
    return 'Żaden sposób wypełnienia $run różnymi cyframi o sumie $sum nie stawia $gone w $cell.';
  }

  @override
  String exTotalsNaked(Object cell, Object value) {
    return 'W $cell musi być $value: wszystkie inne cyfry są tam wykluczone.';
  }

  @override
  String exTotalsFailEmpty(Object cell) {
    return 'Ale wtedy dla $cell nie zostaje żadna cyfra.';
  }

  @override
  String exTotalsFailRun(Object sum, Object run) {
    return 'Ale wtedy $run nie może już dać $sum.';
  }

  @override
  String get famSudoku => 'Sudoku';

  @override
  String get famSudokuAbout => 'Każda cyfra raz w wierszu, kolumnie i bloku, a do tego dodatkowe wskazówki';

  @override
  String get pocketsName => 'Kieszonki';

  @override
  String get pocketsTagline => 'Sudoku, w którym przerywane kieszonki dają swoje sumy';

  @override
  String get pocketsRules =>
      '• Wpisz w każde pole cyfrę od 1 do N (N = rozmiar siatki): każda cyfra raz w każdym wierszu, kolumnie i bloku, jak w sudoku.\n• Siatka jest też podzielona na kieszonki z przerywanymi ramkami. Cyfry kieszonki sumują się do liczby w jej rogu i żadna cyfra nie powtarza się w jednej kieszonce.\n• Nie ma podanych cyfr: wszystko podpowiedzą sumy.\n\nWybierz cyfrę z palety i dotykaj pól, aby ją wpisać, albo najpierw dotknij pola, a potem cyfry. Przycisk ołówka włącza małe notatki. Długie naciśnięcie / prawy przycisk czyści pole. Suma blednie, gdy jej kieszonka jest pełna i się zgadza.';

  @override
  String get tutPockets1 =>
      'Jak w sudoku, każdy wiersz, kolumna i blok (grube ramki) zawiera każdą cyfrę od 1 do 4 raz. Przerywane kieszonki dodają swoje: ich cyfry sumują się do liczby w rogu. 3 w dwóch polach to tylko 1 + 2, a 7 tylko 3 + 4; co gdzie, podpowiedzą kolumny.';

  @override
  String get tutPockets2 =>
      'W kieszonce żadna cyfra się nie powtarza, nawet gdy jej pola leżą w różnych wierszach i kolumnach. Dlatego trzy pola na planszy 4 × 4 pomijają tylko jedną cyfrę: 6 to 1 + 2 + 3, a 8 to 1 + 3 + 4.';

  @override
  String get tutPockets3 =>
      'Na tej planszy nie ma żadnej cyfry. Zacznij od kieszonek, których sumę da się ułożyć tylko na jeden sposób, a dalej jak w sudoku.';

  @override
  String get tutPockets4 =>
      'Teraz prawdziwa plansza. Notuj, jakie cyfry może mieć kieszonka, i pamiętaj: cały wiersz, kolumna czy blok daje 1 + 2 + … + 6 = 21.';

  @override
  String get tutPocketsS1 =>
      'Cały wiersz, kolumna czy blok zawsze daje tę samą sumę: 21 na planszy 6 × 6, 45 na 9 × 9. Odejmij sumy kieszonek leżących w nim w całości, a zostanie suma pozostałych pól. Gdy zostają jedno lub dwa pola, często to je rozstrzyga.';

  @override
  String get tutPocketsS2 =>
      'Działa to też w drugą stronę. Dodaj sumy kieszonek, które wchodzą do wiersza, kolumny czy bloku, odejmij jego sumę, a dostaniesz sumę ich pól wystających na zewnątrz. Pasy z całych bloków działają tak samo.';

  @override
  String get tutPocketsS3 =>
      'Najtrudniejsze plansze wymagają założenia, które da się obalić. Załóż, że w polu jest jedna z dwóch lub trzech ostatnich cyfr, i rozumuj dalej; jeśli jakaś kieszonka nie może już dać swojej sumy albo cyfra nie ma już miejsca, skreśl tę cyfrę.';

  @override
  String exPocketsCombo(Object sum, Object pocket, Object digits, Object cell, Object gone) {
    return 'Aby ułożyć $sum w kieszonce $pocket, wolne pola mogą mieć tylko $digits, więc w $cell nie może być $gone.';
  }

  @override
  String exPocketsMust(Object sum, Object pocket, Object value, Object cell) {
    return 'W $cell musi być $value: każdy sposób ułożenia $sum w kieszonce $pocket używa $value, a żadne inne pole tam jej nie przyjmie.';
  }

  @override
  String exPocketsFill(Object sum, Object pocket, Object gone, Object cell) {
    return 'Żaden sposób wypełnienia kieszonki $pocket różnymi cyframi o sumie $sum nie stawia $gone w $cell.';
  }

  @override
  String exPocketsLineRow(Object sum, Object pocket, Object value, Object row) {
    return 'Każdy sposób ułożenia $sum w kieszonce $pocket używa $value, a tam może ona stać tylko w wierszu $row, więc w reszcie wiersza $row nie będzie $value.';
  }

  @override
  String exPocketsLineCol(Object sum, Object pocket, Object value, Object col) {
    return 'Każdy sposób ułożenia $sum w kieszonce $pocket używa $value, a tam może ona stać tylko w kolumnie $col, więc w reszcie kolumny $col nie będzie $value.';
  }

  @override
  String exPocketsLineBox(Object sum, Object pocket, Object value, Object box) {
    return 'Każdy sposób ułożenia $sum w kieszonce $pocket używa $value, a tam może ona stać tylko w bloku $box, więc w reszcie bloku $box nie będzie $value.';
  }

  @override
  String exPocketsFailSum(Object pocket, Object sum) {
    return 'Ale wtedy kieszonka $pocket nie może już dać $sum.';
  }

  @override
  String exPocketsFailCells(Object cells, Object sum) {
    return 'Ale wtedy $cells nie mogą już dać w sumie $sum.';
  }

  @override
  String exPocketsRegionRow(Object row) {
    return 'w wierszu $row';
  }

  @override
  String exPocketsRegionCol(Object col) {
    return 'w kolumnie $col';
  }

  @override
  String exPocketsRegionBox(Object box) {
    return 'w bloku $box';
  }

  @override
  String exPocketsRegionRows(Object from, Object to) {
    return 'w wierszach $from–$to';
  }

  @override
  String exPocketsRegionCols(Object from, Object to) {
    return 'w kolumnach $from–$to';
  }

  @override
  String exPocketsInnie(Object region, Object total, Object inside, Object cells, Object sum) {
    return 'Cyfry $region dają w sumie $total, a kieszonki leżące tam w całości – $inside, więc $cells dają w sumie $sum';
  }

  @override
  String exPocketsOutie(Object region, Object total, Object reach, Object cells, Object sum) {
    return 'Cyfry $region dają w sumie $total, a kieszonki, które tam wchodzą – $reach, więc $cells poza tym obszarem dają w sumie $sum';
  }

  @override
  String exPocketsAreaCombo(Object lead, Object digits, Object cell, Object gone) {
    return '$lead. Te pola mogą mieć tylko $digits, więc w $cell nie może być $gone.';
  }

  @override
  String exPocketsAreaMust(Object lead, Object value, Object cell) {
    return '$lead. Każdy taki sposób używa $value, a z tych pól przyjąć ją może tylko $cell.';
  }

  @override
  String exPocketsAreaFill(Object lead, Object gone, Object cell) {
    return '$lead. Żaden sposób zrobienia tego różnymi cyframi nie stawia $gone w $cell.';
  }

  @override
  String get chambersName => 'Komnaty';

  @override
  String get chambersTagline => 'Zamaluj w każdej komnacie tyle pól, ile trzeba, i nie ciągnij długich linii';

  @override
  String get chambersRules =>
      '• Siatka jest podzielona na komnaty. Liczba w komnacie mówi, ile jej pól jest zamalowanych; komnata bez liczby może mieć ich dowolnie wiele.\n• Zamalowane pola nigdy nie stykają się bokami.\n• Niezamalowane pola tworzą jeden spójny obszar.\n• Prosta linia niezamalowanych pól, w poziomie lub w pionie, nigdy nie przecina dwóch granic komnat: sięga najwyżej do dwóch komnat.\n\nDotknij pola, aby przełączać: zamalowane → kropka (twoja notatka „zostaje”) → puste. Prawy przycisk przełącza wstecz. Długie naciśnięcie stawia kropki obok zamalowanych pól i w reszcie każdej komnaty, która ma już wszystkie zamalowane pola. Kropki są opcjonalne: zagadka jest rozwiązana, gdy właściwe pola są zamalowane.';

  @override
  String get tutChambers1 =>
      'Siatka jest podzielona na komnaty, a liczba mówi, ile pól jej komnaty jest zamalowanych. Zamalowane pola nigdy nie stykają się bokami. Komnata z 0 zostaje pusta, a jednopolowa komnata z 1 jest zamalowana. Dotknij pola, aby je zamalować.';

  @override
  String get tutChambers2 =>
      'Prosta linia niezamalowanych pól nie może przecinać dwóch granic komnat. Zaznaczony wiersz biegnie przez trzy komnaty, a dwie z nich nie mają zamalowanych pól, więc linię musi przerwać trzecia. Dokończ planszę.';

  @override
  String get tutChambers3 =>
      'Niezamalowane pola muszą tworzyć jedną całość. Gdy sąsiednie pole jest zamalowane, jedynym wyjściem dla lewego górnego pola jest pole pod nim, więc ono zostaje. Dotknij pola dwa razy, aby postawić kropkę (twoja notatka, że zostaje), a potem dokończ planszę.';

  @override
  String get tutChambers4 =>
      'Teraz prawdziwa plansza. Zacznij od komnat z 0, komnat, które potrzebują wszystkich pozostałych pól, i długich linii przez kilka komnat.';

  @override
  String get tutChambersS1 =>
      'Policz, jak komnata może pomieścić swoje zamalowane pola. Zaznaczona komnata ma trzy pola długości i liczbę 2, a zamalowane pola się nie stykają, więc zamalować można tylko jej dwa końce. Zamaluj je, a potem dokończ planszę.';

  @override
  String get tutChambersS2 =>
      'Sprawdzaj każdy sposób rozmieszczenia zamalowanych pól komnaty: żadne dwa się nie stykają, a każda długa linia przez komnatę, którą tylko ona może przerwać, musi zostać przerwana. Pole zamalowane w każdym sposobie jest zamalowane, a pole nigdy niezamalowane zostaje. Zostaje też pole, którego zamalowanie przecięłoby niezamalowane pola na dwie części.';

  @override
  String get tutChambersS3 =>
      'Trudna plansza. Gdy utkniesz, zamaluj pole i zobacz, co dalej: jeśli komnata dostanie za dużo zamalowanych pól, długiej linii nie da się przerwać albo jakieś pola zostaną odcięte, to pole zostaje.';

  @override
  String exChambersFull(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ma już wszystkie $count zamalowanego pola',
      many: 'ma już wszystkie $count zamalowanych pól',
      few: 'ma już wszystkie $count zamalowane pola',
      one: 'ma już swoje 1 zamalowane pole',
      zero: 'nie ma zamalowanych pól',
    );
    return '$cell zostaje: komnata $room $_temp0.';
  }

  @override
  String exChambersNeed(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '1 pole',
    );
    return '$cell jest zamalowane: w komnacie $room trzeba zamalować $_temp0, a innych wolnych pól tam nie ma.';
  }

  @override
  String exChambersSpan(Object cell, Object a, Object b) {
    return '$cell jest zamalowane: inaczej wszystkie pola od $a do $b by zostały, a to prosta linia przez dwie granice komnat.';
  }

  @override
  String exChambersWaysShade(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '1 pole',
    );
    return '$cell jest zamalowane: tak robi każdy sposób zamalowania w komnacie $room $_temp0 tak, by się nie stykały, a każda długa linia była przerwana.';
  }

  @override
  String exChambersWaysKeep(Object cell, Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '1 pole',
    );
    return '$cell zostaje: żaden sposób zamalowania w komnacie $room $_temp0 tak, by się nie stykały, a każda długa linia była przerwana, go nie zamalowuje.';
  }

  @override
  String exChambersFailMany(Object room, int count) {
    return 'Ale wtedy komnata $room ma więcej zamalowanych pól niż $count.';
  }

  @override
  String exChambersFailFew(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '1 pole',
    );
    return 'Ale wtedy w komnacie $room nie da się zamalować $_temp0.';
  }

  @override
  String exChambersFailSpan(Object a, Object b) {
    return 'Ale wtedy wszystkie pola od $a do $b zostają, a to prosta linia przez dwie granice komnat.';
  }

  @override
  String exChambersFailWays(Object room, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '1 pole',
    );
    return 'Ale wtedy w komnacie $room nie da się zamalować $_temp0 tak, by się nie stykały, a każda długa linia była przerwana.';
  }

  @override
  String get lookoutName => 'Widok';

  @override
  String get lookoutTagline => 'Zamaluj pola tak, by każda liczba widziała dokładnie tyle, ile mówi';

  @override
  String get lookoutRules =>
      '• Każda liczba mówi, ile pól widzi w poziomie i w pionie, licząc siebie: wzdłuż swojego wiersza i kolumny aż do pierwszego zamalowanego pola lub krawędzi.\n• Pola z liczbami nigdy nie są zamalowane.\n• Zamalowane pola nigdy nie stykają się bokami.\n• Niezamalowane pola tworzą jeden spójny obszar.\n\nDotknij pola, aby przełączać: zamalowane → kropka (twoja notatka „zostaje”) → puste. Prawy przycisk przełącza wstecz. Długie naciśnięcie stawia kropki obok zamalowanych pól i na każdym polu, które widzi liczba, gdy zamalowane pola zamknęły już jej widok dokładnie na jej wartości. Kropki są opcjonalne: łamigłówka jest rozwiązana, gdy właściwe pola są zamalowane.';

  @override
  String get tutLookout1 =>
      'Każda liczba liczy pola, które widzi wzdłuż swojego wiersza i kolumny, łącznie z sobą, aż do zamalowanego pola lub krawędzi. Zamalowane pola nigdy nie stykają się bokami, a pola z liczbami nigdy nie są zamalowane. Dolna 2 widzi już siebie i 4 nad sobą, więc we wszystkich innych kierunkach jej widok musi się zatrzymać: zamaluj pola obok niej i pole za 4.';

  @override
  String get tutLookout2 =>
      'Policz, jak daleko liczba mogłaby widzieć najwyżej. 5 mogłaby widzieć najwyżej pięć pól: siebie, dwa po bokach i dwa nad sobą. Widzi więc je wszystkie i wszystkie zostają. Dokończ planszę.';

  @override
  String get tutLookout3 =>
      'Niezamalowane pola muszą tworzyć jedną całość. Gdy pole pod 3 jest zamalowane, prawy dolny róg może dotrzeć do reszty tylko przez pole na lewo od niego, więc to pole zostaje. Dotknij pola dwa razy, aby postawić kropkę (twoja notatka, że zostaje), a potem dokończ planszę.';

  @override
  String get tutLookout4 =>
      'Teraz prawdziwa plansza. Zacznij od liczb, które w jakimś kierunku widzą już wszystko, co mogą, i od dużych liczb, które ledwo widzą wystarczająco daleko.';

  @override
  String get tutLookoutS1 =>
      'Widok liczby kończy się na krawędzi lub na zamalowanym polu, nigdy na innej liczbie. 2 widzi jedno pole oprócz siebie. W lewo jej widok nie może się zatrzymać po jednym polu, bo następne to 3, więc widzi pole pod sobą: pole na lewo od niej i drugie pole w dół są zamalowane.';

  @override
  String get tutLookoutS2 =>
      'Sprawdzaj każdy sposób rozdzielenia liczby między cztery kierunki tak, by każdy widok kończył się na krawędzi lub na polu, które można zamalować. Pole widziane w każdym sposobie zostaje, a pole, na którym zatrzymuje się każdy sposób, jest zamalowane. Zostaje też pole, którego zamalowanie przecięłoby niezamalowane pola na dwie części.';

  @override
  String get tutLookoutS3 =>
      'Trudna plansza. Gdy utkniesz, zamaluj pole i zobacz, co dalej: jeśli jakaś liczba widzi wtedy za dużo lub za mało pól, dwa zamalowane pola się stykają albo jakieś pola zostaną odcięte, to pole zostaje.';

  @override
  String get tagSight => 'widzieć, widok, widoczność, patrzeć, wzrok, linia wzroku, obserwacja';

  @override
  String exLookoutReach(Object cell, Object clue, int count) {
    return '$cell zostaje: liczba $count w $clue nie widzi dość pól w innych kierunkach, więc widzi co najmniej aż dotąd.';
  }

  @override
  String exLookoutClose(Object cell, Object clue, int count) {
    return '$cell jest zamalowane: liczba $count w $clue widzi już w tym kierunku tyle pól, ile może, więc jej widok kończy się tutaj.';
  }

  @override
  String exLookoutWaysShade(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '$count pole',
    );
    return '$cell jest zamalowane: każdy sposób, w jaki liczba $count w $clue widzi dokładnie $_temp0, zatrzymuje jej widok tutaj.';
  }

  @override
  String exLookoutWaysKeep(Object cell, Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '$count pole',
    );
    return '$cell zostaje: widzi je każdy sposób, w jaki liczba $count w $clue widzi dokładnie $_temp0.';
  }

  @override
  String exLookoutFailMany(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '$count pole',
    );
    return 'Ale wtedy liczba $count w $clue widzi więcej niż $_temp0.';
  }

  @override
  String exLookoutFailFew(Object clue, int count) {
    return 'Ale wtedy liczba $count w $clue widzi za mało pól: mniej niż $count.';
  }

  @override
  String exLookoutFailWays(Object clue, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pola',
      many: '$count pól',
      few: '$count pola',
      one: '$count pole',
    );
    return 'Ale wtedy liczba $count w $clue nie może widzieć dokładnie $_temp0: żaden widok właściwej długości nie kończy się na krawędzi ani na polu, które można zamalować.';
  }

  @override
  String get rampartName => 'Wał';

  @override
  String get rampartTagline => 'Zbuduj jeden kręty mur pasujący do wskazówek wokół';

  @override
  String get rampartRules =>
      '• Zamaluj pola tak, aby wszystkie zamalowane pola tworzyły jeden mur, połączony bokami.\n• Żaden blok 2×2 nie jest cały zamalowany.\n• Pola ze wskazówkami nigdy nie są zamalowane. Wskazówka podaje ciągi zamalowanych pól wśród jej ośmiu sąsiadów, także po przekątnej, czytane dookoła niej: „3 1” oznacza ciąg trzech pól z rzędu i osobne pojedyncze pole, w dowolnej kolejności. 0 oznacza, że żadne z nich nie jest zamalowane.\n\nDotknij pola, aby przełączać: zamalowane → kropka (twoja notatka „zostaje”) → puste. Prawy przycisk przełącza wstecz. Długie naciśnięcie stawia kropkę na ostatnim polu bloku 2×2 z trzema zamalowanymi polami i wokół każdej wskazówki, którą zamalowane pola już spełniają. Kropki są opcjonalne: łamigłówka jest rozwiązana, gdy właściwe pola są zamalowane.';

  @override
  String get tutRampart1 =>
      'Zamalowuj pola, aby zbudować jeden mur. Każda wskazówka mówi, które z jej ośmiu sąsiadów, także po przekątnej, są zamalowane: 3 to ciąg trzech z rzędu wokół niej, a 0 oznacza, że żaden nie jest. Pola ze wskazówkami nigdy nie są zamalowane.';

  @override
  String get tutRampart2 =>
      'Żaden blok 2×2 nie może być cały zamalowany. Zamaluj to, czego wymagają wskazówki, a lewe górne pole musi zostać, bo inaczej jego blok się zapełni. Dotknij pola dwa razy, aby postawić kropkę (twoja notatka, że zostaje).';

  @override
  String get tutRampart3 =>
      'Wskazówka z kilku liczb ma tyle samo osobnych ciągów: 2 2 to dwa ciągi po dwa pola, a między nimi pola, które zostają. Wszystkie zamalowane pola łączą się w jeden mur, więc oba ciągi spotykają się po lewej stronie.';

  @override
  String get tutRampart4 =>
      'Teraz prawdziwa plansza. Zacznij od wskazówek, które zostawiają jeden sposób ułożenia ciągów, jak duże liczby i zera, i utrzymuj mur w jednym kawałku.';

  @override
  String get tutRampartS1 =>
      'Każdy ciąg wokół wskazówki musi nadal móc połączyć się z resztą muru. Wskazówka 1 1 potrzebuje dwóch osobnych zamalowanych pól. Górny róg zamalowany sam zostałby zamknięty przez wskazówkę i pola wokół, które zostają, więc oba rogi zostają, a jedyna para, jaka zostaje, to pola po obu stronach środkowego.';

  @override
  String get tutRampartS2 =>
      'Porównuj każdy sposób spełnienia wskazówki z innymi zasadami: sposób, który zapełnia blok 2×2 albo zamyka część muru, odpada. Poza tym pole, bez którego mur rozpadłby się na dwie części, jest zamalowane, a pola, do których mur nie dosięgnie, zostają.';

  @override
  String get tutRampartS3 =>
      'Trudna plansza. Gdy utkniesz, zamaluj pole i zobacz, co dalej: jeśli jakiejś wskazówki nie da się wtedy spełnić, blok 2×2 się zapełnia albo mur się rozpada, to pole zostaje.';

  @override
  String exRampartClueShade(Object cell, Object clue) {
    return '$cell jest zamalowane: każdy sposób spełnienia wskazówki w $clue je zamalowuje.';
  }

  @override
  String exRampartClueKeep(Object cell, Object clue) {
    return '$cell zostaje: żaden sposób spełnienia wskazówki w $clue go nie zamalowuje.';
  }

  @override
  String exRampartWaysShade(Object cell, Object clue) {
    return '$cell jest zamalowane: każdy sposób spełnienia wskazówki w $clue bez zamalowanego bloku 2×2 i bez zamkniętej części muru je zamalowuje.';
  }

  @override
  String exRampartWaysKeep(Object cell, Object clue) {
    return '$cell zostaje: żaden sposób spełnienia wskazówki w $clue bez zamalowanego bloku 2×2 i bez zamkniętej części muru go nie zamalowuje.';
  }

  @override
  String exRampartPool(Object cell, Object area) {
    return '$cell zostaje: reszta bloku 2×2 $area jest zamalowana.';
  }

  @override
  String exRampartEscape(Object cell, Object other) {
    return '$cell jest zamalowane: to jedyne wyjście dla części muru w $other.';
  }

  @override
  String exRampartCut(Object cell) {
    return '$cell jest zamalowane: gdyby zostało, mur rozpadłby się na dwie części.';
  }

  @override
  String exRampartAway(Object cell) {
    return '$cell zostaje: mur do niego nie dosięgnie.';
  }

  @override
  String exRampartFailClue(Object clue) {
    return 'Ale wtedy wskazówki w $clue nie da się spełnić.';
  }

  @override
  String exRampartFailPool(Object area) {
    return 'Ale wtedy blok 2×2 $area jest cały zamalowany.';
  }

  @override
  String exRampartFailShut(Object cell) {
    return 'Ale wtedy część muru w $cell jest zamknięta.';
  }

  @override
  String exRampartFailWays(Object clue) {
    return 'Ale wtedy wskazówki w $clue nie da się spełnić bez zamalowanego bloku 2×2 albo zamkniętej części muru.';
  }

  @override
  String exRampartFailApart(Object a, Object b) {
    return 'Ale wtedy zamalowanych pól $a i $b nie da się połączyć.';
  }

  @override
  String get waymarksName => 'Znaki szlaku';

  @override
  String get waymarksTagline => 'Każdy znak wskazuje drogę do następnej liczby';

  @override
  String get waymarksRules =>
      '• W każdym polu jest strzałka, poza ostatnim, w którym jest pierścień.\n• Ponumeruj pola 1, 2, 3, … aż do ostatniego tak, aby każda strzałka wskazywała pole z następną liczbą. To pole może leżeć w dowolnej odległości na linii strzałki, z innymi polami pomiędzy.\n• Niektóre liczby są pokazane, zawsze 1 i ostatnia.\n\nPrzeciągnij od pola do pola, które następuje po nim, albo dotknij jednego, a potem drugiego, aby je połączyć. Połączone pola liczą dalej od pokazanej liczby w ich łańcuchu; łańcuch bez niej dostaje literę (a, a+1, …), dopóki się z taką nie połączy. Dotknij wybranego pola jeszcze raz, aby cofnąć jego połączenie, albo przytrzymaj pole (prawy klik), aby zerwać wszystkie jego połączenia.';

  @override
  String get tutWaymarks1 =>
      'Ponumeruj pola od 1 do pierścienia: każda strzałka wskazuje następną liczbę, w dowolnej odległości na swojej linii. Strzałka, przed którą jest tylko jedno wolne pole, prowadzi tam. Przeciągnij od pola do następnego, aby je połączyć, albo dotknij jednego, a potem drugiego.';

  @override
  String get tutWaymarks2 =>
      'Patrz też wstecz: każde pole poza 1 potrzebuje pola przed sobą. Jeśli na pole wskazuje tylko jedna wolna strzałka, to pole następuje zaraz po polu tej strzałki.';

  @override
  String get tutWaymarks3 =>
      'Połączone pola liczą dalej od pokazanej liczby, a łańcuch bez niej dostaje literę: a, a+1, … Dwie pokazane liczby różniące się o jeden, jak 12 i 13, są zawsze połączone, a pola, których liczby nie różnią się o jeden, nigdy.';

  @override
  String get tutWaymarks4 =>
      'Łańcuch nigdy nie prowadzi z powrotem do swojego pierwszego pola: zamknąłby pętlę, a liczby tylko rosną. Więc koniec łańcucha nie może połączyć się z początkiem tego samego łańcucha.';

  @override
  String get tutWaymarks5 =>
      'Teraz prawdziwa plansza. Łącz pola, z których jest tylko jedna droga dalej albo do których prowadzi tylko jedna, licz od pokazanych liczb i nie pozwól łańcuchom wracać do swojego początku.';

  @override
  String get tutWaymarksS1 =>
      'Pomyśl, jakimi liczbami pole może jeszcze być. Jego liczba jest o jeden większa od liczby pola, które może do niego prowadzić, i o jeden mniejsza od liczby pola, do którego może prowadzić, a żadna liczba się nie powtarza. Zawężaj tak pola, aż dla jakiegoś połączenia zostanie jeden wybór.';

  @override
  String get tutWaymarksS2 =>
      'Dwa pola można połączyć tylko wtedy, gdy ich liczby mogą różnić się o jeden. Gdy żadna możliwa liczba drugiego pola nie jest o jeden większa od możliwej liczby pierwszego, skreśl to połączenie i szukaj tego, co zostało.';

  @override
  String get tutWaymarksS3 =>
      'Trudna plansza. Gdy utkniesz, załóż jakieś połączenie i rozumuj dalej: jeśli któremuś polu nie zostanie droga dalej, droga do niego albo liczba, to połączenie jest błędne.';

  @override
  String exWaymarksOnlyOut(Object from, Object to) {
    return '$from może prowadzić tylko do $to: przed jego strzałką nie zostało inne pole.';
  }

  @override
  String exWaymarksOnlyIn(Object from, Object to) {
    return 'Tylko $from może jeszcze prowadzić do $to, więc $to następuje zaraz po nim.';
  }

  @override
  String exWaymarksTaken(Object from, Object to) {
    return '$from prowadzi do $to, więc żadne inne połączenie nie wychodzi z $from ani nie dochodzi do $to.';
  }

  @override
  String exWaymarksConsecutive(Object from, Object to, Object a, Object b) {
    return '$from to $a, a $to to $b, więc $to następuje zaraz po $from.';
  }

  @override
  String exWaymarksApart(Object from, Object to, Object a, Object b) {
    return '$from to $a, a $to to $b, nie następna liczba, więc $from nie prowadzi do $to.';
  }

  @override
  String exWaymarksLoop(Object from, Object to) {
    return '$from nie może prowadzić do $to: łańcuch przez $from zaczyna się w $to, więc zamknęłoby to pętlę.';
  }

  @override
  String exWaymarksNoFit(Object from, Object to) {
    return '$from nie może prowadzić do $to: żadna możliwa liczba $to nie jest o jeden większa od możliwej liczby $from.';
  }

  @override
  String exWaymarksNumberOn(Object cell, Object nums) {
    return '$cell to $nums: jego łańcuch liczy od pokazanej liczby.';
  }

  @override
  String exWaymarksFailStuck(Object cell) {
    return 'Ale wtedy $cell nie ma pola, do którego mogłoby prowadzić dalej.';
  }

  @override
  String exWaymarksFailNoPrev(Object cell) {
    return 'Ale wtedy żadne pole nie może prowadzić do $cell.';
  }

  @override
  String exWaymarksFailNumber(Object cell) {
    return 'Ale wtedy żadna liczba nie pasuje do $cell.';
  }

  @override
  String exWaymarksFailLoop(Object cell) {
    return 'Ale wtedy łańcuch przez $cell zamyka pętlę.';
  }

  @override
  String exWaymarksFailLink(Object from, Object to) {
    return 'Ale wtedy połączenia w $from i $to są sprzeczne.';
  }

  @override
  String exWaymarksSupposeOn(Object from, Object to) {
    return 'Załóżmy, że $from prowadzi do $to.';
  }

  @override
  String exWaymarksSupposeOff(Object from, Object to) {
    return 'Załóżmy, że $from nie prowadzi do $to.';
  }

  @override
  String exWaymarksRefutedOff(Object from, Object to) {
    return 'Zatem $from nie prowadzi do $to.';
  }

  @override
  String exWaymarksRefutedOn(Object from, Object to) {
    return 'Zatem $from prowadzi do $to.';
  }

  @override
  String get tagArrow => 'strzałka, strzałki, kierunek, wskaźnik';

  @override
  String exWaymarksNumbers(Object cell, Object nums) {
    return '$cell może być tylko $nums.';
  }

  @override
  String get polesName => 'Bieguny';

  @override
  String get polesTagline => 'Daj każdej płytce koniec + i −, albo żadnego, by zgadzały się liczby na brzegach';

  @override
  String get polesRules =>
      '• Siatka jest podzielona na domina. Każde domino jest albo naładowane, z + na jednym końcu i − na drugim, albo neutralne.\n• Dwa pola z + nigdy nie stykają się bokiem, tak samo dwa pola z −.\n• Liczby z lewej i nad siatką mówią, ile pól z + jest w każdym wierszu i kolumnie; liczby z prawej i pod siatką liczą pola z −. Na trudnych planszach niektóre liczby są ukryte.\n\nDotknij pola, by przełączać: + → − → kropka (neutralne) → puste. Prawy klik przełącza wstecz. Przesuń po polach, by ustawić je wszystkie naraz. Długie przytrzymanie uzupełnia drugi koniec każdego zaczętego domina (− naprzeciw +, kropkę naprzeciw kropki) i stawia kropki w reszcie każdej linii, która ma już wszystkie swoje + i −. Kropki są opcjonalne: łamigłówka jest rozwiązana, gdy wszystkie + i − są na miejscu. Liczba blednie, gdy jej linia ma ich tyle.';

  @override
  String get tutPoles1 =>
      'Siatka jest podzielona na domina. Każde jest albo naładowane, z + na jednym końcu i − na drugim, albo neutralne. Liczby z lewej i u góry liczą pola z + w każdym wierszu i kolumnie, liczby z prawej i u dołu liczą pola z −. Dotknij pola, by przełączać +, −, kropkę (neutralne).';

  @override
  String get tutPoles2 =>
      'Dwa pola z + nigdy nie stykają się bokiem, tak samo dwa z −. To mówi, jak obrócone jest domino: jego + nie może stać obok innego +. Dokończ planszę.';

  @override
  String get tutPoles3 =>
      'Dodaj dwie liczby linii: tyle jej pól jest naładowanych. Gdy linia ma ich już tyle, reszta jej pól jest neutralna; gdy potrzebuje każdego pola, które może jeszcze być naładowane, żadne z nich nie jest neutralne. Dokończ planszę.';

  @override
  String get tutPoles4 =>
      'Teraz prawdziwa plansza. Zacznij od linii z zerami albo takich, które potrzebują każdego pola, i pamiętaj: na drugim końcu domina jest zawsze przeciwny znak.';

  @override
  String get tutPolesS1 =>
      'Przemyśl wszystkie sposoby wypełnienia jednej linii: jej liczby, jej domina i zasada, że jednakowe końce się nie stykają, zostawiają ich niewiele. Wartość, której żaden sposób nie stawia w polu, jest tam wykluczona. Spójrz na długie wiersze tej planszy.';

  @override
  String get tutPolesS2 =>
      'Trudna plansza: niektóre liczby są ukryte. Gdy utkniesz, załóż, że w polu jest +, i idź dalej: jeśli linia nie zbierze swoich liczb albo spotkają się jednakowe końce, w tym polu nie ma +.';

  @override
  String get tagCharge => 'plus, minus, dodatni, ujemny, ładunek, elektryczność, biegunowość, przyciągać, odpychać';

  @override
  String exPolesPartner(Object cell, Object value, Object other, Object opposite) {
    return 'W $cell jest $value: na drugim końcu domina, w $other, jest $opposite.';
  }

  @override
  String exPolesPartnerOut(Object cell, Object value, Object other, Object opposite) {
    return 'W $cell nie może być $value: na drugim końcu domina, w $other, nie może być $opposite.';
  }

  @override
  String exPolesRepel(Object cell, Object value, Object other) {
    return 'W $cell nie może być $value: pole styka się z $value w $other.';
  }

  @override
  String exPolesRowDone(Object value, Object row, int count) {
    return 'Wiersz $row ma już tyle $value, ile trzeba ($count): innych $value w nim nie ma.';
  }

  @override
  String exPolesColDone(Object value, Object col, int count) {
    return 'Kolumna $col ma już tyle $value, ile trzeba ($count): innych $value w niej nie ma.';
  }

  @override
  String exPolesRowNeed(Object cell, Object value, Object row, int count) {
    return 'W $cell jest $value: wiersz $row potrzebuje tylu $value ($count), ile pól może je jeszcze mieć.';
  }

  @override
  String exPolesColNeed(Object cell, Object value, Object col, int count) {
    return 'W $cell jest $value: kolumna $col potrzebuje tylu $value ($count), ile pól może je jeszcze mieć.';
  }

  @override
  String exPolesRowBlank(Object cell, Object row, int count, Object plus, Object minus) {
    return '$cell jest neutralne: wiersz $row ma już wszystkie pola z $plus lub $minus ($count).';
  }

  @override
  String exPolesColBlank(Object cell, Object col, int count, Object plus, Object minus) {
    return '$cell jest neutralne: kolumna $col ma już wszystkie pola z $plus lub $minus ($count).';
  }

  @override
  String exPolesRowCharged(Object row, int count, Object plus, Object minus) {
    return 'Wiersz $row potrzebuje tylu pól z $plus lub $minus ($count), ile może je jeszcze mieć: żadne z nich nie jest neutralne.';
  }

  @override
  String exPolesColCharged(Object col, int count, Object plus, Object minus) {
    return 'Kolumna $col potrzebuje tylu pól z $plus lub $minus ($count), ile może je jeszcze mieć: żadne z nich nie jest neutralne.';
  }

  @override
  String exPolesLast(Object cell, Object value) {
    return 'W $cell jest $value: nic innego nie zostało.';
  }

  @override
  String exPolesRowFill(Object cell, Object value, Object row) {
    return 'W $cell nie może być $value: żaden sposób wypełnienia wiersza $row zgodny z jego liczbami go tam nie stawia.';
  }

  @override
  String exPolesColFill(Object cell, Object value, Object col) {
    return 'W $cell nie może być $value: żaden sposób wypełnienia kolumny $col zgodny z jej liczbami go tam nie stawia.';
  }

  @override
  String exPolesFailEmpty(Object cell) {
    return 'Ale wtedy nic nie pasuje do $cell.';
  }

  @override
  String exPolesFailRowMany(Object row, Object value, int count) {
    return 'Ale wtedy wiersz $row ma za dużo $value (potrzebuje $count).';
  }

  @override
  String exPolesFailColMany(Object col, Object value, int count) {
    return 'Ale wtedy kolumna $col ma za dużo $value (potrzebuje $count).';
  }

  @override
  String exPolesFailRowFew(Object row, Object value, int count) {
    return 'Ale wtedy wiersz $row nie zbierze dość $value (potrzebuje $count).';
  }

  @override
  String exPolesFailColFew(Object col, Object value, int count) {
    return 'Ale wtedy kolumna $col nie zbierze dość $value (potrzebuje $count).';
  }

  @override
  String exPolesFailRowFill(Object row) {
    return 'Ale wtedy wiersza $row nie da się wypełnić zgodnie z jego liczbami.';
  }

  @override
  String exPolesFailColFill(Object col) {
    return 'Ale wtedy kolumny $col nie da się wypełnić zgodnie z jej liczbami.';
  }
}
