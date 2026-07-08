#!/usr/bin/env python3
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
lessons = json.loads((ROOT / "assets/data/lessons_ru.json").read_text(encoding="utf-8"))

def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ")

lines = [
    "import '../models/lesson.dart';",
    "",
    "final List<Lesson> appLessons = [",
]
for L in lessons:
    lines += [
        "  Lesson(",
        f"    id: {L['id']},",
        f"    module: '{esc(L['module'])}',",
        f"    title: '{esc(L['title'])}',",
        f"    subtitle: '{esc(L['subtitle'][:100])}',",
        f"    difficulty: '{L['difficulty']}',",
        f"    durationMin: {L['durationMin']},",
        f"    outcome: '{esc(L['outcome'][:150])}',",
        f"    content: '{esc(L['content'][:150])}',",
        f"    takeaway: '{esc(L['takeaway'][:150])}',",
        "  ),",
    ]
lines.append("];")
(ROOT / "lib/data/app_data.dart").write_text("\n".join(lines), encoding="utf-8")
print(f"app_data.dart: {len(lessons)} lessons")
