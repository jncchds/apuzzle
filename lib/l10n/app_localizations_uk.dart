// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get settings => 'Налаштування';

  @override
  String get playCode => 'Грати за кодом головоломки';

  @override
  String get playCodeMenu => 'Грати за кодом…';

  @override
  String get inProgress => 'Триває';

  @override
  String get size => 'Розмір';

  @override
  String get difficulty => 'Складність';

  @override
  String get difficultyEasy => 'Легко';

  @override
  String get difficultyMedium => 'Середньо';

  @override
  String get difficultyHard => 'Складно';

  @override
  String get difficultyExpert => 'Експерт';

  @override
  String notSolvedYet(Object difficulty) {
    return 'Ще не розв\'язано на рівні «$difficulty»';
  }

  @override
  String statsScore(Object count, Object score, Object time) {
    return 'Зіграно $count× · найкращий рахунок $score · найкращий час $time';
  }

  @override
  String statsTime(Object average, Object best, Object count) {
    return 'Розв\'язано $count× · найкраще $best · у середньому $average';
  }

  @override
  String get continueGame => 'Продовжити';

  @override
  String get newPuzzle => 'Нова головоломка';

  @override
  String get highlightErrors => 'Підсвічувати помилки під час гри';

  @override
  String get highlightErrorsHint =>
      'Вимкнено: помилки видно лише після натискання «Перевірити»';

  @override
  String get autoClearMarks => 'Автоматично прибирати позначки';

  @override
  String get autoClearMarksHint =>
      'Поставлене число прибирає цю позначку з рядка, стовпця й блоку';

  @override
  String get haptics => 'Вібровідгук';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get language => 'Мова';

  @override
  String get languageSystem => 'Як у системі';

  @override
  String get aboutLicenses => 'Про застосунок і ліцензії';

  @override
  String get linksTitle => 'Відкривати посилання на головоломки в застосунку';

  @override
  String get linksOn =>
      'Надіслані посилання на головоломки відкриваються в APuzzle';

  @override
  String linksOff(Object host) {
    return 'Вимкнено: торкніться й додайте $host у «Відкривати підтримувані посилання»';
  }

  @override
  String linksUnknown(Object host) {
    return 'Виберіть APuzzle для посилань $host';
  }

  @override
  String get couldNotOpenSettings =>
      'Не вдалося відкрити системні налаштування';

  @override
  String get submitConflicts => 'Деякі клітинки порушують правила';

  @override
  String get submitIncomplete => 'Ще не завершено';

  @override
  String get submitWrong => 'Не зовсім так';

  @override
  String get restartTitle => 'Почати спочатку?';

  @override
  String get restartBody => 'Усі ваші ходи буде стерто. Це можна скасувати.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get restart => 'Спочатку';

  @override
  String get gotIt => 'Зрозуміло';

  @override
  String get rules => 'Правила';

  @override
  String get copyShareLink => 'Копіювати посилання';

  @override
  String get shareLinkCopied => 'Посилання скопійовано';

  @override
  String get couldNotGenerate => 'Не вдалося створити головоломку';

  @override
  String get tryAgain => 'Спробувати ще';

  @override
  String get generating => 'Створюємо головоломку…';

  @override
  String get tapToCycle => 'Перебір дотиком';

  @override
  String get palette => 'Палітра';

  @override
  String get undo => 'Скасувати';

  @override
  String get redo => 'Повторити';

  @override
  String get hint => 'Підказка';

  @override
  String get submit => 'Перевірити';

  @override
  String get erase => 'Стерти';

  @override
  String get pencilMarks => 'Позначки олівцем';

  @override
  String get solved => 'Розв\'язано!';

  @override
  String scoreValue(Object score) {
    return 'Рахунок $score';
  }

  @override
  String get newBest => 'новий рекорд!';

  @override
  String bestValue(Object value) {
    return 'рекорд $value';
  }

  @override
  String hintsUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count підказки',
      many: '$count підказок',
      few: '$count підказки',
      one: '$count підказка',
    );
    return '$_temp0';
  }

  @override
  String get home => 'Головна';

  @override
  String get copyResult => 'Копіювати результат';

  @override
  String get resultCopied => 'Результат скопійовано, надішліть його другові';

  @override
  String shareSolved(int hints, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: '«$name»: розв\'язано за $time з $hints підказки.',
      many: '«$name»: розв\'язано за $time з $hints підказками.',
      few: '«$name»: розв\'язано за $time з $hints підказками.',
      one: '«$name»: розв\'язано за $time з $hints підказкою.',
      zero: '«$name»: розв\'язано за $time.',
    );
    return '$_temp0';
  }

  @override
  String shareScored(int hints, Object score, Object name, Object time) {
    String _temp0 = intl.Intl.pluralLogic(
      hints,
      locale: localeName,
      other: '«$name»: рахунок $score за $time з $hints підказки.',
      many: '«$name»: рахунок $score за $time з $hints підказками.',
      few: '«$name»: рахунок $score за $time з $hints підказками.',
      one: '«$name»: рахунок $score за $time з $hints підказкою.',
      zero: '«$name»: рахунок $score за $time.',
    );
    return '$_temp0';
  }

  @override
  String get shareChallenge => 'Зможеш краще?';

  @override
  String get paste => 'Вставити';

  @override
  String get play => 'Грати';

  @override
  String couldNotOpenLink(Object error) {
    return 'Не вдалося відкрити посилання: $error';
  }

  @override
  String codeExpected(Object example) {
    return 'Очікується код на зразок $example';
  }

  @override
  String codeUnknownPuzzle(Object id) {
    return 'Невідома головоломка «$id»';
  }

  @override
  String codeNoSize(Object name, Object size) {
    return '«$name» не має розміру $size';
  }

  @override
  String codeNoDifficulty(Object level, Object name) {
    return '«$name» не має складності «$level»';
  }

  @override
  String codeBadSeed(Object seed) {
    return 'Неправильне зерно «$seed»';
  }

  @override
  String codeBadVersion(Object version) {
    return 'Неправильна версія «$version»';
  }

  @override
  String get codeOtherVersion =>
      'Цей код з іншої версії застосунку, тож головоломка не збіглася б';

  @override
  String codeNoOption(Object choice, Object name) {
    return '«$name» не має параметра «$choice»';
  }

  @override
  String codeNoChoice(Object choice, Object name, Object option) {
    return '«$name»: параметр «$option» не має варіанта «$choice»';
  }

  @override
  String get valueSun => 'Сонце';

  @override
  String get valueMoon => 'Місяць';

  @override
  String get valueDot => 'Крапка';

  @override
  String get valueCrown => 'Корона';

  @override
  String get valueShade => 'Зафарбувати';

  @override
  String get valueGrass => 'Трава';

  @override
  String get valueTent => 'Намет';

  @override
  String get valueSea => 'Море';

  @override
  String get valueLamp => 'Лампа';

  @override
  String get colorBlue => 'Синій';

  @override
  String get colorPink => 'Рожевий';

  @override
  String get colorYellow => 'Жовтий';

  @override
  String get colorGreen => 'Зелений';

  @override
  String get outOfMoves => 'Ходи скінчилися: скасуйте хід або почніть спочатку';

  @override
  String movesOfLimit(Object moves, int limit) {
    String _temp0 = intl.Intl.pluralLogic(
      limit,
      locale: localeName,
      other: '$limit ходу',
      many: '$limit ходів',
      few: '$limit ходи',
      one: '$limit хід',
    );
    return '$moves / $_temp0';
  }

  @override
  String get bondsCantCross => 'Зв\'язки не можуть перетинатися';

  @override
  String get mamboName => 'Сонце й Місяць';

  @override
  String get mamboTagline => 'Урівноважте сонця й місяці';

  @override
  String get mamboRules =>
      '• Заповніть кожну клітинку сонцем або місяцем.\n• Не більше 2 однакових символів поспіль у рядку чи стовпці.\n• У кожному рядку й стовпці порівну сонць і місяців.\n• «=» між двома клітинками: у них однаковий символ.\n• «×» між двома клітинками: у них різні символи.\n• Заблоковані клітинки задано наперед.\n\nТоркніться клітинки, щоб перебрати: порожньо → сонце → місяць. Довге натискання / правий клік — у зворотному порядку.';

  @override
  String get sudokuName => 'Судоку';

  @override
  String get sudokuTagline => 'Кожне число раз у рядку, стовпці й блоці';

  @override
  String get sudokuRules =>
      '• Заповніть кожну клітинку числом від 1 до N (N — розмір сітки).\n• Кожне число трапляється рівно один раз у кожному рядку, кожному стовпці й кожному блоці.\n• Задані числа змінювати не можна.\n\nВиберіть число в палітрі й торкайтеся клітинок, щоб поставити його, або спершу торкніться клітинки, а потім числа. Кнопка з олівцем вмикає дрібні позначки. Довге натискання / правий клік очищає клітинку.';

  @override
  String get kingsName => 'Корони';

  @override
  String get kingsTagline => 'Одна корона в рядку, стовпці й області';

  @override
  String get kingsRules =>
      '• Поставте рівно одну корону в кожен рядок, кожен стовпець і кожну кольорову область.\n• Корони не можуть торкатися одна одної, навіть по діагоналі.\n\nТоркніться клітинки, щоб перебрати: порожньо → крапка (ваша позначка «тут корони немає») → корона. Довге натискання / правий клік — у зворотному порядку.';

  @override
  String get huesName => 'Відтінки';

  @override
  String get huesTagline => 'Порахуйте однакові кольори навколо чисел';

  @override
  String get huesRules =>
      '• Розфарбуйте кожну порожню клітинку кольорами з палітри.\n• Кожна клітинка з числом показує, скільки порожніх клітинок навколо неї (усі 8 сусідів, разом із діагональними) мають бути того самого кольору, що й вона.\n• Число зменшується, коли ви фарбуєте відповідних сусідів, тож воно показує, скільки ще бракує.\n• Самі клітинки з числами не враховуються.\n\nВиберіть колір у палітрі й торкайтеся клітинок, щоб фарбувати (повторний дотик очищає), або торкайтеся клітинки, щоб перебирати кольори.';

  @override
  String get mosaicName => 'Мозаїка';

  @override
  String get mosaicTagline => 'Залийте поле одним кольором';

  @override
  String get mosaicRules =>
      '• Кольорова область у верхньому лівому куті — ваша.\n• Виберіть колір: ваша область набуває цього кольору й поглинає всі сусідні клітинки такого ж кольору.\n• Зафарбуйте все поле одним кольором, не перевищивши ліміт ходів.\n\nТоркніться кольору в палітрі або будь-якої клітинки, щоб узяти її колір.';

  @override
  String get blendName => 'Злиття';

  @override
  String get blendTagline =>
      'Перефарбовуйте плями, доки не лишиться один колір';

  @override
  String get blendRules =>
      '• Поле складається з кольорових плям (сусідніх клітинок одного кольору).\n• Виберіть колір і торкніться будь-якої плями, щоб перефарбувати її. Вона зливається з усіма сусідніми плямами цього кольору.\n• Зробіть усе поле одного кольору, не перевищивши ліміт ходів.\n\nКолір у палітрі лишається вибраним, тож можна перефарбувати кілька плям поспіль.';

  @override
  String get popName => 'Бульбашки';

  @override
  String get popTagline => 'Лопайте великі групи — отримуйте багато очок';

  @override
  String get popRules =>
      '• Торкніться групи з 2 або більше сусідніх бульбашок одного кольору, щоб виділити її; торкніться ще раз, щоб лопнути.\n• Група з n бульбашок дає n × (n − 1) очок, тож великі групи варто збирати.\n• Бульбашки згори падають униз, а порожні стовпці зсуваються праворуч.\n\nРежими\n• Звичайний: лише це.\n• Зсув: кожен рядок також зсувається праворуч, закриваючи проміжки.\n• Безкінечний: коли звільняється місце, зліва з\'являються нові стовпці.\n• Мега: Зсув і Безкінечний разом.\n\nЦілі\n• Очистити поле: лопніть усі бульбашки (лише Звичайний режим; розв\'язок завжди є).\n• Цільовий рахунок: наберіть потрібну кількість очок, поки є ходи.\n• Вільна гра: без мети, просто побийте свій рекорд.\n\nГра закінчується, коли не лишається жодної групи з 2 бульбашок.';

  @override
  String get popMode => 'Режим';

  @override
  String get popModeStandard => 'Звичайний';

  @override
  String get popModeStandardHint =>
      'Бульбашки падають униз; порожні стовпці зсуваються праворуч.';

  @override
  String get popModeShifter => 'Зсув';

  @override
  String get popModeShifterHint =>
      'Рядки також зсуваються праворуч, закриваючи всі проміжки.';

  @override
  String get popModeContinuous => 'Безкінечний';

  @override
  String get popModeContinuousHint =>
      'Коли звільняється місце, зліва з\'являються нові стовпці.';

  @override
  String get popModeMega => 'Мега';

  @override
  String get popModeMegaHint => 'Зсув і Безкінечний разом.';

  @override
  String get popGoal => 'Мета';

  @override
  String get popGoalClear => 'Очистити поле';

  @override
  String get popGoalClearHint => 'Лопніть усі бульбашки. Розв\'язок завжди є.';

  @override
  String get popGoalTarget => 'Цільовий рахунок';

  @override
  String get popGoalTargetHint =>
      'Наберіть потрібний рахунок, поки лишаються ходи.';

  @override
  String get popGoalFree => 'Вільна гра';

  @override
  String get popGoalFreeHint =>
      'Без мети: грайте до кінця й побийте свій рекорд.';

  @override
  String get popCleared => 'Очищено!';

  @override
  String get popTargetReached => 'Мети досягнуто!';

  @override
  String get popGameOver => 'Гру закінчено';

  @override
  String popStuckBubbles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ходів немає, на полі $count бульбашки: скасуйте хід або почніть спочатку',
      many:
          'Ходів немає, на полі $count бульбашок: скасуйте хід або почніть спочатку',
      few:
          'Ходів немає, на полі $count бульбашки: скасуйте хід або почніть спочатку',
      one:
          'Ходів немає, на полі $count бульбашка: скасуйте хід або почніть спочатку',
    );
    return '$_temp0';
  }

  @override
  String popStuckPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ходів немає, бракує $count очка: скасуйте хід або почніть спочатку',
      many:
          'Ходів немає, бракує $count очок: скасуйте хід або почніть спочатку',
      few: 'Ходів немає, бракує $count очок: скасуйте хід або почніть спочатку',
      one: 'Ходів немає, бракує $count очка: скасуйте хід або почніть спочатку',
    );
    return '$_temp0';
  }

  @override
  String popPoints(Object score) {
    return '$score оч.';
  }

  @override
  String popLeft(Object count) {
    return 'лишилось $count';
  }

  @override
  String popColumns(Object count) {
    return '+$count стовп.';
  }

  @override
  String get pipesName => 'Труби';

  @override
  String get pipesTagline => 'З\'єднайте всі труби з джерелом';

  @override
  String get pipesRules =>
      '• Повертайте плитки так, щоб кожна труба була з\'єднана з джерелом (плитка з кільцем).\n• Жоден кінець труби не може лишатися відкритим, а мережа не може мати петель.\n• Вода тече всім, що вже з\'єднано з джерелом.\n• Плитки із замком уже стоять на місці.\n\nТоркніться плитки, щоб повернути її за годинниковою стрілкою; довге натискання / правий клік повертає назад.';

  @override
  String get shikakuName => 'Сікаку';

  @override
  String get shikakuTagline => 'Поділіть сітку на прямокутники з числами';

  @override
  String get shikakuRules =>
      '• Поділіть усю сітку на прямокутники (квадрати теж рахуються).\n• У кожному прямокутнику рівно одне число.\n• Це число дорівнює площі прямокутника в клітинках.\n\nПроведіть від одного кута до протилежного, щоб намалювати прямокутник. Торкніться прямокутника, щоб прибрати його.';

  @override
  String get trailName => 'Стежка';

  @override
  String get trailTagline => 'Один шлях через усі клітинки, числа по порядку';

  @override
  String get trailRules =>
      '• Намалюйте один шлях, що починається з 1 і проходить через кожну клітинку рівно один раз.\n• Шлях рухається вгору, вниз, ліворуч або праворуч (без діагоналей).\n• Він має проходити числа по порядку (1 → 2 → 3 → …) і закінчуватися на останньому числі.\n\nПроводьте, щоб малювати. Поверніться назад шляхом, щоб скасувати кроки, або торкніться клітинки шляху, щоб обрізати його там.';

  @override
  String get atomsName => 'Атоми';

  @override
  String get atomsTagline => 'З\'єднайте атоми відповідно до їхніх чисел';

  @override
  String get atomsRules =>
      '• З\'єднайте атоми горизонтальними або вертикальними зв\'язками.\n• Кожен атом має мати рівно стільки зв\'язків, скільки вказує його число.\n• Два атоми можуть мати один або два спільні зв\'язки.\n• Зв\'язки не можуть перетинатися чи проходити крізь атоми.\n• Усі атоми мають бути з\'єднані в одну молекулу.\n\nПроведіть від атома до сусіда, щоб додати зв\'язок (1 → 2 → нічого). Також можна торкнутися проміжку між двома атомами.';

  @override
  String get litsName => 'LITS';

  @override
  String get litsTagline => 'Одне тетраміно в кожній області';

  @override
  String get litsRules =>
      '• Зафарбуйте рівно 4 з\'єднані клітинки в кожній обведеній області, щоб вийшла фігура L, I, T або S (повороти й віддзеркалення дозволено).\n• Усі зафарбовані клітинки разом утворюють одну зв\'язну область.\n• Жоден блок 2×2 не може бути зафарбований повністю.\n• Дві однакові фігури не можуть торкатися одна одної через межу області.\n\nТоркніться клітинки, щоб перебрати: порожньо → зафарбовано → крапка (ваша позначка «не зафарбовано»).';

  @override
  String get labyrinthName => 'Лабіринт';

  @override
  String get labyrinthTagline => 'Знайдіть шлях з кута в кут';

  @override
  String get labyrinthRules =>
      '• Знайдіть шлях крізь лабіринт від входу в лівому верхньому куті до виходу в правому нижньому.\n• Крізь стіни проходити не можна.\n\nПроводьте від кінця шляху, щоб іти далі. Проведіть назад, щоб повернутися, або торкніться клітинки шляху, щоб відступити до неї.';

  @override
  String get campName => 'Кемпінг';

  @override
  String get campTagline => 'Поставте намет біля кожного дерева';

  @override
  String get campRules =>
      '• Поставте по одному намету на кожне дерево, поруч із ним (вгорі, внизу, ліворуч або праворуч).\n• У кожного дерева свій намет, і кожен намет належить одному сусідньому дереву.\n• Намети не торкаються один одного, навіть по діагоналі.\n• Числа за межами сітки показують, скільки наметів у кожному рядку та стовпці.\n\nТоркніться клітинки, щоб перебрати: порожньо → трава (ваша позначка «тут намету немає») → намет. Довге натискання / правий клік — у зворотному порядку.';

  @override
  String get islandsName => 'Острови';

  @override
  String get islandsTagline => 'Затопіть море навколо островів із числами';

  @override
  String get islandsRules =>
      '• Зафарбуйте море так, щоб незафарбовані клітинки утворили острови.\n• На кожному острові рівно одне число, і воно дорівнює розміру острова в клітинках.\n• Острови межують лише з морем, а не один з одним (кутами по діагоналі можна).\n• Усе море з\'єднане в одне ціле, і в ньому немає блоків 2×2.\n\nТоркніться клітинки, щоб перебрати: порожньо → море → крапка (ваша позначка «суходіл»). Довге натискання / правий клік — у зворотному порядку.';

  @override
  String get minesName => 'Міни';

  @override
  String get minesTagline => 'Знайдіть усі міни, лише логікою';

  @override
  String get minesRules =>
      '• Відкрийте всі клітинки без мін.\n• Число показує, скільки мін у 8 клітинках навколо нього.\n• Вгадувати ніколи не доведеться: кожне поле можна розчистити логікою.\n• Якщо навколо відкритої клітинки мін немає, її сусіди відкриваються теж.\n\nТоркніться клітинки, щоб копати, довге натискання / правий клік ставить прапорець (або ввімкніть «Прапорець» внизу). Торкніться числа, біля якого стоять усі прапорці, щоб розкопати решту навколо нього. Якщо копнути міну, вона вибухне й отримає прапорець, а гра триває.';

  @override
  String get minesDig => 'Копати';

  @override
  String get minesFlag => 'Прапорець';

  @override
  String get minesBoom => 'Бум! Це була міна, тепер вона позначена';

  @override
  String get lampsName => 'Лампи';

  @override
  String get lampsTagline =>
      'Освітіть усі клітинки, лампи не світять одна на одну';

  @override
  String get lampsRules =>
      '• Ставте лампи в білі клітинки. Лампа освітлює свою клітинку, а також рядок і стовпець до найближчої стіни.\n• Кожна біла клітинка має бути освітлена.\n• Жодна лампа не може світити на іншу лампу.\n• Число на стіні показує, скільки ламп стоїть поруч із нею (вгорі, внизу, ліворуч або праворуч).\n\nТоркніться клітинки, щоб перебрати: порожньо → крапка (ваша позначка «лампи немає») → лампа. Довге натискання / правий клік — у зворотному порядку.';

  @override
  String get fenceName => 'Паркан';

  @override
  String get fenceTagline => 'Одна петля навколо чисел';

  @override
  String get fenceRules =>
      '• Намалюйте одну замкнену петлю по пунктирних лініях.\n• Петля ніде не перетинає й не торкається сама себе.\n• Число показує, скільки з чотирьох сторін його клітинки проходить петля. Клітинки без числа можуть мати будь-яку кількість.\n\nТоркніться між двома точками, щоб провести лінію, ще раз — щоб позначити її хрестиком, і ще раз — щоб очистити. Проводьте від точки до точки, щоб малювати кілька ліній, або стирати їх, якщо почати на лінії.';

  @override
  String get pearlsName => 'Перли';

  @override
  String get pearlsTagline => 'Протягніть одну петлю крізь усі перлини';

  @override
  String get pearlsRules =>
      '• Намалюйте одну замкнену петлю через центри клітинок. Вона не перетинає й не торкається сама себе і не мусить проходити через кожну клітинку.\n• Петля проходить через кожну перлину.\n• На чорній перлині петля повертає, а в клітинках до і після неї йде прямо.\n• Через білу перлину петля йде прямо, а в клітинці до або після неї (чи в обох) повертає.\n\nПроводьте по клітинках, щоб малювати петлю, або вздовж неї, щоб стирати. Торкніться між двома клітинками, щоб перебрати: лінія → хрестик → порожньо.';
}
