"""Replace hardcoded Material colors in lib/screens + lib/widgets with AppTheme tokens."""
import os
import re
import sys

ROOT = os.path.join(os.path.dirname(__file__), "..", "lib")
DIRS = ["screens", "widgets", "ui"]

MAP = [
    (r"Colors\.white70\b", "AppTheme.textSoft"),
    (r"Colors\.white60\b", "AppTheme.muted"),
    (r"Colors\.white54\b", "AppTheme.muted"),
    (r"Colors\.white38\b", "AppTheme.faint"),
    (r"Colors\.white30\b", "AppTheme.faint"),
    (r"Colors\.white24\b", "AppTheme.faint"),
    (r"Colors\.white12\b", "AppTheme.line"),
    (r"Colors\.white10\b", "AppTheme.lineSoft"),
    (r"Colors\.greenAccent\b(?!\.shade)", "AppTheme.bull"),
    (r"Colors\.green\b(?!\.shade)", "AppTheme.bull"),
    (r"Colors\.redAccent\b(?!\.shade)", "AppTheme.bear"),
    (r"Colors\.red\b(?!\.shade)", "AppTheme.bear"),
    (r"Colors\.orangeAccent\b(?!\.shade)", "AppTheme.orange"),
    (r"Colors\.orange\b(?!\.shade)", "AppTheme.orange"),
    (r"Colors\.amber\b(?!\.shade)", "AppTheme.warn"),
    (r"Colors\.blueAccent\b(?!\.shade)", "AppTheme.info"),
    (r"Colors\.blue\b(?!\.shade)", "AppTheme.info"),
    (r"Colors\.purpleAccent\b(?!\.shade)", "AppTheme.violet"),
    (r"Colors\.purple\b(?!\.shade)", "AppTheme.violet"),
    (r"Colors\.deepPurple\b(?!\.shade)", "AppTheme.violet"),
    (r"Color\(0xFF131722\)", "AppTheme.surface"),
    (r"Color\(0xFF0D1117\)", "AppTheme.bg2"),
    (r"Color\(0xFF26A69A\)", "AppTheme.bull"),
    (r"Color\(0xFFEF5350\)", "AppTheme.bear"),
    (r"Color\(0xFFD4AF37\)", "AppTheme.warn"),
    (r"Color\(0xFF6C5CE7\)", "AppTheme.violet"),
]


def theme_import(path):
    rel = os.path.relpath(os.path.join(ROOT, "theme.dart"), os.path.dirname(path))
    return "import '" + rel.replace(os.sep, "/") + "';"


def process(path):
    with open(path, encoding="utf-8") as f:
        src = f.read()
    out = src
    for pat, rep in MAP:
        out = re.sub(pat, rep, out)
    if out == src:
        return False
    if "theme.dart'" not in out:
        imp = theme_import(path)
        lines = out.split("\n")
        last = max(i for i, l in enumerate(lines) if l.startswith("import "))
        lines.insert(last + 1, imp)
        out = "\n".join(lines)
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(out)
    return True


changed = []
for d in DIRS:
    for base, _, files in os.walk(os.path.join(ROOT, d)):
        for name in files:
            if name.endswith(".dart"):
                p = os.path.join(base, name)
                if process(p):
                    changed.append(os.path.relpath(p, ROOT))

print("\n".join(changed))
print(f"{len(changed)} files changed", file=sys.stderr)
