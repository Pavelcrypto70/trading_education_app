#!/usr/bin/env python3
"""Build lesson_content.py with all 100 lesson entries."""
from pathlib import Path

OUTPUT = Path(__file__).parent / "lesson_content.py"

LESSONS = [
    (1, "What is a market?", "Basics"),
    (2, "What is a chart?", "Basics"),
    (3, "Candlestick anatomy", "Basics"),
    (4, "Trends 101", "Basics"),
    (5, "Support and resistance", "Basics"),
    (6, "Price action basics", "Price Action"),
    (7, "Breakouts", "Price Action"),
    (8, "Pullbacks", "Price Action"),
    (9, "False breakouts", "Price Action"),
    (10, "Price structure", "Price Action"),
    (11, "Risk management basics", "Risk"),
    (12, "Position sizing", "Risk"),
    (13, "Stop loss placement", "Risk"),
    (14, "Risk to reward", "Risk"),
    (15, "Drawdown control", "Risk"),
    (16, "Trader discipline", "Psychology"),
    (17, "Fear and greed", "Psychology"),
    (18, "Patience in trading", "Psychology"),
    (19, "Dealing with losses", "Psychology"),
    (20, "Journaling trades", "Psychology"),
    (21, "What is a trading strategy?", "Strategy"),
    (22, "Trend following", "Strategy"),
    (23, "Mean reversion", "Strategy"),
    (24, "Breakout strategy", "Strategy"),
    (25, "Backtesting", "Strategy"),
    (26, "Order types", "Execution"),
    (27, "Slippage", "Execution"),
    (28, "Liquidity", "Execution"),
    (29, "Entry timing", "Execution"),
    (30, "Trade management", "Execution"),
    (31, "Trade review basics", "Review"),
    (32, "Identify mistakes", "Review"),
    (33, "Improving expectancy", "Review"),
    (34, "Consistency tracking", "Review"),
    (35, "Building a routine", "Review"),
    (36, "Advanced market structure", "Advanced"),
    (37, "Confluence", "Advanced"),
    (38, "Multi-timeframe analysis", "Advanced"),
    (39, "Market sessions", "Advanced"),
    (40, "Trading plan design", "Advanced"),
    (41, "What is volatility?", "Basics"),
    (42, "What is volume?", "Basics"),
    (43, "Market orders", "Basics"),
    (44, "Limit orders", "Basics"),
    (45, "Stop orders", "Basics"),
    (46, "Range trading", "Price Action"),
    (47, "Trend continuation", "Price Action"),
    (48, "Reversals", "Price Action"),
    (49, "Market swings", "Price Action"),
    (50, "Reading momentum", "Price Action"),
    (51, "Capital preservation", "Risk"),
    (52, "Daily loss limit", "Risk"),
    (53, "Scaling in", "Risk"),
    (54, "Scaling out", "Risk"),
    (55, "Breakeven stops", "Risk"),
    (56, "Confidence without arrogance", "Psychology"),
    (57, "Handling FOMO", "Psychology"),
    (58, "Overtrading", "Psychology"),
    (59, "Emotional recovery", "Psychology"),
    (60, "Building mental resilience", "Psychology"),
    (61, "Edge in trading", "Strategy"),
    (62, "Trade filters", "Strategy"),
    (63, "Entry confirmation", "Strategy"),
    (64, "Exit planning", "Strategy"),
    (65, "Trading edge review", "Strategy"),
    (66, "Market structure shift", "Execution"),
    (67, "Order flow basics", "Execution"),
    (68, "Using alerts", "Execution"),
    (69, "Screening setups", "Execution"),
    (70, "Trade checklist", "Execution"),
    (71, "Post-trade analysis", "Review"),
    (72, "Tracking win rate", "Review"),
    (73, "Tracking expectancy", "Review"),
    (74, "Common trading mistakes", "Review"),
    (75, "Improvement loops", "Review"),
    (76, "Market context", "Advanced"),
    (77, "False confidence", "Advanced"),
    (78, "Scaling a strategy", "Advanced"),
    (79, "Adaptive thinking", "Advanced"),
    (80, "Long-term progression", "Advanced"),
    (81, "Session volatility", "Advanced"),
    (82, "Market open behavior", "Advanced"),
    (83, "News impact", "Advanced"),
    (84, "Correlation", "Advanced"),
    (85, "Portfolio thinking", "Advanced"),
    (86, "Repeatable process", "Advanced"),
    (87, "Decision fatigue", "Advanced"),
    (88, "Trading environment", "Advanced"),
    (89, "Risk allocation", "Advanced"),
    (90, "Reviewing performance", "Advanced"),
    (91, "Building conviction", "Advanced"),
    (92, "Avoiding revenge trading", "Advanced"),
    (93, "Simple systems", "Advanced"),
    (94, "Strategy refinement", "Advanced"),
    (95, "Long sample testing", "Advanced"),
    (96, "Behavior under pressure", "Advanced"),
    (97, "System confidence", "Advanced"),
    (98, "Avoiding overoptimization", "Advanced"),
    (99, "Trader mindset", "Advanced"),
    (100, "Putting it all together", "Advanced"),
]

# Content will be loaded from companion data file
exec((Path(__file__).parent / "_lesson_data.py").read_text(encoding="utf-8"))

def format_entry(e):
    lines = [f"    {e['id']}: {{"]
    for key in ("outcome", "intro", "core", "chart_title", "chart_caption", "example", "tip", "takeaway"):
        val = e[key].replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'        "{key}": "{val}",')
    lines.append('        "bullets": [')
    for b in e["bullets"]:
        besc = b.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'            "{besc}",')
    lines.append("        ],")
    lines.append("    },")
    return "\n".join(lines)

header = '''"""Rich educational content for all 100 trading lessons."""

LESSON_CONTENT = {
'''

footer = "}\n"

body = "\n".join(format_entry(LESSON_CONTENT[eid]) for eid in sorted(LESSON_CONTENT))
OUTPUT.write_text(header + body + footer, encoding="utf-8")
print(f"Wrote {OUTPUT} ({len(OUTPUT.read_text(encoding='utf-8').splitlines())} lines)")
