# Deep curriculum — lessons 2-12 (RU lecture / EN+PT substantive)
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

# ─── Lesson 2 ───────────────────────────────────────────────────────────────

_LESSON2 = L(
    2, MOD_INTRO, 'Beginner', 38, 'order_flow', 'BINANCE:BTCUSDT', '15',
    {'br': 'No Brasil, Tiger Trade e TradingView são padrão entre scalpers em Binance.',
     'global': 'Trade Master: plan before click, journal after every session.',
     'mx': 'En México muchos usan TradingView + Binance con P2P USDT.',
     'ru': 'В РФ Tiger, Vataga, CScalp — стандарт для скальпа на Binance Futures.'},
    {'ru': {'title': 'Вводное. С чего начать в трейдинге? Часть 2',
            'subtitle': 'Лимит/маркет, maker/taker, funding, терминалы, скальпинг vs свинг, риск '
                        '0.5–1%',
            'outcome': 'Поймёте типы ордеров, комиссии, funding, терминалы Tiger/Vataga и расчёт риска '
                       'на сделку.',
            'content': 'Биржа понимает только ордера — научитесь говорить с ней на языке лимита, '
                       'маркета и процента риска.',
            'takeaway': 'Скальпинг требует терминал и низкую комиссию; новичку — свинг на 15m с риском '
                        '0.5–1%.',
            'blocks': [{'h': 'Ордер — ваш единственный способ говорить с биржей',
                        'body': 'Биржа не читает мысли и не видит вашу уверенность в росте. Она '
                                'сопоставляет только ордера —\n'
                                'заявки на покупку или продажу по цене и объёму. Лимитный ордер: '
                                '«куплю BTC по 67000 USDT, не дороже».\n'
                                'Заявка попадает в стакан и ждёт, пока продавец согласится. '
                                'Маркет-ордер: «купи сейчас по лучшей цене» —\n'
                                'исполнение мгновенное, но цена может пройти несколько уровней '
                                'стакана. Аналогия: лимитка — заказ блюда\n'
                                'по цене из меню с ожиданием; маркет — взял первое свободное блюдо с '
                                'полки, даже если дороже.\n'
                                'Новичок жмёт маркет из страха опоздать и платит спред плюс комиссию '
                                'taker. Профессионал знает,\n'
                                'зачем ему маркет: только когда сетап требует скорости, а потеря на '
                                'спреде меньше упущенного движения.\n'
                                'Откройте историю ордеров на Binance: статусы New, Partially Filled, '
                                'Filled, Canceled — это азбука.\n'
                                'Перед первой сделкой посмотрите справку по комиссиям и сравните '
                                'maker/taker для вашего VIP-уровня.\n'
                                '\n'
                                'Частичное исполнение лимитки — норма на крупном объёме: половина '
                                'позиции по 67000, половина ждёт. Новичок паникует и отменяет остаток '
                                'маркетом — снова taker fee. Проверяйте статус Partially Filled. OCO '
                                '(one-cancels-other) на Binance связывает тейк и стоп — изучите после '
                                'первых десяти сделок. Post-only лимитка гарантирует maker, но может '
                                'не исполниться — осознанный выбор скальпера.\n'
                                '\n'
                                'Перед первой сделкой недели перечитайте чеклист вслух. Звучит глупо — '
                                'работает. Если пункт «funding» непонятен — не держите позицию через '
                                '00:00 UTC в первую неделю. Учитесь по одному усложнению.'},
                       {'h': 'Maker и taker: почему скальпер считает каждый базисный пункт',
                        'body': 'Maker — тот, кто добавил ликвидность: выставил лимит, который кто-то '
                                'исполнил. Taker — забрал чужую заявку.\n'
                                'На Binance Futures ориентир: maker ~0.02%, taker ~0.04% — вдвое '
                                'дороже. Казалось бы, мелочь на одной сделке.\n'
                                'Скальпер делает пятьдесят сделок в день: если все taker, комиссии '
                                'съедают 1–2% депозита за неделю без учёта убытков.\n'
                                'Профессионал ставит лимит на вход там, где опоздание на один тик не '
                                'критично, и маркетом закрывает только при срочном выходе.\n'
                                'BNB для оплаты комиссий даёт скидку — включите после того, как поняли '
                                'базовые ставки, не в первый час.\n'
                                'VIP-уровни снижают fee при объёме — имеет смысл, когда торгуете '
                                'стабильно, а не «ради скидки».\n'
                                'Запомните: каждый лишний маркет-вход — налог на нетерпение. В журнале '
                                'заведите колонку «maker/taker» —\n'
                                'через месяц увидите, сколько edge уходит в комиссии.\n'
                                '\n'
                                'Скидка 25% на комиссии при оплате BNB — включите в настройках после '
                                'того, как посчитали базовую ставку без скидки. VIP0→VIP1 требует '
                                'объёма — не гонитесь; сначала дисциплина. Сравните неделю maker vs '
                                'taker в журнале: разница в USDT удивит. На споте комиссии ниже, чем '
                                'на фьючерсе — ещё один аргумент начать со спота.\n'
                                '\n'
                                'Связка: утром TradingView — уровни; днём биржа — лимитка по плану; '
                                'вечером журнал — что сделали и что пропустили. Finera не заменит этот '
                                'цикл. Один пропуск по чеклисту — не катастрофа; десять пропусков — '
                                'привычка игрока.'},
                       {'h': 'Funding rate — невидимая аренда позиции',
                        'body': 'Funding на perpetual Binance — перевод между лонгами и шортами каждые '
                                '8 часов (00:00, 08:00, 16:00 UTC).\n'
                                'Положительный funding: лонги платят шортам — рынок перегрет вверх '
                                'относительно спота. Отрицательный: шорты платят лонгам.\n'
                                'Это не прямая комиссия бирже, а механизм удержания цены фьючерса '
                                'рядом со спотом. Аналогия: вы арендуете «ставку\n'
                                'на направление». Держите лонг неделю при +0.01% три раза в день — '
                                'набегает ~0.21% от номинала позиции,\n'
                                'что может съесть половину скромного тейка. Внутридневщик часто '
                                'закрывается до funding. Свингер смотрит\n'
                                'вкладку Funding Rate на Binance или CoinGlass перед входом в '
                                'многодневный лонг в сильном апренде.\n'
                                'На шорте в панике funding может быть отрицательным — шорты платят, '
                                'что больно, но ожидаемо.\n'
                                'Для новичка: запишите в плане «держу ли через funding?» — если да, '
                                'посчитайте три платежа в USDT.\n'
                                '\n'
                                'Funding рассчитывается от номинала позиции, не от маржи. Лонг 5000 '
                                'USDT при марже 500 и funding +0.01% = 0.5 USDT за 8 часов. Мало? '
                                'Умножьте на 21 период в неделю. Шорт в медвежьем тренде с '
                                'отрицательным funding получает платежи — но не открывайте шорт «ради '
                                'funding» без сетапа на графике.\n'
                                '\n'
                                'Друг спросит про Tiger — ответ: «Это ускоритель кнопок, не '
                                'волшебство. Без стопа и плана терминал только быстрее сольёт.» '
                                'Покажите расчёт 1% риска на калькуляторе телефона — нагляднее слов.'},
                       {'h': 'Терминалы Tiger.Trade и Vataga — зачем они скальперу',
                        'body': 'Веб-интерфейс Binance достаточен для обучения лимиту, маркету и '
                                'стопу. Скальперу на 5m нужны горячие клавиши,\n'
                                'кластерный объём, быстрый стакан, лента сделок, связка нескольких '
                                'мониторов. Tiger.Trade и Vataga — популярные\n'
                                'терминалы в СНГ; подключаются к Binance по API только на торговлю, '
                                'без вывода. Вы видите плотности в стакане,\n'
                                'можете закрыть позицию одной клавишей, отменить все ордера мгновенно. '
                                'Новичку терминал не обязателен первые недели —\n'
                                'сначала поймите ордера на бирже и разметку на TradingView 15m. Потом, '
                                'если выберете скальпинг, терминал сэкономит\n'
                                'секунды, а на 5m секунды — деньги. Порядок обучения: биржа → '
                                'TradingView старший ТФ → стакан на 5m → терминал.\n'
                                'API-ключ: только trade, IP whitelist, без withdraw. Никому не '
                                'отдавайте ключ с правом вывода.\n'
                                'TradingView остаётся для плана; терминал — для исполнения по плану, '
                                'не вместо плана.\n'
                                '\n'
                                'Подключение Tiger: API key только Enable Reading + Enable Futures, IP '
                                'restrict. Vataga аналогично. Не ставьте терминал на VPS в другой '
                                'стране без причины — задержка убьёт скальп. Горячая клавиша «закрыть '
                                'всё» — тренируйте на демо. Терминал без журнала = быстрые ошибки.\n'
                                '\n'
                                'Эмоциональный тест депозита: представьте, что −20% за день. Если '
                                'мысль парализует — депозит велик. Уменьшите. Обучение на микро-сумме '
                                'честнее, чем «войду на 100 USDT и выучу». P2P минималка — нормальный '
                                'старт в РФ и Бразилии.'},
                       {'h': 'Скальпинг vs свинг: два разных спорта',
                        'body': 'Скальпинг — сделки от секунд до нескольких минут, много комиссий, '
                                'нужен стакан, низкая задержка, железная дисциплина.\n'
                                'Свинг внутри дня — удержание часами, решения на 15m–1h, меньше '
                                'сделок, больше времени на план и журнал.\n'
                                'Позиционная торговля — дни и недели. Новичок ошибается, начиная со '
                                'скальпинга «потому что быстрее деньги» —\n'
                                'быстрее и слив при отсутствии опыта чтения стакана и амплитуды. '
                                'Рекомендация курса: первые 20–30 сделок —\n'
                                'свинг на 15m с риском 0.5%, полный журнал, без терминала. Скальпинг — '
                                'после уроков по стакану, ленте и амплитуде.\n'
                                'Как нельзя бежать марафон, не научившись ходить. Скальпер '
                                'зарабатывает на маленьких движениях минус комиссии;\n'
                                'свингер — на более крупных свечах с меньшим числом кликов. Оба стиля '
                                'требуют стопа до входа.\n'
                                'Выберите один стиль на первый месяц и не переключайтесь из скуки — '
                                'иначе статистика в журнале бессмысленна.\n'
                                '\n'
                                'Свинг на 15m: три–пять сделок в неделю нормально. Скальп: тридцать в '
                                'день — другая психика. Оцените график работы и сон: скальп после '
                                'ночной смены — путь к overtrading. Выберите стиль под жизнь, не под '
                                'ролик на YouTube. Статистика свинга проще для журнала новичка.\n'
                                '\n'
                                'Пример SOL: депозит 800 USDT, риск 0.5% = 4 USDT. Стоп 1.2% → размер '
                                '≈ 333 USDT. То же 4 USDT риска при стопе 0.6% → размер 667 USDT — '
                                'вдвое больше контрактов, ближе ликвидация. Ужесточение стопа не '
                                'делает сделку «безопаснее» без уменьшения номинала.'},
                       {'h': 'Риск 0.5–1% на сделку — математика выживания',
                        'body': 'Риск на сделку — сколько USDT вы готовы потерять, если стоп '
                                'сработает. Не размер позиции, а именно убыток в деньгах.\n'
                                'Депозит 1000 USDT, риск 1% = 10 USDT максимум на одну идею. Формула: '
                                'Размер_номинала = Риск_USDT / (Стоп_в_% / 100).\n'
                                'Стоп 0.5% от цены → при том же риске в USDT позиция в 2 раза больше, '
                                'чем при стопе 1%. Ужесточили стоп —\n'
                                'купили больше контрактов — ликвидация ближе. Десять убыточных сделок '
                                'подряд при 1% риска — минус ~10% депозита,\n'
                                'терпимо для обучения. Десять убытков по 10% на сделку — счёт почти '
                                'уничтожен. Профессионалы редко рискуют больше 1%.\n'
                                '0.5% — мягче для первых пятидесяти сделок. Всегда считайте до клика: '
                                'запишите вход, стоп, риск %, размер в USDT.\n'
                                'Калькулятор на Binance покажет маржу и ликвидацию — сверьте со '
                                'стопом.\n'
                                '\n'
                                'Калькулятор Binance Futures: введите вход, стоп, плечо — увидите '
                                'ликвидацию. Если ликвидация между входом и стопом — математика '
                                'сломана. Уменьшите плечо или размер. Запишите формулу на бумажке и '
                                'повесьте рядом с монитором на первую неделю.\n'
                                '\n'
                                'Калькулятор Binance Futures: введите вход, стоп, плечо — увидите '
                                'ликвидацию. Если ликвидация между входом и стопом — математика '
                                'сломана. Уменьшите плечо или размер. Запишите формулу на бумажке и '
                                'повесьте рядом с монитором на первую неделю.'},
                       {'h': 'Пошаговый расчёт размера позиции',
                        'body': 'Пример на BINANCE:BTCUSDT. Депозит 1000 USDT, риск 1% = 10 USDT. Вход '
                                '67000, стоп 66330 (−1%).\n'
                                'Расстояние стопа 670 USDT / 67000 = 1%. Размер ≈ 10 / 0.01 = 1000 '
                                'USDT номинала. При плече 5x маржа ≈ 200 USDT.\n'
                                'Если стоп 66500 (−0.75%): размер ≈ 10 / 0.0075 ≈ 1333 USDT — больше '
                                'контрактов при том же риске в деньгах.\n'
                                'Если уменьшить риск до 0.5% = 5 USDT при стопе 1%: размер 500 USDT. '
                                'Три рычага: риск %, дистанция стопа, плечо.\n'
                                'Плечо не увеличивает допустимый риск в USDT — только сжимает маржу. '
                                'Ошибка новичка: «плечо 10x, значит рискую 10%» —\n'
                                'нет, риск % задаёте вы, плечо — сколько маржи заблокировать. Таблица '
                                'в блокноте: депозит, риск %, стоп %, размер.\n'
                                '\n'
                                'Пример SOL: депозит 800 USDT, риск 0.5% = 4 USDT. Стоп 1.2% → размер '
                                '≈ 333 USDT. То же 4 USDT риска при стопе 0.6% → размер 667 USDT — '
                                'вдвое больше контрактов, ближе ликвидация. Ужесточение стопа не '
                                'делает сделку «безопаснее» без уменьшения номинала.\n'
                                '\n'
                                'Свинг на 15m: три–пять сделок в неделю нормально. Скальп: тридцать в '
                                'день — другая психика. Оцените график работы и сон: скальп после '
                                'ночной смены — путь к overtrading. Выберите стиль под жизнь, не под '
                                'ролик на YouTube. Статистика свинга проще для журнала новичка.'},
                       {'h': 'Первый депозит — учебный, не последние деньги',
                        'body': 'Сумма, которую потеряете без паники и без влияния на аренду, еду и '
                                'долги. Для кого-то 50 USDT, для кого-то 500 —\n'
                                'честно с собой, не с инфлюенсером. Не берите кредит на трейдинг. Не '
                                '«догоняйте» депозит после минуса удвоением размера.\n'
                                'Учебный депозит покупает опыт, журнал и привычку стопа — не '
                                'Lamborghini. Когда статистика 50+ сделок с соблюдением\n'
                                'правил даёт понимание edge — можно обсуждать масштаб. До тех пор — '
                                'микро-размер. В РФ и LATAM пополнение через P2P\n'
                                'в escrow чате биржи; никогда по ссылке из Telegram. KYC и 2FA — до '
                                'первого USDT на счёте.\n'
                                'Разделите «кошелёк для жизни» и «кошелёк для обучения» ментально, '
                                'даже если физически один аккаунт.\n'
                                '\n'
                                'Эмоциональный тест депозита: представьте, что −20% за день. Если '
                                'мысль парализует — депозит велик. Уменьшите. Обучение на микро-сумме '
                                'честнее, чем «войду на 100 USDT и выучу». P2P минималка — нормальный '
                                'старт в РФ и Бразилии.\n'
                                '\n'
                                'Подключение Tiger: API key только Enable Reading + Enable Futures, IP '
                                'restrict. Vataga аналогично. Не ставьте терминал на VPS в другой '
                                'стране без причины — задержка убьёт скальп. Горячая клавиша «закрыть '
                                'всё» — тренируйте на демо. Терминал без журнала = быстрые ошибки.'},
                       {'h': 'Как объяснить другу про ордера и риск',
                        'body': 'Сценарий за кофе: «Лимитка — как заказ в ресторане: назвал цену, '
                                'ждёшь. Маркет — съел что дали по меню сейчас,\n'
                                'может быть дороже. На фьючерсе каждые 8 часов кто-то кому-то платит '
                                'funding — как аренда за ставку на направление.\n'
                                'Я рискую 1% счёта на сделку — десять плохих дней подряд не убьют '
                                'меня. Скальпинг — спринт, свинг — пробежка в парке;\n'
                                'я пока учусь бегать в парке на 15m. Tiger и Vataga — для спринта, '
                                'когда научусь читать стакан. Не лезу в чаты с 100x.»\n'
                                'Если друг спрашивает «сколько заработаешь» — честно: «Не знаю за '
                                'день. Знаю, сколько готов потерять на одной сделке.»\n'
                                'Покажите на телефоне спред bid/ask на BTC — это уже урок без денег.\n'
                                '\n'
                                'Друг спросит про Tiger — ответ: «Это ускоритель кнопок, не '
                                'волшебство. Без стопа и плана терминал только быстрее сольёт.» '
                                'Покажите расчёт 1% риска на калькуляторе телефона — нагляднее слов.\n'
                                '\n'
                                'Funding рассчитывается от номинала позиции, не от маржи. Лонг 5000 '
                                'USDT при марже 500 и funding +0.01% = 0.5 USDT за 8 часов. Мало? '
                                'Умножьте на 21 период в неделю. Шорт в медвежьем тренде с '
                                'отрицательным funding получает платежи — но не открывайте шорт «ради '
                                'funding» без сетапа на графике.'},
                       {'h': 'Связка Trade Master + TradingView + биржа',
                        'body': 'Урок даёт теорию. TradingView — разметка уровней и сценарий «если '
                                'цена сделает X». Биржа — исполнение только по плану.\n'
                                'Журнал связывает тройку: что планировали на графике, что нажали на '
                                'бирже, что почувствовали до и после.\n'
                                'Finera и похожие приложения учат копить; они не учат стакану и не '
                                'ведут к практике на вашем графике — разрыв,\n'
                                'который закрывает Trade Master. После этого урока откройте '
                                'BINANCE:BTCUSDT 5m, измерьте спред, посчитайте размер\n'
                                'при вашем депозите. Следующий урок — амплитуда и ATR: без них стоп и '
                                'тейк — случайные числа.\n'
                                '\n'
                                'Связка: утром TradingView — уровни; днём биржа — лимитка по плану; '
                                'вечером журнал — что сделали и что пропустили. Finera не заменит этот '
                                'цикл. Один пропуск по чеклисту — не катастрофа; десять пропусков — '
                                'привычка игрока.\n'
                                '\n'
                                'Скидка 25% на комиссии при оплате BNB — включите в настройках после '
                                'того, как посчитали базовую ставку без скидки. VIP0→VIP1 требует '
                                'объёма — не гонитесь; сначала дисциплина. Сравните неделю maker vs '
                                'taker в журнале: разница в USDT удивит. На споте комиссии ниже, чем '
                                'на фьючерсе — ещё один аргумент начать со спота.'},
                       {'h': 'Чеклист перед первой реальной сделкой',
                        'body': '1) Сетап назван словами (не «красиво выглядит»). 2) Вход, стоп, тейк '
                                'записаны в журнале. 3) Размер посчитан из риска %.\n'
                                '4) Комиссия maker/taker учтена. 5) Funding проверен, если держите '
                                'дольше 8 часов. 6) Эмоция «жадность/страх/FOMO» —\n'
                                'если да, пропуск. 7) Изолированная маржа, плечо не выше 3x на старте. '
                                'Нет пункта — нет клика.\n'
                                'Профессионал может пропустить десять сетапов в день; любитель торгует '
                                'скуку. Ваша цель на неделю — не прибыль,\n'
                                'а десять записей в журнале с полным планом, хотя бы половина без '
                                'клика (наблюдение). Дисциплина измеряется пропусками,\n'
                                'а не количеством сделок.\n'
                                '\n'
                                'Перед первой сделкой недели перечитайте чеклист вслух. Звучит глупо — '
                                'работает. Если пункт «funding» непонятен — не держите позицию через '
                                '00:00 UTC в первую неделю. Учитесь по одному усложнению.\n'
                                '\n'
                                'Частичное исполнение лимитки — норма на крупном объёме: половина '
                                'позиции по 67000, половина ждёт. Новичок паникует и отменяет остаток '
                                'маркетом — снова taker fee. Проверяйте статус Partially Filled. OCO '
                                '(one-cancels-other) на Binance связывает тейк и стоп — изучите после '
                                'первых десяти сделок. Post-only лимитка гарантирует maker, но может '
                                'не исполниться — осознанный выбор скальпера.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Ордера и комиссии',
            'chart_cap': 'Лимит добавляет ликвидность (maker). Маркет забирает (taker).',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:BTCUSDT 5m. Найдите спред bid/ask. Посчитайте размер при '
                       'стопе 0.8% и риске 1%.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'Депозит 1000 USDT, риск 1% = 10 USDT. Вход BTC 67000, стоп 66500 (−0.75%). '
                       'Размер ≈ 1333 USDT номинала. При плече 5x маржа ≈ 267 USDT.',
            'bullets_title': 'Запомнить',
            'bullets': ['Лимит = maker, маркет = taker',
                        'Funding каждые 8ч',
                        'Tiger/Vataga после базы',
                        'Свинг 15m первым',
                        'Риск 0.5–1%',
                        'Считайте размер до клика',
                        'Чеклист перед сделкой'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Спред BTC и funding',
                              'Пример расчёта размера',
                              'Скальп или свинг на месяц'],
            'tip_title': 'Совет профи',
            'tip': 'Не начинайте скальпинг без стакана — сначала 15m свинг. Trade Master + TradingView '
                   '= полный цикл.'},
     'en': {'title': 'Intro: Where to start? Part 2',
            'subtitle': 'Limit/market, maker/taker, funding, terminals, scalping vs swing, 0.5–1% risk',
            'outcome': 'Understand order types, fees, funding, Tiger/Vataga, and position sizing from '
                       'risk %.',
            'content': 'The exchange only sees orders — learn limit, market, and risk math.',
            'takeaway': 'Scalping needs terminal and low fees; beginners start swing 15m at 0.5–1% '
                        'risk.',
            'blocks': [{'h': 'Limit vs market orders',
                        'body': 'The exchange only sees orders — not your conviction. A limit order '
                                'waits at your price and often earns maker fee\n'
                                'by adding liquidity to the book. A market order fills immediately at '
                                'the best available prices — taker fee plus\n'
                                'possible slippage across multiple levels on size. Analogy: limit is '
                                'ordering a dish at a listed price and waiting;\n'
                                'market is grabbing whatever is on the counter now, maybe pricier. '
                                'Beginners hammer market from FOMO and pay spread\n'
                                'and double the fee. Pros use market only when speed matters more than '
                                'a few ticks of cost. Open order history on\n'
                                'Binance and learn statuses: New, Partially Filled, Filled, Canceled. '
                                'Check maker/taker rates for your VIP tier before\n'
                                'the first live click. Fifty taker scalps per day can cost 1–2% of '
                                'deposit weekly in fees alone — edge must exceed that tax.\n'
                                '\n'
                                'Partial fills are normal on size — check Partially Filled before '
                                'panic-canceling with market. OCO links take-profit and stop after '
                                "basics. Post-only forces maker but may miss — scalper's tradeoff."},
                       {'h': 'Maker, taker, and funding',
                        'body': 'Maker posted liquidity; taker removed it. On Binance Futures, maker '
                                '~0.02% and taker ~0.04% is a common baseline —\n'
                                'taker is twice as expensive. Funding on perpetuals transfers between '
                                'longs and shorts every eight hours to anchor\n'
                                'futures near spot. Positive funding means longs pay shorts — '
                                'overheated upside. Hold a long a week at +0.01% three\n'
                                'times daily and funding can erase a modest target. Intraday traders '
                                'often flat before funding; swing traders check\n'
                                'CoinGlass or the exchange tab before multi-day holds. Funding is rent '
                                'on directional exposure, not optional trivia.\n'
                                'Log whether your plan crosses a funding timestamp and estimate USDT '
                                'impact before entry.\n'
                                '\n'
                                'BNB fee discount and VIP tiers matter after you log baseline costs. '
                                'Compare one week of maker vs taker fees in USDT — the gap funds '
                                'education or leaks edge.'},
                       {'h': 'Tiger, Vataga, and execution terminals',
                        'body': 'Binance web UI is enough to learn limits, markets, and stops. '
                                'Scalpers on 5m need hotkeys, footprint clusters, fast\n'
                                'depth, and tape — Tiger.Trade and Vataga are popular in CIS, '
                                'connected via trade-only API without withdraw rights.\n'
                                'Beginners should master the exchange and TradingView 15m markup '
                                'before terminals. Order of learning: exchange →\n'
                                'higher timeframe plan → 5m book → terminal for execution speed. '
                                'TradingView plans; the terminal clicks — never the reverse.\n'
                                'API keys: trade permission only, IP whitelist, never share '
                                'withdraw-enabled keys. Terminals save seconds; without book\n'
                                'skills, faster clicks only accelerate losses.\n'
                                '\n'
                                'Funding uses notional, not margin. A 5000 USDT long pays on full '
                                '5000. Multiply by 21 periods per week on multi-day holds. Never open '
                                'shorts for funding alone without chart setup.'},
                       {'h': 'Scalping vs swing and 0.5–1% risk',
                        'body': 'Scalping is seconds to minutes, high fee load, mandatory book skills. '
                                'Intraday swing uses 15m–1h, fewer trades, more\n'
                                'planning time. Newbies who start scalping for «fast money» usually '
                                'donate to fees first. Course recommendation:\n'
                                'first twenty to thirty trades as 15m swing at 0.5% risk with full '
                                'journal, no terminal. Risk per trade is USDT lost\n'
                                'if stop hits — not position notional. Formula: Size = Risk_USDT / '
                                '(stop% / 100). Ten losses at 1% risk ≈ −10% account —\n'
                                'survivable. Ten losses at 10% per trade ends the account. First '
                                'deposit is tuition only — no loans, no revenge deposits.\n'
                                'Pick one style for month one and stick to it so journal stats mean '
                                'something.\n'
                                '\n'
                                'Tiger/Vataga: trade-only API, IP whitelist, practice flatten hotkey '
                                'on demo. Terminal without journal accelerates mistakes, not profits.'},
                       {'h': 'Position sizing walkthrough',
                        'body': 'Example on BINANCE:BTCUSDT. Deposit 1000 USDT, 1% risk = 10 USDT max '
                                'loss. Entry 67000, stop 66330 (−1%).\n'
                                'Notional size ≈ 10 / 0.01 = 1000 USDT. At 5x leverage margin ≈ 200 '
                                'USDT. Tighter stop 0.75% increases contracts\n'
                                'for the same dollar risk — liquidation moves closer. Leverage does '
                                'not increase allowed risk percent; it only\n'
                                'compresses margin blocked. Write a notebook table: deposit, risk %, '
                                'stop %, size, margin. Calculate before every click;\n'
                                'if liquidation sits inside your stop distance, reduce size or '
                                'leverage. BNB fee discount helps after you understand base rates.\n'
                                '\n'
                                'Swing 15m fits busy schedules; scalping needs sleep and focus. Pick '
                                'style for life, not for YouTube. Journal swing stats are kinder to '
                                'beginners.'},
                       {'h': 'Checklist and Trade Master loop',
                        'body': 'Name the setup in words. Log entry, stop, target. Size from risk '
                                'percent. Note maker/taker and funding if holding >8h.\n'
                                'Skip on FOMO, greed, or fear. Isolated margin, modest leverage for '
                                'beginners. No complete checklist — no click.\n'
                                'Trade Master links lesson → TradingView markup → journal; signal '
                                'groups skip the chart step. After this lesson open\n'
                                'BTCUSDT 5m, measure bid/ask spread, size a hypothetical trade at 1% '
                                'risk. Next lesson covers amplitude and ATR —\n'
                                'without measurement, stops and targets are random. Professionals skip '
                                'ten setups a day; amateurs trade boredom.\n'
                                '\n'
                                'Futures calculator must show liquidation beyond your stop — else fix '
                                'leverage or size. Tape the formula on paper week one.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:BTCUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Orders and fees',
            'chart_cap': 'Limit = maker. Market = taker.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:BTCUSDT 5m. Note spread. Size for 0.8% stop and 1% risk.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:BTCUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': '1000 USDT, 1% risk = 10 USDT. Entry 67000, stop 66500. Size ≈ 1333 USDT '
                       'notional at 5x.',
            'bullets_title': 'Remember',
            'bullets': ['Limit maker, market taker',
                        'Funding every 8h',
                        '15m swing first',
                        'Risk 0.5–1%',
                        'Size before click',
                        'Checklist mandatory',
                        'Journal every session'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Spread and funding', 'Size calc example', 'Scalp vs swing choice'],
            'tip_title': 'Pro tip',
            'tip': "Don't scalp without book skills — start 15m swing."},
     'pt': {'title': 'Intro: Por onde começar? Parte 2',
            'subtitle': 'Limit/market, maker/taker, funding, terminais, scalping vs swing',
            'outcome': 'Entenda ordens, taxas, funding e tamanho pela % de risco.',
            'content': 'A exchange só vê ordens — aprenda limit, market e risco.',
            'takeaway': 'Scalping precisa de terminal; iniciante começa swing 15m.',
            'blocks': [{'h': 'Ordens limit e market',
                        'body': 'A exchange só vê ordens. Limit espera seu preço e costuma pagar taxa '
                                'maker. Market executa agora como taker —\n'
                                'taxa maior e slippage em tamanho. Iniciantes usam market por FOMO; '
                                'profissionais usam market só quando velocidade\n'
                                'importa mais que alguns ticks. Cinquenta scalps taker por dia podem '
                                'custar 1–2% do depósito em taxas semanais.\n'
                                'Abra o histórico de ordens na Binance e aprenda os status antes do '
                                'primeiro clique real.\n'
                                '\n'
                                'Preenchimento parcial é normal — não cancele com market por pânico. '
                                'OCO liga take e stop depois do básico.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Maker, taker e funding',
                        'body': 'Maker adiciona liquidez; taker remove. No futuros Binance, taker '
                                'costuma o dobro do maker. Funding a cada 8h\n'
                                'transfere entre longs e shorts no perpétuo. Funding positivo: longs '
                                'pagam — mercado aquecido. Swing de vários dias\n'
                                'deve calcular funding antes da entrada. Intraday fecha antes do '
                                'horário de funding quando possível.\n'
                                '\n'
                                'Desconto BNB e taxas maker/taker — registre uma semana em USDT.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Tiger, Vataga e scalping vs swing',
                        'body': 'Interface web da Binance basta para aprender. Tiger.Trade e Vataga '
                                'aceleram scalping com book e hotkeys via API\n'
                                'só de trade. Iniciante: swing no 15m com risco 0,5% antes do '
                                'terminal. Scalping = segundos e muitas taxas;\n'
                                'swing = horas e menos cliques. Escolha um estilo no primeiro mês.\n'
                                '\n'
                                'Funding usa nocional. Multi-day long: calcule 21 períodos por '
                                'semana.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco 0,5–1% e tamanho',
                        'body': 'Risco = USDT perdido se o stop bater. Fórmula: Tamanho = Risco / '
                                'stop%. Depósito 1000, risco 1% = 10 USDT.\n'
                                'Dez stops seguidos a 1% ≈ −10% da conta — suportável. Primeiro '
                                'depósito = valor de treino, sem empréstimo.\n'
                                'Calcule tamanho antes do clique; alavancagem não aumenta o risco % '
                                'permitido.\n'
                                '\n'
                                'Tiger/Vataga: API só trade, whitelist IP. Terminal sem diário acelera '
                                'erros.'},
                       {'h': 'Checklist e ciclo Trade Master',
                        'body': 'Setup nomeado, entrada/stop/alvo, tamanho pelo risco, sem FOMO. Sem '
                                'checklist — sem clique.\n'
                                'Trade Master liga lição → TradingView → diário. Abra BTCUSDT 5m, meça '
                                'spread, planeje trade de 1% de risco sem clicar.\n'
                                'Próxima lição: amplitude e ATR.\n'
                                '\n'
                                'Swing 15m antes de scalping. Escolha estilo para sua vida.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:BTCUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Ordens e taxas',
            'chart_cap': 'Limit = maker. Market = taker.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BTCUSDT 5m. Veja spread. Calcule tamanho com risco 1%.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:BTCUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': '1000 USDT, risco 1% = 10 USDT. Stop 0,75% → ~1333 USDT nocional.',
            'bullets_title': 'Lembre',
            'bullets': ['Limit maker, market taker',
                        'Funding a cada 8h',
                        'Swing 15m primeiro',
                        'Risco 0,5–1%',
                        'Calcule antes do clique',
                        'Checklist',
                        'Diário'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Spread e funding', 'Exemplo de tamanho', 'Scalp ou swing'],
            'tip_title': 'Dica profissional',
            'tip': 'Não faça scalping sem book — comece 15m.'}},
)

# ─── Lesson 3 ───────────────────────────────────────────────────────────────

_LESSON3 = L(
    3, MOD_CHART, 'Beginner', 34, 'momentum', 'BINANCE:BTCUSDT', '15',
    {'br': 'No Brasil aplique amplitude em pares líquidos Binance como BTCUSDT.',
     'global': 'Measure range before every entry.',
     'mx': 'En México practique price amplitude en BTCUSDT con USDT.',
     'ru': 'В РФ отрабатывайте на ликвидных парах Binance, например BTCUSDT.'},
    {'ru': {'title': 'Амплитуда движения',
            'subtitle': 'ATR, процентные движения BTC vs альтов',
            'outcome': 'Научитесь измерять амплитуду и ATR до входа и подбирать стоп/тейк под BTC и '
                       'альты.',
            'content': 'Амплитуда — линейка рынка; без неё стоп и тейк случайны.',
            'takeaway': 'BTC и альты — разные шкалы; ATR(14) на 15m — ваш первый индикатор размера.',
            'blocks': [{'h': 'Что такое амплитуда движения',
                        'body': 'Амплитуда — насколько далеко цена прошла за выбранный период, в '
                                'процентах от цены. Откройте BINANCE:BTCUSDT 15m\n'
                                'и измерьте расстояние от минимума до максимума последней часовой '
                                'свечи. Если BTC при 80000 прошёл 800 пунктов —\n'
                                'это 1% за час, для биткоина уже заметно. На BINANCE:PEPEUSDT за тот '
                                'же час 8% — для мем-альта обычный вторник.\n'
                                'Новичок ставит тейк 0.3% на BTC и на альте одинаково: на одном '
                                'задыхается в шуме, на другом недобирает движение.\n'
                                'Амплитуда отвечает: «сколько рынок вообще ходит здесь?» Прежде чем '
                                'искать вход, измерьте норму за 20 последних свечей.\n'
                                'Запишите в журнал: пара, ТФ, средний range % — это линейка для стопа '
                                'и цели на неделю вперёд.\n'
                                '\n'
                                'Инструмент «линейка» в TradingView: выделите диапазон свечи — увидите '
                                '% в углу. Потренируйтесь на десяти свечах BTC подряд — глаз привыкнет '
                                'к 0.2% vs 1%. Без этой привычки ATR кажется абстракцией.\n'
                                '\n'
                                'Итог недели: перечитайте журнал измерений — какая пара чаще выбивала '
                                'по узкому стопу? Там увеличьте множитель ATR.\n'
                                '\n'
                                'Практика на BINANCE:BTCUSDT 15m: выделите двадцать свечей, посчитайте '
                                'средний range в процентах, добавьте ATR(14) и запишите в таблицу. '
                                'Сравните с BINANCE:SOLUSDT и BINANCE:PEPEUSDT в тот же день — '
                                'увидите, почему стоп 0.5% на PEPE выбивает чаще. Перед каждой сделкой '
                                'пересчитывайте ATR после новостей; вчерашнее значение в день FOMC '
                                'неактуально. Цель урока — привычка «сначала линейка, потом вход». Без '
                                'измерения вы платите спред и комиссию за лотерею.\n'
                                '\n'
                                'Практика на BINANCE:BTCUSDT 15m: выделите двадцать свечей, посчитайте '
                                'средний range в процентах, добавьте ATR(14) и запишите в таблицу. '
                                'Сравните с BINANCE:SOLUSDT и BINANCE:PEPEUSDT в тот же день — '
                                'увидите, почему стоп 0.5% на PEPE выбивает чаще. Перед каждой сделкой '
                                'пересчитывайте ATR после новостей; вчерашнее значение в день FOMC '
                                'неактуально. Цель урока — привычка «сначала линейка, потом вход». Без '
                                'измерения вы платите спред и комиссию за лотерею.\n'
                                '\n'
                                'Практика на BINANCE:BTCUSDT 15m: выделите двадцать свечей, посчитайте '
                                'средний range в процентах, добавьте ATR(14) и запишите в таблицу. '
                                'Сравните с BINANCE:SOLUSDT и BINANCE:PEPEUSDT в тот же день — '
                                'увидите, почему стоп 0.5% на PEPE выбивает чаще. Перед каждой сделкой '
                                'пересчитывайте ATR после новостей; вчерашнее значение в день FOMC '
                                'неактуально. Цель урока — привычка «сначала линейка, потом вход». Без '
                                'измерения вы платите спред и комиссию за лотерею.'},
                       {'h': 'ATR простыми словами',
                        'body': 'ATR (Average True Range) — средний размах свечи, не направление. '
                                'Добавьте ATR(14) на 15m в TradingView.\n'
                                'Значение 120 USDT на BTC при 67000 ≈ 0.18% за свечу 15m. Стоп уже ATR '
                                '— вас выбьет шумом; стоп в 2–3×ATR даёт место\n'
                                'для нормального дыхания цены. Тейк 1×ATR — скромный скальп внутри '
                                'свечи; 2–3×ATR — свинг внутри дня. ATR растёт\n'
                                'на новостях FOMC, CPI, на листингах — пересчитывайте перед сессией, '
                                'не используйте вчерашний ATR в день отчёта.\n'
                                'На альтах ATR в процентах выше — плечо и риск % должны быть ниже, чем '
                                'на BTC. ATR не говорит «куда» — только «как широко».\n'
                                '\n'
                                'True Range учитывает гэп от закрытия предыдущей свечи — ATR чуть '
                                'точнее простого high-low. На крипте 24/7 гэпы редки внутри дня, но на '
                                'открытии недели бывают. Сброс ATR после выходных — нормален.\n'
                                '\n'
                                'Размер и ATR: при расширении ATR после новости уменьшите номинал, '
                                'чтобы риск USDT не вырос. Та же формула урока 2, новый стоп%.\n'
                                '\n'
                                'BTC как компас: откройте 15m BTC перед любым альтом. Если BTC падает '
                                'ножом, лонг SOL или PEPE — контртренд с повышенным риском. Журнал: '
                                'колонка «BTC тренд 15m» рядом с каждой альт-идеей. Через месяц '
                                'увидите, сколько стопов пришлось из-за игнора контекста. Это '
                                'бесплатная статистика, если записывать честно.\n'
                                '\n'
                                'BTC как компас: откройте 15m BTC перед любым альтом. Если BTC падает '
                                'ножом, лонг SOL или PEPE — контртренд с повышенным риском. Журнал: '
                                'колонка «BTC тренд 15m» рядом с каждой альт-идеей. Через месяц '
                                'увидите, сколько стопов пришлось из-за игнора контекста. Это '
                                'бесплатная статистика, если записывать честно.'},
                       {'h': 'BTC vs альты: разные скорости одного рынка',
                        'body': 'BTC — локомотив: капитал сначала туда, меньше % амплитуда на 15m в '
                                'спокойный день (0.3–0.8% типично).\n'
                                'ETH, SOL — средний класс: 1–3% на 15m в активную сессию. PEPE, ARB — '
                                'высокая волатильность: 5–15% за сессию не редкость.\n'
                                'Альты часто двигаются с множителем к BTC: BTC +1%, SOL +2–3% в '
                                'альтсезон. Перед лонгом альты посмотрите BTCUSDT 15m —\n'
                                'если биткоин падает, альт редко спасёт ваш лонг. Не копируйте стоп '
                                '0.5% с BTC на PEPE: там шум шире, стоп сработает\n'
                                'на случайном тике. Правило курса: отдельная строка в журнале «BTC '
                                'контекст» перед каждой альт-сделкой.\n'
                                '\n'
                                'Корреляция: когда BTC падает 2% за час, SOL может −4%, PEPE −8%. '
                                'Множитель не постоянен — в альтсезоне альты растут быстрее. Таблица в '
                                'журнале: «BTC −1%, SOL ?%, PEPE ?%» в день события.\n'
                                '\n'
                                'Другу: «Сначала линейка, потом двери (уровни). Без линейки не знаешь, '
                                'дверь высокая или низкая.»\n'
                                '\n'
                                'Плечо на волатильной монете — ускоритель ликвидации, не прибыли. '
                                'Пример: ATR PEPE 3%, стоп 0.5% — вас выбьет на шуме; стоп 2% при '
                                'риске 1% USDT даёт меньший номинал — и это правильно. Калькулятор '
                                'Binance покажет ликвидацию — сверьте до Buy. Мемы: 2–3x или спот на '
                                'обучении.\n'
                                '\n'
                                'Плечо на волатильной монете — ускоритель ликвидации, не прибыли. '
                                'Пример: ATR PEPE 3%, стоп 0.5% — вас выбьет на шуме; стоп 2% при '
                                'риске 1% USDT даёт меньший номинал — и это правильно. Калькулятор '
                                'Binance покажет ликвидацию — сверьте до Buy. Мемы: 2–3x или спот на '
                                'обучении.'},
                       {'h': 'Плечо и амплитуда — почему мем с 20x убивает быстрее',
                        'body': 'Высокая амплитуда + высокое плечо = ликвидация от обычного шума. BTC '
                                '5x на 15m с стопом за 1.5×ATR — терпимо для обучения.\n'
                                'PEPE 20x с тем же стопом в % — ликвидация ближе, чем ваш план. '
                                'Формула та же: риск в USDT фиксирован, но волатильность\n'
                                'диктует ширину стопа, а ширина стопа диктует размер. На волатильном '
                                'активе при том же риске USDT позиция меньше в номинале,\n'
                                'но новичок увеличивает плечо «чтобы заработать больше» — и получает '
                                'margin call. Мемы и низколиквидные пары: 2–3x или спот.\n'
                                'Калькулятор ликвидации на Binance — обязательный шаг до Buy на '
                                'альте.\n'
                                '\n'
                                'Ликвидационный каскад на меме: ATR за минуты удваивается — ваш '
                                'вчерашний стоп уже не соответствует рынку. Пересчёт ATR перед каждой '
                                'сессией, не раз в месяц. В новости сидите в стороне или '
                                'микро-размер.\n'
                                '\n'
                                'Ошибка «ATR не смотрю, смотрю только уровни» — уровень на PEPE может '
                                'быть шире 5%, стоп 0.5% бессмысленен. Уровни и ATR вместе.\n'
                                '\n'
                                'Тейк-профит без привязки к range сессии создаёт иллюзию «почти в '
                                'плюсе». Измерьте типичный ход за 4 часа; тейк 0.3% на BTC в спокойный '
                                'день — достижим; на SOL в тот же день — мало. Частичная фиксация на '
                                '+1R снимает жадность. Запишите в плане: «тейк = X% = Y×ATR».\n'
                                '\n'
                                'Тейк-профит без привязки к range сессии создаёт иллюзию «почти в '
                                'плюсе». Измерьте типичный ход за 4 часа; тейк 0.3% на BTC в спокойный '
                                'день — достижим; на SOL в тот же день — мало. Частичная фиксация на '
                                '+1R снимает жадность. Запишите в плане: «тейк = X% = Y×ATR».'},
                       {'h': 'Тейк-профит под амплитуду сессии',
                        'body': 'Нереалистичный тейк — причина «всё время почти в плюсе, но в минусе». '
                                'Измерьте средний range последних 20 свечей 15m.\n'
                                'Тейк 0.5× сессионной амплитуды — консервативный скальп; 1–1.5× — '
                                'свинг внутри дня после сетапа. Жадность «5% за час без\n'
                                'новости» — не план, а лотерея. Если до ближайшего сопротивления '
                                'меньше планируемого тейка — цель режьте или сетап отменяйте.\n'
                                'Частичная фиксация на +1R снимает давление «всё или ничего». Запишите '
                                'в плане: «тейк основан на ATR/range = X%» — потом\n'
                                'сравните с фактом в журнале.\n'
                                '\n'
                                'Тейк 2×ATR на BTC 15m в спокойный день — реалистично. Тейк 0.3×ATR на '
                                'PEPE — возможно, но комиссии съедят. Считайте net после taker×2 + '
                                'spread.\n'
                                '\n'
                                'Практика: таблица Excel/блокнот — три пары, ATR%, range 20, ваш стоп '
                                'в ×ATR. Цель: стоп везде 1.5–3×ATR, не 0.5×ATR на волатильной '
                                'монете.\n'
                                '\n'
                                'Ошибка копирования стопов с BTC на альты — топ причина ранних стопов '
                                'у новичков. Таблица в журнале: пара, ATR%, стоп%, соотношение '
                                'стоп/ATR. Цель: стоп 1.5–3×ATR на каждой паре. Если соотношение <1 — '
                                'стоп слишком узкий.\n'
                                '\n'
                                'Ошибка копирования стопов с BTC на альты — топ причина ранних стопов '
                                'у новичков. Таблица в журнале: пара, ATR%, стоп%, соотношение '
                                'стоп/ATR. Цель: стоп 1.5–3×ATR на каждой паре. Если соотношение <1 — '
                                'стоп слишком узкий.'},
                       {'h': 'Практика измерения на 15m',
                        'body': 'Откройте BINANCE:BTCUSDT и BINANCE:SOLUSDT на 15m рядом. Для каждой: '
                                'high-low последних 20 свечей в %, ATR(14) в %.\n'
                                'Сравните со своим типичным стопом. Если стоп уже среднего range — вы '
                                'торгуете шум. Повторите для PEPEUSDT — увидите разницу\n'
                                'шкал. Сделайте скрин с подписями. Без сделки — только измерение. Это '
                                '20 минут, которые спасут депозит от случайных цифр.\n'
                                'Trade Master учит измерять до входа; сигнальные чаты дают «вход '
                                'сейчас» без линейки — отсюда разный результат через месяц.\n'
                                '\n'
                                'Практика: таблица Excel/блокнот — три пары, ATR%, range 20, ваш стоп '
                                'в ×ATR. Цель: стоп везде 1.5–3×ATR, не 0.5×ATR на волатильной '
                                'монете.\n'
                                '\n'
                                'Тейк 2×ATR на BTC 15m в спокойный день — реалистично. Тейк 0.3×ATR на '
                                'PEPE — возможно, но комиссии съедят. Считайте net после taker×2 + '
                                'spread.\n'
                                '\n'
                                'Другу без жаргона: «У биткоина шаг короче, у мема шире — сначала '
                                'меряем шаг свечи, потом ставим двери (уровни) и стопы». Покажите три '
                                'графика рядом — визуал убедительнее цифр.\n'
                                '\n'
                                'Другу без жаргона: «У биткоина шаг короче, у мема шире — сначала '
                                'меряем шаг свечи, потом ставим двери (уровни) и стопы». Покажите три '
                                'графика рядом — визуал убедительнее цифр.'},
                       {'h': 'Типичные ошибки новичка с амплитудой',
                        'body': 'Одинаковый тейк на все монеты. Игнор BTC при торговле альтом. Плечо '
                                'как на BTC на меме. Стоп «на глаз» без %.\n'
                                'Усреднение на падающем альте без пересчёта ATR. Торговля в первые '
                                'минуты листинга с размером как на BTC.\n'
                                'Исправление: таблица в журнале — пара, ATR%, средний range 20 свечей, '
                                'стоп %, тейк %, соотношение к ATR.\n'
                                'Через 30 записей увидите, где стопы слишком узкие.\n'
                                '\n'
                                'Ошибка «ATR не смотрю, смотрю только уровни» — уровень на PEPE может '
                                'быть шире 5%, стоп 0.5% бессмысленен. Уровни и ATR вместе.\n'
                                '\n'
                                'Ликвидационный каскад на меме: ATR за минуты удваивается — ваш '
                                'вчерашний стоп уже не соответствует рынку. Пересчёт ATR перед каждой '
                                'сессией, не раз в месяц. В новости сидите в стороне или '
                                'микро-размер.\n'
                                '\n'
                                'Связка с уроком 2: размер позиции из риска USDT не меняется; меняется '
                                'дистанция стопа из ATR. Широкий ATR → широкий стоп → меньше '
                                'контрактов. Не сужайте стоп на PEPE «чтобы влезло больше» — '
                                'математика против вас.\n'
                                '\n'
                                'Связка с уроком 2: размер позиции из риска USDT не меняется; меняется '
                                'дистанция стопа из ATR. Широкий ATR → широкий стоп → меньше '
                                'контрактов. Не сужайте стоп на PEPE «чтобы влезло больше» — '
                                'математика против вас.'},
                       {'h': 'Как объяснить другу про амплитуду',
                        'body': '«У биткоина одна скорость ходьбы, у дешёвой монеты — спринт. Сначала '
                                'меряем, сколько монета ходит за час, потом ставим\n'
                                'стоп и цель. ATR — средний шаг свечи. Если стоп меньше шага — нас '
                                'выкинет на случайном чихе рынка. Я не угадываю —\n'
                                'я подгоняю план под норму движения.» Покажите три графика: BTC, SOL, '
                                'PEPE — один ТФ, разная ширина свечей. Друг поймёт без формул.\n'
                                '\n'
                                'Другу: «Сначала линейка, потом двери (уровни). Без линейки не знаешь, '
                                'дверь высокая или низкая.»\n'
                                '\n'
                                'Корреляция: когда BTC падает 2% за час, SOL может −4%, PEPE −8%. '
                                'Множитель не постоянен — в альтсезоне альты растут быстрее. Таблица в '
                                'журнале: «BTC −1%, SOL ?%, PEPE ?%» в день события.\n'
                                '\n'
                                'Домашка: три пары, 15m, range 20 свечей + ATR в журнал без клика. '
                                'Следующий урок — поддержка по лоям на тех же свечах. Урок завершён, '
                                'когда вслух назовёте ATR% BTC.\n'
                                '\n'
                                'Домашка: три пары, 15m, range 20 свечей + ATR в журнал без клика. '
                                'Следующий урок — поддержка по лоям на тех же свечах. Урок завершён, '
                                'когда вслух назовёте ATR% BTC.'},
                       {'h': 'ATR, размер позиции и риск в USDT',
                        'body': 'Широкий ATR → шире стоп → меньше контрактов при том же риске USDT. '
                                'Пример: риск 10 USDT, стоп 0.5% на BTC — размер 2000 USDT.\n'
                                'На PEPE стоп 2% при том же риске — размер 500 USDT. Не сужайте стоп '
                                'на волатильной монете «чтобы влезло больше» —\n'
                                'вас выбьет. Либо уменьшите риск %, либо выберите менее волатильную '
                                'пару для обучения. ETHUSDT — хороший мост между BTC и альтами.\n'
                                '\n'
                                'Размер и ATR: при расширении ATR после новости уменьшите номинал, '
                                'чтобы риск USDT не вырос. Та же формула урока 2, новый стоп%.\n'
                                '\n'
                                'True Range учитывает гэп от закрытия предыдущей свечи — ATR чуть '
                                'точнее простого high-low. На крипте 24/7 гэпы редки внутри дня, но на '
                                'открытии недели бывают. Сброс ATR после выходных — нормален.\n'
                                '\n'
                                'Trade Master: теория без TradingView забывается. Скрин с ATR и range '
                                '— в папку журнала. Finera учит копить; мы учим измерять движение до '
                                'клика.\n'
                                '\n'
                                'Trade Master: теория без TradingView забывается. Скрин с ATR и range '
                                '— в папку журнала. Finera учит копить; мы учим измерять движение до '
                                'клика.'},
                       {'h': 'Итог: амплитуда до входа, журнал после',
                        'body': 'Амплитуда и ATR — не «для продвинутых», а базовая линейка новичка. '
                                'BTC и альты — разные шкалы; контекст BTC обязателен.\n'
                                'Следующий урок — поддержка по лоям: уровни строятся на тех же свечах, '
                                'которые вы уже умеете измерять. Домашка: три пары,\n'
                                '15m, range 20 свечей + ATR в журнал. Без клика на бирже. Когда '
                                'сможете вслух назвать ATR% для BTC — готовы к уровням.\n'
                                '\n'
                                'Итог недели: перечитайте журнал измерений — какая пара чаще выбивала '
                                'по узкому стопу? Там увеличьте множитель ATR.\n'
                                '\n'
                                'Инструмент «линейка» в TradingView: выделите диапазон свечи — увидите '
                                '% в углу. Потренируйтесь на десяти свечах BTC подряд — глаз привыкнет '
                                'к 0.2% vs 1%. Без этой привычки ATR кажется абстракцией.\n'
                                '\n'
                                'Итог недели: перечитайте журнал измерений. Какая пара чаще выбивала '
                                'по узкому стопу? Увеличьте множитель ATR там. Рынок 24/7 — не '
                                'торопитесь с плечом.\n'
                                '\n'
                                'Итог недели: перечитайте журнал измерений. Какая пара чаще выбивала '
                                'по узкому стопу? Увеличьте множитель ATR там. Рынок 24/7 — не '
                                'торопитесь с плечом.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Амплитуда и ATR',
            'chart_cap': 'Измерьте range 20 свечей и ATR перед каждым сетапом.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'BINANCE:BTCUSDT и SOLUSDT 15m: сравните range % и ATR. Запишите в журнал.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'BTC ATR 0.18% на 15m → стоп 0.5% ≈ 2.8×ATR. PEPE ATR 3% → тот же стоп в % '
                       'слишком узок; стоп 1.5% или меньше плечо.',
            'bullets_title': 'Запомнить',
            'bullets': ['Амплитуда в % до входа',
                        'ATR — ширина свечи',
                        'BTC контекст для альтов',
                        'Плечо ниже на мемах',
                        'Тейк под range',
                        'Журнал измерений',
                        'Не копируйте стопы'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['BTC/SOL/PEPE range 20 свечей',
                              'ATR% каждой пары',
                              'Стоп в единицах ATR'],
            'tip_title': 'Совет профи',
            'tip': 'Сначала измерение — потом кнопка Buy.'},
     'en': {'title': 'Price amplitude',
            'subtitle': 'ATR and BTC vs alts',
            'outcome': 'Measure amplitude and ATR before entries; size stops for each symbol.',
            'content': 'Amplitude is your market ruler — without it, stops are random.',
            'takeaway': 'BTC and alts use different scales; ATR(14) on 15m sizes risk.',
            'blocks': [{'h': 'What is price amplitude',
                        'body': 'Amplitude is how far price traveled in a period, as percent of price. '
                                'On BINANCE:BTCUSDT 15m, measure high-low of recent\n'
                                'candles — 1% per hour matters on BTC. On PEPE, 8% in an hour can be '
                                'normal. Newbies use identical targets on all symbols:\n'
                                'stopped out on noise on one, undercaptured on another. Measure the '
                                'last twenty candles before any entry. Log pair, timeframe,\n'
                                'average range % — your ruler for stops and targets. Without '
                                'measurement, stops and targets are random numbers dressed as '
                                'strategy.\n'
                                '\n'
                                'TradingView ruler on ten BTC candles trains eye for 0.2% vs 1% moves '
                                'before ATR feels abstract.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'ATR in plain language',
                        'body': 'ATR(14) is average candle range, not direction. On BTC 15m, a stop '
                                'tighter than ATR gets noise-stopped; 2–3× ATR gives room.\n'
                                'Targets at 1× ATR are modest scalps; 2–3× ATR suit intraday swings. '
                                'ATR expands on news days — recalculate before session.\n'
                                'On alts, ATR% is higher — use lower leverage and smaller risk '
                                'percent. ATR answers «how wide», not «which way».\n'
                                '\n'
                                'True Range includes gaps — rare intraday on crypto but Sunday opens '
                                'matter. Reset ATR after quiet weekends.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'BTC vs alts',
                        'body': 'BTC is the locomotive with smaller 15m % moves in calm sessions. ETH '
                                'and SOL sit in the middle; memes like PEPE swing 5–15%.\n'
                                'Alts often amplify BTC moves. Check BTCUSDT before alt longs — '
                                'falling BTC rarely saves your alt position. Do not copy BTC\n'
                                '0.5% stops to PEPE. Journal line: «BTC context» before every alt '
                                'trade. ARBUSDT and SOLUSDT teach amplitude faster than BTC alone.\n'
                                '\n'
                                'When BTC −2%/hour, SOL may −4%, PEPE −8%. Log multipliers on event '
                                'days.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Leverage, targets, and mistakes',
                        'body': 'High amplitude plus high leverage equals liquidation from normal '
                                'noise. Size from fixed USDT risk; wider stops mean smaller\n'
                                'notional. Partial take at +1R reduces all-or-nothing stress. Common '
                                'errors: same target everywhere, ignoring BTC, eyeball stops.\n'
                                'Fix with a table: pair, ATR%, range, stop%, target%. Explain to a '
                                'friend: «BTC walks, memes sprint — measure first.»\n'
                                'Practice: open BTC, SOL, PEPE on 15m, compare ranges — screenshot '
                                'without trading.\n'
                                '\n'
                                'Meme liquidation cascades double ATR in minutes — recalc each '
                                'session, sit out or micro-size news.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Sizing with ATR and lesson close',
                        'body': 'Wide ATR → wider stop → fewer contracts for same USDT risk. ETHUSDT '
                                'bridges BTC and alt volatility for learning.\n'
                                'Amplitude and ATR are beginner rulers, not advanced trivia. Next '
                                'lesson: support by swing lows on the same candles you measure.\n'
                                'Homework: three pairs, 15m, log twenty-candle range and ATR — no live '
                                'click until you can state BTC ATR% aloud.\n'
                                '\n'
                                '2×ATR target on calm BTC 15m is realistic; 0.3×ATR on PEPE may lose '
                                'to fees after taker round-trip.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:BTCUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Amplitude and ATR',
            'chart_cap': 'Log twenty-candle range and ATR per pair.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Compare BTCUSDT and SOLUSDT 15m ranges and ATR on TradingView.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:BTCUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'BTC 0.18% ATR vs PEPE 3% — same stop % means different noise tolerance.',
            'bullets_title': 'Remember',
            'bullets': ['Measure % range first',
                        'ATR for stop width',
                        'BTC context for alts',
                        'Lower leverage on memes',
                        'Targets fit range',
                        'Journal measurements',
                        'No copied stops'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Range on three pairs', 'ATR%', 'Stop as ATR multiple'],
            'tip_title': 'Pro tip',
            'tip': 'Measure before you click.'},
     'pt': {'title': 'Amplitude de movimento',
            'subtitle': 'ATR e BTC vs alts',
            'outcome': 'Meça amplitude e ATR antes de entrar.',
            'content': 'Amplitude é a régua do mercado.',
            'takeaway': 'BTC e alts têm escalas diferentes.',
            'blocks': [{'h': 'Amplitude de movimento',
                        'body': 'Amplitude é o quanto o preço andou no período, em %. BTC no 15m move '
                                'menos % que PEPE ou SOL. Meça as últimas 20 velas\n'
                                'antes de entrar. Sem medição, stop e alvo são chutes. Registre par, '
                                'timeframe e range médio no diário.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 3: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'ATR e BTC vs alts',
                        'body': 'ATR(14) mede a largura média da vela, não direção. Stop menor que ATR '
                                'sofre ruído. Em alts o ATR% é maior — menos alavancagem.\n'
                                'BTC é contexto obrigatório antes de long em alt. Não copie stop de '
                                'BTC para meme coin.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 3: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Alavancagem e alvos',
                        'body': 'Alta amplitude + alta alavancagem = liquidação rápida. Tamanho pelo '
                                'risco USDT fixo. Take parcial em +1R.\n'
                                'Erros: mesmo alvo em todas as moedas, ignorar BTC, stop no olho.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 3: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Prática e resumo',
                        'body': 'Abra BTC, SOL e PEPE no 15m; compare ranges e ATR. Print sem operar. '
                                'ETHUSDT é bom para treinar entre BTC e alts.\n'
                                'Próxima lição: suporte pelos fundos. Lição completa quando explicar '
                                'amplitude em dois minutos.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 3: pratique no símbolo da aula '
                                'sem clicar.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:BTCUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Amplitude e ATR',
            'chart_cap': 'Range de 20 velas + ATR.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Compare BTC e SOL no 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:BTCUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'ATR de PEPE exige stop mais largo ou menos alavancagem.',
            'bullets_title': 'Lembre',
            'bullets': ['Meça % antes',
                        'ATR guia stop',
                        'Contexto BTC',
                        'Menos alavanca em memes',
                        'Diário',
                        'Alvos realistas',
                        'Não copie stop'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Range 3 pares', 'ATR%', 'Stop em ATR'],
            'tip_title': 'Dica profissional',
            'tip': 'Meça antes do clique.'}},
)

# ─── Lesson 4 ───────────────────────────────────────────────────────────────

_LESSON4 = L(
    4, MOD_CHART, 'Beginner', 35, 'support_resistance', 'BINANCE:ETHUSDT', '15',
    {'br': 'No Brasil aplique suporte pelos fundos em ETHUSDT.',
     'global': 'Support zones, not penny lines.',
     'mx': 'En México practique support by lows en ETHUSDT.',
     'ru': 'В РФ отрабатывайте поддержку по лоям на ETHUSDT.'},
    {'ru': {'title': 'Поддержка по лоям',
            'subtitle': 'Свинг-лои, ложные пробои, сила уровня',
            'outcome': 'Построите поддержку по лоям, отличите ложный пробой и войдёте по сценарию.',
            'content': 'Поддержка — память цены, не магия; нужны касания и реакция.',
            'takeaway': '2+ лоя, зона не линия; ложный пробой — после закрытия свечи.',
            'blocks': [{'h': 'Что такое свинг-лой',
                        'body': 'Свинг-лой (swing low) — локальный минимум, после которого цена '
                                'отскочила вверх и сформировала новый мини-максимум.\n'
                                'На BINANCE:ETHUSDT 15m найдите три таких точки за последнюю неделю. '
                                'Не каждая длинная нижняя тень — лой: нужен отскок,\n'
                                'подтверждённый следующими свечами. Аналогия: пол в квартире, от '
                                'которого мяч несколько раз отпрыгнул вверх — не каждая царапина на '
                                'плитке.\n'
                                'Один лой — наблюдение. Два касания — идея уровня. Три и более — зона, '
                                'где рынок «помнит» цену. Новичок рисует двадцать линий\n'
                                'под каждой тенью; профессионал оставляет три–пять уровней на сессию. '
                                'Меньше линий — больше ясности в плане.\n'
                                '\n'
                                'Лой на старшем ТФ сильнее: лой на ETH 1h важнее лоя на 5m. Практика: '
                                'отметьте один 1h лой и проверьте, сколько раз 15m его уважал.\n'
                                '\n'
                                'Следующий урок стакан объяснит, кто стоит на bid у вашей поддержки — '
                                'связка уровень+стакан.\n'
                                '\n'
                                'Построение поддержки на BINANCE:ETHUSDT: найдите три лоя на 15m за '
                                'неделю, проведите зону, отметьте число касаний. Старший 1h лой важнее '
                                '5m тени. Единый стиль — тени или тела — на всём графике. Журнал: '
                                'дата, зона, касания, исход. Через месяц — статистика отскоков vs '
                                'пробоев.\n'
                                '\n'
                                'Построение поддержки на BINANCE:ETHUSDT: найдите три лоя на 15m за '
                                'неделю, проведите зону, отметьте число касаний. Старший 1h лой важнее '
                                '5m тени. Единый стиль — тени или тела — на всём графике. Журнал: '
                                'дата, зона, касания, исход. Через месяц — статистика отскоков vs '
                                'пробоев.\n'
                                '\n'
                                'Построение поддержки на BINANCE:ETHUSDT: найдите три лоя на 15m за '
                                'неделю, проведите зону, отметьте число касаний. Старший 1h лой важнее '
                                '5m тени. Единый стиль — тени или тела — на всём графике. Журнал: '
                                'дата, зона, касания, исход. Через месяц — статистика отскоков vs '
                                'пробоев.\n'
                                '\n'
                                'Построение поддержки на BINANCE:ETHUSDT: найдите три лоя на 15m за '
                                'неделю, проведите зону, отметьте число касаний. Старший 1h лой важнее '
                                '5m тени. Единый стиль — тени или тела — на всём графике. Журнал: '
                                'дата, зона, касания, исход. Через месяц — статистика отскоков vs '
                                'пробоев.\n'
                                '\n'
                                'Построение поддержки на BINANCE:ETHUSDT: найдите три лоя на 15m за '
                                'неделю, проведите зону, отметьте число касаний. Старший 1h лой важнее '
                                '5m тени. Единый стиль — тени или тела — на всём графике. Журнал: '
                                'дата, зона, касания, исход. Через месяц — статистика отскоков vs '
                                'пробоев.'},
                       {'h': 'Как строить поддержку по лоям',
                        'body': 'Алгоритм на 15m/1h: найдите три значимых лоя на одной высоте '
                                '±0.1–0.3% (зона, не копейка). Проведите горизонталь.\n'
                                'Решите единый стиль: по телам свечей или по экстремумам теней — и '
                                'держитесь его на всём графике. ETH часто уважает зоны\n'
                                'шире, чем BTC. Старший таймфрейм (1h) важнее младшего (5m): уровень с '
                                '1h сильнее, чем случайный лой на 5m.\n'
                                'Поддержка — не «магическая линия», а память рынка о цене, где '
                                'покупатели раньше входили. Когда цена подходит снова,\n'
                                'вопрос: покупатели снова появятся или уровень истощён? Журнал: дата '
                                'построения, число касаний, пара.\n'
                                '\n'
                                'Зона 2450–2455 vs линия 2452.3 — на бирже исполнение по рыночной '
                                'цене, не по вашей линии. Зона снижает ложные «промахи».\n'
                                '\n'
                                'Журнал уровней через месяц: какой % отскоков vs пробоев? Если 50/50 — '
                                'уровни строите верно, нужен фильтр входа.\n'
                                '\n'
                                'Ложный пробой: тень ниже уровня, закрытие выше — охота стопов. Вход '
                                'после закрытия 15m, не на первом тике. Стоп ниже экстремума ложного '
                                'пробоя с запасом 0.2–0.5% на ETH. Скрин в журнал каждого ложного '
                                'пробоя — учебный материал.\n'
                                '\n'
                                'Ложный пробой: тень ниже уровня, закрытие выше — охота стопов. Вход '
                                'после закрытия 15m, не на первом тике. Стоп ниже экстремума ложного '
                                'пробоя с запасом 0.2–0.5% на ETH. Скрин в журнал каждого ложного '
                                'пробоя — учебный материал.\n'
                                '\n'
                                'Ложный пробой: тень ниже уровня, закрытие выше — охота стопов. Вход '
                                'после закрытия 15m, не на первом тике. Стоп ниже экстремума ложного '
                                'пробоя с запасом 0.2–0.5% на ETH. Скрин в журнал каждого ложного '
                                'пробоя — учебный материал.\n'
                                '\n'
                                'Ложный пробой: тень ниже уровня, закрытие выше — охота стопов. Вход '
                                'после закрытия 15m, не на первом тике. Стоп ниже экстремума ложного '
                                'пробоя с запасом 0.2–0.5% на ETH. Скрин в журнал каждого ложного '
                                'пробоя — учебный материал.\n'
                                '\n'
                                'Ложный пробой: тень ниже уровня, закрытие выше — охота стопов. Вход '
                                'после закрытия 15m, не на первом тике. Стоп ниже экстремума ложного '
                                'пробоя с запасом 0.2–0.5% на ETH. Скрин в журнал каждого ложного '
                                'пробоя — учебный материал.'},
                       {'h': 'Сила уровня от числа касаний',
                        'body': 'Больше касаний — больше внимания трейдеров к уровню, но и больше шанс '
                                'пробоя: ликвидность под уровнем собирают стопы.\n'
                                'Первое касание после долгого роста — часто отскок. Пятое касание за '
                                'день — риск «протёртого» пола. Записывайте в журнал:\n'
                                '«касание №3 от уровня 2450 ETH». Со временем увидите, на каком '
                                'касании ваши планы чаще работают. Не входите только потому,\n'
                                'что «уровень есть» — нужен сценарий: отскок с реакцией свечи или '
                                'ложный пробой с закрытием обратно.\n'
                                '\n'
                                'Касание №4–5: часто перед пробоем. Не добавляйте к лонгу «потому что '
                                'уже четыре раза держало» без объёма и контекста BTC.\n'
                                '\n'
                                'Другу покажите ложный пробой на ETH — визуал учит лучше определения.\n'
                                '\n'
                                'Вход у поддержки требует реакции свечи и спокойного BTC. Без реакции '
                                '— ловля ножа. Лимитка у уровня — maker fee и контроль. R:R минимум '
                                '1:2. Риск 0.5–1% из урока 2.\n'
                                '\n'
                                'Вход у поддержки требует реакции свечи и спокойного BTC. Без реакции '
                                '— ловля ножа. Лимитка у уровня — maker fee и контроль. R:R минимум '
                                '1:2. Риск 0.5–1% из урока 2.\n'
                                '\n'
                                'Вход у поддержки требует реакции свечи и спокойного BTC. Без реакции '
                                '— ловля ножа. Лимитка у уровня — maker fee и контроль. R:R минимум '
                                '1:2. Риск 0.5–1% из урока 2.\n'
                                '\n'
                                'Вход у поддержки требует реакции свечи и спокойного BTC. Без реакции '
                                '— ловля ножа. Лимитка у уровня — maker fee и контроль. R:R минимум '
                                '1:2. Риск 0.5–1% из урока 2.\n'
                                '\n'
                                'Вход у поддержки требует реакции свечи и спокойного BTC. Без реакции '
                                '— ловля ножа. Лимитка у уровня — maker fee и контроль. R:R минимум '
                                '1:2. Риск 0.5–1% из урока 2.'},
                       {'h': 'Ложный пробой вниз — охота на стопы',
                        'body': 'Ложный пробой: цена уходит ниже поддержки тенью, но закрывается '
                                'обратно выше уровня. Классическая охота стопов лонгов,\n'
                                'стоящих ровно под лоем. Новичок ставит стоп на 1 тик ниже минимума — '
                                'его забирают перед разворотом. Профессионал ставит\n'
                                'стоп ниже экстремума ложного пробоя или ниже зоны с запасом 0.2–0.5% '
                                'на ETH 15m. Вход в лонг — после закрытия свечи обратно\n'
                                'над уровнем, не на первом тике вверх. На 5m ложных пробоев больше — '
                                'фильтруйте закрытием 15m. Скрин каждого ложного пробоя в журнал.\n'
                                '\n'
                                'Ложный пробой + объём: иногда объём на тени вниз высокий — стопы '
                                'собрали, потом откуп. Ждите закрытие, не ловите дно тени.\n'
                                '\n'
                                'Лимитка на покупку у поддержки: иногда не исполнится — цена '
                                'развернулась выше. Это не ошибка; ошибка — маркет в панике.\n'
                                '\n'
                                'Таймфреймы: 1h зона, 15m триггер, 5m тайминг. Не рисуйте 20 линий на '
                                '5m. Максимум 3–5 уровней на сессию.\n'
                                '\n'
                                'Таймфреймы: 1h зона, 15m триггер, 5m тайминг. Не рисуйте 20 линий на '
                                '5m. Максимум 3–5 уровней на сессию.\n'
                                '\n'
                                'Таймфреймы: 1h зона, 15m триггер, 5m тайминг. Не рисуйте 20 линий на '
                                '5m. Максимум 3–5 уровней на сессию.\n'
                                '\n'
                                'Таймфреймы: 1h зона, 15m триггер, 5m тайминг. Не рисуйте 20 линий на '
                                '5m. Максимум 3–5 уровней на сессию.\n'
                                '\n'
                                'Таймфреймы: 1h зона, 15m триггер, 5m тайминг. Не рисуйте 20 линий на '
                                '5m. Максимум 3–5 уровней на сессию.'},
                       {'h': 'Тени vs тела — единый стиль разметки',
                        'body': 'Если строите по теням — стопы и касания считайте по теням. Если по '
                                'телам — не смешивайте. Смешение даёт «уровень, который\n'
                                'сам себе противоречит». На волатильных альтах тени длиннее — зона '
                                'шире. BTC на 15m часто аккуратнее. Сравните BINANCE:ETHUSDT\n'
                                'и BINANCE:BTCUSDT на одном участке: у ETH зоны поддержки визуально '
                                'толще. Это не ошибка — это характер инструмента.\n'
                                'Перед сделкой спросите: «Мой стоп согласован со стилем линии?»\n'
                                '\n'
                                'Тела свечей при флэте, тени при волатильности — гибкость без смены '
                                'стиля каждую свечу.\n'
                                '\n'
                                '5m для входа после сигнала 15m — ок. 5m для «найти поддержку с нуля» '
                                '— шум.\n'
                                '\n'
                                'Пробитая поддержка часто становится сопротивлением при ретесте — '
                                'запишите для будущих уроков. Обновляйте уровни еженедельно.\n'
                                '\n'
                                'Пробитая поддержка часто становится сопротивлением при ретесте — '
                                'запишите для будущих уроков. Обновляйте уровни еженедельно.\n'
                                '\n'
                                'Пробитая поддержка часто становится сопротивлением при ретесте — '
                                'запишите для будущих уроков. Обновляйте уровни еженедельно.\n'
                                '\n'
                                'Пробитая поддержка часто становится сопротивлением при ретесте — '
                                'запишите для будущих уроков. Обновляйте уровни еженедельно.\n'
                                '\n'
                                'Пробитая поддержка часто становится сопротивлением при ретесте — '
                                'запишите для будущих уроков. Обновляйте уровни еженедельно.'},
                       {'h': 'Таймфреймы 5m и 1h — иерархия',
                        'body': 'План на 1h: где главная поддержка недели. Триггер на 15m: реакция у '
                                'уровня. 5m — точность входа, не место для поиска «новых»\n'
                                'уровней с нуля. Ошибка: нарисовать поддержку на 5m и игнорировать, '
                                'что на 1h цена в пустоте. Правило: старший ТФ задаёт\n'
                                'зону, младший — тайминг. Если на 1h уровень далеко — на 5m скальп к '
                                'этой поддержке может быть ранним.\n'
                                '\n'
                                '5m для входа после сигнала 15m — ок. 5m для «найти поддержку с нуля» '
                                '— шум.\n'
                                '\n'
                                'Тела свечей при флэте, тени при волатильности — гибкость без смены '
                                'стиля каждую свечу.\n'
                                '\n'
                                'Другу: «Пол, от которого мяч отскакивал. Ложный пробой — прокатился '
                                'под плинтус и вернулся». Покажите ETH график.\n'
                                '\n'
                                'Другу: «Пол, от которого мяч отскакивал. Ложный пробой — прокатился '
                                'под плинтус и вернулся». Покажите ETH график.\n'
                                '\n'
                                'Другу: «Пол, от которого мяч отскакивал. Ложный пробой — прокатился '
                                'под плинтус и вернулся». Покажите ETH график.\n'
                                '\n'
                                'Другу: «Пол, от которого мяч отскакивал. Ложный пробой — прокатился '
                                'под плинтус и вернулся». Покажите ETH график.\n'
                                '\n'
                                'Другу: «Пол, от которого мяч отскакивал. Ложный пробой — прокатился '
                                'под плинтус и вернулся». Покажите ETH график.'},
                       {'h': 'Вход у поддержки — сценарий, не надежда',
                        'body': 'Минимум: уровень + реакция (пин-бар, поглощение, сужение range) + BTC '
                                'не падает ножом. Стоп ниже зоны, не внутри неё.\n'
                                'Тейк минимум 1:2 к риску или у ближайшего сопротивления. Без реакции '
                                'свечи — это «ловля падающего ножа», не трейдинг уровня.\n'
                                'Риск 0.5–1% депозита, размер из формулы урока 2. Лимитный вход у '
                                'уровня предпочтительнее маркета — maker fee и контроль цены.\n'
                                '\n'
                                'Лимитка на покупку у поддержки: иногда не исполнится — цена '
                                'развернулась выше. Это не ошибка; ошибка — маркет в панике.\n'
                                '\n'
                                'Ложный пробой + объём: иногда объём на тени вниз высокий — стопы '
                                'собрали, потом откуп. Ждите закрытие, не ловите дно тени.\n'
                                '\n'
                                'Ошибки: один лой, лонг без стопа, стоп под каждой 5m тенью. '
                                'Исправление: терпение и закрытие свечи.\n'
                                '\n'
                                'Ошибки: один лой, лонг без стопа, стоп под каждой 5m тенью. '
                                'Исправление: терпение и закрытие свечи.\n'
                                '\n'
                                'Ошибки: один лой, лонг без стопа, стоп под каждой 5m тенью. '
                                'Исправление: терпение и закрытие свечи.\n'
                                '\n'
                                'Ошибки: один лой, лонг без стопа, стоп под каждой 5m тенью. '
                                'Исправление: терпение и закрытие свечи.\n'
                                '\n'
                                'Ошибки: один лой, лонг без стопа, стоп под каждой 5m тенью. '
                                'Исправление: терпение и закрытие свечи.'},
                       {'h': 'Как объяснить другу про поддержку',
                        'body': '«Представь пол, от которого мяч три раза отскочил. Ложный пробой — '
                                'мяч чуть прокатился под плинтус и вернулся.\n'
                                'Я не покупаю только потому, что пол есть — жду, когда мяч от него '
                                'отскочит, и ставлю стоп, если прокатился всерьёз.»\n'
                                'Покажите ETHUSDT с тремя лоями и одним ложным пробоем — друг поймёт '
                                'без терминов «свинг» и «ликвидность».\n'
                                '\n'
                                'Другу покажите ложный пробой на ETH — визуал учит лучше определения.\n'
                                '\n'
                                'Касание №4–5: часто перед пробоем. Не добавляйте к лонгу «потому что '
                                'уже четыре раза держало» без объёма и контекста BTC.\n'
                                '\n'
                                'Следующий урок — стакан у bid вашей поддержки. Связка уровень+стакан '
                                'сильнее уровня одного.\n'
                                '\n'
                                'Следующий урок — стакан у bid вашей поддержки. Связка уровень+стакан '
                                'сильнее уровня одного.\n'
                                '\n'
                                'Следующий урок — стакан у bid вашей поддержки. Связка уровень+стакан '
                                'сильнее уровня одного.\n'
                                '\n'
                                'Следующий урок — стакан у bid вашей поддержки. Связка уровень+стакан '
                                'сильнее уровня одного.\n'
                                '\n'
                                'Следующий урок — стакан у bid вашей поддержки. Связка уровень+стакан '
                                'сильнее уровня одного.'},
                       {'h': 'Журнал уровней',
                        'body': 'Колонки: пара, ТФ, цена зоны, число касаний, дата последнего касания, '
                                'исход (отскок/пробой/ложный пробой), скрин.\n'
                                'Через месяц у вас база «как ведёт себя ETH на 15m у третьего касания» '
                                '— это edge, не сигнал из чата. Обновляйте уровни:\n'
                                'пробитая поддержка часто становится сопротивлением при ретесте сверху '
                                '— тема следующих уроков по паттернам.\n'
                                '\n'
                                'Журнал уровней через месяц: какой % отскоков vs пробоев? Если 50/50 — '
                                'уровни строите верно, нужен фильтр входа.\n'
                                '\n'
                                'Зона 2450–2455 vs линия 2452.3 — на бирже исполнение по рыночной '
                                'цене, не по вашей линии. Зона снижает ложные «промахи».\n'
                                '\n'
                                'Trade Master цикл: урок → ETHUSDT разметка → журнал. Без скрина — нет '
                                'сделки.\n'
                                '\n'
                                'Trade Master цикл: урок → ETHUSDT разметка → журнал. Без скрина — нет '
                                'сделки.\n'
                                '\n'
                                'Trade Master цикл: урок → ETHUSDT разметка → журнал. Без скрина — нет '
                                'сделки.\n'
                                '\n'
                                'Trade Master цикл: урок → ETHUSDT разметка → журнал. Без скрина — нет '
                                'сделки.\n'
                                '\n'
                                'Trade Master цикл: урок → ETHUSDT разметка → журнал. Без скрина — нет '
                                'сделки.'},
                       {'h': 'Ошибки и итог урока',
                        'body': 'Двадцать линий на графике. Один лой без подтверждения. Лонг без стопа '
                                '«потому что поддержка». Стоп под каждой тенью 5m.\n'
                                'Исправление: 3–5 уровней, старший ТФ, ждать закрытия свечи на ложном '
                                'пробое. Следующий урок — стакан: кто стоит на bid у вашей поддержки.\n'
                                '\n'
                                'Следующий урок стакан объяснит, кто стоит на bid у вашей поддержки — '
                                'связка уровень+стакан.\n'
                                '\n'
                                'Лой на старшем ТФ сильнее: лой на ETH 1h важнее лоя на 5m. Практика: '
                                'отметьте один 1h лой и проверьте, сколько раз 15m его уважал.\n'
                                '\n'
                                'Практика: три лоя, один ложный пробой за 7 дней — план без клика.\n'
                                '\n'
                                'Практика: три лоя, один ложный пробой за 7 дней — план без клика.\n'
                                '\n'
                                'Практика: три лоя, один ложный пробой за 7 дней — план без клика.\n'
                                '\n'
                                'Практика: три лоя, один ложный пробой за 7 дней — план без клика.\n'
                                '\n'
                                'Практика: три лоя, один ложный пробой за 7 дней — план без клика.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Поддержка по лоям',
            'chart_cap': 'Горизонталь через свинг-лои на 15m/1h.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'BINANCE:ETHUSDT 15m: три лоя, один ложный пробой за неделю.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:ETHUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'ETH 2450 зона, третье касание, пин-бар 15m, стоп 2435, тейк 2490, риск 0.7%.',
            'bullets_title': 'Запомнить',
            'bullets': ['Свинг-лой с отскоком',
                        '3–5 уровней макс',
                        'Ложный пробой — закрытие',
                        'Стоп ниже зоны',
                        '1h важнее 5m',
                        'Лимит у уровня',
                        'Журнал касаний'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Уровень ETH и касания', 'Ложный пробой да/нет', 'План вход/стоп/тейк'],
            'tip_title': 'Совет профи',
            'tip': 'Меньше линий — яснее план.'},
     'en': {'title': 'Support by lows',
            'subtitle': 'Swing lows, false breaks, level strength',
            'outcome': 'Build support from swing lows and trade false breaks with rules.',
            'content': 'Support is market memory — needs touches and reaction candles.',
            'takeaway': 'Zones not pennies; false break confirmed by 15m close.',
            'blocks': [{'h': 'Swing lows and building support',
                        'body': 'A swing low is a local minimum followed by a bounce and a higher '
                                'mini-high. On BINANCE:ETHUSDT 15m find three such points.\n'
                                'Two touches suggest a level; three or more form a zone. Draw '
                                'horizontal support through lows using consistent wick or body rules.\n'
                                'Higher timeframe (1h) outweighs 5m noise. Support is market memory of '
                                'prior buying — not magic. Log each level: price zone,\n'
                                'touch count, date. Professionals keep three to five levels per '
                                'session; amateurs paint twenty lines and confuse themselves.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Swing lows need bounce '
                                'confirmation. False break needs 15m close. ETH zone not penny line. '
                                'Max five levels. Limit at support.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'False breaks and entries',
                        'body': 'False break: wick below support, close back above — stop hunt on '
                                'longs parked exactly under the low. Place stops below the\n'
                                'false-break extreme or zone with buffer on ETH 15m. Enter long after '
                                'candle close above level, not first uptick. Filter 5m\n'
                                'fakes with 15m close. Entry needs level plus reaction candle plus BTC '
                                'context — not hope. Stop below zone; target min 1:2 R:R.\n'
                                'Limit entries near support beat market for maker fee and price '
                                'control.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Swing lows need bounce '
                                'confirmation. False break needs 15m close. ETH zone not penny line. '
                                'Max five levels. Limit at support.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Timeframes, journal, and summary',
                        'body': '1h defines weekly support; 15m triggers; 5m refines timing only. '
                                'Journal: pair, zone, touches, outcome, screenshot. Common errors:\n'
                                'one unconfirmed low, long without stop, stops on every 5m wick. Next '
                                'lesson: order book — who bids at your support. Practice:\n'
                                'mark ETHUSDT 15m supports and one false break from last seven days — '
                                'plan only, no click.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Swing lows need bounce '
                                'confirmation. False break needs 15m close. ETH zone not penny line. '
                                'Max five levels. Limit at support.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Practice workflow',
                        'body': 'Open BINANCE:ETHUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process. On ETHUSDT mark three swing '
                                'lows and one false break from the last seven days.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and journal',
                        'body': 'Stop below the support zone, not inside it. Target minimum 1:2 R:R. '
                                'Size from USDT risk formula.\n'
                                'Journal: level price, touch count, false break yes/no, screenshot '
                                'path. Fewer lines, clearer plan.\n'
                                'If distance to invalidation is smaller than normal 15m noise, skip '
                                'the setup entirely.'},
                       {'h': 'Common errors',
                        'body': 'Painting twenty support lines. Long without stop because «support '
                                'will hold». Entering on first touch\n'
                                'without reaction candle. Ignoring 1h structure while scalping 5m. Fix '
                                'with three to five levels max\n'
                                'and 15m close confirmation on false breaks.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Support by lows',
            'chart_cap': 'Horizontal through swing lows on ETHUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'ETHUSDT 15m: mark three lows and one false break this week.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:ETHUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'ETH zone 2450, third touch, pin bar, stop 2435, target 2490, 0.7% risk.',
            'bullets_title': 'Remember',
            'bullets': ['Confirmed swing lows',
                        'Max 3–5 levels',
                        'False break needs close',
                        'Stop below zone',
                        '1h over 5m',
                        'Limit at level',
                        'Touch journal'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Level and touches', 'False break Y/N', 'Entry/stop/target'],
            'tip_title': 'Pro tip',
            'tip': 'Fewer lines, clearer plan.'},
     'pt': {'title': 'Suporte pelos fundos',
            'subtitle': 'Fundos de swing e falsos rompimentos',
            'outcome': 'Construa suporte pelos fundos e opere com regras.',
            'content': 'Suporte é memória de preço — precisa de toques.',
            'takeaway': 'Zona, não centavo; falso rompimento com fechamento.',
            'blocks': [{'h': 'Fundos de swing e suporte',
                        'body': 'Swing low é mínimo local com bounce. Dois toques sugerem nível; três '
                                'formam zona. Use regra consistente: pavios ou corpos.\n'
                                'Timeframe maior (1h) pesa mais que 5m. Registre zona, toques e data '
                                'no diário.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 4: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Falso rompimento e entrada',
                        'body': 'Falso rompimento: pavio abaixo, fechamento acima — caça stops. Entre '
                                'long após fechamento acima do nível. Stop abaixo da zona.\n'
                                'Entrada precisa de nível + reação + contexto BTC. Alvo mínimo 1:2.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 4: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Prática ETHUSDT',
                        'body': 'Marque suportes em ETHUSDT 15m e um falso rompimento da semana. Plano '
                                'sem clique. Próxima lição: book de ofertas.\n'
                                'Máximo 3–5 níveis por sessão.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 4: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:ETHUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Suporte pelos fundos',
            'chart_cap': 'Horizontal em ETHUSDT 15m.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Marque três fundos em ETHUSDT.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:ETHUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Zona 2450, terceiro toque, stop abaixo, alvo 1:2.',
            'bullets_title': 'Lembre',
            'bullets': ['Swing low confirmado',
                        'Máx 3–5 níveis',
                        'Falso rompimento',
                        'Stop abaixo',
                        '1h > 5m',
                        'Limit no nível',
                        'Diário'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Nível e toques', 'Falso rompimento', 'Plano completo'],
            'tip_title': 'Dica profissional',
            'tip': 'Menos linhas, mais clareza.'}},
)

# ─── Lesson 5 ───────────────────────────────────────────────────────────────

_LESSON5 = L(
    5, MOD_CHART, 'Intermediate', 38, 'order_flow', 'BINANCE:BTCUSDT', '5',
    {'br': 'No Brasil o book BTC 5m é base para scalpers.',
     'global': 'Book + chart, not chart alone.',
     'mx': 'En México practique order book en BTCUSDT 5m.',
     'ru': 'В РФ стакан BTC 5m — обязательное наблюдение перед скальпом.'},
    {'ru': {'title': 'Стакан. Подробно',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Стакан. Подробно» с разбором на графике и практикой в TradingView.',
            'content': 'Урок для новичков: стакан. подробно.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Стакан. Подробно».',
            'blocks': [{'h': 'Стакан как живой базар',
                        'body': 'Стакан (order book) — список лимитных заявок: слева bid (покупатели), '
                                'справа ask (продавцы). Цена идёт туда, где встречаются\n'
                                'маркет-ордера с лимитками. На BINANCE:BTCUSDT 5m откройте стакан '
                                'рядом с графиком. Аналогия: базар — продавцы кричат цену,\n'
                                'покупатели торгуются; сделка — когда рукопожатие. График показывает '
                                'итог; стакан — кто стоит в очереди прямо сейчас.\n'
                                'Новичок смотрит только свечи и удивляется «откуда разворот» — часто '
                                'от крупной стены bid или снятия стены ask.\n'
                                '\n'
                                'Глубина стакана Binance: 20 уровней на вебе, больше в терминале. '
                                'Смотрите не только лучший bid, но сумму bid в 0.1% от цены.\n'
                                '\n'
                                'Практика «стакан»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Итог: график + стакан + лента — тройка скальпера.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Глубина стакана Binance: 20 уровней на вебе, больше в терминале. '
                                'Смотрите не только лучший bid, но сумму bid в 0.1% от цены.\n'
                                '\n'
                                'Практика «стакан»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Глубина стакана Binance: 20 уровней на вебе, больше в терминале. '
                                'Смотрите не только лучший bid, но сумму bid в 0.1% от цены.\n'
                                '\n'
                                'Практика «стакан»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Глубина стакана Binance: 20 уровней на вебе, больше в терминале. '
                                'Смотрите не только лучший bid, но сумму bid в 0.1% от цены.\n'
                                '\n'
                                'Практика «стакан»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Глубина стакана Binance: 20 уровней на вебе, больше в терминале. '
                                'Смотрите не только лучший bid, но сумму bid в 0.1% от цены.\n'
                                '\n'
                                'Практика «стакан»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.'},
                       {'h': 'Bid, ask и спред',
                        'body': 'Лучший bid — высшая цена покупки. Лучший ask — низшая цена продажи. '
                                'Спред = ask − bid. На BTC в ликвидные часы спред копейки;\n'
                                'на тонком альте — проценты, и маркет-вход дорог. Запишите спред в '
                                'USDT и в % перед скальпом. Если спред съедает треть планируемого\n'
                                'тейка — сетап мёртв. Скальпер зарабатывает движение больше спреда '
                                'плюс двух комиссий. Измеряйте каждую сессию.\n'
                                '\n'
                                'Агрегированный стакан на BTC ликвиден; на ARB в ночь — дыры. Не '
                                'скальпьте неликвид.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Скрин стакена в журнал обязателен для скальп-идей.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Агрегированный стакан на BTC ликвиден; на ARB в ночь — дыры. Не '
                                'скальпьте неликвид.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Агрегированный стакан на BTC ликвиден; на ARB в ночь — дыры. Не '
                                'скальпьте неликвид.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Агрегированный стакан на BTC ликвиден; на ARB в ночь — дыры. Не '
                                'скальпьте неликвид.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Агрегированный стакан на BTC ликвиден; на ARB в ночь — дыры. Не '
                                'скальпьте неликвид.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Стены в стакане — плотности',
                        'body': 'Стена — крупный объём на одном уровне bid или ask. Может держать цену '
                                '(реальные покупатели) или исчезнуть при подходе (спуфинг).\n'
                                'Не торгуйте «от стены» без подтверждения лентой: цена может пробить, '
                                'если стену снимут. На BTC стены 50–200 BTC заметны;\n'
                                'на ETH — пропорционально. Скрин стакена с подписью «стена bid 67200» '
                                'в журнал — привычка перед скальпом.\n'
                                '\n'
                                'Стена 100 BTC на 67200 — ~6.7M USDT. Сравните с средним объёмом '
                                'минуты в ленте.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                '20 минут наблюдения в день без сделок — домашка.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Стена 100 BTC на 67200 — ~6.7M USDT. Сравните с средним объёмом '
                                'минуты в ленте.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Стена 100 BTC на 67200 — ~6.7M USDT. Сравните с средним объёмом '
                                'минуты в ленте.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Стена 100 BTC на 67200 — ~6.7M USDT. Сравните с средним объёмом '
                                'минуты в ленте.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Стена 100 BTC на 67200 — ~6.7M USDT. Сравните с средним объёмом '
                                'минуты в ленте.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Спуфинг — фейковые стены',
                        'body': 'Спуфинг: крупную лимитку ставят, рынок реагирует, лимитку снимают до '
                                'исполнения. Запрещено на традиционных рынках, на крипте\n'
                                'встречается. Признаки: стена появляется вдруг, далеко от цены, '
                                'исчезает при подходе; нет сделок в ленте на этом уровне.\n'
                                'Правило новичка: не входить только из-за стены — ждать реакцию цены и '
                                'объём в ленте. Стена + пробой + ретест — сильнее стены одной.\n'
                                '\n'
                                'Спуфинг ловят по отсутствию сделок: стена есть, лента пустая — '
                                'подозрение.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: очередь в кассу — кто первый, тот исполнился.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «стакан»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Спуфинг ловят по отсутствию сделок: стена есть, лента пустая — '
                                'подозрение.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Спуфинг ловят по отсутствию сделок: стена есть, лента пустая — '
                                'подозрение.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Спуфинг ловят по отсутствию сделок: стена есть, лента пустая — '
                                'подозрение.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Спуфинг ловят по отсутствию сделок: стена есть, лента пустая — '
                                'подозрение.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Лента сделок (tape)',
                        'body': 'Лента — поток исполненных сделок: зелёные покупки по ask, красные '
                                'продажи по bid. Агрессивные покупки под уровнем — бычий знак;\n'
                                'серия красных без отскока — давление. На 5m BTC лента мелькает быстро '
                                '— смотрите кластеры за 10–30 секунд у уровня.\n'
                                'Tiger/Vataga показывают ленту крупнее веб-интерфейса. Без ленты '
                                'стакан — статичная картинка; с лентой — кино.\n'
                                '\n'
                                'Лента: крупные зелёные принты на уровне — реальный спрос.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'График говорит лонг у поддержки, стакан — давление ask: ждите.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Лента: крупные зелёные принты на уровне — реальный спрос.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лента: крупные зелёные принты на уровне — реальный спрос.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лента: крупные зелёные принты на уровне — реальный спрос.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лента: крупные зелёные принты на уровне — реальный спрос.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'Стакан плюс график — связка',
                        'body': 'Уровень на TradingView 15m + стакан на 5m у того же уровня. План: '
                                '«если у 67200 держится bid и лента зелёная — лонг со стопом ниже».\n'
                                'Противоречие: на графике поддержка, в стакане ask давит — '
                                'осторожность. Trade Master учит обе картины; чаты дают только «вход '
                                'сейчас».\n'
                                '\n'
                                'График говорит лонг у поддержки, стакан — давление ask: ждите.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Лента: крупные зелёные принты на уровне — реальный спрос.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'График говорит лонг у поддержки, стакан — давление ask: ждите.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'График говорит лонг у поддержки, стакан — давление ask: ждите.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'График говорит лонг у поддержки, стакан — давление ask: ждите.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Как объяснить другу про стакан',
                        'body': '«График — это уже случившиеся сделки. Стакан — кто стоит в очереди '
                                'купить и продать. Спред — разница между лучшей покупкой и продажей.\n'
                                'Большая стена — как очередь из десяти человек; может быть настоящей, '
                                'а может разойтись, когда подойдёшь.»\n'
                                '\n'
                                'Другу: очередь в кассу — кто первый, тот исполнился.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «стакан»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Спуфинг ловят по отсутствию сделок: стена есть, лента пустая — '
                                'подозрение.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: очередь в кассу — кто первый, тот исполнился.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «стакан»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: очередь в кассу — кто первый, тот исполнился.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «стакан»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: очередь в кассу — кто первый, тот исполнился.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «стакан»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.'},
                       {'h': 'Скальпинг и стакан — когда переходить',
                        'body': 'Скальп без чтения стакана — лотерея на комиссиях. Первый месяц — 15m '
                                'без стакана; после этого урока — наблюдение 5m BTC 20 минут\n'
                                'в день без сделок. Потом микро-размер одной сделки с полным журналом. '
                                'Риск 0.5%, не 2%.\n'
                                '\n'
                                '20 минут наблюдения в день без сделок — домашка.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Стена 100 BTC на 67200 — ~6.7M USDT. Сравните с средним объёмом '
                                'минуты в ленте.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                '20 минут наблюдения в день без сделок — домашка.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                '20 минут наблюдения в день без сделок — домашка.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                '20 минут наблюдения в день без сделок — домашка.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Ошибки со стаканом',
                        'body': 'Вход на фейковую стену. Игнор спреда. Маркет в тонком стакане. '
                                'Торговля стакана на монете с низкой ликвидностью. Журнал без скрина '
                                'стакена.\n'
                                '\n'
                                'Скрин стакена в журнал обязателен для скальп-идей.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Агрегированный стакан на BTC ликвиден; на ARB в ночь — дыры. Не '
                                'скальпьте неликвид.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Скрин стакена в журнал обязателен для скальп-идей.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Скрин стакена в журнал обязателен для скальп-идей.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Скрин стакена в журнал обязателен для скальп-идей.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 5',
                        'body': 'Стакан — второй глаз к графику. Bid/ask, спред, стены, спуфинг, '
                                'лента. Следующий урок — быстрый и медленный рынок: когда стакан '
                                '«ломается».\n'
                                'Практика: BINANCE:BTCUSDT 5m, запишите спред, найдите одну стену, '
                                'понаблюдайте 15 минут — без клика.\n'
                                '\n'
                                'Итог: график + стакан + лента — тройка скальпера.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Глубина стакана Binance: 20 уровней на вебе, больше в терминале. '
                                'Смотрите не только лучший bid, но сумму bid в 0.1% от цены.\n'
                                '\n'
                                'Практика «стакан»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Итог: график + стакан + лента — тройка скальпера.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Итог: график + стакан + лента — тройка скальпера.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Итог: график + стакан + лента — тройка скальпера.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Стакан. Подробно',
            'chart_cap': 'Разбор на BINANCE:BTCUSDT, 5m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:BTCUSDT на 5m. Найдите пример за 7 дней. Отметьте вход, стоп, '
                       'цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 5m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На BTCUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Стакан. Подробно',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Order book deep dive',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Order book deep dive' with TradingView practice.",
            'content': 'Beginner lesson: order book deep dive.',
            'takeaway': 'Process beats one lucky trade on Order book deep dive.',
            'blocks': [{'h': 'Order book basics',
                        'body': 'The book lists bids (buy limits) and asks (sell limits). Price moves '
                                'where market orders meet resting liquidity. On BINANCE:BTCUSDT 5m\n'
                                'open depth beside the chart. Charts show outcomes; the book shows who '
                                'waits in line. Best bid and ask define spread — measure in USDT\n'
                                'and % before scalping. If spread eats a third of your target, skip. '
                                'Walls are large resting size — may hold or vanish (spoofing).\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Book shows queue; tape '
                                'shows trades. Spread tax on scalps. Walls may spoof — confirm with '
                                'tape. Observe twenty minutes daily.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Tape, spoofing, and practice',
                        'body': 'Tape shows executed trades: aggressive buys at ask vs sells at bid. '
                                'Do not trade walls alone — confirm with tape and price reaction.\n'
                                'Spoofing: huge limit appears and disappears before fill. Link 15m '
                                'chart levels with 5m book at the same price. Beginners observe\n'
                                'twenty minutes daily without clicking before micro-size scalps at '
                                '0.5% risk. Next lesson: fast vs slow market conditions.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Book shows queue; tape '
                                'shows trades. Spread tax on scalps. Walls may spoof — confirm with '
                                'tape. Observe twenty minutes daily.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Summary',
                        'body': 'Journal spread, wall behavior, and screenshots. Tiger/Vataga help '
                                'tape readability. Full loop: lesson → TradingView → book observation '
                                '→ journal.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Book shows queue; tape '
                                'shows trades. Spread tax on scalps. Walls may spoof — confirm with '
                                'tape. Observe twenty minutes daily.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Depth and spread',
                        'body': 'Open BINANCE:BTCUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process. Log best bid, best ask, '
                                'spread in USDT and percent on BTCUSDT 5m.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Walls and tape',
                        'body': 'Large resting size may hold price or vanish (spoofing). Confirm with '
                                'tape: aggressive prints at the level.\n'
                                'Do not trade walls alone. Tiger/Vataga help tape readability after '
                                'you master exchange web UI.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Scalp readiness',
                        'body': 'Observe the book twenty minutes daily without clicking before '
                                'micro-size scalps. Risk 0.5% max.\n'
                                'Spread must be smaller than planned target. Journal book screenshot '
                                'with wall notes.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Order book deep dive',
            'chart_cap': 'Study on BINANCE:BTCUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:BTCUSDT 5m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:BTCUSDT 5m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On BTCUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Order book deep dive',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Book de ofertas',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Book de ofertas' com TradingView.",
            'content': 'Lição: book de ofertas.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Book de ofertas',
                        'body': 'Book lista bids e asks. Spread = ask − bid. Meça antes de scalpar. '
                                'Paredes grandes podem ser spoofing — confirme na fita de trades.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 5: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fita e prática',
                        'body': 'Fita mostra trades executados. Não opere só por parede. BTCUSDT 5m: '
                                'observe 15 min sem clicar. Risco 0,5%.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 5: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Resumo',
                        'body': 'Próxima lição: mercado rápido vs lento. Print do book no diário.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 5: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:BTCUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Book de ofertas',
            'chart_cap': 'BINANCE:BTCUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:BTCUSDT 5m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:BTCUSDT 5m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em BTCUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Book de ofertas',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 6 ───────────────────────────────────────────────────────────────

_LESSON6 = L(
    6, MOD_CHART, 'Intermediate', 33, 'momentum', 'BINANCE:BTCUSDT', '15',
    {'br': 'No Brasil ajuste tamanho em notícias FOMC.',
     'global': 'Fast vs slow regime rules.',
     'mx': 'En México reduzca tamaño en mercado rápido.',
     'ru': 'В РФ на быстром рынке режьте размер вдвое.'},
    {'ru': {'title': 'Особенности быстрого и медленного рынка',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Особенности быстрого и медленного рынка» с разбором на графике и '
                       'практикой в TradingView.',
            'content': 'Урок для новичков: особенности быстрого и медленного рынка.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Особенности быстрого '
                        'и медленного рынка».',
            'blocks': [{'h': 'Быстрый рынок — что меняется',
                        'body': 'Быстрый рынок: широкие свечи, спред расширяется, стакан «дрожит», '
                                'лента не успевает читаться. Новости, листинг, ликвидации каскадом. '
                                'Правило: размер −50%, стоп шире в % но риск USDT тот же, меньше '
                                'сделок. На BINANCE:BTCUSDT после CPI свечи 15m в 3× обычного ATR — '
                                'это быстрый режим, не ваш обычный 0.3% тейк. Ждите 15–30 минут после '
                                'волатильности, пока ATR не сожмётся.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Практика: два скрина BTC — день ATR высокий и низкий.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.'},
                       {'h': 'Медленный рынок — range и скука',
                        'body': 'Медленный рынок: узкий range, тонкий стакан, мало объёма — азиатская '
                                'сессия, воскресенье. Ложные пробои чаще; тейки скромные. Ошибка — '
                                'overtrading от скуки. Лучше пропуск, чем десять сделок в узком флэте '
                                'с комиссиями. Измерьте range 20 свечей — если меньше вашего стопа, не '
                                'торгуйте пробой.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Чеклист в журнале: быстрый/медленный галочка.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Спред в быстром рынке',
                        'body': 'При резком движении маркет-ордер проскальзывает на несколько уровней. '
                                'Лимит может не исполниться — цена уехала. Скальпер переходит на '
                                'меньший размер или паузу. Запишите в журнал «быстрый/медленный» — '
                                'статистика по режимам важнее по монетам.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Другу: шторм — меньше парус; штиль — не крути мотор из скуки.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Ложные импульсы на быстром рынке',
                        'body': 'Длинная свеча без продолжения — охота на FOMO. Не гонитесь за '
                                'маркетом в хвост свечи. Ждите ретест или вторую свечу. На SOLUSDT в '
                                'новости это особенно жёстко.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Стоп в быстром рынке за экстремумом импульсной свечи, не внутри '
                                'тела.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «режим рынка»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Сессии: Азия, Лондон, NY',
                        'body': 'Ликвидность и скорость меняются по UTC. Для РФ и LATAM удобны '
                                'пересечения. Торгуйте ликвидные часы вашей пары; мемы ночью — тонкий '
                                'стакан.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Азия для РФ — ночь; многие торгуют EU/US open для ликвидности.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'Стоп и размер в двух режимах',
                        'body': 'Быстрый: стоп за экстремумом волны, размер половинный. Медленный: '
                                'стоп за границей range, терпение к лимитке. Риск 0.5–1% USDT не '
                                'меняется — меняется номинал.\n'
                                '\n'
                                'Азия для РФ — ночь; многие торгуют EU/US open для ликвидности.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Быстрый рынок: лимитки не успевают — либо пауза, либо меньший '
                                'размер.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Азия для РФ — ночь; многие торгуют EU/US open для ликвидности.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Азия для РФ — ночь; многие торгуют EU/US open для ликвидности.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Азия для РФ — ночь; многие торгуют EU/US open для ликвидности.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Азия для РФ — ночь; многие торгуют EU/US open для ликвидности.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Когда рынок бешеный — уменьшаю ставку и реже играю. Когда тихий — не '
                                'дергаюсь от скуки, иначе комиссии съедят день.»\n'
                                '\n'
                                'Стоп в быстром рынке за экстремумом импульсной свечи, не внутри '
                                'тела.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «режим рынка»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Медленный флэт: тейк на противоположной границе range, не середина.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Стоп в быстром рынке за экстремумом импульсной свечи, не внутри '
                                'тела.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «режим рынка»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Стоп в быстром рынке за экстремумом импульсной свечи, не внутри '
                                'тела.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «режим рынка»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Стоп в быстром рынке за экстремумом импульсной свечи, не внутри '
                                'тела.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «режим рынка»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Стоп в быстром рынке за экстремумом импульсной свечи, не внутри '
                                'тела.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «режим рынка»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.'},
                       {'h': 'Чеклист режима',
                        'body': 'ATR выше среднего? Спред вырос? Новость в календаре? Если два да — '
                                'быстрый режим. План скорректирован? Нет — пропуск.\n'
                                '\n'
                                'Другу: шторм — меньше парус; штиль — не крути мотор из скуки.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'После FOMC первые 15 минут — не ваш размер обучения.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Другу: шторм — меньше парус; штиль — не крути мотор из скуки.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: шторм — меньше парус; штиль — не крути мотор из скуки.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: шторм — меньше парус; штиль — не крути мотор из скуки.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: шторм — меньше парус; штиль — не крути мотор из скуки.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Практика BINANCE:BTCUSDT',
                        'body': 'Найдите день с высоким ATR и день флэта за неделю на 15m. Сравните '
                                'range и спред. Скрин в журнал.\n'
                                '\n'
                                'Чеклист в журнале: быстрый/медленный галочка.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Воскресенье UTC вечер — тонкий рынок, ложные пробои на BTC.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Чеклист в журнале: быстрый/медленный галочка.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Чеклист в журнале: быстрый/медленный галочка.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Чеклист в журнале: быстрый/медленный галочка.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Чеклист в журнале: быстрый/медленный галочка.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 6',
                        'body': 'Два режима — два набора правил. Следующий урок — ошибки новичков. Не '
                                'смешивайте скальп-правила с флэтом.\n'
                                '\n'
                                'Практика: два скрина BTC — день ATR высокий и низкий.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'VIX крипты нет, но ATR(14)/средний ATR за месяц >1.5 — быстрый '
                                'режим.\n'
                                '\n'
                                'Практика «режим рынка»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Практика: два скрина BTC — день ATR высокий и низкий.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Практика: два скрина BTC — день ATR высокий и низкий.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Практика: два скрина BTC — день ATR высокий и низкий.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Практика: два скрина BTC — день ATR высокий и низкий.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Особенности быстрого и медленного рынка',
            'chart_cap': 'Разбор на BINANCE:BTCUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:BTCUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На BTCUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Особенности быстрого и медленного рынка',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Fast vs slow market',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Fast vs slow market' with TradingView practice.",
            'content': 'Beginner lesson: fast vs slow market.',
            'takeaway': 'Process beats one lucky trade on Fast vs slow market.',
            'blocks': [{'h': 'Fast market',
                        'body': 'Fast market: wide candles, wider spread, shaky book, news and '
                                'liquidations. Cut size 50%, same USDT risk, fewer trades. After CPI '
                                'on BTCUSDT 15m, ATR may triple — not your usual scalp target. Wait '
                                '15–30 minutes for compression.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Fast regime: half size, '
                                'wider stop in %, same USDT risk. Slow regime: avoid boredom trades. '
                                'Tag regime in journal.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Slow market',
                        'body': 'Slow market: tight range, thin book, Asian session boredom. False '
                                'breaks multiply; overtrading bleeds fees. If 20-candle range is '
                                'smaller than your stop, skip breakout trades.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Fast regime: half size, '
                                'wider stop in %, same USDT risk. Slow regime: avoid boredom trades. '
                                'Tag regime in journal.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Sessions and checklist',
                        'body': 'Liquidity shifts by session. Journal fast vs slow tag per trade. '
                                'Checklist: elevated ATR, wider spread, news — two yes means fast mode '
                                'rules. Practice: compare high-ATR vs flat days on BTCUSDT 15m.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Fast regime: half size, '
                                'wider stop in %, same USDT risk. Slow regime: avoid boredom trades. '
                                'Tag regime in journal.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Stops and summary',
                        'body': 'Fast: stop beyond spike, half size. Slow: stop beyond range, patient '
                                'limits. Risk percent unchanged. Next: beginner mistakes. Explain '
                                'regime to a friend before live size.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Fast regime: half size, '
                                'wider stop in %, same USDT risk. Slow regime: avoid boredom trades. '
                                'Tag regime in journal.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:BTCUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Fast vs slow market',
            'chart_cap': 'Study on BINANCE:BTCUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:BTCUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:BTCUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On BTCUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Fast vs slow market',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Mercado rápido vs lento',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Mercado rápido vs lento' com TradingView.",
            'content': 'Lição: mercado rápido vs lento.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Mercado rápido',
                        'body': 'Mercado rápido: spread maior, reduza tamanho 50%, mesmo risco USDT. '
                                'Após notícia, espere ATR comprimir.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 6: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Mercado lento',
                        'body': 'Range estreito: evite overtrading. Se range < stop planejado, pule.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 6: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Checklist',
                        'body': 'Marque rápido/lento no diário. Compare dois dias em BTCUSDT 15m.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 6: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Resumo',
                        'body': 'Próxima lição: erros de iniciante.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 6: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:BTCUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Mercado rápido vs lento',
            'chart_cap': 'BINANCE:BTCUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:BTCUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:BTCUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em BTCUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Mercado rápido vs lento',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 7 ───────────────────────────────────────────────────────────────

_LESSON7 = L(
    7, MOD_RISK, 'Beginner', 36, 'risk_reward', 'BINANCE:BTCUSDT', '15',
    {'br': 'No Brasil evite grupos VIP de sinais.',
     'global': 'Checklist beats FOMO.',
     'mx': 'En México cuidado con señales Telegram.',
     'ru': 'В РФ не копируйте «гарантированные» сигналы.'},
    {'ru': {'title': 'Основные ошибки новичков. Часть 1',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Основные ошибки новичков. Часть 1» с разбором на графике и практикой '
                       'в TradingView.',
            'content': 'Урок для новичков: основные ошибки новичков. часть 1.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Основные ошибки '
                        'новичков. Часть 1».',
            'blocks': [{'h': 'Торговля без стопа',
                        'body': 'Стоп — признание ошибки до входа. Без стопа одна сделка может стереть '
                                'месяц. На фьючерсах без стопа вас закроет ликвидация — хуже, чем '
                                'плановый стоп. «Потом поставлю» = нет сделки. Запишите стоп в журнале '
                                'до клика.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.'},
                       {'h': 'All-in в одну монету',
                        'body': 'Весь депозит в PEPE или одну новость — не трейдинг, а ставка. '
                                'Диверсификация для новичка: один актив в фокусе, но риск 0.5–1% на '
                                'идею, не 100% счёта. All-in после плюса — hubris; после минуса — '
                                'отчаяние.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'FOMO — гонка за свечой',
                        'body': 'Зелёная свеча +10% без вас — не приглашение маркетом. FOMO вход в '
                                'хвосте импульса — худший R:R. Правило: пропущенный трейд не снимает '
                                'деньги; плохой вход снимает. Пауза 15 минут после «упустил».\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Чаты сигналов и VIP',
                        'body': 'Telegram «100x сигналы» — сбор депозитов. Нет стопа в сигнале — '
                                'бегите. Trade Master учит свой план на TradingView, не чужой тикер. В '
                                'РФ и LATAM такие чаты особенно активны — блокируйте, не спорьте.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Overtrading',
                        'body': 'Двадцать сделок «потому что скучно» — комиссии и усталость. Лимит: 3 '
                                'сделки в день на обучении или daily loss limit −3R. Качество > '
                                'количество.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'Реванш после стопа',
                        'body': 'Стоп сработал — план сработал. Удвоить размер «отыграться» — '
                                'классический слив. Пауза 30 минут, вода, журнал: «эмоция после '
                                'стопа». Профессионал останавливается на день при −3R.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Overtrading: лимит 3 сделки/день первый месяц.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Реванш: правило «после стопа экран на 30 минут».\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Я заранее решаю, сколько потеряю, если не прав. Не гоняюсь за чужими '
                                'скринами прибыли. После минуса не удваиваю — иду гулять.»\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Чаты с «гарантией» — реферальные ссылки, не образование.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: трейдинг — не казино с кнопкой x2.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «ошибки»: откройте '
                                'символ урока на TradingView, найдите пример за 7 дней.'},
                       {'h': 'Как исправить системно',
                        'body': 'Чеклист до клика. Риск 0.5%. Daily loss cap. Журнал эмоций 1–10. '
                                'Удалить сигнальные чаты. Tuition deposit.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'FOMO: запишите «упустил +5%» и посчитайте, сколько раз дальше было '
                                '−3%.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Исправление: чеклист распечатать.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Пауза как инструмент',
                        'body': 'Лучшая сделка иногда — отсутствие сделки. Рынок 24/7, ваше внимание — '
                                'нет.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'All-in на PEPE после мем-ролика — классика слива депозита за вечер.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Пауза — сделка ноль USDT комиссии.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 7',
                        'body': 'Семь ловушек новичка — узнайте себя в 2–3. Следующий урок — '
                                'нисходящий треугольник. Исправьте одну ошибку на этой неделе.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Стоп-лосс на бирже, не в голове — Conditional order или OCO.\n'
                                '\n'
                                'Практика «ошибки»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Выберите одну ошибку на неделю для искоренения.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Основные ошибки новичков. Часть 1',
            'chart_cap': 'Разбор на BINANCE:BTCUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:BTCUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:BTCUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На BTCUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Основные ошибки новичков. Часть 1',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Beginner mistakes Part 1',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Beginner mistakes Part 1' with TradingView practice.",
            'content': 'Beginner lesson: beginner mistakes part 1.',
            'takeaway': 'Process beats one lucky trade on Beginner mistakes Part 1.',
            'blocks': [{'h': 'No stop and all-in',
                        'body': 'Stop defines loss before entry — no stop means no trade. Liquidation '
                                'is worse than a planned stop. All-in one meme is a bet, not trading. '
                                'Risk 0.5–1% per idea.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. No stop means no trade. '
                                'No revenge double. Cap three trades study day. Delete signal chats.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'FOMO and signal chats',
                        'body': 'Chasing +10% candles with market entries ruins R:R. Missed trade '
                                'costs zero; bad entry costs real USDT. Telegram VIP signals harvest '
                                'deposits — use your TradingView plan.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. No stop means no trade. '
                                'No revenge double. Cap three trades study day. Delete signal chats.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Overtrading and revenge',
                        'body': 'Boredom trading feeds fees. Cap three trades per study day or −3R '
                                'daily stop. After a stop, wait 30 minutes — never double size for '
                                'revenge.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. No stop means no trade. '
                                'No revenge double. Cap three trades study day. Delete signal chats.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Fixes and summary',
                        'body': 'Checklist, emotion log, delete signal groups, tuition deposit only. '
                                'Best trade is often no trade. Next: descending triangle. Pick one '
                                'mistake to fix this week.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. No stop means no trade. '
                                'No revenge double. Cap three trades study day. Delete signal chats.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:BTCUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Beginner mistakes Part 1',
            'chart_cap': 'Study on BINANCE:BTCUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:BTCUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:BTCUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On BTCUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Beginner mistakes Part 1',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Erros de iniciante Parte 1',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Erros de iniciante Parte 1' com TradingView.",
            'content': 'Lição: erros de iniciante parte 1.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Sem stop e all-in',
                        'body': 'Stop antes do clique. All-in em meme é aposta. Risco 0,5–1%.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 7: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'FOMO e sinais',
                        'body': 'Não persiga vela verde com market. Grupos VIP — armadilha.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 7: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Overtrading e revanche',
                        'body': 'Máx 3 trades/dia no estudo. Após stop, pausa 30 min.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 7: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Correções',
                        'body': 'Checklist, diário de emoção, limite diário −3R.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 7: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Resumo',
                        'body': 'Próxima lição: triângulo descendente.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 7: pratique no símbolo da aula '
                                'sem clicar.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:BTCUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Erros de iniciante Parte 1',
            'chart_cap': 'BINANCE:BTCUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:BTCUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:BTCUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em BTCUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Erros de iniciante Parte 1',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 8 ───────────────────────────────────────────────────────────────

_LESSON8 = L(
    8, MOD_PAT, 'Intermediate', 34, 'breakout', 'BINANCE:SOLUSDT', '15',
    {'br': 'No Brasil marque triângulo descendente em SOLUSDT.',
     'global': 'Pattern + volume filter.',
     'mx': 'En México descending triangle en SOLUSDT.',
     'ru': 'В РФ нисходящий треугольник на SOLUSDT.'},
    {'ru': {'title': 'Нисходящий треугольник',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Нисходящий треугольник» с разбором на графике и практикой в '
                       'TradingView.',
            'content': 'Урок для новичков: нисходящий треугольник.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Нисходящий '
                        'треугольник».',
            'blocks': [{'h': 'Форма нисходящего треугольника',
                        'body': 'Горизонтальная поддержка снизу + понижающиеся максимумы (lower highs) '
                                'сверху — сжатие как клин. Давление продавцов нарастает. На '
                                'BINANCE:SOLUSDT 15m ищите 3+ касания низа и 3 lower highs. Не каждый '
                                'клин — треугольник; нужна ясная геометрия.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.'},
                       {'h': 'Горизонтальная поддержка в паттерне',
                        'body': 'Нижняя граница — зона спроса. Чем больше касаний, тем тоньше «пол», '
                                'но тем больше стопов под ним собрано. Пробой вниз часто ускоренный, '
                                'когда покупатели сдались.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Lower highs — сигнал слабости',
                        'body': 'Каждый максимум ниже предыдущего — продавцы входят раньше. Соедините '
                                'вершины наклонной. Вход в шорт чаще после пробоя поддержки, не на '
                                'середине клина без сигнала.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Объём на пробое',
                        'body': 'Пробой вниз с ростом объёма сильнее тихого прокола. На TradingView '
                                'включите объём. Ложный пробой вверх перед настоящим вниз — возможен; '
                                'ждите закрытие свечи.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Ложный пробой вверх',
                        'body': 'Охота стопов шортов перед падением. Закрытие обратно в треугольник — '
                                'ловушка быков. Не шортите середину клина без плана.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'Вход в шорт и стоп',
                        'body': 'Триггер: закрытие 15m ниже поддержки, ретест снизу. Стоп выше ретеста '
                                'или выше последнего lower high. Риск 0.5–1%, размер из формулы.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Ложный пробой вверх перед падением — shakeout.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Шорт после закрытия ниже + ретест, не в середине.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Тейк по высоте треугольника',
                        'body': 'Измерьте высоту клина у основания — часто минимальная цель после '
                                'пробоя (measured move). Частичная фиксация на 1R.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Пробой вниз на объёме 1.5× среднего — фильтр.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк = высота треугольника вниз от пробоя.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «нисходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Потолок наклоняется вниз, пол ровный — как сжимающийся коридор. '
                                'Обычно вываливаются вниз, но жду, когда пол сломают, а не угадываю '
                                'посередине.»\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Lower highs сходятся к поддержке — давление нарастает.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: клин сжимается вниз.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Пример SOLUSDT',
                        'body': 'Найдите на истории SOL 15m нисходящий треугольник за месяц. Разметьте '
                                'вход/стоп/тейк на бумаге. Скрин в журнал.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Горизонтальная поддержка — зона, не линия.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Исторический SOL — разметка без сделки.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 8',
                        'body': 'Паттерн медвежий в контексте сжатия. Следующий — восходящий '
                                'треугольник. Не торгуйте паттерн без объёма и BTC-контекста.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'SOL 15m: ищите сжатие минимум 10–20 свечей — не три свечи '
                                '«треугольник».\n'
                                '\n'
                                'Практика «нисходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'BTC падает — шорт SOL сильнее; BTC растёт — осторожно с шортом SOL.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Нисходящий треугольник',
            'chart_cap': 'Разбор на BINANCE:SOLUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:SOLUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:SOLUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На SOLUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Нисходящий треугольник',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Descending triangle',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Descending triangle' with TradingView practice.",
            'content': 'Beginner lesson: descending triangle.',
            'takeaway': 'Process beats one lucky trade on Descending triangle.',
            'blocks': [{'h': 'Descending triangle shape',
                        'body': 'Flat support plus lower highs — compression wedge. On BINANCE:SOLUSDT '
                                '15m seek three touches on base and three declining peaks. Sellers '
                                'press harder each rally.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Descending triangle on '
                                'SOLUSDT: lower highs, flat support, breakdown with volume, stop above '
                                'retest.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Breakdown and false breaks',
                        'body': 'Volume expansion on breakdown adds confidence. False upside break '
                                'hunts shorts before real drop — wait 15m close. Short trigger: close '
                                'below support, retest from below. Stop above retest.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Descending triangle on '
                                'SOLUSDT: lower highs, flat support, breakdown with volume, stop above '
                                'retest.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Targets and SOL example',
                        'body': 'Measured move: triangle height projected from breakdown. Partial at '
                                '+1R. Risk 0.5–1%. Journal one historical SOL pattern — plan only. '
                                'Next: ascending triangle.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Descending triangle on '
                                'SOLUSDT: lower highs, flat support, breakdown with volume, stop above '
                                'retest.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:SOLUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Descending triangle',
            'chart_cap': 'Study on BINANCE:SOLUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:SOLUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:SOLUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On SOLUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Descending triangle',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Triângulo descendente',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Triângulo descendente' com TradingView.",
            'content': 'Lição: triângulo descendente.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Triângulo descendente',
                        'body': 'Suporte horizontal + topos descendentes. SOLUSDT 15m: marque 3 '
                                'toques.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 8: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Rompimento',
                        'body': 'Fechamento abaixo do suporte + reteste. Stop acima do reteste. Volume '
                                'confirma.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 8: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Alvo e resumo',
                        'body': 'Alvo = altura do triângulo. Próxima lição: triângulo ascendente.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 8: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:SOLUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Triângulo descendente',
            'chart_cap': 'BINANCE:SOLUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:SOLUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:SOLUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em SOLUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Triângulo descendente',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 9 ───────────────────────────────────────────────────────────────

_LESSON9 = L(
    9, MOD_PAT, 'Intermediate', 34, 'breakout', 'BINANCE:SOLUSDT', '15',
    {'br': 'No Brasil triângulo ascendente em SOLUSDT.',
     'global': 'Breakout-retest discipline.',
     'mx': 'En México ascending triangle en SOLUSDT.',
     'ru': 'В РФ восходящий треугольник на SOLUSDT.'},
    {'ru': {'title': 'Восходящий треугольник',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Восходящий треугольник» с разбором на графике и практикой в '
                       'TradingView.',
            'content': 'Урок для новичков: восходящий треугольник.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Восходящий '
                        'треугольник».',
            'blocks': [{'h': 'Форма восходящего треугольника',
                        'body': 'Горизонтальное сопротивление сверху + повышающиеся минимумы (higher '
                                'lows) — покупатели давят вверх. На BINANCE:SOLUSDT 15m ищите '
                                'накопление под потолком.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.'},
                       {'h': 'Сопротивление и higher lows',
                        'body': 'Потолок — зона предложения. Каждый лой выше — спрос сильнее. '
                                'Соедините лои наклонной поддержкой.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Накопление перед пробоем',
                        'body': 'Сужение range под сопротивлением — энергия. Пробой вверх с объёмом — '
                                'бычий сценарий. Ложный пробой вниз — shakeout.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Пробой вверх и ретест',
                        'body': 'Вход лонг: закрытие выше сопротивления, ретест сверху как поддержка. '
                                'Стоп ниже ретеста. Не покупать в середине без сигнала.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Стоп и тейк',
                        'body': 'Стоп под последним higher low или под зоной ретеста. Тейк — высота '
                                'треугольника вверх от пробоя. R:R минимум 1:2.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Пол поднимается, потолок ровный — как придавливают крышку. Жду, '
                                'когда крышку пробьют вверх и подтвердят.»\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Лонг на ретесте сломанного сопротивления.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп под последним higher low.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Пример SOLUSDT',
                        'body': 'Исторический восходящий треугольник на SOL 15m — разметка без '
                                'сделки.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Ложный пробой вниз — вынос стопов перед ростом.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.\n'
                                '\n'
                                'Тейк — высота треугольника вверх.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «восходящий '
                                'треугольник»: откройте символ урока на TradingView, найдите пример за '
                                '7 дней.'},
                       {'h': 'Ошибки',
                        'body': 'Покупка у потолка без пробоя. Игнор BTC падающего. Плечо высокое на '
                                'пробое — волатильность.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Пробой вверх с объёмом — бычий сценарий.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Другу: крышку придавливают снизу.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Журнал паттернов',
                        'body': 'Имя паттерна, высота, объём на пробое, исход. Сравните с нисходящим '
                                'треугольником урока 8.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Накопление под сопротивлением — сжатие range.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'SOL пример на истории.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 9',
                        'body': 'Бычий симметричный брат урока 8. Дальше — стратегия импульсов.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Восходящий — зеркало урока 8: flat top, rising lows.\n'
                                '\n'
                                'Практика «восходящий треугольник»: откройте символ урока на '
                                'TradingView, найдите пример за 7 дней. После стопа — пауза 15–30 '
                                'минут без реванша.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Не покупать у потолка без пробоя — FOMO.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Восходящий треугольник',
            'chart_cap': 'Разбор на BINANCE:SOLUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:SOLUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:SOLUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На SOLUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Восходящий треугольник',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Ascending triangle',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Ascending triangle' with TradingView practice.",
            'content': 'Beginner lesson: ascending triangle.',
            'takeaway': 'Process beats one lucky trade on Ascending triangle.',
            'blocks': [{'h': 'Ascending triangle',
                        'body': 'Flat resistance plus higher lows — buyers press up. SOLUSDT 15m '
                                'accumulation under ceiling. Breakout with volume; false break down '
                                'shakes weak hands.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Ascending triangle: '
                                'higher lows, flat resistance, breakout retest long, stop below '
                                'retest.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Entry and risk',
                        'body': 'Long on 15m close above resistance, retest hold. Stop below retest or '
                                'last higher low. Target triangle height. BTC context required.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Ascending triangle: '
                                'higher lows, flat resistance, breakout retest long, stop below '
                                'retest.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Journal and summary',
                        'body': 'Log pattern name, height, volume. Contrast with lesson 8 descending '
                                'form. Next: impulse strategy.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Ascending triangle: '
                                'higher lows, flat resistance, breakout retest long, stop below '
                                'retest.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:SOLUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Ascending triangle',
            'chart_cap': 'Study on BINANCE:SOLUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:SOLUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:SOLUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On SOLUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Ascending triangle',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Triângulo ascendente',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Triângulo ascendente' com TradingView.",
            'content': 'Lição: triângulo ascendente.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Triângulo ascendente',
                        'body': 'Resistência flat + fundos ascendentes em SOLUSDT 15m.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 9: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Entrada',
                        'body': 'Fechamento acima + reteste. Stop abaixo do reteste.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 9: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Resumo',
                        'body': 'Próxima lição: estratégia de impulsos.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 9: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:SOLUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Triângulo ascendente',
            'chart_cap': 'BINANCE:SOLUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:SOLUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:SOLUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em SOLUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Triângulo ascendente',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 10 ───────────────────────────────────────────────────────────────

_LESSON10 = L(
    10, MOD_STR, 'Intermediate', 37, 'breakout', 'BINANCE:ETHUSDT', '15',
    {'br': 'No Brasil estratégia de impulso em ETHUSDT.',
     'global': 'No FOMO chase on impulse candle.',
     'mx': 'En México impulse strategy en ETHUSDT.',
     'ru': 'В РФ импульсы на ETHUSDT 15m.'},
    {'ru': {'title': 'Торговая стратегия для импульсов',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Торговая стратегия для импульсов» с разбором на графике и практикой в '
                       'TradingView.',
            'content': 'Урок для новичков: торговая стратегия для импульсов.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Торговая стратегия '
                        'для импульсов».',
            'blocks': [{'h': 'Что такое импульс',
                        'body': 'Импульс — резкое направленное движение на объёме, часто после сжатия '
                                'range. На BINANCE:ETHUSDT 15m импульсная свеча в 2–3× среднего range '
                                '— событие, не норма.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.'},
                       {'h': 'Range перед импульсом',
                        'body': 'Длинный флэт + сужение — пружина. Торговать пробой границы range, не '
                                'середину. Ждите закрытие свечи за уровнем.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Объём подтверждает',
                        'body': 'Пробой без объёма — слабый. TradingView volume bar выше среднего — '
                                'фильтр. На новостях объём и так высокий — осторожнее с размером.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Стратегия пробой-ретест',
                        'body': 'Пробой → ретест сломанного уровня → вход по тренду. Стоп за ретест. '
                                'Классика импульсной торговли для новичка на 15m.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Стоп за структурой',
                        'body': 'Стоп за ближайшим swing low (лонг) или high (шорт) импульса, не в '
                                'середине свечи.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'Тейк и трейлинг',
                        'body': 'Первая цель 1–1.5R, остаток трейл по последнему 15m low. Жадность на '
                                'хвосте импульса — FOMO.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп за swing low импульса.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Тейк 1R + трейл остатка.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Сначала тишина, потом резкий выстрел. Я не прыгаю в выстрел — жду, '
                                'когда откатят к сломанной двери и оттолкнутся снова.»\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Пробой-ретест — не погоня за свечой.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: не прыгай в поезд на ходу — жди остановки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «импульс»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.'},
                       {'h': 'ETHUSDT пример',
                        'body': 'Найдите импульс ETH за неделю, отметьте range до, пробой, ретест — '
                                'план на бумаге.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Объём на пробойной свече выше среднего.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Новости — импульс, но размер половинный.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Ошибки импульса',
                        'body': 'Маркет в хвосте свечи. Нет стопа. Плечо 10x на новости. Торговля '
                                'против BTC.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Range 20+ свечей перед импульсом — пружина.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Ошибка: 10x на импульсной свече.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 10',
                        'body': 'Импульс торгуется на пробое и ретесте, не на FOMO. Следующие уроки — '
                                'делистинг и листинг.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Импульс ETH: свеча 2× range после сжатия — кандидат.\n'
                                '\n'
                                'Практика «импульс»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Связка с уроками амплитуды и треугольников.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Торговая стратегия для импульсов',
            'chart_cap': 'Разбор на BINANCE:ETHUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:ETHUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:ETHUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На ETHUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Торговая стратегия для импульсов',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Impulse trading strategy',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Impulse trading strategy' with TradingView practice.",
            'content': 'Beginner lesson: impulse trading strategy.',
            'takeaway': 'Process beats one lucky trade on Impulse trading strategy.',
            'blocks': [{'h': 'Impulse and range',
                        'body': 'Impulse: sharp directional move on volume after compression. ETHUSDT '
                                '15m candle 2–3× average range is an event. Trade breakout of prior '
                                'range, not middle.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Impulse after compression '
                                'on ETHUSDT. Breakout-retest, no chase. Stop beyond impulse swing.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Breakout-retest strategy',
                        'body': 'Break → retest broken level → enter with trend. Stop beyond retest. '
                                'Volume above average filters weak breaks. First target 1–1.5R.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Impulse after compression '
                                'on ETHUSDT. Breakout-retest, no chase. Stop beyond impulse swing.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'ETH example and summary',
                        'body': 'Mark one weekly ETH impulse: range, break, retest — paper plan only. '
                                'Avoid market chase on news. Next: delisting risk.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Impulse after compression '
                                'on ETHUSDT. Breakout-retest, no chase. Stop beyond impulse swing.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:ETHUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Impulse trading strategy',
            'chart_cap': 'Study on BINANCE:ETHUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:ETHUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:ETHUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On ETHUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Impulse trading strategy',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Estratégia para impulsos',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Estratégia para impulsos' com TradingView.",
            'content': 'Lição: estratégia para impulsos.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Impulso',
                        'body': 'Movimento forte após range estreito. ETHUSDT 15m: espere fechamento '
                                'além do nível.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 10: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Breakout-reteste',
                        'body': 'Rompimento, reteste, entrada. Stop além do reteste. Volume confirma.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 10: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Resumo',
                        'body': 'Próximas lições: delisting e listagem.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 10: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:ETHUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Estratégia para impulsos',
            'chart_cap': 'BINANCE:ETHUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:ETHUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:ETHUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em ETHUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Estratégia para impulsos',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 11 ───────────────────────────────────────────────────────────────

_LESSON11 = L(
    11, MOD_MKT, 'Beginner', 32, 'price_chart', 'BINANCE:PEPEUSDT', '15',
    {'br': 'No Brasil leia Announcements Binance.',
     'global': 'Exit early on delist news.',
     'mx': 'En México riesgo de delisting en alts.',
     'ru': 'В РФ следите за делистингом на Binance.'},
    {'ru': {'title': 'Делистинг монет с биржи',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Делистинг монет с биржи» с разбором на графике и практикой в '
                       'TradingView.',
            'content': 'Урок для новичков: делистинг монет с биржи.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Делистинг монет с '
                        'биржи».',
            'blocks': [{'h': 'Что такое делистинг',
                        'body': 'Делистинг — биржа снимает пару с торгов. Торговать нельзя или окно '
                                'ограничено; вывести актив нужно до дедлайна. Binance публикует анонс '
                                'заранее — читайте Announcements.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.'},
                       {'h': 'Почему монеты делистят',
                        'body': 'Низкий объём, нарушения compliance, проблемы проекта. Мемы и '
                                'малоизвестные альты в зоне риска. PEPEUSDT пока ликвиден — но урок '
                                'про механику для любой мелкой монеты.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Таймлайн делистинга',
                        'body': 'Анонс → только закрытие позиций → вывод в срок. Не покупайте '
                                '«дешёвую» монету на делистинге «вдруг отскочит» — ликвидность '
                                'исчезает.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Как выходить',
                        'body': 'Закрыть позицию, конвертировать в USDT, вывести или перевести. Маркет '
                                'в последний день — огромный спред. Действуйте рано.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Падение цены при новости',
                        'body': 'Часто −30–80% за часы на страх. Шорт опасен без опыта; лонг ловить '
                                'нож — тоже. Лучшая сделка — отсутствие позиции.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'PEPEUSDT как напоминание',
                        'body': 'Даже ликвидные мемы волатильны. Делистинг — про процесс, не прогноз '
                                'по PEPE. Держите риск маленьким на экзотике.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Не усреднять «дешёвую» делистинг-монету.\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'PEPE — пример ликвидного мема; урок про процесс.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Биржа выкидывает монету с прилавка. Купить потом некому — цена '
                                'падает в яму. Я не геройствую — выхожу по анонсу.»\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Маркет в последний день — спред 10%+ возможен.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: биржа убирает товар с полки.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «делистинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.'},
                       {'h': 'Чеклист делистинга',
                        'body': 'Проверять Announcements раз в неделю. Нет позиций в монетах без плана '
                                'выхода. Стоп не спасёт при остановке торгов.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Закрыть позицию в первые 24ч после анонса — спокойнее.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Чеклист: нет ли моей монеты в анонсе?\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'Не обнуляйтесь на одной монете',
                        'body': 'Концентрация в одной альте + делистинг = катастрофа. Диверсификация и '
                                'USDT.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Делистинг ≠ instant zero, но ликвидность исчезает.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Диверсификация — не 100% в одной альте.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 11',
                        'body': 'Делистинг — рыночный риск, не паттерн. Следующий — листинг новых '
                                'пар.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Binance Announcements — закладка в браузере.\n'
                                '\n'
                                'Практика «делистинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Вывод на USDT, не «подержу на холодном» без плана.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Делистинг монет с биржи',
            'chart_cap': 'Разбор на BINANCE:PEPEUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:PEPEUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:PEPEUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На PEPEUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, '
                       'риск 1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Делистинг монет с биржи',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'Delisting risk',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'Delisting risk' with TradingView practice.",
            'content': 'Beginner lesson: delisting risk.',
            'takeaway': 'Process beats one lucky trade on Delisting risk.',
            'blocks': [{'h': 'Delisting explained',
                        'body': 'Exchange removes a pair — trading ends or narrows; withdraw before '
                                'deadline. Binance Announcements list timelines. Reasons: low volume, '
                                'compliance, project issues.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Read Binance '
                                'Announcements weekly. Exit delist early. No averaging delist bags.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Timeline and exit',
                        'body': 'Announce → close-only → withdraw. Do not buy «cheap» delisting coins '
                                'hoping for bounce. Exit early; final-day market has huge spread. '
                                'Price can drop 30–80% on fear.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Read Binance '
                                'Announcements weekly. Exit delist early. No averaging delist bags.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'PEPE reminder and checklist',
                        'body': 'PEPEUSDT is liquid today — lesson is process for any small cap. '
                                'Weekly announcement check. No hero trades. Next: new listings.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Read Binance '
                                'Announcements weekly. Exit delist early. No averaging delist bags.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:PEPEUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'Delisting risk',
            'chart_cap': 'Study on BINANCE:PEPEUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:PEPEUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:PEPEUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On PEPEUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['Delisting risk',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Delisting de moedas',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Delisting de moedas' com TradingView.",
            'content': 'Lição: delisting de moedas.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Delisting',
                        'body': 'Exchange remove par — saia antes do prazo. Leia Announcements '
                                'Binance.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 11: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Timeline',
                        'body': 'Não compre moneda em delisting por esperança. Spread enorme no último '
                                'dia.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 11: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Checklist',
                        'body': 'Risco pequeno em alts exóticas. Próxima: listagem.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 11: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:PEPEUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Delisting de moedas',
            'chart_cap': 'BINANCE:PEPEUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:PEPEUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:PEPEUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em PEPEUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Delisting de moedas',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

# ─── Lesson 12 ───────────────────────────────────────────────────────────────

_LESSON12 = L(
    12, MOD_MKT, 'Beginner', 33, 'momentum', 'BINANCE:ARBUSDT', '15',
    {'br': 'No Brasil listagens com tamanho mínimo.',
     'global': 'Observe first hour, trade later.',
     'mx': 'En México new listing volatility en ARBUSDT.',
     'ru': 'В РФ листинг ARBUSDT — урок волатильности.'},
    {'ru': {'title': 'Листинг',
            'subtitle': 'План до клика, риск 0.5–1%, TradingView + журнал',
            'outcome': 'Освоите «Листинг» с разбором на графике и практикой в TradingView.',
            'content': 'Урок для новичков: листинг.',
            'takeaway': 'Дисциплина и журнал важнее одной удачной сделки по теме «Листинг».',
            'blocks': [{'h': 'Что такое листинг',
                        'body': 'Листинг — новая пара на бирже. Первые часы: дикая волатильность, '
                                'широкий спред, FOMO. BINANCE:ARBUSDT на истории листинга — учебный '
                                'кейс волатильности.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.'},
                       {'h': 'Первые минуты торгов',
                        'body': 'Скачки ±10–50%, ликвидации, проскальзывание. Новичку — наблюдение, не '
                                'участие. Если участвуете — микро-размер и стоп обязателен.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.'},
                       {'h': 'Памп и откат',
                        'body': 'Первая волна покупателей, затем фиксация — глубокий откат. Не '
                                'покупать хай первого часа без плана. Ждите структуру 15m.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.'},
                       {'h': 'Размер позиции на листинге',
                        'body': 'Риск 0.25–0.5% максимум — не стандартный 1%. ATR огромен. Плечо 2–3x '
                                'или спот.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.'},
                       {'h': 'Стоп обязателен',
                        'body': 'Гэпы и свечи через несколько процентов. Стоп за последним swing, не '
                                '«в голове». Ликвидация на 10x за минуты реальна.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.'},
                       {'h': 'ARB как пример',
                        'body': 'Откройте ARBUSDT 15m с даты листинга на TradingView. Изучите первые '
                                'сутки — волатильность, не «легкие деньги».\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Стоп за структуру 15m, не «−2% в голове».\n'
                                '\n'
                                'После стопа — пауза 15–30 минут без реванша. Trade Master: урок → '
                                'график → журнал.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.\n'
                                '\n'
                                'Pre-market на некоторых листингах — ещё тоньше.\n'
                                '\n'
                                'В быстром рынке режьте размер на 50% при том же риске USDT. P2P в '
                                'escrow; KYC и 2FA до депозита.'},
                       {'h': 'Pre-market риск',
                        'body': 'Некоторые листинги с pre-market — ещё тоньше ликвидность. Читайте '
                                'правила биржи.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Риск 0.25% на листинге, не 1%.\n'
                                '\n'
                                'Скрин блока 4 с подписями — в журнал с датой. Объясните сетап другу '
                                'за минуту без обещания прибыли.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.\n'
                                '\n'
                                'Другу: открытие магазина — давка, смотри снаружи.\n'
                                '\n'
                                'Лимит у уровня лучше маркета — maker fee. Практика «листинг»: '
                                'откройте символ урока на TradingView, найдите пример за 7 дней.'},
                       {'h': 'Как объяснить другу',
                        'body': '«Новая монета — как открытие популярного магазина: толпа, давка, '
                                'кто-то падает. Я смотрю со стороны первые дни.»\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'Памп 30% и откат 20% — типичная дуга.\n'
                                '\n'
                                'Сверьте BINANCE:BTCUSDT 15m перед сделкой по альту. Лимит у уровня '
                                'лучше маркета — maker fee.\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.\n'
                                '\n'
                                'План: торговать со 2–3 дня, когда ATR стабилизируется.\n'
                                '\n'
                                'Объясните сетап другу за минуту без обещания прибыли. Запишите вход, '
                                'стоп, тейк и риск 0.5–1% USDT до клика.'},
                       {'h': 'План на листинг',
                        'body': 'Не в первый час. Ждать 15m структуру. Размер минимальный. Анонс в '
                                'календаре. Журнал.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Первый час — наблюдение, не FOMO.\n'
                                '\n'
                                'Запишите вход, стоп, тейк и риск 0.5–1% USDT до клика. В быстром '
                                'рынке режьте размер на 50% при том же риске USDT.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.\n'
                                '\n'
                                'Плечо 2x максимум на листинге.\n'
                                '\n'
                                'Trade Master: урок → график → журнал. Сверьте BINANCE:BTCUSDT 15m '
                                'перед сделкой по альту.'},
                       {'h': 'Итог урока 12',
                        'body': 'Листинг — событие для наблюдения, не охоты. Завершили блок 2–12: '
                                'ордера, амплитуда, уровни, стакан, режимы, ошибки, паттерны, импульс, '
                                'листинги.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'ARB листинг — волатильность первых суток в учебниках.\n'
                                '\n'
                                'Практика «листинг»: откройте символ урока на TradingView, найдите '
                                'пример за 7 дней. После стопа — пауза 15–30 минут без реванша.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.\n'
                                '\n'
                                'Блок 2–12 завершён — повторите чеклист урока 2.\n'
                                '\n'
                                'P2P в escrow; KYC и 2FA до депозита. Скрин блока 10 с подписями — в '
                                'журнал с датой.'}],
            'market_title': 'Ваш рынок',
            'chart_title': 'Листинг',
            'chart_cap': 'Разбор на BINANCE:ARBUSDT, 15m.',
            'tv_title': 'Разбор в TradingView',
            'tv_body': 'Откройте BINANCE:ARBUSDT на 15m. Найдите пример за 7 дней. Отметьте вход, '
                       'стоп, цель.',
            'practice_title': 'Практика',
            'practice_intro': '30–40 минут. Без реальных сделок на обучении:',
            'practice_steps': ['Откройте TradingView: BINANCE:ARBUSDT, таймфрейм 15m.',
                               'Разметьте ключевые уровни или элементы урока.',
                               'Опишите сценарий вход/стоп/тейк без клика на бирже.',
                               'Сделайте скрин с подписью уровней.',
                               'Запишите в журнал: сетап, R:R, эмоция до входа.',
                               'Перечитайте план через 24 часа — нужна ли коррекция?'],
            'example_title': 'Разбор сценария',
            'example': 'На ARBUSDT примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск '
                       '1% — план без клика.',
            'bullets_title': 'Запомнить',
            'bullets': ['Тема: Листинг',
                        'План до клика',
                        'Риск 0.5–1%',
                        'TradingView + журнал',
                        'Сетапы не сигналы',
                        'Измеряйте % движения',
                        'Микро-размер'],
            'journal_title': 'Журнал',
            'journal_body': 'Запишите после практики:',
            'journal_items': ['Пара и ТФ', 'Вход / стоп / цель', 'Эмоция до входа'],
            'tip_title': 'Совет профи',
            'tip': 'Trade Master: урок → TradingView → журнал. Не Telegram VIP.'},
     'en': {'title': 'New listing',
            'subtitle': 'Plan before click, 0.5–1% risk',
            'outcome': "Master 'New listing' with TradingView practice.",
            'content': 'Beginner lesson: new listing.',
            'takeaway': 'Process beats one lucky trade on New listing.',
            'blocks': [{'h': 'New listing basics',
                        'body': 'New pair on exchange — extreme volatility first hours, wide spread, '
                                'FOMO. BINANCE:ARBUSDT listing history is a volatility case study. '
                                'Observe first; trade micro if at all.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Listing volatility on '
                                'ARBUSDT — observe hour one. Risk 0.25%. Max 2x leverage. Trade day '
                                'two or three.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Pump, size, and stops',
                        'body': 'First wave then deep pullback — do not chase hour-one high. Risk '
                                '0.25–0.5% max; leverage 2–3x. Stop beyond last swing — gaps are real '
                                'on listings.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Listing volatility on '
                                'ARBUSDT — observe hour one. Risk 0.25%. Max 2x leverage. Trade day '
                                'two or three.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'ARB example and plan',
                        'body': 'Study ARBUSDT first day on 15m. Pre-market rules vary — read exchange '
                                'notice. Next: practice full journal loop on your chosen symbol.\n'
                                '\n'
                                'Define entry, stop, target, and 0.5–1% risk before click. BTC context '
                                'for alts. TradingView screenshot before live order. Journal emotion '
                                '1–10. Trade Master loop beats Telegram VIP. Listing volatility on '
                                'ARBUSDT — observe hour one. Risk 0.25%. Max 2x leverage. Trade day '
                                'two or three.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'TradingView workflow',
                        'body': 'Open BINANCE:ARBUSDT on TradingView at the lesson timeframe. Mark '
                                'swings, levels, or pattern boundaries.\n'
                                'Write entry, stop, target, and 0.5–1% risk in USDT before any live '
                                'order. Screenshot the plan and\n'
                                'store it in your journal with emotion score 1–10. One trade proves '
                                'nothing; edge appears over dozens\n'
                                'of logged repetitions. BTC context matters for alts — check '
                                'BINANCE:BTCUSDT trend before alt entries.\n'
                                'Limit orders add liquidity (maker fee); market orders take liquidity '
                                '(taker) — fees compound for active traders.\n'
                                'Trade Master links lesson theory to chart practice to journal review; '
                                'Telegram signal groups skip the process.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Risk and execution',
                        'body': 'Isolated margin, modest leverage. Funding matters on holds over eight '
                                'hours. Daily loss limit −3R.\n'
                                'Cooldown thirty minutes after stop-out — no revenge size. Tuition '
                                'deposit only; no loans for trading.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'},
                       {'h': 'Lesson discipline',
                        'body': 'Explain the setup to a friend in sixty seconds without promising '
                                'profit — if you cannot, skip the click.\n'
                                'Full loop: lesson → TradingView markup → journal entry. Competitors '
                                'teach savings; Trade Master teaches setups.\n'
                                '\n'
                                'Measure recent range in percent before sizing stops and targets. '
                                'Define entry, stop, target,\n'
                                'and 0.5–1% deposit risk before every click. Screenshot your '
                                'TradingView plan and log emotion\n'
                                '1–10 in your journal. BTC context on BINANCE:BTCUSDT 15m matters '
                                'before alt trades.\n'
                                'Limit orders often pay maker fee; market orders pay taker — fees '
                                'compound for active traders.\n'
                                'After a stop-out, pause 30 minutes — no revenge size. Trade Master: '
                                'lesson → chart → journal.\n'
                                'Telegram VIP groups sell hope without process. If checklist fails, '
                                'skip the trade.'}],
            'market_title': 'Your market (LATAM)',
            'chart_title': 'New listing',
            'chart_cap': 'Study on BINANCE:ARBUSDT.',
            'tv_title': 'TradingView breakdown',
            'tv_body': 'Open BINANCE:ARBUSDT 15m. Mark entry, stop, target.',
            'practice_title': 'Practice',
            'practice_intro': '30–40 minutes:',
            'practice_steps': ['Open TradingView BINANCE:ARBUSDT 15m.',
                               'Mark key levels from the lesson.',
                               'Write entry/stop/target — no live click.',
                               'Screenshot with labels.',
                               'Journal: setup, R:R, emotion.',
                               'Review plan after 24h.'],
            'example_title': 'Scenario',
            'example': 'On ARBUSDT, write plan with 1:2 R:R and 1% risk — no live click.',
            'bullets_title': 'Remember',
            'bullets': ['New listing',
                        'Plan before click',
                        'Risk 0.5–1%',
                        'TradingView + journal',
                        'Setups not signals',
                        'Measure % moves',
                        'Small size'],
            'journal_title': 'Journal',
            'journal_body': 'Record:',
            'journal_items': ['Pair & TF', 'Entry/stop/target', 'Emotion'],
            'tip_title': 'Pro tip',
            'tip': 'Full loop: lesson → chart → journal.'},
     'pt': {'title': 'Listagem',
            'subtitle': 'Plano antes do clique',
            'outcome': "Dominar 'Listagem' com TradingView.",
            'content': 'Lição: listagem.',
            'takeaway': 'Processo e diário vencem sorte.',
            'blocks': [{'h': 'Listagem',
                        'body': 'Nova par — volatilidade extrema nas primeiras horas. ARBUSDT como '
                                'estudo.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 12: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Tamanho e stop',
                        'body': 'Risco 0,25–0,5%. Alavancagem baixa. Não persiga o topo da primeira '
                                'hora.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 12: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Plano',
                        'body': 'Observe primeiro; estrutura 15m antes de entrar. Bloco 2–12 '
                                'completo.\n'
                                '\n'
                                'Defina entrada, stop, alvo e risco 0,5–1% antes do clique. Print no '
                                'TradingView. Diário de emoção. Lição 12: pratique no símbolo da aula '
                                'sem clicar.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Fluxo TradingView',
                        'body': 'Abra BINANCE:ARBUSDT no TradingView no timeframe da aula. Marque '
                                'níveis e escreva entrada, stop, alvo e risco 0,5–1%\n'
                                'antes de clicar. Print do plano no diário com emoção de 1 a 10. '
                                'Contexto BTC importa para alts.\n'
                                'Ordem limite = maker; mercado = taker. Trade Master liga lição → '
                                'gráfico → diário.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Risco e execução',
                        'body': 'Margem isolada, alavancagem baixa. Funding em holds longos. Limite de '
                                'perda diária −3R. Pausa após stop.\n'
                                'Depósito de treino apenas. P2P só no escrow da exchange no Brasil e '
                                'México.\n'
                                '\n'
                                'Meça a amplitude recente em % antes de definir stop e alvo. Defina '
                                'entrada, stop, alvo e risco\n'
                                '0,5–1% do depósito antes de cada clique. Print do TradingView no '
                                'diário com emoção de 1 a 10.\n'
                                'Contexto BTC em BTCUSDT 15m antes de operar alts. Ordem limite = '
                                'maker; mercado = taker.\n'
                                'Após stop, pausa de 30 minutos sem revanche. Trade Master: lição → '
                                'gráfico → diário.\n'
                                'Grupos VIP no Telegram vendem esperança sem processo. Checklist '
                                'incompleto — pule o trade.\n'
                                'P2P só no escrow da exchange. Tamanho pequeno até 50 trades com '
                                'regras escritas.'},
                       {'h': 'Disciplina',
                        'body': 'Explique o setup em um minuto para um amigo. Sem print — sem trade. '
                                'Ciclo completo: lição → TradingView → diário.\n'
                                'Não copie sinais VIP do Telegram.'},
                       {'h': 'Resumo da prática',
                        'body': 'Revise o plano em sete dias. Melhoria em paciência aparece antes do '
                                'saldo. Educação é decisão sob incerteza.\n'
                                'P2P só no escrow. Diário honesto vence grupos de sinais. Tamanho '
                                'pequeno até cinquenta trades com regras.'},
                       {'h': 'Checklist final',
                        'body': 'Setup nomeado, entrada/stop/alvo, risco 0,5–1%, sem FOMO, margem '
                                'isolada. Dois «não» no checklist — pular.\n'
                                'Profissionais pulam dez setups por dia; amadores operam tédio. '
                                'Registre cada sessão mesmo sem clicar.'}],
            'market_title': 'Seu mercado (Brasil)',
            'chart_title': 'Listagem',
            'chart_cap': 'BINANCE:ARBUSDT.',
            'tv_title': 'Setup no TradingView',
            'tv_body': 'Abra BINANCE:ARBUSDT 15m.',
            'practice_title': 'Prática',
            'practice_intro': '30–40 minutos:',
            'practice_steps': ['Abra TradingView BINANCE:ARBUSDT 15m.',
                               'Marque níveis da lição.',
                               'Plano entrada/stop/alvo sem clicar.',
                               'Print com legendas.',
                               'Diário: setup, R:R, emoção.',
                               'Revise o plano em 24h.'],
            'example_title': 'Cenário',
            'example': 'Em ARBUSDT, plano com R:R 1:2 e risco 1%.',
            'bullets_title': 'Lembre',
            'bullets': ['Listagem',
                        'Plano antes do clique',
                        'Risco 0,5–1%',
                        'TradingView + diário',
                        'Setups não sinais',
                        'Meça %',
                        'Tamanho pequeno'],
            'journal_title': 'Diário',
            'journal_body': 'Registre:',
            'journal_items': ['Par e TF', 'Entrada/stop/alvo', 'Emoção'],
            'tip_title': 'Dica profissional',
            'tip': 'Ciclo completo: lição → gráfico → diário.'}},
)

LESSONS = [
    _LESSON2, _LESSON3, _LESSON4, _LESSON5, _LESSON6,
    _LESSON7, _LESSON8, _LESSON9, _LESSON10, _LESSON11, _LESSON12,
]
