#!/usr/bin/env python3
"""Generador de arte por IA para sOC the Game.

Lee los prompts de `prompts/` (retratos, fondos, mapa) y genera los PNG en
`assets/` con los nombres exactos que espera el juego.

Backends:
  * pollinations (por defecto): servicio IA gratuito SIN key (modelos tipo Flux).
    Los retratos se recortan a fondo transparente con `rembg`.
  * gemini: API oficial de Google (requiere paid tier). Key en GEMINI_API_KEY.

Uso:
    python tools/gen_assets.py                      # genera lo que falte (pollinations)
    python tools/gen_assets.py --force              # regenera todo
    python tools/gen_assets.py detective plaza mapa # solo esos
    python tools/gen_assets.py --backend gemini     # via API oficial (GEMINI_API_KEY)
"""
import base64
import hashlib
import io
import json
import os
import re
import sys
import subprocess
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request

# --- Real-ESRGAN (upscaler IA por GPU, ncnn-vulkan; sin Python/torch ni token) ---
REALESRGAN_DIR = os.path.join(os.environ.get("LOCALAPPDATA", ""), "realesrgan")
REALESRGAN_EXE = os.path.join(REALESRGAN_DIR, "realesrgan-ncnn-vulkan.exe")
# Tamano final del arte tras el upscale IA (Pollinations da ~1024 nativos; ESRGAN x4
# anade detalle real y luego se ajusta a estos objetivos).
TARGET = {"portrait": (2400, 3200), "scene": (3840, 2160)}  # retrato 4K (3:4) · escena 4K UHD


# ADR-047: los RETRATOS se reescalan con el modelo ANIME. Desde el ADR-044 el arte es
# anime cel-shaded, pero el upscale seguia con realesrgan-x4plus (modelo de FOTO): sobre
# zonas planas y linework alucina textura fotografica, y donde mas se notaba era en los
# ojos (iris de distinto color, mirada saltona) — defectos que en el 768 original no
# estaban y aparecian al subir a 4K. x4plus-anime respeta el cel-shading.
# Las ESCENAS siguen con x4plus: todas las existentes se generaron asi y cambiarlo
# obligaria a regenerar los ~80 fondos.
UPSCALE_MODEL = {"portrait": "realesrgan-x4plus-anime", "scene": "realesrgan-x4plus"}


def upscale_esrgan(img, model="realesrgan-x4plus"):
    """Sube x4 con Real-ESRGAN en la GPU. Si el binario no esta, devuelve la imagen
    tal cual (el llamador hara un LANCZOS de respaldo)."""
    from PIL import Image
    if not os.path.exists(REALESRGAN_EXE):
        return img
    tin = tempfile.mktemp(suffix="_in.png")
    tout = tempfile.mktemp(suffix="_out.png")
    try:
        img.save(tin)
        subprocess.run([REALESRGAN_EXE, "-i", tin, "-o", tout, "-n", model],
                       cwd=REALESRGAN_DIR, check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return Image.open(tout).convert("RGB")
    except Exception as e:
        print(f"     (Real-ESRGAN no disponible: {e}; upscale por LANCZOS)")
        return img
    finally:
        for f in (tin, tout):
            try:
                os.remove(f)
            except OSError:
                pass

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PORTRAITS = ["detective", "emilio", "rosa", "tomas", "carmen", "nunez", "marta", "encapuchado",
    "laura", "padre", "vidal", "comisario",
    "nano", "periodista", "corredor", "madame", "magnate", "chivato",
    "diego", "sonia", "clara", "ruben", "marco", "kessler", "adler",
    "voluntario", "contable", "testigo", "sospechoso", "anonimo"]
BACKGROUNDS = ["plaza", "casa_emilio", "iglesia_ext", "iglesia_int", "tienda", "casa_carmen", "comisaria", "casa_marta",
    "archivo", "refugio", "muelle", "mansion", "sotano", "torre",
    "almacen", "redaccion", "subasta", "despacho", "azotea",
    "hospital", "morgue", "laboratorio", "clinica", "piso_diego", "oficina", "planta", "consejo",
    "centro", "barrio_alto", "ciudad2", "costa", "montana", "bar_clara", "bar",
    "capilla", "comedor",
    # --- ADR-037 estricto: un fondo por ubicacion ---
    "chatarreria", "trastienda", "gestoria", "casa_laura", "callejon", "salon_privado",
    "despacho_secretario", "nave_industrial", "archivo_medico", "archivo_becario",
    "azotea_nyxos", "bufete_clara", "cafe_ruben", "puesto_policia", "sede_regional",
    "ruta_clara", "clinica_kessler", "sala_ensayos", "clinica_clausurada", "piso_franco",
    "sanatorio_costa", "balneario", "puerto_pesca", "despacho_concejal", "despacho_abogado",
    "despacho_consejero", "despacho_rrpp", "sanatorio_montana", "cabana_ermitano",
    "local_voluntario", "tienda_dealer"]

# name -> (prompt.md, salida, tipo)   tipo: "portrait" | "scene"
JOBS = {}
for p in PORTRAITS:
    JOBS[p] = (f"prompts/portraits/{p}.md", f"assets/portraits/{p}.png", "portrait")
for b in BACKGROUNDS:
    JOBS[b] = (f"prompts/backgrounds/{b}.md", f"assets/backgrounds/{b}.png", "scene")
JOBS["mapa"] = ("prompts/map/mapa.md", "assets/backgrounds/mapa.png", "scene")
for _m in ["mapa_centro", "mapa_costa", "mapa_montana", "mapa_ciudad2"]:
    JOBS[_m] = (f"prompts/map/{_m}.md", f"assets/backgrounds/{_m}.png", "scene")
JOBS["splash"] = ("prompts/backgrounds/splash.md", "assets/backgrounds/splash.png", "scene")
JOBS["menu"] = ("prompts/backgrounds/menu.md", "assets/backgrounds/menu.png", "scene")

# Los retratos se muestran ENMARCADOS en el dialogo (tipo foto de expediente / holo-ID).
# ADR-035: el fondo del retrato NO debe contradecir la ubicacion (nada de neones de calle
# en una iglesia). Por eso llevan un backdrop NEUTRO oscuro (sin escenografia), y el fondo
# real de la escena lo pone el `bg` de la localizacion.
PORTRAIT_HINT = (", cinematic head-and-shoulders bust portrait, character centered "
    "and facing the viewer with headroom, set against a plain neutral dark studio "
    "backdrop with a soft amber-and-cold-blue gradient and gentle bokeh, NO location "
    "scenery, no street, no neon signs, no windows, no readable text, shallow depth of field")

# --- DIRECCION ARTISTICA GLOBAL: cyberpunk-noir --------------------------------
# Se anade a TODOS los prompts para dar un look coherente (megaciudad de neon bajo
# la lluvia, catedral gotica entre rascacielos, hologramas), manteniendo el
# contenido de cada prompt individual. Para volver al noir clasico, vaciar estos
# sufijos (o comentar su uso en gen_pollinations/gen_gemini).
# ADR-036: paleta unificada «mansion» para TODOS los fondos: noir pictorico y opulento,
# luz ambar/dorada calida como principal + acentos azul frio de tormenta, sombras
# profundas, algo desaturado, maderas oscuras y terciopelo, neon contenido (sin magenta
# estridente), grano de pelicula. Referencia: mansion.png.
# ADR-044: direccion global reorientada a ANIME CYBERPUNK-NOIR (Makoto Shinkai x
# Blade Runner). Se conserva la paleta «mansion» (ambar calido + azul frio de tormenta,
# sombras profundas, neon contenido) pero con render de anime cel-shaded de alta calidad,
# linework limpio y ojos expresivos. Backup del look anterior en
# assets/_backup_cyberpunk_noir_2026-07-10/.
STYLE_SCENE = (
    ", anime cyberpunk-noir background art for the whole game, Makoto Shinkai meets Blade "
    "Runner: lush hand-painted cel-shaded anime illustration fused with a neon-noir "
    "megacity, keeping the unified 'mansion' color grade: warm amber and golden key light "
    "with cold storm-blue accents, deep rich shadows, muted slightly desaturated palette, "
    "restrained neon and holograms (no garish magenta) bleeding through faint rain, wet "
    "reflective surfaces, volumetric haze and god-rays, cinematic Blade-Runner-by-"
    "candlelight mood, crisp clean anime linework, ultra-detailed scenery, high dynamic "
    "range, sharp focus, subtle film grain, beautiful anime key visual, lower third darker "
    "for the dialogue box")
# ADR-044: en modo anime, los retratos SÍ usan enhance=ON y este lead al frente (al
# contrario del ADR-042 realista, donde enhance dañaba los ojos). En anime, enhance empuja
# el cel-shading/linework y los ojos estilizados salen limpios y bien alineados.
ANIME_PORTRAIT_LEAD = ("Anime cel-shaded illustration, modern high-quality anime style "
    "(Makoto Shinkai / Kyoto Animation), strong clean anime linework, expressive anime "
    "eyes, ")
# ADR-046: los ojos eran el punto flaco (rosa/nano/voluntario salieron con un ojo
# deformado, de otro tamano o con el iris partido: el artefacto tipico de Flux). Se
# insiste de forma explicita en la simetria y en que los DOS ojos coincidan; vale para
# cualquier retrato que se regenere, no solo los tres que se rehicieron.
EYES_HINT = ("both eyes perfectly symmetrical and identical in shape, size and iris color, "
    "correct human eye anatomy, both irises fully round and centered, clean matching "
    "catchlights in both eyes, no deformed eye, no lazy eye, no melted or damaged eye, "
    "no cross-eye, no extra iris")
STYLE_PORTRAIT = (
    ", anime cyberpunk-noir character portrait in the unified 'mansion' color grade: modern "
    "high-quality anime style fused with neon-noir, clean cel shading, expressive detailed "
    "eyes with bright catchlights, " + EYES_HINT + ", warm amber/golden key light on the "
    "face with a cold storm-blue neon rim light, deep rich shadows, muted slightly "
    "desaturated palette, restrained neon, delicate clean linework, cinematic mood, sharp focus")

# ADR-045: las ESCENAS tambien front-cargan un lead anime fuerte (como los retratos). El
# sufijo STYLE_SCENE iba al final y no podia con prompts .md muy fotograficos («graphic-novel
# illustration», «painterly», «magenta neon»), asi que las escenas salian fotorrealistas.
# Ademas enhance=OFF en escenas: el reescritor de Pollinations expandia el prompt hacia foto
# cinematografica y diluia el «anime». Con el lead al frente + enhance OFF, el cel-shading manda.
ANIME_SCENE_LEAD = ("Anime cel-shaded background illustration, modern high-quality anime key "
    "visual in the style of Makoto Shinkai and Kyoto Animation, hand-painted anime background, "
    "flat cel shading, clean crisp anime linework, painted anime sky and clouds, 2D anime "
    "aesthetic, NOT photorealistic, NOT a 3d render, NOT a photograph. ")

# Objetivo 2K. Pollinations gratis suele devolver imagenes reducidas, asi que
# ademas se reescala el resultado a este tamano con LANCZOS (ensure_2k) para
# garantizar la resolucion. scene = 2560x1440 (QHD 16:9); portrait = 1536x2048 (3:4).
SIZE = {"portrait": (768, 1024), "scene": (2560, 1440)}


def extract_prompt(md_path):
    text = open(os.path.join(ROOT, md_path), encoding="utf-8").read()
    m = re.search(r"```(.*?)```", text, re.S)
    if not m:
        raise ValueError(f"Sin bloque de prompt en {md_path}")
    return " ".join(m.group(1).strip().split())


# Semilla ELEGIDA a mano para un asset concreto. Los ojos son una loteria en Flux
# (un ojo de otro color, de otro tamano, o partido), asi que cuando un retrato sale
# bien se ANOTA aqui su semilla y deja de ser cuestion de suerte: regenerarlo
# devuelve exactamente el mismo. Se eligieron mirando 4 candidatos de cada uno.
SEED_OVERRIDE = {
    "rosa": 140011,        # los dos iris iguales; elegida mirando los OJOS ampliados
    "nano": 627433,        # ojos ambar iguales, sin la marca de agua del anterior
    "voluntario": 790225,  # ojos simetricos y cara nerviosa, como pide el personaje
    "ruben": 295762,       # regenerado: el anterior salio pintado (semi-realista), no cel-shaded
}


def seed_for(name):
    if name in SEED_OVERRIDE:
        return SEED_OVERRIDE[name]
    # hash() de Python va aleatorizado por proceso (PYTHONHASHSEED): con el, la misma
    # llamada daba una imagen distinta cada vez y el arte no se podia reproducir.
    # md5 es estable entre ejecuciones y maquinas.
    return int(hashlib.md5(name.encode("utf-8")).hexdigest()[:8], 16) % 1_000_000


# ---------------------------------------------------------------------------
#  BACKEND: POLLINATIONS (sin key)
# ---------------------------------------------------------------------------
def poll_fetch(prompt, w, h, seed, enhance=True):
    # enhance=true expande el prompt y da un look mas ilustrado; en RETRATOS empeora
    # los ojos/rasgos, asi que se desactiva para caras (ADR-035/042). En escenas ayuda.
    url = ("https://image.pollinations.ai/prompt/" + urllib.parse.quote(prompt) +
           f"?width={w}&height={h}&seed={seed}&model=flux&nologo=true" +
           ("&enhance=true" if enhance else ""))
    req = urllib.request.Request(url, headers={"User-Agent": "sOC-asset-gen"})
    # Pollinations gratuito limita por IP (HTTP 429): backoff largo y reintentos.
    delays = [0, 15, 30, 50, 75]
    last = None
    for d in delays:
        if d:
            print(f"       ...esperando {d}s (rate limit)", flush=True)
            time.sleep(d)
        try:
            with urllib.request.urlopen(req, timeout=180) as r:
                return r.read()
        except urllib.error.HTTPError as e:
            last = e
            if e.code not in (429, 500, 502, 503, 520):
                raise
        except Exception as e:
            last = e
    raise last


def gen_pollinations(name, prompt, kind):
    from PIL import Image
    w, h = SIZE[kind]
    if kind == "portrait":
        full = ANIME_PORTRAIT_LEAD + prompt + STYLE_PORTRAIT + PORTRAIT_HINT
        enh = True   # ADR-044: en retratos enhance=ON empuja el cel-shading sin danar ojos.
    else:
        full = ANIME_SCENE_LEAD + prompt + STYLE_SCENE
        enh = False  # ADR-045: en escenas enhance=OFF; si no, el reescritor tira a foto.
    raw = poll_fetch(full, w, h, seed_for(name), enhance=enh)
    img = Image.open(io.BytesIO(raw)).convert("RGB")
    # Detalle real: Real-ESRGAN x4 en la GPU y ajuste al tamano objetivo (4K/2K).
    tw, th = TARGET[kind]
    img = upscale_esrgan(img, UPSCALE_MODEL[kind])
    if img.size != (tw, th):
        if img.size[0] >= tw:                       # bajamos del x4 -> nitidez maxima
            img = img.resize((tw, th), Image.LANCZOS)
        else:                                       # sin ESRGAN: respaldo LANCZOS+realce
            img = ensure_2k(img, tw, th)
    return img


def ensure_2k(img, w, h):
    """Lleva la imagen al tamano objetivo (2K). Pollinations gratis genera ~1024px
    nativos, asi que se sube en DOS pasos (menos halo) y se realza con UnsharpMask
    para recuperar nitidez percibida. No crea detalle nuevo (limite del backend),
    pero deja los bordes y texturas mucho mas crujientes que un LANCZOS directo."""
    from PIL import Image, ImageFilter
    if img.size != (w, h):
        mid = (max(w * 7 // 10, img.size[0]), max(h * 7 // 10, img.size[1]))
        img = img.resize(mid, Image.LANCZOS).resize((w, h), Image.LANCZOS)
        img = img.filter(ImageFilter.UnsharpMask(radius=2.4, percent=155, threshold=2))
        img = img.filter(ImageFilter.DETAIL)
    return img


def cutout(img):
    """Quita el fondo del retrato -> RGBA transparente.

    Preferentemente con rembg (U^2-Net). Si no esta instalado (p.ej. onnxruntime
    sin wheel para esta version de Python), recorta por flood-fill desde los bordes
    sobre el fondo oscuro plano que garantiza PORTRAIT_HINT.
    """
    try:
        from rembg import remove
        return remove(img)  # PIL RGBA
    except Exception as e:
        print(f"     (rembg no disponible: {e}; recorte por flood-fill)")
        return floodfill_cutout(img)


def floodfill_cutout(img, tol=60):
    """Recorte sin rembg (numpy + scipy): separa el personaje del fondo negro y
    descarta los carteles/luces de neon que Flux mete sueltos, quedandose SOLO con
    el componente conectado mas grande (el busto). Rellena huecos interiores
    (ropa/pelo oscuros) y suaviza el borde."""
    import numpy as np
    from scipy import ndimage
    from PIL import Image, ImageFilter
    rgb = np.asarray(img.convert("RGB"), dtype=np.int16)
    h, w = rgb.shape[:2]
    # Color de fondo = mediana de un marco de 6px en el borde.
    frame = np.concatenate([
        rgb[:6, :, :].reshape(-1, 3), rgb[-6:, :, :].reshape(-1, 3),
        rgb[:, :6, :].reshape(-1, 3), rgb[:, -6:, :].reshape(-1, 3)])
    bg = np.median(frame, axis=0)
    fg = np.abs(rgb - bg).max(axis=2) > tol        # personaje + luces sueltas
    fg = ndimage.binary_opening(fg, iterations=1)  # quita motas de 1px
    lbl, n = ndimage.label(fg)
    if n == 0:
        return img.convert("RGBA")
    sizes = ndimage.sum(np.ones_like(lbl), lbl, index=range(1, n + 1))
    mask = lbl == (int(np.argmax(sizes)) + 1)      # componente mayor = personaje
    mask = ndimage.binary_fill_holes(mask)
    mask = ndimage.binary_closing(mask, iterations=2)
    alpha = Image.fromarray((mask * 255).astype("uint8"), "L")
    alpha = alpha.filter(ImageFilter.GaussianBlur(1.0))  # borde suave
    out = img.convert("RGBA")
    out.putalpha(alpha)
    return out


# ---------------------------------------------------------------------------
#  BACKEND: GEMINI (paid tier)
# ---------------------------------------------------------------------------
GEMINI_MODEL = "gemini-3-pro-image-preview"
GEMINI_API = "https://generativelanguage.googleapis.com/v1beta/models/{m}:generateContent?key={k}"


def gen_gemini(name, prompt, kind):
    from PIL import Image
    key = os.environ.get("GEMINI_API_KEY", "")
    if not key:
        raise RuntimeError("Falta GEMINI_API_KEY")
    aspect = "3:4" if kind == "portrait" else "16:9"
    full = prompt + (STYLE_PORTRAIT if kind == "portrait" else STYLE_SCENE)
    body = {"contents": [{"parts": [{"text": full}]}],
            "generationConfig": {"responseModalities": ["TEXT", "IMAGE"],
                                 "imageConfig": {"aspectRatio": aspect}}}
    req = urllib.request.Request(GEMINI_API.format(m=GEMINI_MODEL, k=key),
                                 data=json.dumps(body).encode(),
                                 headers={"Content-Type": "application/json"}, method="POST")
    with urllib.request.urlopen(req, timeout=180) as r:
        data = json.load(r)
    for cand in data.get("candidates", []):
        for part in cand.get("content", {}).get("parts", []):
            inline = part.get("inlineData") or part.get("inline_data")
            if inline and inline.get("data"):
                img = Image.open(io.BytesIO(base64.b64decode(inline["data"])))
                return ensure_2k(img.convert("RGB"), *SIZE[kind])
    raise RuntimeError("Sin imagen: " + json.dumps(data)[:300])


# ---------------------------------------------------------------------------
def main():
    args = sys.argv[1:]
    force = "--force" in args
    backend = "pollinations"
    if "--backend" in args:
        backend = args[args.index("--backend") + 1]
    wanted = [a for a in args if a in JOBS]
    targets = wanted or list(JOBS.keys())
    gen = gen_gemini if backend == "gemini" else gen_pollinations
    print(f"Backend: {backend}   ·   objetivos: {len(targets)}\n")

    ok = skip = fail = 0
    for name in targets:
        md, out, kind = JOBS[name]
        out_abs = os.path.join(ROOT, out)
        if os.path.exists(out_abs) and not force:
            print(f"  = {name:14s} ya existe")
            skip += 1
            continue
        try:
            prompt = extract_prompt(md)
            print(f"  · {name:14s} generando ({kind}) ...", flush=True)
            img = gen(name, prompt, kind)
            os.makedirs(os.path.dirname(out_abs), exist_ok=True)
            img.save(out_abs)
            print(f"  + {name:14s} OK -> {out}  ({img.size[0]}x{img.size[1]})")
            ok += 1
        except Exception as e:
            print(f"  ! {name:14s} ERROR: {e}")
            fail += 1
        time.sleep(6)   # espaciado entre imagenes para no gatillar el rate limit

    print(f"\nHecho. Generadas: {ok}  ·  Ya existian: {skip}  ·  Fallos: {fail}")


if __name__ == "__main__":
    main()
