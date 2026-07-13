# -*- coding: utf-8 -*-
"""Traduce las cadenas de diálogo (assets/i18n/_es_strings.json) a EN y ZH usando la
API de texto gratuita de Pollinations, por lotes y de forma RESUMIBLE (carga lo ya
hecho y solo traduce lo que falta). Salidas: assets/i18n/dlg_en.json y dlg_zh.json."""
import io, json, os, time, urllib.parse, urllib.request

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
I18N = os.path.join(ROOT, "assets", "i18n")
SRC = os.path.join(I18N, "_es_strings.json")
LANGS = {"en": "English", "zh": "Simplified Chinese"}
BATCH = 8


def load_json(path, default):
    if os.path.exists(path):
        try:
            return json.load(io.open(path, encoding="utf-8"))
        except Exception:
            return default
    return default


def save_json(path, obj):
    io.open(path, "w", encoding="utf-8").write(json.dumps(obj, ensure_ascii=False, indent=0))


def api(prompt):
    url = "https://text.pollinations.ai/" + urllib.parse.quote(prompt)
    req = urllib.request.Request(url, headers={"User-Agent": "soc-i18n"})
    for d in [0, 8, 20, 40]:
        if d:
            time.sleep(d)
        try:
            with urllib.request.urlopen(req, timeout=90) as r:
                return r.read().decode("utf-8", "replace").strip()
        except Exception:
            continue
    return None


def translate_batch(batch, langname):
    prompt = ("Translate each string in this JSON array from Spanish into %s. It is "
              "noir detective video-game dialogue; keep the tone, keep any leading "
              "symbols like the arrow. Output ONLY a valid JSON array of the SAME length, "
              "same order, nothing else:\n\n%s" % (langname, json.dumps(batch, ensure_ascii=False)))
    out = api(prompt)
    if not out:
        return None
    # Extraer el array JSON de la respuesta.
    a, b = out.find("["), out.rfind("]")
    if a >= 0 and b > a:
        try:
            arr = json.loads(out[a:b + 1])
            if isinstance(arr, list) and len(arr) == len(batch):
                return [str(x) for x in arr]
        except Exception:
            pass
    return None


def translate_one(s, langname):
    prompt = ("Translate this noir detective video-game line from Spanish into %s. "
              "Output ONLY the translation, no quotes, no notes:\n\n%s" % (langname, s))
    return api(s and prompt)


def main():
    src = load_json(SRC, [])
    print("Cadenas a traducir:", len(src))
    for lang, langname in LANGS.items():
        outpath = os.path.join(I18N, "dlg_%s.json" % lang)
        table = load_json(outpath, {})
        pending = [s for s in src if s not in table]
        print("[%s] faltan %d de %d" % (lang, len(pending), len(src)))
        done = 0
        for i in range(0, len(pending), BATCH):
            batch = pending[i:i + BATCH]
            res = translate_batch(batch, langname)
            if res is None:
                # Respaldo: una a una.
                res = []
                for s in batch:
                    t = translate_one(s, langname)
                    res.append(t if t else "")   # "" = fallo (no guardar)
            # Solo se guardan traducciones REALES; los fallos (429/timeout) quedan
            # pendientes para un reintento futuro y NO se envenenan con español.
            for s, t in zip(batch, res):
                if t and t != s:
                    table[s] = t
            done += len(batch)
            if done % 40 < BATCH:
                save_json(outpath, table)
                print("  [%s] %d/%d" % (lang, done, len(pending)), flush=True)
            time.sleep(1)
        save_json(outpath, table)
        print("[%s] LISTO -> %s (%d entradas)" % (lang, outpath, len(table)))
    print("TRADUCCION COMPLETA")


if __name__ == "__main__":
    main()
