# -*- coding: utf-8 -*-
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
syl = json.loads((root / "assets/data/syllabus.json").read_text(encoding="utf-8"))
lessons = json.loads((root / "assets/data/lessons_ru.json").read_text(encoding="utf-8"))

by_id = {}
if isinstance(lessons, dict):
    items = lessons.get("lessons") or lessons.get("items") or lessons
    if isinstance(items, dict):
        for k, v in items.items():
            if isinstance(v, dict):
                by_id[str(v.get("id", k))] = v
        items = [v for v in items.values() if isinstance(v, dict)]
    if isinstance(items, list):
        for v in items:
            if isinstance(v, dict):
                by_id[str(v.get("id"))] = v
elif isinstance(lessons, list):
    for v in lessons:
        by_id[str(v.get("id"))] = v

out = []
out.append(f"COURSE: {syl['course'].get('ru')}")
out.append(f"TOTAL in syllabus: {syl.get('totalLessons')}")
out.append(f"Indexed lessons: {len(by_id)}")
out.append("")
n = 0
for m in syl["modules"]:
    out.append(f"=== Модуль {m['order']}: {m['title']['ru']} ({m['id']}) ===")
    for lid in m["lessonIds"]:
        n += 1
        L = by_id.get(str(lid))
        title = "?"
        if L:
            t = L.get("title")
            if isinstance(t, dict):
                title = t.get("ru") or t.get("en") or str(t)
            else:
                title = t or L.get("name") or "?"
        # normalize arrows for plain text
        title = str(title).replace("\u2192", "->").replace("\u2190", "<-")
        out.append(f"{n:2d}. [{lid}] {title}")
    out.append("")
out.append(f"listed: {n}")
text = "\n".join(out)
(root / "tools/_lessons_ru_list.txt").write_text(text, encoding="utf-8")
print(text)
