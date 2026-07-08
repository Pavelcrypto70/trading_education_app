#!/usr/bin/env python3
"""Build 47-lesson practical crypto trading curriculum (RU / EN / PT)."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets" / "data"


def sec_heading(title):
    return {"type": "heading", "title": title}


def sec_text(body):
    return {"type": "text", "body": body}


def sec_chart(title, chart_type, caption):
    return {"type": "chart", "title": title, "chartType": chart_type, "caption": caption}


def sec_example(title, body):
    return {"type": "example", "title": title, "body": body}


def sec_bullets(title, items):
    return {"type": "bullets", "title": title, "items": items}


def sec_tip(body):
    return {"type": "tip", "title": "Практический совет", "body": body}


def sec_tip_en(body):
    return {"type": "tip", "title": "Practical tip", "body": body}


def sec_tip_pt(body):
    return {"type": "tip", "title": "Dica prática", "body": body}


def make_lesson(
    lid,
    module_ru,
    module_en,
    module_pt,
    chart,
    ru,
    en,
    pt,
):
    return {
        "id": lid,
        "module": {"ru": module_ru, "en": module_en, "pt": module_pt},
        "chart": chart,
        "ru": ru,
        "en": en,
        "pt": pt,
    }


# fmt: off
LESSONS = [
    make_lesson(
        1, "Введение", "Introduction", "Introdução", "price_chart",
        ru={
            "title": "Вводное. С чего начать в трейдинге? Часть 1",
            "subtitle": "Кто такой трейдер, спот, фьючерсы, биржа, терминалы",
            "difficulty": "Beginner",
            "durationMin": 25,
            "outcome": "Поймёте, что такое трейдинг, чем спот отличается от фьючерсов, как устроена биржа Binance и как безопасно пополнить счёт.",
            "content": "Трейдинг — это не «угадывание курса» и не казино. Это работа с вероятностями: вы ищете ситуации, где риск ограничен, а потенциал движения оправдывает вход.",
            "takeaway": "Трейдер зарабатывает на дисциплине и повторяемых ситуациях, а не на удаче.",
            "sections": [
                sec_heading("Кто такой трейдер"),
                sec_text(
                    "Трейдер — человек, который покупает и продаёт активы (криптовалюту, акции, валюту) с целью заработать на движении цены. "
                    "Он не инвестор на годы: горизонт — от секунд (скальпинг) до недель. Главный инструмент — график, стакан, риск-менеджмент.\n\n"
                    "Новичок часто путает трейдинг с азартом. Профессионал заранее знает: где вход, где стоп, где фиксация, сколько % депозита рискует."
                ),
                sec_heading("Спотовый рынок"),
                sec_text(
                    "Спот (spot) — покупка «настоящей» монеты. Купили BTC на споте — монета на балансе. Заработок только на росте (лонг). "
                    "Плечо обычно нет. Подходит для накопления и спокойной торговли без ликвидации."
                ),
                sec_heading("Фьючерсный рынок"),
                sec_text(
                    "Фьючерс (perpetual / USD-M на Binance) — контракт на разницу цен. Можно в шорт (заработать на падении). Есть плечо — и риск ликвидации. "
                    "Маржа блокируется на счёте фьючерсов. Большинство активных крипто-трейдеров работают именно здесь из-за гибкости."
                ),
                sec_heading("Торговые терминалы"),
                sec_text(
                    "Биржа (Binance, Bybit) — место исполнения ордеров. Терминал — интерфейс: TradingView, Tiger.Trade, Vataga, встроенный терминал биржи. "
                    "Терминал даёт стакан, быстрые кнопки, горячие клавиши, несколько графиков. Для скальпинга терминал критичен."
                ),
                sec_heading("Регистрация и пополнение Binance"),
                sec_text(
                    "1) Регистрация → верификация KYC.\n"
                    "2) Пополнение: P2P (покупка USDT у проверенного продавца за рубли/тенге) или карта где доступно.\n"
                    "3) Обменники — только проверенные; никогда не переводите по ссылке из «гарантированной» группы.\n"
                    "4) Первые деньги — на спот или перевод на фьючерсный кошелёк USDT-M."
                ),
                sec_chart("Спот vs фьючерс", "market_balance", "Спот — владеете активом. Фьючерс — торгуете контрактом с плечом и возможностью шорта."),
                sec_example(
                    "Практика",
                    "Депозит 500 USDT. На споте купили ETH — ждёте рост. На фьючерсе с плечом 5x открыли лонг ETH: при +2% прибыль ~10% от маржи, при -2% против вас — −10%. "
                    "Без стопа при сильном проливе возможна ликвидация. Вывод: фьючерс = инструмент, а не «ускоритель богатства».",
                ),
                sec_bullets("Запомнить", [
                    "Трейдинг — работа по правилам, а не ставки",
                    "Спот: монета на балансе, в основном лонг",
                    "Фьючерс: лонг и шорт, плечо, риск ликвидации",
                    "Терминал ускоряет работу; биржа исполняет сделки",
                    "P2P и KYC — стандартный безопасный путь пополнения",
                ]),
                sec_tip("Пройдите регистрацию и P2P в демо-режиме: откройте ордербук, посмотрите спот и фьючерс BTC — без реальной сделки."),
            ],
        },
        en={
            "title": "Intro. Where to start in trading? Part 1",
            "subtitle": "Trader role, spot, futures, exchange, terminals",
            "difficulty": "Beginner",
            "durationMin": 25,
            "outcome": "Understand what trading is, spot vs futures, Binance basics, and safe funding.",
            "content": "Trading is probability work with defined risk — not guessing.",
            "takeaway": "Traders earn through discipline and repeatable setups.",
            "sections": [],  # filled below
        },
        pt={
            "title": "Intro. Por onde começar no trading? Parte 1",
            "subtitle": "Trader, spot, futuros, exchange, terminais",
            "difficulty": "Beginner",
            "durationMin": 25,
            "outcome": "Entenda trading, spot vs futuros, Binance e depósito seguro.",
            "content": "Trading é trabalho com probabilidades e risco definido.",
            "takeaway": "Traders ganham com disciplina e setups repetíveis.",
            "sections": [],
        },
    ),
]
# fmt: on

# For EN/PT mirror RU section structure with translated headings where needed
def mirror_sections(ru_sections, lang):
    if lang == "en":
        replacements = {
            "Кто такой трейдер": "Who is a trader",
            "Спотовый рынок": "Spot market",
            "Фьючерсный рынок": "Futures market",
            "Торговые терминалы": "Trading terminals",
            "Регистрация и пополнение Binance": "Binance setup and funding",
            "Практика": "Practice",
            "Запомнить": "Remember",
            "Практический совет": "Practical tip",
        }
        tip_fn = sec_tip_en
    else:
        replacements = {
            "Кто такой трейдер": "Quem é o trader",
            "Спотовый рынок": "Mercado spot",
            "Фьючерсный рынок": "Mercado futuro",
            "Торговые терминалы": "Terminais de trading",
            "Регистрация и пополнение Binance": "Binance e depósito",
            "Практика": "Prática",
            "Запомнить": "Lembre",
            "Практический совет": "Dica prática",
        }
        tip_fn = sec_tip_pt

    out = []
    for s in ru_sections:
        c = dict(s)
        if c["type"] == "heading":
            c["title"] = replacements.get(c["title"], c["title"])
        elif c["type"] == "bullets":
            c["title"] = replacements.get(c["title"], c["title"])
        elif c["type"] == "example":
            c["title"] = replacements.get(c["title"], c["title"])
        elif c["type"] == "tip":
            c["title"] = "Practical tip" if lang == "en" else "Dica prática"
        out.append(c)
    return out


def export_locale(lessons, lang):
    result = []
    for L in lessons:
        data = L[lang]
        ru_secs = L["ru"]["sections"]
        sections = data["sections"] if data.get("sections") else mirror_sections(ru_secs, lang)
        result.append({
            "id": L["id"],
            "module": L["module"][lang] if isinstance(L["module"], dict) else L["module"],
            "title": data["title"],
            "subtitle": data["subtitle"],
            "difficulty": data["difficulty"],
            "durationMin": data["durationMin"],
            "outcome": data["outcome"],
            "content": data["content"],
            "takeaway": data["takeaway"],
            "sections": sections,
        })
    return result


if __name__ == "__main__":
    for lang in ("ru", "en", "pt"):
        path = ASSETS / f"lessons_{lang}.json"
        path.write_text(
            json.dumps(export_locale(LESSONS, lang), ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
        print(f"Wrote {path} ({len(LESSONS)} lessons)")
