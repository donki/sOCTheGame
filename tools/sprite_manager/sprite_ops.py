"""Motor de imagen de SpriteManager (Pillow).
Operaciones manuales y automaticas para recortar y limpiar sprites.
"""
from __future__ import annotations
from collections import deque
from PIL import Image
import os


# ---------------------------------------------------------------------------
#  Utilidades de pixel
# ---------------------------------------------------------------------------
def _is_ink(r, g, b, a, ink_mx=180, ink_sat=0.22):
    if a < 40:
        return False
    mx = max(r, g, b)
    mn = min(r, g, b)
    sat = (mx - mn) / mx if mx > 0 else 0
    return mx < ink_mx or sat > ink_sat


def remove_bg(img: Image.Image, v_thresh=0.66, sat_thresh=0.16) -> Image.Image:
    """Elimina el fondo claro por flood-fill desde los bordes (transparencia)."""
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
    visited = bytearray(w * h)
    dq = deque()
    for x in range(w):
        dq.append((x, 0)); dq.append((x, h - 1))
    for y in range(h):
        dq.append((0, y)); dq.append((w - 1, y))
    while dq:
        x, y = dq.popleft()
        if x < 0 or y < 0 or x >= w or y >= h:
            continue
        idx = y * w + x
        if visited[idx]:
            continue
        visited[idx] = 1
        r, g, b, a = px[x, y]
        fill = False
        if a < 20:
            fill = True
        else:
            mx = max(r, g, b); mn = min(r, g, b)
            v = mx / 255.0
            sat = (mx - mn) / mx if mx > 0 else 0
            if v > v_thresh and sat < sat_thresh:
                fill = True
                px[x, y] = (0, 0, 0, 0)
        if fill:
            dq.append((x + 1, y)); dq.append((x - 1, y))
            dq.append((x, y + 1)); dq.append((x, y - 1))
    return img


def color_key_bg(img: Image.Image, tol=34) -> Image.Image:
    """Elimina el fondo por color-key (muestrea la esquina) + flood-fill."""
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
    br, bg, bb, _ = px[1, 1]
    visited = bytearray(w * h)
    dq = deque()
    for x in range(w):
        dq.append((x, 0)); dq.append((x, h - 1))
    for y in range(h):
        dq.append((0, y)); dq.append((w - 1, y))
    while dq:
        x, y = dq.popleft()
        if x < 0 or y < 0 or x >= w or y >= h:
            continue
        idx = y * w + x
        if visited[idx]:
            continue
        visited[idx] = 1
        r, g, b, a = px[x, y]
        fill = False
        if a < 20:
            fill = True
        elif abs(r - br) + abs(g - bg) + abs(b - bb) < tol:
            fill = True
            px[x, y] = (0, 0, 0, 0)
        if fill:
            dq.append((x + 1, y)); dq.append((x - 1, y))
            dq.append((x, y + 1)); dq.append((x, y - 1))
    return img


def defringe(img: Image.Image, passes=2, v_thresh=0.62, sat_thresh=0.24) -> Image.Image:
    """Erosiona el halo claro del borde (pixeles claros y poco saturados)."""
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
    for _ in range(passes):
        clear = []
        for y in range(h):
            for x in range(w):
                r, g, b, a = px[x, y]
                if a < 20:
                    continue
                edge = False
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if nx < 0 or ny < 0 or nx >= w or ny >= h or px[nx, ny][3] < 20:
                        edge = True
                        break
                if not edge:
                    continue
                mx = max(r, g, b); mn = min(r, g, b)
                v = mx / 255.0
                sat = (mx - mn) / mx if mx > 0 else 0
                if v > v_thresh and sat < sat_thresh:
                    clear.append((x, y))
        for x, y in clear:
            px[x, y] = (0, 0, 0, 0)
    return img


def autotrim(img: Image.Image, pad=0) -> Image.Image:
    """Recorta los margenes transparentes."""
    img = img.convert("RGBA")
    bbox = img.getchannel("A").getbbox()
    if bbox:
        l, t, r, b = bbox
        l = max(0, l - pad); t = max(0, t - pad)
        r = min(img.width, r + pad); b = min(img.height, b + pad)
        img = img.crop((l, t, r, b))
    return img


def trim_sides(img: Image.Image, top=0, bottom=0, left=0, right=0) -> Image.Image:
    img = img.convert("RGBA")
    w, h = img.size
    return img.crop((left, top, max(left + 1, w - right), max(top + 1, h - bottom)))


def flip_h(img: Image.Image) -> Image.Image:
    return img.convert("RGBA").transpose(Image.FLIP_LEFT_RIGHT)


def recenter(img: Image.Image, cw: int, ch: int, feet_pad=2) -> Image.Image:
    """Centra horizontalmente y ancla los pies abajo en una celda cw x ch."""
    img = autotrim(img)
    cell = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    x = (cw - img.width) // 2
    y = ch - img.height - feet_pad
    cell.alpha_composite(img, (max(0, x), max(0, y)))
    return cell


# ---------------------------------------------------------------------------
#  Recorte automatico de HOJAS de personajes (auto-banda + columnas)
# ---------------------------------------------------------------------------
def _row_ink(px, y, x0, x1):
    c = 0
    for x in range(x0, x1):
        r, g, b, a = px[x, y]
        if _is_ink(r, g, b, a):
            c += 1
    return c


def _row_has_ink(px, fx0, fx1, y):
    for x in range(fx0, fx1):
        r, g, b, a = px[x, y]
        if _is_ink(r, g, b, a):
            return True
    return False


def detect_bands(img, x0, x1, dens_thresh, min_h=40, gap=6):
    w, h = img.size
    px = img.load()
    dense = [_row_ink(px, y, x0, x1) > dens_thresh for y in range(h)]
    bands = []
    bs = -1; g = 0
    for y in range(h):
        if dense[y]:
            if bs < 0:
                bs = y
            g = 0
        else:
            if bs >= 0:
                g += 1
                if g >= gap:
                    e = y - g
                    if e - bs >= min_h:
                        bands.append((bs, e))
                    bs = -1; g = 0
    if bs >= 0:
        e = h - 1 - g
        if e - bs >= min_h:
            bands.append((bs, e))
    return bands


def _detect_frames(px, gx0, gx1, y0, y1, min_w=16, gap=8):
    occ = []
    for x in range(gx0, gx1):
        c = 0
        for y in range(y0, y1 + 1):
            r, g, b, a = px[x, y]
            if _is_ink(r, g, b, a):
                c += 1
        occ.append(c > 3)
    frames = []
    start = -1; gg = 0
    for k in range(len(occ)):
        if occ[k]:
            if start < 0:
                start = k
            gg = 0
        else:
            if start >= 0:
                gg += 1
                if gg >= gap:
                    e = k - gg
                    if e - start >= min_w:
                        frames.append((gx0 + start, gx0 + e))
                    start = -1; gg = 0
    if start >= 0:
        e = len(occ) - gg
        if e - start >= min_w:
            frames.append((gx0 + start, gx0 + e))
    return frames


def _crop_clean(img, fx0, fx1, y0, y1, cw, ch, params):
    px = img.load()
    ty0, ty1 = y1, y0
    for y in range(y0, y1 + 1):
        if _row_has_ink(px, fx0, fx1, y):
            ty0 = min(ty0, y); ty1 = max(ty1, y)
    if ty1 <= ty0:
        return None
    sub = img.crop((fx0, ty0, fx1, ty1 + 1)).convert("RGBA")
    cell = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    dx = (cw - sub.width) // 2
    dy = ch - sub.height - 2
    cell.alpha_composite(sub, (max(0, dx), max(0, dy)))
    cell = remove_bg(cell, params.get("bg_v", 0.66), params.get("bg_sat", 0.16))
    cell = defringe(cell, params.get("defringe", 2))
    return cell


def slice_character_sheet(path, out_dir, ref_x, groups, row_names, params):
    """Corta una hoja de personajes por bandas (filas) y grupos (columnas)."""
    img = Image.open(path).convert("RGBA")
    os.makedirs(out_dir, exist_ok=True)
    bands = detect_bands(img, ref_x[0], ref_x[1], params.get("dens", 70))
    out = []
    cw, ch = params.get("cell_w", 88), params.get("cell_h", 120)
    px = img.load()
    for bi, band in enumerate(bands):
        if bi >= len(row_names):
            break
        rowname = row_names[bi]
        y0, y1 = band[0] - 2, band[1] + 2
        for grp in groups:
            frames = _detect_frames(px, grp["x0"], grp["x1"], y0, y1)
            for idx, (fx0, fx1) in enumerate(frames):
                cell = _crop_clean(img, fx0, fx1, y0, y1, cw, ch, params)
                if cell is None:
                    continue
                name = f"{rowname}_{grp['k']}_{idx}.png"
                cell.save(os.path.join(out_dir, name))
                out.append(name)
    return out


def slice_single_band(path, out_dir, ref_x, names, params, name_prefix=""):
    """Una sola fila (p.ej. walk cycle de la detective): primera banda densa."""
    img = Image.open(path).convert("RGBA")
    os.makedirs(out_dir, exist_ok=True)
    bands = detect_bands(img, ref_x[0], ref_x[1], params.get("dens", 90))
    if not bands:
        return []
    y0, y1 = bands[0][0] - 1, bands[0][1] + 1
    px = img.load()
    frames = _detect_frames(px, ref_x[0], ref_x[1], y0, y1)
    out = []
    cw, ch = params.get("cell_w", 88), params.get("cell_h", 104)
    for n, (fx0, fx1) in enumerate(frames):
        if n >= len(names):
            break
        cell = _crop_clean(img, fx0, fx1, y0, y1, cw, ch, params)
        if cell is None:
            continue
        fn = f"{name_prefix}{names[n]}.png"
        cell.save(os.path.join(out_dir, fn))
        out.append(fn)
    return out


# ---------------------------------------------------------------------------
#  Auto-deteccion de cajas para el recorte MANUAL (con raton)
# ---------------------------------------------------------------------------
def auto_boxes(path, min_w=22, min_h=26, band_gap=6, col_gap=7, dens=None):
    """Detecta cajas de sprites (bandas de filas + columnas) para editarlas
    despues a mano. Devuelve [{x,y,w,h}] en pixeles de la imagen. PIL puro."""
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    px = img.load()
    if dens is None:
        dens = max(16, w // 34)              # umbral de densidad relativo al ancho
    bands = detect_bands(img, 0, w, dens, min_h=min_h, gap=band_gap)
    boxes = []
    for (y0, y1) in bands:
        for (fx0, fx1) in _detect_frames(px, 0, w, y0, y1, min_w=min_w, gap=col_gap):
            ty0, ty1 = y1, y0                # ajustar vertical dentro de la columna
            for y in range(y0, y1 + 1):
                if _row_has_ink(px, fx0, fx1 + 1, y):
                    ty0 = min(ty0, y); ty1 = max(ty1, y)
            if ty1 <= ty0:
                continue
            boxes.append({"x": int(fx0), "y": int(ty0),
                          "w": int(fx1 - fx0 + 1), "h": int(ty1 - ty0 + 1)})
    return boxes


def export_box(img, box, cw=0, ch=0, removebg=True, do_trim=True,
               defr=0, bg_v=0.62, bg_sat=0.20, flip=False):
    """Recorta una caja de la hoja y la limpia (fondo/trim/celda/flip)."""
    x, y, bw, bh = box["x"], box["y"], box["w"], box["h"]
    sub = img.crop((x, y, x + bw, y + bh)).convert("RGBA")
    if flip:
        sub = flip_h(sub)
    if removebg:
        sub = remove_bg(sub, bg_v, bg_sat)
    if defr:
        sub = defringe(sub, defr)
    if do_trim:
        sub = autotrim(sub)
    if cw and ch:
        sub = recenter(sub, cw, ch)
    return sub


# ---------------------------------------------------------------------------
#  Recorte automatico por BLOBS (city pack: extrae cada elemento)
# ---------------------------------------------------------------------------
def slice_blobs(path, out_dir, min_w=40, min_h=40, tol=34, name_prefix="obj_"):
    """Etiqueta regiones conectadas de contenido (no-fondo) y las extrae."""
    img = Image.open(path).convert("RGBA")
    os.makedirs(out_dir, exist_ok=True)
    w, h = img.size
    # quitar el fondo claro de las tarjetas (no la esquina, que es el titulo)
    work = remove_bg(img.copy(), 0.72, 0.18)
    px = work.load()
    visited = bytearray(w * h)
    out = []
    idx = 0
    start_y = 106  # saltar la barra de titulo
    for sy in range(start_y, h, 2):
        for sx in range(0, w, 2):
            if px[sx, sy][3] < 20 or visited[sy * w + sx]:
                continue
            # BFS del blob
            dq = deque([(sx, sy)])
            minx, miny, maxx, maxy = sx, sy, sx, sy
            count = 0
            while dq:
                x, y = dq.popleft()
                if x < 0 or y < 0 or x >= w or y >= h:
                    continue
                p = y * w + x
                if visited[p] or px[x, y][3] < 20:
                    continue
                visited[p] = 1
                count += 1
                minx = min(minx, x); miny = min(miny, y)
                maxx = max(maxx, x); maxy = max(maxy, y)
                dq.append((x + 1, y)); dq.append((x - 1, y))
                dq.append((x, y + 1)); dq.append((x, y - 1))
                dq.append((x + 1, y + 1)); dq.append((x - 1, y - 1))
                dq.append((x + 1, y - 1)); dq.append((x - 1, y + 1))
            bw, bh = maxx - minx + 1, maxy - miny + 1
            if bw >= min_w and bh >= min_h and count > (bw * bh) * 0.08:
                sub = work.crop((minx, miny, maxx + 1, maxy + 1))
                fn = f"{name_prefix}{idx:03d}.png"
                sub.save(os.path.join(out_dir, fn))
                out.append(fn)
                idx += 1
    return out
