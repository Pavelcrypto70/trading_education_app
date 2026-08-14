#!/usr/bin/env python3
"""Native-quality overlay for trial lessons (1,2,3,7,10) in PT-BR and ES-LATAM."""

from __future__ import annotations

import json
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "assets" / "data"
TRIAL_IDS = {1, 2, 3, 7, 10}

PT_META = {
    1: {
        "module": "Introdução",
        "title": "Introdução. Por onde começar no trading? Parte 1",
        "subtitle": "Spot vs futuros, início seguro e risco antes da primeira ordem",
        "difficulty": "Iniciante",
        "outcome": "Explique spot e futuros, monte um checklist de cadastro e cite o principal risco do iniciante.",
        "content": "Trading é comprar e vender com objetivo de lucro. Comece por spot, KYC, 2FA e defina o risco do depósito antes do clique.",
        "takeaway": "Comece no spot; futuros = alavancagem e liquidação. Segurança e risco vêm antes de qualquer setup.",
        "learningOutcomes": [
            "Explicar a ideia da aula com suas palavras",
            "Postar um sinal no chat: par, TF, entrada, stop, alvo, invalidação",
            "Registrar risco % e tag do setup no diário",
        ],
    },
    2: {
        "module": "Introdução",
        "title": "Introdução. Por onde começar? Parte 2",
        "subtitle": "Terminal, ordem e o hábito de planejar antes de clicar",
        "difficulty": "Iniciante",
        "outcome": "Descrever limite vs market e explicar por que o plano vem antes da ordem.",
        "content": "Depois do cadastro: entenda o terminal, limíte vs market e treine o plano no papel antes de arriscar capital.",
        "takeaway": "Limite = preço definido; market = execução agora. Sem plano escrito, não há clique.",
        "learningOutcomes": [
            "Distinguir ordem limite e market",
            "Escrever um plano mínimo: entrada, stop, alvo, risco %",
            "Evitar cliques por impulso no celular",
        ],
    },
    3: {
        "module": "Introdução",
        "title": "Amplitude do movimento",
        "subtitle": "Range, ATR e tamanho de stop que faz sentido",
        "difficulty": "Iniciante",
        "outcome": "Medir a amplitude recente e escolher um stop compatível com a volatilidade do ativo.",
        "content": "Sem medir a amplitude, o stop fica aleatório. Use range e ATR para dimensionar risco em USDT.",
        "takeaway": "Amplitude diz o tamanho do 'passo' do preço. Stop menor que o ruído = stop caçador.",
        "learningOutcomes": [
            "Medir range de 20 candles",
            "Relacionar ATR com o tamanho do stop",
            "Registrar a medição no diário",
        ],
    },
    7: {
        "module": "Introdução",
        "title": "Erros clássicos de iniciantes. Parte 1",
        "subtitle": "Overtrading, revenge trade e sinais do Telegram",
        "difficulty": "Iniciante",
        "outcome": "Listar 5 erros de iniciante e explicar como o journal evita revenge trade.",
        "content": "A maioria queima depósito por disciplina, não por falta de 'estratégia secreta'.",
        "takeaway": "Sem stop, sem plano e com revenge trade você aprende caro. Journal = freio de emergência.",
        "learningOutcomes": [
            "Reconhecer overtrading e revenge trade",
            "Recusar sinal sem invalidação",
            "Pausar 15–30 min depois de um stop",
        ],
    },
    10: {
        "module": "Estratégia",
        "title": "Estratégia de impulso",
        "subtitle": "Entrada no movimento com plano de risco e alvo",
        "difficulty": "Iniciante",
        "outcome": "Montar um setup de impulso com entrada, stop, alvo e risco 0,5–1%.",
        "content": "Impulso é velocidade. Sem filtro de estrutura e sem risco fixo, vira perseguição de preço.",
        "takeaway": "Impulso com plano > FOMO. Risco definido antes do clique.",
        "learningOutcomes": [
            "Identificar um impulso válido no gráfico",
            "Definir stop atrás da estrutura",
            "Calcular tamanho da posição pelo risco %",
        ],
    },
}

ES_META = {
    1: {
        "module": "Introducción",
        "title": "Introducción. ¿Por dónde empezar en trading? Parte 1",
        "subtitle": "Spot vs futuros, inicio seguro y riesgo antes de la primera orden",
        "difficulty": "Principiante",
        "outcome": "Explicar spot y futuros, armar un checklist de registro y nombrar el principal riesgo del principiante.",
        "content": "Trading es comprar y vender con objetivo de ganancia. Empieza por spot, KYC, 2FA y define el riesgo del depósito antes del clic.",
        "takeaway": "Empieza en spot; futuros = apalancamiento y liquidación. Seguridad y riesgo van antes que cualquier setup.",
        "learningOutcomes": [
            "Explicar la idea de la clase con tus palabras",
            "Publicar una señal en el chat: par, TF, entrada, stop, objetivo, invalidación",
            "Registrar riesgo % y etiqueta del setup en el diario",
        ],
    },
    2: {
        "module": "Introducción",
        "title": "Introducción. ¿Por dónde empezar? Parte 2",
        "subtitle": "Terminal, órdenes y el hábito de planear antes de clickear",
        "difficulty": "Principiante",
        "outcome": "Describir límite vs market y explicar por qué el plan va antes de la orden.",
        "content": "Después del registro: entiende el terminal, límite vs market y entrena el plan en papel antes de arriesgar capital.",
        "takeaway": "Límite = precio definido; market = ejecución ahora. Sin plan escrito, no hay clic.",
        "learningOutcomes": [
            "Distinguir orden límite y market",
            "Escribir un plan mínimo: entrada, stop, objetivo, riesgo %",
            "Evitar clics por impulso en el celular",
        ],
    },
    3: {
        "module": "Introducción",
        "title": "Amplitud del movimiento",
        "subtitle": "Range, ATR y un stop que tenga sentido",
        "difficulty": "Principiante",
        "outcome": "Medir la amplitud reciente y elegir un stop compatible con la volatilidad del activo.",
        "content": "Sin medir la amplitud, el stop es aleatorio. Usa range y ATR para dimensionar el riesgo en USDT.",
        "takeaway": "La amplitud muestra el 'paso' del precio. Stop más chico que el ruido = stop cazado.",
        "learningOutcomes": [
            "Medir el range de 20 velas",
            "Relacionar ATR con el tamaño del stop",
            "Registrar la medición en el diario",
        ],
    },
    7: {
        "module": "Introducción",
        "title": "Errores clásicos de principiantes. Parte 1",
        "subtitle": "Overtrading, revenge trade y señales de Telegram",
        "difficulty": "Principiante",
        "outcome": "Listar 5 errores de principiante y explicar cómo el journal evita el revenge trade.",
        "content": "La mayoría quema el depósito por disciplina, no por falta de una 'estrategia secreta'.",
        "takeaway": "Sin stop, sin plan y con revenge trade aprendes caro. El journal es el freno de emergencia.",
        "learningOutcomes": [
            "Reconocer overtrading y revenge trade",
            "Rechazar una señal sin invalidación",
            "Pausar 15–30 min después de un stop",
        ],
    },
    10: {
        "module": "Estrategia",
        "title": "Estrategia de impulso",
        "subtitle": "Entrada al movimiento con plan de riesgo y objetivo",
        "difficulty": "Principiante",
        "outcome": "Armar un setup de impulso con entrada, stop, objetivo y riesgo 0,5–1%.",
        "content": "El impulso es velocidad. Sin filtro de estructura y sin riesgo fijo, se vuelve persecución de precio.",
        "takeaway": "Impulso con plan > FOMO. Riesgo definido antes del clic.",
        "learningOutcomes": [
            "Identificar un impulso válido en el gráfico",
            "Definir stop detrás de la estructura",
            "Calcular el tamaño de posición por riesgo %",
        ],
    },
}

PT_SECTION_FIXES = {
    "Trading - trading ativo: comprou mais barato / vendeu mais caro (comprado) ou vice-versa (vendido a descoberto em futuros).\n\nSpot: se você comprar uma moeda por USDT, ela é sua. Sem alavancagem, sem liquidação. Queda = perda da posição, mas não será “nocauteado” automaticamente.\n\nFuturos: contrato de preço com alavancagem. O lucro/perda é mais rápido, mas a liquidação é possível. Para um iniciante, as primeiras semanas são apenas pontuais e micro.": 
    "Trading é operação ativa: comprou mais barato / vendeu mais caro (long) ou o inverso (short nos futuros).\n\nSpot: se você compra a moeda com USDT, ela fica no seu saldo. Sem alavancagem, sem liquidação automática. Se cair, você perde valor da posição — mas a corretora não te “explode” por margem.\n\nFuturos: contrato com alavancagem. O P&L se move mais rápido e existe liquidação. Nas primeiras semanas, fique no spot e em tamanho micro.",
}

ES_SECTION_FIXES = {
    "Negociación - negociación activa: compró más barato / vendió más caro (largo) o viceversa (corto en futuros).\n\nSpot: si compras una moneda por USDT, es tuya. Sin apalancamiento, sin liquidación. Caída = pérdida de la posición, pero no será \"eliminado\" automáticamente.\n\nFuturos: contrato de precio con apalancamiento. Las pérdidas y ganancias son más rápidas, pero la liquidación es posible. Para un principiante, las primeras semanas son sólo puntuales y de tamaño micro.":
    "Trading es operación activa: compraste más barato / vendiste más caro (long) o al revés (short en futuros).\n\nSpot: si compras la moneda con USDT, queda en tu saldo. Sin apalancamiento, sin liquidación automática. Si baja, pierdes valor de la posición — pero el exchange no te liquida por margen.\n\nFuturos: contrato con apalancamiento. El P&L se mueve más rápido y existe liquidación. Las primeras semanas: solo spot y tamaño micro.",
}


def apply_meta(path: Path, meta: dict) -> None:
    lessons = json.loads(path.read_text(encoding="utf-8"))
    for lesson in lessons:
        lid = int(lesson["id"])
        if lid not in meta:
            continue
        lesson.update(meta[lid])
    path.write_text(json.dumps(lessons, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Updated meta in {path.name}", flush=True)


def apply_section_fixes(path: Path, fixes: dict[str, str]) -> None:
    if not fixes:
        return
    text = path.read_text(encoding="utf-8")
    n = 0
    for old, new in fixes.items():
        if old in text:
            text = text.replace(old, new)
            n += 1
    path.write_text(text, encoding="utf-8")
    print(f"Section fixes in {path.name}: {n}", flush=True)


def global_pt_cleanup(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    reps = [
        ("primeira trading", "primeira operação"),
        ("Registrar% de risco", "Registrar % de risco"),
        ("tag de configuração", "tag do setup"),
        ("sinal de chat", "sinal no chat"),
        ("parada,", "stop,"),
        ("parada ", "stop "),
        ("lição com suas", "aula com suas"),
        ("da lição", "da aula"),
        ("a lição", "a aula"),
        ("comprime o estoque", "comprime a margem"),
        ("apenas pontuais e micro", "apenas spot e tamanho micro"),
    ]
    for a, b in reps:
        text = text.replace(a, b)
    path.write_text(text, encoding="utf-8")


def global_es_cleanup(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    reps = [
        ("Introductorio.", "Introducción."),
        ("Negociación,", "Trading,"),
        ("Negociación -", "Trading -"),
        ("sólo puntuales", "solo spot"),
        ("lista de verificación de registro", "checklist de registro"),
        ("etiqueta de configuración", "etiqueta del setup"),
        ("Publicar una señal de chat", "Publicar una señal en el chat"),
        ("parada,", "stop,"),
        ("parada ", "stop "),
        ("la lección", "la clase"),
        ("de la lección", "de la clase"),
        ("comprime la acción", "comprime el margen"),
    ]
    for a, b in reps:
        text = text.replace(a, b)
    path.write_text(text, encoding="utf-8")


def main() -> None:
    pt = DATA / "lessons_pt.json"
    es = DATA / "lessons_es.json"
    apply_meta(pt, PT_META)
    apply_meta(es, ES_META)
    apply_section_fixes(pt, PT_SECTION_FIXES)
    apply_section_fixes(es, ES_SECTION_FIXES)
    global_pt_cleanup(pt)
    global_es_cleanup(es)
    print("Trial native overlay done", flush=True)


if __name__ == "__main__":
    main()
