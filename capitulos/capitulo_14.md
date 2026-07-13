# sOC — Capítulo 14: "El pueblo de la costa"

> Guión del capítulo 14 (Temporada 3, trama Nyxos). Documento de diseño narrativo
> + de misión.
> Estado: **expandido a densidad canon** (ADR 7-bis). Versión 0.2.
>
> **Implementación:** el guión vive en `scripts/Story.gd` (entradas `brief14`, `l14a`,
> `rh14`, `l14b`, `fin14`, `cierre14`). Mapa propio de la región: pueblo de la costa
> (`mapa_costa`). Se entra al cerrar el Capítulo 13 y avanza al 15 con `done_cierre14`.

---

## 1. Premisa
Después de destapar la fábrica de la serpiente en la ciudad, el hilo baja al sur. Un
**pueblo de la costa**, blanco y azul, con un **balneario de salud** de Nyxos plantado
sobre el acantilado. Un balneario que promete talasoterapia y reposo, y del que los
vecinos suben a curarse y no vuelven a bajar. **Nora** baja sin placa, como una turista
más, y descubre que aquí Nyxos no recluta mujeres del Barrio Viejo: recluta a **jubilados
solos y enfermos crónicos** del propio pueblo, gente que en los folletos llaman "sin
cargas". La misma cantera, otro paisaje. El **libro de bajas del ayuntamiento** esconde a
**veinte vecinos** "trasladados a tratamiento" que nunca regresaron —y por los que nadie
preguntó, porque no tenían familia—. En el sótano del balneario, la revelación: es
**idéntico** al laboratorio central. Nyxos no oculta desapariciones: las **industrializa**.
Es una **red nacional**.

## 2. Tono
Noir de mar. Salitre, plomo y viento en vez de neón y lluvia sucia. El pueblo pequeño como
cómplice mudo: todos saben, nadie pregunta. La caridad de folleto ("plazas subvencionadas
para vecinos sin recursos ni familia") como el filtro más frío de todos. El mar, testigo
que Nyxos no puede comprar ni callar. Nada sobrenatural: solo una eficiencia empresarial
aplicada al olvido de las personas.

## 3. Personajes
- **Nora** (jugadora) — baja de incógnito, con la rabia ya guardada de quien reconoce el
  patrón antes de verlo.
- **Sgto. Núñez** — la brief y el cierre; su ancla, la cubre en la distancia y le trae el
  gancho de la montaña.
- **La funcionaria del ayuntamiento** — voz de pueblo, harta y avergonzada, que saca el
  libro de bajas "casi por rebeldía" (implementada como voz de `narrador`, sin clave nueva).
- **Voces del puerto** (red herring) — pescador, tabernero, guardacostas, la "bruja" y un
  forastero: rumor, miedo y folclore, ninguno con prueba.
- **Nyxos Pharma** — el villano-estructura; aquí ya no una clínica, sino un "Centro Sur-3"
  con protocolo estándar y numeración de sucursal.

## 4. Objetivo del capítulo
Reunir las **4 pistas** que prueban que el balneario es otro centro de ensayos, descartar
el ruido del puerto, sacar del cajón la lista de los **veinte desaparecidos del sur** y
bajar al **sótano** para descubrir que el horror está **replicado en serie** por todo el
país. Gancho: existe un centro aún más escondido —un **sanatorio de montaña**— y, por
primera vez, quizá **un superviviente** (cap. 15).

## 5. Estructura (cadena de localizaciones)
1. **Comisaría (brief14)** — Núñez muestra el folleto del balneario y el patrón de "traslados
   sin vuelta" → Nora baja sin placa. *(Rama: entrar como turista discreta / bajar con la
   rabia por delante.)*
2. **La costa / balneario (l14a)** → PISTA *"El balneario"* (otro centro de ensayos
   encubierto; aquí la cantera son jubilados y enfermos "sin recursos ni familia") → revela
   el puerto.
3. **Puerto pesquero (rh14, red herring)** → cinco rumores de pueblo (pescador, tabernero,
   guardacostas, bruja, forastero) que se hunden como la marea → apunta al libro de bajas.
4. **Ayuntamiento (l14b)** → PISTA *"Los desaparecidos del sur"* (veinte vecinos
   "trasladados a tratamiento" sin una sola fecha de reingreso) → desbloquea el sótano.
   *(Rama: ser dura con la funcionaria / ser humana con ella.)*
5. **Sótano del balneario (fin14)** (requiere las pistas) → PISTA *"No es solo una ciudad"*:
   el sótano es idéntico al laboratorio central; cartel "Centro Sur-3, protocolo estándar":
   red nacional. Marca `cap14_completo`. *(Rama: sentir el vértigo / endurecerse y trabajar.)*
6. **Comisaría (cierre14)** — costa y ciudad, mismo método; Núñez trae el gancho: un sanatorio
   de montaña y, quizá, un testigo vivo. `done_cierre14` → pasa al Capítulo 15.

## 6. Pistas (Libreta)
| # | Título | Cómo se obtiene | Texto |
|---|--------|-----------------|-------|
| 1 | El balneario | Costa | "El 'balneario de salud' de Nyxos en el pueblo costero es otro centro de ensayos encubierto." |
| 2 | Los desaparecidos del sur | Ayuntamiento | "El registro del pueblo esconde una lista de vecinos 'trasladados a tratamiento' que nunca regresaron." |
| — | No es solo una ciudad | Sótano | "El balneario prueba que Nyxos replica el sistema por todo el país: es una red nacional." |

## 7. Pistas falsas (red herring, puerto)
| Título | Por qué se cae |
|--------|----------------|
| El pescador chismoso | Mezcla leyendas, faro y aguardiente. |
| El dueño del bar | Repite rumores para vender más vino. |
| El guardacostas | Sus "luces raras" eran pesca furtiva, no Nyxos. |
| La bruja del pueblo | Superstición ("roba la vida") con solo un poso de verdad. |
| El forastero | Un simple periodista de viajes que pregunta de más. |

## 8. Condiciones de progreso
- El **sótano** (fin14) se abre con las pistas de la investigación de la costa.
- Cerrar el sótano (`cap14_completo`) abre la **comisaría de cierre**; su diálogo activa
  `done_cierre14`, que **avanza automáticamente al Capítulo 15** (el sanatorio de montaña).

## 9. Estado de implementación
1. ✅ 6 localizaciones encadenadas con diálogos densos (ADR 7-bis) y pistas.
2. ✅ 3 ramas de elección (brief, ayuntamiento, sótano); sin ramas en red herring ni cierre.
3. ✅ Campos de cableado (`bg`, `flag`, `clue`, `clues`, `revisit`) preservados carácter a
   carácter respecto al esqueleto.
4. ✅ Gancho al cap. 15: red nacional, sanatorio de montaña y posible superviviente.
5. ⏳ Fondos IA propios de la costa (`costa`, `puerto_pesca`, `balneario`, `sanatorio_costa`).

---
*El mar guarda a los desaparecidos del sur. Arriba, en la montaña, quizá respire un testigo.*
