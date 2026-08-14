# -*- coding: utf-8 -*-
import json
import re
from pathlib import Path

p = Path(r"C:\Users\Павел\.cursor\projects\c-Users-Desktop\canvases\trade-master-all-lessons.canvas.tsx")
text = p.read_text(encoding="utf-8")
m = re.search(r"const LESSONS: Lesson\[\] = \[(.*?)\n\];", text, re.S)
if not m:
    raise SystemExit("LESSONS not found")
body = m.group(1)
objs = []
for chunk in body.split("\n  { ")[1:]:
    chunk = "{ " + chunk.strip().rstrip(",")
    # parse loosely with regex fields
    def g(key):
        mm = re.search(rf'{key}: ("(?:\\.|[^"\\])*"|true|false|\d+|\[[\s\S]*?\])', chunk)
        if not mm:
            raise SystemExit(f"missing {key} in {chunk[:80]}")
        return json.loads(mm.group(1))

    objs.append({
        "id": g("id") if False else int(re.search(r"id: (\d+)", chunk).group(1)),
        "module": g("module"),
        "title": g("title"),
        "kit": g("kit"),
        "grandma": g("grandma"),
        "doLive": g("doLive"),
        "doDead": g("doDead"),
        "doSoon": g("doSoon"),
        "doAnswer": re.search(r'doAnswer: "(\w+)"', chunk).group(1),
        "bad1": g("bad1"),
        "bad2": g("bad2"),
        "lines": g("lines"),
    })

out = Path(__file__).resolve().parent / "_linear_ru.json"
out.write_text(json.dumps(objs, ensure_ascii=False, indent=2), encoding="utf-8")
print(len(objs), "lessons ->", out)
print("ids", [o["id"] for o in objs])
