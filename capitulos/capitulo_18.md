# sOC — Capítulo 18: "El consejo"

> Guión del capítulo 18 (Temporada 3, trama Nyxos). Documento de diseño narrativo
> + de misión.
> Estado: **expandido a densidad canon (ADR 7-bis)**. Versión 0.2.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (entradas `brief18`, `l18a`,
> `rh18`, `l18b`, `fin18`, `cierre18`). Se entra al cerrar el Capítulo 17 (bandera
> `done_cierre17`). Cierra con `cap18_completo` → abre el Capítulo 19.

---

## 1. Premisa
Con la tarjeta de acceso que le entregó **Marco**, Nora entra de madrugada en la sede
central desierta de **Nyxos Pharma** y fotografía un **acta reservada** que aprueba el
**Proyecto Somnia** con una partida presupuestaria para *gestión y depuración de sujetos*,
firmada con nombre y apellido por el consejo de administración. El **contable** —testigo
protegido de la vieja trama— aporta el documento hermano: el **registro de la votación**,
aprobado por **unanimidad, doce a favor y cero en contra**. La culpa repartida en doce
trozos hasta que no pesa en ninguna conciencia; pero el papel sí pesa. En la cabecera de
cada acta, un cargo se repite: *Presidenta del Consejo y Directora Científica*: **Adler**.

## 2. Tono
La banalidad burocrática del mal. Aquí el crimen no huele a sangre ni a callejón: huele a
cera de muebles, a café de reunión y a moqueta cara, esa que absorbe los pasos y las
conciencias. Doce firmas en una sala de caoba deciden matar a personas y luego pasan a las
pastas. El horror está en la naturalidad del trámite. Noir de despacho, frío y pulcro.

## 3. Personajes
- **Nora** (jugadora) — entra sola y limpia; busca un papel, no un monstruo.
- **Sgto. Núñez** — la lanza y la frena; siembra la duda final ("una presidenta no es
  una dueña").
- **El contable** — testigo gris y lúcido de la vieja trama; aporta el registro de la
  votación y la clave: apunta a quien firma en la cabecera, no a los doce peones.
- **Dra. Adler** — sólo aparece nombrada, en la cabecera de las actas: la cara científica
  y pública de Nyxos. Gancho del capítulo 19.

## 4. Objetivo del capítulo
Entrar con la tarjeta de Marco, **fotografiar el acta secreta**, descartar las cinco
coartadas de los consejeros, obtener del contable el **registro de la votación unánime** y
cerrar reconstruyendo que **el consejo entero decidió junto**, con un nombre al frente:
Adler.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief18)** — Núñez manda a Nora a por el acta, no a por testigos: "ese papel
   es piedra". *Rama*: entrar limpia a fotografiar / dudar de que el acta exista.
2. **Sede de Nyxos, planta noble (l18a)** → PISTA *"El acta secreta"* (acta reservada que
   aprueba Somnia con partida para "gestión y depuración de sujetos", firmada por el
   consejo; Nora fotografía cada página) → revela el despacho del consejero.
3. **Despacho del consejero (rh18, red herring)** → cinco coartadas de consejeros (el que
   dimite, el "enfermo", el "ausente", el "técnico sin voto", la "víctima"), todas se
   estrellan contra el acta unánime. Sin ramas.
4. **Gestoría / piso protegido (l18b)** → PISTA *"La votación del consejo"* (el contable
   aporta el registro: unanimidad, doce a favor, cero en contra). *Rama*: preguntar cómo
   duermen / confirmar que con esto los tiene a los doce (y el consejo de ir a por la
   cabecera).
5. **Sala del consejo (fin18)** (requiere las 3 pistas) → PISTA *"Deciden juntos"* (el acta
   más la votación prueban que el consejo entero ordenó el proyecto). En la cabecera, un
   cargo repetido: "Presidenta del Consejo y Directora Científica": **Adler**. `cap18_completo`.
6. **Comisaría (cierre18)** — Núñez: vaya a ver a Adler, pero "una presidenta no es lo mismo
   que una dueña". `done_cierre18` → **Capítulo 19**.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | El acta secreta | Sede de Nyxos | "En la sede, un acta reservada aprueba el 'Proyecto Somnia' con presupuesto para 'gestión de sujetos'." |
| 2 | La votación del consejo | Gestoría (contable) | "El contable, ya testigo, aporta el registro de la votación: el consejo aprobó Somnia por unanimidad." |
| — | Deciden juntos | Sala del consejo | "El acta más la votación prueban que el consejo entero de Nyxos ordenó el proyecto: no hay un solo culpable, son todos." |

## 7. Pistas falsas (red herring — despacho del consejero)
- **El consejero que dimite** — huye para salvarse, no se arrepiente.
- **El consejero enfermo** — alega demencia; su firma es firme y reciente.
- **El consejero ausente** — dice que faltó; el registro prueba que votó.
- **El consejero "técnico"** — se declara asesor sin voto; su voto consta.
- **El consejero víctima** — se pinta coaccionado; cobró primas trimestrales.

## 8. Condiciones de progreso
- La **sala del consejo (fin18)** se abre con las **3 pistas** del capítulo.
- Cerrar la sala (`cap18_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre18`, que da paso al **Capítulo 19** (ir a por Adler).

## 9. Estado de implementación
1. ✅ 6 entradas encadenadas con densidad canon (~70 líneas), prosa noir de despacho.
2. ✅ 3 ramas de elección (brief, l18b) respetando el molde de caps 8-9; sin ramas en rh
   ni cierre.
3. ✅ `bg`, `flag`, `clue`, `clues` (5 falsas) y `revisit` preservados carácter por carácter.
4. ✅ Sin comillas dobles dentro de textos (comillas simples y angulares); GDScript válido.
5. ✅ Gancho de continuidad al cap 19: "una presidenta no es lo mismo que una dueña".

---
*El mal por escrito, con presupuesto y firmas. Doce manos sobre la moqueta buena, y un
solo nombre en la cabecera: Adler.*
