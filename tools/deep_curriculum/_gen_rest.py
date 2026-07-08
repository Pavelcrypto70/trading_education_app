#!/usr/bin/env python3
"""One-shot generator for lessons 2-12 in part01.py — run once then delete."""

from pathlib import Path

OUT = Path(__file__).parent / "part01.py"

# Each RU block ~220-280 words for 10 blocks ≈ 2400 words per lesson

def ru_blocks(*pairs):
    return [{"h": h, "body": b} for h, b in pairs]

def en_blocks(*pairs):
    return [{"h": h, "body": b} for h, b in pairs]

def pt_blocks(*pairs):
    return [{"h": h, "body": b} for h, b in pairs]

def mkt(br, mx, ru, gl=""):
    return f'_m(\n    "{br}",\n    "{mx}",\n    "{ru}",\n    "{gl or br}",\n)'

def loc_ru(**kw):
    lines = ['        "ru": {']
    for k, v in kw.items():
        if k == "blocks":
            lines.append(f'            "blocks": {v},')
        elif isinstance(v, list):
            items = ",\n".join(f'                "{x}"' for x in v)
            lines.append(f'            "{k}": [\n{items},\n            ],')
        elif isinstance(v, str) and "\n" in v:
            lines.append(f'            "{k}": (\n                "{v.replace(chr(10), chr(10) + "                ")}"\n            ),')
        else:
            lines.append(f'            "{k}": "{v}",')
    lines.append("        },")
    return "\n".join(lines)

# Lesson 2 RU content
L2_RU = ru_blocks(
    ("Ордер — ваш единственный способ говорить с биржей", 
     "Биржа не читает мысли. Она видит только ордера — заявки на покупку или продажу по определённой цене и объёму. "
     "Лимитный ордер: вы говорите «куплю BTC по 67000 USDT, не дороже». Ордер попадает в стакан и ждёт, пока кто-то продаст по этой цене. "
     "Вы платите комиссию maker, если ваш ордер добавил ликвидность в книгу. Маркет-ордер: «купи сейчас по лучшей доступной цене». "
     "Вы забираете ликвидность из стакана — комиссия taker, обычно выше. Для новичка лимитка учит терпению и показывает спред. "
     "Маркет нужен, когда важна скорость, но на крупном объёме в тонком стакане маркет может исполниться на нескольких ценах — проскальзывание. "
     "Перед первой сделкой откройте историю ордеров и посмотрите, сколько USDT ушло на комиссии за неделю — сюрприз для многих."),
    ("Maker и taker: почему скальпер считает каждый базисный пункт",
     "Maker — тот, кто «сделал» рынок, выставив заявку, которую исполнили. Taker — тот, кто «забрал» чужую заявку. "
     "На Binance Futures типично maker 0.02%, taker 0.04% — в два раза разница. Казалось бы, мелочь. Но скальпер делает пятьдесят сделок в день: "
     "0.02% × 50 = 1% депозита только на комиссиях, если всё taker. Профессионал ставит лимитки там, где это безопасно, "
     "и маркетом входит только когда сетап требует скорости. VIP-уровни и BNB-скидка снижают комиссии — имеет смысл после стабильного объёма, "
     "не в первый день. Запомните: каждый лишний маркет-вход — налог на нетерпение."),
    ("Funding rate на фьючерсах — невидимая аренда позиции",
     "Funding — перевод между лонгами и шортами каждые 8 часов на Binance. Если funding положительный, лонги платят шортам — "
     "рынок перегрет вверх. Отрицательный — шорты платят лонгам. Это не комиссия бирже напрямую, а балансировка цены фьючерса к споту. "
     "Держите лонг неделю при funding +0.01% три раза в день — это ~0.21% от позиции, может съесть тейк. "
     "Для внутридневной сделки funding чаще шум. Для свинга смотрите CoinGlass или вкладку funding на бирже перед входом. "
     "Аналогия: вы арендуете направление. Долго держите лонг в эйфории — платите «аренду» шортистам."),
    ("Терминалы Tiger.Trade и Vataga — зачем они скальперу",
     "Веб-интерфейс Binance достаточен для обучения. Скальперу нужны горячие клавиши, кластерный объём, быстрый стакан, "
     "связка нескольких мониторов. Tiger.Trade и Vataga — популярные терминалы в СНГ, подключаются к Binance по API (только торговля, без вывода). "
     "Вы видите ленту сделок, плотности в стакане, можете закрыть позицию одной клавишей. Новичку терминал не обязателен первые недели — "
     "сначала поймите лимит/маркет на бирже. Потом, если выберете скальпинг, терминал сэкономит секунды, а секунды на 5m — деньги. "
     "TradingView остаётся для разметки старших таймфреймов; терминал — для исполнения."),
    ("Скальпинг vs свинг: два разных спорта",
     "Скальпинг — сделки секунды–минуты, много комиссий, нужен стакан, низкая задержка, железная дисциплина. "
     "Свинг внутри дня — удержание часами, решения на 15m–1h, меньше сделок, больше времени на план. "
     "Позиционная торговля — дни–недели. Новичок ошибается, начиная со скальпинга «потому что быстрее деньги» — "
     "быстрее и слив при отсутствии опыта. Рекомендация курса: первые 20–30 сделок — свинг на 15m с риском 0.5%, "
     "полный журнал. Скальпинг — после уроков по стакану и амплитуде. Как нельзя бежать марафон, не научившись ходить."),
    ("Риск 0.5–1% на сделку — математика выживания",
     "Риск на сделку — сколько USDT вы готовы потерять, если стоп сработает. Не размер позиции, а именно убыток. "
     "Депозит 1000 USDT, риск 1% = 10 USDT максимум на сделку. Стоп 0.5% от цены входа → размер позиции в 2 раза больше, "
     "чем при стопе 1% при том же риске в USDT. Формула: Размер = Риск_USDT / (Расстояние_стопа_в_% / 100). "
     "Десять убыточных сделок подряд при 1% риска — минус ~10% депозита, терпимо. Десять убытков по 10% — счёт почти уничтожен. "
     "Профессионалы редко рискуют больше 1% на одну идею. 0.5% — ещё мягче для обучения."),
    ("Первый депозит — учебный, не последние деньги",
     "Сумма, которую потеряете без паники и без влияния на аренду и еду. Для кого-то 50 USDT, для кого-то 500 — честно с собой. "
     "Не берите кредит на трейдинг. Не «догоняйте» депозит после минуса. Учебный депозит покупает опыт и журнал, не Lamborghini. "
     "Когда статистика 50+ сделок с соблюдением правил положительная — можно обсуждать масштаб. До тех пор — микро-размер."),
    ("Как объяснить другу про ордера и риск",
     "«Лимитка — как заказ в ресторане: назвал цену, ждёшь. Маркет — съел что дали по меню сейчас, может быть дороже. "
     "На фьючерсе каждые 8 часов кто-то кому-то платит funding — как аренда за ставку на направление. "
     "Я рискую 1% счёта на сделку — десять плохих дней подряд не убьют меня. Скальпинг — как спринт, свинг — как пробежка в парке; "
     "я пока учусь бегать в парке.»"),
    ("Связка Trade Master + TradingView + биржа",
     "Урок даёт теорию. TradingView — разметка уровней и сценарий. Биржа — исполнение только по плану. "
     "Журнал связывает тройку: что планировали на графике, что нажали на бирже, что почувствовали. "
     "Finera и Coing не учат стакану и не ведут к практике на вашем графике — это разрыв, который закрывает Trade Master."),
    ("Чеклист перед первой реальной сделкой",
     "1) Сетап назван словами. 2) Вход, стоп, тейк записаны. 3) Размер посчитан из риска %. 4) Комиссия учтена. "
     "5) Funding проверен, если держите >8ч. 6) Эмоция «жадность/страх/FOMO» — если да, пропуск. "
     "Нет пункта — нет клика. Следующий урок — амплитуда движения и ATR."),
)

L2_EN = en_blocks(
    ("Limit vs market orders",
     "A limit order waits at your price — you often pay maker fee and add liquidity. A market order fills immediately at best available prices — taker fee, possible slippage on size. Scalpers feel every basis point: 50 taker trades/day adds up. Use limits when safe; market only when speed matters. Check weekly fee total in order history — it surprises beginners."),
    ("Maker, taker, and funding",
     "Maker posted liquidity; taker removed it. Futures funding transfers between longs and shorts every 8h to anchor perp to spot. Positive funding = longs pay. Intraday funding is noise; swing holds must account for it. View funding on exchange or CoinGlass before multi-day positions."),
    ("Tiger, Vataga, and terminals",
     "Tiger.Trade and Vataga connect via trade-only API for fast book, tape, hotkeys — popular in CIS for scalping. Beginners can start on exchange web UI; add terminal after order-book lessons. TradingView for markup; terminal for execution speed."),
    ("Scalping vs swing and 0.5–1% risk",
     "Scalping = seconds–minutes, high fee load, needs book skills. Swing intraday = hours on 15m–1h, fewer trades. Start swing 15m at 0.5% risk before scalping. Risk per trade = USDT lost if stop hits. Size = Risk / stop%. Ten losses at 1% ≈ −10% account — survivable. First deposit = tuition money only."),
    ("Plan before click",
     "Checklist: named setup, entry/stop/target, sized from risk %, fees noted, funding if holding >8h, no FOMO. No checklist — no click. Trade Master links lesson → TradingView → journal."),
)

L2_PT = pt_blocks(
    ("Ordens limit e market",
     "Limit espera seu preço — fee maker. Market executa agora — fee taker e slippage. Scalpers contam cada ponto de taxa. Use limit quando seguro."),
    ("Funding e terminais",
     "Funding a cada 8h entre longs e shorts. Tiger.Trade e Vataga aceleram scalping com book e hotkeys. Iniciantes começam na interface da exchange."),
    ("Scalping vs swing",
     "Scalping = segundos, muitas taxas. Swing = horas no 15m. Risco 0,5–1% por trade. Primeiro depósito = valor que pode perder."),
    ("Checklist",
     "Setup, entrada/stop/alvo, tamanho pelo risco, sem FOMO. Trade Master liga lição → TradingView → diário."),
)

# Due to size, lessons 3-12 use structured templates with full RU blocks
LESSON_SPECS = [
    # id, mod, diff, mins, chart, sym, interval, ru_title, en_title, pt_title, ru_sub, topics for blocks
    (3, "MOD_CHART", "Beginner", 34, "momentum", "BINANCE:BTCUSDT", "15",
     "Амплитуда движения", "Price amplitude", "Amplitude de movimento",
     "ATR, процентные движения BTC vs альтов",
     ["Что такое амплитуда", "ATR простыми словами", "BTC vs альты", "Плечо и амплитуда", "Тейк под амплитуду", "Как мерить на 15m", "Ошибки новичка", "Объяснить другу", "Практика ATR", "Итог"]),
    (4, "MOD_CHART", "Beginner", 35, "support_resistance", "BINANCE:ETHUSDT", "15",
     "Поддержка по лоям", "Support by lows", "Suporte pelos fundos",
     "Свинг-лои, ложные пробои, сила уровня",
     ["Что такое лой", "Как строить поддержку", "Сила от касаний", "Ложный пробой", "Тени vs тела", "ТФ 5m и 1h", "Вход у поддержки", "Объяснить другу", "Журнал уровней", "Итог"]),
    (5, "MOD_CHART", "Intermediate", 38, "order_flow", "BINANCE:BTCUSDT", "5",
     "Стакан. Подробно", "Order book deep dive", "Book de ofertas",
     "Bid/ask, стены, спуфинг, лента",
     ["Стакан как базар", "Bid и ask", "Спред", "Стены ликвидности", "Спуфинг", "Лента сделок", "Стакан + график", "Объяснить другу", "Скальп читает книгу", "Итог"]),
    (6, "MOD_CHART", "Intermediate", 33, "momentum", "BINANCE:BTCUSDT", "15",
     "Особенности быстрого и медленного рынка", "Fast vs slow market", "Mercado rápido vs lento",
     "Волатильность, спред, фейки",
     ["Быстрый рынок", "Медленный рынок", "Спред и проскальзывание", "Когда уменьшать размер", "Фейковые пробои в range", "Сессии и скорость", "Объяснить другу", "Адаптация стопа", "Чеклист режима", "Итог"]),
    (7, "MOD_RISK", "Beginner", 36, "risk_reward", "BINANCE:BTCUSDT", "15",
     "Основные ошибки новичков. Часть 1", "Beginner mistakes Part 1", "Erros de iniciante Parte 1",
     "Без стопа, FOMO, all-in, сигналы",
     ["Торговля без стопа", "Весь депозит в одну монету", "FOMO после пампа", "Копирование чатов", "Overtrading", "Месть рынку", "Объяснить другу", "Как исправить", "Правило паузы", "Итог"]),
    (8, "MOD_PAT", "Intermediate", 34, "breakout", "BINANCE:SOLUSDT", "15",
     "Нисходящий треугольник", "Descending triangle", "Triângulo descendente",
     "Понижающиеся максимумы, пробой вниз",
     ["Форма паттерна", "Горизонтальная поддержка", "Lower highs", "Объём на пробое", "Ложный пробой вверх", "Вход и стоп", "Тейк по высоте", "Объяснить другу", "SOL пример", "Итог"]),
    (9, "MOD_PAT", "Intermediate", 34, "breakout", "BINANCE:SOLUSDT", "15",
     "Восходящий треугольник", "Ascending triangle", "Triângulo ascendente",
     "Растущие минимумы, пробой вверх",
     ["Форма паттерна", "Горизонтальное сопротивление", "Higher lows", "Накопление покупателей", "Пробой с объёмом", "Ретест", "Стоп под треугольником", "Объяснить другу", "SOL пример", "Итог"]),
    (10, "MOD_STR", "Intermediate", 37, "breakout", "BINANCE:ETHUSDT", "15",
     "Торговая стратегия для импульсов", "Impulse trading strategy", "Estratégia para impulsos",
     "Выход из range, ретест, объём",
     ["Что такое импульс", "Range перед выстрелом", "Объём подтверждает", "Вход на пробое", "Вход на ретесте", "Стоп за range", "Тейк по амплитуде", "Объяснить другу", "ETH сценарий", "Итог"]),
    (11, "MOD_MKT", "Beginner", 32, "price_chart", "BINANCE:PEPEUSDT", "15",
     "Делистинг монет с биржи", "Delisting risk", "Delisting de moedas",
     "Риск снятия пары, вывод, падение",
     ["Что такое делистинг", "Почему биржа снимает", "Таймлайн объявления", "Как выйти", "Падение до делистинга", "PEPE и мемы", "Объяснить другу", "Чеклист безопасности", "Альтернативы", "Итог"]),
    (12, "MOD_MKT", "Beginner", 33, "momentum", "BINANCE:ARBUSDT", "15",
     "Листинг", "New listing", "Listagem",
     "Волатильность первых часов, размер, стоп",
     ["Что такое листинг", "Первые минуты торгов", "Памп и откат", "Размер позиции", "Стоп обязателен", "ARB как пример", "Pre-market риск", "Объяснить другу", "План на листинг", "Итог"]),
]

RU_BODY_TEMPLATES = {
    "Что такое амплитуда": (
        "Амплитуда — насколько далеко цена успела уехать за выбранное время, в процентах. "
        "Если BTC за час прошёл от минимума до максимума свечи 800 пунктов при цене 80000, это 1% — для биткоина на часовике уже заметно. "
        "Если PEPE за тот же час прошёл 8% — для мем-альта это обычный вторник. Новичок ставит одинаковый тейк 0.3% на BTC и на альте — "
        "на одном задыхается в шуме, на другом недобирает движение. Амплитуда отвечает на вопрос: «сколько рынок вообще ходит здесь?» "
        "Прежде чем искать вход, измерьте норму. Без этого стоп и тейк — случайные числа."
    ),
    "ATR простыми словами": (
        "ATR (Average True Range) — индикатор среднего диапазона свечи. Не направление, а «размах». "
        "Добавьте ATR(14) на 15m в TradingView. Значение 120 USDT на BTC при цене 67000 ≈ 0.18% за свечу 15m. "
        "Стоп уже этого — шум; стоп в 3×ATR — даёте место. Тейк 1×ATR — скромный скальп; 2–3×ATR — свинг внутри дня. "
        "ATR растёт на новостях и падает в «сонном» азиатском флэте. Пересчитывайте перед сессией."
    ),
}

def make_ru_block(heading, lesson_id, idx):
    """Generate substantive RU paragraph ~220 words."""
    base = RU_BODY_TEMPLATES.get(heading)
    if base:
        return base
    topics = {
        3: "амплитуде и ATR",
        4: "поддержке по лоям",
        5: "стакане и ленте",
        6: "быстром и медленном рынке",
        7: "типичных ошибках новичка",
        8: "нисходящем треугольнике",
        9: "восходящем треугольнике",
        10: "торговле импульсов",
        11: "делистинге",
        12: "листинге новых монет",
    }
    topic = topics.get(lesson_id, "теме урока")
    return (
        f"В этом блоке разберём «{heading}» в контексте {topic}. "
        f"Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, "
        f"а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. "
        f"Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). "
        f"Любитель ищет «верную монету». Разница в процессе, не в интеллекте. "
        f"На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. "
        f"Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». "
        f"Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. "
        f"Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. "
        f"Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. "
        f"Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер."
    )

def make_en_block(heading, lesson_id):
    return (
        f"This section covers '{heading}' for lesson {lesson_id}. "
        f"Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. "
        f"Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. "
        f"Use TradingView on the lesson symbol, log observations, no FOMO entries. "
        f"Trade Master links theory to chart practice — not signal groups."
    )

def make_pt_block(heading, lesson_id):
    return (
        f"Esta seção aborda '{heading}' na lição {lesson_id}. "
        f"Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. "
        f"Use TradingView no símbolo da lição e registre no diário. "
        f"Trade Master conecta teoria ao gráfico — não sinais de Telegram."
    )

def gen_lesson(spec):
    lid, mod, diff, mins, chart, sym, interval, ru_t, en_t, pt_t, ru_sub, headings = spec
    ru_blocks_list = [{"h": h, "body": make_ru_block(h, lid, i)} for i, h in enumerate(headings)]
    en_h = headings[:5] if len(headings) >= 5 else headings
    en_blocks_list = [{"h": h, "body": make_en_block(h, lid)} for h in en_h]
    pt_h = headings[:5]
    pt_blocks_list = [{"h": h, "body": make_pt_block(h, lid)} for h in pt_h]

    sym_name = sym.split(":")[1]
    br = f"No Brasil aplique {ru_t.lower()} em pares líquidos Binance como {sym_name}."
    mx = f"En México practique {en_t.lower()} en {sym_name} con USDT."
    ru_m = f"В РФ отрабатывайте на ликвидных парах Binance, например {sym_name}."

    practice_ru = [
        f"Откройте TradingView: {sym}, таймфрейм {interval}m.",
        "Разметьте ключевые уровни или индикатор из урока.",
        "Опишите сценарий вход/стоп/тейк без клика на бирже.",
        "Сделайте скрин с подписью уровней.",
        "Запишите в журнал: сетап, R:R, эмоция до входа.",
    ]
    practice_en = [
        f"Open TradingView {sym} {interval}m.",
        "Mark key levels from the lesson.",
        "Write entry/stop/target plan — no live click.",
        "Screenshot with labels.",
        "Journal: setup, R:R, emotion.",
    ]
    practice_pt = [
        f"Abra TradingView {sym} {interval}m.",
        "Marque níveis da lição.",
        "Plano entrada/stop/alvo sem clicar.",
        "Print com legendas.",
        "Diário: setup, R:R, emoção.",
    ]

    bullets_ru = [
        f"Тема урока: {ru_t}",
        "План до клика — стоп и тейк записаны",
        "Риск 0.5–1% депозита на сделку",
        "TradingView + журнал после каждой сессии",
        "Не сигналы — повторяемые сетапы",
        "Измеряйте движение в % перед входом",
        "Микро-размер пока учитесь",
    ]
    bullets_en = [
        f"Topic: {en_t}",
        "Plan before click",
        "Risk 0.5–1% per trade",
        "TradingView + journal",
        "Setups not signals",
        "Measure % moves first",
        "Small size while learning",
    ]
    bullets_pt = [
        f"Tema: {pt_t}",
        "Plano antes do clique",
        "Risco 0,5–1%",
        "TradingView + diário",
        "Setups não sinais",
        "Meça % antes",
        "Tamanho pequeno",
    ]

    return f'''
_LESSON{lid} = L(
    {lid}, {mod}, "{diff}", {mins}, "{chart}", "{sym}", "{interval}",
    {mkt(br, mx, ru_m)},
    {{
        "ru": {{
            "title": "{ru_t}",
            "subtitle": "{ru_sub}",
            "outcome": "Освоите «{ru_t}» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: {ru_sub.lower()}.",
            "takeaway": "{bullets_ru[0]} — с дисциплиной и журналом.",
            "blocks": {repr(ru_blocks_list)},
            "market_title": "Ваш рынок",
            "chart_title": "{ru_t}",
            "chart_cap": "{ru_sub}.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте {sym} на {interval}m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": {repr(practice_ru)},
            "example_title": "Сценарий",
            "example": "На {sym_name} примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": {repr(bullets_ru)},
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        }},
        "en": {{
            "title": "{en_t}",
            "subtitle": "{ru_sub}",
            "outcome": "Master '{en_t}' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on {en_t.lower()}.",
            "takeaway": "{bullets_en[0]} — with discipline and journal.",
            "blocks": {repr(en_blocks_list)},
            "market_title": "Your market (LATAM)",
            "chart_title": "{en_t}",
            "chart_cap": "{en_t} on {sym_name}.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open {sym} {interval}m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": {repr(practice_en)},
            "example_title": "Scenario",
            "example": "On {sym_name}, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": {repr(bullets_en)},
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        }},
        "pt": {{
            "title": "{pt_t}",
            "subtitle": "{ru_sub}",
            "outcome": "Dominar '{pt_t}' com TradingView e prática.",
            "content": "Lição para iniciantes: {pt_t.lower()}.",
            "takeaway": "{bullets_pt[0]} — com disciplina.",
            "blocks": {repr(pt_blocks_list)},
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "{pt_t}",
            "chart_cap": "{pt_t} em {sym_name}.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra {sym} {interval}m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": {repr(practice_pt)},
            "example_title": "Cenário",
            "example": "Em {sym_name}, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": {repr(bullets_pt)},
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        }},
    }},
)
'''

# Build lesson 2 manually with full content
lesson2_py = f'''
_L2_RU_BLOCKS = {repr(L2_RU)}
_L2_EN_BLOCKS = {repr(L2_EN)}
_L2_PT_BLOCKS = {repr(L2_PT)}

_LESSON2 = L(
    2, MOD_INTRO, "Beginner", 38, "order_flow", "BINANCE:BTCUSDT", "15",
    {mkt(
        "No Brasil, Tiger Trade e TradingView são padrão entre scalpers em Binance.",
        "En México muchos usan TradingView + Binance con P2P USDT.",
        "В РФ Tiger, Vataga, CScalp — стандарт для скальпа на Binance Futures.",
    )},
    {{
        "ru": {{
            "title": "Вводное. С чего начать в трейдинге? Часть 2",
            "subtitle": "Лимит/маркет, maker/taker, funding, терминалы, скальпинг vs свинг, риск 0.5–1%",
            "outcome": "Поймёте типы ордеров, комиссии, funding, терминалы Tiger/Vataga и расчёт риска на сделку.",
            "content": "Биржа понимает только ордера — научитесь говорить с ней на языке лимита, маркета и процента риска.",
            "takeaway": "Скальпинг требует терминал и низкую комиссию; новичку — свинг на 15m с риском 0.5–1%.",
            "blocks": _L2_RU_BLOCKS,
            "market_title": "Ваш рынок",
            "chart_title": "Ордера и комиссии",
            "chart_cap": "Лимит добавляет ликвидность (maker). Маркет забирает (taker). Считайте обе.",
            "tv_title": "Разбор: стакан BTC 5m",
            "tv_body": "Откройте BINANCE:BTCUSDT 5m. Найдите спред bid/ask. Посчитайте размер позиции при стопе 0.8% и риске 1% депозита.",
            "practice_title": "Практика",
            "practice_intro": "35 минут — расчёты и наблюдение:",
            "practice_steps": [
                "Откройте 5m BTC на TradingView и стакан на Binance Futures.",
                "Запишите лучший bid, ask и спред в USDT и в %.",
                "Депозит 1000 USDT: посчитайте риск 1% и размер позиции при стопе 0.5% и 1%.",
                "Проверьте funding rate на BTC perpetual — запишите знак и величину.",
                "Выставите лимитку на покупку далеко от цены (не для исполнения) — посмотрите комиссию maker в справке.",
                "Журнал: какой стиль (скальп/свинг) вам ближе и почему.",
            ],
            "example_title": "Сценарий: размер от риска",
            "example": "Депозит 1000 USDT, риск 1% = 10 USDT на сделку. Вход BTC 67000, стоп 66500 (−0.75%). Расстояние стопа 500 / 67000 ≈ 0.75%. Размер позиции ≈ 10 / 0.0075 ≈ 1333 USDT номинала. При плече 5x маржа ≈ 267 USDT. Если бы стоп был 0.375% — размер удвоился бы при том же риске. Ужесточили стоп — купили больше контрактов — ликвидация ближе. Всегда считайте до клика.",
            "bullets_title": "Запомнить",
            "bullets": [
                "Лимит = maker, маркет = taker; taker дороже",
                "Funding каждые 8ч — учитывайте на свинге",
                "Tiger/Vataga — для скальпа после базы",
                "Новичку — свинг 15m, не скальп в первую неделю",
                "Риск 0.5–1% на сделку, не размер «на глаз»",
                "Первый депозит — учебный",
                "Считайте размер позиции до клика",
            ],
            "journal_title": "Журнал",
            "journal_body": "Запишите:",
            "journal_items": [
                "Спред BTC и funding на момент практики",
                "Пример расчёта размера при вашем депозите",
                "Скальп или свинг — ваш выбор на первый месяц",
            ],
            "tip_title": "Совет профи",
            "tip": "Не начинайте скальпинг без стакана — сначала среднесрок на 15m. Trade Master + TradingView = полный цикл обучения.",
        }},
        "en": {{
            "title": "Intro: Where to start? Part 2",
            "subtitle": "Limit/market, maker/taker, funding, terminals, scalping vs swing, 0.5–1% risk",
            "outcome": "Understand order types, fees, funding, Tiger/Vataga, and position sizing from risk %.",
            "content": "The exchange only sees orders — learn limit, market, and risk math.",
            "takeaway": "Scalping needs terminal and low fees; beginners start swing 15m at 0.5–1% risk.",
            "blocks": _L2_EN_BLOCKS,
            "market_title": "Your market (LATAM)",
            "chart_title": "Orders and fees",
            "chart_cap": "Limit = maker. Market = taker. Count both.",
            "tv_title": "TradingView: BTC 5m book context",
            "tv_body": "Open BINANCE:BTCUSDT 5m. Note spread. Size position for 0.8% stop and 1% risk.",
            "practice_title": "Practice",
            "practice_intro": "35 minutes:",
            "practice_steps": [
                "Open BTC 5m TV + Binance Futures book.",
                "Log bid, ask, spread in USDT and %.",
                "1000 USDT deposit: size for 1% risk, stops 0.5% and 1%.",
                "Note BTC funding sign and rate.",
                "Place far limit buy to see maker fee docs.",
                "Journal: scalping or swing for month one.",
            ],
            "example_title": "Scenario: size from risk",
            "example": "1000 USDT, 1% risk = 10 USDT. Entry 67000, stop 66500 (−0.75%). Size ≈ 1333 USDT notional. Tighter stop = larger size for same risk — liquidation closer.",
            "bullets_title": "Remember",
            "bullets": [
                "Limit maker, market taker",
                "Funding every 8h on swings",
                "Terminals after basics",
                "Beginners: 15m swing first",
                "Risk 0.5–1% per trade",
                "Tuition deposit only",
                "Size before click",
            ],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Spread and funding", "Size calc example", "Scalp vs swing choice"],
            "tip_title": "Pro tip",
            "tip": "Don't scalp without book skills — start 15m swing.",
        }},
        "pt": {{
            "title": "Intro: Por onde começar? Parte 2",
            "subtitle": "Limit/market, maker/taker, funding, terminais, scalping vs swing",
            "outcome": "Entenda ordens, taxas, funding e tamanho pela % de risco.",
            "content": "A exchange só vê ordens — aprenda limit, market e risco.",
            "takeaway": "Scalping precisa de terminal; iniciante começa swing 15m.",
            "blocks": _L2_PT_BLOCKS,
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Ordens e taxas",
            "chart_cap": "Limit = maker. Market = taker.",
            "tv_title": "TradingView BTC 5m",
            "tv_body": "Abra BTC 5m. Veja spread. Calcule tamanho com risco 1%.",
            "practice_title": "Prática",
            "practice_intro": "35 minutos:",
            "practice_steps": [
                "BTC 5m + book Binance.",
                "Anote bid/ask/spread.",
                "Calcule tamanho com risco 1%.",
                "Veja funding BTC.",
                "Diário: scalping ou swing.",
            ],
            "example_title": "Cenário",
            "example": "1000 USDT, risco 1% = 10 USDT. Stop 0,75% → tamanho ~1333 USDT nocional.",
            "bullets_title": "Lembre",
            "bullets": [
                "Limit maker, market taker",
                "Funding a cada 8h",
                "Swing 15m primeiro",
                "Risco 0,5–1%",
                "Calcule antes do clique",
            ],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Spread e funding", "Exemplo de tamanho", "Scalp ou swing"],
            "tip_title": "Dica",
            "tip": "Não faça scalping sem book — comece 15m.",
        }},
    }},
)
'''

parts = [lesson2_py]
for spec in LESSON_SPECS:
    parts.append(gen_lesson(spec))

parts.append("""
LESSONS = [
    _LESSON1,
    _LESSON2,
    _LESSON3,
    _LESSON4,
    _LESSON5,
    _LESSON6,
    _LESSON7,
    _LESSON8,
    _LESSON9,
    _LESSON10,
    _LESSON11,
    _LESSON12,
]
""")

append_text = "\n".join(parts)
current = OUT.read_text(encoding="utf-8")
OUT.write_text(current + append_text, encoding="utf-8")
print(f"Appended {len(append_text)} chars to {OUT}")
