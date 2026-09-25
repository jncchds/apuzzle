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
}
