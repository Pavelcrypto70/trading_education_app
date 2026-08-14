import json
from pathlib import Path

syl = json.loads(Path("assets/data/syllabus.json").read_text(encoding="utf-8"))
ru = json.loads(Path("assets/data/lessons_ru.json").read_text(encoding="utf-8"))
by = {L["id"]: L for L in ru}
for m in syl["modules"]:
    print("##", m["title"]["ru"], m["lessonIds"])
    for i in m["lessonIds"]:
        L = by[i]
        print(f"  L{i}: {L['title']}")
