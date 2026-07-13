# Prompts de NPCs — Capítulo 1 ("Desaparición en la iglesia")

Prompts listos para **generar imágenes con Gemini** (uno por NPC, para hacerlos
de uno en uno). Cada archivo tiene una ficha del personaje + el **prompt en
inglés** (los modelos de imagen rinden mejor en inglés) para copiar/pegar.

## Personajes del Capítulo 1
La protagonista + los **4 vecinos** con los que hablar + el sargento del gancho:

| # | Archivo | Personaje | Rol |
|---|---------|-----------|-----|
| 0 | `00_detective.md`    | **Detective Nora Vega** | Protagonista (jugadora) |
| 1 | `01_don_emilio.md`   | Don Emilio    | Vecino anciano; oyó el grito junto al altar |
| 2 | `02_rosa.md`         | Rosa          | Vecina de verde; vigilaba la puerta principal |
| 3 | `03_tomas.md`        | Tomás         | Tendero; vio a Marta discutir con un encapuchado |
| 4 | `04_dona_carmen.md`  | Doña Carmen   | Anciana; sabe lo del campanario, remite a comisaría |
| 5 | `05_sargento_nunez.md` | Sgto. Núñez | Comisaría; gancho al capítulo 2 |

Extras opcionales (no imprescindibles para jugar el cap. 1):
- `06_marta_soler.md` — la desaparecida (para retrato/pista, no deambula).
- `07_encapuchado.md` — el hombre encapuchado (silueta de misterio).

## Estilo común (va incluido en cada prompt)
Cada prompt dice explícitamente que es **para un videojuego (Godot)** y pide una
**hoja de ciclo de andar con MOVIMIENTO**: pixel-art cenital de ARPG, noche
urbana oscura, rim-light cálido, mismo estilo que el pack de la detective
(`assets/mainchar.png`). **4 filas = 4 direcciones** (frente/`down`, espalda/`up`,
`left`, `right`) × **3 frames de andar** cada una, rejilla uniforme, fondo plano
gris claro, sin texto. Así se recorta directo a las animaciones del juego.

## Flujo recomendado
1. Genera el NPC en Gemini (una imagen por personaje).
2. Guárdala en `assets/` (p. ej. `assets/npc_emilio.png`).
3. Ábrela en **SpriteManager** → *Cortar hoja (ratón)* → auto-detecta, ajusta las
   4 vistas, renómbralas `down_0 / left_0 / up_0 / right_0`, salida
   `people` o `npcs_frames`, prefijo `emilio_`, **Exportar**.
4. En Godot re-importar y asignar al NPC.

## Cómo conseguir la API key GRATIS de Gemini
Ver `API_KEY_GEMINI.md` en esta carpeta.
