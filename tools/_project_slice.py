# -*- coding: utf-8 -*-
import json
from pathlib import Path

s = json.loads(Path("assets/data/syllabus.json").read_text(encoding="utf-8"))
out = []
out.append(s["course"]["ru"])
out.append(f"lessons={s['totalLessons']} hours={s['totalHours']}")
for m in s["modules"]:
    ids = m["lessonIds"]
    out.append(f"{m['order']}|{m['id']}|{m['title']['ru']}|{len(ids)}|{ids[0]}-{ids[-1]}")

l = json.loads(Path("assets/data/lessons_ru.json").read_text(encoding="utf-8"))
items = l if isinstance(l, list) else l.get("lessons", [])
out.append(f"lessons_ru={len(items)}")

q = json.loads(Path("assets/data/lesson_quizzes.json").read_text(encoding="utf-8"))
if isinstance(q, dict) and "lessons" in q:
    lessons = q["lessons"]
elif isinstance(q, dict):
    lessons = q
else:
    lessons = {}
total_q = 0
for k, v in lessons.items():
    if isinstance(v, dict) and "questions" in v:
        total_q += len(v["questions"])
    elif isinstance(v, list):
        total_q += len(v)
out.append(f"quiz_groups={len(lessons)} questions={total_q}")

Path("tools/_project_slice.txt").write_text("\n".join(out), encoding="utf-8")
print("wrote", len(out))
