import '../services/locale_service.dart';

/// Curated educational videos per module.
class LessonMediaEntry {
  final String titleRu;
  final String titleEn;
  final String titlePt;
  final String titleEs;
  final String url;
  final String thumbnail;

  const LessonMediaEntry({
    required this.titleRu,
    required this.titleEn,
    required this.titlePt,
    this.titleEs = '',
    required this.url,
    required this.thumbnail,
  });

  String titleFor(String lang) {
    switch (lang) {
      case 'ru':
        return titleRu;
      case 'pt':
        return titlePt;
      case 'es':
        return titleEs.isNotEmpty ? titleEs : titleEn;
      default:
        return titleEn;
    }
  }
}

class LessonMedia {
  static const _byModule = <String, LessonMediaEntry>{
    'intro': LessonMediaEntry(
      titleRu: 'Вводный курс',
      titleEn: 'Intro course',
      titlePt: 'Curso introdutório',
      titleEs: 'Curso introductorio',
      url: 'https://www.youtube.com/watch?v=2ki-YF1heeE',
      thumbnail: 'https://img.youtube.com/vi/2ki-YF1heeE/hqdefault.jpg',
    ),
  };

  static const _byLesson = <int, LessonMediaEntry>{
    1: LessonMediaEntry(
      titleRu: 'Вводное. С чего начать в трейдинге? Часть 1',
      titleEn: 'Introductory. Where to start in trading? Part 1',
      titlePt: 'Introdução. Por onde começar no trading? Parte 1',
      titleEs: 'Introducción. ¿Por dónde empezar en trading? Parte 1',
      url: 'https://www.youtube.com/watch?v=2ki-YF1heeE',
      thumbnail: 'https://img.youtube.com/vi/2ki-YF1heeE/hqdefault.jpg',
    ),
    2: LessonMediaEntry(
      titleRu: 'Вводное. С чего начать? Часть 2',
      titleEn: 'Introductory. Where to start? Part 2',
      titlePt: 'Introdução. Por onde começar? Parte 2',
      titleEs: 'Introducción. ¿Por dónde empezar? Parte 2',
      url: 'https://www.youtube.com/watch?v=YFruWV883tc',
      thumbnail: 'https://img.youtube.com/vi/YFruWV883tc/hqdefault.jpg',
    ),
    3: LessonMediaEntry(
      titleRu: 'Амплитуда движения',
      titleEn: 'Movement amplitude',
      titlePt: 'Amplitude do movimento',
      titleEs: 'Amplitud del movimiento',
      url: 'https://www.youtube.com/watch?v=ula4cspom20',
      thumbnail: 'https://img.youtube.com/vi/ula4cspom20/hqdefault.jpg',
    ),
    4: LessonMediaEntry(
      titleRu: 'Поддержка по лоям',
      titleEn: 'Loyal support',
      titlePt: 'Apoio leal',
      titleEs: 'Apoyo leal',
      url: 'https://www.youtube.com/watch?v=zogDIOFPkbQ',
      thumbnail: 'https://img.youtube.com/vi/zogDIOFPkbQ/hqdefault.jpg',
    ),
    5: LessonMediaEntry(
      titleRu: 'Стакан. Подробно',
      titleEn: 'Order book in detail',
      titlePt: 'Livro de ofertas em detalhes',
      titleEs: 'Libro de órdenes en detalle',
      url: 'https://www.youtube.com/watch?v=Ay8uPZi4MtI',
      thumbnail: 'https://img.youtube.com/vi/Ay8uPZi4MtI/hqdefault.jpg',
    ),
    6: LessonMediaEntry(
      titleRu: 'Быстрый и медленный рынок',
      titleEn: 'Fast and slow market',
      titlePt: 'Mercado rápido e lento',
      titleEs: 'Mercado rápido y lento',
      url: 'https://www.youtube.com/watch?v=bAnyY1W5D6o',
      thumbnail: 'https://img.youtube.com/vi/bAnyY1W5D6o/hqdefault.jpg',
    ),
    7: LessonMediaEntry(
      titleRu: 'Основные ошибки новичков. Часть 1',
      titleEn: 'Basic mistakes of newbies. Part 1',
      titlePt: 'Erros clássicos de iniciantes. Parte 1',
      titleEs: 'Errores clásicos de principiantes. Parte 1',
      url: 'https://www.youtube.com/watch?v=_g0vbQGM-aw',
      thumbnail: 'https://img.youtube.com/vi/_g0vbQGM-aw/hqdefault.jpg',
    ),
    8: LessonMediaEntry(
      titleRu: 'Нисходящий треугольник',
      titleEn: 'Descending triangle',
      titlePt: 'Triângulo descendente',
      titleEs: 'Triangulo descendente',
      url: 'https://www.youtube.com/watch?v=ImGfY5iCS8M',
      thumbnail: 'https://img.youtube.com/vi/ImGfY5iCS8M/hqdefault.jpg',
    ),
    9: LessonMediaEntry(
      titleRu: 'Восходящий треугольник',
      titleEn: 'Ascending triangle',
      titlePt: 'Triângulo ascendente',
      titleEs: 'Triángulo ascendente',
      url: 'https://www.youtube.com/watch?v=-eTem4vDuJo',
      thumbnail: 'https://img.youtube.com/vi/-eTem4vDuJo/hqdefault.jpg',
    ),
    10: LessonMediaEntry(
      titleRu: 'Стратегия для импульсов',
      titleEn: 'Strategy for impulses',
      titlePt: 'Estratégia de impulso',
      titleEs: 'Estrategia de impulso',
      url: 'https://www.youtube.com/watch?v=sTSMRvji9gc',
      thumbnail: 'https://img.youtube.com/vi/sTSMRvji9gc/hqdefault.jpg',
    ),
    11: LessonMediaEntry(
      titleRu: 'Делистинг монет с биржи',
      titleEn: 'Delisting of coins from the exchange',
      titlePt: 'Remoção de moedas da bolsa',
      titleEs: 'Exclusión de monedas del intercambio',
      url: 'https://www.youtube.com/watch?v=dEjY21Kz6b4',
      thumbnail: 'https://img.youtube.com/vi/dEjY21Kz6b4/hqdefault.jpg',
    ),
    12: LessonMediaEntry(
      titleRu: 'Листинг новой монеты',
      titleEn: 'Listing of a new coin',
      titlePt: 'Listagem de uma nova moeda',
      titleEs: 'Listado de una nueva moneda',
      url: 'https://www.youtube.com/watch?v=_lfU_N-YAPo',
      thumbnail: 'https://img.youtube.com/vi/_lfU_N-YAPo/hqdefault.jpg',
    ),
    13: LessonMediaEntry(
      titleRu: 'Каналы: параллельная поддержка и сопротивление',
      titleEn: 'Channels: parallel support and resistance',
      titlePt: 'Canais: suporte paralelo e resistência',
      titleEs: 'Canales: soporte y resistencia paralelos',
      url: 'https://www.youtube.com/watch?v=qRGuHWrEc0k',
      thumbnail: 'https://img.youtube.com/vi/qRGuHWrEc0k/hqdefault.jpg',
    ),
    14: LessonMediaEntry(
      titleRu: 'Восходящий тренд: Higher High и Higher Low',
      titleEn: 'Uptrend: Higher High and Higher Low',
      titlePt: 'Tendência de alta: máxima mais alta e mínima mais alta',
      titleEs: 'Tendencia alcista: máximo más alto y mínimo más alto',
      url: 'https://www.youtube.com/watch?v=f2xFqvZrS58',
      thumbnail: 'https://img.youtube.com/vi/f2xFqvZrS58/hqdefault.jpg',
    ),
    15: LessonMediaEntry(
      titleRu: 'Нисходящий тренд: Lower High и Lower Low',
      titleEn: 'Downtrend: Lower High and Lower Low',
      titlePt: 'Tendência de baixa: máxima inferior e mínima inferior',
      titleEs: 'Tendencia bajista: máximo más bajo y mínimo más bajo',
      url: 'https://www.youtube.com/watch?v=VrdXd0IxZ40',
      thumbnail: 'https://img.youtube.com/vi/VrdXd0IxZ40/hqdefault.jpg',
    ),
    16: LessonMediaEntry(
      titleRu: 'MA, RSI и объём: три фильтра импульса',
      titleEn: 'MA, RSI and volume: three momentum filters',
      titlePt: 'MA, RSI e volume: três filtros de momentum',
      titleEs: 'MA, RSI y volumen: tres filtros de impulso',
      url: 'https://www.youtube.com/watch?v=VMsiQJsrqcg',
      thumbnail: 'https://img.youtube.com/vi/VMsiQJsrqcg/hqdefault.jpg',
    ),
    17: LessonMediaEntry(
      titleRu: 'Новости CPI и FOMC: торговля вокруг макро',
      titleEn: 'CPI and FOMC news: trading around macro',
      titlePt: 'Notícias CPI e FOMC: trading em torno do macro',
      titleEs: 'Noticias sobre el IPC y el FOMC: operaciones macroeconómicas',
      url: 'https://www.youtube.com/watch?v=jBy-ilJ5840',
      thumbnail: 'https://img.youtube.com/vi/jBy-ilJ5840/hqdefault.jpg',
    ),
    18: LessonMediaEntry(
      titleRu: 'Риск на депозит: 0.5–1% на сделку',
      titleEn: 'Deposit risk: 0.5–1% per transaction',
      titlePt: 'Risco de depósito: 0,5–1% por transação',
      titleEs: 'Riesgo de depósito: 0,5–1% por transacción',
      url: 'https://www.youtube.com/watch?v=iovKK79fWp4',
      thumbnail: 'https://img.youtube.com/vi/iovKK79fWp4/hqdefault.jpg',
    ),
    19: LessonMediaEntry(
      titleRu: 'Симметричный треугольник',
      titleEn: 'Symmetric triangle',
      titlePt: 'Triângulo simétrico',
      titleEs: 'Triángulo simétrico',
      url: 'https://www.youtube.com/watch?v=pUA5zXgb9j4',
      thumbnail: 'https://img.youtube.com/vi/pUA5zXgb9j4/hqdefault.jpg',
    ),
    20: LessonMediaEntry(
      titleRu: 'FUN и мем-токены: риски и momentum',
      titleEn: 'FUN and meme tokens: risks and momentum',
      titlePt: 'Tokens FUN e meme: riscos e impulso',
      titleEs: 'Tokens FUN y memes: riesgos e impulso',
      url: 'https://www.youtube.com/watch?v=sTSMRvji9gc',
      thumbnail: 'https://img.youtube.com/vi/sTSMRvji9gc/hqdefault.jpg',
    ),
    21: LessonMediaEntry(
      titleRu: 'Удержание до цели: дисциплина тейк-профита',
      titleEn: 'Holding to the goal: take profit discipline',
      titlePt: 'Mantendo-se fiel ao objetivo: disciplina de obtenção de lucro',
      titleEs: 'Aferrarse al objetivo: disciplina de obtención de beneficios',
      url: 'https://www.youtube.com/watch?v=BwXPhoOjAF0',
      thumbnail: 'https://img.youtube.com/vi/BwXPhoOjAF0/hqdefault.jpg',
    ),
    22: LessonMediaEntry(
      titleRu: 'Тики и поток ордеров — честный старт',
      titleEn: 'Ticks and order flow - a fair start',
      titlePt: 'Tiques e fluxo de pedidos – um começo justo',
      titleEs: 'Tics y flujo de pedidos: un buen comienzo',
      url: 'https://www.youtube.com/watch?v=Ay8uPZi4MtI',
      thumbnail: 'https://img.youtube.com/vi/Ay8uPZi4MtI/hqdefault.jpg',
    ),
    23: LessonMediaEntry(
      titleRu: 'План входа и выхода: R:R минимум 1:2',
      titleEn: 'Entry and exit plan: R:R minimum 1:2',
      titlePt: 'Plano de entrada e saída: R:R mínimo 1:2',
      titleEs: 'Plan de entrada y salida: R:R mínimo 1:2',
      url: 'https://www.youtube.com/watch?v=pBKgw1fxius',
      thumbnail: 'https://img.youtube.com/vi/pBKgw1fxius/hqdefault.jpg',
    ),
    24: LessonMediaEntry(
      titleRu: 'Рыночные циклы: накопление, рост, распределение',
      titleEn: 'Market cycles: accumulation, growth, distribution',
      titlePt: 'Ciclos de mercado: acumulação, crescimento, distribuição',
      titleEs: 'Ciclos de mercado: acumulación, crecimiento, distribución.',
      url: 'https://www.youtube.com/watch?v=25Qye437HrI',
      thumbnail: 'https://img.youtube.com/vi/25Qye437HrI/hqdefault.jpg',
    ),
    25: LessonMediaEntry(
      titleRu: 'Что такое альтсезон и когда его ждать',
      titleEn: 'What is altseason and when to expect it',
      titlePt: 'O que é altseason e quando esperar',
      titleEs: '¿Qué es la temporada alta y cuándo esperarla?',
      url: 'https://www.youtube.com/watch?v=4pduRC-Qq-c',
      thumbnail: 'https://img.youtube.com/vi/4pduRC-Qq-c/hqdefault.jpg',
    ),
    26: LessonMediaEntry(
      titleRu: 'График BTC для движения внутри дня',
      titleEn: 'BTC chart for intraday movement',
      titlePt: 'Gráfico BTC para movimento intradiário',
      titleEs: 'Gráfico BTC para movimiento intradiario',
      url: 'https://www.youtube.com/watch?v=LVBZAquaEEg',
      thumbnail: 'https://img.youtube.com/vi/LVBZAquaEEg/hqdefault.jpg',
    ),
    27: LessonMediaEntry(
      titleRu: 'Торговые ситуации при проливе BTC',
      titleEn: 'Trading situations in the BTC strait',
      titlePt: 'Situações de trading no estreito BTC',
      titleEs: 'Situaciones comerciales en el estrecho de BTC',
      url: 'https://www.youtube.com/watch?v=jZt_1rtC1kY',
      thumbnail: 'https://img.youtube.com/vi/jZt_1rtC1kY/hqdefault.jpg',
    ),
    28: LessonMediaEntry(
      titleRu: 'Как вернуться после большого минуса',
      titleEn: 'How to come back after a big loss',
      titlePt: 'Como voltar depois de uma grande perda',
      titleEs: 'Cómo regresar después de una gran pérdida',
      url: 'https://www.youtube.com/watch?v=hAmCeOyxzZQ',
      thumbnail: 'https://img.youtube.com/vi/hAmCeOyxzZQ/hqdefault.jpg',
    ),
    29: LessonMediaEntry(
      titleRu: 'Марафон. Блок 1',
      titleEn: 'Marathon. Block 1',
      titlePt: 'Maratona. Bloco 1',
      titleEs: 'Maratón. Bloque 1',
      url: 'https://www.youtube.com/watch?v=subkGDpVtc0',
      thumbnail: 'https://img.youtube.com/vi/subkGDpVtc0/hqdefault.jpg',
    ),
    30: LessonMediaEntry(
      titleRu: 'Марафон. Блок 2 — исполнение',
      titleEn: 'Marathon. Block 2 - execution',
      titlePt: 'Maratona. Bloco 2 – execução',
      titleEs: 'Maratón. Bloque 2 - ejecución',
      url: 'https://www.youtube.com/watch?v=fZxYYxdQt7Q',
      thumbnail: 'https://img.youtube.com/vi/fZxYYxdQt7Q/hqdefault.jpg',
    ),
    31: LessonMediaEntry(
      titleRu: 'Усреднение: опасность для депозита',
      titleEn: 'Averaging: danger for the deposit',
      titlePt: 'Média: perigo para o depósito',
      titleEs: 'Promediación: peligro para el depósito',
      url: 'https://www.youtube.com/watch?v=BwXPhoOjAF0',
      thumbnail: 'https://img.youtube.com/vi/BwXPhoOjAF0/hqdefault.jpg',
    ),
    32: LessonMediaEntry(
      titleRu: 'Смена тренда: восходящий → нисходящий',
      titleEn: 'Trend change: upward → downward',
      titlePt: 'Mudança de tendência: para cima → para baixo',
      titleEs: 'Cambio de tendencia: al alza → a la baja',
      url: 'https://www.youtube.com/watch?v=E3oBl8Gv9kE',
      thumbnail: 'https://img.youtube.com/vi/E3oBl8Gv9kE/hqdefault.jpg',
    ),
    33: LessonMediaEntry(
      titleRu: 'Анализ своей торговли',
      titleEn: 'Analysis of your trading',
      titlePt: 'Análise da sua trading',
      titleEs: 'Análisis de su trading',
      url: 'https://www.youtube.com/watch?v=TnFoQZ6huao',
      thumbnail: 'https://img.youtube.com/vi/TnFoQZ6huao/hqdefault.jpg',
    ),
    34: LessonMediaEntry(
      titleRu: 'Заседание ФРС (FOMC)',
      titleEn: 'Federal Reserve Meeting (FOMC)',
      titlePt: 'Reunião da Reserva Federal (FOMC)',
      titleEs: 'Reunión de la Reserva Federal (FOMC)',
      url: 'https://www.youtube.com/watch?v=jBy-ilJ5840',
      thumbnail: 'https://img.youtube.com/vi/jBy-ilJ5840/hqdefault.jpg',
    ),
    35: LessonMediaEntry(
      titleRu: 'Скам-чаты и сигнальные группы',
      titleEn: 'Scam chats and signal groups',
      titlePt: 'Bate-papos fraudulentos e grupos de sinalização',
      titleEs: 'Chats fraudulentos y grupos de señales',
      url: 'https://www.youtube.com/watch?v=g3F7KRRy-3Q',
      thumbnail: 'https://img.youtube.com/vi/g3F7KRRy-3Q/hqdefault.jpg',
    ),
    36: LessonMediaEntry(
      titleRu: 'Перевод активов между биржами',
      titleEn: 'Transfer of assets between exchanges',
      titlePt: 'Transferência de ativos entre bolsas',
      titleEs: 'Transferencia de activos entre bolsas.',
      url: 'https://www.youtube.com/watch?v=3AD3pPSD0q4',
      thumbnail: 'https://img.youtube.com/vi/3AD3pPSD0q4/hqdefault.jpg',
    ),
    37: LessonMediaEntry(
      titleRu: 'Соединение по API. Безопасность read-only',
      titleEn: 'API connection. Read-only security',
      titlePt: 'Conexão API. Segurança somente leitura',
      titleEs: 'Conexión API. Seguridad de solo lectura',
      url: 'https://www.youtube.com/watch?v=U03tEQwoR5o',
      thumbnail: 'https://img.youtube.com/vi/U03tEQwoR5o/hqdefault.jpg',
    ),
    38: LessonMediaEntry(
      titleRu: 'Торговля на работе или дома',
      titleEn: 'Trading at work or at home',
      titlePt: 'Trading no trabalho ou em casa',
      titleEs: 'Negociar en el trabajo o en casa',
      url: 'https://www.youtube.com/watch?v=TDDVLZbKp5g',
      thumbnail: 'https://img.youtube.com/vi/TDDVLZbKp5g/hqdefault.jpg',
    ),
    39: LessonMediaEntry(
      titleRu: 'Фьючерсы. Часть 1',
      titleEn: 'Futures. Part 1',
      titlePt: 'Futuros. Parte 1',
      titleEs: 'Futuros. Parte 1',
      url: 'https://www.youtube.com/watch?v=4BhZ3qhP9DA',
      thumbnail: 'https://img.youtube.com/vi/4BhZ3qhP9DA/hqdefault.jpg',
    ),
    40: LessonMediaEntry(
      titleRu: 'Основные ошибки. Часть 2',
      titleEn: 'Basic mistakes. Part 2',
      titlePt: 'Erros básicos. Parte 2',
      titleEs: 'Errores básicos. parte 2',
      url: 'https://www.youtube.com/watch?v=3cSmtJ927KU',
      thumbnail: 'https://img.youtube.com/vi/3cSmtJ927KU/hqdefault.jpg',
    ),
    41: LessonMediaEntry(
      titleRu: 'Какие приложения реально нужны',
      titleEn: 'What applications are really needed?',
      titlePt: 'Quais aplicativos são realmente necessários?',
      titleEs: '¿Qué aplicaciones son realmente necesarias?',
      url: 'https://www.youtube.com/watch?v=LJ5lhWw1zT4',
      thumbnail: 'https://img.youtube.com/vi/LJ5lhWw1zT4/hqdefault.jpg',
    ),
    42: LessonMediaEntry(
      titleRu: 'Утро трейдера',
      titleEn: 'Trader\'s morning',
      titlePt: 'Manhã do comerciante',
      titleEs: 'La mañana del comerciante',
      url: 'https://www.youtube.com/watch?v=fXFJCUi-y6w',
      thumbnail: 'https://img.youtube.com/vi/fXFJCUi-y6w/hqdefault.jpg',
    ),
    43: LessonMediaEntry(
      titleRu: 'Коррекция по Фибоначчи',
      titleEn: 'Fibonacci correction',
      titlePt: 'Correção de Fibonacci',
      titleEs: 'Corrección de Fibonacci',
      url: 'https://www.youtube.com/watch?v=x39IbgQdBsc',
      thumbnail: 'https://img.youtube.com/vi/x39IbgQdBsc/hqdefault.jpg',
    ),
    44: LessonMediaEntry(
      titleRu: 'Airdrop и Pre-market',
      titleEn: 'Airdrop and Pre-market',
      titlePt: 'Airdrop e pré-comercialização',
      titleEs: 'Lanzamiento aéreo y precomercialización',
      url: 'https://www.youtube.com/watch?v=c94L-1ybV4k',
      thumbnail: 'https://img.youtube.com/vi/c94L-1ybV4k/hqdefault.jpg',
    ),
    45: LessonMediaEntry(
      titleRu: 'Свечи. Часть 2',
      titleEn: 'Candles. Part 2',
      titlePt: 'Velas. Parte 2',
      titleEs: 'Velas. parte 2',
      url: 'https://www.youtube.com/watch?v=Xucv_tRFqtY',
      thumbnail: 'https://img.youtube.com/vi/Xucv_tRFqtY/hqdefault.jpg',
    ),
    46: LessonMediaEntry(
      titleRu: 'Голова и плечи',
      titleEn: 'Head and shoulders',
      titlePt: 'Cabeça e ombros',
      titleEs: 'Cabeza y hombros',
      url: 'https://www.youtube.com/watch?v=yuReGzavfuo',
      thumbnail: 'https://img.youtube.com/vi/yuReGzavfuo/hqdefault.jpg',
    ),
    47: LessonMediaEntry(
      titleRu: 'Перевёрнутые голова и плечи',
      titleEn: 'Inverse head and shoulders',
      titlePt: 'Cabeça e ombros inversos',
      titleEs: 'Cabeza y hombros inversos',
      url: 'https://www.youtube.com/watch?v=yuReGzavfuo',
      thumbnail: 'https://img.youtube.com/vi/yuReGzavfuo/hqdefault.jpg',
    ),
  };

  /// YouTube embeds disabled: no reliable multi-language captions in-app.
  static LessonMediaEntry? forLesson(int lessonId, String module) => null;

  static LessonMediaEntry? forModule(String module) => null;

  static String localizedTitle(LessonMediaEntry entry) {
    return entry.titleFor(LocaleService.instance.languageCode);
  }
}
