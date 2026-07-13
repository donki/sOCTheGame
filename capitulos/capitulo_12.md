# sOC — Capítulo 12: "La filtración"  (Temporada 3)

> Guión del capítulo 12 de la Temporada 3 (trama Nyxos). Documento de diseño
> narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL** en densidad canon (ADR 7-bis).
>
> **Implementación:** el guión vive en `scripts/Story.gd`, bloque `S3` (prefijo
> `*12`). Se entra automáticamente al cerrar el Cap. 11 (bandera `done_cierre11`).
> **Fondos:** `redaccion`, `oficina`. **Retrato clave:** `periodista` (Vera Lang).

---

## 1. Premisa
El caso deja de subir por el papel y empieza a costar sangre. Un **directivo intermedio
de Nyxos**, arrepentido, contacta con la periodista **Vera Lang** y promete el **protocolo
Somnia** entero: qué hacen, a quién, y quién lo ordena. En la entrega, en el aparcamiento
subterráneo de las oficinas, alcanza a pasarle a Nora un **memorándum** que ordena
*depurar sujetos no viables*… y lo **ejecutan de un disparo** delante de ella. Nora rastrea
al sicario hasta la **seguridad corporativa de Nyxos**: no un mafioso, un empleado con
nómina. Matan como quien archiva.

## 2. Tono
Tensión, luto y miedo real. El capítulo baja de los despachos al hormigón frío de un
sótano y convierte una investigación en un duelo. Por primera vez el peligro no es un
juicio perdido: es una bala. La muerte del informante marca el punto en que Nyxos deja de
esconderse y empieza a defenderse matando. Se cierra con luto contenido y un gancho:
las víctimas tienen expediente.

## 3. Personajes
- **Nora** (jugadora) — llega a proteger a un testigo y sale habiéndolo visto morir a un
  brazo de distancia; culpa nueva sobre la vieja.
- **Sgto. Núñez** — la manda rápido pero la frena: un documento no vale un cadáver.
- **Vera Lang** (periodista) — tiende el puente con el informante; se juega el puesto y
  algo peor al decidir publicar el memo.
- **El informante** — directivo intermedio de Nyxos, arrepentido (voz en off / narrador,
  sin retrato propio). Muere pasando la prueba; su gesto final salva a Nora.
- **Suspecto de fondo:** la seguridad corporativa de Nyxos, brazo ejecutor de la dirección.

## 4. Objetivo del capítulo
Acudir a la cita del informante, **conseguir el protocolo/memorándum**, y tras el asesinato,
**identificar al sicario** hasta probar que pertenece a Nyxos. Establecer que la empresa
**mata para tapar** los experimentos y abrir la vía de los expedientes médicos (Cap. 13).

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief12)** — Núñez avisa: hay un informante de dentro y lo tiene Vera.
   *Rama:* proteger al hombre primero vs. exigir el protocolo → revela la Redacción.
2. **Redacción · Vera (l12a)** → PISTA *"El informante"* (un directivo promete el
   protocolo Somnia entero; cita mañana en el aparcamiento; pánico) → revela las Oficinas.
3. **Archivo (rh12)** — red herring: cinco falsas fuentes que solo quieren cámara.
4. **Oficinas de Nyxos · aparcamiento (l12b)** → PISTA *"El memorándum interno"*
   (memo que ordena *depurar sujetos no viables*, firmado por la dirección). *Rama:* sacar
   al hombre primero vs. asegurar la prueba. El informante es **ejecutado**; la hoja
   queda en manos de Nora → desbloquea el rastreo.
5. **Oficinas de Nyxos (fin12)** (requiere las pistas) → PISTA *"Matan para tapar"*: el
   sicario es **seguridad corporativa de Nyxos**. *Rama:* cargar con la culpa vs. tornar el
   luto en rabia. `cap12_completo`.
6. **Comisaría (cierre12)** — el memo lo firma "la dirección", aún sin nombre; los
   historiales del hospital patrocinado pondrán cara a las víctimas. `done_cierre12` → Cap. 13.

## 6. Pistas (Libreta)
| # | Título | Dónde | Texto |
|---|--------|-------|-------|
| 1 | El informante | Redacción (l12a) | "Un directivo intermedio de Nyxos, arrepentido, promete entregar el 'protocolo Somnia' completo." |
| 2 | El memorándum interno | Oficinas (l12b) | "El informante alcanza a pasar una hoja: un memo que ordena 'depurar sujetos no viables'. Firmado por la dirección." |
| — | Matan para tapar | Oficinas (fin12) | "El asesinato del informante confirma que la dirección de Nyxos mata para proteger el proyecto." |

## 7. Pistas falsas (5) — rh12
*El becario dolido · La limpiadora · El hacker de foro · El competidor · El vigilante
nocturno.* Todos quieren su minuto de cámara; ninguno tiene el documento ni tiembla de
verdad. El bueno no presume: tiene pánico y un despacho dentro.

## 8. Condiciones de progreso
- La entrega (**l12b**) queda tras conocer al informante en **l12a**.
- El **fin12** requiere las pistas del capítulo; al cerrarlo activa `cap12_completo`.
- El cierre (**cierre12**) fija `done_cierre12` y encadena con el Cap. 13 (archivo médico).

## 9. Estado de implementación
✅ Expandido a densidad canon: 6 entradas con prosa noir, monólogos internos de Nora
(`side: right`) y **3 ramas de elección** (brief12, l12b, fin12).
✅ Campos de cableado (`bg`, `flag`, `clue`, `clues`, `revisit`) preservados carácter a
carácter. Arte 4K: `redaccion`, `oficina`; retrato `periodista`.

---
*El caso ya no se paga en carrera: se paga en muertos. Y el siguiente hilo pasa por los
expedientes de las víctimas.*
