# sOC — Capítulo 2: "Las campanas que faltan"

> Guión del segundo capítulo. Documento de diseño narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL**. Versión 0.1.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (bloque `CHAPTERS[2]` y
> `_ch2_dialogue`). El capítulo se juega igual que el 1: se marcan localizaciones en
> el mapa (`scenes/CityMap`) y se juega en escenas de diálogo (`scenes/DialogueScene`).
> Se entra en él automáticamente al cerrar el Capítulo 1 (bandera `done_comisaria`).

---

## 1. Premisa
Con la carpeta gris del sargento Núñez en la mano, la detective **Nora** ya no
investiga una desaparición: investiga una **serie**. Tres mujeres —Elena Ruiz,
Nadia Kovač y Marta Soler— desaparecidas en tres iglesias distintas, tres noches
de tormenta. Alguien de arriba cierra los casos en 48 horas. Nora tira del hilo y
descubre que las tres pasaron por la misma puerta antes de esfumarse: la
**Fundación Amparo**, un refugio benéfico demasiado lujoso para lo que dice ser.

## 2. Tono
Noir de conspiración. La lluvia sigue, pero el barrio se abre hacia arriba: hacia
el dinero, los despachos y la placa. La caridad como tapadera; la amabilidad como
anzuelo. Nada sobrenatural: solo poder impune.

## 3. Personajes
- **Nora** (jugadora) — ahora fuera del paraguas oficial; sola.
- **Sgto. Núñez** — su único aliado dentro; se juega la jubilación.
- **Laura Soler** — hermana de Marta; el duelo y la primera pista personal.
- **Sr. Vidal** — administrador de la Fundación Amparo; sonrisa de dentífrico, evasivo.
- **El benefactor / encapuchado** — mecenas anónimo con **anillo de sello**; el mismo
  hombre que Tomás vio en el Cap. 1.

## 4. Objetivo del capítulo
Reunir las **4 pistas** que conectan a las víctimas con la Fundación y con una **mano
policial infiltrada**, y llegar al **muelle** a tiempo de (casi) atrapar al benefactor,
descubriendo que hay un policía implicado. Gancho: la firma apunta a un apellido con
escudo.

## 5. Estructura (cadena de localizaciones)
Cada localización se revela porque en la anterior se habla de ella:
1. **Comisaría (brief)** — Núñez entrega los tres nombres → revela el Archivo.
2. **Archivo policial** → PISTA *"El hilo común"* (las tres pasaron por Amparo; un memo
   pide los horarios de misa) → revela a Laura.
3. **Casa de Laura** → PISTA *"El voluntariado"* (Marta era voluntaria; un benefactor se
   fijó en ella) → revela la Fundación.
4. **Fundación Amparo** → PISTA *"El benefactor"* (mecenas anónimo con anillo; "retiros"
   por invitación; una capilla privada abajo) → revela la Capilla.
5. **Capilla privada** → PISTA *"La agenda de misas"* (libro con horarios + memo policial
   que ordena no asignar patrullas; emblema de **tres campanas**) → desbloquea el Muelle.
6. **Muelle viejo** (requiere las 4 pistas) → confrontación: el benefactor escapa, pero
   su chófer lleva **placa**; queda su mechero con el escudo. Marca `cap2_completo`.
7. **Comisaría (cierre)** — Núñez identifica el vehículo: despacho del **comisario Bru**.
   Retiran a Nora del caso desde arriba. `done_cierre2` → pasa al Capítulo 3.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | El hilo común | Archivo | "Las tres víctimas pasaron por la Fundación Amparo antes de desaparecer." |
| 2 | El voluntariado | Laura | "Marta era voluntaria en Amparo; un 'benefactor' se había fijado en ella." |
| 3 | El benefactor | Fundación | "Un mecenas anónimo con anillo de sello financia 'retiros' desde la Fundación." |
| 4 | La agenda de misas | Capilla | "Un libro con los horarios de misa de las tres parroquias y una copia de un memo policial." |
| — | La cuarta víctima | Muelle | "El benefactor prepara una cuarta. Su chófer lleva placa: hay un policía implicado." |

## 7. Condiciones de progreso
- El **muelle** solo se abre con las **4 pistas** de la investigación.
- Al cerrar el muelle (`cap2_completo`) aparece la **comisaría de cierre**; su diálogo
  activa `done_cierre2`, que **avanza automáticamente al Capítulo 3**.

## 8. Estado de implementación
1. ✅ Framework de capítulos (`CHAPTERS`, `Global.chapter`, avance en `CityMap`).
2. ✅ 7 localizaciones encadenadas con sus diálogos y pistas.
3. ✅ Revisitas ("ya lo conté todo" + pista + siguiente destino).
4. ✅ Fondos IA (`archivo`, `refugio`, `muelle`) y retratos (`laura`, `vidal`).
5. ⏳ Ampliar diálogos a los ~5 min del canon (§7-bis) si se desea.
