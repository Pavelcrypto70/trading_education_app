from part01 import LESSONS
for L in LESSONS:
    ru = L["loc"]["ru"]
    en = L["loc"]["en"]
    rw = sum(len(b["body"].split()) for b in ru.get("blocks", []))
    ew = sum(len(b["body"].split()) for b in en.get("blocks", []))
    print(L["id"], "RU", rw, len(ru["blocks"]), "EN", ew, len(en["blocks"]))
