# Suelo isométrico — carretera y acera (tileset)

Para un **TileMap isométrico** (baldosas en rombo 2:1). El objetivo son piezas que
**encajen entre sí** por los bordes del rombo. Pídelas en una lámina ordenada; yo
las recorto, alineo a la rejilla iso y monto el TileSet.

**Guardar como:** `suelo_iso.png` en `assets/`.

> ⚠️ La IA no garantiza costuras perfectas. Si no encajan, uso plan B (pack CC0).

---
### Prompt para Gemini (copiar/pegar)
```
Isometric 2:1 pixel-art GROUND TILESET for a 2D isometric city game, dark noir rainy
night mood, same art style, palette and line weight as a set of isometric town
buildings. On a plain flat light-gray background (#d7d7d1), arranged in a neat
grid with even spacing, a set of SEAMLESS isometric ground tiles, every tile the
SAME 2:1 isometric diamond size, top surfaces only (no walls, no height), designed
to connect edge-to-edge:
1) plain dark ASPHALT road tile,
2) asphalt road with a painted YELLOW center line,
3) white pedestrian CROSSWALK / zebra stripes tile,
4) grey concrete SIDEWALK / pavement tile,
5) a CURB tile (transition where sidewalk meets road, low kerb),
6) plain GRASS tile.
Clean crisp pixel edges, tileable, top-down isometric (2:1) projection, NO text, NO
labels, NO characters, NO shadows outside the tile.
```

### (Opcional) Piezas de cruce/esquina para la carretera
```
Isometric 2:1 pixel-art road pieces, same style/scale as the ground tileset above,
on a plain flat light-gray background, each the same diamond size: a 4-way road
INTERSECTION, a T-junction, a 90-degree CORNER, and a straight road in both
isometric orientations (NE-SW and NW-SE). Seamless edges to connect with plain road
tiles. NO text, NO labels.
```

## Plan de integración (yo)
1. Recorto y alineo las piezas a la rejilla iso (p. ej. 64×32 o 128×64).
2. Creo el **TileSet isométrico** (`tile_shape = ISOMETRIC`) en Godot.
3. Cambio el `TileMapLayer` del barrio a isométrico y repinto calles/aceras.
4. Recoloco edificios/objetos a la rejilla iso.

> Nota: pasar a suelo isométrico es un **rework** del mapa (posiciones, cámara).
> Merece la pena si quieres el look iso completo. El estilo actual (suelo plano +
> edificios ¾) también es válido y es menos trabajo.
