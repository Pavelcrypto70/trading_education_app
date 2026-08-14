#!/usr/bin/env python3
"""Add high-quality Spanish 4th args to app_localizations.dart _t() calls."""

from __future__ import annotations

import json
import re
import sys
import time
from pathlib import Path

from deep_translator import GoogleTranslator

sys.stdout.reconfigure(encoding="utf-8", errors="replace")

L10N = Path(__file__).resolve().parent.parent / "lib" / "l10n" / "app_localizations.dart"
CACHE = Path(__file__).resolve().parent / ".latam_l10n_cache.json"

# Manual ES (and optional PT upgrades) for key UI — LATAM native tone
MANUAL_ES = {
    "Home": "Inicio",
    "Learn": "Aprender",
    "Quiz": "Quiz",
    "Practice": "Práctica",
    "Profile": "Perfil",
    "Cancel": "Cancelar",
    "Continue": "Continuar",
    "Reset": "Restablecer",
    "All": "Todos",
    "Error": "Error",
    "Done": "Listo",
    "New": "Nuevo",
    "Keep building your edge": "Sigue construyendo tu ventaja",
    "Paper Trading": "Trading simulado",
    "Practice buy & sell with virtual money": "Practica compra y venta con dinero virtual",
    "Daily Challenge": "Desafío diario",
    "Trade journal": "Diario de trades",
    "Get started": "Empezar",
    "Welcome to Trade Master": "Bienvenido a Trade Master",
    "Language": "Idioma",
    "Select language": "Seleccionar idioma",
    "BUY": "COMPRAR",
    "SELL": "VENDER",
    "Privacy Policy": "Política de privacidad",
    "Terms of Service": "Términos del servicio",
    "Flashcards": "Flashcards",
    "Lessons": "Aulas",
    "Streak": "Racha",
    "Continue learning": "Seguir aprendiendo",
    "Premium": "Premium",
    "Brazil · LATAM": "Brasil · LATAM",
    "Mexico · LATAM": "México · LATAM",
    "LATAM focus": "Enfoque LATAM",
    "Russia · CIS": "Rusia · CEI",
    "Global markets": "Mercados globales",
}


def load_cache():
    if CACHE.exists():
        return json.loads(CACHE.read_text(encoding="utf-8"))
    return {}


def save_cache(c):
    CACHE.write_text(json.dumps(c, ensure_ascii=False), encoding="utf-8")


def dart_escape(s: str) -> str:
    return (
        s.replace("\\", "\\\\")
        .replace("'", "\\'")
        .replace("\n", "\\n")
        .replace("\r", "")
    )


def parse_string_literals(s: str) -> list[str] | None:
    args, i, n = [], 0, len(s)
    while i < n:
        while i < n and s[i] in " \t\r\n,":
            i += 1
        if i >= n:
            break
        if s[i] != "'":
            return None
        i += 1
        buf = []
        while i < n:
            if s[i] == "\\" and i + 1 < n:
                buf.append(s[i + 1])
                i += 2
                continue
            if s[i] == "'":
                i += 1
                break
            buf.append(s[i])
            i += 1
        args.append("".join(buf))
    return args if len(args) >= 3 else None


def tr_es(en: str, cache: dict) -> str:
    if en in MANUAL_ES:
        return MANUAL_ES[en]
    # Keep interpolations mostly: translate around $vars is hard — translate whole with Google
    key = f"es::{en}"
    if key in cache:
        return cache[key]
    try:
        result = GoogleTranslator(source="en", target="es").translate(en) or en
        cache[key] = result
        time.sleep(0.03)
        return result
    except Exception as e:
        print("fail", e, flush=True)
        return en


def main():
    src = L10N.read_text(encoding="utf-8")
    cache = load_cache()
    pattern = re.compile(r"_t\((.*?)\)", re.S)
    done = skipped = 0

    def repl(m):
        nonlocal done, skipped
        inner = m.group(1)
        args = parse_string_literals(inner)
        if not args:
            skipped += 1
            return m.group(0)
        en, ru, pt = args[0], args[1], args[2]
        es = args[3] if len(args) >= 4 else tr_es(en, cache)
        # light PT polish for UI
        pt2 = pt.replace("lição", "aula").replace("Lição", "Aula").replace("lições", "aulas")
        pt2 = pt2.replace("Lições", "Aulas").replace("aconselhamento financeiro", "recomendação financeira")
        done += 1
        return (
            f"_t(\n"
            f"        '{dart_escape(en)}',\n"
            f"        '{dart_escape(ru)}',\n"
            f"        '{dart_escape(pt2)}',\n"
            f"        '{dart_escape(es)}',\n"
            f"      )"
        )

    out = pattern.sub(repl, src)
    # ensure signature allows required es after upgrade — keep optional for safety
    if "case AppLanguage.es:" not in out:
        out = out.replace(
            "String _t(String en, String ru, String pt, [String? es])",
            "String _t(String en, String ru, String pt, [String? es])",
        )
    L10N.write_text(out, encoding="utf-8")
    save_cache(cache)
    print(f"updated={done} skipped={skipped} cache={len(cache)}", flush=True)


if __name__ == "__main__":
    main()
