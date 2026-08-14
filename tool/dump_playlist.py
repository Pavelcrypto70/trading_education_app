#!/usr/bin/env python3
"""Dump playlist from yt-dlp JSON to readable UTF-8 file."""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_TXT = ROOT / "tool" / "youtube_lessons.txt"
OUT_JSON = ROOT / "tool" / "playlist.json"
PLAYLIST = "https://www.youtube.com/playlist?list=PL0esFaQ691GJq-lE10jlr_3KLSGej7q2q"

raw = subprocess.check_output(
    ["yt-dlp", "--flat-playlist", "-J", PLAYLIST],
    text=True,
    encoding="utf-8",
)
data = json.loads(raw)
OUT_JSON.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")

lines = []
seen = set()
for e in data.get("entries", []):
    vid = e.get("id", "")
    if not vid or vid in seen:
        continue
    seen.add(vid)
    idx = e.get("playlist_index") or len(lines) + 1
    dur = e.get("duration") or 0
    title = (e.get("title") or "").replace("|", "/")
    lines.append(f"{idx}|{title}|https://www.youtube.com/watch?v={vid}|{dur // 60}:{dur % 60:02d}")

OUT_TXT.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Saved {len(lines)} videos -> {OUT_TXT.name}")
for line in lines:
    print(line)
