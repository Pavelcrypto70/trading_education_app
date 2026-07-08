# Lessons 5-12 block data — imported by _build_part01b.py
import textwrap


def blk(h, body):
    return {"h": h, "body": textwrap.dedent(body).strip()}

_L5_RU = [
    blk("Стакан как живой базар", """
        Стакан (order book) — список лимитных заявок: слева bid (покупатели), справа ask (продавцы). Цена идёт туда, где встречаются
        маркет-ордера с лимитками. На BINANCE:BTCUSDT 5m откройте стакан рядом с графиком. Аналогия: базар — продавцы кричат цену,
        покупатели торгуются; сделка — когда рукопожатие. График показывает итог; стакан — кто стоит в очереди прямо сейчас.
        Новичок смотрит только свечи и удивляется «откуда разворот» — часто от крупной стены bid или снятия стены ask.
    """),
    blk("Bid, ask и спред", """
        Лучший bid — высшая цена покупки. Лучший ask — низшая цена продажи. Спред = ask − bid. На BTC в ликвидные часы спред копейки;
        на тонком альте — проценты, и маркет-вход дорог. Запишите спред в USDT и в % перед скальпом. Если спред съедает треть планируемого
        тейка — сетап мёртв. Скальпер зарабатывает движение больше спреда плюс двух комиссий. Измеряйте каждую сессию.
    """),
    blk("Стены в стакане — плотности", """
        Стена — крупный объём на одном уровне bid или ask. Может держать цену (реальные покупатели) или исчезнуть при подходе (спуфинг).
        Не торгуйте «от стены» без подтверждения лентой: цена может пробить, если стену снимут. На BTC стены 50–200 BTC заметны;
        на ETH — пропорционально. Скрин стакена с подписью «стена bid 67200» в журнал — привычка перед скальпом.
    """),
    blk("Спуфинг — фейковые стены", """
        Спуфинг: крупную лимитку ставят, рынок реагирует, лимитку снимают до исполнения. Запрещено на традиционных рынках, на крипте
        встречается. Признаки: стена появляется вдруг, далеко от цены, исчезает при подходе; нет сделок в ленте на этом уровне.
        Правило новичка: не входить только из-за стены — ждать реакцию цены и объём в ленте. Стена + пробой + ретест — сильнее стены одной.
    """),
    blk("Лента сделок (tape)", """
        Лента — поток исполненных сделок: зелёные покупки по ask, красные продажи по bid. Агрессивные покупки под уровнем — бычий знак;
        серия красных без отскока — давление. На 5m BTC лента мелькает быстро — смотрите кластеры за 10–30 секунд у уровня.
        Tiger/Vataga показывают ленту крупнее веб-интерфейса. Без ленты стакан — статичная картинка; с лентой — кино.
    """),
    blk("Стакан плюс график — связка", """
        Уровень на TradingView 15m + стакан на 5m у того же уровня. План: «если у 67200 держится bid и лента зелёная — лонг со стопом ниже».
        Противоречие: на графике поддержка, в стакане ask давит — осторожность. Trade Master учит обе картины; чаты дают только «вход сейчас».
    """),
    blk("Как объяснить другу про стакан", """
        «График — это уже случившиеся сделки. Стакан — кто стоит в очереди купить и продать. Спред — разница между лучшей покупкой и продажей.
        Большая стена — как очередь из десяти человек; может быть настоящей, а может разойтись, когда подойдёшь.»
    """),
    blk("Скальпинг и стакан — когда переходить", """
        Скальп без чтения стакана — лотерея на комиссиях. Первый месяц — 15m без стакана; после этого урока — наблюдение 5m BTC 20 минут
        в день без сделок. Потом микро-размер одной сделки с полным журналом. Риск 0.5%, не 2%.
    """),
    blk("Ошибки со стаканом", """
        Вход на фейковую стену. Игнор спреда. Маркет в тонком стакане. Торговля стакана на монете с низкой ликвидностью. Журнал без скрина стакена.
    """),
    blk("Итог урока 5", """
        Стакан — второй глаз к графику. Bid/ask, спред, стены, спуфинг, лента. Следующий урок — быстрый и медленный рынок: когда стакан «ломается».
        Практика: BINANCE:BTCUSDT 5m, запишите спред, найдите одну стену, понаблюдайте 15 минут — без клика.
    """),
]

_L5_EN = [
    blk("Order book basics", """
        The book lists bids (buy limits) and asks (sell limits). Price moves where market orders meet resting liquidity. On BINANCE:BTCUSDT 5m
        open depth beside the chart. Charts show outcomes; the book shows who waits in line. Best bid and ask define spread — measure in USDT
        and % before scalping. If spread eats a third of your target, skip. Walls are large resting size — may hold or vanish (spoofing).
    """),
    blk("Tape, spoofing, and practice", """
        Tape shows executed trades: aggressive buys at ask vs sells at bid. Do not trade walls alone — confirm with tape and price reaction.
        Spoofing: huge limit appears and disappears before fill. Link 15m chart levels with 5m book at the same price. Beginners observe
        twenty minutes daily without clicking before micro-size scalps at 0.5% risk. Next lesson: fast vs slow market conditions.
    """),
    blk("Summary", """
        Journal spread, wall behavior, and screenshots. Tiger/Vataga help tape readability. Full loop: lesson → TradingView → book observation → journal.
    """),
]

_L5_PT = [
    blk("Book de ofertas", """
        Book lista bids e asks. Spread = ask − bid. Meça antes de scalpar. Paredes grandes podem ser spoofing — confirme na fita de trades.
    """),
    blk("Fita e prática", """
        Fita mostra trades executados. Não opere só por parede. BTCUSDT 5m: observe 15 min sem clicar. Risco 0,5%.
    """),
    blk("Resumo", """
        Próxima lição: mercado rápido vs lento. Print do book no diário.
    """),
]

# Compact generator for lessons 6-12 using same quality pattern
def _lesson_blocks_ru(topic, sections):
    return [blk(h, body) for h, body in sections]

_L6_RU = _lesson_blocks_ru(6, [
    ("Быстрый рынок — что меняется", "Быстрый рынок: широкие свечи, спред расширяется, стакан «дрожит», лента не успевает читаться. Новости, листинг, ликвидации каскадом. Правило: размер −50%, стоп шире в % но риск USDT тот же, меньше сделок. На BINANCE:BTCUSDT после CPI свечи 15m в 3× обычного ATR — это быстрый режим, не ваш обычный 0.3% тейк. Ждите 15–30 минут после волатильности, пока ATR не сожмётся."),
    ("Медленный рынок — range и скука", "Медленный рынок: узкий range, тонкий стакан, мало объёма — азиатская сессия, воскресенье. Ложные пробои чаще; тейки скромные. Ошибка — overtrading от скуки. Лучше пропуск, чем десять сделок в узком флэте с комиссиями. Измерьте range 20 свечей — если меньше вашего стопа, не торгуйте пробой."),
    ("Спред в быстром рынке", "При резком движении маркет-ордер проскальзывает на несколько уровней. Лимит может не исполниться — цена уехала. Скальпер переходит на меньший размер или паузу. Запишите в журнал «быстрый/медленный» — статистика по режимам важнее по монетам."),
    ("Ложные импульсы на быстром рынке", "Длинная свеча без продолжения — охота на FOMO. Не гонитесь за маркетом в хвост свечи. Ждите ретест или вторую свечу. На SOLUSDT в новости это особенно жёстко."),
    ("Сессии: Азия, Лондон, NY", "Ликвидность и скорость меняются по UTC. Для РФ и LATAM удобны пересечения. Торгуйте ликвидные часы вашей пары; мемы ночью — тонкий стакан."),
    ("Стоп и размер в двух режимах", "Быстрый: стоп за экстремумом волны, размер половинный. Медленный: стоп за границей range, терпение к лимитке. Риск 0.5–1% USDT не меняется — меняется номинал."),
    ("Как объяснить другу", "«Когда рынок бешеный — уменьшаю ставку и реже играю. Когда тихий — не дергаюсь от скуки, иначе комиссии съедят день.»"),
    ("Чеклист режима", "ATR выше среднего? Спред вырос? Новость в календаре? Если два да — быстрый режим. План скорректирован? Нет — пропуск."),
    ("Практика BINANCE:BTCUSDT", "Найдите день с высоким ATR и день флэта за неделю на 15m. Сравните range и спред. Скрин в журнал."),
    ("Итог урока 6", "Два режима — два набора правил. Следующий урок — ошибки новичков. Не смешивайте скальп-правила с флэтом."),
])

_L6_EN = [
    blk("Fast market", "Fast market: wide candles, wider spread, shaky book, news and liquidations. Cut size 50%, same USDT risk, fewer trades. After CPI on BTCUSDT 15m, ATR may triple — not your usual scalp target. Wait 15–30 minutes for compression."),
    blk("Slow market", "Slow market: tight range, thin book, Asian session boredom. False breaks multiply; overtrading bleeds fees. If 20-candle range is smaller than your stop, skip breakout trades."),
    blk("Sessions and checklist", "Liquidity shifts by session. Journal fast vs slow tag per trade. Checklist: elevated ATR, wider spread, news — two yes means fast mode rules. Practice: compare high-ATR vs flat days on BTCUSDT 15m."),
    blk("Stops and summary", "Fast: stop beyond spike, half size. Slow: stop beyond range, patient limits. Risk percent unchanged. Next: beginner mistakes. Explain regime to a friend before live size."),
]

_L6_PT = [
    blk("Mercado rápido", "Mercado rápido: spread maior, reduza tamanho 50%, mesmo risco USDT. Após notícia, espere ATR comprimir."),
    blk("Mercado lento", "Range estreito: evite overtrading. Se range < stop planejado, pule."),
    blk("Checklist", "Marque rápido/lento no diário. Compare dois dias em BTCUSDT 15m."),
    blk("Resumo", "Próxima lição: erros de iniciante."),
]

_L7_RU = _lesson_blocks_ru(7, [
    ("Торговля без стопа", "Стоп — признание ошибки до входа. Без стопа одна сделка может стереть месяц. На фьючерсах без стопа вас закроет ликвидация — хуже, чем плановый стоп. «Потом поставлю» = нет сделки. Запишите стоп в журнале до клика."),
    ("All-in в одну монету", "Весь депозит в PEPE или одну новость — не трейдинг, а ставка. Диверсификация для новичка: один актив в фокусе, но риск 0.5–1% на идею, не 100% счёта. All-in после плюса — hubris; после минуса — отчаяние."),
    ("FOMO — гонка за свечой", "Зелёная свеча +10% без вас — не приглашение маркетом. FOMO вход в хвосте импульса — худший R:R. Правило: пропущенный трейд не снимает деньги; плохой вход снимает. Пауза 15 минут после «упустил»."),
    ("Чаты сигналов и VIP", "Telegram «100x сигналы» — сбор депозитов. Нет стопа в сигнале — бегите. Trade Master учит свой план на TradingView, не чужой тикер. В РФ и LATAM такие чаты особенно активны — блокируйте, не спорьте."),
    ("Overtrading", "Двадцать сделок «потому что скучно» — комиссии и усталость. Лимит: 3 сделки в день на обучении или daily loss limit −3R. Качество > количество."),
    ("Реванш после стопа", "Стоп сработал — план сработал. Удвоить размер «отыграться» — классический слив. Пауза 30 минут, вода, журнал: «эмоция после стопа». Профессионал останавливается на день при −3R."),
    ("Как объяснить другу", "«Я заранее решаю, сколько потеряю, если не прав. Не гоняюсь за чужими скринами прибыли. После минуса не удваиваю — иду гулять.»"),
    ("Как исправить системно", "Чеклист до клика. Риск 0.5%. Daily loss cap. Журнал эмоций 1–10. Удалить сигнальные чаты. Tuition deposit."),
    ("Пауза как инструмент", "Лучшая сделка иногда — отсутствие сделки. Рынок 24/7, ваше внимание — нет."),
    ("Итог урока 7", "Семь ловушек новичка — узнайте себя в 2–3. Следующий урок — нисходящий треугольник. Исправьте одну ошибку на этой неделе."),
])

_L7_EN = [
    blk("No stop and all-in", "Stop defines loss before entry — no stop means no trade. Liquidation is worse than a planned stop. All-in one meme is a bet, not trading. Risk 0.5–1% per idea."),
    blk("FOMO and signal chats", "Chasing +10% candles with market entries ruins R:R. Missed trade costs zero; bad entry costs real USDT. Telegram VIP signals harvest deposits — use your TradingView plan."),
    blk("Overtrading and revenge", "Boredom trading feeds fees. Cap three trades per study day or −3R daily stop. After a stop, wait 30 minutes — never double size for revenge."),
    blk("Fixes and summary", "Checklist, emotion log, delete signal groups, tuition deposit only. Best trade is often no trade. Next: descending triangle. Pick one mistake to fix this week."),
]

_L7_PT = [
    blk("Sem stop e all-in", "Stop antes do clique. All-in em meme é aposta. Risco 0,5–1%."),
    blk("FOMO e sinais", "Não persiga vela verde com market. Grupos VIP — armadilha."),
    blk("Overtrading e revanche", "Máx 3 trades/dia no estudo. Após stop, pausa 30 min."),
    blk("Correções", "Checklist, diário de emoção, limite diário −3R."),
    blk("Resumo", "Próxima lição: triângulo descendente."),
]

_L8_RU = _lesson_blocks_ru(8, [
    ("Форма нисходящего треугольника", "Горизонтальная поддержка снизу + понижающиеся максимумы (lower highs) сверху — сжатие как клин. Давление продавцов нарастает. На BINANCE:SOLUSDT 15m ищите 3+ касания низа и 3 lower highs. Не каждый клин — треугольник; нужна ясная геометрия."),
    ("Горизонтальная поддержка в паттерне", "Нижняя граница — зона спроса. Чем больше касаний, тем тоньше «пол», но тем больше стопов под ним собрано. Пробой вниз часто ускоренный, когда покупатели сдались."),
    ("Lower highs — сигнал слабости", "Каждый максимум ниже предыдущего — продавцы входят раньше. Соедините вершины наклонной. Вход в шорт чаще после пробоя поддержки, не на середине клина без сигнала."),
    ("Объём на пробое", "Пробой вниз с ростом объёма сильнее тихого прокола. На TradingView включите объём. Ложный пробой вверх перед настоящим вниз — возможен; ждите закрытие свечи."),
    ("Ложный пробой вверх", "Охота стопов шортов перед падением. Закрытие обратно в треугольник — ловушка быков. Не шортите середину клина без плана."),
    ("Вход в шорт и стоп", "Триггер: закрытие 15m ниже поддержки, ретест снизу. Стоп выше ретеста или выше последнего lower high. Риск 0.5–1%, размер из формулы."),
    ("Тейк по высоте треугольника", "Измерьте высоту клина у основания — часто минимальная цель после пробоя (measured move). Частичная фиксация на 1R."),
    ("Как объяснить другу", "«Потолок наклоняется вниз, пол ровный — как сжимающийся коридор. Обычно вываливаются вниз, но жду, когда пол сломают, а не угадываю посередине.»"),
    ("Пример SOLUSDT", "Найдите на истории SOL 15m нисходящий треугольник за месяц. Разметьте вход/стоп/тейк на бумаге. Скрин в журнал."),
    ("Итог урока 8", "Паттерн медвежий в контексте сжатия. Следующий — восходящий треугольник. Не торгуйте паттерн без объёма и BTC-контекста."),
])

_L8_EN = [
    blk("Descending triangle shape", "Flat support plus lower highs — compression wedge. On BINANCE:SOLUSDT 15m seek three touches on base and three declining peaks. Sellers press harder each rally."),
    blk("Breakdown and false breaks", "Volume expansion on breakdown adds confidence. False upside break hunts shorts before real drop — wait 15m close. Short trigger: close below support, retest from below. Stop above retest."),
    blk("Targets and SOL example", "Measured move: triangle height projected from breakdown. Partial at +1R. Risk 0.5–1%. Journal one historical SOL pattern — plan only. Next: ascending triangle."),
]

_L8_PT = [
    blk("Triângulo descendente", "Suporte horizontal + topos descendentes. SOLUSDT 15m: marque 3 toques."),
    blk("Rompimento", "Fechamento abaixo do suporte + reteste. Stop acima do reteste. Volume confirma."),
    blk("Alvo e resumo", "Alvo = altura do triângulo. Próxima lição: triângulo ascendente."),
]

_L9_RU = _lesson_blocks_ru(9, [
    ("Форма восходящего треугольника", "Горизонтальное сопротивление сверху + повышающиеся минимумы (higher lows) — покупатели давят вверх. На BINANCE:SOLUSDT 15m ищите накопление под потолком."),
    ("Сопротивление и higher lows", "Потолок — зона предложения. Каждый лой выше — спрос сильнее. Соедините лои наклонной поддержкой."),
    ("Накопление перед пробоем", "Сужение range под сопротивлением — энергия. Пробой вверх с объёмом — бычий сценарий. Ложный пробой вниз — shakeout."),
    ("Пробой вверх и ретест", "Вход лонг: закрытие выше сопротивления, ретест сверху как поддержка. Стоп ниже ретеста. Не покупать в середине без сигнала."),
    ("Стоп и тейк", "Стоп под последним higher low или под зоной ретеста. Тейк — высота треугольника вверх от пробоя. R:R минимум 1:2."),
    ("Как объяснить другу", "«Пол поднимается, потолок ровный — как придавливают крышку. Жду, когда крышку пробьют вверх и подтвердят.»"),
    ("Пример SOLUSDT", "Исторический восходящий треугольник на SOL 15m — разметка без сделки."),
    ("Ошибки", "Покупка у потолка без пробоя. Игнор BTC падающего. Плечо высокое на пробое — волатильность."),
    ("Журнал паттернов", "Имя паттерна, высота, объём на пробое, исход. Сравните с нисходящим треугольником урока 8."),
    ("Итог урока 9", "Бычий симметричный брат урока 8. Дальше — стратегия импульсов."),
])

_L9_EN = [
    blk("Ascending triangle", "Flat resistance plus higher lows — buyers press up. SOLUSDT 15m accumulation under ceiling. Breakout with volume; false break down shakes weak hands."),
    blk("Entry and risk", "Long on 15m close above resistance, retest hold. Stop below retest or last higher low. Target triangle height. BTC context required."),
    blk("Journal and summary", "Log pattern name, height, volume. Contrast with lesson 8 descending form. Next: impulse strategy."),
]

_L9_PT = [
    blk("Triângulo ascendente", "Resistência flat + fundos ascendentes em SOLUSDT 15m."),
    blk("Entrada", "Fechamento acima + reteste. Stop abaixo do reteste."),
    blk("Resumo", "Próxima lição: estratégia de impulsos."),
]

_L10_RU = _lesson_blocks_ru(10, [
    ("Что такое импульс", "Импульс — резкое направленное движение на объёме, часто после сжатия range. На BINANCE:ETHUSDT 15m импульсная свеча в 2–3× среднего range — событие, не норма."),
    ("Range перед импульсом", "Длинный флэт + сужение — пружина. Торговать пробой границы range, не середину. Ждите закрытие свечи за уровнем."),
    ("Объём подтверждает", "Пробой без объёма — слабый. TradingView volume bar выше среднего — фильтр. На новостях объём и так высокий — осторожнее с размером."),
    ("Стратегия пробой-ретест", "Пробой → ретест сломанного уровня → вход по тренду. Стоп за ретест. Классика импульсной торговли для новичка на 15m."),
    ("Стоп за структурой", "Стоп за ближайшим swing low (лонг) или high (шорт) импульса, не в середине свечи."),
    ("Тейк и трейлинг", "Первая цель 1–1.5R, остаток трейл по последнему 15m low. Жадность на хвосте импульса — FOMO."),
    ("Как объяснить другу", "«Сначала тишина, потом резкий выстрел. Я не прыгаю в выстрел — жду, когда откатят к сломанной двери и оттолкнутся снова.»"),
    ("ETHUSDT пример", "Найдите импульс ETH за неделю, отметьте range до, пробой, ретест — план на бумаге."),
    ("Ошибки импульса", "Маркет в хвосте свечи. Нет стопа. Плечо 10x на новости. Торговля против BTC."),
    ("Итог урока 10", "Импульс торгуется на пробое и ретесте, не на FOMO. Следующие уроки — делистинг и листинг."),
])

_L10_EN = [
    blk("Impulse and range", "Impulse: sharp directional move on volume after compression. ETHUSDT 15m candle 2–3× average range is an event. Trade breakout of prior range, not middle."),
    blk("Breakout-retest strategy", "Break → retest broken level → enter with trend. Stop beyond retest. Volume above average filters weak breaks. First target 1–1.5R."),
    blk("ETH example and summary", "Mark one weekly ETH impulse: range, break, retest — paper plan only. Avoid market chase on news. Next: delisting risk."),
]

_L10_PT = [
    blk("Impulso", "Movimento forte após range estreito. ETHUSDT 15m: espere fechamento além do nível."),
    blk("Breakout-reteste", "Rompimento, reteste, entrada. Stop além do reteste. Volume confirma."),
    blk("Resumo", "Próximas lições: delisting e listagem."),
]

_L11_RU = _lesson_blocks_ru(11, [
    ("Что такое делистинг", "Делистинг — биржа снимает пару с торгов. Торговать нельзя или окно ограничено; вывести актив нужно до дедлайна. Binance публикует анонс заранее — читайте Announcements."),
    ("Почему монеты делистят", "Низкий объём, нарушения compliance, проблемы проекта. Мемы и малоизвестные альты в зоне риска. PEPEUSDT пока ликвиден — но урок про механику для любой мелкой монеты."),
    ("Таймлайн делистинга", "Анонс → только закрытие позиций → вывод в срок. Не покупайте «дешёвую» монету на делистинге «вдруг отскочит» — ликвидность исчезает."),
    ("Как выходить", "Закрыть позицию, конвертировать в USDT, вывести или перевести. Маркет в последний день — огромный спред. Действуйте рано."),
    ("Падение цены при новости", "Часто −30–80% за часы на страх. Шорт опасен без опыта; лонг ловить нож — тоже. Лучшая сделка — отсутствие позиции."),
    ("PEPEUSDT как напоминание", "Даже ликвидные мемы волатильны. Делистинг — про процесс, не прогноз по PEPE. Держите риск маленьким на экзотике."),
    ("Как объяснить другу", "«Биржа выкидывает монету с прилавка. Купить потом некому — цена падает в яму. Я не геройствую — выхожу по анонсу.»"),
    ("Чеклист делистинга", "Проверять Announcements раз в неделю. Нет позиций в монетах без плана выхода. Стоп не спасёт при остановке торгов."),
    ("Не обнуляйтесь на одной монете", "Концентрация в одной альте + делистинг = катастрофа. Диверсификация и USDT."),
    ("Итог урока 11", "Делистинг — рыночный риск, не паттерн. Следующий — листинг новых пар."),
])

_L11_EN = [
    blk("Delisting explained", "Exchange removes a pair — trading ends or narrows; withdraw before deadline. Binance Announcements list timelines. Reasons: low volume, compliance, project issues."),
    blk("Timeline and exit", "Announce → close-only → withdraw. Do not buy «cheap» delisting coins hoping for bounce. Exit early; final-day market has huge spread. Price can drop 30–80% on fear."),
    blk("PEPE reminder and checklist", "PEPEUSDT is liquid today — lesson is process for any small cap. Weekly announcement check. No hero trades. Next: new listings."),
]

_L11_PT = [
    blk("Delisting", "Exchange remove par — saia antes do prazo. Leia Announcements Binance."),
    blk("Timeline", "Não compre moneda em delisting por esperança. Spread enorme no último dia."),
    blk("Checklist", "Risco pequeno em alts exóticas. Próxima: listagem."),
]

_L12_RU = _lesson_blocks_ru(12, [
    ("Что такое листинг", "Листинг — новая пара на бирже. Первые часы: дикая волатильность, широкий спред, FOMO. BINANCE:ARBUSDT на истории листинга — учебный кейс волатильности."),
    ("Первые минуты торгов", "Скачки ±10–50%, ликвидации, проскальзывание. Новичку — наблюдение, не участие. Если участвуете — микро-размер и стоп обязателен."),
    ("Памп и откат", "Первая волна покупателей, затем фиксация — глубокий откат. Не покупать хай первого часа без плана. Ждите структуру 15m."),
    ("Размер позиции на листинге", "Риск 0.25–0.5% максимум — не стандартный 1%. ATR огромен. Плечо 2–3x или спот."),
    ("Стоп обязателен", "Гэпы и свечи через несколько процентов. Стоп за последним swing, не «в голове». Ликвидация на 10x за минуты реальна."),
    ("ARB как пример", "Откройте ARBUSDT 15m с даты листинга на TradingView. Изучите первые сутки — волатильность, не «легкие деньги»."),
    ("Pre-market риск", "Некоторые листинги с pre-market — ещё тоньше ликвидность. Читайте правила биржи."),
    ("Как объяснить другу", "«Новая монета — как открытие популярного магазина: толпа, давка, кто-то падает. Я смотрю со стороны первые дни.»"),
    ("План на листинг", "Не в первый час. Ждать 15m структуру. Размер минимальный. Анонс в календаре. Журнал."),
    ("Итог урока 12", "Листинг — событие для наблюдения, не охоты. Завершили блок 2–12: ордера, амплитуда, уровни, стакан, режимы, ошибки, паттерны, импульс, листинги."),
])

_L12_EN = [
    blk("New listing basics", "New pair on exchange — extreme volatility first hours, wide spread, FOMO. BINANCE:ARBUSDT listing history is a volatility case study. Observe first; trade micro if at all."),
    blk("Pump, size, and stops", "First wave then deep pullback — do not chase hour-one high. Risk 0.25–0.5% max; leverage 2–3x. Stop beyond last swing — gaps are real on listings."),
    blk("ARB example and plan", "Study ARBUSDT first day on 15m. Pre-market rules vary — read exchange notice. Next: practice full journal loop on your chosen symbol."),
]

_L12_PT = [
    blk("Listagem", "Nova par — volatilidade extrema nas primeiras horas. ARBUSDT como estudo."),
    blk("Tamanho e stop", "Risco 0,25–0,5%. Alavancagem baixa. Não persiga o topo da primeira hora."),
    blk("Plano", "Observe primeiro; estrutura 15m antes de entrar. Bloco 2–12 completo."),
]

LESSON_BLOCKS = {
    5: (_L5_RU, _L5_EN, _L5_PT),
    6: (_L6_RU, _L6_EN, _L6_PT),
    7: (_L7_RU, _L7_EN, _L7_PT),
    8: (_L8_RU, _L8_EN, _L8_PT),
    9: (_L9_RU, _L9_EN, _L9_PT),
    10: (_L10_RU, _L10_EN, _L10_PT),
    11: (_L11_RU, _L11_EN, _L11_PT),
    12: (_L12_RU, _L12_EN, _L12_PT),
}
