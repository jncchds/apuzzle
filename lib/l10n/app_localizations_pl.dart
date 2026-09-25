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
  String get highlightErrorsHint =>
      'Wyłączone: błędy widać dopiero po naciśnięciu „Sprawdź”';

  @override
  String get autoClearMarks => 'Automatycznie usuwaj notatki';

  @override
  String get autoClearMarksHint =>
      'Wpisanie liczby usuwa tę notatkę z jej wiersza, kolumny i bloku';

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
  String get linksTitle => 'Otwieraj linki do łamigłówek w aplikacji';

  @override
  String get linksOn =>
      'Udostępnione linki do łamigłówek otwierają się w APuzzle';

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
  String get submitConflicts => 'Niektóre pola łamią zasady';

  @override
  String get submitIncomplete => 'Jeszcze nie skończone';

  @override
  String get submitWrong => 'Nie do końca';

  @override
  String get restartTitle => 'Zacząć od nowa?';

  @override
  String get restartBody =>
      'Wszystkie wpisy zostaną wyczyszczone. Nadal możesz to cofnąć.';

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
  String get codeOtherVersion =>
      'Ten kod pochodzi z innej wersji aplikacji, więc łamigłówka by się nie zgadzała';

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
  String get popModeStandardHint =>
      'Bąbelki spadają w dół; puste kolumny przesuwają się w prawo.';

  @override
  String get popModeShifter => 'Przesuwanie';

  @override
  String get popModeShifterHint =>
      'Wiersze też przesuwają się w prawo, zamykając każdą lukę.';

  @override
  String get popModeContinuous => 'Ciągły';

  @override
  String get popModeContinuousHint =>
      'Gdy zwalnia się miejsce, z lewej wjeżdżają nowe kolumny.';

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
      other:
          'Brak ruchów, na planszy zostało $count bąbelka: cofnij lub zacznij od nowa',
      many:
          'Brak ruchów, na planszy zostało $count bąbelków: cofnij lub zacznij od nowa',
      few:
          'Brak ruchów, na planszy zostały $count bąbelki: cofnij lub zacznij od nowa',
      one:
          'Brak ruchów, na planszy został $count bąbelek: cofnij lub zacznij od nowa',
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
  String get mergeGoalTargetHint =>
      'Osiągnij docelowy kafelek, zanim plansza się zablokuje.';

  @override
  String get mergeGoalFreeHint =>
      'Bez celu: graj, aż plansza się zablokuje, i pobij swój rekord.';

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
      '• Obracaj kafelki tak, aby każda rura łączyła się ze źródłem (kafelek z pierścieniem).\n• Żaden koniec rury nie może zostać otwarty, a sieć nie może mieć pętli.\n• Woda płynie przez wszystko, co jest już połączone ze źródłem.\n• Kafelki z kłódką są już na miejscu.\n\nDotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara; długie naciśnięcie / prawy przycisk obraca go z powrotem.';

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
      '• Stawiaj lampy na białych polach. Lampa oświetla swoje pole oraz wiersz i kolumnę aż do ściany.\n• Każde białe pole musi być oświetlone.\n• Żadna lampa nie może świecić na inną lampę.\n• Liczba na ścianie mówi, ile lamp stoi tuż obok niej (nad, pod, z lewej lub z prawej).\n\nDotknij pola, aby przełączać: puste → kropka (twoja notatka „bez lampy”) → lampa. Długie naciśnięcie / prawy przycisk przełącza wstecz.';

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
  String get tutorialOfferBody =>
      'Najpierw krótka interaktywna lekcja? Kilka małych plansz pokaże wszystkie zasady.';

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
  String get tutMambo1 =>
      'Wypełnij każde pole słońcem lub księżycem. Nigdy trzy takie same obok siebie: po dwóch słońcach obok siebie przychodzi księżyc. Dotknij zaznaczonego pola, aby przełączać: puste → słońce → księżyc.';

  @override
  String get tutMambo2 =>
      'W każdym wierszu i kolumnie jest tyle samo słońc co księżyców. Górny wiersz ma już oba słońca, więc reszta jego pól to księżyce. Prawa kolumna działa tak samo.';

  @override
  String get tutMambo3 =>
      '„=” między dwoma polami oznacza, że mają ten sam symbol. Wstaw w zaznaczone pola to samo, co mają sąsiedzi.';

  @override
  String get tutMambo4 =>
      '„×” oznacza, że pola są różne: jedno słońce, jeden księżyc.';

  @override
  String get tutMambo5 =>
      'Teraz cała plansza: użyj wszystkich zasad naraz. Wskazówka: przycisk palety u góry pozwala stawiać jeden symbol na wielu polach, a długie naciśnięcie (lub prawy przycisk) przełącza wstecz.';

  @override
  String get tutSudoku1 =>
      'W każdym wierszu, kolumnie i bloku (grube ramki) każda liczba od 1 do 4 występuje raz. W tym wierszu brakuje jednej liczby: wybierz ją w palecie i dotknij pustego pola.';

  @override
  String get tutSudoku2 =>
      'Według wiersza te dwa pola mogą mieć 3 lub 4. Rozstrzygają kolumny: w każdej brakuje tylko jednej liczby.';

  @override
  String get tutSudoku3 =>
      'Bloki też się liczą: w każdym bloku 1–4 występują raz. Dokończ ostatni blok.';

  @override
  String get tutSudoku4 =>
      'Nie masz pewności? Rób notatki. Włącz ołówek obok palety, wybierz zaznaczone pole i zanotuj wszystkie liczby, które mogą się tam jeszcze znaleźć.';

  @override
  String get tutSudoku5 =>
      'Teraz cała łamigłówka. Wybrane pole podświetla swój wiersz, kolumnę i blok oraz tę samą liczbę gdzie indziej. W ustawieniach możesz włączyć automatyczne usuwanie notatek.';

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
  String get tutHues1 =>
      'Pomaluj każde puste pole. Liczba mówi, ile pustych pól wokół niej (także po przekątnej) będzie miało jej kolor. Niebieska 3 ma dokładnie trzech pustych sąsiadów, więc wszyscy są niebiescy. Wybierz kolor w palecie i dotykaj pól.';

  @override
  String get tutHues2 =>
      'Liczby maleją, gdy malujesz: pokazują, ilu pasujących pól jeszcze brakuje. 0 oznacza, że żaden pusty sąsiad nie ma jej koloru, a pola z liczbami się nie liczą. Zacznij od niebieskiej 3, potem zobacz, czego jeszcze brakuje różowej 2.';

  @override
  String get tutHues3 =>
      'Teraz prawdziwa plansza. Zacznij od liczb, które potrzebują wszystkich pustych sąsiadów albo żadnego.';

  @override
  String get tutMosaic1 =>
      'Plama w lewym górnym rogu jest twoja. Wybierz kolor na dole: plama go przyjmie i wchłonie wszystkie stykające się pola tego koloru. Pomaluj całą planszę na jeden kolor.';

  @override
  String get tutMosaic2 =>
      'Uważaj na limit ruchów: wybieraj kolor, który najbardziej powiększy plamę. Dotknięcie pola na planszy też wybiera jego kolor.';

  @override
  String get tutMosaic3 =>
      'Teraz prawdziwa plansza, z kilkoma zapasowymi ruchami.';

  @override
  String get tutBlend1 =>
      'Plansza składa się z plam: stykających się pól jednego koloru. Wybierz kolor na dole i dotknij plamy, aby ją przemalować. Połączy się ze stykającymi plamami tego koloru. Przemaluj środkową plamę.';

  @override
  String get tutBlend2 =>
      'Jeden ruch może połączyć wiele plam. Środkowa plama styka się z czterema innymi: przemaluj ją, aby je połączyć, a potem dokończ. Masz tylko 2 ruchy.';

  @override
  String get tutBlend3 =>
      'Teraz prawdziwa plansza. Wybrany kolor zostaje, więc możesz malować kilka plam z rzędu.';

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
  String get tutMerge1 =>
      'Przesuń palcem (lub naciśnij strzałkę), aby przesunąć wszystkie kafelki do oporu. Dwa równe kafelki, które na siebie wpadną, łączą się w sumę. Zrób 4.';

  @override
  String get tutMerge2 =>
      'W jednym ruchu kafelek łączy się tylko raz: 4, 4, 8 zmienia się w 8, 8, a nie 16. Po każdym ruchu pojawia się nowa 2 (czasem 4). Zbuduj 16.';

  @override
  String get tutMerge3 =>
      'Trzymaj największy kafelek w rogu i dokarmiaj go krok po kroku. Zbuduj 32.';

  @override
  String get tutPipes1 =>
      'Dotknij kafelka, aby obrócić go zgodnie z ruchem wskazówek zegara (długie naciśnięcie lub prawy przycisk obraca z powrotem). Połącz wszystkie rury ze źródłem, kafelkiem z pierścieniem. Woda pokazuje, co już jest połączone.';

  @override
  String get tutPipes2 =>
      'Żaden koniec rury nie może zostać otwarty, więc żadna rura nie może wychodzić poza planszę. Kafelki z kłódką są już dobrze. Zacznij od brzegów i rogów, gdzie kafelki mają najmniej możliwości.';

  @override
  String get tutPipes3 =>
      'Teraz prawdziwa plansza. Sieć nie może tworzyć pętli.';

  @override
  String get tutShikaku1 =>
      'Podziel siatkę na prostokąty. Każdy zawiera dokładnie jedną liczbę, równą jego polu w kratkach. Przeciągnij od jednego rogu do przeciwległego, aby narysować prostokąt.';

  @override
  String get tutShikaku2 =>
      '1 to prostokąt sam w sobie: po prostu go dotknij. Dotknij narysowanego prostokąta, aby go usunąć. Tutaj 6 pasuje tylko na jeden sposób.';

  @override
  String get tutShikaku3 =>
      'Teraz prawdziwa plansza. Duże liczby przy brzegach zwykle mają najmniej możliwości.';

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
  String get tutLabyrinth1 =>
      'Przeciągnij od startu w lewym górnym rogu do flagi w prawym dolnym. Ściany blokują drogę.';

  @override
  String get tutLabyrinth2 =>
      'Większy labirynt. Ślepy zaułek? Przeciągnij z powrotem po swojej ścieżce albo dotknij dowolnego jej pola, aby tam wrócić. Szybkie przeciągnięcie biegnie prostymi korytarzami.';

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
  String get tutLits1 =>
      'Zamaluj dokładnie 4 pola w każdym obrysowanym obszarze, tworząc L, I, T lub S. Górny obszar ma dokładnie 4 pola, więc zamaluj wszystkie. Dotknij pola, aby je zamalować.';

  @override
  String get tutLits2 =>
      'Żaden blok 2×2 nie może być w całości zamalowany, a identyczne kształty nie stykają się przez granicę. Lewy obszar dopełnia tylko jedno pole. Które?';

  @override
  String get tutLits3 =>
      'Teraz prawdziwa plansza. Wszystkie zamalowane pola muszą być połączone. Dotknij dwa razy, aby postawić kropkę, notatkę, że pole zostaje puste.';

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
  String get tutIslands1 =>
      'Zamaluj morze tak, aby niezamalowane pola tworzyły wyspy. Każda liczba to wyspa z dokładnie tylu pól. Tu 1 jest wyspą sama w sobie: dotknij pozostałych pól, aby zrobić z nich morze.';

  @override
  String get tutIslands2 =>
      'Wyspy nigdy się nie stykają. Pole między dwiema liczbami musi być morzem, inaczej połączyłoby je w jedną wyspę.';

  @override
  String get tutIslands3 =>
      'Morze musi być połączone i nie może tworzyć basenów 2×2. Powiększ 3 tak, aby nie złamać żadnej z tych zasad. Dotknij dwa razy, aby postawić kropkę, notatkę „ląd”.';

  @override
  String get tutIslands4 =>
      'Teraz prawdziwa plansza. Każda wyspa ma dokładnie jedną liczbę.';

  @override
  String get tutLamps1 =>
      'Stawiaj lampy na białych polach: dotknij dwa razy (kropka, potem lampa). Lampa oświetla swój wiersz i kolumnę aż do ścian. Oświetl wszystkie białe pola.';

  @override
  String get tutLamps2 =>
      'Liczba na ścianie mówi, ile lamp jej dotyka (nad, pod, z lewej lub z prawej). Ta 3 potrzebuje lampy z każdej wolnej strony.';

  @override
  String get tutLamps3 =>
      'Lampy nigdy nie świecą na siebie, a 0 oznacza brak lampy tuż obok. Gdzie stanie druga lampa?';

  @override
  String get tutLamps4 =>
      'Teraz prawdziwa plansza. Kropkami zaznaczaj pola, na których nie może stać lampa.';

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
  String get tutPearls1 =>
      'Przeciągaj po polach, aby narysować jedną zamkniętą pętlę. Na czarnej perle pętla skręca, a potem biegnie prosto przez następne pole po obu stronach.';

  @override
  String get tutPearls2 =>
      'Przez białą perłę pętla biegnie prosto i skręca w polu tuż przed nią lub za nią (albo w obu).';

  @override
  String get tutPearls3 =>
      'Teraz prawdziwa plansza. Pętla nie musi przechodzić przez każde pole i nigdy się nie krzyżuje ani nie styka ze sobą.';

  @override
  String get tutMines1 =>
      'Liczba mówi, ile min jest w 8 polach wokół niej. Każda 1 tutaj dotyka tylko jednego zakrytego pola, więc tam jest mina. Postaw flagę: długie naciśnięcie lub prawy przycisk, albo włącz „Flaga” poniżej i dotknij.';

  @override
  String get tutMines2 =>
      'Mina tej 1 ma już flagę, więc wszystkie inne pola wokół są bezpieczne. Odkop je albo dotknij samej 1, aby odkopać wszystkie naraz.';

  @override
  String get tutMines3 =>
      'Pole bez min wokół samo odkrywa swoich sąsiadów. Kop w zaznaczonym rogu.';

  @override
  String get tutMines4 =>
      'Teraz prawdziwa plansza. Nigdy nie musisz zgadywać. Jeśli przez pomyłkę kopniesz minę, po prostu dostanie flagę, a gra toczy się dalej.';
}
