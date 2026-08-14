#!/usr/bin/env python3
"""Build RU/EN/PT/ES lesson JSON, syllabus, quizzes from linear curriculum."""

from __future__ import annotations

import json
import random
from pathlib import Path

from _linear_i18n import I18N, MODULES

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets" / "data"
RU_SRC = Path(__file__).resolve().parent / "_linear_ru.json"

# Early spot lessons must NOT map to risk_reward.
KIT_CHART = {
    "support": "candlestick",
    "resist": "candlestick",
    "flip": "candlestick",
    "hhhl": "candlestick",
    "lhll": "candlestick",
    "channel": "channel",
    "fakeout": "candlestick",
    "impulse": "candlestick",
    "triDown": "descending_triangle",
    "triUp": "ascending_triangle",
    "triSym": "symmetric_triangle",
    "wedge": "candlestick",
    "double": "candlestick",
    "flag": "candlestick",
    "hs": "head_shoulders",
    "ihs": "inverse_head_shoulders",
    "fib": "fibonacci",
    "range": "candlestick",
    "dump": "candlestick",
    "news": "candlestick",
    "chop": "candlestick",
    "equity": "candlestick",
}

UI = {
    "remember": {"ru": "Запомнить", "en": "Remember", "pt": "Lembre", "es": "Recuerda"},
    "one": {"ru": "Одной фразой", "en": "In one sentence", "pt": "Em uma frase", "es": "En una frase"},
    "one_body": {
        "ru": "Выбери верную фразу.",
        "en": "Pick the correct sentence.",
        "pt": "Escolha a frase certa.",
        "es": "Elige la frase correcta.",
    },
    "do": {
        "ru": "Сделай: что верно?",
        "en": "Do: which is true?",
        "pt": "Faça: o que é verdade?",
        "es": "Haz: ¿qué es cierto?",
    },
    "hw": {"ru": "Домашка", "en": "Homework", "pt": "Tarefa", "es": "Tarea"},
    "hw_body": {
        "ru": "Напиши ответ своими словами и отправь в топик homework чата Desk Club.",
        "en": "Write the answer in your own words and send it to the Desk Club homework topic.",
        "pt": "Escreva a resposta com suas palavras e envie no tópico homework do Desk Club.",
        "es": "Escribe la respuesta con tus palabras y envíala al tema homework de Desk Club.",
    },
    "journal": {"ru": "Журнал", "en": "Journal", "pt": "Diário", "es": "Diario"},
    "journal_body": {
        "ru": "Запиши одной фразой, что запомнил, и дату урока.",
        "en": "Write in one sentence what you kept, plus the lesson date.",
        "pt": "Anote em uma frase o que ficou, e a data da aula.",
        "es": "Anota en una frase lo que te quedó, y la fecha de la lección.",
    },
    "practice": {"ru": "Практика", "en": "Practice", "pt": "Prática", "es": "Práctica"},
    "practice_body": {
        "ru": "Открой симулятор. Потом вернись к уроку кнопкой «Вернуться к уроку».",
        "en": "Open the simulator. Then return with Back to lesson.",
        "pt": "Abra o simulador. Depois volte com Voltar à aula.",
        "es": "Abre el simulador. Luego vuelve con Volver a la lección.",
    },
    "chart": {"ru": "Смотри график", "en": "Look at the chart", "pt": "Olhe o gráfico", "es": "Mira el gráfico"},
    "outcome": {
        "ru": "Поймёшь тему на графике, выберешь верную фразу и сдашь домашку.",
        "en": "You'll read the chart idea, pick the right sentence, and submit homework.",
        "pt": "Você lê a ideia no gráfico, escolhe a frase certa e envia a tarefa.",
        "es": "Entenderás la idea en el gráfico, elegirás la frase correcta y entregarás la tarea.",
    },
    "lo_see": {
        "ru": "Увидишь идею на учебном графике",
        "en": "See the idea on a practice chart",
        "pt": "Ver a ideia no gráfico de prática",
        "es": "Ver la idea en el gráfico de práctica",
    },
    "lo_pick": {
        "ru": "Отличишь верный ответ от ловушки",
        "en": "Tell the right answer from the trap",
        "pt": "Separar a resposta certa da armadilha",
        "es": "Separar la respuesta correcta de la trampa",
    },
    "lo_hw": {
        "ru": "Сдашь одной фразой в homework Desk Club",
        "en": "Submit one sentence to Desk Club homework",
        "pt": "Enviar uma frase no homework do Desk Club",
        "es": "Enviar una frase al homework de Desk Club",
    },
}


# Topic card titles (6 content cards) — not 10 micro-beats
TOPICS = {
    "ru": ["Суть", "Как выглядит", "Плюс / правило", "Минус / ловушка", "Сравни", "Запомни"],
    "en": ["The point", "How it looks", "Upside / rule", "Downside / trap", "Compare", "Keep this"],
    "pt": ["A essência", "Como aparece", "Pró / regra", "Contra / armadilha", "Compare", "Guarde"],
    "es": ["La idea", "Cómo se ve", "Plus / regla", "Minus / trampa", "Compara", "Quédate"],
}


def difficulty(n: int) -> str:
    if n <= 14:
        return "Beginner"
    if n <= 36:
        return "Intermediate"
    return "Advanced"


def chart_for(n: int, kit: str) -> str:
    if n <= 3:
        return "candlestick"
    if kit in ("triDown", "triUp", "triSym", "hs", "ihs", "fib", "channel"):
        return KIT_CHART[kit]
    if n >= 47 and kit == "range" and n == 47:
        return "order_book"
    return KIT_CHART.get(kit, "candlestick")


def ru_hw(src: dict) -> list[str]:
    return [
        f"Одной фразой: {src['grandma']}",
        f"Ответь: {src['lines'][6]}",
        "Назови ловушку своими словами.",
        "Отправь в топик homework / Домашки в Desk Club (@Desk_Club) с тегом #hw-submitted.",
    ]


def topic_bodies(lines: list[str]) -> list[str]:
    """Merge 10 micro-lines into 6 meaningful cards. Skip empty phrase prompt (idx 8)."""
    return [
        lines[0],
        lines[1],
        f"{lines[2]}\n\n{lines[3]}" if len(lines) > 3 else lines[2],
        f"{lines[4]}\n\n{lines[7]}" if len(lines) > 7 else lines[4],
        lines[5],
        lines[9] if len(lines) > 9 else lines[-1],
    ]


def shuffle_options(options: list[str], correct_index: int, seed: int) -> tuple[list[str], int]:
    """Deterministic shuffle so correct answer is not always first."""
    indexed = list(enumerate(options))
    rng = random.Random(seed)
    rng.shuffle(indexed)
    new_opts = [text for _, text in indexed]
    new_correct = next(i for i, (old_i, _) in enumerate(indexed) if old_i == correct_index)
    return new_opts, new_correct


def inject_take_word(n: int, text: str, lang: str) -> str:
    """Ensure take-profit word appears in trade module."""
    if n not in (37, 40, 43, 45):
        return text
    markers = {
        "ru": "Стоп — выход в минус. Тейк — выход в плюс по плану.",
        "en": "Stop exits the loss. Take-profit exits the win by plan.",
        "pt": "Stop sai no prejuízo. Take sai no lucro conforme o plano.",
        "es": "Stop sale en pérdida. Take sale en ganancia según el plan.",
    }
    extra = markers[lang]
    if "тейк" in text.lower() or "take" in text.lower():
        return text
    return f"{text}\n\n{extra}"


def build_lesson(src: dict, lang: str) -> dict:
    n = src["id"]
    loc = I18N[n][lang] if lang != "ru" else None
    module = src["module"] if lang == "ru" else MODULES[src["module"]][lang]
    title = src["title"] if lang == "ru" else loc["title"]
    takeaway = src["grandma"] if lang == "ru" else loc["one"]
    if lang == "ru":
        lines = list(src["lines"])
        sub = lines[1] if len(lines) > 1 else lines[0]
        outcome = UI["outcome"][lang]
        content = lines[0]
        do_live, do_dead, do_soon = src["doLive"], src["doDead"], src["doSoon"]
        do_answer = src["doAnswer"]
        bad1, bad2 = src["bad1"], src["bad2"]
        hw = ru_hw(src)
        phrase_opts = [src["grandma"], bad1, bad2]
        do_q = lines[6]
    else:
        lines = list(loc["lines"])
        sub = lines[1] if len(lines) > 1 else lines[0]
        outcome = UI["outcome"][lang]
        content = loc["content"]
        do_live, do_dead, do_soon = loc["doLive"], loc["doDead"], loc["doSoon"]
        do_answer = src["doAnswer"]
        bad1, bad2 = loc["bad1"], loc["bad2"]
        hw = loc["hw"]
        phrase_opts = [loc["one"], bad1, bad2]
        do_q = loc["lines"][6]

    chart = chart_for(n, src["kit"])
    topics = TOPICS[lang]
    bodies = topic_bodies(lines)
    bodies[2] = inject_take_word(n, bodies[2], lang)
    bodies[5] = inject_take_word(n, bodies[5], lang)

    sections: list[dict] = []
    card = 0

    for i, (topic, body) in enumerate(zip(topics, bodies)):
        sections.append({"type": "heading", "title": topic})
        sections.append({
            "type": "text",
            "body": body,
            "chartType": chart,
            "cardIndex": card,
            "caption": topic,
        })
        card += 1

    order = ["live", "dead", "soon"]
    do_opts = [do_live, do_dead, do_soon]
    do_correct = order.index(do_answer)

    phrase_opts, phrase_correct = shuffle_options(phrase_opts, 0, n * 17 + 1)
    do_opts, do_correct = shuffle_options(do_opts, do_correct, n * 17 + 2)

    sections.append({
        "type": "choice",
        "title": UI["one"][lang],
        "body": UI["one_body"][lang],
        "items": phrase_opts,
        "correctIndex": phrase_correct,
        "chartType": chart,
        "cardIndex": card,
        "caption": UI["one"][lang],
    })
    card += 1

    sections.append({
        "type": "choice",
        "title": UI["do"][lang],
        "body": do_q,
        "items": do_opts,
        "correctIndex": do_correct,
        "chartType": chart,
        "cardIndex": card,
        "caption": UI["do"][lang],
    })
    card += 1

    sections.append({
        "type": "homework",
        "title": UI["hw"][lang],
        "body": UI["hw_body"][lang],
        "items": hw,
        "url": "https://t.me/Desk_Club",
        "chartType": chart,
        "cardIndex": card,
        "caption": UI["hw"][lang],
    })
    card += 1

    sections.append({
        "type": "practice",
        "title": UI["practice"][lang],
        "body": UI["practice_body"][lang],
        "chartType": chart,
        "cardIndex": card,
        "caption": UI["practice"][lang],
    })
    card += 1

    sections.append({
        "type": "journal",
        "title": UI["journal"][lang],
        "body": UI["journal_body"][lang],
        "items": [takeaway],
        "chartType": chart,
        "cardIndex": card,
        "caption": UI["journal"][lang],
    })

    return {
        "id": n,
        "module": module,
        "title": title,
        "subtitle": sub,
        "difficulty": difficulty(n),
        "durationMin": 12 if n <= 14 else 16 if n <= 36 else 18,
        "outcome": outcome,
        "content": content,
        "takeaway": takeaway,
        "prerequisites": [] if n == 1 else [n - 1],
        "learningOutcomes": [
            UI["lo_see"][lang],
            UI["lo_pick"][lang],
            UI["lo_hw"][lang],
        ],
        "references": [],
        "sections": sections,
    }


def build_quizzes(ru_lessons: list[dict]) -> list[dict]:
    """3 questions per lesson from the linear curriculum, shuffled, 4 languages."""
    out: list[dict] = []
    q_trap = {
        "ru": "Какая ловушка этого урока?",
        "en": "What is the trap in this lesson?",
        "pt": "Qual é a armadilha desta aula?",
        "es": "¿Cuál es la trampa de esta lección?",
    }
    q_rule = {
        "ru": "Какое правило урока верное?",
        "en": "Which lesson rule is correct?",
        "pt": "Qual regra da aula está certa?",
        "es": "¿Qué regla de la lección es correcta?",
    }
    q_phrase = {
        "ru": "Какая фраза верная?",
        "en": "Which sentence is correct?",
        "pt": "Qual frase está certa?",
        "es": "¿Qué frase es la correcta?",
    }

    for src in ru_lessons:
        n = src["id"]
        en, pt, es = I18N[n]["en"], I18N[n]["pt"], I18N[n]["es"]
        diff = difficulty(n)

        phrase_sets = {
            "ru": [src["grandma"], src["bad1"], src["bad2"]],
            "en": [en["one"], en["bad1"], en["bad2"]],
            "pt": [pt["one"], pt["bad1"], pt["bad2"]],
            "es": [es["one"], es["bad1"], es["bad2"]],
        }
        order = list(range(3))
        random.Random(n * 17 + 1).shuffle(order)
        out.append({
            "lessonId": n,
            "id": f"L{n}-Q1",
            "difficulty": diff,
            "question": q_phrase,
            "options": {lang: [vals[i] for i in order] for lang, vals in phrase_sets.items()},
            "correctIndex": order.index(0),
            "explanation": {
                "ru": src["grandma"],
                "en": en["one"],
                "pt": pt["one"],
                "es": es["one"],
            },
        })

        ans = src["doAnswer"]
        live_dead_soon = ["live", "dead", "soon"]
        do_correct_raw = live_dead_soon.index(ans)
        do_sets = {
            "ru": [src["doLive"], src["doDead"], src["doSoon"]],
            "en": [en["doLive"], en["doDead"], en["doSoon"]],
            "pt": [pt["doLive"], pt["doDead"], pt["doSoon"]],
            "es": [es["doLive"], es["doDead"], es["doSoon"]],
        }
        do_order = list(range(3))
        random.Random(n * 17 + 2).shuffle(do_order)
        out.append({
            "lessonId": n,
            "id": f"L{n}-Q2",
            "difficulty": diff,
            "question": {
                "ru": src["lines"][6],
                "en": en["lines"][6],
                "pt": pt["lines"][6],
                "es": es["lines"][6],
            },
            "options": {lang: [vals[i] for i in do_order] for lang, vals in do_sets.items()},
            "correctIndex": do_order.index(do_correct_raw),
            "explanation": {
                "ru": src["grandma"],
                "en": en["one"],
                "pt": pt["one"],
                "es": es["one"],
            },
        })

        use_rule = n % 2 == 0
        if use_rule:
            correct_sets = {
                "ru": src["lines"][7],
                "en": en["lines"][7],
                "pt": pt["lines"][7],
                "es": es["lines"][7],
            }
            question = q_rule
        else:
            correct_sets = {
                "ru": src["lines"][4],
                "en": en["lines"][4],
                "pt": pt["lines"][4],
                "es": es["lines"][4],
            }
            question = q_trap

        trap_sets = {
            "ru": [correct_sets["ru"], src["bad1"], src["bad2"]],
            "en": [correct_sets["en"], en["bad1"], en["bad2"]],
            "pt": [correct_sets["pt"], pt["bad1"], pt["bad2"]],
            "es": [correct_sets["es"], es["bad1"], es["bad2"]],
        }
        t_order = list(range(3))
        random.Random(n * 17 + 3).shuffle(t_order)
        out.append({
            "lessonId": n,
            "id": f"L{n}-Q3",
            "difficulty": diff,
            "question": question,
            "options": {lang: [vals[i] for i in t_order] for lang, vals in trap_sets.items()},
            "correctIndex": t_order.index(0),
            "explanation": {
                "ru": correct_sets["ru"],
                "en": correct_sets["en"],
                "pt": correct_sets["pt"],
                "es": correct_sets["es"],
            },
        })

    return out


def build_syllabus(ru_lessons: list[dict]) -> dict:
    groups = []
    seen = []
    for src in ru_lessons:
        if src["module"] not in seen:
            seen.append(src["module"])
    hours = [8, 8, 14, 10, 12, 8, 12]
    for i, mod in enumerate(seen):
        ids = [x["id"] for x in ru_lessons if x["module"] == mod]
        first = next(x for x in ru_lessons if x["id"] == ids[0])
        groups.append({
            "id": ["spotfut", "chart", "levels", "patterns", "trade", "market", "risk"][i],
            "order": i + 1,
            "title": {
                "ru": mod,
                "en": MODULES[mod]["en"],
                "pt": MODULES[mod]["pt"],
                "es": MODULES[mod]["es"],
            },
            "hours": hours[i],
            "ects": round(hours[i] / 8, 1),
            "lessonIds": ids,
            "outcomes": {
                "ru": [first["grandma"], "Домашка в топик homework Desk Club", "Одной фразой после урока"],
                "en": [I18N[ids[0]]["en"]["one"], "Homework in the Desk Club homework topic", "One sentence after the lesson"],
                "pt": [I18N[ids[0]]["pt"]["one"], "Tarefa no tópico homework do Desk Club", "Uma frase depois da aula"],
                "es": [I18N[ids[0]]["es"]["one"], "Tarea en el tema homework de Desk Club", "Una frase después de la lección"],
            },
        })
    return {
        "version": "2026.8.2",
        "course": {
            "ru": "Трейдинг с нуля: спот, фьючерс, график",
            "en": "Trading from zero: spot, futures, the chart",
            "pt": "Trading do zero: spot, futuros, o gráfico",
            "es": "Trading desde cero: spot, futuros, el gráfico",
        },
        "institution": {
            "ru": "Trade Master",
            "en": "Trade Master",
            "pt": "Trade Master",
            "es": "Trade Master",
        },
        "totalHours": sum(hours),
        "totalEcts": round(sum(hours) / 8, 1),
        "totalLessons": 58,
        "finalAssessment": {
            "ru": "Тесты модулей + домашки в топике homework Desk Club",
            "en": "Module tests + homework in the Desk Club homework topic",
            "pt": "Testes dos módulos + tarefas no tópico homework do Desk Club",
            "es": "Tests de módulos + tareas en el tema homework de Desk Club",
        },
        "modules": groups,
    }


def main() -> None:
    ru_src = json.loads(RU_SRC.read_text(encoding="utf-8"))
    assert [x["id"] for x in ru_src] == list(range(1, 59))

    for lang, name in (("ru", "lessons_ru.json"), ("en", "lessons_en.json"), ("pt", "lessons_pt.json"), ("es", "lessons_es.json")):
        lessons = [build_lesson(src, lang) for src in ru_src]
        (ASSETS / name).write_text(json.dumps(lessons, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(name, len(lessons), "sections", len(lessons[0]["sections"]))

    quizzes = build_quizzes(ru_src)
    (ASSETS / "lesson_quizzes.json").write_text(json.dumps(quizzes, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("quizzes", len(quizzes))

    syllabus = build_syllabus(ru_src)
    (ASSETS / "syllabus.json").write_text(json.dumps(syllabus, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print("syllabus modules", len(syllabus["modules"]))


if __name__ == "__main__":
    main()
