# -*- coding: utf-8 -*-
"""Ejemplo de voz de Nora con XTTS-v2 (coqui-tts), clonando una referencia de
voz femenina de Espana (nora_ref_esES.wav) para forzar acento castellano.
Ejecutar con el venv: scratchpad\\xtts311\\Scripts\\python.exe tools\\gen_nora_xtts.py
"""
import os
os.environ["COQUI_TOS_AGREED"] = "1"  # aceptar licencia no comercial de XTTS sin prompt

SP  = r"C:\Users\Josep\AppData\Local\Temp\claude\c--ID-OneDrive-sOCProjects\567bd72e-791e-410c-a46d-fc36668288f6\scratchpad"
REF = os.path.join(SP, "nora_ref_esES.wav")
OUT = r"c:\ID\OneDrive\sOCProjects\sOCTheGame\build\nora_voz_xtts"
os.makedirs(OUT, exist_ok=True)
TEXT = "Y yo soy Nora Vega. Detective. La que se va a patear cada caso hasta el fondo, caiga quien caiga."

import torch
from TTS.api import TTS

dev = "cuda" if torch.cuda.is_available() else "cpu"
print("device:", dev, "| torch:", torch.__version__, flush=True)
print("descargando/cargando XTTS-v2 (1.8GB la primera vez)...", flush=True)
tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2").to(dev)

out = os.path.join(OUT, "nora_muestra_xtts.wav")
print("generando...", flush=True)
tts.tts_to_file(text=TEXT, speaker_wav=REF, language="es", file_path=out)
print("GENERADO ->", out, os.path.getsize(out), "bytes", flush=True)
