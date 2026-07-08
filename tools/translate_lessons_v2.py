#!/usr/bin/env python3
"""Reliable per-string lesson translation with disk cache."""

import json
import time
from pathlib import Path

from deep_translator import GoogleTranslator

ROOT = Path(__file__).resolve().parent.parent / "assets" / "data"
SOURCE = ROOT / "lessons_en.json"
CACHE_FILE = Path(__file__).parent / ".translation_cache.json"

MODULE_MAP = {
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


def load_cache():
    if CACHE_FILE.exists():
        return json.loads(CACHE_FILE.read_text(encoding="utf-8"))
    return {}


def save_cache(cache):
    CACHE_FILE.write_text(json.dumps(cache, ensure_ascii=False), encoding="utf-8")


def tr(text: str, target: str, cache: dict) -> str:
    if not text or not text.strip():
        return text
    key = f"{target}::{text}"
    if key in cache:
        return cache[key]
    try:
        result = GoogleTranslator(source="en", target=target).translate(text)
        cache[key] = result
        time.sleep(0.08)
        return result
    except Exception as e:
        print(f"  FAIL: {e}", flush=True)
        return text


def translate_obj(obj, target, cache):
    if isinstance(obj, dict):
        return {k: translate_obj(v, target, cache) for k, v in obj.items()}
    if isinstance(obj, list):
        return [translate_obj(v, target, cache) for v in obj]
    if isinstance(obj, str):
        return tr(obj, target, cache)
    return obj


def apply_meta(lesson, target):
    mm = MODULE_MAP[target]
    lesson = dict(lesson)
    lesson["module"] = mm.get(lesson.get("module", ""), lesson.get("module", ""))
    lesson["difficulty"] = mm.get(lesson.get("difficulty", ""), lesson.get("difficulty", ""))
    return lesson


def main():
    lessons = json.loads(SOURCE.read_text(encoding="utf-8"))
    cache = load_cache()
    print(f"Loaded {len(lessons)} lessons, cache {len(cache)} entries", flush=True)

    for target, filename in [("ru", "lessons_ru.json"), ("pt", "lessons_pt.json")]:
        out = []
        for i, lesson in enumerate(lessons):
            translated = translate_obj(apply_meta(lesson, target), target, cache)
            out.append(translated)
            if (i + 1) % 5 == 0:
                save_cache(cache)
                print(f"[{target}] {i + 1}/{len(lessons)}", flush=True)
        path = ROOT / filename
        path.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
        save_cache(cache)
        print(f"Done {path} ({path.stat().st_size // 1024} KB)", flush=True)


if __name__ == "__main__":
    main()
