#!/usr/bin/env python3
"""Generate part03.py — run: python _gen_part03.py"""
from pathlib import Path
import textwrap

OUT = Path(__file__).parent / "part03.py"

MOD_INTRO = ("Введение", "Introduction", "Introdução")
MOD_CHART = ("График", "Chart", "Gráfico")
MOD_PAT = ("Паттерны", "Patterns", "Padrões")
MOD_STR = ("Стратегии", "Strategies", "Estratégias")
MOD_MKT = ("Рынок", "Market", "Mercado")
MOD_RISK = ("Риск", "Risk", "Risco")
MOD_PRAC = ("Практика", "Practice", "Prática")


def blk(h, body):
    return {"h": h, "body": textwrap.dedent(body).strip()}


def mkt(ru_extra=""):
    return {
        "br": "No Brasil, acompanhe BTC.D e sessões Asia/Londres/NY no TradingView. Use P2P USDT na Binance e registre cada plano no diário.",
        "mx": "En México muchos operan BTC en futuros y rotan a alts con dominancia baja. Calendario FOMC/CPI antes de aumentar tamaño.",
        "ru": "В РФ путь — P2P USDT на Binance после KYC. Альтсезон и сессии читают по BTC.D и графику BTC, не по мемам в Telegram. " + ru_extra,
        "global": "Trade Master teaches BTC context first, then alts — plan before click, journal after every session.",
    }


def make_lesson(lid, mod, diff, mins, chart, sym, interval, markets,
                ru_title, ru_sub, ru_out, ru_content, ru_take, ru_raw,
                en_title, en_sub, en_out, en_content, en_take, en_raw,
                pt_title, pt_sub, pt_out, pt_content, pt_take, pt_raw,
                chart_cap_ru, chart_cap_en, tv_ru, tv_en, tv_pt,
                steps_ru, steps_en, steps_pt,
                ex_ru, ex_en, ex_pt,
                bullets_ru, bullets_en, bullets_pt,
                journal_ru, journal_en, journal_pt,
                tip_ru, tip_en, tip_pt):
    ru_blocks = [blk(h, b) for h, b in ru_raw]
    en_blocks = [blk(h, b) for h, b in en_raw]
    pt_blocks = [blk(h, b) for h, b in pt_raw]
    return {
        "id": lid, "module": mod, "difficulty": diff, "durationMin": mins,
        "chart": chart, "symbol": sym, "interval": interval, "markets": markets,
        "ru_blocks": ru_blocks, "en_blocks": en_blocks, "pt_blocks": pt_blocks,
        "ru_loc": {
            "title": ru_title, "subtitle": ru_sub, "outcome": ru_out, "content": ru_content,
            "takeaway": ru_take, "chart_cap": chart_cap_ru, "tv_body": tv_ru,
            "practice_steps": steps_ru, "example": ex_ru, "bullets": bullets_ru,
            "journal_items": journal_ru, "tip": tip_ru,
        },
        "en_loc": {
            "title": en_title, "subtitle": en_sub, "outcome": en_out, "content": en_content,
            "takeaway": en_take, "chart_cap": chart_cap_en, "tv_body": tv_en,
            "practice_steps": steps_en, "example": ex_en, "bullets": bullets_en,
            "journal_items": journal_en, "tip": tip_en,
        },
        "pt_loc": {
            "title": pt_title, "subtitle": pt_sub, "outcome": pt_out, "content": pt_content,
            "takeaway": pt_take, "chart_cap": chart_cap_en, "tv_body": tv_pt,
            "practice_steps": steps_pt, "example": ex_pt, "bullets": bullets_pt,
            "journal_items": journal_pt, "tip": tip_pt,
        },
    }


LESSON_DATA = []

HEADER = '''# Deep curriculum — lessons 25-36 (RU lecture / EN+PT substantive)
# Export: LESSONS

MOD_INTRO = ("Введение", "Introduction", "Introdução")
MOD_CHART = ("График", "Chart", "Gráfico")
MOD_PAT = ("Паттерны", "Patterns", "Padrões")
MOD_STR = ("Стратегии", "Strategies", "Estratégias")
MOD_MKT = ("Рынок", "Market", "Mercado")
MOD_RISK = ("Риск", "Risk", "Risco")
MOD_PRAC = ("Практика", "Practice", "Prática")


def _m(br, mx, ru, gl=""):
    return {"br": br, "mx": mx, "ru": ru, "global": gl or br}


def L(lid, mod, diff, mins, chart, sym, interval, markets, loc):
    return {
        "id": lid, "module": mod, "difficulty": diff, "durationMin": mins,
        "chart": chart, "symbol": sym, "interval": interval,
        "markets": markets, "loc": loc,
    }


'''


def emit():
    parts = [HEADER]
    names = []
    for d in LESSON_DATA:
        lid = d["id"]
        rb, eb, pb = f"L{lid}_RU_BLOCKS", f"L{lid}_EN_BLOCKS", f"L{lid}_PT_BLOCKS"
        mk, vn = f"L{lid}_MARKETS", f"LESSON{lid}"
        parts.append(f"# ─── Lesson {lid} ───────────────────────────────────────────────────────────────\n")
        for bn, blocks in ((rb, d["ru_blocks"]), (eb, d["en_blocks"]), (pb, d["pt_blocks"])):
            parts.append(f"_{bn} = [")
            for b in blocks:
                parts.append(f"    {{'h': {b['h']!r}, 'body': {b['body']!r}}},")
            parts.append("]\n")
        m = d["markets"]
        parts.append(f"_{mk} = _m({m['br']!r}, {m['mx']!r}, {m['ru']!r}, {m['global']!r})\n")
        parts.append(f"_{vn} = L({lid}, {d['module']!r}, {d['difficulty']!r}, {d['durationMin']}, "
                     f"{d['chart']!r}, {d['symbol']!r}, {d['interval']!r}, _{mk}, {{")
        for lang, loc_key, bname in (("ru", "ru_loc", rb), ("en", "en_loc", eb), ("pt", "pt_loc", pb)):
            loc = d[loc_key]
            parts.append(f'    "{lang}": {{')
            parts.append(f'        "title": {loc["title"]!r}, "subtitle": {loc["subtitle"]!r},')
            parts.append(f'        "outcome": {loc["outcome"]!r}, "content": {loc["content"]!r},')
            parts.append(f'        "takeaway": {loc["takeaway"]!r}, "blocks": _{bname},')
            parts.append(f'        "market_title": {"Ваш рынок" if lang=="ru" else "Your market (LATAM)" if lang=="en" else "Seu mercado (Brasil)"!r},')
            parts.append(f'        "chart_title": {loc["title"]!r}, "chart_cap": {loc["chart_cap"]!r},')
            tv_t = "Разбор в TradingView" if lang == "ru" else "TradingView walkthrough" if lang == "en" else "Setup no TradingView"
            parts.append(f'        "tv_title": {tv_t!r}, "tv_body": {loc["tv_body"]!r},')
            pr_t = "Практика без риска" if lang == "ru" else "Hands-on practice" if lang == "en" else "Prática"
            pr_i = "Выполните по шагам:" if lang == "ru" else "Follow these steps:" if lang == "en" else "Siga os passos:"
            parts.append(f'        "practice_title": {pr_t!r}, "practice_intro": {pr_i!r},')
            parts.append(f'        "practice_steps": {loc["practice_steps"]!r},')
            ex_t = "Разбор сценария" if lang == "ru" else "Scenario walkthrough" if lang == "en" else "Cenário"
            parts.append(f'        "example_title": {ex_t!r}, "example": {loc["example"]!r},')
            bl_t = "Главное запомнить" if lang == "ru" else "Key takeaways" if lang == "en" else "Lembre"
            parts.append(f'        "bullets_title": {bl_t!r}, "bullets": {loc["bullets"]!r},')
            j_t = "Запись в журнал" if lang == "ru" else "Trade journal" if lang == "en" else "Diário"
            j_b = "После урока зафиксируйте:" if lang == "ru" else "Record after the lesson:" if lang == "en" else "Registre após a aula:"
            parts.append(f'        "journal_title": {j_t!r}, "journal_body": {j_b!r},')
            parts.append(f'        "journal_items": {loc["journal_items"]!r},')
            tip_t = "Совет профи" if lang == "ru" else "Pro tip" if lang == "en" else "Dica profissional"
            parts.append(f'        "tip_title": {tip_t!r}, "tip": {loc["tip"]!r},')
            parts.append("    },")
        parts.append("})\n")
        names.append(f"_{vn}")
    parts.append(f"LESSONS = [{', '.join(names)}]\n")
    OUT.write_text("\n".join(parts), encoding="utf-8")
    print(f"Wrote {OUT} ({OUT.stat().st_size} bytes, {len(LESSON_DATA)} lessons)")


if __name__ == "__main__":
    emit()
