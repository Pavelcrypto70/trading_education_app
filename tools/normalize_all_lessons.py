#!/usr/bin/env python3
"""
Normalize ALL lessons:
- Trim bloated text (keep clear core, no essay dumps)
- After every heading+text topic, insert a chart example
- Fix lesson 1 (no charts) and odd chart types
Skip rewriting lesson 5 body (already curated), but keep its charts.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"

# Preferred didactic chart per lesson id
CHART_BY_ID: dict[int, str] = {
    1: "market_balance",
    2: "order_book",
    3: "momentum",
    4: "support_resistance",
    5: "order_book",
    6: "session_timeline",
    7: "risk_reward",
    8: "pattern_desc_triangle",
    9: "pattern_asc_triangle",
    10: "breakout",
    11: "downtrend",
    12: "uptrend",
    13: "pattern_channel",
    14: "uptrend",
    15: "downtrend",
    16: "momentum",
    17: "session_timeline",
    18: "risk_reward",
    19: "pattern_sym_triangle",
    20: "momentum",
    21: "pullback",
    22: "order_book",
    23: "risk_reward",
    24: "structure",
    25: "correlation",
    26: "session_timeline",
    27: "reversal",
    28: "risk_reward",
    29: "structure",
    30: "risk_reward",
    31: "risk_reward",
    32: "reversal",
    33: "structure",
    34: "session_timeline",
    35: "risk_reward",
    36: "order_flow",
    37: "risk_reward",
    38: "session_timeline",
    39: "risk_reward",
    40: "risk_reward",
    41: "order_book",
    42: "session_timeline",
    43: "pattern_fibonacci",
    44: "breakout",
    45: "candlestick",
    46: "pattern_head_shoulders",
    47: "pattern_head_shoulders_inv",
}

CAPTION = {
    "ru": "Пример по теме этого блока — смотрите фигуру, потом текст.",
    "en": "Visual example for this topic — look first, then read.",
    "pt": "Exemplo visual deste tópico — veja a figura e depois leia.",
}

EXAMPLE_TITLE = {
    "ru": "Пример",
    "en": "Example",
    "pt": "Exemplo",
}

KEEP_TYPES = {
    "practice",
    "example",
    "bullets",
    "tip",
    "homework",
    "journal",
    "market_note",
    "references",
    "calculator",
    "link",
    "quiz",
}


def collapse_paras(text: str) -> list[str]:
    parts = [p.strip() for p in re.split(r"\n\s*\n", text) if p.strip()]
    out, seen = [], set()
    for p in parts:
        key = re.sub(r"\s+", " ", p).strip().lower()
        if key in seen:
            continue
        seen.add(key)
        out.append(p)
    return out


def trim_body(text: str, max_chars: int = 700, max_paras: int = 2) -> str:
    paras = collapse_paras(text)
    if not paras:
        return ""
    kept: list[str] = []
    total = 0
    for p in paras:
        if len(kept) >= max_paras:
            break
        # keep first para even if long, but hard-cut sentences
        if total + len(p) > max_chars and kept:
            break
        if len(p) > max_chars:
            p = _soft_cut(p, max_chars)
        kept.append(p)
        total += len(p)
    return "\n\n".join(kept)


def _soft_cut(text: str, max_chars: int) -> str:
    if len(text) <= max_chars:
        return text
    cut = text[: max_chars - 1]
    # prefer sentence end
    for sep in (". ", "! ", "? ", "… "):
        idx = cut.rfind(sep)
        if idx > max_chars * 0.45:
            return cut[: idx + 1].strip()
    idx = cut.rfind(" ")
    if idx > 0:
        return cut[:idx].rstrip() + "…"
    return cut.rstrip() + "…"


def primary_chart(lesson: dict) -> str:
    lid = int(lesson["id"])
    if lid in CHART_BY_ID:
        return CHART_BY_ID[lid]
    for s in lesson.get("sections", []):
        if s.get("type") == "chart" and s.get("chartType"):
            return s["chartType"]
    return "candlestick"


def normalize_lesson(lesson: dict, lang: str) -> None:
    lid = int(lesson["id"])
    # Lesson 5 already curated with multiple order-book scenarios — only light trim leftovers.
    if lid == 5:
        return

    chart_type = primary_chart(lesson)
    sections = lesson.get("sections", [])
    out: list[dict] = []
    i = 0
    n = len(sections)
    charts_added = 0

    while i < n:
        s = sections[i]
        st = s.get("type")

        if st == "heading":
            out.append(s)
            heading = s.get("title") or lesson.get("title") or "Topic"
            if i + 1 < n and sections[i + 1].get("type") == "text":
                body = trim_body(sections[i + 1].get("body") or "")
                out.append({"type": "text", "body": body})
                i += 2
                # Prefer an existing chart right after text; else inject.
                if i < n and sections[i].get("type") == "chart":
                    chart = dict(sections[i])
                    chart["chartType"] = chart.get("chartType") or chart_type
                    # For pattern lessons keep specialized chart types if present
                    if lid in (8, 9, 19, 43, 46, 47) and sections[i].get("chartType"):
                        chart["chartType"] = sections[i]["chartType"]
                    if not chart.get("title"):
                        chart["title"] = f"{EXAMPLE_TITLE[lang]}: {heading}"
                    if not chart.get("caption"):
                        chart["caption"] = CAPTION[lang]
                    out.append(chart)
                    charts_added += 1
                    i += 1
                else:
                    out.append(
                        {
                            "type": "chart",
                            "title": f"{EXAMPLE_TITLE[lang]}: {heading}",
                            "chartType": chart_type,
                            "caption": CAPTION[lang],
                        }
                    )
                    charts_added += 1
            else:
                i += 1
            continue

        if st == "text":
            # orphan text without heading
            body = trim_body(s.get("body") or "")
            out.append({"type": "text", "body": body})
            out.append(
                {
                    "type": "chart",
                    "title": f"{EXAMPLE_TITLE[lang]}: {lesson.get('title', '')}",
                    "chartType": chart_type,
                    "caption": CAPTION[lang],
                }
            )
            charts_added += 1
            i += 1
            continue

        if st == "chart":
            # Drop trailing/orphan charts; topics already got an example.
            # Keep at most one remaining specialized chart if none added yet.
            if charts_added == 0:
                chart = dict(s)
                chart["chartType"] = chart.get("chartType") or chart_type
                out.append(chart)
                charts_added += 1
            i += 1
            continue

        if st in KEEP_TYPES:
            # trim long bodies on keep types too
            ns = dict(s)
            if isinstance(ns.get("body"), str) and len(ns["body"]) > 900:
                ns["body"] = trim_body(ns["body"], max_chars=500, max_paras=2)
            out.append(ns)
            i += 1
            continue

        out.append(s)
        i += 1

    # Guarantee at least one chart in the lesson
    if charts_added == 0:
        out.insert(
            0,
            {
                "type": "chart",
                "title": f"{EXAMPLE_TITLE[lang]}: {lesson.get('title', '')}",
                "chartType": chart_type,
                "caption": CAPTION[lang],
            },
        )

    lesson["sections"] = out


def process_file(path: Path, lang: str) -> tuple[int, int]:
    lessons = json.loads(path.read_text(encoding="utf-8"))
    before = sum(len(json.dumps(l.get("sections", []), ensure_ascii=False)) for l in lessons)
    for les in lessons:
        normalize_lesson(les, lang)
    after = sum(len(json.dumps(l.get("sections", []), ensure_ascii=False)) for l in lessons)
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return before, after


def audit(path: Path) -> None:
    lessons = json.loads(path.read_text(encoding="utf-8"))
    print(f"=== {path.name} ===")
    for les in lessons:
        texts = [s for s in les.get("sections", []) if s.get("type") == "text"]
        charts = [s for s in les.get("sections", []) if s.get("type") == "chart"]
        chars = sum(len(s.get("body") or "") for s in texts)
        print(
            f"L{les['id']:02d} texts={len(texts):2d} charts={len(charts):2d} "
            f"chars={chars:5d} title={(les.get('title') or '')[:40]}"
        )


def main() -> None:
    files = {
        "ru": DATA / "lessons_ru.json",
        "en": DATA / "lessons_en.json",
        "pt": DATA / "lessons_pt.json",
    }
    for lang, path in files.items():
        b, a = process_file(path, lang)
        print(f"{path.name}: {b} -> {a} section-json chars ({(1 - a / b) * 100:.0f}% smaller)")
        audit(path)


if __name__ == "__main__":
    main()
