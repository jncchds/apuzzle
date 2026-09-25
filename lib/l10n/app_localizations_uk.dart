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
  String get dailyTitle => 'Щоденні виклики';

  @override
  String get dailyCalendar => 'Календар';

  @override
  String dailyProgress(int done, int total) {
    return 'Розв’язано $done з $total';
  }

  @override
  String get dailyDayComplete => 'День завершено!';

  @override
  String get dailyNext => 'Наступна';

  @override
  String get dailyToday => 'Сьогодні';

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
  String get mergeName => '2048';

  @override
  String get mergeTagline => 'Зсувай плитки, зливай пари, збирай найбільшу';

  @override
  String get mergeRules =>
      '• Проведи пальцем (або натисни стрілку), щоб усі плитки з’їхали в той бік до упору.\n• Дві плитки з однаковим числом, що зіткнулися, зливаються в одну з їхньою сумою. За один хід плитка зливається лише раз.\n• Після кожного ходу на порожній клітинці з’являється нова 2 (іноді 4).\n• Кожне злиття дає стільки очок, скільки на новій плитці.\n\nЦілі\n• Збери плитку: досягни цільової плитки (вона залежить від розміру поля та складності).\n• Вільна гра: грай, доки поле не заблокується, і побий свій рекорд.\n\nГра закінчується, коли поле заповнене і жодні сусіди не збігаються.';

  @override
  String get mergeGoalTarget => 'Збери плитку';

  @override
  String get mergeGoalTargetHint =>
      'Досягни цільової плитки, доки поле не заблоковане.';

  @override
  String get mergeGoalFreeHint =>
      'Без мети: грай, доки поле не заблокується, і побий свій рекорд.';

  @override
  String mergeReached(int tile) {
    return '$tile!';
  }

  @override
  String get mergeStuck => 'Ходів немає: скасуй хід або почни знову';

  @override
  String mergeBest(int tile) {
    return 'Макс. $tile';
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
  String get litsName => 'Тетра';

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

  @override
  String get learnTitle => 'Як грати';

  @override
  String get learnIntro =>
      'Короткі інтерактивні уроки: кожен крок — маленьке поле, що показує одне правило чи прийом.';

  @override
  String learnSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count кроку',
      many: '$count кроків',
      few: '$count кроки',
      one: '$count крок',
    );
    return '$_temp0';
  }

  @override
  String get learnDone => 'Вивчено';

  @override
  String tutorialOfferTitle(String name) {
    return 'Вперше граєте в «$name»?';
  }

  @override
  String get tutorialOfferBody =>
      'Пройти спершу короткий інтерактивний урок? Кілька маленьких полів покажуть усі правила.';

  @override
  String get tutorialOfferNo => 'Ні, дякую';

  @override
  String get tutorialOfferYes => 'Покажіть';

  @override
  String tutorialTitle(String name) {
    return 'Як грати в «$name»';
  }

  @override
  String tutorialStep(int step, int total) {
    return 'Крок $step з $total';
  }

  @override
  String get tutorialNice => 'Чудово!';

  @override
  String get tutorialNext => 'Далі';

  @override
  String get tutorialFinish => 'Готово';

  @override
  String get tutorialShowMe => 'Покажіть';

  @override
  String get tutorialPrevious => 'Попередній крок';

  @override
  String get tutorialReset => 'Почати крок заново';

  @override
  String get tutorialFinishedTitle => 'Ви все зрозуміли!';

  @override
  String tutorialFinishedBody(String name) {
    return 'Це все, що треба знати, щоб грати в «$name».';
  }

  @override
  String get tutorialPlay => 'Грати';

  @override
  String get tutorialAgain => 'Спочатку';

  @override
  String get tutorialClose => 'Закрити';

  @override
  String get tutMambo1 =>
      'Заповніть кожну клітинку сонцем або місяцем. Ніколи не ставте три однакові поспіль: після двох сонць поруч іде місяць. Торкніться виділеної клітинки, щоб перебрати: порожньо → сонце → місяць.';

  @override
  String get tutMambo2 =>
      'У кожному рядку й стовпці порівну сонць і місяців. У верхньому рядку вже є обидва сонця, тож решта клітинок — місяці. Правий стовпець так само.';

  @override
  String get tutMambo3 =>
      '«=» між двома клітинками означає, що в них однаковий символ. Поставте у виділені клітинки те саме, що в сусідів.';

  @override
  String get tutMambo4 =>
      '«×» означає, що клітинки різні: одне сонце й один місяць.';

  @override
  String get tutMambo5 =>
      'Тепер ціле поле: застосуйте всі правила разом. Порада: кнопка палітри вгорі дає ставити один символ у багато клітинок, а довге натискання (чи правий клік) перебирає у зворотному порядку.';

  @override
  String get tutSudoku1 =>
      'У кожному рядку, стовпці й блоці (товсті рамки) кожне число від 1 до 4 трапляється один раз. У цьому рядку бракує одного числа: виберіть його в палітрі й торкніться порожньої клітинки.';

  @override
  String get tutSudoku2 =>
      'За рядком ці дві клітинки можуть бути 3 або 4. Вирішують стовпці: у кожному бракує лише одного числа.';

  @override
  String get tutSudoku3 =>
      'Блоки теж рахуються: у кожному блоці мають бути 1–4 по одному разу. Заповніть останній блок.';

  @override
  String get tutSudoku4 =>
      'Ще не певні? Робіть позначки. Увімкніть олівець біля палітри, виберіть виділену клітинку й позначте всі числа, які там ще можливі.';

  @override
  String get tutSudoku5 =>
      'Тепер цілий пазл. Вибрана клітинка підсвічує свій рядок, стовпець і блок, а також таке саме число деінде. У налаштуваннях можна ввімкнути автоматичне прибирання позначок.';

  @override
  String get tutKings1 =>
      'Поставте рівно одну корону в кожен рядок, кожен стовпець і кожну кольорову область. Три вже стоять, а для останньої лишилося одне місце. Торкніться його двічі: спершу крапка, потім корона.';

  @override
  String get tutKings2 =>
      'Корони ніколи не торкаються, навіть кутами. Торкніться один раз, щоб поставити крапку (позначку «тут корони немає») на кожну клітинку навколо цієї корони.';

  @override
  String get tutKings3 =>
      'Рядки корон і правило дотику лишають у виділеній області лише одну клітинку без крапки. Поставте туди корону.';

  @override
  String get tutKings4 =>
      'Тепер ціле поле. Ставте крапки там, де корони бути не може, і шукайте рядки, стовпці чи області з єдиною вільною клітинкою.';

  @override
  String get tutHues1 =>
      'Розфарбуйте кожну порожню клітинку. Число рахує порожні клітинки навколо (і по діагоналі), які будуть його кольору. Синя 3 має рівно три порожні сусідні клітинки, тож усі вони сині. Виберіть колір у палітрі й торкайтеся клітинок.';

  @override
  String get tutHues2 =>
      'Числа зменшуються, коли ви фарбуєте: вони показують, скільки ще бракує. 0 означає, що жодна порожня сусідка не має його кольору, а клітинки з числами не рахуються. Почніть із синьої 3, а потім подивіться, чого ще бракує рожевій 2.';

  @override
  String get tutHues3 =>
      'Тепер справжнє поле. Почніть із чисел, яким потрібні всі порожні сусіди або жоден.';

  @override
  String get tutMosaic1 =>
      'Пляма в лівому верхньому куті — ваша. Виберіть колір унизу: пляма набуде його й поглине всі сусідні клітинки цього кольору. Зробіть усе поле одного кольору.';

  @override
  String get tutMosaic2 =>
      'Стежте за лімітом ходів: вибирайте колір, що найбільше збільшить пляму. Дотик до клітинки на полі теж вибирає її колір.';

  @override
  String get tutMosaic3 => 'Тепер справжнє поле з кількома запасними ходами.';

  @override
  String get tutBlend1 =>
      'Поле складається з плям — сусідніх клітинок одного кольору. Виберіть колір унизу й торкніться плями, щоб перефарбувати її. Вона зіллється із сусідніми плямами цього кольору. Перефарбуйте середню пляму.';

  @override
  String get tutBlend2 =>
      'Один хід може злити багато плям. Середня пляма межує з чотирма іншими: перефарбуйте її, щоб їх об\'єднати, а потім завершіть. У вас лише 2 ходи.';

  @override
  String get tutBlend3 =>
      'Тепер справжнє поле. Вибраний колір лишається, тож можна фарбувати кілька плям поспіль.';

  @override
  String get tutPop1 =>
      'Торкніться групи з двох або більше сусідніх бульбашок одного кольору, щоб виділити її, і ще раз, щоб лопнути. Очистіть поле.';

  @override
  String get tutPop2 =>
      'Бульбашки згори падають у порожнечі, тож утворюються нові групи. Порядок важливий: спершу лопніть виділену групу.';

  @override
  String get tutPop3 =>
      'Коли стовпець спорожніє, стовпці ліворуч від нього зсуваються праворуч. Лопніть середину, щоб з\'єднати краї.';

  @override
  String get tutPop4 =>
      'Група з n бульбашок дає n × (n − 1) очок: 2 бульбашки — 2 очки, 5 — 20. Зберіть велику групу, щоб набрати 20 очок.';

  @override
  String get tutPop5 =>
      'Інші режими: у «Зсуві» кожен рядок теж зсувається праворуч, у «Безкінечному» зліва з\'являються нові стовпці, а «Мега» поєднує обидва. Цілі: очистити поле, набрати цільовий рахунок або вільна гра на рекорд. Гра закінчується, коли не лишається жодної групи з 2.';

  @override
  String get tutMerge1 =>
      'Проведи пальцем (або натисни стрілку), щоб усі плитки з\'їхали до упору. Дві однакові плитки, що зіткнулися, зливаються в їхню суму. Збери 4.';

  @override
  String get tutMerge2 =>
      'За хід плитка зливається лише раз: 4, 4, 8 стають 8, 8, а не 16. Після кожного ходу з\'являється нова 2 (іноді 4). Збери 16.';

  @override
  String get tutMerge3 =>
      'Тримай найбільшу плитку в куті й нарощуй її крок за кроком. Збери 32.';

  @override
  String get tutPipes1 =>
      'Торкніться плитки, щоб повернути її за годинниковою стрілкою (довге натискання чи правий клік — назад). З\'єднайте всі труби з джерелом — плиткою з кільцем. Вода показує, що вже з\'єднано.';

  @override
  String get tutPipes2 =>
      'Жоден кінець труби не лишається відкритим, тож труби не можуть дивитися за край поля. Плитки із замком уже на місці. Починайте з країв і кутів, де плитки мають найменше варіантів.';

  @override
  String get tutPipes3 => 'Тепер справжнє поле. Мережа не може мати петель.';

  @override
  String get tutShikaku1 =>
      'Поділіть сітку на прямокутники. У кожному рівно одне число, що дорівнює його площі в клітинках. Проведіть від одного кута до протилежного, щоб намалювати прямокутник.';

  @override
  String get tutShikaku2 =>
      '1 — це прямокутник сам по собі: просто торкніться його. Торкніться намальованого прямокутника, щоб прибрати його. Тут 6 вміщується лише одним способом.';

  @override
  String get tutShikaku3 =>
      'Тепер справжнє поле. Великі числа біля країв зазвичай мають найменше варіантів.';

  @override
  String get tutTrail1 =>
      'Проведіть від 1 один шлях через кожну клітинку: вгору, вниз, ліворуч або праворуч. Він закінчується на останньому числі.';

  @override
  String get tutTrail2 =>
      'Шлях має проходити числа по порядку: 1 → 2 → 3 → 4. Проведіть назад шляхом, щоб скасувати кроки, або торкніться його клітинки, щоб обрізати там.';

  @override
  String get tutTrail3 =>
      'Тепер справжнє поле. У кутову клітинку можна увійти й вийти лише двома шляхами, тож шлях використовує обидва.';

  @override
  String get tutLabyrinth1 =>
      'Проведіть від старту в лівому верхньому куті до прапорця в правому нижньому. Стіни не пускають.';

  @override
  String get tutLabyrinth2 =>
      'Лабіринт більший. Глухий кут? Проведіть назад своїм шляхом або торкніться будь-якої його клітинки, щоб повернутися туди. Швидкий рух іде прямими коридорами.';

  @override
  String get tutAtoms1 =>
      'З\'єднайте атоми зв\'язками. Кожному атому потрібно стільки зв\'язків, скільки його число, а два атоми можуть мати один або два спільні. Проведіть від атома до сусіда, щоб додати зв\'язок (1 → 2 → нічого).';

  @override
  String get tutAtoms2 =>
      'Усі атоми мають утворити одну молекулу, а зв\'язки не перетинаються. Зв\'язок від лівої верхньої 1 униз лишив би дві окремі пари. Куди ж він іде?';

  @override
  String get tutAtoms3 =>
      'Тепер справжнє поле. Почніть з атомів, які можуть отримати зв\'язки лише одним способом.';

  @override
  String get tutLits1 =>
      'Зафарбуйте рівно 4 клітинки в кожній обведеній області, щоб вийшла фігура L, I, T або S. У верхній області рівно 4 клітинки, тож зафарбуйте всі. Торкніться клітинки, щоб зафарбувати її.';

  @override
  String get tutLits2 =>
      'Жоден блок 2×2 не може бути зафарбований повністю, а однакові фігури не торкаються через межу. Ліву область завершує лише одна клітинка. Яка?';

  @override
  String get tutLits3 =>
      'Тепер справжнє поле. Усі зафарбовані клітинки мають бути зв\'язними. Торкніться двічі, щоб поставити крапку — позначку, що клітинка лишається порожньою.';

  @override
  String get tutCamp1 =>
      'Поставте намет поруч із кожним деревом: вгорі, внизу, ліворуч або праворуч, не по діагоналі. Числа ззовні показують, скільки наметів у рядку й стовпці. Торкніться клітинки двічі: трава, потім намет.';

  @override
  String get tutCamp2 =>
      'Намети ніколи не торкаються, навіть по діагоналі. Один намет уже стоїть. Куди можна поставити намет для другого дерева?';

  @override
  String get tutCamp3 =>
      'Тепер справжнє поле. 0 означає, що весь рядок чи стовпець — трава, і в кожного дерева свій намет.';

  @override
  String get tutIslands1 =>
      'Зафарбуйте море так, щоб незафарбовані клітинки утворили острови. Кожне число — це острів рівно з такої кількості клітинок. Тут 1 — острів сам по собі: торкніться решти клітинок, щоб зробити їх морем.';

  @override
  String get tutIslands2 =>
      'Острови ніколи не торкаються. Клітинка між двома числами має бути морем, інакше вона з\'єднала б їх в один острів.';

  @override
  String get tutIslands3 =>
      'Море має бути з\'єднаним і без басейнів 2×2. Виростіть 3 так, щоб не порушити жодне з цього. Торкніться двічі, щоб поставити крапку — позначку суходолу.';

  @override
  String get tutIslands4 =>
      'Тепер справжнє поле. На кожному острові рівно одне число.';

  @override
  String get tutLamps1 =>
      'Ставте лампи в білі клітинки: торкніться двічі (крапка, потім лампа). Лампа освітлює свій рядок і стовпець до стін. Освітіть усі білі клітинки.';

  @override
  String get tutLamps2 =>
      'Число на стіні показує, скільки ламп її торкається (вгорі, внизу, ліворуч або праворуч). Цій 3 потрібна лампа з кожного вільного боку.';

  @override
  String get tutLamps3 =>
      'Лампи ніколи не світять одна на одну, а 0 означає, що поруч немає жодної лампи. Куди йде друга лампа?';

  @override
  String get tutLamps4 =>
      'Тепер справжнє поле. Крапками позначайте клітинки, де лампи бути не може.';

  @override
  String get tutFence1 =>
      'Намалюйте одну замкнену петлю по пунктирних лініях. Число показує, скільки сторін його клітинки проходить петля. Торкніться між двома точками, щоб провести лінію, або проведіть від точки до точки.';

  @override
  String get tutFence2 =>
      'Навколо 0 ліній немає. Торкніться лінії ще раз, щоб перетворити її на хрестик — позначку, що лінії там немає. Клітинки без числа можуть мати будь-яку кількість.';

  @override
  String get tutFence3 =>
      'Петля не розгалужується й не перетинає себе: у кожній точці або жодної лінії, або дві. Числа біля краю поля — добрий початок.';

  @override
  String get tutFence4 => 'Тепер справжнє поле. Почніть із 0 і 3.';

  @override
  String get tutPearls1 =>
      'Проводьте по клітинках, щоб намалювати одну замкнену петлю. На чорній перлині петля повертає, а потім іде прямо через наступну клітинку з обох боків.';

  @override
  String get tutPearls2 =>
      'Через білу перлину петля йде прямо, а повертає в клітинці одразу перед нею чи після неї (або в обох).';

  @override
  String get tutPearls3 =>
      'Тепер справжнє поле. Петля не мусить проходити через кожну клітинку й ніколи не перетинає й не торкається себе.';

  @override
  String get tutMines1 =>
      'Число рахує міни у 8 клітинках навколо. Кожна 1 тут торкається лише однієї закритої клітинки, тож там міна. Поставте прапорець: довге натискання чи правий клік, або ввімкніть «Прапорець» внизу й торкніться.';

  @override
  String get tutMines2 =>
      'Міну цієї 1 уже позначено, тож усі інші клітинки навколо безпечні. Розкопайте їх або торкніться самої 1, щоб розкопати всі одразу.';

  @override
  String get tutMines3 =>
      'Клітинка без мін навколо сама відкриває своїх сусідів. Копайте виділений кут.';

  @override
  String get tutMines4 =>
      'Тепер справжнє поле. Вгадувати ніколи не доведеться. Якщо випадково копнете міну, вона просто отримає прапорець, і гра триває.';
}
