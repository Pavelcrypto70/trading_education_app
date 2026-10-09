import os
import re

ROOT = os.path.join(os.path.dirname(__file__), "..", "lib")
for base, _, files in os.walk(ROOT):
    for name in files:
        if not name.endswith(".dart"):
            continue
        p = os.path.join(base, name)
        with open(p, encoding="utf-8") as f:
            s = f.read()
        n = re.sub(r"const AppTheme\.", "AppTheme.", s)
        if n != s:
            with open(p, "w", encoding="utf-8", newline="") as f:
                f.write(n)
            print(os.path.relpath(p, ROOT))
