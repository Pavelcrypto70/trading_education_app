"""Issue a Desk Club key code for a learner's Trade Master number.

Use after checking their Tiger User ID in the partner cabinet:

    python tools/desk_key_code.py TM-12345

KEY_SALT is read from the environment or from dart_defines.json (gitignored).
It must match the KEY_SALT the web build was compiled with.
"""
import hashlib
import json
import os
import re
import sys
from pathlib import Path


def load_salt() -> str:
    salt = os.environ.get("KEY_SALT", "")
    if salt:
        return salt
    defines = Path(__file__).resolve().parent.parent / "dart_defines.json"
    if defines.exists():
        return json.loads(defines.read_text(encoding="utf-8")).get("KEY_SALT", "")
    return ""


def code_for(public_id: str, salt: str) -> str:
    digest = hashlib.sha256(f"{public_id}|{salt}".encode("utf-8")).hexdigest().upper()
    return f"{digest[:4]}-{digest[4:8]}"


def main() -> int:
    if len(sys.argv) != 2 or not re.fullmatch(r"TM-\d{5}", sys.argv[1].strip().upper()):
        print("usage: python tools/desk_key_code.py TM-12345")
        return 2
    salt = load_salt()
    if not salt:
        print("KEY_SALT is not set (env or dart_defines.json)")
        return 1
    print(code_for(sys.argv[1].strip().upper(), salt))
    return 0


if __name__ == "__main__":
    sys.exit(main())
