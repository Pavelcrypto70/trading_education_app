#!/usr/bin/env python3
"""Patch lesson 2 from Part 2 video + approved extras (maker/taker, funding, terminals, risk %)."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"

TAKE_URL = "https://taketerminal.com/sign-up?referralCode=K6ubEN45OrWRXwhO"
TIGER_URL = "https://tigertrade.ru/"
VATAGA_URL = "https://vataga.trading/"
BINANCE_URL = "https://accounts.binance.com/register?ref=YLTUS35Y"

SECTIONS_RU = [
    {"type": "heading", "title": "Часть 2: биржа, терминал, графики, депозит"},
    {
        "type": "text",
        "body": (
            "Продолжаем вводный блок. В части 1 мы разобрали, что такое трейдинг, спот и фьючерс, "
            "зачем нужен терминал, как безопасно завести USDT и зарегистрироваться на бирже. "
            "Сейчас — практическая база перед первой сделкой: где лежат деньги на Binance, как купить и продать на споте, "
            "как устроен Take Terminal, чем отличаются скальпинг и свинг, что такое свечи и тики, "
            "сколько закладывать на первый депозит и какой размер одного рабочего ордера.\n\n"
            "В этом уроке:\n"
            "• Три кошелька Binance и перевод на спот\n"
            "• Лимитный и рыночный ордер, maker/taker\n"
            "• Funding на фьючерсах (обзор)\n"
            "• Take Terminal, Tiger.Trade, Vataga\n"
            "• Виды торговли и свечи vs тики\n"
            "• Риск 0,5–1% и калькулятор рабочего ордера (3–5% депозита)"
        ),
    },
    {
        "type": "journal",
        "title": "Перед уроком",
        "body": "Зафиксируй отправную точку:",
        "items": [
            "Уже заходил на Binance Spot вручную?",
            "Есть ли подключённый терминал (Take / Tiger / Vataga)?",
            "Какой депозит планируешь на обучение (USDT)?",
        ],
    },
    {"type": "heading", "title": "Кошельки Binance: пополнение, фьючи, спот"},
    {
        "type": "text",
        "body": (
            "Справа вверху на Binance — иконка профиля → «Активы». Там виден общий баланс и три основных кошелька.\n\n"
            "Кошелёк пополнения (Funding) — сюда попадают USDT с P2P или перевод с другой биржи. "
            "Частая ошибка новичка: купил на P2P, открыл терминал — денег «нет». Они в пополнении, не на споте.\n\n"
            "Кошелёк фьючерсов (Futures) — монеты и маржа для USDT-M фьючерсов.\n\n"
            "Спотовый кошелёк (Spot) — то, чем вы торгуете на споте и что видит терминал для спотовых пар.\n\n"
            "Если USDT в пополнении: «Перевод» → из Funding в Spot → монета USDT → «Все» → подтвердить. "
            "После этого баланс появится в терминале."
        ),
    },
    {
        "type": "chart",
        "title": "Путь USDT: P2P → Funding → Spot",
        "chartType": "order_flow",
        "caption": "Пока USDT в Funding, спотовый терминал их не покажет — нужен перевод на Spot.",
    },
    {
        "type": "practice",
        "title": "Практика: найти три кошелька",
        "body": "Без сделок: открой Активы и найди Funding, Futures, Spot. Если есть USDT в Funding — сделай тестовый перевод 1 USDT на Spot.",
        "items": [
            "Активы → обзор: вижу все три кошелька",
            "Перевод Funding → Spot выполнен (или понял, где кнопка)",
            "Записал: где смотреть баланс перед торговлей",
        ],
    },
    {"type": "heading", "title": "Спот на бирже: лимит и рынок"},
    {
        "type": "text",
        "body": (
            "Торговля → Спот — встроенный терминал биржи. Слева пары, по центру график и стакан, снизу блок ордера.\n\n"
            "Лимитный ордер — «куплю по цене не дороже X» или «продам не дешевле X». Заявка встаёт в стакан и ждёт контрагента. "
            "Удобно, когда хотите купить чуть ниже рынка.\n\n"
            "Рыночный ордер (Market) — «купи/продай сейчас по лучшей доступной цене». Исполнение мгновенное, "
            "но цена может проскользнуть на несколько уровней стакана. Новичок часто жмёт market из страха опоздать — "
            "платит спред и комиссию taker.\n\n"
            "Стоп-лимит на старте не обязателен — достаточно лимита и рынка. "
            "При высокой волатильности Binance показывает предупреждение о рисках — это нормально, вы принимаете осознанный риск актива."
        ),
    },
    {
        "type": "chart",
        "title": "Лимит ждёт в стакане — рынок забирает сразу",
        "chartType": "market_balance",
        "caption": "Лимит = терпение и часто комиссия maker. Рынок = скорость и комиссия taker.",
    },
    {
        "type": "text",
        "body": (
            "Maker и taker — кто вы в сделке по отношению к стакану.\n\n"
            "Maker (создатель ликвидности) — выставили лимитную заявку, её кто-то исполнил. На Binance комиссия maker ниже.\n\n"
            "Taker (забирающий ликвидность) — забрали чужую заявку рыночным ордером или лимитом по текущей цене. "
            "Комиссия taker выше. Скальпер с десятками сделок в день, если везде taker, отдаёт 1–2% депозита в неделю только на комиссиях.\n\n"
            "Скидка на комиссии при оплате BNB включается в настройках после того, как поняли базовые ставки. "
            "В журнале полезно колонку maker/taker — через месяц видно, сколько «края» уходит в fee."
        ),
    },
    {"type": "tip", "title": "Совет", "body": "Перед первой неделей сделок откройте справку Binance по комиссиям spot и сравните maker/taker для вашего VIP-уровня."},
    {"type": "heading", "title": "Открытые ордера, отмена и проверка баланса"},
    {
        "type": "text",
        "body": (
            "Демо из видео: купили монету по рынку → выставили лимит на продажу выше → ордер появился в «Открытых». "
            "«Отменить» — это снять лимит, а не продать монету. Чтобы продать сразу: Спот → Рынок → 100% → Продать.\n\n"
            "История ордеров показывает исполненные сделки: средняя цена, объём, сторона (купить/продать). "
            "Если терминал не грузится — на бирже в Споте видно открытые ордера и позицию.\n\n"
            "Финальная проверка: Кошелёк → Спот — монета продана, на балансе USDT, купленной монеты нет."
        ),
    },
    {
        "type": "practice",
        "title": "Мини-практика: лимит vs рынок",
        "body": "На минимальной сумме или в демо-режиме мысленно пройдите цепочку: market buy → limit sell → cancel → market sell.",
        "items": [
            "Понимаю разницу: отмена лимита ≠ продажа",
            "Знаю, где «Открытые ордера» на Binance Spot",
            "Знаю, где «История ордеров»",
        ],
    },
    {"type": "heading", "title": "Безопасность: 2FA, API, PNL"},
    {
        "type": "text",
        "body": (
            "Профиль → Настройки → Безопасность аккаунта.\n\n"
            "Google Authenticator (2FA) — обязателен перед API-ключами для терминала. Без 2FA ключи не создать.\n\n"
            "Почта и телефон должны быть привязаны. Биометрию на этом этапе можно не включать — лишняя поверхность, если не требуют.\n\n"
            "Управление API — здесь создаются ключи для Take / Tiger / Vataga. "
            "Отдельное короткое видео в курсе разберёт галочки: торговля spot/futures — да, вывод — нет, IP whitelist по желанию.\n\n"
            "PNL за сегодня — на главном экране активов; можно выбрать период и увидеть прибыль/убыток в USDT и эквивалент в фиате."
        ),
    },
    {"type": "heading", "title": "Funding rate на фьючерсах"},
    {
        "type": "text",
        "body": (
            "На бессрочных фьючерсах (perpetual) цена контракта держится рядом со спотом через funding — "
            "периодический платёж между лонгами и шортами (на Binance обычно каждые 8 часов).\n\n"
            "Если funding положительный — лонги платят шортам; отрицательный — наоборот. На одну сделку внутри дня это мелочь, "
            "но на недельном шорте в сильном апренде funding может съесть часть прибыли.\n\n"
            "Для новичка на споте funding не актуален. Запомните: переходите на фьючерсы — смотрите строку funding в терминале перед удержанием позиции через ночь."
        ),
    },
    {
        "type": "chart",
        "title": "Funding — «аренда» направления позиции",
        "chartType": "session_timeline",
        "caption": "Каждые ~8 часов одна сторона рынка платит другой — цена фьючерса тянется к споту.",
    },
    {"type": "heading", "title": "Take Terminal — основной терминал курса"},
    {
        "type": "text",
        "body": (
            "На курсе основная торговля ведётся в Take Terminal — веб-терминал с тиковым и свечным графиком, "
            "быстрыми кнопками суммы ордера, стаканом без лишнего шума, автотейком/стопом, детектами и обзором рынка.\n\n"
            "Почему не только биржа: на Binance 80–90% интерфейса — не про активную торговлю (Earn, Web3, P2P). "
            "В терминале оставили то, что нужно скальперу и внутридневному трейдеру: сумма → клик по стакану → ордер открыт.\n\n"
            "Сверху: тикер, переключатель тик/свечи, таймфреймы, кнопки размера ордера (200 / 500 USDT и т.д.), рисование уровней. "
            "Стакан показывает «стенки» плотности — наведение даёт объём до стены. "
            "Снизу: открытые сделки, баланс, отчёты за период, обзор рынка по дельте, уведомления о листинге/делисте.\n\n"
            "Двойной клик по красной стороне стакана — рыночная покупка; настройки позволяют биндить хоткеи, дробить ордер на 3–5 частей, автопокупку BNB для скидки комиссии."
        ),
    },
    {
        "type": "chart",
        "title": "Быстрый вход: сумма + стакан",
        "chartType": "order_flow",
        "caption": "Меньше кликов, чем на сайте биржи — критично для скальпинга.",
    },
    {
        "type": "link",
        "title": "Take Terminal — регистрация",
        "body": "Официальная ссылка из описания урока. После регистрации подключите API Binance (торговля — да, вывод — нет).",
        "url": TAKE_URL,
    },
    {"type": "heading", "title": "Tiger.Trade и Vataga — альтернативы"},
    {
        "type": "text",
        "body": (
            "Tiger.Trade и Vataga — популярные терминалы в СНГ для скальпинга на Binance/Bybit через API. "
            "Дают горячие клавиши, кластерный объём, быстрый стакан, несколько мониторов.\n\n"
            "Когда они нужны: вы уже понимаете лимит/маркет на бирже, ведёте журнал и выбрали скальпинг или активный внутри день. "
            "Первые недели достаточно интерфейса Binance Spot + Take Terminal.\n\n"
            "API для любого терминала: только права на торговлю, без вывода, по возможности IP whitelist. "
            "Никому не передавайте ключ с правом withdrawal."
        ),
    },
    {
        "type": "link",
        "title": "Tiger.Trade",
        "body": "Скачать терминал и ознакомиться с функциями стакана и хоткеев.",
        "url": TIGER_URL,
    },
    {
        "type": "link",
        "title": "Vataga",
        "body": "Альтернативный терминал с похожим назначением — для сравнения после освоения базы.",
        "url": VATAGA_URL,
    },
    {"type": "heading", "title": "Виды торговли"},
    {
        "type": "text",
        "body": (
            "Скальпинг — сделки на секунды–минуты, чаще на тиковом графике; много сделок, важна комиссия и скорость терминала.\n\n"
            "Внутридневная (интрадей) — позиция 5–30 минут и дольше в тот же день, обычно на свечах 1m–15m; забираете более крупное движение.\n\n"
            "Средний срок — от суток до месяца: осознанный холд под тренд или разворот.\n\n"
            "Долгосрок / портфель — от месяца и выше: накопление актива как «цифровое золото» или торговля редкими крупными движениями.\n\n"
            "На сайте курса сначала разбираем скальпинг и внутри день; средний срок и портфели — позже. "
            "Скальпить можно и на свечах, торговать пробои и треугольники — это уже темы стратегий, не «видов»."
        ),
    },
    {
        "type": "chart",
        "title": "Горизонт сделки",
        "chartType": "session_timeline",
        "caption": "Скальп — секунды/минуты. Свинг внутри дня — десятки минут. Портфель — недели и месяцы.",
    },
    {"type": "heading", "title": "Свечной график: таймфрейм, тело, фитиль"},
    {
        "type": "text",
        "body": (
            "Свеча — сжатое движение цены за интервал (таймфрейм): 1m, 5m, 1h, 4h, 1D.\n\n"
            "Зелёная свеча — закрытие выше открытия (рост за период). Красная — закрытие ниже открытия.\n\n"
            "Корпус — между открытием и закрытием. Фитили (тени) — максимум и минимум внутри периода, куда цена ходила, но закрылась выше/ниже.\n\n"
            "Пока свеча не закрылась — итог неизвестен: на 1h через 10 минут до закрытия свеча может сменить цвет.\n\n"
            "Свечной график удобен для анализа за дни и недели на одном экране — видно уровни разворота и структуру тренда."
        ),
    },
    {
        "type": "chart",
        "title": "Свеча: открытие, закрытие, фитили",
        "chartType": "uptrend",
        "caption": "Таймфрейм = сколько времени «упаковано» в одну свечу.",
    },
    {"type": "heading", "title": "Тиковый график vs свечной"},
    {
        "type": "text",
        "body": (
            "Тиковый график рисует каждое заметное движение цены — видно отскоки внутри одной свечи. "
            "На мелком ТФ свечи сглаживают эти колебания: свеча «росла», но внутри были просадки, которые тик-трейдер использует.\n\n"
            "Тики — больше сделок, меньший целевой процент на сделку, выше требования к терминалу и комиссии. "
            "Свечи — меньше сделок, более крупные цели, проще для старта.\n\n"
            "Попробуйте оба формата в Take Terminal и запишите в журнал, на чём вам спокойнее: тики, 1m или 5m."
        ),
    },
    {
        "type": "chart",
        "title": "Внутри одной свечи — десятки тиковых движений",
        "chartType": "order_flow",
        "caption": "Скальпер на тиках видит то, что на свече 5m «спрятано» внутри.",
    },
    {"type": "heading", "title": "Риск 0,5–1% на сделку"},
    {
        "type": "text",
        "body": (
            "Перед кликом фиксируйте три числа: вход, стоп, цель. Риск на сделку — сколько USDT вы готовы потерять, "
            "если сработает стоп, в процентах от депозита. Золотое правило курса: 0,5–1% на одну сделку.\n\n"
            "Размер позиции считается от стопа, а не «на глаз»: чем дальше стоп в процентах от входа, тем меньше монет на тот же риск в USDT.\n\n"
            "Пример: депозит 1000 USDT, риск 1% = 10 USDT. Стоп 2% от входа → позиция ≈ 500 USDT номинала. "
            "Десять стопов подряд при 1% — минус ~10% депозита, а не слив всего счёта.\n\n"
            "Одна сделка ничего не доказывает — смотрите серию из 30–50 записей в журнале."
        ),
    },
    {
        "type": "chart",
        "title": "Риск → размер позиции",
        "chartType": "risk_reward",
        "caption": "Сначала стоп и % риска, потом объём. Не наоборот.",
    },
    {
        "type": "practice",
        "title": "Практика: три числа до клика",
        "body": "Выберите пару на графике без входа. Запишите вход, стоп, цель и риск в % депозита.",
        "items": [
            "Вход (цена)",
            "Стоп (цена)",
            "Цель (цена)",
            "Риск в % депозита (0,5–1%)",
        ],
    },
    {"type": "heading", "title": "Первый депозит и рабочий ордер"},
    {
        "type": "text",
        "body": (
            "Оптимальный первый депозит для обучения — 500–1000 USDT. Не последние деньги и не кредит. "
            "Меньше 50–100 USDT — сложно почувствовать психологию реальной сделки и перекрыть расходники (подписка терминала, интернет).\n\n"
            "Больше 1000 USDT на старте не нужно — сначала механика: кошельки, ордера, терминал, журнал, базовая стратегия.\n\n"
            "Рабочий ордер — размер одной типовой сделки. В курсе закладываем 3–5% депозита на один ордер "
            "(калькулятор ниже). При сомнении можно зайти половиной рабочего. "
            "При сильном сетапе и наборе позиции возможно 2–3 ордера, но суммарная экспозиция должна оставаться в рамках плана риска.\n\n"
            "В видео также упоминается диапазон 10–15% для активной фазы обучения на споте — "
            "используйте его только когда стабильно ведёте журнал и понимаете последствия серии стопов. "
            "На старте держите 3–5% и риск 0,5–1% на сделку."
        ),
    },
    {
        "type": "calculator",
        "title": "Калькулятор рабочего ордера",
        "chartType": "deposit_order",
        "body": "Введите сумму депозита в USDT — покажем размер одного рабочего ордера. Доля одного ордера: 3–5% от депозита (подвиньте ползунок).",
        "items": ["3", "5"],
    },
    {
        "type": "link",
        "title": "Binance — регистрация",
        "body": "Если аккаунта ещё нет — пройдите KYC и 2FA из урока 1, затем вернитесь к этому уроку.",
        "url": BINANCE_URL,
    },
    {
        "type": "example",
        "title": "Разбор: лимит на бирже vs клик в Take",
        "body": "На бирже: Спот → выбор пары → Лимит/Рынок → сумма → Купить. В Take: кнопка суммы → двойной клик по стакану. Оба способа исполняют один план — разница в скорости и комиссии maker/taker.",
    },
    {
        "type": "bullets",
        "title": "Запомнить",
        "items": [
            "Funding → Spot перед торговлей на споте",
            "Лимит ≈ maker, рынок ≈ taker",
            "2FA до API; вывод через API — нет",
            "Take / Tiger / Vataga — после базы биржи",
            "Свечи — обзор; тики — микродвижения",
            "Риск 0,5–1%; рабочий ордер 3–5% депозита",
        ],
    },
    {
        "type": "journal",
        "title": "Итог урока",
        "body": "Запишите в журнал:",
        "items": [
            "Где у вас лежат USDT сейчас (Funding / Spot)?",
            "Какой терминал поставите первым?",
            "Депозит и рабочий ордер по калькулятору",
            "Свечи или тики — что попробуете первым?",
        ],
    },
    {
        "type": "tip",
        "title": "Совет",
        "body": "Не торгуйте в первый день после регистрации. Сделайте перевод Funding→Spot, пройдитесь по меню Spot, подключите 2FA, откройте Take — без клика по рынку.",
    },
]

# EN / PT — condensed faithful translations
SECTIONS_EN = [
    {"type": "heading", "title": "Part 2: exchange, terminal, charts, deposit"},
    {
        "type": "text",
        "body": (
            "We continue the intro track. After Part 1 you know what trading is, spot vs futures, terminals, P2P and registration. "
            "Now: Binance wallets, spot limit/market orders, maker/taker, funding overview, Take Terminal plus Tiger/Vataga, "
            "scalping vs intraday, candles vs ticks, first deposit and working order size (3–5% of deposit).\n\n"
            "In this lesson:\n"
            "• Funding, Futures, Spot wallets\n"
            "• Limit vs market, maker/taker\n"
            "• Funding on perpetual futures\n"
            "• Take, Tiger.Trade, Vataga links\n"
            "• Chart types and 0.5–1% risk\n"
            "• Deposit calculator"
        ),
    },
    {
        "type": "journal",
        "title": "Before you start",
        "body": "Note your baseline:",
        "items": [
            "Have you opened Binance Spot manually?",
            "Any terminal connected (Take / Tiger / Vataga)?",
            "Planned learning deposit (USDT)?",
        ],
    },
    {"type": "heading", "title": "Binance wallets"},
    {
        "type": "text",
        "body": (
            "Profile → Assets. Three main wallets: Funding (P2P deposits), Futures (USDT-M margin), Spot (spot trading). "
            "If the terminal shows zero after P2P — USDT is probably in Funding. Transfer Funding → Spot → USDT → All → confirm."
        ),
    },
    {"type": "chart", "title": "USDT path", "chartType": "order_flow", "caption": "Move USDT to Spot before spot trading."},
    {
        "type": "practice",
        "title": "Practice: find three wallets",
        "body": "Locate Funding, Futures, Spot. Optional: transfer 1 USDT to Spot.",
        "items": ["Found all three wallets", "Know Transfer button", "Know where balance shows before trading"],
    },
    {"type": "heading", "title": "Spot: limit and market"},
    {
        "type": "text",
        "body": (
            "Trade → Spot. Limit = wait at your price (often maker fee). Market = fill now at best price (taker fee). "
            "Beginners often overuse market and pay spread + taker. Skip stop-limit at first."
        ),
    },
    {"type": "chart", "title": "Limit vs market", "chartType": "market_balance", "caption": "Patience vs speed — and fee type."},
    {
        "type": "text",
        "body": (
            "Maker adds liquidity with a resting limit; taker removes liquidity with market/aggressive orders. "
            "Track maker/taker in your journal — fees add up on scalping."
        ),
    },
    {"type": "tip", "title": "Tip", "body": "Check Binance spot fee table for your VIP level before week one."},
    {"type": "heading", "title": "Open orders and history"},
    {
        "type": "text",
        "body": "Cancel removes a limit order — it does not sell. To sell now: Market → 100% → Sell. Order history shows filled trades.",
    },
    {
        "type": "practice",
        "title": "Mental drill",
        "body": "Walk through: market buy → limit sell → cancel → market sell.",
        "items": ["Cancel ≠ sell", "Open orders location", "Order history location"],
    },
    {"type": "heading", "title": "Security: 2FA, API, PNL"},
    {
        "type": "text",
        "body": "Enable Google 2FA before API keys. API: trading yes, withdrawal no. PNL shows daily P&L on Assets overview.",
    },
    {"type": "heading", "title": "Funding rate"},
    {
        "type": "text",
        "body": "On perpetual futures, funding (≈ every 8h on Binance) keeps futures near spot. Longs pay shorts or vice versa. Matters for multi-day holds.",
    },
    {"type": "chart", "title": "Funding timeline", "chartType": "session_timeline", "caption": "Periodic payment between longs and shorts."},
    {"type": "heading", "title": "Take Terminal"},
    {
        "type": "text",
        "body": "Course default terminal: ticks + candles, order size buttons, clean DOM, alerts, market scanner. Double-click DOM for market entry.",
    },
    {"type": "chart", "title": "Fast entry", "chartType": "order_flow", "caption": "Fewer clicks than exchange UI."},
    {"type": "link", "title": "Take Terminal signup", "body": "Official link from lesson. API: trade on, withdraw off.", "url": TAKE_URL},
    {"type": "heading", "title": "Tiger.Trade and Vataga"},
    {
        "type": "text",
        "body": "Popular CIS scalping terminals via API. Use after you understand exchange orders and journaling.",
    },
    {"type": "link", "title": "Tiger.Trade", "body": "Download and explore.", "url": TIGER_URL},
    {"type": "link", "title": "Vataga", "body": "Alternative terminal.", "url": VATAGA_URL},
    {"type": "heading", "title": "Trading styles"},
    {
        "type": "text",
        "body": "Scalping (seconds–minutes, ticks), intraday (minutes–hours, candles), swing (days–weeks), portfolio (months+). Course starts with scalping + intraday.",
    },
    {"type": "chart", "title": "Time horizon", "chartType": "session_timeline", "caption": "Match style to chart type."},
    {"type": "heading", "title": "Candle basics"},
    {
        "type": "text",
        "body": "Timeframe packs price action into one candle. Body = open→close; wicks = high/low. Unclosed candle can still change color.",
    },
    {"type": "chart", "title": "Candle anatomy", "chartType": "uptrend", "caption": "Timeframe = candle duration."},
    {"type": "heading", "title": "Ticks vs candles"},
    {
        "type": "text",
        "body": "Ticks show micro-moves inside a candle. More trades, smaller targets, higher fee sensitivity. Try both in Take Terminal.",
    },
    {"type": "chart", "title": "Inside one candle", "chartType": "order_flow", "caption": "Ticks reveal hidden swings."},
    {"type": "heading", "title": "Risk 0.5–1% per trade"},
    {
        "type": "text",
        "body": "Define entry, stop, target before click. Risk 0.5–1% of deposit per trade. Position size from stop distance, not gut feeling.",
    },
    {"type": "chart", "title": "Risk sizing", "chartType": "risk_reward", "caption": "Stop first, then size."},
    {
        "type": "practice",
        "title": "Three numbers",
        "body": "Paper plan only: entry, stop, target, risk %.",
        "items": ["Entry", "Stop", "Target", "Risk % (0.5–1)"],
    },
    {"type": "heading", "title": "First deposit & working order"},
    {
        "type": "text",
        "body": "Learning deposit: $500–1000 USDT. Working order: 3–5% of deposit (calculator below). Risk 0.5–1% per trade. Video also mentions 10–15% for later active phase — only after stable journaling.",
    },
    {
        "type": "calculator",
        "title": "Working order calculator",
        "chartType": "deposit_order",
        "body": "Enter deposit in USDT. Slider 3–5% shows one working order size.",
        "items": ["3", "5"],
    },
    {"type": "link", "title": "Binance signup", "body": "Complete KYC + 2FA from Lesson 1 first.", "url": BINANCE_URL},
    {
        "type": "example",
        "title": "Exchange limit vs Take click",
        "body": "Same plan, different UI speed. Watch maker/taker on both paths.",
    },
    {
        "type": "bullets",
        "title": "Remember",
        "items": [
            "Funding → Spot before spot trade",
            "Limit ≈ maker, market ≈ taker",
            "2FA before API; no withdraw permission",
            "Terminals after exchange basics",
            "Candles = overview; ticks = micro",
            "Risk 0.5–1%; order 3–5% deposit",
        ],
    },
    {
        "type": "journal",
        "title": "Lesson wrap-up",
        "body": "Journal:",
        "items": ["Where are your USDT?", "First terminal?", "Deposit & order from calculator", "Candles or ticks first?"],
    },
    {"type": "tip", "title": "Tip", "body": "Day one: transfers and menus only — no market clicks."},
]

SECTIONS_PT = [
    {"type": "heading", "title": "Parte 2: exchange, terminal, gráficos, depósito"},
    {
        "type": "text",
        "body": (
            "Continuamos a introdução. Depois da Parte 1 você sabe o básico de trading, spot, futuros, P2P e registro. "
            "Agora: carteiras Binance, ordens limite/mercado, maker/taker, funding, Take Terminal, Tiger/Vataga, "
            "tipos de operação, velas vs ticks, depósito inicial e ordem de trabalho (3–5% do depósito)."
        ),
    },
    {
        "type": "journal",
        "title": "Antes de começar",
        "body": "Anote:",
        "items": ["Já abriu Spot na Binance?", "Terminal conectado?", "Depósito planejado (USDT)?"],
    },
    {"type": "heading", "title": "Carteiras Binance"},
    {
        "type": "text",
        "body": "Funding (P2P), Futures, Spot. Após P2P, transfira Funding → Spot para ver saldo no terminal spot.",
    },
    {"type": "chart", "title": "Caminho do USDT", "chartType": "order_flow", "caption": "USDT no Spot antes de operar."},
    {
        "type": "practice",
        "title": "Prática: três carteiras",
        "body": "Localize Funding, Futures, Spot.",
        "items": ["Achei as três carteiras", "Sei transferir", "Sei onde ver saldo"],
    },
    {"type": "heading", "title": "Spot: limite e mercado"},
    {
        "type": "text",
        "body": "Limite = preço fixo (maker). Mercado = execução imediata (taker). Iniciante não deve abusar de mercado.",
    },
    {"type": "chart", "title": "Limite vs mercado", "chartType": "market_balance", "caption": "Paciência vs velocidade."},
    {
        "type": "text",
        "body": "Maker adiciona liquidez; taker remove. Anote maker/taker no diário — taxas somam no scalping.",
    },
    {"type": "tip", "title": "Dica", "body": "Veja tabela de taxas spot na Binance."},
    {"type": "heading", "title": "Ordens abertas"},
    {"type": "text", "body": "Cancelar limite não vende. Para vender agora: Mercado → 100% → Vender."},
    {"type": "heading", "title": "Segurança e funding"},
    {"type": "text", "body": "2FA antes de API. API: trade sim, saque não. Funding a cada ~8h nos futuros perpétuos."},
    {"type": "chart", "title": "Funding", "chartType": "session_timeline", "caption": "Pagamento entre longs e shorts."},
    {"type": "heading", "title": "Take Terminal"},
    {"type": "text", "body": "Terminal principal do curso: ticks, velas, DOM, atalhos."},
    {"type": "link", "title": "Take Terminal", "body": "Cadastro oficial.", "url": TAKE_URL},
    {"type": "heading", "title": "Tiger e Vataga"},
    {"type": "text", "body": "Terminais alternativos para scalping via API — depois da base na exchange."},
    {"type": "link", "title": "Tiger.Trade", "url": TIGER_URL},
    {"type": "link", "title": "Vataga", "url": VATAGA_URL},
    {"type": "heading", "title": "Estilos e gráficos"},
    {
        "type": "text",
        "body": "Scalping (ticks), intraday (velas), swing, portfólio. Velas = visão ampla; ticks = micro-movimentos.",
    },
    {"type": "chart", "title": "Velas", "chartType": "uptrend", "caption": "Timeframe = duração da vela."},
    {"type": "heading", "title": "Risco 0,5–1%"},
    {"type": "text", "body": "Entrada, stop, alvo antes do clique. Risco 0,5–1% do depósito por trade."},
    {"type": "chart", "title": "Risco", "chartType": "risk_reward", "caption": "Stop primeiro."},
    {"type": "heading", "title": "Depósito e ordem"},
    {"type": "text", "body": "Depósito de aprendizado: 500–1000 USDT. Ordem de trabalho: 3–5% (calculadora)."},
    {
        "type": "calculator",
        "title": "Calculadora de ordem",
        "chartType": "deposit_order",
        "body": "Digite o depósito. Slider 3–5%.",
        "items": ["3", "5"],
    },
    {"type": "link", "title": "Binance", "url": BINANCE_URL},
    {
        "type": "bullets",
        "title": "Lembrar",
        "items": ["Funding → Spot", "Limite maker / mercado taker", "2FA antes de API", "Risco 0,5–1%"],
    },
    {"type": "journal", "title": "Resumo", "body": "Diário:", "items": ["Onde está o USDT?", "Terminal escolhido", "Depósito e ordem"]},
    {"type": "tip", "title": "Dica", "body": "Primeiro dia sem cliques de mercado."},
]

META = {
    "ru": {
        "id": 2,
        "module": "Введение",
        "title": "Вводное. С чего начать в трейдинге? Часть 2",
        "subtitle": "Биржа, ордера, терминалы, графики, депозит и риск",
        "difficulty": "Beginner",
        "durationMin": 42,
        "outcome": "Поймёте кошельки Binance, лимит/маркет, maker/taker, funding, терминалы Take/Tiger/Vataga, свечи vs тики, риск 0,5–1% и размер рабочего ордера.",
        "content": "Биржа понимает только ордера — научитесь переводить USDT на спот, торговать лимитом и рынком и готовить терминал.",
        "takeaway": "Funding→Spot; лимит=maker, рынок=taker; 2FA до API; терминал после базы; риск 0,5–1%; рабочий ордер 3–5% депозита.",
        "prerequisites": [1],
        "learningOutcomes": [
            "Перевести USDT из Funding на Spot и найти открытые ордера",
            "Объяснить разницу лимита, рынка, maker и taker",
            "Рассчитать рабочий ордер 3–5% от депозита и риск 0,5–1% на сделку",
        ],
        "references": [
            {"title": "Binance Spot Trading Rules", "author": "Binance", "year": 2025, "url": "https://www.binance.com/en/support/faq", "type": "documentation"},
        ],
    },
    "en": {
        "id": 2,
        "module": "Introduction",
        "title": "Getting Started with Trading — Part 2",
        "subtitle": "Exchange, orders, terminals, charts, deposit and risk",
        "difficulty": "Beginner",
        "durationMin": 42,
        "outcome": "Understand Binance wallets, limit/market, maker/taker, funding, Take/Tiger/Vataga, candles vs ticks, 0.5–1% risk and working order size.",
        "content": "The exchange only sees orders — learn Funding→Spot, limit vs market, and terminal setup.",
        "takeaway": "Funding→Spot; limit=maker, market=taker; 2FA before API; terminals after basics; 0.5–1% risk; working order 3–5% of deposit.",
        "prerequisites": [1],
        "learningOutcomes": [
            "Transfer USDT Funding→Spot and find open orders",
            "Explain limit, market, maker and taker",
            "Calculate working order 3–5% and risk 0.5–1% per trade",
        ],
        "references": [
            {"title": "Binance Spot Trading Rules", "author": "Binance", "year": 2025, "url": "https://www.binance.com/en/support/faq", "type": "documentation"},
        ],
    },
    "pt": {
        "id": 2,
        "module": "Introdução",
        "title": "Intro: Por onde começar no trading? Parte 2",
        "subtitle": "Exchange, ordens, terminais, gráficos, depósito e risco",
        "difficulty": "Beginner",
        "durationMin": 42,
        "outcome": "Entenda carteiras Binance, limite/mercado, maker/taker, funding, terminais, velas vs ticks e risco 0,5–1%.",
        "content": "A exchange só entende ordens — Funding→Spot, limite vs mercado e terminal.",
        "takeaway": "Funding→Spot; limite=maker; 2FA antes de API; risco 0,5–1%; ordem 3–5% do depósito.",
        "prerequisites": [1],
        "learningOutcomes": [
            "Transferir USDT Funding→Spot",
            "Explicar limite, mercado, maker e taker",
            "Calcular ordem 3–5% e risco 0,5–1%",
        ],
        "references": [
            {"title": "Binance Spot Trading Rules", "author": "Binance", "year": 2025, "url": "https://www.binance.com/en/support/faq", "type": "documentation"},
        ],
    },
}

SECTIONS_BY_LOCALE = {"ru": SECTIONS_RU, "en": SECTIONS_EN, "pt": SECTIONS_PT}
_NO_TV = frozenset({"tradingview"})


def _sections(locale: str) -> list:
    return [s for s in SECTIONS_BY_LOCALE[locale] if s.get("type") not in _NO_TV]


def patch_lessons(locale: str) -> None:
    path = DATA / f"lessons_{locale}.json"
    lessons = json.loads(path.read_text(encoding="utf-8"))
    meta = META[locale].copy()
    meta["sections"] = _sections(locale)
    for i, lesson in enumerate(lessons):
        if lesson.get("id") == 2:
            lessons[i] = meta
            path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            print(f"Patched {path}")
            return
    raise SystemExit(f"Lesson 2 not found in {path}")


def patch_quizzes() -> None:
    path = DATA / "lesson_quizzes.json"
    quizzes = json.loads(path.read_text(encoding="utf-8"))
    tw_ru = META["ru"]["takeaway"]
    tw_en = META["en"]["takeaway"]
    tw_pt = META["pt"]["takeaway"]
    for q in quizzes:
        if q.get("lessonId") != 2:
            continue
        if q["id"] == "L2-Q1":
            q["options"]["ru"][2] = tw_ru
            q["options"]["en"][3] = tw_en
            q["options"]["pt"][0] = tw_pt
            q["explanation"] = {"ru": tw_ru, "en": tw_en, "pt": tw_pt}
        elif q["id"] == "L2-Q2":
            q["options"]["ru"][1] = META["ru"]["outcome"]
            q["options"]["en"][2] = META["en"]["outcome"]
            q["options"]["pt"][0] = META["pt"]["outcome"]
            q["explanation"] = {"ru": tw_ru, "en": tw_en, "pt": tw_pt}
        elif q["id"] == "L2-Q3":
            q["question"] = {
                "ru": "Лимитный ордер на бирже чаще даёт комиссию…",
                "en": "A limit order on the exchange usually earns…",
                "pt": "Ordem limite na exchange geralmente paga taxa…",
            }
            q["options"] = {
                "ru": ["maker (ниже)", "taker (выше)", "funding", "PNL"],
                "en": ["maker (lower)", "taker (higher)", "funding", "PNL"],
                "pt": ["maker (menor)", "taker (maior)", "funding", "PNL"],
            }
            q["correctIndex"] = 0
            q["explanation"] = {
                "ru": "Лимит, который ждёт в стакане, создаёт ликвидность — комиссия maker ниже, чем taker у рынка.",
                "en": "A resting limit adds liquidity — maker fee is lower than market taker.",
                "pt": "Limite no book = maker, taxa menor que mercado taker.",
            }
    path.write_text(json.dumps(quizzes, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Patched {path}")


if __name__ == "__main__":
    for loc in ("ru", "en", "pt"):
        patch_lessons(loc)
    patch_quizzes()
