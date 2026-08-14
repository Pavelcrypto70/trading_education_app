#!/usr/bin/env python3
import json
import re
from pathlib import Path

DATA = Path("assets/data")

for name in ["lessons_ru.json", "lessons_en.json", "lessons_pt.json", "lessons_es.json"]:
    lessons = json.loads((DATA / name).read_text(encoding="utf-8"))
    assert len(lessons) == 58
    filler = 0
    charts = 0
    thin = []
    cyr_hits = []
    for L in lessons:
        text = "\n".join(
            s.get("body", "") for s in L.get("sections", []) if isinstance(s.get("body"), str)
        )
        filler += len(
            re.findall(r"На практике это значит|Finera|Look at the marked example", text)
        )
        nch = sum(1 for s in L.get("sections", []) if s.get("type") == "chart")
        charts += nch
        if len(L.get("sections", [])) < 8:
            thin.append(L["id"])
        if name != "lessons_ru.json":
            for s in L.get("sections", []):
                for k in ("body", "title", "caption"):
                    v = s.get(k)
                    if isinstance(v, str) and re.search(r"[\u0400-\u04FF]", v):
                        cyr_hits.append((L["id"], k, v[:50]))
    print(name, "lessons", len(lessons), "charts", charts, "filler", filler, "thin", thin)
    if cyr_hits:
        print("  CYR samples:", cyr_hits[:8], "total", len(cyr_hits))

ru = json.loads((DATA / "lessons_ru.json").read_text(encoding="utf-8"))
for i in (1, 5, 8, 15, 26, 36, 43, 47):
    L = next(x for x in ru if x["id"] == i)
    nch = sum(1 for s in L["sections"] if s["type"] == "chart")
    print(f"L{i}: secs={len(L['sections'])} charts={nch} | {L['title']}")

qz = json.loads((DATA / "lesson_quizzes.json").read_text(encoding="utf-8"))
print("quizzes", len(qz), "lessons covered", len({q["lessonId"] for q in qz}))
