# sOC — Capítulo 20: "Nyxos" (FINAL de la serie)

> Guión del vigésimo y último capítulo (cierre de la Temporada 3 y de la serie).
> Documento de diseño narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL (densidad canon)**. Versión 1.0.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (entradas `brief20`, `l20a`,
> `rh20`, `l20b`, `fin20`, `cierre20`). Se entra en él automáticamente al cerrar el
> Capítulo 19 (bandera `done_cierre19`). Al ser el último capítulo, no avanza: muestra
> el cierre de la serie.

---

## 1. Premisa
El golpe final. Nora ya no persigue a un villano: persigue a una **MÁQUINA**. Tras veinte
casos y seis tormentas, reúne a todos sus aliados —cada uno con su prueba— y, con el acceso
interno de **Marco** y una citación de **Clara**, cita al **consejo de administración de
Nyxos AL COMPLETO** (los doce) en su propia sala. Nyxos ofrece cinco chivos expiatorios;
Nora los rechaza todos: el acusado es la **corporación entera**. La confrontación final es
en la **azotea de la torre de Nyxos**, bajo la última tormenta, ante la **Dra. Adler**. Cae
la cúpula. Somnia se cancela, las víctimas recuperan su nombre y Diego queda limpio.

## 2. Tono
Clímax coral y catártico. Del bullicio cálido de la comisaría llena de aliados al templo
frío del consejo, y de ahí a lo más alto: una azotea barrida por la lluvia plateada, treinta
y dos pisos sobre la ciudad. El villano no es un rostro sino una estructura; la victoria no
es una detención sino un desmoronamiento. Por primera vez, al final, no llueve. Frase-motivo
del arco, por fin cumplida: **nunca resolví nada sola**.

## 3. Personajes
- **Nora** (jugadora) — cierra el hilo que abrió sola, ahora rodeada de los suyos.
- **Sgto. Núñez** — su ancla; la cubre hasta el final y la manda a descansar.
- **Sonia** (forense) — Somnia en cada víctima, cadena de custodia impecable.
- **Clara** (legal) — el acta, la votación unánime, los consentimientos falsos, la trama nacional.
- **Vera Lang** (prensa) — portada con Irene, la superviviente, contándolo con su nombre.
- **Insp. Rubén** — mentor jubilado "por preguntar"; viene a ver acabada su vieja pregunta.
- **Marco** (interna) — accesos, turnos y la orden de "depurar"; firma su declaración.
- **Diego** — el hermano, recuperándose y por fin limpio; el motivo, no la debilidad.
- **Irene** (testigo) — la superviviente a la que nadie creyó; pone su nombre y su cara.
- **Dra. Adler** — presidenta/directora científica; soberbia glacial que ejecuta, no reina.

## 4. Objetivo del capítulo
Reunir a todos los aliados con sus pruebas, **citar al consejo entero** en una sala
controlada, **rechazar los cinco chivos expiatorios**, **ensamblar las cinco pruebas** en una
imagen irrefutable y **derribar a la corporación** en la azotea, ante Adler. Cerrar los veinte
casos y el único hilo.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief)** — todos los aliados reunidos; Nora agradece y fija la estrategia
   ("entramos todos"). Rama: hacerlo por el libro / que uno de los doce despierte.
2. **Sala del consejo (l20a)** → PISTA *"La cúpula entera"* (con Marco dentro y Clara con la
   orden, los doce citados y localizados por primera vez). Rama: entrar de usted / mirarlos
   a los ojos uno a uno.
3. **Antesala (rh20)** — los cinco chivos expiatorios (mártir, científico loco, filial rebelde,
   error de sistema, difunto Vaultier); Nora los rechaza todos. **Sin ramas** (red herring).
4. **Comisaría (l20b)** → PISTA *"Todas las piezas"* (coral de aliados: forense, legal, prensa,
   testigo, interna). Rama: agradecer a Marco / prometer a Irene que su nombre sale primero.
5. **Azotea de la torre de Nyxos (fin20)** (requiere las pistas) → clímax bajo la tormenta;
   duelo verbal con Adler ("una empresa no cabe en una celda" / "pero cabe en un titular, en
   un sumario y en la ruina"); las pruebas proyectadas sobre la fachada; cae la cúpula.
   `cap20_completo`. Rama: dejar que hable la lluvia / dar la última palabra a las víctimas.
6. **Comisaría (cierre)** — Nyxos se desmorona en los tribunales, Somnia se cancela, las
   víctimas recuperan su nombre; Diego está limpio; Nora brinda con todos; Núñez la manda a
   descansar "hasta la próxima tormenta". `done_cierre20` → **FIN DE LA SERIE**.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | La cúpula entera | Consejo | "Con Marco dentro y Clara con la orden, se cita al consejo AL COMPLETO: por primera vez, los doce en una sala controlada." |
| 2 | Todas las piezas | Comisaría | "Cada aliado aporta su prueba: forense (Sonia), legal (Clara), prensa (Vera), testigo (Irene), interna (Marco). Juntas, son irrefutables." |
| — | La prueba definitiva | Azotea | "En la azotea de Nyxos, ante la cúpula, Nora expone que el culpable es la corporación entera; con las pruebas de todos, cae Nyxos." |

## 7. Pistas falsas (los cinco chivos expiatorios, en rh20)
| Título | Por qué es falsa |
|--------|------------------|
| El directivo mártir | "Confiesa" ser el único culpable; guion aprendido para salvar a Nyxos. |
| El científico loco | Ofrecen a Kessler como mente enferma aislada; era un simple recadero. |
| La filial rebelde | Culpan a una filial descontrolada; las órdenes venían de la central. |
| El error de sistema | Alegan un fallo de protocolo sin responsables; el acta prueba lo contrario. |
| El difunto | Le cuelgan todo a Vaultier, ya caído; muerto el perro, viva la empresa. |

## 8. Condiciones de progreso
- La **azotea** (`fin20`) se abre con las pistas del capítulo reunidas.
- Cerrar la azotea (`cap20_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre20`. Al ser el **último capítulo de la serie**, no avanza: muestra el cierre
  definitivo ("— FIN —").

## 9. Estado de implementación
1. ✅ 6 localizaciones encadenadas con diálogos densos, pistas y clímax coral.
2. ✅ Coral de aliados con voz propia (Sonia, Clara, Vera, Rubén, Marco, Irene, Diego, Núñez).
3. ✅ Tres momentos de rama (brief, consejo, comisaría-aliados) más rama en el final.
4. ✅ Prosa sensorial ampliada en la azotea (lluvia plateada, focos rojos, ciudad de testigo).
5. ✅ Cierre de la serie ("— FIN —", "sOC"), con el motivo "nunca resolví nada sola" resuelto.
6. ✅ Campos de cableado (`bg`, `flag`, `clue`, `clues`, `revisit`) preservados carácter a carácter.

---
*Fin de la serie. Veinte casos, un solo hilo: desde una campana robada hasta una corporación
entera. Por primera vez, al salir, no llueve. sOC.*
