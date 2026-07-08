#!/usr/bin/env python3
"""Strip auto-padded boilerplate from lesson block bodies (RU/EN/PT)."""

from __future__ import annotations

import re

# Markers where unique content ends and template padding begins.
_STRIP_MARKERS = [
    # RU (part03 pad_ru)
    "\n\nДо клика запишите:",
    "\n\nДо клика запишите",
    "\n\nПредставьте, что вы объясняете это другу",
    "\n\nЗакройте урок практикой:",
    # EN (part03 en_std tails)
    "\n\nDefine entry, stop, target, and risk",
    "\n\nBefore every click",
    "\n\nOne winning trade does not prove genius",
    "\n\nTrade Master links lesson theory",
    "\n\nLimit orders add liquidity",
    "\n\nOpen the lesson symbol at the stated interval",
    "\n\nMeasure recent range in percent",
    # PT
    "\n\nAntes de clicar, anote",
    "\n\nDefina entrada, stop e alvo",
]


def _dedupe_paragraphs(text: str) -> str:
    parts = [p.strip() for p in re.split(r"\n\n+", text) if p.strip()]
    seen: set[str] = set()
    unique: list[str] = []
    for p in parts:
        key = p[:120]
        if key in seen:
            continue
        seen.add(key)
        unique.append(p)
    return "\n\n".join(unique)


def clean_body(text: str) -> str:
    if not text:
        return text
    out = text
    for marker in _STRIP_MARKERS:
        if marker in out:
            out = out.split(marker)[0]
    out = re.sub(
        r"\n+Представьте, что вы объясняете это другу.*",
        "",
        out,
        flags=re.DOTALL,
    )
    return _dedupe_paragraphs(out.strip())


def clean_blocks(blocks: list[dict]) -> list[dict]:
    cleaned = []
    for block in blocks:
        body = clean_body(block.get("body", ""))
        if not body:
            continue
        cleaned.append({"h": block["h"], "body": body})
    return cleaned
