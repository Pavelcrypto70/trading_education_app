#!/usr/bin/env python3
"""Add lessons 48–58, inject «Сигнал в чат» into 1–47, update syllabus + module quizzes."""

from __future__ import annotations

import copy
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"
sys.path.insert(0, str(Path(__file__).resolve().parent))

from new_lessons_quality_a import RU as RU_A  # noqa: E402
from new_lessons_quality_b import RU as RU_B  # noqa: E402
from signal_chat_templates import signal_section, SIGNALS  # noqa: E402
from translate_blocks import translate_text, _load_cache, _save_cache  # noqa: E402

REFS = [
    {
        "title": "Technical Analysis of the Financial Markets",
        "author": "John J. Murphy",
        "year": 1999,
        "url": "https://www.investopedia.com/terms/t/technicalanalysis.asp",
        "type": "book",
    },
    {
        "title": "TradingView Charting Basics",
        "author": "TradingView",
        "year": 2024,
        "url": "https://www.tradingview.com/support/",
        "type": "documentation",
    },
]

OUTCOMES = {
    "ru": [
        "Объяснить идею урока своими словами",
        "Собрать сигнал в чат: пара, ТФ, вход, стоп, цель, отмена",
        "Записать в журнал риск % и тег сетапа",
    ],
    "en": [
        "Explain the lesson idea in your own words",
        "Post a chat signal: pair, TF, entry, stop, target, invalidation",
        "Log risk % and setup tag in the journal",
    ],
    "pt": [
        "Explicar a ideia da aula com suas palavras",
        "Postar sinal no chat: par, TF, entrada, stop, alvo, invalidação",
        "Registrar risco % e tag do setup no diário",
    ],
}

STRUCT_HW = {"en": "Signal to chat", "pt": "Sinal no chat"}


def log(msg: str) -> None:
    print(msg, flush=True)


def build_lesson(lid: int, data: dict) -> dict:
    return {
        "id": lid,
        "module": data["module"],
        "title": data["title"],
        "subtitle": data["subtitle"],
        "difficulty": data.get("difficulty", "Intermediate"),
        "durationMin": data.get("durationMin", 22),
        "outcome": data["outcome"],
        "content": data["content"],
        "takeaway": data["takeaway"],
        "prerequisites": data.get("prerequisites", []),
        "learningOutcomes": list(OUTCOMES["ru"]),
        "references": copy.deepcopy(REFS),
        "sections": copy.deepcopy(data["sections"]),
    }


def inject_signal(lesson: dict) -> None:
    lid = int(lesson["id"])
    if lid not in SIGNALS:
        return
    secs = lesson.get("sections") or []
    # Remove old signal homework if present
    secs = [s for s in secs if not (s.get("type") == "homework" and s.get("title") == "Сигнал в чат")]
    # Prefer placing before final tip if tip is last
    sig = signal_section(lid)
    if secs and secs[-1].get("type") == "tip":
        secs.insert(-1, sig)
    else:
        secs.append(sig)
    lesson["sections"] = secs
    lesson["learningOutcomes"] = list(OUTCOMES["ru"])


def translate_section(sec: dict, lang: str, cache: dict) -> dict:
    ns = copy.deepcopy(sec)
    if ns.get("type") == "homework" and ns.get("title") in ("Сигнал в чат", "Signal to chat", "Sinal no chat"):
        ns["title"] = STRUCT_HW[lang]
    elif isinstance(ns.get("title"), str):
        title_map = {
            "en": {
                "Практика": "Practice",
                "Журнал": "Journal",
                "Домашка": "Homework",
                "Совет": "Tip",
                "Запомнить": "Remember",
                "Разбор с цифрами": "Worked example",
            },
            "pt": {
                "Практика": "Prática",
                "Журнал": "Diário",
                "Домашка": "Tarefa",
                "Совет": "Dica",
                "Запомнить": "Lembre",
                "Разбор с цифрами": "Exemplo com números",
            },
        }
        ns["title"] = title_map[lang].get(ns["title"], translate_text(ns["title"], lang, cache))
    for key in ("body", "caption"):
        if isinstance(ns.get(key), str) and ns[key].strip():
            ns[key] = translate_text(ns[key], lang, cache)
    if isinstance(ns.get("items"), list):
        ns["items"] = [
            translate_text(it, lang, cache) if isinstance(it, str) else it for it in ns["items"]
        ]
    if ns.get("type") == "journal":
        ns["body"] = {"en": "Log:", "pt": "Registre:"}.get(lang, ns.get("body", ""))
    return ns


def translate_lesson(ru_lesson: dict, lang: str, cache: dict) -> dict:
    out = copy.deepcopy(ru_lesson)
    for key in ("title", "subtitle", "outcome", "content", "takeaway", "module"):
        if isinstance(out.get(key), str) and out[key].strip():
            out[key] = translate_text(out[key], lang, cache)
    out["learningOutcomes"] = list(OUTCOMES[lang])
    out["sections"] = [translate_section(s, lang, cache) for s in ru_lesson["sections"]]
    return out


def update_syllabus() -> None:
    path = DATA / "syllabus.json"
    syl = json.loads(path.read_text(encoding="utf-8"))
    syl["totalLessons"] = 58
    syl["totalHours"] = 72
    syl["version"] = "2026.2"
    modules = {m["id"]: m for m in syl["modules"]}
    modules["intro"]["lessonIds"] = [1, 2, 3, 4, 48, 5, 6, 7]
    modules["chart"]["lessonIds"] = [13, 14, 15, 49, 50, 16, 17, 22, 26, 56, 42, 45]
    modules["patterns"]["lessonIds"] = [8, 9, 19, 55, 53, 54, 43, 46, 47]
    modules["strategy"]["lessonIds"] = [10, 21, 51, 23, 52, 30, 32]
    modules["market"]["lessonIds"] = [11, 12, 20, 24, 25, 27, 57, 34, 44]
    modules["practice"]["lessonIds"] = [29, 33, 58, 37, 38, 41]
    modules["chart"]["hours"] = 14
    modules["patterns"]["hours"] = 12
    modules["strategy"]["hours"] = 12
    modules["market"]["hours"] = 10
    modules["practice"]["hours"] = 8
    modules["intro"]["outcomes"]["ru"] = [
        "Различать спот, фьючерс и ордера",
        "Строить поддержку и сопротивление с flip",
        "Собрать первый сигнал в чат с риском%",
    ]
    modules["chart"]["outcomes"]["ru"] = [
        "Читать тренд, MTF, ложный пробой",
        "Использовать сессии, VWAP и уровни дня",
        "Фильтровать вход по старшему ТФ",
    ]
    modules["patterns"]["outcomes"]["ru"] = [
        "Отличать треугольники, клинья, флаги, двойные вершины",
        "Считать measured move и писать сигнал отмены",
    ]
    modules["strategy"]["outcomes"]["ru"] = [
        "Вести сделку: partial, BE, trail",
        "Отказывать сетапу по фильтру «не торгую»",
    ]
    modules["market"]["outcomes"]["ru"] = [
        "Учитывать BTC.D, funding и OI",
        "Сравнивать силу альта с BTC в сигнале",
    ]
    modules["practice"]["outcomes"]["ru"] = [
        "Писать сигнал как трейдер: сетап, числа, invalidation",
        "Тегировать журнал и разбирать сделки",
    ]
    path.write_text(json.dumps(syl, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    log("syllabus updated → 58 lessons")


def update_module_quizzes() -> None:
    path = DATA / "module_quizzes.json"
    mq = json.loads(path.read_text(encoding="utf-8"))
    syl = json.loads((DATA / "syllabus.json").read_text(encoding="utf-8"))
    by = {m["id"]: m["lessonIds"] for m in syl["modules"]}
    for mod in mq:
        mid = mod["moduleId"]
        if mid in by:
            mod["lessonIds"] = by[mid]
    path.write_text(json.dumps(mq, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    log("module_quizzes lessonIds synced")


def patch_l10n() -> None:
    path = ROOT / "lib" / "l10n" / "app_localizations.dart"
    text = path.read_text(encoding="utf-8")
    text = text.replace("all 47 lessons", "all 58 lessons")
    text = text.replace("все 47 уроков", "все 58 уроков")
    text = text.replace("as 47 lições", "as 58 lições")
    text = text.replace("All 47 lessons unlocked", "All 58 lessons unlocked")
    text = text.replace("Все 47 уроков", "Все 58 уроков")
    text = text.replace("Todas as 47 lições", "Todas as 58 lições")
    path.write_text(text, encoding="utf-8")
    log("l10n 47→58")


def main() -> None:
    new_map = {**RU_A, **RU_B}
    assert set(new_map) == set(range(48, 59)), set(new_map)

    # --- RU ---
    ru_path = DATA / "lessons_ru.json"
    ru = json.loads(ru_path.read_text(encoding="utf-8"))
    by_id = {int(l["id"]): l for l in ru}
    for lid in range(1, 48):
        inject_signal(by_id[lid])
    for lid, data in new_map.items():
        by_id[lid] = build_lesson(lid, data)
    ru_out = [by_id[i] for i in sorted(by_id)]
    assert len(ru_out) == 58
    ru_path.write_text(json.dumps(ru_out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    log(f"RU: {len(ru_out)} lessons")

    update_syllabus()
    update_module_quizzes()
    patch_l10n()

    # --- EN / PT ---
    cache = _load_cache()
    try:
        for lang, fname in (("en", "lessons_en.json"), ("pt", "lessons_pt.json")):
            log(f"=== {lang.upper()} ===")
            path = DATA / fname
            existing = json.loads(path.read_text(encoding="utf-8"))
            ex_by = {int(l["id"]): l for l in existing}
            out = []
            for lid in range(1, 59):
                if lid <= 47:
                    base = copy.deepcopy(ex_by[lid])
                    # Translate / replace signal block from RU
                    ru_les = by_id[lid]
                    # Keep EN/PT body, but sync signal homework from translated RU signal
                    base_secs = [s for s in base.get("sections", []) if not (
                        s.get("type") == "homework" and str(s.get("title", "")).lower() in (
                            "сигнал в чат", "signal to chat", "sinal no chat", "домашка: тезисы фигуры",
                            "homework: pattern thesis", "homework: thesis",
                        ) and "сигнал" in str(s.get("title", "")).lower()
                    )]
                    # remove any existing signal-titled hw
                    base_secs = [
                        s for s in base_secs
                        if not (
                            s.get("type") == "homework"
                            and (
                                "Сигнал" in str(s.get("title", ""))
                                or "Signal" in str(s.get("title", ""))
                                or "Sinal" in str(s.get("title", ""))
                            )
                        )
                    ]
                    sig_ru = next(
                        s for s in ru_les["sections"]
                        if s.get("type") == "homework" and s.get("title") == "Сигнал в чат"
                    )
                    sig = translate_section(sig_ru, lang, cache)
                    if base_secs and base_secs[-1].get("type") == "tip":
                        base_secs.insert(-1, sig)
                    else:
                        base_secs.append(sig)
                    base["sections"] = base_secs
                    base["learningOutcomes"] = list(OUTCOMES[lang])
                    out.append(base)
                else:
                    log(f"  translate L{lid}")
                    out.append(translate_lesson(by_id[lid], lang, cache))
                if lid % 10 == 0:
                    _save_cache(cache)
            path.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            log(f"{lang.upper()} done: {len(out)}")
    finally:
        _save_cache(cache)
        log(f"cache={len(cache)}")


if __name__ == "__main__":
    main()
