#!/usr/bin/env python3
"""Hard QA: lessons, choices, captions, charts, links, resume-related fields."""
from __future__ import annotations

import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RU = json.loads((ROOT / "tools" / "_linear_ru.json").read_text(encoding="utf-8"))
LES = {lang: json.loads((ROOT / "assets" / "data" / f"lessons_{lang}.json").read_text(encoding="utf-8"))
       for lang in ("ru", "en", "pt", "es")}
QUIZ = json.loads((ROOT / "assets" / "data" / "lesson_quizzes.json").read_text(encoding="utf-8"))
SCREEN = (ROOT / "lib" / "screens" / "lesson_screen.dart").read_text(encoding="utf-8")
PROGRESS = (ROOT / "lib" / "services" / "progress_service.dart").read_text(encoding="utf-8")
HW = (ROOT / "lib" / "services" / "homework_service.dart").read_text(encoding="utf-8")
MEDIA = (ROOT / "lib" / "data" / "lesson_media.dart").read_text(encoding="utf-8")


def norm(s: str) -> str:
    return re.sub(r"\s+", " ", (s or "").strip().lower())


def main() -> None:
    issues: list[tuple[str, str, str]] = []

    # Feature checks
    if "saveLessonStep" not in PROGRESS or "getLessonStep" not in PROGRESS:
        issues.append(("P0", "NO_RESUME_API", "ProgressService missing step save/get"))
    if "_onStepChanged" not in SCREEN or "saveLessonStep" not in SCREEN:
        issues.append(("P0", "NO_RESUME_WIRE", "lesson_screen not saving step"))
    if "LessonMedia.forLesson" in SCREEN or "_VideoStep" in SCREEN:
        issues.append(("P0", "YOUTUBE_IN_PLAYER", "video still in player"))
    if "=> null" not in MEDIA.split("forLesson")[1][:80]:
        issues.append(("P0", "MEDIA_ENABLED", "forLesson not disabled"))

    # Links
    for les in LES["ru"]:
        for s in les["sections"]:
            if s["type"] == "homework":
                url = s.get("url") or ""
                if "t.me/Desk_Club" not in url:
                    issues.append(("P0", "BAD_HW_URL", f"L{les['id']} {url!r}"))
    if "Desk_Club" not in HW and "homeworkTelegramUrl" not in HW:
        issues.append(("P1", "HW_SERVICE_URL", "homework_service may lack telegram url"))

    # Per lesson
    for les in LES["ru"]:
        n = les["id"]
        outs = les.get("learningOutcomes") or []
        if len(outs) != len({norm(o) for o in outs}):
            issues.append(("P0", "INTRO_DUP", f"L{n}"))
        take = les["takeaway"]
        if any(norm(take) == norm(o) for o in outs):
            issues.append(("P1", "TAKEAWAY_IN_BULLETS", f"L{n}"))

        texts = [s for s in les["sections"] if s["type"] == "text"]
        choices = [s for s in les["sections"] if s["type"] == "choice"]
        if len(texts) != 6:
            issues.append(("P1", "TEXT_COUNT", f"L{n} texts={len(texts)}"))
        if len(choices) != 2:
            issues.append(("P0", "CHOICE_COUNT", f"L{n} {len(choices)}"))

        # Pattern lessons: every card uses pattern chartType
        if 28 <= n <= 36:
            kit_chart = None
            for s in les["sections"]:
                if s.get("chartType") and s["type"] == "text":
                    kit_chart = s["chartType"]
                    break
            if kit_chart and kit_chart != "candlestick":
                for s in les["sections"]:
                    if s["type"] in ("text", "choice", "homework", "practice", "journal"):
                        if s.get("chartType") != kit_chart:
                            issues.append(("P0", "PATTERN_NOT_EVERY_CARD", f"L{n} {s['type']} {s.get('chartType')}"))

        # Captions present
        for s in les["sections"]:
            if s["type"] in ("text", "choice", "homework", "practice", "journal"):
                if not s.get("caption"):
                    issues.append(("P1", "NO_CAPTION", f"L{n} {s['type']}"))
                if s.get("cardIndex") is None:
                    issues.append(("P0", "NO_CARD_INDEX", f"L{n} {s['type']}"))

        # Unique card indexes on chart sections
        idxs = [s["cardIndex"] for s in les["sections"] if s.get("cardIndex") is not None and s["type"] != "heading"]
        if len(idxs) != len(set(idxs)):
            issues.append(("P0", "DUP_CARD_INDEX", f"L{n}"))

        # Shuffle: correct not always 0
        for c in choices:
            ci = c.get("correctIndex")
            if ci is None:
                issues.append(("P0", "NO_CORRECT", f"L{n}"))
            items = c.get("items") or []
            if ci is not None and not (0 <= ci < len(items)):
                issues.append(("P0", "CORRECT_OOB", f"L{n}"))

        # Empty / dead
        for s in texts:
            body = (s.get("body") or "").strip()
            if not body:
                issues.append(("P0", "EMPTY_TEXT", f"L{n}"))
            if "Выбери одну фразу" in body:
                issues.append(("P0", "DEAD_PHRASE", f"L{n}"))

        # Sub != first text
        first = texts[0]["body"].split("\n\n")[0] if texts else ""
        if norm(les["subtitle"]) == norm(first):
            issues.append(("P1", "SUB_EQ_FIRST", f"L{n}"))

    # Quiz shuffle: how often correctIndex==0
    q1 = [q for q in QUIZ if q["id"].endswith("Q1")]
    q2 = [q for q in QUIZ if q["id"].endswith("Q2")]
    z1 = sum(1 for q in q1 if q["correctIndex"] == 0)
    z2 = sum(1 for q in q2 if q["correctIndex"] == 0)
    print(f"Quiz Q1 correctIndex==0: {z1}/{len(q1)}  Q2: {z2}/{len(q2)}")
    if z1 == len(q1):
        issues.append(("P0", "QUIZ_NOT_SHUFFLED", "all Q1 correctIndex 0"))
    if z2 == len(q2):
        issues.append(("P0", "QUIZ_DO_NOT_SHUFFLED", "all Q2 correctIndex 0"))

    # Choice shuffle in lessons
    phrase_zero = 0
    for les in LES["ru"]:
        ch = next(s for s in les["sections"] if s["type"] == "choice")
        if ch.get("correctIndex") == 0:
            phrase_zero += 1
    print(f"Lesson phrase choice correctIndex==0: {phrase_zero}/58")
    if phrase_zero == 58:
        issues.append(("P0", "PHRASE_NOT_SHUFFLED", "all phrase correct at 0"))

    # Cross-lang section parity
    for i in range(58):
        counts = {lang: len(LES[lang][i]["sections"]) for lang in LES}
        if len(set(counts.values())) != 1:
            issues.append(("P0", "LANG_SECTION_MISMATCH", f"L{i+1} {counts}"))

    # Sample L1 / L28
    l1 = LES["ru"][0]
    l28 = LES["ru"][27]
    print("L1 phrase correctIndex", next(s["correctIndex"] for s in l1["sections"] if s["type"]=="choice"))
    print("L1 captions sample", [s.get("caption") for s in l1["sections"] if s.get("caption")][:4])
    print("L28 chartTypes", sorted({s.get("chartType") for s in l28["sections"] if s.get("chartType")}))

    print("\n=== ISSUES", len(issues), dict(Counter(i[0] for i in issues)), "===")
    for code, c in Counter(i[1] for i in issues).most_common():
        print(f"  {code}: {c}  e.g. {[i[2] for i in issues if i[1]==code][:2]}")

    backlog = [
        "Slimmer intro (drop concept visual or merge with first topic)",
        "Shorter homework item list",
        "Case studies: wire selectively or delete",
        "Native review EN/PT/ES UI outcome strings",
        "Mid-lesson resume toast «Продолжить с шага N»",
        "Accessibility: larger tap targets on choice",
        "Offline indicator when Telegram homework fails",
        "Analytics events for choice wrong/right",
    ]
    print("\n=== REMAINING IMPROVEMENTS ===")
    for i, b in enumerate(backlog, 1):
        print(f"  {i}. {b}")

    (ROOT / "tools" / "_qa_hard_report.json").write_text(
        json.dumps({"issues": issues, "backlog": backlog, "quiz_zero": {"q1": z1, "q2": z2}, "phrase_zero": phrase_zero},
                   ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
