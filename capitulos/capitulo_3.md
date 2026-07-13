# sOC — Capítulo 3: "El coleccionista"

> Guión del tercer capítulo (final de la Temporada 1). Documento de diseño narrativo
> + de misión.
> Estado: **implementado como NOVELA VISUAL**. Versión 0.1.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (bloque `CHAPTERS[3]` y
> `_ch3_dialogue`). Se entra en él automáticamente al cerrar el Capítulo 2 (bandera
> `done_cierre2`).

---

## 1. Premisa
El hilo ya no se hunde en el barrio: sube. El escudo del mechero —**tres campanas y
una corona**— es el blasón de los **Bru**, y el último de la estirpe es el **comisario
Bru**, el hombre que cerraba los casos. Sin placa que la respalde y con una tormenta
subiendo por el río, **Nora** entra sola en la mansión del mecenas para encontrar a la
cuarta mujer viva y parar la "función final".

## 2. Tono
Clímax noir. De los despachos a una mansión-museo y a lo alto de una torre del reloj.
El villano no es un monstruo de callejón: es un hombre refinado que se cree por encima
de la ley porque la escribe. La lluvia, por una vez, termina limpiando.

## 3. Personajes
- **Nora** (jugadora) — a la caza, sin red.
- **Sgto. Núñez** — la cubre desde fuera; ha quemado su carrera en esto.
- **Elena Ruiz y Nadia Kovač** — las cautivas vivas; testigos.
- **Padre Ismael** — párroco de San José; **chantajeado**, entregaba a las mujeres.
- **Comisario Bru** — el **coleccionista**; aristócrata, anillo de sello, elegante y cruel.

## 4. Objetivo del capítulo
Seguir el rastro del blasón hasta la mansión, **rescatar a las cautivas**, arrancar la
**confesión del párroco** y llegar a la **torre del reloj** antes de medianoche para
**detener a Bru** y salvar a Marta.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (aviso)** — Núñez identifica el escudo de los Bru y da la dirección de la
   mansión → revela la Mansión.
2. **Mansión del mecenas** → PISTA *"Las tres campanas"* (tres campanas-trofeo, una por
   iglesia; una cuarta peana vacía: "la torre del reloj, esta noche") → revela el Sótano.
3. **El sótano** → PISTA *"Las cautivas"* (Elena y Nadia, vivas; a Marta se la llevaron a
   la torre; fue el **padre Ismael** quien las entregaba) → revela la Iglesia.
4. **Iglesia de San José (padre)** → PISTA *"El chantaje"* (Bru chantajeaba al párroco; la
   "función" es en la torre del reloj a medianoche) → desbloquea la Torre.
5. **La torre del reloj** (requiere las 3 pistas) → clímax: enfrentamiento con Bru entre
   engranajes; a la última campanada, **Bru detenido** y Marta libre. `cap3_completo`.
6. **Comisaría (cierre)** — con tres testigos vivas, el anillo, el mechero y el libro de
   la capilla, Bru **cae**. Núñez asciende. `done_cierre3` → **fin de la temporada**.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | Las tres campanas | Mansión | "Tres campanas de iglesia expuestas como trofeos, una placa por víctima." |
| 2 | Las cautivas | Sótano | "Elena y Nadia siguen vivas, encerradas. Marta fue llevada a 'la torre'." |
| 3 | El chantaje | Padre | "El padre Ismael entregaba a las mujeres, chantajeado por Bru. La 'función' es en la torre del reloj." |
| — | El coleccionista | Torre | "El comisario Bru, detenido en la torre del reloj. Marta, viva." |

## 7. Condiciones de progreso
- La **torre del reloj** se abre con las **3 pistas** del capítulo.
- Cerrar la torre (`cap3_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre3`. Como es el **último capítulo**, no avanza: muestra el cierre de temporada.

## 8. Estado de implementación
1. ✅ 6 localizaciones encadenadas con diálogos, pistas y clímax.
2. ✅ Rescate de cautivas, confesión del párroco y detención del villano.
3. ✅ Fondos IA (`mansion`, `sotano`, `torre`) y retratos (`padre`, `comisario`).
4. ✅ Cierre de la Temporada 1 ("— FIN DE LA TEMPORADA 1 —").
5. ⏳ Ampliar diálogos a los ~5 min del canon (§7-bis); posible Temporada 2.

---
*Fin de la Temporada 1. Tres casos, tres tormentas, tres campanas que vuelven a su sitio.*
