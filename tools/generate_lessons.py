#!/usr/bin/env python3
"""Generate full lesson content for all 100 trading education lessons."""

import json
import re
from pathlib import Path

OUTPUT = Path(__file__).resolve().parent.parent / "assets" / "data" / "lessons_full.json"

CHART_MAP = {
    1: "market_balance", 2: "price_chart", 3: "candlestick", 4: "uptrend",
    5: "support_resistance", 6: "candlestick", 7: "breakout", 8: "pullback",
    9: "false_breakout", 10: "structure", 11: "risk_reward", 12: "risk_reward",
    13: "risk_reward", 14: "risk_reward", 15: "price_chart", 16: "price_chart",
    17: "price_chart", 18: "sideways", 19: "price_chart", 20: "price_chart",
    21: "uptrend", 22: "uptrend", 23: "reversal", 24: "breakout", 25: "price_chart",
    26: "order_flow", 27: "price_chart", 28: "order_flow", 29: "pullback",
    30: "risk_reward", 31: "price_chart", 32: "price_chart", 33: "price_chart",
    34: "price_chart", 35: "price_chart", 36: "structure", 37: "support_resistance",
    38: "uptrend", 39: "session_timeline", 40: "price_chart", 41: "momentum",
    42: "volume_bars", 43: "order_flow", 44: "order_flow", 45: "breakout",
    46: "range_trading", 47: "pullback", 48: "reversal", 49: "structure",
    50: "momentum", 51: "risk_reward", 52: "risk_reward", 53: "risk_reward",
    54: "risk_reward", 55: "risk_reward", 56: "price_chart", 57: "breakout",
    58: "sideways", 59: "price_chart", 60: "price_chart", 61: "uptrend",
    62: "support_resistance", 63: "pullback", 64: "risk_reward", 65: "price_chart",
    66: "structure", 67: "order_flow", 68: "price_chart", 69: "uptrend",
    70: "price_chart", 71: "price_chart", 72: "price_chart", 73: "price_chart",
    74: "price_chart", 75: "price_chart", 76: "uptrend", 77: "uptrend",
    78: "price_chart", 79: "sideways", 80: "uptrend", 81: "session_timeline",
    82: "momentum", 83: "momentum", 84: "correlation", 85: "risk_reward",
    86: "price_chart", 87: "price_chart", 88: "sideways", 89: "risk_reward",
    90: "price_chart", 91: "uptrend", 92: "price_chart", 93: "uptrend",
    94: "price_chart", 95: "price_chart", 96: "price_chart", 97: "uptrend",
    98: "price_chart", 99: "price_chart", 100: "structure",
}

CRYPTO_PAIRS = [
    "BTC/USDT", "ETH/USDT", "SOL/USDT", "BNB/USDT",
    "XRP/USDT", "ADA/USDT", "DOGE/USDT", "AVAX/USDT",
]

import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
from _lesson_data import LESSON_CONTENT as CONTENT


def parse_app_data():
    """Parse lesson metadata from app_data.dart."""
    dart_path = Path(__file__).resolve().parent.parent / "lib" / "data" / "app_data.dart"
    text = dart_path.read_text(encoding="utf-8")
    lessons = []
    blocks = re.findall(
        r"Lesson\(\s*id:\s*(\d+),\s*module:\s*'([^']+)',\s*title:\s*'([^']+)',\s*"
        r"subtitle:\s*'([^']+)',\s*difficulty:\s*'([^']+)',\s*durationMin:\s*(\d+),\s*"
        r"outcome:\s*'([^']+)',\s*content:\s*'([^']*)',\s*takeaway:\s*'([^']*)',",
        text,
        re.DOTALL,
    )
    for b in blocks:
        lessons.append({
            "id": int(b[0]),
            "module": b[1],
            "title": b[2],
            "subtitle": b[3],
            "difficulty": b[4],
            "durationMin": int(b[5]),
            "outcome_short": b[6],
            "content_short": b[7],
            "takeaway_short": b[8],
        })
    return lessons


def build_sections(lesson):
    lid = lesson["id"]
    title = lesson["title"]
    module = lesson["module"]
    custom = CONTENT.get(lid, {})

    intro = custom.get("intro", f"In this lesson we explore {title.lower()} — a core concept in {module.lower()} that every serious trader must understand deeply, not just memorize.")
    core = custom.get("core", f"{lesson['content_short']}\n\nUnderstanding {title.lower()} is essential because it connects directly to how you analyze charts, manage risk, and make decisions under pressure. Many traders know the definition but fail in practice because they skip the details.\n\nLet's break it down step by step so you can apply this concept on your next chart review.")
    chart_type = CHART_MAP.get(lid, "price_chart")
    pair = CRYPTO_PAIRS[(lid - 1) % len(CRYPTO_PAIRS)]

    sections = [
        {"type": "heading", "title": "Introduction"},
        {"type": "text", "body": intro},
        {"type": "heading", "title": "Core concept"},
        {"type": "text", "body": core},
    ]

    if chart_type:
        sections.extend([
            {"type": "heading", "title": "Chart example"},
            {
                "type": "chart",
                "title": custom.get("chart_title", f"{pair} — {title}"),
                "chartType": chart_type,
                "caption": custom.get(
                    "chart_caption",
                    f"This diagram shows the core idea of {title.lower()}. "
                    f"Read the labels on the chart and connect them to the lesson text above.",
                ),
            },
        ])

    sections.extend([
        {
            "type": "example",
            "title": "Practical scenario",
            "body": custom.get(
                "example",
                f"On Binance, {pair} shows conditions related to {title.lower()}. "
                f"Price consolidates near a key level while volume drops — a disciplined crypto trader "
                f"marks support, resistance, and waits for a clear break with volume before entering. "
                f"They set a stop below the last swing low and target 2R. "
                f"An impulsive trader FOMOs into a wick and gets stopped on the next candle. "
                f"The difference is preparation, not luck.",
            ),
        },
        {
            "type": "bullets",
            "title": "Key points to remember",
            "items": custom.get("bullets", [
                f"{title} is a foundational concept in {module}",
                "Always combine this idea with proper risk management",
                "Context matters — the same signal means different things in different market conditions",
                "Practice identifying this on historical charts before trading live",
                "Review your trades to see how well you applied this concept",
            ]),
        },
        {
            "type": "tip",
            "title": "Pro tip",
            "body": custom.get(
                "tip",
                f"When studying {title.lower()}, open a chart and find three real examples from the past month. "
                f"Mark them, write down what you see, and compare your analysis to what actually happened. "
                f"This active practice builds the pattern recognition that separates professionals from beginners.",
            ),
        },
    ])

    return sections


def enrich_outcome(lesson):
    custom = CONTENT.get(lesson["id"], {})
    if "outcome" in custom:
        return custom["outcome"]
    return (
        f"By the end of this lesson you will {lesson['outcome_short'].lower().rstrip('.')}, "
        f"understand how {lesson['title'].lower()} applies to real chart analysis, "
        f"and know the common mistakes traders make when applying this concept."
    )


def enrich_takeaway(lesson):
    custom = CONTENT.get(lesson["id"], {})
    if "takeaway" in custom:
        return custom["takeaway"]
    return (
        f"{lesson['takeaway_short']} "
        f"Apply this consistently in your {lesson['module'].lower()} workflow and your decisions will become clearer over time."
    )


def new_duration(lesson):
    base = lesson["durationMin"]
    if lesson["difficulty"] == "Advanced":
        return max(base + 8, 18)
    if lesson["difficulty"] == "Intermediate":
        return max(base + 6, 15)
    return max(base + 5, 12)


def main():
    lessons_meta = parse_app_data()
    output = []

    for meta in lessons_meta:
        sections = build_sections(meta)
        content_text = " ".join(
            s.get("body", "") for s in sections if s["type"] == "text"
        )[:500]

        output.append({
            "id": meta["id"],
            "module": meta["module"],
            "title": meta["title"],
            "subtitle": meta["subtitle"],
            "difficulty": meta["difficulty"],
            "durationMin": new_duration(meta),
            "outcome": enrich_outcome(meta),
            "content": content_text,
            "takeaway": enrich_takeaway(meta),
            "sections": sections,
        })

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding="utf-8")
    en_path = OUTPUT.parent / "lessons_en.json"
    en_path.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Generated {len(output)} lessons -> {OUTPUT}")
    print(f"File size: {OUTPUT.stat().st_size / 1024:.1f} KB")


if __name__ == "__main__":
    main()
