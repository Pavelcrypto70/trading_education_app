#!/usr/bin/env python3
"""Generate 47-lesson premium curriculum: RU / EN / PT with TradingView practice."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets" / "data"


def tv_url(symbol: str, interval: str = "15") -> str:
    sym = symbol.replace(":", "%3A")
    return f"https://www.tradingview.com/chart/?symbol={sym}&interval={interval}"


def build_sections(lang: str, d: dict) -> list:
    L = d["loc"][lang]
    market_key = {"ru": "ru", "en": "mx", "pt": "br"}[lang]
    market = d["markets"].get(market_key, d["markets"].get("global", ""))

    sections = []
    blocks = L.get("blocks")
    if blocks:
        for block in blocks:
            sections.append({"type": "heading", "title": block["h"]})
            sections.append({"type": "text", "body": block["body"]})
    else:
        sections.extend([
            {"type": "heading", "title": L["h1"]},
            {"type": "text", "body": L["theory"]},
            {"type": "heading", "title": L["h2"]},
            {"type": "text", "body": L["theory2"]},
        ])

    sections.extend([
        {
            "type": "market_note",
            "title": L["market_title"],
            "body": market,
            "market": market_key if market_key in ("br", "mx", "ru") else "latam",
        },
        {
            "type": "chart",
            "title": L["chart_title"],
            "chartType": d["chart"],
            "caption": L["chart_cap"],
        },
        {
            "type": "tradingview",
            "title": L["tv_title"],
            "body": L["tv_body"],
            "symbol": d["symbol"],
            "interval": d.get("interval", "15"),
            "url": tv_url(d["symbol"], d.get("interval", "15")),
        },
        {
            "type": "practice",
            "title": L["practice_title"],
            "body": L["practice_intro"],
            "items": L["practice_steps"],
        },
        {"type": "example", "title": L["example_title"], "body": L["example"]},
        {"type": "bullets", "title": L["bullets_title"], "items": L["bullets"]},
        {
            "type": "journal",
            "title": L["journal_title"],
            "body": L["journal_body"],
            "items": L["journal_items"],
        },
        {"type": "tip", "title": L["tip_title"], "body": L["tip"]},
    ])
    return sections


def lesson(
    lid,
    module,
    difficulty,
    mins,
    chart,
    symbol,
    interval,
    markets,
    loc,
):
    return {
        "id": lid,
        "module": module,
        "difficulty": difficulty,
        "durationMin": mins,
        "chart": chart,
        "symbol": symbol,
        "interval": interval,
        "markets": markets,
        "loc": loc,
    }


# Import deep curriculum (30–40 min lectures per topic)
from deep_curriculum.part01 import LESSONS as DEEP_P1A  # noqa: E402
from deep_curriculum.part01b import LESSONS as DEEP_P1B  # noqa: E402
from deep_curriculum.part02 import LESSONS as DEEP_P2  # noqa: E402
from deep_curriculum.part03 import LESSONS as DEEP_P3  # noqa: E402
from deep_curriculum.part04 import LESSONS as DEEP_P4  # noqa: E402

ALL_LESSONS = DEEP_P1A + DEEP_P1B + DEEP_P2 + DEEP_P3 + DEEP_P4


def export(lang: str) -> list:
    out = []
    for d in ALL_LESSONS:
        L = d["loc"][lang]
        mod = d["module"]
        out.append({
            "id": d["id"],
            "module": mod[0] if lang == "ru" else mod[1] if lang == "en" else mod[2],
            "title": L["title"],
            "subtitle": L["subtitle"],
            "difficulty": d["difficulty"],
            "durationMin": d["durationMin"],
            "outcome": L["outcome"],
            "content": L["content"],
            "takeaway": L["takeaway"],
            "sections": build_sections(lang, d),
        })
    return out


if __name__ == "__main__":
    for lang in ("ru", "en", "pt"):
        data = export(lang)
        path = ASSETS / f"lessons_{lang}.json"
        path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"{path.name}: {len(data)} lessons")
    full = ASSETS / "lessons_full.json"
    full.write_text(json.dumps(export("ru"), ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"lessons_full.json written")
