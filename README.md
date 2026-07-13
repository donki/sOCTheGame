# sOC the Game

**Novela visual noir de detectives.** Escenas de diálogo entre personajes y un
**mapa de la ciudad** por el que decides a dónde ir a investigar, caso a caso.
Hecho en **Godot 4.7** para **Windows** y **Android**.

*A noir detective visual novel made with Godot 4 — Windows & Android.*

---

## Historia

Encarnas a la **detective Nora Vega** en una megaciudad bajo lluvia perpetua.
**20 casos** encadenados por un solo hilo —la trama de la farmacéutica **Nyxos** y
su fármaco **Somnia**—, desde una desaparición en una iglesia hasta el desmontaje
de una corporación entera. Un **Capítulo 0 (tutorial)** enseña a jugar.

- **20 casos + tutorial**, cada uno con su cadena de localizaciones, pistas,
  pistas falsas (red herrings) y un lugar clave donde se resuelve.
- **Diálogos largos** tipo novela visual, con voz propia por personaje y ramas de
  elección.
- **Guardado automático** a cada pista y a cada paso.

## Cómo se juega

1. En el **mapa**, toca/clica un **pin** de localización para viajar allí → se abre
   una **escena de diálogo**.
2. En el **diálogo**: **click / espacio / toque** avanza el texto; cuando aparecen
   **opciones**, elígelas. Cada personaje tiene su propia "voz" (voice-blips).
3. Reúne **pistas** hablando con la gente; se guardan en la **Libreta** (**N**) y
   vuelan hasta su icono. Las **falsas** se descartan solas.
4. Con todas las pistas del caso se desbloquea el **lugar clave**; ciérralo e
   **informa en comisaría** para abrir el siguiente caso.
5. **ESC** vuelve al menú.

Controles idénticos en Windows y Android: **ratón / toque**; teclado opcional.

## Requisitos

- **Godot Engine 4.7** (rama 4.x). Editor portable en
  <https://godotengine.org/download> (no requiere instalación).
- Para Android: **Android SDK + JDK 17** y las *export templates* de Godot.

## Abrir y ejecutar

1. Abre Godot 4.7 → `Import` → selecciona `project.godot` → `Import & Edit`.
2. Pulsa **F5**. Arranca en la intro cinemática (splash → menú → *Nueva partida* →
   Tutorial → Caso 1).

## Arte (generado por IA — no incluido en el repo)

El arte definitivo (retratos y fondos, **anime cyberpunk-noir 4K**) se **genera con
IA** (Pollinations / Flux + upscale Real-ESRGAN) a partir de los prompts de
`prompts/`, con `tools/gen_assets.py`. **No se versiona en este repositorio** (por
peso y por los términos de uso del servicio de generación). Para obtenerlo:

```bash
python tools/gen_assets.py            # genera lo que falte
python tools/gen_assets.py --force    # regenera todo
```

El juego incluye **respaldos procedurales** (retratos-silueta y mapa dibujado por
código), así que arranca aunque falten los PNG.

## Compilar

```powershell
# Windows (4K)
pwsh tools/build.ps1                    #  -> build/sOC.exe

# Android (APK 1080p, ligero para móvil; reescala y revierte a 4K solo)
pwsh tools/build_android.ps1            #  -> build/sOC.apk
```

Las texturas se importan como **Lossy (WebP)** manteniendo el 4K en escritorio; el
build de Android reescala a 1080p para reducir tamaño y RAM (ver `constitucion.md`,
ADR-046).

## Estructura

```
project.godot            Config del proyecto (escena inicial, display, autoloads)
scripts/Global.gd        Autoload: transiciones, input, ajustes, guardado, audio, voice-blips
scripts/Story.gd         CONTENIDO del juego: reparto, fondos, localizaciones y TODOS los diálogos
scripts/Music.gd         Motor de música generativa (síntesis en tiempo real, moods)
scenes/SplashIntro       Intro cinemática procedural (audio sintetizado)
scenes/MainMenu          Menú principal
scenes/CityMap           Mapa de la ciudad: viaje, pistas, libreta, coach-mark del tutorial
scenes/DialogueScene     Reproductor de novela visual (retratos + texto + opciones)
capitulos/               Documentos de diseño de los 20 casos
prompts/                 Prompts de IA para el arte
tools/                   gen_assets.py, build.ps1, build_android.ps1, i18n, utilidades
assets/                  fonts, audio (Kenney CC0), ui, i18n  (el arte IA se genera aparte)
constitucion.md          Documento vivo del proyecto + bitácora / ADRs
CREDITS.md               Créditos y licencias de assets de terceros
```

## Idiomas

Español (nativo), con infraestructura i18n para **inglés** y **chino** (parcial,
`assets/i18n/`, `tools/translate_i18n.py`).

## Licencia

Código bajo licencia **MIT** (ver `LICENSE`). Los assets de terceros mantienen su
licencia (ver `CREDITS.md`): fuentes y audio de **Kenney** son **CC0 1.0**. El arte
generado por IA no se distribuye aquí; se regenera con `tools/gen_assets.py`.
