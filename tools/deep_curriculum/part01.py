# Deep curriculum — lessons 1-12 (RU lecture / EN+PT substantive)
# Export: LESSONS

MOD_INTRO = ("Введение", "Introduction", "Introdução")
MOD_CHART = ("График", "Chart", "Gráfico")
MOD_PAT = ("Паттерны", "Patterns", "Padrões")
MOD_STR = ("Стратегии", "Strategies", "Estratégias")
MOD_MKT = ("Рынок", "Market", "Mercado")
MOD_RISK = ("Риск", "Risk", "Risco")


def _m(br, mx, ru, gl=""):
    return {"br": br, "mx": mx, "ru": ru, "global": gl or br}


def L(lid, mod, diff, mins, chart, sym, interval, markets, loc):
    return {
        "id": lid,
        "module": mod,
        "difficulty": diff,
        "durationMin": mins,
        "chart": chart,
        "symbol": sym,
        "interval": interval,
        "markets": markets,
        "loc": loc,
    }


# ─── Lesson 1 ───────────────────────────────────────────────────────────────────
_L1_RU_BLOCKS = [
    {
        "h": "Кто такой трейдер — простыми словами",
        "body": (
            "Представьте рынок как огромный базар, который никогда не закрывается. Продавцы выставляют цену, "
            "покупатели торгуются, и каждую секунду кто-то соглашается на сделку. Трейдер — это человек, "
            "который сознательно участвует в этом базаре, чтобы заработать на разнице цен: купил дешевле, "
            "продал дороже — или наоборот, если вы умеете продавать в шорт. Это не инвестор, который покупает "
            "акции компании на десять лет и забывает про них. Трейдер работает с горизонтом от нескольких секунд "
            "до нескольких недель и каждый раз принимает решение: входить, ждать или выходить. "
            "У него нет «гарантированной зарплаты» — есть серия сделок, где часть приносит прибыль, часть убыток, "
            "и итог зависит от того, насколько прибыльные сделки перекрывают убыточные. "
            "Новичок часто думает, что трейдер — это тот, кто «угадал биткоин». Профессионал думает иначе: "
            "он ищет ситуации, где вероятность и соотношение риска к прибыли работают на него, "
            "и повторяет одни и те же правила сотни раз. Как повар не готовит случайные блюда, "
            "а следует рецепту, так и трейдер следует сетапу — заранее описанному сценарию с входом, стопом и целью."
        ),
    },
    {
        "h": "Чем трейдинг отличается от казино и от «удачи»",
        "body": (
            "В казино математика всегда против вас: рулетка, слоты, даже блэкджек без счёта карт — "
            "у заведения есть преимущество. На бирже преимущество не зашито в правила игры. "
            "Его создаёт или разрушает сам трейдер: дисциплина, размер позиции, умение читать график. "
            "Можно торговать как в казино — на эмоциях, без стопа, «всё на красное» — и тогда результат "
            "будет похож на казино. Можно торговать как ремесленник: рисковать полпроцента депозита на сделку, "
            "ставить стоп до входа, вести журнал — и тогда за сотни сделок станет видна ваша реальная статистика. "
            "Важная мысль для полного новичка: одна сделка ничего не доказывает. Выиграли — не значит, что вы гений. "
            "Проиграли — не значит, что рынок «против вас лично». Рынок не знает вашего имени. "
            "Он просто сопоставляет ордера покупателей и продавцов. Ваша задача на первом этапе — "
            "перестать воспринимать каждую свечу как личное оскорбление и начать воспринимать её как данные."
        ),
    },
    {
        "h": "Спот: вы реально покупаете монету",
        "body": (
            "Спотовый рынок — самый понятный режим для старта. Вы переводите USDT на биржу, нажимаете «Купить BTC», "
            "и на балансе появляется биткоин. Это как купить яблоки на рынке: заплатили деньги — яблоки ваши. "
            "Продали яблоки дороже — заработали. Продали дешевле — потеряли. На споте вы не можете «поставить "
            "на падение» в классическом смысле, если у вас нет самой монеты: чтобы продать то, чего нет, "
            "нужен маржинальный спот или фьючерс. Зато на споте нет ликвидации в привычном фьючерсном смысле: "
            "если цена упала на пятьдесят процентов, у вас просто остался биткоин, который стоит в два раза меньше — "
            "больно, но счёт не обнуляется автоматически из-за плеча. "
            "Спот идеален для первых недель: изучить интерфейс, научиться выставлять лимитный ордер, "
            "увидеть, как меняется баланс в USDT и в монете. Многие профессионалы держат основной капитал "
            "на споте или в стейблкоинах, а на фьючерс переводят только ту часть, с которой активно торгуют."
        ),
    },
    {
        "h": "Фьючерсы USDT-M: контракт, а не монета в кошельке",
        "body": (
            "Фьючерс perpetual (бессрочный) на Binance — это не покупка биткоина. Это контракт: "
            "вы договариваетесь с контрагентом (биржей и другими трейдерами) об участии в движении цены. "
            "Расчёт идёт в USDT. Вы можете открыть лонг — зарабатывать на росте, или шорт — зарабатывать на падении. "
            "Это как поставить на то, что температура завтра выше сегодняшней, не покупая градусники. "
            "Плечо (leverage) увеличивает размер позиции относительно вашей маржи. Маржа сто тысяч рублей "
            "при плече 10x даёт экспозицию как будто вы торгуете на миллион — но и прибыль, и убыток "
            "считаются от этой увеличенной позиции. Плечо не создаёт деньги из воздуха; оно ускоряет "
            "и прибыль, и убыток. На фьючерсах есть funding rate — периодический платёж между лонгами и шортами, "
            "который удерживает цену фьючерса рядом со спотом. Раз в восемь часов одна сторона платит другой. "
            "Для новичка это мелочь на дистанции одного дня, но на недельном шорте в сильном апренде "
            "funding может съесть заметную часть прибыли."
        ),
    },
    {
        "h": "Спот vs фьючерс: глубокое сравнение для новичка",
        "body": (
            "Сведём в одну таблицу в голове. Спот: владеете активом, заработок в основном на росте, "
            "нет ликвидации от плеча, комиссии обычно ниже, психологически проще — «купил и держу». "
            "Фьючерс: не владеете монетой, лонг и шорт, плечо, ликвидация, funding, выше риск ошибки новичка. "
            "Зачем тогда фьючерс? Потому что на падающем рынке спот не даёт заработать (без монеты на балансе), "
            "а фьючерс даёт. Потому что с меньшим депозитом можно контролировать большую позицию — "
            "но это меч обоюдоострый. Пример: депозит тысяча USDT. На споте покупаете BTC на всю сумму — "
            "цена −5% = −50 USDT. На фьючерсе 10x лонг на ту же экспозицию — маржа ~100 USDT, "
            "но движение −5% по позиции бьёт как −50 USDT по марже, то есть −50% к залогу. "
            "Ещё −5% — и при отсутствии стопа вас ликвидирует. На споте после −10% у вас всё ещё есть монета. "
            "Вывод для начинающего: освоите спот и риск-менеджмент — потом фьючерс с плечом 2–3x и изолированной маржой. "
            "Не наоборот."
        ),
    },
    {
        "h": "Binance: как устроена биржа и с чего начать",
        "body": (
            "Binance — одна из крупнейших криптобирж в мире. Для вас это площадка: регистрация, верификация KYC, "
            "пополнение, торговля, вывод. Интерфейс делится на Спот, Фьючерсы USDT-M, P2P, Earn и прочее. "
            "Новичку нужны три зоны: Кошелёк (балансы), Спот-торговля, позже — Фьючерсы. "
            "Пройдите KYC до пополнения: паспорт, селфи — стандарт AML. Без KYC P2P и лимиты будут жёстче. "
            "Включите двухфакторную аутентификацию (Google Authenticator), отключите лишние разрешения API. "
            "Никому не давайте пароль и коды. «Саппорт Binance» в Telegram, который просит seed-фразу — всегда мошенник. "
            "Первую неделю ходите по меню без сделок: где история ордеров, где перевод между спот и фьючерс, "
            "где калькулятор ликвидации на фьючерсах. Trade Master в этом курсе учит не нажимать кнопки наугад, "
            "а связывать теорию с графиком в TradingView — это ваше отличие от приложений, которые дают только "
            "общие советы про экономию."
        ),
    },
    {
        "h": "P2P: как завести рубли или реалы на биржу",
        "body": (
            "P2P на Binance — покупка USDT у другого пользователя через эскроу биржи. Вы выбираете продавца "
            "с высоким рейтингом и большим числом сделок, переводите рубли по СБП или банку, "
            "продавец отпускает USDT на ваш кошелёк. Биржа держит USDT продавца «в залоге», пока вы не подтвердите оплату. "
            "В Бразилии часто используют PIX; в Мексике — переводы и Mercado Pago; в РФ — СБП и карты крупных банков. "
            "Правила безопасности: не общайтесь вне чата сделки, не принимайте «возврат на другую карту», "
            "не отмечайте оплату, если не платили. Мошенники просят перевести на третье лицо — отмена сделки. "
            "Первый раз купите минимальную сумму, убедитесь, что USDT пришли, потом увеличивайте. "
            "После P2P USDT лежит в кошельке фиата/фандинга — переведите на Спот для покупки монет "
            "или на Фьючерсы для маржинальной торговли. Комиссия P2P часто нулевая; платите спред курса продавца."
        ),
    },
    {
        "h": "Ликвидация: что это и как не потерять весь депозит за минуту",
        "body": (
            "Ликвидация на фьючерсах — принудительное закрытие позиции биржей, когда маржа не покрывает убыток. "
            "Аналогия: вы взяли в долг у друга деньги на ставку, рынок пошёл против вас, друг забирает залог. "
            "Цена ликвидации зависит от плеча, размера позиции, режима маржи (кросс или изолированная). "
            "Изолированная маржа — на кону только залог этой позиции; кросс — весь баланс фьючерсного счёта. "
            "Новичку только изолированная. Плечо 20x на первой сделке — путь к ликвидации от обычного шума рынка. "
            "Стоп-лосс — ордер, который закрывает позицию до ликвидации. Профессионал ставит стоп до входа и знает, "
            "сколько USDT он рискует. Если стоп 0.8% от цены, а риск на сделку 1% депозита — размер позиции "
            "рассчитывается из этих двух чисел, а не «на глаз». Калькулятор на Binance показывает цену ликвидации — "
            "откройте его до клика «Купить». Если ликвидация ближе, чем ваш стоп — размер или плечо неверны."
        ),
    },
    {
        "h": "Как объяснить другу за чашкой кофе",
        "body": (
            "Сценарий для друга без опыта: «Трейдинг — это не гарантированный доход. Это работа с риском. "
            "На споте ты покупаешь биткоин как валюту — упал курс, упал баланс, но монета осталась. "
            "На фьючерсе ты ставишь на направление с плечом — можно заработать на падении, "
            "но биржа закроет сделку, если проигрыш съест залог. Я сначала учусь на демо и малых суммах, "
            "рискую не больше одного процента депозита на сделку, веду журнал. Не лезу в чаты с „сигналами на 100x“.» "
            "Если друг спрашивает «сколько заработаешь» — честный ответ: «Не знаю за день. Знаю, сколько готов потерять "
            "на одной сделке.» Это отличает трейдера от игрока. Попросите друга открыть TradingView и показать "
            "вчерашний максимум и минимум BTC — это уже первый урок чтения графика без денег."
        ),
    },
    {
        "h": "Мифы, которые стоят денег",
        "body": (
            "Миф первый: «На фьючерсе заработаю быстрее». Быстрее можно и потерять — плечо симметрично. "
            "Миф второй: «Спот безопасен, можно держать без стопа». Альткоин −80% на споте — "
            "это не ликвидация, но финансово больно. Миф третий: «Шорт — это предательство или магия». "
            "Шорт на фьючерсе — обычный контракт, не моральный выбор. Миф четвёртый: «Сигнал из чата заменит обучение». "
            "Чужой вход без вашего стопа и размера — лотерея. Миф пятый: «Нужно много денег для старта». "
            "Для обучения достаточно суммы, которую готовы списать на опыт — часто 50–200 USDT на споте, "
            "плюс месяцы практики на демо. Реальное преимущество новичка — не капитал, а время на обучение "
            "и дисциплина журнала. Каждый миф снимается практикой: одна неделя наблюдений за спотом и фьючерсом "
            "без сделок даёт больше, чем месяц сигналов."
        ),
    },
    {
        "h": "Числовой пример: одна и та же сделка на споте и на фьючерсе",
        "body": (
            "Закрепим цифрами. BTC стоит 70 000 USDT. У вас 1 000 USDT. Сценарий А — спот: покупаете BTC на 1 000 USDT, "
            "получаете ~0.0143 BTC. Цена выросла на 3% до 72 100 — продаёте, получаете ~1 030 USDT, прибыль 30 USDT (+3%). "
            "Цена упала на 3% до 67 900 — баланс ~970 USDT, убыток 30 USDT (−3%). Монета остаётся у вас. "
            "Сценарий Б — фьючерс 10x: маржа 1 000 USDT, позиция ~10 000 USDT номинала. +3% по BTC ≈ +300 USDT к позиции "
            "≈ +30% к марже (+300 USDT). −3% ≈ −300 USDT (−30% маржи). −10% по BTC без стопа — ликвидация, "
            "маржа потеряна. Тот же рынок, тот же актив — разный инструмент, разная скорость результата. "
            "Профессионал выбирает инструмент под задачу: накопить монету — спот; торговать падение или хеджировать — фьючерс "
            "с малым плечом и стопом. Новичок проходит путь: спот → бумажные планы → фьючерс 2–3x → только потом больше."
        ),
    },
    {
        "h": "Первые шаги после этого урока",
        "body": (
            "План на ближайшие три дня без спешки. День первый: аккаунт Binance, KYC, 2FA, прогулка по интерфейсу. "
            "День второй: P2P на минимальную сумму или демо TradingView — сравнить цену BTC спот и perpetual. "
            "День третий: на графике 15m отметить последний явный максимум и минимум, записать в блокнот: "
            "«Если бы я купил у минимума, стоп поставил бы ниже на 0.5%» — без реальной сделки. "
            "Не открывайте фьючерс с высоким плечом «попробовать». Не копируйте сделки из Telegram. "
            "Следующий урок — ордера, комиссии, терминалы Tiger и Vataga, скальпинг против свинга. "
            "Вы строите фундамент: понимание инструментов важнее первой прибыльной сделки. "
            "Прибыльная сделка без правил — случайность, которая научит плохим привычкам."
        ),
    },
]

_L1_EN_BLOCKS = [
    {
        "h": "Who is a trader?",
        "body": (
            "Imagine a marketplace that never closes. A trader participates deliberately to profit from price moves — "
            "buy lower, sell higher, or the reverse with shorts. Unlike a long-term investor, a trader works on horizons "
            "from seconds to weeks and repeats setups with defined risk. One winning trade proves nothing; "
            "discipline over hundreds of trades does. Professionals plan entry, stop, and target before clicking. "
            "Amateurs click and hope. Your first goal is to stop treating each candle as luck and start treating it as data."
        ),
    },
    {
        "h": "Spot: you own the coin",
        "body": (
            "Spot is the simplest start. You deposit USDT, buy BTC, and BTC appears on your balance — like buying apples "
            "at a market. You mainly profit from rises unless you already hold coins to sell. There is no futures-style "
            "liquidation from leverage: if price halves, your coin is worth half, but the exchange does not auto-close "
            "your account. Spot is ideal for learning the UI, limit orders, and how balances move in USDT vs coin. "
            "Many pros keep core capital in spot or stables and move only active trading funds to futures."
        ),
    },
    {
        "h": "USDT-M futures: contract with leverage",
        "body": (
            "Perpetual futures are contracts settled in USDT, not coins in your wallet. You can go long or short. "
            "Leverage multiplies exposure relative to margin — it accelerates both gains and losses. Funding payments "
            "between longs and shorts keep futures near spot. A 5% adverse move on 10x can devastate margin without a stop. "
            "Beginners should master spot and risk math before futures at 2–3x isolated margin only."
        ),
    },
    {
        "h": "Spot vs futures — deep comparison",
        "body": (
            "Spot: own asset, mainly long bias, no leverage liquidation, psychologically simpler. "
            "Futures: long/short, leverage, liquidation, funding, higher skill demand. "
            "Why futures? Profit on downtrends and capital efficiency — but errors are punished faster. "
            "Example: $1000 spot BTC −5% = −$50. Same exposure 10x futures may lose 50% of margin on −5%. "
            "Learn spot first, then small leveraged futures with stops always planned before entry."
        ),
    },
    {
        "h": "Binance, P2P, and liquidation safety",
        "body": (
            "Binance flow: register, KYC, 2FA, fund via P2P (PIX in Brazil, SPEI/cards in Mexico, SBP in Russia), "
            "transfer to Spot or Futures. Never share passwords; fake support is always a scam. "
            "Liquidation closes your futures position when margin is exhausted. Use isolated margin, modest leverage, "
            "and stop-loss before entry. Check liquidation price in the calculator before you buy. "
            "Trade Master links lessons to TradingView practice — not signal groups."
        ),
    },
]

_L1_PT_BLOCKS = [
    {
        "h": "Quem é o trader?",
        "body": (
            "Trader participa do mercado para lucrar com movimentos de preço — comprar mais barato, vender mais caro, "
            "ou o contrário no short. Diferente do investidor de longo prazo, opera de segundos a semanas com risco definido. "
            "Profissionais planejam entrada, stop e alvo antes do clique. Uma trade vencedora não prova nada; "
            "a disciplina em centenas de trades prova."
        ),
    },
    {
        "h": "Spot vs futuros",
        "body": (
            "Spot: você possui a moeda; ganha principalmente na alta; sem liquidação por alavancagem. "
            "Futuros USDT-M: contrato com alavancagem, long e short, funding e risco de liquidação. "
            "No Brasil, PIX + P2P é o caminho comum para USDT. Comece no spot; depois futuros com 2–3x e margem isolada."
        ),
    },
    {
        "h": "Binance e segurança",
        "body": (
            "Cadastro, KYC, 2FA, P2P com vendedores bem avaliados. Nunca pague fora do escrow da Binance. "
            "Liquidação encerra a posição quando a margem acaba — use stop antes da entrada. "
            "Trade Master ensina setups no TradingView, não sinais de Telegram."
        ),
    },
    {
        "h": "Como explicar a um amigo",
        "body": (
            "Trading não é salário garantido. No spot você tem a moeda; no futuro você aposta direção com alavancagem. "
            "Risco 0,5–1% por trade, diário, sem grupos VIP. Mostre o gráfico BTC no TradingView — "
            "máxima e mínima de ontem já é aula gratuita."
        ),
    },
    {
        "h": "Próximos passos",
        "body": (
            "Três dias: dia 1 interface Binance; dia 2 comparar spot vs perp no TradingView; "
            "dia 3 marcar swing high/low no 15m sem operar. Não use alavancagem alta no primeiro dia."
        ),
    },
]

_L1_MARKETS = _m(
    "No Brasil, mais de 90% dos traders ativos usam Binance ou Bybit com PIX para USDT. "
    "Comece no spot; depois futuros USDT-M. Evite grupos de sinais VIP no Telegram — golpe comum na LATAM.",
    "En México muchos entran por P2P USDT y Mercado Pago. Binance y Bitso son comunes. "
    "Regla: educación sí, asesoría personalizada sin licencia no.",
    "В РФ основной путь — P2P USDT на Binance после KYC. Спот для старта, фьючерсы USDT-M для активной торговли. "
    "Не переводите крипту по ссылкам из «гарант-чатов».",
    "Trade Master teaches setup-first trading: plan before click, journal after every session.",
)

_LESSON1 = L(
    1, MOD_INTRO, "Beginner", 36, "market_balance", "BINANCE:BTCUSDT", "15", _L1_MARKETS,
    {
        "ru": {
            "title": "Вводное. С чего начать в трейдинге? Часть 1",
            "subtitle": "Кто такой трейдер, спот, фьючерсы, Binance, P2P, плечо, ликвидация",
            "outcome": "Поймёте роль трейдера, глубокую разницу спот/фьючерс, безопасный старт на Binance и механику ликвидации.",
            "content": "Трейдинг — работа с вероятностями и заранее ограниченным риском, а не казино и не «угадайка».",
            "takeaway": "Трейдер зарабатывает дисциплиной и повторяемыми сетапами; спот — для старта, фьючерс — только с планом и стопом.",
            "blocks": _L1_RU_BLOCKS,
            "market_title": "Ваш рынок",
            "chart_title": "Спот vs фьючерс USDT-M",
            "chart_cap": "Спот — монета на балансе. Фьючерс — контракт с плечом, шортом и риском ликвидации.",
            "tv_title": "Разбор: Binance + TradingView",
            "tv_body": (
                "Откройте BINANCE:BTCUSDT на 15m. Переключитесь мысленно между спот и perpetual: "
                "сравните цену и funding. Отметьте последний swing high и swing low — "
                "это базовые точки для стопов во всех следующих уроках."
            ),
            "practice_title": "Практика без риска",
            "practice_intro": "Выделите 30–40 минут. Только наблюдение и записи — без реальных сделок:",
            "practice_steps": [
                "Зарегистрируйтесь на Binance (или откройте paper TradingView), пройдите KYC и включите 2FA.",
                "Через P2P купите минимальную сумму USDT или используйте демо — переведите на Спот.",
                "Откройте BTC/USDT спот и BTC/USDT perpetual — сравните цену, funding rate и калькулятор ликвидации на фьючерсе.",
                "В TradingView нарисуйте горизонтали на вчерашнем high и low; запишите, где был бы стоп для лонга от low.",
                "В журнале зафиксируйте: тип счёта, размер депозита, целевой риск 0.5–1% на сделку, один открытый вопрос.",
            ],
            "example_title": "Разбор сценария: плечо и ликвидация",
            "example": (
                "Депозит 500 USDT на фьючерсном счёте. Открываете лонг ETH с плечом 10x, маржа 50 USDT, "
                "экспозиция как на 500 USDT. Цена ETH +2% — прибыль около +10% к марже (+5 USDT). "
                "Цена −2% — убыток −5 USDT (−10% маржи). Без стопа при резком −10% по ETH позиция ликвидируется — "
                "теряете маржу и комиссии. Тот же сценарий на споте: купили ETH на 500 USDT, −10% — "
                "остались с монетой минус 50 USDT, счёт не обнулён. Вывод: плечо — инструмент скорости, "
                "не «ускоритель богатства»; стоп и изолированная маржа обязательны."
            ),
            "bullets_title": "Запомнить",
            "bullets": [
                "Трейдинг = правила + вероятности, не одна удачная сделка",
                "Спот: монета на балансе, без ликвидации от плеча",
                "Фьючерс: лонг/шорт, плечо, funding, ликвидация",
                "P2P + KYC — стандартный безопасный путь пополнения",
                "Риск 0.5–1% депозита на сделку — цель с первого дня",
                "Стоп ставится до входа, не «когда станет больно»",
                "Trade Master учит сетапам в TradingView, не сигналам из чатов",
            ],
            "journal_title": "Запись в журнал",
            "journal_body": "После урока зафиксируйте три пункта — это начало дисциплины:",
            "journal_items": [
                "Биржа, тип счёта (спот/фьючерс) и размер депозита в USDT",
                "Целевой % риска на одну сделку (0.5 или 1%) и пример расчёта в USDT",
                "Один вопрос, который остался непонятным — принесите на следующий урок",
            ],
            "tip_title": "Совет профи",
            "tip": (
                "Пройдите KYC и P2P без сделок — сначала изучите интерфейс и калькулятор ликвидации. "
                "Конкуренты дают общую теорию; Trade Master связывает урок → график TradingView → журнал."
            ),
        },
        "en": {
            "title": "Intro: Where to start in trading? Part 1",
            "subtitle": "Trader role, spot vs futures deep dive, Binance, P2P, leverage, liquidation",
            "outcome": "Understand the trader's role, spot vs futures in depth, safe Binance onboarding, and liquidation mechanics.",
            "content": "Trading is probability work with defined risk — not a casino or guessing game.",
            "takeaway": "Traders earn through discipline and repeatable setups; start spot, add futures only with a plan and stop.",
            "blocks": _L1_EN_BLOCKS,
            "market_title": "Your market (Mexico / LATAM)",
            "chart_title": "Spot vs USDT-M futures",
            "chart_cap": "Spot = coin on balance. Futures = leveraged contract with short side and liquidation risk.",
            "tv_title": "TradingView: Binance BTC setup",
            "tv_body": "Open BINANCE:BTCUSDT 15m. Compare spot vs perpetual price and funding. Mark last swing high/low for stop practice.",
            "practice_title": "Hands-on practice",
            "practice_intro": "30–40 minutes observation only:",
            "practice_steps": [
                "Register Binance or TradingView paper; enable 2FA.",
                "Fund minimal USDT via P2P or demo; open Spot wallet.",
                "Compare BTC spot vs perpetual — note funding and liquidation calculator.",
                "Draw yesterday high/low on TradingView; write where your long stop would sit.",
                "Journal: account type, deposit, target 0.5–1% risk, one open question.",
            ],
            "example_title": "Scenario: leverage and liquidation",
            "example": (
                "500 USDT futures balance. 10x long ETH, 50 USDT margin, ~500 exposure. +2% ETH ≈ +10% on margin. "
                "−10% without stop = liquidation. Spot: same 500 buys ETH; −10% leaves coin, account not wiped. "
                "Leverage speeds outcomes — stops and isolated margin are mandatory."
            ),
            "bullets_title": "Remember",
            "bullets": [
                "Trading = rules + probabilities",
                "Spot = coin ownership, no leverage liquidation",
                "Futures = long/short + leverage + funding",
                "P2P + KYC for funding in LATAM",
                "Risk 0.5–1% per trade from day one",
                "Stop before entry, not after pain",
                "Trade Master teaches setups, not Telegram signals",
            ],
            "journal_title": "Trade journal",
            "journal_body": "Record after lesson:",
            "journal_items": [
                "Exchange, account type, deposit in USDT",
                "Target risk % and example in USDT",
                "One open question for next lesson",
            ],
            "tip_title": "Pro tip",
            "tip": "Explore UI and liquidation calculator before first trade. Finera teaches savings — we teach chart setups with TradingView.",
        },
        "pt": {
            "title": "Intro: Por onde começar no trading? Parte 1",
            "subtitle": "Trader, spot vs futuros, Binance, P2P, alavancagem, liquidação",
            "outcome": "Entenda o papel do trader, spot vs futuros em profundidade e liquidação.",
            "content": "Trading é trabalho com probabilidades e risco definido — não cassino.",
            "takeaway": "Traders ganham com disciplina; comece no spot, futuros só com plano e stop.",
            "blocks": _L1_PT_BLOCKS,
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Spot vs futuros USDT-M",
            "chart_cap": "Spot = posse da moeda. Futuros = contrato alavancado com risco de liquidação.",
            "tv_title": "TradingView: setup BTC Binance",
            "tv_body": "Abra BINANCE:BTCUSDT 15m. Compare spot vs perp e funding. Marque swing high/low.",
            "practice_title": "Prática guiada",
            "practice_intro": "30–40 minutos só observando:",
            "practice_steps": [
                "Cadastro Binance ou paper TV; ative 2FA.",
                "USDT mínimo via PIX/P2P ou demo.",
                "Compare BTC spot vs perpétuo.",
                "Desenhe high/low de ontem; anote stop do long.",
                "Diário: conta, depósito, risco 0,5–1%, uma dúvida.",
            ],
            "example_title": "Cenário: alavancagem",
            "example": (
                "500 USDT, long 10x ETH: +2% ≈ +10% na margem. −10% sem stop = liquidação. "
                "No spot a moeda permanece. Alavancagem acelera — stop obrigatório."
            ),
            "bullets_title": "Lembre",
            "bullets": [
                "Trading = regras + probabilidades",
                "Spot = moeda na carteira",
                "Futuros = long/short + alavancagem",
                "PIX + P2P no Brasil",
                "Risco 0,5–1% por trade",
                "Stop antes da entrada",
                "Trade Master ensina setups, não sinais",
            ],
            "journal_title": "Diário",
            "journal_body": "Registre após a lição:",
            "journal_items": [
                "Exchange, tipo de conta, depósito USDT",
                "% de risco alvo e exemplo em USDT",
                "Uma dúvida em aberto",
            ],
            "tip_title": "Dica profissional",
            "tip": "Explore a interface antes do primeiro trade. Finera foca finanças pessoais — nós focamos setups no TradingView.",
        },
    },
)

_L2_RU_BLOCKS = [{'h': 'Ордер — ваш единственный способ говорить с биржей', 'body': 'Биржа не читает мысли. Она видит только ордера — заявки на покупку или продажу по определённой цене и объёму. Лимитный ордер: вы говорите «куплю BTC по 67000 USDT, не дороже». Ордер попадает в стакан и ждёт, пока кто-то продаст по этой цене. Вы платите комиссию maker, если ваш ордер добавил ликвидность в книгу. Маркет-ордер: «купи сейчас по лучшей доступной цене». Вы забираете ликвидность из стакана — комиссия taker, обычно выше. Для новичка лимитка учит терпению и показывает спред. Маркет нужен, когда важна скорость, но на крупном объёме в тонком стакане маркет может исполниться на нескольких ценах — проскальзывание. Перед первой сделкой откройте историю ордеров и посмотрите, сколько USDT ушло на комиссии за неделю — сюрприз для многих.'}, {'h': 'Maker и taker: почему скальпер считает каждый базисный пункт', 'body': 'Maker — тот, кто «сделал» рынок, выставив заявку, которую исполнили. Taker — тот, кто «забрал» чужую заявку. На Binance Futures типично maker 0.02%, taker 0.04% — в два раза разница. Казалось бы, мелочь. Но скальпер делает пятьдесят сделок в день: 0.02% × 50 = 1% депозита только на комиссиях, если всё taker. Профессионал ставит лимитки там, где это безопасно, и маркетом входит только когда сетап требует скорости. VIP-уровни и BNB-скидка снижают комиссии — имеет смысл после стабильного объёма, не в первый день. Запомните: каждый лишний маркет-вход — налог на нетерпение.'}, {'h': 'Funding rate на фьючерсах — невидимая аренда позиции', 'body': 'Funding — перевод между лонгами и шортами каждые 8 часов на Binance. Если funding положительный, лонги платят шортам — рынок перегрет вверх. Отрицательный — шорты платят лонгам. Это не комиссия бирже напрямую, а балансировка цены фьючерса к споту. Держите лонг неделю при funding +0.01% три раза в день — это ~0.21% от позиции, может съесть тейк. Для внутридневной сделки funding чаще шум. Для свинга смотрите CoinGlass или вкладку funding на бирже перед входом. Аналогия: вы арендуете направление. Долго держите лонг в эйфории — платите «аренду» шортистам.'}, {'h': 'Терминалы Tiger.Trade и Vataga — зачем они скальперу', 'body': 'Веб-интерфейс Binance достаточен для обучения. Скальперу нужны горячие клавиши, кластерный объём, быстрый стакан, связка нескольких мониторов. Tiger.Trade и Vataga — популярные терминалы в СНГ, подключаются к Binance по API (только торговля, без вывода). Вы видите ленту сделок, плотности в стакане, можете закрыть позицию одной клавишей. Новичку терминал не обязателен первые недели — сначала поймите лимит/маркет на бирже. Потом, если выберете скальпинг, терминал сэкономит секунды, а секунды на 5m — деньги. TradingView остаётся для разметки старших таймфреймов; терминал — для исполнения.'}, {'h': 'Скальпинг vs свинг: два разных спорта', 'body': 'Скальпинг — сделки секунды–минуты, много комиссий, нужен стакан, низкая задержка, железная дисциплина. Свинг внутри дня — удержание часами, решения на 15m–1h, меньше сделок, больше времени на план. Позиционная торговля — дни–недели. Новичок ошибается, начиная со скальпинга «потому что быстрее деньги» — быстрее и слив при отсутствии опыта. Рекомендация курса: первые 20–30 сделок — свинг на 15m с риском 0.5%, полный журнал. Скальпинг — после уроков по стакану и амплитуде. Как нельзя бежать марафон, не научившись ходить.'}, {'h': 'Риск 0.5–1% на сделку — математика выживания', 'body': 'Риск на сделку — сколько USDT вы готовы потерять, если стоп сработает. Не размер позиции, а именно убыток. Депозит 1000 USDT, риск 1% = 10 USDT максимум на сделку. Стоп 0.5% от цены входа → размер позиции в 2 раза больше, чем при стопе 1% при том же риске в USDT. Формула: Размер = Риск_USDT / (Расстояние_стопа_в_% / 100). Десять убыточных сделок подряд при 1% риска — минус ~10% депозита, терпимо. Десять убытков по 10% — счёт почти уничтожен. Профессионалы редко рискуют больше 1% на одну идею. 0.5% — ещё мягче для обучения.'}, {'h': 'Первый депозит — учебный, не последние деньги', 'body': 'Сумма, которую потеряете без паники и без влияния на аренду и еду. Для кого-то 50 USDT, для кого-то 500 — честно с собой. Не берите кредит на трейдинг. Не «догоняйте» депозит после минуса. Учебный депозит покупает опыт и журнал, не Lamborghini. Когда статистика 50+ сделок с соблюдением правил положительная — можно обсуждать масштаб. До тех пор — микро-размер.'}, {'h': 'Как объяснить другу про ордера и риск', 'body': '«Лимитка — как заказ в ресторане: назвал цену, ждёшь. Маркет — съел что дали по меню сейчас, может быть дороже. На фьючерсе каждые 8 часов кто-то кому-то платит funding — как аренда за ставку на направление. Я рискую 1% счёта на сделку — десять плохих дней подряд не убьют меня. Скальпинг — как спринт, свинг — как пробежка в парке; я пока учусь бегать в парке.»'}, {'h': 'Связка Trade Master + TradingView + биржа', 'body': 'Урок даёт теорию. TradingView — разметка уровней и сценарий. Биржа — исполнение только по плану. Журнал связывает тройку: что планировали на графике, что нажали на бирже, что почувствовали. Finera и Coing не учат стакану и не ведут к практике на вашем графике — это разрыв, который закрывает Trade Master.'}, {'h': 'Чеклист перед первой реальной сделкой', 'body': '1) Сетап назван словами. 2) Вход, стоп, тейк записаны. 3) Размер посчитан из риска %. 4) Комиссия учтена. 5) Funding проверен, если держите >8ч. 6) Эмоция «жадность/страх/FOMO» — если да, пропуск. Нет пункта — нет клика. Следующий урок — амплитуда движения и ATR.'}]
_L2_EN_BLOCKS = [{'h': 'Limit vs market orders', 'body': 'A limit order waits at your price — you often pay maker fee and add liquidity. A market order fills immediately at best available prices — taker fee, possible slippage on size. Scalpers feel every basis point: 50 taker trades/day adds up. Use limits when safe; market only when speed matters. Check weekly fee total in order history — it surprises beginners.'}, {'h': 'Maker, taker, and funding', 'body': 'Maker posted liquidity; taker removed it. Futures funding transfers between longs and shorts every 8h to anchor perp to spot. Positive funding = longs pay. Intraday funding is noise; swing holds must account for it. View funding on exchange or CoinGlass before multi-day positions.'}, {'h': 'Tiger, Vataga, and terminals', 'body': 'Tiger.Trade and Vataga connect via trade-only API for fast book, tape, hotkeys — popular in CIS for scalping. Beginners can start on exchange web UI; add terminal after order-book lessons. TradingView for markup; terminal for execution speed.'}, {'h': 'Scalping vs swing and 0.5–1% risk', 'body': 'Scalping = seconds–minutes, high fee load, needs book skills. Swing intraday = hours on 15m–1h, fewer trades. Start swing 15m at 0.5% risk before scalping. Risk per trade = USDT lost if stop hits. Size = Risk / stop%. Ten losses at 1% ≈ −10% account — survivable. First deposit = tuition money only.'}, {'h': 'Plan before click', 'body': 'Checklist: named setup, entry/stop/target, sized from risk %, fees noted, funding if holding >8h, no FOMO. No checklist — no click. Trade Master links lesson → TradingView → journal.'}]
_L2_PT_BLOCKS = [{'h': 'Ordens limit e market', 'body': 'Limit espera seu preço — fee maker. Market executa agora — fee taker e slippage. Scalpers contam cada ponto de taxa. Use limit quando seguro.'}, {'h': 'Funding e terminais', 'body': 'Funding a cada 8h entre longs e shorts. Tiger.Trade e Vataga aceleram scalping com book e hotkeys. Iniciantes começam na interface da exchange.'}, {'h': 'Scalping vs swing', 'body': 'Scalping = segundos, muitas taxas. Swing = horas no 15m. Risco 0,5–1% por trade. Primeiro depósito = valor que pode perder.'}, {'h': 'Checklist', 'body': 'Setup, entrada/stop/alvo, tamanho pelo risco, sem FOMO. Trade Master liga lição → TradingView → diário.'}]

_LESSON2 = L(
    2, MOD_INTRO, "Beginner", 38, "order_flow", "BINANCE:BTCUSDT", "15",
    _m(
    "No Brasil, Tiger Trade e TradingView são padrão entre scalpers em Binance.",
    "En México muchos usan TradingView + Binance con P2P USDT.",
    "В РФ Tiger, Vataga, CScalp — стандарт для скальпа на Binance Futures.",
    "No Brasil, Tiger Trade e TradingView são padrão entre scalpers em Binance.",
),
    {
        "ru": {
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
        },
        "en": {
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
        },
        "pt": {
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
        },
    },
)


_LESSON3 = L(
    3, MOD_CHART, "Beginner", 34, "momentum", "BINANCE:BTCUSDT", "15",
    _m(
    "No Brasil aplique амплитуда движения em pares líquidos Binance como BTCUSDT.",
    "En México practique price amplitude en BTCUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например BTCUSDT.",
    "No Brasil aplique амплитуда движения em pares líquidos Binance como BTCUSDT.",
),
    {
        "ru": {
            "title": "Амплитуда движения",
            "subtitle": "ATR, процентные движения BTC vs альтов",
            "outcome": "Освоите «Амплитуда движения» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: atr, процентные движения btc vs альтов.",
            "takeaway": "Тема урока: Амплитуда движения — с дисциплиной и журналом.",
            "blocks": [{'h': 'Что такое амплитуда', 'body': 'Амплитуда — насколько далеко цена успела уехать за выбранное время, в процентах. Если BTC за час прошёл от минимума до максимума свечи 800 пунктов при цене 80000, это 1% — для биткоина на часовике уже заметно. Если PEPE за тот же час прошёл 8% — для мем-альта это обычный вторник. Новичок ставит одинаковый тейк 0.3% на BTC и на альте — на одном задыхается в шуме, на другом недобирает движение. Амплитуда отвечает на вопрос: «сколько рынок вообще ходит здесь?» Прежде чем искать вход, измерьте норму. Без этого стоп и тейк — случайные числа.'}, {'h': 'ATR простыми словами', 'body': 'ATR (Average True Range) — индикатор среднего диапазона свечи. Не направление, а «размах». Добавьте ATR(14) на 15m в TradingView. Значение 120 USDT на BTC при цене 67000 ≈ 0.18% за свечу 15m. Стоп уже этого — шум; стоп в 3×ATR — даёте место. Тейк 1×ATR — скромный скальп; 2–3×ATR — свинг внутри дня. ATR растёт на новостях и падает в «сонном» азиатском флэте. Пересчитывайте перед сессией.'}, {'h': 'BTC vs альты', 'body': 'В этом блоке разберём «BTC vs альты» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Плечо и амплитуда', 'body': 'В этом блоке разберём «Плечо и амплитуда» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Тейк под амплитуду', 'body': 'В этом блоке разберём «Тейк под амплитуду» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Как мерить на 15m', 'body': 'В этом блоке разберём «Как мерить на 15m» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Ошибки новичка', 'body': 'В этом блоке разберём «Ошибки новичка» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Практика ATR', 'body': 'В этом блоке разберём «Практика ATR» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте амплитуде и ATR. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Амплитуда движения",
            "chart_cap": "ATR, процентные движения BTC vs альтов.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:BTCUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На BTCUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Амплитуда движения', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Price amplitude",
            "subtitle": "ATR, процентные движения BTC vs альтов",
            "outcome": "Master 'Price amplitude' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on price amplitude.",
            "takeaway": "Topic: Price amplitude — with discipline and journal.",
            "blocks": [{'h': 'Что такое амплитуда', 'body': "This section covers 'Что такое амплитуда' for lesson 3. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'ATR простыми словами', 'body': "This section covers 'ATR простыми словами' for lesson 3. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'BTC vs альты', 'body': "This section covers 'BTC vs альты' for lesson 3. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Плечо и амплитуда', 'body': "This section covers 'Плечо и амплитуда' for lesson 3. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Тейк под амплитуду', 'body': "This section covers 'Тейк под амплитуду' for lesson 3. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Price amplitude",
            "chart_cap": "Price amplitude on BTCUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:BTCUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:BTCUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On BTCUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Price amplitude', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Amplitude de movimento",
            "subtitle": "ATR, процентные движения BTC vs альтов",
            "outcome": "Dominar 'Amplitude de movimento' com TradingView e prática.",
            "content": "Lição para iniciantes: amplitude de movimento.",
            "takeaway": "Tema: Amplitude de movimento — com disciplina.",
            "blocks": [{'h': 'Что такое амплитуда', 'body': "Esta seção aborda 'Что такое амплитуда' na lição 3. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'ATR простыми словами', 'body': "Esta seção aborda 'ATR простыми словами' na lição 3. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'BTC vs альты', 'body': "Esta seção aborda 'BTC vs альты' na lição 3. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Плечо и амплитуда', 'body': "Esta seção aborda 'Плечо и амплитуда' na lição 3. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Тейк под амплитуду', 'body': "Esta seção aborda 'Тейк под амплитуду' na lição 3. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Amplitude de movimento",
            "chart_cap": "Amplitude de movimento em BTCUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:BTCUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:BTCUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em BTCUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Amplitude de movimento', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON4 = L(
    4, MOD_CHART, "Beginner", 35, "support_resistance", "BINANCE:ETHUSDT", "15",
    _m(
    "No Brasil aplique поддержка по лоям em pares líquidos Binance como ETHUSDT.",
    "En México practique support by lows en ETHUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например ETHUSDT.",
    "No Brasil aplique поддержка по лоям em pares líquidos Binance como ETHUSDT.",
),
    {
        "ru": {
            "title": "Поддержка по лоям",
            "subtitle": "Свинг-лои, ложные пробои, сила уровня",
            "outcome": "Освоите «Поддержка по лоям» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: свинг-лои, ложные пробои, сила уровня.",
            "takeaway": "Тема урока: Поддержка по лоям — с дисциплиной и журналом.",
            "blocks": [{'h': 'Что такое лой', 'body': 'В этом блоке разберём «Что такое лой» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Как строить поддержку', 'body': 'В этом блоке разберём «Как строить поддержку» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Сила от касаний', 'body': 'В этом блоке разберём «Сила от касаний» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Ложный пробой', 'body': 'В этом блоке разберём «Ложный пробой» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Тени vs тела', 'body': 'В этом блоке разберём «Тени vs тела» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'ТФ 5m и 1h', 'body': 'В этом блоке разберём «ТФ 5m и 1h» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Вход у поддержки', 'body': 'В этом блоке разберём «Вход у поддержки» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Журнал уровней', 'body': 'В этом блоке разберём «Журнал уровней» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте поддержке по лоям. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Поддержка по лоям",
            "chart_cap": "Свинг-лои, ложные пробои, сила уровня.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:ETHUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:ETHUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На ETHUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Поддержка по лоям', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Support by lows",
            "subtitle": "Свинг-лои, ложные пробои, сила уровня",
            "outcome": "Master 'Support by lows' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on support by lows.",
            "takeaway": "Topic: Support by lows — with discipline and journal.",
            "blocks": [{'h': 'Что такое лой', 'body': "This section covers 'Что такое лой' for lesson 4. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Как строить поддержку', 'body': "This section covers 'Как строить поддержку' for lesson 4. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Сила от касаний', 'body': "This section covers 'Сила от касаний' for lesson 4. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Ложный пробой', 'body': "This section covers 'Ложный пробой' for lesson 4. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Тени vs тела', 'body': "This section covers 'Тени vs тела' for lesson 4. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Support by lows",
            "chart_cap": "Support by lows on ETHUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:ETHUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:ETHUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On ETHUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Support by lows', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Suporte pelos fundos",
            "subtitle": "Свинг-лои, ложные пробои, сила уровня",
            "outcome": "Dominar 'Suporte pelos fundos' com TradingView e prática.",
            "content": "Lição para iniciantes: suporte pelos fundos.",
            "takeaway": "Tema: Suporte pelos fundos — com disciplina.",
            "blocks": [{'h': 'Что такое лой', 'body': "Esta seção aborda 'Что такое лой' na lição 4. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Как строить поддержку', 'body': "Esta seção aborda 'Как строить поддержку' na lição 4. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Сила от касаний', 'body': "Esta seção aborda 'Сила от касаний' na lição 4. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Ложный пробой', 'body': "Esta seção aborda 'Ложный пробой' na lição 4. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Тени vs тела', 'body': "Esta seção aborda 'Тени vs тела' na lição 4. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Suporte pelos fundos",
            "chart_cap": "Suporte pelos fundos em ETHUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:ETHUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:ETHUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em ETHUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Suporte pelos fundos', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON5 = L(
    5, MOD_CHART, "Intermediate", 38, "order_flow", "BINANCE:BTCUSDT", "5",
    _m(
    "No Brasil aplique стакан. подробно em pares líquidos Binance como BTCUSDT.",
    "En México practique order book deep dive en BTCUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например BTCUSDT.",
    "No Brasil aplique стакан. подробно em pares líquidos Binance como BTCUSDT.",
),
    {
        "ru": {
            "title": "Стакан. Подробно",
            "subtitle": "Bid/ask, стены, спуфинг, лента",
            "outcome": "Освоите «Стакан. Подробно» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: bid/ask, стены, спуфинг, лента.",
            "takeaway": "Тема урока: Стакан. Подробно — с дисциплиной и журналом.",
            "blocks": [{'h': 'Стакан как базар', 'body': 'В этом блоке разберём «Стакан как базар» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Bid и ask', 'body': 'В этом блоке разберём «Bid и ask» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Спред', 'body': 'В этом блоке разберём «Спред» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Стены ликвидности', 'body': 'В этом блоке разберём «Стены ликвидности» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Спуфинг', 'body': 'В этом блоке разберём «Спуфинг» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Лента сделок', 'body': 'В этом блоке разберём «Лента сделок» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Стакан + график', 'body': 'В этом блоке разберём «Стакан + график» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Скальп читает книгу', 'body': 'В этом блоке разберём «Скальп читает книгу» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте стакане и ленте. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Стакан. Подробно",
            "chart_cap": "Bid/ask, стены, спуфинг, лента.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:BTCUSDT на 5m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 5m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На BTCUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Стакан. Подробно', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Order book deep dive",
            "subtitle": "Bid/ask, стены, спуфинг, лента",
            "outcome": "Master 'Order book deep dive' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on order book deep dive.",
            "takeaway": "Topic: Order book deep dive — with discipline and journal.",
            "blocks": [{'h': 'Стакан как базар', 'body': "This section covers 'Стакан как базар' for lesson 5. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Bid и ask', 'body': "This section covers 'Bid и ask' for lesson 5. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Спред', 'body': "This section covers 'Спред' for lesson 5. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Стены ликвидности', 'body': "This section covers 'Стены ликвидности' for lesson 5. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Спуфинг', 'body': "This section covers 'Спуфинг' for lesson 5. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Order book deep dive",
            "chart_cap": "Order book deep dive on BTCUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:BTCUSDT 5m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:BTCUSDT 5m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On BTCUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Order book deep dive', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Book de ofertas",
            "subtitle": "Bid/ask, стены, спуфинг, лента",
            "outcome": "Dominar 'Book de ofertas' com TradingView e prática.",
            "content": "Lição para iniciantes: book de ofertas.",
            "takeaway": "Tema: Book de ofertas — com disciplina.",
            "blocks": [{'h': 'Стакан как базар', 'body': "Esta seção aborda 'Стакан как базар' na lição 5. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Bid и ask', 'body': "Esta seção aborda 'Bid и ask' na lição 5. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Спред', 'body': "Esta seção aborda 'Спред' na lição 5. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Стены ликвидности', 'body': "Esta seção aborda 'Стены ликвидности' na lição 5. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Спуфинг', 'body': "Esta seção aborda 'Спуфинг' na lição 5. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Book de ofertas",
            "chart_cap": "Book de ofertas em BTCUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:BTCUSDT 5m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:BTCUSDT 5m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em BTCUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Book de ofertas', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON6 = L(
    6, MOD_CHART, "Intermediate", 33, "momentum", "BINANCE:BTCUSDT", "15",
    _m(
    "No Brasil aplique особенности быстрого и медленного рынка em pares líquidos Binance como BTCUSDT.",
    "En México practique fast vs slow market en BTCUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например BTCUSDT.",
    "No Brasil aplique особенности быстрого и медленного рынка em pares líquidos Binance como BTCUSDT.",
),
    {
        "ru": {
            "title": "Особенности быстрого и медленного рынка",
            "subtitle": "Волатильность, спред, фейки",
            "outcome": "Освоите «Особенности быстрого и медленного рынка» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: волатильность, спред, фейки.",
            "takeaway": "Тема урока: Особенности быстрого и медленного рынка — с дисциплиной и журналом.",
            "blocks": [{'h': 'Быстрый рынок', 'body': 'В этом блоке разберём «Быстрый рынок» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Медленный рынок', 'body': 'В этом блоке разберём «Медленный рынок» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Спред и проскальзывание', 'body': 'В этом блоке разберём «Спред и проскальзывание» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Когда уменьшать размер', 'body': 'В этом блоке разберём «Когда уменьшать размер» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Фейковые пробои в range', 'body': 'В этом блоке разберём «Фейковые пробои в range» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Сессии и скорость', 'body': 'В этом блоке разберём «Сессии и скорость» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Адаптация стопа', 'body': 'В этом блоке разберём «Адаптация стопа» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Чеклист режима', 'body': 'В этом блоке разберём «Чеклист режима» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте быстром и медленном рынке. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Особенности быстрого и медленного рынка",
            "chart_cap": "Волатильность, спред, фейки.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:BTCUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На BTCUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Особенности быстрого и медленного рынка', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Fast vs slow market",
            "subtitle": "Волатильность, спред, фейки",
            "outcome": "Master 'Fast vs slow market' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on fast vs slow market.",
            "takeaway": "Topic: Fast vs slow market — with discipline and journal.",
            "blocks": [{'h': 'Быстрый рынок', 'body': "This section covers 'Быстрый рынок' for lesson 6. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Медленный рынок', 'body': "This section covers 'Медленный рынок' for lesson 6. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Спред и проскальзывание', 'body': "This section covers 'Спред и проскальзывание' for lesson 6. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Когда уменьшать размер', 'body': "This section covers 'Когда уменьшать размер' for lesson 6. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Фейковые пробои в range', 'body': "This section covers 'Фейковые пробои в range' for lesson 6. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Fast vs slow market",
            "chart_cap": "Fast vs slow market on BTCUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:BTCUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:BTCUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On BTCUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Fast vs slow market', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Mercado rápido vs lento",
            "subtitle": "Волатильность, спред, фейки",
            "outcome": "Dominar 'Mercado rápido vs lento' com TradingView e prática.",
            "content": "Lição para iniciantes: mercado rápido vs lento.",
            "takeaway": "Tema: Mercado rápido vs lento — com disciplina.",
            "blocks": [{'h': 'Быстрый рынок', 'body': "Esta seção aborda 'Быстрый рынок' na lição 6. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Медленный рынок', 'body': "Esta seção aborda 'Медленный рынок' na lição 6. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Спред и проскальзывание', 'body': "Esta seção aborda 'Спред и проскальзывание' na lição 6. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Когда уменьшать размер', 'body': "Esta seção aborda 'Когда уменьшать размер' na lição 6. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Фейковые пробои в range', 'body': "Esta seção aborda 'Фейковые пробои в range' na lição 6. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Mercado rápido vs lento",
            "chart_cap": "Mercado rápido vs lento em BTCUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:BTCUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:BTCUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em BTCUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Mercado rápido vs lento', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON7 = L(
    7, MOD_RISK, "Beginner", 36, "risk_reward", "BINANCE:BTCUSDT", "15",
    _m(
    "No Brasil aplique основные ошибки новичков. часть 1 em pares líquidos Binance como BTCUSDT.",
    "En México practique beginner mistakes part 1 en BTCUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например BTCUSDT.",
    "No Brasil aplique основные ошибки новичков. часть 1 em pares líquidos Binance como BTCUSDT.",
),
    {
        "ru": {
            "title": "Основные ошибки новичков. Часть 1",
            "subtitle": "Без стопа, FOMO, all-in, сигналы",
            "outcome": "Освоите «Основные ошибки новичков. Часть 1» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: без стопа, fomo, all-in, сигналы.",
            "takeaway": "Тема урока: Основные ошибки новичков. Часть 1 — с дисциплиной и журналом.",
            "blocks": [{'h': 'Торговля без стопа', 'body': 'В этом блоке разберём «Торговля без стопа» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Весь депозит в одну монету', 'body': 'В этом блоке разберём «Весь депозит в одну монету» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'FOMO после пампа', 'body': 'В этом блоке разберём «FOMO после пампа» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Копирование чатов', 'body': 'В этом блоке разберём «Копирование чатов» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Overtrading', 'body': 'В этом блоке разберём «Overtrading» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Месть рынку', 'body': 'В этом блоке разберём «Месть рынку» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Как исправить', 'body': 'В этом блоке разберём «Как исправить» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Правило паузы', 'body': 'В этом блоке разберём «Правило паузы» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте типичных ошибках новичка. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Основные ошибки новичков. Часть 1",
            "chart_cap": "Без стопа, FOMO, all-in, сигналы.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:BTCUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На BTCUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Основные ошибки новичков. Часть 1', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Beginner mistakes Part 1",
            "subtitle": "Без стопа, FOMO, all-in, сигналы",
            "outcome": "Master 'Beginner mistakes Part 1' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on beginner mistakes part 1.",
            "takeaway": "Topic: Beginner mistakes Part 1 — with discipline and journal.",
            "blocks": [{'h': 'Торговля без стопа', 'body': "This section covers 'Торговля без стопа' for lesson 7. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Весь депозит в одну монету', 'body': "This section covers 'Весь депозит в одну монету' for lesson 7. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'FOMO после пампа', 'body': "This section covers 'FOMO после пампа' for lesson 7. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Копирование чатов', 'body': "This section covers 'Копирование чатов' for lesson 7. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Overtrading', 'body': "This section covers 'Overtrading' for lesson 7. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Beginner mistakes Part 1",
            "chart_cap": "Beginner mistakes Part 1 on BTCUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:BTCUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:BTCUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On BTCUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Beginner mistakes Part 1', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Erros de iniciante Parte 1",
            "subtitle": "Без стопа, FOMO, all-in, сигналы",
            "outcome": "Dominar 'Erros de iniciante Parte 1' com TradingView e prática.",
            "content": "Lição para iniciantes: erros de iniciante parte 1.",
            "takeaway": "Tema: Erros de iniciante Parte 1 — com disciplina.",
            "blocks": [{'h': 'Торговля без стопа', 'body': "Esta seção aborda 'Торговля без стопа' na lição 7. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Весь депозит в одну монету', 'body': "Esta seção aborda 'Весь депозит в одну монету' na lição 7. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'FOMO после пампа', 'body': "Esta seção aborda 'FOMO после пампа' na lição 7. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Копирование чатов', 'body': "Esta seção aborda 'Копирование чатов' na lição 7. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Overtrading', 'body': "Esta seção aborda 'Overtrading' na lição 7. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Erros de iniciante Parte 1",
            "chart_cap": "Erros de iniciante Parte 1 em BTCUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:BTCUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:BTCUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em BTCUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Erros de iniciante Parte 1', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON8 = L(
    8, MOD_PAT, "Intermediate", 34, "breakout", "BINANCE:SOLUSDT", "15",
    _m(
    "No Brasil aplique нисходящий треугольник em pares líquidos Binance como SOLUSDT.",
    "En México practique descending triangle en SOLUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например SOLUSDT.",
    "No Brasil aplique нисходящий треугольник em pares líquidos Binance como SOLUSDT.",
),
    {
        "ru": {
            "title": "Нисходящий треугольник",
            "subtitle": "Понижающиеся максимумы, пробой вниз",
            "outcome": "Освоите «Нисходящий треугольник» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: понижающиеся максимумы, пробой вниз.",
            "takeaway": "Тема урока: Нисходящий треугольник — с дисциплиной и журналом.",
            "blocks": [{'h': 'Форма паттерна', 'body': 'В этом блоке разберём «Форма паттерна» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Горизонтальная поддержка', 'body': 'В этом блоке разберём «Горизонтальная поддержка» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Lower highs', 'body': 'В этом блоке разберём «Lower highs» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объём на пробое', 'body': 'В этом блоке разберём «Объём на пробое» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Ложный пробой вверх', 'body': 'В этом блоке разберём «Ложный пробой вверх» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Вход и стоп', 'body': 'В этом блоке разберём «Вход и стоп» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Тейк по высоте', 'body': 'В этом блоке разберём «Тейк по высоте» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'SOL пример', 'body': 'В этом блоке разберём «SOL пример» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте нисходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Нисходящий треугольник",
            "chart_cap": "Понижающиеся максимумы, пробой вниз.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:SOLUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:SOLUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На SOLUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Нисходящий треугольник', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Descending triangle",
            "subtitle": "Понижающиеся максимумы, пробой вниз",
            "outcome": "Master 'Descending triangle' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on descending triangle.",
            "takeaway": "Topic: Descending triangle — with discipline and journal.",
            "blocks": [{'h': 'Форма паттерна', 'body': "This section covers 'Форма паттерна' for lesson 8. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Горизонтальная поддержка', 'body': "This section covers 'Горизонтальная поддержка' for lesson 8. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Lower highs', 'body': "This section covers 'Lower highs' for lesson 8. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Объём на пробое', 'body': "This section covers 'Объём на пробое' for lesson 8. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Ложный пробой вверх', 'body': "This section covers 'Ложный пробой вверх' for lesson 8. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Descending triangle",
            "chart_cap": "Descending triangle on SOLUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:SOLUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:SOLUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On SOLUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Descending triangle', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Triângulo descendente",
            "subtitle": "Понижающиеся максимумы, пробой вниз",
            "outcome": "Dominar 'Triângulo descendente' com TradingView e prática.",
            "content": "Lição para iniciantes: triângulo descendente.",
            "takeaway": "Tema: Triângulo descendente — com disciplina.",
            "blocks": [{'h': 'Форма паттерна', 'body': "Esta seção aborda 'Форма паттерна' na lição 8. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Горизонтальная поддержка', 'body': "Esta seção aborda 'Горизонтальная поддержка' na lição 8. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Lower highs', 'body': "Esta seção aborda 'Lower highs' na lição 8. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Объём на пробое', 'body': "Esta seção aborda 'Объём на пробое' na lição 8. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Ложный пробой вверх', 'body': "Esta seção aborda 'Ложный пробой вверх' na lição 8. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Triângulo descendente",
            "chart_cap": "Triângulo descendente em SOLUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:SOLUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:SOLUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em SOLUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Triângulo descendente', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON9 = L(
    9, MOD_PAT, "Intermediate", 34, "breakout", "BINANCE:SOLUSDT", "15",
    _m(
    "No Brasil aplique восходящий треугольник em pares líquidos Binance como SOLUSDT.",
    "En México practique ascending triangle en SOLUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например SOLUSDT.",
    "No Brasil aplique восходящий треугольник em pares líquidos Binance como SOLUSDT.",
),
    {
        "ru": {
            "title": "Восходящий треугольник",
            "subtitle": "Растущие минимумы, пробой вверх",
            "outcome": "Освоите «Восходящий треугольник» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: растущие минимумы, пробой вверх.",
            "takeaway": "Тема урока: Восходящий треугольник — с дисциплиной и журналом.",
            "blocks": [{'h': 'Форма паттерна', 'body': 'В этом блоке разберём «Форма паттерна» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Горизонтальное сопротивление', 'body': 'В этом блоке разберём «Горизонтальное сопротивление» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Higher lows', 'body': 'В этом блоке разберём «Higher lows» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Накопление покупателей', 'body': 'В этом блоке разберём «Накопление покупателей» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Пробой с объёмом', 'body': 'В этом блоке разберём «Пробой с объёмом» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Ретест', 'body': 'В этом блоке разберём «Ретест» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Стоп под треугольником', 'body': 'В этом блоке разберём «Стоп под треугольником» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'SOL пример', 'body': 'В этом блоке разберём «SOL пример» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте восходящем треугольнике. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Восходящий треугольник",
            "chart_cap": "Растущие минимумы, пробой вверх.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:SOLUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:SOLUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На SOLUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Восходящий треугольник', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Ascending triangle",
            "subtitle": "Растущие минимумы, пробой вверх",
            "outcome": "Master 'Ascending triangle' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on ascending triangle.",
            "takeaway": "Topic: Ascending triangle — with discipline and journal.",
            "blocks": [{'h': 'Форма паттерна', 'body': "This section covers 'Форма паттерна' for lesson 9. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Горизонтальное сопротивление', 'body': "This section covers 'Горизонтальное сопротивление' for lesson 9. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Higher lows', 'body': "This section covers 'Higher lows' for lesson 9. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Накопление покупателей', 'body': "This section covers 'Накопление покупателей' for lesson 9. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Пробой с объёмом', 'body': "This section covers 'Пробой с объёмом' for lesson 9. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Ascending triangle",
            "chart_cap": "Ascending triangle on SOLUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:SOLUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:SOLUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On SOLUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Ascending triangle', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Triângulo ascendente",
            "subtitle": "Растущие минимумы, пробой вверх",
            "outcome": "Dominar 'Triângulo ascendente' com TradingView e prática.",
            "content": "Lição para iniciantes: triângulo ascendente.",
            "takeaway": "Tema: Triângulo ascendente — com disciplina.",
            "blocks": [{'h': 'Форма паттерна', 'body': "Esta seção aborda 'Форма паттерна' na lição 9. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Горизонтальное сопротивление', 'body': "Esta seção aborda 'Горизонтальное сопротивление' na lição 9. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Higher lows', 'body': "Esta seção aborda 'Higher lows' na lição 9. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Накопление покупателей', 'body': "Esta seção aborda 'Накопление покупателей' na lição 9. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Пробой с объёмом', 'body': "Esta seção aborda 'Пробой с объёмом' na lição 9. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Triângulo ascendente",
            "chart_cap": "Triângulo ascendente em SOLUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:SOLUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:SOLUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em SOLUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Triângulo ascendente', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON10 = L(
    10, MOD_STR, "Intermediate", 37, "breakout", "BINANCE:ETHUSDT", "15",
    _m(
    "No Brasil aplique торговая стратегия для импульсов em pares líquidos Binance como ETHUSDT.",
    "En México practique impulse trading strategy en ETHUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например ETHUSDT.",
    "No Brasil aplique торговая стратегия для импульсов em pares líquidos Binance como ETHUSDT.",
),
    {
        "ru": {
            "title": "Торговая стратегия для импульсов",
            "subtitle": "Выход из range, ретест, объём",
            "outcome": "Освоите «Торговая стратегия для импульсов» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: выход из range, ретест, объём.",
            "takeaway": "Тема урока: Торговая стратегия для импульсов — с дисциплиной и журналом.",
            "blocks": [{'h': 'Что такое импульс', 'body': 'В этом блоке разберём «Что такое импульс» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Range перед выстрелом', 'body': 'В этом блоке разберём «Range перед выстрелом» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объём подтверждает', 'body': 'В этом блоке разберём «Объём подтверждает» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Вход на пробое', 'body': 'В этом блоке разберём «Вход на пробое» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Вход на ретесте', 'body': 'В этом блоке разберём «Вход на ретесте» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Стоп за range', 'body': 'В этом блоке разберём «Стоп за range» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Тейк по амплитуде', 'body': 'В этом блоке разберём «Тейк по амплитуде» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'ETH сценарий', 'body': 'В этом блоке разберём «ETH сценарий» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте торговле импульсов. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Торговая стратегия для импульсов",
            "chart_cap": "Выход из range, ретест, объём.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:ETHUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:ETHUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На ETHUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Торговая стратегия для импульсов', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Impulse trading strategy",
            "subtitle": "Выход из range, ретест, объём",
            "outcome": "Master 'Impulse trading strategy' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on impulse trading strategy.",
            "takeaway": "Topic: Impulse trading strategy — with discipline and journal.",
            "blocks": [{'h': 'Что такое импульс', 'body': "This section covers 'Что такое импульс' for lesson 10. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Range перед выстрелом', 'body': "This section covers 'Range перед выстрелом' for lesson 10. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Объём подтверждает', 'body': "This section covers 'Объём подтверждает' for lesson 10. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Вход на пробое', 'body': "This section covers 'Вход на пробое' for lesson 10. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Вход на ретесте', 'body': "This section covers 'Вход на ретесте' for lesson 10. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Impulse trading strategy",
            "chart_cap": "Impulse trading strategy on ETHUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:ETHUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:ETHUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On ETHUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Impulse trading strategy', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Estratégia para impulsos",
            "subtitle": "Выход из range, ретест, объём",
            "outcome": "Dominar 'Estratégia para impulsos' com TradingView e prática.",
            "content": "Lição para iniciantes: estratégia para impulsos.",
            "takeaway": "Tema: Estratégia para impulsos — com disciplina.",
            "blocks": [{'h': 'Что такое импульс', 'body': "Esta seção aborda 'Что такое импульс' na lição 10. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Range перед выстрелом', 'body': "Esta seção aborda 'Range перед выстрелом' na lição 10. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Объём подтверждает', 'body': "Esta seção aborda 'Объём подтверждает' na lição 10. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Вход на пробое', 'body': "Esta seção aborda 'Вход на пробое' na lição 10. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Вход на ретесте', 'body': "Esta seção aborda 'Вход на ретесте' na lição 10. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Estratégia para impulsos",
            "chart_cap": "Estratégia para impulsos em ETHUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:ETHUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:ETHUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em ETHUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Estratégia para impulsos', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON11 = L(
    11, MOD_MKT, "Beginner", 32, "price_chart", "BINANCE:PEPEUSDT", "15",
    _m(
    "No Brasil aplique делистинг монет с биржи em pares líquidos Binance como PEPEUSDT.",
    "En México practique delisting risk en PEPEUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например PEPEUSDT.",
    "No Brasil aplique делистинг монет с биржи em pares líquidos Binance como PEPEUSDT.",
),
    {
        "ru": {
            "title": "Делистинг монет с биржи",
            "subtitle": "Риск снятия пары, вывод, падение",
            "outcome": "Освоите «Делистинг монет с биржи» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: риск снятия пары, вывод, падение.",
            "takeaway": "Тема урока: Делистинг монет с биржи — с дисциплиной и журналом.",
            "blocks": [{'h': 'Что такое делистинг', 'body': 'В этом блоке разберём «Что такое делистинг» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Почему биржа снимает', 'body': 'В этом блоке разберём «Почему биржа снимает» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Таймлайн объявления', 'body': 'В этом блоке разберём «Таймлайн объявления» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Как выйти', 'body': 'В этом блоке разберём «Как выйти» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Падение до делистинга', 'body': 'В этом блоке разберём «Падение до делистинга» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'PEPE и мемы', 'body': 'В этом блоке разберём «PEPE и мемы» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Чеклист безопасности', 'body': 'В этом блоке разберём «Чеклист безопасности» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Альтернативы', 'body': 'В этом блоке разберём «Альтернативы» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте делистинге. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Делистинг монет с биржи",
            "chart_cap": "Риск снятия пары, вывод, падение.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:PEPEUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:PEPEUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На PEPEUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Делистинг монет с биржи', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "Delisting risk",
            "subtitle": "Риск снятия пары, вывод, падение",
            "outcome": "Master 'Delisting risk' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on delisting risk.",
            "takeaway": "Topic: Delisting risk — with discipline and journal.",
            "blocks": [{'h': 'Что такое делистинг', 'body': "This section covers 'Что такое делистинг' for lesson 11. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Почему биржа снимает', 'body': "This section covers 'Почему биржа снимает' for lesson 11. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Таймлайн объявления', 'body': "This section covers 'Таймлайн объявления' for lesson 11. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Как выйти', 'body': "This section covers 'Как выйти' for lesson 11. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Падение до делистинга', 'body': "This section covers 'Падение до делистинга' for lesson 11. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "Delisting risk",
            "chart_cap": "Delisting risk on PEPEUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:PEPEUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:PEPEUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On PEPEUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: Delisting risk', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Delisting de moedas",
            "subtitle": "Риск снятия пары, вывод, падение",
            "outcome": "Dominar 'Delisting de moedas' com TradingView e prática.",
            "content": "Lição para iniciantes: delisting de moedas.",
            "takeaway": "Tema: Delisting de moedas — com disciplina.",
            "blocks": [{'h': 'Что такое делистинг', 'body': "Esta seção aborda 'Что такое делистинг' na lição 11. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Почему биржа снимает', 'body': "Esta seção aborda 'Почему биржа снимает' na lição 11. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Таймлайн объявления', 'body': "Esta seção aborda 'Таймлайн объявления' na lição 11. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Как выйти', 'body': "Esta seção aborda 'Как выйти' na lição 11. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Падение до делистинга', 'body': "Esta seção aborda 'Падение до делистинга' na lição 11. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Delisting de moedas",
            "chart_cap": "Delisting de moedas em PEPEUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:PEPEUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:PEPEUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em PEPEUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Delisting de moedas', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


_LESSON12 = L(
    12, MOD_MKT, "Beginner", 33, "momentum", "BINANCE:ARBUSDT", "15",
    _m(
    "No Brasil aplique листинг em pares líquidos Binance como ARBUSDT.",
    "En México practique new listing en ARBUSDT con USDT.",
    "В РФ отрабатывайте на ликвидных парах Binance, например ARBUSDT.",
    "No Brasil aplique листинг em pares líquidos Binance como ARBUSDT.",
),
    {
        "ru": {
            "title": "Листинг",
            "subtitle": "Волатильность первых часов, размер, стоп",
            "outcome": "Освоите «Листинг» с разбором на графике и практикой в TradingView.",
            "content": "Урок для полных новичков: волатильность первых часов, размер, стоп.",
            "takeaway": "Тема урока: Листинг — с дисциплиной и журналом.",
            "blocks": [{'h': 'Что такое листинг', 'body': 'В этом блоке разберём «Что такое листинг» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Первые минуты торгов', 'body': 'В этом блоке разберём «Первые минуты торгов» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Памп и откат', 'body': 'В этом блоке разберём «Памп и откат» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Размер позиции', 'body': 'В этом блоке разберём «Размер позиции» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Стоп обязателен', 'body': 'В этом блоке разберём «Стоп обязателен» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'ARB как пример', 'body': 'В этом блоке разберём «ARB как пример» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Pre-market риск', 'body': 'В этом блоке разберём «Pre-market риск» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Объяснить другу', 'body': 'В этом блоке разберём «Объяснить другу» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'План на листинг', 'body': 'В этом блоке разберём «План на листинг» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}, {'h': 'Итог', 'body': 'В этом блоке разберём «Итог» в контексте листинге новых монет. Представьте, что вы объясняете другу без опыта: рынок — это аукцион, цена — результат сделок, а ваша задача — не угадать будущее, а действовать, когда заранее описанный сценарий совпал с реальностью. Профессионал записывает план до входа: где вход, где признание ошибки (стоп), где фиксация прибыли (тейк). Любитель ищет «верную монету». Разница в процессе, не в интеллекте. На графике отметьте последние swing points, измерьте расстояние в процентах — это ваша линейка для стопа и цели. Если расстояние до ближайшего уровня меньше планируемого стопа, сетап отменяется — не входите «потому что красиво». Журнал после каждого наблюдения: дата, пара, что увидели, что сделали бы, эмоция. Через двадцать записей появится закономерность — вы начнёте видеть повторяющиеся ситуации раньше, чем толпа. Trade Master связывает эту теорию с TradingView: не сухой текст, а разметка на живом графике BINANCE. Не торопитесь с плечом: сначала десять раз отработайте сценарий на бумаге, потом микро-размер.'}],
            "market_title": "Ваш рынок",
            "chart_title": "Листинг",
            "chart_cap": "Волатильность первых часов, размер, стоп.",
            "tv_title": "Разбор в TradingView",
            "tv_body": "Откройте BINANCE:ARBUSDT на 15m. Найдите пример темы урока за последние 7 дней. Отметьте вход, стоп и цель.",
            "practice_title": "Практика",
            "practice_intro": "30–40 минут. Без реальных сделок, если вы ещё на обучении:",
            "practice_steps": ['Откройте TradingView: BINANCE:ARBUSDT, таймфрейм 15m.', 'Разметьте ключевые уровни или индикатор из урока.', 'Опишите сценарий вход/стоп/тейк без клика на бирже.', 'Сделайте скрин с подписью уровней.', 'Запишите в журнал: сетап, R:R, эмоция до входа.'],
            "example_title": "Сценарий",
            "example": "На ARBUSDT примените правило урока: опишите, где был бы вход, стоп за уровнем, тейк с R:R минимум 1:2. Посчитайте риск 1% депозита. Без клика — только план и скрин.",
            "bullets_title": "Запомнить",
            "bullets": ['Тема урока: Листинг', 'План до клика — стоп и тейк записаны', 'Риск 0.5–1% депозита на сделку', 'TradingView + журнал после каждой сессии', 'Не сигналы — повторяемые сетапы', 'Измеряйте движение в % перед входом', 'Микро-размер пока учитесь'],
            "journal_title": "Журнал",
            "journal_body": "Запишите после практики:",
            "journal_items": ["Пара и таймфрейм", "Вход / стоп / цель и R:R", "Эмоция до входа"],
            "tip_title": "Совет профи",
            "tip": "Конкуренты не дают связку урок → TradingView → журнал. Вы проходите полный цикл на каждом занятии.",
        },
        "en": {
            "title": "New listing",
            "subtitle": "Волатильность первых часов, размер, стоп",
            "outcome": "Master 'New listing' with TradingView breakdown and practice.",
            "content": "Beginner-friendly lesson on new listing.",
            "takeaway": "Topic: New listing — with discipline and journal.",
            "blocks": [{'h': 'Что такое листинг', 'body': "This section covers 'Что такое листинг' for lesson 12. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Первые минуты торгов', 'body': "This section covers 'Первые минуты торгов' for lesson 12. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Памп и откат', 'body': "This section covers 'Памп и откат' for lesson 12. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Размер позиции', 'body': "This section covers 'Размер позиции' for lesson 12. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}, {'h': 'Стоп обязателен', 'body': "This section covers 'Стоп обязателен' for lesson 12. Markets auction price every second. Your edge is a written plan: entry, stop, target, risk 0.5–1%. Measure moves in % before sizing stops. On BTC, 1% hourly swings matter; on alts, 5–10% can be normal. Use TradingView on the lesson symbol, log observations, no FOMO entries. Trade Master links theory to chart practice — not signal groups."}],
            "market_title": "Your market (LATAM)",
            "chart_title": "New listing",
            "chart_cap": "New listing on ARBUSDT.",
            "tv_title": "TradingView breakdown",
            "tv_body": "Open BINANCE:ARBUSDT 15m. Find this week's example. Mark entry, stop, target.",
            "practice_title": "Practice",
            "practice_intro": "30–40 minutes:",
            "practice_steps": ['Open TradingView BINANCE:ARBUSDT 15m.', 'Mark key levels from the lesson.', 'Write entry/stop/target plan — no live click.', 'Screenshot with labels.', 'Journal: setup, R:R, emotion.'],
            "example_title": "Scenario",
            "example": "On ARBUSDT, apply the lesson rule with min 1:2 R:R and 1% risk plan — no click, screenshot only.",
            "bullets_title": "Remember",
            "bullets": ['Topic: New listing', 'Plan before click', 'Risk 0.5–1% per trade', 'TradingView + journal', 'Setups not signals', 'Measure % moves first', 'Small size while learning'],
            "journal_title": "Journal",
            "journal_body": "Record:",
            "journal_items": ["Pair & timeframe", "Entry / stop / target", "Emotion before entry"],
            "tip_title": "Pro tip",
            "tip": "Full loop: lesson → TradingView → journal. Not Telegram signals.",
        },
        "pt": {
            "title": "Listagem",
            "subtitle": "Волатильность первых часов, размер, стоп",
            "outcome": "Dominar 'Listagem' com TradingView e prática.",
            "content": "Lição para iniciantes: listagem.",
            "takeaway": "Tema: Listagem — com disciplina.",
            "blocks": [{'h': 'Что такое листинг', 'body': "Esta seção aborda 'Что такое листинг' na lição 12. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Первые минуты торгов', 'body': "Esta seção aborda 'Первые минуты торгов' na lição 12. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Памп и откат', 'body': "Esta seção aborda 'Памп и откат' na lição 12. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Размер позиции', 'body': "Esta seção aborda 'Размер позиции' na lição 12. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}, {'h': 'Стоп обязателен', 'body': "Esta seção aborda 'Стоп обязателен' na lição 12. Meça movimentos em % antes de definir stop e alvo. Risco 0,5–1% por trade. Use TradingView no símbolo da lição e registre no diário. Trade Master conecta teoria ao gráfico — não sinais de Telegram."}],
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Listagem",
            "chart_cap": "Listagem em ARBUSDT.",
            "tv_title": "Setup no TradingView",
            "tv_body": "Abra BINANCE:ARBUSDT 15m. Marque exemplo da semana.",
            "practice_title": "Prática",
            "practice_intro": "30–40 minutos:",
            "practice_steps": ['Abra TradingView BINANCE:ARBUSDT 15m.', 'Marque níveis da lição.', 'Plano entrada/stop/alvo sem clicar.', 'Print com legendas.', 'Diário: setup, R:R, emoção.'],
            "example_title": "Cenário",
            "example": "Em ARBUSDT, aplique a regra com R:R 1:2 e risco 1% — só plano.",
            "bullets_title": "Lembre",
            "bullets": ['Tema: Listagem', 'Plano antes do clique', 'Risco 0,5–1%', 'TradingView + diário', 'Setups não sinais', 'Meça % antes', 'Tamanho pequeno'],
            "journal_title": "Diário",
            "journal_body": "Registre:",
            "journal_items": ["Par e timeframe", "Entrada / stop / alvo", "Emoção antes da entrada"],
            "tip_title": "Dica profissional",
            "tip": "Ciclo completo: lição → TradingView → diário.",
        },
    },
)


LESSONS = [
    _LESSON1,
]
