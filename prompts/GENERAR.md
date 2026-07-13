# 🎨 Lista de generación (Gemini) — Capítulo 1

**Cómo funciona:** por cada fila, abre el archivo de prompt, copia el prompt en
Gemini, y **DESCARGA** el resultado a `C:\Users\Josep\Downloads\` con el **nombre
exacto** de la columna "Guardar como". Cuando tengas un lote, dime **"listo"** (o
qué nombres hay) y yo los muevo a `assets/`, los recorto e integro en el juego.

> El único paso manual es ese: copiar el prompt en Gemini y **Descargar** con el
> nombre indicado. Todo lo demás (recortar, colocar, código, recompilar) lo hago yo.

---

## 1) Personajes  (prioridad ALTA — dan vida al barrio)
| Personaje | Prompt (archivo) | Guardar como |
|---|---|---|
| Detective Nora Vega | `npc_capitulo1/00_detective.md` | `nora.png` |
| Don Emilio | `npc_capitulo1/01_don_emilio.md` | `emilio.png` |
| Rosa | `npc_capitulo1/02_rosa.md` | `rosa.png` |
| Tomás | `npc_capitulo1/03_tomas.md` | `tomas.png` |
| Doña Carmen | `npc_capitulo1/04_dona_carmen.md` | `carmen.png` |
| Sargento Núñez | `npc_capitulo1/05_sargento_nunez.md` | `nunez.png` |
| Marta (opcional) | `npc_capitulo1/06_marta_soler.md` | `marta.png` |
| Encapuchado (opcional) | `npc_capitulo1/07_encapuchado.md` | `encapuchado.png` |

## 2) Iglesia / splash  (prioridad ALTA)
| Asset | Prompt | Guardar como |
|---|---|---|
| Iglesia de noche (splash) | `escenario_capitulo1/01_splash_iglesia.md` | `church2.png` |
| Interior iglesia (pista 5) | `escenario_capitulo1/02_iglesia_interior.md` | `iglesia_interior.png` |

## 3) Edificios  (prioridad MEDIA — reemplazan los actuales)
Archivo: `escenario_capitulo1/03_edificios.md` (un prompt por edificio)
| Guardar como | | Guardar como |
|---|---|---|
| `casa_ladrillo.png` | | `cafe.png` |
| `casa_marron.png` | | `tienda.png` |
| `casa_estrecha.png` | | `policia.png` |
| `adosados.png` | | `bomberos.png` |
| `ayuntamiento.png` | | |

## 4) Coches  (prioridad MEDIA)
Archivo: `escenario_capitulo1/04_coches.md`
`car_sedan.png` · `car_van.png` · `car_hatchback.png` · `car_policia.png`

## 5) Props de calle  (prioridad BAJA)
Archivo: `escenario_capitulo1/05_props_calle.md`
`prop_farola.png` · `prop_banco.png` · `prop_papelera.png` · `prop_contenedor.png`
· `prop_arbol.png` · `prop_seto.png` · `prop_hidrante.png`

## 6) Objetos / iconos  (prioridad BAJA)
Archivo: `escenario_capitulo1/06_objetos.md`
`item_panuelo.png` · `item_libreta.png` · `item_lupa.png`

---

## Orden recomendado
1. **Los 6 personajes + `church2.png`** → con eso el barrio ya se ve poblado y la
   intro con iglesia nueva. Dime "listo" y lo integro TODO de golpe.
2. Luego edificios, luego coches/props/objetos (a tu ritmo).

> Los que ya generaste (Nora, Emilio, Rosa, Tomás, Carmen, Núñez) solo hay que
> **descargarlos** a `Downloads` con esos nombres y avisarme.
