# sOC — Capítulo 7: "La receta"  (Temporada 3)

> Implementado en `scripts/Story.gd` (diccionario `S3`, prefijo `*7`). Se entra al
> cerrar el Cap. 6. Diálogos concisos (ampliables al canon de ~5 min).

## 1. Premisa
Una de las mujeres del caso Vaultier aparece muerta: no se ahogó, la mató un fármaco
experimental en la sangre, **Somnia**. Era lo que las tenía dóciles durante los
secuestros. No lo cocina un camello: sale de un laboratorio. El caso no acabó con
Vaultier; era la punta de algo más grande.

## 2. Personajes
- **Sonia** — forense, mejor amiga de Nora; identifica Somnia.
- **Dr. Kessler** — sospechoso: médico que recetaba a las víctimas.

## 3. Cadena de localizaciones
1. **Comisaría (brief7)** → Morgue.
2. **Morgue (l7a · Sonia)** → PISTA *"El fármaco Somnia"*.
3. **Hospital (l7b)** → PISTA *"El médico que receta"* (Dr. Kessler).
4. **Clínica de Kessler (fin7)** → confiesa que "seleccionaba pacientes" por encargo;
   membrete de una serpiente en una copa. `cap7_completo`.
5. **Comisaría (cierre7)** — el hilo sube hacia un laboratorio. `done_cierre7` → Cap. 8.

## 4. Pistas falsas (5)
En **rh7** Nora descarta cinco leads fáciles: *El camello del puente · El veterinario ·
La enfermera despedida · El químico jubilado · El curandero*. Ninguno fabrica Somnia.

## 5. Estado
✅ Implementado y validado. Arte 4K: `morgue`, `hospital`, `clinica`; retratos `sonia`, `kessler`.
