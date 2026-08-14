#!/usr/bin/env python3
"""Rewrite lesson 5 (order book) with clean text + Binance-style chart examples."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "assets" / "data"


def collapse_dups(text: str) -> str:
    import re

    parts = [p.strip() for p in re.split(r"\n\s*\n", text) if p.strip()]
    out, seen = [], set()
    for p in parts:
        key = " ".join(p.lower().split())
        if key in seen:
            continue
        seen.add(key)
        out.append(p)
    return "\n\n".join(out)


def clean_all_lessons(path: Path) -> int:
    lessons = json.loads(path.read_text(encoding="utf-8"))
    n = 0
    for les in lessons:
        for s in les.get("sections", []):
            body = s.get("body")
            if isinstance(body, str) and body.strip():
                clean = collapse_dups(body)
                if clean != body:
                    s["body"] = clean
                    n += 1
        for key in ("content", "takeaway"):
            val = les.get(key)
            if isinstance(val, str) and val.strip():
                clean = collapse_dups(val)
                if clean != val:
                    les[key] = clean
                    n += 1
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return n


LESSON_5 = {
    "ru": {
        "title": "Стакан. Подробно",
        "subtitle": "Как читать order book на Binance: bid, ask, спред, стены",
        "outcome": "Узнаете, как выглядит стакан Binance и что означают bid, ask, спред и стены.",
        "sections": [
            {"type": "heading", "title": "Как выглядит стакан на Binance"},
            {
                "type": "text",
                "body": "Стакан (Order Book) — очередь лимитных заявок.\n\nСверху красные ask — продавцы (цена от высокой к лучшей).\nСнизу зелёные bid — покупатели.\nПосередине — последняя цена и спред.\n\nГрафик = уже случившиеся сделки. Стакан = кто стоит в очереди прямо сейчас.",
            },
            {
                "type": "chart",
                "title": "Пример: стакан BTC/USDT как на Binance",
                "chartType": "order_book",
                "caption": "Ask сверху (красные), bid снизу (зелёные). Сделки идут в середине — где встречаются лучший ask и лучший bid.",
            },
            {"type": "heading", "title": "Bid, ask и спред"},
            {
                "type": "text",
                "body": "Лучший bid — самая высокая цена покупки.\nЛучший ask — самая низкая цена продажи.\nСпред = ask − bid.\n\nНа ликвидном BTC спред часто копейки. На тонком альте — проценты: маркет-вход сразу дорогой.",
            },
            {
                "type": "chart",
                "title": "Пример: широкий спред на альте",
                "chartType": "order_book_spread",
                "caption": "Жёлтая полоса — спред. Если он большой, рыночный ордер «прожжёт» несколько уровней стакана.",
            },
            {"type": "heading", "title": "Стена продавцов (ask wall)"},
            {
                "type": "text",
                "body": "Стена — очень крупный объём на одном уровне цены.\n\nAsk-стена = много продавцов в одном месте. Цена может упереться… или стену снимут до касания.\nПравило: не торгуйте только «от стены» — смотрите реакцию цены и ленту сделок.",
            },
            {
                "type": "chart",
                "title": "Пример: стена ask ~48 BTC",
                "chartType": "order_book_wall",
                "caption": "Золотая метка WALL — аномально большой объём. Это плотность, а не гарантия разворота.",
            },
            {"type": "heading", "title": "Стена покупателей (bid wall)"},
            {
                "type": "text",
                "body": "Bid-стена = крупный покупатель / группа покупок ниже цены.\nМожет удержать падение (поддержка в стакане) или исчезнуть, когда цена подойдёт.",
            },
            {
                "type": "chart",
                "title": "Пример: стена bid ~52 BTC",
                "chartType": "order_book_bid_wall",
                "caption": "Зелёная сторона с меткой WALL — покупатели стоят в очереди. Сверьте с графиком поддержки.",
            },
            {"type": "heading", "title": "Спуфинг — фейковая стена"},
            {
                "type": "text",
                "body": "Спуфинг: огромную лимитку ставят, рынок пугается, лимитку снимают до исполнения.\n\nПризнаки:\n• стена появилась внезапно и далеко от цены;\n• при подходе цены исчезает;\n• в ленте нет реальных сделок на этом уровне.\n\nНовичок не входит «потому что стена». Ждёт подтверждения.",
            },
            {
                "type": "chart",
                "title": "Пример: подозрительная стена (spoof?)",
                "chartType": "order_book_spoof",
                "caption": "Огромный объём далеко от mid-price + пустая лента = не вход. Ждите реакцию.",
            },
            {"type": "heading", "title": "Стакан + график"},
            {
                "type": "text",
                "body": "Рабочая связка:\n1) уровень на графике (15m);\n2) стакан у этого уровня (1m/5m);\n3) лента — реальные покупки/продажи.\n\nЕсли на графике поддержка, а в стакане давит ask — ждите. Не входите против стакана «потому что на картинке красиво».",
            },
            {
                "type": "chart",
                "title": "Ещё раз: читаемый стакан",
                "chartType": "order_book",
                "caption": "Перед скальпом: лучший bid/ask → спред → есть ли стена → что говорит лента.",
            },
            {"type": "heading", "title": "Итог"},
            {
                "type": "text",
                "body": "Запомните 4 вещи: bid / ask / спред / стены.\nПрактика без клика: откройте BTCUSDT на Binance Spot, 15 минут смотрите стакан и запишите спред + одну стену в журнал.",
            },
            {
                "type": "market_note",
                "title": "Ваш рынок",
                "body": "Перед скальпом обязателен взгляд на стакан BTC 5m — даже если торгуете альт.",
                "market": "ru",
            },
            {
                "type": "practice",
                "title": "Практика",
                "body": "20–30 минут. Без реальных сделок:",
                "items": [
                    "Откройте Binance Spot: BTC/USDT",
                    "Найдите лучший bid и лучший ask, запишите спред",
                    "Найдите одну крупную стену (если есть)",
                    "Наблюдайте 10 минут: стена держалась или сняли?",
                    "Скрин стакана + 1–2 предложения в журнал",
                ],
            },
            {
                "type": "example",
                "title": "Разбор сценария",
                "body": "На BTCUSDT: спред узкий, у 67205 ask-стена 48 BTC. Цена подходит — стена снимается. Это не сигнал шортить. Ждём ленту и реакцию свечи.",
            },
            {
                "type": "bullets",
                "title": "Запомнить",
                "items": [
                    "Ask сверху, bid снизу — как на Binance",
                    "Спред = цена входа маркетом",
                    "Стена ≠ сигнал",
                    "Спуфинг = стена без сделок",
                    "График + стакан + лента",
                ],
            },
            {
                "type": "journal",
                "title": "Журнал",
                "body": "Запишите после практики:",
                "items": ["Пара и время", "Спред в USDT и %", "Была ли стена / что с ней стало", "Эмоция до входа"],
            },
            {
                "type": "homework",
                "title": "Домашка",
                "body": "Тезисно в чат домашек:",
                "items": [
                    "Что такое bid, ask и спред своими словами",
                    "Чем стена отличается от обычного уровня",
                    "Что подозрительно в спуфинге",
                ],
            },
            {
                "type": "tip",
                "title": "Совет профи",
                "body": "Скрин стакана в журнал для скальп-идей обязателен. Без скрина — только догадка.",
            },
        ],
    },
    "en": {
        "title": "Order book in detail",
        "subtitle": "How to read Binance order book: bid, ask, spread, walls",
        "outcome": "You will recognize a Binance-style order book and what bid, ask, spread and walls mean.",
        "sections": [
            {"type": "heading", "title": "What the Binance order book looks like"},
            {
                "type": "text",
                "body": "The order book is a queue of limit orders.\n\nTop = red asks (sellers).\nBottom = green bids (buyers).\nMiddle = last price and spread.\n\nChart = trades that already happened. Book = who is waiting right now.",
            },
            {
                "type": "chart",
                "title": "Example: BTC/USDT book like Binance",
                "chartType": "order_book",
                "caption": "Asks on top (red), bids below (green). Trades happen in the middle.",
            },
            {"type": "heading", "title": "Bid, ask and spread"},
            {
                "type": "text",
                "body": "Best bid = highest buy price.\nBest ask = lowest sell price.\nSpread = ask − bid.\n\nOn liquid BTC the spread is tiny. On thin alts it can be large — market orders become expensive.",
            },
            {
                "type": "chart",
                "title": "Example: wide spread on an alt",
                "chartType": "order_book_spread",
                "caption": "Yellow band = spread. A market order can burn through several levels.",
            },
            {"type": "heading", "title": "Ask wall"},
            {
                "type": "text",
                "body": "A wall is a very large size on one price level.\n\nAn ask wall is heavy selling interest. Price may bounce… or the wall may cancel.\nRule: never trade only because of a wall — wait for tape and price reaction.",
            },
            {
                "type": "chart",
                "title": "Example: ask wall ~48 BTC",
                "chartType": "order_book_wall",
                "caption": "Gold WALL tag = abnormal size. Density, not a guaranteed reversal.",
            },
            {"type": "heading", "title": "Bid wall"},
            {
                "type": "text",
                "body": "A bid wall is large buy interest below price. It may hold a drop — or disappear when price approaches.",
            },
            {
                "type": "chart",
                "title": "Example: bid wall ~52 BTC",
                "chartType": "order_book_bid_wall",
                "caption": "Green side with WALL — stacked buyers. Cross-check with support on the chart.",
            },
            {"type": "heading", "title": "Spoofing — fake wall"},
            {
                "type": "text",
                "body": "Spoofing: place a huge limit, scare the market, cancel before fill.\n\nClues: wall appears far from mid, vanishes on approach, no prints on the tape.\nBeginners do not enter “because of the wall”.",
            },
            {
                "type": "chart",
                "title": "Example: suspicious wall (spoof?)",
                "chartType": "order_book_spoof",
                "caption": "Huge size far from mid + empty tape = wait, do not enter.",
            },
            {"type": "heading", "title": "Book + chart"},
            {
                "type": "text",
                "body": "Workflow: chart level (15m) → book at that level → tape confirmation.\nIf chart says support but asks are pressing — wait.",
            },
            {
                "type": "chart",
                "title": "Readable book checklist",
                "chartType": "order_book",
                "caption": "Best bid/ask → spread → any wall → what the tape shows.",
            },
            {"type": "heading", "title": "Takeaway"},
            {
                "type": "text",
                "body": "Remember four things: bid / ask / spread / walls.\nPractice: watch BTCUSDT book for 15 minutes and log spread + one wall.",
            },
            {
                "type": "practice",
                "title": "Practice",
                "body": "20–30 minutes. No live trades:",
                "items": [
                    "Open Binance Spot: BTC/USDT",
                    "Write best bid, best ask, spread",
                    "Find one large wall if present",
                    "Watch 10 minutes: did the wall hold or cancel?",
                    "Screenshot + note in journal",
                ],
            },
            {
                "type": "example",
                "title": "Scenario",
                "body": "Tight spread, ask wall at 67205 for 48 BTC. Price approaches — wall cancels. Not a blind short. Wait for tape + candle.",
            },
            {
                "type": "bullets",
                "title": "Remember",
                "items": [
                    "Asks top, bids bottom — Binance layout",
                    "Spread = market-entry cost",
                    "Wall ≠ signal",
                    "Spoof = wall without prints",
                    "Chart + book + tape",
                ],
            },
            {
                "type": "journal",
                "title": "Journal",
                "body": "After practice:",
                "items": ["Pair and time", "Spread USDT and %", "Wall behavior", "Emotion before entry"],
            },
            {
                "type": "homework",
                "title": "Homework",
                "body": "Write briefly:",
                "items": [
                    "Bid, ask, spread in your words",
                    "Wall vs normal level",
                    "What looks like spoofing",
                ],
            },
            {
                "type": "tip",
                "title": "Pro tip",
                "body": "For scalp ideas, a book screenshot in the journal is mandatory.",
            },
        ],
    },
    "pt": {
        "title": "Livro de ofertas em detalhe",
        "subtitle": "Como ler o order book da Binance: bid, ask, spread, paredes",
        "outcome": "Vai reconhecer o order book estilo Binance e o que significam bid, ask, spread e walls.",
        "sections": [
            {"type": "heading", "title": "Como parece o order book na Binance"},
            {
                "type": "text",
                "body": "O order book é a fila de ordens limitadas.\n\nEm cima = asks vermelhos (vendedores).\nEm baixo = bids verdes (compradores).\nNo meio = último preço e spread.\n\nGráfico = negociações já feitas. Book = quem espera agora.",
            },
            {
                "type": "chart",
                "title": "Exemplo: BTC/USDT como na Binance",
                "chartType": "order_book",
                "caption": "Asks em cima (vermelho), bids em baixo (verde). Os negócios acontecem no meio.",
            },
            {"type": "heading", "title": "Bid, ask e spread"},
            {
                "type": "text",
                "body": "Melhor bid = maior preço de compra.\nMelhor ask = menor preço de venda.\nSpread = ask − bid.\n\nNo BTC líquido o spread é mínimo. Em alt fina pode ser grande — market fica caro.",
            },
            {
                "type": "chart",
                "title": "Exemplo: spread largo num alt",
                "chartType": "order_book_spread",
                "caption": "Faixa amarela = spread. Uma ordem a mercado pode queimar vários níveis.",
            },
            {"type": "heading", "title": "Parede de ask"},
            {
                "type": "text",
                "body": "Wall = tamanho muito grande num nível.\n\nAsk wall = pressão de venda. O preço pode travar… ou a wall some.\nRegra: não opere só por causa da wall — espere tape e reação.",
            },
            {
                "type": "chart",
                "title": "Exemplo: ask wall ~48 BTC",
                "chartType": "order_book_wall",
                "caption": "Etiqueta WALL dourada = tamanho anormal. Densidade, não garantia de reversão.",
            },
            {"type": "heading", "title": "Parede de bid"},
            {
                "type": "text",
                "body": "Bid wall = compra grande abaixo do preço. Pode segurar a queda — ou desaparecer na aproximação.",
            },
            {
                "type": "chart",
                "title": "Exemplo: bid wall ~52 BTC",
                "chartType": "order_book_bid_wall",
                "caption": "Lado verde com WALL — compradores empilhados. Confirme com suporte no gráfico.",
            },
            {"type": "heading", "title": "Spoofing — wall falsa"},
            {
                "type": "text",
                "body": "Spoofing: colocam wall enorme, o mercado reage, cancelam antes de executar.\n\nSinais: wall longe do mid, some na aproximação, tape sem negócios.\nIniciante não entra “por causa da wall”.",
            },
            {
                "type": "chart",
                "title": "Exemplo: wall suspeita (spoof?)",
                "chartType": "order_book_spoof",
                "caption": "Tamanho enorme longe do mid + tape vazio = espere.",
            },
            {"type": "heading", "title": "Book + gráfico"},
            {
                "type": "text",
                "body": "Fluxo: nível no gráfico (15m) → book nesse nível → confirmação na tape.\nSe o gráfico diz suporte mas o ask pressiona — espere.",
            },
            {
                "type": "chart",
                "title": "Checklist do book",
                "chartType": "order_book",
                "caption": "Melhor bid/ask → spread → há wall? → o que a tape mostra.",
            },
            {"type": "heading", "title": "Resumo"},
            {
                "type": "text",
                "body": "Lembre 4 coisas: bid / ask / spread / walls.\nPrática: observe BTCUSDT 15 min e anote spread + uma wall.",
            },
            {
                "type": "practice",
                "title": "Prática",
                "body": "20–30 minutos. Sem trades reais:",
                "items": [
                    "Abra Binance Spot: BTC/USDT",
                    "Anote melhor bid, ask e spread",
                    "Ache uma wall grande se houver",
                    "Observe 10 min: manteve ou cancelou?",
                    "Print + nota no diário",
                ],
            },
            {
                "type": "example",
                "title": "Cenário",
                "body": "Spread apertado, ask wall em 67205 com 48 BTC. Preço chega — wall some. Não é short cego. Espere tape + candle.",
            },
            {
                "type": "bullets",
                "title": "Lembrar",
                "items": [
                    "Asks em cima, bids em baixo — layout Binance",
                    "Spread = custo do market",
                    "Wall ≠ sinal",
                    "Spoof = wall sem negócios",
                    "Gráfico + book + tape",
                ],
            },
            {
                "type": "journal",
                "title": "Diário",
                "body": "Depois da prática:",
                "items": ["Par e hora", "Spread USDT e %", "Comportamento da wall", "Emoção antes da entrada"],
            },
            {
                "type": "homework",
                "title": "Tarefa",
                "body": "Escreva em poucas linhas:",
                "items": [
                    "Bid, ask, spread com suas palavras",
                    "Wall vs nível normal",
                    "O que parece spoofing",
                ],
            },
            {
                "type": "tip",
                "title": "Dica pro",
                "body": "Para ideias de scalp, print do book no diário é obrigatório.",
            },
        ],
    },
}


def patch_lesson_5(path: Path, lang: str) -> None:
    lessons = json.loads(path.read_text(encoding="utf-8"))
    data = LESSON_5[lang]
    for les in lessons:
        if les.get("id") != 5:
            continue
        les["title"] = data["title"]
        les["subtitle"] = data["subtitle"]
        les["outcome"] = data["outcome"]
        # Keep module/prereqs/refs; replace teaching sections
        keep_prefix_types = set()  # rewrite fully
        # Preserve references block if present at lesson root
        les["sections"] = data["sections"]
        break
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main() -> None:
    files = {
        "ru": DATA / "lessons_ru.json",
        "en": DATA / "lessons_en.json",
        "pt": DATA / "lessons_pt.json",
    }
    for lang, path in files.items():
        n = clean_all_lessons(path)
        patch_lesson_5(path, lang)
        print(f"{path.name}: cleaned bodies≈{n}, lesson 5 rewritten")


if __name__ == "__main__":
    main()
