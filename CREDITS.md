# Créditos y licencias de assets

## Arte de la novela visual (generado por IA)
- **Retratos de personajes** (`assets/portraits/*.png`) y **fondos de escena**
  (`assets/backgrounds/plaza|casa_emilio|iglesia_ext|iglesia_int|tienda|casa_carmen|comisaria.png`)
  y **mapa** (`assets/backgrounds/mapa.png`) — generados con **Pollinations**
  (modelo tipo **Flux**, servicio gratuito sin API key) a partir de los prompts de
  `prompts/`. Retratos recortados a fondo transparente con **rembg** (U²-Net).
  Reproducibles con `tools/gen_assets.py` (semilla por personaje).
  *(Verificar términos de uso del modelo/servicio antes de distribución comercial;
  alternativa: regenerar con Gem/Imagen en paid tier — backend `--backend gemini`.)*

## Gráficos (splash cinemático)
- **Ilustración de la iglesia** (`assets/church2.png`) — aportada por el usuario.
  Fondo del splash cinemático. *(Confirmar licencia/origen antes de publicar.)*
- **Character pack — personas** (`assets/people/*_back_*.png`) — aportado por el
  usuario. La gente que corre a refugiarse en la iglesia durante el splash.
  *(Confirmar licencia/origen antes de publicar.)*

> Nota: al reorientar el juego a novela visual (2026-07-08) se eliminaron los
> assets del prototipo cenital que ya no se usan (tiles urbanos, hojas de
> personajes/NPCs, City Pack, edificios recortados, frames de la detective). El
> arte del juego es ahora el de la sección superior (retratos/fondos por IA).

## Tipografía
- **Kenney Fonts** (Kenney) — Licencia **CC0 1.0**. `assets/fonts/`.
  Cuerpo: *Kenney Future*; títulos: *Kenney Future Narrow*; frases atmosféricas:
  *Kenney High*.

## Audio
- **Interface Sounds** — Kenney. Licencia **CC0 1.0**.
  `assets/audio/kenney_interface-sounds/` (clics de menú, confirmaciones…).
- **RPG Audio** — Kenney. Licencia **CC0 1.0**.
  `assets/audio/kenney_rpg-audio/` (pasos, puertas, libros…).

## Procedural (hecho en el proyecto)
- Splash cinemático y su **audio sintetizado** (campanas, viento, truenos, lluvia):
  generados por código en `scenes/SplashIntro.gd` y `scenes/MainMenu.gd`.
- **Mapa procedural de respaldo** de la ciudad (`CityMap.MapCanvas`) y
  **retratos-silueta** de respaldo (`DialogueScene`) si faltara algún PNG.

---
CC0 no exige atribución, pero la mantenemos por transparencia. Al añadir nuevos
assets, anota aquí su origen y licencia (evitar cualquier asset sin licencia
clara para poder publicar en Play Store / distribuir el ejecutable).
