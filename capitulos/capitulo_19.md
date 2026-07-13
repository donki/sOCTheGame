# sOC — Capítulo 19: "La directora"

> Guión del decimonoveno capítulo (Temporada 3, penúltimo de la trama Nyxos).
> Documento de diseño narrativo + de misión.
> Estado: **expandido a densidad canon** (§7-bis). Versión 0.1.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (entradas `brief19`, `l19a`,
> `rh19`, `l19b`, `fin19`, `cierre19`). Se entra al cerrar el Capítulo 18. Cerrarlo
> (`cap19_completo` + `done_cierre19`) abre el Capítulo 20, el golpe final.

---

## 1. Premisa
El ascenso capa a capa toca por fin la cima visible: la **Dra. Adler**, presidenta y
directora científica de Nyxos. Con la orden judicial y la tarjeta de acceso de **Marco**,
Nora entra en la planta noble a arrancarle una confesión y, sobre todo, a **rescatar a
Diego**, sedado en una sala anexa. Pero la cima no es la cumbre: la carpeta azul que Diego
ha escondido revela que **sobre la firma de Adler hay otra** —"Aprobado por el Consejo, en
representación de los accionistas"—. El villano no es una mujer con premios: es una
**estructura**. Nora decide no llevarse un chivo expiatorio, sino la bestia entera.

## 2. Tono
Noir de despacho blanco. Frío quirúrgico, soberbia glacial, cortesía como arma. Adler es un
espejo de Vaultier (cap. 3) pero con bata: la misma convicción de estar por encima del bien
y del mal, con un matiz nuevo y demoledor —ella **ejecuta**, no reina—. El calor emocional
lo aporta el **reencuentro con Diego**; el escalofrío intelectual, la revelación de que el
culpable es un logo, no un rostro.

## 3. Personajes
- **Nora** (jugadora) — sube el último peldaño; pasa de buscar una cabeza a querer la bestia entera.
- **Sgto. Núñez** — la prepara y la recibe; propone el golpe único y coral del cap. 20.
- **Dra. Adler** — presidenta y directora científica de Nyxos; soberbia glacial, se cree progreso necesario; clave: **habla como quien ejecuta** ("llevo la contabilidad", no "yo decido").
- **Diego** — hermano de Nora, sedado pero vivo; escondió la carpeta azul; su lucidez guía la escena.
- **Marco** — off/silente: su tarjeta abre la sala anexa (lealtad vieja que ya despertó).

## 4. Objetivo del capítulo
Entrar en Nyxos con la orden, **medir a Adler** y detectar que ejecuta y no decide, **descartar
a los cinco satélites** que fingen mandar, **rescatar a Diego** y hacerse con la **carpeta azul**,
y comprender que sobre Adler está el **consejo en nombre de los accionistas**: el culpable es
**Nyxos entera**. Salir con la certeza de que hace falta una jugada perfecta.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief19)** — Núñez entrega la orden y advierte: Adler encanta, no amenaza →
   Nora entra a por ella y a por Diego. *(rama: cómo encara la visita / miedo por Diego)*
2. **Despacho de Adler (l19a)** → PISTA *"La directora Adler"*: defiende Somnia como progreso
   necesario, soberbia tipo Vaultier; Nora capta que **habla como quien ejecuta**.
3. **Planta noble / RR. PP. (rh19, red herring)** → cinco satélites que parecen mandar
   (prensa, secretario, médico estrella, ventas, accionista visible); todos brillan por reflejo.
4. **Sala anexa / piso franco (l19b)** → PISTA *"El proyecto Somnia"*: con la tarjeta de Marco,
   **rescate de Diego** y hallazgo de la carpeta azul con el plan completo y **una firma sobre
   la de Adler**. *(rama: sacar a Diego primero / prometerle que se acabó)*
5. **Despacho de Adler (fin19)** → PISTA *"Adler no está sola"*: Adler admite "el proyecto no
   soy yo, es Nyxos"; Nora decide llevarse la corporación entera. `cap19_completo`.
6. **Comisaría (cierre)** — Núñez propone el golpe único y coral: mañana, en su propia casa,
   con todos los aliados. `done_cierre19` → gancho del Capítulo 20.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | La directora Adler | Despacho | "Adler defiende Somnia como 'progreso necesario'; se cree por encima del bien y del mal, como Vaultier." |
| 2 | El proyecto Somnia | Sala anexa | "Rescatas a Diego de una sala de Nyxos; entre sus papeles, el plan completo de Somnia... y una firma por encima de Adler." |
| 3 | Adler no está sola | Despacho (fin) | "El plan revela que Adler solo cumple: el proyecto Somnia lo sostiene y financia el consejo en nombre de los accionistas. El culpable es la corporación." |

## 7. Pistas falsas (red herring, RR. PP.)
| Título | Por qué cae |
|--------|-------------|
| El jefe de prensa | Parece el titiritero; solo maquilla lo que otros deciden. |
| El secretario de Adler | Controla la agenda; sabe horarios, no decisiones. |
| El médico estrella | Cara pública en congresos; un maniquí con bata. |
| La jefa de ventas | Coloca el fármaco; vendedora, no diseñadora del horror. |
| El accionista visible | Sale en las fotos; testaferro de los accionistas reales, ocultos. |

## 8. Condiciones de progreso
- El **despacho final (fin19)** requiere haber rescatado a Diego y la carpeta azul (l19b).
- Cerrar el despacho (`cap19_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre19`, que desbloquea el **Capítulo 20** (el golpe final contra Nyxos).

## 9. Estado de implementación
1. ✅ 6 localizaciones encadenadas con diálogos densos, pistas y red herring.
2. ✅ Reescritura a densidad canon (§7-bis) con narrador ambiental y monólogos internos.
3. ✅ 3 ramas de elección (brief, rescate de Diego) sin ramas en rh ni cierre.
4. ✅ Revelación clave: el villano es una estructura (consejo + accionistas), no Adler.
5. ✅ Gancho al Capítulo 20: la jugada perfecta, un solo golpe con todos los aliados.
6. ✅ Arte 4K: `oficina`, `despacho_rrpp`, `piso_franco`, `comisaria`; retrato `adler`.

---
*Penúltimo peldaño. La cima visible resulta ser una firma más bajo otra sin rostro: el monstruo tiene logo, no cara.*
