#!/usr/bin/env python3
"""Patch build_quizzes in build_linear_curriculum.py to emit 3Q/lesson."""
from pathlib import Path

ROOT = Path(__file__).resolve().parent
target = ROOT / "build_linear_curriculum.py"
text = target.read_text(encoding="utf-8")
start = text.index("def build_quizzes")
end = text.index("def build_syllabus")

new = r'''def build_quizzes(ru_lessons: list[dict]) -> list[dict]:
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


'''

target.write_text(text[:start] + new + text[end:], encoding="utf-8")
print("patched build_quizzes")
