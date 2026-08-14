#!/usr/bin/env python3
"""Extract lesson titles for mapping."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
with open(ROOT / "assets/data/lessons_ru.json", encoding="utf-8") as f:
    lessons = json.load(f)
for L in lessons:
    print(f"{L['id']}\t{L['title']}\t{L['module']}")
