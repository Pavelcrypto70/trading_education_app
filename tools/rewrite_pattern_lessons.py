#!/usr/bin/env python3
"""Rewrite pattern lessons 8, 9, 19, 46, 47 — correct geometry + numerical examples."""

from __future__ import annotations

import json
from copy import deepcopy
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "assets" / "data"

COMMON_PRACTICE = {
    "ru": {
        "type": "practice",
        "title": "Практика",
        "body": "30–40 минут. Без реальных сделок:",
        "items": [
            "Откройте график пары урока на 15m или 1H.",
            "Найдите историю с этой фигурой за 30–90 дней (или ближайший аналог).",
            "Нарисуйте границы фигуры и линию пробоя.",
            "Запишите вход / стоп / цель и R:R без сделки.",
            "Скрин с подписями — в журнал.",
        ],
    },
    "en": {
        "type": "practice",
        "title": "Practice",
        "body": "30–40 minutes. No live trades:",
        "items": [
            "Open the lesson pair on 15m or 1H.",
            "Find this pattern in the last 30–90 days (or the closest analogue).",
            "Draw the pattern borders and the breakout line.",
            "Write entry / stop / target and R:R without placing a trade.",
            "Screenshot with labels → journal.",
        ],
    },
    "pt": {
        "type": "practice",
        "title": "Prática",
        "body": "30–40 minutos. Sem trades reais:",
        "items": [
            "Abra o par da aula em 15m ou 1H.",
            "Ache a figura nos últimos 30–90 dias (ou o análogo mais próximo).",
            "Desenhe as bordas e a linha de rompimento.",
            "Anote entrada / stop / alvo e R:R sem clicar.",
            "Print com legendas → diário.",
        ],
    },
}

COMMON_JOURNAL = {
    "ru": {
        "type": "journal",
        "title": "Журнал",
        "body": "После практики запишите:",
        "items": ["Пара и ТФ", "Границы фигуры", "Вход / стоп / цель", "R:R и эмоция до входа"],
    },
    "en": {
        "type": "journal",
        "title": "Journal",
        "body": "After practice, log:",
        "items": ["Pair and TF", "Pattern borders", "Entry / stop / target", "R:R and emotion before entry"],
    },
    "pt": {
        "type": "journal",
        "title": "Diário",
        "body": "Depois da prática, registre:",
        "items": ["Par e TF", "Bordas da figura", "Entrada / stop / alvo", "R:R e emoção antes da entrada"],
    },
}

COMMON_HW = {
    "ru": {
        "type": "homework",
        "title": "Домашка: тезисы фигуры",
        "body": "В чат домашек Telegram — только текст: как выглядит фигура, где вход/стоп/цель, одна ошибка новичков.",
        "items": [
            "Геометрия своими словами (3–5 тезисов)",
            "Ваш план вход/стоп/цель с цифрами",
            "Одна ошибка, которую больше не повторите",
        ],
    },
    "en": {
        "type": "homework",
        "title": "Homework: pattern thesis",
        "body": "Telegram homework chat — text only: shape, entry/stop/target, one beginner mistake.",
        "items": [
            "Geometry in your words (3–5 bullets)",
            "Your entry/stop/target plan with numbers",
            "One mistake you will not repeat",
        ],
    },
    "pt": {
        "type": "homework",
        "title": "Tarefa: tese da figura",
        "body": "No chat de tarefas do Telegram — só texto: forma, entrada/stop/alvo, um erro de iniciante.",
        "items": [
            "Geometria com suas palavras (3–5 tópicos)",
            "Seu plano entrada/stop/alvo com números",
            "Um erro que você não vai repetir",
        ],
    },
}


def refs():
    return [
        {
            "title": "Technical Analysis of the Financial Markets",
            "author": "John J. Murphy",
            "year": 1999,
            "url": "https://www.investopedia.com/terms/t/technicalanalysis.asp",
            "type": "book",
        },
        {
            "title": "TradingView Charting Basics",
            "author": "TradingView",
            "year": 2024,
            "url": "https://www.tradingview.com/support/",
            "type": "documentation",
        },
    ]


def meta(lang: str, outcomes: list[str]):
    keys = {
        "ru": [
            "Объяснить ключевую идею урока своими словами",
            "Разметить сетап на графике биржи без входа в сделку",
            "Записать в журнал вход, стоп, цель и риск в % депозита",
        ],
        "en": [
            "Explain the lesson core idea in your own words",
            "Mark the setup on the exchange chart without entering a live trade",
            "Log entry, stop, target and risk % in the journal",
        ],
        "pt": [
            "Explicar a ideia central da aula com suas palavras",
            "Marcar o setup no gráfico da exchange sem entrar no trade",
            "Registrar no diário entrada, stop, alvo e risco % do depósito",
        ],
    }
    return keys[lang]


LESSONS = {
    8: {
        "module": {"ru": "Паттерны", "en": "Patterns", "pt": "Padrões"},
        "title": {
            "ru": "Нисходящий треугольник",
            "en": "Descending triangle",
            "pt": "Triângulo descendente",
        },
        "subtitle": {
            "ru": "Горизонтальная поддержка + понижающиеся максимумы",
            "en": "Flat support + lower highs",
            "pt": "Suporte horizontal + máximas descendentes",
        },
        "difficulty": "Intermediate",
        "durationMin": 22,
        "outcome": {
            "ru": "Узнаете нисходящий треугольник, посчитаете measured move и отличите его от клина.",
            "en": "Spot a descending triangle, compute the measured move, and not confuse it with a wedge.",
            "pt": "Reconhecer o triângulo descendente, calcular o measured move e não confundir com cunha.",
        },
        "content": {
            "ru": "Нисходящий треугольник: сжатие к горизонтальной поддержке перед чаще медвежьим пробоем.",
            "en": "Descending triangle: compression into flat support, often before a bearish break.",
            "pt": "Triângulo descendente: compressão contra suporte flat, muitas vezes antes de rompimento de baixa.",
        },
        "takeaway": {
            "ru": "Шорт только после close ниже поддержки (часто + ретест). Не из середины треугольника.",
            "en": "Short only after a close below support (often + retest). Never from mid-triangle.",
            "pt": "Short só após close abaixo do suporte (muitas vezes + reteste). Nunca do meio do triângulo.",
        },
        "prerequisites": [4, 14, 15],
        "sections": {
            "ru": [
                {"type": "heading", "title": "Что за фигура"},
                {
                    "type": "text",
                    "body": "Нисходящий треугольник — сжатие цены:\n• снизу почти горизонтальная поддержка (зона, не «идеальная линия»);\n• сверху ряд lower highs — максимумы всё ниже.\n\nПокупатели слабее отталкивают цену вверх, продавцы давят раньше. Часто это продолжение нисходящего тренда, но торгуем только сторону подтверждённого пробоя.\n\nНе путайте с нисходящим клином: у клина обе границы наклонены вниз; у треугольника пол — плоский.",
                },
                {
                    "type": "chart",
                    "title": "Анимация фигуры",
                    "chartType": "pattern_desc_triangle",
                    "caption": "Плоская поддержка + descending highs. Пробой — вниз за пол.",
                },
                {"type": "heading", "title": "Как узнать на графике"},
                {
                    "type": "text",
                    "body": "На одном ТФ (SOLUSDT / BTCUSDT 15m или 1H):\n1) ≥3 касания одной зоны поддержки;\n2) ≥3 понижающихся максимума;\n3) сжатие обычно 12–30+ свечей — не «три свечи и треугольник».\n\nВнутри дня на крипте сначала смотрите контекст BTC: сильный импульс вверх снижает шанс чистого шорта альта.",
                },
                {
                    "type": "chart",
                    "title": "Пример на свечах",
                    "chartType": "breakout",
                    "caption": "Касания поддержки ~100, lower highs 108→105→103→102, пробой, ретест, цель 92.",
                },
                {"type": "heading", "title": "Вход, стоп, цель"},
                {
                    "type": "text",
                    "body": "Триггер: закрытие свечи рабочего ТФ ниже поддержки, лучше с объёмом ≥1.5× среднего.\nВход: на пробое (агрессивно) или на ретесте снизу (консервативно).\nСтоп: над ретестом или над последним lower high внутри фигуры.\nЦель (measured move): высота фигуры H = highest high − поддержка; от точки пробоя вниз отложите H.\nРиск 0.5–1% депозита; размер позиции из стопа.",
                },
                {
                    "type": "chart",
                    "title": "Пробой + ретест + цель",
                    "chartType": "pattern_desc_triangle",
                    "caption": "Схема: где вход, стоп за фигурой и measured move вниз.",
                },
                {"type": "heading", "title": "Частые ошибки"},
                {
                    "type": "text",
                    "body": "• Шорт из середины «потому что похоже» — нет edge.\n• Путать треугольник с клином.\n• Игнорировать BTC: памп биткоина часто убивает шорт альта.\n• Шортить тень ниже поддержки без close — ложный пробой / стоп-хант.",
                },
                {
                    "type": "example",
                    "title": "Сценарий с цифрами (без клика)",
                    "body": "SOLUSDT 15m.\nПоддержка: 100 (3+ касания).\nМаксимумы: 108 → 105 → 103 → 102.\nH = 108 − 100 = 8.\nClose ниже 100 → шорт; стоп 102.5 (над последним LH); цель 100 − 8 = 92.\nРиск на сделку 0.7% депозита. Сначала разметка и журнал — клик только если план совпал.",
                },
                {
                    "type": "bullets",
                    "title": "Запомнить",
                    "items": [
                        "Пол горизонтальный, highs ↓",
                        "Это треугольник, не клин",
                        "Вход после close ниже поддержки",
                        "Цель = H от пробоя вниз",
                        "Риск 0.5–1%, контекст BTC",
                    ],
                },
            ],
            "en": [
                {"type": "heading", "title": "What the pattern is"},
                {
                    "type": "text",
                    "body": "A descending triangle is compression:\n• nearly flat support below (a zone, not a perfect line);\n• a sequence of lower highs above.\n\nBuyers bounce weaker; sellers press earlier. Often a bearish continuation — but you only trade the confirmed breakout side.\n\nDo not confuse with a falling wedge: a wedge has both borders sloping down; a descending triangle has a flat floor.",
                },
                {
                    "type": "chart",
                    "title": "Pattern animation",
                    "chartType": "pattern_desc_triangle",
                    "caption": "Flat support + descending highs. Break is down through the floor.",
                },
                {"type": "heading", "title": "How to spot it"},
                {
                    "type": "text",
                    "body": "On one TF (SOLUSDT / BTCUSDT 15m or 1H):\n1) ≥3 touches of the same support zone;\n2) ≥3 lower highs;\n3) compression usually 12–30+ candles — not a 3-candle sketch.\n\nIntraday crypto: check BTC first — a strong bitcoin pump weakens alt shorts.",
                },
                {
                    "type": "chart",
                    "title": "Candlestick example",
                    "chartType": "breakout",
                    "caption": "Support touches ~100, lower highs 108→105→103→102, break, retest, target 92.",
                },
                {"type": "heading", "title": "Entry, stop, target"},
                {
                    "type": "text",
                    "body": "Trigger: working-TF candle close below support, ideally volume ≥1.5× average.\nEntry: on break (aggressive) or retest from below (conservative).\nStop: above the retest or last lower high inside the pattern.\nTarget (measured move): H = highest high − support; project H down from the breakout.\nRisk 0.5–1% of equity; size from the stop distance.",
                },
                {
                    "type": "chart",
                    "title": "Break + retest + target",
                    "chartType": "pattern_desc_triangle",
                    "caption": "Schematic: entry, stop beyond the pattern, measured move down.",
                },
                {"type": "heading", "title": "Common mistakes"},
                {
                    "type": "text",
                    "body": "• Shorting mid-pattern “because it looks like one” — no edge.\n• Confusing triangle with wedge.\n• Ignoring BTC: a bitcoin pump often kills alt shorts.\n• Shorting a wick below support without a close — fakeout / stop hunt.",
                },
                {
                    "type": "example",
                    "title": "Numbers scenario (no click yet)",
                    "body": "SOLUSDT 15m.\nSupport: 100 (3+ touches).\nHighs: 108 → 105 → 103 → 102.\nH = 108 − 100 = 8.\nClose below 100 → short; stop 102.5 (above last LH); target 100 − 8 = 92.\nRisk 0.7% of equity. Mark + journal first — click only if the plan still matches.",
                },
                {
                    "type": "bullets",
                    "title": "Remember",
                    "items": [
                        "Flat floor, highs ↓",
                        "Triangle ≠ wedge",
                        "Enter after close below support",
                        "Target = H projected down",
                        "Risk 0.5–1%, watch BTC",
                    ],
                },
            ],
            "pt": [
                {"type": "heading", "title": "O que é a figura"},
                {
                    "type": "text",
                    "body": "Triângulo descendente = compressão:\n• suporte quase horizontal embaixo (zona, não linha perfeita);\n• sequência de máximas cada vez mais baixas.\n\nCompradores reagem mais fracos; vendedores pressionam antes. Muitas vezes é continuação de baixa — mas só operamos o lado do rompimento confirmado.\n\nNão confunda com cunha descendente: na cunha as duas bordas inclinam para baixo; no triângulo o piso é flat.",
                },
                {
                    "type": "chart",
                    "title": "Animação da figura",
                    "chartType": "pattern_desc_triangle",
                    "caption": "Suporte flat + máximas descendentes. Rompimento para baixo.",
                },
                {"type": "heading", "title": "Como reconhecer"},
                {
                    "type": "text",
                    "body": "No mesmo TF (SOLUSDT / BTCUSDT 15m ou 1H):\n1) ≥3 toques na mesma zona de suporte;\n2) ≥3 lower highs;\n3) compressão geralmente 12–30+ velas — não “três velas e pronto”.\n\nIntraday em cripto: veja o BTC primeiro — pump forte do bitcoin enfraquece short de alt.",
                },
                {
                    "type": "chart",
                    "title": "Exemplo em velas",
                    "chartType": "breakout",
                    "caption": "Toques no suporte ~100, máximas 108→105→103→102, rompimento, reteste, alvo 92.",
                },
                {"type": "heading", "title": "Entrada, stop, alvo"},
                {
                    "type": "text",
                    "body": "Gatilho: close da vela do TF abaixo do suporte, de preferência volume ≥1.5× a média.\nEntrada: no rompimento (agressivo) ou no reteste por baixo (conservador).\nStop: acima do reteste ou do último lower high dentro da figura.\nAlvo (measured move): H = máxima da figura − suporte; projete H para baixo a partir do rompimento.\nRisco 0.5–1% do depósito; tamanho pela distância do stop.",
                },
                {
                    "type": "chart",
                    "title": "Rompimento + reteste + alvo",
                    "chartType": "pattern_desc_triangle",
                    "caption": "Esquema: entrada, stop além da figura e measured move para baixo.",
                },
                {"type": "heading", "title": "Erros comuns"},
                {
                    "type": "text",
                    "body": "• Short no meio “porque parece” — sem edge.\n• Confundir triângulo com cunha.\n• Ignorar BTC: pump do bitcoin costuma matar short de alt.\n• Shortar pavio abaixo do suporte sem close — fakeout / caça a stop.",
                },
                {
                    "type": "example",
                    "title": "Cenário com números (sem clique)",
                    "body": "SOLUSDT 15m.\nSuporte: 100 (3+ toques).\nMáximas: 108 → 105 → 103 → 102.\nH = 108 − 100 = 8.\nClose < 100 → short; stop 102.5 (acima do último LH); alvo 100 − 8 = 92.\nRisco 0.7% do depósito. Marque e registre no diário — clique só se o plano continuar válido.",
                },
                {
                    "type": "bullets",
                    "title": "Lembre",
                    "items": [
                        "Piso flat, máximas ↓",
                        "Triângulo ≠ cunha",
                        "Entrada após close abaixo do suporte",
                        "Alvo = H projetado para baixo",
                        "Risco 0.5–1%, contexto do BTC",
                    ],
                },
            ],
        },
        "tip": {
            "ru": "Схема — геометрия; свечной пример — как это выглядит в рынке. Без журнала паттерн бесполезен.",
            "en": "The schematic is geometry; the candle example is the market shape. Without a journal the pattern is useless.",
            "pt": "O esquema é geometria; o exemplo em velas é o formato no mercado. Sem diário o padrão não serve.",
        },
    },
    9: {
        "module": {"ru": "Паттерны", "en": "Patterns", "pt": "Padrões"},
        "title": {
            "ru": "Восходящий треугольник",
            "en": "Ascending triangle",
            "pt": "Triângulo ascendente",
        },
        "subtitle": {
            "ru": "Горизонтальное сопротивление + растущие минимумы",
            "en": "Flat resistance + higher lows",
            "pt": "Resistência horizontal + mínimas ascendentes",
        },
        "difficulty": "Intermediate",
        "durationMin": 22,
        "outcome": {
            "ru": "Узнаете восходящий треугольник и план long после close выше сопротивления.",
            "en": "Spot an ascending triangle and plan a long after a close above resistance.",
            "pt": "Reconhecer o triângulo ascendente e planejar long após close acima da resistência.",
        },
        "content": {
            "ru": "Восходящий треугольник: давление покупателей к горизонтальному потолку.",
            "en": "Ascending triangle: buyers pressing into a flat ceiling.",
            "pt": "Triângulo ascendente: compradores pressionando um teto flat.",
        },
        "takeaway": {
            "ru": "Лонг после close выше сопротивления + чаще ретест сверху. Не из середины.",
            "en": "Long after close above resistance, often + retest from above. Never mid-pattern.",
            "pt": "Long após close acima da resistência, muitas vezes + reteste por cima. Nunca no meio.",
        },
        "prerequisites": [8],
        "sections": {
            "ru": [
                {"type": "heading", "title": "Что за фигура"},
                {
                    "type": "text",
                    "body": "Восходящий треугольник — зеркало нисходящего:\n• сверху горизонтальное сопротивление (потолок / зона);\n• снизу higher lows — минимумы всё выше.\n\nПокупатели поднимают «пол», продавцы держат потолок — пока close не закрепится выше.\n\nНе путайте с восходящим клином: у клина обе границы вверх; у треугольника потолок плоский.",
                },
                {
                    "type": "chart",
                    "title": "Анимация фигуры",
                    "chartType": "pattern_asc_triangle",
                    "caption": "Плоский потолок + rising lows. Пробой — вверх через сопротивление.",
                },
                {"type": "heading", "title": "Как узнать на графике"},
                {
                    "type": "text",
                    "body": "≥3 касания одной зоны сопротивления и ≥3 higher lows на одном ТФ. Сжатие 12–30+ свечей.\nНа ETH/BTC в бычьем контексте 1H/4H шанс продолжения вверх выше — но вход всё равно только после close.",
                },
                {
                    "type": "chart",
                    "title": "Пример на свечах",
                    "chartType": "breakout",
                    "caption": "Сопротивление 64, HL 54→58→60→62, пробой, ретест, цель 74 (H=10).",
                },
                {"type": "heading", "title": "Вход, стоп, цель"},
                {
                    "type": "text",
                    "body": "Триггер: close выше сопротивления + желательно объём.\nВход на пробое или на ретесте сверху (бывшее сопротивление → поддержка).\nСтоп: под ретестом / последним higher low.\nЦель: H = сопротивление − lowest low фигуры; от пробоя вверх +H.\nРиск 0.5–1%.",
                },
                {
                    "type": "chart",
                    "title": "Пробой + ретест + цель",
                    "chartType": "pattern_asc_triangle",
                    "caption": "Схема long: вход, стоп под полом, measured move вверх.",
                },
                {"type": "heading", "title": "Частые ошибки"},
                {
                    "type": "text",
                    "body": "• Лонг из середины треугольника.\n• Стоп выше последнего HL (внутри фигуры) — выбьет шумом.\n• Игнор падения BTC при лонге альта.\n• Принимать тень выше потолка за пробой без close.",
                },
                {
                    "type": "example",
                    "title": "Сценарий с цифрами (без клика)",
                    "body": "ETHUSDT 1H (учебные цены).\nСопротивление: 3200 (3+ касания).\nМинимумы: 3100 → 3140 → 3170.\nH = 3200 − 3100 = 100.\nClose выше 3200 + ретест сверху → long; стоп 3165 (под последним HL 3170); цель 3200 + 100 = 3300.\nR ≈ 35 пунктов, цель 100 → R:R ≈ 1:2.8.",
                },
                {
                    "type": "bullets",
                    "title": "Запомнить",
                    "items": [
                        "Потолок горизонтальный, lows ↑",
                        "Треугольник ≠ клин",
                        "Вход после close выше сопротивления",
                        "Стоп под последним HL",
                        "Цель = H вверх от пробоя",
                    ],
                },
            ],
            "en": [
                {"type": "heading", "title": "What the pattern is"},
                {
                    "type": "text",
                    "body": "An ascending triangle mirrors the descending one:\n• flat resistance above (ceiling / zone);\n• higher lows below.\n\nBuyers raise the floor while sellers defend the ceiling — until a close holds above.\n\nDo not confuse with a rising wedge: a wedge slopes both borders up; an ascending triangle has a flat ceiling.",
                },
                {
                    "type": "chart",
                    "title": "Pattern animation",
                    "chartType": "pattern_asc_triangle",
                    "caption": "Flat ceiling + rising lows. Break is up through resistance.",
                },
                {"type": "heading", "title": "How to spot it"},
                {
                    "type": "text",
                    "body": "≥3 touches of one resistance zone and ≥3 higher lows on one TF. Compression 12–30+ candles.\nOn ETH/BTC in a bullish 1H/4H context continuation odds improve — but entry still needs a close.",
                },
                {
                    "type": "chart",
                    "title": "Candlestick example",
                    "chartType": "breakout",
                    "caption": "Resistance 64, HL 54→58→60→62, break, retest, target 74 (H=10).",
                },
                {"type": "heading", "title": "Entry, stop, target"},
                {
                    "type": "text",
                    "body": "Trigger: close above resistance, preferably with volume.\nEntry on break or retest from above (old resistance → support).\nStop: under the retest / last higher low.\nTarget: H = resistance − lowest low of the pattern; project +H from the breakout.\nRisk 0.5–1%.",
                },
                {
                    "type": "chart",
                    "title": "Break + retest + target",
                    "chartType": "pattern_asc_triangle",
                    "caption": "Long schematic: entry, stop under the floor, measured move up.",
                },
                {"type": "heading", "title": "Common mistakes"},
                {
                    "type": "text",
                    "body": "• Buying mid-triangle.\n• Stop above the last HL (inside the pattern) — noise will hit you.\n• Ignoring a BTC dump while longing an alt.\n• Treating a wick above the ceiling as a break without a close.",
                },
                {
                    "type": "example",
                    "title": "Numbers scenario (no click yet)",
                    "body": "ETHUSDT 1H (teaching prices).\nResistance: 3200 (3+ touches).\nLows: 3100 → 3140 → 3170.\nH = 3200 − 3100 = 100.\nClose above 3200 + retest from above → long; stop 3165 (under last HL 3170); target 3200 + 100 = 3300.\nR ≈ 35 points, target 100 → R:R ≈ 1:2.8.",
                },
                {
                    "type": "bullets",
                    "title": "Remember",
                    "items": [
                        "Flat ceiling, lows ↑",
                        "Triangle ≠ wedge",
                        "Enter after close above resistance",
                        "Stop under last HL",
                        "Target = H projected up",
                    ],
                },
            ],
            "pt": [
                {"type": "heading", "title": "O que é a figura"},
                {
                    "type": "text",
                    "body": "Triângulo ascendente = espelho do descendente:\n• resistência horizontal em cima (teto / zona);\n• higher lows embaixo.\n\nCompradores sobem o piso; vendedores defendem o teto — até um close se firmar acima.\n\nNão confunda com cunha ascendente: na cunha as duas bordas sobem; no triângulo o teto é flat.",
                },
                {
                    "type": "chart",
                    "title": "Animação da figura",
                    "chartType": "pattern_asc_triangle",
                    "caption": "Teto flat + mínimas ascendentes. Rompimento para cima.",
                },
                {"type": "heading", "title": "Como reconhecer"},
                {
                    "type": "text",
                    "body": "≥3 toques na mesma resistência e ≥3 higher lows no mesmo TF. Compressão 12–30+ velas.\nEm ETH/BTC com contexto de alta em 1H/4H a continuação é mais provável — mas a entrada ainda exige close.",
                },
                {
                    "type": "chart",
                    "title": "Exemplo em velas",
                    "chartType": "breakout",
                    "caption": "Resistência 64, HL 54→58→60→62, rompimento, reteste, alvo 74 (H=10).",
                },
                {"type": "heading", "title": "Entrada, stop, alvo"},
                {
                    "type": "text",
                    "body": "Gatilho: close acima da resistência, de preferência com volume.\nEntrada no rompimento ou no reteste por cima (ex-resistência → suporte).\nStop: abaixo do reteste / último higher low.\nAlvo: H = resistência − mínima da figura; +H a partir do rompimento.\nRisco 0.5–1%.",
                },
                {
                    "type": "chart",
                    "title": "Rompimento + reteste + alvo",
                    "chartType": "pattern_asc_triangle",
                    "caption": "Esquema de long: entrada, stop abaixo do piso, measured move para cima.",
                },
                {"type": "heading", "title": "Erros comuns"},
                {
                    "type": "text",
                    "body": "• Long no meio do triângulo.\n• Stop acima do último HL (dentro da figura) — o ruído te tira.\n• Ignorar dump do BTC ao longar um alt.\n• Tratar pavio acima do teto como rompimento sem close.",
                },
                {
                    "type": "example",
                    "title": "Cenário com números (sem clique)",
                    "body": "ETHUSDT 1H (preços didáticos).\nResistência: 3200 (3+ toques).\nMínimas: 3100 → 3140 → 3170.\nH = 3200 − 3100 = 100.\nClose > 3200 + reteste por cima → long; stop 3165 (abaixo do último HL 3170); alvo 3200 + 100 = 3300.\nR ≈ 35 pontos, alvo 100 → R:R ≈ 1:2.8.",
                },
                {
                    "type": "bullets",
                    "title": "Lembre",
                    "items": [
                        "Teto flat, mínimas ↑",
                        "Triângulo ≠ cunha",
                        "Entrada após close acima da resistência",
                        "Stop sob o último HL",
                        "Alvo = H para cima a partir do rompimento",
                    ],
                },
            ],
        },
        "tip": {
            "ru": "Стоп всегда под последним HL, не «чуть ниже входа». Иначе шум съест позицию до цели.",
            "en": "Stop always under the last HL, not “just under entry”. Otherwise noise stops you before the target.",
            "pt": "Stop sempre abaixo do último HL, não “um pouco abaixo da entrada”. Senão o ruído te tira antes do alvo.",
        },
    },
    19: {
        "module": {"ru": "Паттерны", "en": "Patterns", "pt": "Padrões"},
        "title": {
            "ru": "Симметричный треугольник",
            "en": "Symmetric triangle",
            "pt": "Triângulo simétrico",
        },
        "subtitle": {
            "ru": "Сжатие → пробой. Measured move на цифрах",
            "en": "Squeeze → break. Measured move with numbers",
            "pt": "Compressão → rompimento. Measured move com números",
        },
        "difficulty": "Intermediate",
        "durationMin": 22,
        "outcome": {
            "ru": "Разметите симметричный треугольник и посчитаете цель 1:1 от высоты H.",
            "en": "Mark a symmetric triangle and compute the 1:1 target from height H.",
            "pt": "Marcar o triângulo simétrico e calcular o alvo 1:1 a partir da altura H.",
        },
        "content": {
            "ru": "Симметричный треугольник — баланс сил до пробоя; направление заранее не гадаем.",
            "en": "A symmetric triangle is balance before the break; do not guess the direction early.",
            "pt": "Triângulo simétrico = equilíbrio até o rompimento; não chute a direção cedo.",
        },
        "takeaway": {
            "ru": "Ждите close за границей + объём; цель ≈ H от точки пробоя.",
            "en": "Wait for a close beyond the border + volume; target ≈ H from the breakout.",
            "pt": "Espere close além da borda + volume; alvo ≈ H a partir do rompimento.",
        },
        "prerequisites": [8, 9],
        "sections": {
            "ru": [
                {"type": "heading", "title": "Как выглядит"},
                {
                    "type": "text",
                    "body": "Симметричный треугольник: highs ниже, lows выше — «сжатие пружины».\nОбе границы наклонные и сходятся к апексу; линии не должны пересекаться «наоборот».\n\nНаправление заранее не угадываем: торгуем сторону close.\nТень за границей ≠ пробой — нужно закрытие свечи выбранного ТФ.",
                },
                {
                    "type": "chart",
                    "title": "Симметричный треугольник",
                    "chartType": "pattern_sym_triangle",
                    "caption": "Две сходящиеся линии. Ждём close за границей.",
                },
                {"type": "heading", "title": "Measured move — цель линейкой"},
                {
                    "type": "text",
                    "body": "1) Измерьте высоту самой широкой части треугольника (H) у основания.\n2) От цены пробоя (close за границей) отложите H в сторону пробоя — цель 1:1.\n3) Стоп — за противоположной границей или за last swing внутри фигуры.\n\nПример: H = 120. Пробой вверх close 5400. Цель ≈ 5400 + 120 = 5520.",
                },
                {
                    "type": "chart",
                    "title": "Высота фигуры = размер цели",
                    "chartType": "breakout",
                    "caption": "H у основания; цель = break ± H. Линии сходятся, не перекрещиваются.",
                },
                {"type": "heading", "title": "Полный пример BNB"},
                {
                    "type": "text",
                    "body": "BNBUSDT 4H.\nВерхняя граница (LH): 620 → 600 → 590.\nНижняя граница (HL): 560 → 570 → 580.\nH у основания ≈ 620 − 560 = 60.\n\nClose 4H выше верхней линии около 592–595 → пробой вверх.\nВход 593, стоп 579 (под последним HL / нижней границей), R ≈ 14.\nЦель measured 592 + 60 = 652.\nЧастично фиксируйте на 1.5R (≈ 614) и трейльте остаток — полная 1:1 часто далеко для intraday.",
                },
                {
                    "type": "chart",
                    "title": "Пробой симметричного треугольника",
                    "chartType": "pattern_sym_triangle",
                    "caption": "Close за границей + стоп + цель от H.",
                },
                {
                    "type": "example",
                    "title": "Разбор с цифрами",
                    "body": "H = 40, пробой вверх close 100, вход 100.5, стоп 97.5 (R = 3), цель measured 140.\nДаже частичная цель 1.5R = 105 уже лучше входа наугад. Без close за границей — сетапа нет.",
                },
                {
                    "type": "bullets",
                    "title": "Запомнить",
                    "items": [
                        "Highs ↓ и lows ↑ сходятся",
                        "Пробой = close, не тень",
                        "H = высота у основания",
                        "Цель ≈ H от пробоя",
                        "Стоп за противоположной стороной",
                    ],
                },
            ],
            "en": [
                {"type": "heading", "title": "What it looks like"},
                {
                    "type": "text",
                    "body": "Symmetric triangle: lower highs and higher lows — a “coiling spring”.\nBoth borders slope and converge toward the apex; they must not cross upside-down.\n\nDo not guess direction early: trade the close side.\nA wick beyond the border ≠ breakout — you need a working-TF candle close.",
                },
                {
                    "type": "chart",
                    "title": "Symmetric triangle",
                    "chartType": "pattern_sym_triangle",
                    "caption": "Two converging lines. Wait for a close beyond the border.",
                },
                {"type": "heading", "title": "Measured move — ruler target"},
                {
                    "type": "text",
                    "body": "1) Measure height H at the widest (base) part of the triangle.\n2) From the breakout price (close beyond the border) project H in the breakout direction — 1:1 target.\n3) Stop beyond the opposite border or last swing inside the pattern.\n\nExample: H = 120. Upside break close 5400. Target ≈ 5400 + 120 = 5520.",
                },
                {
                    "type": "chart",
                    "title": "Pattern height = target size",
                    "chartType": "breakout",
                    "caption": "H at the base; target = break ± H. Lines converge, they do not cross wrong-way.",
                },
                {"type": "heading", "title": "Full BNB example"},
                {
                    "type": "text",
                    "body": "BNBUSDT 4H.\nUpper border (LH): 620 → 600 → 590.\nLower border (HL): 560 → 570 → 580.\nBase H ≈ 620 − 560 = 60.\n\n4H close above the upper line near 592–595 → upside break.\nEntry 593, stop 579 (under last HL / lower border), R ≈ 14.\nMeasured target 592 + 60 = 652.\nScale out at 1.5R (≈ 614) and trail the rest — full 1:1 is often too far for intraday.",
                },
                {
                    "type": "chart",
                    "title": "Symmetric triangle breakout",
                    "chartType": "pattern_sym_triangle",
                    "caption": "Close beyond the border + stop + target from H.",
                },
                {
                    "type": "example",
                    "title": "Numbers walkthrough",
                    "body": "H = 40, upside break close 100, entry 100.5, stop 97.5 (R = 3), measured target 140.\nEven a partial 1.5R = 105 beats a random entry. No close beyond the border — no setup.",
                },
                {
                    "type": "bullets",
                    "title": "Remember",
                    "items": [
                        "Highs ↓ and lows ↑ converge",
                        "Break = close, not wick",
                        "H = height at the base",
                        "Target ≈ H from the break",
                        "Stop beyond the opposite side",
                    ],
                },
            ],
            "pt": [
                {"type": "heading", "title": "Como parece"},
                {
                    "type": "text",
                    "body": "Triângulo simétrico: máximas mais baixas e mínimas mais altas — “mola comprimida”.\nAs duas bordas inclinadas convergem para o ápice; não podem se cruzar ao contrário.\n\nNão chute a direção cedo: opere o lado do close.\nPavio além da borda ≠ rompimento — precisa de close da vela do TF.",
                },
                {
                    "type": "chart",
                    "title": "Triângulo simétrico",
                    "chartType": "pattern_sym_triangle",
                    "caption": "Duas linhas convergentes. Espere close além da borda.",
                },
                {"type": "heading", "title": "Measured move — alvo com régua"},
                {
                    "type": "text",
                    "body": "1) Meça a altura H na parte mais larga (base) do triângulo.\n2) Do preço do rompimento (close além da borda) projete H na direção do rompimento — alvo 1:1.\n3) Stop além da borda oposta ou do last swing dentro da figura.\n\nExemplo: H = 120. Rompimento de alta close 5400. Alvo ≈ 5400 + 120 = 5520.",
                },
                {
                    "type": "chart",
                    "title": "Altura da figura = tamanho do alvo",
                    "chartType": "breakout",
                    "caption": "H na base; alvo = break ± H. Linhas convergem, não se cruzam errado.",
                },
                {"type": "heading", "title": "Exemplo completo BNB"},
                {
                    "type": "text",
                    "body": "BNBUSDT 4H.\nBorda superior (LH): 620 → 600 → 590.\nBorda inferior (HL): 560 → 570 → 580.\nH na base ≈ 620 − 560 = 60.\n\nClose 4H acima da linha superior perto de 592–595 → rompimento de alta.\nEntrada 593, stop 579 (abaixo do último HL / borda inferior), R ≈ 14.\nAlvo measured 592 + 60 = 652.\nRealize parcialmente em 1.5R (≈ 614) e faça trailing do resto — 1:1 cheio costuma ser longe demais para intraday.",
                },
                {
                    "type": "chart",
                    "title": "Rompimento do triângulo simétrico",
                    "chartType": "pattern_sym_triangle",
                    "caption": "Close além da borda + stop + alvo a partir de H.",
                },
                {
                    "type": "example",
                    "title": "Números",
                    "body": "H = 40, rompimento de alta close 100, entrada 100.5, stop 97.5 (R = 3), alvo measured 140.\nMesmo um parcial 1.5R = 105 já é melhor que entrada aleatória. Sem close além da borda — sem setup.",
                },
                {
                    "type": "bullets",
                    "title": "Lembre",
                    "items": [
                        "Highs ↓ e lows ↑ convergem",
                        "Rompimento = close, não pavio",
                        "H = altura na base",
                        "Alvo ≈ H a partir do rompimento",
                        "Stop além do lado oposto",
                    ],
                },
            ],
        },
        "tip": {
            "ru": "Нет закрытия за границей — нет сетапа. Тень не считается.",
            "en": "No close beyond the border — no setup. A wick does not count.",
            "pt": "Sem close além da borda — sem setup. Pavio não conta.",
        },
    },
    46: {
        "module": {"ru": "Паттерны", "en": "Patterns", "pt": "Padrões"},
        "title": {
            "ru": "Голова и плечи",
            "en": "Head and shoulders",
            "pt": "Cabeça e ombros",
        },
        "subtitle": {
            "ru": "Левое плечо — голова — правое плечо + линия шеи",
            "en": "Left shoulder — head — right shoulder + neckline",
            "pt": "Ombro esquerdo — cabeça — ombro direito + linha do pescoço",
        },
        "difficulty": "Intermediate",
        "durationMin": 24,
        "outcome": {
            "ru": "Разметите классический H&S и план short после close ниже шеи с целью = высота головы.",
            "en": "Mark classic H&S and plan a short after a close below the neck with target = head height.",
            "pt": "Marcar H&S clássico e planejar short após close abaixo do pescoço com alvo = altura da cabeça.",
        },
        "content": {
            "ru": "Классический разворот вниз: левое плечо, более высокая голова, правое плечо, пробой линии шеи.",
            "en": "Classic bearish reversal: left shoulder, higher head, right shoulder, neckline break.",
            "pt": "Reversão clássica de baixa: ombro esquerdo, cabeça mais alta, ombro direito, rompimento do pescoço.",
        },
        "takeaway": {
            "ru": "Триггер — close ниже шеи; стоп над правым плечом; цель ≈ высота головы вниз.",
            "en": "Trigger — close below the neck; stop above the right shoulder; target ≈ head height down.",
            "pt": "Gatilho — close abaixo do pescoço; stop acima do ombro direito; alvo ≈ altura da cabeça para baixo.",
        },
        "prerequisites": [8, 19],
        "sections": {
            "ru": [
                {"type": "heading", "title": "Что за фигура"},
                {
                    "type": "text",
                    "body": "Голова и плечи — разворот с бычьего на медвежий:\n1) левое плечо (пик);\n2) откат к «шее»;\n3) голова — более высокий пик;\n4) откат снова к шее;\n5) правое плечо ≈ уровень левого (чуть выше/ниже ок);\n6) close ниже линии шеи.\n\nШея соединяет две впадины между пиками; может быть слегка наклонной.",
                },
                {
                    "type": "chart",
                    "title": "Анимация фигуры",
                    "chartType": "pattern_head_shoulders",
                    "caption": "LS → голова → RS → пробой шеи вниз.",
                },
                {"type": "heading", "title": "Как узнать на графике"},
                {
                    "type": "text",
                    "body": "Три вершины на одном ТФ; средняя заметно выше.\nПравое плечо часто на меньшем объёме, чем голова.\nНа 4H/1D надежнее, чем на 5m — на низких ТФ много «похожих» шумов.\nПосле серии HH/HL появление LH + H&S — сильный сигнал смены структуры.",
                },
                {
                    "type": "chart",
                    "title": "Пример на свечах",
                    "chartType": "reversal",
                    "caption": "Плечи ~58, голова ~72, шея ~50, close ниже шеи, цель ~28 (H=22).",
                },
                {"type": "heading", "title": "Вход, стоп, цель"},
                {
                    "type": "text",
                    "body": "Триггер: close ниже шеи (тень недостаточна).\nВход на пробое или на ретесте шеи снизу.\nСтоп: над правым плечом (не над головой — слишком далеко).\nЦель: H = high головы − шея в точке под головой; от пробоя шеи вниз −H.\nЧастичная фиксация на 1R обязательна на внутридневке.",
                },
                {
                    "type": "example",
                    "title": "Сценарий с цифрами (без клика)",
                    "body": "BTCUSDT 4H.\nПлечи ≈ 65 000, голова 68 000, шея 63 000.\nH = 68 000 − 63 000 = 5 000.\nClose ниже 63 000 → short; стоп над правым плечом ≈ 65 200; цель 63 000 − 5 000 = 58 000.\nR ≈ 2 200, цель 5 000 → R:R ≈ 1:2.3. Не шортите «голову» до пробоя шеи.",
                },
                {
                    "type": "bullets",
                    "title": "Запомнить",
                    "items": [
                        "Голова выше плеч",
                        "Триггер = close ниже шеи",
                        "Стоп над правым плечом",
                        "Цель = высота головы вниз",
                        "Не шортить до подтверждения шеи",
                    ],
                },
            ],
            "en": [
                {"type": "heading", "title": "What the pattern is"},
                {
                    "type": "text",
                    "body": "Head and shoulders is a bullish-to-bearish reversal:\n1) left shoulder (peak);\n2) pullback to the “neck”;\n3) head — a higher peak;\n4) pullback to the neck again;\n5) right shoulder ≈ left shoulder height;\n6) close below the neckline.\n\nThe neckline joins the two troughs between peaks; a mild slope is fine.",
                },
                {
                    "type": "chart",
                    "title": "Pattern animation",
                    "chartType": "pattern_head_shoulders",
                    "caption": "LS → head → RS → neckline break down.",
                },
                {"type": "heading", "title": "How to spot it"},
                {
                    "type": "text",
                    "body": "Three peaks on one TF; the middle one clearly higher.\nRight shoulder often prints on lower volume than the head.\n4H/1D is more reliable than 5m — lower TFs are full of lookalikes.\nAfter an HH/HL series, an LH + H&S is a strong structure-shift signal.",
                },
                {
                    "type": "chart",
                    "title": "Candlestick example",
                    "chartType": "reversal",
                    "caption": "Shoulders ~58, head ~72, neck ~50, close below neck, target ~28 (H=22).",
                },
                {"type": "heading", "title": "Entry, stop, target"},
                {
                    "type": "text",
                    "body": "Trigger: close below the neck (a wick is not enough).\nEntry on break or retest of the neck from below.\nStop: above the right shoulder (not above the head — too far).\nTarget: H = head high − neck under the head; project −H from the neck break.\nIntraday: take partials at 1R.",
                },
                {
                    "type": "example",
                    "title": "Numbers scenario (no click yet)",
                    "body": "BTCUSDT 4H.\nShoulders ≈ 65,000, head 68,000, neck 63,000.\nH = 68,000 − 63,000 = 5,000.\nClose below 63,000 → short; stop above right shoulder ≈ 65,200; target 63,000 − 5,000 = 58,000.\nR ≈ 2,200, target 5,000 → R:R ≈ 1:2.3. Do not short the “head” before the neck breaks.",
                },
                {
                    "type": "bullets",
                    "title": "Remember",
                    "items": [
                        "Head higher than shoulders",
                        "Trigger = close below neck",
                        "Stop above right shoulder",
                        "Target = head height down",
                        "No short before neck confirmation",
                    ],
                },
            ],
            "pt": [
                {"type": "heading", "title": "O que é a figura"},
                {
                    "type": "text",
                    "body": "Cabeça e ombros = reversão de alta para baixa:\n1) ombro esquerdo (pico);\n2) pullback ao “pescoço”;\n3) cabeça — pico mais alto;\n4) pullback de novo ao pescoço;\n5) ombro direito ≈ altura do esquerdo;\n6) close abaixo da linha do pescoço.\n\nA linha une as duas mínimas entre os picos; leve inclinação é ok.",
                },
                {
                    "type": "chart",
                    "title": "Animação da figura",
                    "chartType": "pattern_head_shoulders",
                    "caption": "OE → cabeça → OD → rompimento do pescoço para baixo.",
                },
                {"type": "heading", "title": "Como reconhecer"},
                {
                    "type": "text",
                    "body": "Três topos no mesmo TF; o do meio claramente mais alto.\nO ombro direito muitas vezes vem com volume menor que a cabeça.\n4H/1D é mais confiável que 5m — TF baixo tem muitos “parecidos”.\nDepois de uma série HH/HL, um LH + H&S é sinal forte de mudança de estrutura.",
                },
                {
                    "type": "chart",
                    "title": "Exemplo em velas",
                    "chartType": "reversal",
                    "caption": "Ombros ~58, cabeça ~72, pescoço ~50, close abaixo, alvo ~28 (H=22).",
                },
                {"type": "heading", "title": "Entrada, stop, alvo"},
                {
                    "type": "text",
                    "body": "Gatilho: close abaixo do pescoço (pavio não basta).\nEntrada no rompimento ou no reteste do pescoço por baixo.\nStop: acima do ombro direito (não acima da cabeça — longe demais).\nAlvo: H = máxima da cabeça − pescoço sob a cabeça; −H a partir do rompimento.\nIntraday: parcial em 1R.",
                },
                {
                    "type": "example",
                    "title": "Cenário com números (sem clique)",
                    "body": "BTCUSDT 4H.\nOmbros ≈ 65 000, cabeça 68 000, pescoço 63 000.\nH = 68 000 − 63 000 = 5 000.\nClose < 63 000 → short; stop acima do ombro direito ≈ 65 200; alvo 63 000 − 5 000 = 58 000.\nR ≈ 2 200, alvo 5 000 → R:R ≈ 1:2.3. Não shorte a “cabeça” antes do rompimento do pescoço.",
                },
                {
                    "type": "bullets",
                    "title": "Lembre",
                    "items": [
                        "Cabeça mais alta que os ombros",
                        "Gatilho = close abaixo do pescoço",
                        "Stop acima do ombro direito",
                        "Alvo = altura da cabeça para baixo",
                        "Sem short antes da confirmação",
                    ],
                },
            ],
        },
        "tip": {
            "ru": "Пока шея не пробита close — это ещё не H&S-сетап, а только «похожая форма».",
            "en": "Until the neck closes below — it is not an H&S setup yet, only a lookalike shape.",
            "pt": "Enquanto o pescoço não fechar abaixo — ainda não é setup H&S, só uma forma parecida.",
        },
    },
    47: {
        "module": {"ru": "Паттерны", "en": "Patterns", "pt": "Padrões"},
        "title": {
            "ru": "Перевёрнутые голова и плечи",
            "en": "Inverse head and shoulders",
            "pt": "Cabeça e ombros invertidos",
        },
        "subtitle": {
            "ru": "Разворот вверх от линии шеи",
            "en": "Bullish reversal from the neckline",
            "pt": "Reversão de alta a partir do pescoço",
        },
        "difficulty": "Advanced",
        "durationMin": 24,
        "outcome": {
            "ru": "Узнаете inverse H&S и план long после close выше шеи с целью = высота головы вверх.",
            "en": "Spot inverse H&S and plan a long after a close above the neck with target = head height up.",
            "pt": "Reconhecer H&S invertido e planejar long após close acima do pescoço com alvo = altura da cabeça para cima.",
        },
        "content": {
            "ru": "Inverse H&S — зеркало классики: три впадины, средняя глубже, пробой шеи вверх.",
            "en": "Inverse H&S mirrors the classic: three troughs, middle deepest, neckline break up.",
            "pt": "H&S invertido espelha o clássico: três fundos, o do meio mais fundo, rompimento do pescoço para cima.",
        },
        "takeaway": {
            "ru": "Лонг после close выше шеи + ретест; стоп под правым плечом; цель ≈ высота головы вверх.",
            "en": "Long after close above the neck + retest; stop under right shoulder; target ≈ head height up.",
            "pt": "Long após close acima do pescoço + reteste; stop sob o ombro direito; alvo ≈ altura da cabeça para cima.",
        },
        "prerequisites": [46],
        "sections": {
            "ru": [
                {"type": "heading", "title": "Что за фигура"},
                {
                    "type": "text",
                    "body": "Перевёрнутые голова и плечи — разворот вверх:\n• левое плечо (впадина);\n• подъём к шее;\n• голова — более глубокая впадина;\n• снова к шее;\n• правое плечо ≈ левое;\n• close выше линии шеи.\n\nШея соединяет вершины между впадинами.",
                },
                {
                    "type": "chart",
                    "title": "Анимация фигуры",
                    "chartType": "pattern_head_shoulders_inv",
                    "caption": "Три дна, среднее глубже → пробой шеи вверх.",
                },
                {"type": "heading", "title": "Как узнать на графике"},
                {
                    "type": "text",
                    "body": "Левое плечо — голова — правое плечо на дне. Шея — линия по highs между ними.\nОбъём на пробое шеи вверх желателен.\nСверьте старший ТФ: inverse H&S на 15m против сильного даунтренда 4H слабее.",
                },
                {
                    "type": "chart",
                    "title": "Пример на свечах",
                    "chartType": "reversal",
                    "caption": "Плечи ~48, голова ~40, шея ~58, close выше, ретест, цель ~76 (H=18).",
                },
                {"type": "heading", "title": "Вход, стоп, цель"},
                {
                    "type": "text",
                    "body": "Триггер: close выше шеи.\nВход на пробое или ретесте шеи сверху.\nСтоп: под правым плечом.\nЦель: H = шея − low головы; от пробоя вверх +H.",
                },
                {
                    "type": "example",
                    "title": "Сценарий с цифрами (без клика)",
                    "body": "ETHUSDT 1D.\nПлечи ≈ 2200, голова 2000, шея 2400.\nH = 2400 − 2000 = 400.\nClose выше 2400 → long; стоп под правым плечом ≈ 2180; цель 2400 + 400 = 2800.\nR ≈ 220, цель 400 → R:R ≈ 1:1.8 (можно цель чуть ниже / частичные фиксации). Не лонгите «голову» до пробоя шеи.",
                },
                {
                    "type": "bullets",
                    "title": "Запомнить",
                    "items": [
                        "Голова — самое глубокое дно",
                        "Триггер = close выше шеи",
                        "Стоп под правым плечом",
                        "Цель = высота головы вверх",
                        "Контекст старшего ТФ",
                    ],
                },
            ],
            "en": [
                {"type": "heading", "title": "What the pattern is"},
                {
                    "type": "text",
                    "body": "Inverse head and shoulders is a bullish reversal:\n• left shoulder (trough);\n• rally to the neck;\n• head — a deeper trough;\n• back to the neck;\n• right shoulder ≈ left;\n• close above the neckline.\n\nThe neck joins the peaks between the troughs.",
                },
                {
                    "type": "chart",
                    "title": "Pattern animation",
                    "chartType": "pattern_head_shoulders_inv",
                    "caption": "Three bottoms, middle deepest → neckline break up.",
                },
                {"type": "heading", "title": "How to spot it"},
                {
                    "type": "text",
                    "body": "Left shoulder — head — right shoulder on the lows. Neckline across the highs between them.\nVolume on the upside neck break helps.\nCheck the higher TF: inverse H&S on 15m against a strong 4H downtrend is weak.",
                },
                {
                    "type": "chart",
                    "title": "Candlestick example",
                    "chartType": "reversal",
                    "caption": "Shoulders ~48, head ~40, neck ~58, close above, retest, target ~76 (H=18).",
                },
                {"type": "heading", "title": "Entry, stop, target"},
                {
                    "type": "text",
                    "body": "Trigger: close above the neck.\nEntry on break or retest of the neck from above.\nStop: under the right shoulder.\nTarget: H = neck − head low; project +H from the break.",
                },
                {
                    "type": "example",
                    "title": "Numbers scenario (no click yet)",
                    "body": "ETHUSDT 1D.\nShoulders ≈ 2200, head 2000, neck 2400.\nH = 2400 − 2000 = 400.\nClose above 2400 → long; stop under right shoulder ≈ 2180; target 2400 + 400 = 2800.\nR ≈ 220, target 400 → R:R ≈ 1:1.8 (trim target / take partials). Do not buy the “head” before the neck breaks.",
                },
                {
                    "type": "bullets",
                    "title": "Remember",
                    "items": [
                        "Head is the deepest trough",
                        "Trigger = close above neck",
                        "Stop under right shoulder",
                        "Target = head height up",
                        "Higher-TF context matters",
                    ],
                },
            ],
            "pt": [
                {"type": "heading", "title": "O que é a figura"},
                {
                    "type": "text",
                    "body": "Cabeça e ombros invertidos = reversão de alta:\n• ombro esquerdo (fundo);\n• alta até o pescoço;\n• cabeça — fundo mais profundo;\n• de volta ao pescoço;\n• ombro direito ≈ esquerdo;\n• close acima da linha do pescoço.\n\nO pescoço une as máximas entre os fundos.",
                },
                {
                    "type": "chart",
                    "title": "Animação da figura",
                    "chartType": "pattern_head_shoulders_inv",
                    "caption": "Três fundos, o do meio mais fundo → rompimento do pescoço para cima.",
                },
                {"type": "heading", "title": "Como reconhecer"},
                {
                    "type": "text",
                    "body": "Ombro esquerdo — cabeça — ombro direito nos fundos. Pescoço pelas máximas entre eles.\nVolume no rompimento de alta ajuda.\nConfira o TF maior: H&S invertido em 15m contra downtrend forte em 4H é fraco.",
                },
                {
                    "type": "chart",
                    "title": "Exemplo em velas",
                    "chartType": "reversal",
                    "caption": "Ombros ~48, cabeça ~40, pescoço ~58, close acima, reteste, alvo ~76 (H=18).",
                },
                {"type": "heading", "title": "Entrada, stop, alvo"},
                {
                    "type": "text",
                    "body": "Gatilho: close acima do pescoço.\nEntrada no rompimento ou reteste do pescoço por cima.\nStop: abaixo do ombro direito.\nAlvo: H = pescoço − mínima da cabeça; +H a partir do rompimento.",
                },
                {
                    "type": "example",
                    "title": "Cenário com números (sem clique)",
                    "body": "ETHUSDT 1D.\nOmbros ≈ 2200, cabeça 2000, pescoço 2400.\nH = 2400 − 2000 = 400.\nClose > 2400 → long; stop sob o ombro direito ≈ 2180; alvo 2400 + 400 = 2800.\nR ≈ 220, alvo 400 → R:R ≈ 1:1.8 (ajuste alvo / parciais). Não compre a “cabeça” antes do rompimento do pescoço.",
                },
                {
                    "type": "bullets",
                    "title": "Lembre",
                    "items": [
                        "Cabeça = fundo mais profundo",
                        "Gatilho = close acima do pescoço",
                        "Stop sob o ombro direito",
                        "Alvo = altura da cabeça para cima",
                        "Contexto do TF maior",
                    ],
                },
            ],
        },
        "tip": {
            "ru": "Inverse H&S на 15m против сильного даунтренда BTC 4H — сначала контекст, потом фигура.",
            "en": "Inverse H&S on 15m against a strong BTC 4H downtrend — context first, pattern second.",
            "pt": "H&S invertido em 15m contra downtrend forte do BTC em 4H — contexto primeiro, figura depois.",
        },
    },
}


def build_lesson(lid: int, lang: str, existing: dict) -> dict:
    spec = LESSONS[lid]
    sections = deepcopy(spec["sections"][lang])
    sections.append(deepcopy(COMMON_PRACTICE[lang]))
    sections.append(deepcopy(COMMON_JOURNAL[lang]))
    sections.append(deepcopy(COMMON_HW[lang]))
    sections.append({"type": "tip", "title": {"ru": "Совет", "en": "Tip", "pt": "Dica"}[lang], "body": spec["tip"][lang]})

    out = deepcopy(existing)
    out["id"] = lid
    out["module"] = spec["module"][lang]
    out["title"] = spec["title"][lang]
    out["subtitle"] = spec["subtitle"][lang]
    out["difficulty"] = spec["difficulty"]
    out["durationMin"] = spec["durationMin"]
    out["outcome"] = spec["outcome"][lang]
    out["content"] = spec["content"][lang]
    out["takeaway"] = spec["takeaway"][lang]
    out["prerequisites"] = spec["prerequisites"]
    out["learningOutcomes"] = meta(lang, [])
    out["references"] = refs()
    out["sections"] = sections
    return out


def apply(path: Path, lang: str) -> None:
    lessons = json.loads(path.read_text(encoding="utf-8"))
    by_id = {int(l["id"]): i for i, l in enumerate(lessons)}
    for lid in LESSONS:
        if lid not in by_id:
            raise SystemExit(f"Lesson {lid} missing in {path}")
        lessons[by_id[lid]] = build_lesson(lid, lang, lessons[by_id[lid]])
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Updated {path.name}: lessons {sorted(LESSONS)}")


def main() -> None:
    apply(DATA / "lessons_ru.json", "ru")
    apply(DATA / "lessons_en.json", "en")
    apply(DATA / "lessons_pt.json", "pt")


if __name__ == "__main__":
    main()
