#!/usr/bin/env python3
"""Sync lesson_media.dart titles from lessons_{pt,es,ru,en}.json."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "assets" / "data"
MEDIA = ROOT / "lib" / "data" / "lesson_media.dart"


def load_titles(locale: str) -> dict[int, str]:
    path = DATA / f"lessons_{locale}.json"
    if not path.exists():
        return {}
    lessons = json.loads(path.read_text(encoding="utf-8"))
    return {int(l["id"]): str(l.get("title", "")) for l in lessons}


def dart_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "\\'")


def main() -> None:
    en = load_titles("en")
    ru = load_titles("ru")
    pt = load_titles("pt")
    es = load_titles("es")
    src = MEDIA.read_text(encoding="utf-8")

    def repl_entry(m: re.Match) -> str:
        lid = int(m.group(1))
        block = m.group(0)
        title_en = en.get(lid, "")
        title_ru = ru.get(lid, "")
        title_pt = pt.get(lid, title_en)
        title_es = es.get(lid, title_en)
        if not title_en:
            return block

        # Replace title fields inside the entry
        block = re.sub(
            r"titleRu:\s*'[^']*'",
            f"titleRu: '{dart_escape(title_ru or title_en)}'",
            block,
            count=1,
        )
        block = re.sub(
            r"titleEn:\s*'[^']*'",
            f"titleEn: '{dart_escape(title_en)}'",
            block,
            count=1,
        )
        block = re.sub(
            r"titlePt:\s*'[^']*'",
            f"titlePt: '{dart_escape(title_pt)}'",
            block,
            count=1,
        )
        if "titleEs:" in block:
            block = re.sub(
                r"titleEs:\s*'[^']*'",
                f"titleEs: '{dart_escape(title_es)}'",
                block,
                count=1,
            )
        else:
            block = re.sub(
                r"(titlePt:\s*'[^']*',\n)",
                rf"\1      titleEs: '{dart_escape(title_es)}',\n",
                block,
                count=1,
            )
        return block

    out = re.sub(
        r"(\d+):\s*LessonMediaEntry\([\s\S]*?\),",
        repl_entry,
        src,
    )
    MEDIA.write_text(out, encoding="utf-8")
    print(f"Synced titles for {len(en)} lessons", flush=True)


if __name__ == "__main__":
    main()
