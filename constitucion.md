# Constitución de **sOC the Game**

> Documento vivo. Es la fuente de verdad del proyecto: visión, principios,
> decisiones y estado. **Se actualiza en cada paso de desarrollo.** Al final
> está la **Bitácora / Historial**, que se amplía (nunca se reescribe) para
> conservar el contexto completo de cómo se ha ido construyendo el juego.
>
> **Doble propósito.** Este documento también sirve de **plantilla/marco reutilizable**: el motor y sus
> sistemas están pensados para que, **dándole otro guión**, se pueda producir OTRO juego del mismo género.
> Ver **§8. Marco reutilizable** — contrato de datos, qué reescribir y en qué orden.
>
> Última actualización: **2026-07-14** · Versión del juego: **0.3.0** · Fase: **4**

> **CAMBIO DE ORIENTACIÓN (2026-07-08).** El juego deja de ser un ARPG de
> movimiento y pasa a ser una **novela visual de misterio**: la historia avanza
> con **escenas de diálogo** entre personajes (retratos + texto + opciones) y la
> ciudad es un **mapa** donde el jugador **marca la localización** a la que quiere
> ir. Se conserva la ambientación, el caso 1, la libreta de pistas, la paleta noir
> y los assets CC0. El prototipo de movimiento queda archivado en `backup/`.

---

## 1. Visión

**sOC the Game** es una **novela visual de misterio urbano** con estética noir
oscura, ambientada en un **mundo urbano contemporáneo con un trasfondo de
misterio**. La ciudad esconde algo; la jugadora (una **detective**) lo destapa
**hablando con los personajes** y **decidiendo a dónde ir** en el mapa.

Referencia visual/tonal: lluvia, penumbra, farolas cálidas y un resplandor rojo
latente (peligro / lo oculto). Ritmo de investigación, no de acción.

### Pilares de diseño
1. **Diálogo como mecánica central** — escenas de novela visual (retratos,
   máquina de escribir, elecciones) que revelan la trama y las pistas.
2. **Mapa como navegación** — la ciudad es un plano; el jugador **marca destino**
   y viaja; las localizaciones se abren según el progreso del caso.
3. **Misterio urbano** — la ciudad como personaje; secretos que se desvelan por
   capas.
4. **Narrativa en capas** — caso principal + secundarias + microhistorias.
5. **Investigación y pistas** — libreta de pistas; algunas puertas requieren
   reunir pruebas antes de abrirse.
6. **Multiplataforma real** — misma experiencia en **Windows** y **Android**; los
   controles son **ratón/toque** (teclado opcional) sin rediseñar el juego.

### Contenido previsto (alcance global, no de la Fase 1)
- Historia principal por capítulos.
- Misiones secundarias y encargos.
- Puzles ambientales y de inventario.
- Minijuegos (p. ej. hackeos, cerraduras, ritmo).
- Progresión de personaje (habilidades, equipo).

---

## 2. Stack tecnológico (Decisión ADR-001)

**Motor: Godot 4 (GDScript).**

| Criterio | Por qué Godot 4 |
|---|---|
| Multiplataforma | Exporta nativo a **Windows** y **Android** desde un único proyecto. |
| 2D | Motor 2D de primera clase (ideal para pixel-art cenital). |
| Coste/licencia | Gratis, open-source, MIT, **sin royalties**. |
| Peso | Editor portable (~110 MB), sin instalación pesada ni cuenta. |
| Iteración | Recarga rápida, escenas y nodos componibles. |

**Alternativas descartadas:** Unity (pesado, overkill para 2D, licencia),
Flutter+Flame (menos orientado a juego, ecosistema 2D menor), Web+Capacitor
(peor rendimiento y control para un ARPG).

**Render:** `gl_compatibility` (OpenGL ES 3) por **máxima compatibilidad de
dispositivos Android**. Se revisará a `mobile` (Vulkan) si el objetivo de gama
lo permite.

**Versión de Godot objetivo:** 4.3 stable o superior de la rama 4.x.

---

## 3. Principios de ingeniería

1. **Autoload `Global` como columna vertebral** de estado transversal:
   transiciones de escena, mapa de entrada, ajustes y guardado.
2. **Entrada registrada en runtime** (`InputMap` en `Global`) para asegurar los
   mismos controles en todas las plataformas sin depender de la serialización
   del editor.
3. **UI construida por código** cuando la escena es dinámica/compleja, para
   evitar errores de formato `.tscn` y facilitar revisiones en texto plano.
   Las `.tscn` se mantienen mínimas (nodo raíz + script).
4. **Assets procedurales primero.** Mientras no haya arte definitivo, se generan
   siluetas, gradientes y **audio sintetizado** por código. Esto desbloquea el
   diseño sin depender de material externo y mantiene el repo ligero.
5. **Adaptación de plataforma, no bifurcación.** Se detecta `OS.get_name()` para
   ajustar detalles (p. ej. ocultar “Salir” y pantalla completa en Android),
   nunca para crear dos juegos distintos.
6. **Paleta y tono centralizados** en constantes de `Global` (COL_*).
7. **Cada cambio relevante** se refleja en esta constitución (sección 5 y
   Bitácora) para preservar contexto.

---

## 4. Arquitectura y estructura

```
sOCTheGame/
├─ project.godot          # Config: nombre, escena inicial, display, render, autoload
├─ icon.svg               # Icono del juego
├─ constitucion.md        # ESTE documento (vivo)
├─ README.md              # Cómo abrir, ejecutar y exportar
├─ .gitignore             # Ignora .godot/ y exports/
├─ scripts/
│  └─ Global.gd           # Autoload: transiciones, input, ajustes, guardado, paleta
└─ scenes/
   ├─ SplashIntro.tscn/.gd  # Intro cinemática (iglesia, campanas, viento, gente)
   ├─ MainMenu.tscn/.gd     # Pantalla principal (menú)
   └─ Game.tscn/.gd         # Stub de gameplay (valida el bucle ARPG multiplataforma)
```

**Flujo de arranque:** `SplashIntro` → `MainMenu` → (Nueva partida) → `Game`.

**Escenas actuales**
- **SplashIntro** — Cinemática procedural: noche de tormenta, iglesia con
  campanario, campanas tocando a rebato (audio sintetizado), viento creciente
  con escombros y lluvia, relámpagos con truenos, y gente corriendo a
  refugiarse dentro. Saltable con cualquier tecla/toque; encadena al menú.
- **MainMenu** — Título “sOC / THE GAME”, fondo con shader (gradiente nocturno +
  resplandor rojo pulsante + viñeta + grano), lluvia, botones (Nueva partida,
  Continuar, Opciones, Salir*) y overlay de Opciones (volúmenes + pantalla
  completa*). Navegable con teclado, ratón y toque. (*solo escritorio)
- **Game** — Placeholder jugable: personaje con farolillo, movimiento
  WASD/flechas y *tap-to-move*, cámara con suavizado, efecto linterna
  (oscuridad con halo transparente) y vuelta al menú (ESC o botón).

**Convenciones**
- Idioma del código y comentarios: **español** (sin tildes en identificadores).
- Indentación: **tabuladores** (estándar GDScript).
- Nombres: `PascalCase` para nodos/escenas/clases; `snake_case` para funciones y
  variables; `_prefijo` para miembros privados.
- Acciones de entrada: `move_up/down/left/right`, `interact`, `attack`, `pause`.

---

## 5. Registro de decisiones (ADR)

| ID | Decisión | Estado |
|----|----------|--------|
| ADR-001 | Motor **Godot 4 / GDScript** para Windows + Android. | Aceptada |
| ADR-002 | Render **gl_compatibility** por compatibilidad Android. | Aceptada (revisable) |
| ADR-003 | **Orientación horizontal** (landscape), como la referencia. | Aceptada |
| ADR-004 | Estado global en autoload **`Global`**; input en runtime. | Aceptada |
| ADR-005 | UI dinámica **por código**; `.tscn` mínimas. | Aceptada |
| ADR-006 | **Assets procedurales** (siluetas + audio sintetizado) hasta tener arte. | Aceptada (temporal) |
| ADR-007 | Arranque con **splash cinemático** antes del menú. | Aceptada |
| ADR-008 | **Protagonista: una DETECTIVE** que investiga un caso. | Aceptada |
| ADR-009 | **Iluminación 2D real** (`CanvasModulate` noche + `PointLight2D`). | Aceptada |
| ADR-010 | **Joystick virtual** táctil; teclado sigue activo en paralelo. | Aceptada |
| ADR-011 | Suelo con **TileMapLayer** + atlas de tiles generado por código. | Aceptada |
| ADR-012 | Distribuir Windows como **`.exe` único** (PCK embebido). | Aceptada |
| ADR-013 | **Assets CC0 (Kenney)** para tiles y audio; créditos en `CREDITS.md`. | Aceptada |
| ADR-014 | Pixel-art **16px** escalado ×2; filtro **nearest** global. | Aceptada |
| ADR-015 | **Reorientación a NOVELA VISUAL**: diálogos + mapa, en vez de ARPG de movimiento. | Aceptada |
| ADR-016 | **Contenido dirigido por datos** en `scripts/Story.gd` (reparto, fondos, localizaciones, diálogos). | Aceptada |
| ADR-017 | **Diálogo por código** (`DialogueView`, `class_name`) instanciado como capa sobre el mapa; señal `finished`. | Aceptada |
| ADR-018 | **Degradación elegante de assets**: retratos-silueta y mapa procedural si faltan los PNG; el juego corre sin arte. | Aceptada |
| ADR-019 | Arte definitivo por **IA (Gemini / Google AI Plus)**: retratos (busto) + fondos (16:9) + mapa; prompts en `prompts/`. | Aceptada |
| ADR-020 | **Dirección artística cyberpunk-noir** para TODO el arte IA (megaciudad de neón bajo la lluvia, catedral gótica entre rascacielos), aplicada como capa de estilo global en `tools/gen_assets.py`; el guion no cambia. | Aceptada |
| ADR-021 | **Estándar Godot 4.7** (unificado; se descarta 4.3). `config/features=("4.7",...)`. | Aceptada |
| ADR-022 | **Retratos ENMARCADOS** (foto de expediente / holo-ID con borde neón), no recortados a transparente: `rembg` no corre en Python 3.14 y el recorte por color falla sobre fondo oscuro; el arte cyberpunk lleva su propio fondo. | Aceptada |
| ADR-023 | **Resolución de arte 2K** (fondos 2560×1440, retratos 1536×2048); Pollinations gratis reduce, se reescala con LANCZOS (`ensure_2k`). | Aceptada |
| ADR-024 | **HUD con iconos** (neón, procedurales en `assets/ui/`) en vez de texto. | Aceptada |
| ADR-025 | **Versión = `yyyy.MM.dd.N`**: cada compilación (`tools/build.ps1`) incrementa el nº de compilación `N`; `N` se reinicia a 1 al cambiar el día (la fecha ya identifica el día). Migra automáticamente desde el esquema antiguo `x.y.z`. | Aceptada (rev. 2026-07-14) |
| ADR-026 | **Localizaciones progresivas**: los pines del mapa se revelan según avanzan las conversaciones (`req` por bandera en `Story.gd`). | Aceptada |
| ADR-027 | **Framework de capítulos** (`CHAPTERS` en `Story.gd` + `Global.chapter`); temporada de 3 casos que se encadenan al cerrar cada uno (`end_flag`). | Aceptada |
| ADR-028 | **Retratos como viñeta de cómic** (shader: posterizado cel + tinta + halftone) sobre el retrato enmarcado. | Aceptada |
| ADR-029 | **Arte a 4K con detalle real vía Real-ESRGAN** (ncnn-vulkan, GPU, sin torch/token): Pollinations 1024 → ESRGAN x4 → 4K UHD. Binario en `%LOCALAPPDATA%\realesrgan`. Tope nativo de Pollinations = 1024. | Aceptada |
| ADR-030 | **Pistas falsas (red herrings)** en cada capítulo para romper la linealidad: localización marcada `red_herring`, con `clue.false=true`; se anota aparte ("Pistas descartadas") y no cuenta para la puerta. | Aceptada |
| ADR-031 | **Temporada 2 (Caps. 4-6)**: el heredero, la subasta y la cúspide (Vaultier). Retratos a 4K (2400×3200). | Aceptada |
| ADR-032 | **Temporada 3 (Caps. 7-20)** dirigida por DATOS: diccionario `S3` en `Story.gd` + `_ch_data_dialogue` (evita 84 funciones). Un solo caso que escala hasta **Nyxos Pharma**. | Aceptada |
| ADR-033 | **Reparto personal de Nora** recurrente (Diego, Sonia, Clara, Rubén, Marco): dan fondo al personaje, revelan pistas y ayudan en interrogatorios. | Aceptada |
| ADR-034 | **Escenarios variados**: además del Barrio, centro de negocios, barrio alto, otra ciudad, pueblo de costa y de montaña, hospital, laboratorio, etc. | Aceptada |
| ADR-035 | **5 pistas falsas por capítulo** (diálogo admite lista `clues`); libreta con "Pistas descartadas". | Aceptada |
| ADR-036 | **Mapas por región** (`Story.chapter_map()` + `map` por capítulo); CityMap recarga el mapa al cambiar de caso. | Aceptada |
| ADR-037 | **Marco de viñeta de cómic** en los retratos (borde de tinta + línea crema), en vez del shader de cómic sobre la imagen. | Aceptada |
| ADR-038 | **Idiomas es/en/zh**: texto original en español; traducción por tabla (`assets/i18n/`) buscada por el propio texto es (fallback a es). Idioma inicial = el del dispositivo (es/zh si coincide cualquier variante, si no en); selector en Opciones; **fuente CJK del sistema** como fallback. Diálogos traducidos con pipeline (`tools/extract_i18n.gd` + `translate_i18n.py`, API de texto de Pollinations). | Aceptada |
| — | *Supersede:* ADR-006, ADR-011, ADR-014 (procedural/pixel-art/tiles) quedan obsoletos al pasar a novela visual con arte IA. | — |

---

## 6. Hoja de ruta

- **Fase 1 — Cimientos y primera pantalla.** ✅ Proyecto Godot, autoload, splash
  cinemático, menú principal, stub de gameplay, documentación.
- **Fase 2 — Personaje y mundo (ACTUAL).** ✅ Detective jugable (`CharacterBody2D`,
  sprite procedural animado, linterna en cono), barrio con `TileMapLayer` (atlas
  generado), edificios con colisiones y ventanas iluminadas, farolas, noche con
  iluminación 2D real, cámara con límites, joystick virtual táctil y primera
  interacción (tablón → semilla de la trama). ✅ **Build Windows (`.exe`)**.
- **Fase 3 — Bucle de juego.** Combate ARPG básico, enemigos, vida (el orbe rojo
  de la referencia), interacción con objetos y puertas.
- **Fase 4 — Novela visual (ACTUAL).** ✅ Reorientación: sistema de diálogo
  (retratos + máquina de escribir + elecciones), mapa de la ciudad con marcado de
  destino y viaje, caso 1 completo en `Story.gd` (5 pistas, 7 localizaciones,
  cierre + gancho al cap. 2), libreta de pistas, degradación elegante de assets.
  ⏳ Arte definitivo por IA (retratos/fondos/mapa), audio ambiental por escena.
- **Fase 5 — Sistemas.** Guardado real de progreso (pistas + flags), más casos,
  banda sonora por localización, ajustes completos, localización de textos.
- **Fase 6 — Pulido y publicación.** Arte final, audio, exportes firmados
  (APK/AAB y ejecutable Windows), rendimiento.

---

## 7. Estado actual (Fase 2)

- ✅ Fundación completa (autoload, splash, menú) — ver Fase 1.
- ✅ `scripts/Player.gd`: detective jugable con movimiento 8-dir, sprite
  procedural animado (gabardina + sombrero) y linterna en cono (`PointLight2D`).
- ✅ `scripts/VirtualJoystick.gd`: joystick táctil (mitad izquierda), con ratón
  en escritorio para pruebas.
- ✅ `scenes/Game.gd`: Barrio Viejo nocturno — `TileMapLayer` con atlas generado
  (asfalto/acera/línea/hierba), 6 edificios con colisión y ventanas iluminadas,
  farolas, `CanvasModulate` nocturno, cámara con límites, HUD, joystick y una
  interacción (tablón de desapariciones → semilla de la trama).
- ✅ Validado en Godot 4.3 (headless): scripts compilan, `Game` corre sin fallos.
- ✅ **Exportado a Windows**: `build/sOC.exe` (~80 MB, PCK embebido). Arranque
  verificado y ejecutado en el escritorio.
- ✅ **Exportado a Android (debug)**: `build/sOC.apk` (~58 MB, firmada/verificada,
  arm64-v8a + armeabi-v7a, minSdk 21).
- ⏳ Pendiente: APK **release** + AAB firmados con keystore propio; sprites/arte
  definitivos; combate.

---

## 7-bis. Guía de estilo y contenido — CANON para próximos capítulos

Decisiones del usuario a respetar en todos los capítulos (no volver a preguntar):

**Identidad / narrativa**
- Protagonista: **Nora** (así se muestra en la placa de nombre; es la Detective Nora Vega).
- La iglesia del barrio es **San José** (no San Roque).
- Frase de Nora al arrancar un caso: *"El barrio es mío esta noche"* (no "el mapa es mío").
- El caso al cerrarse se rotula **"Caso uno completado"** (ordinal en palabra, "completado").

**Estructura de localizaciones**
- Las localizaciones del mapa se **revelan encadenadas**: cada una aparece porque en la
  ANTERIOR se habla de ella o remiten a un personaje al que preguntar. Nada de mostrar
  todos los pines de golpe. (`req` por bandera en `Story.gd`; aviso "Nueva localización".)
- Cadena del Cap. 1: **Plaza → Casa de Marta → Don Emilio → Rosa → Tomás → Doña Carmen →
  (4 pistas de calle) → Iglesia de San José → (caso cerrado) → Comisaría**.
- **Revisita**: si vuelves a una ubicación ya resuelta, el personaje dice que **ya lo contó
  todo**, **recuerda su pista** y **apunta a la siguiente** ubicación.

**Diálogos**
- **Largos**: ~5 minutos de lectura por ubicación. Prosa noir, sensorial, con voz propia de
  cada personaje y **2-3 ramas de elección** con varios beats cada una.
- Formato dirigido por datos en `scripts/Story.gd` (ver cabecera del archivo).

**Guardado**
- **Autoguardado a cada pista y a cada bandera** (`Global.save_game()` en `add_clue`/`set_flag`).
- Menú: **Continuar** carga la partida; **Nueva partida** borra el guardado y empieza de cero.

**Audio**
- **Motor de música generativa** (`scripts/Music.gd`, autoload `Music`): sintetiza en
  tiempo real (AudioStreamGenerator, sin ficheros) pads noir en grave + sub-bajo +
  motivo/melodía con envolvente de campana + capa de aire. **Dirigido por datos** en
  `MOODS`: 5 ambientes — `noir`, `investigacion`, `misterio`, `tension`, `revelacion`.
  Cada escena elige uno con `Music.play_mood("...")`; el motor **cruza suave** (duck sin
  clics) y **persiste entre escenas** (no corta la música). El volumen sigue el ajuste
  `music_volume` (antes el slider no hacía nada). La progresión de acordes se calcula
  desde el tiempo absoluto → crossfade por amplitud sin chasquidos.
- **Ambientes por contexto**: el mapa elige mood según el capítulo (1-6 `noir`, 7-13
  `investigacion`, 14-20 `misterio`); al entrar en un diálogo cambia a uno más
  íntimo/tenso (1-6 `misterio`, 7-13 `tension`, 14-20 `revelacion`) y vuelve al del mapa
  al cerrar. El menú suena con `noir` bajo la tormenta. **Tono que se oscurece** con el caso.
- Splash: intro cinemática con campanas/tormenta (audio propio sintetizado, sin el motor
  `Music`); **mantiene el título ~5 s** y cierra con **relámpago + trueno** antes del fundido.

**Arte (cyberpunk-noir, 2K)**
- Todo el arte IA en **estilo cyberpunk-noir** a **2K** (fondos 2560×1440, retratos
  1536×2048) vía Pollinations (`tools/gen_assets.py`, capa de estilo global).
- **Retratos ENMARCADOS** (foto de expediente): marco redondeado con **borde rojo neón**
  grueso y **sombra fuerte**; no transparentes.
- **Menú**: fondo cyberpunk propio (`menu.png`) con scrim; **número de versión pequeño** en
  la esquina.
- **HUD con iconos** neón (no texto). **Pines** del mapa cyberpunk con halo: rojo/magenta =
  por visitar, cian/teal = visitada.

**Infra**
- Motor **Godot 4.7**. Compilar con **`tools/build.ps1`** (incrementa el patch de versión).
- La memoria de Claude vive en **`.claude/memory/`** dentro del repo.

---

## 7-ter. Arco de la Temporada 1 (capítulos)

Guiones detallados en `capitulos/capitulo_1.md`, `capitulo_2.md`, `capitulo_3.md`.
Implementados en `scripts/Story.gd` (`CHAPTERS` + `_chN_dialogue`). Se encadenan solos:
al cerrar un caso, la bandera `end_flag` avanza `Global.chapter` y `CityMap` reconstruye
el mapa.

- **Cap. 1 · "Desaparición en la iglesia"** — Marta Soler se esfuma durante la misa en
  **San José**. Nora descubre que la sacaron por el **campanario**: no fue milagro, fue
  secuestro. Núñez revela que es la **tercera** de una serie. Cadena: Plaza → Casa de
  Marta → Emilio → Rosa → Tomás → Carmen → Iglesia → Comisaría. `end_flag: done_comisaria`.
- **Cap. 2 · "Las campanas que faltan"** — La serie. Las tres víctimas pasaron por la
  **Fundación Amparo** (tapadera); un **benefactor con anillo** las "invita" a retiros y
  hay una **mano policial** que deja el barrio sin patrullas. Casi lo atrapa en el muelle.
  Cadena: Comisaría → Archivo → Laura → Fundación → Capilla → Muelle → Comisaría.
  `end_flag: done_cierre2`.
- **Cap. 3 · "El coleccionista"** — El blasón (tres campanas) es de los **Bru**; el
  villano es el **comisario Bru**. Nora rescata a las cautivas, el párroco chantajeado
  confiesa, y detiene a Bru en la **torre del reloj** a medianoche. Fin de temporada.
  Cadena: Comisaría → Mansión → Sótano → Iglesia (padre) → Torre → Comisaría.
  `end_flag: done_cierre3` (último capítulo).

Reparto añadido en Cap. 2-3: **Laura** (hermana), **Padre Ismael**, **Sr. Vidal**,
**Comisario Bru**. Pendiente: ampliar los diálogos de 2-3 a los ~5 min del canon.

### Temporada 2 (Caps. 4-6) — guiones en `capitulos/capitulo_{4,5,6}.md`
- **Cap. 4 · "El heredero"** — Bru sigue preso pero el método continúa: no era un loco,
  era un **negocio** (el "Cónclave del Bronce") con sello, corredor y contabilidad.
  Cadena: Comisaría → Iglesia de la Merced → Chivato → Redacción (Vera Lang) → Almacén.
- **Cap. 5 · "La subasta"** — Nora se infiltra en la **subasta** donde el gremio "vende"
  a las víctimas; cae el Corredor jefe y delata a la cima (A.V.). Cadena: Comisaría →
  Muelle → Salón (Madame Ourense) → Trastienda → Subasta.
- **Cap. 6 · "La cúspide"** — el magnate intocable **Aristide Vaultier**. Nora rompe su
  coartada siguiendo el dinero y lo detiene en su **azotea** bajo la tormenta. Fin de
  temporada. Cadena: Comisaría → Bufete → Contable → Mansión → Azotea.

**Pistas falsas (ADR-030)**: cada capítulo tiene ≥1 red herring — Cap.1 el exnovio
(coartada), Cap.2 el voluntario nervioso (sisa monedas), Cap.3 el soplo anónimo (cebo),
Cap.4 el falso culpable (busca fama), Cap.5 el chatarrero (pez pequeño), Cap.6 el trato
del secretario (soborno-trampa). Reparto T2: **Vera Lang** (periodista aliada), **el
Corredor**, **Madame Ourense**, **Aristide Vaultier**, chivato/contable (silueta).

### Temporada 3 (Caps. 7-20) — un solo caso: **Nyxos Pharma**
Guion dirigido por datos (`S3` en `Story.gd`). Hilo único que escala: las desapariciones
alimentaban ensayos ilegales de un fármaco (**Somnia**) de la corporación **Nyxos Pharma**;
Bru y Vaultier eran proveedores/fachada. Cada capítulo destapa una capa con **un sospechoso
que parece el jefe** (pero es un peón) y **≥1 pista falsa**. En el **Cap. 20** Nora lo une
todo: el culpable no es una persona, es la **corporación entera** (consejo + accionistas).

- Caps: 7 La receta · 8 El hermano · 9 La clínica fantasma · 10 El laboratorio · 11 El barrio
  alto · 12 La filtración · 13 El expediente · 14 El pueblo de la costa · 15 El pueblo de
  montaña · 16 La otra ciudad · 17 La compra · 18 El consejo · 19 La directora · 20 Nyxos.
- **Reparto personal de Nora** (ADR-033), intercalado, con fondo y ayuda real: **Diego**
  (hermano, cobaya de Somnia), **Sonia** (forense), **Clara** (ex, abogada), **Rubén**
  (mentor), **Marco** (excompañero en seguridad de Nyxos que acaba ayudando). Villana visible:
  **Dra. Adler** (ejecutora, no dueña). Superviviente clave: **Irene**.
- **Escenarios variados** (ADR-034): centro de negocios, barrio alto, otra ciudad, costa,
  montaña, hospital, morgue, laboratorio, planta, sala del consejo, bar de Clara...

---

## 8. Marco reutilizable — plantilla para OTRO juego (mismo motor, otro guión)

> **Objetivo de esta sección:** que baste con **darle otro guión** para producir otro juego.
> El motor y los sistemas son **reutilizables**; lo que cambia es el **contenido** (un archivo
> de datos + arte + textos). Aquí está el contrato exacto: qué reescribir, qué NO tocar y en qué orden.

### 8.1. Qué es MOTOR (reutilizable) vs. CONTENIDO (por juego)

**Motor (no se toca salvo para añadir mecánicas nuevas):**
- `scripts/Global.gd` — autoload de estado y servicios: `chapter`, `clues[]`, `flags{}`, `met_chars[]`,
  guardado (`save_game`/`load_game` en `user://savegame.json`), paleta `COL_*`, fuentes y estilos
  (`style_main_title/subtitle/tagline/dialogue`, `FONT_TITLE/ACCENT/BODY_PATH`), SFX (`play_sfx`,
  `SFX_*`), i18n (`loc(texto_es)`), `change_scene`, `note_char(who)`, `add_clue`, `set_flag`/`has_flag`.
- `scripts/Music.gd` — autoload de música generativa por ambiente (`play_mood(...)`).
- `scenes/SplashIntro.*`, `scenes/MainMenu.*` — front-end (título/subtítulo cambian por juego, la lógica no).
- `scenes/CityMap.gd` — **hub/mapa**: pines por localización (revelado progresivo por `req`), enruta cada
  visita a diálogo o a mini-escena, HUD (tablero, menú, saltar tutorial), animaciones (pista→libreta,
  viaje), avance de capítulo por `end_flag`.
- `scenes/DialogueScene.gd` (`class_name DialogueView`) — reproductor de diálogos: beats con máquina de
  escribir, retratos izq/dcha, elecciones (`choices`), marco cinematográfico (viñeta), **saltar ⏭ en
  revisitas**. Contrato: `start(dialogue)` + `signal finished(result)`.
- **Vistas de interacción** (todas: `class_name` + `signal finished(result)` + `func start(data)`, emiten
  `{clue, flag, false_count}` y aplican `add_clue`+`set_flag`): `SearchView` (búsqueda por hotspots),
  `ExamineView` (examinar con zoom/lupa), `PuzzleView` (puzzle, p.ej. keypad), `PresentView` (presentar
  prueba contra una mentira), `DeduceView` (deducción). Registradas en `CityMap._make_interaction`.
- `scenes/EvidenceBoard.gd` — **tablero de corcho dinámico**: se autoensambla con pistas + fotos de
  interrogados (`met_chars`) + hilo rojo; zoom (+/−, rueda, pinch), centrado, auto-encaje.
- Assets de motor: `assets/ui/frame_vignette.png` (marco), `assets/ui/ic_*.png` (HUD), fuentes en
  `assets/fonts/`, i18n en `assets/i18n/`.

**Contenido (se REESCRIBE por juego):**
- `scripts/Story.gd` (`class_name Story`) — **TODO el guión, dirigido por datos** (ADR-016). Es el archivo
  que se cambia para un juego nuevo. Ver esquemas en 8.2.
- `prompts/` — un `.md` por personaje/fondo/mapa; alimentan el pipeline de arte (8.3).
- `assets/portraits/*.png`, `assets/backgrounds/*.png` — arte generado desde los prompts.
- `capitulos/*.md` — el guión humano (referencia narrativa; no lo lee el juego).
- Identidad: título/subtítulo (menú y splash), icono, paleta si procede.

### 8.2. Esquemas de datos del guión (en `scripts/Story.gd`)

```gdscript
# Reparto: clave -> ficha. La clave se usa en los beats ("who") y en met_chars.
const CHARS := { "detective": {"name":"Nora Vega","color":Color(...),"portrait":"res://assets/portraits/detective.png"}, ... }
#   "narrador" y "detective" son especiales (narrador = sin placa; detective = lado derecho por defecto).

# Fondos: clave -> ruta PNG. La clave se usa en los diálogos ("bg") y en INTERACT.
const BGS := { "plaza":"res://assets/backgrounds/plaza.png", ... }

# Capítulos: n -> metadatos. end_flag = bandera que, al activarse, pasa al capítulo n+1.
const CHAPTERS := { 1: {"title":"Capítulo 1 · ...","locations":CH1_LOCATIONS,"street":CH1_STREET,
                        "complete_flag":"cap1_completo","end_flag":"done_cierre1","map":"res://.../mapa.png"}, ... }

# Localizaciones de un capítulo (pines del mapa). pos = normalizado 0..1 sobre el mapa.
const CH1_LOCATIONS := [ {"id":"plaza","name":"Plaza","sub":"...","pos":Vector2(0.5,0.58),"req":"always"},
                         {"id":"casa","name":"...","pos":Vector2(...),"req":"done_plaza"},
                         {"id":"rh","...":"...","req":"done_plaza","red_herring":true}, ... ]
#   req: "always" | "done_<id>" (otra localización) | "clues4" (todas las street) | "cap<n>_completo".

# Pistas "de calle" que abren el FINAL del caso (la puerta req="clues4").
const CH1_STREET := ["El grito","La puerta principal", ...]   # deben coincidir con clue.title de los diálogos

# Diálogo de una localización: Story.get_dialogue(id) -> dict, ruteado por Global.chapter.
#   {"bg":"plaza","flag":"done_plaza","beats":[...],"clue":{...} | "clues":[{...},...]}
#   beat normal:   {"who":"emilio","text":"...","side":"left"|"right","bg":"otro_fondo"}
#   beat elección: {"choices":[{"text":"Opción","then":[<beats>]}, ...]}
#   clue:          {"title":"...","text":"...","false":true|false}  # false=pista falsa (red herring)
# Para muchos capítulos, usar el diccionario data-driven S3 + _ch_data_dialogue (ADR-032) en vez de N funciones.

# Mini-escenas jugables por localización (mecánicas). En la 1ª visita se abre la vista;
# si lleva then_dialogue, al terminar ENCADENA el diálogo de esa id (no se pierde narrativa).
const INTERACT := {
  "id": {"type":"search","bg":"plaza","flag":"searched_id","then_dialogue":true,"show_marks":false,
         "intro":"...","clue":{"title":"...","text":"..."},"reveal":"...",
         "hotspots":[{"pos":Vector2(0.47,0.85),"r":34,"target":true,"text":"..."}, {..decoy..}]},
  # examine: {"detail_pos":Vector2,"detail_r":74,"hint","found"}
  # puzzle:  {"kind":"keypad","code":"427","hint","solved"}
  # present: {"speaker":"sospechoso","statements":[{"text","lie":true|false}],"evidence_needed","rebuttal","hint_*"}
  # deduce:  {"clues_shown":[titulos],"conclusions":[...],"solution":idx,"solved","wrong"}
}
```

**Sistema de banderas (progresión):** `done_<id>` la pone el diálogo al terminar (su `flag`); habilita las
localizaciones con `req:"done_<id>"`. `searched_<id>` la pone una búsqueda encadenada (evita repetir la
mini-escena en revisitas). `req:"clues4"` exige tener todas las pistas de `CHn_STREET` (por `title`). El
`end_flag` del capítulo (normalmente el `done_` de la última escena) avanza al capítulo siguiente.
**Regla de oro del gating:** una pista solo cuenta para `clues4` si su `title` está en `CHn_STREET`; las
pistas atmosféricas de las búsquedas usan títulos propios (no colisionan) para no alterar la puerta.

### 8.3. Pipeline de arte (por juego, mismo proceso)

- **Prompts:** `prompts/portraits/<clave>.md`, `prompts/backgrounds/<clave>.md`, `prompts/map/*.md`
  (bloque de prompt entre ``` ```). El estilo global (anime cyberpunk-noir) lo aporta `tools/gen_assets.py`
  (`ANIME_PORTRAIT_LEAD`/`ANIME_SCENE_LEAD`, ADR-044/045): el `.md` solo describe al personaje/escena.
- **Generación:** `python tools/gen_assets.py` (genera lo que falte) · `--force <clave>` (regenera uno).
  Pollinations/Flux (gratis, sin key) → **Real-ESRGAN x4** a 4K (ADR-029). Retratos `enhance=ON`
  (2400×3200, 3:4); escenas `enhance=OFF` (16:9). Tras generar, **reimportar** en Godot
  (`godot --headless --import`) o el `.ctex` viejo persiste.
- **Import optimizado (ADR-046):** WebP lossy por plataforma (Windows 4K / Android 1080p) vía
  `tools/set_texture_size_limit.py` para no inflar el APK.
- **Degradación elegante (ADR-018):** si falta un PNG, hay silueta/placeholder y mapa procedural; el juego
  corre sin arte, útil para prototipar el guión antes de generar.

### 8.4. Proceso para un GUIÓN NUEVO (paso a paso)

1. **Escribe el guión** en `capitulos/*.md` (casos, capítulos, escenas, personajes, pistas verdaderas y
   falsas, mecánicas por escena). Es la fuente narrativa.
2. **Reescribe `scripts/Story.gd`**: `CHARS` (reparto), `BGS` (fondos), `CHAPTERS` + cada `CHn_LOCATIONS`
   y `CHn_STREET`, los diálogos (`get_dialogue`/`_dlg_*` o el diccionario `S3`) y `INTERACT` (mecánicas).
   Mantén las convenciones de banderas (8.2).
3. **Crea los prompts** de cada personaje y fondo nuevos en `prompts/`.
4. **Genera el arte** (`gen_assets.py` + ESRGAN) y **reimporta**.
5. **i18n** (opcional): texto original en español; `tools/extract_i18n.gd` + `translate_i18n.py` para
   es/en/zh (ADR-038). El código llama a `Global.loc("texto es")`.
6. **Identidad**: título/subtítulo del menú y splash, icono, paleta `COL_*` si el tono cambia.
7. **Prueba** (headless: `godot --headless --editor --quit-after N` para validar 0 errores de script; y
   ejecución real) y **build** (`tools/build.ps1` Windows, `tools/build_android.ps1` Android; ADR-025 bumpea patch).

### 8.5. Checklist "qué tocar / qué NO"

- **Tocar por juego:** `scripts/Story.gd`, `prompts/`, `assets/portraits`, `assets/backgrounds`,
  `capitulos/`, título/subtítulo/icono, `assets/i18n/`.
- **NO tocar (motor):** `Global.gd`, `Music.gd`, `CityMap.gd`, `DialogueScene.gd`, las 5 vistas de
  interacción, `EvidenceBoard.gd`, `frame_vignette.png` — salvo para **añadir una mecánica nueva** (crear
  otra vista con el contrato `class_name`+`finished`+`start`, y registrarla en `CityMap._make_interaction`
  + un nuevo `type` en `INTERACT`).
- **Añadir una mecánica nueva:** copia el patrón de `SearchView` (root `Control`, `start(data)`, construir
  UI por código, emitir `finished({clue,flag,false_count})`, `add_clue`+`set_flag` al cerrar).

---

## 9. Bitácora / Historial

> Registro **append-only**. Cada sesión añade una entrada al final con lo hecho,
> por qué y qué queda. No se borra ni reescribe: es la memoria del proyecto.

### 2026-07-05 — Sesión 1 · Fundación (Fase 1)
**Objetivo:** arrancar el proyecto y llegar “hasta la primera pantalla
principal”, más una intro cinemática pedida y este documento vivo.

**Hecho:**
- Elegido el stack (ADR-001..007) y montado el proyecto Godot 4.
- `scripts/Global.gd`: autoload con transiciones de escena (fundido),
  registro de `InputMap` en runtime, ajustes (volúmenes, pantalla completa) con
  persistencia en `user://settings.cfg`, `has_save()` y paleta compartida.
- `scenes/SplashIntro`: cinemática procedural (iglesia + campanario, campanas
  con síntesis de parciales inarmónicos, viento con ruido marrón creciente +
  rachas + aullido, relámpagos con truenos, lluvia y escombros, y gente-silueta
  corriendo a refugiarse en la iglesia). Saltable; encadena al menú.
- `scenes/MainMenu`: fondo por shader (gradiente + resplandor rojo pulsante +
  viñeta + grano), lluvia, título, botones y overlay de Opciones. Adaptación a
  Android (oculta “Salir”/pantalla completa). Navegable por teclado/ratón/toque.
- `scenes/Game`: stub jugable (movimiento teclado + *tap-to-move*, cámara
  suavizada, efecto linterna, HUD y regreso al menú).
- Documentación: esta constitución y el README con pasos de ejecución/exportación.

**Decisiones destacadas:** todo el arte y el audio son procedurales de momento
(ADR-006) para no bloquearnos en assets; la escena inicial es el splash (ADR-007).

**Validación:** descargado Godot 4.3 headless; corregido un error de tipado en
el bucle de audio de `SplashIntro` (`frames` sin tipo inferible). Tras el fix,
importación con `--editor` sin errores y las tres escenas (`SplashIntro`,
`MainMenu`, `Game`) ejecutan en runtime sin fallos.

**Pendiente / siguiente paso:** abrir en el editor para revisión visual;
sustituir el stub por un TileMap urbano real y sprite del protagonista con
joystick virtual (Fase 2).

### 2026-07-05 — Sesión 2 · Fase 2 + Build Windows
**Objetivo:** arrancar la Fase 2 (protagonista + mundo) y, a petición del
usuario, **compilar para Windows y ejecutar**.

**Hecho:**
- Definido el protagonista: **detective urbano** (ADR-008).
- `scripts/Player.gd`: `CharacterBody2D` con movimiento 8-dir (teclado o
  joystick), sprite procedural animado (gabardina + fedora, 4 orientaciones +
  ciclo de andar) y **linterna en cono** con textura de luz generada.
- `scripts/VirtualJoystick.gd`: joystick táctil (ADR-010), operable también con
  ratón para pruebas en escritorio.
- `scenes/Game.gd` reescrito: **Barrio Viejo** nocturno con `TileMapLayer` +
  atlas de tiles generado (ADR-011), 6 edificios con colisiones y ventanas
  iluminadas, farolas, `CanvasModulate` de noche + `PointLight2D` (ADR-009),
  cámara con límites al mundo, HUD y una interacción (tablón → trama).
- **Exportación Windows** (ADR-012): instaladas las export templates 4.3, creado
  `export_presets.cfg`, generado `build/sOC.exe` (PCK embebido). Verificado el
  arranque y **lanzado en el escritorio del usuario**.
- Corregidos warnings de inferencia de tipo tratados como error (`:=` que
  resolvían a Variant): tipos explícitos y `clampf`/`maxf`.

**Validación:** `--editor` importa sin errores; `Game` corre en runtime limpio;
`sOC.exe --quit-after` arranca con exit 0. Capturas de menú, splash y mundo
revisadas y correctas.

**Pendiente / siguiente paso:** exportar Android (APK/AAB), sustituir siluetas
por sprites/arte definitivos, e iniciar el bucle de combate (Fase 3).

### 2026-07-05 — Sesión 3 · Arreglo de la intro (visibilidad)
**Síntoma:** el usuario no veía la iglesia ni la gente en la pantalla inicial.
**Causas y arreglo:**
- **Bug de la viñeta:** el `Gradient` conserva un punto 1 blanco por defecto; al
  no sobrescribirlo, los bordes salían **blancos** y lavaban la escena. Corregido
  con `set_color(1, negro)`. (Aplicable a cualquier `GradientTexture2D` futuro.)
- **Salto involuntario:** el clic que da foco a la ventana se interpretaba como
  "saltar". Añadido un bloqueo de salto durante los primeros 1.2 s.
- **Legibilidad:** luna que recorta la iglesia, charco de luz cálida en el suelo,
  puerta/ventanas como faro, y gente más grande con contraluz cálido. Campanas
  más audibles (`volume_db` +2).
- Reexportado `build/sOC.exe` con los cambios.

### 2026-07-05 — Sesión 4 · Assets reales (tiles CC0 + audio CC0)
**Objetivo:** integrar los tiles urbanos que aportó el usuario y hacer las
descargas convenientes de gráficos y sonidos.

**Hecho:**
- **Tiles urbanos** (Kenney city top-down, 16px, atlas `assets/tile_0000.png`
  37×28): sustituido el atlas procedural por el real. `TileMapLayer` escalado ×2
  con filtro nearest (ADR-014). Suelo del Barrio Viejo: aceras (plaza), cruce de
  avenidas con **líneas amarillas y pasos de cebra**, parches de **césped con
  árboles**. Filtro nearest global en `project.godot`.
- **Audio CC0 descargado** (Kenney, ADR-013): *Interface Sounds* y *RPG Audio* en
  `assets/audio/`. Sistema de SFX en `Global` (pool de 6 reproductores +
  `play_sfx`/`play_footstep`). Conectado: **clic** en botones del menú, **pasos**
  del detective al andar, **sonido de papel** al investigar el tablón.
- `CREDITS.md` con licencias (todo CC0).
- Reexportado `build/sOC.exe` (~83 MB) con tiles + audio; `modify_resources=false`
  para evitar el aviso de `rcedit`.

**Nota:** el sprite del detective sigue siendo procedural (funciona bien); se
podrá cambiar por un sheet CC0 más adelante. Las campanas/viento del splash
siguen sintetizados (suenan bien y eran el objetivo del arreglo previo).

**Pendiente / siguiente paso:** (opcional) props extra (coches, bancos, farolas
como sprite), sprite de personaje real, y comenzar el bucle de combate (Fase 3).

### 2026-07-05 — Sesión 5 · Protagonista, arte real y splash con iglesia
**Cambios de diseño del usuario:** la protagonista es **una DETECTIVE** que
investiga un caso (ADR-008). La intro de la iglesia **no se puede saltar**, dura
**10 s** y sin rótulo de "saltar".

**Hecho:**
- **Detective jugable con sprites reales** (`assets/detective.png`): recortado el
  walk-cycle (4 direcciones) a `assets/detective_frames/`; `Player.gd` anima
  Sprite2D real + conserva la linterna en cono.
- **Splash con ilustración real** (`assets/church2.png`) a pantalla completa
  (cover, zoom lento) + lluvia + campanas/viento/truenos (sintetizados) + leyenda,
  **no saltable, sin rótulo**, 10 s.
- **Gente animada entrando** con sprites reales del character pack
  (`assets/characters.png`), fotogramas **de espaldas** recortados a
  `assets/people/` (auto-detección de bandas + flood-fill de fondo → transparencia
  real, cabeza completa, sin texto de la lámina).
- **Suelo del juego con tiles reales** (Kenney city) + **props** (coches, bancos,
  árboles, hidrante, farolas) con y-sort; audio CC0 (clic menú, pasos, papel).
- **Botón "Salir del juego" en Opciones** del menú.
- Assets recibidos y catalogados para construir ciudad: `npcs.png` (NPCs
  animados), `citypack_1/2.png` (City Expansion: viviendas, edificios públicos,
  policía/bomberos, transporte, parques). Pendiente de integrar en un mapa.

**Técnica de recorte de láminas:** las hojas de sprites son *previews* con texto
y espaciado irregular. Método: detectar bandas por densidad de tinta (excluye
textos), recortar por columnas, y **flood-fill desde los bordes** para volver
transparente el fondo gris. Reutilizable para futuros packs.

**Pendiente / siguiente paso:** construir la ciudad real con `citypack_*`
(edificios como sprites/props con colisión), NPCs con rutinas, y arrancar la
investigación (Fase 3): diálogos, pistas, primer caso.

### 2026-07-05 — Sesión 6 · Fase 3: maqueta del barrio + menú/icono
**Caso elegido:** "Desaparición en la iglesia" (enlaza con la intro).

**Hecho:**
- **Barrio maquetado** (`scenes/Game.gd` reescrito): mundo 52×38, calles con
  tiles reales (avenidas en cruz, líneas, pasos de cebra), **edificios del City
  Pack** colocados con colisión y **y-sort** (casas, ayuntamiento, café, tienda,
  comisaría, bomberos), recortados a `assets/buildings/` (color-key + flood-fill,
  transparencia, sin textos de la lámina).
- **Iglesia como localización del caso** (`church2` escalada al norte) con
  interacción que arranca el caso.
- **NPCs con diálogo** (vecinos del character pack) repartidos por el barrio;
  sistema genérico de interactuables (prompt + panel de diálogo).
- **Iluminación de anochecer** (barrio visible) + farolas de acento.
- **Menú**: botones más pequeños; lista Nueva partida / Continuar / Opciones /
  Salir; quitado el "Salir" de Opciones.
- **Icono del `.exe`**: generado `icon.ico` multi-resolución (16–256) y
  configurado `rcedit`; el ejecutable ya muestra el icono de la app.

**Técnica de recorte de edificios:** color-key del fondo gris de la lámina
(muestreado por edificio) + flood-fill desde bordes + auto-trim. Documentado por
si llegan más packs (NPCs animados y transporte están pendientes de integrar).

**Pendiente / siguiente paso (Fase 3 cont.):** libreta de pistas y progreso del
caso; NPCs animados con rutinas (usar `npcs.png`); interiores (iglesia,
comisaría); primer puzle/minijuego de investigación.

### 2026-07-05 — Sesión 7 · Caso 1 (pistas/NPCs), tipografía, tormenta, test
**Hecho:**
- **Guión del Capítulo 1** en `capitulos/capitulo_1.md` ("Desaparición en la
  iglesia"): premisa, personajes, 5 pistas, estructura y progreso.
- **Libreta de pistas** (`Global.clues` + panel en el HUD, tecla **N**): hablar
  con los 4 vecinos anota pistas; la **iglesia** se investiga a fondo con las 4
  pistas y da la 5ª + cierre de capítulo.
- **NPCs animados** que deambulan por el barrio (clase `NPC`: waypoints +
  animación 4-dir con el character pack; derecha = izquierda espejada).
- **Sistema tipográfico** (Kenney, CC0): fuente de cuerpo por defecto en
  `project.godot`; helpers `Global.style_main_title/subtitle/tagline/dialogue`.
  Aplicado a menú (título/subtítulo/tagline), splash y diálogos.
- **Menú**: arreglado que "Salir" no se veía (resplandor sacado del layout);
  **tormenta** con lluvia intensa + **sonido de lluvia, rayos y truenos**
  sintetizados; **Test de sprites** accesible desde Opciones.
- **Pantalla de test de sprites** (`SpriteTest`): galería de todos los recortes
  sobre fondo a cuadros con su nombre, para revisar y ajustar. Ya detectó y
  corregimos los frames de la detective (re-recortados con auto-banda+flood-fill).
- **Android**: preset con `package/unique_name=com.socratic.socthegame`.
- **Icono del `.exe`**: `icon.ico` multi-resolución incrustado vía rcedit.

**Pendiente / siguiente (Fase 3 cont.):** interior de la iglesia (pista 5 como
escena real), comisaría (gancho cap. 2), NPCs con más variedad (usar `npcs.png`),
persistencia de progreso del caso.

### 2026-07-06 — Sesión 8 · SpriteManager.exe + APK Android
**Hecho:**
- **SpriteManager compilado a ejecutable**: `tools/sprite_manager/SpriteManager.exe`
  (~57 MB, PyInstaller onefile, no requiere Python). `app.py` ahora es
  *freeze-aware*: resuelve `static/`+`config.json` embebidos vs. `config.json`
  externo (con la API key) junto al exe, y localiza `assets/` por `assets_dir` de
  config → `..\..\assets` → búsqueda ascendente de `project.godot`. README y
  `.gitignore` actualizados; comando de recompilación documentado.
- **APK Android generada**: `build/sOC.apk` (~58 MB, **debug**, firmada con el
  keystore debug de Godot y verificada). Paquete `com.socratic.socthegame`,
  `versionName 0.2.0`, minSdk 21 (Android 5.0+), nativo arm64-v8a + armeabi-v7a.
  Export clásico (`use_gradle_build=false`) con Godot 4.3 headless. Requisitos
  ya presentes: JDK 17, Android SDK (build-tools 34, ndk 26, platforms 29/34/35),
  templates 4.3 Android. Se fijó `export/android/android_sdk_path` en los editor
  settings de Godot (estaba vacío).

- **SpriteManager · "Cortar hoja (ratón)"**: nueva herramienta de recorte manual.
  Auto-detecta cajas de sprites (bandas+columnas, PIL puro) sobre una hoja y el
  usuario las mueve/redimensiona/renombra con el ratón (tecla `F` = voltear) y
  exporta cada frame (fondo quitado + centrado en celda opcional). Endpoints
  `/api/detect_boxes` y `/api/export_boxes`; `.exe` recompilado. Pensada para
  `mainchar.png` (nuevo sheet de la detective, con caminar de espaldas).
- **Prompts de NPCs (Cap. 1)** en `prompts/npc_capitulo1/` (uno por NPC: Emilio,
  Rosa, Tomás, Carmen, Núñez + extras Marta/encapuchado) con guía de estilo.
- **Generación de imagen por IA en SpriteManager**: el free tier de **Gemini NO
  genera imágenes** (429 `limit: 0`; imagen-* de pago). Se añadió al tool un panel
  «Generar NPC (IA · NVIDIA FLUX)» que usa la clave **NVIDIA** (endpoint
  `ai.api.nvidia.com`, `flux.1-schnell`) y guarda el PNG en `assets/`; corre en la
  máquina del usuario (el sandbox no alcanza ese host). Endpoint `/api/gen_image`.
- **SpriteManager · layout y edición**: interfaz reorganizada en 3 columnas
  (galería 2-col a la izquierda · editor en el centro · opciones a la derecha).
  Recortador: **dibujar caja** arrastrando en zona vacía; botón **→ Editor** que
  manda el recorte crudo (`/api/crop_raw` → carpeta `_staging`) al editor manual
  para ajustarlo. Editor: **Deshacer** (botón + Ctrl+Z) con pila de estados que
  persiste vía `/api/save_image`.

**Pendiente / siguiente:** recortar `mainchar.png` con la herramienta nueva y
sustituir los `det_*` (incl. caminar de espaldas); generar los NPCs con Gemini;
APK de **release** firmada con keystore propio + AAB para Play Store; resto Fase 3.

### 2026-07-08 — Sesión 9 · Reorientación a NOVELA VISUAL (Fase 4)
**Cambio de diseño del usuario:** convertir el juego de movimiento en un **juego
de diálogo**. Aparecen **escenas de diálogo** entre personajes y la ciudad es un
**mapa** donde el jugador **marca a dónde ir**. Rehacer el juego y los prompts de
los assets, con backup de lo anterior.

**Hecho:**
- **Backup** del prototipo ARPG en `backup/movimiento_2026-07-08/` (`Game.gd/.tscn`,
  `Player.gd`, `VirtualJoystick.gd`, y los prompts de hojas de 4 vistas
  `prompts_npc_capitulo1/`). Los archivos siguen en disco pero fuera del flujo.
- **`scripts/Story.gd`** (nuevo, dirigido por datos, ADR-016): reparto con retratos
  (`CHARS`), fondos (`BGS`), **7 localizaciones** del mapa (`LOCATIONS` con posición
  fraccional y requisito de desbloqueo) y **todos los diálogos del caso 1**
  (formato beats: líneas con locutor/lado/fondo + beats de elección con respuestas).
  Editar este archivo es editar el juego.
- **`scenes/DialogueScene.gd`** (`class_name DialogueView`, ADR-017): reproductor
  de **novela visual** — fondo (imagen o gradiente de respaldo + rótulo), **dos
  retratos** (izq/dcha, el que habla se ilumina, el otro se atenúa), placa de
  nombre coloreada por personaje, caja de texto con **efecto máquina de escribir**
  (click/espacio/toque avanza o completa), **botones de elección** con ramas, y
  señal `finished(result)` que entrega la pista/flag al terminar. Se instancia como
  **capa sobre el mapa**.
- **`scenes/CityMap.gd/.tscn`** (nuevo núcleo): **mapa** del Barrio Viejo con
  **pines** por localización (disponible/hecha/bloqueada; la comisaría oculta hasta
  desbloquearse), **ficha de la detective que viaja** al pin marcado antes de abrir
  el diálogo, **barra de objetivo** dinámica, **libreta de pistas** (tecla **N**),
  avisos (toast) de pistas, y **mapa procedural de respaldo** (`MapCanvas._draw`) si
  falta `assets/backgrounds/mapa.png` (ADR-018).
- **`Global.gd`**: añadidas **flags** de progreso (`set_flag/has_flag`) y su reset;
  la libreta (`clues`) se mantiene.
- **`MainMenu.gd`**: "Nueva partida"/"Continuar" → `CityMap.tscn` (antes `Game`).
- **Prompts de arte rehechos** (`prompts/`, ADR-019): `README.md` con el mapa de
  archivos y rutas exactas; **8 retratos** (busto de novela visual, fondo
  transparente) en `prompts/portraits/`; **7 fondos** 16:9 en `prompts/backgrounds/`;
  y el **mapa** en `prompts/map/mapa.md`. Pensados para **Gemini / Google AI Plus**;
  cada archivo es autónomo y dice dónde va el PNG (`assets/portraits/<id>.png`,
  `assets/backgrounds/<clave>.png`). Los prompts antiguos de 4 vistas quedan como
  referencia histórica.
- `project.godot`: versión **0.3.0** y descripción actualizada.

**Decisiones destacadas:** contenido dirigido por datos (ADR-016) para iterar la
historia sin tocar la lógica; diálogo como capa reutilizable con señal (ADR-017);
degradación elegante de assets (ADR-018) para poder jugar **ya**, sin arte
definitivo; el arte llegará por IA con los prompts nuevos (ADR-019).

**Validación:** no había binario de Godot en la máquina; revisión manual de
sintaxis GDScript 4.3 (ternarios, lambdas tipadas, acceso a diccionarios, señales
con `bind`, clase interna `MapCanvas`). Al abrir el editor se registran las clases
globales `Story` y `DialogueView`. **Pendiente**: abrir en el editor para revisión
visual y reexportar `.exe`/APK.

**Pendiente / siguiente paso:** generar el arte con los nuevos prompts; audio
ambiental por localización; **guardado real** de pistas+flags; y arrancar el
**Capítulo 2** (la serie de desapariciones que insinúa Núñez).

### 2026-07-08 — Sesión 10 · Arte de la novela visual generado por IA
**Objetivo:** generar el arte definitivo (retratos, fondos, mapa) con IA.

**Camino recorrido:** la API de **Gemini/Imagen** con la key del usuario **falla**
para imágenes (`free_tier limit: 0`; Imagen "only available on paid plans"): AI
Plus es de la app, no activa el paid tier de la API. Sin GPU NVIDIA (torch CPU) el
SD local sería lentísimo; el usuario tiene **GPU Intel + NPU** (opción OpenVINO
futura). Solución adoptada: **Pollinations** (servicio IA gratuito **sin key**,
modelo tipo Flux) + **rembg** (U²-Net) para recortar los retratos a transparente.

**Hecho:**
- `tools/gen_assets.py` reescrito con dos backends (`pollinations` por defecto,
  `gemini` para cuando haya billing); lee los prompts de `prompts/`, tamaños 3:4
  (retratos) y 16:9 (fondos/mapa), semilla por nombre (reproducible).
- **16 imágenes generadas** sin fallos: 8 retratos transparentes en
  `assets/portraits/`, 7 fondos + `mapa.png` en `assets/backgrounds/`. Calidad y
  coherencia noir revisadas (paletas por personaje correctas; el campanario incluso
  muestra el pañuelo-pista).
- Créditos actualizados (`CREDITS.md`).
- ADR-019 revisado: el arte se genera con **Pollinations/Flux + rembg** (no Gemini,
  por el muro de facturación); Gemini queda como backend alternativo.

**Pendiente / siguiente:** abrir el editor de Godot **una vez** para que importe los
nuevos PNG (`.import`); revisar el encaje visual de retratos sobre fondos en el
diálogo; retoques puntuales de recorte (leve halo en algún retrato) si molestan;
audio ambiental por localización; guardado real; Capítulo 2.

### 2026-07-08 — Sesión 11 · Sincronización, limpieza y giro cyberpunk-noir 2K
**Contexto:** se retoma en el PC de sobremesa tras trabajar la novela visual en otro
equipo. OneDrive tardó en bajar los cambios (y dejó una copia en conflicto de Global);
una vez sincronizado, se verificó que compila y corre en 4.7.

**Hecho:**
- **Sincronización resuelta**: bajada la versión novela visual (`CityMap`, `Story.gd`,
  `DialogueScene`); borrada la copia en conflicto `Global-DESKTOP-FETR675.gd`.
- **Unificado en Godot 4.7** (ADR-021): `config/features=("4.7",...)`.
- **Limpieza de restos ARPG** (superseden ADR-006/011/014): borrados scripts/escenas
  muertos (`Game.gd`, `ChurchInterior.*`, `Player.gd`, `GameEditable`, `ground_tileset`,
  `.uid` huérfanos), **60+ assets** sueltos de la raíz y `detective_frames/`, `people/`,
  `buildings/`, y las **tools de captura/iso** (`tools/capture*`, `iso_*`, `make_editable`).
  Se conservan `gen_assets.py`, `sprite_manager/` y `assets/packs/` (CC0 reutilizable).
- **Splash coherente**: reescrito `SplashIntro.gd` para usar fondo IA
  (`assets/backgrounds/splash.png`, catedral gótica/tormenta) y **eliminados los sprites
  pixel-art de gente** que chocaban con la pintura.
- **Dirección artística cyberpunk-noir** (ADR-020): capa de estilo global en
  `tools/gen_assets.py` (megaciudad de neón bajo la lluvia, catedral gótica entre
  rascacielos, iluminación teal/magenta); **el guion no cambia**.
- **Arte 2K regenerado** (ADR-023): **17 imágenes** (8 retratos + 8 fondos + mapa +
  splash) a 2560×1440 / 1536×2048; Pollinations reduce y se reescala con LANCZOS
  (`ensure_2k`). Manejo de rate-limit (HTTP 429) con backoff.
- **Retratos enmarcados** (ADR-022): como `rembg` no corre en **Python 3.14**
  (sin `onnxruntime`) y el recorte por color falla, los retratos llevan su fondo neón y
  se muestran en un **marco tipo foto de expediente** (borde neón + degradado) en
  `DialogueScene`. Se intentó recorte flood-fill + componente mayor, descartado.
- **HUD con iconos** (ADR-024): iconos neón procedurales en `assets/ui/`
  (`ic_libreta`, `ic_menu`, `ic_close`) sustituyen el texto de los botones de `CityMap`.
- **Menú**: el pie muestra **solo la versión** (`v0.3.0`).
- Verificado: importa y corre en 4.7 sin errores; mapa cyberpunk 2K + HUD de iconos en
  pantalla; splash y retratos revisados (calidad y coherencia altas).

**Pendiente / siguiente:** ver en el juego una conversación con el retrato enmarcado
(pendiente de captura, no se hizo por no interrumpir el uso del PC); posible **vídeo
introductorio** grabando el splash con el *Movie Maker* de Godot (`--write-movie`);
audio ambiental por localización; guardado real; Capítulo 2. `CREDITS.md` a revisar
(estilo cyberpunk-noir 2K).

### 2026-07-08 — Sesión 12 · Test de usuario del Capítulo 1 + memoria en el repo
**Hecho:**
- **Capítulo 1 confirmado COMPLETO** en `Story.gd` (5 pistas, 7 localizaciones,
  puertas por requisito, cierre + gancho al cap. 2). No faltaba implementación.
- **Test de usuario automatizado** (`tools/test_cap1.gd` + `TestCap1.tscn`): playthrough
  **headless** que juega el capítulo entero a través de las **escenas reales**
  (`DialogueView` + `Story` + `Global`), avanzando todos los beats (elige la 1ª opción)
  y comprobando: existencia de los 17 assets, buena formación de todos los diálogos
  (locutores/bg válidos, elecciones bien formadas), y el flujo — iglesia bloqueada
  hasta 4 pistas, comisaría hasta `cap1_completo`, acumulación de 5 pistas, sin
  duplicar en revisitas. **119 comprobaciones, 0 fallos** (Godot 4.7, EXIT 0).
  Se ejecuta fijando `TestCap1.tscn` como `main_scene` (restaurada a `SplashIntro`).
- **Memoria de Claude en el proyecto**: copiada `memory/` (MEMORY.md + memorias) a
  `.claude/memory/` de la raíz para que viaje con el repo por OneDrive (sin las
  transcripciones .jsonl, ~104 MB privadas).

**Pendiente / siguiente:** ver en el juego una conversación con retrato enmarcado
(captura); vídeo intro con Movie Maker (`--write-movie`); audio por escena; guardado
real; Capítulo 2. Mantener sincronizada la copia `.claude/memory/` si cambia la memoria.

### 2026-07-08 — Sesión 13 · Bugs de diálogo, splash, menú y progresión
**Bugs corregidos (encontrados jugando):**
- **BLOQUEO al entrar en una localización** (dos causas, ambas en `DialogueScene`):
  1. El `Control` raíz usaba `set_anchors_preset` (solo anclas, sin offsets) → quedaba
     a **tamaño 0**, la caja colapsaba y el texto se apilaba en **vertical a la
     izquierda** (las "letras grises" que se veían). Arreglado con
     `set_anchors_and_offsets_preset(FULL_RECT)`. Verificado por sonda headless
     (`_box` pasa de 0 a 1072 px de ancho).
  2. El clic no avanzaba (raíz con `mouse_filter=STOP` → los clics no llegaban a
     `_unhandled_input`). Añadido `_gui_input` para ratón/táctil; teclado sigue en
     `_unhandled_input`. Ahora avanza con clic, tap o tecla.
**Cambios pedidos:**
- **Splash**: mantiene el título ~5 s más (DURATION 10→15) y cierra con **relámpago +
  trueno** antes del fundido.
- **Menú**: nuevo **fondo cyberpunk** (`assets/backgrounds/menu.png`, skyline lluvioso)
  con scrim suave para legibilidad; **versión más pequeña** (font 10, esquina).
- **Localizaciones progresivas** (ADR-026): solo la **Plaza** al inicio; sus vecinos
  aparecen tras la conversación de la Plaza; la Iglesia al reunir 4 pistas; la
  Comisaría al cerrar el caso. Aviso "Nueva localización" al revelarse.
- **Build** (ADR-025): `tools/build.ps1` incrementa el patch de `config/version` y
  exporta.
- **Test del Cap.1** re-ejecutado tras los cambios: **119 comprobaciones, 0 fallos**.

**Pendiente / siguiente:** vídeo intro (Movie Maker); audio ambiental por escena;
guardado real; Capítulo 2; mantener sincronizada `.claude/memory/`.

### 2026-07-08 — Sesión 14 · Contenido del Cap.1, guardado, audio y canon
**Hecho (todo pedido por el usuario; ver §7-bis para el canon):**
- **Fix del clic**: avanzar el diálogo con clic/tap se captura ahora en `_input`
  (antes lo comía la caja con mouse_filter=STOP). Márgenes del texto del diálogo
  (izq/arriba) y hint "[click/espacio]" a la derecha.
- **Retratos enmarcados** con borde rojo neón grueso + sombra fuerte (antes sosos).
- **Nueva ubicación "Casa de Marta"** (fondo IA propio) y **cadena de revelado**
  Plaza→Casa de Marta→Emilio→Rosa→Tomás→Carmen→Iglesia→Comisaría (cada una se nombra
  en la anterior). **Revisitas** con "ya lo conté todo" + pista + siguiente destino.
- **Diálogos de ubicación reescritos y MUY ampliados** (~5 min lectura, ramas).
- **Nora** como nombre; **iglesia de San José**; "el barrio es mío esta noche";
  "Caso uno completado".
- **Guardado automático a cada pista/bandera** (`save_game`); Continuar carga, Nueva
  partida borra.
- **Música ambiente** procedural en el mapa (y en diálogos, por jerarquía).
- **Libreta** con `ScrollContainer` + márgenes + contador dinámico.
- **Pines cyberpunk** (halo neón rojo/cian); menú con **versión pequeña**.
- Borrada la carpeta `backup`.
- **Canon documentado** en §7-bis para próximos capítulos.
- **Test del Cap.1 actualizado** (cadena con Casa de Marta, 6 pistas).

**Pendiente:** vídeo intro; Capítulo 2 siguiendo §7-bis; afinar audio por escena.

### 2026-07-08 — Sesión 15 · Capítulos 2 y 3 + framework de capítulos
**Hecho:**
- **Framework de capítulos** en `Story.gd`: `CHAPTERS` (1..3) con `locations`, `street`,
  `complete_flag` y `end_flag`; accesos `locations()/street_clues()/chapter_title()/
  complete_flag()/end_flag()/is_last_chapter()` según `Global.chapter`. `get_dialogue`
  enruta por capítulo (`_ch2_dialogue`, `_ch3_dialogue`).
- **`Global.chapter`** persistido en el guardado; `reset_case` vuelve a 1.
- **CityMap capítulo-consciente**: título dinámico, objetivo genérico, y **avance de
  capítulo** (`_advance_chapter`) que reconstruye los pines al cerrar el caso.
- **Capítulo 2 · "Las campanas que faltan"**: Comisaría→Archivo→Casa de Laura→Fundación
  Amparo→Capilla privada→Muelle→Comisaría. Descubre la Fundación como tapadera, el
  benefactor del anillo y una mano policial dentro. Pistas: hilo común, voluntariado,
  benefactor, agenda de misas.
- **Capítulo 3 · "El coleccionista"**: Comisaría→Mansión→Sótano→Iglesia (padre)→Torre
  del reloj→Comisaría. Se rescata a las cautivas, confiesa el párroco chantajeado y se
  detiene al **Comisario Bru** en la torre. Cierre de temporada.
- **Personajes nuevos**: Laura, Padre Ismael, Sr. Vidal, Comisario Bru. **Fondos nuevos**:
  archivo, refugio, muelle, mansión, sótano, torre (generándose; con fallback de rótulo).
- **Rename a "sOC"** (splash, menú, `project.godot`). Aviso de nueva ubicación en cian.
  Mezcla de audio: menos lluvia, más música. Sombra del retrato reforzada.
- **Test ampliado**: playthrough de Ch1 + validación estructural de Ch2 y Ch3 →
  **416 comprobaciones, 0 fallos**.

**Pendiente:** que termine la generación de arte de Ch2/Ch3 e importarlo; ampliar los
diálogos de Ch2/Ch3 a los ~5 min del canon si se desea; vídeo intro.

### 2026-07-09 — Sesión 16 · Temporada 2 (Caps. 4-6), pistas falsas y arte 4K
**Hecho:**
- **Arte a 4K real con Real-ESRGAN** (GPU, ncnn-vulkan): 17 fondos y todos los retratos
  regenerados (escenas 3840×2160, retratos 2400×3200) con detalle real. Pipeline en
  `gen_assets.py` (ADR-029). Retratos con **shader de viñeta de cómic** (ADR-028).
- **Mecánica de pistas falsas** (ADR-030): `clue.false`, locations `red_herring`; libreta
  con sección "Pistas descartadas"; aviso en rojo. **≥1 red herring por capítulo** (1-6).
- **Temporada 2 · Capítulos 4, 5 y 6** escritos e implementados (framework de capítulos):
  "El heredero", "La subasta", "La cúspide" (Vaultier). Nuevas localizaciones y reparto
  (Vera Lang, el Corredor, Madame Ourense, Vaultier, chivato/contable). Fondos y retratos
  4K generados. Guiones en `capitulos/capitulo_{4,5,6}.md`.
- **Rename a "sOC"** completado (splash, menú, `project.godot`).
- **Test ampliado**: playthrough de Cap.1 + validación estructural de Caps. 2-6 (incl.
  red herrings) → **654 comprobaciones, 0 fallos**.

**Pendiente:** ampliar los diálogos de T2 a los ~5 min del canon; posible Temporada 3.

### 2026-07-09 — Sesión 17 · Temporada 3 completa (Caps. 7-20) · un caso: Nyxos
**Hecho:**
- **14 capítulos nuevos (7-20)** implementados como **un solo caso que escala** hasta
  destapar a la farmacéutica **Nyxos Pharma** (fármaco Somnia). Un sospechoso-peón y ≥1
  **pista falsa** por capítulo; misterio creciente; en el Cap. 20 el culpable es la
  **corporación entera**. Guion **dirigido por datos** (`S3` + `_ch_data_dialogue`,
  ADR-032) para no escribir 84 funciones.
- **Reparto personal de Nora** (ADR-033): Diego (hermano), Sonia (forense), Clara (ex,
  abogada), Rubén (mentor), Marco (excompañero). Dan fondo, revelan pistas y ayudan.
- **Escenarios variados** (ADR-034): centro, barrio alto, otra ciudad, costa, montaña,
  hospital, morgue, laboratorio, planta, consejo, bar... 14 fondos + 7 retratos nuevos a
  **4K** (Real-ESRGAN); azotea corregida para ver el suelo.
- **Test**: playthrough Cap.1 + validación estructural de los **20 capítulos** (locutores,
  fondos, elecciones, pistas falsas) → **1062 comprobaciones, 0 fallos**.
- Docs: `capitulos/temporada_3.md` (visión de 7-20). Constitución y memoria al día.

**Pendiente:** que termine la generación de arte de T3 e importarla; ampliar diálogos de
T2/T3 al canon de ~5 min; mapas propios por escenario (ahora los pines usan el mapa base).

### 2026-07-09 — Sesión 18 · 5 pistas falsas/capítulo, mapas por región, docs 7-20
**Hecho:**
- **5 pistas falsas por capítulo** (los 20): el sistema de pistas admite ahora una lista
  (`"clues"` en el diálogo); cada red herring reparte 5 pistas falsas (`clue.false`) que
  van a "Pistas descartadas". Aviso del HUD adaptado ("N pistas falsas descartadas").
- **Mapas propios por región** (ADR-034): `Story.chapter_map()` + campo `map` por capítulo;
  `CityMap` carga y reconstruye el mapa al cambiar de caso. Generados a 4K: `mapa_centro`
  (zona de negocios, caps. 10-11), `mapa_costa` (14), `mapa_montana` (15), `mapa_ciudad2` (16).
- **Documentos por capítulo 7-20** (`capitulos/capitulo_7.md` … `capitulo_20.md`), además
  del `temporada_3.md` de conjunto.
- **Test**: 20 capítulos + 5 pistas falsas + mapas → **1046 comprobaciones, 0 fallos**.

**Pendiente:** ampliar diálogos de T2/T3 al canon de ~5 min; posible Temporada 4.

### 2026-07-09 — Sesión 19 · Coherencia de arte, fondos/retratos que faltaban, idiomas
**Reglas de arte (obligatorias para todo asset a partir de ahora):**
- **ADR-035 · Fondo del retrato coherente con la ubicación.** El fondo de un retrato
  NUNCA debe contradecir la localización de la escena (p.ej. neones de calle mientras se
  está en la iglesia). Como un mismo retrato aparece en muchas ubicaciones, los retratos
  se generan con un **backdrop neutro oscuro** (degradado ámbar/azul + bokeh suave, sin
  escenografía, sin calle, sin carteles de neón) para que encajen en cualquier lugar. El
  fondo real de la escena lo pone el `bg` de la localización, no el retrato. (`PORTRAIT_HINT`
  en `gen_assets.py`.) *Compositar el fondo de la ubicación tras el busto queda como mejora
  futura (requiere recorte alfa, no disponible en Python 3.14).*
- **ADR-036 · Paleta cromática unificada «mansión».** TODOS los fondos comparten el
  colorido de `mansion.png`: noir pictórico y opulento, **luz ámbar/dorada cálida (araña)
  como luz principal + acentos azul frío de tormenta por los ventanales**, sombras
  profundas, paleta algo desaturada, maderas oscuras y terciopelo, neón contenido (sin
  magenta estridente), grano de película. Es la referencia canónica del *color grade*.
  (`STYLE_SCENE` en `gen_assets.py`.)
- **ADR-037 · Un fondo único por ubicación.** Prohibido que dos localizaciones distintas
  compartan `bg`. Corrección inicial: el interrogatorio del **voluntario** deja de usar
  `refugio` (Fundación Amparo) y pasa a fondo propio **`comedor`**; añadido el fondo
  **`capilla`**. *Aplicado en modo ESTRICTO en la Sesión 20 (31 fondos nuevos): ver abajo.*
- **ADR-038 · Todo personaje que habla tiene retrato.** Añadidos retratos de `voluntario`,
  `contable`, `testigo` y `sospechoso`, y un personaje **`anonimo`** (silueta encapuchada
  «¿?») para notas/soplos anónimos (p.ej. el soplo del río). `narrador` sigue SIN retrato
  por diseño (voz en off).

**Idiomas (ADR-039, formalizado).** El juego está en **español, inglés y chino simplificado**.
Lógica: se usa el idioma del dispositivo si es es/en/zh; **`es` cubre todas las variantes de
español y `zh` todas las de chino**; cualquier otro idioma → **inglés**. Selector manual en
Opciones. Textos base en español; `Global.loc()` traduce contra `assets/i18n/*.json` con
respaldo al español. Fuente CJK vía `SystemFont` (fallback Microsoft YaHei / Noto Sans CJK).

**Otros ajustes:** el «bar del Nano» pasó a fondo propio `bar` (antes usaba `tienda`); la
tienda se reaprovecha para una pista falsa. **Se ocultó el total de pistas** (objetivo y
bloqueos ya no muestran `x/total`) para que no se sepa cuántas faltan.

**Pendiente:** que termine la regeneración de arte con la paleta «mansión» e importarla;
valorar compositar el fondo de ubicación tras el retrato (recorte alfa).

### 2026-07-09 — Sesión 20 · ADR-037 estricto + propiedad intelectual
**ADR-037 aplicado en modo ESTRICTO.** Auditoría completa de las ~129 localizaciones →
mapa ubicación→`bg`. Cada lugar distinto tiene ahora su propio fondo: **31 fondos nuevos**
(`chatarreria`, `trastienda`, `gestoria`, `casa_laura`, `callejon`, `salon_privado`,
`despacho_secretario`, `nave_industrial`, `archivo_medico`, `archivo_becario`,
`azotea_nyxos`, `bufete_clara`, `cafe_ruben`, `puesto_policia`, `sede_regional`,
`ruta_clara`, `clinica_kessler`, `sala_ensayos`, `clinica_clausurada`, `piso_franco`,
`sanatorio_costa`, `balneario`, `puerto_pesca`, `despacho_concejal`, `despacho_abogado`,
`despacho_consejero`, `despacho_rrpp`, `sanatorio_montana`, `cabana_ermitano`,
`local_voluntario`, `tienda_dealer`). Migración verificada por script: 0 colisiones no
intencionales.

**Fondos compartidos permitidos (excepciones documentadas de ADR-037).** Solo cuando es
**la misma ubicación revisitada** o un **plano de establecimiento de región**:
`comisaria` (todas las sesiones en la comisaría: briefings, cierres, soplo, detenidos…),
`morgue`, `hospital`, `iglesia_ext` (atrio = exterior de la iglesia), `mansion` (Vaultier
= «el mecenas»), `redaccion`, `planta` y `oficina` (**sede corporativa de Nyxos**, todas
sus salas/despachos internos), y los planos de región `costa` / `montana` / `ciudad2` /
`centro` reutilizados para escenas a nivel de esa región. Cualquier lugar *concreto* dentro
de esas regiones sí lleva fondo propio.

**ADR-040 · Propiedad intelectual y originalidad.** Todo el contenido de sOC es **original
y ficticio**. No se usan marcas registradas, logotipos, nombres comerciales, personajes,
lugares ni obras protegidas de terceros. Empresas (p. ej. **Nyxos Pharma**), personajes,
ciudades y organizaciones son **invención propia**; cualquier parecido con entidades reales
es casual. En los prompts de arte se exige explícitamente «no readable text, no logos, no
brands»: los rótulos generados son **ilegibles/genéricos**. Las fuentes (Kenney) son de uso
libre; el arte se genera con modelos propios del proyecto vía Pollinations/Real-ESRGAN sin
reproducir obras identificables. Ninguna música/recurso con derechos de terceros se
incorpora sin licencia libre. Esta regla es vinculante para todo el contenido futuro.

**ADR-041 · Selector de idioma con banderas.** En el menú, el idioma se elige con
**banderas** (España, Reino Unido = inglés, China = chino simplificado), no con los nombres
de texto. Se usan **imágenes** PNG (`assets/ui/flag_es|en|zh.png`), porque los emoji de
bandera no se renderizan como banderas en Windows/Godot. `Global.LANG_FLAGS` mapea código→
imagen; cada botón es un icono con **tooltip** que muestra el nombre (`LANG_NAMES`) para
accesibilidad. Las banderas nacionales son de dominio público (coherente con ADR-040).

**Pendiente:** generar los 31 fondos nuevos (van en la tanda de regeneración), importarlos
y validar en el test.

### 2026-07-09 — Sesión 21 · Consistencia de retratos + pipeline
**Plantilla única de retrato (ADR-035 ampliado).** TODOS los retratos usan la misma
plantilla: «Semi-realistic painterly noir character portrait, waist-up bust… <descripción>…
clear well-aligned symmetric eyes with natural gaze… no distortion/deformity/extra fingers…
plain neutral dark studio backdrop». Se eliminó el estilo antiguo mezclado («graphic-novel
illustration» y los prompts mínimos «Head-and-shoulders portrait of X») que hacía que unos
retratos salieran ilustrados y otros no. `anonimo` y `encapuchado` usan una variante sin
rostro (silueta encapuchada, cara en sombra). Nora sigue **rubia con nariz estilizada**.

**ADR-042 · `enhance=OFF` en retratos.** Se descubrió que el parámetro `enhance=true` de
Pollinations (que expande el prompt) daba a las CARAS un look ilustrado y **ojos/rasgos
deformados**. Se desactiva para retratos (`kind == "portrait"` → `enhance=False` en
`poll_fetch`) y se genera a tamaño **nativo 768×1024** antes del upscale ESRGAN x4. En
escenas/fondos `enhance` se mantiene (les sienta bien). Regla vinculante: las caras se
generan sin `enhance`.

**Pendiente:** compilar Windows (`build/sOC.exe`) y Android (`build/sOC.apk`); reanudar la
traducción EN/ZH (quedó en EN 200/1547, ZH 0) cuando baje el rate-limit de Pollinations.

### 2026-07-10 — Sesión 22 · Motor de música generativa (ambiente + misterio)
**ADR-043 · Música generativa por moods (autoload `Music`).** La música dejó de ser un
único pad Am con melodía fija duplicado por escena. Nuevo motor **`scripts/Music.gd`**
(autoload `Music`) que sintetiza en tiempo real (AudioStreamGenerator, sin ficheros):
pad armónico en registro grave con progresión de acordes, sub-bajo, motivo/melodía con
envolvente de «pluck» tipo campana y una capa de aire/ruido filtrado. Todo **dirigido por
datos** en el diccionario `MOODS` con **5 ambientes**: `noir` (melancólico, menú/inicio),
`investigacion` (mapa, suspendido), `misterio` (diálogos, drone frío + notas dispersas),
`tension` (confrontaciones, racimo disonante) y `revelacion` (clímax, grave y resolutivo).
API: `Music.play_mood(name, fade)` / `Music.stop(fade)`. Detalles de diseño: la progresión
se calcula desde el **tiempo absoluto** (fase continua) para que el crossfade entre acordes
sea por amplitud y **sin clics**; el cambio de mood hace un **duck** (baja, intercambia en
silencio, sube) también sin cortes; el motor **persiste entre escenas** (autoload), así la
música no se corta al viajar; y el volumen sigue el ajuste **`music_volume`** (que antes no
tenía efecto). Arranca **en silencio**: solo suena cuando una escena pide un mood, de modo
que la intro (`SplashIntro`, con su audio propio) no se solapa.

**Integración por contexto (tono creciente).** `CityMap` elige el ambiente del mapa según
el capítulo (1-6 `noir`, 7-13 `investigacion`, 14-20 `misterio`) y, al abrir un diálogo,
cruza a uno más íntimo/tenso (1-6 `misterio`, 7-13 `tension`, 14-20 `revelacion`),
volviendo al del mapa al cerrarlo; `_advance_chapter` reevalúa el mood. `MainMenu` suena
con `noir` bajo la tormenta. Se **eliminó** el generador de audio inline de `CityMap`
(`_build_ambient`/`_amb_sample`) en favor del autoload. `SplashIntro` no cambia.

**Verificación.** Import headless sin errores de parseo; sonda de runtime
(`tools/TestMusicProbe.tscn`, carga el proyecto completo con autoloads) confirma que el DSP
**genera audio** y que los cruces entre los 5 moods no producen errores ni muestras fuera de
rango/NaN. Registrado en ADR-006 (audio procedural) como implementación definitiva del audio
musical.

**Pendiente:** reexportar `build/` con el motor de música; afinar mezcla por escena si hace
falta; seguir con la expansión de capítulos 11-20 a canon largo; traducción EN/ZH.

### 2026-07-10 — Sesión 23 · ADR-044 · Dirección visual a ANIME CYBERPUNK-NOIR
**Reorientación del arte a anime cyberpunk-noir (todo el juego).** A petición del usuario,
la dirección artística global pasa de «noir pictórico realista» (look *mansion*) a **anime
cyberpunk-noir**: ilustración anime cel-shaded de alta calidad (Makoto Shinkai × Blade
Runner) **conservando la paleta unificada «mansion»** (clave ámbar/dorada cálida + acentos
azul frío de tormenta, sombras profundas, neón contenido sin magenta estridente, lluvia y
haze). Los retratos ganan ojos anime expresivos con catchlights y linework limpio; los
fondos, escenografía anime de megaciudad neón bajo la lluvia.

**ADR-044 · Estilo anime cyberpunk-noir.** Se reescribieron `STYLE_SCENE` y `STYLE_PORTRAIT`
en `tools/gen_assets.py` (el resto del pipeline —Pollinations/Flux + Real-ESRGAN x4 a 4K,
`enhance=OFF` en retratos por ADR-042— no cambia). Al ser sufijos globales aplicados a
todos los prompts, un solo cambio reorienta los ~106 assets sin tocar los `.md` individuales.

**Backup previo (reversible).** Antes de sobrescribir se copió el arte cyberpunk-noir
realista completo (31 retratos + 75 fondos) a
`assets/_backup_cyberpunk_noir_2026-07-10/`. Para revertir la dirección basta restaurar esa
carpeta y volver a los sufijos anteriores. **Ojo OneDrive:** el backup (~888 MB) sincroniza;
considerar borrarlo o zipearlo tras validar.

**Regeneración.** `python tools/gen_assets.py --force` sobre los 30 retratos + fondos +
mapas + splash/menu. Se descartaron dos ficheros experimentales previos
(`iglesia_ext_anime.png`, `nora_anime.png`) al pasar todo el juego a anime.

**Matiz retratos (enhance=ON en anime).** Los **fondos** salieron anime a la primera, pero
los **retratos** seguían fotorrealistas: con `enhance=OFF` (ADR-042, pensado para el look
realista) Flux ignora las palabras «anime» en las caras. Solución bajo ADR-044: en modo
anime los retratos usan **`enhance=ON`** + un `ANIME_PORTRAIT_LEAD` al frente del prompt
(«Anime cel-shaded illustration, Makoto Shinkai / Kyoto Animation, clean linework,
expressive anime eyes»). Con eso las caras salen cel-shaded, linework limpio y **ojos anime
bien alineados** (la estilización anime tolera el `enhance` que en fotorrealismo dañaba los
ojos). ADR-042 queda **acotado al look realista**; ADR-044 lo invierte para anime.

**Pendiente:** validar visualmente el lote en juego; reexportar `build/`; decidir si se
conserva o elimina el backup en OneDrive.

### 2026-07-11 — Sesión · Diagnóstico OneDrive + caps 11-20 a canon

**Objetivo:** aclarar la sospecha de que OneDrive había dañado retratos/fondos, rehacer el
arte que no gustaba y **acabar completamente los capítulos 11-20**.

**Diagnóstico OneDrive (sin daño).** Se verificaron las 30 portraits y 75 backgrounds:
firma PNG (`89504e47…`) y chunk `IEND` finales correctos en TODAS, tamaños reales en disco
(6-12 MB, no placeholders «cloud-only»). OneDrive **no corrompió** nada; las fechas recientes
son la regeneración a anime (ADR-044), no un daño de sincronización.

**Retratos: selección del usuario.** Se **conservan 17** (adler, anonimo, carmen, contable,
diego, emilio, encapuchado, kessler, laura, madame, magnate, marco, marta, nunez, sonia,
sospechoso, tomas) y se **rehacen 13** (chivato, clara, comisario, corredor, detective, nano,
padre, periodista, rosa, ruben, testigo, vidal, voluntario). Backup previo de fondos + los 13
retratos en `assets/_backup_2026-07-11_pre_anime_regen/`.

**Regeneración anime.** `gen_assets.py --force` sobre **todos los backgrounds + mapas +
splash/menu + los 13 retratos** (87 objetivos) en anime cyberpunk-noir 4K (3840×2160,
Real-ESRGAN x4). Los 17 retratos aprobados quedan intactos (no se pasan como argumento).

**Caps 11-20 a densidad canon (COMPLETADO).** Los diálogos de `S3` en `scripts/Story.gd`
para los caps 11-20 pasaron de esqueleto (~31-35 líneas/cap) a **canon pleno** (~67-90
líneas/cap), al nivel de los caps 8-10: prosa noir sensorial, voz propia por personaje,
monólogos internos (`side:right`) y **2-4 ramas de elección** por capítulo. Cada
`capitulos/capitulo_N.md` (11-20) reescrito a documento de diseño completo (~5-6.7 KB).
Trabajo repartido en 10 subagentes (uno por capítulo) e integrado por splice de líneas.

**Invariantes preservados (verificado).** Los campos que gobiernan la progresión
—`bg`, `flag`, `clue`, `clues` (5 falsas), `revisit`— se conservan **carácter por carácter**
en los 60 ids (script `verify_frozen.py`: 0 diferencias), de modo que las puertas `clues4`
(que comparan títulos de pista por texto exacto) siguen funcionando. Validación en Godot 4.7:
importación de editor headless completa con **0 errores de script**.

**Pendiente:** terminar el lote de regeneración anime (en curso al cierre de la sesión) y
validarlo visualmente en juego; reexportar `build/`; decidir si se conservan los backups en
OneDrive (`_backup_cyberpunk_noir_2026-07-10` ~888 MB + `_backup_2026-07-11_pre_anime_regen`).

### 2026-07-11 (tarde) — Anime en escenas, Cap. 0 tutorial, animaciones y UI

**ADR-045 · Escenas anime de verdad (lead al frente + enhance OFF).** La primera regeneración
anime dejó los RETRATOS en anime pero las ESCENAS salían fotorrealistas (splash/menu incluidos,
con magenta que el estilo prohíbe). Causa: `STYLE_SCENE` iba como SUFIJO (poco peso) y `enhance=ON`
hacía que el reescritor de Pollinations tirase a foto cinematográfica. Solución en `gen_assets.py`:
nuevo `ANIME_SCENE_LEAD` **al frente** del prompt (como el `ANIME_PORTRAIT_LEAD`) + **`enhance=OFF`
en escenas**. Validado en splash+menu (pasan a anime pintado key-visual) y aplicado al resto de
fondos (regeneración en background al cierre de sesión).

**Retrato vidal rehecho.** El usuario descartó una variación de `vidal` y se regeneró (semilla nueva
por proceso) hasta un look anime/manga que aprobó. Recordatorio operativo: tras regenerar arte hay
que **reimportar** en Godot (editor headless) o el juego sigue mostrando el `.ctex` cacheado viejo.

**Capítulo 0 · TUTORIAL (nuevo).** Se añadió un capítulo 0 que enseña el bucle de juego con un
«caso de prácticas», con la MISMA estructura que un caso real (brief → pista A → red herring →
pista B → lugar clave `clues4` → cierre). Enseña: mapa encadenado, objetivo, pistas→libreta,
pistas falsas descartadas, puerta por pistas, informar en comisaría, autoguardado. Guía: Núñez +
Nora (con guiño meta al jugador). Cambios: `CH0_LOCATIONS`/`CH0_STREET`, `CHAPTERS[0]`, ruta de
`get_dialogue` (chapter 0 → `_ch_data_dialogue`), bloque `S3` (brief0/l0a/rh0/l0b/fin0/cierre0),
y `Global.reset_case()` ahora arranca en **chapter 0** (nueva partida). `done_cierre0` pasa al Caso 1.
Reutiliza fondos existentes (comisaria, plaza, callejon, tienda, archivo). Compila limpio.

**Animaciones de mapa (`scenes/CityMap.gd`).**
- *Viaje de Nora*: la ficha viaja del origen al destino con una **estela** (`Line2D`) que crece y se
  desvanece, un **pulso de escala** de la ficha y un **aro** que se expande en el destino.
- *Pista → libreta*: al terminar una escena con pista, una **tarjeta** vuela desde el centro hasta el
  botón de la libreta (verde/ámbar ✓ para pista buena, con pulso del icono; roja ✗ para falsa, que se
  desvanece por el camino porque se descarta). Se guardó `_nb_btn` para el destino.

**Iconos UI a anime.** `ic_libreta.png` y `ic_menu.png` se rehicieron (script PIL) de cian neón a
**line-art ámbar cálido con glow** (paleta `COL_WARM`), coherentes con el arte anime. Fondo
transparente; pendiente reimportar con el lote de fondos.

**Consultas de diseño resueltas (sin implementar aún):**
- *Voces*: recomendado **voice-blips generativos** por personaje (encajan con `Music.gd`) + quizá
  4-5 frases dobladas reales en momentos cumbre. TTS genérico para todo: NO (suena robótico).
- *Anuncios*: recomendado **intersticial entre capítulos** + **rewarded opcional** (AdMob/Android,
  integración aparte); posible product placement diegético en las vallas/hologramas del arte. Nunca
  banners fijos ni cortes a mitad de diálogo. Se pueden dejar los puntos de corte preparados.

**Voice-blips (implementado).** Voz estilizada por personaje (Ace Attorney/Undertale): `Global.gd`
sintetiza UNA vez un blip corto (cuadrada+seno, caída rápida) y lo reproduce por carácter con
`pitch_scale` según `VOICE_PITCH` (graves hombres mayores, agudos voces jóvenes/femeninas; hash
estable para los que falten). `DialogueScene._emit_blips` dispara 1 cada 3 chars saltando
espacios/puntuación; el narrador no lleva voz. Sin ficheros, encaja con el audio generativo.
Doblaje real de 4-5 frases cumbre = pendiente manual (grabación).

**Anuncios (decisión).** Serán **Google AdMob**, solo Android, y se dejan **para cuando toque**
(no implementado). Encaje recomendado: intersticial entre capítulos (en `CityMap._advance_chapter`,
cap de 1 cada 2-3 casos, nunca 0→1 ni en escena) + rewarded opcional (utilidad: pista/localización);
banner descartado. Requiere plugin AdMob + App/unit IDs + consentimiento UMP. Wrapper `Ads.gd` con
no-ops fuera de Android, para futuro.

**Mantenimiento (2026-07-11).** OneDrive **detenido** (`OneDrive.exe /shutdown`) para sincronizar con
todo estable. **Limpieza profunda** (~4,3 GB liberados): borrados los dos `_backup_*` (1,64 GB),
`build/` desactualizado (1,5 GB), `__pycache__`, y purga+reimport limpio de `.godot` (1,9 GB → 678 MB).
Regen anime de TODOS los fondos completada (72/72, 0 fallos; 74 válidos). Reimport limpio validado
(2ª pasada sin errores). Proyecto de ~6 GB a ~2,9 GB.

**Pulido de tutorial y UI (2ª ronda).**
- *Cap. 0 más guiado*: los diálogos ahora PRESENTAN a los personajes al aparecer («Ese es el sargento
  Núñez», «Ella es Nora Vega, la protagonista») y dicen EXPLÍCITAMENTE qué tocar en cada paso. En el
  MAPA: barra de objetivo con instrucción paso a paso (`_tutorial_objective`), pines disponibles que
  PARPADEAN (`_set_pin_pulse`), y un COACH MARK (flecha ámbar que rebota + cartel «¡Empieza aquí! Toca
  la Comisaría») que señala el pin a tocar (`_build_coach`/`_update_coach`/`_tutorial_target_pin`).
- *Animación pista→libreta corregida*: antes se desvanecía por el camino; ahora el elemento que vuela
  es el ICONO de la libreta DIFUMINADO (semitransparente) y LLEGA de verdad al botón (verde/ámbar ✓
  con pulso; rojo ✗ para falsa). 
- *Estela de viaje eliminada*: quitada la línea azul (`Line2D`) del desplazamiento de Nora; se conservan
  el aro del destino (`_ping_at`) y el pulso de la ficha.
- *Splash legible*: la frase inferior y el título llevan CONTORNO negro + sombra + un velo oscuro
  degradado en el tercio inferior (el fondo anime brillante los dejaba ilegibles).
- *Naming (decisión del usuario)*: la protagonista es **Nora Vega** (con g). **Núñez la llama SIEMPRE
  «detective Vega»**, nunca «Nora»: se cambiaron sus 32 líneas con «Nora» a «detective Vega» (mayúscula
  al inicio de frase, minúscula en vocativo) + tutorial + final. Solo Núñez usa esa fórmula. «Vera» es
  otra personaje (Vera Lang, la periodista): no confundir.

**ADR-046 · Optimización de tamaño (texturas Lossy) + builds.** El peso lo marcaba el modo de
importación **Lossless** de las texturas. Se pasaron los 104 fondos+retratos a **Lossy WebP q0.88**
(`compress/mode=1` en sus `.import`), MANTENIENDO el 4K. El arte importado (`.godot/imported`, lo que va
en el build) cayó de **678 MB → 52 MB** sin pérdida visible. Resultado de los builds (v0.3.x):
- **Windows** `build/sOC.exe` (release, 4K): **~756 MB → 155 MB**.
- **Android** `build/sOC.apk` (debug firmado, arm64+arm32): **~707 MB → 106 MB** — instalable directo por
  los 12 testers.
Los másters PNG 4K siguen en `assets/` (para escritorio/regeneración).

**Android a 1080p (hecho, 2026-07-13).** Godot no reescala por plataforma, así que el build Android usa un
swap temporal: `tools/set_texture_size_limit.py 1920` → reimport → export APK → `set_texture_size_limit.py 0`
→ reimport (restaura 4K). Encapsulado en **`tools/build_android.ps1`** (un solo comando, con revert
garantizado en `finally`). Resultado: **APK 1080p = 79 MB** (vs 106 MB en 4K; vs ~707 MB original) — menor
descarga y **mucha menos RAM/VRAM** en móviles de gama baja de los testers. Windows sigue en 4K (155 MB).
Verificado además que `build/sOC.exe` **arranca en runtime** (no solo exporta): la opción Lossy funciona.
Tooling verificado: plantillas 4.7, SDK Android, keystore debug y `editor_settings-4.7.tres`.

**GitHub (2026-07-13).** Repo inicializado y subido a **https://github.com/donki/sOCTheGame** (rama
`main`, commit inicial). Se añadió **README** (acorde al estado real: 20 casos + tutorial, anime,
Godot 4.7, scripts de build) y **LICENSE MIT** (código; assets Kenney CC0; ver CREDITS). Decisión: el
`.gitignore` excluye `build/`, `.godot/`, `.claude/`, backups y **el arte generado por IA**
(`assets/backgrounds/`, `assets/portraits/`) — por peso y por licencia ambigua del servicio de
generación; se regenera con `tools/gen_assets.py`. Repo resultante: **541 ficheros, ~4 MB** (código +
prompts + tooling + assets pequeños Kenney/UI/i18n + docs). `git` ya autenticado como `donki` (GCM).

**Pendiente:** validar los builds en dispositivo real (Windows OK; falta un Android físico); reabrir
OneDrive cuando el usuario quiera; si se quiere, subir el arte al repo (o a releases/LFS) aparte.

### 2026-07-13 (tarde) — Prototipo de interactividad en el Cap. 0 (5 mecánicas)

Se añadieron **5 mini-escenas jugables** como prototipo, encadenadas en el tutorial (Cap. 0), cada
una en su localización, con una vista propia (`scenes/*View.gd`, `class_name`, `signal finished(result)`,
`func start(data)`), que aplican clue+flag y emiten `finished` igual que `DialogueView`:
1. **Búsqueda por hotspots** (`SearchView`) — Plaza (l0a): tocar zonas del escenario para hallar la pista.
2. **Examinar objeto** (`ExamineView`) — Callejón (rh0): zoom (+/−/rueda) + arrastre; detalle oculto.
3. **Mini-puzzle** (`PuzzleView`) — Tienda (l0b): teclado/código para abrir un cajón.
4. **Presentar prueba** (`PresentView`) — Interrogatorio (l0c): pillar la mentira + presentar la pista que la refuta.
5. **Deducción** (`DeduceView`) — Archivo (fin0): unir pistas → conclusión correcta.

Integración: `Story.INTERACT` (datos por id) + `has_interact`/`interact_data`; `CityMap._open_dialogue`
enruta la PRIMERA visita a la vista (revisita = diálogo de S3) vía `_make_interaction`; Cap. 0
reestructurado a 7 pasos (brief0→l0a→rh0→l0b→l0c→fin0→cierre0) con coach/objetivo por mecánica.
Contrato compartido en `scratchpad/INTERACT_SPEC.md`; escritas por 5 subagentes en paralelo e integradas.
**Validado:** compila 0 errores + prueba de runtime (instanciar cada vista y `start()` con datos reales)
que cazó y arregló un bug (`PuzzleView._style_text` sin definir). Las 5 arrancan sin crashes.

**Pendiente:** jugar el tutorial a mano para afinar dificultad/feedback; si gusta, llevar estas mecánicas
a casos reales (son data-driven vía `INTERACT`, escalan sin tocar motor); reexportar builds.

### 2026-07-13 (noche) — Identidad de serie, subtítulo y pulido de UX

**sOC es una SERIE de juegos.** Título: **sOC**. **Subtítulo oficial de la serie: «La ciudad esconde
algo bajo la lluvia.»** — se muestra con peso (ámbar, contorno, grande) bajo el título «sOC» en el
**menú principal** (`scenes/MainMenu.gd`, font 33) y en el **splash** (`scenes/SplashIntro.gd`, font 34;
antes decía «La ciudad llama a los suyos…»). Cada entrega de la serie será un caso/temporada bajo este
paraguas; mantener el subtítulo y la estética anime cyberpunk-noir como sello común.

**Pulido de esta ronda:**
- **Voice-blips DESACTIVADOS** (`DialogueScene._emit_blips` → no-op): sonaban mal. El motor de voz de
  `Global` queda latente por si en el futuro se hacen blips mejores o doblaje real.
- **Frase de Nora** en el tutorial: «La que se va a patear cada caso hasta el fondo, caiga quien caiga»
  (antes decía «el barrio»; se evita porque hay muchos escenarios: costa, montaña, otra ciudad…).
- **Búsqueda (SearchView)**: el «?» de las zonas se cambió por un **punto ámbar sutil con halo** (marca
  sin destacar). Se mantiene la ayuda progresiva (al fallar, la zona correcta se realza).
- **Fondo del menú** regenerado (anime cyberpunk al atardecer, cielo despejado arriba para el título).
- **Fondos opacos** en las mini-escenas Deduce/Present/Puzzle (les faltaba la base opaca → se veía el
  mapa a través) + `z_index` alto de las interacciones sobre el HUD del mapa. Coach-mark: se oculta al
  viajar y su cartel es neutro de género («Toca aquí ▸ %s»).

**Pendiente:** compactar el layout de la escena de Deducción (cartel muy grande, tarjetas recortadas);
jugar el tutorial completo a mano; llevar las mecánicas a casos reales si convencen; reexportar builds.

### 2026-07-13 (noche) — Marco cinematográfico fiable, zoom de escena en TODO el juego y pinch Android

**Marco cinematográfico (el que «no salía»):** el enfoque por *shader* de viñeta fallaba silenciosamente
en la GPU (con `ColorRect` blanco tapaba; con color transparente de seguridad, desaparecía). Se sustituye
por una **textura de viñeta** `assets/ui/frame_vignette.png` (RGBA 640×360, negro con alfa que decae ~6.5%
en X y ~11.5% en Y hacia el centro), mostrada como `TextureRect` a pantalla completa (`STRETCH_SCALE`,
`MOUSE_FILTER_IGNORE`). 100% fiable, sin shaders. Transición **negro → imagen** sin línea de color, como
se pedía. Aplicada en `SearchView`, `PuzzleView`, `PresentView`, `DeduceView` **y ahora en `DialogueScene`**.

**Zoom de escena en TODAS las escenas de todos los capítulos:** `DialogueScene` (el reproductor único de
todos los diálogos del juego) ahora permite **ampliar el fondo** con rueda del ratón, botones **+/−**
discretos (arriba-derecha, aparecen con el nivel `×N`) y **pinch de 2 dedos en Android**. Paso de zoom
**0.1** (rango 1.0–2.6). Con zoom>1 el **arrastre desplaza** el fondo (clamp para no revelar bordes). Se
reescribió `_input` con desambiguación **tap vs arrastre**: el avance del diálogo pasa a producirse al
**soltar** un toque limpio (sin arrastre) — así arrastrar para desplazar ya no avanza el texto. Los clics
sobre los botones de zoom se dejan pasar (no roban el toque). El zoom se **resetea en cada localización**
(`_apply_bg`). El fondo escala desde su centro (`pivot_offset`).

**Pinch en el tablero (`EvidenceBoard`):** además de +/− y arrastre de un dedo, ahora hay **pinch de 2
dedos** (se rastrean los `InputEventScreenTouch/Drag` por `index`; la razón de distancias escala el zoom
sobre el zoom base al iniciar el pinch). Zoom sigue en pasos de 0.1 con los botones.

**Salvaguarda de carga:** `Global.load_game` filtra `met_chars` descartando claves que ya no existan en
`Story.CHARS`, para que el tablero dinámico nunca reciba una clave inválida de un save antiguo (posible
causa del «al cargar la partida ha petado» junto con la clase `EvidenceBoard` que estuvo rota).

**Verificado:** editor headless sin errores de script; captura real de `DialogueScene` con marco visible
(viñeta negra fundiéndose a la escena) y zoom ×1.6 aplicado.

**Pendiente:** compactar el layout de la escena de Deducción; jugar el tutorial completo a mano; reexportar
builds (Windows 4K / Android 1080p) tras esta tanda.

### 2026-07-14 — Fuera zoom de escena; DENTRO búsqueda interactiva en casos reales

**Revertido el zoom de escena** en `DialogueScene` (botones +/−, rueda, pinch, pan y la reescritura de
`_input`): el usuario lo vio innecesario en las escenas de diálogo. **Se conserva el marco cinematográfico
(viñeta-textura)**. `_input` vuelve al tap simple para avanzar.

**Escenas de BÚSQUEDA interactiva en casos reales (como el Cap 0):** era lo que faltaba. Mecanismo
data-driven y de bajo riesgo:
- **Encadenado búsqueda → diálogo** (`CityMap`): la primera visita a una localización con `INTERACT`
  abre su mini-escena; si la entrada lleva `then_dialogue: true` (búsquedas de casos reales), al terminar
  se **reproduce el diálogo existente** de esa localización. Así no se pierde la narrativa: buscas la
  pista en el escenario y luego hablas con quien toque. Nuevo `_open_dialogue_view` + `_on_interaction_finished`.
- **Sin romper el gating de pistas:** la búsqueda añade una pista **atmosférica** (título propio, NO en
  `CHx_STREET`), así que `street_clues_count()`/`clues4` no se altera; las pistas de calle siguen
  llegando por los diálogos. La búsqueda pone `searched_<id>` (no reabre en revisitas); el diálogo pone
  `done_<id>`. Ids verificados únicos por capítulo (INTERACT se indexa por id sin capítulo).
- **Escenas añadidas (Temporada 1):** Cap 1 `plaza` (huellas en el barro) y `casa_marta` (la taza a
  medias); Cap 2 `refugio` (registro tachado) y `capilla` (cera fresca); Cap 3 `mansion` (vitrina con
  un hueco) y `sotano` (arañazos en la puerta). Cada una con 4 zonas (1 correcta + 3 señuelos con texto).

**Verificado:** editor headless 0 errores; captura real de `SearchView` con datos de `casa_marta`
(fondo correcto, barra, contador 0/4 y marco). SearchView ya registra pista+flag en `_finish`, así que el
encadenado no pierde la pista.

**Pendiente:** si convence, extender búsquedas a Temporada 2 y 3 (mismo patrón, solo añadir entradas
`INTERACT` con `then_dialogue`); afinar posiciones de zonas mirando cada fondo; reexportar builds.

### 2026-07-14 (cont.) — Botón "Saltar tutorial", saltar diálogo en revisitas y búsquedas en T2/T3

**1) Botón "Saltar tutorial" (`CityMap`).** Mini-botón en el HUD superior, **solo visible en el Cap. 0**
(`_skip_btn.visible = Global.chapter == 0`, reforzado en `_refresh`). Pide confirmación
(`ConfirmationDialog`: "¿Saltar el tutorial y empezar el primer caso?" · Saltar / Seguir) y, al aceptar,
`_skip_tutorial()` marca `cap0_completo` + `done_cierre0` y llama a `_advance_chapter()` (0→1, reconstruye
el mapa y guarda). Evita saltos accidentales.

**2) Saltar diálogo en REVISITAS (`DialogueScene`).** Si la escena YA se había completado antes
(`_is_repeat = Global.has_flag(dialogue.flag)` al empezar), aparece un botón discreto **"Saltar ⏭"**
(arriba-derecha). `_skip_to_actions()` descarta los beats de narración **hasta la primera decisión
(`choices`) o el final** — así en las revisitas se pasa la parte ya vista y se llega directo a las acciones;
si no hay decisiones, cierra la escena. En la PRIMERA vez no aparece (se juega entera). `_input` deja pasar
el clic/toque que cae sobre el botón (si no, el tap se consumiría para avanzar). Verificado: botón creado
solo en revisita, salto sin crash, y captura real con "SALTAR ⏭" visible.

**3) Búsqueda interactiva extendida a Temporada 2 y 3.** Mismo patrón `then_dialogue` (búsqueda atmosférica
→ diálogo existente), **17 escenas nuevas**, una por capítulo, en su localización-escena principal:
- **T2:** Cap 4 `escena4` (el lacre en el suelo), Cap 5 `trastienda` (el cuaderno de pujas), Cap 6
  `coartada` (la escalera a la azotea).
- **T3:** Cap 7 `l7a` morgue · Cap 8 `l8a` piso_diego · Cap 9 `l9a` bufete_clara · Cap 10 `l10a`
  laboratorio · Cap 11 `l11a` barrio_alto · Cap 12 `l12a` redaccion · Cap 13 `l13a` archivo_medico ·
  Cap 14 `l14a` costa · Cap 15 `l15a` montana · Cap 16 `l16a` ciudad2 · Cap 17 `l17a` bar_clara · Cap 18
  `l18a` oficina · Cap 19 `l19a` oficina (Adler) · Cap 20 `l20a` consejo.
- Generadas por script (`scratchpad/gen_search.py`) e insertadas en `INTERACT`. `bg` de cada una tomado
  del diálogo real (S3 / funciones), todos los PNG verificados. **Ningún título atmosférico colisiona con
  `CHx_STREET`** (comprobado) → gating `clues4` intacto; las pistas de calle siguen viniendo de los diálogos.
- **Total de escenas de búsqueda en casos reales: 6 (T1) + 17 (T2/T3) = 23.**

**Además:** se quitó la frase "toca las zonas marcadas" de todos los intros (T1 incluida, tutorial y default
de `SearchView`), por indicaciones inmersivas ("¿qué desentona?", "algo se salió de la rutina"...). Las
zonas mantienen su marca ámbar sutil + la ayuda progresiva al fallar.

**Verificado:** editor headless 0 errores; sin colisiones de títulos; capturas reales de `SearchView`
(casa_marta) y del botón "Saltar ⏭".

**Pendiente:** afinar posiciones exactas de las zonas mirando cada fondo (ahora son plausibles + ayuda
progresiva); si se quiere, variar mecánica (examine/puzzle) en algún capítulo para no repetir siempre
búsqueda; reexportar builds.

### 2026-07-14 (cont.) — Rosa envejecida (retrato)

**Cambio de coherencia de personaje.** El retrato de Rosa (la vecina que vigilaba la puerta de la
iglesia, testigo del barrio) se veía demasiado joven para su rol. Se reescribió `prompts/portraits/rosa.md`
para describirla como mujer mayor (~65-70 años): pelo canoso/plateado recogido en moño, rostro curtido con
arrugas y líneas de expresión, mirada cansada pero digna, piel con manchas de edad. Se mantuvo el resto
(busto 3:4, estilo anime cel-shaded cyberpunk-noir, iluminación neón, pañuelo/vestido verde del barrio).
Regenerado con `python tools/gen_assets.py --force rosa` (Pollinations + Real-ESRGAN x4 → 2400x3200) y
reimportado en Godot (`--headless --import`, `.ctex` actualizado). Solo se tocó `rosa`; ningún otro retrato.

### 2026-07-14 (cont.) — Doña Carmen regenerada (retrato)

**Nueva toma del retrato.** Se regeneró el retrato de Doña Carmen (la vecina mayor que guarda los secretos
del barrio) para una versión distinta y más coherente con su rol. Se reforzaron los rasgos en
`prompts/portraits/carmen.md`: anciana digna (~80 años) de pelo blanco recogido en moño, rostro sabio,
curtido y arrugado, chal oscuro sobre los hombros y mirada penetrante que "lo sabe todo". Se mantuvo el
encuadre busto 3:4 y el estilo anime cel-shaded cyberpunk-noir con iluminación neón. Regenerado con
`python tools/gen_assets.py --force carmen` (Pollinations + Real-ESRGAN x4 → 2400x3200) y reimportado en
Godot (`--headless --import`). Solo se tocó `carmen`; ningún otro retrato.

### 2026-07-14 (cont.) — Voluntario regenerado (retrato)

**Nueva toma del retrato.** Se regeneró el retrato del voluntario del comedor social (pista falsa / red
herring del Cap. 2: un ratero que roba monedas del cepillo para su madre, no el criminal). Se reforzaron
los rasgos en `prompts/portraits/voluntario.md`: hombre joven-adulto de aspecto humilde, mirada esquiva y
nerviosa que rehúye al espectador, hombros encogidos por la tensión, sudor frío en la frente, culpa y
vergüenza, ropa sencilla y raída de voluntario (tabardo barato sobre sudadera gastada), e iluminación noir
de neón. Se mantuvo el encuadre busto 3:4 y el estilo anime cel-shaded cyberpunk-noir. Regenerado con
`python tools/gen_assets.py --force voluntario` (Pollinations + Real-ESRGAN x4 → 2400x3200) y reimportado
en Godot (`--headless --import`); imagen distinta del backup. Solo se tocó `voluntario`; ningún otro retrato.

### 2026-07-14 (cont.) — Búsqueda sin pistas visibles + marcas sobre objetos reales; pulido varios

**Búsqueda (`SearchView`) rediseñada:** las marcas ya NO se ven al inicio (`modulate.a = 0`); se buscan de
verdad tocando los objetos del escenario. **Revelado por tiempo**: a 1 min pasan a 15% de opacidad (85%
transp., `REVEAL_A1`) y a 2 min a 20% (`REVEAL_A2`), vía `_process` + `_reveal_marks`. Se **eliminó** la
ayuda al fallar (`_hint_target` y `_hinting`). El TUTORIAL usa `"show_marks": true` para verlas desde el
principio (enseña la mecánica).

**Marcas sobre objetos reales (las 23 escenas):** se revisó cada fondo y se recolocó el target (+ textos de
zona) sobre el objeto que describe la pista. Donde el objeto inventado no existía en el arte (exteriores
como costa/montaña/barrio_alto), se **adaptó la pista** a lo que sí se ve (barca sospechosa junto al muelle,
sanatorio aislado en lo alto, coche de gama alta sin matrícula). Scripts de reposicionamiento en
`scratchpad/fix_t1.py` y `fix_t23.py`. Nota: las marcas son tenues por diseño (15–20%); el jugador explora
tocando los objetos, que ahora coinciden con el target.

**Pulido:**
- **Botón "Saltar tutorial"**: ahora es un ICONO acorde (`assets/ui/ic_saltar.png`, ▶▶│ ámbar+rojo con glow,
  al estilo de `ic_libreta`/`ic_menu`), sin texto.
- **Animación pista→libreta**: se reduce la escala final del icono volador (0.5→0.34) para que quede DENTRO
  del botón de la libreta (antes lo sobrepasaba).
- **Título del capítulo en el mapa**: usa la fuente de los diálogos (`FONT_BODY_PATH`, Kenney Future) en vez
  de la de títulos.
- **"Caso N" → "Capítulo N"** en los 20 capítulos (`CHAPTERS`): es un único caso que abarca toda la serie.
- **"Nadia Kovač" → "Nadia Kovac"**: la `č` (c con háček) no la representa la fuente Kenney y salía como
  carácter raro; se sustituye por `c` simple (2 ocurrencias).

**Verificado:** editor headless 0 errores; captura de `casa_marta` confirmando que el target cae sobre la
taza de la mesita.

### 2026-07-14 (cont.) — Versionado yyyy.MM.dd.N y VOCES por personaje (build v2026.07.14.2)

**Versionado (ADR-025 rev.):** `config/version` pasa a **`yyyy.MM.dd.N`**. `tools/build.ps1` fija la fecha
de hoy y **cada compilación incrementa N**; N se reinicia a 1 al cambiar el día. Migra solo desde el
esquema antiguo `x.y.z`. `project.godot` migrado a `2026.07.14.1`; primer build del día → `2026.07.14.2`.

**Voces por personaje (reactivadas y mejoradas).** El sistema de voice-blips estaba desactivado porque
"sonaba mal" (un único blip cuadrado+seno pitcheado: todos sonaban igual, metálico). Rehecho en
`Global.gd`: cada personaje tiene una **voz distinta de verdad** — no solo tono, sino **timbre propio**.
`_voice_params(who)` deriva `[f0, ratio de formante (color vocal), zumbido, caída]` del tono curado
(`VOICE_PITCH`) + hash estable del nombre; `_blip_for(who)` sintetiza y **cachea** un WAV por personaje
(seno fundamental + formante + algo de cuadrada, con ataque 4 ms + caída exponencial → suena a voz, no a
pitido). `play_voice` reproduce el blip del hablante con micro-variación de tono. `DialogueScene._emit_blips`
reactivado: un blip cada 3 caracteres al escribir (salta espacios; el narrador no lleva voz). Flag
`Global.voices_enabled` por si se quiere silenciar. Verificado: 10 personajes → 10 voces con checksum único
(Núñez grave/áspero, Rosa aguda de anciana, Sonia la más aguda, Adler limpia...).

**Build:** `pwsh tools/build.ps1` → `build/sOC.exe` **v2026.07.14.2** (162 MB). `build/` está gitignorado.

---
*Fin del documento. Recordatorio: actualizar secciones 5–7 y añadir entrada en la
Bitácora en cada avance.*
