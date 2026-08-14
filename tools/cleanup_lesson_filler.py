#!/usr/bin/env python3
"""Phase 1: strip boilerplate filler from all lesson locales."""

from __future__ import annotations

import json
import re
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "assets" / "data"

FILLER_PATTERNS = [
    r"На практике это значит: примените идею этого урока на графике в терминале или на бирже — без сделки, только разметка\. Запишите в журнал одну мысль: что изменилось в понимании после урока\.",
    r"Представьте, что объясняете это другу за чашкой кофе: сначала простыми словами, потом пример с графика\.",
    r"Ошибка новичка — торопиться с первым депозитом\. Лучше три дня только наблюдать график и заполнять журнал без сделок, чем один вечер реванша после минуса\. Дисциплина ощущается скучно, пока не сравните счёт через три месяца\.",
    r"Ошибка новичка — торопиться с первым депозитом\. Лучше три дня только наблюдать график и заполнять журнал без сделок, чем один вечер реванша после минуса\.",
    r"Когда чувствуете FOMO — закройте терминал на 15 минут, выпейте воды, перечитайте чеклист урока\. Рынок откроется завтра; депозит может не пережить один импульсивный клик\.",
    r"Сравните с Finera и приложениями личных финансов: они про бюджет и сбережения, а Trade Master — про сетап на графике и честный журнал\. Это разные инструменты; не путайте учёт расходов с торговым планом на сегодня\.",
    r"Для закрепления перескажите блок вслух за 60 секунд\. Если путаетесь — вернитесь к разметке на истории за 30 дней, найдите два примера, где правило сработало, и один, где без правила был бы убыток\.",
    r"Если после блока остались вопросы — запишите их в журнал одной строкой и принесите на разбор в терминал или график биржи\. Обучение трейдингу — марафон: сегодняшний урок складывается с предыдущими \(стоп, R:R, структура, сессии\)\.",
    r"В РФ большинство учатся через Binance P2P и USDT-M фьючерсы: принципы риска 0\.5–1% на сделку одинаковы для спота и фьючерса\.",
    r"Помните: одна сделка ничего не доказывает\. Серия из 30–50 записей в журнале показывает, работает ли ваш процесс\.",
    r"Новичку важно не выучить термин наизусть, а увидеть на терминал или график биржи и записать в журнал Trade Master вход, стоп и цель до клика\. Цель курса — не «угадать монету», а торговать по плану с ограниченным риском\.",
    r"Профессионал тратит 20 минут на подготовку и 2 минуты на клик — не наоборот\.",
    r"Не гонитесь за «секретными индикаторами» из Telegram — повторяемый процесс важнее очередного платного курса-сигнала\.",
    r"На практике откройте символ урока на 15m и 4h: отметьте последний swing high и swing low — это база для стопов и целей\. Без разметки любая теория превращается в гадание\.",
    r"In practice, mark the chart first, then decide entry, stop, and target before any click\. Trade Master links each lesson to TradingView and a journal entry — not Telegram signal groups\.",
    r"Risk 0\.5–1% per trade applies on Binance spot and USDT-M futures alike\. Process beats one lucky trade\.",
    r"Open the lesson symbol on 15m and 4h; mark swing highs and lows — stops and targets start there\.",
    r"Compare with personal-finance apps: they track budgets; Trade Master tracks setups and an honest journal\.",
    r"When you feel FOMO — close the terminal for 15 minutes, drink water, reread the checklist\.",
]

CAPTION_BOILER = re.compile(
    r"^Смотрите пример: что отмечено на рисунке = идея блока\.\s*(Пример:\s*)?",
    re.I,
)
CAPTION_BOILER_EN = re.compile(
    r"^Look at the marked example — it matches this block\.\s*(Example:\s*)?",
    re.I,
)


def clean_text(text: str) -> str:
    t = text
    for pat in FILLER_PATTERNS:
        t = re.sub(pat, "", t, flags=re.I)
    # collapse leftover whitespace
    t = re.sub(r"\n{3,}", "\n\n", t)
    t = re.sub(r"[ \t]+\n", "\n", t)
    t = re.sub(r"\n[ \t]+", "\n", t)
    return t.strip()


def collapse_duplicate_charts(sections: list[dict]) -> list[dict]:
    """Keep first chart per chartType; drop later identical spam charts with boilerplate titles."""
    seen_types: set[str] = set()
    chart_count = 0
    out = []
    for s in sections:
        if s.get("type") != "chart":
            out.append(s)
            continue
        ct = s.get("chartType") or ""
        title = s.get("title") or ""
        is_spam_title = title.startswith("Пример:") or title.startswith("Example:") or title.startswith("Exemplo:")
        if chart_count >= 3 and is_spam_title:
            continue
        if ct in seen_types and is_spam_title:
            continue
        seen_types.add(ct)
        chart_count += 1
        cap = s.get("caption")
        if isinstance(cap, str):
            cap2 = CAPTION_BOILER.sub("", cap)
            cap2 = CAPTION_BOILER_EN.sub("", cap2).strip()
            if cap2:
                s = {**s, "caption": cap2}
        out.append(s)
    return out


def process_lesson(lesson: dict) -> bool:
    changed = False
    for key in ("content", "takeaway", "outcome"):
        v = lesson.get(key)
        if isinstance(v, str):
            c = clean_text(v)
            if c != v:
                lesson[key] = c
                changed = True
    secs = lesson.get("sections")
    if not isinstance(secs, list):
        return changed
    new_secs = []
    for s in secs:
        s2 = dict(s)
        if isinstance(s2.get("body"), str):
            c = clean_text(s2["body"])
            if c != s2["body"]:
                s2["body"] = c
                changed = True
        if isinstance(s2.get("caption"), str):
            cap = CAPTION_BOILER.sub("", s2["caption"])
            cap = CAPTION_BOILER_EN.sub("", cap).strip()
            if cap != s2["caption"]:
                s2["caption"] = cap
                changed = True
        # drop empty text sections after cleanup
        if s2.get("type") == "text" and not (s2.get("body") or "").strip():
            changed = True
            continue
        new_secs.append(s2)
    collapsed = collapse_duplicate_charts(new_secs)
    if collapsed != new_secs:
        changed = True
    lesson["sections"] = collapsed
    return changed


def main() -> None:
    for name in ("lessons_ru.json", "lessons_en.json", "lessons_pt.json"):
        path = DATA / name
        lessons = json.loads(path.read_text(encoding="utf-8"))
        n = sum(1 for les in lessons if process_lesson(les))
        path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"{name}: cleaned {n} lessons")


if __name__ == "__main__":
    main()
