#!/usr/bin/env python3
"""Patch lesson 1 in lessons_ru.json, lessons_en.json, lessons_pt.json."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"

SECTIONS_RU = [
    {"type": "heading", "title": "Зачем сначала теория"},
    {
        "type": "text",
        "body": "Всем привет. Меня зовут Павел Тетерин, вы на канале «Академия трейдинга» — личный блог про торговлю, развитие продукта и сообщества. Прежде чем смотреть посты и советы по рынку, важно понять базу: что такое трейдинг, какие бывают рынки, терминалы и как безопасно завести деньги на биржу. Без этого в чате кажется, что «купи тут, продай там — и миллиарды», но непонятно, куда нажимать и что вообще происходит. Этот урок — пять вводных тем из первой части видео. Налейте кофе и пройдите спокойно — дальше будет часть 2.\n\nВ этом уроке:\n• Что такое трейдинг и кто такой трейдер\n• Спотовый и фьючерсный рынок — в чём разница\n• Зачем нужны торговые терминалы\n• Как безопасно купить USDT (P2P и обменники)\n• Регистрация на бирже: KYC, 2FA, API для терминала",
    },
    {
        "type": "journal",
        "title": "Стартовая запись",
        "body": "Перед уроком зафиксируй отправную точку:",
        "items": [
            "Что ты уже слышал о трейдинге?",
            "Что кажется самым непонятным?",
            "Какой у тебя регион (РФ, Бразилия, Мексика, LATAM)?",
        ],
    },
    {"type": "heading", "title": "Что такое трейдинг"},
    {
        "type": "text",
        "body": "Трейдинг — это деятельность, при которой мы совершаем покупки и продажи бумаг, валюты или другого имущества по определённым ценам. Задача всей этой деятельности — активная торговля с целью выгоды. Из трейдинга вытекает слово «трейдер» — человек, который по собственной инициативе пытается купить дешевле и продать дороже. На фьючерсном рынке можно действовать и в обратную сторону — заработать на падении. Если совсем просто: трейдинг — это работа на разнице цен, а трейдер — тот, кто этим занимается осознанно.",
    },
    {
        "type": "chart",
        "title": "Покупатель и продавец на рынке",
        "chartType": "market_balance",
        "caption": "Трейдинг — постоянный поиск выгодной цены покупки и продажи.",
    },
    {
        "type": "heading",
        "title": "Спотовый рынок"},
    {
        "type": "text",
        "body": "Спотовый рынок — классический рынок, с которого все начинали. При покупке любого актива на споте актив попадает вам в руки: купили валюту — она ваша, храните сколько хотите, никто не заберёт. Как с iPhone: купил — он твой, пока сам не продашь. Чтобы заработать на споте, нужно дешевле купить и дороже продать. Пример: купил доллар по 100, продал по 110 — с одного доллара прибыль 10 рублей. Торговли на падение (шорт) на чистом споте нет — только классика «купил дешевле, продал дороже».",
    },
    {
        "type": "chart",
        "title": "Спот: купил — актив твой",
        "chartType": "uptrend",
        "caption": "На споте монета остаётся на балансе, даже если цена временно падает.",
    },
    {
        "type": "tradingview",
        "title": "Посмотри график BTC",
        "body": "Открой BINANCE:BTCUSDT на дневном таймфрейме. Найди последний минимум и максимум — это база для понимания движения цены без сделок.",
        "symbol": "BINANCE:BTCUSDT",
        "interval": "D",
        "url": "https://www.tradingview.com/chart/?symbol=BINANCE%3ABTCUSDT&interval=D",
    },
    {"type": "heading", "title": "Фьючерсный рынок"},
    {
        "type": "text",
        "body": "Фьючерсный рынок устроен иначе. На споте купил телефон — он у тебя. На фьючерсах при покупке актива у вас нет самого актива в руках — вы заключаете контракт с биржей. Вы говорите: «купи здесь, подрастёт — продадим» или «продай сейчас, упадёт — перезакупим дешевле». Актив хранит биржа, не вы. Можно торговать в лонг (на рост) и в шорт (на падение). Есть кредитные плечи — разберём подробно в отдельном видео. Главное отличие: на споте купил — хранишь сколько угодно; на фьючерсах контракт ограничен по времени и риску — позицию могут закрыть автоматически, если рынок пошёл против вас. Фьючерс — более рискованная торговля.",
    },
    {
        "type": "chart",
        "title": "Спот vs фьючерс",
        "chartType": "risk_reward",
        "caption": "Слева — владеешь активом. Справа — контракт с биржей, long и short, выше риск.",
    },
    {"type": "heading", "title": "Торговые терминалы"},
    {
        "type": "text",
        "body": "На биржах сегодня слишком много всего: Web3, стейкинг, airdrop, Earn — до 80–90% интерфейса не про торговлю напрямую. Торговые терминалы созданы именно для трейдеров: убрали лишнее, упростили управление, ускорили сделки. Например, в Take Terminal сверху есть кнопки с суммами — нажал 200 или 500 USDT, кликнул по стакану — ордер открыт. На бирже пришлось бы вручную вводить сумму, выбирать тип ордера, копаться в настройках. Терминал показывает стакан проще, добавляет детекты и индикаторы. Какой терминал выбрал автор — разберём во второй части. Сейчас запомни: терминал = быстрее торговать и анализировать.",
    },
    {
        "type": "chart",
        "title": "Стакан и быстрый вход",
        "chartType": "order_flow",
        "caption": "Терминал экономит клики: сумма, стакан, вход — в несколько действий.",
    },
    {
        "type": "practice",
        "title": "Мини-практика: терминал vs биржа",
        "body": "Без сделок — только наблюдение:",
        "items": [
            "Открой интерфейс спот-торговли на бирже",
            "Посчитай, сколько кликов до лимитного ордера на фиксированную сумму",
            "Запиши число в журнал — сравнишь с терминалом в части 2",
        ],
    },
    {"type": "heading", "title": "P2P и обменники"},
    {
        "type": "text",
        "body": "Перед торговлей нужно купить USDT или BTC за обычные деньги. P2P на бирже — покупка у другого человека через эскроу. Но сейчас P2P стал «грязным»: серые схемы, отмывание через казино, блокировки карт. Опасный признак — много мелких переводов вместо одного: продали USDT на 10 000 ₽, а пришло 20 платежей по 500 ₽ — почти наверняка грязные деньги. Лучше проверенный обменник или знакомый трейдер из сообщества, которому доверяешь. В нашем чате есть проверенный обменник — можно спросить. В крупных городах работают обменные пункты за наличные — читай отзывы. На P2P ты не знаешь, откуда придут деньги; при переводе знакомому трейдеру — знаешь.",
    },
    {
        "type": "market_note",
        "title": "Пополнение: Россия",
        "body": "Основные способы: СБП и карты крупных банков через P2P (осторожно — один платёж, чат только на бирже) или проверенный обменник сообщества. Bybit P2P — один из более живых вариантов, но риск блокировки карты остаётся. Первый раз — минимальная сумма. Не принимай переводы «от незнакомых» дробными платежами.",
        "market": "ru",
    },
    {
        "type": "market_note",
        "title": "Пополнение: Бразилия",
        "body": "Регистрация на Binance или Bybit → KYC с CPF → P2P → фильтр PIX. Выбирай продавца с рейтингом 95%+ и 500+ сделок. Плати только в чате ордера на бирже, не в Telegram. После оплаты подтверди — USDT придут на Funding. Переведи на Spot для торговли. Первый раз — минимальная сумма.",
        "market": "br",
    },
    {
        "type": "market_note",
        "title": "Пополнение: Мексика",
        "body": "Binance → KYC с INE/IFE + селфи → P2P → SPEI или Mercado Pago. Продавец с высоким рейтингом, оплата только в чате сделки. Не переводи на третье лицо. USDT → Spot. Первый депозит — минимальный, проверь зачисление.",
        "market": "mx",
    },
    {
        "type": "market_note",
        "title": "Пополнение: LATAM",
        "body": "Аргентина, Колумбия, Чили, Перу: P2P Binance/Bybit с местным банком (Nequi, Bancolombia, Mercado Pago и т.д.). Только escrow биржи — никогда по ссылке из Telegram. KYC до депозита. Один платёж лучше десяти мелких. Спроси в сообществе, какой способ используют трейдеры в твоей стране.",
        "market": "latam",
    },
    {
        "type": "practice",
        "title": "Чеклист безопасного пополнения",
        "body": "Пока не покупай — составь план:",
        "items": [
            "Выбери биржу (Binance или Bybit)",
            "Запиши способ для своего региона из карточек выше",
            "Отметь 3 красных флага: дробные платежи, чат вне биржи, перевод третьему лицу",
        ],
    },
    {"type": "heading", "title": "KYC — обязательная верификация"},
    {
        "type": "text",
        "body": "Верификацию проходим всегда. Без KYC нельзя полноценно торговать и нельзя создать API-ключи для подключения торгового терминала. Обычно нужны документ (паспорт, ID) и селфи. Процесс занимает от нескольких минут до суток. Телефон и почта тоже должны быть подтверждены.",
    },
    {"type": "heading", "title": "Отдельная почта на каждую биржу"},
    {
        "type": "text",
        "body": "Не привязывай биржу к основной почте, где Netflix, банк и соцсети. Создай новую почту для каждой биржи — уникальный пароль, используй только для неё. Зарегистрировался на другой бирже — новая почта. TradingView и форумы можно оставить на обычной почте.",
    },
    {"type": "heading", "title": "Google Authenticator (2FA)"},
    {
        "type": "text",
        "body": "Двухфакторная аутентификация обязательна. Без Google Authenticator не создашь API-ключи для терминала. При включении сохрани backup-коды — без них потеряешь доступ при смене телефона.",
    },
    {"type": "heading", "title": "Хранение паролей и кодов"},
    {
        "type": "text",
        "body": "Сохраняй коды биржи отдельно — не в Telegram «Избранное», не в публичных заметках. Отдельный офлайн-документ, менеджер паролей или, как в видео, листочек в надёжном месте. API-ключ: только торговля (Read + Trade), вывод (Withdraw) — ВЫКЛЮЧЕН. Никому не отправляй ключи.",
    },
    {"type": "heading", "title": "API-ключи для терминала"},
    {
        "type": "text",
        "body": "Binance или Bybit → API Management → Create API → включи Spot/Futures trading, отключи Withdraw. Скопируй ключ в Take Terminal, Tiger или Vataga. IP whitelist — по возможности. Терминал соединяется с биржей только через эти ключи — поэтому KYC и 2FA нужны до подключения.",
    },
    {
        "type": "market_note",
        "title": "Регистрация: Россия",
        "body": "1) binance.com или bybit.com (при ограничениях — уточни в Telegram сообщества, есть PDF-инструкция). 2) Sign Up → новая почта → пароль. 3) Verify Identity → паспорт РФ + селфи. 4) Security → Google Authenticator → сохрани backup codes. 5) Пополнение через обменник сообщества или P2P (осторожно). 6) API Management → Create → Trade ON, Withdraw OFF. 7) USDT: Funding → Spot.",
        "market": "ru",
    },
    {
        "type": "market_note",
        "title": "Регистрация: Бразилия",
        "body": "1) binance.com → Sign Up → e-mail novo. 2) KYC → CPF + documento (RG/CNH) + selfie. 3) 2FA → Google Authenticator → salvar códigos backup. 4) Comprar cripto → P2P → PIX → vendedor 95%+, 500+ ordens. 5) Pagar só no chat da ordem → Confirmar. 6) Transferir Funding → Spot. 7) API → trading ON, saque OFF → conectar terminal.",
        "market": "br",
    },
    {
        "type": "market_note",
        "title": "Регистрация: Мексика",
        "body": "1) binance.com → registro con e-mail nuevo. 2) KYC → INE/IFE + selfie. 3) 2FA → Google Authenticator. 4) Comprar cripto → P2P → SPEI o Mercado Pago. 5) Vendedor con alto rating, pago solo en chat de la orden. 6) USDT → Spot. 7) API → solo trading, sin retiro.",
        "market": "mx",
    },
    {
        "type": "market_note",
        "title": "Регистрация: LATAM",
        "body": "Общий порядок для Аргентины, Колумбии, Чили, Перу, Эквадора: 1) Регистрация Binance/Bybit — новый email. 2) KYC — национальный ID + selfie. 3) 2FA обязателен. 4) P2P с местным банком (Nequi, Bancolombia, Mercado Pago, банковский перевод). 5) Первый депозит — минимальный. 6) API: trade ON, withdraw OFF. Только escrow биржи.",
        "market": "latam",
    },
    {
        "type": "practice",
        "title": "Практика: регистрация без сделок",
        "body": "Выдели 30–40 минут:",
        "items": [
            "Зарегистрируйся на Binance или Bybit по инструкции для своего региона",
            "Пройди KYC и включи Google Authenticator — сохрани backup-коды офлайн",
            "Создай API-ключ: торговля ON, вывод OFF (пока не подключай терминал, если не готов)",
            "Открой Spot и посмотри интерфейс — без покупки",
            "В журнале запиши: биржа, почта (без пароля!), 2FA включён — да/нет",
        ],
    },
    {
        "type": "tradingview",
        "title": "После регистрации",
        "body": "Открой BINANCE:BTCUSDT на 15m — просто посмотри график. Следующий урок — часть 2: ордера, терминалы подробнее.",
        "symbol": "BINANCE:BTCUSDT",
        "interval": "15",
        "url": "https://www.tradingview.com/chart/?symbol=BINANCE%3ABTCUSDT&interval=15",
    },
    {
        "type": "example",
        "title": "Разбор: спот, фьючерс и безопасный старт",
        "body": "Спот: купил BTC на 1000 USDT — монета твоя, +3% = +30 USDT, −3% = −30 USDT, монета остаётся. Фьючерс 10x: та же идея, но контракт — +3% бьёт сильнее по марже, −10% без стопа может ликвидировать. P2P: один перевод от проверенного продавца — нормально; 20 платежей по 500 ₽ — стоп. Регистрация: новая почта + KYC + 2FA + API без вывода — минимум перед терминалом.",
    },
    {
        "type": "bullets",
        "title": "Запомнить",
        "items": [
            "Трейдинг — активная торговля ради выгоды",
            "Спот: купил — актив твой; заработок на росте",
            "Фьючерс: контракт, long/short, выше риск",
            "Терминал ускоряет торговлю vs перегруженная биржа",
            "P2P осторожно — лучше проверенный обменник",
            "KYC + отдельная почта + 2FA + API без вывода",
        ],
    },
    {
        "type": "journal",
        "title": "Итог урока",
        "body": "Зафиксируй в журнале:",
        "items": [
            "Своими словами: чем спот отличается от фьючерса?",
            "Какой способ пополнения выбрал для своего региона?",
            "Чеклист регистрации выполнен? Что осталось?",
        ],
    },
    {
        "type": "tip",
        "title": "Совет",
        "body": "Не прыгай в сделки после регистрации. Сначала KYC, 2FA, прогулка по интерфейсу — сделки в части 2 и дальше. Backup-коды 2FA сфотографируй и спрячь офлайн.",
    },
]

# English sections - translate key content
SECTIONS_EN = [
    {"type": "heading", "title": "Why theory comes first"},
    {
        "type": "text",
        "body": "Welcome to Academy of Trading. I'm Pavel Teterin. Before posts and market tips, learn the basics: what trading is, spot vs futures, terminals, and how to fund your account safely. Without this, «buy here, sell there» makes no sense. This lesson covers five intro topics from Part 1 of the video.\n\nIn this lesson:\n• What trading is and who a trader is\n• Spot vs futures markets\n• Why trading terminals exist\n• How to buy USDT safely (P2P and exchangers)\n• Exchange registration: KYC, 2FA, API for terminals",
    },
    {
        "type": "journal",
        "title": "Starting note",
        "body": "Before the lesson, write down:",
        "items": [
            "What have you heard about trading?",
            "What feels most confusing?",
            "Your region (Russia, Brazil, Mexico, LATAM)?",
        ],
    },
    {"type": "heading", "title": "What is trading"},
    {
        "type": "text",
        "body": "Trading is buying and selling assets at specific prices to make a profit. A trader actively seeks to buy lower and sell higher — or profit from a drop on futures. Trading is the activity; the trader is the person doing it.",
    },
    {
        "type": "chart",
        "title": "Buyers and sellers",
        "chartType": "market_balance",
        "caption": "Trading is finding favorable buy and sell prices.",
    },
    {"type": "heading", "title": "Spot market"},
    {
        "type": "text",
        "body": "On spot, when you buy an asset, you own it — like buying an iPhone. To profit: buy cheaper, sell higher. Example: buy a dollar at 100, sell at 110 — profit 10. No shorting on pure spot.",
    },
    {
        "type": "chart",
        "title": "Spot: you own the asset",
        "chartType": "uptrend",
        "caption": "On spot the coin stays in your balance even if price dips.",
    },
    {
        "type": "tradingview",
        "title": "View BTC chart",
        "body": "Open BINANCE:BTCUSDT daily. Find the last low and high — no trades yet.",
        "symbol": "BINANCE:BTCUSDT",
        "interval": "D",
        "url": "https://www.tradingview.com/chart/?symbol=BINANCE%3ABTCUSDT&interval=D",
    },
    {"type": "heading", "title": "Futures market"},
    {
        "type": "text",
        "body": "On futures you sign a contract with the exchange — you do not hold the asset. You can go long or short. Leverage comes in a later lesson. Futures are riskier: positions can be closed automatically if the market moves against you.",
    },
    {
        "type": "chart",
        "title": "Spot vs futures",
        "chartType": "risk_reward",
        "caption": "Left: you own the asset. Right: contract, long/short, higher risk.",
    },
    {"type": "heading", "title": "Trading terminals"},
    {
        "type": "text",
        "body": "Exchanges are cluttered with Web3, staking, airdrops — 80–90% is not direct trading. Terminals like Take Terminal strip the noise: preset size buttons, faster order book, detectors. Part 2 covers the author's terminal choice.",
    },
    {
        "type": "chart",
        "title": "Order book and fast entry",
        "chartType": "order_flow",
        "caption": "Terminals save clicks: size, book, entry in a few actions.",
    },
    {
        "type": "practice",
        "title": "Mini-practice: terminal vs exchange",
        "body": "Observation only — no trades:",
        "items": [
            "Open spot trading on the exchange",
            "Count clicks to a limit order for a fixed amount",
            "Log the number — compare with a terminal in Part 2",
        ],
    },
    {"type": "heading", "title": "P2P and exchangers"},
    {
        "type": "text",
        "body": "You need USDT or BTC before trading. P2P can be risky: dirty money, card blocks, casino laundering. Red flag: many small payments instead of one. Prefer a trusted exchanger or community member. Ask in our chat.",
    },
    {
        "type": "market_note",
        "title": "Funding: Russia",
        "body": "SBP/bank cards via P2P (careful — one payment, chat on exchange only) or community exchanger. Bybit P2P is active but risky. Start with minimum amount.",
        "market": "ru",
    },
    {
        "type": "market_note",
        "title": "Funding: Brazil",
        "body": "Binance/Bybit → KYC with CPF → P2P → PIX filter. Seller 95%+, 500+ orders. Pay only in order chat. USDT → Spot. Minimum first deposit.",
        "market": "br",
    },
    {
        "type": "market_note",
        "title": "Funding: Mexico",
        "body": "Binance → KYC INE/IFE → P2P SPEI or Mercado Pago. High-rated seller, pay in order chat only. USDT → Spot.",
        "market": "mx",
    },
    {
        "type": "market_note",
        "title": "Funding: LATAM",
        "body": "Argentina, Colombia, Chile, Peru: P2P with local bank via exchange escrow only. KYC first. One payment beats twenty small ones.",
        "market": "latam",
    },
    {
        "type": "practice",
        "title": "Safe funding checklist",
        "body": "Plan before you buy:",
        "items": [
            "Pick exchange (Binance or Bybit)",
            "Note your regional method from cards above",
            "List 3 red flags: split payments, off-exchange chat, third-party transfer",
        ],
    },
    {"type": "heading", "title": "KYC is mandatory"},
    {
        "type": "text",
        "body": "Always complete verification. Without KYC you cannot create API keys for a trading terminal. ID + selfie; usually minutes to 24 hours.",
    },
    {"type": "heading", "title": "Separate email per exchange"},
    {
        "type": "text",
        "body": "Do not use your main email for exchanges. One new email + unique password per exchange. TradingView can stay on your regular email.",
    },
    {"type": "heading", "title": "Google Authenticator (2FA)"},
    {
        "type": "text",
        "body": "2FA is required for API keys. Save backup codes when enabling — you need them if you change phones.",
    },
    {"type": "heading", "title": "Storing passwords and codes"},
    {
        "type": "text",
        "body": "Store exchange codes offline — not in Telegram Saved. API key: Read + Trade only, Withdraw OFF. Never share keys.",
    },
    {"type": "heading", "title": "API keys for terminals"},
    {
        "type": "text",
        "body": "Binance/Bybit → API Management → Create → Spot/Futures ON, Withdraw OFF. Paste into Take Terminal, Tiger, or Vataga.",
    },
    {
        "type": "market_note",
        "title": "Registration: Russia",
        "body": "1) binance.com or bybit.com. 2) New email signup. 3) KYC passport + selfie. 4) Google Authenticator + backup codes. 5) Fund via trusted exchanger or careful P2P. 6) API Trade ON, Withdraw OFF. 7) Funding → Spot.",
        "market": "ru",
    },
    {
        "type": "market_note",
        "title": "Registration: Brazil",
        "body": "1) binance.com signup. 2) KYC CPF + ID + selfie. 3) 2FA + backup codes. 4) P2P PIX. 5) Funding → Spot. 6) API trading ON, withdraw OFF.",
        "market": "br",
    },
    {
        "type": "market_note",
        "title": "Registration: Mexico",
        "body": "1) New email. 2) KYC INE/IFE. 3) 2FA. 4) P2P SPEI/Mercado Pago. 5) Spot. 6) API trade only.",
        "market": "mx",
    },
    {
        "type": "market_note",
        "title": "Registration: LATAM",
        "body": "Argentina, Colombia, Chile, Peru: new email → KYC → 2FA → local bank P2P → min deposit → API trade ON, withdraw OFF. Exchange escrow only.",
        "market": "latam",
    },
    {
        "type": "practice",
        "title": "Practice: register without trading",
        "body": "30–40 minutes:",
        "items": [
            "Register on Binance or Bybit for your region",
            "Complete KYC and 2FA — save backup codes offline",
            "Create API: trade ON, withdraw OFF",
            "Browse Spot UI — no buy yet",
            "Journal: exchange, 2FA yes/no",
        ],
    },
    {
        "type": "tradingview",
        "title": "After registration",
        "body": "Open BINANCE:BTCUSDT 15m — just observe. Part 2 covers orders and terminals.",
        "symbol": "BINANCE:BTCUSDT",
        "interval": "15",
        "url": "https://www.tradingview.com/chart/?symbol=BINANCE%3ABTCUSDT&interval=15",
    },
    {
        "type": "example",
        "title": "Scenario: spot, futures, safe start",
        "body": "Spot: buy BTC — you own it. Futures 10x: same move hits margin harder. P2P: one payment OK; twenty small ones — stop. Registration: new email + KYC + 2FA + API no withdraw.",
    },
    {
        "type": "bullets",
        "title": "Remember",
        "items": [
            "Trading seeks profit through active buying/selling",
            "Spot: you own the asset",
            "Futures: contract, long/short, higher risk",
            "Terminals speed up trading",
            "P2P carefully — trusted exchanger better",
            "KYC + separate email + 2FA + API no withdraw",
        ],
    },
    {
        "type": "journal",
        "title": "Lesson summary",
        "body": "Log in your journal:",
        "items": [
            "Spot vs futures in your own words?",
            "Funding method for your region?",
            "Registration checklist done? What's left?",
        ],
    },
    {
        "type": "tip",
        "title": "Pro tip",
        "body": "Do not trade right after signup. KYC, 2FA, explore the UI first. Store 2FA backup codes offline.",
    },
]

# Portuguese - similar to EN with PT text
SECTIONS_PT = [
    {"type": "heading", "title": "Por que a teoria vem primeiro"},
    {
        "type": "text",
        "body": "Bem-vindo à Academy of Trading. Eu sou Pavel Teterin. Antes de posts e dicas de mercado, aprenda o básico: o que é trading, spot vs futuros, terminais e como depositar com segurança. Esta lição cobre cinco temas introdutórios da Parte 1 do vídeo.\n\nNesta lição:\n• O que é trading e quem é o trader\n• Mercado spot vs futuros\n• Por que existem terminais de trading\n• Como comprar USDT com segurança (P2P e cambistas)\n• Registro na exchange: KYC, 2FA, API para terminais",
    },
    {
        "type": "journal",
        "title": "Nota inicial",
        "body": "Antes da lição, anote:",
        "items": [
            "O que você já ouviu sobre trading?",
            "O que parece mais confuso?",
            "Sua região (Rússia, Brasil, México, LATAM)?",
        ],
    },
    {"type": "heading", "title": "O que é trading"},
    {
        "type": "text",
        "body": "Trading é comprar e vender ativos a preços específicos para lucrar. O trader busca comprar mais barato e vender mais caro — ou lucrar com queda nos futuros.",
    },
    {
        "type": "chart",
        "title": "Compradores e vendedores",
        "chartType": "market_balance",
        "caption": "Trading é encontrar preços favoráveis de compra e venda.",
    },
    {"type": "heading", "title": "Mercado spot"},
    {
        "type": "text",
        "body": "No spot, quando você compra um ativo, ele é seu — como um iPhone. Para lucrar: compre mais barato, venda mais caro. Exemplo: comprou dólar a 100, vendeu a 110 — lucro 10. Sem short no spot puro.",
    },
    {
        "type": "chart",
        "title": "Spot: o ativo é seu",
        "chartType": "uptrend",
        "caption": "No spot a moeda fica no saldo mesmo se o preço cair.",
    },
    {
        "type": "tradingview",
        "title": "Veja o gráfico BTC",
        "body": "Abra BINANCE:BTCUSDT diário. Encontre o último fundo e topo — sem trades ainda.",
        "symbol": "BINANCE:BTCUSDT",
        "interval": "D",
        "url": "https://www.tradingview.com/chart/?symbol=BINANCE%3ABTCUSDT&interval=D",
    },
    {"type": "heading", "title": "Mercado de futuros"},
    {
        "type": "text",
        "body": "Nos futuros você assina um contrato com a exchange — não possui o ativo. Pode operar comprado ou vendido. Alavancagem vem em outra lição. Futuros são mais arriscados: posições podem ser fechadas automaticamente.",
    },
    {
        "type": "chart",
        "title": "Spot vs futuros",
        "chartType": "risk_reward",
        "caption": "Esquerda: você possui o ativo. Direita: contrato, long/short, mais risco.",
    },
    {"type": "heading", "title": "Terminais de trading"},
    {
        "type": "text",
        "body": "Exchanges estão cheias de Web3, staking, airdrops — 80–90% não é trading direto. Terminais como Take Terminal removem o ruído: botões de tamanho, book rápido, detectores. Parte 2 cobre a escolha do terminal.",
    },
    {
        "type": "chart",
        "title": "Book e entrada rápida",
        "chartType": "order_flow",
        "caption": "Terminais economizam cliques: tamanho, book, entrada.",
    },
    {
        "type": "practice",
        "title": "Mini-prática: terminal vs exchange",
        "body": "Só observação — sem trades:",
        "items": [
            "Abra spot trading na exchange",
            "Conte cliques até ordem limite com valor fixo",
            "Anote o número — compare com terminal na Parte 2",
        ],
    },
    {"type": "heading", "title": "P2P e cambistas"},
    {
        "type": "text",
        "body": "Você precisa de USDT ou BTC antes de operar. P2P pode ser arriscado: dinheiro sujo, bloqueio de cartão. Sinal vermelho: muitos pagamentos pequenos. Prefira cambista confiável ou membro da comunidade.",
    },
    {
        "type": "market_note",
        "title": "Depósito: Rússia",
        "body": "SBP/cartões via P2P (cuidado) ou cambista da comunidade. Bybit P2P ativo mas arriscado. Comece com valor mínimo.",
        "market": "ru",
    },
    {
        "type": "market_note",
        "title": "Depósito: Brasil",
        "body": "Binance/Bybit → KYC com CPF → P2P → filtro PIX. Vendedor 95%+, 500+ ordens. Pague só no chat da ordem. USDT → Spot. Primeiro depósito mínimo.",
        "market": "br",
    },
    {
        "type": "market_note",
        "title": "Depósito: México",
        "body": "Binance → KYC INE/IFE → P2P SPEI ou Mercado Pago. Vendedor bem avaliado, pagamento só no chat.",
        "market": "mx",
    },
    {
        "type": "market_note",
        "title": "Depósito: LATAM",
        "body": "Argentina, Colômbia, Chile, Peru: P2P com banco local via escrow da exchange. KYC primeiro. Um pagamento melhor que vinte pequenos.",
        "market": "latam",
    },
    {
        "type": "practice",
        "title": "Checklist de depósito seguro",
        "body": "Planeje antes de comprar:",
        "items": [
            "Escolha exchange (Binance ou Bybit)",
            "Anote método regional das cartas acima",
            "Liste 3 sinais vermelhos: pagamentos divididos, chat fora da exchange, terceiros",
        ],
    },
    {"type": "heading", "title": "KYC é obrigatório"},
    {
        "type": "text",
        "body": "Sempre complete a verificação. Sem KYC não cria chaves API para terminal. Documento + selfie; de minutos a 24 horas.",
    },
    {"type": "heading", "title": "E-mail separado por exchange"},
    {
        "type": "text",
        "body": "Não use e-mail principal para exchanges. Um e-mail novo + senha única por exchange. TradingView pode ficar no e-mail normal.",
    },
    {"type": "heading", "title": "Google Authenticator (2FA)"},
    {
        "type": "text",
        "body": "2FA é necessário para chaves API. Salve códigos backup ao ativar.",
    },
    {"type": "heading", "title": "Guardar senhas e códigos"},
    {
        "type": "text",
        "body": "Guarde códigos offline — não no Telegram. API: Read + Trade, Withdraw OFF. Nunca compartilhe chaves.",
    },
    {"type": "heading", "title": "Chaves API para terminais"},
    {
        "type": "text",
        "body": "Binance/Bybit → API Management → Create → Spot/Futures ON, Withdraw OFF. Cole no Take Terminal, Tiger ou Vataga.",
    },
    {
        "type": "market_note",
        "title": "Registro: Rússia",
        "body": "1) binance.com ou bybit.com. 2) E-mail novo. 3) KYC passaporte + selfie. 4) Google Authenticator + backup. 5) Depósito via cambista ou P2P cuidadoso. 6) API Trade ON, Withdraw OFF.",
        "market": "ru",
    },
    {
        "type": "market_note",
        "title": "Registro: Brasil",
        "body": "1) binance.com cadastro. 2) KYC CPF + RG/CNH + selfie. 3) 2FA + códigos backup. 4) P2P PIX. 5) Funding → Spot. 6) API trading ON, saque OFF → conectar terminal.",
        "market": "br",
    },
    {
        "type": "market_note",
        "title": "Registro: México",
        "body": "1) E-mail novo. 2) KYC INE/IFE. 3) 2FA. 4) P2P SPEI/Mercado Pago. 5) Spot. 6) API só trading.",
        "market": "mx",
    },
    {
        "type": "market_note",
        "title": "Registro: LATAM",
        "body": "Argentina, Colômbia, Chile, Peru: e-mail novo → KYC → 2FA → P2P banco local → depósito mínimo → API trade ON, withdraw OFF.",
        "market": "latam",
    },
    {
        "type": "practice",
        "title": "Prática: registrar sem operar",
        "body": "30–40 minutos:",
        "items": [
            "Registre na Binance ou Bybit para sua região",
            "Complete KYC e 2FA — salve backup offline",
            "Crie API: trade ON, saque OFF",
            "Explore Spot — sem comprar",
            "Diário: exchange, 2FA sim/não",
        ],
    },
    {
        "type": "tradingview",
        "title": "Após o registro",
        "body": "Abra BINANCE:BTCUSDT 15m — só observe. Parte 2: ordens e terminais.",
        "symbol": "BINANCE:BTCUSDT",
        "interval": "15",
        "url": "https://www.tradingview.com/chart/?symbol=BINANCE%3ABTCUSDT&interval=15",
    },
    {
        "type": "example",
        "title": "Cenário: spot, futuros, início seguro",
        "body": "Spot: comprou BTC — é seu. Futuros 10x: mesmo movimento bate mais forte na margem. P2P: um pagamento OK; vinte pequenos — pare. Registro: e-mail novo + KYC + 2FA + API sem saque.",
    },
    {
        "type": "bullets",
        "title": "Lembrar",
        "items": [
            "Trading busca lucro com compra/venda ativa",
            "Spot: você possui o ativo",
            "Futuros: contrato, long/short, mais risco",
            "Terminais aceleram operações",
            "P2P com cuidado — cambista confiável melhor",
            "KYC + e-mail separado + 2FA + API sem saque",
        ],
    },
    {
        "type": "journal",
        "title": "Resumo da lição",
        "body": "Registre no diário:",
        "items": [
            "Spot vs futuros com suas palavras?",
            "Método de depósito para sua região?",
            "Checklist de registro feito? O que falta?",
        ],
    },
    {
        "type": "tip",
        "title": "Dica",
        "body": "Não opere logo após cadastro. KYC, 2FA, explore a interface primeiro. Guarde códigos 2FA offline.",
    },
]

META = {
    "ru": {
        "id": 1,
        "module": "Введение",
        "title": "Вводное. С чего начать в трейдинге? Часть 1",
        "subtitle": "Трейдинг, спот, фьючерсы, терминалы, P2P, регистрация на бирже",
        "difficulty": "Beginner",
        "durationMin": 28,
        "outcome": "Поймёте, что такое трейдинг, разницу спот/фьючерс, зачем терминал, риски P2P и как безопасно зарегистрироваться на бирже.",
        "content": "Трейдинг — активная торговля с целью выгоды. Без базы непонятны ни посты в чате, ни первые сделки.",
        "takeaway": "Трейдинг — торговля ради выгоды; спот для старта; фьючерс — контракт и риск; терминал ускоряет; P2P осторожно; регистрация = KYC + 2FA + отдельная почта + API без вывода.",
        "prerequisites": [],
        "learningOutcomes": [
            "Объяснить своими словами, чем спот отличается от фьючерса",
            "Назвать три правила безопасной регистрации на бирже",
            "Составить чеклист безопасного пополнения USDT для своего региона",
        ],
        "references": [
            {
                "title": "Binance Account Registration",
                "author": "Binance",
                "year": 2025,
                "url": "https://www.binance.com/en/support/faq",
                "type": "documentation",
            }
        ],
    },
    "en": {
        "id": 1,
        "module": "Introduction",
        "title": "Getting Started with Trading — Part 1",
        "subtitle": "Trading basics, spot, futures, terminals, P2P, exchange registration",
        "difficulty": "Beginner",
        "durationMin": 28,
        "outcome": "Understand what trading is, spot vs futures, why terminals matter, P2P risks, and how to register safely on an exchange.",
        "content": "Trading is active buying and selling for profit. Without basics, community posts and first trades make no sense.",
        "takeaway": "Trading seeks profit; start with spot; futures are contracts with higher risk; terminals speed execution; be careful with P2P; registration = KYC + 2FA + separate email + API without withdrawal.",
        "prerequisites": [],
        "learningOutcomes": [
            "Explain spot vs futures in your own words",
            "Name three safe exchange registration rules",
            "Build a safe USDT funding checklist for your region",
        ],
        "references": [
            {
                "title": "Binance Account Registration",
                "author": "Binance",
                "year": 2025,
                "url": "https://www.binance.com/en/support/faq",
                "type": "documentation",
            }
        ],
    },
    "pt": {
        "id": 1,
        "module": "Introdução",
        "title": "Intro: Por onde começar no trading? Parte 1",
        "subtitle": "Trading, spot, futuros, terminais, P2P, registro na exchange",
        "difficulty": "Beginner",
        "durationMin": 28,
        "outcome": "Entenda o que é trading, spot vs futuros, por que usar terminal, riscos do P2P e como se registrar com segurança.",
        "content": "Trading é compra e venda ativa buscando lucro. Sem base, posts da comunidade e primeiras operações não fazem sentido.",
        "takeaway": "Trading busca lucro; comece no spot; futuros são contratos com mais risco; terminal acelera; cuidado com P2P; registro = KYC + 2FA + e-mail separado + API sem saque.",
        "prerequisites": [],
        "learningOutcomes": [
            "Explicar spot vs futuros com suas palavras",
            "Citar três regras de registro seguro na exchange",
            "Montar checklist seguro de USDT para sua região",
        ],
        "references": [
            {
                "title": "Binance Account Registration",
                "author": "Binance",
                "year": 2025,
                "url": "https://www.binance.com/en/support/faq",
                "type": "documentation",
            }
        ],
    },
}

SECTIONS_BY_LOCALE = {"ru": SECTIONS_RU, "en": SECTIONS_EN, "pt": SECTIONS_PT}

_NO_CHART_TYPES = frozenset({"chart", "tradingview"})


def _without_chart_integrations(sections: list) -> list:
    return [s for s in sections if s.get("type") not in _NO_CHART_TYPES]


def patch_lessons(locale: str) -> None:
    path = DATA / f"lessons_{locale}.json"
    lessons = json.loads(path.read_text(encoding="utf-8"))
    meta = META[locale].copy()
    meta["sections"] = _without_chart_integrations(SECTIONS_BY_LOCALE[locale])
    replaced = False
    for i, lesson in enumerate(lessons):
        if lesson.get("id") == 1:
            lessons[i] = meta
            replaced = True
            break
    if not replaced:
        raise SystemExit(f"Lesson 1 not found in {path}")
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Patched {path}")


def patch_quizzes() -> None:
    path = DATA / "lesson_quizzes.json"
    quizzes = json.loads(path.read_text(encoding="utf-8"))
    new_takeaway_ru = META["ru"]["takeaway"]
    new_takeaway_en = META["en"]["takeaway"]
    new_takeaway_pt = META["pt"]["takeaway"]
    new_outcome_ru = META["ru"]["outcome"]
    new_outcome_en = META["en"]["outcome"]
    new_outcome_pt = META["pt"]["outcome"]

    for q in quizzes:
        if q.get("lessonId") != 1:
            continue
        if q["id"] == "L1-Q1":
            q["options"]["ru"][3] = new_takeaway_ru
            q["options"]["en"][2] = new_takeaway_en
            q["options"]["pt"][0] = new_takeaway_pt
            q["explanation"]["ru"] = new_takeaway_ru
            q["explanation"]["en"] = new_takeaway_en
            q["explanation"]["pt"] = new_takeaway_pt
        elif q["id"] == "L1-Q2":
            q["options"]["ru"][2] = new_outcome_ru
            q["options"]["en"][0] = new_outcome_en
            q["options"]["pt"][1] = new_outcome_pt
            q["explanation"]["ru"] = new_takeaway_ru
            q["explanation"]["en"] = new_takeaway_en
            q["explanation"]["pt"] = new_takeaway_pt
        elif q["id"] == "L1-Q3":
            q["options"]["ru"][0] = "Трейдинг — активная торговля ради выгоды"
            q["options"]["en"][0] = "Trading seeks profit through active buying/selling"
            q["options"]["pt"][0] = "Trading busca lucro com compra/venda ativa"
            q["explanation"]["ru"] = new_takeaway_ru
            q["explanation"]["en"] = new_takeaway_en
            q["explanation"]["pt"] = new_takeaway_pt

    path.write_text(json.dumps(quizzes, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Patched {path}")


if __name__ == "__main__":
    for loc in ("ru", "en", "pt"):
        patch_lessons(loc)
    patch_quizzes()
