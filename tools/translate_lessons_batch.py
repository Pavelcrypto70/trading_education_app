#!/usr/bin/env python3
"""Fast batch translation: one API call per lesson per language."""

import json
import sys
import time
from pathlib import Path

from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parent.parent / "assets" / "data"
SOURCE = ROOT / "lessons_en.json"
SEP = "\n<<<TM>>>\n"


def collect_strings(obj, path=()):
    items = []
    if isinstance(obj, dict):
        for k, v in obj.items():
            items.extend(collect_strings(v, path + (k,)))
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            items.extend(collect_strings(v, path + (i,)))
    elif isinstance(obj, str) and obj.strip():
        items.append((path, obj))
    return items


def set_at_path(obj, path, value):
    cur = obj
    for key in path[:-1]:
        cur = cur[key]
    cur[path[-1]] = value


def translate_lesson(lesson: dict, target: str, cache: dict) -> dict:
    result = json.loads(json.dumps(lesson))
    items = collect_strings(result)
    if not items:
        return result

    module_maps = {
        "ru": {
            "Basics": "Основы", "Price Action": "Price Action", "Risk": "Риск",
            "Psychology": "Психология", "Strategy": "Стратегия", "Execution": "Исполнение",
            "Review": "Разбор", "Advanced": "Продвинутый",
            "Beginner": "Начальный", "Intermediate": "Средний", "Advanced": "Продвинутый",
        },
        "pt": {
            "Basics": "Fundamentos", "Price Action": "Price Action", "Risk": "Risco",
            "Psychology": "Psicologia", "Strategy": "Estratégia", "Execution": "Execução",
            "Review": "Revisão", "Advanced": "Avançado",
            "Beginner": "Iniciante", "Intermediate": "Intermediário", "Advanced": "Avançado",
        },
    }
    mm = module_maps.get(target, {})
    if "module" in result:
        result["module"] = mm.get(result["module"], result["module"])
    if "difficulty" in result:
        result["difficulty"] = mm.get(result["difficulty"], result["difficulty"])

    texts = [t for _, t in items]
    combined = SEP.join(texts)
    cache_key = (target, combined[:200])
    if cache_key in cache:
        translated_parts = cache[cache_key]
    else:
        translator = GoogleTranslator(source="en", target=target)
        chunk_size = 4500
        translated_parts = []
        for i in range(0, len(combined), chunk_size):
            chunk = combined[i : i + chunk_size]
            translated_parts.append(translator.translate(chunk))
            time.sleep(0.2)
        translated_parts = SEP.join(translated_parts).split(SEP)
        cache[cache_key] = translated_parts

    if len(translated_parts) != len(texts):
        print(f"  WARN: part count mismatch {len(translated_parts)} vs {len(texts)}", flush=True)
        return result

    for (path, _), new_text in zip(items, translated_parts):
        set_at_path(result, path, new_text)
    return result


def main():
    lessons = json.loads(SOURCE.read_text(encoding="utf-8"))
    print(f"Loaded {len(lessons)} lessons", flush=True)

    for target, filename in [("ru", "lessons_ru.json"), ("pt", "lessons_pt.json")]:
        cache = {}
        out = []
        for i, lesson in enumerate(lessons):
            out.append(translate_lesson(lesson, target, cache))
            print(f"[{target}] {i + 1}/{len(lessons)} — {lesson['title'][:40]}", flush=True)
        path = ROOT / filename
        path.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"Done: {path} ({path.stat().st_size // 1024} KB)", flush=True)


if __name__ == "__main__":
    main()
