# -*- coding: utf-8 -*-
"""Renderiza las lineas de dialogo a MP3 con edge-tts, una VOZ por personaje.
Lee voice_lines.json (generado por ExtractVoices) y escribe assets/voices/<key>.mp3.
key = sha1("who|text")[:16]  (debe coincidir con el runtime en Global.gd).
Uso: python tools/gen_voices.py [ruta_json]
"""
import asyncio, hashlib, json, os, sys
import edge_tts

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "assets", "voices")
JSON_PATH = sys.argv[1] if len(sys.argv) > 1 else \
    os.path.expandvars(r"%APPDATA%\Godot\app_userdata\sOC\voice_lines.json")

FEMALE = {"detective","rosa","carmen","marta","laura","clara","sonia","adler",
          "madame","periodista","testigo","anonimo"}
FEM_VOICES = ["es-ES-ElviraNeural","es-ES-XimenaNeural","es-MX-DaliaNeural",
              "es-AR-ElenaNeural","es-CL-CatalinaNeural","es-CO-SalomeNeural",
              "es-PE-CamilaNeural","es-US-PalomaNeural","es-VE-PaolaNeural"]
MALE_VOICES = ["es-ES-AlvaroNeural","es-MX-JorgeNeural","es-AR-TomasNeural",
               "es-CL-LorenzoNeural","es-CO-GonzaloNeural","es-PE-AlexNeural",
               "es-US-AlonsoNeural","es-VE-SebastianNeural"]

# Voz/entonacion fija para personajes principales (voice, rate, pitch).
MAP = {
    "detective": ("es-ES-ElviraNeural", "+0%",  "+0Hz"),
    "nunez":     ("es-ES-AlvaroNeural", "-8%",  "-25Hz"),
    "emilio":    ("es-CO-GonzaloNeural","-10%", "-25Hz"),
    "rosa":      ("es-AR-ElenaNeural",  "-5%",  "-8Hz"),
    "carmen":    ("es-VE-PaolaNeural",  "-6%",  "-14Hz"),
    "tomas":     ("es-MX-JorgeNeural",  "+0%",  "+0Hz"),
    "marta":     ("es-MX-DaliaNeural",  "+0%",  "+0Hz"),
    "laura":     ("es-CL-CatalinaNeural","+0%", "+0Hz"),
    "clara":     ("es-ES-XimenaNeural", "+0%",  "+0Hz"),
    "sonia":     ("es-PE-CamilaNeural", "+0%",  "+0Hz"),
    "diego":     ("es-PE-AlexNeural",   "+6%",  "+12Hz"),
    "ruben":     ("es-VE-SebastianNeural","-8%","-20Hz"),
    "marco":     ("es-US-AlonsoNeural", "+0%",  "-5Hz"),
    "kessler":   ("es-CL-LorenzoNeural","-4%",  "-10Hz"),
    "adler":     ("es-US-PalomaNeural", "-3%",  "-6Hz"),
    "madame":    ("es-CO-SalomeNeural", "-4%",  "-6Hz"),
    "periodista":("es-ES-XimenaNeural", "+4%",  "+8Hz"),
    "voluntario":("es-PE-AlexNeural",   "+9%",  "+18Hz"),
    "nano":      ("es-AR-TomasNeural",  "+3%",  "+6Hz"),
    "padre":     ("es-CO-GonzaloNeural","-6%",  "-18Hz"),
}
RATES  = ["-10%","-5%","+0%","+5%"]
PITCHES= ["-25Hz","-15Hz","-6Hz","+6Hz","+16Hz"]

def voice_for(who):
    if who in MAP:
        return MAP[who]
    h = int(hashlib.sha1(who.encode("utf-8")).hexdigest(), 16)
    pool = FEM_VOICES if who in FEMALE else MALE_VOICES
    return (pool[h % len(pool)], RATES[(h // 7) % len(RATES)], PITCHES[(h // 11) % len(PITCHES)])

def key_for(who, text):
    return hashlib.sha1((who + "|" + text).encode("utf-8")).hexdigest()[:16]

async def render(sem, who, text, stats):
    v, rate, pitch = voice_for(who)
    path = os.path.join(OUT, key_for(who, text) + ".mp3")
    if os.path.exists(path) and os.path.getsize(path) > 0:
        stats["skip"] += 1
        return
    async with sem:
        for attempt in range(3):
            try:
                await edge_tts.Communicate(text, v, rate=rate, pitch=pitch).save(path)
                stats["ok"] += 1
                return
            except Exception as e:
                if attempt == 2:
                    stats["err"] += 1
                    print("ERR", who, repr(e)[:80])
                else:
                    await asyncio.sleep(1.0)

async def main():
    os.makedirs(OUT, exist_ok=True)
    lines = json.load(open(JSON_PATH, encoding="utf-8"))
    # dedup por (who,text)
    uniq = {}
    for it in lines:
        uniq[(it["who"], it["text"])] = True
    items = list(uniq.keys())
    print("Lineas unicas:", len(items), "| voces:", len(set(voice_for(w)[0] for w,_ in items)))
    sem = asyncio.Semaphore(10)
    stats = {"ok":0,"skip":0,"err":0}
    tasks = [render(sem, w, t, stats) for (w, t) in items]
    for i in range(0, len(tasks), 100):
        await asyncio.gather(*tasks[i:i+100])
        print("  progreso %d/%d  ok=%d skip=%d err=%d" % (min(i+100,len(tasks)), len(tasks), stats["ok"], stats["skip"], stats["err"]))
    print("HECHO ok=%d skip=%d err=%d" % (stats["ok"], stats["skip"], stats["err"]))

if __name__ == "__main__":
    asyncio.run(main())
