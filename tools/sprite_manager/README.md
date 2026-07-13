# SpriteManager — gestor y editor de sprites de *sOC the Game*

App local (Flask + Pillow) para **revisar, recortar y limpiar** los sprites del
juego, con **opciones manuales y automáticas** y un **asistente IA** conectado a
build.nvidia.com que puede *ver* el sprite y recomendar ajustes.

## Arrancar
Dos formas:
- **Ejecutable** (no necesita Python): doble clic en `SpriteManager.exe`.
- **Python**: `tools\sprite_manager\run.bat` (o `python app.py`).

Abre <http://127.0.0.1:5000>. Edita directamente los PNG de `assets/` del juego,
así que al re-importar en Godot verás los cambios.

> El `.exe` busca `assets/` así: `assets_dir` de `config.json` → `..\..\assets`
> desde el exe → sube directorios hasta un `project.godot` con `assets/` al lado.
> El `config.json` **junto al exe** (con tu API key) tiene prioridad sobre el
> embebido de plantilla. Recompilar: ver el comando PyInstaller abajo.

## Compilar el .exe
```
python -m pip install pyinstaller
cd tools\sprite_manager
python -m PyInstaller --onefile --name SpriteManager --console ^
  --add-data "static;static" --add-data "config.json;." app.py
```
(el `.exe` queda en `dist\`; cópialo junto a `config.json`).

## Qué hace
**Galería**: carpetas (`people`, `detective_frames`, `buildings`, …) sobre fondo
a cuadros para ver la transparencia. Clic en un frame para editarlo.

**Manual** (sobre el frame seleccionado):
- Auto-recortar margen transparente · Defringe (erosiona el halo claro)
- Recortar lados (T/B/L/R) · Quitar fondo (umbral v/sat) · Color-key (tolerancia)
- Voltear H · **Goma** (pinta para borrar píxeles) + Guardar · Borrar frame

**Automático** (re-recortar una hoja entera):
- `characters.png`, `detective.png` → recorte por bandas + columnas + limpieza
- `npcs.png`, `citypack_1/2.png` → recorte automático por *blobs* (cada elemento)
- Parámetros: pasadas de defringe, umbrales de fondo, tamaño/tolerancia de blob
- Botón para **borrar los `tile_*.png`** sueltos

**Asistente IA (NVIDIA)**: chat que, con "incluir frame actual", envía la imagen
a un modelo de visión y te dice qué operación aplicar (defringe, recorte, etc.).

## Configuración
`config.json` (NO se sube a git):
```json
{
  "nvidia_api_key": "nvapi-...",
  "base_url": "https://integrate.api.nvidia.com/v1",
  "text_model": "meta/llama-3.1-70b-instruct",
  "vision_model": "meta/llama-3.2-11b-vision-instruct"
}
```
> ⚠️ La API key es privada. Si se ha compartido, **rótala** en build.nvidia.com.

## Flujo típico
1. Abre la carpeta `people` y revisa los frames.
2. Selecciona uno con problema → aplica *Defringe* / *Auto-recortar* o usa la
   *Goma*, o pregunta al asistente ("¿qué le pasa a este recorte?").
3. Guarda. En Godot, re-importa (`--import`) y exporta.
