# sOC the Game — Capítulo 1: "Desaparición en la iglesia"

> Guión del primer capítulo. Documento de diseño narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL**. Versión 0.2.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (localizaciones del mapa
> + diálogos). Ya no se explora el barrio caminando: se **marca cada localización
> en el mapa** (`scenes/CityMap`) y se juega en **escenas de diálogo**
> (`scenes/DialogueScene`). Editar `Story.gd` es editar este capítulo.

---

## 1. Premisa
Noche de tormenta en el **Barrio Viejo**. La iglesia de **San José** toca a
rebato: las campanas llaman a los vecinos, que corren a refugiarse (esto es la
intro cinemática del juego). Durante la misa, entre el fragor de las campanas,
**una mujer desaparece junto al altar**. Nadie la vio salir.

La protagonista, la **Detective**, llega al barrio. Su primer caso: averiguar
qué le pasó a la desaparecida, **Marta Soler**.

## 2. Tono
Misterio urbano con un poso inquietante. Lluvia constante, farolas, luz cálida
saliendo de las ventanas. Nada sobrenatural (todavía): todo tiene explicación...
o eso parece.

## 3. Personajes
- **Detective** (jugadora) — metódica, irónica, observadora.
- **Marta Soler** — la desaparecida. No aparece en escena (aún).
- **Don Emilio** (vecino anciano) — estaba en misa. Oyó un grito.
- **Rosa** (vecina, vestido verde) — vigila la puerta principal; nadie salió por ahí.
- **Tomás** (tendero) — vio a Marta discutir con un encapuchado.
- **Doña Carmen** (anciana) — conoce los secretos del barrio; remite a la comisaría.
- **Sargento Núñez** (comisaría) — da acceso oficial y una pista clave *(cap. 2)*.

## 4. Objetivo del capítulo
**Reunir las 4 pistas** hablando con los vecinos y luego **investigar la iglesia**
para descubrir la vía de escape (la **puerta del campanario**) y cerrar el
capítulo con un gancho hacia el capítulo 2.

## 5. Estructura (beats)
1. **Intro** (cinemática): campanas, tormenta, vecinos entrando a la iglesia.
2. **Llegada**: la Detective aparece en el cruce del Barrio Viejo. HUD: "Caso 1".
3. **Investigación de calle** (mundo abierto del barrio):
   - Hablar con **Don Emilio** → PISTA: *"El grito junto al altar"*.
   - Hablar con **Rosa** → PISTA: *"Nadie salió por la puerta principal"*.
   - Hablar con **Tomás** → PISTA: *"Marta discutió con un encapuchado"*.
   - Hablar con **Doña Carmen** → PISTA: *"La puerta del campanario estaba abierta"*.
   - Las pistas se guardan en la **Libreta** (tecla **N** / botón).
4. **La iglesia** (interacción en la puerta):
   - Antes de tener las 4 pistas: la Detective observa el exterior, toma notas.
   - Con las 4 pistas: puede **entrar a investigar** → descubre que la salida fue
     por el **campanario** (coincide con la pista de Doña Carmen). Encuentra un
     objeto de Marta (un **pañuelo con iniciales**).
5. **Cierre**: PISTA final *"Alguien la sacó por el campanario"*. Gancho: el
   Sargento Núñez menciona que **no es la primera desaparición** este mes.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | El grito | Don Emilio | "Durante las campanas se oyó un grito junto al altar." |
| 2 | La puerta principal | Rosa | "Nadie salió por la puerta principal: alguien vigilaba." |
| 3 | El encapuchado | Tomás | "Marta discutió ayer con un hombre encapuchado." |
| 4 | El campanario | Doña Carmen | "La puerta del campanario estaba abierta esa noche." |
| 5 | El pañuelo | Iglesia (interior) | "Un pañuelo con las iniciales M.S. junto a la escalera del campanario." |

## 7. Condiciones de progreso
- La iglesia solo se puede **investigar a fondo** con las **4 pistas** de calle.
- Al obtener la pista 5, se marca el **capítulo como completado** y aparece el
  mensaje de cierre + gancho.

## 8. Mecánicas implicadas (novela visual)
- **Mapa de la ciudad**: se marca la localización y la detective "viaja" allí.
- **Escenas de diálogo**: retratos, texto con máquina de escribir y **opciones**.
- **Libreta de pistas** (tecla **N**): lista de las pistas obtenidas.
- **Puertas por requisito**: la **iglesia** solo se abre con las 4 pistas de calle;
  la **comisaría** aparece al completar la iglesia.

## 9. Estado de implementación
1. ✅ Mapa con 7 localizaciones y viaje al pin marcado.
2. ✅ Diálogos de los 4 vecinos con pistas (Emilio, Rosa, Tomás, Carmen).
3. ✅ Iglesia (interior/campanario) con la pista 5 + cierre de capítulo.
4. ✅ Comisaría (gancho al cap. 2: "no es la primera desaparición").
5. ✅ Libreta de pistas y objetivo dinámico.
6. ⏳ Arte definitivo (retratos/fondos/mapa) — ver `prompts/`.
7. ⏳ Guardado real del progreso (pistas + flags).

---
*Revísalo y dime: nombres, pistas, tono, o el giro final. Ajusto y sigo
implementando por este orden.*
