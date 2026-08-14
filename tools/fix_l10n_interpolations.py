#!/usr/bin/env python3
"""Fix broken Dart string interpolations in app_localizations.dart after MT."""

from __future__ import annotations

import re
from pathlib import Path

PATH = Path(__file__).resolve().parent.parent / "lib" / "l10n" / "app_localizations.dart"

# Bad MT interpolations → correct Dart interpolation / literal
REPLACEMENTS = [
    ("$título", r"$title"),
    ("$día", r"$day"),
    ("$d ", r"$day "),  # careful
    ("$actual", r"$current"),
    ("$puntuación", r"$score"),
    ("$puntuaci", r"$score"),  # truncated
    ("$hechas", r"$done"),
    ("$lecciones", r"$total"),  # context-dependent, fixed manually below
    ("$preguntas", r"$questions"),
    ("$minutos", r"$minutes"),
]

# Manual line-level fixes for ambiguous cases (old → new substring)
MANUAL = [
    (
        "'Lección $id: $título'",
        "'Lección $id: $title'",
    ),
    (
        "'Día $día de $total'",
        "'Día $day de $total'",
    ),
    (
        "'Progresso: $done lições (meta hoje: $expected de $totalLessons)',\n      );",
        "'Progresso: $done aulas (meta hoje: $expected de $totalLessons)',\n"
        "        'Progreso: $done clases (meta de hoy: $expected de $totalLessons)',\n"
        "      );",
    ),
]


def fix_method_optional(src: str) -> str:
    """Ensure _t 4th arg is optional so 3-arg calls compile."""
    src = re.sub(
        r"String _t\(String en, String ru, String pt, String es\)",
        "String _t(String en, String ru, String pt, [String? es])",
        src,
    )
    # ensure es case uses es ?? en
    src = re.sub(
        r"case AppLanguage\.es:\s*\n\s*return es;",
        "case AppLanguage.es:\n        return es ?? en;",
        src,
    )
    return src


def main() -> None:
    text = PATH.read_text(encoding="utf-8")
    for a, b in MANUAL:
        text = text.replace(a, b)
    for a, b in REPLACEMENTS:
        text = text.replace(a, b)

    # Fix leftover broken $words with unicode letters in single-quoted strings
    def fix_interp(m: re.Match) -> str:
        name = m.group(1)
        mapping = {
            "título": "title",
            "día": "day",
            "actual": "current",
            "puntuación": "score",
            "hechas": "done",
            "lecciones": "lessons",
            "preguntas": "questions",
            "minutos": "minutes",
            "experiencia": None,  # literal 'XP' already handled
        }
        if name in mapping and mapping[name]:
            return f"${mapping[name]}"
        # Unknown: escape as literal
        return "\\$" + name

    text = re.sub(r"\$([A-Za-záéíóúñüÁÉÍÓÚÑÜ]+)", fix_interp, text)

    # Undoing over-escape of valid dart ids
    for valid in (
        "id",
        "title",
        "day",
        "total",
        "done",
        "expected",
        "totalLessons",
        "questions",
        "minutes",
        "lessons",
        "score",
        "current",
        "needed",
        "n",
        "p",
        "pct",
        "min",
        "rr",
        "xp",
        "amount",
        "c",
        "t",
    ):
        text = text.replace(f"\\${valid}", f"${valid}")

    text = fix_method_optional(text)
    PATH.write_text(text, encoding="utf-8")
    print("fixed", PATH, flush=True)


if __name__ == "__main__":
    main()
