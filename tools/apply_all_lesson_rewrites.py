#!/usr/bin/env python3
"""Apply RU rewrites (if needed) and translate rewritten lessons to EN/PT with resume."""

from __future__ import annotations

import copy
import json
import sys
from pathlib import Path

from rewrite_all_part_a import RU as RU_A
from rewrite_all_part_b import RU as RU_B
from rewrite_all_part_c import RU as RU_C
from translate_blocks import translate_text, _load_cache, _save_cache

DATA = Path(__file__).resolve().parents[1] / "assets" / "data"
SKIP = {8, 9, 19, 46, 47}

STRUCT = {
    "en": {
        "practice": "Practice",
        "journal": "Journal",
        "homework": "Homework",
        "tip": "Tip",
        "example": "Worked example",
        "bullets": "Remember",
    },
    "pt": {
        "practice": "Prática",
        "journal": "Diário",
        "homework": "Tarefa",
        "tip": "Dica",
        "example": "Exemplo com números",
        "bullets": "Lembre",
    },
}


def log(msg: str) -> None:
    print(msg, flush=True)


def merge_ru() -> dict[int, dict]:
    out: dict[int, dict] = {}
    for part in (RU_A, RU_B, RU_C):
        for lid, data in part.items():
            if lid in SKIP:
                continue
            out[lid] = data
    return out


def apply_ru(ru_map: dict[int, dict]) -> int:
    path = DATA / "lessons_ru.json"
    lessons = json.loads(path.read_text(encoding="utf-8"))
    by_id = {int(l["id"]): l for l in lessons}
    n = 0
    for lid, d in ru_map.items():
        les = by_id[lid]
        les["title"] = d["title"]
        les["subtitle"] = d["subtitle"]
        les["outcome"] = d["outcome"]
        les["content"] = d.get("content", les.get("content", ""))
        les["takeaway"] = d.get("takeaway", les.get("takeaway", ""))
        if "prerequisites" in d:
            les["prerequisites"] = d["prerequisites"]
        les["sections"] = d["sections"]
        n += 1
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return n


def tr_section(sec: dict, lang: str, cache: dict) -> dict:
    ns = copy.deepcopy(sec)
    fixed = STRUCT[lang]
    if ns.get("type") in fixed:
        ns["title"] = fixed[ns["type"]]
    elif isinstance(ns.get("title"), str) and ns["title"].strip():
        ns["title"] = translate_text(ns["title"], lang, cache)
    for key in ("body", "caption"):
        if isinstance(ns.get(key), str) and ns[key].strip():
            ns[key] = translate_text(ns[key], lang, cache)
    if isinstance(ns.get("items"), list):
        ns["items"] = [
            translate_text(it, lang, cache) if isinstance(it, str) else it for it in ns["items"]
        ]
    if ns.get("type") == "journal" and isinstance(ns.get("body"), str):
        ns["body"] = {"en": "Log:", "pt": "Registre:"}[lang]
    return ns


def translate_overlay(d: dict, lang: str, cache: dict) -> dict:
    return {
        "title": translate_text(d["title"], lang, cache),
        "subtitle": translate_text(d["subtitle"], lang, cache),
        "outcome": translate_text(d["outcome"], lang, cache),
        "content": translate_text(d.get("content", ""), lang, cache),
        "takeaway": translate_text(d.get("takeaway", ""), lang, cache),
        "prerequisites": d.get("prerequisites", []),
        "sections": [tr_section(s, lang, cache) for s in d["sections"]],
    }


def apply_locale(fname: str, overlays: dict[int, dict]) -> int:
    path = DATA / fname
    lessons = json.loads(path.read_text(encoding="utf-8"))
    by_id = {int(l["id"]): l for l in lessons}
    for lid, data in overlays.items():
        les = by_id[lid]
        for k in ("title", "subtitle", "outcome", "content", "takeaway", "sections"):
            if k in data and data[k] is not None:
                les[k] = data[k]
        if "prerequisites" in data:
            les["prerequisites"] = data["prerequisites"]
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return len(overlays)


def main() -> None:
    ru_map = merge_ru()
    log(f"Lessons to apply: {sorted(ru_map)} ({len(ru_map)})")
    n = apply_ru(ru_map)
    log(f"RU applied: {n}")

    cache = _load_cache()
    log(f"Cache start: {len(cache)}")
    try:
        for lang, fname in (("en", "lessons_en.json"), ("pt", "lessons_pt.json")):
            log(f"=== {lang.upper()} ===")
            overlays: dict[int, dict] = {}
            for i, lid in enumerate(sorted(ru_map)):
                log(f"  [{i+1}/{len(ru_map)}] lesson {lid}")
                overlays[lid] = translate_overlay(ru_map[lid], lang, cache)
                if (i + 1) % 3 == 0:
                    _save_cache(cache)
                    log(f"  cache checkpoint {len(cache)}")
            apply_locale(fname, overlays)
            _save_cache(cache)
            log(f"{lang.upper()} done")
    finally:
        _save_cache(cache)
        log(f"Cache end: {len(cache)}")


if __name__ == "__main__":
    main()
