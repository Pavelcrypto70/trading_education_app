#!/usr/bin/env python3
"""Generate part01b.py — lessons 2-12 with full RU/EN/PT content."""
from pathlib import Path
import pprint
import textwrap

OUT = Path(__file__).parent / "part01b.py"


def d(s):
    return textwrap.dedent(s).strip()


def blk(h, body):
    return {"h": h, "body": d(body)}


def wc(blocks):
    return sum(len(b["body"].split()) for b in blocks)


HEADER = d("""
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
""")


# ─── Lesson 2 RU ─────────────────────────────────────────────────────────────
_L2_RU = [
    blk("Ордер — ваш единственный способ говорить с биржей", """
        Биржа не читает мысли и не видит вашу уверенность в росте. Она сопоставляет только ордера —
        заявки на покупку или продажу по цене и объёму. Лимитный ордер: «куплю BTC по 67000 USDT, не дороже».
        Заявка попадает в стакан и ждёт, пока продавец согласится. Маркет-ордер: «купи сейчас по лучшей цене» —
        исполнение мгновенное, но цена может пройти несколько уровней стакана. Аналогия: лимитка — заказ блюда
        по цене из меню с ожиданием; маркет — взял первое свободное блюдо с полки, даже если дороже.
        Новичок жмёт маркет из страха опоздать и платит спред плюс комиссию taker. Профессионал знает,
        зачем ему маркет: только когда сетап требует скорости, а потеря на спреде меньше упущенного движения.
        Откройте историю ордеров на Binance: статусы New, Partially Filled, Filled, Canceled — это азбука.
        Перед первой сделкой посмотрите справку по комиссиям и сравните maker/taker для вашего VIP-уровня.
    """),
    blk("Maker и taker: почему скальпер считает каждый базисный пункт", """
        Maker — тот, кто добавил ликвидность: выставил лимит, который кто-то исполнил. Taker — забрал чужую заявку.
        На Binance Futures ориентир: maker ~0.02%, taker ~0.04% — вдвое дороже. Казалось бы, мелочь на одной сделке.
        Скальпер делает пятьдесят сделок в день: если все taker, комиссии съедают 1–2% депозита за неделю без учёта убытков.
        Профессионал ставит лимит на вход там, где опоздание на один тик не критично, и маркетом закрывает только при срочном выходе.
        BNB для оплаты комиссий даёт скидку — включите после того, как поняли базовые ставки, не в первый час.
        VIP-уровни снижают fee при объёме — имеет смысл, когда торгуете стабильно, а не «ради скидки».
        Запомните: каждый лишний маркет-вход — налог на нетерпение. В журнале заведите колонку «maker/taker» —
        через месяц увидите, сколько edge уходит в комиссии.
    """),
    blk("Funding rate — невидимая аренда позиции", """
        Funding на perpetual Binance — перевод между лонгами и шортами каждые 8 часов (00:00, 08:00, 16:00 UTC).
        Положительный funding: лонги платят шортам — рынок перегрет вверх относительно спота. Отрицательный: шорты платят лонгам.
        Это не прямая комиссия бирже, а механизм удержания цены фьючерса рядом со спотом. Аналогия: вы арендуете «ставку
        на направление». Держите лонг неделю при +0.01% три раза в день — набегает ~0.21% от номинала позиции,
        что может съесть половину скромного тейка. Внутридневщик часто закрывается до funding. Свингер смотрит
        вкладку Funding Rate на Binance или CoinGlass перед входом в многодневный лонг в сильном апренде.
        На шорте в панике funding может быть отрицательным — шорты платят, что больно, но ожидаемо.
        Для новичка: запишите в плане «держу ли через funding?» — если да, посчитайте три платежа в USDT.
    """),
    blk("Терминалы Tiger.Trade и Vataga — зачем они скальперу", """
        Веб-интерфейс Binance достаточен для обучения лимиту, маркету и стопу. Скальперу на 5m нужны горячие клавиши,
        кластерный объём, быстрый стакан, лента сделок, связка нескольких мониторов. Tiger.Trade и Vataga — популярные
        терминалы в СНГ; подключаются к Binance по API только на торговлю, без вывода. Вы видите плотности в стакане,
        можете закрыть позицию одной клавишей, отменить все ордера мгновенно. Новичку терминал не обязателен первые недели —
        сначала поймите ордера на бирже и разметку на TradingView 15m. Потом, если выберете скальпинг, терминал сэкономит
        секунды, а на 5m секунды — деньги. Порядок обучения: биржа → TradingView старший ТФ → стакан на 5m → терминал.
        API-ключ: только trade, IP whitelist, без withdraw. Никому не отдавайте ключ с правом вывода.
        TradingView остаётся для плана; терминал — для исполнения по плану, не вместо плана.
    """),
    blk("Скальпинг vs свинг: два разных спорта", """
        Скальпинг — сделки от секунд до нескольких минут, много комиссий, нужен стакан, низкая задержка, железная дисциплина.
        Свинг внутри дня — удержание часами, решения на 15m–1h, меньше сделок, больше времени на план и журнал.
        Позиционная торговля — дни и недели. Новичок ошибается, начиная со скальпинга «потому что быстрее деньги» —
        быстрее и слив при отсутствии опыта чтения стакана и амплитуды. Рекомендация курса: первые 20–30 сделок —
        свинг на 15m с риском 0.5%, полный журнал, без терминала. Скальпинг — после уроков по стакану, ленте и амплитуде.
        Как нельзя бежать марафон, не научившись ходить. Скальпер зарабатывает на маленьких движениях минус комиссии;
        свингер — на более крупных свечах с меньшим числом кликов. Оба стиля требуют стопа до входа.
        Выберите один стиль на первый месяц и не переключайтесь из скуки — иначе статистика в журнале бессмысленна.
    """),
    blk("Риск 0.5–1% на сделку — математика выживания", """
        Риск на сделку — сколько USDT вы готовы потерять, если стоп сработает. Не размер позиции, а именно убыток в деньгах.
        Депозит 1000 USDT, риск 1% = 10 USDT максимум на одну идею. Формула: Размер_номинала = Риск_USDT / (Стоп_в_% / 100).
        Стоп 0.5% от цены → при том же риске в USDT позиция в 2 раза больше, чем при стопе 1%. Ужесточили стоп —
        купили больше контрактов — ликвидация ближе. Десять убыточных сделок подряд при 1% риска — минус ~10% депозита,
        терпимо для обучения. Десять убытков по 10% на сделку — счёт почти уничтожен. Профессионалы редко рискуют больше 1%.
        0.5% — мягче для первых пятидесяти сделок. Всегда считайте до клика: запишите вход, стоп, риск %, размер в USDT.
        Калькулятор на Binance покажет маржу и ликвидацию — сверьте со стопом.
    """),
    blk("Пошаговый расчёт размера позиции", """
        Пример на BINANCE:BTCUSDT. Депозит 1000 USDT, риск 1% = 10 USDT. Вход 67000, стоп 66330 (−1%).
        Расстояние стопа 670 USDT / 67000 = 1%. Размер ≈ 10 / 0.01 = 1000 USDT номинала. При плече 5x маржа ≈ 200 USDT.
        Если стоп 66500 (−0.75%): размер ≈ 10 / 0.0075 ≈ 1333 USDT — больше контрактов при том же риске в деньгах.
        Если уменьшить риск до 0.5% = 5 USDT при стопе 1%: размер 500 USDT. Три рычага: риск %, дистанция стопа, плечо.
        Плечо не увеличивает допустимый риск в USDT — только сжимает маржу. Ошибка новичка: «плечо 10x, значит рискую 10%» —
        нет, риск % задаёте вы, плечо — сколько маржи заблокировать. Таблица в блокноте: депозит, риск %, стоп %, размер.
    """),
    blk("Первый депозит — учебный, не последние деньги", """
        Сумма, которую потеряете без паники и без влияния на аренду, еду и долги. Для кого-то 50 USDT, для кого-то 500 —
        честно с собой, не с инфлюенсером. Не берите кредит на трейдинг. Не «догоняйте» депозит после минуса удвоением размера.
        Учебный депозит покупает опыт, журнал и привычку стопа — не Lamborghini. Когда статистика 50+ сделок с соблюдением
        правил даёт понимание edge — можно обсуждать масштаб. До тех пор — микро-размер. В РФ и LATAM пополнение через P2P
        в escrow чате биржи; никогда по ссылке из Telegram. KYC и 2FA — до первого USDT на счёте.
        Разделите «кошелёк для жизни» и «кошелёк для обучения» ментально, даже если физически один аккаунт.
    """),
    blk("Как объяснить другу про ордера и риск", """
        Сценарий за кофе: «Лимитка — как заказ в ресторане: назвал цену, ждёшь. Маркет — съел что дали по меню сейчас,
        может быть дороже. На фьючерсе каждые 8 часов кто-то кому-то платит funding — как аренда за ставку на направление.
        Я рискую 1% счёта на сделку — десять плохих дней подряд не убьют меня. Скальпинг — спринт, свинг — пробежка в парке;
        я пока учусь бегать в парке на 15m. Tiger и Vataga — для спринта, когда научусь читать стакан. Не лезу в чаты с 100x.»
        Если друг спрашивает «сколько заработаешь» — честно: «Не знаю за день. Знаю, сколько готов потерять на одной сделке.»
        Покажите на телефоне спред bid/ask на BTC — это уже урок без денег.
    """),
    blk("Связка Trade Master + TradingView + биржа", """
        Урок даёт теорию. TradingView — разметка уровней и сценарий «если цена сделает X». Биржа — исполнение только по плану.
        Журнал связывает тройку: что планировали на графике, что нажали на бирже, что почувствовали до и после.
        Finera и похожие приложения учат копить; они не учат стакану и не ведут к практике на вашем графике — разрыв,
        который закрывает Trade Master. После этого урока откройте BINANCE:BTCUSDT 5m, измерьте спред, посчитайте размер
        при вашем депозите. Следующий урок — амплитуда и ATR: без них стоп и тейк — случайные числа.
    """),
    blk("Чеклист перед первой реальной сделкой", """
        1) Сетап назван словами (не «красиво выглядит»). 2) Вход, стоп, тейк записаны в журнале. 3) Размер посчитан из риска %.
        4) Комиссия maker/taker учтена. 5) Funding проверен, если держите дольше 8 часов. 6) Эмоция «жадность/страх/FOMO» —
        если да, пропуск. 7) Изолированная маржа, плечо не выше 3x на старте. Нет пункта — нет клика.
        Профессионал может пропустить десять сетапов в день; любитель торгует скуку. Ваша цель на неделю — не прибыль,
        а десять записей в журнале с полным планом, хотя бы половина без клика (наблюдение). Дисциплина измеряется пропусками,
        а не количеством сделок.
    """),
]

_L2_EN = [
    blk("Limit vs market orders", """
        The exchange only sees orders — not your conviction. A limit order waits at your price and often earns maker fee
        by adding liquidity to the book. A market order fills immediately at the best available prices — taker fee plus
        possible slippage across multiple levels on size. Analogy: limit is ordering a dish at a listed price and waiting;
        market is grabbing whatever is on the counter now, maybe pricier. Beginners hammer market from FOMO and pay spread
        and double the fee. Pros use market only when speed matters more than a few ticks of cost. Open order history on
        Binance and learn statuses: New, Partially Filled, Filled, Canceled. Check maker/taker rates for your VIP tier before
        the first live click. Fifty taker scalps per day can cost 1–2% of deposit weekly in fees alone — edge must exceed that tax.
    """),
    blk("Maker, taker, and funding", """
        Maker posted liquidity; taker removed it. On Binance Futures, maker ~0.02% and taker ~0.04% is a common baseline —
        taker is twice as expensive. Funding on perpetuals transfers between longs and shorts every eight hours to anchor
        futures near spot. Positive funding means longs pay shorts — overheated upside. Hold a long a week at +0.01% three
        times daily and funding can erase a modest target. Intraday traders often flat before funding; swing traders check
        CoinGlass or the exchange tab before multi-day holds. Funding is rent on directional exposure, not optional trivia.
        Log whether your plan crosses a funding timestamp and estimate USDT impact before entry.
    """),
    blk("Tiger, Vataga, and execution terminals", """
        Binance web UI is enough to learn limits, markets, and stops. Scalpers on 5m need hotkeys, footprint clusters, fast
        depth, and tape — Tiger.Trade and Vataga are popular in CIS, connected via trade-only API without withdraw rights.
        Beginners should master the exchange and TradingView 15m markup before terminals. Order of learning: exchange →
        higher timeframe plan → 5m book → terminal for execution speed. TradingView plans; the terminal clicks — never the reverse.
        API keys: trade permission only, IP whitelist, never share withdraw-enabled keys. Terminals save seconds; without book
        skills, faster clicks only accelerate losses.
    """),
    blk("Scalping vs swing and 0.5–1% risk", """
        Scalping is seconds to minutes, high fee load, mandatory book skills. Intraday swing uses 15m–1h, fewer trades, more
        planning time. Newbies who start scalping for «fast money» usually donate to fees first. Course recommendation:
        first twenty to thirty trades as 15m swing at 0.5% risk with full journal, no terminal. Risk per trade is USDT lost
        if stop hits — not position notional. Formula: Size = Risk_USDT / (stop% / 100). Ten losses at 1% risk ≈ −10% account —
        survivable. Ten losses at 10% per trade ends the account. First deposit is tuition only — no loans, no revenge deposits.
        Pick one style for month one and stick to it so journal stats mean something.
    """),
    blk("Position sizing walkthrough", """
        Example on BINANCE:BTCUSDT. Deposit 1000 USDT, 1% risk = 10 USDT max loss. Entry 67000, stop 66330 (−1%).
        Notional size ≈ 10 / 0.01 = 1000 USDT. At 5x leverage margin ≈ 200 USDT. Tighter stop 0.75% increases contracts
        for the same dollar risk — liquidation moves closer. Leverage does not increase allowed risk percent; it only
        compresses margin blocked. Write a notebook table: deposit, risk %, stop %, size, margin. Calculate before every click;
        if liquidation sits inside your stop distance, reduce size or leverage. BNB fee discount helps after you understand base rates.
    """),
    blk("Checklist and Trade Master loop", """
        Name the setup in words. Log entry, stop, target. Size from risk percent. Note maker/taker and funding if holding >8h.
        Skip on FOMO, greed, or fear. Isolated margin, modest leverage for beginners. No complete checklist — no click.
        Trade Master links lesson → TradingView markup → journal; signal groups skip the chart step. After this lesson open
        BTCUSDT 5m, measure bid/ask spread, size a hypothetical trade at 1% risk. Next lesson covers amplitude and ATR —
        without measurement, stops and targets are random. Professionals skip ten setups a day; amateurs trade boredom.
    """),
]

_L2_PT = [
    blk("Ordens limit e market", """
        A exchange só vê ordens. Limit espera seu preço e costuma pagar taxa maker. Market executa agora como taker —
        taxa maior e slippage em tamanho. Iniciantes usam market por FOMO; profissionais usam market só quando velocidade
        importa mais que alguns ticks. Cinquenta scalps taker por dia podem custar 1–2% do depósito em taxas semanais.
        Abra o histórico de ordens na Binance e aprenda os status antes do primeiro clique real.
    """),
    blk("Maker, taker e funding", """
        Maker adiciona liquidez; taker remove. No futuros Binance, taker costuma o dobro do maker. Funding a cada 8h
        transfere entre longs e shorts no perpétuo. Funding positivo: longs pagam — mercado aquecido. Swing de vários dias
        deve calcular funding antes da entrada. Intraday fecha antes do horário de funding quando possível.
    """),
    blk("Tiger, Vataga e scalping vs swing", """
        Interface web da Binance basta para aprender. Tiger.Trade e Vataga aceleram scalping com book e hotkeys via API
        só de trade. Iniciante: swing no 15m com risco 0,5% antes do terminal. Scalping = segundos e muitas taxas;
        swing = horas e menos cliques. Escolha um estilo no primeiro mês.
    """),
    blk("Risco 0,5–1% e tamanho", """
        Risco = USDT perdido se o stop bater. Fórmula: Tamanho = Risco / stop%. Depósito 1000, risco 1% = 10 USDT.
        Dez stops seguidos a 1% ≈ −10% da conta — suportável. Primeiro depósito = valor de treino, sem empréstimo.
        Calcule tamanho antes do clique; alavancagem não aumenta o risco % permitido.
    """),
    blk("Checklist e ciclo Trade Master", """
        Setup nomeado, entrada/stop/alvo, tamanho pelo risco, sem FOMO. Sem checklist — sem clique.
        Trade Master liga lição → TradingView → diário. Abra BTCUSDT 5m, meça spread, planeje trade de 1% de risco sem clicar.
        Próxima lição: amplitude e ATR.
    """),
]

# ─── Lesson 3 RU: Amplitude, ATR, BTC vs alts ─────────────────────────────────
_L3_RU = [
    blk("Что такое амплитуда движения", """
        Амплитуда — насколько далеко цена прошла за выбранный период, в процентах от цены. Откройте BINANCE:BTCUSDT 15m
        и измерьте расстояние от минимума до максимума последней часовой свечи. Если BTC при 80000 прошёл 800 пунктов —
        это 1% за час, для биткоина уже заметно. На BINANCE:PEPEUSDT за тот же час 8% — для мем-альта обычный вторник.
        Новичок ставит тейк 0.3% на BTC и на альте одинаково: на одном задыхается в шуме, на другом недобирает движение.
        Амплитуда отвечает: «сколько рынок вообще ходит здесь?» Прежде чем искать вход, измерьте норму за 20 последних свечей.
        Запишите в журнал: пара, ТФ, средний range % — это линейка для стопа и цели на неделю вперёд.
    """),
    blk("ATR простыми словами", """
        ATR (Average True Range) — средний размах свечи, не направление. Добавьте ATR(14) на 15m в TradingView.
        Значение 120 USDT на BTC при 67000 ≈ 0.18% за свечу 15m. Стоп уже ATR — вас выбьет шумом; стоп в 2–3×ATR даёт место
        для нормального дыхания цены. Тейк 1×ATR — скромный скальп внутри свечи; 2–3×ATR — свинг внутри дня. ATR растёт
        на новостях FOMC, CPI, на листингах — пересчитывайте перед сессией, не используйте вчерашний ATR в день отчёта.
        На альтах ATR в процентах выше — плечо и риск % должны быть ниже, чем на BTC. ATR не говорит «куда» — только «как широко».
    """),
    blk("BTC vs альты: разные скорости одного рынка", """
        BTC — локомотив: капитал сначала туда, меньше % амплитуда на 15m в спокойный день (0.3–0.8% типично).
        ETH, SOL — средний класс: 1–3% на 15m в активную сессию. PEPE, ARB — высокая волатильность: 5–15% за сессию не редкость.
        Альты часто двигаются с множителем к BTC: BTC +1%, SOL +2–3% в альтсезон. Перед лонгом альты посмотрите BTCUSDT 15m —
        если биткоин падает, альт редко спасёт ваш лонг. Не копируйте стоп 0.5% с BTC на PEPE: там шум шире, стоп сработает
        на случайном тике. Правило курса: отдельная строка в журнале «BTC контекст» перед каждой альт-сделкой.
    """),
    blk("Плечо и амплитуда — почему мем с 20x убивает быстрее", """
        Высокая амплитуда + высокое плечо = ликвидация от обычного шума. BTC 5x на 15m с стопом за 1.5×ATR — терпимо для обучения.
        PEPE 20x с тем же стопом в % — ликвидация ближе, чем ваш план. Формула та же: риск в USDT фиксирован, но волатильность
        диктует ширину стопа, а ширина стопа диктует размер. На волатильном активе при том же риске USDT позиция меньше в номинале,
        но новичок увеличивает плечо «чтобы заработать больше» — и получает margin call. Мемы и низколиквидные пары: 2–3x или спот.
        Калькулятор ликвидации на Binance — обязательный шаг до Buy на альте.
    """),
    blk("Тейк-профит под амплитуду сессии", """
        Нереалистичный тейк — причина «всё время почти в плюсе, но в минусе». Измерьте средний range последних 20 свечей 15m.
        Тейк 0.5× сессионной амплитуды — консервативный скальп; 1–1.5× — свинг внутри дня после сетапа. Жадность «5% за час без
        новости» — не план, а лотерея. Если до ближайшего сопротивления меньше планируемого тейка — цель режьте или сетап отменяйте.
        Частичная фиксация на +1R снимает давление «всё или ничего». Запишите в плане: «тейк основан на ATR/range = X%» — потом
        сравните с фактом в журнале.
    """),
    blk("Практика измерения на 15m", """
        Откройте BINANCE:BTCUSDT и BINANCE:SOLUSDT на 15m рядом. Для каждой: high-low последних 20 свечей в %, ATR(14) в %.
        Сравните со своим типичным стопом. Если стоп уже среднего range — вы торгуете шум. Повторите для PEPEUSDT — увидите разницу
        шкал. Сделайте скрин с подписями. Без сделки — только измерение. Это 20 минут, которые спасут депозит от случайных цифр.
        Trade Master учит измерять до входа; сигнальные чаты дают «вход сейчас» без линейки — отсюда разный результат через месяц.
    """),
    blk("Типичные ошибки новичка с амплитудой", """
        Одинаковый тейк на все монеты. Игнор BTC при торговле альтом. Плечо как на BTC на меме. Стоп «на глаз» без %.
        Усреднение на падающем альте без пересчёта ATR. Торговля в первые минуты листинга с размером как на BTC.
        Исправление: таблица в журнале — пара, ATR%, средний range 20 свечей, стоп %, тейк %, соотношение к ATR.
        Через 30 записей увидите, где стопы слишком узкие.
    """),
    blk("Как объяснить другу про амплитуду", """
        «У биткоина одна скорость ходьбы, у дешёвой монеты — спринт. Сначала меряем, сколько монета ходит за час, потом ставим
        стоп и цель. ATR — средний шаг свечи. Если стоп меньше шага — нас выкинет на случайном чихе рынка. Я не угадываю —
        я подгоняю план под норму движения.» Покажите три графика: BTC, SOL, PEPE — один ТФ, разная ширина свечей. Друг поймёт без формул.
    """),
    blk("ATR, размер позиции и риск в USDT", """
        Широкий ATR → шире стоп → меньше контрактов при том же риске USDT. Пример: риск 10 USDT, стоп 0.5% на BTC — размер 2000 USDT.
        На PEPE стоп 2% при том же риске — размер 500 USDT. Не сужайте стоп на волатильной монете «чтобы влезло больше» —
        вас выбьет. Либо уменьшите риск %, либо выберите менее волатильную пару для обучения. ETHUSDT — хороший мост между BTC и альтами.
    """),
    blk("Итог: амплитуда до входа, журнал после", """
        Амплитуда и ATR — не «для продвинутых», а базовая линейка новичка. BTC и альты — разные шкалы; контекст BTC обязателен.
        Следующий урок — поддержка по лоям: уровни строятся на тех же свечах, которые вы уже умеете измерять. Домашка: три пары,
        15m, range 20 свечей + ATR в журнал. Без клика на бирже. Когда сможете вслух назвать ATR% для BTC — готовы к уровням.
    """),
]

_L3_EN = [
    blk("What is price amplitude", """
        Amplitude is how far price traveled in a period, as percent of price. On BINANCE:BTCUSDT 15m, measure high-low of recent
        candles — 1% per hour matters on BTC. On PEPE, 8% in an hour can be normal. Newbies use identical targets on all symbols:
        stopped out on noise on one, undercaptured on another. Measure the last twenty candles before any entry. Log pair, timeframe,
        average range % — your ruler for stops and targets. Without measurement, stops and targets are random numbers dressed as strategy.
    """),
    blk("ATR in plain language", """
        ATR(14) is average candle range, not direction. On BTC 15m, a stop tighter than ATR gets noise-stopped; 2–3× ATR gives room.
        Targets at 1× ATR are modest scalps; 2–3× ATR suit intraday swings. ATR expands on news days — recalculate before session.
        On alts, ATR% is higher — use lower leverage and smaller risk percent. ATR answers «how wide», not «which way».
    """),
    blk("BTC vs alts", """
        BTC is the locomotive with smaller 15m % moves in calm sessions. ETH and SOL sit in the middle; memes like PEPE swing 5–15%.
        Alts often amplify BTC moves. Check BTCUSDT before alt longs — falling BTC rarely saves your alt position. Do not copy BTC
        0.5% stops to PEPE. Journal line: «BTC context» before every alt trade. ARBUSDT and SOLUSDT teach amplitude faster than BTC alone.
    """),
    blk("Leverage, targets, and mistakes", """
        High amplitude plus high leverage equals liquidation from normal noise. Size from fixed USDT risk; wider stops mean smaller
        notional. Partial take at +1R reduces all-or-nothing stress. Common errors: same target everywhere, ignoring BTC, eyeball stops.
        Fix with a table: pair, ATR%, range, stop%, target%. Explain to a friend: «BTC walks, memes sprint — measure first.»
        Practice: open BTC, SOL, PEPE on 15m, compare ranges — screenshot without trading.
    """),
    blk("Sizing with ATR and lesson close", """
        Wide ATR → wider stop → fewer contracts for same USDT risk. ETHUSDT bridges BTC and alt volatility for learning.
        Amplitude and ATR are beginner rulers, not advanced trivia. Next lesson: support by swing lows on the same candles you measure.
        Homework: three pairs, 15m, log twenty-candle range and ATR — no live click until you can state BTC ATR% aloud.
    """),
]

_L3_PT = [
    blk("Amplitude de movimento", """
        Amplitude é o quanto o preço andou no período, em %. BTC no 15m move menos % que PEPE ou SOL. Meça as últimas 20 velas
        antes de entrar. Sem medição, stop e alvo são chutes. Registre par, timeframe e range médio no diário.
    """),
    blk("ATR e BTC vs alts", """
        ATR(14) mede a largura média da vela, não direção. Stop menor que ATR sofre ruído. Em alts o ATR% é maior — menos alavancagem.
        BTC é contexto obrigatório antes de long em alt. Não copie stop de BTC para meme coin.
    """),
    blk("Alavancagem e alvos", """
        Alta amplitude + alta alavancagem = liquidação rápida. Tamanho pelo risco USDT fixo. Take parcial em +1R.
        Erros: mesmo alvo em todas as moedas, ignorar BTC, stop no olho.
    """),
    blk("Prática e resumo", """
        Abra BTC, SOL e PEPE no 15m; compare ranges e ATR. Print sem operar. ETHUSDT é bom para treinar entre BTC e alts.
        Próxima lição: suporte pelos fundos. Lição completa quando explicar amplitude em dois minutos.
    """),
]

# ─── Lesson 4: Support by lows ─────────────────────────────────────────────────
_L4_RU = [
    blk("Что такое свинг-лой", """
        Свинг-лой (swing low) — локальный минимум, после которого цена отскочила вверх и сформировала новый мини-максимум.
        На BINANCE:ETHUSDT 15m найдите три таких точки за последнюю неделю. Не каждая длинная нижняя тень — лой: нужен отскок,
        подтверждённый следующими свечами. Аналогия: пол в квартире, от которого мяч несколько раз отпрыгнул вверх — не каждая царапина на плитке.
        Один лой — наблюдение. Два касания — идея уровня. Три и более — зона, где рынок «помнит» цену. Новичок рисует двадцать линий
        под каждой тенью; профессионал оставляет три–пять уровней на сессию. Меньше линий — больше ясности в плане.
    """),
    blk("Как строить поддержку по лоям", """
        Алгоритм на 15m/1h: найдите три значимых лоя на одной высоте ±0.1–0.3% (зона, не копейка). Проведите горизонталь.
        Решите единый стиль: по телам свечей или по экстремумам теней — и держитесь его на всём графике. ETH часто уважает зоны
        шире, чем BTC. Старший таймфрейм (1h) важнее младшего (5m): уровень с 1h сильнее, чем случайный лой на 5m.
        Поддержка — не «магическая линия», а память рынка о цене, где покупатели раньше входили. Когда цена подходит снова,
        вопрос: покупатели снова появятся или уровень истощён? Журнал: дата построения, число касаний, пара.
    """),
    blk("Сила уровня от числа касаний", """
        Больше касаний — больше внимания трейдеров к уровню, но и больше шанс пробоя: ликвидность под уровнем собирают стопы.
        Первое касание после долгого роста — часто отскок. Пятое касание за день — риск «протёртого» пола. Записывайте в журнал:
        «касание №3 от уровня 2450 ETH». Со временем увидите, на каком касании ваши планы чаще работают. Не входите только потому,
        что «уровень есть» — нужен сценарий: отскок с реакцией свечи или ложный пробой с закрытием обратно.
    """),
    blk("Ложный пробой вниз — охота на стопы", """
        Ложный пробой: цена уходит ниже поддержки тенью, но закрывается обратно выше уровня. Классическая охота стопов лонгов,
        стоящих ровно под лоем. Новичок ставит стоп на 1 тик ниже минимума — его забирают перед разворотом. Профессионал ставит
        стоп ниже экстремума ложного пробоя или ниже зоны с запасом 0.2–0.5% на ETH 15m. Вход в лонг — после закрытия свечи обратно
        над уровнем, не на первом тике вверх. На 5m ложных пробоев больше — фильтруйте закрытием 15m. Скрин каждого ложного пробоя в журнал.
    """),
    blk("Тени vs тела — единый стиль разметки", """
        Если строите по теням — стопы и касания считайте по теням. Если по телам — не смешивайте. Смешение даёт «уровень, который
        сам себе противоречит». На волатильных альтах тени длиннее — зона шире. BTC на 15m часто аккуратнее. Сравните BINANCE:ETHUSDT
        и BINANCE:BTCUSDT на одном участке: у ETH зоны поддержки визуально толще. Это не ошибка — это характер инструмента.
        Перед сделкой спросите: «Мой стоп согласован со стилем линии?»
    """),
    blk("Таймфреймы 5m и 1h — иерархия", """
        План на 1h: где главная поддержка недели. Триггер на 15m: реакция у уровня. 5m — точность входа, не место для поиска «новых»
        уровней с нуля. Ошибка: нарисовать поддержку на 5m и игнорировать, что на 1h цена в пустоте. Правило: старший ТФ задаёт
        зону, младший — тайминг. Если на 1h уровень далеко — на 5m скальп к этой поддержке может быть ранним.
    """),
    blk("Вход у поддержки — сценарий, не надежда", """
        Минимум: уровень + реакция (пин-бар, поглощение, сужение range) + BTC не падает ножом. Стоп ниже зоны, не внутри неё.
        Тейк минимум 1:2 к риску или у ближайшего сопротивления. Без реакции свечи — это «ловля падающего ножа», не трейдинг уровня.
        Риск 0.5–1% депозита, размер из формулы урока 2. Лимитный вход у уровня предпочтительнее маркета — maker fee и контроль цены.
    """),
    blk("Как объяснить другу про поддержку", """
        «Представь пол, от которого мяч три раза отскочил. Ложный пробой — мяч чуть прокатился под плинтус и вернулся.
        Я не покупаю только потому, что пол есть — жду, когда мяч от него отскочит, и ставлю стоп, если прокатился всерьёз.»
        Покажите ETHUSDT с тремя лоями и одним ложным пробоем — друг поймёт без терминов «свинг» и «ликвидность».
    """),
    blk("Журнал уровней", """
        Колонки: пара, ТФ, цена зоны, число касаний, дата последнего касания, исход (отскок/пробой/ложный пробой), скрин.
        Через месяц у вас база «как ведёт себя ETH на 15m у третьего касания» — это edge, не сигнал из чата. Обновляйте уровни:
        пробитая поддержка часто становится сопротивлением при ретесте сверху — тема следующих уроков по паттернам.
    """),
    blk("Ошибки и итог урока", """
        Двадцать линий на графике. Один лой без подтверждения. Лонг без стопа «потому что поддержка». Стоп под каждой тенью 5m.
        Исправление: 3–5 уровней, старший ТФ, ждать закрытия свечи на ложном пробое. Следующий урок — стакан: кто стоит на bid у вашей поддержки.
    """),
]

_L4_EN = [
    blk("Swing lows and building support", """
        A swing low is a local minimum followed by a bounce and a higher mini-high. On BINANCE:ETHUSDT 15m find three such points.
        Two touches suggest a level; three or more form a zone. Draw horizontal support through lows using consistent wick or body rules.
        Higher timeframe (1h) outweighs 5m noise. Support is market memory of prior buying — not magic. Log each level: price zone,
        touch count, date. Professionals keep three to five levels per session; amateurs paint twenty lines and confuse themselves.
    """),
    blk("False breaks and entries", """
        False break: wick below support, close back above — stop hunt on longs parked exactly under the low. Place stops below the
        false-break extreme or zone with buffer on ETH 15m. Enter long after candle close above level, not first uptick. Filter 5m
        fakes with 15m close. Entry needs level plus reaction candle plus BTC context — not hope. Stop below zone; target min 1:2 R:R.
        Limit entries near support beat market for maker fee and price control.
    """),
    blk("Timeframes, journal, and summary", """
        1h defines weekly support; 15m triggers; 5m refines timing only. Journal: pair, zone, touches, outcome, screenshot. Common errors:
        one unconfirmed low, long without stop, stops on every 5m wick. Next lesson: order book — who bids at your support. Practice:
        mark ETHUSDT 15m supports and one false break from last seven days — plan only, no click.
    """),
]

_L4_PT = [
    blk("Fundos de swing e suporte", """
        Swing low é mínimo local com bounce. Dois toques sugerem nível; três formam zona. Use regra consistente: pavios ou corpos.
        Timeframe maior (1h) pesa mais que 5m. Registre zona, toques e data no diário.
    """),
    blk("Falso rompimento e entrada", """
        Falso rompimento: pavio abaixo, fechamento acima — caça stops. Entre long após fechamento acima do nível. Stop abaixo da zona.
        Entrada precisa de nível + reação + contexto BTC. Alvo mínimo 1:2.
    """),
    blk("Prática ETHUSDT", """
        Marque suportes em ETHUSDT 15m e um falso rompimento da semana. Plano sem clique. Próxima lição: book de ofertas.
        Máximo 3–5 níveis por sessão.
    """),
]

from _part01b_lessons_5_12 import LESSON_BLOCKS  # noqa: E402
from _part01b_depth import (  # noqa: E402
    DEEPEN_RU, DEEPEN_EN, DEEPEN_PT, apply_deepen, en_extra_blocks, pt_extra_blocks,
    ensure_ru_words, ensure_en_words, ensure_pt_words,
)

LESSON_META = {
    2: dict(mod="MOD_INTRO", diff="Beginner", mins=38, chart="order_flow", sym="BINANCE:BTCUSDT", interval="15",
            markets=("No Brasil, Tiger Trade e TradingView são padrão entre scalpers em Binance.",
                     "En México muchos usan TradingView + Binance con P2P USDT.",
                     "В РФ Tiger, Vataga, CScalp — стандарт для скальпа на Binance Futures.",
                     "Trade Master: plan before click, journal after every session.")),
    3: dict(mod="MOD_CHART", diff="Beginner", mins=34, chart="momentum", sym="BINANCE:BTCUSDT", interval="15",
            markets=("No Brasil aplique amplitude em pares líquidos Binance como BTCUSDT.",
                     "En México practique price amplitude en BTCUSDT con USDT.",
                     "В РФ отрабатывайте на ликвидных парах Binance, например BTCUSDT.",
                     "Measure range before every entry.")),
    4: dict(mod="MOD_CHART", diff="Beginner", mins=35, chart="support_resistance", sym="BINANCE:ETHUSDT", interval="15",
            markets=("No Brasil aplique suporte pelos fundos em ETHUSDT.",
                     "En México practique support by lows en ETHUSDT.",
                     "В РФ отрабатывайте поддержку по лоям на ETHUSDT.",
                     "Support zones, not penny lines.")),
    5: dict(mod="MOD_CHART", diff="Intermediate", mins=38, chart="order_flow", sym="BINANCE:BTCUSDT", interval="5",
            markets=("No Brasil o book BTC 5m é base para scalpers.",
                     "En México practique order book en BTCUSDT 5m.",
                     "В РФ стакан BTC 5m — обязательное наблюдение перед скальпом.",
                     "Book + chart, not chart alone.")),
    6: dict(mod="MOD_CHART", diff="Intermediate", mins=33, chart="momentum", sym="BINANCE:BTCUSDT", interval="15",
            markets=("No Brasil ajuste tamanho em notícias FOMC.",
                     "En México reduzca tamaño en mercado rápido.",
                     "В РФ на быстром рынке режьте размер вдвое.",
                     "Fast vs slow regime rules.")),
    7: dict(mod="MOD_RISK", diff="Beginner", mins=36, chart="risk_reward", sym="BINANCE:BTCUSDT", interval="15",
            markets=("No Brasil evite grupos VIP de sinais.",
                     "En México cuidado con señales Telegram.",
                     "В РФ не копируйте «гарантированные» сигналы.",
                     "Checklist beats FOMO.")),
    8: dict(mod="MOD_PAT", diff="Intermediate", mins=34, chart="breakout", sym="BINANCE:SOLUSDT", interval="15",
            markets=("No Brasil marque triângulo descendente em SOLUSDT.",
                     "En México descending triangle en SOLUSDT.",
                     "В РФ нисходящий треугольник на SOLUSDT.",
                     "Pattern + volume filter.")),
    9: dict(mod="MOD_PAT", diff="Intermediate", mins=34, chart="breakout", sym="BINANCE:SOLUSDT", interval="15",
            markets=("No Brasil triângulo ascendente em SOLUSDT.",
                     "En México ascending triangle en SOLUSDT.",
                     "В РФ восходящий треугольник на SOLUSDT.",
                     "Breakout-retest discipline.")),
    10: dict(mod="MOD_STR", diff="Intermediate", mins=37, chart="breakout", sym="BINANCE:ETHUSDT", interval="15",
             markets=("No Brasil estratégia de impulso em ETHUSDT.",
                      "En México impulse strategy en ETHUSDT.",
                      "В РФ импульсы на ETHUSDT 15m.",
                      "No FOMO chase on impulse candle.")),
    11: dict(mod="MOD_MKT", diff="Beginner", mins=32, chart="price_chart", sym="BINANCE:PEPEUSDT", interval="15",
             markets=("No Brasil leia Announcements Binance.",
                      "En México riesgo de delisting en alts.",
                      "В РФ следите за делистингом на Binance.",
                      "Exit early on delist news.")),
    12: dict(mod="MOD_MKT", diff="Beginner", mins=33, chart="momentum", sym="BINANCE:ARBUSDT", interval="15",
             markets=("No Brasil listagens com tamanho mínimo.",
                      "En México new listing volatility en ARBUSDT.",
                      "В РФ листинг ARBUSDT — урок волатильности.",
                      "Observe first hour, trade later.")),
}

LOCALE = {
    2: dict(
        ru=dict(title="Вводное. С чего начать в трейдинге? Часть 2",
                subtitle="Лимит/маркет, maker/taker, funding, терминалы, скальпинг vs свинг, риск 0.5–1%",
                outcome="Поймёте типы ордеров, комиссии, funding, терминалы Tiger/Vataga и расчёт риска на сделку.",
                content="Биржа понимает только ордера — научитесь говорить с ней на языке лимита, маркета и процента риска.",
                takeaway="Скальпинг требует терминал и низкую комиссию; новичку — свинг на 15m с риском 0.5–1%.",
                chart_title="Ордера и комиссии", chart_cap="Лимит добавляет ликвидность (maker). Маркет забирает (taker).",
                tv_body="Откройте BINANCE:BTCUSDT 5m. Найдите спред bid/ask. Посчитайте размер при стопе 0.8% и риске 1%.",
                example="Депозит 1000 USDT, риск 1% = 10 USDT. Вход BTC 67000, стоп 66500 (−0.75%). Размер ≈ 1333 USDT номинала. При плече 5x маржа ≈ 267 USDT.",
                bullets=["Лимит = maker, маркет = taker", "Funding каждые 8ч", "Tiger/Vataga после базы", "Свинг 15m первым", "Риск 0.5–1%", "Считайте размер до клика", "Чеклист перед сделкой"],
                journal_items=["Спред BTC и funding", "Пример расчёта размера", "Скальп или свинг на месяц"],
                tip="Не начинайте скальпинг без стакана — сначала 15m свинг. Trade Master + TradingView = полный цикл."),
        en=dict(title="Intro: Where to start? Part 2",
                subtitle="Limit/market, maker/taker, funding, terminals, scalping vs swing, 0.5–1% risk",
                outcome="Understand order types, fees, funding, Tiger/Vataga, and position sizing from risk %.",
                content="The exchange only sees orders — learn limit, market, and risk math.",
                takeaway="Scalping needs terminal and low fees; beginners start swing 15m at 0.5–1% risk.",
                chart_title="Orders and fees", chart_cap="Limit = maker. Market = taker.",
                tv_body="Open BINANCE:BTCUSDT 5m. Note spread. Size for 0.8% stop and 1% risk.",
                example="1000 USDT, 1% risk = 10 USDT. Entry 67000, stop 66500. Size ≈ 1333 USDT notional at 5x.",
                bullets=["Limit maker, market taker", "Funding every 8h", "15m swing first", "Risk 0.5–1%", "Size before click", "Checklist mandatory", "Journal every session"],
                journal_items=["Spread and funding", "Size calc example", "Scalp vs swing choice"],
                tip="Don't scalp without book skills — start 15m swing."),
        pt=dict(title="Intro: Por onde começar? Parte 2",
                subtitle="Limit/market, maker/taker, funding, terminais, scalping vs swing",
                outcome="Entenda ordens, taxas, funding e tamanho pela % de risco.",
                content="A exchange só vê ordens — aprenda limit, market e risco.",
                takeaway="Scalping precisa de terminal; iniciante começa swing 15m.",
                chart_title="Ordens e taxas", chart_cap="Limit = maker. Market = taker.",
                tv_body="Abra BTCUSDT 5m. Veja spread. Calcule tamanho com risco 1%.",
                example="1000 USDT, risco 1% = 10 USDT. Stop 0,75% → ~1333 USDT nocional.",
                bullets=["Limit maker, market taker", "Funding a cada 8h", "Swing 15m primeiro", "Risco 0,5–1%", "Calcule antes do clique", "Checklist", "Diário"],
                journal_items=["Spread e funding", "Exemplo de tamanho", "Scalp ou swing"],
                tip="Não faça scalping sem book — comece 15m."),
    ),
    3: dict(
        ru=dict(title="Амплитуда движения", subtitle="ATR, процентные движения BTC vs альтов",
                outcome="Научитесь измерять амплитуду и ATR до входа и подбирать стоп/тейк под BTC и альты.",
                content="Амплитуда — линейка рынка; без неё стоп и тейк случайны.",
                takeaway="BTC и альты — разные шкалы; ATR(14) на 15m — ваш первый индикатор размера.",
                chart_title="Амплитуда и ATR", chart_cap="Измерьте range 20 свечей и ATR перед каждым сетапом.",
                tv_body="BINANCE:BTCUSDT и SOLUSDT 15m: сравните range % и ATR. Запишите в журнал.",
                example="BTC ATR 0.18% на 15m → стоп 0.5% ≈ 2.8×ATR. PEPE ATR 3% → тот же стоп в % слишком узок; стоп 1.5% или меньше плечо.",
                bullets=["Амплитуда в % до входа", "ATR — ширина свечи", "BTC контекст для альтов", "Плечо ниже на мемах", "Тейк под range", "Журнал измерений", "Не копируйте стопы"],
                journal_items=["BTC/SOL/PEPE range 20 свечей", "ATR% каждой пары", "Стоп в единицах ATR"],
                tip="Сначала измерение — потом кнопка Buy."),
        en=dict(title="Price amplitude", subtitle="ATR and BTC vs alts",
                outcome="Measure amplitude and ATR before entries; size stops for each symbol.",
                content="Amplitude is your market ruler — without it, stops are random.",
                takeaway="BTC and alts use different scales; ATR(14) on 15m sizes risk.",
                chart_title="Amplitude and ATR", chart_cap="Log twenty-candle range and ATR per pair.",
                tv_body="Compare BTCUSDT and SOLUSDT 15m ranges and ATR on TradingView.",
                example="BTC 0.18% ATR vs PEPE 3% — same stop % means different noise tolerance.",
                bullets=["Measure % range first", "ATR for stop width", "BTC context for alts", "Lower leverage on memes", "Targets fit range", "Journal measurements", "No copied stops"],
                journal_items=["Range on three pairs", "ATR%", "Stop as ATR multiple"],
                tip="Measure before you click."),
        pt=dict(title="Amplitude de movimento", subtitle="ATR e BTC vs alts",
                outcome="Meça amplitude e ATR antes de entrar.",
                content="Amplitude é a régua do mercado.",
                takeaway="BTC e alts têm escalas diferentes.",
                chart_title="Amplitude e ATR", chart_cap="Range de 20 velas + ATR.",
                tv_body="Compare BTC e SOL no 15m.",
                example="ATR de PEPE exige stop mais largo ou menos alavancagem.",
                bullets=["Meça % antes", "ATR guia stop", "Contexto BTC", "Menos alavanca em memes", "Diário", "Alvos realistas", "Não copie stop"],
                journal_items=["Range 3 pares", "ATR%", "Stop em ATR"],
                tip="Meça antes do clique."),
    ),
    4: dict(
        ru=dict(title="Поддержка по лоям", subtitle="Свинг-лои, ложные пробои, сила уровня",
                outcome="Построите поддержку по лоям, отличите ложный пробой и войдёте по сценарию.",
                content="Поддержка — память цены, не магия; нужны касания и реакция.",
                takeaway="2+ лоя, зона не линия; ложный пробой — после закрытия свечи.",
                chart_title="Поддержка по лоям", chart_cap="Горизонталь через свинг-лои на 15m/1h.",
                tv_body="BINANCE:ETHUSDT 15m: три лоя, один ложный пробой за неделю.",
                example="ETH 2450 зона, третье касание, пин-бар 15m, стоп 2435, тейк 2490, риск 0.7%.",
                bullets=["Свинг-лой с отскоком", "3–5 уровней макс", "Ложный пробой — закрытие", "Стоп ниже зоны", "1h важнее 5m", "Лимит у уровня", "Журнал касаний"],
                journal_items=["Уровень ETH и касания", "Ложный пробой да/нет", "План вход/стоп/тейк"],
                tip="Меньше линий — яснее план."),
        en=dict(title="Support by lows", subtitle="Swing lows, false breaks, level strength",
                outcome="Build support from swing lows and trade false breaks with rules.",
                content="Support is market memory — needs touches and reaction candles.",
                takeaway="Zones not pennies; false break confirmed by 15m close.",
                chart_title="Support by lows", chart_cap="Horizontal through swing lows on ETHUSDT.",
                tv_body="ETHUSDT 15m: mark three lows and one false break this week.",
                example="ETH zone 2450, third touch, pin bar, stop 2435, target 2490, 0.7% risk.",
                bullets=["Confirmed swing lows", "Max 3–5 levels", "False break needs close", "Stop below zone", "1h over 5m", "Limit at level", "Touch journal"],
                journal_items=["Level and touches", "False break Y/N", "Entry/stop/target"],
                tip="Fewer lines, clearer plan."),
        pt=dict(title="Suporte pelos fundos", subtitle="Fundos de swing e falsos rompimentos",
                outcome="Construa suporte pelos fundos e opere com regras.",
                content="Suporte é memória de preço — precisa de toques.",
                takeaway="Zona, não centavo; falso rompimento com fechamento.",
                chart_title="Suporte pelos fundos", chart_cap="Horizontal em ETHUSDT 15m.",
                tv_body="Marque três fundos em ETHUSDT.",
                example="Zona 2450, terceiro toque, stop abaixo, alvo 1:2.",
                bullets=["Swing low confirmado", "Máx 3–5 níveis", "Falso rompimento", "Stop abaixo", "1h > 5m", "Limit no nível", "Diário"],
                journal_items=["Nível e toques", "Falso rompimento", "Plano completo"],
                tip="Menos linhas, mais clareza."),
    ),
}

for lid, topic_ru, topic_en, topic_pt in [
    (5, "Стакан. Подробно", "Order book deep dive", "Book de ofertas"),
    (6, "Особенности быстрого и медленного рынка", "Fast vs slow market", "Mercado rápido vs lento"),
    (7, "Основные ошибки новичков. Часть 1", "Beginner mistakes Part 1", "Erros de iniciante Parte 1"),
    (8, "Нисходящий треугольник", "Descending triangle", "Triângulo descendente"),
    (9, "Восходящий треугольник", "Ascending triangle", "Triângulo ascendente"),
    (10, "Торговая стратегия для импульсов", "Impulse trading strategy", "Estratégia para impulsos"),
    (11, "Делистинг монет с биржи", "Delisting risk", "Delisting de moedas"),
    (12, "Листинг", "New listing", "Listagem"),
]:
    m = LESSON_META[lid]
    sym = m["sym"].replace("BINANCE:", "")
    LOCALE[lid] = dict(
        ru=dict(title=topic_ru, subtitle="План до клика, риск 0.5–1%, TradingView + журнал",
                outcome=f"Освоите «{topic_ru}» с разбором на графике и практикой в TradingView.",
                content=f"Урок для новичков: {topic_ru.lower()}.",
                takeaway=f"Дисциплина и журнал важнее одной удачной сделки по теме «{topic_ru}».",
                chart_title=topic_ru, chart_cap=f"Разбор на {m['sym']}, {m['interval']}m.",
                tv_body=f"Откройте {m['sym']} на {m['interval']}m. Найдите пример за 7 дней. Отметьте вход, стоп, цель.",
                example=f"На {sym} примените правило урока: вход, стоп за уровнем, тейк R:R ≥1:2, риск 1% — план без клика.",
                bullets=[f"Тема: {topic_ru}", "План до клика", "Риск 0.5–1%", "TradingView + журнал", "Сетапы не сигналы", "Измеряйте % движения", "Микро-размер"],
                journal_items=["Пара и ТФ", "Вход / стоп / цель", "Эмоция до входа"],
                tip="Trade Master: урок → TradingView → журнал. Не Telegram VIP."),
        en=dict(title=topic_en, subtitle="Plan before click, 0.5–1% risk",
                outcome=f"Master '{topic_en}' with TradingView practice.",
                content=f"Beginner lesson: {topic_en.lower()}.",
                takeaway=f"Process beats one lucky trade on {topic_en}.",
                chart_title=topic_en, chart_cap=f"Study on {m['sym']}.",
                tv_body=f"Open {m['sym']} {m['interval']}m. Mark entry, stop, target.",
                example=f"On {sym}, write plan with 1:2 R:R and 1% risk — no live click.",
                bullets=[topic_en, "Plan before click", "Risk 0.5–1%", "TradingView + journal", "Setups not signals", "Measure % moves", "Small size"],
                journal_items=["Pair & TF", "Entry/stop/target", "Emotion"],
                tip="Full loop: lesson → chart → journal."),
        pt=dict(title=topic_pt, subtitle="Plano antes do clique",
                outcome=f"Dominar '{topic_pt}' com TradingView.",
                content=f"Lição: {topic_pt.lower()}.",
                takeaway="Processo e diário vencem sorte.",
                chart_title=topic_pt, chart_cap=f"{m['sym']}.",
                tv_body=f"Abra {m['sym']} {m['interval']}m.",
                example=f"Em {sym}, plano com R:R 1:2 e risco 1%.",
                bullets=[topic_pt, "Plano antes do clique", "Risco 0,5–1%", "TradingView + diário", "Setups não sinais", "Meça %", "Tamanho pequeno"],
                journal_items=["Par e TF", "Entrada/stop/alvo", "Emoção"],
                tip="Ciclo completo: lição → gráfico → diário."),
    )

RU_BLOCKS = {2: _L2_RU, 3: _L3_RU, 4: _L4_RU}
EN_BLOCKS = {2: _L2_EN, 3: _L3_EN, 4: _L4_EN}
PT_BLOCKS = {2: _L2_PT, 3: _L3_PT, 4: _L4_PT}
for lid, (ru, en, pt) in LESSON_BLOCKS.items():
    RU_BLOCKS[lid] = ru
    EN_BLOCKS[lid] = en
    PT_BLOCKS[lid] = pt

for lid in range(2, 13):
    if lid in DEEPEN_RU:
        ad = DEEPEN_RU[lid]
        RU_BLOCKS[lid] = apply_deepen(RU_BLOCKS[lid], ad)
        RU_BLOCKS[lid] = apply_deepen(RU_BLOCKS[lid], ad[::-1])
    if lid in DEEPEN_EN:
        EN_BLOCKS[lid] = apply_deepen(EN_BLOCKS[lid], DEEPEN_EN[lid])
    if lid in DEEPEN_PT:
        PT_BLOCKS[lid] = apply_deepen(PT_BLOCKS[lid], DEEPEN_PT.get(lid, DEEPEN_PT.get(2, [])))
    m = LESSON_META[lid]
    EN_BLOCKS[lid] = EN_BLOCKS[lid] + en_extra_blocks(lid, m["sym"])
    PT_BLOCKS[lid] = PT_BLOCKS[lid] + pt_extra_blocks(lid, m["sym"])
    RU_BLOCKS[lid] = ensure_ru_words(RU_BLOCKS[lid], lid, 2100)
    EN_BLOCKS[lid] = ensure_en_words(EN_BLOCKS[lid], 900)
    PT_BLOCKS[lid] = ensure_pt_words(PT_BLOCKS[lid], 700)


def _practice_steps(sym, interval):
    return [
        f"Откройте TradingView: {sym}, таймфрейм {interval}m.",
        "Разметьте ключевые уровни или элементы урока.",
        "Опишите сценарий вход/стоп/тейк без клика на бирже.",
        "Сделайте скрин с подписью уровней.",
        "Запишите в журнал: сетап, R:R, эмоция до входа.",
        "Перечитайте план через 24 часа — нужна ли коррекция?",
    ]


def _practice_steps_en(sym, interval):
    return [
        f"Open TradingView {sym} {interval}m.",
        "Mark key levels from the lesson.",
        "Write entry/stop/target — no live click.",
        "Screenshot with labels.",
        "Journal: setup, R:R, emotion.",
        "Review plan after 24h.",
    ]


def _practice_steps_pt(sym, interval):
    return [
        f"Abra TradingView {sym} {interval}m.",
        "Marque níveis da lição.",
        "Plano entrada/stop/alvo sem clicar.",
        "Print com legendas.",
        "Diário: setup, R:R, emoção.",
        "Revise o plano em 24h.",
    ]


def build_loc(lid):
    m = LESSON_META[lid]
    loc = {}
    for lang in ("ru", "en", "pt"):
        Ld = LOCALE[lid][lang]
        blocks = {"ru": RU_BLOCKS, "en": EN_BLOCKS, "pt": PT_BLOCKS}[lang][lid]
        ps = {"ru": _practice_steps, "en": _practice_steps_en, "pt": _practice_steps_pt}[lang](m["sym"], m["interval"])
        loc[lang] = {
            "title": Ld["title"],
            "subtitle": Ld["subtitle"],
            "outcome": Ld["outcome"],
            "content": Ld["content"],
            "takeaway": Ld["takeaway"],
            "blocks": blocks,
            "market_title": {"ru": "Ваш рынок", "en": "Your market (LATAM)", "pt": "Seu mercado (Brasil)"}[lang],
            "chart_title": Ld["chart_title"],
            "chart_cap": Ld["chart_cap"],
            "tv_title": {"ru": "Разбор в TradingView", "en": "TradingView breakdown", "pt": "Setup no TradingView"}[lang],
            "tv_body": Ld["tv_body"],
            "practice_title": {"ru": "Практика", "en": "Practice", "pt": "Prática"}[lang],
            "practice_intro": {"ru": "30–40 минут. Без реальных сделок на обучении:", "en": "30–40 minutes:", "pt": "30–40 minutos:"}[lang],
            "practice_steps": ps,
            "example_title": {"ru": "Разбор сценария", "en": "Scenario", "pt": "Cenário"}[lang],
            "example": Ld["example"],
            "bullets_title": {"ru": "Запомнить", "en": "Remember", "pt": "Lembre"}[lang],
            "bullets": Ld["bullets"],
            "journal_title": {"ru": "Журнал", "en": "Journal", "pt": "Diário"}[lang],
            "journal_body": {"ru": "Запишите после практики:", "en": "Record:", "pt": "Registre:"}[lang],
            "journal_items": Ld["journal_items"],
            "tip_title": {"ru": "Совет профи", "en": "Pro tip", "pt": "Dica profissional"}[lang],
            "tip": Ld["tip"],
        }
    return loc


def main():
    parts = [HEADER, ""]
    for lid in range(2, 13):
        m = LESSON_META[lid]
        br, mx, ru, gl = m["markets"]
        markets = {"br": br, "mx": mx, "ru": ru, "global": gl}
        loc = build_loc(lid)
        parts.append(f"# ─── Lesson {lid} ───────────────────────────────────────────────────────────────")
        parts.append("")
        parts.append(f"_LESSON{lid} = L(")
        parts.append(f"    {lid}, {m['mod']}, {m['diff']!r}, {m['mins']}, {m['chart']!r}, {m['sym']!r}, {m['interval']!r},")
        mp = pprint.pformat(markets, width=100)
        parts.append("    " + mp.replace("\n", "\n    ") + ",")
        lp = pprint.pformat(loc, width=100, sort_dicts=False)
        parts.append("    " + lp.replace("\n", "\n    ") + ",")
        parts.append(")")
        parts.append("")
    parts.append("LESSONS = [")
    parts.append("    _LESSON2, _LESSON3, _LESSON4, _LESSON5, _LESSON6,")
    parts.append("    _LESSON7, _LESSON8, _LESSON9, _LESSON10, _LESSON11, _LESSON12,")
    parts.append("]")
    parts.append("")
    OUT.write_text("\n".join(parts), encoding="utf-8")
    print(f"Wrote {OUT}")
    import importlib.util
    spec = importlib.util.spec_from_file_location("p01b", OUT)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    for Ls in mod.LESSONS:
        rw = wc(Ls["loc"]["ru"]["blocks"])
        ew = wc(Ls["loc"]["en"]["blocks"])
        pw = wc(Ls["loc"]["pt"]["blocks"])
        print(f"L{Ls['id']}: RU {rw} ({len(Ls['loc']['ru']['blocks'])} blk)  EN {ew}  PT {pw}")


if __name__ == "__main__":
    main()

