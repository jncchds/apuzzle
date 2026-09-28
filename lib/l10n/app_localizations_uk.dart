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
  String get highlightErrorsHint => 'Вимкнено: помилки видно лише після натискання «Перевірити»';

  @override
  String get autoClearMarks => 'Автоматично прибирати позначки';

  @override
  String get autoClearMarksHint => 'Поставлене число прибирає цю позначку з рядка, стовпця й блоку';

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
  String get linksOn => 'Надіслані посилання на головоломки відкриваються в APuzzle';

  @override
  String linksOff(Object host) {
    return 'Вимкнено: торкніться й додайте $host у «Відкривати підтримувані посилання»';
  }

  @override
  String linksUnknown(Object host) {
    return 'Виберіть APuzzle для посилань $host';
  }

  @override
  String get couldNotOpenSettings => 'Не вдалося відкрити системні налаштування';

  @override
  String get installApp => 'Встановити застосунок';

  @override
  String get installAppHint => 'Додайте APuzzle на головний екран; він відкриватиметься в окремому вікні';

  @override
  String get installAppIos => 'Торкніться кнопки «Поділитися» в браузері, а потім «На початковий екран».';

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
  String get codeOtherVersion => 'Цей код з іншої версії застосунку, тож головоломка не збіглася б';

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
  String get blendTagline => 'Перефарбовуйте плями, доки не лишиться один колір';

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
  String get popModeStandardHint => 'Бульбашки падають униз; порожні стовпці зсуваються праворуч.';

  @override
  String get popModeShifter => 'Зсув';

  @override
  String get popModeShifterHint => 'Рядки також зсуваються праворуч, закриваючи всі проміжки.';

  @override
  String get popModeContinuous => 'Безкінечний';

  @override
  String get popModeContinuousHint => 'Коли звільняється місце, зліва з\'являються нові стовпці.';

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
  String get popGoalTargetHint => 'Наберіть потрібний рахунок, поки лишаються ходи.';

  @override
  String get popGoalFree => 'Вільна гра';

  @override
  String get popGoalFreeHint => 'Без мети: грайте до кінця й побийте свій рекорд.';

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
      other: 'Ходів немає, на полі $count бульбашки: скасуйте хід або почніть спочатку',
      many: 'Ходів немає, на полі $count бульбашок: скасуйте хід або почніть спочатку',
      few: 'Ходів немає, на полі $count бульбашки: скасуйте хід або почніть спочатку',
      one: 'Ходів немає, на полі $count бульбашка: скасуйте хід або почніть спочатку',
    );
    return '$_temp0';
  }

  @override
  String popStuckPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ходів немає, бракує $count очка: скасуйте хід або почніть спочатку',
      many: 'Ходів немає, бракує $count очок: скасуйте хід або почніть спочатку',
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
  String get mergeGoalTargetHint => 'Досягни цільової плитки, доки поле не заблоковане.';

  @override
  String get mergeGoalFreeHint => 'Без мети: грай, доки поле не заблокується, і побий свій рекорд.';

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
      '• Повертайте плитки так, щоб кожна труба була з\'єднана з джерелом (плитка з кільцем).\n• Жоден кінець труби не може лишатися відкритим, а мережа не може мати петель.\n• Вода тече всім, що вже з\'єднано з джерелом.\n• Плитки з крапкою в куті закріплені й уже стоять на місці.\n\nТоркніться плитки, щоб повернути її за годинниковою стрілкою; довге натискання / правий клік повертає назад.';

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
  String get lampsTagline => 'Освітіть усі клітинки, лампи не світять одна на одну';

  @override
  String get lampsRules =>
      '• Ставте лампи в порожні клітинки (не на стіни). Лампа освітлює свою клітинку, а також рядок і стовпець до найближчої стіни.\n• Кожна порожня клітинка має бути освітлена.\n• Жодна лампа не може світити на іншу лампу.\n• Число на стіні показує, скільки ламп стоїть поруч із нею (вгорі, внизу, ліворуч або праворуч).\n\nТоркніться клітинки, щоб перебрати: порожньо → крапка (ваша позначка «лампи немає») → лампа. Довге натискання / правий клік — у зворотному порядку.';

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
  String get railsName => 'Рейки';

  @override
  String get railsTagline => 'Прокладіть одну колію від входу до виходу';

  @override
  String get railsRules =>
      '• Прокладіть одну колію через центри клітинок, від входу на лівому краї до виходу на нижньому.\n• Колія не розгалужується, не перетинає себе й не замикається в петлю, і не мусить проходити через кожну клітинку.\n• Числа над полем і праворуч від нього показують, скільки клітинок кожного стовпця й рядка займає колія.\n• Відрізки, що вже є на полі, закріплені: колія проходить через них саме так, як показано.\n\nПроводьте по клітинках, щоб класти колію, або вздовж неї, щоб стирати. Торкніться між двома клітинками, щоб перебрати: колія → хрестик → порожньо.';

  @override
  String get blocksName => 'Блоки';

  @override
  String get blocksTagline => 'Числа від 1 до k у кожній області з k клітинок';

  @override
  String get blocksRules =>
      '• Заповніть кожну клітинку числом.\n• Область із k клітинок містить кожне число від 1 до k рівно один раз (в області з однієї клітинки стоїть 1).\n• Однакові числа ніколи не торкаються, навіть по діагоналі.\n• Задані числа змінювати не можна.\n\nВиберіть число в палітрі й торкайтеся клітинок, щоб поставити його, або спершу торкніться клітинки, а потім числа. Кнопка з олівцем вмикає дрібні позначки. Довге натискання / правий клік очищає клітинку.';

  @override
  String get pairsName => 'Пари';

  @override
  String get pairsTagline => 'Дві зафарбовані клітинки поруч у кожній області';

  @override
  String get pairsRules =>
      '• Зафарбуйте рівно дві клітинки в кожній обведеній області.\n• Кожна зафарбована клітинка торкається стороною рівно однієї іншої зафарбованої, тож зафарбовані клітинки йдуть парами.\n• Пари ніколи не торкаються одна одної сторонами (кутами можна).\n\nТоркніться клітинки, щоб перебрати: порожньо → зафарбовано → крапка (ваша позначка «не зафарбовано»). Довге натискання / правий клік — у зворотному порядку.';

  @override
  String get plotsName => 'Ділянки';

  @override
  String get plotsTagline => 'Поділіть поле на ділянки завбільшки з їхні числа';

  @override
  String get plotsRules =>
      '• Заповніть кожну клітинку числом.\n• Однакові числа, що торкаються сторонами, утворюють ділянку, і в ділянці рівно стільки клітинок, скільки каже її число: 3 лежить у ділянці з трьох клітинок.\n• Дві ділянки однакового розміру ніколи не торкаються сторонами (інакше це була б одна ділянка).\n• У деяких ділянках немає жодного заданого числа.\n\nВиберіть число в палітрі й торкайтеся клітинок, щоб заповнити їх, або спершу торкніться клітинки, а потім числа. Між різними числами з\'являються лінії, тож видно, як складаються ділянки.';

  @override
  String get linksName => 'Зв\'язки';

  @override
  String get linksTagline => 'З\'єднайте пари й заповніть поле';

  @override
  String get linksRules =>
      '• З\'єднайте кожну пару однакових кружків шляхом через сусідні клітинки (не по діагоналі).\n• Шляхи не перетинаються, не розгалужуються й не займають спільних клітинок.\n• Разом шляхи заповнюють кожну клітинку поля.\n\nПроводьте від кружка, щоб намалювати його шлях; шлях поверх іншого перерізає той. Торкніться кружка, щоб стерти його шлях, або клітинки шляху, щоб обрізати шлях у ній.';

  @override
  String get arrowsName => 'Стрілки';

  @override
  String get arrowsTagline => 'Зафарбуйте те, що рахують стрілки, а решту обійдіть петлею';

  @override
  String get arrowsRules =>
      '• Зафарбуйте деякі клітинки. Зафарбовані клітинки ніколи не торкаються сторонами.\n• Намалюйте одну замкнену петлю через центри всіх інших клітинок. Вона не розгалужується й не перетинає себе.\n• Клітинки з підказками (число й стрілка) не зафарбовані й не на петлі. Число підказки рахує зафарбовані клітинки в напрямку її стрілки, аж до краю.\n\nПроводьте по клітинках, щоб малювати петлю, або вздовж неї, щоб стирати. Торкніться центру клітинки, щоб перебрати: порожньо → зафарбовано → крапка (ваша позначка «на петлі»), або торкніться між двома клітинками, щоб перебрати: лінія → хрестик → порожньо.';

  @override
  String get learnTitle => 'Як грати';

  @override
  String get learnIntro => 'Короткі інтерактивні уроки: кожен крок — маленьке поле, що показує одне правило чи прийом.';

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
  String get tutorialStrategies => 'Вивчити стратегії';

  @override
  String strategiesTitle(String name) {
    return '$name: стратегії';
  }

  @override
  String strategiesFinishedBody(String name) {
    return 'Ви знаєте головні прийоми для гри $name.';
  }

  @override
  String get learnBasicsTab => 'Основи';

  @override
  String get learnStrategiesTab => 'Стратегії';

  @override
  String get learnStrategiesIntro =>
      'Для тих, хто вже знає правила: кожен урок показує прийом досвідчених гравців на полі, де без нього не обійтися.';

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
  String get tutMambo4 => '«×» означає, що клітинки різні: одне сонце й один місяць.';

  @override
  String get tutMambo5 =>
      'Тепер ціле поле: застосуйте всі правила разом. Порада: кнопка палітри вгорі дає ставити один символ у багато клітинок, а довге натискання (чи правий клік) перебирає у зворотному порядку.';

  @override
  String get tutMamboS1 =>
      'Коли жодне правило не спрацьовує напряму, спитайте себе «а що, як?». Виділена пара з\'єднана знаком =, тож обидві клітинки однакові. Два сонця дали б верхньому рядку три сонця з чотирьох, тож обидві — місяці.';

  @override
  String get tutMamboS2 =>
      'Складніше поле, де цей прийом знадобиться часто: спробуйте символ у клітинці й пройдіть за правилами кілька кроків. Якщо щось ламається, правильний інший символ. Пара з × завжди містить по одному, тож у своєму рядку вона рахується як одне сонце й один місяць.';

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
  String get tutSudokuS1 =>
      'Дивіться на одне число, а не на одну клітинку. Виділеному блоку потрібна 1: одиниці в його стовпцях і в другому рядку виключають усі клітинки, крім однієї. Далі розв\'яжіть поле так само.';

  @override
  String get tutSudokuS2 =>
      'Ще два прийоми. Пари: дві клітинки лінії чи блоку, де можливі лише ті самі два числа, забирають їх собі. Вказівка: якщо місця для числа в блоці лежать на одній лінії, у решті цієї лінії його немає.';

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
  String get tutKingsS1 =>
      'Шукайте область, що вміщується в одному рядку чи стовпці. Виділена область лежить цілком у нижньому рядку, тож корона цього рядка — в ній: поставте крапки в інших клітинках нижнього рядка й продовжуйте.';

  @override
  String get tutKingsS2 =>
      'Ще один прийом: якщо корона в клітинці виключила б усі клітинки іншої області (рядком, стовпцем чи дотиком), у цій клітинці корони бути не може. Поставте крапку. Так само з двома областями, втиснутими у два рядки.';

  @override
  String get tutHues1 =>
      'Розфарбуйте кожну порожню клітинку. Число рахує порожні клітинки навколо (і по діагоналі), які будуть його кольору. Синя 3 має рівно три порожні сусідні клітинки, тож усі вони сині. Виберіть колір у палітрі й торкайтеся клітинок.';

  @override
  String get tutHues2 =>
      'Числа зменшуються, коли ви фарбуєте: вони показують, скільки ще бракує. 0 означає, що жодна порожня сусідка не має його кольору, а клітинки з числами не рахуються. Почніть із синьої 3, а потім подивіться, чого ще бракує рожевій 2.';

  @override
  String get tutHues3 => 'Тепер справжнє поле. Почніть із чисел, яким потрібні всі порожні сусіди або жоден.';

  @override
  String get tutHuesS1 =>
      'Виключайте кольори. Кожна виділена клітинка торкається синього 0, тож не може бути синьою, і рожевого 0, тож не може бути рожевою. Лишається тільки жовтий.';

  @override
  String get tutHuesS2 =>
      'Складніше поле. Порівнюйте числа зі спільними порожніми сусідами: те, чого бракує одному, може вже вичерпати інше. Коли застрягли, спробуйте колір у клітинці й перевірте, чи не ламається якесь число.';

  @override
  String get tutMosaic1 =>
      'Пляма в лівому верхньому куті — ваша. Виберіть колір унизу: пляма набуде його й поглине всі сусідні клітинки цього кольору. Зробіть усе поле одного кольору.';

  @override
  String get tutMosaic2 =>
      'Стежте за лімітом ходів: вибирайте колір, що найбільше збільшить пляму. Дотик до клітинки на полі теж вибирає її колір.';

  @override
  String get tutMosaic3 => 'Тепер справжнє поле з кількома запасними ходами.';

  @override
  String get tutMosaicS1 =>
      'Плануйте наперед. Рано дістаньтеся до середини поля, бо тоді ваша пляма торкається більшої кількості кольорів, а коли можете, обирайте колір, що повністю зникає з поля.';

  @override
  String get tutBlend1 =>
      'Поле складається з плям — сусідніх клітинок одного кольору. Виберіть колір унизу й торкніться плями, щоб перефарбувати її. Вона зіллється із сусідніми плямами цього кольору. Перефарбуйте середню пляму.';

  @override
  String get tutBlend2 =>
      'Один хід може злити багато плям. Середня пляма межує з чотирма іншими: перефарбуйте її, щоб їх об\'єднати, а потім завершіть. У вас лише 2 ходи.';

  @override
  String get tutBlend3 => 'Тепер справжнє поле. Вибраний колір лишається, тож можна фарбувати кілька плям поспіль.';

  @override
  String get tutBlendS1 =>
      'Виберіть одну пляму посередині й перефарбовуйте саме її: кожен хід поглинає всі дотичні плями нового кольору. Обирайте колір, який мають більшість її сусідів.';

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
  String get tutPopS1 =>
      'Очищення поля потребує плану. Перш ніж лопати, подумайте, що впаде в проміжок: лопайте групи, які зводять разом кульки одного кольору, і ніколи не лишайте кульку якогось кольору саму.';

  @override
  String get tutPopS2 =>
      'Гонитва за очками: група з n кульок дає n × (n − 1), тож одна група з 8 (56) краща за чотири групи з 2 (8). Спершу лопайте інші кольори, щоб зібрати один колір у велику групу.';

  @override
  String get tutMerge1 =>
      'Проведи пальцем (або натисни стрілку), щоб усі плитки з\'їхали до упору. Дві однакові плитки, що зіткнулися, зливаються в їхню суму. Збери 4.';

  @override
  String get tutMerge2 =>
      'За хід плитка зливається лише раз: 4, 4, 8 стають 8, 8, а не 16. Після кожного ходу з\'являється нова 2 (іноді 4). Збери 16.';

  @override
  String get tutMerge3 => 'Тримай найбільшу плитку в куті й нарощуй її крок за кроком. Збери 32.';

  @override
  String get tutMergeS1 =>
      'Будуйте ланцюжок: тримайте плитки по порядку вздовж одного рядка, найбільшу в куті, як 64, 32, 16, 8. Тоді одна нова 8 у кінці котиться аж до початку. Зберіть 128.';

  @override
  String get tutPipes1 =>
      'Торкніться плитки, щоб повернути її за годинниковою стрілкою (довге натискання чи правий клік — назад). З\'єднайте всі труби з джерелом — плиткою з кільцем. Вода показує, що вже з\'єднано.';

  @override
  String get tutPipes2 =>
      'Жоден кінець труби не лишається відкритим, тож труби не можуть дивитися за край поля. Плитки з крапкою в куті закріплені й уже на місці. Починайте з країв і кутів, де плитки мають найменше варіантів.';

  @override
  String get tutPipes3 => 'Тепер справжнє поле. Мережа не може мати петель.';

  @override
  String get tutPipesS1 =>
      'Рухайтеся від краю всередину. Пряма на краю мусить іти вздовж нього, у куті може бути лише коліно, звернене всередину, а трійник на краю повертається плоским боком до краю. Кожна встановлена плитка обмежує сусідів.';

  @override
  String get tutPipesS2 =>
      'Складне поле. Мережа не може мати петель: якщо поворот плитки замкнув би петлю, вона мусить дивитися в інший бік. А два тупики ніколи не дивляться один на одного, бо утворили б пару, відрізану від решти.';

  @override
  String get tutShikaku1 =>
      'Поділіть сітку на прямокутники. У кожному рівно одне число, що дорівнює його площі в клітинках. Проведіть від одного кута до протилежного, щоб намалювати прямокутник.';

  @override
  String get tutShikaku2 =>
      '1 — це прямокутник сам по собі: просто торкніться його. Торкніться намальованого прямокутника, щоб прибрати його. Тут 6 вміщується лише одним способом.';

  @override
  String get tutShikaku3 => 'Тепер справжнє поле. Великі числа біля країв зазвичай мають найменше варіантів.';

  @override
  String get tutShikakuS1 =>
      'Питайте, які числа можуть дістатися до клітинки. Лівий нижній кут задалеко, щоб 4 чи 6 накрили його прямокутником свого розміру, тож він належить 2.';

  @override
  String get tutShikakuS2 =>
      'Складне поле. Перелічіть кілька прямокутників, які може зайняти велике число: клітинки, які накривають усі вони, належать йому, а клітинка, до якої дістає лише одне число, належить саме йому.';

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
  String get tutTrailS1 =>
      'Клітинки лише з двома вільними сусідами треба проходити наскрізь: шлях заходить з одного боку й виходить з іншого. Стежте за клітинками, які ваш шлях щойно затиснув.';

  @override
  String get tutTrailS2 =>
      'Складне поле. Ніколи не розрізайте вільні клітинки на дві частини: шлях не зможе повернутися по другу. А клітинка лише з одним вільним сусідом — глухий кут, дозволений тільки для останнього числа.';

  @override
  String get tutLabyrinth1 =>
      'Проведіть від старту в лівому верхньому куті до прапорця в правому нижньому. Стіни не пускають.';

  @override
  String get tutLabyrinth2 =>
      'Лабіринт більший. Глухий кут? Проведіть назад своїм шляхом або торкніться будь-якої його клітинки, щоб повернутися туди. Швидкий рух іде прямими коридорами.';

  @override
  String get tutLabyrinthS1 =>
      'Заблукали? Тримайтеся рукою за стіну: завжди обирайте крайній правий прохід. У такому лабіринті це завжди виводить, хоч і не найкоротшим шляхом.';

  @override
  String get tutLabyrinthS2 =>
      'Або йдіть від кінця: простежте шлях від прапорця до старту й шукайте, де зустрінуться два маршрути. Так глухі кути біля прапорця відпадають швидко.';

  @override
  String get tutAtoms1 =>
      'З\'єднайте атоми зв\'язками. Кожному атому потрібно стільки зв\'язків, скільки його число, а два атоми можуть мати один або два спільні. Проведіть від атома до сусіда, щоб додати зв\'язок (1 → 2 → нічого).';

  @override
  String get tutAtoms2 =>
      'Усі атоми мають утворити одну молекулу, а зв\'язки не перетинаються. Зв\'язок від лівої верхньої 1 униз лишив би дві окремі пари. Куди ж він іде?';

  @override
  String get tutAtoms3 => 'Тепер справжнє поле. Почніть з атомів, які можуть отримати зв\'язки лише одним способом.';

  @override
  String get tutAtomsS1 =>
      'Порівнюйте число атома з його сусідами. У 4 в куті лише два сусіди, а пара може мати щонайбільше два зв\'язки, тож обидва зв\'язки подвійні. Так само 3 з двома сусідами отримує щонайменше по одному зв\'язку до кожного.';

  @override
  String get tutAtomsS2 =>
      'Складне поле. Тримайте молекулу цілою: дві одиниці ніколи не з\'єднуються між собою, а дві двійки не мають подвійного зв\'язку, якщо вони не єдині атоми. Коли застрягли, спробуйте зв\'язок і подивіться, чи не відрізається частина поля.';

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
  String get tutLitsS1 =>
      'Перелічіть фігури, які ще вміщує кожна область. Клітинки, які накриває кожна можлива фігура, зафарбовані, а ті, яких не накриває жодна, лишаються порожніми. Найменше варіантів у малих областях і тих, що стиснуті правилом 2×2.';

  @override
  String get tutLitsS2 =>
      'Складніше поле. Коли застрягли, спробуйте одну фігуру в області: якщо вона утворює блок 2×2, розрізає зафарбовану частину надвоє або ставить дві однакові фігури поруч, вона неправильна.';

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
  String get tutCampS1 =>
      'Рахуйте проміжки. Верхньому рядку потрібні 2 намети, і поставити їх можна лише в три виділені клітинки. Два намети в трьох клітинках, що не можуть торкатися, стоять по краях.';

  @override
  String get tutCampS2 =>
      'Складне поле, і деякі числа приховані. Коли застрягли, спробуйте поставити намет: якщо якомусь дереву не лишається місця для свого намету, там трава.';

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
  String get tutIslands4 => 'Тепер справжнє поле. На кожному острові рівно одне число.';

  @override
  String get tutIslandsS1 =>
      'Шукайте клітинки, до яких не дотягнеться жоден острів. 3 росте щонайбільше на два кроки від свого числа, 2 — на один, а 1 — ні на який. Виділені клітинки недосяжні для всіх островів, тож це море.';

  @override
  String get tutIslandsS2 =>
      'Складне поле. Пам\'ятайте про море: воно має лишатися з\'єднаним, тож морська клітинка з одним виходом продовжується туди, і воно не може утворити ставок 2×2. Коли застрягли, спробуйте клітинку як суходіл і подивіться, чи щось не ламається.';

  @override
  String get tutLamps1 =>
      'Ставте лампи в порожні клітинки: торкніться двічі (крапка, потім лампа). Темні клітинки — це стіни. Лампа освітлює свій рядок і стовпець до стін. Освітіть усі порожні клітинки.';

  @override
  String get tutLamps2 =>
      'Число на стіні показує, скільки ламп її торкається (вгорі, внизу, ліворуч або праворуч). Цій 3 потрібна лампа з кожного вільного боку.';

  @override
  String get tutLamps3 =>
      'Лампи ніколи не світять одна на одну, а 0 означає, що поруч немає жодної лампи. Куди йде друга лампа?';

  @override
  String get tutLamps4 => 'Тепер справжнє поле. Крапками позначайте клітинки, де лампи бути не може.';

  @override
  String get tutLampsS1 =>
      'Деякі клітинки можна освітити лише одним способом. Лівий верхній кут освітлюється тільки з нього самого або з двох сусідів, а 0 виключає сусідів: лампа стоїть у куті. Потім подивіться на 1.';

  @override
  String get tutLampsS2 =>
      'Складне поле. Коли застрягли, спробуйте лампу в клітинці й простежте, до чого це веде: якщо якусь клітинку вже не освітити або число не виконати, у цій клітинці крапка.';

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
  String get tutFenceS1 =>
      'Вивчіть кілька шаблонів. Між двома трійками поруч завжди є лінія, і ще по лінії на їхніх дальніх сторонах: інакше одній з них забракне. 0 зверху теж допомагає.';

  @override
  String get tutFenceS2 =>
      'Кути дають багато. 1 у куті ніколи не використовує двох зовнішніх сторін: петля мусила б там повернути й зайняти обидві. 3 у куті завжди використовує обидві.';

  @override
  String get tutFenceS3 =>
      'Складне поле. Коли застрягли, спробуйте лінію на одному ребрі й простежте її: якщо вона веде в глухий кут, до числа, яке не виконати, або до малої петлі, що лишає інші поза нею, на цьому ребрі хрестик.';

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
  String get tutPearlsS1 =>
      'Чорна перлина не може повернути до надто близького краю: петлі потрібні дві прямі клітинки з кожного боку. Обидві чорні перлини тут надто близько до двох країв, тож їхні напрямки визначені.';

  @override
  String get tutPearlsS2 =>
      'Складне поле. Три білі перлини поспіль не можуть лежати на одній прямій ділянці (середній потрібен поворот поруч), тож петля перетинає їх упоперек. Коли застрягли, спробуйте лінію й подивіться, чи не ламається якась перлина.';

  @override
  String get tutRails1 =>
      'Проводьте по клітинках, щоб прокласти одну колію від входу ліворуч до виходу внизу. Числа згори й праворуч рахують клітинки колії в кожному стовпці й рядку.';

  @override
  String get tutRails2 =>
      'Відрізки, що вже є на полі, закріплені: колія проходить через них саме так, як показано. 0 означає, що в цьому рядку чи стовпці колії немає зовсім.';

  @override
  String get tutRails3 =>
      'Тепер справжнє поле. Колія не розгалужується й не перетинає себе і не мусить проходити через кожну клітинку.';

  @override
  String get tutRailsS1 =>
      'Почніть із ліній, де число не лишає вибору. Другому рядку потрібно 4 клітинки колії, і в ньому їх лише 4; правому стовпцю так само. Потім з\'єднайте кінці.';

  @override
  String get tutRailsS2 =>
      'Складне поле. Вичерпане число блокує решту своєї лінії, а клітинці колії завжди потрібні рівно два сусіди з колією. Коли застрягли, спробуйте шматок колії й перевірте, чи числа ще сходяться.';

  @override
  String get tutBlocks1 =>
      'Кожна область із k клітинок містить числа від 1 до k по одному разу. Кожна виділена клітинка — остання порожня у своїй області: виберіть число, якого бракує, у палітрі й торкніться клітинки.';

  @override
  String get tutBlocks2 =>
      'Однакові числа ніколи не торкаються, навіть кутами. Області вгорі ліворуч потрібні 1 і 2, а одна з її клітинок уже торкається двійки. Так само заповніть нижній рядок.';

  @override
  String get tutBlocks3 =>
      'Тепер справжнє поле. Почніть із малих областей і клітинок, чиї сусіди виключають більшість чисел. Позначки олівцем допомагають.';

  @override
  String get tutBlocksS1 =>
      'Вказівка: позначте, де кожна область ще може поставити число. Якщо всі ці клітинки торкаються однієї клітинки поза областю, у ній цього числа бути не може, бо вона б його торкалася. Нотатки олівцем допоможуть це побачити.';

  @override
  String get tutBlocksS2 =>
      'Складне поле. Коли більше нічого не працює, виберіть клітинку лише з двома можливими числами й спробуйте одне: якщо незабаром якійсь області ніде поставити число, правильне інше.';

  @override
  String get tutPairs1 =>
      'Зафарбуйте рівно дві клітинки в кожній області так, щоб кожна зафарбована торкалася рівно однієї іншої: зафарбовані клітинки йдуть парами. У виділеній області лише дві клітинки, тож зафарбуйте обидві.';

  @override
  String get tutPairs2 =>
      'Пари ніколи не торкаються одна одної сторонами. Верхня пара готова, тож виділені клітинки поруч із нею не зафарбовуються: поставте там крапки (торкніться двічі), а потім розв\'яжіть поле до кінця.';

  @override
  String get tutPairs3 =>
      'Тепер справжнє поле. Малі області й клітинки, затиснуті крапками, — гарні місця для початку.';

  @override
  String get tutPairsS1 =>
      'Переберіть усі способи завершити невелику область: клітинка, зафарбована в кожному з них, зафарбована, а та, що не зафарбована в жодному, отримує крапку. Наприклад, у куточку з трьох клітинок завжди зафарбований кут.';

  @override
  String get tutPairsS2 =>
      'Складне поле. Коли застрягли, зафарбуйте клітинку й ідіть за правилами: якщо якась область уже не може отримати свої дві клітинки або дві пари торкнулися б, ця клітинка не зафарбовується.';

  @override
  String get tutPlots1 =>
      'Заповніть кожну клітинку числом. Однакові числа, що торкаються сторонами, утворюють ділянку рівно з такої кількості клітинок. Виділеній трійці потрібні ще дві клітинки для ділянки.';

  @override
  String get tutPlots2 =>
      'Дві ділянки однакового розміру не можуть торкатися: вони злилися б в одну завелику ділянку. Виділена клітинка торкається двох ділянок по 2, тож двійкою вона бути не може.';

  @override
  String get tutPlots3 =>
      'Тепер справжнє поле. У деяких ділянках немає жодного числа: визначте їхній розмір за вільним місцем.';

  @override
  String get tutPlotsS1 =>
      'Шукайте кишені. Дві виділені клітинки оточені завершеними ділянками, тож можуть об\'єднатися лише одна з одною. Дві одиниці не можуть торкатися, тож разом вони — ділянка з 2.';

  @override
  String get tutPlotsS2 =>
      'Складне поле. Коли нічого не певно, виберіть клітинку лише з двома-трьома можливими числами й перевірте кожне: число, через яке якась ділянка не може набрати свій розмір, не підходить.';

  @override
  String get tutLinks1 =>
      'Проведіть від кружка до його пари, щоб з\'єднати їх. Шляхи йдуть через сусідні клітинки, ніколи не по діагоналі.';

  @override
  String get tutLinks2 =>
      'Шляхи не перетинаються, а разом заповнюють кожну клітинку, тож деяким доводиться йти в обхід.';

  @override
  String get tutLinks3 => 'Тепер справжнє поле. У кутах і на краях найменше варіантів, тож почніть звідти.';

  @override
  String get tutLinksS1 =>
      'Спершу заповнюйте тісні місця. У порожнього кута лише два сусіди, тож шлях через нього використовує обидва. Так само з будь-якою клітинкою, якій лишилося два вільні сусіди.';

  @override
  String get tutLinksS2 =>
      'Складне поле. У головоломці з однією відповіддю шлях ніколи не згортається поруч сам із собою (він міг би зрізати), тож жоден квадрат 2×2 не належить одному шляху. І не лишайте порожньої клітинки, до якої вже не дістанеться жоден шлях.';

  @override
  String get tutArrows1 =>
      'Намалюйте одну петлю через центри всіх порожніх клітинок: проводьте від клітинки до клітинки. Клітинка з підказкою посередині ніколи не на петлі. Її 0 каже, що над нею нічого не зафарбовано, тож тут зафарбовувати нічого.';

  @override
  String get tutArrows2 =>
      'Тепер дві клітинки треба зафарбувати. Кожна підказка рахує зафарбовані клітинки в напрямку своєї стрілки: знайдіть їх і торкніться їхніх центрів, щоб зафарбувати. Зафарбовані клітинки не торкаються сторонами. Потім намалюйте петлю через усі інші клітинки.';

  @override
  String get tutArrows3 =>
      'Тепер справжнє поле. Клітинки поруч із зафарбованою завжди на петлі, а клітинці петлі потрібні два виходи.';

  @override
  String get tutArrowsS1 =>
      'Шукайте тісні підказки. У 2 в середньому рядку праворуч лише три клітинки, а дві зафарбовані не можуть торкатися, тож займають першу й останню. З 2 у верхньому рядку ще простіше: у неї лише дві вільні клітинки.';

  @override
  String get tutArrowsS2 =>
      'Складне поле. Кожна клітинка, що не зафарбована й не підказка, лежить на петлі, тож у клітинки лише з двома вільними сусідами шлях визначений. Коли застрягли, спробуйте зафарбувати клітинку й подивіться, чи не лишилося клітинці петлі менше двох виходів.';

  @override
  String get tutMines1 =>
      'Число рахує міни у 8 клітинках навколо. Кожна 1 тут торкається лише однієї закритої клітинки, тож там міна. Поставте прапорець: довге натискання чи правий клік, або ввімкніть «Прапорець» внизу й торкніться.';

  @override
  String get tutMines2 =>
      'Міну цієї 1 уже позначено, тож усі інші клітинки навколо безпечні. Розкопайте їх або торкніться самої 1, щоб розкопати всі одразу.';

  @override
  String get tutMines3 => 'Клітинка без мін навколо сама відкриває своїх сусідів. Копайте виділений кут.';

  @override
  String get tutMines4 =>
      'Тепер справжнє поле. Вгадувати ніколи не доведеться. Якщо випадково копнете міну, вона просто отримає прапорець, і гра триває.';

  @override
  String get tutMinesS1 =>
      'Порівнюйте сусідні числа. 2 бачить три закриті клітинки, а 1 ліворуч — лише перші дві, тож третя — міна. Те саме працює справа. Тоді середня клітинка безпечна.';

  @override
  String get tutMinesS2 =>
      'Складне поле. Далі порівнюйте числа зі спільними закритими клітинками. Під кінець рахуйте, що лишилося: лічильник мін може розв\'язати останні закриті клітинки.';
}
