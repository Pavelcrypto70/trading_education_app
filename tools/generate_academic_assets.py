#!/usr/bin/env python3
"""Generate syllabus, glossary, lesson quizzes, module tests, rubrics, case studies."""

from __future__ import annotations

import json
import random
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets" / "data"

SYLLABUS_VERSION = "2026.1"

MODULES = [
    {
        "id": "intro",
        "order": 1,
        "title": {"ru": "Введение", "en": "Introduction", "pt": "Introdução"},
        "hours": 8,
        "ects": 1.0,
        "lessonIds": [1, 2, 3, 4, 5, 6, 7],
        "outcomes": {
            "ru": [
                "Различать спот, фьючерс и типы ордеров",
                "Читать свечной график и уровни поддержки/сопротивления",
                "Формулировать план сделки до клика",
            ],
            "en": [
                "Distinguish spot, futures and order types",
                "Read candle charts and support/resistance",
                "Formulate a trade plan before clicking",
            ],
            "pt": [
                "Distinguir spot, futuros e tipos de ordem",
                "Ler gráficos de velas e suporte/resistência",
                "Formular plano de trade antes do clique",
            ],
        },
    },
    {
        "id": "chart",
        "order": 2,
        "title": {"ru": "График и структура", "en": "Chart & Structure", "pt": "Gráfico e Estrutura"},
        "hours": 10,
        "ects": 1.5,
        "lessonIds": [13, 14, 15, 16, 17, 22, 26, 42, 45],
        "outcomes": {
            "ru": ["Определять тренд, канал и сессии", "Использовать MA и объём", "Строить уровни дня"],
            "en": ["Identify trend, channel and sessions", "Use MA and volume", "Build daily levels"],
            "pt": ["Identificar tendência, canal e sessões", "Usar MA e volume", "Construir níveis do dia"],
        },
    },
    {
        "id": "patterns",
        "order": 3,
        "title": {"ru": "Паттерны", "en": "Patterns", "pt": "Padrões"},
        "hours": 8,
        "ects": 1.0,
        "lessonIds": [8, 9, 19, 43, 46, 47],
        "outcomes": {
            "ru": ["Распознавать треугольники и разворотные формации", "Считать цель по измеренному движению"],
            "en": ["Recognize triangles and reversal patterns", "Calculate measured move targets"],
            "pt": ["Reconhecer triângulos e reversões", "Calcular alvos por movimento medido"],
        },
    },
    {
        "id": "strategy",
        "order": 4,
        "title": {"ru": "Стратегии", "en": "Strategies", "pt": "Estratégias"},
        "hours": 8,
        "ects": 1.0,
        "lessonIds": [10, 21, 23, 30, 32],
        "outcomes": {
            "ru": ["Торговать пробой и откат по плану", "Вести марафон разметки без FOMO"],
            "en": ["Trade breakouts and pullbacks with a plan", "Run markup marathons without FOMO"],
            "pt": ["Operar rompimentos e pullbacks com plano", "Maratonas de marcação sem FOMO"],
        },
    },
    {
        "id": "market",
        "order": 5,
        "title": {"ru": "Рынок и макро", "en": "Market & Macro", "pt": "Mercado e Macro"},
        "hours": 8,
        "ects": 1.0,
        "lessonIds": [11, 12, 20, 24, 25, 27, 34, 44],
        "outcomes": {
            "ru": ["Учитывать BTC.D и новости", "Оценивать листинг/делистинг и альтсезон"],
            "en": ["Account for BTC.D and news", "Assess listing/delisting and altseason"],
            "pt": ["Considerar BTC.D e notícias", "Avaliar listing/delisting e altseason"],
        },
    },
    {
        "id": "risk",
        "order": 6,
        "title": {"ru": "Риск и этика", "en": "Risk & Ethics", "pt": "Risco e Ética"},
        "hours": 10,
        "ects": 1.5,
        "lessonIds": [7, 18, 28, 31, 35, 36, 39, 40],
        "outcomes": {
            "ru": [
                "Рассчитывать риск 0.5–1% на сделку",
                "Распознавать скамы и ошибки плеча",
                "Соблюдать этику и безопасность API/переводов",
            ],
            "en": [
                "Calculate 0.5–1% risk per trade",
                "Recognize scams and leverage mistakes",
                "Follow ethics and API/transfer safety",
            ],
            "pt": [
                "Calcular risco 0,5–1% por trade",
                "Reconhecer golpes e erros de alavancagem",
                "Seguir ética e segurança de API/transferências",
            ],
        },
    },
    {
        "id": "practice",
        "order": 7,
        "title": {"ru": "Практика и аттестация", "en": "Practice & Assessment", "pt": "Prática e Avaliação"},
        "hours": 6,
        "ects": 1.0,
        "lessonIds": [29, 33, 37, 38, 41],
        "outcomes": {
            "ru": ["Вести журнал по сетапам", "Сдавать домашние задания с разметкой"],
            "en": ["Keep a setup-based journal", "Submit homework with chart markup"],
            "pt": ["Manter diário por setups", "Entregar tarefas com marcação no gráfico"],
        },
    },
]

GLOSSARY = [
    {"term": {"ru": "Спот", "en": "Spot", "pt": "Spot"}, "def": {"ru": "Покупка актива на баланс без плеча.", "en": "Buying the asset on balance without leverage.", "pt": "Compra do ativo no saldo sem alavancagem."}},
    {"term": {"ru": "Фьючерс", "en": "Futures", "pt": "Futuros"}, "def": {"ru": "Контракт с плечом, возможен шорт и ликвидация.", "en": "Leveraged contract; shorting and liquidation possible.", "pt": "Contrato alavancado; short e liquidação possíveis."}},
    {"term": {"ru": "Поддержка", "en": "Support", "pt": "Suporte"}, "def": {"ru": "Уровень, где цена неоднократно отскакивала вверх.", "en": "Level where price bounced up repeatedly.", "pt": "Nível onde o preço repicou várias vezes."}},
    {"term": {"ru": "Сопротивление", "en": "Resistance", "pt": "Resistência"}, "def": {"ru": "Уровень, где продавцы останавливали рост.", "en": "Level where sellers halted the rise.", "pt": "Nível onde vendedores pararam a alta."}},
    {"term": {"ru": "Стоп-лосс", "en": "Stop-loss", "pt": "Stop-loss"}, "def": {"ru": "Цена выхода при неверном сценарии.", "en": "Exit price when the scenario is wrong.", "pt": "Preço de saída quando o cenário falha."}},
    {"term": {"ru": "R:R", "en": "R:R", "pt": "R:R"}, "def": {"ru": "Соотношение риска к прибыли (1:2 = риск $1, цель $2).", "en": "Risk-to-reward ratio (1:2 = risk $1, target $2).", "pt": "Relação risco/recompensa (1:2 = risco $1, alvo $2)."}},
    {"term": {"ru": "Funding", "en": "Funding", "pt": "Funding"}, "def": {"ru": "Периодический платёж между лонгами и шортами на perpetual.", "en": "Periodic payment between longs and shorts on perpetuals.", "pt": "Pagamento periódico entre longs e shorts em perpetual."}},
    {"term": {"ru": "BTC.D", "en": "BTC.D", "pt": "BTC.D"}, "def": {"ru": "Доля капитализации BTC — индикатор ротации в альты.", "en": "BTC market cap dominance — alt rotation indicator.", "pt": "Dominância de cap. do BTC — indicador de rotação para alts."}},
    {"term": {"ru": "Ликвидация", "en": "Liquidation", "pt": "Liquidação"}, "def": {"ru": "Принудительное закрытие позиции при нехватке маржи.", "en": "Forced position close when margin is insufficient.", "pt": "Fechamento forçado quando a margem acaba."}},
    {"term": {"ru": "Ложный пробой", "en": "False breakout", "pt": "Falso rompimento"}, "def": {"ru": "Выход за уровень с быстрым возвратом — часто ловушка.", "en": "Brief break beyond level then reversal — often a trap.", "pt": "Rompimento breve e retorno — muitas vezes armadilha."}},
    {"term": {"ru": "HH / HL", "en": "HH / HL", "pt": "HH / HL"}, "def": {"ru": "Higher High / Higher Low — признаки восходящего тренда.", "en": "Higher High / Higher Low — uptrend structure.", "pt": "Higher High / Higher Low — estrutura de alta."}},
    {"term": {"ru": "LH / LL", "en": "LH / LL", "pt": "LH / LL"}, "def": {"ru": "Lower High / Lower Low — нисходящий тренд.", "en": "Lower High / Lower Low — downtrend structure.", "pt": "Lower High / Lower Low — estrutura de baixa."}},
    {"term": {"ru": "ATR", "en": "ATR", "pt": "ATR"}, "def": {"ru": "Средний истинный диапазон — мера волатильности.", "en": "Average True Range — volatility measure.", "pt": "Average True Range — medida de volatilidade."}},
    {"term": {"ru": "Спуфинг", "en": "Spoofing", "pt": "Spoofing"}, "def": {"ru": "Крупные фейковые заявки в стакане для манипуляции.", "en": "Large fake orders in the book to manipulate price.", "pt": "Ordens falsas grandes no book para manipular."}},
    {"term": {"ru": "FOMO", "en": "FOMO", "pt": "FOMO"}, "def": {"ru": "Страх упустить — эмоциональный вход без плана.", "en": "Fear of missing out — emotional entry without a plan.", "pt": "Medo de perder — entrada emocional sem plano."}},
]

CASE_STUDIES = [
    {
        "id": "covid-crash-2020",
        "date": "2020-03-12",
        "title": {"ru": "Чёрный четверг: обвал BTC −50% за день", "en": "Black Thursday: BTC −50% in one day", "pt": "Quinta-feira Negra: BTC −50% em um dia"},
        "summary": {
            "ru": "Паника по COVID-19 вызвала каскад ликвидаций. Урок: стоп обязателен, плечо опасно в шоке.",
            "en": "COVID panic caused liquidation cascade. Lesson: stops mandatory; leverage dangerous in shocks.",
            "pt": "Pânico COVID causou cascata de liquidações. Lição: stops obrigatórios; alavancagem perigosa.",
        },
        "lessonIds": [7, 18, 27],
        "source": {"title": "CoinDesk Archive", "url": "https://www.coindesk.com/markets/2020/03/12/"},
    },
    {
        "id": "ftx-2022",
        "date": "2022-11-08",
        "title": {"ru": "Крах FTX: контрагентский риск", "en": "FTX collapse: counterparty risk", "pt": "Colapso FTX: risco de contraparte"},
        "summary": {
            "ru": "Средства на бирже без due diligence — потеря депозита. Урок: self-custody и диверсификация площадок.",
            "en": "Exchange funds without due diligence — total loss. Lesson: self-custody and venue diversification.",
            "pt": "Fundos na exchange sem due diligence — perda total. Lição: autocustódia e diversificação.",
        },
        "lessonIds": [35, 36, 7],
        "source": {"title": "U.S. SEC FTX Case", "url": "https://www.sec.gov/news/press-release/2022-219"},
    },
    {
        "id": "luna-2022",
        "date": "2022-05-09",
        "title": {"ru": "Крах LUNA/UST: риск алгоритмического стейбла", "en": "LUNA/UST crash: algo-stable risk", "pt": "Crash LUNA/UST: risco de stable algorítmico"},
        "summary": {
            "ru": "Плечо + вера в «безрисковый» доход → −99% за 48ч. Урок: размер позиции и скепсис к хайпу.",
            "en": "Leverage + belief in 'risk-free' yield → −99% in 48h. Lesson: position sizing and hype skepticism.",
            "pt": "Alavancagem + crença em rendimento 'sem risco' → −99% em 48h. Lição: tamanho e ceticismo.",
        },
        "lessonIds": [20, 31, 11],
        "source": {"title": "Investopedia LUNA Explainer", "url": "https://www.investopedia.com/terra-luna-cryptocurrency-5217396"},
    },
]

HOMEWORK_RUBRIC = {
    "version": SYLLABUS_VERSION,
    "maxScore": 10,
    "criteria": [
        {"id": "setup", "weight": 3, "ru": "Сетап назван и соответствует уроку", "en": "Setup named and matches lesson", "pt": "Setup nomeado e alinhado à lição"},
        {"id": "levels", "weight": 3, "ru": "Вход, стоп и цель размечены на скрине", "en": "Entry, stop, target marked on screenshot", "pt": "Entrada, stop e alvo marcados no print"},
        {"id": "risk", "weight": 2, "ru": "Риск в % депозита указан", "en": "Risk % of deposit stated", "pt": "Risco % do depósito informado"},
        {"id": "reflection", "weight": 2, "ru": "1–2 предложения: почему сетап валиден", "en": "1–2 sentences: why setup is valid", "pt": "1–2 frases: por que o setup é válido"},
    ],
    "passScore": 7,
    "telegram": {
        "enabled": True,
        "chatUrl": "https://t.me/trade_master_homework",
        "instructions": {
            "ru": "Нажмите «Сдать домашку» — откроется Telegram-чат. Прикрепите скрин TradingView и текст: Урок N, сетап, вход/стоп/цель, риск %.",
            "en": "Tap 'Submit homework' to open our Telegram chat. Attach TradingView screenshot + text: Lesson N, setup, entry/stop/target, risk %.",
            "pt": "Toque em 'Enviar tarefa' para abrir o Telegram. Anexe print do TradingView + texto: Lição N, setup, entrada/stop/alvo, risco %.",
        },
    },
}


def _wrong_options(correct: str, pool: list[str], n: int = 3) -> list[str]:
    opts = [correct]
    for item in pool:
        if item != correct and item not in opts and len(item) > 12:
            opts.append(item[:120])
        if len(opts) >= n + 1:
            break
    while len(opts) < n + 1:
        opts.append("—")
    random.shuffle(opts)
    return opts


def generate_lesson_quizzes(lessons_by_lang: dict[str, list[dict]]) -> list[dict]:
    rng = random.Random(42)
    ru_lessons = {l["id"]: l for l in lessons_by_lang["ru"]}
    questions = []

    for lesson in lessons_by_lang["ru"]:
        lid = lesson["id"]
        bullets = []
        for s in lesson.get("sections", []):
            if s.get("type") == "bullets" and s.get("items"):
                bullets.extend(s["items"])

        q_specs = [
            ("takeaway", lesson["takeaway"]),
            ("outcome", lesson["outcome"]),
        ]
        if bullets:
            q_specs.append(("bullet", bullets[0]))

        for qi, (kind, correct_ru) in enumerate(q_specs[:3]):
            options_ru = _wrong_options(correct_ru, bullets if kind == "bullet" else [l["takeaway"] for l in lessons_by_lang["ru"]])
            correct_idx = options_ru.index(correct_ru if correct_ru in options_ru else options_ru[0])

            q_loc = {}
            o_loc = {}
            e_loc = {}
            for lang in ("ru", "en", "pt"):
                les = next(x for x in lessons_by_lang[lang] if x["id"] == lid)
                if kind == "takeaway":
                    correct = les["takeaway"]
                    pool = [l["takeaway"] for l in lessons_by_lang[lang] if l["id"] != lid]
                elif kind == "outcome":
                    correct = les["outcome"]
                    pool = [l["outcome"] for l in lessons_by_lang[lang] if l["id"] != lid]
                else:
                    bl = [s for s in les.get("sections", []) if s.get("type") == "bullets"]
                    correct = bl[0]["items"][0] if bl and bl[0].get("items") else les["takeaway"]
                    pool = bl[0]["items"][1:] if bl and bl[0].get("items") else [les["takeaway"]]

                opts = _wrong_options(correct, pool + [les["takeaway"], les["outcome"]])
                ci = opts.index(correct if correct in opts else opts[0])
                if lang == "ru":
                    correct_idx = ci
                labels = {"ru": "Какой главный вывод урока", "en": "Main takeaway of lesson", "pt": "Conclusão principal da lição"}
                q_loc[lang] = f"{labels[lang]} {lid}?"
                o_loc[lang] = opts
                e_loc[lang] = les["takeaway"]

            questions.append({
                "lessonId": lid,
                "id": f"L{lid}-Q{qi + 1}",
                "difficulty": lesson.get("difficulty", "Beginner"),
                "question": q_loc,
                "options": o_loc,
                "correctIndex": correct_idx,
                "explanation": e_loc,
            })
        rng.shuffle(questions[-3:])

    return questions


def generate_module_quizzes() -> list[dict]:
    tests = []
    for mod in MODULES:
        tests.append({
            "moduleId": mod["id"],
            "title": mod["title"],
            "lessonIds": mod["lessonIds"],
            "passPercent": 70,
            "questionCount": min(10, len(mod["lessonIds"]) * 2),
            "timeMin": 15,
        })
    return tests


def build_syllabus() -> dict:
    total_hours = sum(m["hours"] for m in MODULES)
    return {
        "version": SYLLABUS_VERSION,
        "course": {
            "ru": "Криптотрейдинг: от основ к системной практике",
            "en": "Crypto Trading: Foundations to Systematic Practice",
            "pt": "Cripto Trading: Fundamentos à Prática Sistemática",
        },
        "institution": {
            "ru": "Trade Master University Track",
            "en": "Trade Master University Track",
            "pt": "Trade Master University Track",
        },
        "totalHours": total_hours,
        "totalEcts": round(sum(m["ects"] for m in MODULES), 1),
        "totalLessons": 47,
        "finalAssessment": {
            "ru": "Итоговый тест по 7 модулям (70%+) + 3 принятые домашние работы в Telegram",
            "en": "Final module tests (70%+) + 3 accepted homework submissions in Telegram",
            "pt": "Testes finais por módulo (70%+) + 3 tarefas aceitas no Telegram",
        },
        "modules": MODULES,
        "ethicsLessonIds": [7, 18, 28, 35, 36, 39, 40],
        "caseStudyIds": [c["id"] for c in CASE_STUDIES],
    }


def main():
    lessons_by_lang = {
        lang: json.loads((ASSETS / f"lessons_{lang}.json").read_text(encoding="utf-8"))
        for lang in ("ru", "en", "pt")
        if (ASSETS / f"lessons_{lang}.json").exists()
    }

    (ASSETS / "syllabus.json").write_text(
        json.dumps(build_syllabus(), ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (ASSETS / "glossary.json").write_text(
        json.dumps(GLOSSARY, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (ASSETS / "case_studies.json").write_text(
        json.dumps(CASE_STUDIES, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (ASSETS / "homework_rubrics.json").write_text(
        json.dumps(HOMEWORK_RUBRIC, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    (ASSETS / "module_quizzes.json").write_text(
        json.dumps(generate_module_quizzes(), ensure_ascii=False, indent=2), encoding="utf-8"
    )

    if "ru" in lessons_by_lang:
        quizzes = generate_lesson_quizzes(lessons_by_lang)
        (ASSETS / "lesson_quizzes.json").write_text(
            json.dumps(quizzes, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        print(f"lesson_quizzes.json: {len(quizzes)} questions")

    print("Academic assets generated.")


if __name__ == "__main__":
    main()
