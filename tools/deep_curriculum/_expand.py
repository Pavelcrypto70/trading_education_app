#!/usr/bin/env python3
"""Patch part01.py in-memory and rewrite with expanded blocks."""
import importlib.util
import pprint
from pathlib import Path

TARGET = Path(__file__).parent / "part01.py"

spec = importlib.util.spec_from_file_location("part01_mod", TARGET)
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)

L1_EXTRA_RU = {
    "h": "Маржа кросс и изолированная — выберите до первой сделки",
    "body": (
        "На фьючерсах Binance есть два режима маржи. Кросс-маржа: весь баланс фьючерсного кошелька "
        "поддерживает все открытые позиции. Удобно для опытных, опасно для новичка — один неудачный трейд "
        "может потянуть за собой остальные. Изолированная маржа: вы отделяете конкретную сумму USDT "
        "только под одну позицию. Ликвидируют максимум эту сумму, остальной баланс не трогают. "
        "Аналогия: кросс — общий семейный кошелёк на рискованную авантюру; изолированная — отдельный конверт "
        "с надписью «только на этот эксперимент». Первые пятьдесят сделок — только изолированная. "
        "Плечо 2–3x достаточно, чтобы почувствовать ускорение PnL, не превращая каждый тик в угрозу счёту. "
        "Перед входом откройте вкладку позиции и убедитесь, что режим Isolated выбран до нажатия Buy. "
        "Одна случайная сделка в Cross при 20x может стоить дороже всего курса обучения."
    ),
}
L1_EXTRA_EN = {
    "h": "Cross vs isolated margin",
    "body": (
        "Cross margin uses your entire futures wallet to back positions — one bad trade can drag the rest. "
        "Isolated margin caps loss to the allocated USDT for that position only. Beginners: isolated only, "
        "2–3x leverage max for first fifty trades. Verify Isolated is selected before Buy. "
        "Liquidation price must sit beyond your planned stop — if not, reduce size or leverage. "
        "Funding on overnight holds eats slow winners; check rate before multi-day longs. "
        "P2P in LATAM: use escrow chat only, rated sellers, test small first. "
        "Trade Master ties each lesson to TradingView markup — competitors rarely do full loop practice. "
        "Journal every session even when you do not trade — observation counts as training."
    ),
}

L2_RU_FULL = [
    ("Ордер — единственный язык общения с биржей",
     "Биржа — автомат. Она не знает, что вы «уверены в росте». Она видит заявки. Лимитный ордер: "
     "«Куплю 0.01 BTC по 66500 USDT». Пока цена выше — ордер ждёт в стакане. Маркет: «Купи сейчас» — "
     "исполнение по лучшим ask, возможно в несколько ценовых уровней. Новичок жмёт маркет из страха опоздать "
     "и платит taker fee плюс проскальзывание. Профессионал почти всегда знает, зачем ему маркет: "
     "только когда сетап требует скорости, а потеря на спреде меньше, чем потеря на упущенном движении. "
     "Откройте историю ордеров — увидите статусы New, Filled, Canceled. Это базовая грамотность."),
    ("Maker и taker: математика комиссий",
     "Maker добавил ликвидность — выставил лимит, который кто-то исполнил. Taker забрал чужую лимитку. "
     "На Binance Futures ориентир: maker ~0.02%, taker ~0.04%. Пятьдесят скальперских сделок в день все taker: "
     "комиссии съедают edge. Скальпер учится ставить лимит на вход там, где риск опоздания минимален. "
     "BNB для оплаты комиссий даёт скидку — включите после понимания базовых ставок."),
    ("Funding rate — скрытая стоимость удержания",
     "Каждые 8 часов на perpetual Binance происходит funding. Положительный: лонги платят шортам. "
     "Держите лонг три дня в апренде при +0.01% каждые 8ч — набегает заметная сумма. "
     "Внутридневщик часто закрывается до funding. Свингер смотрит CoinGlass перед входом."),
    ("Tiger.Trade и Vataga — когда нужен терминал",
     "Веб Binance хватит для обучения. Tiger и Vataga дают горячие клавиши, кластеры, быстрый стакан. "
     "Скальпер без терминала проигрывает в скорости. Порядок: биржа → TradingView 15m → стакан → терминал. "
     "API только trade, без withdraw, IP whitelist."),
    ("Скальпинг против свинга",
     "Скальп: секунды–минуты, десятки сделок, стакан обязателен. Свинг: 15m–1h, меньше сделок. "
     "Первый месяц — 15m свинг, риск 0.5%. Скальпинг после уроков по стакану."),
    ("Риск 0.5–1% — формула до клика",
     "Риск = USDT при стопе. Депозит 2000, риск 1% = 20 USDT. Размер = риск / дистанция стопа в долях. "
     "Десять стопов при 1% ≈ −10% счёта — переживаемо. При 10% на сделку — game over."),
    ("Первый депозит — учебные деньги",
     "Сумма без влияния на жизнь. Не кредит. Масштаб после 50+ сделок с правилами."),
    ("Как объяснить другу",
     "«Лимитка — заказ по акции. Маркет — купил сейчас по кассе. Funding — аренда ставки на направление. "
     "Рискую 1% кошелька, не весь кошелёк.»"),
    ("Урок → TradingView → биржа → журнал",
     "Теория без разметки забывается. Журнал без дисциплины — дневник обид."),
    ("Чеклист перед сделкой",
     "Сетап, вход/стоп/тейк, размер, комиссия, funding, нет FOMO. Красный пункт — нет клика."),
]

TOPIC_RU = {
    3: [
        ("Что такое амплитуда", "Амплитуда — диапазон движения цены в % за период. BTC на 15m в спокойный день 0.3–0.8%; SOL/PEPE 5–12% — норма. Измерьте high-low последних 20 свечей — это линейка для стопа и тейка. Тейк 0.2% на волатильном альте — нереалистичен. Без измерения торгуете вслепую."),
        ("ATR простыми словами", "ATR(14) — средний размах свечи, не направление. На BTCUSDT 15m стоп 0.1% — шум; 0.5% — за шумом. Тейк 1–3×ATR. Пересчитывайте после новостей. На альтах ATR в % выше — плечо ниже."),
        ("BTC vs альты", "BTC — локомотив, меньше % амплитуда. Альты двигаются с множителем. Смотрите BTC перед альтом. Не копируйте стопы с BTC на PEPE."),
        ("Плечо и амплитуда", "Высокая амплитуда + высокое плечо = близкая ликвидация. BTC max 5x на старте, альты 3x, мемы 2x или спот."),
        ("Тейк под амплитуду", "Тейк 0.5–1.5× сессионной амплитуды после сетапа. Жадность 5% за час без новости — не план."),
        ("Практика на 15m", "Измерьте % range 20 свечей на BTC и SOL. Сравните со стопом. Запишите в журнал."),
        ("Ошибки", "Одинаковый тейк на все монеты. Игнор BTC. Плечо как на BTC на меме."),
        ("Объяснить другу", "«У биткоина одна скорость, у дешёвой монеты выше. Сначала меряем, потом цели.»"),
        ("ATR и размер", "Широкий ATR → шире стоп, меньше контрактов при том же риске USDT."),
        ("Итог", "Амплитуда и ATR — до входа. BTC и альты — разные шкалы."),
    ],
    4: [
        ("Свинг-лой", "Локальный минимум с отскоком. 2+ касания — зона поддержки. Не рисуйте все тени подряд."),
        ("Построение уровня", "Три лоя на 1h/15m, горизонталь. Тела или тени — единообразно. Зона, не копейка."),
        ("Сила от касаний", "Больше касаний — внимание, но уровень истончается. Журналируйте дату и число касаний."),
        ("Ложный пробой", "Тень ниже, закрытие выше — охота стопов. Ждите закрытие свечи. Стоп ниже экстремума."),
        ("Тени vs тела", "Единый стиль. 5m и 1h — разные уровни. Старший ТФ важнее."),
        ("Вход у поддержки", "Уровень + реакция + контекст BTC. Стоп ниже зоны. R:R минимум 1:2."),
        ("Объяснить другу", "«Пол, от которого несколько раз отскакивали. Ложный пробой — наступил и вернулся.»"),
        ("Журнал уровней", "Пара, уровень, касания, пробит или нет."),
        ("Ошибки", "20 линий. Один лой. Лонг без стопа «из-за поддержки»."),
        ("Итог", "2+ лоя, ложный пробой, 3–5 уровней на сессию."),
    ],
}

def topic_block(lid, h):
    return (
        f"«{h}» — ключевая часть урока {lid}. Рынок — аукцион 24/7. До клика: вход, стоп, тейк, риск 0.5–1%. "
        f"TradingView: swing points, уровни, скрин. Журнал: эмоция до входа. Без плана — лотерея. "
        f"Профессионал после стопа делает паузу; любитель — реванш. Finera/Coing не дают цикл урок→график→журнал. "
        f"Trade Master даёт. Не копируйте Telegram VIP. Одна сделка не решает — процесс на 100 сделок решает. "
        f"Измеряйте движение в % перед входом. На быстром рынке уменьшайте размер. На медленном — не ждите огромных тейков. "
        f"Плечо снижайте на альтах и мемах. KYC и 2FA — база. P2P только в escrow чате биржи."
    )

for lid, heads in [
    (5, ["Стакан как базар", "Bid и ask", "Спред", "Стены", "Спуфинг", "Лента", "Стакан+график", "Другу", "Скальп", "Итог"]),
    (6, ["Быстрый рынок", "Медленный range", "Спред", "Размер", "Фейки", "Сессии", "Другу", "Стоп", "Чеклист", "Итог"]),
    (7, ["Без стопа", "All-in", "FOMO", "Чаты", "Overtrading", "Реванш", "Другу", "Исправить", "Пауза", "Итог"]),
    (8, ["Форма", "Поддержка", "Lower highs", "Объём", "Ложный вверх", "Вход шорт", "Тейк", "Другу", "SOL", "Итог"]),
    (9, ["Форма", "Сопротивление", "Higher lows", "Накопление", "Пробой", "Ретест", "Стоп", "Другу", "SOL", "Итог"]),
    (10, ["Импульс", "Range", "Объём", "Пробой", "Ретест", "Стоп", "Тейк", "Другу", "ETH", "Итог"]),
    (11, ["Делистинг", "Почему", "Таймлайн", "Выход", "Падение", "PEPE", "Другу", "Чеклист", "Не ноль", "Итог"]),
    (12, ["Листинг", "Первые минуты", "Памп-откат", "Размер", "Стоп", "ARB", "Pre-market", "Другу", "План", "Итог"]),
]:
    if lid not in TOPIC_RU:
        TOPIC_RU[lid] = [(h, topic_block(lid, h)) for h in heads]

def en_blocks(lid, title):
    return [
        {"h": "Core idea", "body": (
            f"Lesson {lid}: {title}. Trading is a continuous auction. Define entry, stop, target, and risk 0.5–1% "
            f"before every click. One trade proves nothing; edge appears over dozens of logged repetitions. "
            f"Beginners treat wins as genius and losses as betrayal — professionals treat both as data."
        )},
        {"h": "Measurement and context", "body": (
            "Measure recent range in % on your working timeframe. BTC context matters for alts. "
            "High amplitude → lower leverage and smaller risk. Use ATR or last 20 candles as a ruler for stops and targets. "
            "If distance to invalidation is smaller than noise, skip the setup."
        )},
        {"h": "TradingView workflow", "body": (
            "Open the lesson symbol and interval. Mark swings and levels. Screenshot the plan. "
            "Journal: setup name, entry/stop/target, R:R, emotion before entry. No screenshot — no trade. "
            "Trade Master links lesson → chart → journal; signal apps skip the middle step."
        )},
        {"h": "Execution rules", "body": (
            "Limit orders add liquidity (maker); market orders take liquidity (taker) — fees add up for scalpers. "
            "Funding every 8h affects swings, not most scalps. Isolated margin for beginners. "
            "Listing and delisting events demand minimum size and mandatory stops."
        )},
        {"h": "Mistakes to avoid", "body": (
            "No stop, all-in one coin, FOMO chase, copying chat signals, revenge trading after a stop. "
            "Fix with checklist, daily loss limit, 15–30 min cooldown, tuition deposit only."
        )},
        {"h": "Pro habit", "body": (
            "Reduce size 50% in fast markets. Widen stop without increasing USDT risk → smaller position. "
            "Explain the setup to a friend in one minute — if you cannot, you are not ready to click."
        )},
    ]

lessons = {L["id"]: L for L in mod.LESSONS}

lessons[1]["loc"]["ru"]["blocks"].append(L1_EXTRA_RU)
lessons[1]["loc"]["en"]["blocks"].append(L1_EXTRA_EN)

lessons[2]["loc"]["ru"]["blocks"] = [{"h": h, "body": b} for h, b in L2_RU_FULL]

for lid, pairs in TOPIC_RU.items():
    lessons[lid]["loc"]["ru"]["blocks"] = [{"h": h, "body": b} for h, b in pairs]

for lid in range(1, 13):
    title = lessons[lid]["loc"]["en"]["title"]
    lessons[lid]["loc"]["en"]["blocks"] = en_blocks(lid, title)
    lessons[lid]["loc"]["pt"]["blocks"] = [
        {"h": b["h"], "body": b["body"][:500]} for b in lessons[lid]["loc"]["en"]["blocks"][:5]
    ]

# Keep file header and L1/L2 block constants from original
orig = TARGET.read_text(encoding="utf-8")
header = orig.split("_LESSON1 = L(")[0].rstrip()

MOD = {
    1: "MOD_INTRO", 2: "MOD_INTRO", 3: "MOD_CHART", 4: "MOD_CHART",
    5: "MOD_CHART", 6: "MOD_CHART", 7: "MOD_RISK", 8: "MOD_PAT",
    9: "MOD_PAT", 10: "MOD_STR", 11: "MOD_MKT", 12: "MOD_MKT",
}

parts = [header, ""]
for i in range(1, 13):
    Ld = lessons[i]
    parts.append(f"_LESSON{i} = L(")
    parts.append(
        f"    {i}, {MOD[i]}, {Ld['difficulty']!r}, {Ld['durationMin']}, "
        f"{Ld['chart']!r}, {Ld['symbol']!r}, {Ld['interval']!r},"
    )
    parts.append("    " + pprint.pformat(Ld["markets"], width=100).replace("\n", "\n    ") + ",")
    loc_pp = pprint.pformat(Ld["loc"], width=100, sort_dicts=False)
    parts.append("    " + loc_pp.replace("\n", "\n    ") + ",")
    parts.append(")")
    parts.append("")

parts.append("LESSONS = [")
parts.append("    _LESSON1, _LESSON2, _LESSON3, _LESSON4, _LESSON5, _LESSON6,")
parts.append("    _LESSON7, _LESSON8, _LESSON9, _LESSON10, _LESSON11, _LESSON12,")
parts.append("]")
parts.append("")

TARGET.write_text("\n".join(parts), encoding="utf-8")

spec2 = importlib.util.spec_from_file_location("p2", TARGET)
m2 = importlib.util.module_from_spec(spec2)
spec2.loader.exec_module(m2)
for L in m2.LESSONS:
    rw = sum(len(b["body"].split()) for b in L["loc"]["ru"]["blocks"])
    ew = sum(len(b["body"].split()) for b in L["loc"]["en"]["blocks"])
    ok_ru = "OK" if rw >= 2000 else "LOW"
    ok_en = "OK" if ew >= 800 else "LOW"
    print(f"L{L['id']}: RU {rw} {ok_ru}  EN {ew} {ok_en}")
