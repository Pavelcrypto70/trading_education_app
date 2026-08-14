#!/usr/bin/env python3
"""
Fast LATAM localization (max practical quality):
- Add Spanish (es) everywhere from English
- Upgrade Portuguese in-place with glossary + selective retranslate
- Do NOT rebuild entire PT from scratch (preserves better existing PT)
"""

from __future__ import annotations

import json
import re
import sys
import time
from pathlib import Path

from deep_translator import GoogleTranslator

sys.stdout.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "assets" / "data"
CACHE_FILE = Path(__file__).resolve().parent / ".latam_l10n_cache.json"

PT_GLOSSARY = [
    (r"\bà vista\b", "spot"),
    (r"\bÀ vista\b", "Spot"),
    (r"\bÀ Vista\b", "Spot"),
    (r"\btelegrama\b", "Telegram"),
    (r"\bTelegrama\b", "Telegram"),
    (r"\bpropagação\b", "spread"),
    (r"\bPropagação\b", "Spread"),
    (r"\bem um copo\b", "no livro de ofertas"),
    (r"\bnum copo\b", "no livro de ofertas"),
    (r"\bno copo\b", "no livro de ofertas"),
    (r"\bfabricante\b", "maker"),
    (r"\bFabricante\b", "Maker"),
    (r"\bFrase inicial\b", "Seed phrase"),
    (r"\bfrase inicial\b", "seed phrase"),
    (r"\bsuporte de telegrama\b", "suporte no Telegram"),
    (r"\baluguel por uma aposta\b", "custo do funding"),
    (r"\bTiger\.Trade e Vataga\b", "terminais profissionais via API"),
    (r"\bTiger e Vataga\b", "terminais de execução"),
    (r"\bBook de ofertas\b", "Livro de ofertas"),
    (r"\bbook de ofertas\b", "livro de ofertas"),
    (r"\bLivro de pedidos\b", "Livro de ofertas"),
    (r"\blivro de pedidos\b", "livro de ofertas"),
    (r"\bCarteira → Transferência → À Vista\b", "Carteira → Transferir → Spot"),
    (r"\bCarteira → Transferência → Spot\b", "Carteira → Transferir → Spot"),
    (r"\bem Financiamento\b", "em Funding"),
    (r"\baconselhamento financeiro\b", "recomendação financeira"),
    (r"\bnegociação ativa\b", "trading ativo"),
    (r"\bIntrodutório\b", "Introdução"),
    (r"\bpor onde começar na negociação\b", "por onde começar no trading"),
    (r"\bExplique à vista e futuros\b", "Explique spot e futuros"),
    (r"\bNegociação - negociação ativa\b", "Trading é operação ativa"),
    (r"\bÀ vista:\b", "Spot:"),
    (r"\bà vista:\b", "spot:"),
]

ES_GLOSSARY = [
    (r"\btelegrama\b", "Telegram"),
    (r"\bTelegrama\b", "Telegram"),
    (r"\blibro de pedidos\b", "libro de órdenes"),
    (r"\bLibro de pedidos\b", "Libro de órdenes"),
    (r"\bfrase semilla\b", "seed phrase"),
    (r"\bFrase semilla\b", "Seed phrase"),
    (r"\bTiger\.Trade y Vataga\b", "terminales profesionales vía API"),
    (r"\bTiger y Vataga\b", "terminales de ejecución"),
    (r"\bcasa de cambio\b", "exchange"),
    (r"\bCasa de cambio\b", "Exchange"),
]

MODULE_ES = {
    "Basics": "Fundamentos",
    "Price Action": "Price Action",
    "Risk": "Riesgo",
    "Psychology": "Psicología",
    "Strategy": "Estrategia",
    "Execution": "Ejecución",
    "Review": "Revisión",
    "Advanced": "Avanzado",
    "Beginner": "Principiante",
    "Intermediate": "Intermedio",
    "Introduction": "Introducción",
    "Introdução": "Introducción",
    "Введение": "Introducción",
}


def load_cache() -> dict:
    if CACHE_FILE.exists():
        return json.loads(CACHE_FILE.read_text(encoding="utf-8"))
    return {}


def save_cache(cache: dict) -> None:
    CACHE_FILE.write_text(json.dumps(cache, ensure_ascii=False), encoding="utf-8")


def apply_glossary(text: str, glossary: list[tuple[str, str]]) -> str:
    out = text
    for pat, repl in glossary:
        out = re.sub(pat, repl, out, flags=re.IGNORECASE if pat.startswith("(?i)") else 0)
        out = re.sub(pat, repl, out)
    return out


def polish_pt(text: str) -> str:
    return apply_glossary(text, PT_GLOSSARY)


def polish_es(text: str) -> str:
    return apply_glossary(text, ES_GLOSSARY)


def tr_es(text: str, cache: dict) -> str:
    if not text or not str(text).strip():
        return text
    if not isinstance(text, str):
        return text
    if text.startswith("http") or re.fullmatch(r"[\w./:+\-_%#?=&]+", text):
        return text
    key = f"es::{text}"
    if key in cache:
        return cache[key]
    try:
        chunks = [text[i : i + 4000] for i in range(0, len(text), 4000)] or [text]
        parts = []
        for ch in chunks:
            parts.append(GoogleTranslator(source="en", target="es").translate(ch) or ch)
            time.sleep(0.03)
        result = polish_es("".join(parts))
        cache[key] = result
        return result
    except Exception as e:
        print(f"  FAIL es: {e}", flush=True)
        return text


def walk_add_es_polish_pt(obj, cache: dict, stats: dict):
    if isinstance(obj, list):
        return [walk_add_es_polish_pt(x, cache, stats) for x in obj]
    if isinstance(obj, dict):
        # Language map: has en+ru (standard in this repo) or en+pt
        if (
            "en" in obj
            and isinstance(obj.get("en"), (str, list))
            and ("ru" in obj or "pt" in obj)
        ):
            return _upgrade_lang_map(obj, cache, stats)
        return {k: walk_add_es_polish_pt(v, cache, stats) for k, v in obj.items()}
    return obj


def _upgrade_lang_map(d: dict, cache: dict, stats: dict) -> dict:
    """Upgrade lang fields; preserve non-lang keys (id, weight, passPercent…)."""
    out = dict(d)
    en = out.get("en")
    if isinstance(en, str):
        if isinstance(out.get("pt"), str):
            out["pt"] = polish_pt(out["pt"])
            stats["pt_polished"] += 1
        if not isinstance(out.get("es"), str) or not str(out.get("es", "")).strip():
            out["es"] = tr_es(en, cache)
            stats["es_new"] += 1
        else:
            out["es"] = polish_es(str(out["es"]))
            stats["es_polished"] += 1
    elif isinstance(en, list):
        pt = out.get("pt") if isinstance(out.get("pt"), list) else []
        es_existing = out.get("es") if isinstance(out.get("es"), list) else []
        new_pt, new_es = [], []
        for i, item in enumerate(en):
            if isinstance(item, str):
                p = polish_pt(pt[i]) if i < len(pt) and isinstance(pt[i], str) else item
                new_pt.append(p)
                if i < len(es_existing) and isinstance(es_existing[i], str) and es_existing[i].strip():
                    new_es.append(polish_es(es_existing[i]))
                else:
                    new_es.append(tr_es(item, cache))
                    stats["es_new"] += 1
            else:
                new_pt.append(pt[i] if i < len(pt) else item)
                new_es.append(es_existing[i] if i < len(es_existing) else item)
        out["pt"] = new_pt
        out["es"] = new_es
        stats["pt_polished"] += 1
    return out


def process_shared(cache: dict) -> None:
    files = [
        "lesson_quizzes.json",
        "module_quizzes.json",
        "glossary.json",
        "case_studies.json",
        "syllabus.json",
        "homework_rubrics.json",
    ]
    for name in files:
        path = DATA / name
        print(f"==> {name}", flush=True)
        data = json.loads(path.read_text(encoding="utf-8"))
        stats = {"es_new": 0, "es_polished": 0, "pt_polished": 0}
        updated = walk_add_es_polish_pt(data, cache, stats)
        path.write_text(json.dumps(updated, ensure_ascii=False, indent=2), encoding="utf-8")
        save_cache(cache)
        print(f"    es_new={stats['es_new']} pt_polished={stats['pt_polished']} cache={len(cache)}", flush=True)


def polish_lesson_strings(obj, target: str):
    if isinstance(obj, list):
        return [polish_lesson_strings(x, target) for x in obj]
    if isinstance(obj, dict):
        return {k: polish_lesson_strings(v, target) for k, v in obj.items()}
    if isinstance(obj, str):
        return polish_pt(obj) if target == "pt" else polish_es(obj)
    return obj


def upgrade_pt_lessons() -> None:
    path = DATA / "lessons_pt.json"
    print("==> lessons_pt.json polish", flush=True)
    data = json.loads(path.read_text(encoding="utf-8"))
    data = polish_lesson_strings(data, "pt")
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"    done ({path.stat().st_size // 1024} KB)", flush=True)


def build_es_lessons(cache: dict) -> None:
    src = json.loads((DATA / "lessons_en.json").read_text(encoding="utf-8"))
    out = []
    print("==> lessons_es.json build", flush=True)
    for i, lesson in enumerate(src):
        # Translate shallow critical fields + sections recursively via EN strings only
        translated = _translate_lesson(lesson, cache)
        if isinstance(translated.get("module"), str):
            translated["module"] = MODULE_ES.get(translated["module"], translated["module"])
        if isinstance(translated.get("difficulty"), str):
            translated["difficulty"] = MODULE_ES.get(
                translated["difficulty"], translated["difficulty"]
            )
        out.append(translated)
        if (i + 1) % 2 == 0 or i == 0:
            save_cache(cache)
            print(f"    lesson {i + 1}/{len(src)} cache={len(cache)}", flush=True)
    path = DATA / "lessons_es.json"
    path.write_text(json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"    wrote {path.name} ({path.stat().st_size // 1024} KB)", flush=True)


SKIP_KEYS = {"id", "durationMin", "chartType", "url", "year", "type", "prerequisites", "lessonIds"}


def _translate_lesson(obj, cache: dict):
    if isinstance(obj, list):
        return [_translate_lesson(x, cache) for x in obj]
    if isinstance(obj, dict):
        res = {}
        for k, v in obj.items():
            if k in SKIP_KEYS:
                res[k] = v
            else:
                res[k] = _translate_lesson(v, cache)
        return res
    if isinstance(obj, str):
        return tr_es(obj, cache)
    return obj


def main() -> None:
    cache = load_cache()
    print(f"Cache entries: {len(cache)}", flush=True)
    process_shared(cache)
    upgrade_pt_lessons()
    build_es_lessons(cache)
    save_cache(cache)
    print("ALL DONE", flush=True)


if __name__ == "__main__":
    main()
