#!/usr/bin/env python3
"""Translate lessons_full.json to lessons_ru.json and lessons_pt.json."""

import json
import time
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError:
    import subprocess
    subprocess.check_call(["pip", "install", "deep-translator", "-q"])
    from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parent.parent / "assets" / "data"
SOURCE = ROOT / "lessons_full.json"

TEXT_KEYS = {"outcome", "content", "takeaway", "title", "subtitle", "body", "caption"}
SKIP_KEYS = {"id", "type", "chartType", "durationMin", "difficulty", "module", "items"}


def translate_value(text: str, target: str, cache: dict) -> str:
    if not text or not text.strip():
        return text
    key = (target, text)
    if key in cache:
        return cache[key]
    try:
        result = GoogleTranslator(source="en", target=target).translate(text)
        cache[key] = result
        time.sleep(0.05)
        return result
    except Exception:
        cache[key] = text
        return text


def translate_section(section: dict, target: str, cache: dict) -> dict:
    result = dict(section)
    for key in TEXT_KEYS:
        if key in result and isinstance(result[key], str):
            result[key] = translate_value(result[key], target, cache)
    if "items" in result and isinstance(result["items"], list):
        result["items"] = [translate_value(item, target, cache) for item in result["items"]]
    return result


def translate_lesson(lesson: dict, target: str, cache: dict) -> dict:
    result = dict(lesson)
    for key in ("title", "subtitle", "outcome", "content", "takeaway"):
        if key in result:
            result[key] = translate_value(result[key], target, cache)
    if "module" in result:
        module_map_ru = {
            "Basics": "Основы", "Price Action": "Price Action", "Risk": "Риск",
            "Psychology": "Психология", "Strategy": "Стратегия", "Execution": "Исполнение",
            "Review": "Разбор", "Advanced": "Продвинутый",
        }
        module_map_pt = {
            "Basics": "Fundamentos", "Price Action": "Price Action", "Risk": "Risco",
            "Psychology": "Psicologia", "Strategy": "Estratégia", "Execution": "Execução",
            "Review": "Revisão", "Advanced": "Avançado",
        }
        m = result["module"]
        if target == "ru":
            result["module"] = module_map_ru.get(m, m)
        elif target == "pt":
            result["module"] = module_map_pt.get(m, m)
    diff_map_ru = {"Beginner": "Начальный", "Intermediate": "Средний", "Advanced": "Продвинутый"}
    diff_map_pt = {"Beginner": "Iniciante", "Intermediate": "Intermediário", "Advanced": "Avançado"}
    if target == "ru":
        result["difficulty"] = diff_map_ru.get(result.get("difficulty", ""), result.get("difficulty"))
    elif target == "pt":
        result["difficulty"] = diff_map_pt.get(result.get("difficulty", ""), result.get("difficulty"))
    if "sections" in result:
        result["sections"] = [translate_section(s, target, cache) for s in result["sections"]]
    return result


def main():
    lessons = json.loads(SOURCE.read_text(encoding="utf-8"))
    print(f"Loaded {len(lessons)} lessons from {SOURCE}")

    # Copy English
    en_path = ROOT / "lessons_en.json"
    en_path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Wrote {en_path}")

    for target, filename in [("ru", "lessons_ru.json"), ("pt", "lessons_pt.json")]:
        cache = {}
        translated = []
        for i, lesson in enumerate(lessons):
            translated.append(translate_lesson(lesson, target, cache))
            if (i + 1) % 10 == 0:
                print(f"  [{target}] {i + 1}/{len(lessons)}...")
        out = ROOT / filename
        out.write_text(json.dumps(translated, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"Wrote {out} ({out.stat().st_size / 1024:.0f} KB)")


if __name__ == "__main__":
    main()
