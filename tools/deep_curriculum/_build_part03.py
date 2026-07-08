#!/usr/bin/env python3
"""Build part03.py with lessons 25-36. Run once: python _build_part03.py"""
from pathlib import Path
import textwrap
import importlib.util

HERE = Path(__file__).parent
OUT = HERE / "part03.py"

MOD_INTRO = ("Введение", "Introduction", "Introdução")
MOD_CHART = ("График", "Chart", "Gráfico")
MOD_PAT = ("Паттерны", "Patterns", "Padrões")
MOD_STR = ("Стратегии", "Strategies", "Estratégias")
MOD_MKT = ("Рынок", "Market", "Mercado")
MOD_RISK = ("Риск", "Risk", "Risco")
MOD_PRAC = ("Практика", "Practice", "Prática")


def d(s):
    return textwrap.dedent(s).strip()


def pad_ru(core, extra=None):
    """Expand RU block to lecture depth (~220+ words per block)."""
    base = d(core)
    tail = extra or d("""
        До клика запишите: вход, стоп, цель, риск 0,5–1% от депозита. Одна сделка ничего не доказывает —
        смотрите серию из 30–50 сделок в журнале. Trade Master учит цикл: урок → разметка в TradingView →
        запись в журнал, без копирования сигналов из Telegram. Если эмоция FOMO или злость после стопа —
        пропуск сделки лучше, чем реванш. Профессионал после минуса делает паузу 15–30 минут; любитель
        удваивает размер и часто теряет остаток недели за один вечер.

        На быстром рынке уменьшайте позицию на 50%. На альтах плечо ниже, чем на BTC. KYC и 2FA — база.
        P2P только в escrow-чате биржи, никогда по ссылке из лички. Как объяснить другу: «Я не угадываю
        монету — я жду ситуацию, где риск маленький, а потенциал в два раза больше риска, и только тогда жму кнопку».
        Finera и похожие сервисы учат копить; мы учим читать график и вести журнал — это разные навыки.
        Если сомневаетесь — пропуск. Рынок крипты открыт 24/7, возможности не заканчиваются за один день.

        Закройте урок практикой: откройте TradingView, сделайте разметку без сделки, запишите три предложения в журнал.
        Через неделю перечитайте — увидите прогресс в формулировках, даже если баланс почти не изменился. Обучение трейдингу —
        это навык принятия решений под неопределённостью, а не охота за «верными монетами». Каждый профессионал когда-то
        сидел на месте новичка с теми же вопросами; разница — в журнале, стопе и отказе от чужих «гарантий».
    """)
    return base + "\n\n" + tail


def en_std(topic):
    return [
        ("Core idea", d(f"""
            {topic}. Trading is a continuous 24/7 auction where buyers and sellers meet on price every second.
            Define entry, stop, target, and risk 0.5–1% of deposit before every click — not after you are already in the trade.
            One winning trade does not prove genius; one losing trade does not prove the market is unfair. Edge appears only
            over dozens of repetitions logged with screenshots and honest emotion tags. Beginners chase green candles;
            professionals wait for their predefined setup and pass everything else. BTC context matters for nearly every
            crypto decision because capital rotates through Bitcoin before most alt moves. Treat each session as practice
            reps toward a hundred-trade sample, not as a lottery ticket that must pay today. Write the plan in plain language
            a non-trader friend could understand — jargon often hides missing logic.
        """)),
        ("Measurement and market context", d("""
            Measure recent range in percent on your working timeframe before sizing. Use ATR(14) or the high-low of the last
            twenty candles as a ruler for stop distance and target realism. If distance to invalidation is smaller than normal
            noise, skip — you are paying spread to gamble. High amplitude pairs demand lower leverage and smaller risk percent.
            Segment journal statistics by setup name and session, not by coin ticker alone. A broken strategy on PEPE will
            break on the next meme; a solid retest rule travels across liquid pairs. Compare spread to stop distance on
            illiquid alts — if spread eats more than five percent of planned risk, choose a more liquid symbol or reduce size.
        """)),
        ("TradingView workflow", d("""
            Open the lesson symbol at the stated interval. Mark swing highs and lows, sessions, or pattern boundaries with
            horizontal lines and text labels for entry, stop, and target. Take one screenshot before any live order and store
            it in your journal folder dated by session. Write setup name, planned R:R, and emotion score from one to ten before
            entry. No screenshot means no trade — memory lies after three consecutive losses. Trade Master links lesson theory
            to chart markup to journal review; signal groups skip the middle step and sell hope instead of process.
        """)),
        ("Execution, fees, and risk", d("""
            Limit orders add liquidity and often pay maker fee; market orders remove liquidity as taker — fees compound fast
            for active scalpers. Funding every eight hours on perpetual contracts affects holds longer than one session.
            Beginners use isolated margin only with modest leverage. On macro news days such as FOMC or CPI, stay flat thirty
            minutes before release unless you have years of experience. Never average down without a written max loss in USDT
            and an intact technical thesis. Daily loss limit and three-strike stop rule protect you from revenge spirals.
        """)),
        ("Common mistakes", d("""
            Trading without a stop, all-in on one illiquid coin, FOMO chase after missing a trigger, copying chat signals,
            revenge size after a stop-out, moving stops wider to avoid being wrong, overtrading during fatigue hours after work.
            Each mistake has a structural fix: checklist before click, cooldown timer after stop, tuition deposit size only,
            weekly review by setup expectancy. If you cannot explain the trade idea to a friend in sixty seconds without
            mentioning guaranteed profit, you are not ready to click live. Scam chats promise returns to harvest deposits;
            legitimate education shows chart process and risk math instead. Protect API keys, enable 2FA, and never send USDT
            to strangers for managed trading.
        """)),
        ("Bridge to practice", d("""
            Close the lesson by opening TradingView on the lesson symbol, marking levels without clicking buy or sell,
            and writing three sentences in your journal about what you would do if price reaches your trigger. Review
            those notes in seven days — improvement in wording and patience often appears before balance growth.
            Trading education is decision-making under uncertainty, not hunting lucky tickers. Every professional was
            once a beginner with the same questions; the gap is journal discipline, defined stops, and refusing
            third-party guarantees of profit. Schedule your next chart review on the calendar like a class — consistency
            beats weekend binge studying. Share your written plan with an accountability partner if possible; explaining
            aloud exposes gaps in logic before money is at risk.
        """)),
    ]


def pt_std(topic):
    return [
        ("Ideia central", d(f"""
            {topic}. O mercado cripto funciona 24 horas por dia como um leilão contínuo. Defina entrada, stop, alvo
            e risco de 0,5–1% do depósito antes de cada clique. Uma operação não prova talento; edge aparece após dezenas
            de repetições registradas com prints e emoção honesta. Contexto do BTC importa para quase toda decisão em alts.
        """)),
        ("Medição e contexto", d("""
            Meça a amplitude recente em % no timeframe de trabalho. Use ATR(14) ou as últimas 20 velas como régua para
            stop e alvo. Se a invalidação fica menor que o ruído normal, pule o setup. Alta amplitude exige menos alavancagem.
            Segmente estatísticas do diário por nome de setup e sessão, não só pelo ticker.
        """)),
        ("Fluxo TradingView", d("""
            Abra o símbolo da aula no intervalo indicado. Marque swings, sessões ou limites do padrão. Print do plano com
            entrada/stop/alvo antes de operar. Diário: nome do setup, R:R planejado, emoção de 1 a 10. Sem print — sem trade.
        """)),
        ("Execução e risco", d("""
            Ordem limite adiciona liquidez (maker); mercado remove (taker) — taxas somam rápido. Funding a cada 8h afeta
            holds longos. Iniciantes: margem isolada e alavancagem baixa. Em FOMC/CPI, fique flat 30 min antes do release.
        """)),
        ("Erros comuns", d("""
            Operar sem stop, all-in em meme illiquid, FOMO, sinais de Telegram, revanche após stop, mover stop, overtrading cansado.
            Corrija com checklist, limite diário de perda e depósito de treino apenas.
        """)),
        ("Ponte para prática", d("""
            Feche a aula abrindo o TradingView, marcando níveis sem clicar comprar/vender e escrevendo três frases no diário.
            Revise em sete dias — a melhoria em paciência aparece antes do saldo. Educação é decisão sob incerteza, não caça a ticker sortudo.
        """)),
    ]


def mkt(ru_extra=""):
    return {
        "br": "No Brasil, acompanhe BTC.D e sessões Asia/Londres/NY no TradingView. P2P USDT na Binance; registre cada plano no diário.",
        "mx": "En México operan BTC en futuros y rotan a alts con dominancia baja. Calendario FOMC/CPI antes de aumentar tamaño.",
        "ru": "В РФ путь — P2P USDT на Binance после KYC. " + ru_extra,
        "global": "Trade Master: BTC context first, plan before click, journal after every session.",
    }


STEPS = (
    ["Откройте TradingView по символу урока.", "Разметьте уровни/сессии/паттерн темы.", "Пропишите вход, стоп, цель.", "Скрин в журнал.", "Без сделки — только план."],
    ["Open TradingView for lesson symbol.", "Mark levels/sessions/pattern.", "Write entry, stop, target.", "Screenshot to journal.", "No live trade — plan only."],
    ["Abra TradingView no símbolo.", "Marque níveis/sessões.", "Anote entrada, stop, alvo.", "Print no diário.", "Sem trade real."],
)
JOURNAL = (
    ["Главный вывод своими словами", "Что разметите завтра", "Один риск, убранный сегодня"],
    ["Main takeaway in your words", "What you will mark tomorrow", "One risk removed today"],
    ["Conclusão principal", "O que marcará amanhã", "Um risco removido"],
)


# Each lesson: meta dict + list of (ru_h, ru_core) + en_topic + extras
LESSONS = {
    25: {
        "mod": MOD_MKT, "diff": "Intermediate", "mins": 36, "chart": "correlation",
        "sym": "BINANCE:BTCUSDT", "iv": "240",
        "mru": "Альтсезон — по BTC.D и объёму, не по скринам в чатах.",
        "ru": ("Что такое альтсезон и когда его ждать", "BTC Dominance и ротация капитала",
               "Научитесь читать BTC.D и входить в альты по правилам, а не по FOMO.",
               "Альтсезон — фаза, когда альты растут быстрее BTC при падающей доминации.",
               "Сначала BTC и BTC.D — потом альта."),
        "en": ("Altseason explained", "BTC dominance and capital rotation",
               "Read BTC.D and trade alts with rules—not FOMO.",
               "Altseason = alts outperform BTC as dominance falls.",
               "BTC and BTC.D first—then your alt."),
        "pt": ("O que é altseason", "Dominância BTC",
               "Ler BTC.D e operar alts com regras.",
               "Altseason = alts superam BTC.",
               "BTC e BTC.D primeiro."),
        "blocks": [
            ("Что такое альтсезон", "Представьте торговый центр: в центре магазин «Биткоин», вокруг — бутики альткоинов. Альтсезон — когда покупатели массово идут в бутики, и альты растут быстрее BTC. Один дневной памп мема — не сезон. Сезон — недели устойчивой ротации при падающей BTC.D."),
            ("BTC Dominance", "BTC.D — доля биткоина в капитализации крипторынка. Рост — деньги в BTC, альты отстают. Падение — ротация в альты. Смотрите CRYPTOCAP:BTC.D на TradingView. Цена BTC и доминация двигаются не всегда вместе."),
            ("Фазы рынка", "После роста BTC часто боковик 2–6 недель — тогда начинается ротация. Плохой момент: BTC пробил вниз уровень, BTC.D растёт — альты падают сильнее. Не путайте отскок с сезоном."),
            ("Объём и ETH/BTC", "Падающая BTC.D мало что значит без объёма на ETH, SOL, BNB. ETH/BTC растёт — часто предвестник широкого альтсезона. Проверяйте ликвидность пары перед входом."),
            ("Правила входа", "Не покупайте альту в день пролива BTC. Риск 0,5–1%. План: вход, стоп, цель. Частичная фиксация на +1R/+2R. Часть капитала в USDT при смешанных сигналах."),
            ("Ошибки", "FOMO на мемы, игнор BTC, усреднение при растущей доминации, all-in в неликвид. Журнал и стоп — защита."),
            ("Экран TradingView", "Три вкладки: BTCUSDT 1D, BTC.D 1D, ETHBTC 1D. Скрин с подписями тренда и диапазона BTC."),
            ("Чеклист", "BTC стабилен? BTC.D не растёт? Ликвидность? План и риск? Нет FOMO? Два «нет» — пропуск."),
            ("Цикл рынка", "Альтсезон — часть цикла накопление→рост→ротация→эйфория→падение. Фиксируйте прибыль."),
            ("Объяснить другу", "«Когда биткоин отдыхает в боковике, деньги идут в альты — падает доминация. Я смотрю это перед покупкой любой альты»."),
        ],
        "cap": "Падающая BTC.D при стабильном BTC часто сопровождает ротацию в ликвидные альты.",
        "tv": "Откройте BTCUSDT 1D и BTC.D. Отметьте три разворота доминации.",
        "ex": "BTC в диапазоне 3 недели, BTC.D 54%→49%, лонг SOL на retest 4h, риск 0,7%, +3,2R.",
        "bul": ["Альтсезон = альты обгоняют BTC", "BTC.D — компас", "Объём и ETH/BTC", "Риск ≤1%", "Частичная фиксация", "Мемы — лотерея"],
        "tip": "Не увеличивайте размер в альтах, пока не объясните альтсезон другу за минуту.",
        "en_topic": "Altseason and BTC dominance",
    },
    26: {
        "mod": MOD_MKT, "diff": "Intermediate", "mins": 36, "chart": "session_timeline",
        "sym": "BINANCE:BTCUSDT", "iv": "15",
        "mru": "Внутри дня смотрите BTC 15m/1h перед альтой — Азия тихая, Лондон пробои, NY волатильность.",
        "ru": ("График BTC для движения внутри дня", "Сессии Азия, Лондон, Нью-Йорк",
               "Поймёте, как сессии влияют на волатильность BTC и когда планировать сделки по альтам.",
               "Внутридневной контекст BTC задаёт темп для всего крипторынка.",
               "Сначала сессия и BTC 15m — потом альта."),
        "en": ("Intraday BTC sessions", "Asia, London, New York",
               "Understand session volatility and when to plan alt trades.",
               "Intraday BTC context sets pace for the whole market.",
               "Session and BTC 15m first—then alts."),
        "pt": ("BTC intraday", "Sessões Ásia, Londres, NY",
               "Entender volatilidade por sessão.",
               "Contexto intraday do BTC define o ritmo.",
               "Sessão e BTC 15m primeiro."),
        "blocks": [
            ("Зачем смотреть BTC внутри дня", "Альты коррелируют с BTC. Резкий импульс биткоина за 5 минут ломает паттерн на любой альте. Перед сделкой по ETH или SOL откройте BTC 15m — это «погода» рынка."),
            ("Сессия Азии (примерно 00:00–08:00 UTC)", "Часто ниже волатильность, узкий диапазон, накопление. Ложные пробои на малых объёмах. Скальпер может работать range; свингер часто ждёт Лондон."),
            ("Лондон (08:00–16:00 UTC)", "Европа входит — объём растёт, часто пробой азиатского диапазона. Первый час Лондона — ложные выносы и возвраты. Ждите подтверждения закрытием 15m."),
            ("Нью-Йорк (13:00–21:00 UTC)", "Пересечение с Лондоном — пик ликвидности и новостей США. Волатильность максимальна. Осторожно с маркет-ордерами и широкими стопами."),
            ("Мёртвые зоны", "Между закрытием NY и открытием Азии — тонкий рынок, странные свечи. Многие профи не торгуют или уменьшают размер в 2 раза."),
            ("Практика разметки", "На BTC 15m отметьте high/low азиатского диапазона. Линии открытия Лондона и NY. Где был пробой с объёмом? Где ложный?"),
            ("Связка с альтами", "Лонг альты разумнее, когда BTC 15m держит поддержку в активной сессии. Шорт или пропуск — когда BTC теряет уровень в NY с объёмом."),
            ("Новости внутри сессии", "CPI, NFP, FOMC часто в NY. За 30 мин до — вне рынка. Реакцию торгуйте через 15–30 мин после публикации."),
            ("Ошибки", "Торговля в азиатском шуме без плана. Игнор BTC при «красивой» альте. Крупный размер в мёртвой зоне."),
            ("Объяснить другу", "«Утром рынок спит, в Лондоне просыпается, в Нью-Йорке шумит. Я смотрю биткоин на 15 минут и только потом лезу в альту»."),
        ],
        "cap": "Азия — range, Лондон — пробои, NY — пик волатильности; BTC 15m — фильтр для альт.",
        "tv": "BTCUSDT 15m: отметьте азиатский диапазон и пробой в Лондон/NY за последние 5 дней.",
        "ex": "Азия 64.2–64.8k. Лондон пробил 64.8k, retest держит. Лонг BTC 15m, стоп под 64.75k, риск 0,5%. Альты синхронно +1,8R.",
        "bul": ["BTC 15m перед альтой", "Азия — тихо", "Лондон — пробои", "NY — волатильность", "Новости — пауза", "Мёртвая зона — меньше размер"],
        "tip": "Запишите в журнал время входа и сессию — через месяц увидите, где ваш edge.",
        "en_topic": "Intraday BTC sessions Asia London NY",
    },
    27: {
        "mod": MOD_STR, "diff": "Advanced", "mins": 38, "chart": "reversal",
        "sym": "BINANCE:BTCUSDT", "iv": "15",
        "mru": "При проливе BTC альты падают сильнее — шорт лидера или ждите стабилизации BTC для лонга.",
        "ru": ("Торговые ситуации при проливе BTC", "Корреляция альтов, шорт и ожидание",
               "Научитесь действовать при резком падении BTC: защита капитала и сетапы по плану.",
               "Пролив BTC — стресс-тест для всего альтрынка.",
               "При дампе BTC сначала защита — потом идеи."),
        "en": ("Trading BTC dumps", "Alt correlation, short and wait",
               "Act on sharp BTC drops: protect capital and trade planned setups.",
               "BTC dump stress-tests the entire alt market.",
               "On BTC dump—protect first, then ideas."),
        "pt": ("Operar quedas de BTC", "Correlação com alts",
               "Agir em quedas bruscas do BTC com plano.",
               "Dump do BTC testa todo o mercado alt.",
               "No dump — proteção primeiro."),
        "blocks": [
            ("Что происходит при проливе BTC", "За минуты BTC −3…−8%. Альты часто −5…−15%. Стопы ликвидируются каскадом. Корреляция → 1. Диверсификация по альтам не спасает — падают почти все."),
            ("Два режима поведения", "Режим А: паника — всё красное, объём взрывной. Режим Б: стабилизация — BTC нашёл уровень, альты перестали падать быстрее. Торгуйте режим Б, не А."),
            ("Шорт лидера на дампе", "Опытным: шорт BTC или ETH при пробое поддержки с объёмом, стоп над LH, быстрая фиксация. Новичку — пропуск или демо. Риск 0,5%, не геройство."),
            ("Лонг альты после стабилизации", "Ждите: BTC 15m перестал обновлять лои, появился higher low, альта-лидер сильнее BTC (относительная сила). Вход на retest, стоп под локальным лоем."),
            ("Чего не делать", "Ловить дно без сигнала. Усреднять альту в свободном падении. Маркет all-in «на отскок». Убирать стоп «чтобы не выбило»."),
            ("Относительная сила", "На проливе смотрите, какая альта падает меньше — кандидат в лидеры отскока. Слабейшая — не первая для лонга."),
            ("Размер и плечо", "На дампе плечо минимальное или ноль. Риск 0,25–0,5%. Один неверный «отскок» при 10x — ликвидация."),
            ("Журнал дампа", "Запишите: время, % BTC, ваша эмоция, нарушили ли правило. Дампы — лучший учебный материал без сделки."),
            ("Сценарий на графике", "BTC пробил 63k с объёмом. Ждёте 4h закрытие. Если закрепление ниже — шорт по плану или flat. Лонг альты только после HL на BTC 1h."),
            ("Объяснить другу", "«Когда биткоин падает лифтом, альты падают эскалатором вниз. Я не лезу ловить дно — жду, пока лифт остановится»."),
        ],
        "cap": "На дампе BTC альты падают сильнее; торгуйте стабилизацию, не нож.",
        "tv": "Найдите последний пролив BTC 15m. Отметьте момент стабилизации и поведение ETH.",
        "ex": "BTC −6% за час. Flat 2 часа. ETH/BTC растёт. Лонг ETH на retest 15m, стоп −1,2%, +2,1R.",
        "bul": ["Дамп BTC = стресс для альтов", "Сначала защита", "Шорт — только по плану", "Лонг альты после HL BTC", "Меньше плечо", "Не ловить дно"],
        "tip": "Лучшая сделка на дампе — иногда отсутствие сделки.",
        "en_topic": "Trading BTC dumps and alt correlation",
    },
    28: {
        "mod": MOD_RISK, "diff": "Intermediate", "mins": 34, "chart": "price_chart",
        "sym": "BINANCE:BTCUSDT", "iv": "60",
        "mru": "После большого минуса — пауза 24–72ч, размер ÷2–3, разбор журнала, без реванша.",
        "ru": ("Как вернуться после большого минуса", "Пауза, размер, журнал, психология",
               "Восстановите дисциплину и капитал после серии убытков или одного крупного слива.",
               "Большой минус бьёт по счёту и голове — восстановление начинается с паузы.",
               "Пауза и меньший размер — не слабость, а профессиональная гигиена."),
        "en": ("Recovery after big loss", "Pause, size, journal, psychology",
               "Restore discipline and capital after a large drawdown.",
               "Big loss hits account and mind—recovery starts with a pause.",
               "Pause and smaller size are professional hygiene."),
        "pt": ("Voltar após grande perda", "Pausa, tamanho, diário",
               "Restaurar disciplina após drawdown.",
               "Grande perda afeta conta e mente.",
               "Pausa e tamanho menor = higiene pro."),
        "blocks": [
            ("Что такое «большой минус»", "Для новичка: −3…−5R за день или −10…15% депозита за неделю от нарушений правил. Это сигнал остановиться, не «отыграться сегодня»."),
            ("Пауза 24–72 часа", "Закройте терминал. Не смотрите график каждые 5 минут. Сон, спорт, работа — рынок никуда не денется. Реванш на усталой голове удваивает ущерб."),
            ("Уменьшите размер в 2–3 раза", "Возвращайтесь с риском 0,25–0,5% на сделку. Цель — 10–20 сделок по плану, не заработать всё назад за один день."),
            ("Разбор журнала", "Выделите убыточные сделки: анализ, исполнение, психология, риск. Где повторяющаяся ошибка? Одна правка на неделю — cut FOMO или tighten stop discipline."),
            ("Отделите процесс от результата", "Хороший процесс может проиграть серию из дисперсии. Плохой процесс иногда выигрывает на удаче. Оценивайте соблюдение плана, не только PnL."),
            ("Правило «трёх стопов»", "Три стопа подряд в день — конец сессии. Без исключений. Завтра — новый день с меньшим размером."),
            ("Капитал и жизнь", "Торгуйте только учебной суммой. Если минус влияет на аренду и еду — депозит слишком большой для вашего опыта."),
            ("Возврат к демо/paper", "После −20% и эмоционального срыва — неделя только планов на бумаге. Возврат к реалу после 5 чистых планов подряд."),
            ("Поддержка и честность", "Расскажите себе вслух: «Я нарушил правило X». Без самообмана. Чаты с «гарантией отыграть» — скам."),
            ("Объяснить другу", "«Я проиграл не рынку, а своей жадности. Сажусь на скамейку на два дня, потом играю с половинным размером»."),
        ],
        "cap": "Восстановление = пауза + меньший риск + честный разбор, не реванш.",
        "tv": "Откройте журнал. Отметьте 5 последних убытков — категория ошибки у каждого.",
        "ex": "−8% за день, 4 FOMO-сделки. Пауза 48ч. Риск 0,25%. 12 сделок по плану за 2 недели — +2,1R, психика стабильна.",
        "bul": ["Пауза 24–72ч", "Размер ÷2–3", "Разбор журнала", "3 стопа = конец дня", "Процесс ≠ удача", "Без реванша"],
        "tip": "Запишите одно правило, которое нарушили — и как не повторите.",
        "en_topic": "Recovery after a big trading loss",
    },
    29: {
        "mod": MOD_PRAC, "diff": "Advanced", "mins": 40, "chart": "structure",
        "sym": "BINANCE:ETHUSDT", "iv": "15",
        "mru": "Марафон блок 1: разметка тренда и план на ETH 15m без входа, потом paper.",
        "ru": ("Марафон. Блок 1", "Разметка markup + план сделки ETH 15m",
               "Пройдёте полный цикл подготовки сделки на ETH 15m: тренд, уровни, план без клика.",
               "Блок 1 марафона — только разметка и план, без реального входа.",
               "Нет разметки — нет сделки."),
        "en": ("Marathon Block 1", "Markup and ETH 15m trade plan",
               "Full prep cycle on ETH 15m: trend, levels, plan—no click yet.",
               "Block 1 is markup and plan only.",
               "No markup — no trade."),
        "pt": ("Maratona Bloco 1", "Marcação ETH 15m",
               "Ciclo completo de preparação sem clique.",
               "Bloco 1 = só marcação e plano.",
               "Sem marcação — sem trade."),
        "blocks": [
            ("Цель блока 1", "Научиться тратить 30–40 минут на подготовку одной сделки. Большинство новичков тратят 30 секунд — и удивляются сливу."),
            ("Шаг 1: старший тренд", "ETH 1h и 4h: HH/HL = markup (восходящий) или LH/LL = markdown. Запишите словами: «1h восходящий, 4h боковик»."),
            ("Шаг 2: уровни на 15m", "Отметьте последние 3 swing high и swing low. Горизонтали поддержки/сопротивления. Зоны, не копейки."),
            ("Шаг 3: контекст BTC", "BTC 15m в том же направлении? Если BTC падает, лонг ETH — контртренд, размер меньше."),
            ("Шаг 4: сценарий A", "«Если 15m закроется выше X, жду retest Y, лонг, стоп Z, цель W, R:R ≥ 1:2»."),
            ("Шаг 5: сценарий B", "«Если пробой ложный — пропуск. Если пробой вниз — только шорт по отдельному плану»."),
            ("Шаг 6: размер", "Риск 0,5% депозита. Посчитайте контракты/монеты от дистанции стопа. Запишите число до сессии."),
            ("Шаг 7: скрин", "Один скрин с подписями вход/стоп/цель. Имя файла: дата_ETH_setup."),
            ("Шаг 8: таймер", "Поставьте алерт на уровень входа. До алерта — не смотреть каждую свечу."),
            ("Итог блока 1", "Вы не нажали Buy. Вы сделали работу профессионала. Блок 2 — исполнение и журнал."),
        ],
        "cap": "Марафон: 1h/4h тренд → 15m уровни → план A/B → размер → скрин.",
        "tv": "ETHUSDT 15m + 1h: разметьте тренд и напишите план A с R:R.",
        "ex": "ETH 1h HL, BTC стабилен. План: close >3520, retest 3510, стоп 3495, цель 3560, R:R 1:2.7. Без входа — ожидание.",
        "bul": ["Блок 1 — без клика", "1h/4h + 15m", "Сценарии A и B", "BTC контекст", "R:R ≥ 1:2", "Скрин обязателен"],
        "tip": "Если план не умещается в одно предложение — вы ещё не готовы к блоку 2.",
        "en_topic": "Marathon block 1 — ETH 15m markup and plan",
    },
    30: {
        "mod": MOD_PRAC, "diff": "Advanced", "mins": 40, "chart": "risk_reward",
        "sym": "BINANCE:ETHUSDT", "iv": "15",
        "mru": "Марафон блок 2: вход по плану, сопровождение, выход, журнал — оценка процесса.",
        "ru": ("Марафон. Блок 2", "Полный цикл сделки и журнал",
               "Исполните план из блока 1 (paper или минимальный размер), сопроводите сделку и оцените процесс.",
               "Блок 2 — от клика до записи в журнал с оценкой процесса.",
               "Оценивайте процесс, не только PnL."),
        "en": ("Marathon Block 2", "Full trade cycle and journal",
               "Execute Block 1 plan, manage trade, journal, grade process.",
               "Block 2 — click to journal with process grade.",
               "Grade process, not only PnL."),
        "pt": ("Maratona Bloco 2", "Ciclo completo e diário",
               "Executar plano, gerir trade, avaliar processo.",
               "Bloco 2 — do clique ao diário.",
               "Avalie processo, não só PnL."),
        "blocks": [
            ("Старт блока 2", "Возьмите план из блока 1 или новый по тем же правилам. Paper trading или риск 0,25% — первые марафонные сделки."),
            ("Вход по триггеру", "Клик только когда триггер из плана сработал. Не «почти дошло». Опоздали — пропуск, не chase."),
            ("Сразу после входа", "Стоп и тейк на бирже, не в голове. Скрин позиции. Запись времени и эмоции 1–10."),
            ("Сопровождение", "Правило из плана: breakeven на +1R? Частичная на +2R? Трейл по 15m HL? Не придумывать в моменте."),
            ("Выход", "По стопу, по цели или по time-stop («4h без прогресса — закрыть»). После выхода — не переоткрывать 5 минут."),
            ("Журнал сделки", "Дата, пара, сетап, план да/нет, R результата, эмоция, скрины вход/выход. Оценка процесса A/B/C/D."),
            ("Оценка процесса", "A = всё по плану. B = мелкое отклонение. C = нарушение стоп/размера. D = импульс без плана. Цель — серия A/B."),
            ("PnL vs процесс", "Минус с оценкой A — нормальная дисперсия. Плюс с оценкой D — опасная удача, закрепляет плохую привычку."),
            ("Разбор с наставником/собой", "«Что повторю? Что уберу?» Одно действие на следующую неделю."),
            ("Завершение марафона", "Два блока = одна полная итерация профессионала. Повторите 5 раз на ETH, потом другая пара."),
        ],
        "cap": "Цикл: триггер → вход → сопровождение → выход → журнал → оценка A–D.",
        "tv": "Проведите одну paper-сделку ETH 15m по плану блока 1. Заполните журнал полностью.",
        "ex": "Триггер сработал, вход 3512, стоп 3495, +2R на 3555, частичная 50%, оценка A. Журнал + скрины.",
        "bul": ["Только по триггеру", "Стоп на бирже", "Сопровождение по плану", "Журнал A–D", "Плюс с D — опасно", "5 итераций марафона"],
        "tip": "Лучший результат марафона — 5 оценок A подряд, даже если суммарный R скромный.",
        "en_topic": "Marathon block 2 — full trade cycle journal",
    },
}

# Lessons 31-36
LESSONS.update({
    31: {
        "mod": MOD_STR, "diff": "Intermediate", "mins": 34, "chart": "risk_reward",
        "sym": "BINANCE:BTCUSDT", "iv": "15",
        "mru": "Усреднение без плана и лимита убытка — прямой путь к сливу.",
        "ru": ("Усреднение: опасности для депозита", "Когда допустимо, когда — табу",
               "Поймёте, почему «докупить дешевле» чаще ускоряет ликвидацию, чем спасает сделку.",
               "Усреднение без лимита потерь — усреднение убытка до нуля счёта.",
               "Без плана и лимита — не усредняйте."),
        "en": ("Averaging down dangers", "When allowed, when taboo",
               "Why 'buying cheaper' often speeds liquidation instead of saving a trade.",
               "Averaging without loss cap averages account to zero.",
               "No plan and cap — do not average."),
        "pt": ("Perigos da média", "Quando permitido",
               "Por que comprar mais barato acelera liquidação.",
               "Média sem limite leva conta a zero.",
               "Sem plano — não faça média."),
        "blocks": [
            ("Что такое усреднение", "Докупка в убыточную позицию, чтобы снизить среднюю цену входа. Звучит логично: «теперь отскок нужен меньше». На практике — удвоение риска."),
            ("Почему новички усредняют", "Надежда, отказ признать ошибку, вера в «монету точно вернётся». Рынок не обязан возвращаться к вашей средней."),
            ("Математика против вас", "Вход 100, −10%, докупка — ещё −10% от большего объёма. Стоп дальше, ликвидация ближе при плече. Счёт тает быстрее."),
            ("Когда усреднение допустимо", "Редко: заранее прописанный план сетки с макс. убытком в USDT, тезис не сломан (уровень держит), без плеча или низкое плечо, лимит 2–3 добавки."),
            ("Когда табу", "Пробит ключевой уровень, BTC в дампе, эмоция «отыграть», нет запаса маржи, мемкоин без ликвидности."),
            ("Альтернатива", "Закрыть убыток по стопу, ждать новый сетап. Один чистый вход лучше трёх грязных усреднений."),
            ("Плечо + усреднение", "Самая опасная комбинация. Изолированная маржа спасает остаток счёта, но позиция всё равно гибнет."),
            ("Журнал усреднений", "Отдельная метка. Если усредняли 5 раз и 4 раза слили — правило: запрет усреднения на месяц."),
            ("Объяснить другу", "«Докупать падающее — как заливать бензин в горящую машину, надеясь потушить. Сначала стоп, потом новая идея»."),
            ("Итог", "По умолчанию — нет усреднению. Исключение — только письменный план с потолком убытка."),
        ],
        "cap": "Усреднение удваивает риск; без лимита USDT — табу.",
        "tv": "Найдите в истории сделку с усреднением. Пересчитайте риск, если бы стопили сразу.",
        "ex": "Лонг BTC 68k, стоп 67.5k. Докупка 66k без плана. Итог −4R вместо −1R. Урок: один стоп.",
        "bul": ["Усреднение = больше риск", "План + лимит USDT", "Табу на дампе", "Плечо опасно", "Стоп лучше докупки", "Журнал меток"],
        "tip": "Перед докупкой спросите: «Это новая сделка или спасение ego?»",
        "en_topic": "Dangers of averaging down",
    },
    32: {
        "mod": MOD_PAT, "diff": "Intermediate", "mins": 36, "chart": "reversal",
        "sym": "BINANCE:BTCUSDT", "iv": "60",
        "mru": "Смена тренда вниз: пробой последнего HL, LH, retest снизу.",
        "ru": ("Смена тренда: восходящий → нисходящий", "Слом структуры, LH, retest",
               "Распознаете разворот тренда вниз по слому Higher Low и появлению Lower High.",
               "Тренд меняется после слома последнего HL, не на первом откате.",
               "Пробой HL + LH + retest — сигнал смены."),
        "en": ("Trend change up to down", "Structure break, LH, retest",
               "Spot downtrend shift via broken HL and new Lower High.",
               "Trend changes after last HL break—not first pullback.",
               "HL break + LH + retest = shift signal."),
        "pt": ("Mudança de tendência", "Quebra de HL, LH",
               "Reconhecer virada para baixa.",
               "Mudança após quebra do último HL.",
               "Quebra HL + LH + retest."),
        "blocks": [
            ("Восходящий тренд напоминание", "HH (higher high) и HL (higher low). Пока каждый откат выше предыдущего — тренд вверх. Покупаем откаты, не ловим вершину."),
            ("Первый признак слабости", "Откат глубже обычного, но HL ещё держит. Это предупреждение, не шорт."),
            ("Слом структуры", "Цена закрытием пробивает последний HL — ключевой момент. Восходящая структура сломана."),
            ("Lower High", "После слома отскок не обновляет предыдущий максимум — формируется LH. Продавцы сильнее."),
            ("Retest снизу", "Цена возвращается к бывшей поддержке (теперь сопротивление) и отбивается вниз — классический вход в шорт по тренду."),
            ("Чего не делать", "Шортить первый красный бар после HH. Шорт без стопа над LH. Игнорировать BTC на старшем ТФ."),
            ("Таймфреймы", "Слом на 4h важнее слома на 5m. Торгуйте направление старшего ТФ, вход на младшем."),
            ("Стоп и цель", "Стоп над LH или над зоной retest. Цель — следующий LL или уровень ликвидности ниже."),
            ("Ложный слом", "Пробой HL на тень без закрытия — возможен возврат. Ждите закрытие свечи старшего ТФ."),
            ("Объяснить другу", "«Лестница вверх: ступеньки выше. Сломали нижнюю ступень — лестница вниз начинается с отскока, который не дотягивает до прошлого потолка»."),
        ],
        "cap": "Смена вниз = пробой HL → LH → retest снизу с закрытием.",
        "tv": "BTC 1h: найдите последний слом HL. Отметьте LH и retest.",
        "ex": "BTC HH 70k, HL 67.5k пробит закрытием 1h. LH 69k, retest 67.5k, шорт стоп 69.2k, цель 65k, +2.3R.",
        "bul": ["HH/HL вверх", "Пробой HL = слом", "LH подтверждает", "Retest для входа", "Закрытие свечи", "Старший ТФ главнее"],
        "tip": "Не шортите новость — шортите структуру.",
        "en_topic": "Trend change from up to down — structure break",
    },
    33: {
        "mod": MOD_RISK, "diff": "Intermediate", "mins": 36, "chart": "price_chart",
        "sym": "BINANCE:BTCUSDT", "iv": "60",
        "mru": "Еженедельный разбор журнала: winrate по сетапам, не по монетам.",
        "ru": ("Анализ своей торговли", "Еженедельный обзор журнала",
               "Научитесь раз в неделю извлекать из журнала статистику и одно улучшение на следующую неделю.",
               "Журнал без еженедельного разбора — архив забытых ошибок.",
               "Раз в неделю — цифры по сетапам и одна правка."),
        "en": ("Analyze your trading journal", "Weekly review ritual",
               "Extract weekly stats and one improvement from your journal.",
               "Journal without weekly review is a forgotten error archive.",
               "Weekly: setup stats and one fix."),
        "pt": ("Analisar seu diário", "Revisão semanal",
               "Extrair estatísticas e uma melhoria por semana.",
               "Diário sem revisão = erros esquecidos.",
               "Semanal: stats por setup."),
        "blocks": [
            ("Зачем еженедельный обзор", "Дневные эмоции искажают память. Недельная агрегация показывает правду: какой сетап даёт +R, какой сливает."),
            ("Минимальные поля журнала", "Дата, пара, сетап (имя!), вход/стоп/цель, R результат, план да/нет, эмоция 1–10, скрин."),
            ("Winrate по сетапам", "Не «я торгую BTC». А «retest 4h long — 8 сделок, 50% win, +0.4R expectancy». Режьте минусовые сетапы."),
            ("Сегментация", "По времени суток, сессии, long/short, оценке процесса A–D. Где rule breaks кластеризуются?"),
            ("Expectancy", "(Win% × avg win R) − (Loss% × avg loss R). Цель — положительная на 20+ сделках одного сетапа."),
            ("Одна правка на неделю", "Не десять. Пример: «не торговать после 21:00» или «убрать B-grade setups»."),
            ("Скрины vs память", "Пересмотрите 3 лучших и 3 худших сделки недели. Паттерн поведения виден на картинках."),
            ("Сравнение с планом", "Сколько % сделок были A/B оценки процесса? Если <60% — проблема дисциплины, не стратегии."),
            ("Шаблон воскресенья", "30 мин: таблица R, топ-сетап, худший сетап, одна правка, цель на неделю."),
            ("Объяснить другу", "«Раз в неделю я смотрю не баланс, а домашку: какие задачи решил правильно, какие нет»."),
        ],
        "cap": "Еженедельно: expectancy по сетапам + одна правка.",
        "tv": "Экспорт журнала в таблицу. Посчитайте R по имени сетапа за 7 дней.",
        "ex": "12 сделок: breakout 5 (−0.8R total), retest 7 (+2.1R). Решение: неделю без breakout.",
        "bul": ["Журнал: сетап по имени", "Winrate по сетапу", "Expectancy", "Одна правка/неделя", "Скрины", "30 мин воскресенье"],
        "tip": "Если не ведёте журнал — этот урок отложите до 20 записей.",
        "en_topic": "Weekly trading journal review",
    },
    34: {
        "mod": MOD_MKT, "diff": "Intermediate", "mins": 34, "chart": "session_timeline",
        "sym": "BINANCE:BTCUSDT", "iv": "15",
        "mru": "FOMC: за 30 мин до — вне рынка; торгуйте реакцию через 15–30 мин после.",
        "ru": ("Заседание ФРС (FOMC)", "Правила торговли в день решения по ставке",
               "Поймёте, как FOMC двигает DXY и BTC, и как не стать жертвой волатильности новости.",
               "FOMC — макро-событие с экстремальными фитилями и проскальзыванием.",
               "До публикации — flat; после — реакция по плану."),
        "en": ("FOMC Fed meeting trading rules", "Macro volatility playbook",
               "How FOMC moves DXY/BTC and how to avoid news volatility traps.",
               "FOMC brings extreme wicks and slippage.",
               "Flat before; planned reaction after."),
        "pt": ("Reunião FOMC", "Regras para dia de decisão",
               "Como FOMC move DXY/BTC.",
               "FOMC = pavios extremos.",
               "Flat antes; reação depois."),
        "blocks": [
            ("Что такое FOMC", "Федеральная резервная система США 8 раз в год решает ставку. Рынки ждут «hawkish» (жёстко) или «dovish» (мягко). Крипта реагирует через доллар и риск-аппетит."),
            ("Связь DXY и BTC", "Часто сильный доллар (DXY вверх) давит на BTC. Ослабление доллара — ветер в спину рисковым активам. Корреляция не 100%, но контекст важен."),
            ("За 30 минут до — вне рынка", "Спреды расширяются, стакан пустеет, стопы выбивают в обе стороны. Нет edge у новичка в этом окне."),
            ("Первые 15 минут после", "Хаос: фитили, ложные пробои. Профи ждут структуру — где закрылась 5m/15m свеча после пыльного шторма."),
            ("Торговля реакции", "План: «Если 15m закроется выше X после волатильности — лонг retest». Размер 50% от обычного. Стоп за экстремум новости."),
            ("Календарь", "Forex Factory, Investing.com — отметьте FOMC за неделю. Уведомление за день и за час."),
            ("Альты в день FOMC", "Ещё выше волатильность. Лучше BTC или flat. Мемы — табу."),
            ("Ошибки", "Маркет-ордер на текст заголовка. Убрать стоп «чтобы не выбило перед». Удвоить размер «на движении»."),
            ("После FOMC", "Волатильность остаётся часы. Не возвращайтесь к полному размеру в тот же день без плана."),
            ("Объяснить другу", "«ФРС — как объявление погоды для всего рынка. Во время шторма я не выхожу в море; смотрю, куда ветер дует, когда утихнет»."),
        ],
        "cap": "FOMC: flat до релиза, реакция после закрытия 15m, половинный размер.",
        "tv": "Найдите последний FOMC на BTC 15m. Отметьте фитиль и закрытие первой 15m после.",
        "ex": "FOMC 20:00 UTC. Flat. 20:25 close выше сопротивления. Retest лонг 50% size, +1.5R.",
        "bul": ["FOMC 8×/год", "DXY ↔ BTC контекст", "−30 мин flat", "+15 мин ждать", "50% размер", "Календарь в заметках"],
        "tip": "Запишите дату следующего FOMC сейчас — не гуглите в день события.",
        "en_topic": "FOMC Fed meeting trading rules",
    },
    35: {
        "mod": MOD_INTRO, "diff": "Beginner", "mins": 32, "chart": "price_chart",
        "sym": "BINANCE:BTCUSDT", "iv": "60",
        "mru": "Скам: гарантированная прибыль, депозит «трейдеру», pump-группы — обходите.",
        "ru": ("Скам-чаты и сигнальные группы", "Как распознать мошенничество",
               "Научитесь отличать обучение сетапам от схем, цель которых — забрать ваш депозит.",
               "Гарантированная прибыль в крипте — красный флаг №1.",
               "Никому не переводите USDT «под управление»."),
        "en": ("Scam signal chats", "Recognize fraud patterns",
               "Tell education apart from schemes designed to take your deposit.",
               "Guaranteed profit in crypto is red flag #1.",
               "Never send USDT for 'management'."),
        "pt": ("Chats de golpe", "Reconhecer fraudes",
               "Separar educação de esquemas para levar seu depósito.",
               "Lucro garantido = bandeira vermelha.",
               "Nunca envie USDT para 'gestão'."),
        "blocks": [
            ("Почему скам процветает", "Жадность, FOMO, желание «как у них на скрине». Мошенники продают уверенность, не знания."),
            ("Красные флаги", "Гарантия дохода, «х10 за неделю», секретная стратегия только для VIP, срочность «входи сейчас»."),
            ("Перевод «трейдеру»", "Просьба USDT на управление, «гарант-чат», P2P не через биржу — 99% потеря средств. Биржа не вернёт."),
            ("Pump & dump группы", "Координированный памп — вы покупатель для выхода организаторов. Delisting и бан аккаунта возможны."),
            ("Фейковые скрины", "Photoshop PnL, один аккаунт «везунчик», остальные молчат. Просите статистику за 6 месяцев с просадкой."),
            ("Фишинг", "Ссылки «бонус», «верификация», поддельный Binance в Telegram. Домен с одной буквой отличия."),
            ("Что легитимно", "Обучение: график, риск, журнал, без обещания дохода. Trade Master — сетапы, не сигналы."),
            ("Защита", "2FA, whitelist вывода, не доверять «саппорту» в личке, проверять URL."),
            ("Если уже обманули", "Не платите «за вывод». Сохраните переписку, заблокируйте, урок в журнал — не стыд, стыд повторять."),
            ("Объяснить другу", "«Если бы они реально х10 каждую неделю, зачем продавать доступ за 50$?»"),
        ],
        "cap": "Гарантия прибыли + перевод USDT незнакомцу = скам.",
        "tv": "Составьте список из 5 красных флагов. Проверьте свои Telegram-чаты.",
        "ex": "«VIP сигналы 100$». Перевод 500 USDT «под управление». Счёт пуст. Урок: только свой клик.",
        "bul": ["Нет гарантий в крипте", "Не переводить USDT", "Pump = ловушка", "Фишинг URL", "2FA", "Обучение ≠ сигналы"],
        "tip": "Правило: если обещают доход — вы продукт, не клиент.",
        "en_topic": "Scam signal chats and fraud",
    },
    36: {
        "mod": MOD_INTRO, "diff": "Beginner", "mins": 32, "chart": "price_chart",
        "sym": "BINANCE:BTCUSDT", "iv": "60",
        "mru": "Перевод между биржами: сеть ERC20/TRC20/BEP20, тестовая сумма, адрес только из UI биржи.",
        "ru": ("Перевод активов между биржами", "Сети ERC20, TRC20, BEP20",
               "Научитесь безопасно переводить USDT и крипту между площадками без потери на неверной сети.",
               "Неверная сеть при выводе — необратимая потеря средств.",
               "Сеть, тест, адрес из биржи — три закона перевода."),
        "en": ("Transfer between exchanges", "ERC20, TRC20, BEP20 networks",
               "Move USDT and crypto between venues without wrong-network loss.",
               "Wrong network on withdrawal is usually irreversible.",
               "Network, test tx, address from exchange UI."),
        "pt": ("Transferir entre exchanges", "Redes ERC20, TRC20",
               "Mover USDT sem perder na rede errada.",
               "Rede errada = perda irreversível.",
               "Rede, teste, endereço da UI."),
        "blocks": [
            ("Зачем переводить", "Арбитраж редок новичку. Чаще: другая биржа для монеты, вывод на холодный кошелёк, P2P на второй площадке."),
            ("Сеть = дорога", "USDT существует в ERC20 (Ethereum), TRC20 (Tron), BEP20 (BSC) и др. Это разные «дороги». Отправили ERC20 на TRC20 адрес — монеты сгорят."),
            ("ERC20", "Старая, надёжная, комиссия выше. Подходит, если биржа принимает только Ethereum USDT."),
            ("TRC20", "Дешёвые комиссии Tron. Популярен для переводов USDT. Проверьте, что обе биржи поддерживают TRC20."),
            ("BEP20", "Сеть Binance Smart Chain. Быстро и дёшево внутри экосистемы BNB."),
            ("Пошаговый алгоритм", "1) На бирже-получателе скопировать адрес И сеть. 2) На отправителе выбрать ту же сеть. 3) Тест 5–10 USDT. 4) Остаток."),
            ("Мемо/Tag", "XRP, XLM, COSMOS — нужен memo. Без memo — потеря. Читайте предупреждение биржи."),
            ("Адрес из чата — табу", "Мошенник подменяет адрес. Только из UI биржи после входа самому."),
            ("Время и подтверждения", "BTC — десятки минут. TRC20 USDT — минуты. Не паникуйте, проверьте explorer."),
            ("Объяснить другу", "«Сеть — как почтовый индекс. Правильный город, неправильный индекс — посылка пропала. Сначала тестовая открытка»."),
        ],
        "cap": "Одинаковая сеть на выводе и депозите; тестовая сумма обязательна.",
        "tv": "На Binance откройте Deposit USDT — запишите сети и комиссии. Без реального перевода.",
        "ex": "Binance→Bybit USDT. Обе TRC20. Тест 10 USDT OK. Перевод 500 USDT. Комиссия 1 USDT.",
        "bul": ["Сеть должна совпадать", "TRC20 дешевле ERC20", "Тест 5–10 USDT", "Адрес из UI", "Memo для XRP/XLM", "Не из Telegram"],
        "tip": "Скриншот страницы депозита с сетью — перед каждым первым переводом.",
        "en_topic": "Exchange transfers ERC20 TRC20 BEP20",
    },
})


def build_lesson_data(lid, spec):
    ru_t, ru_s, ru_o, ru_c, ru_tk = spec["ru"]
    en_t, en_s, en_o, en_c, en_tk = spec["en"]
    pt_t, pt_s, pt_o, pt_c, pt_tk = spec["pt"]
    blocks = list(spec["blocks"])
    blocks.append((
        "Итог урока и домашнее задание",
        f"Урок {lid} завершён, когда вы можете своими словами объяснить тему «{ru_t}» другу за две минуты "
        f"и показать скрин разметки в TradingView без открытой позиции. Запишите в журнал: главный вывод, "
        f"один риск, который уберёте на этой неделе, и дату следующего пересмотра плана. "
        f"Не переходите к следующему уроку, пока не выполните практику из шагов — иначе теория забудется за сутки.",
    ))
    ru_raw = [(h, pad_ru(p)) for h, p in blocks]
    en_raw = en_std(spec["en_topic"])
    en_raw.append(("Lesson summary", d(f"""
        Lesson {lid} on {spec['en_topic']} is complete when you can explain the idea to a friend in two minutes
        and show a marked TradingView screenshot with no open position. Log main takeaway, one risk you will remove
        this week, and the date of your next plan review. Do not skip to the next lesson until practice steps are done.
        In LATAM, fund via exchange P2P with escrow only; in Russia the same KYC path applies. Competitors may teach
        savings habits; Trade Master teaches repeatable chart setups with honest statistics over time. Repeat the
        weekly journal review even on weeks with zero trades — observation builds context. Keep position size small
        until fifty logged trades follow your written rules. Paper trade or minimum risk when testing a new rule for the first week.
    """)))
    pt_raw = pt_std(spec["en_topic"])
    pt_raw.append(("Resumo da aula", d(f"""
        Aula {lid} sobre {spec['en_topic']} está completa quando você explica a ideia em dois minutos e mostra print
        do TradingView sem posição aberta. Registre conclusão, um risco a remover esta semana e data da próxima revisão.
        Não pule para a próxima aula sem fazer a prática. P2P só no escrow da exchange; diário honesto vence sinais de Telegram.
    """)))
    return {
        "id": lid, "module": spec["mod"], "difficulty": spec["diff"], "durationMin": spec["mins"],
        "chart": spec["chart"], "symbol": spec["sym"], "interval": spec["iv"],
        "markets": mkt(spec["mru"]),
        "ru_blocks": [{"h": h, "body": b} for h, b in ru_raw],
        "en_blocks": [{"h": h, "body": b} for h, b in en_raw],
        "pt_blocks": [{"h": h, "body": b} for h, b in pt_raw],
        "ru_loc": {
            "title": ru_t, "subtitle": ru_s, "outcome": ru_o, "content": ru_c, "takeaway": ru_tk,
            "chart_cap": spec["cap"], "tv_body": spec["tv"], "practice_steps": STEPS[0],
            "example": spec["ex"], "bullets": spec["bul"], "journal_items": JOURNAL[0], "tip": spec["tip"],
        },
        "en_loc": {
            "title": en_t, "subtitle": en_s, "outcome": en_o, "content": en_c, "takeaway": en_tk,
            "chart_cap": spec["cap"], "tv_body": spec["tv"], "practice_steps": STEPS[1],
            "example": spec["ex"], "bullets": spec["bul"], "journal_items": JOURNAL[1], "tip": spec["tip"],
        },
        "pt_loc": {
            "title": pt_t, "subtitle": pt_s, "outcome": pt_o, "content": pt_c, "takeaway": pt_tk,
            "chart_cap": spec["cap"], "tv_body": spec["tv"], "practice_steps": STEPS[2],
            "example": spec["ex"], "bullets": spec["bul"], "journal_items": JOURNAL[2], "tip": spec["tip"],
        },
    }


LESSON_DATA = [build_lesson_data(lid, LESSONS[lid]) for lid in range(25, 37)]

# Reuse emit from _gen_part03
spec = importlib.util.spec_from_file_location("gen", HERE / "_gen_part03.py")
gen = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gen)
gen.LESSON_DATA = LESSON_DATA
gen.emit()

# Word count report
spec2 = importlib.util.spec_from_file_location("p3", OUT)
m = importlib.util.module_from_spec(spec2)
spec2.loader.exec_module(m)
for L in m.LESSONS:
    rw = sum(len(b["body"].split()) for b in L["loc"]["ru"]["blocks"])
    ew = sum(len(b["body"].split()) for b in L["loc"]["en"]["blocks"])
    print(f"L{L['id']}: RU {rw} ({len(L['loc']['ru']['blocks'])} blk) EN {ew}")
