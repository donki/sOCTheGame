# sOC — Capítulo 16: "La otra ciudad"  (Temporada 3)

> Guión del decimosexto capítulo. Documento de diseño narrativo + de misión.
> Estado: **expandido a densidad canon** (ADR 7-bis). Versión 0.2.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (bloque `S3`, prefijo `*16`).
> Se entra al cerrar el Cap. 15 (bandera `done_cierre15`). **Mapa propio de la región**:
> otra ciudad (`mapa_ciudad2`).

---

## 1. Premisa
El hilo deja de ser local: sube y se extiende. Nora y **Clara** viajan a la filial de
Nyxos en la capital del norte, una ciudad más gris, más grande y más fría. Allí descubren
que los protocolos, formularios y códigos de proyecto son **idénticos** a los de casa: no
es una imitación, es la misma empresa copiándose a sí misma, una franquicia del horror.
Clara levanta un organigrama que ata cada filial, balneario y sanatorio a **una única sede
central**: las órdenes, el dinero y el «protocolo Somnia» bajan de un solo consejo de doce
sillas. Ya no hay «filial rebelde»: es una trama nacional centralizada en la casa madre.

## 2. Tono
Noir corporativo, geográfico. La misma lluvia, pero recta y sin viento; una ciudad
demasiado ordenada para dar miedo, y por eso más inquietante. Mármol frío, ascensores
silenciosos, membretes escaneados. El villano ya no es una persona ni una ciudad: es una
estructura que se replica igual en todas partes. Mismo neón enfermo sobre otra torre.

## 3. Personajes
- **Nora** (jugadora) — fuera de su jurisdicción; turista con demasiadas preguntas.
- **Sgto. Núñez** — la cubre desde casa; consigue los registros por lo bajo y la avisa.
- **Clara** — ex pareja de Nora, abogada; la acompaña por lo legal y **levanta el
  organigrama** que une las filiales. Se protege con ironía profesional ("No lo hago
  por ti"), pero lleva un mes sin dormir por los expedientes de admisión.
- Sospechosos de pega del capítulo: un policía local perdido, un taxista fantasioso,
  un político de foto, un detective privado de recortes y una empleada resentida.

## 4. Objetivo del capítulo
Demostrar que la filial del norte **es la misma organización** (protocolos idénticos),
atar todas las filiales a una **sede central única** con el organigrama de Clara y salir
de la sede regional con las **circulares nacionales** firmadas por una sola dirección:
la prueba de que Somnia es una trama nacional centralizada.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief16)** — Núñez identifica la filial del norte; Clara la acompaña.
   *Rama:* cómo encara Nora el viaje (fría y rápida / tumbarlos a todos) → Otra ciudad.
2. **Otra ciudad (l16a)** → PISTA *"La franquicia"* (formularios y códigos idénticos a los
   de casa: la misma empresa copiándose) → revela el Puesto de policía.
3. **Puesto de policía (rh16)** — cinco falsos aliados de ciudad nueva; Clara los descarta.
   Lo sólido son los papeles → revela la ruta de Clara.
4. **Clara · juzgado prestado (l16b)** → PISTA *"El patrón nacional"* (organigrama: todo
   cuelga de una sede central). *Rama:* la deuda emocional con Clara → revela la Sede.
5. **Sede regional (fin16)** → PISTA *"Una sola cabeza"*: circulares firmadas por
   «Dirección Central — Consejo». *Rama:* cotejar circulares / buscar la de Somnia.
   `cap16_completo`.
6. **Comisaría (cierre16)** — Nyxos quiere «negociar»: reunión privada, traje y cheque.
   Gancho del Cap. 17.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | La franquicia | Otra ciudad | "La filial del norte usa idénticos protocolos, formularios y códigos: es la misma organización." |
| 2 | El patrón nacional | Clara (juzgado) | "Clara ata las filiales a una única sede central: todas dependen del consejo de Nyxos." |
| — | Una sola cabeza | Sede regional | "Documentos de la filial confirman que el proyecto Somnia es nacional y centralizado en la sede de Nyxos." |

## 7. Pistas falsas (5)
En **rh16**: *El policía local · El taxista · El político local · El detective privado ·
La empleada resentida*. Ruido de ciudad nueva; gente que huele forastera con dinero y
acude. Lo sólido no charla: son los protocolos que atan la filial a la central.

## 8. Condiciones de progreso
- **Otra ciudad** se abre tras el brief; su pista abre el **puesto de policía**.
- La escena con **Clara** exige haber pasado por l16a/rh16; su organigrama abre la **sede**.
- Cerrar la sede (`cap16_completo`) activa la **comisaría de cierre** (`done_cierre16`),
  que engancha con el Cap. 17 (la reunión de compra).

## 9. Estado de implementación
- ✅ 6 localizaciones encadenadas; beats expandidos a densidad canon con 3 ramas de
  elección (brief16, l16b, fin16) y monólogos internos de Nora (`side: right`).
- ✅ Campos de cableado preservados (`bg`, `flag`, `clue`, `clues`, `revisit`).
- ✅ Arte 4K: `ciudad2`, `sede_regional`, `puesto_policia`, `ruta_clara`; retrato `clara`;
  mapa `mapa_ciudad2`.

---
*La serpiente no tenía muchas cabezas: tenía una sola, repartida por todo el país.*
