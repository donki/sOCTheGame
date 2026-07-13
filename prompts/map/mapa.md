# Mapa de la ciudad  →  `assets/backgrounds/mapa.png`

Plano ilustrado del **Barrio Viejo** sobre el que el juego dibuja los pines de las
localizaciones. Debe ser legible y con zonas despejadas donde caen los pines (el
juego los coloca por código; ver posiciones en `scripts/Story.gd`, campo `pos`).

**Posiciones de los pines** (fracción del ancho×alto, para no taparlas con detalles
importantes): Plaza (0.50, 0.58) · Casa de Emilio (0.24, 0.40) · Atrio iglesia
(0.62, 0.30) · Tienda de Tomás (0.30, 0.72) · Casa de Carmen (0.78, 0.66) ·
Iglesia de San José (0.50, 0.20) · Comisaría (0.84, 0.44).

### Prompt (copiar/pegar en Gemini)
```
Top-down stylized illustrated map of a small old European town district ("Barrio
Viejo") at night, in a dark noir detective aesthetic — like a hand-drawn
investigation map spread on a table. 16:9 landscape. Winding cobbled streets and a
central square, tightly packed old rooftops seen from above, a large church with a
bell tower at the top-center, a small park beside it, a river or canal along one
edge, a few distinct buildings (a corner shop, a police station). Muted palette:
deep blues and greys, warm ochre street-lamp dots, a faint red accent. Subtle grid
lines, a small compass rose in a corner, aged-paper texture and film grain.

Leave open, uncluttered spots (no important detail) at these relative positions so
location pins can be placed on top: center, upper-center, left-center, right-center,
lower-left, lower-right. No readable text, no place names, no labels, no legend, no
characters. Consistent art style for the game "sOC the Game".
```
