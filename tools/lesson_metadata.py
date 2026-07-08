#!/usr/bin/env python3
"""Academic metadata: references, prerequisites, learning outcomes per lesson."""

from __future__ import annotations

# Shared references reused across lessons
_REF_MURPHY = {
    "title": "Technical Analysis of the Financial Markets",
    "author": "John J. Murphy",
    "year": 1999,
    "url": "https://www.investopedia.com/terms/t/technicalanalysis.asp",
    "type": "book",
}
_REF_BINANCE_SPOT = {
    "title": "Binance Spot Trading Rules",
    "author": "Binance",
    "year": 2024,
    "url": "https://www.binance.com/en/support/faq",
    "type": "documentation",
}
_REF_BINANCE_FUTURES = {
    "title": "Binance Futures: Introduction to Margin",
    "author": "Binance",
    "year": 2024,
    "url": "https://www.binance.com/en/support/faq/futures",
    "type": "documentation",
}
_REF_TRADINGVIEW = {
    "title": "TradingView Charting Basics",
    "author": "TradingView",
    "year": 2024,
    "url": "https://www.tradingview.com/support/",
    "type": "documentation",
}
_REF_INVESTOPEDIA_RR = {
    "title": "Risk/Reward Ratio",
    "author": "Investopedia",
    "year": 2024,
    "url": "https://www.investopedia.com/terms/r/riskrewardratio.asp",
    "type": "article",
}
_REF_COINGLASS = {
    "title": "Funding Rate & Open Interest",
    "author": "CoinGlass",
    "year": 2024,
    "url": "https://www.coinglass.com/",
    "type": "data",
}
_REF_SEC_CRYPTO = {
    "title": "Investor Alerts: Crypto Assets",
    "author": "U.S. SEC",
    "year": 2024,
    "url": "https://www.sec.gov/crypto",
    "type": "regulation",
}

DEFAULT_REFERENCES: dict[int, list[dict]] = {
    1: [_REF_BINANCE_SPOT, _REF_BINANCE_FUTURES, _REF_MURPHY],
    2: [_REF_BINANCE_SPOT, _REF_INVESTOPEDIA_RR],
    3: [_REF_MURPHY, _REF_TRADINGVIEW],
    4: [_REF_MURPHY, _REF_TRADINGVIEW],
    5: [_REF_BINANCE_SPOT, _REF_TRADINGVIEW],
    6: [_REF_MURPHY, _REF_TRADINGVIEW],
    7: [_REF_INVESTOPEDIA_RR, _REF_SEC_CRYPTO],
    8: [_REF_MURPHY, _REF_TRADINGVIEW],
    9: [_REF_MURPHY, _REF_TRADINGVIEW],
    10: [_REF_MURPHY, _REF_TRADINGVIEW],
    11: [_REF_BINANCE_SPOT, _REF_SEC_CRYPTO],
    12: [_REF_BINANCE_SPOT, _REF_INVESTOPEDIA_RR],
    13: [_REF_MURPHY, _REF_TRADINGVIEW],
    14: [_REF_MURPHY, _REF_TRADINGVIEW],
    15: [_REF_MURPHY, _REF_TRADINGVIEW],
    16: [_REF_TRADINGVIEW, _REF_MURPHY],
    17: [_REF_TRADINGVIEW, _REF_COINGLASS],
    18: [_REF_INVESTOPEDIA_RR, _REF_BINANCE_FUTURES],
    19: [_REF_MURPHY, _REF_TRADINGVIEW],
    20: [_REF_SEC_CRYPTO, _REF_INVESTOPEDIA_RR],
    21: [_REF_INVESTOPEDIA_RR, _REF_MURPHY],
    22: [_REF_BINANCE_SPOT, _REF_TRADINGVIEW],
    23: [_REF_INVESTOPEDIA_RR, _REF_TRADINGVIEW],
    24: [_REF_MURPHY, _REF_COINGLASS],
    25: [_REF_COINGLASS, _REF_TRADINGVIEW],
    26: [_REF_TRADINGVIEW, _REF_MURPHY],
    27: [_REF_COINGLASS, _REF_TRADINGVIEW],
    28: [_REF_INVESTOPEDIA_RR, _REF_SEC_CRYPTO],
    29: [_REF_TRADINGVIEW, _REF_MURPHY],
    30: [_REF_INVESTOPEDIA_RR, _REF_TRADINGVIEW],
    31: [_REF_INVESTOPEDIA_RR, _REF_BINANCE_FUTURES],
    32: [_REF_MURPHY, _REF_TRADINGVIEW],
    33: [_REF_INVESTOPEDIA_RR, _REF_TRADINGVIEW],
    34: [_REF_TRADINGVIEW, _REF_COINGLASS],
    35: [_REF_SEC_CRYPTO, _REF_INVESTOPEDIA_RR],
    36: [_REF_BINANCE_SPOT, _REF_SEC_CRYPTO],
    37: [_REF_BINANCE_SPOT, _REF_SEC_CRYPTO],
    38: [_REF_TRADINGVIEW, _REF_MURPHY],
    39: [_REF_BINANCE_FUTURES, _REF_COINGLASS],
    40: [_REF_INVESTOPEDIA_RR, _REF_SEC_CRYPTO],
    41: [_REF_TRADINGVIEW, _REF_COINGLASS],
    42: [_REF_TRADINGVIEW, _REF_MURPHY],
    43: [_REF_MURPHY, _REF_TRADINGVIEW],
    44: [_REF_BINANCE_SPOT, _REF_SEC_CRYPTO],
    45: [_REF_MURPHY, _REF_TRADINGVIEW],
    46: [_REF_MURPHY, _REF_TRADINGVIEW],
    47: [_REF_MURPHY, _REF_TRADINGVIEW],
}

PREREQUISITES: dict[int, list[int]] = {
    2: [1],
    3: [2],
    4: [3],
    5: [4],
    6: [4],
    7: [4, 18],
    8: [4, 14, 15],
    9: [8],
    10: [4, 13],
    11: [1, 7],
    12: [2, 18],
    13: [14, 15],
    14: [4],
    15: [4],
    16: [14, 15],
    17: [16],
    18: [2],
    19: [8, 9],
    20: [18, 7],
    21: [18, 14],
    22: [5, 2],
    23: [18, 21],
    24: [14, 15, 25],
    25: [14, 16],
    26: [25],
    27: [25, 26],
    28: [18, 7],
    29: [14, 23],
    30: [29, 33],
    31: [18, 7],
    32: [14, 15],
    33: [23, 30],
    34: [17],
    35: [7, 20],
    36: [1],
    37: [5],
    38: [26, 42],
    39: [1, 18],
    40: [7, 31],
    41: [16, 37],
    42: [26, 34],
    43: [14, 21],
    44: [12, 20],
    45: [4, 8],
    46: [8, 19],
    47: [46],
}

LEARNING_OUTCOMES: dict[int, list[dict]] = {
    i: [
        {
            "id": f"L{i}-1",
            "bloom": "understand",
            "text_ru": "Объяснить ключевую идею урока своими словами",
            "text_en": "Explain the lesson core idea in your own words",
            "text_pt": "Explicar a ideia central da lição com suas palavras",
        },
        {
            "id": f"L{i}-2",
            "bloom": "apply",
            "text_ru": "Разметить сетап на графике TradingView без входа в сделку",
            "text_en": "Mark the setup on TradingView without entering a live trade",
            "text_pt": "Marcar o setup no TradingView sem entrar em trade real",
        },
        {
            "id": f"L{i}-3",
            "bloom": "analyze",
            "text_ru": "Записать в журнал вход, стоп, цель и риск в % депозита",
            "text_en":         "Log entry, stop, target and risk % in the journal",
            "text_pt": "Registrar entrada, stop, alvo e risco % no diário",
        },
    ]
    for i in range(1, 48)
}

OUTCOME_EN = [
    "Explain the lesson core idea in your own words",
    "Mark the setup on TradingView without entering a live trade",
    "Log entry, stop, target and risk % in the journal",
]
OUTCOME_PT = [
    "Explicar a ideia central da lição com suas palavras",
    "Marcar o setup no TradingView sem entrar em trade real",
    "Registrar entrada, stop, alvo e risco % no diário",
]


def references_for(lesson_id: int) -> list[dict]:
    return DEFAULT_REFERENCES.get(lesson_id, [_REF_MURPHY, _REF_TRADINGVIEW])


def prerequisites_for(lesson_id: int) -> list[int]:
    return PREREQUISITES.get(lesson_id, [])


def outcomes_for(lesson_id: int, lang: str) -> list[str]:
    key = {"ru": "text_ru", "en": "text_en", "pt": "text_pt"}[lang]
    return [o[key] for o in LEARNING_OUTCOMES.get(lesson_id, [])]
