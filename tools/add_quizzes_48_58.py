#!/usr/bin/env python3
"""Append 33 quizzes (lessons 48–58 × 3) to assets/data/lesson_quizzes.json.

Idempotent: removes any existing lessonId 48–58 quizzes, then appends the pack.
Expected total after a clean 141-quiz base: 174.
"""

from __future__ import annotations

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "assets" / "data" / "lesson_quizzes.json"


def q(
    lesson_id: int,
    n: int,
    difficulty: str,
    question: dict[str, str],
    options: dict[str, list[str]],
    correct_index: int,
    explanation: dict[str, str],
) -> dict:
    assert 0 <= correct_index <= 3
    for lang in ("ru", "en", "pt"):
        assert lang in question and lang in options and lang in explanation
        assert len(options[lang]) == 4
    return {
        "lessonId": lesson_id,
        "id": f"L{lesson_id}-Q{n}",
        "difficulty": difficulty,
        "question": question,
        "options": options,
        "correctIndex": correct_index,
        "explanation": explanation,
    }


NEW: list[dict] = [
    # ── 48 resistance / flip ──────────────────────────────────────────────
    q(
        48,
        1,
        "Beginner",
        {
            "ru": "Как правильно рисовать сопротивление?",
            "en": "How should you draw resistance?",
            "pt": "Como desenhar resistance corretamente?",
        },
        {
            "ru": [
                "Одной случайной линией по одному хаю",
                "Зоной по 2+ близким хаям",
                "Только по круглой цене без касаний",
                "Всегда строго по VWAP дня",
            ],
            "en": [
                "As one random line on a single high",
                "As a zone from 2+ nearby highs",
                "Only on a round number with no touches",
                "Always exactly on the day VWAP",
            ],
            "pt": [
                "Como uma linha aleatória num único high",
                "Como uma zona a partir de 2+ highs próximos",
                "Só num preço redondo sem toques",
                "Sempre exatamente no VWAP do dia",
            ],
        },
        1,
        {
            "ru": "Сопротивление — зона продавцов по нескольким хаям, не тонкая линия «на глаз».",
            "en": "Resistance is a sellers’ zone from several highs, not a thin guess-line.",
            "pt": "Resistance é uma zona de vendedores a partir de vários highs, não uma linha fina.",
        },
    ),
    q(
        48,
        2,
        "Beginner",
        {
            "ru": "Что такое flip уровня после пробоя сопротивления?",
            "en": "What is a level flip after resistance breaks?",
            "pt": "O que é o flip de nível após romper resistance?",
        },
        {
            "ru": [
                "Старое сопротивление часто работает как поддержка сверху",
                "Уровень сразу удаляется с графика",
                "Всегда нужно удваивать риск",
                "Flip разрешает вход без стопа",
            ],
            "en": [
                "Old resistance often acts as support from above",
                "The level is deleted from the chart immediately",
                "You must always double the risk",
                "A flip allows entry without a stop",
            ],
            "pt": [
                "A antiga resistance costuma atuar como suporte por cima",
                "O nível é apagado do gráfico imediatamente",
                "É preciso sempre dobrar o risco",
                "O flip permite entrar sem stop",
            ],
        },
        0,
        {
            "ru": "После close выше зоны цена часто ретестит сверху: бывшее сопротивление → поддержка.",
            "en": "After a close above the zone, price often retests from above: old resistance → support.",
            "pt": "Após close acima da zona, o preço costuma retestar por cima: antiga resistance → suporte.",
        },
    ),
    q(
        48,
        3,
        "Beginner",
        {
            "ru": "Где ставят стоп при шорте от зоны сопротивления?",
            "en": "Where do you put the stop when shorting a resistance zone?",
            "pt": "Onde fica o stop ao shortar uma zona de resistance?",
        },
        {
            "ru": [
                "Внутри зоны «чуть ниже хая»",
                "На входе без стопа",
                "За хаями / за зоной сверху",
                "Всегда ровно на круглой цене",
            ],
            "en": [
                "Inside the zone “a bit below the high”",
                "At entry with no stop",
                "Beyond the highs / above the zone",
                "Always exactly on a round number",
            ],
            "pt": [
                "Dentro da zona “um pouco abaixo do high”",
                "Na entrada sem stop",
                "Além dos highs / acima da zona",
                "Sempre exatamente num preço redondo",
            ],
        },
        2,
        {
            "ru": "Шорт у зоны сверху: стоп за хаями, чтобы тень не сняла позу без слома уровня.",
            "en": "Short at the zone from above: stop beyond the highs so a wick doesn’t take you out without a break.",
            "pt": "Short na zona por cima: stop além dos highs para um pavio não tirar sem romper o nível.",
        },
    ),
    # ── 49 multi-timeframe ────────────────────────────────────────────────
    q(
        49,
        1,
        "Beginner",
        {
            "ru": "Какая роль у 4h в карте таймфреймов?",
            "en": "What is the 4h role on the timeframe map?",
            "pt": "Qual é o papel do 4h no mapa de timeframes?",
        },
        {
            "ru": [
                "Точный вход по пину",
                "Только расчёт funding",
                "Поиск объёма на 1m",
                "Сторона / направление структуры",
            ],
            "en": [
                "Exact pin-bar entry",
                "Funding calculation only",
                "Finding volume on 1m",
                "Side / structure direction",
            ],
            "pt": [
                "Entrada exata no pin",
                "Só cálculo de funding",
                "Achar volume no 1m",
                "Lado / direção da estrutura",
            ],
        },
        3,
        {
            "ru": "4h (или 1D) задаёт сторону: вверх, вниз или флэт. Вход ищется ниже по ТФ.",
            "en": "4h (or 1D) sets the side: up, down, or range. Entry is found on lower TFs.",
            "pt": "O 4h (ou 1D) define o lado: alta, baixa ou range. A entrada fica nos TFs menores.",
        },
    ),
    q(
        49,
        2,
        "Beginner",
        {
            "ru": "Зачем открывают 1h, если уже смотрят 4h?",
            "en": "Why open 1h if you already look at 4h?",
            "pt": "Por que abrir o 1h se já olha o 4h?",
        },
        {
            "ru": [
                "Чтобы заменить стоп на «ощущение»",
                "Чтобы найти зону входа (уровень / ретест)",
                "Чтобы игнорировать старший тренд",
                "Чтобы торговать каждый шум 1m",
            ],
            "en": [
                "To replace the stop with a “feeling”",
                "To find the entry zone (level / retest)",
                "To ignore the higher-timeframe trend",
                "To trade every 1m noise tick",
            ],
            "pt": [
                "Para trocar o stop por “feeling”",
                "Para achar a zona de entrada (nível / reteste)",
                "Para ignorar a tendência do TF maior",
                "Para operar todo ruído do 1m",
            ],
        },
        1,
        {
            "ru": "1h показывает где стоять: зона уровня, ретеста или границы диапазона.",
            "en": "1h shows where to stand: level, retest, or range-edge zone.",
            "pt": "O 1h mostra onde ficar: zona de nível, reteste ou borda do range.",
        },
    ),
    q(
        49,
        3,
        "Beginner",
        {
            "ru": "Можно ли входить 15m против явного направления 4h?",
            "en": "Can you enter on 15m against a clear 4h direction?",
            "pt": "Pode entrar no 15m contra a direção clara do 4h?",
        },
        {
            "ru": [
                "Да, всегда — 15m важнее",
                "Да, если «кажется, отскочит»",
                "Только с заранее написанным контртренд-планом",
                "Нет никогда, даже с планом",
            ],
            "en": [
                "Yes always — 15m matters more",
                "Yes if it “looks like a bounce”",
                "Only with a pre-written countertrend plan",
                "Never, even with a plan",
            ],
            "pt": [
                "Sim sempre — 15m importa mais",
                "Sim se “parece que vai quicar”",
                "Só com um plano contra-tendência escrito antes",
                "Nunca, mesmo com plano",
            ],
        },
        2,
        {
            "ru": "Против 4h без явного плана (зона, стоп, цель, риск) — нельзя. «Кажется» ≠ план.",
            "en": "Against 4h without an explicit plan (zone, stop, target, risk) — no. “Looks like it” ≠ a plan.",
            "pt": "Contra o 4h sem plano explícito (zona, stop, alvo, risco) — não. “Parece” ≠ plano.",
        },
    ),
    # ── 50 false breakout ─────────────────────────────────────────────────
    q(
        50,
        1,
        "Beginner",
        {
            "ru": "Чем ложный пробой отличается от настоящего?",
            "en": "How does a false breakout differ from a real one?",
            "pt": "Como um falso rompimento difere de um verdadeiro?",
        },
        {
            "ru": [
                "Любая тень уже = пробой",
                "Разницы нет",
                "Пробой = только объём без close",
                "Тень проколола, но close ТФ вернулся внутрь / за зону",
            ],
            "en": [
                "Any wick already = a breakout",
                "There is no difference",
                "Breakout = volume only, no close needed",
                "A wick pierced, but the TF close came back inside / past the zone",
            ],
            "pt": [
                "Qualquer pavio já = rompimento",
                "Não há diferença",
                "Rompimento = só volume, sem close",
                "O pavio furou, mas o close do TF voltou para dentro / além da zona",
            ],
        },
        3,
        {
            "ru": "Тень ≠ слом. Нужен close рабочего ТФ и удержание; иначе часто shakeout.",
            "en": "A wick ≠ a break. You need the working-TF close and hold; otherwise it’s often a shakeout.",
            "pt": "Pavio ≠ rompimento. Precisa do close do TF de trabalho e retenção; senão é shakeout.",
        },
    ),
    q(
        50,
        2,
        "Beginner",
        {
            "ru": "Что важнее подтвердить при проверке пробоя уровня?",
            "en": "What matters most when checking a level breakout?",
            "pt": "O que mais importa ao checar um rompimento de nível?",
        },
        {
            "ru": [
                "Close выбранного таймфрейма относительно зоны",
                "Цвет индикатора RSI за 1 секунду",
                "Мнение в чате без графика",
                "Только то, что high обновился на 1 тик",
            ],
            "en": [
                "The chosen timeframe’s close vs the zone",
                "RSI color for one second",
                "Chat opinion without a chart",
                "Only that the high moved one tick",
            ],
            "pt": [
                "O close do timeframe escolhido em relação à zona",
                "A cor do RSI por um segundo",
                "Opinião do chat sem gráfico",
                "Só que o high andou um tick",
            ],
        },
        0,
        {
            "ru": "Правило урока: close ТФ + удержание. Один тик high/low сам по себе — не сигнал.",
            "en": "Lesson rule: TF close + hold. A one-tick high/low alone is not a signal.",
            "pt": "Regra da aula: close do TF + retenção. Um tick de high/low sozinho não é sinal.",
        },
    ),
    q(
        50,
        3,
        "Beginner",
        {
            "ru": "Что делать сразу после ложного выноса (false break)?",
            "en": "What should you do right after a false breakout?",
            "pt": "O que fazer logo após um falso rompimento?",
        },
        {
            "ru": [
                "Удвоить позицию «из мести»",
                "Сразу маркет без плана",
                "Не мстить рынку: переоценить зону / план, не chase",
                "Убрать стоп и «переждать»",
            ],
            "en": [
                "Double size out of revenge",
                "Market-enter immediately with no plan",
                "Don’t revenge-trade: reassess the zone / plan, don’t chase",
                "Remove the stop and “wait it out”",
            ],
            "pt": [
                "Dobrar a posição por vingança",
                "Entrar a mercado sem plano",
                "Não vingar o mercado: reavaliar zona / plano, sem chase",
                "Tirar o stop e “esperar passar”",
            ],
        },
        2,
        {
            "ru": "После false break легко эмоционально влететь. Сначала план и зона заново — не месть.",
            "en": "After a fakeout it’s easy to revenge-trade. Rebuild the plan and zone first.",
            "pt": "Após o fakeout é fácil entrar por emoção. Refaça plano e zona primeiro.",
        },
    ),
    # ── 51 trade management BE / partial ──────────────────────────────────
    q(
        51,
        1,
        "Beginner",
        {
            "ru": "Что обычно делают на +1R в сопровождении сделки?",
            "en": "What do you usually do at +1R in trade management?",
            "pt": "O que se faz em geral em +1R na gestão da trade?",
        },
        {
            "ru": [
                "Закрыть всё и никогда не трейлить",
                "Часть позиции в плюс и/или стоп в безубыток (BE)",
                "Сдвинуть стоп дальше от цены",
                "Добавить риск «потому что пошла»",
            ],
            "en": [
                "Close everything and never trail",
                "Take a partial in profit and/or move stop to break-even (BE)",
                "Move the stop farther from price",
                "Add risk “because it’s running”",
            ],
            "pt": [
                "Fechar tudo e nunca trailar",
                "Realizar parcial e/ou mover o stop para break-even (BE)",
                "Afastar o stop do preço",
                "Aumentar risco “porque está andando”",
            ],
        },
        1,
        {
            "ru": "На +1R часто фиксируют часть и переводят стоп в BE — защищают результат.",
            "en": "At +1R you often bank a partial and move stop to BE — protect the result.",
            "pt": "Em +1R costuma-se realizar parcial e mover o stop para BE — proteger o resultado.",
        },
    ),
    q(
        51,
        2,
        "Beginner",
        {
            "ru": "Почему нельзя отодвигать стоп дальше от входа «пережду»?",
            "en": "Why mustn’t you drag the stop farther from entry to “wait it out”?",
            "pt": "Por que não afastar o stop da entrada para “esperar passar”?",
        },
        {
            "ru": [
                "Потому что это увеличивает риск сверх плана",
                "Потому что биржа запрещает стопы",
                "Потому что BE всегда хуже",
                "Потому что partial запрещён",
            ],
            "en": [
                "Because it increases risk beyond the plan",
                "Because exchanges ban stops",
                "Because BE is always worse",
                "Because partials are forbidden",
            ],
            "pt": [
                "Porque aumenta o risco além do plano",
                "Porque exchanges proíbem stops",
                "Porque BE é sempre pior",
                "Porque partial é proibido",
            ],
        },
        0,
        {
            "ru": "Расширение стопа = больший % риска. Урок: стоп дальше от цены запрещён.",
            "en": "Widening the stop = larger % risk. Lesson: stop farther from price is banned.",
            "pt": "Alargar o stop = maior % de risco. Aula: stop mais longe do preço é proibido.",
        },
    ),
    q(
        51,
        3,
        "Beginner",
        {
            "ru": "Для чего нужен трейлинг после частичной фиксации?",
            "en": "What is trailing for after a partial take-profit?",
            "pt": "Para que serve o trail após uma parcial?",
        },
        {
            "ru": [
                "Чтобы убрать цель полностью",
                "Чтобы вход без стопа стал «нормой»",
                "Чтобы дать остатку расти, подтягивая защиту за структурой",
                "Чтобы всегда закрывать на −1R",
            ],
            "en": [
                "To delete the target entirely",
                "To make no-stop entries “normal”",
                "To let the remainder run while pulling protection with structure",
                "To always exit at −1R",
            ],
            "pt": [
                "Para apagar o alvo por completo",
                "Para tornar entrada sem stop “normal”",
                "Para deixar o resto correr, puxando proteção com a estrutura",
                "Para sempre sair em −1R",
            ],
        },
        2,
        {
            "ru": "Трейл защищает остаток по мере движения, не расширяя исходный риск.",
            "en": "A trail protects the remainder as price moves, without expanding original risk.",
            "pt": "O trail protege o restante conforme o preço anda, sem expandir o risco original.",
        },
    ),
    # ── 52 no-trade filter / invalidation ─────────────────────────────────
    q(
        52,
        1,
        "Beginner",
        {
            "ru": "Что проверяют до входа фильтром «не торгуй»?",
            "en": "What does a no-trade filter check before entry?",
            "pt": "O que o filtro “não operar” verifica antes da entrada?",
        },
        {
            "ru": [
                "Только цвет свечи на 1m",
                "Есть ли условия плана / контекст; если нет — пропускаем",
                "Можно ли усреднить позже",
                "Написал ли кто-то «памп» в чате",
            ],
            "en": [
                "Only the 1m candle color",
                "Whether plan conditions / context exist; if not — skip",
                "Whether you can average down later",
                "Whether someone wrote “pump” in chat",
            ],
            "pt": [
                "Só a cor do candle de 1m",
                "Se há condições do plano / contexto; se não — pular",
                "Se dá para médio depois",
                "Se alguém escreveu “pump” no chat",
            ],
        },
        1,
        {
            "ru": "Сначала фильтр: нет условий сетапа — нет клика. Усреднение не спасает плохой вход.",
            "en": "Filter first: no setup conditions — no click. Averaging doesn’t fix a bad entry.",
            "pt": "Filtro primeiro: sem condições do setup — sem clique. Médias não salvam má entrada.",
        },
    ),
    q(
        52,
        2,
        "Beginner",
        {
            "ru": "Что значит инвалидация паттерна / сетапа?",
            "en": "What does pattern / setup invalidation mean?",
            "pt": "O que significa invalidação do padrão / setup?",
        },
        {
            "ru": [
                "Цена чуть отошла от входа",
                "Индикатор моргнул красным",
                "Нужно удвоить размер",
                "Close обратно внутрь фигуры / за ключевой уровень — идея мертва",
            ],
            "en": [
                "Price moved a bit from entry",
                "An indicator blinked red",
                "You must double size",
                "A close back inside the pattern / past a key level — idea is dead",
            ],
            "pt": [
                "O preço só se afastou um pouco da entrada",
                "Um indicador piscou vermelho",
                "É preciso dobrar o tamanho",
                "Close de volta para dentro da figura / além do nível-chave — ideia morta",
            ],
        },
        3,
        {
            "ru": "Инвалидация — чёткое условие отмены. После неё не «держу надеждой».",
            "en": "Invalidation is a clear cancel condition. After it, you don’t “hope and hold”.",
            "pt": "Invalidação é condição clara de cancelar. Depois dela, não “segurar na esperança”.",
        },
    ),
    q(
        52,
        3,
        "Beginner",
        {
            "ru": "Почему усреднение убыточной позиции обычно запрещено в уроке?",
            "en": "Why does the lesson usually ban averaging a losing position?",
            "pt": "Por que a aula costuma proibir médio em posição perdedora?",
        },
        {
            "ru": [
                "Потому что увеличивает риск и размывает план входа",
                "Потому что биржа блокирует avg",
                "Потому что partial тогда запрещён",
                "Потому что funding всегда 0",
            ],
            "en": [
                "Because it increases risk and blurs the entry plan",
                "Because the exchange blocks averaging",
                "Because partials become illegal",
                "Because funding is always 0",
            ],
            "pt": [
                "Porque aumenta o risco e embaca o plano de entrada",
                "Porque a exchange bloqueia médio",
                "Porque partial fica ilegal",
                "Porque funding é sempre 0",
            ],
        },
        0,
        {
            "ru": "Усреднение часто превращает −1R в −2R/−3R без нового edge. Сетап мёртв — выход.",
            "en": "Averaging often turns −1R into −2R/−3R without new edge. Dead setup — exit.",
            "pt": "Médias muitas vezes viram −1R em −2R/−3R sem edge novo. Setup morto — sair.",
        },
    ),
    # ── 53 double top / bottom measured move ──────────────────────────────
    q(
        53,
        1,
        "Beginner",
        {
            "ru": "Когда входит по двойной вершине / двойному дну?",
            "en": "When do you enter a double top / double bottom?",
            "pt": "Quando entrar em double top / double bottom?",
        },
        {
            "ru": [
                "В середине между двумя пиками «на глаз»",
                "Сразу на первом касании без шеи",
                "После close за линией шеи",
                "Только если RSI = 50",
            ],
            "en": [
                "Halfway between the two peaks “by eye”",
                "On the first touch with no neckline",
                "After a close beyond the neckline",
                "Only if RSI = 50",
            ],
            "pt": [
                "No meio entre os dois picos “no olho”",
                "No primeiro toque sem neckline",
                "Após close além da linha do pescoço",
                "Só se RSI = 50",
            ],
        },
        2,
        {
            "ru": "Триггер — close за шеей. До этого фигура ещё не подтверждена.",
            "en": "Trigger = close beyond the neckline. Until then the pattern isn’t confirmed.",
            "pt": "Gatilho = close além do pescoço. Antes disso o padrão não está confirmado.",
        },
    ),
    q(
        53,
        2,
        "Beginner",
        {
            "ru": "Куда ставят стоп на двойной вершине?",
            "en": "Where is the stop on a double top?",
            "pt": "Onde fica o stop no double top?",
        },
        {
            "ru": [
                "Ровно на шее без запаса",
                "За вторым пиком (экстремумом)",
                "Ниже далекого PDL без связи с фигурой",
                "В безубыток до close за шеей",
            ],
            "en": [
                "Exactly on the neckline with no buffer",
                "Beyond the second peak (extreme)",
                "Under a distant PDL unrelated to the pattern",
                "At break-even before the neckline close",
            ],
            "pt": [
                "Exatamente no pescoço sem folga",
                "Além do segundo pico (extremo)",
                "Abaixo de um PDL distante sem relação com a figura",
                "No break-even antes do close do pescoço",
            ],
        },
        1,
        {
            "ru": "Стоп за 2-м пиком/дном: если экстремум переписан — идея double top/bottom ломается.",
            "en": "Stop beyond the 2nd peak/bottom: if that extreme is taken out, the idea breaks.",
            "pt": "Stop além do 2º pico/fundo: se esse extremo for violado, a ideia quebra.",
        },
    ),
    q(
        53,
        3,
        "Beginner",
        {
            "ru": "Как считают measured move у двойной вершины?",
            "en": "How do you measure the measured move on a double top?",
            "pt": "Como medir o measured move no double top?",
        },
        {
            "ru": [
                "H = высота от пиков до шеи; цель ≈ H вниз от пробоя шеи",
                "Всегда ×10 от ATR без шеи",
                "Цель = вход минус 1 тик",
                "Только до ближайшей круглой цены",
            ],
            "en": [
                "H = height from peaks to neckline; target ≈ H down from the neckline break",
                "Always 10× ATR with no neckline",
                "Target = entry minus 1 tick",
                "Only to the nearest round number",
            ],
            "pt": [
                "H = altura dos picos à neckline; alvo ≈ H para baixo a partir do rompimento",
                "Sempre 10× ATR sem neckline",
                "Alvo = entrada menos 1 tick",
                "Só até o preço redondo mais próximo",
            ],
        },
        0,
        {
            "ru": "Классика: высота фигуры H проецируется от точки пробоя шеи.",
            "en": "Classic: pattern height H is projected from the neckline break.",
            "pt": "Clássico: a altura H da figura projeta-se a partir do rompimento do pescoço.",
        },
    ),
    # ── 54 flag / pennant ─────────────────────────────────────────────────
    q(
        54,
        1,
        "Beginner",
        {
            "ru": "Что обязательно должно быть до флага или вымпела?",
            "en": "What must exist before a flag or pennant?",
            "pt": "O que precisa existir antes de um flag ou pennant?",
        },
        {
            "ru": [
                "Только флэт без импульса",
                "Сильное древко (импульс), потом короткая пауза",
                "Пять индикаторов на одном экране",
                "Двойная вершина без шеи",
            ],
            "en": [
                "Only a flat range with no impulse",
                "A strong pole (impulse), then a short pause",
                "Five indicators on one screen",
                "A double top with no neckline",
            ],
            "pt": [
                "Só um range flat sem impulso",
                "Um pole forte (impulso), depois uma pausa curta",
                "Cinco indicadores numa tela",
                "Double top sem neckline",
            ],
        },
        1,
        {
            "ru": "Без сильного древка «флаг» — просто шум. Сначала импульс, потом пауза.",
            "en": "Without a strong pole, a “flag” is just noise. Impulse first, then the pause.",
            "pt": "Sem um pole forte, o “flag” é só ruído. Impulso primeiro, depois a pausa.",
        },
    ),
    q(
        54,
        2,
        "Beginner",
        {
            "ru": "Чем флаг визуально отличается от вымпела?",
            "en": "How does a flag differ visually from a pennant?",
            "pt": "Como um flag difere visualmente de um pennant?",
        },
        {
            "ru": [
                "Флаг = параллельный канал паузы; вымпел = сходящийся треугольник",
                "Разницы нет никогда",
                "Флаг всегда красный на графике",
                "Вымпел торгуют только против древка",
            ],
            "en": [
                "Flag = parallel pause channel; pennant = converging triangle",
                "There is never a difference",
                "A flag is always colored red on the chart",
                "Pennants are only traded against the pole",
            ],
            "pt": [
                "Flag = canal paralelo da pausa; pennant = triângulo convergente",
                "Nunca há diferença",
                "Flag é sempre vermelho no gráfico",
                "Pennant só se opera contra o pole",
            ],
        },
        0,
        {
            "ru": "Оба — пауза после импульса; форма паузы разная: канал vs схождение.",
            "en": "Both are pauses after an impulse; pause shape differs: channel vs convergence.",
            "pt": "Ambos são pausas após impulso; a forma da pausa difere: canal vs convergência.",
        },
    ),
    q(
        54,
        3,
        "Beginner",
        {
            "ru": "Куда обычно метить цель после пробоя флага?",
            "en": "Where do you usually project the target after a flag break?",
            "pt": "Para onde projetar o alvo após o rompimento do flag?",
        },
        {
            "ru": [
                "Случайный −50% от входа",
                "Всегда обратно в середину древка",
                "От точки пробоя ≈ высота древка H",
                "Только до funding settlement",
            ],
            "en": [
                "A random −50% from entry",
                "Always back to the middle of the pole",
                "From the break point ≈ pole height H",
                "Only until funding settlement",
            ],
            "pt": [
                "Um −50% aleatório da entrada",
                "Sempre de volta ao meio do pole",
                "Do ponto de rompimento ≈ altura H do pole",
                "Só até o settlement de funding",
            ],
        },
        2,
        {
            "ru": "Measured move флага: отложите H древка от пробоя в сторону тренда.",
            "en": "Flag measured move: project pole height H from the break in trend direction.",
            "pt": "Measured move do flag: projete a altura H do pole a partir do rompimento.",
        },
    ),
    # ── 55 wedge vs triangle ──────────────────────────────────────────────
    q(
        55,
        1,
        "Beginner",
        {
            "ru": "Чем клин визуально отличается от треугольника?",
            "en": "How does a wedge differ visually from a triangle?",
            "pt": "Como um wedge difere visualmente de um triângulo?",
        },
        {
            "ru": [
                "Клин: обе границы наклонены в одну сторону; треугольник — flat или встречные склоны",
                "Клин всегда без схождения",
                "Треугольник запрещён на 1H",
                "Разницы нет — это одно и то же",
            ],
            "en": [
                "Wedge: both borders slope the same way; triangle — flat side or opposite slopes",
                "A wedge never converges",
                "Triangles are banned on 1H",
                "No difference — they are the same",
            ],
            "pt": [
                "Wedge: ambas as bordas inclinadas no mesmo sentido; triângulo — lado flat ou declives opostos",
                "Wedge nunca converge",
                "Triângulos são proibidos no 1H",
                "Não há diferença — é a mesma coisa",
            ],
        },
        0,
        {
            "ru": "Сначала назовите форму границ: одинаковый наклон (клин) vs flat/встречные (треугольник).",
            "en": "Name the border shape first: same-way slopes (wedge) vs flat/opposite (triangle).",
            "pt": "Nomeie a forma das bordas: declives iguais (wedge) vs flat/opostos (triângulo).",
        },
    ),
    q(
        55,
        2,
        "Beginner",
        {
            "ru": "Какой классический bias у rising wedge?",
            "en": "What is the classic bias of a rising wedge?",
            "pt": "Qual é o bias clássico de um rising wedge?",
        },
        {
            "ru": [
                "Всегда лонг из середины",
                "Часто медвежий (пробой вниз), но вход только после close",
                "Всегда игнор стопа",
                "Только скальп без инвалидации",
            ],
            "en": [
                "Always long from the middle",
                "Often bearish (break down), but enter only after a close",
                "Always ignore the stop",
                "Scalp only with no invalidation",
            ],
            "pt": [
                "Sempre long do meio",
                "Muitas vezes bearish (rompimento para baixo), mas entrar só após close",
                "Sempre ignorar o stop",
                "Só scalp sem invalidação",
            ],
        },
        1,
        {
            "ru": "Rising wedge чаще даёт медвежий bias; falling wedge — бычий. Bias ≠ вход без close.",
            "en": "Rising wedge often has a bearish bias; falling wedge — bullish. Bias ≠ entry without close.",
            "pt": "Rising wedge costuma ter bias bearish; falling wedge — bullish. Bias ≠ entrada sem close.",
        },
    ),
    q(
        55,
        3,
        "Beginner",
        {
            "ru": "Почему ascending triangle — не rising wedge?",
            "en": "Why is an ascending triangle not a rising wedge?",
            "pt": "Por que um ascending triangle não é rising wedge?",
        },
        {
            "ru": [
                "Потому что у треугольника сопротивление почти плоское, а lows растут",
                "Потому что в треугольнике нет highs",
                "Потому что wedge всегда плоский сверху",
                "Потому что оба запрещены в крипте",
            ],
            "en": [
                "Because the triangle has nearly flat resistance while lows rise",
                "Because triangles have no highs",
                "Because a wedge is always flat on top",
                "Because both are banned in crypto",
            ],
            "pt": [
                "Porque o triângulo tem resistance quase flat e lows a subir",
                "Porque triângulos não têm highs",
                "Porque wedge tem sempre o topo flat",
                "Porque ambos são proibidos em crypto",
            ],
        },
        0,
        {
            "ru": "У клина обе границы вверх; у ascending triangle верх почти flat — другой сетап.",
            "en": "A wedge slopes both borders up; an ascending triangle has a nearly flat top — different setup.",
            "pt": "No wedge ambas as bordas sobem; no ascending triangle o topo é quase flat — outro setup.",
        },
    ),
    # ── 56 VWAP / PDH Asia ────────────────────────────────────────────────
    q(
        56,
        1,
        "Beginner",
        {
            "ru": "Что такое PDH / PDL?",
            "en": "What are PDH / PDL?",
            "pt": "O que são PDH / PDL?",
        },
        {
            "ru": [
                "Индикаторы плеча биржи",
                "Максимум и минимум вчерашнего дня",
                "Только Asia open",
                "Средняя funding за месяц",
            ],
            "en": [
                "Exchange leverage indicators",
                "Yesterday’s day high and day low",
                "Asia open only",
                "Average funding for the month",
            ],
            "pt": [
                "Indicadores de alavancagem da exchange",
                "Máxima e mínima do dia anterior",
                "Só o Asia open",
                "Funding médio do mês",
            ],
        },
        1,
        {
            "ru": "PDH/PDL — previous day high/low: карта дня, магниты отбоя и пробоя.",
            "en": "PDH/PDL = previous day high/low: day map, bounce and break magnets.",
            "pt": "PDH/PDL = máxima/mínima do dia anterior: mapa do dia, ímãs de rejeição e rompimento.",
        },
    ),
    q(
        56,
        2,
        "Beginner",
        {
            "ru": "Что показывает VWAP внутри дня?",
            "en": "What does VWAP show within the day?",
            "pt": "O que o VWAP mostra dentro do dia?",
        },
        {
            "ru": [
                "Среднюю цену с весом объёма от открытия дня/сессии",
                "Точный сигнал без стопа",
                "Только депозит кошелька",
                "Сторону 4h структуры",
            ],
            "en": [
                "Volume-weighted average price from the day/session open",
                "A perfect no-stop signal",
                "Only the wallet deposit size",
                "4h structure direction",
            ],
            "pt": [
                "Preço médio ponderado pelo volume desde a abertura do dia/sessão",
                "Um sinal perfeito sem stop",
                "Só o tamanho do depósito",
                "A direção da estrutura no 4h",
            ],
        },
        0,
        {
            "ru": "VWAP — «справедливая» средняя дня. Выше VWAP в ап-дне часто long bias.",
            "en": "VWAP is the day’s “fair” average. Above VWAP on an up day often implies long bias.",
            "pt": "VWAP é a média “justa” do dia. Acima do VWAP num dia de alta costuma dar bias long.",
        },
    ),
    q(
        56,
        3,
        "Beginner",
        {
            "ru": "Зачем размечают Asia high / Asia low?",
            "en": "Why mark Asia high / Asia low?",
            "pt": "Para que marcar Asia high / Asia low?",
        },
        {
            "ru": [
                "Чтобы заменить stop-loss на азию",
                "Чтобы торговать только по funding Asia",
                "Чтобы запретить London сессию",
                "Это края диапазона Азии; часто играют в London как уровни",
            ],
            "en": [
                "To replace stop-loss with Asia",
                "To trade only Asian funding",
                "To ban the London session",
                "They are Asia’s range edges; London often reacts to them as levels",
            ],
            "pt": [
                "Para trocar o stop pela Ásia",
                "Para operar só funding da Ásia",
                "Para banir a sessão de Londres",
                "São as bordas do range asiático; Londres costuma reagir a eles como níveis",
            ],
        },
        3,
        {
            "ru": "Asia H/L + PDH/PDL + VWAP — карта дня, не отдельная «магическая» стратегия.",
            "en": "Asia H/L + PDH/PDL + VWAP are a day map, not a magic standalone strategy.",
            "pt": "Asia H/L + PDH/PDL + VWAP são o mapa do dia, não uma estratégia mágica sozinha.",
        },
    ),
    # ── 57 funding OI RS vs BTC ───────────────────────────────────────────
    q(
        57,
        1,
        "Beginner",
        {
            "ru": "Что обычно значит цена ↑ вместе с ростом OI?",
            "en": "What does price ↑ with rising OI usually mean?",
            "pt": "O que costuma significar preço ↑ com OI a subir?",
        },
        {
            "ru": [
                "Сила тренда: новые позиции по направлению хода",
                "Обязательный разворот вниз завтра",
                "Что funding всегда 0",
                "Что стоп можно убрать",
            ],
            "en": [
                "Trend strength: new positions in the move’s direction",
                "A guaranteed reversal down tomorrow",
                "That funding is always 0",
                "That you can remove the stop",
            ],
            "pt": [
                "Força da tendência: novas posições no sentido do movimento",
                "Reversão garantida para baixo amanhã",
                "Que funding é sempre 0",
                "Que se pode tirar o stop",
            ],
        },
        0,
        {
            "ru": "Price↑ + OI↑ — подпитка тренда. Price↑ + OI↓ чаще хрупкий ход / short cover.",
            "en": "Price↑ + OI↑ feeds the trend. Price↑ + OI↓ is often fragile / short cover.",
            "pt": "Preço↑ + OI↑ alimenta a tendência. Preço↑ + OI↓ costuma ser frágil / short cover.",
        },
    ),
    q(
        57,
        2,
        "Beginner",
        {
            "ru": "Чем опасен долго сильно плюсовой funding?",
            "en": "Why is persistently strongly positive funding risky?",
            "pt": "Por que funding fortemente positivo por muito tempo é arriscado?",
        },
        {
            "ru": [
                "Потому что шорты платят меньше спреда",
                "Потому что биржа отключает график",
                "Лонги перегреты → выше риск даун-сквиза",
                "Потому что OI всегда падает",
            ],
            "en": [
                "Because shorts pay less spread",
                "Because the exchange disables the chart",
                "Longs are overcrowded → higher down-squeeze risk",
                "Because OI always falls",
            ],
            "pt": [
                "Porque shorts pagam menos spread",
                "Porque a exchange desliga o gráfico",
                "Longs overcrowded → maior risco de squeeze para baixo",
                "Porque OI sempre cai",
            ],
        },
        2,
        {
            "ru": "Экстремальный funding — не приказ разворота, а повод резать размер / ужесточать план.",
            "en": "Extreme funding isn’t a must-reverse order — cut size / tighten the plan.",
            "pt": "Funding extremo não é ordem de reversão — corte tamanho / aperte o plano.",
        },
    ),
    q(
        57,
        3,
        "Beginner",
        {
            "ru": "Что такое RS альта к BTC для сигнала?",
            "en": "What is alt RS vs BTC for a signal?",
            "pt": "O que é RS do alt vs BTC para um sinal?",
        },
        {
            "ru": [
                "Случайный хештег в чате",
                "Только цена funding BTC",
                "Только объём спота ETH",
                "Сильнее/слабее BTC в % на том же окне",
            ],
            "en": [
                "A random chat hashtag",
                "Only BTC funding price",
                "Only ETH spot volume",
                "Stronger/weaker than BTC in % on the same window",
            ],
            "pt": [
                "Uma hashtag aleatória no chat",
                "Só o preço de funding do BTC",
                "Só o volume spot do ETH",
                "Mais forte/fraco que o BTC em % na mesma janela",
            ],
        },
        3,
        {
            "ru": "RS = relative strength: альт растёт больше / падает меньше BTC → сильнее для лонга.",
            "en": "RS = relative strength: alt up more / down less than BTC → stronger for longs.",
            "pt": "RS = relative strength: alt sobe mais / cai menos que BTC → mais forte para long.",
        },
    ),
    # ── 58 signal format in chat ──────────────────────────────────────────
    q(
        58,
        1,
        "Beginner",
        {
            "ru": "Какой минимум полей у сигнала в чат?",
            "en": "What is the minimum field set for a chat signal?",
            "pt": "Qual é o conjunto mínimo de campos de um sinal no chat?",
        },
        {
            "ru": [
                "Только emoji и тикер",
                "Pair TF Side | Setup | Entry Stop Target | Risk% | Invalidation",
                "Только «long soon» без чисел",
                "Только скрин без стопа",
            ],
            "en": [
                "Only emoji and a ticker",
                "Pair TF Side | Setup | Entry Stop Target | Risk% | Invalidation",
                "Only “long soon” with no numbers",
                "Only a screenshot with no stop",
            ],
            "pt": [
                "Só emoji e o ticker",
                "Pair TF Side | Setup | Entry Stop Target | Risk% | Invalidation",
                "Só “long soon” sem números",
                "Só um print sem stop",
            ],
        },
        1,
        {
            "ru": "Без стопа или invalidation это мнение, не сигнал. Шаблон обязателен.",
            "en": "Without a stop or invalidation it’s an opinion, not a signal. Template is required.",
            "pt": "Sem stop ou invalidação é opinião, não sinal. O template é obrigatório.",
        },
    ),
    q(
        58,
        2,
        "Beginner",
        {
            "ru": "Зачем в журнале теги A / B / C?",
            "en": "Why use A / B / C tags in the journal?",
            "pt": "Para que servem as tags A / B / C no diário?",
        },
        {
            "ru": [
                "Чтобы сравнивать качество сетапов, а не «ощущения»",
                "Чтобы скрыть убытки от себя",
                "Чтобы ставить тег после PnL",
                "Чтобы заменить стоп на тег",
            ],
            "en": [
                "To compare setup quality, not “feelings”",
                "To hide losses from yourself",
                "To tag only after PnL",
                "To replace the stop with a tag",
            ],
            "pt": [
                "Para comparar qualidade dos setups, não “feelings”",
                "Para esconder perdas de si mesmo",
                "Para marcar só depois do PnL",
                "Para trocar o stop por uma tag",
            ],
        },
        0,
        {
            "ru": "A/B/C ставят до результата. Плюс по C не делает сетап уровнем A.",
            "en": "Tag A/B/C before the result. A profit on a C does not make the setup an A.",
            "pt": "Marque A/B/C antes do resultado. Lucro num C não transforma o setup em A.",
        },
    ),
    q(
        58,
        3,
        "Beginner",
        {
            "ru": "Что такое тег C в журнале урока?",
            "en": "What is a C tag in this lesson’s journal?",
            "pt": "O que é a tag C no diário desta aula?",
        },
        {
            "ru": [
                "Идеальный чеклист со всеми фильтрами",
                "Норм сетап с одной мелкой дырой",
                "FOMO / «похолож» — пропуск или микроразмер, не гордость",
                "Сигнал без пары и ТФ",
            ],
            "en": [
                "A perfect checklist with every filter",
                "A decent setup with one small hole",
                "FOMO / “looks like it” — skip or micro size, not a badge of honor",
                "A signal with no pair and no TF",
            ],
            "pt": [
                "Checklist perfeito com todos os filtros",
                "Setup ok com um furo pequeno",
                "FOMO / “parece” — pular ou micro tamanho, não orgulho",
                "Sinal sem par e sem TF",
            ],
        },
        2,
        {
            "ru": "C — осознанный слабый вход/FOMO. В журнал честно: пропуск или микроразмер.",
            "en": "C = knowingly weak / FOMO. Log it honestly: skip or micro size.",
            "pt": "C = entrada fraca / FOMO consciente. Registre com honestidade: pular ou micro.",
        },
    ),
]


def main() -> None:
    raw = json.loads(DATA.read_text(encoding="utf-8"))
    if not isinstance(raw, list):
        raise SystemExit(f"Expected list in {DATA}, got {type(raw).__name__}")

    before = len(raw)
    kept = [item for item in raw if not (48 <= int(item.get("lessonId", -1)) <= 58)]
    removed = before - len(kept)
    out = kept + NEW
    DATA.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(f"Was: {before}")
    if removed:
        print(f"Removed existing 48–58 quizzes: {removed}")
    print(f"Appended: {len(NEW)}")
    print(f"Final quiz count: {len(out)}")
    ids = sorted({int(x["lessonId"]) for x in out})
    print(f"Lesson id range: {ids[0]}–{ids[-1]} ({len(ids)} lessons)")
    ci = [x["correctIndex"] for x in NEW]
    print(f"New correctIndex mix: {sorted(set(ci))} counts={[ci.count(i) for i in range(4)]}")


if __name__ == "__main__":
    main()
