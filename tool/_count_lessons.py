import json
with open('assets/data/lessons_ru.json', encoding='utf-8') as f:
    lessons = json.load(f)
for L in lessons:
    secs = L['sections']
    types = {}
    for s in secs:
        types[s['type']] = types.get(s['type'], 0) + 1
    tv = types.get('tradingview', 0)
    print(f"{L['id']:2d} | {len(secs):3d} secs | tv={tv} | {L['title']}")
print('total', len(lessons))
