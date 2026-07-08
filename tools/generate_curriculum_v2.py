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

    sections = [
        {"type": "heading", "title": L["h1"]},
        {"type": "text", "body": L["theory"]},
        {"type": "heading", "title": L["h2"]},
        {"type": "text", "body": L["theory2"]},
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
    ]
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


# ─── LESSON 1 ───────────────────────────────────────────────────────────────
L01_MARKETS = {
    "br": "No Brasil, 90%+ dos traders ativos usam Binance ou Bybit com PIX para depositar USDT. "
          "Comece com spot para entender ordens; depois migre para futuros USDT-M. "
          "Evite grupos de 'sinais VIP' no Telegram — golpe #1 em LATAM.",
    "mx": "En México muchos entran por P2P USDT y Mercado Pago. Binance y Bitso son comunes. "
          "Regla CNBV: educación sí, asesoría personalizada no sin licencia.",
    "ru": "В РФ основной путь — P2P USDT на Binance после KYC. "
          "Спот для старта, фьючерсы USDT-M для активной торговли. "
          "Не переводите крипту по ссылкам из «гарант-чатов».",
    "global": "Trade Master teaches setup-first trading: plan before click, journal after every session.",
}

L01 = lesson(
    1,
    ("Введение", "Introduction", "Introdução"),
    "Beginner",
    28,
    "market_balance",
    "BINANCE:BTCUSDT",
    "15",
    L01_MARKETS,
    {
        "ru": {
            "title": "Вводное. С чего начать в трейдинге? Часть 1",
            "subtitle": "Кто такой трейдер, спот, фьючерсы, Binance, P2P",
            "outcome": "Поймёте разницу спот/фьючерс, роль трейдера и безопасный старт на бирже.",
            "content": "Трейдинг — работа с вероятностями и риском, а не казино.",
            "takeaway": "Трейдер зарабатывает дисциплиной и повторяемыми сетапами.",
            "h1": "Кто такой трейдер",
            "theory": "Трейдер покупает и продаёт активы, чтобы заработать на движении цены. "
                      "Горизонт — от секунд до недель. Главные инструменты: график, стакан, риск на сделку.\n\n"
                      "Профессионал до клика знает: вход, стоп, цель, % риска. Любитель жмёт «в рынок» и надеется.",
            "h2": "Спот и фьючерсы",
            "theory2": "Спот — покупаете монету на баланс. Заработок в основном на росте.\n\n"
                       "Фьючерс USDT-M — контракт с плечом. Можно шорт. Есть ликвидация. "
                       "Терминалы (Tiger, Vataga, TradingView) ускоряют работу со стаканом.",
            "market_title": "Ваш рынок",
            "chart_title": "Спот vs фьючерс",
            "chart_cap": "Спот — владение активом. Фьючерс — контракт с плечом и шортом.",
            "tv_title": "Разбор: интерфейс Binance + TradingView",
            "tv_body": "Откройте график BTC. Найдите переключатель Spot/Futures. "
                       "Отметьте последний swing high/low — это база для всех уроков курса.",
            "practice_title": "Практика без риска",
            "practice_intro": "15 минут — только наблюдение:",
            "practice_steps": [
                "Зарегистрируйтесь на Binance (или откройте демо-аккаунт TradingView).",
                "Откройте BTC/USDT спот и фьючерс — сравните цену и funding.",
                "В TradingView добавьте горизонталь на вчерашний high и low.",
                "Запишите: где бы вы поставили стоп, если бы вошли в лонг?",
            ],
            "example_title": "Сценарий",
            "example": "Депозит 500 USDT. На фьючерсе 5x лонг ETH: +2% = +10% к марже, −2% = −10%. "
                       "Без стопа при проливе — ликвидация. Вывод: плечо — инструмент, не «ускоритель».",
            "bullets_title": "Запомнить",
            "bullets": [
                "Трейдинг = правила + вероятности",
                "Спот: монета на балансе",
                "Фьючерс: лонг/шорт, плечо, ликвидация",
                "P2P + KYC — стандартный путь пополнения",
                "Trade Master ≠ сигналы, это обучение сетапам",
            ],
            "journal_title": "Запись в журнал",
            "journal_body": "После урока зафиксируйте:",
            "journal_items": [
                "Биржа и тип счёта (спот/фьючерс)",
                "Размер депозита и % риска на сделку (цель 0.5–1%)",
                "Один вопрос, который остался непонятным",
            ],
            "tip_title": "Совет профи",
            "tip": "Пройдите KYC и P2P без сделок — сначала изучите интерфейс. "
                   "Конкуренты дают теорию; Trade Master даёт разбор графика в TradingView.",
        },
        "en": {
            "title": "Intro: Where to start in trading? Part 1",
            "subtitle": "Trader role, spot, futures, Binance, P2P",
            "outcome": "Understand spot vs futures and how to start safely on exchange.",
            "content": "Trading is probability work with defined risk.",
            "takeaway": "Traders earn through discipline and repeatable setups.",
            "h1": "Who is a trader",
            "theory": "A trader buys and sells assets to profit from price moves. "
                      "Horizon: seconds to weeks. Tools: chart, order book, risk per trade.\n\n"
                      "Pros know entry, stop, target before clicking. Amateurs hope.",
            "h2": "Spot vs futures",
            "theory2": "Spot = you own the coin. Futures USDT-M = contract with leverage, shorts, liquidation risk.\n\n"
                       "Terminals (TradingView, exchange UI) speed up execution.",
            "market_title": "Your market (Mexico / LATAM)",
            "chart_title": "Spot vs futures",
            "chart_cap": "Spot = ownership. Futures = leveraged contract.",
            "tv_title": "TradingView: Binance BTC setup",
            "tv_body": "Open BTC chart. Mark yesterday's high/low. Compare spot vs futures price.",
            "practice_title": "Hands-on practice",
            "practice_intro": "15 minutes observation only:",
            "practice_steps": [
                "Open Binance or TradingView paper account.",
                "Compare BTC spot vs perpetual futures price.",
                "Draw horizontal lines on yesterday high/low.",
                "Write where your stop would be for a long.",
            ],
            "example_title": "Scenario",
            "example": "500 USDT, 5x long ETH: +2% = +10% on margin. No stop = liquidation risk on dump.",
            "bullets_title": "Remember",
            "bullets": [
                "Trading = rules + probabilities",
                "Spot = coin on balance",
                "Futures = long/short + leverage",
                "P2P + KYC for funding in LATAM",
                "Trade Master teaches setups, not signals",
            ],
            "journal_title": "Trade journal",
            "journal_body": "Record after lesson:",
            "journal_items": [
                "Exchange and account type",
                "Deposit size and risk % per trade",
                "One open question",
            ],
            "tip_title": "Pro tip",
            "tip": "Explore the UI before first trade. Finera teaches savings — we teach chart setups with TradingView.",
        },
        "pt": {
            "title": "Intro: Por onde começar no trading? Parte 1",
            "subtitle": "Trader, spot, futuros, Binance, PIX/P2P",
            "outcome": "Entenda spot vs futuros e início seguro na exchange.",
            "content": "Trading é trabalho com probabilidades e risco definido.",
            "takeaway": "Traders ganham com disciplina e setups repetíveis.",
            "h1": "Quem é o trader",
            "theory": "Trader compra e vende ativos para lucrar com movimento. "
                      "Ferramentas: gráfico, book, risco por trade.\n\n"
                      "Profissional sabe entrada, stop e alvo antes do clique.",
            "h2": "Spot vs futuros",
            "theory2": "Spot = você possui a moeda. Futuros USDT-M = contrato com alavancagem e risco de liquidação.\n\n"
                       "No Brasil, PIX + P2P é o caminho mais usado para USDT.",
            "market_title": "Seu mercado (Brasil)",
            "chart_title": "Spot vs futuros",
            "chart_cap": "Spot = posse. Futuros = contrato alavancado.",
            "tv_title": "TradingView: setup BTC Binance",
            "tv_body": "Abra BTC. Marque máxima/mínima de ontem. Compare spot vs futuro perpétuo.",
            "practice_title": "Prática guiada",
            "practice_intro": "15 minutos só observando:",
            "practice_steps": [
                "Abra Binance ou conta demo TradingView.",
                "Compare preço spot vs futuro BTC.",
                "Desenhe linhas no high/low de ontem.",
                "Anote onde ficaria seu stop no long.",
            ],
            "example_title": "Cenário",
            "example": "500 USDT, long 5x em ETH: +2% = +10% na margem. Sem stop = risco de liquidação.",
            "bullets_title": "Lembre",
            "bullets": [
                "Trading = regras + probabilidades",
                "Spot = moeda na carteira",
                "Futuros = long/short + alavancagem",
                "PIX + P2P no Brasil",
                "Trade Master ensina setups, não sinais",
            ],
            "journal_title": "Diário",
            "journal_body": "Registre após a lição:",
            "journal_items": [
                "Exchange e tipo de conta",
                "Depósito e % de risco por trade",
                "Uma dúvida em aberto",
            ],
            "tip_title": "Dica profissional",
            "tip": "Explore a interface antes do primeiro trade. Finera foca finanças pessoais — nós focamos setups no TradingView.",
        },
    },
)

# Import remaining lessons from data file
from curriculum_lessons_data import LESSONS_DATA  # noqa: E402

ALL_LESSONS = [L01] + LESSONS_DATA


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
