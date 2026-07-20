#!/usr/bin/env python3
"""Generador de "fotos de objeto" para las PISTAS de sOC the Game.

El tablero de pruebas (EvidenceBoard) muestra cada pista como una polaroid y
busca su imagen en `res://assets/objects/<slug>.png`, donde `<slug>` es el titulo
de la pista en minusculas y sin acentos ("El pañuelo" -> `el-panuelo.png`), tal
como lo calculan `slugify()` aqui y `Global.clue_slug()` en Godot. Este script:

  1. Lee `clues.json` del userdata de Godot.
  2. Para las pistas que representan un OBJETO FISICO tangible (una prueba que se
     fotografia: taza, sello, lacre, cuaderno, agenda, sobre, recibo, grabadora,
     blisters, pañuelo, foto, mapa, cartel, expediente, albaran, post-it, tarjeta,
     libro de registro...), genera una "foto de evidencia" noir con Pollinations.
  3. Guarda cada PNG en `assets/objects/<slug>.png` a 768x768 (SIN Real-ESRGAN:
     se ven pequeñas en el tablero, se prioriza rapidez).

NO se generan imagenes para conceptos abstractos, nombres de personas,
deducciones o acciones (p. ej. "Cerrar el caso", "El exnovio", "La coartada
rota"). El mapa OBJECTS de abajo es la lista curada (slug -> objeto concreto);
su clave es el nombre de fichero, asi que se lee de un vistazo que foto es cada
una y coincide con lo que hay en assets/objects/.

Reutiliza el acceso a Pollinations de `gen_assets.py` (`poll_fetch`,
`ANIME_SCENE_LEAD`). Descarga concurrente (por defecto 8 hilos) con reintentos;
si Pollinations falla una pista se reintenta y, si no, se salta y sigue.

Uso:
    python tools/gen_objects.py                 # genera lo que falte
    python tools/gen_objects.py --force         # regenera todo
    python tools/gen_objects.py --workers 4     # menos concurrencia (rate limit)
    python tools/gen_objects.py el-panuelo      # solo esos slugs

Tras generar, reimporta en Godot:
    godot_console.exe --headless --import
"""
import io
import os
import re
import sys
import json
import time
import hashlib
import unicodedata
import importlib.util
from concurrent.futures import ThreadPoolExecutor, as_completed

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(ROOT, "assets", "objects")
CLUES_JSON = os.path.join(
    os.environ.get("APPDATA", ""), "Godot", "app_userdata", "sOC", "clues.json")

# --- Reutiliza la maquinaria de Pollinations de gen_assets.py ---------------
_spec = importlib.util.spec_from_file_location(
    "gen_assets", os.path.join(ROOT, "tools", "gen_assets.py"))
_ga = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_ga)
poll_fetch = _ga.poll_fetch
ANIME_SCENE_LEAD = _ga.ANIME_SCENE_LEAD  # lead anime del pipeline, para coherencia

SIZE = 768  # las polaroids del tablero son pequeñas; 768 sobra y va rapido

# Sufijo de estilo especifico para FOTO DE PRUEBA (no es un fondo de escena):
# primer plano del objeto sobre superficie oscura, luz dramatica de neon, noir.
EVIDENCE_STYLE = (
    ", shot as a police forensic evidence photograph: a single object is the "
    "clear subject in sharp focus, resting on a dark matte surface, dramatic "
    "low-key noir lighting with a cold neon rim glow and warm amber accent, "
    "cyberpunk-noir mood, shallow depth of field, deep moody shadows, "
    "centered close-up composition, ultra detailed. No people, no hands, "
    "no readable text, no lettering, no captions, no watermark, no logo "
    "overlay, no frame, no border.")


def build_prompt(desc):
    """Prompt completo = lead anime del pipeline + objeto concreto + estilo prueba."""
    return (ANIME_SCENE_LEAD + "A police evidence close-up photograph of " +
            desc + EVIDENCE_STYLE)


def slugify(title):
    """Nombre de fichero a partir del titulo de la pista: "El pañuelo" -> "el-panuelo".

    DEBE coincidir con Global.clue_slug() en scripts/Global.gd: es la clave con la
    que el tablero busca assets/objects/<slug>.png.
    """
    s = unicodedata.normalize("NFD", title)
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    s = re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-")
    return s[:48].strip("-")


def seed_for(slug):
    # Semilla estable derivada del slug (que ya no es hex: se hashea).
    # Renombrar un objeto cambia su semilla -> --force daria otra imagen.
    return int(hashlib.sha1(slug.encode("utf-8")).hexdigest()[:8], 16) % 1_000_000


# ---------------------------------------------------------------------------
#  LISTA CURADA: slug -> descripcion del OBJETO concreto a fotografiar.
#  El objeto se dedujo del title/text de cada pista en clues.json.
#  Solo pistas que representan una prueba fisica y tangible.
# ---------------------------------------------------------------------------
OBJECTS = {
    # --- Caso 1: Marta / la iglesia ---
    "la-cita-sin-nombre": "an open leather personal diary lying on a desk, one page showing a single handwritten appointment entry at night with no name, only a time",
    "el-panuelo": "a white cloth handkerchief embroidered with the initials 'M.S.' lying on the ground beside stone stairs",
    "el-grafiti": "a cryptic spray-painted symbol on a grimy wall that looks like a secret code but is really a bar advertisement",
    "el-coche-mal-aparcado": "a car badly parked at a curb at night with a paper parking ticket tucked under the windshield wiper",
    # --- Caso 2: Fundacion Amparo / trata ---
    "la-agenda-de-misas": "an old book listing the mass schedules of three parishes, with a folded photocopied police memo tucked between its pages",
    "el-soplo-anonimo": "an anonymous typed tip-off note on a dark table, an accusatory unsigned letter, clearly a decoy",
    "las-tres-campanas": "three old bronze church bells displayed as trophies on stands, with a small engraved brass plaque",
    "la-marca-del-gremio": "an engraved metal seal stamp depicting a balance scale between two bells, a sinister guild mark, extreme close-up",
    "el-metodo-heredado": "a fresh blob of red sealing wax stamped as a signature on a document, a chilling new calling-card mark",
    # --- Caso 3: el gremio / el muelle / la subasta ---
    "el-libro-de-envios": "an old warehouse shipping ledger book lying open, ruled columns of dates and ink stamps, a smugglers 'shipments' registry",
    "la-lista-de-clientes": "a sheet of paper covered in an encrypted client list, coded rows of ciphered names and bid numbers",
    "el-sello-de-la-casa": "an embossed auction invitation card sealed with a golden wax seal",
    "el-cuaderno-de-pujas": "a small worn notebook on a desk, half hidden under papers, its pages filled with auction bids and nicknames",
    # --- Caso 4: Vaultier / el Conclave ---
    "los-pagos": "a printed bank statement of a shell ghost account on a desk, columns of suspicious transfer payments highlighted",
    # --- Caso 5: Somnia / farmaco ---
    "el-farmaco-somnia": "a small unlabeled glass drug vial of an experimental medicine beside a sealed blood sample tube, a handwritten label reading 'Somnia'",
    "los-blisters-vacios": "several empty pharmaceutical blister packs hidden inside an open bedside-table drawer, far more than a single treatment",
    # --- Caso 6: la clinica fantasma / ensayos ---
    "ensayos-con-personas": "a tall stack of manila medical patient files and clinical history folders labelled 'voluntarios' on a table",
    "el-consentimiento-falso": "a stack of informed-consent medical forms on a desk, signature lines filled by a forged notary",
    "la-ficha-sin-nombre": "a clinical index card inside an archive box on a shelf, printed with a subject number but no patient name",
    "el-expediente-sellado": "an open case file on a desk stamped with a consent seal and an unusual signature",
    # --- Caso 7: Nyxos Pharma / la planta ---
    "n-p-nyxos-pharma": "sealed cardboard shipping crates stencilled 'Nyxos Pharma' stacked inside a shut-down clinic",
    "la-marca-nyxos": "a laboratory tray holding rows of numbered pharmaceutical ampoules and vials, each printed with a batch lot number",
    "el-albaran-interno": "an internal delivery note packing slip bearing a corporate serpent logo, listing numbered product lots, one line marked with initials",
    "el-lote-humano": "a security guard's logbook open on a table, columns listing 'test lots' with human identifier numbers",
    # --- Caso 8: los sobornos / archivo ---
    "el-memorandum-interno": "a single internal corporate memo sheet on a dark desk, a cold directive ordering to 'purge non-viable subjects'",
    "el-codigo-del-proyecto": "a clinical file folder stamped in red with a code reading 'Proyecto SOMNIA - Nivel Consejo'",
    # --- Caso 9: el balneario costero ---
    "los-desaparecidos-del-sur": "an old town population registry book, a hidden list of residents marked as 'transferred to treatment' who never returned",
    "el-sanatorio-de-lo-alto": "a grainy night surveillance shot of an isolated building on a hilltop with a chimney smoking against the dark sky",
    # --- Caso 10: la sede / el consejo ---
    "el-acta-secreta": "a confidential corporate board minutes document approving a secret project, with a budget line for 'subject management'",
    "el-acta-incompleta": "a corporate council minutes document on a desk with one agenda item roughly torn out, leaving a ragged gap",
    "la-votacion-del-consejo": "a board voting record sheet on a table showing a unanimous approval tally of hand-marked votes",
    "la-foto-recortada": "a framed council group photograph on a desk with one person's face deliberately cut out",
    "la-grabadora-oculta": "a small digital voice recorder taped hidden under the edge of a polished boardroom table, its red light still recording",
    "el-proyecto-somnia": "a thick classified dossier of papers spread on a desk, the master plan of a project titled 'Somnia'",
    # --- Pistas de escena (primeros planos ambientales) ---
    "el-detalle-del-callejon": "a small serpent emblem carved and engraved into a dark brick alley wall, easy to miss, extreme close-up",
    "el-reflejo-en-el-charco": "a large rain puddle on a night street reflecting a blurred figure walking away into the distance",
    "la-taza-a-medias": "a half-full cup of cold coffee gone still on a side table, scattered papers beside it",
    "el-registro-tachado": "an open intake ledger book on a counter with several names crossed out in the same ink",
    "cera-fresca": "a row of wall votive candles still dripping warm fresh wax in a supposedly closed chapel",
    "el-cuadro-torcido": "a framed painting hanging crooked on a wall, revealing beside it a clean dust-free rectangle where another painting used to hang",
    "aranazos-en-la-reja": "extreme close-up of iron cell bars with desperate fingernail scratch marks at hand height on the inside",
    "el-lacre-en-el-suelo": "a single hardened drop of red sealing wax on a stone floor at the foot of a staircase",
    "el-informe-corregido": "an autopsy report page on a counter with one typed line crossed out and rewritten in different handwriting",
    "el-coche-sin-matricula": "a high-end luxury car parked on a wet night street with no license plates, its hood faintly steaming with warmth",
    "el-post-it-garabateado": "a scribbled yellow sticky post-it note stuck under a computer monitor, showing only a time and the word for a dock",
    "la-barca-de-mas": "a small rowing boat moored at a wooden dock, rigged with brand-new leather straps and tarpaulins, out of place for a fisherman",
    "el-mismo-cartel": "a weathered building facade sign bearing a corporate logo with a coiled serpent emblem",
    "la-tarjeta-olvidada": "an elegant law-firm business card left forgotten under a bar counter beside liquor bottles",
    "la-escalera-a-la-azotea": "a narrow private staircase leading up to a rooftop, its layer of dust disturbed by recent footprints",
}


def gen_one(slug, desc, force):
    """Genera y guarda UNA foto de objeto. Devuelve (slug, estado)."""
    out = os.path.join(OUT_DIR, slug + ".png")
    if os.path.exists(out) and not force:
        return (slug, "skip")
    prompt = build_prompt(desc)
    # Reintentos externos ademas del backoff interno de poll_fetch.
    for intento in range(1, 4):
        try:
            from PIL import Image
            raw = poll_fetch(prompt, SIZE, SIZE, seed_for(slug), enhance=False)
            img = Image.open(io.BytesIO(raw)).convert("RGB")
            if img.size != (SIZE, SIZE):
                img = img.resize((SIZE, SIZE), Image.LANCZOS)
            os.makedirs(OUT_DIR, exist_ok=True)
            img.save(out)
            return (slug, "ok")
        except Exception as e:
            if intento == 3:
                return (slug, "fail:" + str(e)[:80])
            time.sleep(8 * intento)
    return (slug, "fail")


def main():
    args = sys.argv[1:]
    force = "--force" in args
    workers = 8
    if "--workers" in args:
        workers = int(args[args.index("--workers") + 1])
    wanted = [a for a in args if a in OBJECTS]
    targets = wanted or list(OBJECTS.keys())

    # Titulos para log legible.
    titles = {}
    try:
        for c in json.load(open(CLUES_JSON, encoding="utf-8")):
            titles[c["slug"]] = c["title"]
    except Exception:
        pass

    os.makedirs(OUT_DIR, exist_ok=True)
    print(f"Objetos a generar: {len(targets)}  ·  hilos: {workers}  ·  "
          f"salida: assets/objects/  ({SIZE}x{SIZE}, sin ESRGAN)\n", flush=True)

    ok = skip = fail = 0
    with ThreadPoolExecutor(max_workers=workers) as ex:
        futs = {ex.submit(gen_one, s, OBJECTS[s], force): s for s in targets}
        for fut in as_completed(futs):
            slug, status = fut.result()
            t = titles.get(slug, "")
            if status == "ok":
                ok += 1
                print(f"  + {slug}  OK   {t}", flush=True)
            elif status == "skip":
                skip += 1
                print(f"  = {slug}  ya existe   {t}", flush=True)
            else:
                fail += 1
                print(f"  ! {slug}  {status}   {t}", flush=True)

    print(f"\nHecho. Generadas: {ok}  ·  Ya existian: {skip}  ·  Fallos: {fail}"
          f"  ·  Total objetos catalogados: {len(OBJECTS)}")


if __name__ == "__main__":
    main()
