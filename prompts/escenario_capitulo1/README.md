# Prompts de ESCENARIO — Capítulo 1 + Splash

Prompts para generar con **Gemini** las imágenes del entorno del Capítulo 1 y la
pantalla de inicio (splash), en el mismo estilo pixel-art que los personajes
(Detective Collection). Cada archivo tiene varios prompts **listos para copiar**,
uno por asset.

## Qué va aquí (IA) y qué no
- **IA (Gemini)** — objetos/escenas sueltos sobre fondo plano: edificios, coches,
  props de calle, la iglesia del splash, interiores, iconos de objeto. ✅
- **NO IA** — el **suelo tileable** (calzada, acera, césped): usa los packs CC0 de
  `assets/packs/` (Kenney), que sí tilean sin costuras. La IA no hace tilesets.

## Archivos
| Archivo | Contenido |
|---|---|
| `01_splash_iglesia.md`   | Escena de la iglesia de noche (tormenta) — el splash |
| `02_iglesia_interior.md` | Interior de la iglesia (altar + campanario) — pista 5 |
| `03_edificios.md`        | Edificios del barrio (casas, café, tienda, comisaría, bomberos, ayuntamiento…) |
| `04_coches.md`           | Coches vista cenital (para la calzada) |
| `05_props_calle.md`      | Farola, banco, papelera, árbol, seto, boca de incendios, contenedor |
| `06_objetos.md`          | Iconos de objeto/pista (pañuelo M.S., libreta…) |

## Estilo común (incluido en cada prompt)
Pixel-art de ARPG detectivesco, **noche urbana oscura**, rim-light cálido, mismo
estilo que el pack de personajes. **Un solo asset, aislado, fondo plano gris claro
`#d7d7d1`, sin texto, sin sombra en el suelo, bordes limpios** para recortar.
- **Edificios/props**: vista **¾ cenital frontal** (se ve fachada + algo de tejado),
  como los `assets/buildings/*` actuales.
- **Coches**: vista **cenital pura** (desde arriba), como los de la calzada.
- **Splash/interior**: **ilustración** de escena (encuadre frontal amplio).

## Flujo
1. Genera en Gemini → guarda en `assets/` (p. ej. `assets/bld_cafe.png`).
2. Recorta/limpia en **SpriteManager** (fondo fuera, «Cortar hoja» o «Guardar como»).
3. Colócalo: edificios en `assets/buildings/`, splash como `assets/church2.png`,
   etc. En `scenes/Game.gd` los edificios se cargan por nombre.
