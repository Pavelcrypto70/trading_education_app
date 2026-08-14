#!/usr/bin/env python3
"""QA audit of linear curriculum + generated lesson JSON vs player assumptions."""
from __future__ import annotations

import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RU = json.loads((ROOT / "tools" / "_linear_ru.json").read_text(encoding="utf-8"))
LESSONS = json.loads((ROOT / "assets" / "data" / "lessons_ru.json").read_text(encoding="utf-8"))

KIT_CHART = {
    "support": "candlestick",
    "resist": "candlestick",
    "flip": "candlestick",
    "hhhl": "candlestick",
    "lhll": "candlestick",
    "channel": "channel",
    "fakeout": "candlestick",
    "impulse": "candlestick",
    "triDown": "descending_triangle",
    "triUp": "ascending_triangle",
    "triSym": "symmetric_triangle",
    "wedge": "candlestick",
    "double": "candlestick",
    "flag": "candlestick",
    "hs": "head_shoulders",
    "ihs": "inverse_head_shoulders",
    "fib": "fibonacci",
    "range": "candlestick",
    "dump": "risk_reward",
    "news": "candlestick",
    "chop": "candlestick",
    "equity": "risk_reward",
}

# Old chart setup map in lesson_chart_setups.dart (by lesson id) — known mismatched titles
OLD_CHART_LABELS = {
    1: "Spot vs futures + liquidation 10x",
    2: "Limit entry + Stop/Take + R:R",
    3: "Amplitude / ATR",
}

EARLY_TERMS = [
    ("ликвидац", "liquidation"),
    ("плеч", "leverage"),
    ("стоп", "stop"),
    ("тейк", "take"),
    ("шорт", "short"),
    ("лонг", "long"),
    ("фьючерс", "futures"),
    ("funding", "funding"),
]


def approx_player_steps(les: dict) -> dict:
    secs = les["sections"]
    types = Counter(s["type"] for s in secs)
    # Player: intro + mandatory visual
    steps = 2
    # topic blocks: each text -> 1 step (short lines), each chart block -> 1
    steps += types.get("text", 0)
    steps += types.get("chart", 0)
    # interactive: practice, homework, journal each become a step
    for t in ("practice", "homework", "journal", "market_note", "calculator", "link"):
        steps += types.get(t, 0)
    # example, bullets, tip always if present
    steps += 1 if types.get("example") else 0
    steps += 1 if types.get("bullets") else 0
    steps += 1 if types.get("tip") else 0
    # case studies step always added (may be empty widget)
    steps += 1
    # checkpoint
    steps += 1
    return {"approx_steps": steps, "types": dict(types)}


def main() -> None:
    print(f"SOURCE={len(RU)} GENERATED={len(LESSONS)}")
    print("KITS", dict(Counter(x["kit"] for x in RU)))

    # Phrase step problem
    print("\n=== PHRASE CARD (lines[8]) ===")
    for x in RU[:5]:
        print(f"L{x['id']}: {x['lines'][8]!r}")

    # Early concept + wrong chart kits
    print("\n=== MODULE 1 CONCEPT / CHART RISK ===")
    for x in RU[:7]:
        blob = " ".join(x["lines"] + [x["grandma"], x["bad1"], x["bad2"]]).lower()
        hits = [name for term, name in EARLY_TERMS if term in blob]
        chart = KIT_CHART.get(x["kit"], "?")
        old = OLD_CHART_LABELS.get(x["id"], "")
        print(
            f"L{x['id']:02} title={x['title']!r} kit={x['kit']} -> {chart} "
            f"text_hits={hits} old_setup={old}"
        )

    # Repetition: near-identical structure
    print("\n=== STRUCTURAL SAMENESS ===")
    line8 = Counter(x["lines"][8] for x in RU)
    print("unique lines[8]:", len(line8), "top:", line8.most_common(3))
    do_patterns = Counter((x["doLive"], x["doDead"], x["doSoon"]) for x in RU)
    print("unique do triples:", len(do_patterns))

    # Duplicate grandma / takeaway similarity (prefix)
    prefixes = Counter(x["grandma"][:40] for x in RU)
    dups = [(p, c) for p, c in prefixes.items() if c > 1]
    print("grandma prefix dups:", len(dups))

    # Cross-lesson same line reuse
    all_lines = []
    for x in RU:
        for i, line in enumerate(x["lines"]):
            all_lines.append((line.strip().lower(), x["id"], i))
    by_text = {}
    for text, lid, idx in all_lines:
        by_text.setdefault(text, []).append((lid, idx))
    reused = {t: v for t, v in by_text.items() if len(v) > 1 and len(t) > 20}
    print("reused lines across lessons (>20 chars):", len(reused))
    for t, v in list(reused.items())[:8]:
        print(" ", v, "->", t[:70])

    # When stop/take first appear in text
    print("\n=== FIRST APPEARANCE OF KEY TERMS ===")
    for term, name in EARLY_TERMS:
        first = None
        for x in RU:
            blob = " ".join(x["lines"] + [x["grandma"]]).lower()
            if term in blob:
                first = (x["id"], x["title"])
                break
        print(f"  {name}: first L{first}")

    # Per-lesson generated quality flags
    print("\n=== PER-LESSON FLAGS ===")
    src_by_id = {x["id"]: x for x in RU}
    for les in LESSONS:
        n = les["id"]
        src = src_by_id[n]
        est = approx_player_steps(les)
        flags = []
        # empty phrase choice
        if any(s.get("body") == "Выбери одну фразу." for s in les["sections"]):
            flags.append("EMPTY_PHRASE_PROMPT")
        # tip has no options
        tip = next((s for s in les["sections"] if s["type"] == "tip"), None)
        if tip and not tip.get("items"):
            flags.append("TIP_NO_CHOICES")
        # practice items look like choices but UI is numbered list
        practice = next((s for s in les["sections"] if s["type"] == "practice"), None)
        if practice and practice.get("items") and len(practice["items"]) == 3:
            flags.append("PRACTICE_ITEMS_NOT_CHOICE_UI")
        # wrong chart kits for early lessons
        if n <= 3 and src["kit"] in ("equity", "dump", "hhhl"):
            if KIT_CHART.get(src["kit"]) == "risk_reward":
                flags.append("CHART_RISK_REWARD_TOO_EARLY")
            if n == 1:
                flags.append("OLD_SETUP_LIQUIDATION")
            if n == 2:
                flags.append("OLD_SETUP_STOP_TAKE")
        # 10 micro beats
        if est["types"].get("heading", 0) >= 10:
            flags.append("TEN_MICRO_BEATS")
        if est["approx_steps"] >= 20:
            flags.append(f"TOO_MANY_STEPS:{est['approx_steps']}")
        # chart spam in JSON
        if est["types"].get("chart", 0) >= 3:
            flags.append("CHART_X3_IN_JSON")
        print(f"L{n:02} {src['title'][:32]:32} steps~{est['approx_steps']:2} {','.join(flags) or 'ok'}")

    # Severity summary
    print("\n=== SUMMARY COUNTS ===")
    all_flags = Counter()
    for les in LESSONS:
        n = les["id"]
        src = src_by_id[n]
        est = approx_player_steps(les)
        if any(s.get("body") == "Выбери одну фразу." for s in les["sections"]):
            all_flags["EMPTY_PHRASE_PROMPT"] += 1
        if est["approx_steps"] >= 20:
            all_flags["TOO_MANY_STEPS"] += 1
        if est["types"].get("chart", 0) >= 3:
            all_flags["CHART_X3"] += 1
        if est["types"].get("heading", 0) >= 10:
            all_flags["TEN_MICRO_BEATS"] += 1
        if n <= 3 and KIT_CHART.get(src["kit"]) == "risk_reward":
            all_flags["EARLY_RISK_REWARD_KIT"] += 1
    for k, v in all_flags.most_common():
        print(f"  {k}: {v}/{len(LESSONS)}")


if __name__ == "__main__":
    main()
