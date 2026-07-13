# sOC — Capítulo 5: "La subasta"  (Temporada 2)

> Estado: **implementado como NOVELA VISUAL**. Guión en `scripts/Story.gd`
> (`CHAPTERS[5]` + `_ch5_dialogue`). Se entra al cerrar el Cap. 4 (`done_cierre4`).

## 1. Premisa
Con el libro de envíos, Nora sigue al **Corredor** hasta el corazón del negocio: una
**subasta** mensual donde el Cónclave del Bronce "vende" a las víctimas a clientes con
apellido. Para entrar necesita el favor de la anfitriona, **Madame Ourense**, y la
lista de clientes. La noche de la puja, revienta la subasta y el Corredor jefe, para
salvarse, delata a la cima: unas iniciales, **A.V.**

## 2. Personajes nuevos
- **Madame Ourense** — anfitriona de la subasta; elegante y cruel.
- **El Corredor jefe** — cabeza del transporte del gremio.
- **Sisebuto** — cargador asustadizo del muelle (usa el retrato del chivato).

## 3. Objetivo
Reunir 3 pistas (lista de clientes, sello de la casa, corredor jefe) e infiltrarse en
la **subasta** para reventarla y arrancar el nombre de arriba.

## 4. Cadena de localizaciones
1. **Comisaría (brief5)** → Muelle.
2. **Muelle (contacto)** → PISTA *"La lista de clientes"* → Salón. *(Aparece el red herring.)*
3. **Salón privado (Madame Ourense)** → PISTA *"El sello de la casa"* → Trastienda.
4. **Trastienda** → PISTA *"El corredor jefe"* (y una nota: 'consultar con A.V.') → Subasta.
5. **La subasta** (3 pistas) → redada; rescate de Sara Beltrán; el Corredor delata a
   **Aristide Vaultier**. `cap5_completo`.
6. **Comisaría (cierre5)** — el objetivo es Vaultier. `done_cierre5` → Cap. 6.

## 5. Pista FALSA (red herring)
- **Chatarrería (falso5)**: el Rubio, jefe de un desguace con matones, **parece** el
  pez gordo, pero solo trafica con coches robados y tabaco. *"El chatarrero"* → descartada.

## 6. Estado
✅ 7 localizaciones (incl. red herring) con diálogos, pistas y clímax. ✅ Arte 4K
(fondos `muelle` reuso, `subasta`, `almacen` reuso; retrato `madame`, `corredor`).
⏳ Ampliar diálogos al canon de ~5 min.
