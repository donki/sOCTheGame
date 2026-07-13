# Prompts de assets — **sOC the Game** (novela visual + mapa)

El juego pasó de ARPG de movimiento a **novela visual de misterio**: escenas de
diálogo entre personajes sobre fondos de localización, y un **mapa de la ciudad**
por el que el jugador marca a dónde ir. Estos son los prompts para generar el
arte con IA (**Google AI Plus / Gemini**, o cualquier generador). Cada archivo es
autónomo (incluye el estilo común) para poder generar **de uno en uno**.

## Qué hay que generar y **dónde va cada archivo**
El código busca los PNG en rutas exactas. Respétalas (el juego funciona sin ellas
—usa retratos-silueta y mapa dibujado por código— pero se ven mucho mejor con arte).

### 1. Retratos de personajes → `assets/portraits/<id>.png`
Busto de novela visual, fondo transparente. `id` exacto:

| id | Personaje | Archivo de prompt |
|----|-----------|-------------------|
| `detective`   | La Detective (protagonista) | `portraits/detective.md` |
| `emilio`      | Don Emilio (vecino anciano) | `portraits/emilio.md` |
| `rosa`        | Rosa (vecina, vigilaba la puerta) | `portraits/rosa.md` |
| `tomas`       | Tomás (tendero) | `portraits/tomas.md` |
| `carmen`      | Doña Carmen (anciana enigmática) | `portraits/carmen.md` |
| `nunez`       | Sargento Núñez (comisaría) | `portraits/nunez.md` |
| `marta`       | Marta Soler (la desaparecida) | `portraits/marta.md` |
| `encapuchado` | El encapuchado (misterio) | `portraits/encapuchado.md` |

### 2. Fondos de escena → `assets/backgrounds/<clave>.png`
Ilustración panorámica 16:9. `clave` exacta:

| clave | Localización | Archivo de prompt |
|-------|--------------|-------------------|
| `plaza`       | Plaza del Barrio (llegada) | `backgrounds/plaza.md` |
| `casa_emilio` | Casa de Don Emilio | `backgrounds/casa_emilio.md` |
| `iglesia_ext` | Iglesia de San José, exterior | `backgrounds/iglesia_ext.md` |
| `iglesia_int` | Campanario (interior) | `backgrounds/iglesia_int.md` |
| `tienda`      | Tienda de Tomás | `backgrounds/tienda.md` |
| `casa_carmen` | Casa/balcón de Doña Carmen | `backgrounds/casa_carmen.md` |
| `comisaria`   | Comisaría | `backgrounds/comisaria.md` |

### 3. Mapa de la ciudad → `assets/backgrounds/mapa.png`
Prompt en `map/mapa.md`. Plano ilustrado del Barrio Viejo (los pines los pone el juego encima).

## Estilo común (va incluido en cada prompt)
Ilustración **noir de novela gráfica**: noche urbana lluviosa, luz cálida de
farola con un tenue acento rojo, alto contraste, pintado con grano de película
sutil, mismo estilo en todo el juego.

## Flujo con Google AI Plus / Gemini
1. Abre <https://gemini.google.com> (con AI Plus tienes el modelo de imagen) o
   AI Studio. Pega el prompt en inglés del archivo correspondiente.
2. Descarga el PNG y **renómbralo con el `id`/`clave` exactos** de las tablas.
3. Guárdalo en `assets/portraits/` o `assets/backgrounds/` según toque.
4. Para retratos, si el fondo no salió transparente, quítalo en **SpriteManager**
   (color-key + flood-fill) y exporta. Reimporta en Godot.

## API key (recordatorio de seguridad)
La API key va **solo** en tu máquina (config local de SpriteManager). Nunca en el
repositorio, en git, ni pegada en un chat. Si se expuso, **revócala y genera otra**
en AI Studio.

---
> `npc_capitulo1/` (carpeta anterior) contiene los prompts de **hojas de 4 vistas
> para el movimiento** (versión ARPG). Quedan como referencia histórica; para la
> novela visual usa los retratos de `portraits/`.
