import '../models/quiz_question.dart';

class QuizBank {
  static const List<String> categories = [
    'All',
    'Basics',
    'Chart',
    'Patterns',
    'Risk',
    'Market',
    'Strategy',
  ];

  static const List<QuizQuestion> allQuestions = [
    QuizQuestion(
      category: 'Basics',
      difficulty: 'Easy',
      question: 'Чем спот отличается от фьючерса?',
      options: [
        'На споте нельзя продать',
        'Спот — монета на балансе; фьючерс — контракт с плечом и шортом',
        'Фьючерс без риска ликвидации',
        'Спот только для BTC',
      ],
      correctIndex: 1,
      explanation: 'Спот = владение активом. Фьючерс = контракт, плечо, ликвидация.',
    ),
    QuizQuestion(
      category: 'Basics',
      difficulty: 'Easy',
      question: 'What is a trader\'s main job?',
      options: [
        'Predict news exactly',
        'Work with probabilities, risk and repeatable setups',
        'Win every trade',
        'Copy Telegram signals',
      ],
      correctIndex: 1,
      explanation: 'Pros plan entry, stop and target before clicking.',
    ),
    QuizQuestion(
      category: 'Chart',
      difficulty: 'Easy',
      question: 'O que é suporte pelos fundos?',
      options: [
        'Linha nos máximos',
        'Linha horizontal nos mínimos com 2+ reações',
        'Indicador RSI',
        'Taxa de funding',
      ],
      correctIndex: 1,
      explanation: 'Suporte = lows onde compradores reagiram várias vezes.',
    ),
    QuizQuestion(
      category: 'Chart',
      difficulty: 'Medium',
      question: 'Стакан: что такое спуфинг?',
      options: [
        'Исполнение крупного ордера',
        'Крупная стена снята до касания цены',
        'Рост funding rate',
        'Перевод между сетями',
      ],
      correctIndex: 1,
      explanation: 'Спуфинг — фейковая плотность для манипуляции.',
    ),
    QuizQuestion(
      category: 'Chart',
      difficulty: 'Medium',
      question: 'Amplitude de movimento mede:',
      options: [
        'A comissão da exchange',
        'O tamanho do movimento em %',
        'O horário de Londres',
        'A cor da vela',
      ],
      correctIndex: 1,
      explanation: 'Amplitude = quão longe o preço se move — define alvos e stops.',
    ),
    QuizQuestion(
      category: 'Patterns',
      difficulty: 'Medium',
      question: 'Восходящий треугольник — это:',
      options: [
        'Понижающиеся максимумы и рост минимумов у сопротивления',
        'Только падающие свечи',
        'Любой канал',
        'Паттерн без пробоя',
      ],
      correctIndex: 0,
      explanation: 'Плоское сопротивление + растущие лои → пробой вверх.',
    ),
    QuizQuestion(
      category: 'Patterns',
      difficulty: 'Medium',
      question: 'Head & shoulders neckline break often signals:',
      options: [
        'Continuation up',
        'Potential trend reversal down',
        'No change',
        'Only spot buying',
      ],
      correctIndex: 1,
      explanation: 'Neckline break + retest = classic reversal short setup.',
    ),
    QuizQuestion(
      category: 'Strategy',
      difficulty: 'Medium',
      question: 'Импульсная стратегия — лучший вход:',
      options: [
        'В середине range без объёма',
        'На пробое с объёмом или ретесте уровня',
        'После 5 красных свечей без плана',
        'Только на новостях без стопа',
      ],
      correctIndex: 1,
      explanation: 'Импульс = выход из range с подтверждением объёмом.',
    ),
    QuizQuestion(
      category: 'Strategy',
      difficulty: 'Hard',
      question: 'Antes de abrir trade, você DEVE ter:',
      options: [
        'Apenas esperança',
        'Entrada, stop, alvo e R:R mínimo 1:2',
        'Alavancagem máxima',
        'Sinal de grupo VIP',
      ],
      correctIndex: 1,
      explanation: 'Sem plano = sem trade. Trade Master ensina isso.',
    ),
    QuizQuestion(
      category: 'Risk',
      difficulty: 'Easy',
      question: 'Оптимальный риск на сделку для новичка:',
      options: ['5–10%', '0.5–1%', '25%', 'Весь депозит'],
      correctIndex: 1,
      explanation: 'Малый риск = выживание в серии убытков.',
    ),
    QuizQuestion(
      category: 'Risk',
      difficulty: 'Medium',
      question: 'Усреднение без плана чаще всего:',
      options: [
        'Спасает счёт',
        'Увеличивает убыток при сломанном тезисе',
        'Не влияет на риск',
        'Заменяет стоп',
      ],
      correctIndex: 1,
      explanation: 'Усреднение только с лимитом потерь и живым тезисом.',
    ),
    QuizQuestion(
      category: 'Risk',
      difficulty: 'Medium',
      question: 'After a big loss you should:',
      options: [
        'Double size to recover',
        'Pause, cut size, review journal',
        'Ignore and trade more',
        'Remove all stops',
      ],
      correctIndex: 1,
      explanation: 'Recovery = process reset, not revenge.',
    ),
    QuizQuestion(
      category: 'Market',
      difficulty: 'Easy',
      question: 'Делистинг монеты означает:',
      options: [
        'Гарантированный рост',
        'Пара уходит с биржи — нужно закрыть/вывести',
        'Бесплатный airdrop',
        'Снижение комиссии',
      ],
      correctIndex: 1,
      explanation: 'Делистинг — операционный риск, выходите заранее.',
    ),
    QuizQuestion(
      category: 'Market',
      difficulty: 'Medium',
      question: 'Altseason typically happens when:',
      options: [
        'BTC dominance falls and alts outperform',
        'Only BTC pumps',
        'Volume is zero',
        'FOMC is cancelled',
      ],
      correctIndex: 0,
      explanation: 'BTC range + falling dominance + alt volume = altseason watch.',
    ),
    QuizQuestion(
      category: 'Market',
      difficulty: 'Medium',
      question: 'За сколько минут до ФРС лучше не входить?',
      options: ['1 минута', '30 минут', 'Никогда', '24 часа'],
      correctIndex: 1,
      explanation: 'Волатильность и спред растут — торгуйте реакцию после.',
    ),
    QuizQuestion(
      category: 'Basics',
      difficulty: 'Easy',
      question: 'P2P на Binance — это:',
      options: [
        'Бесплатные сигналы',
        'Покупка USDT у продавца за фиат',
        'Только для фьючерсов',
        'Взлом аккаунта',
      ],
      correctIndex: 1,
      explanation: 'P2P — стандартный путь пополнения в РФ и LATAM.',
    ),
    QuizQuestion(
      category: 'Basics',
      difficulty: 'Medium',
      question: 'API key для бота должен быть:',
      options: [
        'С правом вывода',
        'Read-only / trade без withdraw',
        'Публичным в чате',
        'Без IP whitelist',
      ],
      correctIndex: 1,
      explanation: 'Никогда не давайте withdraw на API.',
    ),
    QuizQuestion(
      category: 'Chart',
      difficulty: 'Hard',
      question: 'Fibonacci 0.618 in uptrend often acts as:',
      options: [
        'Random line',
        'Pullback support zone in trend',
        'Guaranteed top',
        'Funding rate',
      ],
      correctIndex: 1,
      explanation: 'Fib levels — зоны отката, не магия.',
    ),
    QuizQuestion(
      category: 'Patterns',
      difficulty: 'Easy',
      question: 'Нисходящий треугольник чаще пробивается:',
      options: ['Вверх всегда', 'Вниз', 'Без движения', 'Только на споте'],
      correctIndex: 1,
      explanation: 'Плоская поддержка + lower highs → breakdown.',
    ),
    QuizQuestion(
      category: 'Strategy',
      difficulty: 'Medium',
      question: 'Утро трейдера включает:',
      options: [
        'Сразу маркет на случайную монету',
        'Календарь, уровни BTC, watchlist, лимит сделок',
        'Только Instagram',
        'Удаление стопов',
      ],
      correctIndex: 1,
      explanation: 'Рутина снижает импульсивные ошибки.',
    ),
    QuizQuestion(
      category: 'Market',
      difficulty: 'Easy',
      question: 'Скам-чаты обычно обещают:',
      options: [
        'Обучение сетапам',
        'Гарантированную прибыль и «депозит трейдеру»',
        'Журнал сделок',
        'TradingView разбор',
      ],
      correctIndex: 1,
      explanation: 'Trade Master учит сетапам — не сигналам.',
    ),
  ];

  static List<QuizQuestion> byCategory(String category) {
    if (category == 'All') return allQuestions;
    return allQuestions.where((q) => q.category == category).toList();
  }

  static List<QuizQuestion> filter({
    required String category,
    required String difficulty,
  }) {
    final byCat = byCategory(category);
    if (difficulty == 'All') return byCat;
    return byCat.where((q) => q.difficulty == difficulty).toList();
  }
}
