# sOC — Capítulo 17: "La compra"  (Temporada 3)

> Guión del capítulo 17 de la trama Nyxos. Documento de diseño narrativo + de misión.
> Estado: **expandido a densidad canon** (ADR 7-bis). Versión 0.2.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (bloque `S3`, entradas con
> sufijo `17`). Se entra al cerrar el Capítulo 16 (bandera `done_cierre16`).

---

## 1. Premisa
Cuando no pueden matar a Nora sin hacer ruido, la **compran**. En el reservado del bar de
Clara, un abogado de Nyxos le desliza una carpeta: una **jefatura nacional** a cambio de
"reorientar" la investigación hacia culpables manejables. Nora lo **graba todo** y lo
rechaza. Ante la negativa, Nyxos amenaza a **Diego** ("la salud es frágil"). Es la gota que
colma a **Marco** —excompañero, ahora en la seguridad de Nyxos—: asqueado, elige bando y le
entrega su tarjeta de acceso y los turnos de la sede central. La integridad no se vende; y
una vieja lealtad acaba de abrir la puerta del consejo.

## 2. Tono
Noir de guante blanco. La violencia no viene con navaja, sino con traje caro, rioja y una
sonrisa ensayada. El soborno como forma educada de asesinato; la amenaza al hermano como
puño dentro del guante. Frente a esa maquinaria, la decencia sobrevive donde menos se
espera: en un guardia de seguridad harto de sí mismo. Lluvia que, al final, afloja.

## 3. Personajes
- **Nora** (jugadora) — la compran y no se deja; fría por fuera, con Diego como única grieta.
- **Sgto. Núñez** — le da el micro y el aviso; la cubre desde fuera, prudente.
- **Sospechoso (abogado de Nyxos)** — emisario de guante blanco; sonríe, ofrece y, al fallar,
  amenaza. Lee un guion ajeno: no decide, transmite.
- **Marco** — excompañero, ahora en seguridad de Nyxos; **elige bando**. Le da a Nora acceso
  a la sede central "por los viejos tiempos". La vieja lealtad que despierta.
- **Diego** (mencionado) — el talón de Aquiles; la palanca del chantaje.

## 4. Objetivo del capítulo
**Encajar el soborno sin morderlo**, grabar la oferta y la amenaza, y convertir la negativa
en una ganancia inesperada: la **llave de la sede central** que da Marco. Salir con pruebas
y con acceso, listos para subir al consejo.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief17)** — Núñez entrega el micro y avisa: la recibe una cara conocida →
   revela el Bar de Clara.
2. **Bar de Clara (l17a)** → PISTA *"La oferta"* (jefatura nacional a cambio de reorientar el
   caso; Nora lo graba con el micro) → revela el Despacho.
3. **Despacho del abogado / red herring (rh17)** → cinco emisarios de guante blanco, cinco
   máscaras; ninguno decide. La puerta la abre Marco.
4. **Oficina · pasillo (l17b)** → PISTA *"El chantaje a Nora"* (amenaza a Diego; Marco,
   asqueado, entrega tarjeta y turnos de la sede) → desbloquea el cierre de escena.
5. **Oficina (fin17)** → grabación de la oferta + de la amenaza + acceso de Marco: una llave
   de su propia casa. `cap17_completo`.
6. **Comisaría (cierre17)** — hora de subir al consejo. `done_cierre17` → **Cap. 18**.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | La oferta | Bar de Clara | "Nyxos ofrece a Nora dinero y un ascenso a cambio de 'reorientar' la investigación." |
| 2 | El chantaje a Nora | Oficina (Marco) | "Ante tu negativa, Nyxos amenaza a Diego; Marco, asqueado, decide ayudarte desde dentro." |
| — | No se venden todos | Oficina (fin) | "La grabación de la oferta y el chantaje, más el acceso de Marco, abren la puerta a la sede central." |

## 7. Pistas falsas (5)
En **rh17**, cinco emisarios que parecen la cabeza y solo son cáscara:
*El abogado mensajero · El relaciones públicas · El testaferro · El guardaespaldas ·
El asesor de imagen*. Cinco máscaras de la misma cara que no da la cara: ninguno decide.

## 8. Condiciones de progreso
- El bar (l17a), el red herring (rh17) y el pasillo de Marco (l17b) se encadenan desde el
  brief; la pista clave es el acceso a la sede que da Marco.
- `fin17` fija `cap17_completo`. Cerrar la escena (cierre17) activa `done_cierre17`, que abre
  el **Capítulo 18** (subir al consejo).
- Ramas de elección (ADR 7-bis): en **brief17** (cómo encara la reunión), en **l17b** (cómo
  acepta la ayuda de Marco) y en **fin17** (qué siente al salir). Sin ramas en rh17 ni cierre.

## 9. Estado de implementación
1. ✅ 6 entradas encadenadas con diálogos a densidad canon, 2 pistas verdaderas + 5 falsas.
2. ✅ Soborno grabado, chantaje a Diego y giro de Marco (acceso a la sede central).
3. ✅ Tres ramas de elección (brief17, l17b, fin17).
4. ✅ Arte 4K: `bar_clara`, `despacho_abogado`, `oficina`; retrato `marco`, `sospechoso`.
5. ⏳ Enlaza con el Cap. 18 (asalto/entrada al consejo con la llave de Marco).

---
*La integridad no se vendió. Y un viejo perro decidió, por una noche, volver a ser policía.*
