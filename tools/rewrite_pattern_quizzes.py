#!/usr/bin/env python3
"""Replace boilerplate pattern quizzes with geometry-focused questions."""

from __future__ import annotations

import json
from pathlib import Path

DATA = Path(__file__).resolve().parents[1] / "assets" / "data" / "lesson_quizzes.json"

NEW = [
    {
        "lessonId": 8,
        "id": "L8-Q1",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Что обязательно для нисходящего треугольника?",
            "en": "What is required for a descending triangle?",
            "pt": "O que é obrigatório no triângulo descendente?",
        },
        "options": {
            "ru": [
                "Горизонтальная поддержка + понижающиеся максимумы",
                "Обе границы наклонены вниз как у клина",
                "Только три свечи подряд вниз",
                "Горизонтальное сопротивление + higher lows",
            ],
            "en": [
                "Flat support + lower highs",
                "Both borders sloping down like a wedge",
                "Only three red candles in a row",
                "Flat resistance + higher lows",
            ],
            "pt": [
                "Suporte horizontal + máximas descendentes",
                "As duas bordas inclinadas para baixo como na cunha",
                "Apenas três velas vermelhas seguidas",
                "Resistência horizontal + higher lows",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Плоский «пол» + lower highs. Наклон обеих границ — это клин, не треугольник.",
            "en": "Flat floor + lower highs. Both borders sloping = wedge, not triangle.",
            "pt": "Piso flat + lower highs. Duas bordas inclinadas = cunha, não triângulo.",
        },
    },
    {
        "lessonId": 8,
        "id": "L8-Q2",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Поддержка 100, максимум фигуры 108. Пробой вниз. Какая цель measured move?",
            "en": "Support 100, pattern high 108. Break down. Measured-move target?",
            "pt": "Suporte 100, máxima 108. Rompimento para baixo. Alvo measured move?",
        },
        "options": {
            "ru": ["92", "108", "100", "116"],
            "en": ["92", "108", "100", "116"],
            "pt": ["92", "108", "100", "116"],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "H = 108 − 100 = 8; цель = 100 − 8 = 92.",
            "en": "H = 108 − 100 = 8; target = 100 − 8 = 92.",
            "pt": "H = 108 − 100 = 8; alvo = 100 − 8 = 92.",
        },
    },
    {
        "lessonId": 8,
        "id": "L8-Q3",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Когда входить в шорт по нисходящему треугольнику?",
            "en": "When to enter short on a descending triangle?",
            "pt": "Quando entrar short no triângulo descendente?",
        },
        "options": {
            "ru": [
                "После close ниже поддержки (часто + ретест)",
                "Из середины фигуры «потому что похоже»",
                "По тени ниже поддержки без close",
                "Сразу после первой касания поддержки",
            ],
            "en": [
                "After a close below support (often + retest)",
                "From mid-pattern “because it looks like one”",
                "On a wick below support without a close",
                "Right after the first support touch",
            ],
            "pt": [
                "Após close abaixo do suporte (muitas vezes + reteste)",
                "No meio da figura “porque parece”",
                "No pavio abaixo do suporte sem close",
                "Logo após o primeiro toque no suporte",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Триггер — закрытие ниже поддержки. Тень и середина фигуры — не сетап.",
            "en": "Trigger is a close below support. Wick / mid-pattern is not the setup.",
            "pt": "Gatilho = close abaixo do suporte. Pavio / meio da figura não é setup.",
        },
    },
    {
        "lessonId": 9,
        "id": "L9-Q1",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Геометрия восходящего треугольника?",
            "en": "Ascending triangle geometry?",
            "pt": "Geometria do triângulo ascendente?",
        },
        "options": {
            "ru": [
                "Горизонтальное сопротивление + higher lows",
                "Горизонтальная поддержка + lower highs",
                "Обе границы вверх (клин)",
                "Три равных вершины",
            ],
            "en": [
                "Flat resistance + higher lows",
                "Flat support + lower highs",
                "Both borders rising (wedge)",
                "Three equal peaks",
            ],
            "pt": [
                "Resistência horizontal + higher lows",
                "Suporte horizontal + lower highs",
                "Duas bordas subindo (cunha)",
                "Três topos iguais",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Плоский потолок + растущие минимумы.",
            "en": "Flat ceiling + rising lows.",
            "pt": "Teto flat + mínimas ascendentes.",
        },
    },
    {
        "lessonId": 9,
        "id": "L9-Q2",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Сопротивление 3200, low фигуры 3100. Пробой вверх. Цель?",
            "en": "Resistance 3200, pattern low 3100. Break up. Target?",
            "pt": "Resistência 3200, mínima 3100. Rompimento de alta. Alvo?",
        },
        "options": {
            "ru": ["3300", "3100", "3150", "3000"],
            "en": ["3300", "3100", "3150", "3000"],
            "pt": ["3300", "3100", "3150", "3000"],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "H = 100; цель = 3200 + 100 = 3300.",
            "en": "H = 100; target = 3200 + 100 = 3300.",
            "pt": "H = 100; alvo = 3200 + 100 = 3300.",
        },
    },
    {
        "lessonId": 9,
        "id": "L9-Q3",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Где поставить стоп long после пробоя восходящего треугольника?",
            "en": "Where to place the long stop after an ascending-triangle break?",
            "pt": "Onde colocar o stop do long após rompimento do triângulo ascendente?",
        },
        "options": {
            "ru": [
                "Под ретестом / последним higher low",
                "Над сопротивлением",
                "Над головой паттерна H&S",
                "Ровно на цене входа",
            ],
            "en": [
                "Under the retest / last higher low",
                "Above resistance",
                "Above an H&S head",
                "Exactly at entry",
            ],
            "pt": [
                "Abaixo do reteste / último higher low",
                "Acima da resistência",
                "Acima da cabeça de um H&S",
                "Exatamente na entrada",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Стоп под структурой (последний HL / ретест), не внутри фигуры над HL.",
            "en": "Stop under structure (last HL / retest), not inside above the HL.",
            "pt": "Stop sob a estrutura (último HL / reteste), não dentro acima do HL.",
        },
    },
    {
        "lessonId": 19,
        "id": "L19-Q1",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Симметричный треугольник — что верно?",
            "en": "Symmetric triangle — which is true?",
            "pt": "Triângulo simétrico — o que é verdade?",
        },
        "options": {
            "ru": [
                "Highs ↓ и lows ↑ сходятся; направление — по close за границей",
                "Всегда торгуем только вверх",
                "Тень за границей = пробой",
                "Линии границ должны обязательно пересечься «наоборот»",
            ],
            "en": [
                "Highs ↓ and lows ↑ converge; direction follows the close beyond the border",
                "Always trade only long",
                "A wick beyond the border equals a breakout",
                "Border lines must cross upside-down",
            ],
            "pt": [
                "Highs ↓ e lows ↑ convergem; direção = close além da borda",
                "Sempre só long",
                "Pavio além da borda = rompimento",
                "As bordas devem se cruzar ao contrário",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Сжатие без заранее заданного направления; пробой = close.",
            "en": "Squeeze without a pre-set direction; breakout = close.",
            "pt": "Compressão sem direção pré-definida; rompimento = close.",
        },
    },
    {
        "lessonId": 19,
        "id": "L19-Q2",
        "difficulty": "Intermediate",
        "question": {
            "ru": "H = 60, close пробоя вверх 592. Measured move цель?",
            "en": "H = 60, upside break close 592. Measured-move target?",
            "pt": "H = 60, close de alta 592. Alvo measured move?",
        },
        "options": {
            "ru": ["652", "532", "592", "620"],
            "en": ["652", "532", "592", "620"],
            "pt": ["652", "532", "592", "620"],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Цель ≈ 592 + 60 = 652.",
            "en": "Target ≈ 592 + 60 = 652.",
            "pt": "Alvo ≈ 592 + 60 = 652.",
        },
    },
    {
        "lessonId": 19,
        "id": "L19-Q3",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Где измеряют высоту H симметричного треугольника?",
            "en": "Where do you measure H on a symmetric triangle?",
            "pt": "Onde se mede H no triângulo simétrico?",
        },
        "options": {
            "ru": [
                "У самой широкой части (основания)",
                "Только у апекса",
                "По ATR(14)",
                "По размеру последней свечи",
            ],
            "en": [
                "At the widest part (the base)",
                "Only at the apex",
                "From ATR(14)",
                "From the last candle size",
            ],
            "pt": [
                "Na parte mais larga (base)",
                "Só no ápice",
                "Pelo ATR(14)",
                "Pelo tamanho da última vela",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "H берут у основания — самой широкой части фигуры.",
            "en": "H is taken at the base — the widest part of the pattern.",
            "pt": "H se mede na base — a parte mais larga da figura.",
        },
    },
    {
        "lessonId": 46,
        "id": "L46-Q1",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Классический H&S: где головa относительно плеч?",
            "en": "Classic H&S: where is the head vs shoulders?",
            "pt": "H&S clássico: onde está a cabeça em relação aos ombros?",
        },
        "options": {
            "ru": [
                "Голова выше обоих плеч",
                "Голова ниже обоих плеч",
                "Все три пика на одном уровне",
                "Голова только на 5m",
            ],
            "en": [
                "Head higher than both shoulders",
                "Head lower than both shoulders",
                "All three peaks at one level",
                "Head only on 5m",
            ],
            "pt": [
                "Cabeça mais alta que os dois ombros",
                "Cabeça mais baixa que os dois ombros",
                "Três topos no mesmo nível",
                "Cabeça só em 5m",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Средний пик (голова) заметно выше левого и правого плеча.",
            "en": "The middle peak (head) is clearly higher than left and right shoulders.",
            "pt": "O pico do meio (cabeça) fica claramente acima dos ombros.",
        },
    },
    {
        "lessonId": 46,
        "id": "L46-Q2",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Плечи 65000, голова 68000, шея 63000. Цель short после пробоя шеи?",
            "en": "Shoulders 65000, head 68000, neck 63000. Short target after neck break?",
            "pt": "Ombros 65000, cabeça 68000, pescoço 63000. Alvo short após o rompimento?",
        },
        "options": {
            "ru": ["58000", "68000", "65000", "70000"],
            "en": ["58000", "68000", "65000", "70000"],
            "pt": ["58000", "68000", "65000", "70000"],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "H = 5000; цель = 63000 − 5000 = 58000.",
            "en": "H = 5000; target = 63000 − 5000 = 58000.",
            "pt": "H = 5000; alvo = 63000 − 5000 = 58000.",
        },
    },
    {
        "lessonId": 46,
        "id": "L46-Q3",
        "difficulty": "Intermediate",
        "question": {
            "ru": "Триггер входа short по H&S?",
            "en": "Short entry trigger on H&S?",
            "pt": "Gatilho de entrada short no H&S?",
        },
        "options": {
            "ru": [
                "Close ниже линии шеи",
                "Касание головы",
                "Формирование левого плеча",
                "Тень ниже шеи без close",
            ],
            "en": [
                "Close below the neckline",
                "Touching the head",
                "Forming the left shoulder",
                "Wick below the neck without a close",
            ],
            "pt": [
                "Close abaixo da linha do pescoço",
                "Toque na cabeça",
                "Formação do ombro esquerdo",
                "Pavio abaixo do pescoço sem close",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Без close ниже шеи — это ещё не подтверждённый H&S-сетап.",
            "en": "Without a close below the neck it is not a confirmed H&S setup.",
            "pt": "Sem close abaixo do pescoço ainda não é setup H&S confirmado.",
        },
    },
    {
        "lessonId": 47,
        "id": "L47-Q1",
        "difficulty": "Advanced",
        "question": {
            "ru": "Чем inverse H&S отличается от классики?",
            "en": "How does inverse H&S differ from the classic?",
            "pt": "Como o H&S invertido difere do clássico?",
        },
        "options": {
            "ru": [
                "Три впадины, голова глубже; пробой шеи вверх",
                "Три вершины, голова выше; пробой шеи вниз",
                "Только на мем-токенах",
                "Всегда без линии шеи",
            ],
            "en": [
                "Three troughs, deeper head; neck break up",
                "Three peaks, higher head; neck break down",
                "Only on meme tokens",
                "Always without a neckline",
            ],
            "pt": [
                "Três fundos, cabeça mais profunda; rompimento do pescoço para cima",
                "Três topos, cabeça mais alta; rompimento do pescoço para baixo",
                "Só em meme tokens",
                "Sempre sem linha do pescoço",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Зеркало: дно-голова-дно и long после close выше шеи.",
            "en": "Mirror image: trough-head-trough and long after close above the neck.",
            "pt": "Espelho: fundo-cabeça-fundo e long após close acima do pescoço.",
        },
    },
    {
        "lessonId": 47,
        "id": "L47-Q2",
        "difficulty": "Advanced",
        "question": {
            "ru": "Плечи 2200, голова 2000, шея 2400. Цель long?",
            "en": "Shoulders 2200, head 2000, neck 2400. Long target?",
            "pt": "Ombros 2200, cabeça 2000, pescoço 2400. Alvo long?",
        },
        "options": {
            "ru": ["2800", "2000", "2400", "1800"],
            "en": ["2800", "2000", "2400", "1800"],
            "pt": ["2800", "2000", "2400", "1800"],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "H = 400; цель = 2400 + 400 = 2800.",
            "en": "H = 400; target = 2400 + 400 = 2800.",
            "pt": "H = 400; alvo = 2400 + 400 = 2800.",
        },
    },
    {
        "lessonId": 47,
        "id": "L47-Q3",
        "difficulty": "Advanced",
        "question": {
            "ru": "Где стоп long по inverse H&S?",
            "en": "Where is the long stop on inverse H&S?",
            "pt": "Onde fica o stop do long no H&S invertido?",
        },
        "options": {
            "ru": [
                "Под правым плечом",
                "Над головой",
                "Ровно на линии шеи",
                "Над левым плечом",
            ],
            "en": [
                "Under the right shoulder",
                "Above the head",
                "Exactly on the neckline",
                "Above the left shoulder",
            ],
            "pt": [
                "Abaixo do ombro direito",
                "Acima da cabeça",
                "Exatamente na linha do pescoço",
                "Acima do ombro esquerdo",
            ],
        },
        "correctIndex": 0,
        "explanation": {
            "ru": "Стоп под правым плечом — за последней защитной структурой long.",
            "en": "Stop under the right shoulder — beyond the last protective long structure.",
            "pt": "Stop sob o ombro direito — além da última estrutura de proteção do long.",
        },
    },
]


def main() -> None:
    quizzes = json.loads(DATA.read_text(encoding="utf-8"))
    drop_ids = {q["id"] for q in NEW}
    kept = [q for q in quizzes if q.get("id") not in drop_ids]
    # Insert new quizzes roughly where old ones were (by lessonId order).
    out = []
    inserted = set()
    for q in kept:
        lid = q.get("lessonId")
        if lid in {8, 9, 19, 46, 47} and lid not in inserted:
            out.extend([nq for nq in NEW if nq["lessonId"] == lid])
            inserted.add(lid)
        if q.get("lessonId") not in {8, 9, 19, 46, 47}:
            out.append(q)
    for lid in (8, 9, 19, 46, 47):
        if lid not in inserted:
            out.extend([nq for nq in NEW if nq["lessonId"] == lid])
    DATA.write_text(json.dumps(out, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Rewrote quizzes for lessons {sorted({q['lessonId'] for q in NEW})}; total={len(out)}")


if __name__ == "__main__":
    main()
