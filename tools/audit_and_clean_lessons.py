#!/usr/bin/env python3
"""Audit lesson JSON spam/duplication and optionally clean duplicate paragraphs."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"


def collapse_dup_paragraphs(text: str) -> str:
    parts = [p.strip() for p in re.split(r"\n\s*\n", text) if p.strip()]
    out: list[str] = []
    seen: set[str] = set()
    for p in parts:
        key = re.sub(r"\s+", " ", p).strip().lower()
        if key in seen:
            continue
        seen.add(key)
        out.append(p)
    return "\n\n".join(out)


def estimate_chunks(text: str, max_chars: int = 380) -> int:
    cleaned = collapse_dup_paragraphs(text)
    total = 0
    for p in [x for x in re.split(r"\n\s*\n", cleaned) if x.strip()]:
        total += max(1, (len(p) + max_chars - 1) // max_chars)
    return total


def load_lessons(path: Path) -> list[dict]:
    raw = json.loads(path.read_text(encoding="utf-8"))
    if isinstance(raw, list):
        return raw
    return raw.get("lessons", raw)


def audit(path: Path) -> None:
    lessons = load_lessons(path)
    print(f"=== {path.name}: {len(lessons)} lessons ===")
    flagged = []
    for les in lessons:
        bodies = []
        has_chart = False
        for s in les.get("sections", []):
            if s.get("type") == "chart":
                has_chart = True
            body = s.get("body") or ""
            if body:
                bodies.append(body)
        raw_chars = sum(len(b) for b in bodies)
        clean_chars = sum(len(collapse_dup_paragraphs(b)) for b in bodies)
        est = sum(estimate_chunks(b) for b in bodies)
        spam_ratio = 1 - (clean_chars / raw_chars) if raw_chars else 0
        if est > 20 or spam_ratio > 0.25 or not has_chart or raw_chars > 8000:
            flagged.append(
                (
                    les["id"],
                    les.get("title", "")[:40],
                    est,
                    round(spam_ratio, 2),
                    has_chart,
                    raw_chars,
                    clean_chars,
                )
            )
    print(f"Flagged: {len(flagged)}")
    print("id | title | est_chunks | spam | chart | raw | clean")
    for row in sorted(flagged, key=lambda x: -x[2])[:50]:
        # Avoid Windows console encoding crashes on arrows/emoji.
        safe = tuple(str(x).encode("ascii", "replace").decode("ascii") for x in row)
        print(safe)

    for les in lessons:
        if les["id"] != 5:
            continue
        print("\n--- Lesson 5 sections ---")
        for i, s in enumerate(les.get("sections", [])):
            body = s.get("body") or ""
            clean = collapse_dup_paragraphs(body)
            raw_p = len([p for p in re.split(r"\n\s*\n", body) if p.strip()])
            clean_p = len([p for p in re.split(r"\n\s*\n", clean) if p.strip()])
            title = str(s.get("title") or "").encode("ascii", "replace").decode("ascii")
            print(
                f"  [{i}] type={s.get('type')} title={title!r} "
                f"raw={len(body)} clean={len(clean)} paras {raw_p}->{clean_p}"
            )


def clean_file(path: Path) -> tuple[int, int]:
    lessons = load_lessons(path)
    changed_bodies = 0
    saved = 0
    for les in lessons:
        for s in les.get("sections", []):
            body = s.get("body")
            if not body:
                continue
            clean = collapse_dup_paragraphs(body)
            if clean != body.strip() or clean != body:
                saved += len(body) - len(clean)
                if clean != body:
                    s["body"] = clean
                    changed_bodies += 1
        takeaway = les.get("takeaway")
        if isinstance(takeaway, str) and takeaway.strip():
            clean = collapse_dup_paragraphs(takeaway)
            if clean != takeaway:
                saved += len(takeaway) - len(clean)
                les["takeaway"] = clean
                changed_bodies += 1
        content = les.get("content")
        if isinstance(content, str) and content.strip():
            clean = collapse_dup_paragraphs(content)
            if clean != content:
                saved += len(content) - len(clean)
                les["content"] = clean
                changed_bodies += 1

    path.write_text(
        json.dumps(lessons, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return changed_bodies, saved


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--clean", action="store_true")
    args = parser.parse_args()

    files = [
        DATA / "lessons_ru.json",
        DATA / "lessons_en.json",
        DATA / "lessons_pt.json",
    ]
    for f in files:
        audit(f)
    if args.clean:
        print("\n=== CLEANING ===")
        for f in files:
            changed, saved = clean_file(f)
            print(f"{f.name}: bodies changed={changed}, chars saved={saved}")
            audit(f)


if __name__ == "__main__":
    main()
