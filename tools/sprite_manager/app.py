"""SpriteManager — app local para gestionar y editar los sprites del juego,
con opciones manuales y automaticas y un asistente IA (build.nvidia.com).

Arranque:  python app.py   ->   http://127.0.0.1:5000
"""
import os
import io
import sys
import json
import base64
import glob
import requests
from flask import Flask, request, jsonify, send_file, Response
from PIL import Image

import sprite_ops as ops

# --- Resolucion de rutas (funciona tanto con "python app.py" como con el .exe
#     empaquetado por PyInstaller) -------------------------------------------
if getattr(sys, "frozen", False):
    EXE_DIR = os.path.dirname(sys.executable)   # carpeta donde vive el .exe
    RES_DIR = sys._MEIPASS                       # recursos embebidos (static/, config por defecto)
else:
    EXE_DIR = os.path.dirname(os.path.abspath(__file__))
    RES_DIR = EXE_DIR

HERE = EXE_DIR


def _find_assets():
    """Localiza la carpeta assets/ del juego.
    1) config.json -> "assets_dir" (absoluta)  2) ../../assets desde el exe
    3) sube directorios buscando un project.godot con assets/ al lado."""
    if CFG.get("assets_dir"):
        return os.path.normpath(CFG["assets_dir"])
    cand = os.path.normpath(os.path.join(EXE_DIR, "..", "..", "assets"))
    if os.path.isdir(cand):
        return cand
    d = EXE_DIR
    for _ in range(6):
        if os.path.exists(os.path.join(d, "project.godot")) and os.path.isdir(os.path.join(d, "assets")):
            return os.path.join(d, "assets")
        d = os.path.dirname(d)
    return cand  # fallback (aunque no exista aun)


def _load_config():
    """config.json externo (junto al exe) tiene prioridad; si no, el embebido."""
    for base in (EXE_DIR, RES_DIR):
        p = os.path.join(base, "config.json")
        if os.path.exists(p):
            with open(p, "r", encoding="utf-8") as f:
                return json.load(f)
    raise FileNotFoundError("No se encontro config.json (junto al .exe ni embebido)")


CFG = _load_config()
ASSETS = _find_assets()

SHEET_PRESETS = {
    "characters.png": {"type": "chars", "ref_x": [45, 410], "rows": ["green", "red", "blue", "oldman", "purple"],
                       "groups": [{"k": "down", "x0": 45, "x1": 410}, {"k": "back", "x0": 435, "x1": 585},
                                  {"k": "up", "x0": 590, "x1": 875}, {"k": "left", "x0": 880, "x1": 1120}],
                       "out": "people"},
    "detective.png": {"type": "single", "ref_x": [45, 715], "prefix": "det_", "out": "detective_frames",
                      "names": ["down_0", "left_0", "left_1", "up_0", "right_0", "up_1", "right_1"]},
    "npcs.png": {"type": "blobs", "out": "npcs_frames", "prefix": "npc_"},
    "citypack_1.png": {"type": "blobs", "out": "buildings_auto", "prefix": "obj_"},
    "citypack_2.png": {"type": "blobs", "out": "citypack2_frames", "prefix": "obj_"},
}

app = Flask(__name__, static_folder=os.path.join(RES_DIR, "static"), static_url_path="/static")


def apath(rel):
    p = os.path.normpath(os.path.join(ASSETS, rel))
    if not p.startswith(ASSETS):
        raise ValueError("ruta fuera de assets")
    return p


@app.get("/")
def index():
    return send_file(os.path.join(RES_DIR, "static", "index.html"))


@app.get("/api/config")
def api_config():
    subdirs = [d for d in os.listdir(ASSETS) if os.path.isdir(os.path.join(ASSETS, d))]
    subdirs = [d for d in subdirs if any(glob.glob(os.path.join(ASSETS, d, "*.png")))]
    sheets = [s for s in SHEET_PRESETS if os.path.exists(apath(s))]
    root_pngs = sorted(os.path.basename(p) for p in glob.glob(os.path.join(ASSETS, "*.png")))
    return jsonify({"folders": sorted(subdirs), "sheets": sheets, "root_pngs": root_pngs,
                    "text_model": CFG.get("text_model"), "vision_model": CFG.get("vision_model")})


@app.get("/api/frames")
def api_frames():
    folder = request.args.get("folder", "")
    d = apath(folder)
    files = sorted(os.path.basename(p) for p in glob.glob(os.path.join(d, "*.png")))
    return jsonify([{"name": n, "url": f"/img?path={folder}/{n}"} for n in files])


@app.get("/img")
def img():
    p = apath(request.args.get("path", ""))
    if not os.path.exists(p):
        return "not found", 404
    resp = send_file(p, mimetype="image/png")
    resp.headers["Cache-Control"] = "no-store"
    return resp


@app.post("/api/edit")
def api_edit():
    data = request.get_json()
    rel = data["path"]
    p = apath(rel)
    img = Image.open(p).convert("RGBA")
    for op in data.get("ops", []):
        k = op.get("op")
        if k == "autotrim":
            img = ops.autotrim(img, op.get("pad", 0))
        elif k == "defringe":
            img = ops.defringe(img, op.get("passes", 1))
        elif k == "removebg":
            img = ops.remove_bg(img, op.get("v", 0.66), op.get("sat", 0.16))
        elif k == "colorkey":
            img = ops.color_key_bg(img, op.get("tol", 34))
        elif k == "trim":
            img = ops.trim_sides(img, op.get("top", 0), op.get("bottom", 0), op.get("left", 0), op.get("right", 0))
        elif k == "flip":
            img = ops.flip_h(img)
        elif k == "recenter":
            img = ops.recenter(img, op.get("cw", img.width), op.get("ch", img.height))
    img.save(p)
    return jsonify({"ok": True})


@app.post("/api/save_image")
def api_save_image():
    """Guarda una imagen editada en el cliente (borrador/goma)."""
    data = request.get_json()
    p = apath(data["path"])
    os.makedirs(os.path.dirname(p), exist_ok=True)
    raw = base64.b64decode(data["png"].split(",")[-1])
    Image.open(io.BytesIO(raw)).convert("RGBA").save(p)
    return jsonify({"ok": True})


@app.post("/api/autoslice")
def api_autoslice():
    data = request.get_json()
    sheet = data["sheet"]
    preset = SHEET_PRESETS.get(sheet)
    if not preset:
        return jsonify({"error": "hoja desconocida"}), 400
    params = data.get("params", {})
    src = apath(sheet)
    out_dir = apath(preset["out"])
    if preset["type"] == "chars":
        made = ops.slice_character_sheet(src, out_dir, preset["ref_x"], preset["groups"], preset["rows"], params)
    elif preset["type"] == "single":
        made = ops.slice_single_band(src, out_dir, preset["ref_x"], preset["names"], params, preset.get("prefix", ""))
    else:
        made = ops.slice_blobs(src, out_dir, params.get("min_w", 40), params.get("min_h", 40),
                               params.get("tol", 34), preset.get("prefix", "obj_"))
    return jsonify({"ok": True, "folder": preset["out"], "count": len(made)})


@app.post("/api/detect_boxes")
def api_detect_boxes():
    """Auto-detecta cajas de sprites en una hoja para el recorte manual."""
    data = request.get_json()
    p = apath(data["sheet"])
    if not os.path.exists(p):
        return jsonify({"error": "hoja no encontrada"}), 404
    pr = data.get("params", {})
    boxes = ops.auto_boxes(p, min_w=int(pr.get("min_w", 22)), min_h=int(pr.get("min_h", 26)),
                           band_gap=int(pr.get("band_gap", 6)), col_gap=int(pr.get("col_gap", 7)),
                           dens=pr.get("dens"))
    im = Image.open(p)
    return jsonify({"w": im.width, "h": im.height, "boxes": boxes})


@app.post("/api/export_boxes")
def api_export_boxes():
    """Recorta y guarda las cajas ajustadas por el usuario como frames PNG."""
    data = request.get_json()
    src = apath(data["sheet"])
    out_dir = apath(data["out"])
    os.makedirs(out_dir, exist_ok=True)
    prefix = data.get("prefix", "")
    o = data.get("opts", {})
    cw, ch = int(o.get("cell_w", 0) or 0), int(o.get("cell_h", 0) or 0)
    img = Image.open(src).convert("RGBA")
    made = []
    for i, b in enumerate(data.get("boxes", [])):
        if b.get("w", 0) < 2 or b.get("h", 0) < 2:
            continue
        name = str(b.get("name") or i).strip() or str(i)
        cell = ops.export_box(img, b, cw=cw, ch=ch,
                              removebg=bool(o.get("removebg", True)),
                              do_trim=bool(o.get("trim", True)),
                              defr=int(o.get("defringe", 0)),
                              bg_v=float(o.get("bg_v", 0.62)), bg_sat=float(o.get("bg_sat", 0.20)),
                              flip=bool(b.get("flip", False)))
        fn = f"{prefix}{name}.png"
        cell.save(os.path.join(out_dir, fn))
        made.append(fn)
    return jsonify({"ok": True, "folder": data["out"], "count": len(made), "files": made})


@app.post("/api/crop_raw")
def api_crop_raw():
    """Recorta una caja de la hoja SIN procesar y la guarda (para ajustarla luego
    en el editor manual). Por defecto en la carpeta _staging."""
    data = request.get_json()
    src = apath(data["sheet"])
    b = data["box"]
    out = (data.get("out") or "_staging").strip()
    name = (data.get("name") or "crop").strip().replace("/", "_")
    if not name.lower().endswith(".png"):
        name += ".png"
    out_dir = apath(out)
    os.makedirs(out_dir, exist_ok=True)
    img = Image.open(src).convert("RGBA")
    x, y = max(0, int(b["x"])), max(0, int(b["y"]))
    w, h = max(1, int(b["w"])), max(1, int(b["h"]))
    sub = img.crop((x, y, min(img.width, x + w), min(img.height, y + h)))
    sub.save(os.path.join(out_dir, name))
    return jsonify({"ok": True, "folder": out, "name": name})


@app.post("/api/delete")
def api_delete():
    data = request.get_json()
    p = apath(data["path"])
    if os.path.exists(p):
        os.remove(p)
    return jsonify({"ok": True})


@app.post("/api/cleanup_tiles")
def api_cleanup_tiles():
    """Housekeeping: borra los tile_*.png sueltos (deja el atlas renombrado)."""
    removed = 0
    for p in glob.glob(os.path.join(ASSETS, "tile_*.png")):
        os.remove(p); removed += 1
    for p in glob.glob(os.path.join(ASSETS, "tile_*.png.import")):
        os.remove(p)
    return jsonify({"ok": True, "removed": removed})


# ---------------------------------------------------------------------------
#  Asistente IA (build.nvidia.com, OpenAI-compatible)
# ---------------------------------------------------------------------------
def _nvidia_chat(messages, model):
    r = requests.post(
        f"{CFG['base_url']}/chat/completions",
        headers={"Authorization": f"Bearer {CFG['nvidia_api_key']}", "Accept": "application/json"},
        json={"model": model, "messages": messages, "max_tokens": 800, "temperature": 0.3},
        timeout=120,
    )
    r.raise_for_status()
    return r.json()["choices"][0]["message"]["content"]


def _nvidia_image(prompt, model, width=1024, height=1024, steps=4, cfg_scale=3.5, seed=0):
    """Genera una imagen con un modelo de NVIDIA (FLUX/SDXL) y devuelve bytes PNG."""
    base = CFG.get("image_base", "https://ai.api.nvidia.com/v1/genai")
    url = f"{base}/{model}"
    payload = {"prompt": prompt, "mode": "base", "cfg_scale": cfg_scale,
               "width": width, "height": height, "seed": seed, "steps": steps}
    r = requests.post(url, headers={"Authorization": f"Bearer {CFG['nvidia_api_key']}",
                                    "Accept": "application/json"}, json=payload, timeout=200)
    r.raise_for_status()
    d = r.json()
    b64 = None
    arts = d.get("artifacts") or d.get("images") or d.get("data")
    if isinstance(arts, list) and arts:
        a = arts[0]
        b64 = a.get("base64") or a.get("b64_json") or a.get("image") if isinstance(a, dict) else a
    b64 = b64 or d.get("image") or d.get("b64_json")
    if not b64:
        raise ValueError("Respuesta sin imagen: " + json.dumps(d)[:300])
    if isinstance(b64, str) and b64.startswith("data:"):
        b64 = b64.split(",", 1)[1]
    return base64.b64decode(b64)


@app.post("/api/gen_image")
def api_gen_image():
    """Genera un sprite/NPC por IA (NVIDIA) y lo guarda en assets/<name>.png."""
    data = request.get_json()
    prompt = (data.get("prompt") or "").strip()
    if not prompt:
        return jsonify({"error": "prompt vacio"}), 400
    name = (data.get("name") or "gen").strip().replace("/", "_")
    if not name.lower().endswith(".png"):
        name += ".png"
    model = data.get("model") or CFG.get("image_model", "black-forest-labs/flux.1-schnell")
    try:
        raw = _nvidia_image(prompt, model, int(data.get("size", 1024)),
                            int(data.get("size", 1024)), int(data.get("steps", 4)))
    except requests.HTTPError as e:
        return jsonify({"error": f"NVIDIA {e.response.status_code}: {e.response.text[:300]}"}), 502
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    p = apath(name)
    Image.open(io.BytesIO(raw)).convert("RGBA").save(p)
    return jsonify({"ok": True, "name": name, "url": f"/img?path={name}"})


@app.post("/api/assistant")
def api_assistant():
    data = request.get_json()
    prompt = data.get("prompt", "")
    image_path = data.get("image_path")
    system = ("Eres un asistente experto en pixel-art y recorte de sprites para un juego en Godot. "
              "Ayudas a diagnosticar recortes (halos, fondos, cabezas cortadas, centrado) y recomiendas "
              "operaciones concretas: autotrim, defringe (n pasadas), removebg (umbral v/sat), colorkey (tol), "
              "trim por lados, recenter. Responde en espanol, breve y accionable.")
    try:
        if image_path:
            p = apath(image_path)
            with open(p, "rb") as fh:
                b64 = base64.b64encode(fh.read()).decode()
            content = [
                {"type": "text", "text": prompt or "Analiza este sprite recortado y dime que ajustar."},
                {"type": "image_url", "image_url": {"url": f"data:image/png;base64,{b64}"}},
            ]
            msgs = [{"role": "system", "content": system}, {"role": "user", "content": content}]
            txt = _nvidia_chat(msgs, CFG["vision_model"])
        else:
            msgs = [{"role": "system", "content": system}, {"role": "user", "content": prompt}]
            txt = _nvidia_chat(msgs, CFG["text_model"])
        return jsonify({"reply": txt})
    except requests.HTTPError as e:
        return jsonify({"error": f"API NVIDIA: {e.response.status_code} {e.response.text[:300]}"}), 502
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    print(f"SpriteManager -> http://127.0.0.1:5000   (assets: {ASSETS})")
    app.run(host="127.0.0.1", port=5000, debug=False)
