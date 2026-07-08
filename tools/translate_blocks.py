#!/usr/bin/env python3
"""Translate lesson blocks RU → EN/PT with disk cache."""

from __future__ import annotations

import json
import re
import time
from pathlib import Path

try:
    from deep_translator import GoogleTranslator
except ImportError:
    GoogleTranslator = None  # type: ignore

CACHE_FILE = Path(__file__).parent / ".block_translation_cache.json"

_PLACEHOLDER_EN = re.compile(
    r"^This section covers |^Markets auction price every second",
    re.I,
)
_PLACEHOLDER_PT = re.compile(
    r"^Esta seção aborda ",
    re.I,
)
_CYRILLIC = re.compile(r"[\u0400-\u04FF]")

__all__ = ["align_blocks", "translate_text", "_load_cache", "_CYRILLIC", "is_placeholder", "needs_retranslate"]


def _load_cache() -> dict:
    if CACHE_FILE.exists():
        return json.loads(CACHE_FILE.read_text(encoding="utf-8"))
    return {}


def _save_cache(cache: dict) -> None:
    CACHE_FILE.write_text(json.dumps(cache, ensure_ascii=False, indent=0), encoding="utf-8")


def is_placeholder(body: str, lang: str) -> bool:
    if not body:
        return True
    if lang == "en" and _PLACEHOLDER_EN.search(body):
        return True
    if lang == "pt" and _PLACEHOLDER_PT.search(body):
        return True
    if _CYRILLIC.search(body):
        return True
    return False


def needs_retranslate(ru_body: str, target_body: str, lang: str) -> bool:
    if is_placeholder(target_body, lang):
        return True
    ru_w = len(ru_body.split())
    tg_w = len(target_body.split())
    if ru_w > 120 and tg_w < ru_w * 0.55:
        return True
    return False


def translate_text(text: str, target: str, cache: dict) -> str:
    if not text or not text.strip():
        return text
    key = f"{target}::{text}"
    if key in cache:
        return cache[key]
    if GoogleTranslator is None:
        return text
    try:
        result = GoogleTranslator(source="ru", target=target).translate(text)
        cache[key] = result
        time.sleep(0.06)
        return result
    except Exception:
        return text


def align_blocks(ru_blocks: list[dict], target_blocks: list[dict], lang: str, cache: dict) -> list[dict]:
    """Return blocks for lang; translate from RU where target is stub or too short."""
    out: list[dict] = []
    for i, ru in enumerate(ru_blocks):
        ru_h, ru_b = ru["h"], ru["body"]
        if i < len(target_blocks) and not needs_retranslate(ru_b, target_blocks[i].get("body", ""), lang):
            tb = target_blocks[i]
            out.append({"h": tb["h"], "body": tb["body"]})
            continue
        h = translate_text(ru_h, lang, cache)
        b = translate_text(ru_b, lang, cache)
        out.append({"h": h, "body": b})
    _save_cache(cache)
    return out
