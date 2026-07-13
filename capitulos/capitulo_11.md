# sOC — Capítulo 11: "El barrio alto"

> Guión del undécimo capítulo (Temporada 3, trama Nyxos). Documento de diseño
> narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL**. Versión 0.1.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (entradas `brief11`, `l11a`,
> `rh11`, `l11b`, `fin11`, `cierre11`). Se entra en él automáticamente al cerrar el
> Capítulo 10 (bandera `done_cierre10`). Mapa propio: zona de negocios (`mapa_centro`).

---

## 1. Premisa
Tras filmar el sótano de las peceras, el hilo deja de bajar y empieza a subir.
La detective **Nora** ya no persigue a quien fabrica el Somnia, sino a quien lo
**protege desde los despachos**. Nyxos no compra a tiros: monta una **Fundación
Nyxos** que paga campañas, palcos y viajes de los mismos cargos que firman sus
licencias de ensayo. En el barrio alto, la empresa no secuestra a nadie: invita a
cenar. Con la ayuda de su viejo mentor jubilado, el inspector **Rubén**, Nora llega
al hombre que abrió la puerta: el concejal de Urbanismo **Vela**, que aprobó la
planta de Nyxos en tiempo récord. Vela confiesa a medias y, cobarde, señala más
arriba: al **consejo**.

## 2. Tono
Noir de guante blanco. La lluvia cae más fina sobre las villas con verja; el crimen
se sirve con canapés y no deja mancha en la moqueta. El soborno lleva lazo de regalo:
placa de bronce, foto en la sección de sociedad, notario delante. El villano ya no es
una persona sino una **estructura** de firmas repartidas en trozos tan pequeños que
ninguno cabe en una condena. Nada de sangre a la vista; todo tinta.

## 3. Personajes
- **Nora** (jugadora) — subiendo escaleras, con la placa cada vez menos visible.
- **Sgto. Núñez** — su ancla; le enseña que arriba el barro ensucia distinto.
- **Insp. Rubén** — viejo mentor jubilado "por preguntar"; castizo, cansado, lúcido.
  Conoce a cada figura del barrio alto por su nombre y su precio. Le da a Nora el
  nombre clave y una advertencia: Vela es un cobarde y los cobardes señalan hacia arriba.
- **Concejal Vela** (clave `sospechoso`) — Urbanismo; firmó la planta en cuatro semanas
  y a la semana cobró la campaña. Escurridizo, cobarde; confiesa a medias y apunta al consejo.

## 4. Objetivo del capítulo
Reunir las pistas que prueban la red de favores (la fundación como vehículo de soborno
y el nombre del concejal comprado) y llegar al despacho de **Vela** para arrancarle que
Nyxos "agradece" con dinero y silencio a quien le facilita las cosas. Gancho: hace falta
un **testigo de dentro**; alguien de Nyxos ha llamado pidiendo hablar (enlace directo al
Cap. 12).

## 5. Estructura (cadena de localizaciones)
Cada localización se revela porque en la anterior se habla de ella:
1. **Comisaría (brief11)** — Núñez señala el barrio alto, donde viven los que firman los
   permisos → revela el barrio alto. *(Ramas: ir de frente / ir despacio.)*
2. **Barrio alto (l11a)** → PISTA *"Los sobornos"* (la Fundación Nyxos financia las
   campañas de los cargos que aprueban sus permisos; soborno legal por fuera) → revela el
   despacho del concejal y la necesidad de un guía: Rubén.
3. **Despacho del concejal (rh11, red herring)** → cinco corruptelas de guante blanco que
   se descartan una a una con Rubén; el pez gordo es **Vela** → revela el café de Rubén.
4. **Café de Rubén (l11b)** → PISTA *"El concejal comprado"* (Rubén señala a Vela, de
   Urbanismo, que aprobó la planta en tiempo récord; a quien preguntó, lo jubilaron) →
   desbloquea el despacho de Vela. *(Ramas: reprochar / comprender el silencio de Rubén.)*
5. **Despacho de Vela (fin11)** (requiere las pistas) → confrontación: Vela confiesa a
   medias, jura no saber nada de sótanos y apunta al **consejo de Nyxos**. Marca
   `cap11_completo`. *(Ramas: apretarle la conciencia / ofrecerle salida como testigo.)*
6. **Comisaría (cierre11)** — Núñez: contra una culpa repartida en trozos hace falta un
   testigo de dentro. Alguien de Nyxos ha llamado. `done_cierre11` → pasa al Capítulo 12.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | Los sobornos | Barrio alto | "Nyxos financia a través de una fundación las campañas de varios cargos que aprueban sus permisos." |
| 2 | El concejal comprado | Café de Rubén | "Rubén, tu viejo mentor, señala al concejal de Urbanismo que aprobó en tiempo récord la planta de Nyxos." |
| — | La red de favores | Despacho de Vela | "Vela confiesa a medias: Nyxos 'agradece' con dinero y con silencio a quien le facilita las cosas." |

## 7. Pistas falsas (red herring, rh11)
Cinco corrupciones pequeñas puestas como setos para tapar la casa que hay detrás:
- **El concejal rival** — ataca a Nyxos en prensa; solo busca titulares y votos, sin prueba.
- **El constructor** — levantó la sede de Nyxos; cobró y calló, pero no sabe qué pasa dentro.
- **La asociación vecinal** — protesta por el ruido de las obras; nada que ver con los ensayos.
- **El del catastro** — aceleró un registro por un sobre; corrupción de calderilla, no de sangre.
- **El periodista comprado** — escribe elogios a Nyxos por dinero; vanidoso, no un cerebro.

## 8. Condiciones de progreso
- El **despacho de Vela** se abre tras las pistas de la investigación (fundación + Vela).
- Cerrar el despacho (`cap11_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre11`, que **avanza automáticamente al Capítulo 12**.

## 9. Estado de implementación
1. ✅ 6 entradas encadenadas (`brief11`, `l11a`, `rh11`, `l11b`, `fin11`, `cierre11`).
2. ✅ Diálogos ampliados a densidad canon (§7-bis) con beats de narrador ambientales.
3. ✅ Ramas de elección en brief, café de Rubén y confrontación con Vela.
4. ✅ 2 pistas de investigación + confesión final; 5 pistas falsas conservadas.
5. ✅ Cierre con gancho al Cap. 12: el testigo de dentro que quiere hablar.
6. ✅ Arte 4K: `barrio_alto`, `centro`; retratos `ruben`, `sospechoso`; mapa `mapa_centro`.

---
*El hilo ya no baja al sótano: sube a los salones. Y arriba, por primera vez, alguien
del muro ha decidido hablar.*
