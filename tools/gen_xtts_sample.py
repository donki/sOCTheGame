# -*- coding: utf-8 -*-
"""Muestra XTTS-v2 clonando una referencia. Uso:
python gen_xtts_sample.py <ref.wav> <text_file_utf8> <out.wav>
"""
import os, sys
os.environ["COQUI_TOS_AGREED"] = "1"
ref, txt_file, out = sys.argv[1], sys.argv[2], sys.argv[3]
text = open(txt_file, encoding="utf-8").read().strip()
os.makedirs(os.path.dirname(out), exist_ok=True)
import soundfile as sf
from TTS.api import TTS
api = TTS("tts_models/multilingual/multi-dataset/xtts_v2").to("cpu")
m = api.synthesizer.tts_model
g, s = m.get_conditioning_latents(audio_path=[ref])
o = m.inference(text, "es", g, s, temperature=0.7)
sf.write(out, o["wav"], 24000)
print("OK ->", out, os.path.getsize(out), "bytes")
