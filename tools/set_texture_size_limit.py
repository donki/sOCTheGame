#!/usr/bin/env python3
"""Ajusta process/size_limit en los .import de fondos+retratos.

Godot no reescala texturas por plataforma, así que para un APK Android más ligero
(1080p) se aplica un límite temporal, se reimporta, se exporta y se REVIERTE a 0 (4K)
para conservar el 4K en Windows/editor.

Uso:
    python tools/set_texture_size_limit.py 1920   # reescala (max lado 1920 = 1080p)
    python tools/set_texture_size_limit.py 0       # restaura 4K nativo
"""
import glob, io, os, re, sys

v = int(sys.argv[1]) if len(sys.argv) > 1 else 0
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
n = 0
for d in ("assets/backgrounds", "assets/portraits"):
    for p in glob.glob(os.path.join(root, d, "*.png.import")):
        t = io.open(p, encoding="utf-8").read()
        t2 = re.sub(r"process/size_limit=\d+", "process/size_limit=%d" % v, t)
        if t2 != t:
            io.open(p, "w", encoding="utf-8", newline="\n").write(t2)
            n += 1
print("process/size_limit=%d en %d imports" % (v, n))
