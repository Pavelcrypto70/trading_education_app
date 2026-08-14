#!/usr/bin/env python3
"""
Bulk upgrade all lessons per course rules:
- Remove TradingView sections and mentions
- Replace TV with thematic chart sections
- Add pattern diagrams for figure lessons
- Add homework section (thesis → Telegram)
- Enrich short text cards
- Add extra thematic charts
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"

# YouTube video_id per app lesson (author's channel)
VIDEO_BY_LESSON: dict[int, tuple[str, str] | None] = {
    1: ("2ki-YF1heeE", "Вводное. Часть 1"),
    2: ("YFruWV883tc", "Вводное. Часть 2"),
    3: ("ula4cspom20", "Амплитуда движения"),
    4: ("zogDIOFPkbQ", "Поддержка по лоям"),
    5: ("Ay8uPZi4MtI", "Стакан. Подробно"),
    6: ("bAnyY1W5D6o", "Быстрый и медленный рынок"),
    7: ("_g0vbQGM-aw", "Основные ошибки новичков"),
    8: ("ImGfY5iCS8M", "Нисходящий треугольник"),
    9: ("-eTem4vDuJo", "Восходящий треугольник"),
    10: ("sTSMRvji9gc", "Торговая стратегия для импульсов"),
    11: ("dEjY21Kz6b4", "Делист"),
    12: ("_lfU_N-YAPo", "Листинг"),
    13: ("qRGuHWrEc0k", "Каналы"),
    14: ("f2xFqvZrS58", "Восходящий тренд"),
    15: ("VrdXd0IxZ40", "Нисходящий тренд"),
    16: ("VMsiQJsrqcg", "Индикаторы"),
    17: ("jBy-ilJ5840", "Заседание ФРС"),
    18: ("iovKK79fWp4", "Риск на сделку"),
    19: ("pUA5zXgb9j4", "Симметричный треугольник"),
    20: ("sTSMRvji9gc", "Momentum и мем-токены"),  # related market video
    21: ("BwXPhoOjAF0", "Удержание позиции"),  # averaging/hold context
    22: ("Ay8uPZi4MtI", "Order flow и стакан"),
    23: ("pBKgw1fxius", "Идея точки входа"),
    24: ("25Qye437HrI", "Циклы рынка"),
    25: ("4pduRC-Qq-c", "Альтсезон"),
    26: ("LVBZAquaEEg", "График BTC внутри дня"),
    27: ("jZt_1rtC1kY", "Пролив BTC"),
    28: ("hAmCeOyxzZQ", "Возврат после минуса"),
    29: ("subkGDpVtc0", "Марафон. Разворотные движения"),
    30: ("fZxYYxdQt7Q", "Марафон. День 3"),
    31: ("BwXPhoOjAF0", "Усреднение"),
    32: ("E3oBl8Gv9kE", "Смена тренда"),
    33: ("TnFoQZ6huao", "Анализ своей торговли"),
    34: ("jBy-ilJ5840", "Заседание ФРС"),
    35: ("g3F7KRRy-3Q", "Скам-чаты"),
    36: ("3AD3pPSD0q4", "Перевод между биржами"),
    37: ("U03tEQwoR5o", "Соединение по API"),
    38: ("TDDVLZbKp5g", "Торговля на работе или дома"),
    39: ("4BhZ3qhP9DA", "Фьючерсы. Основа"),
    40: ("3cSmtJ927KU", "Основные ошибки. Часть 2"),
    41: ("LJ5lhWw1zT4", "Приложения которые помогут"),
    42: ("fXFJCUi-y6w", "Утро трейдера"),
    43: ("x39IbgQdBsc", "Уровни Фибоначчи"),
    44: ("c94L-1ybV4k", "Airdrop и Pre market"),
    45: ("Xucv_tRFqtY", "Свечи. Часть 2"),
    46: ("yuReGzavfuo", "Голова и плечи. Часть 1"),  # same series
    47: ("yuReGzavfuo", "Голова и плечи. Часть 2"),
}

# Primary pattern chart per lesson (inserted if missing)
PATTERN_CHART: dict[int, tuple[str, str, str]] = {
    8: ("pattern_desc_triangle", "Нисходящий треугольник — схема", "Горизонтальная поддержка + падающие максимумы. Пробой вниз — цель по высоте фигуры."),
    9: ("pattern_asc_triangle", "Восходящий треугольник — схема", "Горизонтальное сопротивление + растущие минимумы. Пробой вверх — измерение по высоте."),
    13: ("pattern_channel", "Ценовой канал — схема", "Параллельные линии поддержки и сопротивления. Торговля от границ канала."),
    19: ("pattern_sym_triangle", "Симметричный треугольник — схема", "Сходящиеся максимумы и минимумы. Ждём пробой с объёмом — направление решает рынок."),
    43: ("pattern_fibonacci", "Коррекция Фибоначчи — схема", "Уровни 38.2%, 50%, 61.8% в тренде. Зона входа — не угадывание дна."),
    46: ("pattern_head_shoulders", "Голова и плечи — схема", "Три вершины: левое плечо, голова, правое плечо. Линия шеи — ключевой уровень."),
    47: ("pattern_head_shoulders", "Пробой линии шеи", "Закрепление ниже шеи + ретест. Цель — расстояние от головы до шеи."),
}

# Default chart when replacing TradingView
DEFAULT_CHART_BY_LESSON: dict[int, str] = {
    3: "momentum",
    4: "support_resistance",
    5: "order_flow",
    6: "session_timeline",
    7: "risk_reward",
    10: "breakout",
    11: "downtrend",
    12: "uptrend",
    14: "uptrend",
    15: "downtrend",
    16: "momentum",
    17: "session_timeline",
    18: "risk_reward",
    20: "momentum",
    21: "pullback",
    22: "order_flow",
    23: "risk_reward",
    24: "structure",
    25: "correlation",
    26: "uptrend",
    27: "breakout",
    28: "risk_reward",
    29: "reversal",
    30: "structure",
    31: "pullback",
    32: "structure",
    33: "structure",
    34: "session_timeline",
    35: "risk_reward",
    36: "order_flow",
    37: "order_flow",
    38: "session_timeline",
    39: "risk_reward",
    40: "risk_reward",
    41: "order_flow",
    42: "session_timeline",
    44: "breakout",
    45: "candlestick",
}

TV_PATTERNS = [
    (re.compile(r"https?://[^\s]*tradingview[^\s]*", re.I), ""),
    (re.compile(r"TradingView", re.I), "терминал или график биржи"),
    (re.compile(r"BINANCE:([A-Z0-9]+)", re.I), r"\1"),
    (re.compile(r"откройте?\s+график\s+в\s+[^\n.]+", re.I), "откройте график в терминале"),
    (re.compile(r"Разбор в TradingView", re.I), "Разбор на графике"),
    (re.compile(r"скрин\s+TradingView", re.I), "запись в журнале"),
    (re.compile(r"tradingview\.com/support", re.I), "binance.com/en/support"),
    (re.compile(r"без TradingView", re.I), "в терминале"),
]

HOMEWORK_RU = {
    "type": "homework",
    "title": "Домашка: тезисы урока",
    "body": "Тезисно напишите в Telegram-чат домашек: что прошли в этом уроке и как вы это поняли своими словами. Без скринов — только текст.",
    "items": [
        "3–5 ключевых тем урока (тезисами)",
        "Как вы это поняли — своими словами",
        "Что осталось непонятным (можно «пока ничего»)",
    ],
}

HOMEWORK_EN = {
    "type": "homework",
    "title": "Homework: lesson summary",
    "body": "Briefly write in the Telegram homework chat: what you covered in this lesson and how you understood it. Text only — no screenshots.",
    "items": [
        "3–5 key topics (bullet points)",
        "How you understood it — in your words",
        "What is still unclear (or 'nothing yet')",
    ],
}

HOMEWORK_PT = {
    "type": "homework",
    "title": "Tarefa: resumo da lição",
    "body": "Escreva no Telegram: o que viu na lição e como entendeu. Só texto.",
    "items": [
        "3–5 tópicos-chave",
        "Como entendeu — com suas palavras",
        "O que ainda não ficou claro",
    ],
}


def clean_text(text: str) -> str:
    if not text:
        return text
    out = text
    for pat, repl in TV_PATTERNS:
        out = pat.sub(repl, out)
    out = re.sub(r"\n{3,}", "\n\n", out)
    out = re.sub(r"  +", " ", out)
    return out.strip()


def enrich_text(body: str, title: str) -> str:
    """Expand very short cards to premium multi-sentence depth."""
    if not body or len(body) >= 280:
        return clean_text(body)
    base = clean_text(body)
    extra = (
        f"\n\nНа практике это значит: примените идею «{title}» на графике в терминале или на бирже — "
        "без сделки, только разметка. Запишите в журнал одну мысль: что изменилось в понимании после урока."
    )
    return base + extra


def tv_to_chart(section: dict, lesson_id: int) -> dict:
    chart_type = DEFAULT_CHART_BY_LESSON.get(lesson_id, "structure")
    if lesson_id in PATTERN_CHART:
        chart_type = PATTERN_CHART[lesson_id][0]
    title = section.get("title", "График урока")
    title = clean_text(title).replace("TradingView", "график").replace("tradingview", "график")
    if "TradingView" in (section.get("title") or ""):
        title = "Разбор на графике"
    return {
        "type": "chart",
        "title": title,
        "chartType": chart_type,
        "caption": "Разметьте в терминале Take или на графике биржи — без внешних сервисов.",
    }


def ensure_pattern_chart(sections: list, lesson_id: int) -> list:
    if lesson_id not in PATTERN_CHART:
        return sections
    ctype, title, caption = PATTERN_CHART[lesson_id]
    has = any(s.get("type") == "chart" and ctype in (s.get("chartType") or "") for s in sections)
    if has:
        return sections
    # Insert after first heading+text
    out = []
    inserted = False
    for i, s in enumerate(sections):
        out.append(s)
        if not inserted and s.get("type") == "text":
            out.append({"type": "chart", "title": title, "chartType": ctype, "caption": caption})
            inserted = True
    if not inserted:
        out.insert(0, {"type": "chart", "title": title, "chartType": ctype, "caption": caption})
    return out


def add_extra_charts(sections: list, lesson_id: int) -> list:
    """Add thematic chart if lesson has fewer than 2 charts."""
    chart_count = sum(1 for s in sections if s.get("type") == "chart")
    if chart_count >= 2 or lesson_id in (1, 2):
        return sections
    extra_type = DEFAULT_CHART_BY_LESSON.get(lesson_id, "structure")
    if lesson_id in PATTERN_CHART:
        extra_type = "risk_reward"
    # find first text block after heading
    out = []
    added = False
    for s in sections:
        out.append(s)
        if not added and s.get("type") == "heading" and lesson_id not in PATTERN_CHART:
            out.append({
                "type": "chart",
                "title": "Визуализация темы",
                "chartType": extra_type,
                "caption": "Схема помогает увидеть структуру до первой сделки.",
            })
            added = True
    return out if added else sections


def dedupe_homework(sections: list) -> list:
    seen = False
    out = []
    for s in sections:
        if s.get("type") == "homework":
            if seen:
                continue
            seen = True
        out.append(s)
    return out


def ensure_homework(sections: list, lang: str) -> list:
    if any(s.get("type") == "homework" for s in sections):
        return sections
    hw = {"ru": HOMEWORK_RU, "en": HOMEWORK_EN, "pt": HOMEWORK_PT}[lang]
    out = []
    for s in sections:
        if s.get("type") == "tip":
            out.append(hw)
        out.append(s)
    if hw not in out:
        out.append(hw)
    return out


def process_sections(sections: list, lesson_id: int, lang: str) -> list:
    out = []
    for s in sections:
        st = s.get("type")
        if st == "tradingview":
            out.append(tv_to_chart(s, lesson_id))
            continue
        if st == "references":
            refs = s.get("references") or []
            refs = [r for r in refs if "tradingview" not in (r.get("url") or "").lower()]
            refs = [{**r, "title": clean_text(r.get("title", ""))} for r in refs]
            if refs:
                out.append({**s, "references": refs})
            continue
        sec = dict(s)
        if sec.get("body"):
            title = sec.get("title") or ""
            sec["body"] = enrich_text(sec["body"], title) if st == "text" else clean_text(sec["body"])
        if sec.get("title"):
            sec["title"] = clean_text(sec["title"])
        out.append(sec)

    out = ensure_pattern_chart(out, lesson_id)
    out = add_extra_charts(out, lesson_id)
    out = ensure_homework(out, lang)
    return dedupe_homework(out)


def process_lesson(lesson: dict, lang: str) -> dict:
    lid = lesson["id"]
    if lid in (1, 2):
        # Lessons 1-2 hand-crafted — only clean TV mentions + homework
        sections = lesson["sections"]
        sections = [s for s in sections if s.get("type") != "tradingview"]
        for s in sections:
            if s.get("body"):
                s["body"] = clean_text(s["body"])
        if not any(s.get("type") == "homework" for s in sections):
            sections = ensure_homework(sections, lang)
        lesson["sections"] = dedupe_homework(sections)
        if lesson.get("content"):
            lesson["content"] = clean_text(lesson["content"])
        if lesson.get("takeaway"):
            lesson["takeaway"] = clean_text(lesson["takeaway"])
        return lesson

    lesson["sections"] = process_sections(lesson["sections"], lid, lang)
    for key in ("content", "takeaway", "outcome", "subtitle"):
        if lesson.get(key):
            lesson[key] = clean_text(lesson[key])
    if lesson.get("learningOutcomes"):
        lesson["learningOutcomes"] = [clean_text(x) for x in lesson["learningOutcomes"]]
    return lesson


def patch_file(filename: str, lang: str) -> None:
    path = DATA / filename
    with open(path, encoding="utf-8") as f:
        lessons = json.load(f)
    lessons = [process_lesson(L, lang) for L in lessons]
    with open(path, "w", encoding="utf-8") as f:
        json.dump(lessons, f, ensure_ascii=False, indent=2)
    print(f"Patched {path} ({lang})")


def patch_quizzes() -> None:
    path = DATA / "lesson_quizzes.json"
    with open(path, encoding="utf-8") as f:
        quizzes = json.load(f)

    def clean_obj(obj):
        if isinstance(obj, str):
            return clean_text(obj)
        if isinstance(obj, dict):
            return {k: clean_obj(v) for k, v in obj.items()}
        if isinstance(obj, list):
            return [clean_obj(x) for x in obj]
        return obj

    quizzes = clean_obj(quizzes)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(quizzes, f, ensure_ascii=False, indent=2)
    print(f"Patched {path}")


def main() -> None:
    patch_file("lessons_ru.json", "ru")
    patch_file("lessons_en.json", "en")
    patch_file("lessons_pt.json", "pt")
    patch_quizzes()
    print("Done. Run tool/generate_lesson_media.py next.")


if __name__ == "__main__":
    main()
