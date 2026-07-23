# -*- coding: utf-8 -*-
"""Genera la voz de Nora (who='detective') con Kokoro-82M (kokoro-onnx), local, ES.
Cada linea -> <sha1("detective|text")[:16]>.wav en build/nora_voz_kokoro/.
Uso: python tools/gen_nora_kokoro.py [limite]   (sin limite = todas)
"""
import json, hashlib, os, sys
from kokoro_onnx import Kokoro
import soundfile as sf

MD   = r"C:\Users\Josep\AppData\Local\kokoro_models"
JSON = r"C:\Users\Josep\AppData\Roaming\Godot\app_userdata\sOC\voice_lines.json"
OUT  = r"c:\ID\OneDrive\sOCProjects\sOCTheGame\build\nora_voz_kokoro"
VOICE = "ef_dora"   # femenina espanola
LANG  = "es"
os.makedirs(OUT, exist_ok=True)

limit = int(sys.argv[1]) if len(sys.argv) > 1 else None

k = Kokoro(os.path.join(MD, "kokoro-v1.0.onnx"), os.path.join(MD, "voices-v1.0.bin"))
lines = json.load(open(JSON, encoding="utf-8"))
nora = [l for l in lines if l.get("who") == "detective" and l.get("text", "").strip()]
if limit:
    nora = nora[:limit]
print("Lineas de Nora a generar:", len(nora), flush=True)

done = 0
for l in nora:
    text = l["text"].strip()
    key = hashlib.sha1(("detective|" + text).encode("utf-8")).hexdigest()[:16]
    path = os.path.join(OUT, key + ".wav")
    if os.path.exists(path):
        done += 1
        continue
    try:
        samples, sr = k.create(text, voice=VOICE, speed=1.0, lang=LANG)
        sf.write(path, samples, sr)
        done += 1
        if done <= 12 or done % 25 == 0:
            print(f"[{done}] {key}.wav  <- {text[:55]}", flush=True)
    except Exception as e:
        print("ERR:", repr(e)[:160], flush=True)
        try:
            print("voces disponibles:", list(k.get_voices())[:40], flush=True)
        except Exception:
            pass
        break

print(f"GENERADAS: {done} -> {OUT}", flush=True)
