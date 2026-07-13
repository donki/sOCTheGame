# sOC — Capítulo 15: "El pueblo de montaña"  (Temporada 3)

> Guión del decimoquinto capítulo. Documento de diseño narrativo + de misión.
> Estado: **implementado como NOVELA VISUAL** en `S3` (prefijo `*15`).
> Se entra al cerrar el Cap. 14 (bandera `done_cierre14`).
>
> **Mapa propio de la región**: pueblo de montaña (`mapa_montana`).

---

## 1. Premisa
Nyxos regenta un antiguo sanatorio en la alta montaña, aislado por la nieve medio año,
bajo la fachada de "cuidados paliativos". Suben "enfermos" que caminan solos, con maleta,
y de allí solo bajan cajas cerradas. La clave es humana: **Irene**, la primera persona que
escapó con vida —descalza, de noche— y a la que nadie creyó ("está enferma, delira").
Escondida en una buhardilla del pueblo desde hace meses, cuenta el método **desde dentro**:
los numeraban, los dormían con **Somnia** y a los que no respondían "bien" se los llevaban
de noche. Nora la pone a salvo bajo protección de Núñez. Por primera vez hay un **testigo
humano vivo y lúcido** contra el proyecto: la coartada "delira" deja de funcionar.

## 2. Tono
Frío que corta, piedra y humo de chimenea. Noir de montaña: el aislamiento como arma, la
caridad como tapadera, la nieve como censura. El horror ya no se esconde en un sótano
urbano, sino que ocurre a plena luz sobre la cumbre, protegido por la distancia y por el
descrédito de sus víctimas.

## 3. Personajes
- **Nora** (jugadora) — sube a escuchar, no a acusar; aprende que a un testigo roto la
  verdad no se le arranca, se le merece.
- **Sgto. Núñez** — la briefa y la ancla; recoge a Irene abajo y le organiza el blindaje.
- **Irene** (`testigo`) — superviviente número 31 del sanatorio; frágil, lúcida, a la que
  el pueblo entero decidió no creer. El testigo humano clave del arco.
- **Cinco leyendas de montaña** (red herring): el ermitaño, el cazador, el cura, la
  posadera y el niño. Miedo real, prueba nula.
- Menciones: **Sonia** (informe forense de lucidez) y **Clara** (declaración blindada).

## 4. Objetivo del capítulo
Subir a la montaña, descartar las leyendas del pueblo, **encontrar a Irene**, ganarse su
testimonio y **blindarlo** junto a las pruebas materiales del sanatorio, de modo que la
etiqueta de "delirio" ya no pueda enterrar el caso.

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief15)** — Núñez describe el sanatorio y el parte antiguo de la mujer que
   bajó gritando; Nora reconoce en ella a un testigo, no a un rumor. *(2 ramas: subir con
   guantes / no esperar al deshielo.)* → revela la Montaña.
2. **Pueblo de montaña (l15a)** → PISTA *"El sanatorio de montaña"* (suben sanos con maleta,
   bajan cajas; a un hospicio de terminales no llega gente que carga su equipaje) → revela
   la cabaña.
3. **Cabaña del ermitaño (rh15)** — cinco leyendas junto al fuego; todas miedo, ninguna
   prueba. Señala a Irene. *(Sin ramas.)*
4. **Sanatorio · buhardilla, Irene (l15b)** → PISTA *"La superviviente"*; Irene cuenta el
   método desde dentro (números, Somnia, la puerta de un solo sentido). *(2 ramas: darle
   tiempo / pedir el método paso a paso.)*
5. **Sanatorio evacuado (fin15)** (requiere las pistas del capítulo) → PISTA *"El testimonio
   vivo"*: Irene a salvo bajo Núñez; batas numeradas, viales y la puerta con cerrojo por
   fuera confirman su relato palabra por palabra. *(2 ramas: los números sin nombre / blindar
   el testimonio.)* `cap15_completo`.
6. **Comisaría (cierre15)** — Nyxos alegará "filial rebelde" y casos aislados; hay que probar
   que es la MISMA mano en otra ciudad. `done_cierre15` → **Cap. 16**.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | El sanatorio de montaña | Pueblo (l15a) | "El sanatorio de Nyxos en la montaña recibe 'pacientes terminales' que en realidad están sanos." |
| 2 | La superviviente | Irene (l15b) | "Una mujer que escapó del sanatorio, escondida en el pueblo, acepta hablar por primera vez." |
| — | El testimonio vivo | Sanatorio (fin15) | "Con la superviviente y las muestras, hay por fin un testigo humano contra el proyecto Somnia." |

## 7. Pistas falsas (5)
En **rh15** (`cabana_ermitano`): *El ermitaño lunático · El cazador · El cura del pueblo ·
La posadera · El niño del pueblo*. Son leyendas de montaña: miedo genuino, valor probatorio
nulo. La única prueba que aguanta un juicio es Irene.

## 8. Condiciones de progreso
- El **sanatorio (fin15)** se abre con las pistas del capítulo.
- Cerrar el sanatorio (`cap15_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre15`, que da paso al **Cap. 16 · La otra ciudad**.

## 9. Estado de implementación
✅ Seis entradas encadenadas (`brief15`, `l15a`, `rh15`, `l15b`, `fin15`, `cierre15`) a
densidad canon (§7-bis), con 4 puntos de rama y monólogos internos de Nora.
✅ Cableado intacto: `bg`, `flag`, `clue`/`clues` y `revisit` preservados carácter por carácter.
✅ Arte 4K: `montana`, `sanatorio_montana`, `cabana_ermitano`; mapa `mapa_montana`; retrato `testigo`.

---
*Por fin una voz que sobrevivió a la nieve. Y el mapa de Nyxos se abre hacia otras ciudades.*
