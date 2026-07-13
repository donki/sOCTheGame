# sOC — Capítulo 13: "El expediente"

> Guión del decimotercer capítulo (Temporada 3, trama Nyxos). Documento de diseño
> narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL (densidad canon)**. Versión 0.1.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (entradas `brief13`, `l13a`,
> `rh13`, `l13b`, `fin13`, `cierre13`). Se entra en él al cerrar el Capítulo 12
> (bandera `done_cierre12`). Cierra activando `cap13_completo` y `done_cierre13`.

---

## 1. Premisa
El caso deja de ser una cadena de indicios y se convierte en un **expediente**. En el
archivo médico del hospital, la forense **Sonia** ayuda a **Nora** a cruzar los
historiales clínicos de los diecinueve desaparecidos: todos pasaron por un mismo
**"estudio patrocinado" de Nyxos**. Cada número de lote era una persona. En la última
tanda de reclutados aparece **Diego**, el hermano de Nora: ha recaído y Nyxos lo ha
vuelto a captar para **presionarla** ("que la detective piense en su familia"). Al
fondo de cada carpeta, un sello: **Proyecto SOMNIA — Nivel Consejo**. La orden no la
da un directivo suelto: nace del **consejo de administración**.

## 2. Tono
Noir íntimo y frío. Del papel viejo y el formol del archivo al blanco clínico de una
habitación de hospital. Es el capítulo en el que el caso **toca a la familia** de Nora
y, a la vez, revela por fin la altura del enemigo: no un monstruo, sino doce firmas en
una sala con moqueta buena. Rabia contenida, ternura de hermana mayor, vértigo ante la
escala del mal burocrático.

## 3. Personajes
- **Nora Vega** (jugadora) — cruza el expediente con la cabeza fría hasta que un nombre
  se la rompe. "Nunca resolví nada sola."
- **Sonia** — forense y mejor amiga; llave del archivo, ojo clínico, hombro humano. Es
  quien encuentra el nombre que nadie quería leer.
- **Diego Vega** — el hermano; ha recaído, reclutado de nuevo por Nyxos, usado como
  mensajero de su propia amenaza. Culpa y cariño.
- **Sgto. Núñez** — el ancla; enmarca el paso legal y abre el gancho de la costa.

## 4. Objetivo del capítulo
Convertir los "lotes" en **nombres**, probar que los diecinueve desaparecidos pasaron
por un **mismo estudio de Nyxos**, descubrir a **Diego** en la última tanda (y la
presión que eso significa) y leer el **código del proyecto** que sitúa la orden a
**nivel de consejo**. Cierre: demostrar que el patrón es **sistemático más allá de la
ciudad** → gancho del centro de la costa (cap. 14).

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief13)** — Núñez propone poner cara a cada lote con los historiales del
   hospital; Nora recurre a Sonia para acceder al archivo. *(2 ramas: cabeza fría vs.
   mal presentimiento.)*
2. **Archivo médico (l13a)** → PISTA *"Los sujetos de prueba"* (los diecinueve
   desaparecidos comparten un mismo "estudio patrocinado" de Nyxos; los historiales se
   cortan en seco tras el ensayo).
3. **Morgue / pasillo (rh13, red herring)** → cinco empleados con acceso, **todos
   inocentes**: el mal no está en quien toca los papeles, sino en quien ordenó crearlos.
4. **Hospital — habitación (l13b)** → PISTA *"Diego en la lista"* (Diego ha recaído y
   Nyxos lo ha vuelto a reclutar para presionar a Nora: "que la detective piense en su
   familia"). *(2 ramas: ternura vs. rabia contenida.)*
5. **Hospital — archivo final (fin13)** → PISTA *"El código del proyecto"* (todos los
   historiales llevan el sello **"Proyecto SOMNIA — Nivel Consejo"**; la orden nace del
   consejo de Nyxos). `cap13_completo`. *(2 ramas: vértigo vs. endurecerse.)*
6. **Comisaría (cierre13)** — hay que probar que es sistemático más allá de la ciudad;
   rumores de un **centro/balneario en la costa**. `done_cierre13` → abre el Cap. 14.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | Los sujetos de prueba | Archivo médico | "Los historiales cruzan a los desaparecidos con un mismo 'estudio patrocinado' de Nyxos." |
| 2 | Diego en la lista | Hospital | "Diego ha recaído y aparece de nuevo reclutado por Nyxos: lo usan para presionar a Nora." |
| — | El código del proyecto | Hospital (fin) | "Todos los historiales llevan un código: 'Proyecto SOMNIA — Nivel Consejo'. La orden viene del consejo de Nyxos." |

## 7. Pistas falsas (red herring — la morgue)
| Título | Por qué se descarta |
|--------|---------------------|
| El celador dormilón | Solo teme que lo pillen durmiendo en el turno de noche. |
| El informático | Digitalizó los historiales sin leer ni uno; escaneó por lotes. |
| La auxiliar nueva | Confunde carpetas por torpeza de novata, no por sabotaje. |
| El jefe de archivo | Firma todo sin mirar desde hace veinte años; vago, no cómplice. |
| El estudiante de prácticas | Fotografió un historial... para un trabajo de clase. |

**Lectura del capítulo:** ninguno de los cinco decidió nada. La culpa no está en la
mano que toca el papel, sino en el **código** que lo mandó crear, aprobado arriba.

## 8. Condiciones de progreso
- El **fin del capítulo** (`fin13`) porta la pista clave *"El código del proyecto"* y
  activa `cap13_completo`.
- El **cierre** (`cierre13`) activa `done_cierre13` y siembra el gancho del centro de la
  costa, abriendo el **Capítulo 14** ("El pueblo de la costa").

## 9. Estado de implementación
1. ✅ 6 entradas encadenadas (`brief13`→`cierre13`) con densidad canon (~85 líneas).
2. ✅ 3 ramas de elección (brief, escena con Diego, revelación del código).
3. ✅ Pistas, red herring y `revisit` preservados carácter por carácter.
4. ✅ Fondos reutilizados (`comisaria`, `archivo_medico`, `morgue`, `hospital`) y
   reparto válido (`detective`, `nunez`, `sonia`, `diego`, `narrador`).
5. ✅ Gancho de Temporada abierto hacia la costa (Cap. 14).

---
*El caso ya no persigue a un hombre: persigue una decisión colectiva. Y esa decisión
tiene doce firmas y un sello violeta.*
