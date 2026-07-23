# -*- coding: utf-8 -*-
"""Genera TODAS las lineas de Nora (who='detective') con XTTS-v2, clonando la
referencia femenina de Espana. Reanudable: salta las que ya existen.
Calcula el timbre (conditioning latents) UNA sola vez -> mucho mas rapido.
Salida: build/nora_voz_xtts/<sha1("detective|text")[:16]>.wav
Uso: python tools/gen_nora_xtts_all.py [limite]
"""
import os, sys, json, hashlib, time
os.environ["COQUI_TOS_AGREED"] = "1"

SP  = r"C:\Users\Josep\AppData\Local\Temp\claude\c--ID-OneDrive-sOCProjects\567bd72e-791e-410c-a46d-fc36668288f6\scratchpad"
REF = os.path.join(SP, "nora_ref_esES.wav")
JSON = r"C:\Users\Josep\AppData\Roaming\Godot\app_userdata\sOC\voice_lines.json"
OUT  = r"c:\ID\OneDrive\sOCProjects\sOCTheGame\build\nora_voz_xtts"
os.makedirs(OUT, exist_ok=True)
limit = int(sys.argv[1]) if len(sys.argv) > 1 else None

import torch, soundfile as sf
from TTS.api import TTS

print("cargando XTTS-v2...", flush=True)
api = TTS("tts_models/multilingual/multi-dataset/xtts_v2").to("cpu")
model = api.synthesizer.tts_model
print("calculando timbre de la referencia (una vez)...", flush=True)
gpt_cond_latent, speaker_embedding = model.get_conditioning_latents(audio_path=[REF])

lines = json.load(open(JSON, encoding="utf-8"))
nora = [l for l in lines if l.get("who") == "detective" and l.get("text", "").strip()]
if limit:
    nora = nora[:limit]
print(f"Nora: {len(nora)} lineas", flush=True)

done = skipped = 0
t0 = time.time()
for i, l in enumerate(nora, 1):
    text = l["text"].strip()
    key = hashlib.sha1(("detective|" + text).encode("utf-8")).hexdigest()[:16]
    path = os.path.join(OUT, key + ".wav")
    if os.path.exists(path):
        skipped += 1
        continue
    ts = time.time()
    out = model.inference(text, "es", gpt_cond_latent, speaker_embedding, temperature=0.7)
    sf.write(path, out["wav"], 24000)
    done += 1
    dt = time.time() - ts
    avg = (time.time() - t0) / done
    eta = avg * (len(nora) - i) / 60
    print(f"[{i}/{len(nora)}] {key}.wav {dt:.1f}s (ETA {eta:.0f} min) <- {text[:50]}", flush=True)

print(f"HECHO. generadas={done} saltadas={skipped} -> {OUT}", flush=True)
