#!/usr/bin/env python3
"""Generate lib/data/lesson_media.dart with per-lesson YouTube videos."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
from upgrade_all_lessons import VIDEO_BY_LESSON  # noqa: E402

DATA = ROOT / "assets" / "data"
OUT = ROOT / "lib" / "data" / "lesson_media.dart"

TITLE_EN = {
    1: "Getting Started — Part 1",
    2: "Getting Started — Part 2",
    3: "Price Amplitude",
    4: "Support at Swing Lows",
    5: "Order Book Deep Dive",
    6: "Fast vs Slow Market",
    7: "Beginner Mistakes — Part 1",
    8: "Descending Triangle",
    9: "Ascending Triangle",
    10: "Impulse Trading Strategy",
    11: "Delisting",
    12: "Listing",
    13: "Price Channels",
    14: "Uptrend HH/HL",
    15: "Downtrend LH/LL",
    16: "Indicators MA RSI",
    17: "FOMC Trading Rules",
    18: "Risk 0.5–1% per Trade",
    19: "Symmetric Triangle",
    20: "Meme Coins Momentum",
    21: "Hold to Target",
    22: "Order Flow",
    23: "Entry Plan R:R",
    24: "Market Cycles",
    25: "Altseason",
    26: "BTC Intraday Chart",
    27: "BTC Dump Situations",
    28: "Recovery After Drawdown",
    29: "Marathon Reversals",
    30: "Marathon Day 3",
    31: "Averaging",
    32: "Trend Change",
    33: "Trade Journal Review",
    34: "FOMC Meeting",
    35: "Scam Signal Groups",
    36: "Exchange Transfers",
    37: "API Connection",
    38: "Trading at Work vs Home",
    39: "Futures Basics",
    40: "Mistakes Part 2",
    41: "Useful Apps",
    42: "Trader Morning Routine",
    43: "Fibonacci Levels",
    44: "Airdrop Pre-market",
    45: "Candles Part 2",
    46: "Head & Shoulders Part 1",
    47: "Head & Shoulders Part 2",
}


def main() -> None:
    with open(DATA / "lessons_ru.json", encoding="utf-8") as f:
        lessons = {L["id"]: L["title"] for L in json.load(f)}

    lines = [
        "import '../services/locale_service.dart';",
        "",
        "/// Curated educational videos per module.",
        "class LessonMediaEntry {",
        "  final String titleRu;",
        "  final String titleEn;",
        "  final String titlePt;",
        "  final String url;",
        "  final String thumbnail;",
        "",
        "  const LessonMediaEntry({",
        "    required this.titleRu,",
        "    required this.titleEn,",
        "    required this.titlePt,",
        "    required this.url,",
        "    required this.thumbnail,",
        "  });",
        "",
        "  String titleFor(String lang) {",
        "    switch (lang) {",
        "      case 'ru': return titleRu;",
        "      case 'pt': return titlePt;",
        "      default: return titleEn;",
        "    }",
        "  }",
        "}",
        "",
        "class LessonMedia {",
        "  static const _byModule = <String, LessonMediaEntry>{",
        "    'intro': LessonMediaEntry(",
        "      titleRu: 'Вводный курс',",
        "      titleEn: 'Intro course',",
        "      titlePt: 'Curso introdutório',",
        "      url: 'https://www.youtube.com/watch?v=2ki-YF1heeE',",
        "      thumbnail: 'https://img.youtube.com/vi/2ki-YF1heeE/hqdefault.jpg',",
        "    ),",
        "  };",
        "",
        "  static LessonMediaEntry? forModule(String module) =>",
        "      _byModule[_normalizeModule(module)];",
        "",
        "  static String _normalizeModule(String module) {",
        "    final m = module.toLowerCase();",
        "    if (m.contains('введ') || m.contains('intro')) return 'intro';",
        "    return 'intro';",
        "  }",
        "",
        "  static const _byLesson = <int, LessonMediaEntry>{",
    ]

    for lid in sorted(VIDEO_BY_LESSON.keys()):
        entry = VIDEO_BY_LESSON[lid]
        if not entry:
            continue
        vid, _ = entry
        ru = lessons.get(lid, f"Урок {lid}").replace("'", "\\'")
        en = TITLE_EN.get(lid, f"Lesson {lid}").replace("'", "\\'")
        pt = en
        lines.append(f"    {lid}: LessonMediaEntry(")
        lines.append(f"      titleRu: '{ru}',")
        lines.append(f"      titleEn: '{en}',")
        lines.append(f"      titlePt: '{pt}',")
        lines.append(f"      url: 'https://www.youtube.com/watch?v={vid}',")
        lines.append(f"      thumbnail: 'https://img.youtube.com/vi/{vid}/hqdefault.jpg',")
        lines.append("    ),")

    lines += [
        "  };",
        "",
        "  static LessonMediaEntry? forLesson(int lessonId, String module) {",
        "    return _byLesson[lessonId] ?? forModule(module);",
        "  }",
        "",
        "  static String localizedTitle(LessonMediaEntry entry) {",
        "    return entry.titleFor(LocaleService.instance.languageCode);",
        "  }",
        "}",
        "",
    ]

    OUT.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote {OUT}")


if __name__ == "__main__":
    main()
