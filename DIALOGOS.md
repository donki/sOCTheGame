# sOC the Game — Guion completo de diálogos

> Extracción automática de todos los diálogos jugables del proyecto Godot.
> **No es un fichero del juego**: es un volcado para revisión del guion.

## Nota sobre el origen de los textos

Todos los diálogos jugables viven en un único fichero: **`scripts/Story.gd`**.

- Los **capítulos 1–6** se definen como funciones `static func _dlg_*()`.
- El **capítulo 7** usa la versión ampliada ("canon largo") en funciones `_dlg_*7()`.
- El **capítulo 0 (tutorial)** y los **capítulos 8–20** son dirigidos por datos en el diccionario `const S3`.
- Los personajes y sus nombres visibles proceden del diccionario `const CHARS` del mismo fichero.
- Existe además un diccionario `const INTERACT` con mini-escenas interactivas (búsqueda / examen / puzzle / presentar prueba / deducción); su texto de ambientación y las frases de "presentar prueba" se recogen en el **Apéndice** al final.

Idioma: **todo el guion está en español** (no hay ficheros de traducción `.po`/`.csv` ni versiones multi-idioma).

Los ficheros de `capitulos/*.md` son **documentos de diseño narrativo**, no diálogo jugable, por lo que no se incluyen aquí.

Convenciones de este volcado:
- **Narrador:** = voz en off (`who: "narrador"`).
- Cada bloque `###` es una escena; el subtítulo indica su origen exacto en `Story.gd`.
- `*(Opción del jugador)*` marca una ramificación elegible; las líneas que siguen son su rama.
- `> PISTA` es la pista que la escena anota en la libreta.


**Resumen de extracción:** 1 fichero de origen con diálogo (`scripts/Story.gd`); **136 escenas** de diálogo y **~1474 líneas/opciones** de personaje extraídas, más **81 fragmentos** de texto en el apéndice de mini-escenas.


## Reparto (nombres visibles)

- `detective` → **Nora**
- `emilio` → **Don Emilio**
- `rosa` → **Rosa**
- `tomas` → **Tomás**
- `carmen` → **Doña Carmen**
- `nunez` → **Sgto. Núñez**
- `marta` → **Marta Soler**
- `encapuchado` → **¿?**
- `laura` → **Laura Soler**
- `padre` → **Padre Ismael**
- `vidal` → **Sr. Vidal**
- `comisario` → **Comisario Bru**
- `nano` → **Nano**
- `periodista` → **Vera Lang**
- `corredor` → **El Corredor**
- `madame` → **Madame Ourense**
- `magnate` → **Aristide Vaultier**
- `chivato` → **El chivato**
- `voluntario` → **Voluntario**
- `contable` → **El contable**
- `anonimo` → **¿?**
- `diego` → **Diego Vega**
- `sonia` → **Sonia**
- `clara` → **Clara**
- `ruben` → **Insp. Rubén**
- `marco` → **Marco**
- `kessler` → **Dr. Kessler**
- `adler` → **Dra. Adler**
- `testigo` → **Testigo**
- `sospechoso` → **Sospechoso**
- `narrador` → *(voz en off, sin nombre)*


## Capítulo 1 · Desaparición en la iglesia

### Plaza (llegada)
_fuente: _dlg_plaza()_

**(Narrador/voz en off):** Barrio Viejo. Medianoche. La lluvia no da tregua desde que sonaron las campanas a rebato.

**Nora:** Así que aquí es. Una mujer se esfuma en plena misa y nadie ve nada. Curioso.

**Nora:** Marta Soler. Treinta y dos años. Entró en la iglesia... y no volvió a salir.

**(Narrador/voz en off):** El barrio duerme a medias tras las contraventanas. Alguien vio algo. Alguien siempre ve algo.

**Nora:** Marta Soler vivía a dos calles de aquí. Empezaré por su casa.

**Nora:** El barrio es mío esta noche.


### Casa de Marta
_fuente: _dlg_marta_house()_

**(Narrador/voz en off):** La casa de Marta sigue vacía, como la dejaste. La taza fría, la cama sin hacer.

**Nora:** La cita sin nombre en su agenda. Y Don Emilio, que estaba en misa. Sigo por ahí.

> **PISTA — La cita sin nombre:** En la agenda de Marta, una cita sin nombre la noche en que desapareció.

**(Narrador/voz en off):** El portal cede a la primera. Ni forzado ni cerrado con llave: entornado, como si Marta hubiera salido a por pan y fuera a volver en cualquier momento. No va a volver.

**Nora:** Primera regla: la casa de una persona habla más que la persona. Veamos qué me cuenta la tuya, Marta.

**(Narrador/voz en off):** Un piso pequeño, ordenado con esmero de quien tiene poco y lo cuida. Una taza de té a medias sobre la mesa, con una película fría en la superficie. La cama sin hacer. Todo detenido a media frase.

**Nora:** El té sin terminar. La cama deshecha. Salió con prisa, de noche, sin pensar en volver a una taza. O sin poder.

**(Narrador/voz en off):** En la estantería, una foto: Marta y otra mujer muy parecida, abrazadas, riéndose en una playa gris. Detrás, escrito a bolígrafo: 'Hermanas, pase lo que pase'.

**Nora:** Una hermana. Alguien a quien esto le va a partir en dos. Tomo nota: hay que encontrarla.

**(Narrador/voz en off):** Sobre la mesa, la agenda abierta por la fecha de ayer. La mayoría de los días están en blanco. Solo la casilla de la noche tiene algo escrito, con letra nerviosa.

**Nora:** '23:00'. Una hora. Sin nombre. ¿A quién se cita una a las once de la noche y prefiere no escribir su nombre ni en su propia agenda?

**Nora:** A alguien a quien se teme. O a alguien prohibido. A veces son la misma persona.

- *(Opción del jugador)* **Registrar los cajones**
**(Narrador/voz en off):** En el cajón de la mesilla, bajo un rosario, un fajo de estampas religiosas de San Judas Tadeo. El de las causas perdidas. Y una, arrugada, con un número de teléfono a lápiz, casi borrado.

**Nora:** Rezaba a las causas perdidas y guardaba un número sin nombre. Marta, te estabas ahogando y no se lo dijiste a nadie.

- *(Opción del jugador)* **Mirar hacia la ventana**
**(Narrador/voz en off):** La ventana da justo a la torre de San José, negra sobre el cielo eléctrico. Desde el alféizar, alguien ha estado mirándola mucho: hay un cerco de tazas y una silla girada hacia el cristal.

**Nora:** Se sentaba a mirar el campanario. Como si de allí viniera lo que temía. O lo que esperaba.

**(Narrador/voz en off):** Clavada en la pared de la cocina, una circular de la parroquia: 'Misa de las 23:00. Rogamos puntualidad'. La misma hora de la cita.

**Nora:** La cita y la misa a la misma hora. No fue a rezar: fue a encontrarse con alguien a cubierto de todo el barrio. Qué mejor coartada que estar entre cien testigos.

**Nora:** Necesito a alguien que estuviera dentro de esa misa y con los oídos bien puestos. Don Emilio, el vecino, no se pierde una. Empiezo por él.


### El exnovio
_fuente: _dlg_exnovio()_

**Nano:** Que yo no fui, pesada. Estaba en el calabozo esa noche, pregúntale a tus colegas.

**(Narrador/voz en off):** El bar del Nano huele a lejía y a cerveza rancia. Neones de marcas baratas parpadean sobre una barra pegajosa. Detrás, un tipo fornido con los nudillos marcados te mira como quien mira a la policía: con asco.

**Nora:** Nano. Fuiste el novio de Marta Soler. El que le dejó dos costillas rotas el invierno pasado.

**Nano:** Eso es agua pasada. Y si ha desaparecido, yo no tengo nada que ver. Me tenéis manía en este barrio.

**Nora:** Un hombre que pega a su pareja y luego ella se esfuma. Entenderás que empiece por ti.

**Nano:** Empieza por donde quieras, pero mira antes tu propio archivo. La noche de la misa yo estaba en TU calabozo, por una pelea en el 12. Veinticuatro horas. Firmado y sellado.

**(Narrador/voz en off):** Una llamada rápida a comisaría lo confirma: Nano pasó toda la noche de la desaparición entre rejas. Imposible que estuviera en la iglesia.

**Nora:** (Coartada de hierro. El sospechoso obvio nunca es el bueno. Tacho a Nano.)

**(Narrador/voz en off):** En una esquina de la barra, un cliente fijo del Nano —el tendero de comestibles de la esquina— te hace señas con cara de tener un secreto que vender.

**Nora:** Me dicen que usted lo ve todo desde su mostrador. ¿Vio algo la noche de la desaparición?

**(Narrador/voz en off):** El tendero se arranca con un torrente de chismes sin bajarse del taburete: que si la Marta debía en tres tiendas, que si un primo la vio en la estación, que si un coche negro... Nada que se sostenga al preguntar dos veces.

**Nora:** (Chismes de mostrador, uno encima de otro, ninguno con pies. El tendero no vende información: vende ruido.)

**Nora:** Gracias por... todo esto. Cinco pistas fáciles y cinco callejones. El exnovio, el tendero, el pretendiente, el usurero, el vagabundo. Ninguno cuadra. Vuelvo al hilo que sí aguanta.


### Don Emilio
_fuente: _dlg_emilio()_

**Don Emilio:** Ya se lo conté todo, hija. Ese grito junto al altar... aún lo tengo metido en el oído.

**Don Emilio:** Hable con la Rosa, la del atrio. Ella vigilaba la puerta principal.

> **PISTA — El grito:** Durante las campanas se oyó un grito junto al altar.

**(Narrador/voz en off):** El portal huele a humedad y a geranios muertos. Llamas dos veces antes de que una cadena chirríe y una rendija de luz amarilla se abra en la penumbra.

**Don Emilio:** ¿Quién anda...? Ah. Usted es la detective de la ciudad. La estaba esperando, aunque no me lo crea.

**(Narrador/voz en off):** Don Emilio quita la cadena. Es un hombre menudo, encogido dentro de un jersey de lana que le viene grande. Le tiemblan las manos, pero no de miedo: de años.

**Don Emilio:** Pase, pase, que se está mojando y aquí dentro al menos hay caldo caliente. Siéntese. La silla buena es esa, la otra cojea.

**Nora:** Gracias. No le robaré mucho tiempo, Don Emilio.

**Don Emilio:** Tiempo es lo único que me sobra, hija. Lo que se me acaba es el sueño. Desde anoche no pego ojo.

**(Narrador/voz en off):** Sobre la cómoda, un retrato en blanco y negro de una mujer joven. Él sigue tu mirada y sonríe con tristeza.

**Don Emilio:** Mi Amparo. Cuarenta años juntos y dos viéndola marchar poco a poco. Por eso voy a misa cada noche. Ya no rezo por mí.

**Nora:** Anoche también estaba usted en la iglesia.

**Don Emilio:** En mi banco de siempre, el tercero por la izquierda. Desde ahí se ve el altar entero. Y se oye. Vaya si se oye.

**Nora:** Cuénteme la noche. Desde el principio, sin prisa.

**Don Emilio:** Llovía como ahora, o peor. El padre Ismael empezó tarde porque la gente entraba goteando. Estaba la iglesia llena, cosa rara en noche de tormenta.

**Don Emilio:** A media misa se soltó el viento y las campanas empezaron a batir solas, a rebato, como cuando yo era niño y avisaban de riada. Un estruendo que no dejaba oír ni el sermón.

**Don Emilio:** Y entonces, entre campanada y campanada... un grito. Uno solo. Corto, agudo. Junto al altar.

**(Narrador/voz en off):** Se le quiebra la voz. Aprieta el borde de la mesa con los nudillos blancos.

**Don Emilio:** Me giré. La muchacha, la Marta, estaba en la primera fila y de pronto ya no estaba. Como si el suelo se la hubiera tragado. Se me heló la sangre, detective. Se me heló.

- *(Opción del jugador)* **"¿Reconoció la voz del grito?"**
**Don Emilio:** Era de mujer, joven. Eso lo juraría. Pero con aquel repique... no le sabría decir si dijo un nombre o solo gritó por gritar.

**Don Emilio:** Aunque... hubo algo. Antes del grito me pareció oír unos pasos rápidos por el lateral. Botas, no zapatos de domingo. Botas.

**Nora:** (Botas. Otra vez las botas.)

- *(Opción del jugador)* **"¿Vio salir a alguien por la puerta?"**
**Don Emilio:** No, no... yo miraba al altar, como todos. La puerta grande la vigilaba la Rosa, esa nunca se mueve de su sitio. Pregúntele a ella, que tiene mejor vista que yo.

- *(Opción del jugador)* **"¿Notó algo raro en Marta esos días?"**
**Don Emilio:** La veía rezar mucho últimamente. Y mirar hacia atrás, hacia la puerta, como quien espera a alguien que no quiere que llegue.

**Don Emilio:** Una noche la vi santiguarse tres veces seguidas. Tres. Eso no lo hace quien está en paz.

**Nora:** ¿Y cuando encendieron las luces? Después del revuelo.

**Don Emilio:** El padre Ismael mandó callar y buscar. Miramos por todas partes. Nada. Ni la chica ni una pista. Solo el banco vacío y el reclinatorio caído.

**Don Emilio:** La gente empezó a decir que había sido un milagro al revés. Yo no creo en esas cosas. Los milagros no dejan un reclinatorio tirado de una patada.

**Nora:** Es usted mejor detective que la mitad de los míos, Don Emilio.

**Don Emilio:** Soy viejo, que no es lo mismo, pero se le parece. Uno aprende a mirar lo que sobra en un sitio y lo que falta.

**Don Emilio:** Y esa noche, en el altar, faltaba una muchacha y sobraban unos pasos con botas. Apúntelo, hija. Apúntelo bien.

**Nora:** Un grito junto al altar, en plena tormenta. Lo apunto. Gracias, Don Emilio.

**Don Emilio:** No me las dé. Encuéntrela. Y si ya no se puede... que al menos alguien pague por el reclinatorio de una patada. Vaya a ver a la Rosa. Ella vigilaba la puerta.


### Rosa
_fuente: _dlg_rosa()_

**Rosa:** Le repito lo mismo: por la puerta principal no salió nadie. Nadie.

**Rosa:** Si quiere más, hable con Tomás, el del colmado. Ese lo ve todo desde el mostrador.

> **PISTA — La puerta principal:** Nadie salió por la puerta principal: alguien vigilaba.

**(Narrador/voz en off):** El atrio de San José es un arco de piedra ennegrecida donde la lluvia repica como metralla. Bajo él, una mujer de verde botella fuma con la espalda muy recta, sin quitar ojo a la puerta grande.

**Rosa:** La estaba viendo cruzar la plaza. Camina usted como quien busca algo. Usted es la de la ciudad, la detective.

**Nora:** Rosa, ¿verdad? Me han dicho que anoche estuvo aquí, en la puerta.

**Rosa:** Aquí estoy siempre. Vendo estampas y velas a la entrada y a la salida. Cuarenta años haciéndolo. Esta puerta la conozco mejor que a mi marido, que en paz descanse.

**(Narrador/voz en off):** Da una calada larga. La brasa ilumina un rostro duro, de pómulos afilados y ojos que no parpadean.

**Nora:** Entonces, si alguien hubiera salido durante la misa, usted lo habría visto.

**Rosa:** No 'si'. Lo habría visto. Y no salió nadie. Ni durante la misa ni durante el revuelo. Por esta puerta no salió Marta Soler ni el Espíritu Santo.

**Nora:** Es una afirmación muy rotunda para una noche de tormenta.

**Rosa:** Mire, hija. Cuando empezaron las campanas a batir solas se me pusieron los pelos de punta y me pegué al quicio como una lapa. No me moví ni para persignarme. Si hubiera salido una mosca, la habría contado.

- *(Opción del jugador)* **"¿Y las otras puertas de la iglesia?"**
**Rosa:** La lateral, la de la sacristía, estaba cerrada con llave. Yo misma vi al padre echarla al empezar, que hay mucho desalmado que entra a robar el cepillo.

**Rosa:** Y luego está la del campanario. Pero por ahí no entra ni sale nadie en misa. Esa llave la lleva el sacristán colgada del cinto.

**Nora:** (La del campanario. Guardemos eso.)

- *(Opción del jugador)* **"¿Se distrajo en algún momento?"**
**Rosa:** Ni un segundo, ya se lo he dicho. Bueno... miento. Hubo uno.

**Rosa:** Cayó un rayo que iluminó la nave entera como si fuera de día, y todos, todos, levantamos la cabeza hacia las vidrieras. Un instante. Un parpadeo.

**Nora:** (Un instante puede bastar. Todos mirando arriba, y alguien moviéndose abajo.)

**Rosa:** No me mire así. Un rayo es un rayo. Cualquiera mira.

- *(Opción del jugador)* **"¿Conocía usted bien a Marta?"**
**Rosa:** Me compraba una vela cada noche. Blanca, la más barata. La encendía siempre en el mismo sitio: ante San José, el de los imposibles.

**Rosa:** Últimamente venía pálida, con ojeras. Y una noche me pidió una estampa de San Judas. El de las causas perdidas. Me dio no sé qué dársela.

**Nora:** Rosa, si nadie salió por delante y las laterales estaban cerradas... ¿cómo desaparece una mujer de una iglesia llena?

**Rosa:** Eso pregúnteselo a Dios, o al diablo, que de los dos hay en este barrio. Yo solo sé lo que vi. Y lo que no vi salir.

**Rosa:** Si quiere ojos en la CALLE y no en la puerta, hable con Tomás, el del colmado de la esquina. Ese, desde su mostrador, ve hasta lo que uno piensa.

**Nora:** Si nadie salió por delante... salió por otro sitio. Y solo queda uno. Gracias, Rosa.


### Tomás
_fuente: _dlg_tomas()_

**Tomás:** El tipo del capuchón, sí. Discutió con Marta. Ojalá me equivoque, pero mala espina me dio.

**Tomás:** Los secretos viejos del barrio, Doña Carmen. Pásese por su balcón.

> **PISTA — El encapuchado:** Marta discutió ayer con un hombre encapuchado.

**(Narrador/voz en off):** El colmado de Tomás tiene la persiana a media asta y un tubo de neón que parpadea sobre latas de conserva. Huele a café rancio y a serrín mojado. El tendero frota el mostrador con un trapo aunque ya brilla.

**Tomás:** Cierro en diez minutos, deten... ah. Usted no viene a comprar. Se le nota. Viene por la Marta.

**Nora:** Se nota mucho, por lo visto.

**Tomás:** En este barrio, forastero que aparece de noche, o es cura nuevo o es problema. Y usted no tiene cara de cura. Siéntese en el taburete, que cojea menos que yo.

**(Narrador/voz en off):** Deja el trapo. Tiene las manos grandes, agrietadas, de descargar cajas toda una vida. Los ojos, en cambio, son rápidos, listos.

**Tomás:** Marta venía cada noche. Leche, tabaco rubio y, los viernes, una tableta de turrón aunque no fuera Navidad. Decía que el azúcar la ayudaba a dormir. Buena chica. De las que pagan y saludan.

**Nora:** ¿Notó algo distinto en ella últimamente?

**Tomás:** Estaba asustada. Y no de deber dinero, que ese miedo lo conozco. Era otro. Miraba la calle antes de entrar. Y una vez me pidió salir por la puerta de atrás, la del almacén.

**Nora:** ¿Y usted la dejó?

**Tomás:** Claro que la dejé. A una mujer con ese miedo en la cara no le niegas una puerta. Ojalá le hubiera preguntado de quién huía. No lo hice. Con eso cargo yo ahora.

**(Narrador/voz en off):** Golpea el mostrador, más con pena que con rabia.

**Tomás:** Y ayer lo vi. Aquí mismo, en la esquina, bajo la farola que no funciona. Discutía con un hombre. Alto. Con capucha. No le vi la cara, se cuidó de no dármela.

**Tomás:** Ella le decía 'déjame en paz, ya te dije que no'. Él la agarró del brazo, fuerte. Salí con la escoba, más por hacer ruido que por otra cosa, y cuando llegué a la puerta ya no estaba. Se lo tragó la lluvia.

- *(Opción del jugador)* **"¿Le había visto antes por el barrio?"**
**Tomás:** Nunca. Y mire que yo conozco hasta a los gatos por su nombre. Ese no era de aquí. Olía a otra parte, ¿me entiende? A dinero y a ciudad.

**Tomás:** Los de aquí andan encogidos por la lluvia. Ese andaba recto, como si la lluvia fuera para los demás.

- *(Opción del jugador)* **"¿Recuerda algún detalle suyo?"**
**Tomás:** Botas. Buenas botas, de cuero, de las caras. Y bajo la capucha un abrigo largo, de paño fino. Un señorito jugando a ser sombra.

**Tomás:** Ah, y un anillo. En la mano con que la agarró. Grande, de sello. Brilló un segundo con el neón. Oro, o algo que quería parecerlo.

**Nora:** (Botas caras. Un anillo de sello. No es un vecino: es alguien que baja al barrio.)

- *(Opción del jugador)* **"¿Por qué no avisó a la comisaría?"**
**Tomás:** ¿A la comisaría? Ja. En este barrio, detective, la comisaría es donde van a morir las denuncias. Uno aprende a callar y a bajar la persiana.

**Tomás:** Aunque el sargento Núñez... ese es distinto. A ese sí le importaría. Si es que le dejan que le importe.

**Nora:** Un hombre de fuera, con dinero, que la agarra del brazo la víspera de desaparecer. Esto ya no huele a milagro.

**Tomás:** Nunca olió a milagro. Olió a lo de siempre: a alguien fuerte haciéndole daño a alguien que no puede defenderse.

**Tomás:** Si quiere entender el barrio de verdad, y quién puede entrar y salir sin que nadie chiste, hable con Doña Carmen. La del balcón de los geranios. Esa lo sabe todo antes de que pase.

**Nora:** Un encapuchado con botas caras y un anillo de sello. Lo apunto en negrita. Gracias, Tomás. Y baje la persiana esta noche.


### Doña Carmen
_fuente: _dlg_carmen()_

**Doña Carmen:** El campanario, niña. Ya te lo dije. Todo lo que sube por ahí, baja por detrás.

**Doña Carmen:** Ya tienes lo que necesitas. Entra en la iglesia de San José.

> **PISTA — El campanario:** La puerta del campanario estaba abierta esa noche.

**(Narrador/voz en off):** No hace falta llamar. Doña Carmen ya está en el balcón, entre geranios que gotean, envuelta en un mantón negro. Te mira bajar la calle como quien lleva rato esperando a un invitado que se retrasa.

**Doña Carmen:** Has tardado más de lo que pensaba, detective. Emilio, Rosa, el Tomás... todos antes que la vieja Carmen. Siempre igual. La última en la que piensan y la primera que sabe.

**Nora:** ¿Y qué sabe la vieja Carmen?

**Doña Carmen:** Sube. La puerta está abierta. En esta casa las puertas siempre están abiertas para quien busca la verdad. Es a los mentirosos a los que se las cierro.

**(Narrador/voz en off):** El piso huele a membrillo y a tiempo detenido. Relojes por todas partes, ninguno a la misma hora. Ella se sienta en una mecedora frente a la ventana, desde la que se ve, justo enfrente, el campanario de San José.

**Doña Carmen:** El Barrio Viejo guarda secretos, hija. Y yo los guardo todos, porque desde este balcón llevo cincuenta años viendo entrar y salir a los vivos y a los muertos.

**Nora:** Entonces guárdeme uno esta noche, Doña Carmen. El de la iglesia. El de Marta.

**Doña Carmen:** Esa pobre criatura. ¿Sabes qué es lo que más miedo da de este barrio? Que aquí nadie desaparece del todo. Siempre queda quien lo vio y calla.

**(Narrador/voz en off):** Señala con un dedo torcido hacia la ventana, hacia la torre negra recortada contra los relámpagos.

**Doña Carmen:** Esa noche, entre campanada y campanada, oí una que no tocaba. La campana pequeña, la del muerto, sonó a destiempo. Sola. Yo esa campana la conozco: solo suena si alguien pisa el suelo del campanario.

**Doña Carmen:** Y nadie sube al campanario durante la misa, detective. Nadie. Salvo que quiera bajar por donde nadie mira.

**Nora:** ¿La puerta del campanario estaba abierta?

**Doña Carmen:** Abierta de par en par. Lo vi con estos ojos cuando cesó la tormenta: un rectángulo negro en lo alto de la torre, como una boca. Por la mañana ya estaba cerrada otra vez. Alguien la cerró. Alguien con prisa y con llave.

- *(Opción del jugador)* **"¿Quién tiene llave del campanario?"**
**Doña Carmen:** Oficialmente, el sacristán. Ese pobre no rompería un plato. Pero las llaves, hija, se prestan. Se copian. Se roban.

**Doña Carmen:** Pregunta en la comisaría, cuando tengas agallas. Y pregunta por quién MÁS tenía copia de esa llave. Ahí empieza lo gordo. Ahí es donde a la gente le entra la tos y cambia de tema.

- *(Opción del jugador)* **"¿Vio usted a alguien en la torre?"**
**Doña Carmen:** Una silueta. Un momento, contra el resplandor de un rayo. Cargaba con algo. Con alguien, quiero decir. Al hombro, como un saco.

**Doña Carmen:** Y no era el jorobado del sacristán. Este iba recto. Alto. Con un abrigo largo que el viento levantaba como alas de cuervo.

**Nora:** (El encapuchado de Tomás. El mismo abrigo. El mismo hombre.)

- *(Opción del jugador)* **"¿Por qué me cuenta todo esto a mí?"**
**Doña Carmen:** Porque Marta me subía la compra cuando me fallan las piernas, sin pedir nada. Porque era buena sin presumir de serlo, que es la única bondad que vale.

**Doña Carmen:** Y porque tú, hija, no eres de las que se rinden. Se te ve en el paso. A los demás la lluvia los encoge; a ti te endereza. Encuentra a quien hizo esto.

**Doña Carmen:** Una cosa más, y ya me callo. No es la primera. Hace años, otra muchacha. Otra tormenta. También dijeron milagro. También cerraron el caso rápido. Pregúntate por qué siempre llueve cuando desaparece una mujer en este barrio.

**Nora:** El campanario. Ahí está la salida que nadie vio. Ya tengo lo que necesito para entrar en la iglesia.

**Doña Carmen:** Ve con Dios, o sin él, que para lo que vas a encontrar quizá sea mejor ir sola. Y abrígate, que la torre es fría y guarda más de un frío.


### La iglesia
_fuente: _dlg_iglesia()_

> **PISTA — El pañuelo:** Un pañuelo con las iniciales M.S. junto a la escalera del campanario.

**(Narrador/voz en off):** La puerta de San José pesa como una losa. Dentro, la nave está vacía y a oscuras, iluminada solo por el rojo tembloroso de las lamparillas votivas. Huele a incienso frío y a piedra mojada.

**Nora:** Cuatro pistas. Un grito junto al altar. Nadie por la puerta principal. Un encapuchado con anillo de sello. Y un campanario abierto a destiempo.

**Nora:** Todo apunta hacia arriba. A esa torre. Rosa vigilaba la puerta; nadie mentía. Es que Marta no salió por ninguna puerta que dé a la calle.

**(Narrador/voz en off):** Ante el altar, un reclinatorio sigue caído de lado. Nadie lo ha enderezado. La primera fila conserva una vela consumida hasta el metal, blanca, ante la imagen de San José.

**Nora:** Su vela. La encendió antes de morir... o antes de lo que fuera. Aquí estaba sentada. Aquí gritó.

**(Narrador/voz en off):** Junto al muro lateral, medio oculta tras un confesonario, una portezuela baja. Entornada. Del otro lado arranca una escalera de caracol que se pierde hacia arriba, en la negrura.

**Nora:** La puerta del campanario. Doña Carmen tenía razón. Subamos.

**(Narrador/voz en off):** Los peldaños de piedra están gastados y húmedos. La escalera cruje, sube y sube. A media altura, la linterna capta algo en el polvo del escalón: dos surcos paralelos.

**Nora:** Marcas de arrastre. Talones. Alguien subió a un cuerpo por aquí, escalón a escalón. Un cuerpo que no colaboraba.

**(Narrador/voz en off):** Arriba, el campanario se abre a la noche. El viento entra por los arcos y hace oscilar las cuerdas de las campanas, que gimen bajito. La ciudad de neón late a lo lejos, indiferente.

**Nora:** Desde aquí se domina todo el barrio. Y hay una escala de servicio que baja por fuera, por detrás, al callejón. Por donde no mira nadie.

**(Narrador/voz en off):** En el suelo, junto al hueco de la escala exterior, algo blanco destaca contra la mugre. Te agachas. Un pañuelo de tela, bordado con esmero. En una esquina, dos iniciales: M. S.

**Nora:** Marta Soler. La subieron mientras el rayo cegaba a todos, la bajaron por la escala de atrás y se la llevaron por el callejón. Coartada de tormenta y salida de campanario.

- *(Opción del jugador)* **Examinar el hueco de la escala**
**(Narrador/voz en off):** En el barandal metálico, enganchada, una hebra de paño oscuro, caro. Y una marca fresca: algo pesado rozó al bajar, hace poco.

**Nora:** Paño fino. El abrigo del encapuchado. No me cabe duda: es el mismo hombre que Tomás vio agarrarla del brazo.

- *(Opción del jugador)* **Mirar el pañuelo a la luz**
**(Narrador/voz en off):** Bajo la linterna, junto a las iniciales, una mancha parda, seca. Y un olor tenue, dulzón, químico. No es sangre: es otra cosa.

**Nora:** Cloroformo, o algo parecido. No la mataron aquí. Se la llevaron viva. Eso cambia el reloj: puede que aún estemos a tiempo.

**Nora:** No fue una desaparición. Ni un milagro. Fue un secuestro planeado con frialdad de relojero, usando la misa como tapadera.

**(Narrador/voz en off):** Guardas el pañuelo en una bolsa. El primer nudo del caso está deshecho, pero el hilo sigue, y se hunde en algo mucho más grande y más negro que una sola noche de lluvia.

**Nora:** Quien planea así no improvisa, y no lo hace por primera vez. Necesito los archivos. Sargento Núñez. Es hora de una visita oficial a la comisaría.


### Comisaría
_fuente: _dlg_comisaria()_

**(Narrador/voz en off):** La comisaría del Barrio Viejo es un cuarto estrecho con una bombilla desnuda, un ventilador roto y expedientes apilados hasta el techo, amarilleando. Huele a tabaco viejo y a café quemado.

**Sgto. Núñez:** Pase, detective, y cierre. Aquí las paredes oyen y algunas hasta cobran por lo que oyen.

**(Narrador/voz en off):** El sargento Núñez es un hombre grande, cansado, con la corbata floja y unos ojos que han visto demasiado archivo cerrado por orden de arriba.

**Sgto. Núñez:** Así que subió al campanario. Buen ojo. Mis 'compañeros' pasaron por delante de esa puerta tres veces y anotaron 'sin novedad'. Sin novedad. Con las marcas de arrastre en el polvo.

**Nora:** Tengo un pañuelo con las iniciales de Marta, restos de cloroformo y una hebra del abrigo del hombre que la bajó por la escala trasera. No se desvaneció. Se la llevaron.

**Sgto. Núñez:** Lo sé. Y le voy a contar algo que no está en ningún parte, porque en cuanto lo escribo, desaparece del archivo a la mañana siguiente.

**(Narrador/voz en off):** Se levanta, comprueba que el pasillo está vacío y vuelve a sentarse, bajando la voz.

**Sgto. Núñez:** Marta Soler no es la primera. Es la tercera este mes. Tres mujeres. Tres noches de tormenta. Tres campanarios distintos del Barrio Viejo.

**Nora:** ¿Tres? ¿Y por qué no consta ni una línea en ningún sitio?

**Sgto. Núñez:** Porque alguien de muy arriba quiere que no conste. Cada vez que abro uno de estos casos, me llega una llamada. Educada. Amable. 'Sargento, no se complique la jubilación'.

- *(Opción del jugador)* **"¿Sospecha de alguien de dentro?"**
**Sgto. Núñez:** Sospecho de todos y no puedo probar nada. Alguien avisa a ese hombre de cuándo hay misa multitudinaria. Alguien le consigue copia de las llaves de los campanarios. Eso no lo hace un forastero solo.

**Sgto. Núñez:** Hay una mano dentro y una mano fuera. La de fuera es la del abrigo caro. La de dentro... la de dentro lleva placa, me temo.

- *(Opción del jugador)* **"¿Qué tenían en común las tres?"**
**Sgto. Núñez:** Jóvenes. Solas, sin familia que diera guerra. Y las tres, en las semanas previas, habían ido a pedir ayuda a la misma parroquia. A San José y a las otras dos.

**Nora:** (Iban a la iglesia a buscar refugio. Y el refugio era la trampa.)

- *(Opción del jugador)* **"¿Por qué me llama a mí y no a los suyos?"**
**Sgto. Núñez:** Porque usted viene de fuera y no le deben nada a nadie de aquí. Porque a usted no la pueden llamar por teléfono a las tres de la mañana. Todavía.

**Sgto. Núñez:** Y porque estoy viejo y harto de firmar 'sin novedad' sobre la vida de tres mujeres.

**(Narrador/voz en off):** Núñez desliza sobre la mesa una carpeta gris sin nombre. Dentro, dos fotografías más de dos mujeres que sonríen sin saber. Y dos pañuelos más, bordados, cada uno con sus iniciales.

**Nora:** Entonces esto no es un caso, sargento. Es una serie. Y alguien lleva meses cerrándola con carpetazo.

**Sgto. Núñez:** Ahora ya somos dos los que lo sabemos. Cuídese, detective. A partir de esta noche, usted también es un cabo suelto para ellos.

**(Narrador/voz en off):** Guardas la carpeta bajo la gabardina. Fuera, la lluvia arrecia otra vez sobre el neón del Barrio Viejo.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 1 —  El campanario de San José calla. Pero en algún tejado, bajo la próxima tormenta que ya se forma, alguien afila el reloj para la cuarta.



## Capítulo 2 · Las campanas que faltan

### Briefing
_fuente: _dlg_brief()_

**Sgto. Núñez:** Ya tiene los tres nombres. Elena, Nadia, Marta. Empiece por el archivo del sótano, detective.

**(Narrador/voz en off):** Amanece gris sobre el Barrio Viejo. La comisaría huele a café recalentado. Núñez ha extendido tres carpetas sobre la mesa, como quien reparte una mala mano de cartas.

**Sgto. Núñez:** Antes de que se arrepienta: en cuanto toque estos papeles, ya no hay marcha atrás. Para ninguno de los dos.

**Nora:** Ya no había marcha atrás la noche que subí a ese campanario. Deme los nombres.

**Sgto. Núñez:** Elena Ruiz, veintiocho. Desapareció hace tres semanas en Santa Rita, durante una tormenta. Nadia Kovac, veinticuatro, hace dos, en la ermita del Cristo. Y Marta. Tres iglesias, tres tormentas.

**Nora:** Un patrón perfecto. Demasiado perfecto. ¿Qué se hizo con estos casos?

**Sgto. Núñez:** Se cerraron en cuarenta y ocho horas. 'Abandono voluntario del domicilio'. Firmados por arriba. Yo solo pude quedarme las copias que ve, y porque las escondí.

- *(Opción del jugador)* **"¿Quién los cerró?"**
**Sgto. Núñez:** La firma es de la comisaría central. Un nombre con demasiados galones para que yo lo diga en voz alta dentro de este edificio.

- *(Opción del jugador)* **"¿Por dónde empiezo?"**
**Sgto. Núñez:** Por el archivo del sótano. Ahí está lo que no cabe en estas tres carpetas. Cruce las fechas, los barrios, los conocidos. Busque lo que se repite.

**Nora:** Tres mujeres, tres campanarios, una misma mano borrando el rastro. Al archivo. Si hay un hilo común, estará enterrado ahí abajo.


### El archivo
_fuente: _dlg_archivo()_

**Nora:** El hilo común: las tres pasaron por la Fundación Amparo. Y alguien pidió los horarios de misa. La hermana de Marta, Laura, era su contacto.

> **PISTA — El hilo común:** Las tres víctimas pasaron por la Fundación Amparo antes de desaparecer.

**(Narrador/voz en off):** El archivo es un sótano sin ventanas, con estanterías metálicas que se pierden en la penumbra y un zumbido de fluorescente moribundo. Décadas de barrio dormidas en cajas.

**Nora:** Bien. Aquí nadie me llama por teléfono. Crucemos los tres nombres y veamos qué comparten además de una tormenta.

**(Narrador/voz en off):** Horas de polvo. Fichas, denuncias archivadas, recibos. Poco a poco, tres carpetas distintas empiezan a repetir una misma palabra en los márgenes.

**Nora:** 'Amparo'. Fundación Amparo. Las tres pidieron ayuda ahí en las semanas previas. Un comedor social, un refugio para mujeres. Elena, Nadia, Marta. Las tres.

- *(Opción del jugador)* **Revisar los movimientos internos**
**(Narrador/voz en off):** En una bandeja de correspondencia interna, un memorándum sin firmar: alguien solicitó a las tres parroquias los horarios de las misas con más asistencia. Fechado justo antes de cada tormenta.

**Nora:** Alguien de dentro pidió los horarios. Para saber cuándo la iglesia estaría llena. La coartada se encarga por escrito.

- *(Opción del jugador)* **Buscar los contactos de las fichas**
**(Narrador/voz en off):** En la ficha de Marta, una casilla de 'persona de contacto': Laura Soler. Hermana. Con una dirección al otro lado del canal.

**Nora:** Laura. La hermana de la foto de la playa. Si Marta se estaba ahogando, se lo contó a ella antes que a nadie.

**Nora:** El hilo común es la Fundación Amparo. Y el primer cabo que puedo tirar tiene nombre: Laura Soler. Voy a verla.


### El voluntario
_fuente: _dlg_voluntario()_

**Nora:** El voluntario solo robaba del cepillo. Un ladronzuelo, no un secuestrador. Callejón sin salida.

**(Narrador/voz en off):** Un voluntario joven, con la camisa empapada de sudor pese al frío, no te sostiene la mirada. Cuando te acercas, tira sin querer una pila de folletos.

**Nora:** Tranquilo. Solo quiero hablar. Aunque quien no debe nada no suele temblar así.

**Voluntario:** Yo... yo no sé nada de las mujeres esas, lo juro. Yo solo... por favor, no se lo diga al Sr. Vidal.

**Nora:** ¿Que no le diga qué?

**Voluntario:** Lo de la caja. Cojo algo del cepillo, poco, para mi madre. Soy un miserable, lo sé, pero un ladrón de monedas, no... no lo otro.

**(Narrador/voz en off):** Le tiemblan las manos mientras vacía los bolsillos: calderilla, un fajo mísero. El miedo de un ratero, no de un asesino.

**Nora:** (Sudaba por unas monedas, no por tres vidas. Su pánico me despistó. Sigo.)

**Nora:** Devuelve lo que has cogido y no lo repitas. Tu secreto no es el que yo busco.


### Laura Soler
_fuente: _dlg_laura()_

**Laura Soler:** Ya se lo dije: Marta ayudaba en el Amparo. Y ese 'benefactor' que la rondaba... vaya usted allí. Pregunte por él.

> **PISTA — El voluntariado:** Marta era voluntaria en Amparo; un 'benefactor' se había fijado en ella.

**(Narrador/voz en off):** Laura Soler tiene los mismos ojos que su hermana en la foto de la playa, pero apagados. Abre la puerta con un pañuelo estrujado en la mano.

**Laura Soler:** Usted es la que no ha firmado 'abandono voluntario'. Núñez me avisó. Pase. Perdone el desorden, ya no... ya no ordeno para nadie.

**Nora:** Siento lo de Marta, Laura. Necesito entenderla para encontrarla. ¿Qué era la Fundación Amparo para ella?

**Laura Soler:** Su refugio. Marta lo pasó mal, deudas, un novio de los que dejan marca. En Amparo le dieron comida, papeles, un sitio donde llorar. Ella lo devolvió haciéndose voluntaria. Era así.

**Laura Soler:** Al principio le brillaban los ojos hablando de aquello. Después... después empezó a tener miedo otra vez. Y esta vez no era del novio.

- *(Opción del jugador)* **"¿De qué tenía miedo?"**
**Laura Soler:** De un hombre. Un 'benefactor', decía ella con retintín. Un señor rico que financiaba el refugio y que se había 'fijado en ella'. La invitaba a 'retiros'. Le regalaba cosas caras.

**Laura Soler:** Marta no era tonta. Sabía que esa clase de generosidad siempre pasa factura. Quiso dejar el voluntariado. Y entonces empezaron las tormentas.

- *(Opción del jugador)* **"¿Le dio algún nombre?"**
**Laura Soler:** Nunca. Decía que era mejor que yo no lo supiera. Solo una vez soltó que llevaba 'un anillo de esos con escudo, como los marqueses de antes'.

**Nora:** (El anillo de sello. Otra vez. El encapuchado de Tomás y el 'benefactor' son el mismo hombre.)

**(Narrador/voz en off):** Laura rebusca en un cajón y te tiende una tarjeta ajada: 'Fundación Amparo — Sr. Vidal, administrador'.

**Laura Soler:** Esto lo dejó Marta. Encuentre a ese benefactor, detective. Y encuentre a mi hermana. Aunque sea para traérmela y enterrarla como Dios manda.

**Nora:** El voluntariado, el benefactor del anillo. Lo apunto. Empezaré por la Fundación. Gracias, Laura.


### El refugio
_fuente: _dlg_refugio()_

**Sr. Vidal:** Ya le he dicho todo lo que sé, detective. El benefactor es anónimo. Y la capilla de abajo... no es asunto suyo.

**Nora:** (La capilla de abajo. Justo lo que necesitaba oír.)

> **PISTA — El benefactor:** Un mecenas anónimo con anillo de sello financia 'retiros' desde la Fundación.

**(Narrador/voz en off):** La Fundación Amparo ocupa un edificio restaurado con dinero que se nota: mármol nuevo, un logo dorado, calefacción. Demasiado caro para un comedor social. El Sr. Vidal te recibe con una sonrisa de dentífrico.

**Sr. Vidal:** ¡Detective! Qué honor. Aquí solo hacemos el bien, ya lo ve. Damos de comer, damos cobijo. ¿En qué puedo ayudarla, aunque sea tarde?

**Nora:** Marta Soler era voluntaria aquí. Y ha desaparecido. Como Elena Ruiz. Como Nadia Kovac. Las tres, de aquí.

**Sr. Vidal:** Terrible, terrible. Pero coincidencia, detective. Por aquí pasan cientos de personas. Que a tres les haya ido mal después no nos convierte en... en lo que insinúa.

**(Narrador/voz en off):** Sonríe, pero un músculo de la mandíbula le tiembla. Sobre su mesa, un folleto: 'Retiros de silencio — solo por invitación del patrono'.

- *(Opción del jugador)* **"Hábleme del benefactor."**
**Sr. Vidal:** El patrono desea el anonimato. Es un caballero de gran corazón que sostiene esta casa entero. No puedo, y no quiero, dar su nombre.

**Sr. Vidal:** Solo le diré que es un hombre de otra época. Con modales. Con... clase. Lleva siempre un anillo de familia. Un detalle encantador.

**Nora:** (Un anillo de familia. Encantador. Y el mismo que aprieta brazos en callejones.)

- *(Opción del jugador)* **"¿Qué son esos retiros?"**
**Sr. Vidal:** Un regalo del patrono a las voluntarias más... entregadas. Unos días de paz fuera de la ciudad. Marta estaba invitada al próximo, ¿sabe? Qué pena que no llegara a ir.

**Nora:** (Elegía a sus víctimas y las 'invitaba'. Vidal las servía en bandeja.)

**(Narrador/voz en off):** Suena un teléfono en el despacho de al lado. Vidal se disculpa con demasiada prisa. Por una puerta entreabierta, al fondo, ves una escalera que baja: 'Capilla privada — Patronato'.

**Nora:** El benefactor con anillo, los 'retiros', y una capilla privada bajo tierra a la que Vidal no quiere que baje. Ahí abajo está la verdad. Voy a colarme.


### La capilla
_fuente: _dlg_capilla()_

**Nora:** El libro de la capilla lo dice todo: horarios de misa y un memo policial. La mano de dentro existe. Toca esperar en el muelle.

> **PISTA — La agenda de misas:** Un libro con los horarios de misa de las tres parroquias y una copia de un memo policial.

**(Narrador/voz en off):** La escalera desemboca en una capilla pequeña y fría, sin santos, con las paredes forradas de terciopelo rojo. No huele a incienso: huele a cerrado y a dinero. Sobre un atril, un libro grande, abierto.

**Nora:** Esto no es una capilla. Es el despacho privado de alguien que juega a ser dios. Veamos su libro de oraciones.

**(Narrador/voz en off):** No hay salmos. Hay columnas: fechas, parroquias, horas de misa concurrida. Santa Rita. El Cristo. San José. Y al lado de cada una, una marca de visto bueno.

**Nora:** La agenda de misas. Elegía la noche, la iglesia llena, la tormenta anunciada. Todo cuadrado como un horario de trenes.

- *(Opción del jugador)* **Buscar entre los papeles del atril**
**(Narrador/voz en off):** Bajo el libro, una copia mecanografiada: un memorándum con membrete de la policía, autorizando 'no asignar patrullas' a esas zonas en esas fechas exactas.

**Nora:** Una orden para dejar el barrio sin vigilancia justo esas noches. Esto solo lo firma alguien con mando. La mano de dentro tiene despacho y placa.

- *(Opción del jugador)* **Fijarte en el motivo de la pared**
**(Narrador/voz en off):** En el terciopelo, bordado en hilo de oro, un emblema: tres campanas bajo una corona. Y un lema: 'Lo que suena, es mío'.

**Nora:** Tres campanas. Un coleccionista. Para él no son mujeres: son piezas. Trofeos con nombre de iglesia.

**(Narrador/voz en off):** Arriba se oyen pasos y la voz nerviosa de Vidal despidiendo a alguien. Y otra voz, grave, tranquila, que ordena: 'Esta noche, en el muelle. La última carga'.

**Nora:** La última carga. Esta noche. En el muelle viejo. Si quiero atrapar al benefactor con las manos en la masa, es ahí y es ya.


### El muelle
_fuente: _dlg_muelle()_

> **PISTA — La cuarta víctima:** El benefactor prepara una cuarta. Su chófer lleva placa: hay un policía implicado.

**(Narrador/voz en off):** El muelle viejo es un bosque de grúas muertas y neón reflejado en charcos de aceite. Bajo la lluvia, una furgoneta negra con el motor en marcha. Dos siluetas cargan un bulto largo, envuelto.

**Nora:** Un bulto del tamaño de una persona. La cuarta. Llegué a tiempo... o casi.

**(Narrador/voz en off):** Reconoces al más alto: abrigo de paño, capucha, y al girarse, el destello de un anillo de sello bajo una farola. El benefactor en persona.

**Nora:** ¡Alto! ¡Policía! ¡Aparta de la furgoneta!

**(Narrador/voz en off):** El encapuchado ni se inmuta. Hace un gesto seco al otro, que se vuelve hacia ti abriéndose la chaqueta: bajo ella, una pistola reglamentaria y, prendida al cinturón, una placa.

- *(Opción del jugador)* **Cubrirte y memorizar la matrícula**
**(Narrador/voz en off):** Te tiras tras un contenedor mientras la furgoneta arranca chirriando. Alcanzas a grabar la matrícula y, en la puerta, un adhesivo oficial de vehículo municipal.

**Nora:** Vehículo municipal. Placa. El chófer del monstruo es uno de los nuestros. Por eso nunca hubo patrullas.

- *(Opción del jugador)* **Ir a por el encapuchado**
**(Narrador/voz en off):** Corres, pero el del arma dispara al suelo, a tus pies, para frenarte. Cuando levantas la vista, las luces traseras ya se pierden en la lluvia. En el suelo, un mechero de plata caído.

**Nora:** Se me ha escapado. Pero se ha dejado algo. Un mechero con un escudo grabado: tres campanas y una corona. Su firma.

**Nora:** No he salvado a la cuarta. Pero ahora sé dos cosas: que hay un policía en esto, y que el benefactor colecciona. Y a los coleccionistas se les encuentra por su colección.

**(Narrador/voz en off):** Guardas la prueba, temblando de rabia y de agua. El hilo ya no se hunde en el barrio: sube, hacia arriba, hacia los despachos con galones.

**Nora:** Núñez tiene que ver esto. Aunque lo que voy a contarle le cueste la jubilación de verdad.


### Cierre
_fuente: _dlg_cierre2()_

**(Narrador/voz en off):** De vuelta en la comisaría, de madrugada. Núñez escucha la grabación de la matrícula con la cara cada vez más gris.

**Sgto. Núñez:** Ese vehículo... es de la central. Y esa matrícula la firma el parque móvil a nombre del despacho del comisario Bru.

**Nora:** ¿Bru? ¿Su superior?

**Sgto. Núñez:** Mi superior. El que cierra los casos en cuarenta y ocho horas. El que me llama para que no me complique. Todo encaja, y ojalá no encajara.

**(Narrador/voz en off):** Suena el teléfono de la comisaría. Núñez descuelga, escucha, y cuelga muy despacio.

**Sgto. Núñez:** Era de arriba. Me acaban de 'sugerir' que le retire a usted el acceso al caso. A estas horas. Justo ahora. ¿Entiende lo que significa?

**Nora:** Que les hemos pisado la cola. Y que el benefactor no es un forastero rico: es alguien a quien la placa protege.

**Sgto. Núñez:** No puedo darle una orden para lo que viene, detective. Oficialmente, a partir de ahora está usted sola. Extraoficialmente... el mechero lleva un escudo. Averigüe de qué familia es. Ahí está su hombre.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 2 —  El caso ya no cabe en una carpeta gris. Cabe en un apellido con escudo. Y la cuarta tormenta se acerca.



## Capítulo 3 · El coleccionista

### Aviso
_fuente: _dlg_aviso()_

**Sgto. Núñez:** El escudo es de los Bru. La mansión está junto al parque. Vaya con cuidado, que ya no la cubre nadie.

**(Narrador/voz en off):** Núñez te espera en el coche, en un callejón, con las luces apagadas. Ya no confía ni en su propia comisaría.

**Sgto. Núñez:** El escudo del mechero: tres campanas y una corona. Es el blasón de los Bru. Una familia de toda la vida. Y el comisario es el último de la estirpe.

**Nora:** El benefactor con anillo y el comisario que cierra los casos son la misma persona.

**Sgto. Núñez:** Eso creo. Y si tengo razón, ninguna orden mía vale ya nada contra él. Le he traído lo único que puedo darle: la dirección de su mansión, junto al parque.

**Sgto. Núñez:** Escúcheme bien: si entra ahí, entra sola y sin placa que la respalde. Si algo sale mal, no habrá comisaría que la busque.

**Nora:** Hay una cuarta mujer en algún sitio y una tormenta subiendo por el río. No es momento de esperar una orden. Voy a esa mansión.


### El soplo
_fuente: _dlg_soplo()_

**Nora:** El soplo era un cebo. Nos querían mirando a la banda del río mientras el pez gordo respiraba tranquilo.

**(Narrador/voz en off):** Sobre tu mesa, alguien ha dejado un sobre sin remite. Dentro, una nota mecanografiada, sin firma.

**¿?:** «Buscad a la banda del río. Ellos se llevaron a las mujeres.»

**Nora:** Qué oportuno. Una pista que llega sola, servida en bandeja, justo cuando aprieto por otro lado.

**(Narrador/voz en off):** Compruebas a la banda del río: contrabandistas de tabaco, sí, pero la noche de cada desaparición estaban a kilómetros, moviendo cajas en la otra punta del puerto. Coartadas cruzadas.

**Nora:** Nada. Ni una conexión real. Alguien mecanografió esto para que perdiera una semana persiguiendo fantasmas.

**Nora:** (Y quien puede plantar una nota en MI mesa está dentro de esta comisaría. El cebo dice más que la pista: me están vigilando.)

**Nora:** Al cesto con el soplo. A veces una pista falsa es la mejor prueba de que vas por el camino bueno.


### La mansión
_fuente: _dlg_mansion()_

**Nora:** La sala de las campanas ya la he visto. Sus trofeos. Lo que importa está más abajo, en el sótano.

> **PISTA — Las tres campanas:** En la mansión de Bru, tres campanas de iglesia expuestas como trofeos con una placa por víctima.

**(Narrador/voz en off):** La mansión de los Bru se alza junto al parque, negra contra los relámpagos, con más vidrieras que muchas iglesias. Fuerzas una ventana de servicio y entras en un vestíbulo de retratos de antepasados severos.

**Nora:** Toda una vida de placas y galones colgada en las paredes. Y detrás, esto. Veamos qué colecciona el señor comisario.

**(Narrador/voz en off):** Una sala interior, iluminada como un museo. Sobre peanas de terciopelo, tres campanas de bronce de distinto tamaño. Bajo cada una, una placa grabada.

**Nora:** 'Santa Rita'. 'El Cristo'. 'San José'. Una campana por iglesia. Una iglesia por mujer. Elena. Nadia. Marta.

- *(Opción del jugador)* **Leer las placas de cerca**
**(Narrador/voz en off):** Cada placa lleva una fecha y una inicial. Y una cuarta peana, vacía, ya rotulada: 'La torre del reloj — esta noche'.

**Nora:** La cuarta peana ya tiene sitio. Y nombre de lugar: la torre del reloj. Es esta noche. Todavía puedo llegar.

- *(Opción del jugador)* **Registrar el escritorio**
**(Narrador/voz en off):** En un secreter, correspondencia con el membrete de la Fundación Amparo y, en un cajón con cerradura forzada por ti, una llave de hierro antigua etiquetada: 'sótano'.

**Nora:** Una llave del sótano. En las casas así, lo que de verdad esconden nunca está en la planta noble. Está abajo.

**Nora:** Tres campanas, tres trofeos, y una cuarta peana esperando. Este hombre no mata: 'adquiere'. Y guarda. Si guarda campanas arriba... ¿qué guarda abajo? Al sótano.


### El sótano
_fuente: _dlg_sotano()_

**Nora:** Elena y Nadia están vivas ahí abajo. Y el párroco de San José sabe más de lo que dijo. Hay que apretarle.

> **PISTA — Las cautivas:** Elena y Nadia siguen vivas, encerradas en el sótano. Marta fue llevada a 'la torre'.

**(Narrador/voz en off):** La llave abre una puerta de hierro. Detrás, una escalera húmeda baja a un sótano abovedado. Al fondo, tras una reja, dos figuras se encogen al oír tus pasos.

**Nora:** Tranquilas. Soy policía. No voy a haceros daño. Estoy aquí para sacaros.

**(Narrador/voz en off):** Dos mujeres demacradas pero vivas. Una de ellas se aferra a la reja con manos temblorosas.

**Nora:** ¿Elena? ¿Nadia? Estáis vivas... Gracias a Dios. ¿Dónde está Marta? ¿Dónde está la tercera?

- *(Opción del jugador)* **"¿Qué le pasó a Marta?"**
**(Narrador/voz en off):** Elena rompe a llorar. Nadia contesta con un hilo de voz, con acento del este.

**(Narrador/voz en off):** 'Se la llevó anoche. Arriba, dijo. A la torre del reloj. Para la 'función final'. Dijo que Marta era... su pieza favorita.'

**Nora:** (Todavía viva. Todavía a tiempo. La torre del reloj.)

- *(Opción del jugador)* **"¿Quién os trajo aquí?"**
**(Narrador/voz en off):** 'Un cura', susurra Elena. 'Nos ganó la confianza en la parroquia. El padre Ismael. Él nos entregaba... llorando, pero nos entregaba.'

**Nora:** (El párroco de San José. La mano que abría las puertas desde dentro de la fe.)

**(Narrador/voz en off):** Cortas la cadena de la reja con una barra. Les das tu abrigo y tu teléfono para que llamen a Núñez, al número directo, al único limpio.

**Nora:** Salid por donde entré y no miréis atrás. Yo tengo que llegar a esa torre antes de que suene la campana. Y de paso, hacerle una visita a un párroco.


### Padre Ismael
_fuente: _dlg_padre()_

**Padre Ismael:** Que Dios me perdone... suba a la torre del reloj. Y dese prisa, que la campana ya está montada.

> **PISTA — El chantaje:** El padre Ismael entregaba a las mujeres, chantajeado por Bru. La 'función' es en la torre del reloj.

**(Narrador/voz en off):** San José, otra vez, bajo otra tormenta. El padre Ismael reza solo ante el altar. Se sobresalta al verte, y en su cara no hay sorpresa: hay alivio y terror a partes iguales.

**Nora:** Elena me lo ha contado, padre. Usted les ganaba la confianza. Usted abría las puertas. ¿Cómo pudo?

**Padre Ismael:** ¿Cree que no lo llevo clavado cada noche? Bru tiene cartas mías, detective. Pecados de hace treinta años que hundirían a la parroquia y a la gente que confía en ella. Me eligió por eso.

**Padre Ismael:** Me dijo que solo era 'ayudarlas a empezar de cero lejos'. Cuando entendí la verdad, ya era su cómplice. Y un cómplice con miedo es el mejor de los candados.

- *(Opción del jugador)* **"Ayúdeme a pararlo ahora."**
**Padre Ismael:** Sí. Sí. Es lo único que me queda. Marta está en la torre del reloj, la vieja, la del ayuntamiento. Ahí celebra su 'función final', cuando el reloj da las doce.

**Padre Ismael:** Tenga la llave del portón. Yo llamaré a todas las campanas del barrio para que alguien, por fin, mire hacia arriba.

- *(Opción del jugador)* **"¿Por qué campanas? ¿Por qué así?"**
**Padre Ismael:** Dice que las campanas 'llaman a las almas' y que él las 'colecciona' en su mejor momento, el del miedo. Está loco, detective. Loco con dinero y con placa, que es la peor locura.

**Nora:** El chantaje, la torre del reloj, medianoche. Ya lo tengo todo. Ahora es una carrera contra un reloj de verdad. Voy a por Marta.


### La torre
_fuente: _dlg_torre()_

> **PISTA — El coleccionista:** El comisario Bru, detenido en la torre del reloj. Marta, viva.

**(Narrador/voz en off):** La torre del reloj del viejo ayuntamiento se alza sobre la ciudad de neón. Subes los últimos peldaños con el corazón golpeando más fuerte que la tormenta. Arriba, entre engranajes gigantes, una figura elegante espera de espaldas.

**Comisario Bru:** Detective. La estaba esperando. Reconozco el talento: ha llegado más lejos que nadie. Es usted casi digna de mi colección.

**(Narrador/voz en off):** Se vuelve. El comisario Bru, de esmoquin, con el anillo de sello en la mano. A su lado, atada a una silla junto a la maquinaria, Marta Soler, viva, con los ojos enormes de terror.

**Nora:** Se acabó, Bru. Elena y Nadia están fuera. El padre Ismael ha cantado. Y Núñez viene con los únicos policías de esta ciudad a los que usted no ha comprado.

**Comisario Bru:** ¿Comprado? Yo no compro, detective. Yo colecciono lo que el mundo tira: mujeres que nadie reclama. Les doy lo único eterno que existe: un instante perfecto, cuando suena la campana.

- *(Opción del jugador)* **Mantenerlo hablando y ganar tiempo**
**Nora:** Un instante perfecto. Cuénteme más. A los hombres como usted les encanta explicar por qué son especiales.

**Comisario Bru:** Porque estoy por encima. De la ley que redacto, del barrio que sostengo, de la moral de los pobres. Yo decido quién suena y quién calla.

**(Narrador/voz en off):** Mientras habla, ganas terreno. Faltan segundos para las doce. Cuando el gran engranaje se mueva, el ruido tapará todo.

- *(Opción del jugador)* **Fingir rendirte y acercarte**
**Nora:** Tiene razón. Ha ganado. Solo... déjeme verla de cerca. Concédame ese instante perfecto a mí también.

**Comisario Bru:** Ah. Por fin alguien que lo entiende. Acérquese, entonces. Sea parte de la obra.

**(Narrador/voz en off):** Das un paso, dos. Tu mano roza la palanca de freno del mecanismo del reloj.

**(Narrador/voz en off):** El reloj empieza a dar las doce. La campana atronadora ahoga el mundo. En ese estruendo que él tanto amaba, te lanzas.

**Nora:** ¡El único instante perfecto de esta noche va a ser el de las esposas, Bru!

**(Narrador/voz en off):** Forcejeo entre engranajes y campanadas. El anillo de sello rueda por el suelo de madera. A la última campanada, Bru está contra el suelo, tu rodilla en su espalda, y Marta respira, libre.

**Comisario Bru:** No lo entiende... gente como yo no cae. Mañana estaré fuera. Siempre estoy fuera.

**Nora:** Puede ser. Pero esta noche, por una vez, la campana ha sonado por usted. Y hay tres mujeres vivas para contarlo.


### Cierre
_fuente: _dlg_cierre3()_

**(Narrador/voz en off):** Amanece limpio por primera vez en semanas. La comisaría hierve de prensa y de caras nuevas de Asuntos Internos. Núñez, con una insignia recién ascendida que le sienta como un traje prestado, te tiende un café.

**Sgto. Núñez:** Bru tenía razón en una cosa: gente como él rara vez cae. Pero con tres testigos vivas, el anillo, el mechero y el libro de la capilla... esta vez no se levanta. Va a caer entero.

**Nora:** ¿Y usted? Ha quemado su jubilación en esto.

**Sgto. Núñez:** La he cambiado por poder mirarme al espejo. Buen negocio, a mi edad. Marta ha preguntado por usted, por cierto. Ella y Laura. Quieren darle las gracias.

**Nora:** Dígales que las gracias, cuando encuentre a la persona, no a la detective. Hoy solo quiero dormir una semana.

**(Narrador/voz en off):** Recoges tus cosas. En el tablón, alguien ha colgado ya un mapa nuevo, con otro barrio, otras luces, otra lluvia esperando.

**Sgto. Núñez:** Habrá más noches como esta, detective. Siempre las hay. Pero por hoy... el barrio es suyo. Y las campanas, por fin, callan en paz.

**(Narrador/voz en off):** — FIN DE LA TEMPORADA 1 —  Tres casos, tres tormentas, tres campanas que vuelven a su sitio. sOC.



## Capítulo 4 · El heredero

### Briefing
_fuente: _dlg_brief4()_

**Sgto. Núñez:** Bru sigue en su celda. Y aun así ha vuelto a pasar. Vaya a la iglesia de la Merced, detective.

**(Narrador/voz en off):** Meses después. Nora ya no es una intrusa: tiene mesa propia en la comisaría y a Núñez de jefe. Pero esta madrugada la cara de Núñez es la de siempre: la de las malas noticias.

**Sgto. Núñez:** Otra. Anoche, tormenta, misa concurrida en la iglesia de la Merced. Una mujer, Sara Beltrán, se esfumó del banco. Mismo modus. Idéntico.

**Nora:** Imposible. Bru está encerrado. Lo metí yo en esa celda.

**Sgto. Núñez:** Y ahí sigue, lo he comprobado tres veces. O tenemos un imitador... o el método de Bru no se ha ido con él.

**Nora:** Las dos cosas dan miedo. Si alguien copia hasta el último detalle, es que alguien se lo enseñó. Voy a la escena antes de que la lluvia borre lo poco que quede.


### Escena del crimen
_fuente: _dlg_escena4()_

**Nora:** El sello de lacre en el campanario. Un gremio, no un lobo solitario. Hay que preguntar en la calle.

> **PISTA — El método heredado:** El secuestro repite el método de Bru al detalle, con una marca nueva: un sello de lacre.

**(Narrador/voz en off):** La iglesia de la Merced es gemela de San José en lo esencial: nave, campanario, una puerta de servicio que da a un callejón. Subes la escalera de caracol con una sensación de déjà vu que hiela.

**Nora:** Marcas de arrastre. La escala trasera. El pañuelo... todo igual. Quien hizo esto tiene el manual de Bru abierto sobre las rodillas.

**(Narrador/voz en off):** Pero hay algo que Bru nunca dejaba: en el quicio de la puerta del campanario, un pegote de lacre rojo con un sello estampado. Una figura: una balanza con una campana en cada platillo.

**Nora:** Esto es nuevo. Bru firmaba con silencio. Este firma con un sello, como un gremio de artesanos orgulloso de su oficio.

- *(Opción del jugador)* **Examinar el sello de cerca**
**(Narrador/voz en off):** Bajo la lupa, alrededor de la balanza, unas letras diminutas: 'C. del B.'

**Nora:** Unas iniciales. Un emblema. Esto no es un imitador solitario: es una marca. Una firma de negocio.

- *(Opción del jugador)* **Buscar diferencias con los casos de Bru**
**(Narrador/voz en off):** A diferencia de Bru, aquí no hay trofeo, no hay campana robada. Se llevaron a la mujer y punto: rápido, limpio, comercial.

**Nora:** Bru coleccionaba por amor enfermo. Este se la lleva por dinero. Ya no es un loco: es un proveedor.

**Nora:** El método heredado, con sello propio. Si es un negocio, en la calle alguien habrá oído hablar de él. Toca visitar a mis oídos del arroyo.


### El chivato
_fuente: _dlg_chivato()_

**Nora:** El 'Corredor'. Así llaman a quien mueve la mercancía. La periodista Vera Lang lleva meses tras él.

> **PISTA — El corredor:** En la calle hablan de un 'Corredor' que mueve mujeres por encargo; un intermediario.

**(Narrador/voz en off):** El chivato te espera en la trastienda de siempre, medio a oscuras, mordiendo un palillo. No da nada gratis, pero esta noche está más pálido que de costumbre.

**El chivato:** Detective, esta vez no quiero su dinero. Quiero que esto pare, que me da hasta a mí repelús. Andan diciendo por ahí una palabra: el 'Corredor'.

**Nora:** ¿El Corredor?

**El chivato:** Un tipo que no roba, que no mata: transporta. Le encargas y él 'consigue'. Mujeres solas, sin familia. Dicen que trabaja para un gremio, gente de arriba con guantes limpios.

- *(Opción del jugador)* **"¿Dónde lo encuentro?"**
**El chivato:** A él no se le encuentra. Él te encuentra a ti. Pero hay una periodista, la Lang, del diario, que lleva meses olfateándolo. Sabe más que yo. Y que usted.

- *(Opción del jugador)* **"¿Para quién trabaja?"**
**El chivato:** Para el que paga. Y paga gente con anillos y apellidos. Bru era un cliente, ¿sabe? Uno más. Cuando cayó, el negocio ni se enteró.

**Nora:** (Bru no era la cabeza. Era un comprador. La cabeza sigue suelta.)

**Nora:** El Corredor, un gremio, clientes con apellido. Esto es mucho más grande que un hombre. Voy a ver a esa periodista antes que la calle me la calle también a ella.


### Pista falsa
_fuente: _dlg_falso4()_

**Nora:** El que se confesó culpable ni siquiera sabía por qué puerta salió la víctima. Un pobre diablo buscando fama.

**(Narrador/voz en off):** En la sala de interrogatorios, un hombre demacrado sonríe a las cámaras que no hay. 'Fui yo', repite. 'Yo me las llevé a todas.'

**Nora:** Muy bien. Entonces dígame: ¿por qué puerta sacó a Sara Beltrán de la iglesia de la Merced?

**(Narrador/voz en off):** El hombre duda, sonríe, improvisa: 'Por... por la puerta grande, la principal.' Error. Salió por el campanario, como todas.

**Nora:** Por la principal, dice. Con cien testigos mirando. Ya. ¿Y el sello de lacre? ¿De qué color?

**(Narrador/voz en off):** Silencio. El hombre se derrumba: solo quería salir en los periódicos, sentirse alguien por una noche. No sabe nada.

**Nora:** (Cada caso sonado atrae a estos pobres diablos. Confiesan para existir. Descartado.)

**Nora:** Que le den una manta y una tila. Y que nadie filtre su nombre: bastante castigo tiene con ser quien es.


### La redacción
_fuente: _dlg_redaccion()_

**Vera Lang:** La marca del gremio: la balanza con dos campanas. Búscala en el almacén del muelle. Ahí guardan la 'mercancía'.

> **PISTA — La marca del gremio:** El sello (balanza y dos campanas) es la marca de un gremio de trata; su almacén está en el muelle.

**(Narrador/voz en off):** La redacción del diario es un caos de humo, teclas y teléfonos. Vera Lang, la periodista, despeja una silla de un manotazo de recortes y te clava una mirada que ya lo sabe todo.

**Vera Lang:** La detective que metió a un comisario en la cárcel. Por fin. Llevo dos años escribiendo artículos que me tumban antes de imprimir. Igual juntas llegamos a algún sitio.

**Nora:** Me han hablado de un 'Corredor' y de un gremio. Y de un sello: una balanza con dos campanas.

**Vera Lang:** El 'Cónclave del Bronce', lo llaman ellos. Un club de señores muy respetables que 'coleccionan' personas. El Corredor es su recadero. Bru era un socio pequeño.

**Vera Lang:** Esa balanza es su marca de garantía. La estampan en la 'mercancía' y en los sitios donde la almacenan. Y sé dónde está uno: un almacén en el muelle viejo.

- *(Opción del jugador)* **"¿Por qué no lo has publicado?"**
**Vera Lang:** Porque el dueño del periódico juega al golf con ellos. Cada vez que me acerco, me cambian de sección. A ti no te pueden cambiar de sección, detective. Por eso te ayudo.

- *(Opción del jugador)* **"¿Qué encontraré en ese almacén?"**
**Vera Lang:** Registros. Fechas. Y si hay suerte, a alguien esperando el próximo 'envío'. Pero ve con cuidado y ve pronto: cuando huelen una redada, lo vacían en horas.

**Nora:** El Cónclave del Bronce. La marca del gremio. El almacén del muelle. Tres pistas y un nombre nuevo. Esta noche entro en ese almacén.


### El almacén
_fuente: _dlg_almacen()_

> **PISTA — El libro de envíos:** En el almacén, un registro de 'envíos' con fechas, sellos y un contacto: el Corredor.

**(Narrador/voz en off):** El almacén es una catedral de sombras y contenedores. Huele a salitre y a miedo viejo. Al fondo, jaulas vacías con la marca de la balanza grabada a fuego en la madera.

**Nora:** Jaulas. Con sello de calidad. Como si fueran cajas de fruta. Malditos sean.

**(Narrador/voz en off):** Sobre una mesa, un libro de contabilidad abierto: columnas de fechas, 'piezas', y una firma que se repite como responsable de logística: el Corredor.

**Nora:** Aquí está todo. Quién, cuándo, cuánto. Esto no lo tumba ningún dueño de periódico.

**(Narrador/voz en off):** Un ruido. Entre los contenedores, una figura enjuta con guantes recoge deprisa unos papeles y echa a correr hacia la salida de carga.

- *(Opción del jugador)* **Perseguir al Corredor**
**(Narrador/voz en off):** Corres, pero el hombre conoce el laberinto mejor que tú. Se cuela por un hueco y desaparece en la lluvia. En el suelo, se le ha caído una tarjeta con la balanza.

**Nora:** Otra vez se me escapa el recadero. Pero se deja su tarjeta. Y su libro. Con esto ya no persigo rumores: persigo nombres.

- *(Opción del jugador)* **Asegurar el libro de envíos**
**(Narrador/voz en off):** Dejas ir a la figura y agarras el libro con las dos manos. Vale más que diez detenciones: es el mapa entero del negocio.

**Nora:** Un recadero se sustituye en un día. Este libro, no. Prefiero el mapa al ratón.

**Nora:** Sara Beltrán no está aquí: ya la 'enviaron'. Pero por primera vez tengo la contabilidad del horror. Núñez tiene que verlo esta misma noche.


### Cierre
_fuente: _dlg_cierre4()_

**(Narrador/voz en off):** Núñez y Vera Lang revisan el libro bajo la lámpara. Tres cabezas sobre las mismas cifras que valen vidas.

**Sgto. Núñez:** Con esto podemos empapelar a medio gremio. Pero el Corredor sigue suelto, y por encima de él hay quien firma los cheques.

**Vera Lang:** El Cónclave del Bronce. Y hay una noche, una vez al mes, en que se reúnen a 'pujar'. Una subasta. Si damos con ella, damos con todos a la vez.

**Nora:** Entonces ya no perseguimos a un hombre. Perseguimos a un club entero. Y me voy a colar en su fiesta.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 4 —  El heredero no era una persona: era un negocio con socios, sello y contabilidad. Y una subasta esperando.



## Capítulo 5 · La subasta

### Briefing
_fuente: _dlg_brief5()_

**Sgto. Núñez:** El Corredor mueve la mercancía por el muelle. Empiece por su contacto de allí.

**(Narrador/voz en off):** El libro de envíos es un mapa, pero está en clave. Núñez ha pasado la noche descifrando rutas con un café tras otro.

**Sgto. Núñez:** Todos los 'envíos' pasan por el muelle antes de la subasta mensual. Hay un contacto allí, un tal Sisebuto, que carga y descarga. Asustadizo. Empiece por él.

**Nora:** Un mes. Tengo un mes hasta la próxima puja para meterme dentro. Y a Sara Beltrán quizá ya la estén 'exponiendo'.

**Sgto. Núñez:** Cuídese, detective Vega. En cuanto el gremio note que husmea la subasta, dejará de mandarle notas falsas y empezará a mandarle otra cosa.

**Nora:** Que manden lo que quieran. Voy al muelle a apretarle las tuercas a ese tal Sisebuto.


### El contacto
_fuente: _dlg_contacto()_

**Nora:** Existe una lista de clientes con sus pujas. Y un salón, el de Madame Ourense, donde se cierran los tratos.

> **PISTA — La lista de clientes:** Existe una lista cifrada de clientes que pujan; los tratos se cierran en el salón de Madame Ourense.

**(Narrador/voz en off):** Sisebuto resulta ser un cargador flaco que fuma con las dos manos. Cuando le enseñas la tarjeta del Corredor, se le cae el cigarro.

**El chivato:** No sé nada, no sé nada. Yo cargo cajas, no pregunto qué llevan. Es más sano así.

**Nora:** Las cajas que tú cargas llevan personas dentro. Eso ya no es sano de ninguna manera. Habla, y te saco de esto antes de que te conviertas en carga tú también.

**El chivato:** Está bien, está bien... Hay una lista. De clientes. Gente que puja por 'encargos concretos'. Yo he visto el sobre, no lo que hay dentro, se lo juro.

- *(Opción del jugador)* **"¿Dónde se hacen las pujas?"**
**El chivato:** En un salón elegante, arriba en la ciudad. Lo lleva una tal Madame Ourense. Allí no entran cargadores como yo. Ni policías como usted, sin invitación.

- *(Opción del jugador)* **"¿Y Sara Beltrán?"**
**El chivato:** ¿La última? Sigue 'en catálogo'. No se ha vendido aún. Si va a hacer algo, hágalo antes de la próxima luna llena, que es cuando pujan.

**Nora:** (Viva. En catálogo. Tengo hasta luna llena.)

**Nora:** Una lista de clientes y un salón con dueña. Si quiero la lista, tengo que encantar a Madame Ourense. Hora de vestirme de otra cosa.


### Pista falsa
_fuente: _dlg_falso5()_

**Nora:** El chatarrero solo vendía coches robados. Ruidoso, pero pez pequeño. Nada que ver con el gremio.

**(Narrador/voz en off):** La chatarrería del Rubio tiene fama en el barrio: dinero, matones, coches que entran enteros y salen en piezas. El candidato perfecto a villano.

**Nora:** Mucho músculo para un desguace. A ver qué esconde el Rubio bajo tanta chapa.

**(Narrador/voz en off):** Registras, aprietas, amenazas. Aparecen coches robados, matrículas limadas, un alijo de tabaco... y nada más. Ni rastro de sellos, ni de listas, ni de mujeres.

**Nora:** Un ladrón de coches de manual. Ruidoso, sucio, evidente. Demasiado evidente para lo que busco.

**Nora:** (El gremio no hace ruido ni ostentación. Tiene guantes limpios y apellidos. El Rubio es un pez pequeño en un charco aparte.)

**Nora:** Que Tráfico se ocupe del Rubio. Yo busco a monstruos que huelen a colonia cara, no a grasa de motor.


### El salón
_fuente: _dlg_salon()_

**Madame Ourense:** Ya le dije lo que iba a decirle, encanto. El sello dorado es el pase. Lo demás, en la trastienda.

> **PISTA — El sello de la casa:** El acceso a la puja se controla con un sello dorado en la invitación; lo guarda Madame Ourense.

**(Narrador/voz en off):** El salón privado es terciopelo, champán y risas de gente que nunca ha pagado por nada. Madame Ourense te recibe midiéndote de arriba abajo como a una joya que no acaba de tasar.

**Madame Ourense:** Cara nueva. Y no del gremio, eso se huele. ¿Compradora, curiosa... o problema, querida?

**Nora:** Coleccionista. Me han dicho que aquí se consiguen piezas que no están en ningún catálogo legal.

**Madame Ourense:** Aquí se consigue de todo, si se tienen dos cosas: dinero y un sello. El sello dorado en la invitación es lo que separa a los nuestros de la chusma curiosa.

- *(Opción del jugador)* **Seguir el juego de coleccionista**
**Nora:** Dinero tengo. Y el gusto por lo exclusivo. ¿Cómo consigue una dama su sello?

**Madame Ourense:** Con una recomendación... o con un descuido mío. Y yo esta noche estoy siendo muy descuidada con usted, no sé por qué. Me recuerda a alguien peligroso.

- *(Opción del jugador)* **Presionar con lo que sabes**
**Nora:** Sé lo del Cónclave del Bronce. Sé lo de la balanza. Podría cerrarle el salón esta noche, Madame.

**Madame Ourense:** Podría. Pero entonces no vería la lista de clientes, ¿verdad? Y sin lista, solo tiene a una anfitriona vieja. Yo soy la puerta, no la casa.

**Nora:** El sello de la casa. La lista en la trastienda. Madame es una puerta, no la casa: necesito lo que guarda detrás. Voy a colarme en su trastienda.


### La trastienda
_fuente: _dlg_trastienda()_

**Nora:** El Corredor jefe tiene nombre en la lista. Y todo apunta a la subasta de luna llena. Ahí caerán todos.

> **PISTA — El corredor jefe:** La lista revela al Corredor jefe y la fecha de la gran puja: luna llena en la casa de subastas.

**(Narrador/voz en off):** La trastienda de Madame es un despacho forrado de archivadores con cerradura. Con paciencia y una horquilla, el cajón bueno cede.

**Nora:** La lista de clientes. Apellidos que salen en los periódicos... en la sección de sociedad, no en la de sucesos.

**(Narrador/voz en off):** Junto a la lista, un organigrama. En la cima del transporte, un nombre subrayado dos veces: el Corredor jefe, con dirección y todo. Y una fecha en rojo: la gran puja, luna llena.

- *(Opción del jugador)* **Fotografiar la lista entera**
**(Narrador/voz en off):** Disparas la cámara sobre cada página. Clientes, precios, 'piezas' pasadas y futuras. Sara Beltrán aparece con un número de lote.

**Nora:** Sara es un número de lote. Voy a convertir ese número en una detención y a estos apellidos en titulares.

- *(Opción del jugador)* **Buscar quién está por encima**
**(Narrador/voz en off):** En el margen, una anotación de puño y letra de Madame: 'Consultar con A.V. antes de la puja'. Solo iniciales. A.V.

**Nora:** (A.V. Alguien a quien hasta el Corredor jefe consulta. La cima de verdad tiene esas dos letras.)

**Nora:** El Corredor jefe, la lista, la fecha de la puja. Tengo la noche y el lugar. En la próxima luna llena, el Cónclave se reúne... y yo estaré dentro con Núñez detrás.


### La redada
_fuente: _dlg_redada()_

> **PISTA — El eslabón que canta:** Cae la subasta y el Corredor jefe; para salvarse, delata a quien manda: las iniciales A.V.

**(Narrador/voz en off):** Noche de luna llena. La casa de subastas reluce como un teatro. Desde dentro, con un sello robado en la solapa, ves subir al estrado el horror disfrazado de puja elegante.

**Nora:** (Aguanta, Nora. Que suban todos a la vez. Que se confíen. Y entonces...)

**(Narrador/voz en off):** Cuando el martillo canta el primer 'lote', das la señal. Las puertas revientan. Núñez y treinta agentes limpios inundan el salón entre gritos y copas rotas.

**Nora:** ¡Cónclave del Bronce! ¡Quietos todos! Esta noche el lote que se subasta son ustedes.

**(Narrador/voz en off):** En la confusión, liberas a tres mujeres entre bambalinas. Una de ellas, temblando, susurra su nombre: Sara Beltrán. Viva.

**(Narrador/voz en off):** El Corredor jefe, acorralado contra el telón, levanta las manos y empieza a hablar atropelladamente para salvar su pellejo.

- *(Opción del jugador)* **"Un nombre. El de arriba."**
**El Corredor:** ¡Yo solo transporto! El que manda, el que protege a todos, el que era el dueño hasta de Bru... es Vaultier. Aristide Vaultier. ¡Yo solo cumplo órdenes!

**Nora:** (A.V. Aristide Vaultier. El magnate intocable. Por fin la cima tiene cara.)

- *(Opción del jugador)* **"¿Dónde está Vaultier ahora?"**
**El Corredor:** En su bufete, o en su mansión, rodeado de abogados y de jueces amigos. A él no lo tocará nunca. Es demasiado grande. Ustedes solo cazan recaderos.

**Nora:** Un recadero más entre rejas y una subasta reventada. Pero el que firma los cheques tiene nombre: Vaultier. Y contra un apellido así se necesita más que una redada.


### Cierre
_fuente: _dlg_cierre5()_

**Sgto. Núñez:** Aristide Vaultier. Constructoras, bancos, media ciudad le debe favores. Y ahora sabemos que era el dueño del Cónclave.

**Nora:** El que protegía a Bru. El que firma las órdenes de 'no patrullar'. La cabeza que buscábamos desde la primera tormenta.

**Vera Lang:** Contra Vaultier no vale una redada. Vale una prueba tan grande que ningún juez amigo pueda enterrarla. Y yo tengo un periódico esperándola.

**Sgto. Núñez:** Un último caso, detective Vega. El más grande. Y probablemente el que nos entierre a todos si fallamos.

**Nora:** Entonces no fallemos. Voy a por Vaultier. Hasta la cúspide.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 5 —  Cayó la subasta, cayó el Corredor. Queda una sola silla en la cima, y un solo apellido: Vaultier.



## Capítulo 6 · La cúspide

### Briefing
_fuente: _dlg_brief6()_

**Sgto. Núñez:** Vaultier recibe en su bufete. Nadie le arranca nada allí. Pero es el único sitio por donde empezar.

**(Narrador/voz en off):** El nombre de Vaultier pesa tanto que en la comisaría lo pronuncian bajando la voz. Núñez cierra la puerta con llave antes de hablar.

**Sgto. Núñez:** Aristide Vaultier. No existe expediente suyo porque cada vez que alguien abre uno, desaparece. Como las mujeres. Es el hombre más limpio de la ciudad sobre el papel.

**Nora:** Los más limpios sobre el papel son los que tienen a alguien limpiando. Voy a ir de frente: a su bufete, a mirarle a los ojos.

**Sgto. Núñez:** No le sacará una confesión. Pero le hará saber que existe. A veces, con esta gente, que sepan que van a caer ya es empezar a empujarlos.

**Nora:** Que sepa que existo. Buen principio. Al bufete Vaultier.


### El despacho
_fuente: _dlg_despacho()_

**Nora:** Vaultier es la cima, sí. Pero es intocable sin dinero rastreable. Hay que seguir los pagos.

> **PISTA — El nombre de arriba:** Aristide Vaultier dirige el Cónclave; se sabe intocable y casi lo confiesa, seguro de su impunidad.

**(Narrador/voz en off):** El bufete Vaultier ocupa la última planta de una torre de cristal. Desde el ventanal, la ciudad de neón parece un tablero suyo. Vaultier, elegantísimo, ni se levanta.

**Aristide Vaultier:** La famosa detective Vega. Siéntese. Es usted una mujer notable: ha desmontado un negocio que llevaba décadas funcionando. Casi da pena.

**Nora:** Lo dice como si el negocio fuera suyo.

**Aristide Vaultier:** Digo lo que quiero, aquí y donde sea. Esa es la diferencia entre usted y yo, detective. Usted persigue la verdad. Yo, sencillamente, decido cuál es.

- *(Opción del jugador)* **"Sé lo del Cónclave. Y lo probaré."**
**Aristide Vaultier:** Pruébelo. Tiene un libro que ningún juez admitirá, la palabra de un recadero cobarde y la cara de una periodista a la que despediré con una llamada. Yo tengo la ciudad.

**Nora:** (Está tan seguro que casi lo admite. La soberbia es la grieta de los intocables.)

- *(Opción del jugador)* **"¿Por qué mujeres? ¿Por qué así?"**
**Aristide Vaultier:** Porque puedo. Porque hay quien colecciona arte y quien colecciona poder sobre lo único que el dinero no debería comprar. A Bru lo movía el amor, pobre iluso. A mí, la certeza de que nada me alcanza.

**Nora:** El nombre de arriba, confesado por pura soberbia. Pero la soberbia no es prueba. Si él decide la verdad, yo tendré que traer uña que no pueda tapar: su dinero. Voy a seguir los pagos.


### Pista falsa
_fuente: _dlg_falso6()_

**Nora:** El 'trato' del secretario era una trampa para comprarme o grabarme. Ni de lejos.

**(Narrador/voz en off):** En el pasillo, un secretario impecable te intercepta con una sonrisa ensayada y un sobre grueso entre los dedos.

**Nora:** Déjeme adivinar. Dentro hay más de lo que gano en cinco años.

**(Narrador/voz en off):** 'El Sr. Vaultier admira su talento', ronronea. 'Le ofrece una jefatura, un despacho como este, y el olvido de este malentendido. Solo tiene que firmar su traslado... y su silencio.'

**Nora:** ¿Y si en vez de firmar, me llevo el sobre como prueba de cohecho?

**(Narrador/voz en off):** El secretario ni parpadea: 'Entonces jurará ante el juez que usted lo exigió. Somos tres testigos y usted, una. ¿Ve el problema?'

**Nora:** (Un soborno que es una trampa. Acepto y me compran; me niego con el sobre y me hunden por extorsión. No hay pista aquí: hay una jaula.)

**Nora:** Guárdese su sobre y su jaula. No todas las piezas de este tablero están a la venta. Empezando por mí.


### El contable
_fuente: _dlg_contable()_

**Nora:** Los pagos del Cónclave salían de una cuenta fantasma de Vaultier. El dinero sí deja huella.

> **PISTA — Los pagos:** Una cuenta fantasma conecta a Vaultier con los pagos al Corredor y a los policías comprados.

**(Narrador/voz en off):** El contable del gremio, un hombrecito gris al que Vera Lang localizó, tiembla en un piso franco. Ha decidido hablar el día que ha entendido que él también es prescindible.

**Nora:** Vaultier dice que su dinero es invisible. Usted lo movía. Dígame que se equivoca.

**El contable:** Se equivoca en una cosa: creía que yo destruía los duplicados. Los guardé. Todos. Una cuenta en el extranjero, 'Fundación Bronce', desde la que se pagaba al Corredor, a los jueces, a los policías. Todo cuadra al céntimo.

- *(Opción del jugador)* **"¿Puede probarse que es suya?"**
**El contable:** Con estos duplicados y su firma real en la apertura, sí. Es el único papel que Vaultier no pudo tocar porque no sabía que existía.

- *(Opción del jugador)* **"¿Por qué me ayuda ahora?"**
**El contable:** Porque después de la subasta, oí a Vaultier dar mi nombre en una frase que terminaba en 'ocúpate'. Prefiero un juicio a un accidente de coche.

**Nora:** Los pagos. La cuenta fantasma con su firma. El dinero es la única verdad que Vaultier no puede reescribir. Ya casi lo tengo: solo me falta romper su coartada.


### La coartada
_fuente: _dlg_coartada()_

**Nora:** Su coartada de las noches de tormenta es falsa. Vaultier subía a su azotea a 'presidir'. Ahí lo espero.

> **PISTA — La coartada rota:** Las noches de los secuestros Vaultier no estaba en sus galas: subía a la azotea de su torre.

**(Narrador/voz en off):** La mansión Vaultier presume de coartadas: fotos del magnate en galas benéficas cada noche de tormenta. Demasiado puntual para ser verdad.

**Nora:** Un hombre que aparece fotografiado en una gala EXACTAMENTE en cada desaparición. O es mala suerte... o es puesta en escena.

**(Narrador/voz en off):** Cotejas las fotos con Vera. En todas, el mismo esmoquin, la misma copa a medio llenar, el mismo ángulo. Fueron tomadas el mismo día y repartidas por noches.

- *(Opción del jugador)* **Interrogar al servicio**
**(Narrador/voz en off):** Una doncella despedida sin carta habla por rencor: cada noche de tormenta, el señor subía solo a la azotea de su torre y prohibía molestarle. 'A ver llover', decía.

**Nora:** A ver llover. Desde la azotea más alta de la ciudad. Presidiendo su cosecha como un dios de pacotilla.

- *(Opción del jugador)* **Revisar los registros del ascensor**
**(Narrador/voz en off):** El registro privado del ascensor de la torre no miente como las fotos: cada noche señalada, un único viaje a la azotea a las 23:00. Y bajada de madrugada.

**Nora:** El ascensor lo delata. A las once arriba, de madrugada abajo. Justo la hora de cada campana.

**Nora:** La coartada rota. El dinero, el testigo, la mentira de las fotos... lo tengo entero. Y sé dónde estará esta noche de tormenta: en su azotea. Voy a subir a por él.


### La azotea
_fuente: _dlg_azotea()_

> **PISTA — La cúspide:** Aristide Vaultier, detenido en su azotea con pruebas irrefutables. La cima, por fin, cae.

**(Narrador/voz en off):** La azotea de la torre Vaultier es el punto más alto de la ciudad. La tormenta azota los pararrayos como campanas invisibles. Vaultier, de esmoquin y sin paraguas, contempla su reino sin volverse.

**Aristide Vaultier:** Sabía que subiría, detective. Todos los que me persiguen acaban aquí arriba, conmigo, viendo lo pequeño que es el mundo desde la cima. Casi ninguno vuelve a bajar.

**Nora:** Yo traigo compañía, Vaultier. Su contable. Sus cuentas. El registro de su ascensor. Y una periodista imprimiendo mientras hablamos. Esta vez la verdad la decido yo.

**Aristide Vaultier:** Impresionante. De verdad. Pero mire abajo: mis jueces, mis periódicos, mis policías. ¿Cuánto cree que sobrevive su 'verdad' ahí abajo, en mi ciudad?

- *(Opción del jugador)* **"Esta noche no es su ciudad."**
**(Narrador/voz en off):** Abajo, en la avenida, un río de luces azules rodea la torre. Núñez ha traído a los limpios, y a la prensa que Vera no pudo callar. Por una vez, el ruido no lo controla Vaultier.

**Nora:** Escuche las sirenas, Vaultier. No las manda usted. Su ciudad, esta noche, ha dejado de contestarle.

- *(Opción del jugador)* **Enseñarle las pruebas en la mano**
**(Narrador/voz en off):** Alzas la carpeta a la luz de un relámpago: la firma de la cuenta fantasma, imposible de negar. Por primera vez, la sonrisa del magnate vacila.

**Nora:** Su firma, Vaultier. La única cosa de este mundo que no pudo comprar ni borrar: su propio nombre en el sitio equivocado.

**(Narrador/voz en off):** Por un instante, Vaultier mira el borde de la azotea, la caída, la salida elegante. Luego mira las esposas. Y elige, por cobardía o por soberbia, seguir vivo para pelear.

**Aristide Vaultier:** Tendré a los mejores abogados del país, detective. Esto no ha terminado.

**Nora:** Puede. Pero por primera vez tendrá que pelear. Y las mujeres a las que convirtió en lotes tendrán, por fin, un juicio con su nombre en la portada. Vamos abajo. Llueve.


### Cierre
_fuente: _dlg_cierre6()_

**(Narrador/voz en off):** El juicio de Vaultier llena las portadas durante semanas. El de Vera, sin censura por primera vez. La 'Fundación Bronce' se desmorona, apellido a apellido.

**Sgto. Núñez:** No hemos limpiado la ciudad, detective Vega. Eso no pasa nunca. Pero le hemos quitado la cúspide. Y las que estaban 'en catálogo' están en casa.

**Vera Lang:** Sara, Elena, Nadia, y otras nueve. Nombres, no lotes. En mi periódico, en primera, con foto y apellido. Se lo debía a las que no llegamos a tiempo.

**Nora:** A esas también. Sobre todo a esas.

**(Narrador/voz en off):** Nora sale a la calle. Ha dejado de llover. Sobre el Barrio Viejo, por primera vez en mucho tiempo, las campanas suenan a las horas, y solo a las horas.

**Sgto. Núñez:** Descanse, detective. Se lo ha ganado. Aunque los dos sabemos que en esta ciudad el descanso dura lo que tarda en formarse la próxima tormenta.

**Nora:** Que se forme. Cuando caiga, aquí estaré. El barrio es mío las noches que hagan falta.

**(Narrador/voz en off):** — FIN DE LA TEMPORADA 2 —  Seis casos. Seis tormentas. De una campana robada a una ciudad entera puesta del revés. sOC.



## Capítulo 7 · La receta (versión ampliada · canon largo)

### Briefing
_fuente: _dlg_brief7()_

**Sgto. Núñez:** La chica del río, la del veneno raro en la sangre. Baje a la morgue: Sonia la sigue teniendo en la mesa esperándola a usted.

**(Narrador/voz en off):** Han pasado meses desde que la torre de Vaultier se llenó de sirenas. Nora ya no es la intrusa de la ciudad: tiene mesa, placa reconocida y una silla que no cojea. Pero la lluvia sigue siendo la misma, y la cara de Núñez esta mañana también.

**Sgto. Núñez:** Buenos días, detective. Ojalá lo fueran. ¿Se acuerda de Rosa Marín, una de las mujeres que rescatamos del muelle en el caso Vaultier?

**Nora:** La pelirroja. La que declaró con las manos temblando y luego no quiso protección. Claro que me acuerdo.

**Sgto. Núñez:** Apareció anoche en el río. Y aquí viene lo que me quita el sueño: no se ahogó. Estaba muerta antes de tocar el agua.

**Nora:** ¿Un ajuste de cuentas? ¿Alguien del Cónclave que quedó suelto, cerrando bocas?

**Sgto. Núñez:** Eso pensé yo. Pero la forense dice que no hay violencia. Ni un golpe, ni una marca de forcejeo. La mató algo que llevaba dentro. Un veneno que ella no reconoce.

**(Narrador/voz en off):** Núñez desliza sobre la mesa el informe preliminar. En el margen, con la letra apretada de Sonia, una sola palabra subrayada dos veces: 'DESCONOCIDO'.

**Nora:** Sonia no subraya 'desconocido' por una aspirina. Si ella no lo reconoce, es que no está en ningún libro.

- *(Opción del jugador)* **"¿Por qué Rosa, y por qué ahora?"**
**Sgto. Núñez:** No lo sé. Sobrevivió a lo peor y meses después aparece envenenada con algo que no existe. O es un cabo suelto de Vaultier... o es un caso nuevo que ni sabíamos que teníamos.

**Nora:** (Sobrevivió al muelle para morir en el río. Alguien no quería que Rosa siguiera respirando. La pregunta es qué llevaba en la sangre que valía una vida.)

- *(Opción del jugador)* **"¿Hay más como ella?"**
**Sgto. Núñez:** Esa es la pregunta que no me atrevo a hacerme en voz alta, detective Vega. Porque si empiezo a cruzar autopsias con 'causa desconocida'... vaya usted a saber cuántos ríos abajo miran hacia otro lado.

**Nora:** Empecemos por una. Rosa merece que alguien mire de frente lo que a ella la mató.

**Sgto. Núñez:** Baje a la morgue. Sonia la ha tenido en la mesa toda la noche esperándola. Dice que solo se lo enseña a usted, que del resto no se fía. Cosa de amigas, supongo.

**Nora:** Con Sonia siempre es cosa de amigas y de ciencia, en ese orden. A la morgue, pues. A ver qué mató a Rosa Marín.


### La morgue
_fuente: _dlg_l7a()_

**Sonia:** Ya lo tienes anotado, Nora: 'Somnia'. Un fármaco de laboratorio, no de garaje. Eso es lo que mató a Rosa. Sigue el hilo hacia quien lo fabrica.

> **PISTA — El fármaco Somnia:** En la sangre de Rosa, un fármaco experimental sin nombre comercial: 'Somnia'. De un laboratorio, no de la calle.

**(Narrador/voz en off):** La morgue municipal es el sitio más honesto de la ciudad: aquí no hay abogados, ni sobres, ni sonrisas. Solo acero, frío y la verdad tumbada bajo una sábana. Sonia te espera con dos cafés, uno para cada mano, como siempre.

**Sonia:** Vega. Llegas con esa cara de 'vengo a que me estropees el día'. Toma café, que vas a necesitar las dos manos para lo que traigo.

**Nora:** Diez años viéndote descubrir horrores con una sonrisa, Sonia. No sé cómo lo haces.

**Sonia:** Sonriendo. Es eso o volverme loca, y la locura no cotiza. Mira. Rosa Marín. Sin traumatismos, sin asfixia por agua, sin nada de lo que un río suele dejar.

**(Narrador/voz en off):** Sonia retira la sábana con el cuidado de quien respeta a los muertos más que a los vivos. Luego gira hacia ti una pantalla llena de picos y curvas.

**Sonia:** Su sangre, en cambio, es una fiesta química. Hay un compuesto que no está en ningún vademécum, en ninguna base de datos, en ningún manual que yo haya estudiado. Y he estudiado muchos.

**Nora:** ¿Un veneno nuevo?

**Sonia:** No exactamente. Es un sedante. Uno brutal, elegantísimo: apaga la conciencia sin apagar el cuerpo. Te deja despierta por fuera y ausente por dentro. Lo he bautizado 'Somnia', porque no tiene otro nombre.

**Nora:** Un sedante que deja el cuerpo dócil y la mente apagada... Sonia, eso es lo que usaban en los secuestros. Lo que las tenía quietas mientras se las llevaban.

**Sonia:** Exacto. Y aquí está lo que te va a quitar a TI el sueño: esto no lo cocina un camello en una bañera. Sintetizar Somnia requiere un laboratorio de verdad, reactivos caros, gente con doctorado. Es industria, Nora. No delincuencia de barrio.

- *(Opción del jugador)* **"¿Pudo ser una sobredosis accidental?"**
**Sonia:** Ni de broma. La dosis en Rosa es quirúrgica, calculada para matar despacio y limpio, como quien apaga una vela para que no eche humo. Esto es una ejecución con bata blanca.

**Nora:** (Una ejecución con bata blanca. La mataron con el mismo fármaco que la esclavizó. Poético y monstruoso a la vez.)

- *(Opción del jugador)* **"¿Por qué no lo denunciaste antes?"**
**Sonia:** Porque hasta hoy solo lo había visto en trazas, en las supervivientes del muelle, y siempre me decían 'archívalo, no relevante'. Contigo enfrente por fin puedo decirlo en voz alta: alguien está haciendo esto en serie, y a alguien de arriba le conviene que yo escriba 'desconocido'.

**Nora:** Pues a partir de ahora lo escribes con mi nombre al lado. Si te tocan, me tocan.

**Sonia:** Una cosa más, y esta te la doy como amiga, no como forense. Ten cuidado, Nora. La gente que fabrica algo así no deja cabos. Rosa era un cabo. Tú, en cuanto tires del hilo, serás otro.

**Nora:** Somnia. Un fármaco de laboratorio en la sangre de una superviviente. Lo apunto. Y tranquila, Sonia: llevo años siendo un cabo suelto que no se deja cortar.

**Sonia:** Por eso te quiero, boba. Ahora vete, que tengo que devolverle a Rosa la dignidad de una sábana limpia. Y busca ese laboratorio.


### Descartes/pistas falsas
_fuente: _dlg_rh7()_

**Nora:** Cinco pistas fáciles, cinco callejones. Somnia sale de un laboratorio, no de la calle. Vuelvo al hilo bueno: quién la receta.

**(Narrador/voz en off):** De vuelta en comisaría, Nora hace lo que haría cualquier detective con prisa y sin pista: llenar la pizarra de sospechosos fáciles. Cinco nombres, cinco flechas, una tarde entera de teléfono y café malo.

**Nora:** Empecemos por lo obvio, aunque lo obvio casi nunca sea lo cierto. ¿Quién mueve sedantes raros en esta ciudad?

**(Narrador/voz en off):** El primero, el camello del puente. Suda antes de sentarse.

**Sospechoso:** ¿Somnia? Yo vendo pastillas de colores y grifa mala, detective. Lo que me describe es de película. Yo no llego a tanto, ni queriendo.

**Nora:** (Dice la verdad. Este no distingue un laboratorio de una farmacia.) Siguiente.

**(Narrador/voz en off):** Un veterinario que compra sedantes a granel: eran para el ganado, con factura. Una enfermera despedida con rencor: robaba gasas, no ciencia. Un químico jubilado con laboratorio casero: solo destila orujo. Un curandero que 'cura el sueño': valeriana en bolsitas.

**Nora:** Cinco flechas, cinco tachones. El camello no llega, el veterinario está limpio, la enfermera roba gasas, el químico hace orujo y el curandero, infusiones.

**Nora:** (Cinco callejones sin salida en una tarde. Casi un récord. Y en el fondo, lo agradezco: cada pista falsa me confirma lo que Sonia ya sabía.)

**Nora:** Somnia no la fabrica un aficionado con mala suerte. La fabrica alguien con bata, presupuesto y firma. Fuera la pizarra fácil. Vuelvo al único hilo que aguanta un tirón: quién le recetó veneno a Rosa.


### El hospital
_fuente: _dlg_l7b()_

**Nora:** El Dr. Kessler firmó recetas de un 'ansiolítico en pruebas' a Rosa y a otras antes de desaparecer. Es el primer eslabón. A su clínica.

> **PISTA — El médico que receta:** Un tal Dr. Kessler firmó recetas de un 'ansiolítico en pruebas' a Rosa y a varias víctimas antes de desaparecer.

**(Narrador/voz en off):** El hospital central de noche es un animal dormido que respira por sus fluorescentes. Nora se cuela en el archivo de farmacia con una sonrisa y una placa, y empieza a cruzar nombres con la paciencia de un relojero.

**Nora:** Si Somnia sale de un laboratorio, en algún punto tuvo que tocar el sistema legal. Un ensayo, una receta, un formulario. La sangre limpia deja rastro en el papel sucio.

**(Narrador/voz en off):** Hora tras hora, un patrón emerge de la marea de historiales. Un nombre que se repite en la casilla de 'médico prescriptor', siempre asociado a un mismo fármaco críptico.

**Nora:** Dr. Kessler. Recetó a Rosa Marín un 'ansiolítico en fase de pruebas' tres semanas antes de que apareciera en el río. Y no solo a ella.

**(Narrador/voz en off):** Cruzas más fichas. El nombre de Kessler brota una y otra vez, siempre junto a mujeres que después figuran como desaparecidas o muertas de 'causa desconocida'.

**Nora:** Media docena, por lo menos. Todas pasaron por su consulta. Todas recibieron la misma 'medicación experimental'. Todas terminaron mal.

- *(Opción del jugador)* **"¿Kessler las elegía... o solo las trataba?"**
**(Narrador/voz en off):** Repasas los ingresos: ninguna llegó a Kessler por casualidad. Todas fueron 'derivadas' a él con una nota idéntica: 'candidata a programa de sueño'.

**Nora:** (No las trataba: las seleccionaba. Kessler no es un médico que se equivoca. Es un cazador con recetario.)

- *(Opción del jugador)* **"¿Dónde está Kessler ahora?"**
**(Narrador/voz en off):** El hospital lo dio de baja hace un mes 'por motivos personales'. Pero conserva una consulta privada, discreta, en un edificio sin placa.

**Nora:** Un médico que reparte veneno y luego se esconde en una consulta sin nombre. Nada dice más alto 'culpable' que una puerta sin letrero.

**Nora:** El que reparte la droga es el que marca a las presas. Kessler es mi primer eslabón de verdad. El médico que receta. Lo apunto, y me presento en esa consulta sin nombre antes de que le dé por desaparecer a él también.


### Final: Dr. Kessler
_fuente: _dlg_fin7()_

> **PISTA — El eslabón Kessler:** Kessler admite que le pagaban por 'seleccionar candidatas' para un ensayo; membrete: una serpiente enroscada en una copa. No sabe de quién.

**(Narrador/voz en off):** La consulta privada del Dr. Kessler huele a desinfectante caro y a miedo barato. Él está detrás de una mesa impecable, con las manos demasiado quietas, como quien lleva semanas esperando que llamen a la puerta.

**Dr. Kessler:** Detective Vega. Sé quién es usted. La que no se deja... la que no para. Siéntese, por favor. Llevo tiempo sin dormir, así que perdone si voy directo: sabía que vendría alguien.

**Nora:** Rosa Marín. Elena. Nadia. Media docena de mujeres con su firma en la receta y Somnia en la sangre. Empiece por explicarme eso, doctor. Despacio.

**Dr. Kessler:** Yo... yo seleccionaba candidatas. Eso era todo, se lo juro. Mujeres solas, ansiosas, insomnes, sin familia que preguntara. Rellenaba una ficha, las 'derivaba a un programa', y me pagaban por cada una. Nunca pregunté para qué.

**Nora:** Derivaba mujeres a un matadero por un sobre y prefería no saber a qué matadero. Eso no le hace inocente, Kessler. Le hace cómplice con coartada moral.

**Dr. Kessler:** ¿Cree que no lo sé? ¿Cree que duermo? Empecé por deudas. Un 'ensayo privado bien pagado', me dijeron. Para cuando entendí que las que derivaba no volvían, ya era suyo. Un médico endeudado es la marioneta más barata del mundo.

**(Narrador/voz en off):** Se le quiebra la voz. Abre un cajón con manos temblorosas y saca un sobre, uno de los muchos con los que le pagaban.

**Dr. Kessler:** Todo por mensajeros. Nunca vi una cara. Solo esto: el membrete que venía en cada sobre. Yo lo miraba y hacía como que no significaba nada.

**(Narrador/voz en off):** En el papel, grabado en relieve, un símbolo elegante y frío: una serpiente enroscada en una copa. El emblema clásico de la medicina, retorcido hasta parecer una amenaza.

**Nora:** La serpiente y la copa. El símbolo de curar, usado por los que envenenan. Qué sentido del humor tan enfermo.

- *(Opción del jugador)* **"¿Quién le pagaba? Un nombre."**
**Dr. Kessler:** ¡No lo sé, se lo juro por lo que quiera! Nunca hubo un nombre. Solo el símbolo, y una vez, en una llamada, una voz que dijo 'el laboratorio agradece su colaboración'. Laboratorio. Esa fue la palabra. Gente de bata, como yo, pero arriba.

**Nora:** (Un laboratorio. Sonia tenía razón: es industria. Kessler es el eslabón más bajo de una cadena que sube hacia batas más limpias y manos más sucias.)

- *(Opción del jugador)* **"¿Reconoció a alguna de sus víctimas?"**
**Dr. Kessler:** A todas. Ese es mi castigo: recuerdo cada cara. Rosa venía con una foto de su sobrina, me hablaba de ella para no llorar. Y yo firmaba su sentencia con una sonrisa profesional. Deténgame, detective. Por favor. Se lo pido yo.

**Nora:** Lo detendré. Pero antes va a ayudarme a subir por esa cadena. Su cárcel puede empezar siendo útil.

**Nora:** Una serpiente en una copa. Un 'laboratorio' sin nombre que paga por seleccionar mujeres. Kessler es culpable, sí, pero es el peldaño de abajo. El hilo sube, y sube hacia gente con doctorado y presupuesto.

**(Narrador/voz en off):** Esposas al médico y precintas el sobre como oro. Fuera, la lluvia repica sobre la consulta sin placa. El caso ya no es una muerta en un río: es una droga con símbolo propio.

**Nora:** Núñez tiene que ver este membrete. Y hay algo que me quema por dentro y que aún no le he contado a nadie: esta serpiente... la he visto antes. En un frasco, en casa de mi hermano Diego.


### Cierre
_fuente: _dlg_cierre7()_

**(Narrador/voz en off):** En comisaría, de madrugada, Núñez le da vueltas al sobre bajo la lámpara como si el símbolo fuera a confesar por sí solo.

**Sgto. Núñez:** Así que las desapariciones de todos estos años... ¿eran una cantera? ¿Se las llevaban para probar una droga en ellas?

**Nora:** Eso parece, sargento. Bru las coleccionaba, Vaultier las vendía, pero ninguno de los dos fabricaba nada. Solo eran proveedores. Quien fabrica Somnia está por encima de todos ellos, y no se ha movido de su laboratorio ni cuando cayó Vaultier.

**Sgto. Núñez:** Un laboratorio con una serpiente por bandera. Podría ser cualquiera de las diez farmacéuticas de esta ciudad, detective Vega. Todas usan ese símbolo.

**Nora:** Todas menos una lo usan para curar. Voy a encontrar cuál lo usa para lo contrario.

**(Narrador/voz en off):** Núñez asiente, cansado, y se guarda el sobre. Nora se queda un momento a solas, mirando por la ventana la lluvia sobre el neón.

**Nora:** Hay algo que no le he dicho, Núñez, porque llevo dos años sin querer decírmelo ni a mí misma. Mi hermano Diego toma algo para dormir desde hace meses. Un frasco sin marca, con una serpiente en una copa.

**Sgto. Núñez:** Detective Vega... si eso es lo que creo que es, su hermano no es un paciente. Es una prueba andando. Y usted acaba de convertir esto en algo personal.

**Nora:** Ya era personal cuando Rosa apareció en el río. Ahora es de familia. Mañana empiezo por Diego. Y por el frasco que ha tenido en su mesilla todo este tiempo.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 7 —  El caso ya no son unas mujeres: es una droga con símbolo de médico. Y el hilo acaba de meterse, sin avisar, en la propia sangre de Nora.



## Capítulo 0 · Tutorial (cómo se juega)

### Briefing (comisaría) — brief0
_clave S3: "brief0"_

**(Narrador/voz en off):** Bienvenido a sOC. Esto es el CAPÍTULO 0: el tutorial. Aquí vas a aprender a jugar paso a paso. Toca la pantalla (o haz clic) para pasar cada línea de texto.

**(Narrador/voz en off):** Estás en la COMISARÍA, tu base de operaciones. Alguien va a hablarte...

**Sgto. Núñez:** Buenas noches. Soy el sargento Núñez. Trabajo aquí, en la comisaría, y voy a ser tu apoyo durante todo el juego.

**(Narrador/voz en off):** » Ese es el SARGENTO NÚÑEZ. Cuando un personaje habla, ves su RETRATO a un lado de la pantalla y su NOMBRE encima del texto.

**Nora:** Y yo soy Nora Vega. Detective. La que se va a patear cada caso hasta el fondo, caiga quien caiga.

**(Narrador/voz en off):** » Ella es NORA VEGA, la PROTAGONISTA: a la que acompañas durante todo el juego. Su retrato aparece al OTRO lado cuando habla ella.

**Sgto. Núñez:** El trabajo es fácil de entender: la ciudad es un MAPA con lugares marcados. Vas a un lugar, hablas con la gente y sacas PISTAS. Con las pistas, resuelves el caso.

**Nora:** Empecemos por lo básico. En cuanto cerremos esta charla, volverás al mapa. Yo te voy guiando.

**Sgto. Núñez:** Y no te limitarás a leer: en cada sitio BUSCARÁS pistas en el escenario, EXAMINARÁS detalles de cerca, forzarás algún CANDADO, presentarás PRUEBAS para pillar una mentira y ATARÁS CABOS para deducir. Yo te guío en cada paso.

**(Narrador/voz en off):** » AHORA: al cerrar esto verás el MAPA. Habrá un punto que PARPADEA (la Plaza del Barrio). TÓCALO para ir allí. Arriba del todo, la barra de OBJETIVO te dirá siempre qué hacer.


### Localización A — l0a
_clave S3: "l0a"_

> **PISTA — Leer el escenario:** Cada lugar que visitas abre una escena; lo que sacas en claro se anota como PISTA en tu libreta.

**(Narrador/voz en off):** Has llegado a la PLAZA. Esto es una LOCALIZACIÓN: una escena donde observas y hablas con la gente. Toca para avanzar el texto, como hasta ahora.

**Nora:** Aquí miro, escucho y ato cabos. Y cuando saco algo que de verdad importa, eso es una PISTA.

**(Narrador/voz en off):** » Cuando consigues una pista, se guarda sola en tu LIBRETA: el botón con el cuaderno, arriba a la DERECHA de la pantalla.

**Nora:** Tu primera pista ya es tuya: aprender a leer un escenario. No tienes que apuntar nada, el juego lo hace por ti.

**(Narrador/voz en off):** » Al cerrar esta escena verás la PISTA VOLAR hasta el icono de la libreta. Ahí quedan guardadas TODAS; pulsa el icono cuando quieras para releerlas.

**(Narrador/voz en off):** » Además, en el MAPA habrán aparecido lugares NUEVOS. Toca el siguiente punto que PARPADEE para continuar el tutorial.


### Descartes / pistas falsas — rh0
_clave S3: "rh0"_

**(Narrador/voz en off):** Estás en un CALLEJÓN. Aquí aprendes algo clave: no todo lo que encuentras es una pista de verdad.

**Nora:** Mira: un gato, un borracho, una sombra, un grafiti, un coche mal aparcado... Sustos que no llevan a nada. Son PISTAS FALSAS.

**(Narrador/voz en off):** » Las pistas FALSAS el juego las DESCARTA solas: las verás salir hacia la libreta pero TACHADAS en ROJO, y NO se guardan. No cuentan para resolver el caso.

**Nora:** No pierdas el tiempo con ellas. Cinco sustos, cero pistas buenas. Volvamos al hilo que sí importa.

**(Narrador/voz en off):** » Vuelve al mapa y toca el siguiente punto que parpadee para seguir el tutorial.


### Localización B — l0b
_clave S3: "l0b"_

> **PISTA — Tirar del hilo:** Cada caso necesita TODAS sus pistas de calle antes de abrir el lugar clave. El objetivo de arriba te avisa cuando ya las tienes.

**(Narrador/voz en off):** La TIENDA de la esquina. Aquí sacas tu SEGUNDA pista de verdad.

**Nora:** Con esta ya tengo las dos pistas que pedía este caso de prácticas.

**(Narrador/voz en off):** » REGLA IMPORTANTE: el LUGAR donde se resuelve el caso NO se abre hasta que tienes TODAS las pistas. Mira la barra de OBJETIVO arriba: ahora te dirá que vayas al lugar clave.

**(Narrador/voz en off):** » Vuelve al mapa y toca el ARCHIVO, el punto que se acaba de desbloquear.


### Localización (tutorial) — l0c
_clave S3: "l0c"_

**(Narrador/voz en off):** El interrogatorio: presentaste la prueba y lo pillaste en la mentira.


### Final del caso — fin0
_clave S3: "fin0"_

> **PISTA — Cerrar el caso:** Con las pistas reunidas se llega al lugar clave y se resuelve el caso. Después, se informa en comisaría para abrir el siguiente.

**(Narrador/voz en off):** El ARCHIVO. Este es el LUGAR CLAVE del caso, y solo se abrió porque ya tenías todas las pistas.

**Nora:** Aquí se junta todo y el caso se resuelve. Esto es siempre lo último de cada caso.

**(Narrador/voz en off):** » Al resolverlo verás el aviso «Caso resuelto». Después SIEMPRE hay que volver a la COMISARÍA a informar: eso abre el caso siguiente.

**Nora:** Caso de prácticas: resuelto. No estaba mal para ser de mentira.

**(Narrador/voz en off):** » Vuelve al mapa por última vez y toca la COMISARÍA para terminar el tutorial.


### Cierre — cierre0
_clave S3: "cierre0"_

**(Narrador/voz en off):** De vuelta en la comisaría. Fin del tutorial.

**Sgto. Núñez:** Bien hecho. Ese es el oficio: recorre el MAPA, BUSCA y EXAMINA para sacar PISTAS, fuerza lo que se cierre, PRESENTA la prueba que pilla la mentira y DEDUCE para cerrar el caso. Luego, siempre, INFORMA en comisaría.

**(Narrador/voz en off):** » El juego GUARDA solo a cada paso. Puedes cerrar cuando quieras y pulsar «Continuar» en el menú principal para seguir donde lo dejaste.

**Nora:** Lo tengo. Mapa, pistas, libreta, lugar clave, informar. Vamos a lo de verdad.

**Sgto. Núñez:** Se acabó el ensayo. Tu primer caso real: una desaparición en la iglesia de San José. Suerte ahí fuera, detective Vega.

**Nora:** El barrio es mío esta noche.

**(Narrador/voz en off):** » Empieza el CASO 1. A partir de aquí, tú decides. ¡Suerte!



## Capítulo 8 · El hermano

### Briefing (comisaría) — brief8
_clave S3: "brief8"_

**(Narrador/voz en off):** La comisaría a las tres de la mañana es un pasillo de fluorescentes que zumban y cafés olvidados. Nora tiene sobre la mesa el folleto que sacó del sótano: 'Proyecto Somnia'. La misma palabra que su hermano lleva meses repitiendo sin darse cuenta.

**Nora:** Somnia. Lo he oído en mi propia familia. Diego, mi hermano pequeño, toma 'algo para dormir' desde el invierno. 'Unas pastillas nuevas, gratis', decía. Yo no escuché. Estaba en el caso.

**Sgto. Núñez:** Detective Vega, párese un segundo. Si el nombre de su caso ha entrado en la casa de su hermano, esto ya no es una investigación: es una herida. Y con una herida abierta se cometen errores.

**Nora:** Lo sé. Por eso quiero hacerlo bien. Necesito ver a Diego, ver esas pastillas, y necesito que quede fuera de mi informe hasta que sepa qué es. Si esto es lo que temo, es un testigo. Y si es peor, es una víctima.

**Sgto. Núñez:** Fuera del informe, de momento. Pero prométame una cosa: en cuanto la sangre le nuble la cabeza, me llama. No entra sola donde no debe.

- *(Opción del jugador)* **«Te lo prometo. Solo voy a hablar con mi hermano.»**
**Nora:** Solo voy a hablar con mi hermano, Núñez. Todavía puedo hacerlo como hermana.

**Sgto. Núñez:** Ojalá. Vaya. Y lleve el móvil cargado.

- *(Opción del jugador)* **«Si es Somnia, no prometo nada.»**
**Nora:** Si lo que le están dando a Diego es lo que durmió a esas mujeres, no le prometo que me quede quieta.

**Sgto. Núñez:** Me lo temía. Al menos avíseme antes de hacer una locura, no después.

**Nora:** (Cuarenta minutos en coche hasta su piso. Cuarenta minutos para decidir si voy a llamar a su puerta como policía o como su hermana mayor. No lo tengo claro, y eso ya me da miedo.)


### Localización A — l8a
_clave S3: "l8a"_

> **PISTA — El paciente cero:** Diego consume Somnia; se la dieron 'gratis' en un ensayo clínico para insomnes.

**(Narrador/voz en off):** El piso de Diego huele a cerrado y a café recalentado. Las persianas bajadas a mediodía, ropa por el suelo, un cerco de tazas en la mesa. Tu hermano pequeño tarda en abrir, y cuando lo hace, no es él: es una versión con diez años de más y las ojeras hasta el mentón.

**Diego Vega:** ¿Nora? Joder, ¿qué hora es? No... no es buen momento. Llevo una racha mala otra vez. Bueno, mala menos, desde las pastillas nuevas. Esas sí funcionan, hermana. Esas me apagan como a una lámpara.

**Nora:** Diego, mírame. ¿Cuándo dormiste de verdad por última vez sin ellas?

**Diego Vega:** No sé. ¿Septiembre? Da igual, ya no hace falta. Me metí en un ensayo para el insomnio. Gratis. Encima te pagan por ir a las revisiones. A mí, que no me llega el mes. Me pareció un regalo.

**Nora:** Enséñame el bote. Y el folleto. Todo lo que te dieran. Ahora, Diego.

**(Narrador/voz en off):** Rebusca en un cajón y te tiende un frasco ámbar sin etiqueta de farmacia, solo un código y un logo diminuto: una serpiente enroscada en una copa. El mismo que viste bordado en el terciopelo de la capilla.

**Nora:** (La serpiente en la copa. Aquí, en la mesilla de mi hermano. El caso ha estado durmiendo en esta casa todo el invierno y yo sin verlo.)

**Diego Vega:** Pones la cara de policía, Nora. No la de hermana. Me estás asustando. Son solo pastillas para dormir.

- *(Opción del jugador)* **Decírselo de golpe, sin adornos**
**Nora:** Diego, esa droga es la que usaban para dormir a las mujeres que secuestraban. La misma. Te has metido en la boca del lobo y te han pagado por entrar.

**Diego Vega:** No... no me jodas, Nora. Yo solo quería dormir. Fui a una clínica limpia, con batas blancas, con papeles. Firmé cosas. ¿Cómo iba a...?

**Nora:** No es culpa tuya. Los eligieron así: gente cansada, sola, que firmaría lo que fuera por una noche de sueño. Escúchame: se acabaron las pastillas desde este segundo.

- *(Opción del jugador)* **Protegerlo primero, explicarle después**
**Nora:** Necesito que confíes en mí y tires ese bote a la basura ahora mismo. Luego te lo explico entero. Pero no tomas una más.

**Diego Vega:** ¿Y si vuelven las noches en blanco? Tú no sabes lo que es, Nora. Es estar muerto pero despierto.

**Nora:** Lo sé mejor de lo que crees. Y aun así: ni una más. Prefiero verte sin dormir que no verte.

**Diego Vega:** Vale. Vale. Me das miedo, pero te hago caso. Siempre te hago caso, hermana mayor.

**Nora:** Una cosa más. La dirección de esa clínica. La necesito. Y necesito que no vuelvas por allí ni para devolver el frasco.

**(Narrador/voz en off):** Diego copia una dirección en un papel con mano temblorosa. Al dártelo, te agarra la muñeca un segundo, como cuando era niño y había tormenta.

**Diego Vega:** Cógelos, Nora. A los que hacen esto. Cógelos por mí y por todos los que firmaron pensando que era un regalo.


### Descartes / pistas falsas — rh8
_clave S3: "rh8"_

**(Narrador/voz en off):** Antes de la clínica, Nora tira de los hilos fáciles: los que cualquiera seguiría. Una trastienda de barrio que huele a incienso barato y a mentiras. El dueño vende de todo y sabe de nada.

**Nora:** Cinco pistas que apuntan a Somnia. Vamos a ver cuántas aguantan un empujón.

**(Narrador/voz en off):** El fanfarrón que presume de surtirla resulta que revende vitaminas caras en frascos bonitos. El compañero de piso de Diego, tan sospechoso por convivencia, está más roto por las pastillas que nadie: otra víctima.

**Nora:** La web milagro manda azúcar glas en cápsulas contra reembolso. El médico de guardia que ingresó a Diego una vez ni recuerda su cara. Y el foro de insomnes solo es un coro de desesperados recomendándose veneno.

**Nora:** Cinco puertas, cinco callejones. Ninguno FABRICA Somnia: todos la sufren o la imitan. El de la calle no es el proveedor.

**Nora:** El de verdad no vende en una trastienda. Está detrás de una bata blanca, en una clínica que no existe en ningún registro. Ahí es donde tengo que entrar.


### Localización B — l8b
_clave S3: "l8b"_

> **PISTA — La clínica fantasma:** El 'ensayo' de Diego se hacía en una clínica que no consta en ningún registro sanitario.

**(Narrador/voz en off):** La dirección del folleto te lleva a un edificio pulcro en una calle sin vida: cristales espejados, jardinera nueva, un timbre sin nombre. Demasiado limpio para un barrio así. Y cerrado a cal y canto.

**Nora:** Sin placa, sin licencia a la vista, sin horario. Una clínica que hace ensayos con personas y no aparece en ningún registro sanitario. Fantasma. Igual que las mujeres.

**(Narrador/voz en off):** Pegas la cara al cristal. Dentro se adivinan camillas, un mostrador vacío, un pasillo que se hunde en negro. En la puerta, una pegatina medio arrancada: la serpiente en la copa.

**Nora:** Está ahí. Todo está ahí dentro. Y no puedo tocar el pomo.

- *(Opción del jugador)* **Forzar la entrada ya, sin orden**
**Nora:** (Un empujón y estoy dentro. Y mañana un abogado de mil euros la hora tira todo lo que encuentre a la basura por 'prueba ilícita'. Justo lo que quieren.)

**Nora:** No. Así no. Si entro sucia, salen limpios. Esta vez lo hago blindado.

- *(Opción del jugador)* **Llamar a Clara y hacerlo legal**
**Nora:** Necesito una orden exprés y a alguien que sepa moverla entre jueces de guardia. Necesito a Clara.

**(Narrador/voz en off):** Marcas el número que juraste no volver a marcar. Tres tonos. Su voz, igual que la recordabas.

**Clara:** ¿Nora? Son las cuatro de la mañana. O te has muerto o me necesitas para algo turbio. ¿Cuál de las dos?

**Nora:** La segunda. Tengo una clínica fantasma llena de pruebas y ni un papel para entrar. ¿Me consigues la orden?

**Clara:** ...Dame dos horas y un juez que me deba un favor. Y, Nora: cuando esto acabe, tú y yo tenemos una conversación pendiente que no es sobre órdenes judiciales.

**Nora:** Dos horas. Que dentro no muevan nada. Voy a por lo único que puede tumbar a esta gente: hacerlo todo por el libro.


### Final del caso — fin8
_clave S3: "fin8"_

> **PISTA — Ensayos con personas:** Dentro: historiales de decenas de 'voluntarios' insomnes, muchos ya desaparecidos.

**(Narrador/voz en off):** Con la orden en la mano y Clara detrás vigilando cada paso, la puerta se abre. Por fuera, clínica. Por dentro, laboratorio: camillas con correas, monitores apagados, neveras llenas de viales ámbar con la serpiente impresa.

**Nora:** Correas en las camillas. Para dormir a nadie hacen falta correas.

**(Narrador/voz en off):** En una sala trasera, un archivador metálico. Decenas de carpetas. Cada una, un 'voluntario': fotos de fichaje, dosis, fechas, y una columna final que a algunos les pone 'baja' con una cruz.

**Nora:** Insomnes, solitarios, gente que nadie echaría de menos. Los eligieron por eso. Cobayas humanas con nombre, apellido y una cruz cuando dejaban de servir.

- *(Opción del jugador)* **Fotografiarlo todo antes de tocar nada**
**Nora:** Cadena de custodia. Primero foto, luego mano. Que ningún abogado pueda decir que me lo inventé.

**Clara:** Así me gusta. Cada carpeta, cada vial, cada correa. Esto ya no lo entierra nadie.

- *(Opción del jugador)* **Buscar la carpeta de Diego primero**
**(Narrador/voz en off):** Tus dedos encuentran su nombre antes de que lo decidas: 'Vega, Diego'. Dosis crecientes. Y en la última línea, una anotación reciente: 'candidato a fase 2'.

**Nora:** Fase 2. Iban a subirlo de fase. A mi hermano. Un mes más y su carpeta tendría una cruz.

**Clara:** Nora. Respira. Está vivo y está fuera. Ahora usa esa rabia para lo que sirve: para que esto no se caiga.

**(Narrador/voz en off):** Cotejas la lista con los archivos abiertos de la comisaría. Un tercio de esos 'voluntarios' constan como desaparecidos sin resolver. Los mismos nombres. Los mismos meses.

**Nora:** No secuestraban para vender. Secuestraban para PROBAR. Las desapariciones no eran el negocio: eran el residuo. El sótano sucio de un ensayo clínico con fachada de caridad.


### Cierre — cierre8
_clave S3: "cierre8"_

**(Narrador/voz en off):** Amanece sobre las cajas de pruebas apiladas en la sala de reuniones. Núñez pasa una por una las carpetas, sin decir nada, hasta que llega a la de la cruz.

**Nora:** Diego está fuera del ensayo, vigilado y durmiendo mal, que es lo mejor que le podía pasar. Pero es uno de cientos, Núñez. Esto no lo monta un médico loco en un garaje.

**Sgto. Núñez:** No. Neveras industriales, viales en serie, una clínica pantalla, una fundación que lava el dinero... Ensayos ilegales a esta escala solo los mueve una empresa con laboratorios. Una farmacéutica.

**Nora:** La serpiente en la copa no es el símbolo de un asesino. Es un logo corporativo. Alguien firma nóminas debajo de esa serpiente.

**Clara:** Y si es una empresa, tiene sociedades, contratos, consejo. Un rastro de papel que se puede seguir hasta arriba. Ahí sí sé nadar yo. Cuenta conmigo, Nora. De lleno.

**Nora:** Entonces dejamos de perseguir sombras en el barrio y empezamos a perseguir una firma. Buscamos la empresa detrás de la serpiente.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 8 —  El hermano de Nora era una cobaya. Detrás de la clínica fantasma ya no hay un monstruo: hay una empresa. Y las empresas dejan huellas.



## Capítulo 9 · La clínica fantasma

### Briefing (comisaría) — brief9
_clave S3: "brief9"_

**(Narrador/voz en off):** Sobre la pizarra, Núñez ha escrito una sola palabra dentro de un círculo: EMPRESA. Alrededor, las carpetas de la clínica. Nora la mira como quien mira un muro demasiado alto.

**Sgto. Núñez:** Para tocar a una farmacéutica que cotiza en bolsa no basta con una placa y buena voluntad. Necesita blindaje legal, detective Vega. Del bueno. Del que no se arruga ante un bufete de treinta abogados.

**Nora:** Sé lo que va a decir, Núñez, y la respuesta es no.

**Sgto. Núñez:** Usted conoce a la mejor abogada de esta ciudad. Da igual que además sea su ex. Los papeles no saben de corazones rotos.

**Nora:** Clara. Cómo no. Nada como pedir favores a quien te dejó precisamente por esto, por elegir el trabajo antes que la cena de aniversario. Dos veces.

**Sgto. Núñez:** Trague orgullo. Por las mujeres del archivo no le va a doler tanto.

**Nora:** (Hace catorce meses que no la llamo. Y voy a hacerlo para pedirle que me salve el caso. Muy propio de mí.)


### Localización A — l9a
_clave S3: "l9a"_

> **PISTA — Los ensayos ilegales:** Clara confirma que un ensayo sin consentimiento válido es delito grave y rastreable por la empresa promotora.

**(Narrador/voz en off):** El bufete de Clara huele a café bueno y a papel caro. Estanterías de tomos jurídicos, diplomas enmarcados, todo en orden. Ella te espera de pie tras la mesa, tan guapa y tan afilada como el día que se fue.

**Clara:** La detective Vega, en mi despacho, a plena luz. Debe de arder el mundo. O por fin has aprendido a pedir las cosas antes de que se rompan.

**Nora:** Arde, Clara. Ensayos con personas sin consentimiento, gente desaparecida, mi propio hermano de cobaya. Necesito saber a quién agarro y cómo, sin que un abogado caro lo tire todo en el juicio.

**Clara:** ¿Diego? ¿Tu Diego?

**Nora:** Mi Diego. Está fuera y a salvo. Pero por poco.

**(Narrador/voz en off):** Algo se ablanda un segundo en la cara de Clara. Luego vuelve la abogada, que es su forma de protegerse.

**Clara:** Escúchame bien. Un ensayo clínico sin consentimiento válido es delito grave, no una multa. Y toda la clave está en una palabra: 'promotor'. Hasta el ensayo más ilegal tiene una empresa que lo paga y lo diseña. Encuentra al promotor y tienes la cabeza, no la mano.

**Nora:** ¿Y cómo llego al promotor si todo lo firma gente que no existe?

**Clara:** Siguiendo el dinero y las firmas hacia arriba, capa por capa. Yo sé nadar en ese barro. Te ayudo.

- *(Opción del jugador)* **«Gracias, Clara. De verdad.»**
**Nora:** Gracias. De verdad. Sé lo que te estoy pidiendo y a quién.

**Clara:** No lo hago por ti, que quede claro. Lo hago por las que no pudieron firmar un 'no'. Pero el papeleo, esta vez, lo mando yo. Tú no mueves un dedo sin decírmelo.

- *(Opción del jugador)* **«¿Por qué me ayudas, después de todo?»**
**Nora:** ¿Por qué me ayudas, Clara? Después de cómo acabamos.

**Clara:** Porque sigo siendo abogada antes que tu ex, y esto es un crimen enorme. Y porque, aunque me cueste admitirlo, sé que tú no vas a parar. Prefiero que no pares bien acompañada que sola y a lo loco.

**Nora:** Trato hecho. El promotor. Esa es la palabra. Sigamos al que paga.


### Descartes / pistas falsas — rh9
_clave S3: "rh9"_

**(Narrador/voz en off):** El promotor se esconde tras un local de inscripción de voluntarios, de esos con cartel de buena gente y papeles de nadie. Con Clara al lado, Nora interroga a los cinco nombres que rodean la clínica.

**Clara:** Antes de subir, quitemos la hojarasca. Cinco personas parecen saber algo. Veamos si alguna es el hueso o si son todas cáscara.

**(Narrador/voz en off):** El voluntario profesional sale en cuatro ensayos distintos: alquila su brazo por dinero, no fabrica nada. El notario que valida los consentimientos, sencillamente, no existe: un colegiado inventado para estampar firmas.

**Nora:** La recepcionista fue una temporal que no duró ni un mes y no vio nada. El casero alquiló a una sociedad pantalla y no preguntó. El repartidor llevaba las cajas sin saber qué transportaba.

**Clara:** Capas de cebolla, Nora. Cada una puesta a propósito para que llores un poco y te rindas antes de llegar al centro. Ninguno es el promotor.

**Nora:** Cinco tapaderas. Pero toda cáscara protege un fruto. Las siglas del pie de página, N.P., ese es el hueso. Sigamos el papel, no a la gente.


### Localización B — l9b
_clave S3: "l9b"_

> **PISTA — El consentimiento falso:** Los formularios de consentimiento están firmados por un notario inexistente y un promotor con siglas: N.P.

**(Narrador/voz en off):** En una oficina alquilada del centro de negocios, Clara despliega sobre la mesa decenas de consentimientos y los cruza con el registro mercantil. Trabaja rápido, como quien desactiva una bomba.

**Clara:** Mira esto. Los mismos folios, la misma letra, el mismo sello. Todos los consentimientos los 'valida' el mismo notario. Y ese notario no consta en ningún colegio del país. Fraude en cadena, industrial, con plantilla.

**Nora:** Firmas de humo. ¿Y quién paga la fiesta? ¿Quién es el promotor?

**Clara:** Aquí, al pie, en letra de mosquito: 'Promotor: N.P.' Dos iniciales, nada más. Pero es un cabo de verdad, no una cáscara. Alguien registró estos papeles con esas siglas.

**Nora:** N.P. La clínica clausurada aún tiene cajas dentro. Si el promotor imprimió su nombre en algún sitio, fue en la mercancía. Vamos allí con esto.


### Final del caso — fin9
_clave S3: "fin9"_

> **PISTA — N.P. = Nyxos Pharma:** En la clínica clausurada, cajas con el nombre completo del promotor: Nyxos Pharma.

**(Narrador/voz en off):** La clínica clausurada es un esqueleto de baldosas y polvo. Vaciaron a toda prisa, pero la prisa deja restos: en un cuarto trasero, media docena de cajas de material precintadas que no dio tiempo a llevarse.

**Nora:** N.P. en los papeles. A ver si aquí, en la caja, se atrevieron a escribirlo entero.

**(Narrador/voz en off):** Rasgas el precinto. En el cartón, impreso en serie, sin abreviar: el logotipo de la serpiente enroscada en la copa. Y debajo, un nombre completo. NYXOS PHARMA.

**Nora:** Nyxos Pharma. Por fin la serpiente tiene apellido. Ya no persigo a un encapuchado, ni a un mecenas, ni a un médico asustado: persigo a una empresa entera, con nombre, con logo y con nóminas.

- *(Opción del jugador)* **Sentir el peso de lo que empieza**
**Nora:** (Llevo meses tirando de un hilo en la oscuridad y resulta que el hilo salía de un rascacielos con el logo iluminado. Qué pequeña me siento de repente.)

**Clara:** Ese silencio tuyo lo conozco. Es el de antes de una guerra. Y esta la vas a empezar contra Nyxos.

- *(Opción del jugador)* **Ir a por ellos sin dudar**
**Nora:** Grande o no, tiene un nombre. Y un nombre se lleva a un juez. Voy a por ellos.

**Clara:** Nora, escúchame. Nyxos cotiza en bolsa. Tiene más abogados que el Estado y amigos en sitios que ni imaginas. Esto no es un caso. Es una guerra.

**Nora:** Pues que sea guerra. Pero limpia, blindada y con papeles. Contigo delante y yo detrás rompiendo puertas solo cuando tú me digas.


### Cierre — cierre9
_clave S3: "cierre9"_

**(Narrador/voz en off):** En la comisaría, el nombre 'Nyxos' cae sobre la mesa como una piedra en un estanque. Núñez deja el café a medias.

**Sgto. Núñez:** ¿Nyxos? ¿La de los anuncios en los autobuses, la de las becas para chavales, la que patrocina el ala nueva del hospital? Detective Vega, en el consejo de esa empresa se sienta medio poder de esta ciudad.

**Nora:** Y aun así. Fabrican Somnia, promueven ensayos ilegales y se surten de las desaparecidas de nuestros propios archivos. El tamaño no cambia lo que son.

**Clara:** Pero cambia cómo hay que cazarlos. A una empresa no la esposas: la desmontas. Sociedad por sociedad, contrato por contrato, hasta llegar a quien firma de verdad. El siguiente paso son sus laboratorios.

**Nora:** Entonces a por los laboratorios. Quiero ver dónde fabrican la serpiente.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 9 —  La sombra tiene por fin nombre en un logo: Nyxos Pharma. Y es gigante. Nora acaba de declararle la guerra a media ciudad.



## Capítulo 10 · El laboratorio

### Briefing (comisaría) — brief10
_clave S3: "brief10"_

**(Narrador/voz en off):** Sobre el mapa de la ciudad, Núñez clava una chincheta en el polígono nuevo, la zona de cristal y hormigón donde el dinero se pone corbata. El laboratorio central de Nyxos brilla ahí como un diente de oro.

**Sgto. Núñez:** Ahí lo tiene. Laboratorio central de Nyxos. Legal hasta la última baldosa, con visitas guiadas y folletos. Pero un edificio que enseña tanto suele esconder un piso que no enseña.

**Nora:** Los ensayos no se hacen solos. En algún sitio fabrican el Somnia y en algún sitio guardan a los que lo prueban. Voy a colarme con una inspección de rutina y a mirar debajo de las batas blancas.

**Clara:** Inspección administrativa, Nora, no allanamiento. Tú miras lo que te enseñan y lo que quede a la vista. Nada de forzar. Si ven que buscas el sótano, te sacan y avisan a los de arriba.

**Nora:** Miro lo que quede a la vista. Y confío en que dejen a la vista más de lo que creen.


### Localización A — l10a
_clave S3: "l10a"_

> **PISTA — La marca Nyxos:** El Somnia se fabrica en serie en el laboratorio; lotes numerados como 'producto'.

**(Narrador/voz en off):** El laboratorio de Nyxos es un templo de acero y luz blanca sin sombras. Batas, guantes, suelos que rechinan de limpios. Con la excusa de la inspección, una relaciones públicas de sonrisa perfecta te pasea por las plantas 'de visita'.

**Nora:** Producción en serie. Cintas, dosificadores, control de calidad, cámaras frigoríficas. Fabrican pastillas con la misma frialdad con que otros embotellan refrescos.

**(Narrador/voz en off):** En una cinta, cajas idénticas desfilan bajo un escáner. En cada una, la serpiente en la copa y un código: SOM-, seguido de un número de lote larguísimo.

**Nora:** Somnia. Etiquetado, numerado, trazado. Un fármaco que oficialmente no existe, fabricado a escala industrial. Nadie monta esta maquinaria para regalar pastillas a insomnes por bondad.

**Nora:** (Todo impecable, todo con papeles. El horror aquí no grita: susurra en letra de etiqueta. Y para leer el susurro tengo que bajar a donde no me llevan.)


### Descartes / pistas falsas — rh10
_clave S3: "rh10"_

**(Narrador/voz en off):** En la nave de producción, cinco trabajadores se ponen nerviosos al ver la placa. Nora los aparta uno a uno, entre el ruido de las máquinas.

**Nora:** Cuando la gente tiene algo que esconder, se le nota. Vamos a ver qué esconden estos cinco.

**(Narrador/voz en off):** El jefe de planta grita órdenes y aprieta tuercas: cumple la orden de producción y no pregunta qué produce. El de mantenimiento tiene llaves de todo y no lee una sola etiqueta. La becaria de calidad firma controles sin mirar, muerta de miedo a que la echen.

**Nora:** El transportista cree que lleva 'muestras médicas' a otras sedes. Y el sindicalista, que berrea contra la empresa, lo hace por las horas extra, no por lo que se fabrica.

**Nora:** Cinco personas, cinco ejecutores. Todos mueven la máquina; ninguno la diseñó. Piezas que no saben qué construyen. El mando no está en la planta.

**Nora:** El mando está arriba, en los despachos con vistas. Pero para subir necesito una puerta que alguien de dentro me deje entornada. Y creo que sé quién.


### Localización B — l10b
_clave S3: "l10b"_

> **PISTA — El lote humano:** Marco, seguridad de Nyxos, deja ver sin querer un registro: los 'lotes de prueba' llevan números de persona.

**(Narrador/voz en off):** En el control de seguridad, tras una pared de monitores, hay una cara que no esperabas: Marco. De tu misma promoción en la academia. Colgó la placa hace años por un sueldo que la placa no daba.

**Marco:** ¿Nora Vega? No me jodas. La última persona que esperaba ver con un carnet de visitante colgado del cuello. Sabes que no debería dejarte pasar de este mostrador, ¿verdad?

**Nora:** Y tú sabes qué se prueba en la casa que vigilas, ¿verdad, Marco? Ahí, en tu pantalla. Los 'lotes de prueba'. Esos números no empiezan por SOM como las cajas. Empiezan por PX. Paciente. Persona.

**(Narrador/voz en off):** Marco tapa la pantalla con el cuerpo, demasiado tarde. En su cara se pelean el uniforme y algo más viejo: el chaval que juró servir y proteger contigo.

**Marco:** Yo solo vigilo puertas, Nora. No miro lo que hay detrás de ellas. Es la única forma de cobrar a fin de mes y seguir durmiendo. No me pidas que mire, porque entonces ya no puedo cerrar los ojos.

- *(Opción del jugador)* **Apretarle la conciencia**
**Nora:** ¿Dormir? Marco, hay gente ahí abajo con un número en la muñeca que no va a volver a dormir en su vida. Tú y yo hicimos el mismo juramento el mismo día.

**Marco:** No es justo que uses eso.

**Nora:** Nada de esto es justo. Por eso estoy aquí.

- *(Opción del jugador)* **Darle tiempo, no forzarlo**
**Nora:** No te pido que hagas nada hoy. Solo que sepas que, cuando ya no puedas cerrar los ojos, sabes dónde encontrarme.

**Marco:** ...Vete, Nora. Por la salida de carga. Y no vuelvas por delante.

**Nora:** (Marco sabe. Y le pesa como una losa. Ese peso, algún día, lo pondrá de mi lado. Hoy solo me ha dejado una puerta entornada.)


### Final del caso — fin10
_clave S3: "fin10"_

> **PISTA — Cobayas con número:** En la planta baja, celdas-laboratorio: personas reducidas a números de lote de Nyxos.

**(Narrador/voz en off):** La puerta que Marco dejó entornada da a un montacargas de carga sin botones a la vista. Bajas más de lo que cabría esperar. Cuando se abre, el aire cambia: huele a desinfectante y a miedo. Una planta que no aparece en ningún plano.

**(Narrador/voz en off):** Filas de habitáculos de cristal, como peceras. Dentro, personas. Batas de papel, pulseras con un número, ojos que hace tiempo dejaron de esperar a nadie.

**Nora:** Personas. Vivas. Etiquetadas como mercancía de laboratorio, guardadas en estantes como reactivos.

**Nora:** Nyxos no compra cobayas en el mercado negro. Es peor. Fabrica humanos-cobaya: los recoge de la calle, los borra del mundo y los archiva con un número de lote hasta que fallan.

- *(Opción del jugador)* **Grabarlo todo, rostro a rostro**
**(Narrador/voz en off):** Sacas el teléfono y grabas despacio: los números, los rostros, el logo en cada puerta. Alguna mano se pega al cristal al verte, sin fuerza para golpear.

**Nora:** Voy a sacaros de aquí. A todos. Lo juro sobre esta grabación.

- *(Opción del jugador)* **Buscar una lista de nombres reales**
**(Narrador/voz en off):** En un puesto de enfermería encuentras una tablet abierta: una tabla que cruza cada número PX con un nombre real. Los reconoces. Son los desaparecidos de tus propios archivos.

**Nora:** Tienen nombres. Todos tienen nombres. Y yo los tengo ahora en la mano.

**(Narrador/voz en off):** Una alarma silenciosa parpadea. En un monitor del pasillo, Marco ve tu punto rojo moverse por donde no debe. Cierra los ojos un segundo, y en vez de dar la voz, congela la cámara de la salida de carga tres minutos. Los justos.

**Nora:** Tengo vídeo de una planta de experimentación humana con el logo de Nyxos en cada puerta. Esto ya no lo entierra ningún abogado ni ningún cheque.


### Cierre — cierre10
_clave S3: "cierre10"_

**(Narrador/voz en off):** En la sala a oscuras, el vídeo se reproduce en bucle sobre la pared. Nadie dice nada durante un minuto largo. Núñez es el que rompe el silencio, con la voz ronca.

**Nora:** Nyxos tiene un piso que no está en ningún plano, lleno de personas con número de lote. Y una seguridad tan fina que solo un fallo humano me dejó bajar. Esto está protegido, Núñez. Blindado desde muy arriba.

**Sgto. Núñez:** Protección política, detective Vega. Para operar así durante años hace falta que mucha gente con despacho mire a otro lado a cambio de algo. Permisos que se firman, inspecciones que no se hacen, denuncias que se pierden.

**Clara:** Y eso, por asqueroso que sea, deja rastro: presupuestos, donaciones, favores. El siguiente paso no es una nave. Es un barrio de despachos caros. Hay que averiguar quién les cubre las espaldas desde el poder.

**Nora:** Entonces subo. De la planta de las peceras a los despachos con vistas. Quiero los nombres de los que firman para no mirar.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 10 —  El laboratorio confirma el horror con rostro y número. Ahora Nora deja el subsuelo y sube a buscar a quienes lo protegen desde los despachos.



## Capítulo 11 · El barrio alto

### Briefing (comisaría) — brief11
_clave S3: "brief11"_

**(Narrador/voz en off):** La comisaría amanece con olor a café quemado y a papel viejo. Sobre la pizarra, Núñez ha pegado un plano de la ciudad y ha dibujado flechas de tinta roja que salen del laboratorio de Nyxos y suben, todas, hacia el mismo rincón: la loma de las villas, el barrio alto, donde la lluvia parece caer más fina.

**Sgto. Núñez:** Nyxos riega de dinero a media ciudad: becas, obras, campañas. Empiece por el barrio alto, donde viven los que firman sus permisos. Ahí no encontrará celdas ni viales, detective Vega. Encontrará algo peor: gente respetable que sonríe mientras firma.

**Nora:** El dinero limpio siempre huele a algo. Al barrio alto. Llevo toda la vida entrando en sótanos; ahora me toca subir a los salones, donde el crimen se sirve con canapés y no deja una sola mancha en la moqueta.

**Sgto. Núñez:** Y por eso mismo tenga cuidado. En el barro de abajo, si mete la mano, se ensucia usted. En el de arriba, si mete la mano, la ensucian a usted. Cambian las pruebas por rumores y a los testigos por columnas de opinión.

- *(Opción del jugador)* **«Voy de frente. Que sepan que los miro.»**
**Nora:** No pienso disimular, Núñez. Que me vean subir la cuesta con la placa por delante. Que se pongan nerviosos. La gente tranquila no comete errores; la gente asustada, sí.

**Sgto. Núñez:** Es una forma. Peligrosa, pero suya de cabo a rabo. Solo le pido que apunte cada nombre y cada fecha. Contra esta gente, un cuaderno bien llevado vale más que una pistola.

- *(Opción del jugador)* **«Voy despacio. Primero miro quién cobra.»**
**Nora:** Esta vez no rompo la puerta. La rodeo. Quiero saber quién cena con quién y quién paga la cuenta antes de llamar a ningún timbre.

**Sgto. Núñez:** Así me gusta. Paciencia de pescador. Y si necesita a alguien que conozca ese barrio desde antes de que fuera caro, ya sabe a quién llamar. El viejo Rubén todavía respira.

**Nora:** (Núñez tiene razón. Nunca resolví nada sola, y menos voy a resolverlo sola allá arriba, entre gente que aprendió a mentir en colegios que yo no pude pagar. Necesito a alguien que hable su idioma.)


### Localización A — l11a
_clave S3: "l11a"_

> **PISTA — Los sobornos:** Nyxos financia a través de una fundación las campañas de varios cargos que aprueban sus permisos.

**(Narrador/voz en off):** El barrio alto son villas con verja, setos recortados con regla y coches que valen pisos. Aquí la lluvia no ensucia: resbala por los cristales tintados y se va por desagües que nadie ve. Huele a césped mojado y a dinero que nunca ha tocado una cartera. Aquí Nyxos no secuestra a nadie: aquí invita a cenar.

**Nora:** La 'Fundación Nyxos' financia campañas, palcos en el estadio, viajes de estudios, un ala de la biblioteca. Todo con placa de bronce y foto en el periódico. Y casualmente los que cobran son los mismos que firman sus licencias de ensayo.

**(Narrador/voz en off):** Frente a una de las villas, un jardinero riega rosas que ya reluce la lluvia. En la verja, discreta, una placa: 'Rehabilitado con el mecenazgo de la Fundación Nyxos'. Cuentas la misma placa en tres portales de la misma calle.

**Nora:** Soborno con lazo de regalo. Nadie mete un fajo en un sobre; montan una fundación, la registran, pagan impuestos y llaman filantropía a lo que abajo llamaríamos comprar a un funcionario. Legal por fuera, podrido por dentro.

**Nora:** (He visto sobornos de barrio: un sobre grasiento bajo el mostrador de un bar. Esto es lo mismo, pero con abogados, notarios y una foto sonriente en la sección de sociedad. El asco es idéntico; el traje, mejor.)

**Nora:** Necesito a alguien que conozca este barro desde hace décadas. Alguien que sepa qué mano firmó la planta de Nyxos y a cambio de qué. Y solo se me ocurre un nombre.


### Descartes / pistas falsas — rh11
_clave S3: "rh11"_

**(Narrador/voz en off):** El barrio alto está lleno de sospechosos de guante blanco. Ninguno tiene sangre en las manos; todos tienen tinta. Nora los va cruzando con Rubén, que conoce a cada uno por su nombre de pila, su apodo y su precio exacto.

**Nora:** Cinco nombres que rodean a Nyxos y huelen mal. Vamos a ver cuál aguanta un empujón y cuál es solo humo perfumado.

**Insp. Rubén:** El concejal rival hace ruido en los periódicos, pero es puro teatro: ataca a Nyxos para robarle votos, y no tiene ni un papel. El constructor levantó la sede, cobró su millonada y calló; ni sabe ni quiere saber qué pasa dentro de lo que edifica.

**Insp. Rubén:** La asociación vecinal protesta por el polvo y las grúas a las siete de la mañana, no por lo que se cuece en el sótano. El del catastro aceleró un registro por un sobre de nada: corrupción de calderilla. Y el plumilla ese escribe alabanzas a Nyxos por dinero, pero es un vanidoso, no un cerebro.

**Nora:** Cinco corrupciones pequeñas, puestas ahí como setos para que no veas la casa que hay detrás. Ninguno firmó la planta. Ninguno decide nada.

**Nora:** El pez gordo es el que firmó la planta en tiempo récord: el concejal Vela, el de Urbanismo. El resto son ramas; él es el tronco. A por el tronco.


### Localización B — l11b
_clave S3: "l11b"_

> **PISTA — El concejal comprado:** Rubén, tu viejo mentor, señala al concejal de Urbanismo que aprobó en tiempo récord la planta de Nyxos.

**(Narrador/voz en off):** El café de Rubén es de los que ya casi no quedan: barra de zinc, un futbolín viejo, la cafetera echando vapor como una locomotora cansada. Huele a achicoria y a tabaco de otra época. El inspector Rubén, el hombre que te enseñó el oficio, está jubilado, pero conserva el olfato intacto y media agenda de la ciudad guardada en la cabeza.

**Insp. Rubén:** Nora, chiquilla. Cuánto pelo blanco te veo ya, igual que a mí. Siéntate, que las malas noticias se dan sentado. Sé lo que buscas antes de que abras la boca: se te nota en los ojos, como se me notaba a mí.

**Nora:** Necesito el nombre, Rubén. El que le abrió la puerta a Nyxos. El que convirtió dos años de expediente en un mes de trámite.

**Insp. Rubén:** El que le firmó a Nyxos la planta en cuatro semanas, cuando lo normal son dos años de informes, es Vela, el de Urbanismo. Firmó como quien firma la lista de la compra. Y a la semana siguiente, la Fundación Nyxos le pagaba la campaña. Casualidades que se cobran en euros.

**Nora:** ¿Y por qué no salió nunca? ¿Cómo aguanta un tipo así tantos años a la vista de todos?

**(Narrador/voz en off):** Rubén remueve el café despacio, sin mirarte, con la cucharilla tintineando contra la loza. Cuando levanta la vista, hay en ella algo que no le habías visto: no miedo, cansancio de haber tenido miedo demasiado tiempo.

**Insp. Rubén:** Porque cada vez que alguien lo intentó, lo trasladaron a un archivo, lo mandaron a un pueblo o lo jubilaron. A mí me jubilaron, Nora. No fue por la edad. Fue por preguntar por Vela una vez de más. Un día me llegó la carta de agradecimiento por mis servicios y se acabó.

- *(Opción del jugador)* **«No debiste callarte. Yo no voy a callarme.»**
**Nora:** Debiste seguir, Rubén. Aunque doliera. Yo no pienso guardarme este nombre en un cajón como te lo guardaste tú.

**Insp. Rubén:** Lo sé. Y por eso te lo doy a ti y no me lo llevo a la tumba. Yo tenía una hipoteca y una hija en la universidad, chiquilla. Tú tienes otra clase de deudas, de las que no se pagan callando. Adelante. Pero ándate con más ojo que yo.

- *(Opción del jugador)* **«No te culpo. Tenías una familia que proteger.»**
**Nora:** No te reprocho nada, Rubén. Tenías una hija, una casa, una vida. Cualquiera habría hecho lo mismo. Casi cualquiera.

**Insp. Rubén:** Eres buena chica, siempre lo fuiste. Pero no me consueles: los dos sabemos que callar tiene un precio, y lo llevo pagando veinte años. Págalo tú de otra manera. Ve a por Vela. Y no vayas sola a ningún sitio, ¿me oyes?

**Insp. Rubén:** Una cosa más, y grábatela. Vela es un cobarde. Y los cobardes, cuando los acorralas, no pelean: señalan a otro para salvar el pellejo. Cuando lo aprietes, no te contará lo que hizo él. Te dirá quién está por encima.


### Final del caso — fin11
_clave S3: "fin11"_

> **PISTA — La red de favores:** Vela confiesa a medias: Nyxos 'agradece' con dinero y con silencio a quien le facilita las cosas.

**(Narrador/voz en off):** El despacho del concejal Vela huele a ambientador caro y a sudor mal disimulado. Ventanales del centro, diplomas enmarcados, una foto suya estrechando la mano de gente importante. Acorralas a Vela contra su propia mesa, con los papeles de la Fundación Nyxos desplegados encima como una mano de cartas marcadas.

**Sospechoso:** Detective, esto es un atropello. Yo... agilicé un expediente, nada más. Todos lo hacen. Nyxos es un motor económico para esta ciudad, da empleo, paga impuestos, patrocina. Darles alas es bueno para todos. ¿Qué crimen hay en firmar rápido lo que es bueno?

**Nora:** Firmó en cuatro semanas lo que a cualquier otro le cuesta dos años. Y a la semana la Fundación le pagaba la campaña. ¿También eso lo hacen todos, señor Vela?

**Sospechoso:** La Fundación apoya muchas causas. Mi campaña era una causa. No hay nada escrito que diga 'firme esto y le pago'. Nunca lo hay. Así no funciona esto, detective. Aquí nadie pide nada; simplemente, se agradece.

**Nora:** Sus 'alas' tienen un sótano lleno de gente numerada como mercancía. Personas que respiran detrás de un cristal con una pulsera y un número de lote. ¿Sabía eso cuando cobró la campaña?

**(Narrador/voz en off):** Vela se afloja el nudo de la corbata. Por un segundo, bajo el bronceado de despacho, asoma el hombre pequeño que hay debajo del cargo. Mira la puerta, mira el teléfono, mira sus propias manos.

**Sospechoso:** Yo no sé nada de sótanos. Se lo juro por mis hijos. Yo firmo papeles, detective, no bajo a ninguna parte. Si hay algo abajo, yo no lo puse ahí. Yo solo... facilité. Como me pidieron. Como se lo pidieron a otros antes que a mí.

**Nora:** ¿Quién se lo pidió, Vela? Un nombre. Uno solo y salgo de aquí.

**Sospechoso:** No hay un nombre. ¿No lo entiende? Nunca hay uno. Le llega un correo, una llamada, una cena. Le dicen que sería 'conveniente'. Y usted firma, porque el que no firma desaparece del organigrama. Yo soy un mandado, como todos. Si quiere sótanos, pregunte arriba. Pregunte en el consejo de Nyxos.

- *(Opción del jugador)* **Apretarle con lo que ha visto abajo**
**Nora:** Le voy a decir lo que hay 'arriba', Vela: hay una mujer que se sabe de memoria el número que le pintaron en la muñeca. Eso hay arriba de su firma. Duerma con eso esta noche, si puede.

**Sospechoso:** No es justo que me cargue eso a mí. Yo no elegí a nadie. Yo solo... firmé un papel entre mil papeles.

**Nora:** Ese papel entre mil era el que abría la puerta. Sin su firma no hay planta, sin planta no hay sótano. Usted es la bisagra, Vela. Y las bisagras también se llevan por delante.

- *(Opción del jugador)* **Dejarle una salida a cambio del consejo**
**Nora:** Escúcheme bien. Si me da el hilo hacia el consejo, hay una manera de que usted salga de esto como testigo y no como acusado. Es la única puerta que le queda abierta, y se cierra rápido.

**Sospechoso:** ¿Testigo? ¿Contra Nyxos? Usted no sabe lo que me está pidiendo. A los que hablan les pasan cosas, detective. Accidentes. Jubilaciones. O peor.

**Nora:** Lo sé mejor que usted. Pero también sé que el silencio no lo ha salvado a nadie de esta lista. Piénselo. Sabe dónde encontrarme antes de que lo encuentren a usted.

**Nora:** 'Pregunte arriba.' Es lo que dicen todos justo antes de que el hilo suba un piso más. La red institucional existe, tiene nombres, cobra por firmar y calla por dinero. Y protege a Nyxos entera desde una altura donde mi placa ya casi no se ve.


### Cierre — cierre11
_clave S3: "cierre11"_

**(Narrador/voz en off):** De vuelta en la comisaría, la lluvia ha arreciado y golpea los cristales como si quisiera entrar. Nora deja los papeles de la Fundación sobre la mesa de Núñez, que los repasa uno a uno, en silencio, con las gafas en la punta de la nariz.

**Nora:** Nyxos compra permisos, campañas y silencios. Está enredada con media institución, Núñez. Vela firmó, cobró y ahora señala hacia arriba, como Marco, como todos. Cada uno es una pieza que jura que la culpa es de la de al lado.

**Sgto. Núñez:** Así se blinda el poder, detective Vega: repartiendo la culpa en trozos tan pequeños que ninguno cabe en una condena. Contra eso no vale un concejal asustado ni un montón de facturas de fundación. Un juez le dirá que todo es legal.

**Nora:** Entonces dígame qué vale. Porque estoy subiendo escaleras y en cada rellano hay una puerta cerrada con un abogado detrás.

**Sgto. Núñez:** Entonces necesitamos algo que ni el dinero calle: un testigo de dentro. Alguien que se siente en esa mesa, que conozca los nombres de verdad, y que esté dispuesto a hablar. Y justo esta mañana, detective Vega, alguien de Nyxos ha llamado pidiendo hablar. Antes de que se arrepienta, vaya.

**Nora:** Alguien de dentro. Por fin una grieta en el cristal. Voy antes de que el miedo se la vuelva a cerrar.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 11 —  Nyxos tiene comprada a la ciudad, firma a firma, cena a cena. Pero dentro del muro, por primera vez, alguien ha decidido hablar.



## Capítulo 12 · La filtración

### Briefing (comisaría) — brief12
_clave S3: "brief12"_

**(Narrador/voz en off):** La comisaría a esa hora es un acuario de luz muerta. Núñez cuelga el teléfono despacio, como si pesara, y se queda mirando el auricular antes de girarse hacia Nora.

**Sgto. Núñez:** El que quiere hablar es de dentro de Nyxos. No un becario ni un vigilante: un mando con despacho y con miedo. Ha llamado a la periodista, a Vera Lang, no a nosotros. Se fía más de una libreta que de una placa, y lo entiendo.

**Nora:** Un directivo arrepentido. Después de meses arañando cáscara, alguien de dentro abre la puerta él solo. Suena demasiado bien, Núñez.

**Sgto. Núñez:** Por eso vaya rápido y vaya con cuidado. Esta gente no da segundas oportunidades: al que se arrepiente lo jubilan de forma definitiva. Si el hombre ha decidido hablar, ya está muerto de miedo, y con razón.

- *(Opción del jugador)* **«Voy a protegerlo antes que al caso.»**
**Nora:** Lo primero es sacarlo entero, Núñez. El protocolo puede esperar; un testigo vivo, no. Si tengo que elegir entre el papel y el hombre, elijo al hombre.

**Sgto. Núñez:** Esa es la detective Vega que quiero de vuelta. Pero llévese el móvil cargado y no se meta sola en ningún sótano. Me llama antes, no después.

- *(Opción del jugador)* **«Necesito ese protocolo como sea.»**
**Nora:** Con el protocolo entero les corto la cabeza a todos de una vez. No pienso dejar que se me escurra por exceso de prudencia.

**Sgto. Núñez:** Le entiendo el hambre. Pero un documento no vale un cadáver, detective Vega. Consiga las dos cosas: el papel y el hombre respirando. Las dos.

**Nora:** (Un mando intermedio. De los que firman sin mirar hasta que una noche, por fin, miran. Ojalá llegue yo antes que quien lo esté buscando.)


### Localización A — l12a
_clave S3: "l12a"_

> **PISTA — El informante:** Un directivo intermedio de Nyxos, arrepentido, promete entregar el 'protocolo Somnia' completo.

**(Narrador/voz en off):** La redacción a medianoche es un campo de pantallas apagadas y ceniceros a escondidas. Vera Lang te espera en un cubículo del fondo, dos cafés fríos y las manos que no paran quietas. En su móvil, una grabación en bucle: una voz de hombre, distorsionada, que respira como si le costara.

**Vera Lang:** Escúchalo, Nora. No es un chalado ni un resentido. Es alguien acostumbrado a mandar que de repente tiene pánico. Dice que es un mando intermedio, que ha visto lo que hay debajo de los informes bonitos y que no puede dormir.

**Nora:** ¿Y qué ofrece exactamente? Palabras las tiene cualquiera.

**Vera Lang:** El 'protocolo Somnia' entero. Qué hacen, a quién se lo hacen, qué dosis, qué pasa con los que ya no sirven. Y lo que más me quema: quién lo ordena. Nombres, no siglas. La cabeza, Nora, no la mano.

**Nora:** Eso es el caso servido en bandeja de plata. Demasiada bandeja, quizá. ¿Cuándo y dónde entrega?

**Vera Lang:** Mañana, en el aparcamiento de las oficinas. Eligió él el sitio: subterráneo, sin cámaras que él no controle, dice. Tiene miedo hasta de su sombra. Me repitió una frase que no me quito de encima: que si lo pillan, no habrá cadáver que encontrar. Como las otras.

**Nora:** (No habrá cadáver. Lo dice un hombre que sabe cómo desaparece la gente en su empresa, porque habrá firmado alguna de esas desapariciones. Y aun así ha decidido hablar. O eso, o está más asustado de vivir consigo mismo que de morir.)

**Nora:** Mañana estaré en ese aparcamiento antes que él. Y salimos los dos, Vera. Con el protocolo o sin él, pero los dos.


### Descartes / pistas falsas — rh12
_clave S3: "rh12"_

**(Narrador/voz en off):** En cuanto se huele una filtración, salen las moscas. Antes de llegar al informante de verdad, cinco voces se ofrecen a Vera y a Nora, cada una con su gran secreto que vender. Un cuartucho de archivo, café de máquina y humo de gente que quiere su minuto de gloria.

**Vera Lang:** Un becario al que echaron y ahora presume de haberlos hundido; solo se llevó el finiquito y el rencor. Una limpiadora que ve papeles cada noche pero solo sabe vaciar papeleras, no leerlas. Un hacker de foro con 'los servidores de Nyxos', que son capturas trucadas para presumir.

**Nora:** Y los dos de siempre: un competidor que suelta bulos para hundir a Nyxos en bolsa, y un vigilante nocturno que oyó 'cosas raras' que resultaron ser la caldera. Cinco tenores y ni una nota afinada.

**Vera Lang:** Todos quieren cámara, Nora. Ninguno tiene el documento. Ninguno tiembla de verdad.

**Nora:** Ese es el filtro. El bueno no presume ni cobra: tiene pánico y tiene un despacho dentro. Al que hay que llegar es al único que no quiere salir en ninguna foto.


### Localización B — l12b
_clave S3: "l12b"_

> **PISTA — El memorándum interno:** El informante alcanza a pasar una hoja: un memo que ordena 'depurar sujetos no viables'. Firmado por la dirección.

**(Narrador/voz en off):** El aparcamiento subterráneo de Nyxos es un bosque de columnas de hormigón y tubos fluorescentes que parpadean. Huele a goma quemada y a frío de sótano. Tus pasos rebotan y vuelven, y no sabes si el eco es tuyo o de alguien más.

**(Narrador/voz en off):** El informante aparece entre dos coches, pálido, el traje caro arrugado como si hubiera dormido con él puesto. Trae un sobre pegado al pecho y los ojos por todas partes menos en los tuyos.

**Nora:** Tranquilo. Soy yo, la que esperaba. Deme lo que tiene y le saco de aquí ahora mismo, sin ruido. Tengo el coche a treinta metros.

- *(Opción del jugador)* **Sacarlo primero, coger el sobre después**
**Nora:** El papel luego. Primero usted. Camine a mi lado, despacio, como si no pasara nada.

**(Narrador/voz en off):** Da un paso hacia ti y, en ese medio segundo, te alarga el sobre casi sin querer, como quien suelta lastre. Sus dedos están helados.

- *(Opción del jugador)* **Coger la prueba ya, por si acaso**
**Nora:** (Si algo sale mal en los próximos segundos, que al menos no salga mal para nada.) Deme el sobre. Ahora. Luego corremos los dos.

**(Narrador/voz en off):** Te pone el sobre en la mano con una urgencia que da miedo, como si supiera que no va a haber un segundo intento.

**(Narrador/voz en off):** Dentro, una sola hoja. Un memorándum interno, membrete de Nyxos, lenguaje de oficina: ordena 'depurar a los sujetos no viables del proyecto Somnia'. Depurar. Como quien limpia un archivo. Personas.

**Nora:** 'Sujetos no viables.' Lo escribieron así, con esa asepsia, para no tener que leer nunca la palabra personas. Esto no lo firma un loco: lo firma un comité en una reunión con café y galletas.

**(Narrador/voz en off):** Un chirrido de neumáticos rompe el silencio del sótano. Faros largos, de golpe, que te ciegan. El informante reacciona antes que tú: te empuja detrás de una columna con las dos manos, un instante antes del disparo. Seco. Único. De profesional.

**(Narrador/voz en off):** El coche ya no está cuando bajas la vista. Él sí. En el suelo, junto a la columna que te salvó, sin respirar. La hoja sigue en tu mano, arrugada por el empujón que te dejó viva.

**Nora:** (Me ha apartado. Con las últimas fuerzas que le quedaban, me ha apartado a mí. Un hombre al que no conocía de nada.)

**Nora:** Lo han ejecutado por una hoja de papel. Pero la hoja la tengo yo. Y dice 'depurar', firmado por la dirección de Nyxos. No te has muerto para nada. Te lo juro.


### Final del caso — fin12
_clave S3: "fin12"_

> **PISTA — Matan para tapar:** El asesinato del informante confirma que la dirección de Nyxos mata para proteger el proyecto.

**(Narrador/voz en off):** Con la matrícula grabada en la retina, Nora rastrea el coche del sicario hasta un garaje anodino a nombre de una sociedad de Nyxos. Cuando llega, está vacío y apesta a lejía: alguien lo fregó de arriba abajo con la calma de quien ha hecho esto muchas veces.

**Nora:** Limpio. Demasiado limpio. Pero la prisa siempre se deja algo detrás.

**(Narrador/voz en off):** En una cámara del techo que olvidaron desconectar, la imagen: el coche, la matrícula entera y el conductor bajando un segundo con la cara descubierta. En la solapa, un logo pequeño bordado. La serpiente enroscada en la copa.

**Nora:** Seguridad corporativa de Nyxos. No un matón de callejón: un empleado con nómina, con seguro médico, con vacaciones pagadas. Aprieta un gatillo y luego ficha la salida. Matan como quien archiva.

- *(Opción del jugador)* **Cargar con la culpa**
**Nora:** (Estaba vivo hace tres horas. Vino a hacer lo correcto por una vez en su vida y yo no supe sacarlo. Otro nombre para la lista de los que no salvé.)

**(Narrador/voz en off):** Te apoyas en el capó frío del coche vacío. Por un momento no eres detective: solo eres alguien que ha visto morir a un hombre a un brazo de distancia y no ha podido hacer nada.

- *(Opción del jugador)* **Convertir el luto en rabia**
**Nora:** No me voy a quedar llorando en un garaje con olor a lejía. Me apartó para que yo siguiera de pie. Pues sigo de pie, y con su papel en la mano.

**Nora:** Lo van a lamentar. No el hombre que apretó el gatillo: el despacho que escribió la orden.

**Nora:** Ya no es solo experimentar con gente. Es asesinar para tapar los experimentos, con su propia gente de seguridad. Y el memo dice que la orden nace arriba, en la dirección.

**Vera Lang:** Publico lo del memo, Nora. Con el rostro tapado del sicario y todo. Aunque me cueste el puesto y algo peor. Se lo debo al hombre del aparcamiento, que se fió de una libreta antes que de nadie.

**Nora:** Publícalo bien blindado, Vera. Que cuando salga, ya no puedan depurarte a ti también.


### Cierre — cierre12
_clave S3: "cierre12"_

**(Narrador/voz en off):** De vuelta en la comisaría, el memorándum descansa dentro de una funda de plástico sobre la mesa, como una cosa viva a la que hay que vigilar. Núñez lo lee tres veces sin tocar la funda. Fuera, la lluvia otra vez, insistente.

**Nora:** Tenemos un memo firmado por 'la dirección' y un cadáver en un aparcamiento para taparlo. Pero 'la dirección' sigue sin ser un nombre. Y sin un nombre, un juez me lo devuelve por la ventanilla.

**Sgto. Núñez:** Piénselo al revés, detective Vega. Los memos no nacen de la nada: nacen de expedientes. Alguien decide que un sujeto es 'no viable' leyendo su historial. Y esos historiales tienen que estar guardados en algún sitio, con nombre y apellido.

**Nora:** En un archivo médico. Del hospital que Nyxos patrocina con tanto cariño para las fotos y los recortes de prensa.

**Sgto. Núñez:** Ahí lo tiene. Los sujetos con cara, con nombre, con historia clínica. Deje de perseguir la firma un momento y vaya a por las víctimas: ellas le dirán quién decidió sobre sus vidas.

**Nora:** Nombres, no números. Se lo debo al hombre que me apartó de un balazo. Al archivo del hospital.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 12 —  Nyxos mata para callar. Y el siguiente hilo pasa por los expedientes de sus víctimas.



## Capítulo 13 · El expediente

### Briefing (comisaría) — brief13
_clave S3: "brief13"_

**(Narrador/voz en off):** Llueve otra vez sobre la comisaría, esa lluvia fina que no moja pero cala. Sobre la mesa de Nora, una lista de nombres impresa se va emborronando bajo el vaho del café. Diecinueve desaparecidos. Diecinueve números de lote que Nyxos anotó como quien apunta cajas en un almacén.

**Sgto. Núñez:** El hospital central guarda los historiales clínicos de todos esos 'sujetos'. Fechas de ingreso, tratamientos, altas que no fueron altas. Con eso, detective Vega, podemos ponerle cara y nombre a cada número de lote.

**Nora:** Nombres, Núñez. No números. Cada lote de esos era una persona que un día tuvo hambre, o insomnio, o miedo a morir sola. Nyxos los convirtió en un código de barras. Yo se lo pienso devolver del revés.

**Sgto. Núñez:** Al archivo médico, entonces. Pero vaya con tiento: un historial clínico está protegido. Necesita a alguien de dentro que le abra las carpetas sin que salte una alarma.

**Nora:** Sonia. Es forense, tiene llave del archivo y es la única persona en esta ciudad en la que confío a ciegas. Ella me cruza los datos.

- *(Opción del jugador)* **«Voy a mirarlo como policía. Con la cabeza fría.»**
**Nora:** Entro ahí como investigadora, no como nada más. Cruzo listas, ato lotes con nombres y salgo con un expediente que aguante en un juzgado. Sin sangre en los ojos.

**Sgto. Núñez:** Así me gusta oírla. La cabeza fría es lo único que esta gente no sabe comprar. Guárdela bien.

- *(Opción del jugador)* **«Tengo un mal presentimiento con esta lista.»**
**Nora:** Llevo toda la mañana con un peso en el pecho, Núñez. Como si supiera que en esa lista hay un nombre que no quiero leer. Y aun así tengo que leerla entera.

**Sgto. Núñez:** Los presentimientos de los buenos policías suelen ser memoria disfrazada de miedo. Si algo le tira del estómago, no lo aparte: sígalo. Pero llámeme si escuece.

**Nora:** (Diecinueve nombres. He aprendido a mirar listas de muertos sin que me tiemble el pulso. Ojalá esta sea una más. Ojalá.)


### Localización A — l13a
_clave S3: "l13a"_

> **PISTA — Los sujetos de prueba:** Los historiales cruzan a los desaparecidos con un mismo 'estudio patrocinado' de Nyxos.

**(Narrador/voz en off):** El archivo médico del sótano del hospital es un laberinto de estanterías metálicas y olor a papel viejo y a formol. La luz cae de tubos que parpadean. Sonia camina delante entre las carpetas como por su casa, con una linterna entre los dientes y una carpeta bajo el brazo.

**Sonia:** Bienvenida a la memoria de la ciudad, Nora. Aquí abajo está todo el mundo que ha pasado por una camilla en cuarenta años. Y aquí abajo, si sabes mirar, también están los que alguien quiso borrar.

**Nora:** Mi lista tiene diecinueve nombres. Necesito su historial. Ingresos, tratamientos, quién los firmaba y adónde fueron a parar.

**(Narrador/voz en off):** Sonia despliega las carpetas sobre una mesa de acero, una junto a otra, como quien tiende cartas de una baraja marcada. Va marcando renglones con un rotulador rojo. Poco a poco, un mismo dibujo empieza a repetirse en todas.

**Sonia:** Aquí, mira. Y aquí. Y aquí. Todos tus desaparecidos pasaron por lo mismo antes de esfumarse: un 'estudio patrocinado'. Mismo código de protocolo, misma firma de patrocinador en el pie. Nyxos. Los diecinueve.

**Nora:** Cada número de lote es una persona con historia clínica, Sonia. Nyxos los reclutaba enfermos, insomnes, solos, gente que firmaba por una cama caliente y una promesa. Los devolvía al estudio... y del estudio ya no volvían.

**Sonia:** Fíjate en las fechas. Ingreso, 'estudio', y a las pocas semanas el historial se corta en seco. Ni alta, ni defunción, ni traslado. Se corta. Como si les hubieran arrancado el resto de la vida de la carpeta.

**Nora:** (Una carpeta que se corta a media frase. He visto expedientes de guerra menos fríos que estos. Los ordenaron con letra bonita y márgenes rectos. El horror con buena caligrafía.)

**Sonia:** Y hay algo peor, Nora. Deja que termine de cruzar la última tanda de reclutados, la más reciente. Porque en esa... en esa hay un nombre que tú conoces. Y no sé cómo decírtelo.


### Descartes / pistas falsas — rh13
_clave S3: "rh13"_

**(Narrador/voz en off):** Un pasillo comunica el archivo con la morgue, y allí, entre camillas vacías y el zumbido de las neveras, Sonia y Nora reciben de uno en uno a los cinco empleados con acceso al archivo. Cinco caras nerviosas bajo la luz verde de los fluorescentes. Cinco sospechosos de manual.

**Sonia:** El instinto dice que el que toca los papeles es el que los pudre. Vamos a ver si el instinto acierta o si solo estamos asustando a cinco pobres diablos.

**Nora:** El celador del turno de noche suda como si lo fueran a fusilar. Pero no teme por los muertos: teme que lo pillen echando la siesta en un sillón del sótano. Miedo de vago, no de cómplice.

**(Narrador/voz en off):** Desfilan los demás. El informático digitalizó miles de historiales sin leer uno solo, escaneando por lotes con la mirada perdida. La auxiliar nueva confunde carpetas por pura torpeza de novata. El jefe de archivo firma todo sin mirar desde hace veinte años. El estudiante de prácticas fotografió un historial... para un trabajo de clase.

**Sonia:** Dormilón, informático, novata, vago, estudiante. Cero intención criminal, Nora. Los cinco pasan las manos por esos papeles sin entender lo que sostienen. El mal no está en quien toca los papeles: está en quien los mandó crear.

**Nora:** Exacto. Ninguno de estos cinco decidió nada. El código del proyecto no lo firma un celador que ronca ni una novata que se traba con el alfabético. Ese código lleva hacia arriba, muy arriba, al consejo. Ahí es donde muerdo.


### Localización B — l13b
_clave S3: "l13b"_

> **PISTA — Diego en la lista:** Diego ha recaído y aparece de nuevo reclutado por Nyxos: lo usan para presionar a Nora.

**(Narrador/voz en off):** El nombre que Sonia no se atrevía a leer era el peor de todos. Nora sube tres plantas con la carpeta apretada contra el pecho y empuja una puerta de una habitación individual. En la cama, bajo una manta demasiado blanca, con una vía en el brazo y el sueño químico dibujado en la cara, está Diego. Otra vez. Otra vez con Somnia en las venas.

**Nora:** (Se me para el mundo en el umbral de esa puerta. Toda la ciudad, todo el caso, los diecinueve nombres... y de golpe solo veo a mi hermano pequeño respirando despacio en una cama que no eligió.)

**Diego Vega:** ¿Nora...? No llores, anda, que se te pone cara de cuando éramos críos. Lo siento. Lo siento muchísimo. Vinieron ellos. Yo había recaído, estaba fatal, y aparecieron con batas y con papeles.

**Nora:** Diego, mírame. ¿Quiénes vinieron? ¿Qué te ofrecieron esta vez?

**Diego Vega:** Dijeron que si volvía al 'programa' me curaban gratis, con lo mejor que tienen. Y luego, muy amables, muy suaves, soltaron lo otro: que a ti te convenía que yo colaborase. Que una hermana tranquila trabaja mejor.

**Nora:** ¿Te han usado para llegar a mí? ¿Nyxos te ha vuelto a meter en la máquina solo para tenerme cogida por donde más duele?

**Diego Vega:** Creo que sí, hermana. Me dieron un mensaje para ti, palabra por palabra, para que no se me olvidara: 'que la detective piense en su familia'. Me hicieron de cartero de mi propia condena. Perdóname. Otra vez soy tu punto débil.

- *(Opción del jugador)* **Abrazarlo y prometerle que esta vez no falla**
**(Narrador/voz en off):** Nora deja la carpeta en la silla y se sienta en el borde de la cama. Le aparta el pelo sudado de la frente, igual que hacía su madre, igual que hizo ella la primera vez que lo sacó de un mal sitio. Diego se agarra a su manga.

**Nora:** No eres mi punto débil, Diego. Escúchame bien esto: eres la razón por la que voy a tirarles la torre encima. Te van a soltar, te van a limpiar la sangre de esa porquería, y ellos van a caer. Esta vez no fallo.

**Diego Vega:** Te creo. Siempre te creo, hermana mayor. Es lo único que me ha sujetado en pie estos años.

- *(Opción del jugador)* **Contener la rabia y jurarles guerra en voz baja**
**Nora:** (Podría gritar. Podría bajar al aparcamiento y romperle la cara al primer traje de Nyxos que encuentre. Y eso es exactamente lo que quieren: que pierda la cabeza y con ella el caso.)

**Nora:** No van a verme temblar, Diego. Van a verme llegar. Han metido a mi hermano en esto pensando que me paralizaba. Se han equivocado de detective y de familia.

**Diego Vega:** Esa voz. Esa voz baja tuya me daba miedo de pequeño. Ahora me da paz. Que se preparen.

**Nora:** Descansa. Núñez va a poner a un agente en esa puerta y no entra ni el médico sin que yo lo sepa. Se acabó que te usen. Ahora la que va a usar algo soy yo: este expediente, contra ellos.


### Final del caso — fin13
_clave S3: "fin13"_

> **PISTA — El código del proyecto:** Todos los historiales llevan un código: 'Proyecto SOMNIA — Nivel Consejo'. La orden viene del consejo de Nyxos.

**(Narrador/voz en off):** Con Diego dormido y custodiado, Nora y Sonia vuelven al archivo y exprimen los historiales hasta la última página. En un rincón de cada carpeta, estampada con un sello de tinta violeta, la misma etiqueta de máxima confidencialidad se repite como una firma del diablo.

**Nora:** Aquí está. En todas. 'Proyecto Somnia — autorización: Nivel Consejo'. Léelo, Sonia. No es una planta que se descontroló. No es un directivo suelto haciendo el loco. Lo aprueba el consejo de administración. La cúpula entera.

**Sonia:** El consejo, Nora. No un monstruo con colmillos: doce personas con firma, en una sala con moqueta buena y agua en botella de cristal. El horror no lo decidió un chalado en un sótano. Lo aprobó una reunión con orden del día.

**Nora:** Doce personas decidiendo, entre el café y las galletas, a cuánta gente experimentar y a cuánta 'depurar'. Levantaban la mano, se aprobaba el punto, y en algún sitio de la ciudad se apagaba una persona. El mal con acta y con secretario.

- *(Opción del jugador)* **Sentir el vértigo de contra quién va**
**Nora:** (Doce firmas. Doce personas que esta noche cenarán en casa mientras mi hermano suda veneno en una cama. Y yo, con una carpeta y una placa gastada, voy a ir a por las doce.)

**Sonia:** Conozco esa cara tuya. Es la de antes de una cuesta muy larga. No la subas sola, Nora. Para eso estamos los que te queremos: para que no la subas sola.

- *(Opción del jugador)* **Endurecerse y aceptar el tamaño del enemigo**
**Nora:** Mejor. Si la orden nace de un consejo, entonces ya sé exactamente dónde clavar el hierro. No persigo a un culpable: desmonto una decisión colectiva. Y las decisiones dejan actas, y las actas dejan huella.

**Sonia:** Esa es mi Nora. Yo te firmo cada informe forense que haga falta, con nombre y apellidos. Que tiemblen los de la moqueta buena.

**Nora:** 'Nivel Consejo'. Ya no busco al que aprieta la aguja. Busco a los doce que aprobaron que existiera la aguja. La orden nace arriba del todo, y hasta arriba del todo voy a subir.


### Cierre — cierre13
_clave S3: "cierre13"_

**(Narrador/voz en off):** En la comisaría, el expediente ocupa media mesa: carpetas, fotocopias, el sello violeta repetido decenas de veces. Núñez lo hojea despacio, con las gafas en la punta de la nariz, y por primera vez en semanas no encuentra una pega.

**Nora:** El proyecto lo firma el consejo, Núñez. Lo tengo por escrito, con su código y su nivel de autorización. Pero conozco a los jueces: el primero me va a preguntar si esto pasa solo aquí. Si es un desmán local o una máquina.

**Sgto. Núñez:** Y tiene razón el juez imaginario. Un consejo que aprueba esto no lo aprueba para una ciudad. Hay que demostrar que Nyxos hace lo mismo en otros sitios, que es sistemático. Que no es una herida: es un método.

**Nora:** Entonces necesito un segundo lugar. Otro archivo, otras carpetas, el mismo sello violeta a doscientos kilómetros de aquí.

**Sgto. Núñez:** Corren rumores de un centro en la costa. Un 'balneario de salud' de Nyxos donde entra gente a curarse y no vuelve a salir. Coja unos días, detective Vega. Baje al sur y mire con sus propios ojos. Diego está a salvo aquí; de eso me encargo yo.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 13 —  La orden nace en el consejo de Nyxos. Y el rastro, ahora, se extiende más allá de la ciudad: hacia un pueblo de la costa donde el mar guarda otro secreto.



## Capítulo 14 · El pueblo de la costa

### Briefing (comisaría) — brief14
_clave S3: "brief14"_

**(Narrador/voz en off):** La comisaría huele a café quemado y a expedientes que no cierran. Núñez despliega sobre la mesa un folleto satinado: cielo azul, batas blancas, un acantilado sobre el mar. En una esquina, pequeña, la serpiente enroscada en la copa.

**Sgto. Núñez:** Un pueblo de la costa, tres horas al sur. Un 'balneario de salud' de Nyxos sobre el acantilado. Talasoterapia, dicen, aire de mar, curas de reposo. Y demasiada gente que sube a curarse y no vuelve a bajar.

**Nora:** Del neón al salitre. La misma serpiente, otro clima. ¿Qué le hace pensar que no es solo un balneario caro para viejos con dinero?

**Sgto. Núñez:** Que los que suben no tienen dinero. Son jubilados solos, enfermos crónicos del pueblo. Gente que allí llaman 'sin cargas'. Y que en el registro del ayuntamiento constan como 'trasladados' y nunca como 'vueltos'.

**Nora:** Sin cargas. Otra vez la misma palabra bonita para decir: nadie preguntará por ellos.

**Sgto. Núñez:** Baje a mirar, detective Vega. Pero sin placa por si acaso. Allí abajo Nyxos no es una empresa que patrocina hospitales: es el que da los pocos empleos que quedan. Usted allí no tiene amigos.

- *(Opción del jugador)* **«Bajo como turista. Ojos abiertos, boca cerrada.»**
**Nora:** Bajo como una señora cansada que busca aire de mar. Nadie desconfía de una mujer sola con maleta. Miro, escucho y no firmo nada.

**Sgto. Núñez:** Así me gusta. Sea sombra hasta que tenga algo que aguante en un juzgado. Y llámeme cada noche, que la cobertura ahí baila.

- *(Opción del jugador)* **«Voy con rabia. Esto ya lo he visto en la ciudad.»**
**Nora:** Ya sé lo que voy a encontrar, Núñez. Lo vi en la clínica, lo vi en el laboratorio. Solo cambia el papel de pared. Y me pone enferma saberlo de antemano.

**Sgto. Núñez:** Precisamente por eso, cabeza fría. Si baja con la rabia por delante, la ven venir a un kilómetro. Rabia guardada, detective Vega. La necesitará entera para el final.

**Nora:** (Tres horas al sur. Tres horas para convencerme de que esta vez, quizá, solo sea un balneario. No me lo creo ni yo.)


### Localización A — l14a
_clave S3: "l14a"_

> **PISTA — El balneario:** El 'balneario de salud' de Nyxos en el pueblo costero es otro centro de ensayos encubierto.

**(Narrador/voz en off):** El pueblo de la costa es blanco y azul: casas encaladas, barcas varadas panza arriba, redes secándose. El mar es una lámina de plomo bajo un cielo que no acaba de llover. Y sobre el acantilado, dominándolo todo, un edificio nuevo, luminoso, con el logo de la serpiente recortado contra el gris.

**Nora:** Un balneario. Aire de yodo, batas blancas y precios de folleto. La misma fachada amable de siempre, solo que aquí huele a salitre en vez de a lluvia sucia.

**(Narrador/voz en off):** Subes el camino del acantilado. En la verja, un jardinero riega geranios que no necesitan agua. Dos ancianos toman el sol en sillas de ruedas, quietos como estatuas, vigilados por un celador demasiado corpulento para ser enfermero.

**Nora:** Esos dos no toman el sol: los han puesto al sol. Como se saca a airear la ropa. Y el enfermero tiene espaldas de portero de discoteca, no de cuidador.

**Nora:** Aquí no traen mujeres del Barrio Viejo. Aquí reclutan a jubilados solos, a enfermos crónicos del pueblo. Gente que ya estaba medio borrada del mundo. La misma cantera, otro paisaje.

**(Narrador/voz en off):** Una recepcionista de sonrisa ensayada te tiende un tríptico: 'Programa de bienestar prolongado. Plazas subvencionadas para vecinos sin recursos ni familia'. Lo dice como si fuera un premio.

**Nora:** 'Sin recursos ni familia.' Lo ponen en el folleto, con orgullo, como si fuera caridad. Es el mismo filtro que en la ciudad: no eligen a los débiles. Eligen a los que nadie va a reclamar.


### Descartes / pistas falsas — rh14
_clave S3: "rh14"_

**(Narrador/voz en off):** El puerto pesquero es un rosario de barcas, cabos podridos y gaviotas que gritan sobre las cajas de hielo. Aquí todo el mundo tiene una teoría sobre el balneario, y todas saben a vino peleón y a miedo viejo.

**Nora:** En un pueblo así, el chismorreo es el único periódico. Escucho a los cinco que más hablan. A ver cuántos aguantan de pie.

**(Narrador/voz en off):** El pescador chismoso jura, con la mirada perdida en el faro, que ha visto 'barcos que cargaban cuerpos de noche'. Pero mezcla la leyenda del ahogado, las luces del faro y media garrafa de aguardiente. El tabernero sabe de todo el pueblo y no sabe de nada: repite rumores para llenar vasos.

**Nora:** El guardacostas vio luces raras mar adentro, sí. Eran arrastreros furtivos faenando donde no deben, no lanchas de Nyxos. La 'bruja' del pueblo dice que el balneario 'roba la vida' por las ventanas: superstición, aunque la vieja no anda tan descaminada de fondo.

**Nora:** Y el forastero que hace demasiadas preguntas resulta ser un periodista de viajes buscando una crónica de pueblo con encanto. Cinco bocas, cinco callejones. Rumor, miedo y folclore. Ninguno prueba nada ante un juez.

**Nora:** Pero hay una cosa en este pueblo que no bebe, no delira y no inventa leyendas: el libro de bajas del ayuntamiento. Ahí, en negro sobre blanco, están los que no volvieron. La prueba no está en el puerto. Está en el registro.


### Localización B — l14b
_clave S3: "l14b"_

> **PISTA — Los desaparecidos del sur:** El registro del pueblo esconde una lista de vecinos 'trasladados a tratamiento' que nunca regresaron.

**(Narrador/voz en off):** El ayuntamiento del pueblo es un caserón de piedra medio dormido, con un reloj parado y un ficus polvoriento. Tras el mostrador, una funcionaria de mediana edad teclea con la cara de quien lleva veinte años tramitando el olvido de los demás.

**(Narrador/voz en off):** Le pides el registro de traslados a centros asistenciales. Ella te mira largo, calibrando si eres peligro o compañía. Luego, casi por rebeldía, saca un libro grande de tapas grises y lo deja caer sobre el mostrador con un golpe seco.

**(Narrador/voz en off):** —Usted no es de aquí —dice sin preguntar—. Los de aquí ya no preguntan. Mire la columna de la derecha. La de 'reingreso'. Y cuénteme cuántas fechas ve escritas.

**Nora:** Veinte nombres 'trasladados a tratamiento especial' en dos años. Y la columna de reingreso, veinte veces en blanco. Ni una fecha de vuelta. Ni una.

**(Narrador/voz en off):** La funcionaria pasa el dedo por los renglones, uno a uno, como quien reza un rosario que odia. Baja la voz aunque no hay nadie más en la sala.

**(Narrador/voz en off):** —Don Amaro, el del faro. La Pura, que vendía pescado. El maestro jubilado, que no tenía a nadie. Yo tramité sus papeles. Puse el sello. 'Traslado por bienestar.' Y nunca me atreví a preguntar por qué no volvía ninguno.

- *(Opción del jugador)* **Ser dura: «Usted lo sabía y firmó igual.»**
**Nora:** Usted puso el sello veinte veces. Veinte personas. Y ni una llamada, ni una carta al forense. Eso también tiene un nombre, señora.

**(Narrador/voz en off):** La mujer no se defiende. Aprieta los labios y asiente, como si llevara años esperando que alguien se lo dijera a la cara.

**(Narrador/voz en off):** —Lo sé. Por eso he sacado el libro. Sáquelo del cajón, detective. Yo ya no puedo dormir; que al menos sirva de algo mi vergüenza.

- *(Opción del jugador)* **Ser humana: «No es usted quien los subió al acantilado.»**
**Nora:** Usted no los subió al acantilado. Solo hizo su trabajo en un pueblo que mira para otro lado. El que hay que colgar está allá arriba, no en este mostrador.

**(Narrador/voz en off):** A la funcionaria se le quiebra algo en la garganta. Empuja el libro hacia ti unos centímetros más, como quien se quita un peso de encima.

**(Narrador/voz en off):** —Lléveselo. Copie lo que quiera. Yo no vi nada, ¿me entiende? Pero necesitaba que alguien lo viera por fin.

**Nora:** Veinte vecinos 'trasladados' y ninguno vuelto. Sin familia, sin denuncia, sin nadie que llame. Nyxos elige pueblos pequeños y gente sola por lo mismo que elegía mujeres solas en la ciudad: porque el silencio ya venía de fábrica.


### Final del caso — fin14
_clave S3: "fin14"_

> **PISTA — No es solo una ciudad:** El balneario prueba que Nyxos replica el sistema por todo el país: es una red nacional.

**(Narrador/voz en off):** De madrugada, con el viento cortando salitre contra la cara, entras por la puerta de servicio del balneario. La planta noble huele a lavanda y a cera. Bajas una escalera de mármol que se vuelve hormigón, y la lavanda se convierte en desinfectante y en frío de nevera.

**Nora:** Arriba, balneario de folleto. Aquí abajo, el mismo hormigón que en el laboratorio de la ciudad. Como si hubieran fotocopiado el infierno y cambiado la dirección postal.

**(Narrador/voz en off):** El sótano se abre ante ti y es un déjà vu que hiela: habitáculos numerados con puertas de observación, neveras de viales ámbar con la serpiente impresa, camillas con correas, pulseras de plástico con códigos en vez de nombres. Idéntico. Hasta la disposición de las salas es la misma.

**Nora:** Idéntico. Copiado y pegado. No es una imitación torpe de un jefe local: es el mismo plano, el mismo protocolo, el mismo mobiliario. Un franquiciado del horror junto al mar.

**(Narrador/voz en off):** En una pared, un cuadro de organización con pestañas de colores. Y en la cabecera, impresa, una frase de manual corporativo: 'Centro Sur-3. Protocolo estándar de bienestar prolongado.'

**Nora:** Sur-3. Un número. Si esto es el tres, hay un uno y un dos. Y detrás de un número siempre hay una lista, y un departamento que la gestiona, y un presupuesto anual. Esto ya no es un caso de una ciudad.

- *(Opción del jugador)* **Sentir el vértigo de lo que acaba de descubrir**
**Nora:** (Creí que perseguía una herida en una ciudad. Y resulta que la herida está por todo el mapa, con su plano, su número y su hoja de cálculo. No lucho contra un crimen: lucho contra un modelo de negocio.)

**Nora:** Nyxos no oculta desapariciones. Las industrializa. Producción en serie, sucursal a sucursal, con manual de instrucciones. Y el manual funciona porque nadie reclama la mercancía.

- *(Opción del jugador)* **Endurecerse y ponerse a trabajar**
**Nora:** Nada de temblar ahora. Si es una red, la red deja rastro: facturas, transportes, nóminas de celadores, pedidos de viales. Todo lo que se replica, se documenta. Y todo lo que se documenta, se sigue.

**(Narrador/voz en off):** Fotografías el cuadro de organización pestaña por pestaña, el número, la frase de manual. Cada foto es un eslabón que ya no podrán fingir que no existe.

**Nora:** Es un sistema nacional, replicado pueblo a pueblo, con la eficiencia de quien fabrica jabón. La ciudad no era el centro del mundo. Era una sucursal más.

**(Narrador/voz en off):** Grabas, coges muestras y pulseras numeradas, y subes antes de que clareen las primeras barcas. Detrás de ti, el mar sigue golpeando el acantilado, plomo contra piedra, el único testigo que Nyxos nunca podrá comprar ni callar.


### Cierre — cierre14
_clave S3: "cierre14"_

**(Narrador/voz en off):** En la comisaría, Nora vacía sobre la mesa una bolsa de pruebas: viales con la serpiente, pulseras numeradas, las fotos del cuadro de organización. Núñez las mira una a una y se sienta despacio, como si de repente le pesara la espalda.

**Nora:** Costa y ciudad, mismo hormigón, mismo protocolo, mismo logo. Y una etiqueta que lo dice todo: 'Centro Sur-3'. No es un desliz de una sucursal. Es una red nacional con numeración propia.

**Sgto. Núñez:** Sur-3. Madre mía. Si numeran los centros, es que hay un mapa entero en algún despacho, con chinchetas. Y nosotros vamos descubriéndolos de uno en uno, tarde y a ciegas.

**Nora:** Veinte vecinos del sur trasladados a la nada, Núñez. Sin una sola denuncia. Y son solo los de un pueblo. Multiplique eso por cada chincheta del mapa.

**Sgto. Núñez:** Si es nacional, los centros más sucios estarán en los sitios más escondidos. Se cuenta que hay uno en la montaña, un viejo sanatorio de tuberculosos reconvertido, lejos de toda carretera. Y allí, dicen, por primera vez, alguien salió con vida.

**Nora:** Un superviviente. Alguien que vio el sótano por dentro y respira para contarlo. Eso no es una pista, Núñez. Es la primera grieta de verdad en toda la pared.

**Sgto. Núñez:** Si es que llegamos antes que ellos. Un testigo vivo es lo único que Nyxos no puede permitirse. Lo estarán buscando con el mismo mapa que nosotros.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 14 —  El mar guarda a los desaparecidos del sur. Y arriba, en la montaña, en un sanatorio olvidado, quizá respire todavía un testigo.



## Capítulo 15 · El pueblo de montaña

### Briefing (comisaría) — brief15
_clave S3: "brief15"_

**(Narrador/voz en off):** La calefacción de la comisaría lleva días peleando contra una ola de frío que baja del norte. Sobre la mesa de Nora, un mapa de la sierra y una foto satélite: un edificio largo y blanco encaramado a una cumbre, con el logo nuevo de Nyxos pintado sobre piedra vieja. Debajo, una carpeta fina, casi vacía.

**Sgto. Núñez:** Un sanatorio de montaña, detective Vega. Aislado por la nieve medio año. Nyxos lo compró hace dos inviernos y lo reabrió como 'unidad de cuidados paliativos'. El sitio perfecto para esconder lo que no debe verse.

**Nora:** Y para que, si alguien escapa, no le crea nadie. ¿Qué tenemos de dentro?

**Sgto. Núñez:** Nada firme. Rumores de pueblo. Suben 'enfermos' que caminan solos y bajan cajas cerradas. Y un parte antiguo de la Guardia Civil: hace meses una mujer bajó descalza por la nieve gritando que la mataban ahí arriba. La ingresaron por delirio. Nadie volvió a hablar de ella.

**Nora:** Una mujer que bajó por su propio pie. Viva. Núñez, eso no es un rumor: es un testigo.

**Sgto. Núñez:** Un testigo al que ya etiquetaron de loca. Si la encuentra y no lo hace con cuidado, la palabra 'delira' se los come a los dos. A la montaña se sube con guantes, y en este caso lo digo en los dos sentidos.

- *(Opción del jugador)* **«Subo a escuchar, no a acusar. Con guantes.»**
**Nora:** Subo a escuchar, Núñez. Nada de irrumpir con la placa por delante. Si esa mujer lleva meses sin que la crean, lo último que necesita es otro que llegue a decirle lo que vio.

**Sgto. Núñez:** Así me gusta. La verdad de montaña no se arranca, se merece. Vaya despacio y llámeme desde el pueblo, que arriba no habrá cobertura.

- *(Opción del jugador)* **«Si hay alguien vivo ahí arriba, no espero al deshielo.»**
**Nora:** Si hay una sola persona respirando en ese sitio, Núñez, no me quedo abajo esperando a que el juez se despierte de buen humor.

**Sgto. Núñez:** Me lo temía. Suba, pero prométame que antes de forzar una puerta con nieve hasta la rodilla me lo piensa dos veces. Los mártires no declaran.

**Nora:** (Todos los que persigo desde hace meses son fotos, cruces en una carpeta, nombres apagados. Ahí arriba puede que haya una boca que aún habla. Una sola. Y voy a subir una montaña entera para no perderla.)


### Localización A — l15a
_clave S3: "l15a"_

> **PISTA — El sanatorio de montaña:** El sanatorio de Nyxos en la montaña recibe 'pacientes terminales' que en realidad están sanos.

**(Narrador/voz en off):** El pueblo de montaña es piedra, humo de chimenea y un frío que corta la cara como un papel. Cuatro calles empinadas, un campanario, tejados con una cuarta de nieve. La gente mira de reojo desde las ventanas y no saluda. Sobre la cumbre, colgado del cielo gris, el sanatorio antiguo con el logo nuevo de Nyxos.

**Nora:** 'Cuidados paliativos', dice el cartel de la carretera. Un sitio adonde la gente sube a morir en paz. Bonito. Piadoso. Inatacable.

**(Narrador/voz en off):** En la única taberna, un viejo que apura un orujo suelta la lengua cuando Nora paga la ronda. Baja la voz aunque no haya nadie más.

**Nora:** Cuénteme lo del sanatorio. Lo que se cuenta aquí, no lo que pone el folleto.

**(Narrador/voz en off):** El viejo señala la cumbre con el mentón. Dice que los enfermos que suben en la furgoneta suben andando, por su pie, con maleta. Que a veces saludan por la ventanilla, coloradotes, sanos como un roble. Y que lo único que baja de ahí son cajas. Cajas cerradas, del tamaño justo.

**Nora:** Suben sanos y bajan cajas. A un sitio de terminales no llega gente que camina y carga su equipaje. Eso no es un hospicio: es una puerta de un solo sentido con papeleo de caridad.

**Nora:** Aislamiento perfecto. Medio año incomunicados por la nieve. Aquí Nyxos hace, a plena luz de la montaña, lo que en la ciudad no se atreve ni en un sótano.


### Descartes / pistas falsas — rh15
_clave S3: "rh15"_

**(Narrador/voz en off):** El pueblo tiene, como toda montaña, sus leyendas. Cinco voces se le acercan a Nora junto al fuego de una cabaña, cada una con su trozo de miedo. Fuera arrecia el viento; dentro, el humo pica en los ojos y las historias crecen con las llamas.

**Nora:** Cinco testigos de leyenda. Vamos a ver cuántos aguantan la luz del día.

**(Narrador/voz en off):** El ermitaño jura entre temblores que ahí arriba 'roban almas y las guardan en frascos'; delira, aunque su miedo sea de verdad. El cazador vio subir camillas de noche y creyó que eran heridos de la nieve. El cura bendice el sanatorio, cobra su donativo y mira para otro lado.

**Nora:** La posadera aloja al personal y solo sabe que 'pagan bien y hablan poco'. Y el niño ve 'fantasmas en las ventanas', que no son sino pacientes de carne y hueso pegados al cristal, mirando un pueblo al que ya no bajarán.

**Nora:** Ermitaño, cazador, cura, posadera, un crío asustado. Todo miedo, todo bruma. Pero el miedo no declara ante un juez, y una leyenda no tumba a una farmacéutica.

**Nora:** La única voz que vale es la de quien bajó de ahí con vida y en su sano juicio. Y hay una. Se llama Irene, y lleva meses escondida en una buhardilla de este pueblo, esperando a que alguien la crea.


### Localización B — l15b
_clave S3: "l15b"_

> **PISTA — La superviviente:** Una mujer que escapó del sanatorio, escondida en el pueblo, acepta hablar por primera vez.

**(Narrador/voz en off):** La buhardilla huele a leña húmeda y a miedo viejo. Bajo el alero, tapada con tres mantas pese al brasero, una mujer joven se encoge al oír los pasos en la escalera. Meses lleva así: la primera que salió del sanatorio por su propio pie y a la que el mundo entero decidió no escuchar.

**Testigo:** No se acerque de golpe. Por favor. Me llamo Irene. Subí ahí arriba por 'un tratamiento del sueño', gratis, con folleto y todo. Bajé descalza por la nieve, de noche, corriendo. Y desde entonces la única palabra que me devuelve la gente es 'delira'.

**Nora:** Yo no he subido a decirte que deliras, Irene. He subido una montaña entera para escucharte. Y te creo. Cada cosa que recuerdes es una grieta en algo muy grande.

**Testigo:** ¿Me cree? Usted es la primera que no me mira como a una loca desde que puse un pie en este pueblo.

- *(Opción del jugador)* **«Tómate tu tiempo. No hay prisa que valga más que tú.»**
**Nora:** No hay ninguna prisa, Irene. Cuéntamelo a tu ritmo. Llevo meses persiguiendo papeles y cruces en una lista. Tú eres la primera persona viva que puede ponerles nombre a esas cruces. Puedo esperar lo que haga falta.

**Testigo:** Nadie me había dicho eso. Todos querían el resumen rápido para volver a sus cosas. Está bien. Voy a contárselo entero, aunque tiemble.

- *(Opción del jugador)* **«Necesito el método. Cómo lo hacían, paso a paso.»**
**Nora:** Sé que duele, y lo siento, pero necesito el método, Irene. Cómo funcionaba por dentro, paso a paso. Es lo único que un juez no puede llamar 'delirio': los detalles que solo sabe quien estuvo dentro.

**Testigo:** Los detalles los tengo grabados a fuego. Ojalá pudiera borrarlos. Escuche, entonces, y no me interrumpa, que si paro no vuelvo a empezar.

**Testigo:** Al entrar te quitan el nombre y te dan un número, cosido en la bata. Yo era la treinta y uno. Te dan una pastilla para dormir, dicen que es para el descanso: Somnia. Te duermen y te despiertan a horas raras para 'medir'. Luces, agujas, preguntas que no recuerdas haber contestado.

**Testigo:** Los que respondían 'bien' seguían arriba, dóciles, sonrientes, apagados. A los que no... a los que nos removíamos, nos poníamos difíciles, se nos llevaban de noche. Una camilla, un pasillo, una puerta al fondo. Nunca vi volver a nadie por esa puerta. Yo salí de una de esas noches, treinta y una, descalza, por la ventana del office. Corriendo hacia la única luz del valle.

**Nora:** (Los numeraban. Les quitaban el nombre para que doliera menos firmar la cruz. Y esta mujer, la treinta y uno, es la única que se salió del papel y bajó a contarlo.)

**Nora:** Irene, escúchame bien. A partir de ahora no estás sola en esto. Todo lo que acabas de decir es exactamente lo que llevo meses sin poder probar. Tú eres la prueba.


### Final del caso — fin15
_clave S3: "fin15"_

> **PISTA — El testimonio vivo:** Con la superviviente y las muestras, hay por fin un testigo humano contra el proyecto Somnia.

**(Narrador/voz en off):** Antes del alba, un coche camuflado saca a Irene del pueblo envuelta en una manta térmica, con Núñez esperándola abajo, lejos de cualquier mano de Nyxos. Arriba, el sanatorio ya olía la redada: lo evacuaron a toda prisa. Pero la prisa, otra vez, deja restos.

**(Narrador/voz en off):** Entre las habitaciones vacías quedan batas con números cosidos, hojas de 'medición', un frigorífico industrial con viales ámbar y la serpiente impresa, y una puerta al fondo del pasillo con un cerrojo por fuera. La puerta que Irene describió sin haberla vuelto a ver.

**Nora:** Todo encaja con su relato palabra por palabra. Los números, las dosis, la puerta de un solo sentido. Un testigo vivo que cuenta el método desde dentro, y una casa entera que le da la razón.

- *(Opción del jugador)* **Pensar en todos los números sin nombre**
**Nora:** (La treinta y uno salió corriendo. ¿Y del uno al treinta? ¿Y del treinta y dos en adelante? Cada bata doblada en ese armario fue una persona a la que le quitaron hasta el nombre.)

**Nora:** Irene sobrevivió para que las demás cuenten, aunque ya no puedan. Voy a hacer que su voz valga por todas las que se callaron tras esa puerta.

- *(Opción del jugador)* **Blindar el testimonio antes que nada**
**Nora:** Lo primero es blindarla. Declaración grabada, forense que certifique que está lúcida, custodia de cada vial y cada bata. Que ningún abogado de mil euros la hora pueda volver a decir la palabra 'delira'.

**Sgto. Núñez:** Ya está en marcha, detective Vega. Sonia le hará el informe médico y Clara le prepara la declaración blindada. Esta vez la loca del pueblo se sube al estrado con toda la casa de testigos detrás.

**Nora:** Un testigo humano, vivo y en su sano juicio, contra el proyecto Somnia. Documentos, viales, habitáculos con cerrojo por fuera. La palabra 'delira' ya no funciona contra esto. Ahora funciona la palabra 'Irene'.


### Cierre — cierre15
_clave S3: "cierre15"_

**(Narrador/voz en off):** En la comisaría, con el radiador a tope y el café humeante, la declaración de Irene descansa sobre la mesa, firmada y grabada. Fuera sigue nevando el norte. Núñez la lee entera, despacio, y al terminar deja el papel como quien deja algo sagrado.

**Nora:** Tenemos superviviente lúcida, muestras, historiales y un patrón que se repite ciudad tras ciudad. Por fin una voz que aguanta un juicio.

**Sgto. Núñez:** Y por eso mismo, prepárese. En cuanto esto salga, Nyxos dirá que el sanatorio era cosa de una 'filial rebelde'. Un capataz que se pasó de la raya. Casos aislados. La manzana podrida de siempre.

**Nora:** La franquicia loca que actuó por su cuenta. Lo veo venir. Cortan la rama y salvan el árbol.

**Sgto. Núñez:** Entonces hay que probar que no es una rama: que es la MISMA mano en sitios distintos. Los mismos formularios, los mismos números, el mismo Somnia. Hay una filial de Nyxos en otra ciudad. Vaya, compare, y ate el nudo nacional.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 15 —  Por fin una voz que sobrevivió a la nieve. Y el mapa de Nyxos, lejos de cerrarse, se abre hacia otras ciudades.



## Capítulo 16 · La otra ciudad

### Briefing (comisaría) — brief16
_clave S3: "brief16"_

**(Narrador/voz en off):** Cinco de la mañana. Sobre el mapa de la comisaría, Núñez ha clavado una chincheta nueva, cuatrocientos kilómetros al norte. Un hilo rojo la une con la ciudad de Nora, y el hilo tiembla cada vez que pasa un camión por la calle.

**Sgto. Núñez:** La filial de Nyxos en la capital del norte, detective Vega. Llevo una semana pidiendo sus registros por lo bajo. Y me da miedo lo que veo: si esa filial opera igual que la de aquí, esto ya no es una ciudad podrida. Es un país.

**Nora:** Otra ciudad, la misma serpiente. Siempre pensé que subíamos por una escalera y resulta que subíamos por un ascensor con muchas plantas idénticas.

**Sgto. Núñez:** Por eso no va sola. Clara la acompaña, por lo legal. Un paso en falso a cuatrocientos kilómetros de su placa y no la saca de allí ni Dios.

**Nora:** (Clara. Ocho horas de coche con Clara. Preferiría el interrogatorio de Adler.)

- *(Opción del jugador)* **«Voy a por pruebas, no a hacer amigos.»**
**Nora:** Voy a mirar sus papeles, Núñez. Si son los mismos formularios que aquí, los fotografío y me largo. No pienso simpatizar con nadie del norte.

**Sgto. Núñez:** Así me gusta. Fría y rápida. Pero recuerde: allí usted no es la ley, es una turista con demasiadas preguntas. Dígalo con Clara delante siempre.

- *(Opción del jugador)* **«Si es la misma empresa, la tumbamos entera.»**
**Nora:** Si demuestro que allí usan mi mismo protocolo, con mis mismos códigos, ya no persigo una filial: las persigo a todas de un tirón. Vale la pena el viaje.

**Sgto. Núñez:** Eso es pensar en grande. Solo le pido que piense también en volver. Esta gente, cuando huele que quieres tirar la casa entera, deja de ser educada.

**Nora:** Otra ciudad, la misma serpiente. Vamos.


### Localización A — l16a
_clave S3: "l16a"_

> **PISTA — La franquicia:** La filial del norte usa idénticos protocolos, formularios y códigos: es la misma organización.

**(Narrador/voz en off):** La otra ciudad es más gris, más grande, más fría. La lluvia cae aquí más recta, sin viento, como si hasta el clima tuviera prisa. Rascacielos distintos, avenidas más anchas, más solas. Y en el centro, coronando una plaza de granito mojado, otra torre de Nyxos con el mismo neón enfermo latiendo en lo alto: la serpiente en la copa, verde veneno contra el cielo de plomo.

**Clara:** Sabes lo que me revienta de esta ciudad, Nora? Que no me da miedo. Es demasiado ordenada para dar miedo. Y lo ordenado, en este caso, es lo que asusta de verdad.

**Nora:** Pedí ver un expediente de admisión en su balneario del norte, con una excusa. Míralo. Mismo formulario. Mismos campos. Mismo código de proyecto arriba, a la derecha, con la misma tipografía diminuta.

**(Narrador/voz en off):** Extiendes junto al papel una foto que sacaste en el sanatorio de tu ciudad. Los dos documentos, uno al lado del otro sobre el capó del coche bajo la llovizna, son gemelos. Cambia la dirección. Nada más.

**Nora:** Mismos formularios, mismos códigos de proyecto, mismo «notario» inexistente firmando abajo. No es una imitación: es la misma empresa copiándose a sí misma. Un calco. Una franquicia del horror.

**Clara:** Y eso, Nora, legalmente es la mina de oro. Una imitación se defiende: cada quien responde de lo suyo. Pero si demuestro que los protocolos son idénticos y bajan centralizados, del mismo sitio, entonces caen todos a la vez. No filial por filial, en diez juicios de diez años. Todos. De golpe.

**Nora:** (La miro explicarlo y por un segundo recuerdo por qué me enamoré de ella. Se le encienden los ojos con la ley como a mí con una puerta que ceder. Somos la misma clase de perro, cada uno mordiendo su hueso.)

**Nora:** Entonces dejamos de fotografiar ciudades y empezamos a fotografiar el cordón que las une. Enséñame de dónde bajan estos papeles.


### Descartes / pistas falsas — rh16
_clave S3: "rh16"_

**(Narrador/voz en off):** El puesto de policía del distrito huele a café de máquina y a suelo recién fregado con lejía. En una ciudad nueva, donde nadie sabe quién eres, todos quieren venderte algo. En una hora, cinco supuestos aliados se acercan a Nora como polillas a la única bombilla forastera. Clara los recibe uno a uno y los pesa con ojo de abogada.

**Clara:** Vamos a jugar a mi juego preferido, Nora: descartar. El policía local se ofrece con prisa, honrado y perdido; sabe menos del caso que nosotras y encima nos frenaría. Ni topo ni ayuda: lastre bienintencionado.

**Nora:** El taxista jura que conoce todos los secretos de la ciudad. Lo único que conoce de verdad son todos los atascos. Y el político local promete el cielo delante de una cámara y se evapora en cuanto se apaga la luz roja.

**Clara:** Añade al detective privado que me quiere vender un dossier sobre Nyxos: recortes de periódico viejos que hasta yo tengo archivados. Y la empleada resentida, que odia a la filial. Pero la odia por un ascenso que le negaron, no por lo que hacen. Rabia de nómina, no de conciencia. En un juzgado no vale nada.

**Nora:** Cinco puertas y detrás de cada una, aire. Ruido de ciudad nueva, gente que huele forastera con dinero y acude. Nada sólido.

**Clara:** Lo sólido no charla, Nora. Lo sólido está impreso. Son los protocolos idénticos que atan esta filial a la casa madre. Un papel no cobra, no exagera, no se raja en el estrado. Persigamos el papel.


### Localización B — l16b
_clave S3: "l16b"_

> **PISTA — El patrón nacional:** Clara ata las filiales a una única sede central: todas dependen del consejo de Nyxos.

**(Narrador/voz en off):** Un juzgado prestado, cedido a Clara por un colega que le debe favores. La sala de vistas está vacía y a media luz, y sobre la mesa alargada Clara despliega un organigrama enorme, dibujado a mano y corregido mil veces, que ha tardado semanas en levantar. Líneas, cajas, flechas. Un árbol de raíces enfermas.

**Clara:** Mira esto despacio, que me ha costado el sueño de un mes. Cada filial, cada balneario, cada sanatorio, cada clínica fantasma como la de tu hermano: todo cuelga de aquí arriba. De la misma sede central. Las órdenes, el dinero y el «protocolo Somnia» bajan de un único consejo. Doce sillas.

**Nora:** Entonces todo este tiempo he estado dando puñetazos a las ramas. Y la cabeza es una sola, con doce sillas y un logo.

**(Narrador/voz en off):** Sigues con el dedo una de las líneas, de una ciudad cualquiera hasta la caja de arriba. Todas las líneas mueren en el mismo punto. No hay una sola rama suelta. No hay filial rebelde. Es un cuerpo con un solo corazón.

- *(Opción del jugador)* **«Gracias, Clara. De verdad.»**
**Nora:** No sé cómo agradecerte esto. Un mes sin dormir por un caso que ni siquiera es tuyo. Gracias, Clara. De verdad.

**Clara:** No lo hago por ti, Nora, que lo sepas. Lo hago porque he leído esos expedientes de admisión y no puedo dormir sabiendo lo que firmaba esa gente sin entenderlo. Que me sirvas para algo es casualidad.

**Nora:** (Miente fatal cuando quiere sonar dura. Siempre lo hizo. Y yo siempre se lo dejé pasar.)

- *(Opción del jugador)* **«¿Por qué te metes en esto, Clara?»**
**Nora:** Podrías estar cobrando fortunas defendiendo a esta misma gente, Clara. Eres la mejor. ¿Por qué te pones del otro lado, conmigo, gratis y de noche?

**Clara:** Porque hace catorce meses me fui de tu casa jurando que no me arruinarías la vida con tus muertos. Y resulta que los tuyos me quitan el sueño más que mis vivos. Enhorabuena. Ganaste tú, como siempre.

**Nora:** No he ganado nada. Solo tengo un organigrama y una deuda contigo que no sé pagar.

**Clara:** Deja los sentimientos para el viaje de vuelta. Céntrate: por primera vez tienes cómo llevarlos a todos ante un juez a la vez. Solo te falta una cosa. Entrar en esa sede central, coger un papel firmado arriba del todo... y que no te compren o te maten antes de sacarlo.


### Final del caso — fin16
_clave S3: "fin16"_

> **PISTA — Una sola cabeza:** Documentos de la filial confirman que el proyecto Somnia es nacional y centralizado en la sede de Nyxos.

**(Narrador/voz en off):** La sede regional del norte es un vestíbulo de mármol frío y ascensores silenciosos, tan pulcro que hasta la lluvia parece pedir permiso para entrar. Con una orden firmada por el juez de Clara en la mano, un archivero pálido te abre, contra su voluntad, el armario de las circulares internas. Carpetas grises, cientos, ordenadas por trimestre.

**Nora:** No me hace falta leerlas todas. Solo el membrete.

**(Narrador/voz en off):** Sacas una al azar. Y otra. Y otra de un año distinto, de un asunto distinto. En todas, arriba, la misma línea impresa: «Dirección Central — Consejo». La misma firma escaneada. La misma serpiente diminuta en la esquina.

- *(Opción del jugador)* **Fotografiar y cotejar con las circulares de su ciudad**
**Nora:** Cadena de custodia. Primero foto de cada una, luego las coteja Clara con las que saqué en mi ciudad. Que ningún abogado pueda decir que las mezclé.

**Clara:** Idénticas, Nora. Palabra por palabra, salvo la dirección del pie. La misma orden bajó a tu ciudad y a esta el mismo día. Esto ya no lo entierra nadie.

- *(Opción del jugador)* **Buscar una circular sobre el protocolo Somnia**
**(Narrador/voz en off):** Tus dedos encuentran una carpeta más gruesa: «Fase clínica — sujetos». Dentro, instrucciones de dosis, criterios de «baja», y el mismo pie de firma. La misma cruz en el margen de algunos nombres que ya viste en el archivo de tu hermano.

**Nora:** La misma mano que firmó lo de Diego firmó esto, a cuatrocientos kilómetros, para gente que no conozco. Una sola pluma para todo el país.

**Clara:** Respira. Y no la sueltes. Esa carpeta es la soga entera, Nora. Solo hay que subir hasta el cuello que la sostiene.

**Nora:** Circulares nacionales. La misma firma para toda España. Ya no hay «filial rebelde» que valga: es la casa madre. La franquicia entera nace de una sola oficina.

**Nora:** Tengo el patrón nacional atado. Solo falta subir a la cima real y ponerle rostro a esas doce sillas.


### Cierre — cierre16
_clave S3: "cierre16"_

**(Narrador/voz en off):** De vuelta en casa, la lluvia conocida vuelve a tener viento. Sobre la mesa de Nora, el organigrama de Clara y las circulares del norte, sujetos con un cenicero. Núñez los mira largo rato antes de hablar, y cuando lo hace, no levanta la voz.

**Nora:** Es una sola cabeza para todo el país, Núñez. Doce sillas, una firma, un protocolo. Y en cuanto sepan que lo sé, van a dejar de jugar limpio conmigo.

**Sgto. Núñez:** Ya lo están jugando. Mientras usted volvía, llegó esto a jefatura. Han pedido una reunión «privada» con usted. Traje caro, sonrisas y un cheque de esos que se firman despacio. Vaya, detective Vega, y escuche mucho. Pero no firme nada. Nada.

**Nora:** (Primero intentaron enterrarme el caso. Luego asustarme. Ahora que no pueden, sacan la cartera. Es casi un halago.)

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 16 —  Nyxos es una sola cabeza nacional. Y esa cabeza acaba de invitar a Nora a negociar.



## Capítulo 17 · La compra

### Briefing (comisaría) — brief17
_clave S3: "brief17"_

**(Narrador/voz en off):** La comisaría a medianoche huele a café quemado y a lluvia colada por las juntas de las ventanas. Núñez deja sobre la mesa de Nora un estuche pequeño, negro, del tamaño de un mechero, y no aparta la mano de él enseguida.

**Sgto. Núñez:** Escúcheme bien, que esto lo he visto otras veces y nunca acaba como usted cree. Cuando alguien como Nyxos no puede matarla sin hacer ruido, no se rinde: cambia de arma. Ya no mandan un coche sin luces a la salida del turno. Mandan un abogado con una carpeta y una sonrisa cara.

**Nora:** O sea, que he subido de categoría. De estorbo a inversión.

**Sgto. Núñez:** No se ría, que es peor. A un estorbo lo apartan. A una inversión la compran, y si no se deja comprar, la amortizan. La reunión es esta noche, en el reservado del bar de Clara. Lleve esto encima.

**(Narrador/voz en off):** Empuja el estuche los últimos centímetros. Dentro, un micro del tamaño de una lenteja y un clip para la solapa.

**Nora:** Un micro. Muy analógico para lo que se juega.

**Sgto. Núñez:** Lo analógico no se hackea ni se apaga desde un despacho. Y una cosa más, detective Vega, y por eso he insistido en dárselo yo en persona: quien la recibe es alguien que usted conoce.

**Nora:** ¿Alguien que conozco? Vaya. Estos no fallan un solo detalle. Saben que a una cara conocida cuesta más decirle que no.

- *(Opción del jugador)* **«Voy a dejar que hablen. Todo. Y que se graben solos.»**
**Nora:** No voy a discutir con ellos, Núñez. Voy a dejarles hablar. Cuanto más ofrezcan, más largo queda el cabo con el que colgarlos. Yo solo tengo que sonreír y no tocar la carpeta.

**Sgto. Núñez:** Esa es la detective Vega que necesito esta noche. Fría. La otra, la que rompe la mesa de un puñetazo, se la deja aquí guardada.

- *(Opción del jugador)* **«¿Y si la cara conocida me hace dudar?»**
**Nora:** ¿Y si me sientan delante a alguien a quien no puedo mirar mal? No todos los que trabajan para esta gente firmaron sabiendo lo que firmaban.

**Sgto. Núñez:** Entonces se acuerda de las camillas con correas y del nombre de su hermano en una carpeta. Con eso vuelve a ver claro enseguida. Vaya, y grábelo todo.

**Nora:** Está bien. A que me compren. Nunca resolví nada sola; a lo mejor esta noche me resuelven ellos el caso a base de ofrecerme demasiado.


### Localización A — l17a
_clave S3: "l17a"_

> **PISTA — La oferta:** Nyxos ofrece a Nora dinero y un ascenso a cambio de 'reorientar' la investigación.

**(Narrador/voz en off):** El bar de Clara a esa hora es penumbra de terciopelo y hielo tintineando en vasos ajenos. En el reservado del fondo, la luz de una lámpara baja lo recorta todo: una carpeta cerrada sobre la mesa, dos copas que nadie ha tocado y un hombre de traje impecable que ya estaba sentado antes de que existiera el problema.

**Sospechoso:** Detective Vega. Siéntese, por favor. Le he pedido un rioja que le va a gustar, aunque intuyo que esta noche va a beber poco. Represento a un cliente que admira su trabajo. De verdad lo admira.

**Nora:** Déjeme adivinar el resto. Una cifra con muchos ceros, un cargo bonito y el consejo amable de que, a partir de mañana, mire hacia otro lado.

**(Narrador/voz en off):** El hombre sonríe como quien ha oído esa frase cien veces y siempre acaba ganando. Empuja la carpeta un dedo hacia ella, sin abrirla, como se ofrece un caramelo a un niño desconfiado.

**Sospechoso:** Qué visión tan pobre tiene de nosotros. No queremos que mire hacia otro lado. Queremos que mire mejor. Una jefatura nacional, detective. Su propia unidad, su presupuesto, su equipo elegido a dedo. Recursos que en esta comisaría de goteras no verá ni jubilándose.

**Nora:** ¿Y a cambio de tanto amor?

**Sospechoso:** A cambio de que reoriente su investigación. Hay culpables, detective, siempre los hay. Solo pedimos que sean los culpables adecuados. Gente más... manejable. Un par de mandos intermedios que ya han dejado de sernos útiles. Se los servimos en bandeja, con pruebas, con confesión. Usted cierra el caso del año y sube. Todos ganan.

**Nora:** Culpables manejables. Es decir, carne de usar y tirar, igual que la gente que metieron en sus camillas. Ustedes no cambian de método ni para sobornar a un policía: siempre alguien prescindible pagando por los de arriba.

**Sospechoso:** Lo llama usted feo. Yo lo llamo eficiencia. Piénselo despacio. La carpeta contiene la cifra. No hace falta que la abra ahora.

**Nora:** No la voy a abrir nunca. Pero siga, se lo ruego, que lo está haciendo usted muy bien. Explíquemelo todo otra vez, con calma, con nombres. Que lo estamos disfrutando los dos.

**Nora:** Tres cosas, letrado. Una: no. Dos: no con más ceros. Y tres, la importante: la lenteja que llevo en la solapa lleva grabándole desde el «siéntese, por favor». Gracias por el rioja.


### Descartes / pistas falsas — rh17
_clave S3: "rh17"_

**(Narrador/voz en off):** Para comprar a una persona con dignidad, Nyxos no manda a uno: manda a cinco. En las horas que siguen desfilan por el reservado, uno tras otro, cinco emisarios de guante blanco. Nora los deja hablar a todos y a todos les encuentra la costura por donde se descosen.

**Nora:** El abogado del traje caro solo lee un guion que le han escrito: si le pregunto quién decide, se le apaga la sonrisa. Un mensajero con colonia.

**Nora:** El de relaciones públicas endulza la cifra con palabras de folleto: maquilla el veneno, no lo fabrica. El testaferro que firma las cuentas ni sabe qué es Somnia; alquila su nombre por una nómina y una firma.

**Nora:** El guardaespaldas trae la parte fea, la amenaza dicha bajito: músculo a sueldo, cero cabeza. Y el asesor de imagen me propone, tan tranquilo, «reconducir el relato». Vanidad de empresa, no una pista.

**Nora:** Cinco caras, cinco máscaras de la misma cara que no da la cara. Ninguno decide nada. Ninguno me sirve para subir.

**Nora:** Pero entre tanto guante blanco hay un uniforme viejo que conozco. Uno de dentro, de seguridad, que sí puede abrirme la puerta hacia los que deciden de verdad. Marco. Y esta noche Marco tiene mala cara: la cara del que está a punto de elegir bando.


### Localización B — l17b
_clave S3: "l17b"_

> **PISTA — El chantaje a Nora:** Ante tu negativa, Nyxos amenaza a Diego; Marco, asqueado, decide ayudarte desde dentro.

**(Narrador/voz en off):** En cuanto Nora dice que no por última vez, la sonrisa del letrado se cae como una máscara mal pegada. Recoge la carpeta sin prisa y, al ponerse el abrigo, deja caer la frase como quien no quiere la cosa.

**Sospechoso:** Es una pena, detective. Piense en su hermano antes de dormir. Diego, ¿verdad? La salud es tan frágil a su edad... Sería terrible que una recaída se lo llevara justo ahora que usted está tan ocupada.

**Nora:** (Ahí está. El puño dentro del guante. No han tardado ni diez segundos en pasar del soborno a la amenaza. Y han ido directos a lo único que me duele.)

**(Narrador/voz en off):** Sale a un pasillo de servicio, entre cajas y neones parpadeantes, con el corazón golpeando de rabia más que de miedo. Y en la penumbra, apoyado en la pared como quien lleva un rato decidiéndose, la espera Marco. Uniforme de seguridad de Nyxos. Cara de no haber dormido.

**Marco:** Nora. Lo he oído todo por el pinganillo del servicio. Lo de tu hermano. Yo... llevo meses mirando para otro lado en esa sede porque me pagan por no mirar. Pero esto no. A la familia no.

**Nora:** Marco. Tú aquí. Claro que la cara conocida eras tú.

**Marco:** Entré por un sueldo, Nora. Custodiar puertas, no vender a la hermana de nadie. Cuando firmé no sabía lo que había detrás de esas puertas. Ahora lo sé. Y ya no puedo hacer como que no.

- *(Opción del jugador)* **«Ayúdame desde dentro, Marco. Es la única forma.»**
**Nora:** Entonces ayúdame desde dentro. Es la única manera de proteger a Diego y de tumbarlos a la vez. Yo sola no entro en esa sede ni con orden; contigo, a lo mejor, sí.

**Marco:** Ya contaba con que me lo pedirías. Y ya contaba con decir que sí.

- *(Opción del jugador)* **«No te pido que te quemes por mí, Marco.»**
**Nora:** No he venido a pedirte que te juegues el cuello por mí. Si me ayudas y te pillan, eres hombre muerto. No cargo con eso.

**Marco:** No lo haces tú, lo hago yo. Y no es por ti, es por mí. Por poder mirarme al espejo mañana. Déjame elegir bien por una vez, Nora.

**(Narrador/voz en off):** Marco saca una tarjeta blanca sin logo y un papel doblado en cuatro. Le tiemblan un poco las manos al ponérselos en la palma, como el que suelta algo que ya no va a poder recuperar.

**Marco:** Mi tarjeta de acceso. Y los turnos de seguridad de la sede central, semana entera, con los relevos y los puntos ciegos de las cámaras. Si descubren que ha salido de mí, soy hombre muerto, sin más. Pero prefiero eso a seguir siendo su perro. Por los viejos tiempos, Nora.

**Nora:** Por los viejos tiempos, Marco. No lo voy a desperdiciar. Y no vas a estar solo en esto: cuando caigan, caen ellos, no tú.


### Final del caso — fin17
_clave S3: "fin17"_

> **PISTA — No se venden todos:** La grabación de la oferta y el chantaje, más el acceso de Marco, abren la puerta a la sede central.

**(Narrador/voz en off):** Nora sale del edificio a una calle que la lluvia ha vuelto un espejo negro. En el bolsillo interior lleva tres cosas que valen más que la cifra de aquella carpeta: la grabación de la oferta, la grabación de la amenaza a Diego y la tarjeta blanca de Marco todavía tibia de su mano.

**Nora:** Primero intentaron comprarme. Luego, cuando vieron que no, intentaron asustarme por Diego. Ninguna de las dos les ha funcionado. Y por el camino me han regalado, sin querer, lo único que jamás me habrían dado por las buenas.

- *(Opción del jugador)* **Pensar en Marco, en la lealtad vieja**
**Nora:** (Marco ha vuelto a ser policía por una noche, después de años de no serlo. Le ha costado el sueldo, puede que el cuello. La gente decente no se ha muerto del todo; solo estaba escondida esperando a que alguien le diera una razón.)

**Nora:** No pienso desperdiciar lo que me ha dado. Se lo debo. Y se lo debo a Diego.

- *(Opción del jugador)* **Pensar en lo que acaban de demostrar de sí mismos**
**Nora:** (Una empresa que soborna y, en el mismo aliento, amenaza a un enfermo para callar a su hermana. Ya sé exactamente qué son. Lo he tenido grabado en la solapa toda la noche.)

**Nora:** La integridad no estaba en venta. Resulta que era lo único que no podían comprar, y por eso la necesitan muerta.

**Nora:** Una llave de su propia casa. Eso es lo que tengo ahora. La sede central de Nyxos, con los turnos, los relevos y los puntos ciegos. Hora de subir hasta donde se sientan los que deciden.


### Cierre — cierre17
_clave S3: "cierre17"_

**(Narrador/voz en off):** En la comisaría, Nora deja sobre la mesa de Núñez la grabadora y la tarjeta blanca, una al lado de la otra, como dos cartas ganadoras. Fuera, la lluvia por fin afloja.

**Nora:** Tengo acceso a la sede central y tengo su voz confesándolo todo: el soborno, la jefatura, la amenaza a mi hermano. Intentaron comprarme y se les cayó la máscara solos. Es hora de subir al consejo.

**Sgto. Núñez:** Con cuidado, detective Vega. Ahí arriba ya no hay recaderos ni matones de pasillo: están los que deciden. Y los que deciden no perdonan que alguien entre en su casa sin llamar a la puerta.

**Nora:** Precisamente por eso tengo una llave. No pienso llamar.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 17 —  No pudieron comprar a Nora. Y un viejo amigo, harto de ser el perro de alguien, le ha abierto la puerta del consejo.



## Capítulo 18 · El consejo

### Briefing (comisaría) — brief18
_clave S3: "brief18"_

**(Narrador/voz en off):** Las tres de la madrugada en la comisaría. Sobre la mesa, la tarjeta de acceso de Marco brilla bajo el flexo como una moneda robada. Núñez la mira sin tocarla, igual que se mira una granada con la anilla floja.

**Sgto. Núñez:** Con esa tarjeta puede entrar esta noche en la sede central de Nyxos. Pero óigame bien, detective Vega: no busque un despacho, ni un ordenador, ni una caja fuerte con billetes. Busque un papel. El acta del consejo donde se aprobó Somnia.

**Nora:** Un acta. Con lo que he visto ahí abajo, en los sótanos, en la carne de mi hermano, y usted me manda a por una hoja mecanografiada.

**Sgto. Núñez:** Esa hoja vale más que mil testigos, y usted lo sabe. Un testigo se retracta, se compra, aparece flotando en el río. Un acta firmada por doce manos con nombre y apellido no se retracta. Es piedra.

**Nora:** Piedra que hunde a los de arriba, no a los peones. Los que aprietan el botón desde una silla con reposabrazos. Esos nunca se manchan; solo firman.

- *(Opción del jugador)* **«Entro limpia, solo a fotografiar.»**
**Nora:** No toco nada, Núñez. Entro, fotografío cada página, salgo. Lo que traiga tiene que aguantar de pie ante un juez, no caerse por como lo cogí.

**Sgto. Núñez:** Así se habla. La foto es suya, el original que se quede donde está. Y a las cinco quiero saber que ha salido de ahí con los dos pies.

- *(Opción del jugador)* **«¿Y si el acta ni existe?»**
**Nora:** ¿Y si son más listos que eso, Núñez? ¿Y si nunca lo pusieron por escrito?

**Sgto. Núñez:** Existe. Esta gente lo apunta todo, detective Vega. Necesitan repartir la culpa por escrito para que ninguno cargue con ella entera. Su vanidad burocrática es su talón de Aquiles. Vaya a buscarlo.

**Nora:** El acta que lo firma todo. A la sede de Nyxos, entonces. Con la tarjeta de Marco y sin hacer ruido.


### Localización A — l18a
_clave S3: "l18a"_

> **PISTA — El acta secreta:** En la sede, un acta reservada aprueba el 'Proyecto Somnia' con presupuesto para 'gestión de sujetos'.

**(Narrador/voz en off):** De madrugada, la sede de Nyxos es una catedral de cristal apagada. La tarjeta de Marco parpadea en verde en cada torno y las puertas se abren solas, sin un guardia, como si el edificio entero te esperase. Subes en un ascensor de espejos hasta la planta noble.

**(Narrador/voz en off):** La sala del consejo huele a cera de muebles y a moqueta cara, esa que absorbe los pasos y las conciencias. Al fondo, un archivo blindado con teclado. Marco te dio también el código: seis dígitos y un chasquido metálico.

**Nora:** Carpetas de piel, lomos numerados, todo ordenado como en una notaría. El mal aquí no huele a sangre. Huele a ambientador de cítricos y a papel bueno.

**(Narrador/voz en off):** Pasas los dedos por los lomos hasta que uno se detiene solo: un dossier gris, sin logo, con una pestaña roja. Dentro, mecanografiado y sellado, el documento que Núñez juró que existía.

**Nora:** 'Acta reservada de la sesión del Consejo de Administración. Punto único del orden del día: aprobación del Proyecto Somnia.' Y aquí, la partida presupuestaria: 'gestión y depuración de sujetos'. Depuración. Escrito con todas las letras.

**Nora:** Depurar sujetos. Así llaman a matar personas cuando lo escribes en un renglón con una cifra al lado y un asterisco a pie de página. Le pusieron IVA a mi hermano.

**(Narrador/voz en off):** Al pie del acta, una columna de firmas. No garabatos anónimos: nombres completos, cargos, rúbricas de gente que preside galas benéficas y sale en las portadas de las revistas de economía.

**Nora:** Aquí está el mal por escrito, con presupuesto y firmas. No un rumor, no un soplo: un acta. Saco el móvil y fotografío cada página, cada firma, cada número. Que no se caiga ni una coma.


### Descartes / pistas falsas — rh18
_clave S3: "rh18"_

**(Narrador/voz en off):** La noticia de que hay un acta corriendo por ahí se filtra antes del amanecer, como se filtra todo entre los que tienen algo que perder. Para media mañana, cada consejero ha llamado a su abogado y ensaya, temblando, su coartada particular.

**Nora:** Huelen la caída y se pisan unos a otros por ser el primero en decir 'yo no fui'. Vamos a ver cuántas de esas coartadas aguantan un solo empujón contra el papel.

**(Narrador/voz en off):** El primero dimite de golpe, con un comunicado lloroso sobre su 'crisis de conciencia'; no se arrepiente, solo corre más rápido que los demás hacia la salida. El segundo, de pronto, alega una demencia que su firma reciente y firme desmiente sola.

**Nora:** El tercero jura que faltó a la reunión clave; el registro de asistencia lo sienta en su silla y le pone el voto en la mano. El cuarto se declara 'mero asesor técnico sin voto', pero su voto consta, negro sobre blanco, como los otros once.

**Nora:** Y la quinta se pinta de víctima coaccionada, pobrecita, obligada a firmar. Salvo que cobró una prima por cada trimestre que el proyecto siguió en marcha. Nadie coacciona a nadie a ingresar bonus.

**Nora:** El que dimite, el 'enfermo', el 'ausente', el 'técnico', la 'víctima'. Cinco excusas distintas para una sola culpa, y todas se estrellan contra el mismo renglón. El acta no escucha coartadas: aprobado. Doce firmas, doce responsables.


### Localización B — l18b
_clave S3: "l18b"_

> **PISTA — La votación del consejo:** El contable, ya testigo, aporta el registro de la votación: el consejo aprobó Somnia por unanimidad.

**(Narrador/voz en off):** La gestoría del piso protegido huele a café de sobre y a expedientes viejos. El contable de la vieja trama, el hombre gris que un día te ayudó a hundir a otros, ahora vive con nombre falso y persianas bajadas. Le pones el acta delante y algo en su cara se enciende y se apaga a la vez.

**El contable:** Este formato lo conozco de memoria, detective. Yo archivé cientos de actas así. La misma tipografía, el mismo pie de página, el mismo sello en seco. Y para cada acta como esta hay un documento hermano que casi nadie guarda: el registro de la votación.

**Nora:** ¿Y usted lo tiene?

**El contable:** Yo tengo copias de todo lo que pasó por mis manos. Es lo único que me mantiene vivo. Aquí está. Lo recuerdo como si fuera ayer: se votó por unanimidad. Doce a favor, cero en contra. Ni un solo 'me abstengo'.

**El contable:** Aprobaron experimentar con personas como quien aprueba el color de una moqueta. Sin debate, sin una voz temblorosa. Levantaron doce manos, alguien apuntó el resultado, y luego pasaron al café y a las pastas.

**Nora:** Unanimidad. Ninguno de los doce puede sentarse ante un juez y decir 'yo me opuse, yo voté en contra'. Es la coartada perfecta al revés: en lugar de un culpable que lo niega, doce culpables que no pueden negarlo.

- *(Opción del jugador)* **«¿Cómo duerme uno después de firmar esto?»**
**Nora:** Dígame una cosa. Usted los conoció. ¿Cómo duerme uno por la noche después de levantar la mano para esto?

**El contable:** Duerme de maravilla, detective. Esa es la parte que no entenderá nunca. Cada uno se dice que su mano sola no decidió nada, que fue el consejo, que fue la mayoría, que fue el mercado. Reparten la culpa en doce trozos hasta que ninguno pesa lo suficiente para quitarle el sueño a nadie.

**Nora:** Doce trozos de nada que suman una montaña de muertos.

- *(Opción del jugador)* **«Con esto los tengo a los doce.»**
**Nora:** El acta con las firmas y su registro de la votación. Con las dos cosas los tengo a los doce a la vez. Ninguno se escurre.

**El contable:** A los doce, sí. Pero le doy un consejo gratis, de viejo que ha visto caer a muchos: cuando tenga el paquete completo, no vaya a por los doce peones. Vaya a por quien firma en la cabecera. En un consejo siempre hay una silla que pesa más que las once juntas.

**El contable:** Esa es la gracia de un consejo, detective. Reparten la culpa hasta que no pesa en ninguna conciencia. Pero el papel sí pesa. Y ahora el papel lo tiene usted. Cuídelo mejor que ellos cuidaron a sus sujetos.


### Final del caso — fin18
_clave S3: "fin18"_

> **PISTA — Deciden juntos:** El acta más la votación prueban que el consejo entero de Nyxos ordenó el proyecto: no hay un solo culpable, son todos.

**(Narrador/voz en off):** Vuelves de madrugada a la sala del consejo, vacía. La mesa de caoba se estira bajo la luz de emergencia, larga como un ataúd para doce. Cuentas las sillas: doce, altas, de respaldo capitoné, cada una con su carpeta de piel esperando a un dueño que ahora tiembla en su casa.

**Nora:** Coloco mentalmente cada firma en su silla. Aquí el que dimite, aquí la 'víctima' que cobraba primas, aquí el 'técnico sin voto'. Doce personas normales, con hijos y con hipoteca, sentadas en esta moqueta buena.

**Nora:** No busco un monstruo con nombre, ni un encapuchado, ni un doctor loco. Busco a doce personas que, sentadas en estas sillas, con el café humeando, decidieron que unas cuantas vidas valían menos que una patente. Y ni siquiera discutieron.

**Nora:** El acta y la votación lo prueban juntas: lo decidieron juntos, a mano alzada, por unanimidad. Y juntos van a responder. Solo me falta una firma. La de más arriba de todo. La que preside la mesa.

**(Narrador/voz en off):** Pasas el dedo por la cabecera de cada acta, ahí donde el resto de firmas se ordenan debajo como súbditos. Un mismo cargo se repite, impreso, en todas las páginas: 'Presidenta del Consejo y Directora Científica'. Y al lado, un solo nombre. Adler.

**Nora:** Adler. La que firma arriba y la que diseña la ciencia abajo. Preside la mesa y dirige el laboratorio. La cara entera de Nyxos cabe en esas dos líneas.


### Cierre — cierre18
_clave S3: "cierre18"_

**Nora:** Lo aprobó el consejo entero, los doce, por unanimidad. Y en la cabecera de cada acta, presidiéndolo todo, una tal Dra. Adler. Presidenta del consejo y directora científica. La cara pública de Nyxos.

**Sgto. Núñez:** Adler. La eminencia, la de los premios, la de las portadas y los discursos sobre el futuro de la medicina. La conozco de los periódicos como todo el mundo. Vaya a verla, detective Vega.

**Nora:** Por fin un rostro al que mirar a los ojos. Después de meses de sombras, de logos y de siglas, alguien a quien poder decirle a la cara lo que hicieron.

**Sgto. Núñez:** Vaya. Pero llévese una idea puesta y no la suelte: una presidenta no es lo mismo que una dueña. Preside quien pone la firma; manda quien pone el dinero. Y no siempre son la misma persona.

**Nora:** ¿Insinúa que Adler, con todo su poder, también firma por encargo de alguien?

**Sgto. Núñez:** Insinúo que mire bien esas dos líneas de la cabecera antes de creer que ha llegado al final. A veces la cara más visible es solo la que ponen delante para que dejemos de buscar. Vaya con cuidado.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 18 —  El consejo entero firmó, doce manos sobre la moqueta buena. Y al frente, un nombre por fin: la Dra. Adler. Aunque una presidenta no es lo mismo que una dueña.



## Capítulo 19 · La directora

### Briefing (comisaría) — brief19
_clave S3: "brief19"_

**(Narrador/voz en off):** La orden judicial descansa sobre la mesa de Nora como un cuchillo recién afilado: fría, legal, capaz de abrir la única puerta de Nyxos que nunca se abre. Fuera, la lluvia lame los cristales de la comisaría. Dentro, Núñez le sirve un café que ninguno de los dos va a beber.

**Sgto. Núñez:** La Dra. Adler la recibirá: le encanta que la admiren, aunque sea una detective con una orden. Sáquele todo lo que pueda. Y traiga a su hermano de vuelta si está allí.

**Nora:** Adler. La cara de Nyxos. La bata que sale en las portadas, la que da conferencias sobre el sueño mientras dormía a media ciudad para siempre. Y quizá donde tienen a Diego. Voy.

**Sgto. Núñez:** Una cosa, detective Vega. Esa mujer no se parece a los matones que ha esposado hasta ahora. No grita, no amenaza, no se pone nerviosa. Le va a hablar como si le hiciera un favor con cada palabra. No se deje encantar.

- *(Opción del jugador)* **«Voy a por ella. Y a por mi hermano.»**
**Nora:** Voy con la orden por delante y las manos limpias. Le saco lo que sepa y saco a Diego de ese sitio. En ese orden si puedo, en el otro si hace falta.

**Sgto. Núñez:** En el orden que sea, pero salga entera. Y con papeles, no con astillas.

- *(Opción del jugador)* **«¿Y si Diego no está allí?»**
**Nora:** ¿Y si me planto delante de esa mujer y mi hermano no aparece por ninguna parte? ¿Y si ya es tarde, Núñez?

**Sgto. Núñez:** Entonces le arranca a ella dónde está. Pero no vaya pensando en un funeral. Vaya pensando en abrir una puerta. Una cada vez.

**Nora:** (He subido peldaño a peldaño toda la temporada: el barrio, la clínica, el laboratorio, el consejo. Y arriba del todo espera una mujer con premios en las paredes. La última cara antes del logo. O eso creo.)


### Localización A — l19a
_clave S3: "l19a"_

> **PISTA — La directora Adler:** Adler defiende Somnia como 'progreso necesario'; se cree por encima del bien y del mal, como Vaultier.

**(Narrador/voz en off):** El despacho de la Dra. Adler es blanco, minimalista, lleno de premios. Ni un papel fuera de sitio, ni una mota de polvo, ni una sombra que no esté prevista. Huele a flores caras y a desinfectante, como un quirófano que quisiera pasar por salón. Ella te recibe como una reina que concede audiencia.

**Dra. Adler:** Detective Vega. La mujer que no se deja comprar. Qué anticuada. Y qué valiosa habría sido para la ciencia. Siéntese. Tiene usted una orden judicial y toda mi atención: es más de lo que consiguen la mayoría de mis accionistas.

**Nora:** No he venido a sentarme, doctora. He venido a mirarla a los ojos mientras le nombro a las mujeres que numeraron y depuraron en sus ensayos. La ciencia que apaga cerebros y deja los cuerpos calientes para que hagan bulto. ¿Duerme bien? Ah, no: para eso tienen ustedes su droga.

**Dra. Adler:** Duermo perfectamente, gracias. Es una de las ventajas de tener la conciencia ordenada por números y no por sentimientos. Los sentimientos, detective, son un lujo que solo se permiten quienes no cargan con decisiones difíciles.

**Dra. Adler:** Somnia salvará a millones. ¿Qué son unos pocos frente a eso? Todo gran avance se pagó con cuerpos. La anestesia, las vacunas, cada fármaco que hoy le parece un milagro empezó en un cuarto que usted llamaría horror. Yo solo llevo la contabilidad con honestidad científica.

**Nora:** La contabilidad. Personas convertidas en asientos de un libro. ¿Y usted firma las bajas con la misma mano con la que recoge esos premios de la pared?

**Dra. Adler:** Yo firmo lo que me ponen delante cuando los números cuadran. Ni una firma más, ni una menos. No soy una asesina, detective: soy una directora. Es una distinción que a usted, con su placa y su rabia, se le escapa.

**Nora:** (Ahí está. La misma soberbia glacial de Vaultier, pero con bata en vez de esmoquin. Se cree por encima del bien y del mal, un motor del progreso. Y sin embargo... escúchala. 'Firmo lo que me ponen delante.' 'Llevo la contabilidad.' Habla como quien ejecuta, no como quien manda del todo. No ha dicho una sola vez 'yo decido'.)

**Nora:** Le voy a hacer una pregunta rara, doctora. Cuando se aprobó Somnia, cuando se decidió usar personas... ¿quién dijo que sí? ¿Usted, o alguien por encima de usted?

**Dra. Adler:** Qué pregunta más impertinente. Y qué reveladora de su ingenuidad. Yo dirijo la ciencia, detective. La ciencia no manda: sirve. Pero eso no lo va a entender hoy. Registre lo que quiera. No encontrará una sola cosa que no esté, técnicamente, en regla.


### Descartes / pistas falsas — rh19
_clave S3: "rh19"_

**(Narrador/voz en off):** Fuera del despacho blanco, en la planta noble de Nyxos, la vida corporativa fluye pulcra y silenciosa. Alrededor de Adler orbitan cinco figuras que parecen mandar: saludan, sonríen, firman carpetas al vuelo. Nora las estudia una a una y comprende que son satélites, no sol.

**Nora:** Jefe de prensa, secretario, médico estrella de congresos, jefa de ventas, accionista de las fotos. Cinco personas que parecen tocar el poder con la punta de los dedos. Vamos a ver de qué están hechas.

**(Narrador/voz en off):** El jefe de prensa habla como si moviera los hilos del mundo, pero solo maquilla notas que le bajan ya escritas. El secretario domina cada minuto de la agenda de Adler y ni un solo gramo de sus decisiones. El médico estrella pone su cara guapa en los congresos: un maniquí con bata que repite un guion que no ha leído entero.

**Nora:** La jefa de ventas coloca Somnia en hospitales a golpe de comisión; vende el horror sin haberlo diseñado. Y el accionista que sale en todas las galas es un testaferro: presta su cara a unos accionistas de verdad que nunca se dejan fotografiar. Cinco puertas. Cinco reflejos. Todos brillan por la luz de otro.

**Nora:** Y aquí está lo que me hiela: la luz no está ni siquiera en Adler del todo. Ella también ejecuta. Por encima de su bata blanca hay un consejo que decide en nombre de los accionistas. El culpable de este caso no tiene cara. Tiene logo.


### Localización B — l19b
_clave S3: "l19b"_

> **PISTA — El proyecto Somnia:** Rescatas a Diego de una sala de Nyxos; entre sus papeles, el plan completo de Somnia... y una firma por encima de Adler.

**(Narrador/voz en off):** Al fondo de la planta, una puerta sin rótulo que la tarjeta de Marco abre con un chasquido seco. Dentro, penumbra y el zumbido de una máquina. En una camilla, bajo una manta térmica, un cuerpo delgado que sube y baja despacio. Nora conoce esa respiración: la ha oído en la habitación de al lado toda su infancia.

**Nora:** Diego. Diego, soy yo. Estoy aquí. Abre los ojos, hermano, por favor.

**(Narrador/voz en off):** Le aparta el pelo de la frente. Está sedado, lejos, pero vivo: la aguja de un gotero le entra en el brazo con la misma serpiente impresa en la bolsa. Le retira la vía con cuidado, como si desactivara una bomba, y lo incorpora contra su hombro.

**Diego Vega:** ¿Nora...? Sabía que vendrías. Siempre vienes. Aunque llegues tarde y de mal humor, siempre vienes. Coge... coge la carpeta azul. La escondí para ti, debajo del colchón. Es 'el plan entero'. Lo vi cuando creían que dormía. Yo escuchaba, hermana. Escuchaba con los ojos cerrados.

**Nora:** Te tengo, hermano. Ya está. No te esfuerces. Vamos a casa.

- *(Opción del jugador)* **Sacarlo ya, la carpeta después**
**Nora:** La carpeta puede esperar. Tú no. Primero te saco de aquí, luego leo lo que haga falta.

**Diego Vega:** No, Nora. Escúchame por una vez en tu vida. Coge la carpeta. Si me sacas a mí y dejas eso, mañana meten a otro en esta camilla. Yo salgo contigo o con la carpeta, pero la carpeta sale seguro.

**Nora:** (Está roto, sedado, y aun así piensa en los que vienen detrás. Mi hermano pequeño. Qué poco lo he mirado.) Está bien. Las dos cosas. No suelto ninguna.

- *(Opción del jugador)* **Prometerle que se acabó**
**Nora:** Escúchame, Diego. Esta es la última camilla. La última aguja. Te lo juro por lo que quieras. No vuelves a estar solo ni una noche más.

**Diego Vega:** No jures, Nora. Tú siempre juras y luego llega un caso. Solo... solo sácame. Y agárrate a esa carpeta como te agarrabas a mí cuando había tormenta.

**Nora:** Esta vez el caso y tú sois lo mismo. Por primera vez. Vamos.

**(Narrador/voz en off):** En la carpeta azul, el plan completo del Proyecto Somnia: fórmulas, fases, presupuestos, un mapa entero del horror con membrete corporativo. Y en la última página, sobre la firma de Adler, otra escrita a máquina, fría, sin rúbrica personal: 'Aprobado por el Consejo — en representación de los accionistas'.

**Nora:** Adler no es la dueña. Es la ejecutora. Por encima de ella está el consejo, y por encima del consejo... la propia empresa. Los accionistas. Nyxos entera.

**Diego Vega:** Te lo dije, hermana. Yo escuchaba. Nadie mandaba. Todos... firmaban. Como si el horror fuera un formulario que va pasando de mesa en mesa hasta que ya no es de nadie.


### Final del caso — fin19
_clave S3: "fin19"_

> **PISTA — Adler no está sola:** El plan revela que Adler solo cumple: el proyecto Somnia lo sostiene y financia el consejo en nombre de los accionistas. El culpable es la corporación.

**(Narrador/voz en off):** Con Diego a salvo en manos de Marco al final del pasillo y la carpeta azul apretada contra el pecho, Nora vuelve a entrar en el despacho blanco. Adler no se ha movido de su sillón. Levanta la vista de un informe con la calma de quien ya sabe lo que va a oír.

**Nora:** Usted no inventó esto por maldad propia, doctora. Lo hizo porque el consejo lo aprobó, porque los accionistas lo exigían, porque a la empresa le salía a cuenta. Su firma es la penúltima. Encima hay otra, y esa no tiene nombre: tiene un sello.

**Dra. Adler:** ...Por fin alguien lo entiende. Llevo veinte años esperando que alguien mire ese papel y lea la línea de arriba en vez de la mía. Yo soy sustituible, detective. Si caigo yo, mañana hay otra bata firmando lo mismo, en este mismo despacho, con mis mismos premios en la pared.

**Dra. Adler:** El proyecto no soy yo: es Nyxos. Siempre fue Nyxos. Yo pongo la cara, la ciencia y la firma. Pero la voluntad que sostiene todo esto no cabe en una persona. Es una máquina de decidir sin culpables. Ese es su verdadero enemigo, y no lo puede esposar.

**Nora:** (Quería una villana con nombre para poder odiarla y dormir tranquila. Y me dan una estructura. Una bestia sin cabeza que si le cortas una, le crece otra idéntica. Ella lo sabe. Y casi lo dice con alivio, como quien confiesa que nunca fue del todo suya la culpa.)

**Nora:** Entonces no me llevo una cabeza, doctora. Me llevo a la bestia entera. Voy a hacer caer a la corporación, no a un chivo expiatorio con premios. A usted, al consejo, a los accionistas de las fotos y a los que no salen en ninguna. A Nyxos completa.

**Dra. Adler:** Ambiciosa. Como yo a su edad. Le deseo suerte, detective: la va a necesitar toda. Una corporación no se cae empujándola. Se cae con una jugada perfecta, ejecutada de golpe, sin darle tiempo a sus abogados a respirar. ¿Sabe usted hacer algo así? Yo, francamente, lo dudo.

**Nora:** Sola, no. Pero hace tiempo que dejé de hacer las cosas sola. Ese es el error que ustedes nunca entendieron: cuentan personas de una en una. Y yo tengo un equipo.


### Cierre — cierre19
_clave S3: "cierre19"_

**(Narrador/voz en off):** De vuelta en la comisaría, Diego duerme por fin un sueño de verdad en un catre del fondo, tapado con la chaqueta de Núñez. Nora deja la carpeta azul sobre la mesa como quien deposita una bomba desactivada. El sargento la abre por la última página y lee la línea sobre la firma de Adler.

**Nora:** Adler caerá, pero es intercambiable. El culpable no es una persona: es Nyxos como estructura. Consejo, accionistas, una máquina de firmar horrores sin que nadie se manche. Y contra una corporación entera no me vale una orden más ni una redada más. Necesito una jugada perfecta.

**Sgto. Núñez:** Entonces reúnalos a todos, detective Vega: sus pruebas, sus testigos, sus aliados. Un solo golpe, a la vez, que ningún abogado pueda deshacer. Mañana. En su propia casa.

**Nora:** Sonia con la ciencia, Clara con la ley, Vera con la portada, Rubén con la memoria, Marco con las llaves. Y Diego, vivo, como prueba de que sobrevivieron. Todos a la vez, o nada.

**(Narrador/voz en off):** — FIN DEL CAPÍTULO 19 —  El monstruo no tiene una cara: tiene un logo. Y Nora está lista para el golpe final.



## Capítulo 20 · Nyxos

### Briefing (comisaría) — brief20
_clave S3: "brief20"_

**(Narrador/voz en off):** El día del golpe final amanece sin lluvia, y eso, después de tantos meses, casi asusta. La comisaría no huele a café rancio ni a expediente muerto: huele a gente. La sala de reuniones está llena por primera vez en veinte casos. Sonia despliega sus informes forenses en un abanico limpio. Clara ordena carpetas con lomo de bufete caro. Vera afila un lápiz sobre una maqueta de portada. Rubén, jubilado y castizo, ha traído su vieja agenda de tapas gastadas. Marco, todavía con el uniforme de seguridad de Nyxos, suda una lealtad que por fin ha cambiado de bando. Y en una silla, con una manta sobre las piernas, Diego se recupera y mira a su hermana como quien mira amanecer.

**Nora:** Nunca creí que diría esto en una comisaría, y menos con testigos: gracias. A todos. A cada uno. Hoy no entra Nora Vega en Nyxos. Hoy entramos todos, con todo lo que cada uno trae bajo el brazo.

**Sgto. Núñez:** Doce sillas, una corporación, un país entero mirando por encima del hombro. Que no se nos escape ni una firma, ni una coma, ni un chivo expiatorio de última hora. Esta gente ha comprado jueces con menos. Adelante, detective. Es su golpe.

**Insp. Rubén:** A mí me jubilaron por preguntar demasiado, criatura. Veinte años callando en un banco del parque. Hoy vengo a ver cómo alguien acaba la pregunta que a mí me costó la placa. No me lo perdería por nada.

**Nora:** (Cinco personas en una sala, dispuestas a quemarse conmigo. Yo que empecé este hilo sola, con una campana robada y una tormenta. Nunca resolví nada sola. Hoy menos que nunca.)

- *(Opción del jugador)* **«Vamos a hacerlo por el libro, hasta la última página.»**
**Nora:** Escuchadme bien. Esta gente sobrevive a todo menos a un procedimiento perfecto. Nada de atajos, nada de puertas forzadas. Cada prueba blindada, cada firma en su sitio. Los tumbamos por el libro, hasta la última página.

**Clara:** Esa es la Nora que llevo catorce meses esperando oír. Por fin. Yo pongo las páginas. Tú, por una vez, no las rompas.

- *(Opción del jugador)* **«Que uno de esos doce entienda lo que hizo. Con eso me basta.»**
**Nora:** No os voy a mentir. Quiero verlos caer, sí. Pero quiero algo más raro: que al menos uno de esos doce, cuando le pongamos las pruebas delante, entienda de verdad lo que firmó. Que no todo sea papeleo.

**Sonia:** Eso no lo garantiza ninguna cadena de custodia, detective. Pero mira a Marco. A veces pasa. A veces uno despierta.

**Nora:** Se acabó tirar del hilo en la oscuridad. Hoy encendemos todas las luces a la vez. Que Nyxos nos vea llegar.


### Localización A — l20a
_clave S3: "l20a"_

> **PISTA — La cúpula entera:** Con Marco dentro y Clara con la orden, se cita al consejo AL COMPLETO: por primera vez, los doce en una sala controlada.

**(Narrador/voz en off):** La sala del consejo de Nyxos es un templo de cristal ahumado y madera negra, treinta pisos sobre la ciudad. Doce sillones de piel rodean una mesa larga como un ataúd de reyes. En cada plaza, una carpeta con el logo grabado en seco: la serpiente enroscada en la copa. Fuera, la tormenta que faltaba empieza a amontonarse sobre los rascacielos. Dentro, huele a ambientador caro y a miedo educado.

**(Narrador/voz en off):** Uno a uno, los doce van entrando, convencidos de que vienen a negociar. Marco, con su tarjeta de acceso, ha dejado abiertas todas las puertas justas. Clara, con la citación firmada, ha cerrado todas las salidas.

**Nora:** Doce sillas. Doce firmas en el acta. Doce responsables sentados a la vez, por primera y última vez. Ninguno podrá levantarse mañana y señalar al de al lado, porque hoy están todos al alcance de la misma mano.

**Marco:** Los tengo controlados en la sala, Nora. Cámaras mías, puertas mías. Durante años abrí estas puertas para que entraran las víctimas. Hoy las abro para que no salga ni uno de ellos. Es lo menos que puedo hacer.

**Clara:** Legalmente, tenerlos a los doce en la misma sala con las pruebas encima de la mesa es la jugada de mi carrera. Un consejo entero, en cuerpo presente, notificado en regla. No dejes que ninguno se levante, Nora. Ni para ir al baño.

**Nora:** (Doce personas que decidieron por votación que unas vidas valían menos que un balance trimestral. Y ahí están, con sus relojes y sus corbatas, como si esto fuera otra junta de accionistas.)

- *(Opción del jugador)* **Entrar en frío, institucional, de usted**
**Nora:** Buenos días. Soy la detective Vega. Están todos citados en calidad de miembros del consejo de administración de Nyxos Pharma. Les ruego que no abandonen la sala. Lo que va a pasar aquí quedará grabado.

**Clara:** Perfecto. Fría, correcta, imposible de recusar. Que conste en acta cada palabra que digan a partir de ahora.

- *(Opción del jugador)* **Mirarlos a los ojos, uno por uno, antes de hablar**
**(Narrador/voz en off):** Antes de decir nada, Nora recorre la mesa con la mirada, silla por silla, cara por cara. Doce pares de ojos que aprenden, despacio, que esto no es una negociación.

**Nora:** Quería veros las caras antes. Solo eso. Las caras de los que firman lo que otros ejecutan. Ya está. Ahora podemos empezar.


### Descartes / pistas falsas — rh20
_clave S3: "rh20"_

**(Narrador/voz en off):** En una antesala acristalada, mientras Clara prepara la notificación, los abogados de Nyxos abren su última defensa como quien reparte cartas marcadas. No niegan el crimen: ofrecen un culpable. Y luego otro. Y otro. Cinco figuras de usar y tirar, servidas en bandeja para que la máquina siga girando.

**Nora:** Miralos venir. Primero el directivo mártir, que sale con un guion aprendido y se declara único responsable de todo, como si un hombre solo pudiera montar esto. Luego Kessler, el científico loco, la mente enferma y aislada; el pobre Kessler, que no era más que un recadero con bata.

**Nora:** Después la filial rebelde, esa sucursal descontrolada que actuó por su cuenta; salvo que todas las órdenes salían de la central, con membrete. Luego el error de sistema, un fallo de protocolo sin nombre y sin cara; salvo que el acta lo firmaron doce manos. Y por último el difunto: le cuelgan todo a Vaultier, que ya está caído y no protesta. Muerto el perro, viva la empresa.

**Clara:** Es un manual, Nora. Se llama contención de daños. Te ofrecen una cabeza para que sueltes el cuerpo. Si muerdes cualquiera de las cinco, mañana Nyxos abre otra vez con nombre nuevo y logo nuevo.

**Nora:** No compro ninguno. Ni el mártir, ni el loco, ni la filial, ni el error, ni el muerto. Es el mismo truco que usaron con sus víctimas: convertir a una persona en el residuo de un sistema. Si acepto un culpable, mañana hay otro Somnia con otras siglas.

**Nora:** El acusado no es un hombre. Es la corporación entera. Y va a caer entera, del portero al presidente, sin un solo chivo expiatorio que le sirva de coartada.


### Localización B — l20b
_clave S3: "l20b"_

> **PISTA — Todas las piezas:** Cada aliado aporta su prueba: forense (Sonia), legal (Clara), prensa (Vera), testigo (Irene), interna (Marco). Juntas, son irrefutables.

**(Narrador/voz en off):** De vuelta en la comisaría, la mesa larga se llena de pruebas como un altar. Cada aliado deja lo suyo y explica lo suyo, y por primera vez las piezas no se contradicen: encajan. La lluvia empieza a golpear los cristales; nadie la oye.

**Sonia:** Lo forense es mío y es de hierro. Somnia, la misma molécula, en cada víctima analizada. Cadena de custodia impecable, sellada, cotejada dos veces. No hay perito en el mundo que la discuta sin quedar en ridículo. Que lo intenten.

**Clara:** Lo legal lo pongo yo. El acta del consejo, la votación unánime que aprobó 'depurar' el proyecto, los consentimientos falsos con notario inexistente, la trama que sube hasta el nivel nacional. Doce imputaciones, Nora, no una. Nombre por nombre, firma por firma.

**Vera Lang:** Lo público es cosa mía, y sale mañana a primera hora. Portada a cinco columnas. Y no la firmo yo sola: la firma Irene. La superviviente. Con su nombre, con su cara, contando lo que le hicieron. Se acabó lo de 'esa mujer delira'. Cuando media ciudad lea su nombre en el desayuno, ya no hay abogado que lo entierre.

**Testigo:** Nadie me creyó durante dos años, detective. Me llamaron loca, confundida, histérica. Mañana lo cuento yo, con mi nombre entero, y que me lean todos los que miraron para otro lado. Ya no tengo miedo. Usted me quitó el miedo.

**Marco:** Y lo de dentro lo firmo yo, con mi puño. Los accesos, los turnos, quién entraba y quién salía, y la orden. La orden de 'depurar', escrita, con su cadena de mando. Firmo mi declaración aquí y ahora, Nora. Me hundo con ellos si hace falta, pero vuelvo a ser de los buenos.

**Nora:** Cinco piezas, una sola imagen. Por separado, Nyxos las parte con un soplido: un perito, un recurso, una rueda de prensa. Juntas, ni todos sus abogados las levantan del suelo. Es la hora.

- *(Opción del jugador)* **Agradecer a Marco el paso que ha dado**
**Nora:** Marco. Sé lo que te cuesta esa firma. Tu nómina, tu nombre, quince años de otra vida. No te lo pedí. Lo has hecho tú.

**Marco:** Me lo debía a mí, Nora. Y a toda la gente a la que abrí la puerta sin preguntar. Un hombre no puede pasarse la vida abriendo puertas equivocadas.

- *(Opción del jugador)* **Prometer a Irene que su nombre sale primero**
**Nora:** Irene, escúcheme. En ese titular, el primer nombre no es Nyxos ni el mío. Es el suyo. Los demás son los que la creyeron tarde. Usted es la que sobrevivió para contarlo.

**Testigo:** Gracias. Durante dos años fui un número en un archivo. Mañana vuelvo a ser una persona con nombre. Eso ya no me lo quita nadie.

**Nora:** Cerrad las carpetas. Nos vamos a Nyxos. Es hora de que la serpiente vea de cerca a quienes convirtió en números.


### Final del caso — fin20
_clave S3: "fin20"_

> **PISTA — La prueba definitiva:** En la azotea de Nyxos, ante la cúpula, Nora expone que el culpable es la corporación entera; con las pruebas de todos, cae Nyxos.

**(Narrador/voz en off):** La confrontación final no es en un sótano ni en un campanario: es en la azotea de la torre de Nyxos, treinta y dos pisos de acero mordidos por la última tormenta del arco. El viento arranca las palabras de la boca antes de decirlas. La lluvia cae de lado, plateada bajo los focos rojos de las antenas, y golpea los rostros de la cúpula como si también ella hubiera venido a acusar. Abajo, muy abajo, la ciudad entera late en luces mojadas: mil ventanas, mil testigos que no saben que lo son. Sobre la gran pantalla publicitaria de la fachada, apagada por primera vez, esperan las pruebas de todos.

**(Narrador/voz en off):** La Dra. Adler avanza hasta el borde, impecable pese al agua, el pelo pegado a la sien, la soberbia intacta. No huye. La gente como ella no huye: negocia.

**Dra. Adler:** ¿Va a detenernos a todos, detective? ¿A una empresa entera? Piénselo bien. Una empresa no cabe en una celda. No tiene muñecas que esposar ni cuello que ahorcar. Nyxos es una idea, y las ideas no caben en sus calabozos.

**Nora:** No. Tiene razón. Una empresa no cabe en una celda. Pero cabe en un titular, cabe en un sumario y cabe, entera, en la ruina. Ustedes convirtieron a personas en números para que Nyxos ganara un punto en bolsa. Hoy Nyxos se convierte en el número de un caso. Cerrado.

**Dra. Adler:** Somnia era progreso. Dormir sin soñar, apagar el dolor. La historia me dará la razón cuando usted no sea ni una nota a pie de página.

**Nora:** Progreso. Diego, mi hermano, decía que Somnia lo apagaba como a una lámpara. Eso no es dormir, doctora. Eso es estar muerto sin el descanso de estarlo. Y usted lo sabía en cada acta que votó.

**(Narrador/voz en off):** Nora levanta la mano, y sobre la gran pantalla de la fachada, encarada a toda la ciudad, se enciende la imagen. Una a una, las pruebas suben a la luz bajo la lluvia: los informes de Sonia, el acta de Clara con las doce firmas, la portada de Vera con el nombre de Irene, los accesos de Marco, la cara serena de la superviviente. La cúpula entera, iluminada por sus propios crímenes, empieza a deshacerse. Uno afloja la corbata. Otro busca a su abogado con los ojos. Un tercero, sin más, se sienta en el suelo mojado.

**Dra. Adler:** No pueden probar que yo... que fue una decisión mía. Fue un órgano colegiado. Fue un voto. Fue de todos.

**Nora:** Exacto. Fue de todos. Ese es justo el punto, doctora. No busco a un monstruo con nombre. Nunca lo busqué. Durante veinte casos perseguí sombras: un mecenas, un párroco, un contable, un magnate. Y al final del hilo no había un hombre. Había una MÁQUINA. Y a las máquinas no se las convence ni se las detiene: se las para. Se acabó Somnia. Se acabó Nyxos.

- *(Opción del jugador)* **Dejar que la lluvia hable por ella**
**(Narrador/voz en off):** Nora no dice nada más. Baja la mano, se sube el cuello del abrigo empapado y deja que la tormenta remate la frase. Los focos rojos parpadean sobre doce rostros que ya no gobiernan nada. La cúpula ha caído sin que nadie la empuje.

**Nora:** (Ya está. Ni un grito, ni una esposa de más. Solo hechos, y la lluvia lavándolo todo por una vez de verdad. Se lo debía a las del archivo. A todas.)

- *(Opción del jugador)* **Mirar a Adler y darle la última palabra a las víctimas**
**Nora:** Una última cosa, doctora. Las mujeres a las que llamó residuo tenían nombre. Irene tiene nombre. Y mañana lo va a leer usted en la portada, encima del suyo. Para siempre.

**Dra. Adler:** ...Váyase al infierno, detective.

**Nora:** Ya vengo de ahí. Lo he tenido montado en su torre treinta pisos. Buenas noches, doctora.

**(Narrador/voz en off):** La lluvia arrecia sobre la azotea, limpiando por una vez de verdad. Los agentes de Núñez suben por las escaleras y rodean a la cúpula sin resistencia. Abajo, veinte casos, seis tormentas, un solo hilo tejido desde una campana robada hasta una corporación entera: por fin cortado de raíz, en lo más alto, bajo el agua.


### Cierre — cierre20
_clave S3: "cierre20"_

**(Narrador/voz en off):** Nyxos se desmorona en los tribunales durante meses, sociedad por sociedad, firma por firma, tal como prometió Clara. El proyecto Somnia se cancela y se destruye bajo control judicial. Los supervivientes recuperan su nombre en los registros; las familias, por fin, una tumba con letras de verdad y una verdad que no cabía en ningún parte de desaparición. La comisaría, esta noche, huele a papel cerrado y a algo que hacía años no se olía aquí: a final bueno.

**Diego Vega:** Estoy limpio, Nora. De verdad esta vez. Sin pastillas, con noches malas de las normales, de las que se pasan durmiendo poco y viviendo mucho. Y es por ti. Perdón por haber sido tu talón de Aquiles todo este tiempo. Por haberte dado un motivo para que te comieran.

**Nora:** Nunca fuiste mi debilidad, Diego. Métetelo en la cabeza dura que tienes. Fuiste mi motivo. Cada vez que quise soltar el hilo y mirar para otro lado, estabas tú al final de él. Sin ti, quizá me habría comprado hace veinte casos.

**Insp. Rubén:** Veinte años me costó a mí no acabar la pregunta, criatura. A ti te ha costado veinte casos acabarla. Bien empleados están. Ahora hazme caso de viejo: no dejes que el trabajo te quite lo que acabas de recuperar.

**Clara:** Por una vez lo hiciste todo por el libro, Vega. Hasta la última página. No sabes lo raro que es verte ganar limpio. Casi me caes bien y todo.

**Sonia:** ¿Y ahora qué, detective? ¿Descanso de verdad, o te busco otro cadáver para el lunes?

**Nora:** Ahora una copa con vosotros, que os la debo desde hace seis tormentas. Sonia, Clara, Vera, Rubén, Marco, Diego. Escuchadme bien, porque no lo repito: nunca resolví nada sola. Ni un caso. Solo fui la que no se rindió mientras vosotros sosteníais todo lo demás. El hilo era mío. La red erais vosotros.

**Vera Lang:** Eso, detective, deja que lo escriba yo. Sin tu nombre en grande, si quieres. Pero que quede escrito.

**Sgto. Núñez:** Descanse, detective Vega. Se lo ha ganado como pocos. Váyase a casa, apague el móvil, duerma sin nombre de caso en la cabeza. Hasta la próxima tormenta.

**Nora:** Hasta la próxima tormenta, sargento. Pero esta noche, que llueva donde quiera. Yo tengo una copa pendiente.

**(Narrador/voz en off):** — FIN —  Veinte casos. Un solo hilo, desde una campana robada hasta una corporación entera. Nora Vega apaga la luz de la comisaría y sale con los suyos. Fuera, por primera vez en mucho tiempo, no llueve. Sobre el asfalto seco, las farolas dibujan un camino que, por una noche, no lleva a ningún crimen. sOC.



---

## Apéndice · Texto de las mini-escenas interactivas (`const INTERACT`)

_Ambientación (intro), pista revelada y, en escenas de "presentar prueba", las frases del sospechoso. Los textos de los puntos calientes (hotspots) se omiten por ser descripciones de UI repetitivas._

### `l0a` (search)
- **Intro:** MECANICA - BUSQUEDA: examina la PLAZA. Toca lo que te llame la atencion.
- **Pista:** *Leer el escenario* — Un charco reflejaba a alguien huyendo: se aprende a leer la escena.
- **Revelación:** Una pista! Se guarda sola en tu libreta (arriba a la derecha).

### `rh0` (examine)
- **Intro:** MECÁNICA · EXAMINAR: usa +/− (o la rueda) para acercarte y arrastra. Busca el detalle.
- **Pista:** *El detalle del callejón* — Una marca grabada en la pared: el sello de una serpiente. Fácil de pasar por alto.

### `l0b` (puzzle)
- **Intro:** MECÁNICA · PUZZLE: el cajón del mostrador está cerrado. Marca el código del recibo.
- **Pista:** *Tirar del hilo* — Dentro del cajón, el hilo que conecta el caso. Con esta ya tienes las dos pistas.

### `l0c` (present)
- **Intro:** MECÁNICA · PRESENTAR PRUEBA: escucha al sospechoso y toca la frase que es MENTIRA.
- **Sospechoso (frases, presentar prueba):**
  - "Yo esa noche no pisé la plaza." *(MENTIRA)*
  - "No sé nada de ninguna investigación."
  - "Estuve en casa durmiendo."

### `fin0` (deduce)
- **Intro:** MECÁNICA · DEDUCCIÓN: une las pistas. ¿Qué se deduce de ellas?

### `plaza` (search)
- **Intro:** Acabas de llegar. Lee la PLAZA antes de moverte: que desentona?
- **Pista:** *El reflejo en el charco* — En el gran charco del centro se recorta, borrosa, una figura que se aleja hacia el fondo: alguien cruzo la plaza con prisa esa noche.
- **Revelación:** Anotado. Alguien cruzo la plaza deprisa esa noche.

### `casa_marta` (search)
- **Intro:** Estas en la CASA DE MARTA. Registrala con calma: algo se salio de la rutina.
- **Pista:** *La taza a medias* — Sobre la mesita, una taza de cafe a medias y ya fria, con papeles al lado. Marta salio sin terminarla, con prisa.
- **Revelación:** Anotado. Marta salio de casa con prisa y sin plan.

### `refugio` (search)
- **Intro:** FUNDACION AMPARO. Antes de que te acompanen, mira alrededor: no todo cuadra.
- **Pista:** *El registro tachado* — En el mostrador, un libro de acogidas abierto con varios nombres tachados con la misma tinta. Como si nunca hubieran estado.
- **Revelación:** Anotado. Alguien borra a personas del registro del refugio.

### `capilla` (search)
- **Intro:** La CAPILLA PRIVADA bajo la Fundacion. Examinala: alguien ha estado aqui hace poco.
- **Pista:** *Cera fresca* — Los cirios de la pared aun gotean cera tibia. Esta capilla que dicen cerrada se usa a diario.
- **Revelación:** Anotado. La capilla cerrada se usa en secreto.

### `mansion` (search)
- **Intro:** La MANSION del mecenas. Fijate bien antes de que aparezca nadie.
- **Pista:** *El cuadro torcido* — Un cuadro cuelga torcido; detras asoma el rectangulo limpio, sin polvo, de otro que ya no esta. Falta una pieza de la coleccion.
- **Revelación:** Anotado. De la coleccion falta algo, y hace poco.

### `sotano` (search)
- **Intro:** EL SOTANO de la mansion. Con cuidado: aqui paso algo.
- **Pista:** *Aranazos en la reja* — En los barrotes de la reja, aranazos a la altura de unas manos por dentro. Aqui encerraron a alguien.
- **Revelación:** Anotado. Aqui retuvieron a alguien contra su voluntad.

### `escena4` (search)
- **Intro:** La IGLESIA DE LA MERCED, aun acordonada. Recorrela: el metodo se repite, pero hay algo nuevo.
- **Pista:** *El lacre en el suelo* — En el suelo, al pie de la escalera, una gota de lacre rojo endurecido. Una firma nueva sobre un metodo viejo.
- **Revelación:** Anotado. El secuestrador ha dejado su sello propio.

### `trastienda` (search)
- **Intro:** La TRASTIENDA del salon. Rapido, antes de que vuelvan: aqui se guarda lo que no se ensena.
- **Pista:** *El cuaderno de pujas* — Sobre el escritorio, medio tapado, un cuaderno con pujas y apodos. Nadie apunta esto por gusto.
- **Revelación:** Anotado. Hay un registro de la subasta y de quien puja.

### `coartada` (search)
- **Intro:** La MANSION VAULTIER. Su coartada dice una cosa; la casa, quiza otra.
- **Pista:** *La escalera a la azotea* — La escalera privada que sube a la azotea tiene el polvo pisado: alguien sube ahi las noches senaladas, cuando dice estar en sus galas.
- **Revelación:** Anotado. Vaultier no estaba donde dice esas noches.

### `l7a` (search)
- **Intro:** La MORGUE. Mientras Sonia prepara el cuerpo, mira alrededor: algo no cuadra en el papeleo.
- **Pista:** *El informe corregido* — En el mostrador central, un informe de autopsia con una linea tachada y reescrita por otra mano.
- **Revelación:** Anotado. Alguien altero el informe forense.

### `l8a` (search)
- **Intro:** El PISO DE DIEGO. Con el corazon encogido, registra: necesitas saber hasta donde llega.
- **Pista:** *Los blisters vacios* — En el cajon de la mesilla, blisters de Somnia vacios, escondidos. Mas de los que un tratamiento explica.
- **Revelación:** Anotado. Diego consume mucho mas de lo recetado.

### `l9a` (search)
- **Intro:** El BUFETE DE CLARA. Entre sus papeles hay algo que ni ella sabe que guarda.
- **Pista:** *El expediente sellado* — Sobre el escritorio, un expediente abierto con el sello de consentimiento y una firma que no coincide con la del paciente.
- **Revelación:** Anotado. Los consentimientos estan falsificados.

### `l10a` (search)
- **Intro:** El LABORATORIO NYXOS. Todo reluce. Fijate en lo que la limpieza no borro.
- **Pista:** *El albaran interno* — Sobre una mesa, un albaran con el logo de Nyxos: numera lotes... y uno lleva iniciales de personas.
- **Revelación:** Anotado. Nyxos etiqueta personas como lotes.

### `l11a` (search)
- **Intro:** El BARRIO ALTO. Tras las verjas, el dinero se mueve en silencio. Busca su rastro.
- **Pista:** *El coche sin matricula* — Un coche de gama alta parado en la calle sin matricula y con el capo tibio: alguien acaba de entregar algo en mano aqui.
- **Revelación:** Anotado. Reparten dinero a domicilio, sin nombres.

### `l12a` (search)
- **Intro:** La REDACCION. Vera confia en ti; su mesa, sin querer, cuenta mas.
- **Pista:** *El post-it garabateado* — Pegado bajo el monitor de Vera, un post-it con una hora y un muelle. Una cita a ciegas.
- **Revelación:** Anotado. Hay una cita secreta anotada al vuelo.

### `l13a` (search)
- **Intro:** El ARCHIVO MEDICO. Filas de expedientes. Uno desentona por lo que le falta.
- **Pista:** *La ficha sin nombre* — En una caja del estante, una ficha clinica con numero de sujeto pero sin nombre. Alguien prefirio que no lo tuviera.
- **Revelación:** Anotado. Hay pacientes reducidos a un numero.

### `l14a` (search)
- **Intro:** El PUEBLO DE LA COSTA. Aire salado y silencio de mas. Mira lo que nadie mira.
- **Pista:** *La barca de mas* — Una barca amarrada junto al muelle con correas y lonas nuevas, impropias de un pescador: aqui no se pesca, se transporta.
- **Revelación:** Anotado. Mueven carga -o personas- por mar.

### `l15a` (search)
- **Intro:** El PUEBLO DE MONTANA. Frio y aislado, perfecto para esconder. Registra con calma.
- **Pista:** *El sanatorio de lo alto* — En lo alto de la loma, un edificio aislado con una chimenea humeando toda la noche. De ese sanatorio nadie sale con el alta de verdad.
- **Revelación:** Anotado. El sanatorio esconde a quienes no salen.

### `l16a` (search)
- **Intro:** OTRA CIUDAD, misma sombra. Compara lo que ves con lo que ya conoces.
- **Pista:** *El mismo cartel* — En una fachada, el mismo logotipo de Nyxos que en tu ciudad, con la serpiente. No es casualidad: es una cadena.
- **Revelación:** Anotado. Nyxos replica el mismo montaje en otras ciudades.

### `l17a` (search)
- **Intro:** EL BAR DE CLARA. Una copa tranquila... o eso parece. Fijate en lo que sobra.
- **Pista:** *La tarjeta olvidada* — Bajo la barra, junto a las botellas, la tarjeta de un bufete que arregla problemas. Alguien la dejo para ti.
- **Revelación:** Anotado. Te estan tanteando con un intermediario.

### `l18a` (search)
- **Intro:** LA SEDE DE NYXOS. Pasillos de cristal. Lo que falta grita mas que lo que hay.
- **Pista:** *El acta incompleta* — Sobre un escritorio, un acta del consejo con un punto del orden del dia arrancado. Justo el que importaba.
- **Revelación:** Anotado. Han mutilado el acta del consejo.

### `l19a` (search)
- **Intro:** EL DESPACHO DE ADLER. La cara de Nyxos. Su despacho la delata mejor que sus palabras.
- **Pista:** *La foto recortada* — En el escritorio de Adler, una foto de grupo del consejo con una cara recortada a conciencia.
- **Revelación:** Anotado. Adler borra a alguien de la foto oficial.

### `l20a` (search)
- **Intro:** LA SALA DEL CONSEJO. La cupula al completo. Esta vez, que quede grabado.
- **Pista:** *La grabadora oculta* — Encajada bajo el borde de la mesa del consejo, una grabadora que alguien dejo corriendo. La prueba definitiva puede estar aqui.
- **Revelación:** Anotado. Puede que la prueba definitiva ya se este grabando.
