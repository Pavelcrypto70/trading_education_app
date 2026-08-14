#!/usr/bin/env python3
"""Deep QA after intro/youtube fixes — find remaining improvement opportunities."""
from __future__ import annotations

import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RU = json.loads((ROOT / "tools" / "_linear_ru.json").read_text(encoding="utf-8"))
LES = json.loads((ROOT / "assets" / "data" / "lessons_ru.json").read_text(encoding="utf-8"))
SRC = (ROOT / "lib" / "screens" / "lesson_screen.dart").read_text(encoding="utf-8")


def norm(s: str) -> str:
    return re.sub(r"\s+", " ", s.strip().lower())


def main() -> None:
    issues: list[tuple[str, str, str]] = []  # sev, code, detail

    # Player: youtube gone?
    if "LessonMedia.forLesson" in SRC or "_VideoStep" in SRC:
        issues.append(("P0", "YOUTUBE_STILL_IN_PLAYER", "lesson_screen still references video"))
    else:
        print("OK: no YouTube step in lesson_screen")

    media = (ROOT / "lib" / "data" / "lesson_media.dart").read_text(encoding="utf-8")
    if "forLesson(int lessonId, String module) => null" not in media.replace(" ", ""):
        # softer check
        if "=> null" not in media.split("forLesson")[1][:120]:
            issues.append(("P0", "MEDIA_NOT_DISABLED", "LessonMedia.forLesson not null"))
        else:
            print("OK: LessonMedia.forLesson disabled")
    else:
        print("OK: LessonMedia.forLesson disabled")

    for les in LES:
        n = les["id"]
        title = les["title"]
        outs = les.get("learningOutcomes") or []
        take = les.get("takeaway", "")
        outcome = les.get("outcome", "")
        sub = les.get("subtitle", "")

        # Intro duplication
        blob = [outcome, *outs]
        norms = [norm(x) for x in blob if x]
        if len(norms) != len(set(norms)):
            issues.append(("P0", "INTRO_DUP", f"L{n} duplicate outcome lines"))
        if take and any(norm(take) == norm(x) or norm(take) in norm(x) for x in blob):
            issues.append(("P1", "TAKEAWAY_IN_INTRO", f"L{n} takeaway still in intro block"))
        if sub and take and norm(sub) == norm(take):
            issues.append(("P1", "SUB_IS_TAKEAWAY", f"L{n} subtitle == takeaway"))

        # Empty / short cards
        texts = [s for s in les["sections"] if s["type"] == "text"]
        for s in texts:
            body = (s.get("body") or "").strip()
            if not body:
                issues.append(("P0", "EMPTY_TEXT", f"L{n} empty text card"))
            if body in ("Выбери одну фразу.", "Выбери фразу соседке."):
                issues.append(("P0", "DEAD_PHRASE", f"L{n} dead phrase prompt as text"))

        choices = [s for s in les["sections"] if s["type"] == "choice"]
        if len(choices) < 2:
            issues.append(("P0", "MISSING_CHOICE", f"L{n} choices={len(choices)}"))
        for c in choices:
            items = c.get("items") or []
            if len(items) < 2:
                issues.append(("P0", "CHOICE_FEW_ITEMS", f"L{n} {c.get('title')}"))
            if c.get("correctIndex") is None:
                issues.append(("P0", "NO_CORRECT_INDEX", f"L{n}"))
            # duplicate options
            if len(items) != len({norm(i) for i in items}):
                issues.append(("P1", "DUP_OPTIONS", f"L{n} {c.get('title')}"))

        # Unique cardIndexes on chart-bearing sections only
        idxs = [
            s.get("cardIndex")
            for s in les["sections"]
            if s["type"] in ("text", "choice", "homework", "practice", "journal") and s.get("cardIndex") is not None
        ]
        if len(idxs) != len(set(idxs)):
            issues.append(("P1", "DUP_CARD_INDEX", f"L{n} {idxs}"))

        # subtitle must not equal first text body
        first_text = next((s.get("body") for s in texts if s.get("body")), "")
        if sub and first_text and norm(sub) == norm(first_text.split("\n\n")[0]):
            issues.append(("P1", "SUB_EQ_FIRST_CARD", f"L{n}"))

        # Chart on every interactive/content section
        for s in les["sections"]:
            if s["type"] in ("text", "choice", "homework", "practice", "journal"):
                if s.get("cardIndex") is None:
                    issues.append(("P1", "NO_CARD_INDEX", f"L{n} {s['type']}"))

        # Cross-card text near-dup within lesson
        bodies = [norm(s.get("body", "")) for s in texts if s.get("body")]
        for i, a in enumerate(bodies):
            for b in bodies[i + 1 :]:
                if a and b and (a == b or (len(a) > 40 and a in b) or (len(b) > 40 and b in a)):
                    issues.append(("P1", "INTRA_LESSON_DUP_TEXT", f"L{n}"))

        # Journal items only takeaway — ok but note
        # Practice without return hint
        for s in les["sections"]:
            if s["type"] == "practice":
                body = s.get("body") or ""
                if "Вернуться" not in body and "return" not in body.lower() and "Voltar" not in body and "Volver" not in body:
                    issues.append(("P2", "PRACTICE_NO_RETURN_HINT", f"L{n}"))

    # Source pedagogy: take word
    trade_blob = " ".join(
        " ".join(x["lines"]) + x["grandma"] for x in RU if 37 <= x["id"] <= 46
    ).lower()
    if "тейк" not in trade_blob and "тейк" not in json.dumps(LES[36:46], ensure_ascii=False).lower():
        issues.append(("P1", "NO_TAKE_WORD", "trade module missing тейк"))

    # Cross-lesson identical first lines (template smell beyond structure)
    firsts = Counter(norm(x["lines"][0]) for x in RU)
    for t, c in firsts.most_common(5):
        if c > 1:
            issues.append(("P2", "SHARED_OPENERS", f"{c}x: {t[:60]}"))

    # Step count estimate
    for les in LES[:1]:
        types = Counter(s["type"] for s in les["sections"])
        est = 1 + types["text"] + types["choice"] + types.get("homework", 0) + types.get("practice", 0) + types.get("journal", 0) + 1
        print(f"L1 approx steps={est} types={dict(types)}")
        print("L1 subtitle:", les["subtitle"][:80])
        print("L1 outcome:", les["outcome"])
        print("L1 outcomes:", les["learningOutcomes"])

    sev = Counter(i[0] for i in issues)
    print("\n=== ISSUES", len(issues), dict(sev), "===")
    by_code = Counter(i[1] for i in issues)
    for code, c in by_code.most_common():
        samples = [i[2] for i in issues if i[1] == code][:3]
        print(f"  {code}: {c}  e.g. {samples}")

    # Remaining improvement ideas (always print)
    print("\n=== IMPROVEMENT BACKLOG ===")
    ideas = [
        "Chart captions still generic visualExampleCaption — make per-card caption from topic",
        "Intro still has concept visual + chart — may feel heavy; optional slim intro",
        "Choice correct always index 0 for phrase — shuffle options for harder quiz feel",
        "Homework items still include full takeaway — fine for template, but UI may look long",
        "Pattern lessons: pattern diagram only on even cards — odd still generic candles",
        "Case studies orphaned (not in player) — either wire selectively or delete from assets",
        "EN/PT/ES loc['outcome']/sub overridden by RU-style UI strings — OK; verify naturalness",
        "Paper practice default scenario still mentions stop/target before trade module",
        "No progress resume mid-lesson step index",
        "Checkpoint can still show chart with lessonId cardIndex 0 — may mismatch last card",
    ]
    for i, idea in enumerate(ideas, 1):
        print(f"  {i}. {idea}")

    out = ROOT / "tools" / "_qa_deep_report.json"
    out.write_text(json.dumps({"issues": issues, "ideas": ideas}, ensure_ascii=False, indent=2), encoding="utf-8")
    print("wrote", out)


if __name__ == "__main__":
    main()
