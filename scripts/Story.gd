extends RefCounted
class_name Story
## Contenido narrativo de "sOC the Game" (formato novela visual + mapa).
##
## Aqui vive TODO el guion jugable: el reparto (retratos), los fondos de las
## escenas, las localizaciones del mapa y los dialogos de cada una. Editar este
## archivo es editar el juego; no hace falta tocar la logica de las escenas.
##
## FORMATO DE UN DIALOGO (Dictionary):
##   {
##     "bg": "iglesia_ext",                 # fondo inicial (clave de BGS)
##     "clue": {"title": "...", "text": "..."},   # pista que se anota al terminar (opcional)
##     "flag": "cap1_completo",             # bandera que se activa al terminar (opcional)
##     "beats": [ ...beats... ]             # secuencia de la escena
##   }
##
## FORMATO DE UN BEAT:
##   Linea:  {"who": "emilio", "text": "...", "side": "left", "bg": "..."}
##             - who: clave de CHARS (o "narrador" para voz en off)
##             - side: "left"/"right" (opcional; por defecto NPC izquierda, detective derecha)
##             - bg: cambia el fondo a partir de aqui (opcional)
##   Eleccion: {"choices": [ {"text": "...", "then": [ ...beats... ]} ]}

# ---------------------------------------------------------------------------
#  REPARTO (retratos de novela visual)
# ---------------------------------------------------------------------------
const CHARS := {
	"detective":   {"name": "Nora",           "color": Color(0.45, 0.78, 0.80), "portrait": "res://assets/portraits/detective.png"},
	"emilio":      {"name": "Don Emilio",     "color": Color(0.80, 0.58, 0.35), "portrait": "res://assets/portraits/emilio.png"},
	"rosa":        {"name": "Rosa",           "color": Color(0.45, 0.75, 0.45), "portrait": "res://assets/portraits/rosa.png"},
	"tomas":       {"name": "Tomás",          "color": Color(0.90, 0.60, 0.30), "portrait": "res://assets/portraits/tomas.png"},
	"carmen":      {"name": "Doña Carmen",    "color": Color(0.68, 0.52, 0.82), "portrait": "res://assets/portraits/carmen.png"},
	"nunez":       {"name": "Sgto. Núñez",    "color": Color(0.42, 0.55, 0.85), "portrait": "res://assets/portraits/nunez.png"},
	"marta":       {"name": "Marta Soler",    "color": Color(0.88, 0.45, 0.55), "portrait": "res://assets/portraits/marta.png"},
	"encapuchado": {"name": "¿?",             "color": Color(0.35, 0.33, 0.40), "portrait": "res://assets/portraits/encapuchado.png"},
	"laura":       {"name": "Laura Soler",    "color": Color(0.90, 0.55, 0.62), "portrait": "res://assets/portraits/laura.png"},
	"padre":       {"name": "Padre Ismael",   "color": Color(0.80, 0.78, 0.55), "portrait": "res://assets/portraits/padre.png"},
	"vidal":       {"name": "Sr. Vidal",      "color": Color(0.60, 0.70, 0.85), "portrait": "res://assets/portraits/vidal.png"},
	"comisario":   {"name": "Comisario Bru",  "color": Color(0.72, 0.40, 0.40), "portrait": "res://assets/portraits/comisario.png"},
	"nano":        {"name": "Nano",           "color": Color(0.70, 0.50, 0.40), "portrait": "res://assets/portraits/nano.png"},
	"periodista":  {"name": "Vera Lang",      "color": Color(0.55, 0.80, 0.72), "portrait": "res://assets/portraits/periodista.png"},
	"corredor":    {"name": "El Corredor",    "color": Color(0.60, 0.55, 0.40), "portrait": "res://assets/portraits/corredor.png"},
	"madame":      {"name": "Madame Ourense", "color": Color(0.80, 0.50, 0.72), "portrait": "res://assets/portraits/madame.png"},
	"magnate":     {"name": "Aristide Vaultier","color": Color(0.78, 0.42, 0.36), "portrait": "res://assets/portraits/magnate.png"},
	"chivato":     {"name": "El chivato",     "color": Color(0.62, 0.62, 0.55), "portrait": "res://assets/portraits/chivato.png"},
	"voluntario":  {"name": "Voluntario",     "color": Color(0.65, 0.70, 0.60), "portrait": "res://assets/portraits/voluntario.png"},
	"contable":    {"name": "El contable",    "color": Color(0.60, 0.64, 0.70), "portrait": "res://assets/portraits/contable.png"},
	"anonimo":     {"name": "¿?",             "color": Color(0.55, 0.57, 0.62), "portrait": "res://assets/portraits/anonimo.png"},
	# --- Reparto personal de Nora (Temporada 3, caps. 7-20) ---
	"diego":       {"name": "Diego Vega",     "color": Color(0.55, 0.72, 0.88), "portrait": "res://assets/portraits/diego.png"},
	"sonia":       {"name": "Sonia",          "color": Color(0.50, 0.82, 0.70), "portrait": "res://assets/portraits/sonia.png"},
	"clara":       {"name": "Clara",          "color": Color(0.88, 0.62, 0.72), "portrait": "res://assets/portraits/clara.png"},
	"ruben":       {"name": "Insp. Rubén",    "color": Color(0.60, 0.62, 0.80), "portrait": "res://assets/portraits/ruben.png"},
	"marco":       {"name": "Marco",          "color": Color(0.66, 0.58, 0.50), "portrait": "res://assets/portraits/marco.png"},
	# --- Trama Nyxos ---
	"kessler":     {"name": "Dr. Kessler",    "color": Color(0.70, 0.74, 0.62), "portrait": "res://assets/portraits/kessler.png"},
	"adler":       {"name": "Dra. Adler",     "color": Color(0.80, 0.44, 0.50), "portrait": "res://assets/portraits/adler.png"},
	"testigo":     {"name": "Testigo",        "color": Color(0.72, 0.72, 0.66), "portrait": "res://assets/portraits/testigo.png"},
	"sospechoso":  {"name": "Sospechoso",     "color": Color(0.66, 0.58, 0.58), "portrait": "res://assets/portraits/sospechoso.png"},
	"narrador":    {"name": "",               "color": Color(0.70, 0.72, 0.78), "portrait": ""},
}

# ---------------------------------------------------------------------------
#  FONDOS DE LAS ESCENAS
# ---------------------------------------------------------------------------
const BGS := {
	"plaza":       "res://assets/backgrounds/plaza.png",
	"casa_emilio": "res://assets/backgrounds/casa_emilio.png",
	"iglesia_ext": "res://assets/backgrounds/iglesia_ext.png",
	"iglesia_int": "res://assets/backgrounds/iglesia_int.png",
	"tienda":      "res://assets/backgrounds/tienda.png",
	"casa_carmen": "res://assets/backgrounds/casa_carmen.png",
	"comisaria":   "res://assets/backgrounds/comisaria.png",
	"casa_marta":  "res://assets/backgrounds/casa_marta.png",
	# --- Capítulo 2 ---
	"archivo":     "res://assets/backgrounds/archivo.png",
	"refugio":     "res://assets/backgrounds/refugio.png",
	"muelle":      "res://assets/backgrounds/muelle.png",
	# --- Capítulo 3 ---
	"mansion":     "res://assets/backgrounds/mansion.png",
	"torre":       "res://assets/backgrounds/torre.png",
	"sotano":      "res://assets/backgrounds/sotano.png",
	# --- Temporada 2 (Capítulos 4-6) ---
	"almacen":     "res://assets/backgrounds/almacen.png",
	"redaccion":   "res://assets/backgrounds/redaccion.png",
	"subasta":     "res://assets/backgrounds/subasta.png",
	"despacho":    "res://assets/backgrounds/despacho.png",
	"azotea":      "res://assets/backgrounds/azotea.png",
	# --- Temporada 3 (Caps. 7-20) · trama Nyxos ---
	"hospital":    "res://assets/backgrounds/hospital.png",
	"morgue":      "res://assets/backgrounds/morgue.png",
	"laboratorio": "res://assets/backgrounds/laboratorio.png",
	"clinica":     "res://assets/backgrounds/clinica.png",
	"piso_diego":  "res://assets/backgrounds/piso_diego.png",
	"oficina":     "res://assets/backgrounds/oficina.png",
	"planta":      "res://assets/backgrounds/planta.png",
	"consejo":     "res://assets/backgrounds/consejo.png",
	# --- Ubicaciones variadas de la ciudad y más allá ---
	"centro":      "res://assets/backgrounds/centro.png",
	"barrio_alto": "res://assets/backgrounds/barrio_alto.png",
	"ciudad2":     "res://assets/backgrounds/ciudad2.png",
	"costa":       "res://assets/backgrounds/costa.png",
	"montana":     "res://assets/backgrounds/montana.png",
	"bar_clara":   "res://assets/backgrounds/bar_clara.png",
	"bar":         "res://assets/backgrounds/bar.png",
	"capilla":     "res://assets/backgrounds/capilla.png",
	"comedor":     "res://assets/backgrounds/comedor.png",
	# --- ADR-037 estricto: un fondo por ubicacion ---
	"chatarreria":   "res://assets/backgrounds/chatarreria.png",
	"trastienda":    "res://assets/backgrounds/trastienda.png",
	"gestoria":      "res://assets/backgrounds/gestoria.png",
	"casa_laura":    "res://assets/backgrounds/casa_laura.png",
	"callejon":      "res://assets/backgrounds/callejon.png",
	"salon_privado": "res://assets/backgrounds/salon_privado.png",
	"despacho_secretario": "res://assets/backgrounds/despacho_secretario.png",
	"nave_industrial": "res://assets/backgrounds/nave_industrial.png",
	"archivo_medico": "res://assets/backgrounds/archivo_medico.png",
	"archivo_becario": "res://assets/backgrounds/archivo_becario.png",
	"azotea_nyxos":  "res://assets/backgrounds/azotea_nyxos.png",
	"bufete_clara":  "res://assets/backgrounds/bufete_clara.png",
	"cafe_ruben":    "res://assets/backgrounds/cafe_ruben.png",
	"puesto_policia": "res://assets/backgrounds/puesto_policia.png",
	"sede_regional": "res://assets/backgrounds/sede_regional.png",
	"ruta_clara":    "res://assets/backgrounds/ruta_clara.png",
	"clinica_kessler": "res://assets/backgrounds/clinica_kessler.png",
	"sala_ensayos":  "res://assets/backgrounds/sala_ensayos.png",
	"clinica_clausurada": "res://assets/backgrounds/clinica_clausurada.png",
	"piso_franco":   "res://assets/backgrounds/piso_franco.png",
	"sanatorio_costa": "res://assets/backgrounds/sanatorio_costa.png",
	"balneario":     "res://assets/backgrounds/balneario.png",
	"puerto_pesca":  "res://assets/backgrounds/puerto_pesca.png",
	"despacho_concejal": "res://assets/backgrounds/despacho_concejal.png",
	"despacho_abogado": "res://assets/backgrounds/despacho_abogado.png",
	"despacho_consejero": "res://assets/backgrounds/despacho_consejero.png",
	"despacho_rrpp": "res://assets/backgrounds/despacho_rrpp.png",
	"sanatorio_montana": "res://assets/backgrounds/sanatorio_montana.png",
	"cabana_ermitano": "res://assets/backgrounds/cabana_ermitano.png",
	"local_voluntario": "res://assets/backgrounds/local_voluntario.png",
	"tienda_dealer": "res://assets/backgrounds/tienda_dealer.png",
}

# ---------------------------------------------------------------------------
#  LOCALIZACIONES DEL MAPA
#   pos: fraccion (0..1) del mapa, para colocar el pin de forma responsive.
#   req: condicion para poder visitar ("always" | "clues4" | "cap1_completo").
# ---------------------------------------------------------------------------
# req: condición para que la localización APAREZCA en el mapa. Cada una se revela
# porque en la conversación ANTERIOR se habla de ella o remiten a ese personaje:
#   plaza (always) -> Emilio ; Emilio -> Rosa ; Rosa -> Tomás ; Tomás -> Carmen ;
#   Carmen/4 pistas -> Iglesia ; caso cerrado -> Comisaría.
# --- Capítulo 0: TUTORIAL (enseña el bucle de juego con un caso de prácticas) ---
const CH0_LOCATIONS := [
	{"id": "brief0",  "name": "Comisaría",           "sub": "Núñez te enseña el oficio",   "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l0a",     "name": "Plaza del Barrio",    "sub": "Buscar pistas (examinar)",    "pos": Vector2(0.50, 0.58), "req": "done_brief0"},
	{"id": "rh0",     "name": "Callejón",            "sub": "Examinar un detalle (zoom)",  "pos": Vector2(0.34, 0.82), "req": "done_l0a"},
	{"id": "l0b",     "name": "Tienda de la esquina","sub": "Mini-puzzle: el código",      "pos": Vector2(0.26, 0.66), "req": "done_rh0"},
	{"id": "l0c",     "name": "Interrogatorio",      "sub": "Presentar la prueba",         "pos": Vector2(0.62, 0.44), "req": "clues4"},
	{"id": "fin0",    "name": "Archivo",             "sub": "Deducción: cerrar el caso",   "pos": Vector2(0.64, 0.28), "req": "done_l0c"},
	{"id": "cierre0", "name": "Comisaría",           "sub": "Informar y empezar de verdad","pos": Vector2(0.86, 0.22), "req": "cap0_completo"},
]
const CH0_STREET := ["Leer el escenario", "Tirar del hilo"]

const CH1_LOCATIONS := [
	{"id": "plaza",     "name": "Plaza del Barrio",  "sub": "Tu punto de llegada",        "pos": Vector2(0.50, 0.58), "req": "always"},
	{"id": "casa_marta","name": "Casa de Marta",     "sub": "La casa de la desaparecida", "pos": Vector2(0.14, 0.52), "req": "done_plaza"},
	{"id": "exnovio",   "name": "El bar del Nano",   "sub": "El ex de Marta",             "pos": Vector2(0.40, 0.84), "req": "done_casa_marta", "red_herring": true},
	{"id": "emilio",    "name": "Casa de Don Emilio","sub": "Un vecino estaba en misa",   "pos": Vector2(0.24, 0.34), "req": "done_casa_marta"},
	{"id": "rosa",      "name": "Atrio de la iglesia","sub": "Rosa vigilaba la puerta",   "pos": Vector2(0.62, 0.30), "req": "done_emilio"},
	{"id": "tomas",     "name": "Tienda de Tomás",   "sub": "El tendero lo ve todo",      "pos": Vector2(0.30, 0.72), "req": "done_rosa"},
	{"id": "carmen",    "name": "Casa de Doña Carmen","sub": "Guarda los secretos del barrio", "pos": Vector2(0.78, 0.66), "req": "done_tomas"},
	{"id": "iglesia",   "name": "Iglesia de San José","sub": "El lugar de la desaparición", "pos": Vector2(0.50, 0.20), "req": "clues4"},
	{"id": "comisaria", "name": "Comisaría",         "sub": "El sargento Núñez",          "pos": Vector2(0.84, 0.44), "req": "cap1_completo"},
]
const CH1_STREET := ["El grito", "La puerta principal", "El encapuchado", "El campanario"]

# --- Capítulo 2: seguir la pista de la serie ---
const CH2_LOCATIONS := [
	{"id": "brief",     "name": "Comisaría",           "sub": "Núñez y la carpeta sin nombre", "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "archivo",   "name": "Archivo policial",    "sub": "Los otros dos casos",           "pos": Vector2(0.66, 0.58), "req": "done_brief"},
	{"id": "voluntario","name": "Un voluntario",       "sub": "Anda muy nervioso",             "pos": Vector2(0.52, 0.44), "req": "done_archivo", "red_herring": true},
	{"id": "laura",     "name": "Casa de Laura",       "sub": "La hermana de Marta",           "pos": Vector2(0.16, 0.40), "req": "done_archivo"},
	{"id": "refugio",   "name": "Fundación Amparo",     "sub": "El refugio benéfico",           "pos": Vector2(0.40, 0.30), "req": "done_laura"},
	{"id": "capilla",   "name": "Capilla privada",     "sub": "Bajo la Fundación",             "pos": Vector2(0.30, 0.66), "req": "done_refugio"},
	{"id": "muelle",    "name": "Muelle viejo",        "sub": "Donde cargan la furgoneta",     "pos": Vector2(0.80, 0.78), "req": "clues4"},
	{"id": "cierre2",   "name": "Comisaría",           "sub": "Lo que se cierra desde arriba", "pos": Vector2(0.86, 0.24), "req": "cap2_completo"},
]
const CH2_STREET := ["El hilo común", "El voluntariado", "El benefactor", "La agenda de misas"]

# --- Capítulo 3: el coleccionista ---
const CH3_LOCATIONS := [
	{"id": "aviso",   "name": "Comisaría",           "sub": "Núñez te advierte",             "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "soplo",   "name": "Soplo anónimo",       "sub": "Una pista que llega sola",      "pos": Vector2(0.46, 0.62), "req": "done_aviso", "red_herring": true},
	{"id": "mansion", "name": "Mansión del mecenas", "sub": "La casa del benefactor",        "pos": Vector2(0.30, 0.28), "req": "done_aviso"},
	{"id": "sotano",  "name": "El sótano",           "sub": "Lo que esconde la mansión",     "pos": Vector2(0.20, 0.62), "req": "done_mansion"},
	{"id": "padre",   "name": "Iglesia de San José", "sub": "La confesión del párroco",      "pos": Vector2(0.56, 0.30), "req": "done_sotano"},
	{"id": "torre",   "name": "La torre del reloj",  "sub": "La cuarta noche",               "pos": Vector2(0.62, 0.16), "req": "clues4"},
	{"id": "cierre3", "name": "Comisaría",           "sub": "El final del hilo",             "pos": Vector2(0.84, 0.70), "req": "cap3_completo"},
]
const CH3_STREET := ["Las tres campanas", "Las cautivas", "El chantaje"]

# ===== TEMPORADA 2 =====
# --- Capítulo 4: el heredero ---
const CH4_LOCATIONS := [
	{"id": "brief4",  "name": "Comisaría",           "sub": "Otra tormenta, otra iglesia",   "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "escena4", "name": "Iglesia de la Merced","sub": "La nueva escena",               "pos": Vector2(0.50, 0.22), "req": "done_brief4"},
	{"id": "chivato", "name": "El chivato",          "sub": "Oídos en la calle",             "pos": Vector2(0.30, 0.70), "req": "done_escena4"},
	{"id": "falso4",  "name": "Un detenido",         "sub": "Se confiesa culpable",          "pos": Vector2(0.66, 0.60), "req": "done_escena4", "red_herring": true},
	{"id": "redaccion","name": "Redacción del diario","sub": "La periodista Vera Lang",       "pos": Vector2(0.20, 0.36), "req": "done_chivato"},
	{"id": "almacen", "name": "Almacén del muelle",  "sub": "Donde guardan la mercancía",    "pos": Vector2(0.78, 0.76), "req": "clues4"},
	{"id": "cierre4", "name": "Comisaría",           "sub": "No es un loco: es un negocio",  "pos": Vector2(0.86, 0.24), "req": "cap4_completo"},
]
const CH4_STREET := ["El método heredado", "El corredor", "La marca del gremio"]

# --- Capítulo 5: la subasta ---
const CH5_LOCATIONS := [
	{"id": "brief5",    "name": "Comisaría",         "sub": "Seguir al Corredor",            "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "contacto",  "name": "Muelle viejo",      "sub": "Un contacto asustado",          "pos": Vector2(0.80, 0.78), "req": "done_brief5"},
	{"id": "falso5",    "name": "Chatarrería",       "sub": "Un pez gordo... o no",          "pos": Vector2(0.34, 0.80), "req": "done_brief5", "red_herring": true},
	{"id": "salon",     "name": "Salón privado",     "sub": "Madame Ourense",                "pos": Vector2(0.44, 0.30), "req": "done_contacto"},
	{"id": "trastienda","name": "Trastienda",        "sub": "La lista de clientes",          "pos": Vector2(0.22, 0.56), "req": "done_salon"},
	{"id": "redada",    "name": "La subasta",        "sub": "La noche de la puja",           "pos": Vector2(0.60, 0.68), "req": "clues4"},
	{"id": "cierre5",   "name": "Comisaría",         "sub": "Sube un peldaño más",           "pos": Vector2(0.86, 0.24), "req": "cap5_completo"},
]
const CH5_STREET := ["La lista de clientes", "El sello de la casa", "El corredor jefe"]

# --- Capítulo 6: la cúspide (final de temporada 2) ---
const CH6_LOCATIONS := [
	{"id": "brief6",   "name": "Comisaría",          "sub": "El nombre que nadie dice",      "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "despacho", "name": "Bufete Vaultier",    "sub": "El despacho del magnate",       "pos": Vector2(0.36, 0.28), "req": "done_brief6"},
	{"id": "falso6",   "name": "El secretario",      "sub": "Ofrece un trato",               "pos": Vector2(0.60, 0.44), "req": "done_brief6", "red_herring": true},
	{"id": "contable", "name": "El contable",        "sub": "Sigue el dinero",               "pos": Vector2(0.20, 0.58), "req": "done_despacho"},
	{"id": "coartada", "name": "Mansión Vaultier",   "sub": "Romper la coartada",            "pos": Vector2(0.30, 0.72), "req": "done_contable"},
	{"id": "azotea",   "name": "La azotea",          "sub": "La última campana",             "pos": Vector2(0.58, 0.16), "req": "clues4"},
	{"id": "cierre6",  "name": "Comisaría",          "sub": "El final del hilo",             "pos": Vector2(0.86, 0.70), "req": "cap6_completo"},
]
const CH6_STREET := ["El nombre de arriba", "Los pagos", "La coartada rota"]

# ===== TEMPORADA 3 (Caps. 7-20) · un solo caso que escala hasta Nyxos Pharma =====
# Plantilla por capítulo: briefN -> lNa (pista1) -> lNb (pista2) -> [rhN red herring]
#   -> finN (clímax, gated por las 2 pistas) -> cierreN (end_flag al siguiente).
# Escenarios variados por la ciudad y más allá; reparto personal de Nora intercalado.
const CH7_LOCATIONS := [
	{"id": "brief7","name": "Comisaría",         "sub": "Una autopsia rara",      "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l7a",   "name": "Morgue municipal",  "sub": "Sonia, la forense",      "pos": Vector2(0.30, 0.40), "req": "done_brief7"},
	{"id": "rh7",   "name": "Un camello",        "sub": "El sospechoso fácil",    "pos": Vector2(0.60, 0.68), "req": "done_brief7", "red_herring": true},
	{"id": "l7b",   "name": "Hospital central",  "sub": "El médico que receta",   "pos": Vector2(0.20, 0.66), "req": "done_l7a"},
	{"id": "fin7",  "name": "Clínica del Dr. Kessler","sub": "El primer eslabón",  "pos": Vector2(0.52, 0.24), "req": "clues4"},
	{"id": "cierre7","name": "Comisaría",        "sub": "Somnia",                 "pos": Vector2(0.86, 0.24), "req": "cap7_completo"},
]
const CH7_STREET := ["El fármaco Somnia", "El médico que receta"]

const CH8_LOCATIONS := [
	{"id": "brief8","name": "Comisaría",         "sub": "El nombre en la receta", "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l8a",   "name": "Piso de Diego",     "sub": "Tu hermano",             "pos": Vector2(0.24, 0.36), "req": "done_brief8"},
	{"id": "rh8",   "name": "Un falso dealer",   "sub": "Vende humo",             "pos": Vector2(0.62, 0.70), "req": "done_brief8", "red_herring": true},
	{"id": "l8b",   "name": "Clínica fantasma",  "sub": "Ensayos a escondidas",   "pos": Vector2(0.44, 0.28), "req": "done_l8a"},
	{"id": "fin8",  "name": "Sala de ensayos",   "sub": "El paciente cero",       "pos": Vector2(0.30, 0.66), "req": "clues4"},
	{"id": "cierre8","name": "Comisaría",        "sub": "Ensayos con personas",   "pos": Vector2(0.86, 0.24), "req": "cap8_completo"},
]
const CH8_STREET := ["El paciente cero", "La clínica fantasma"]

const CH9_LOCATIONS := [
	{"id": "brief9","name": "Comisaría",         "sub": "Sin orden no hay caso",  "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l9a",   "name": "Bufete de Clara",   "sub": "Tu ex, la abogada",      "pos": Vector2(0.22, 0.34), "req": "done_brief9"},
	{"id": "rh9",   "name": "Un voluntario",     "sub": "Firmó por dinero",       "pos": Vector2(0.60, 0.66), "req": "done_brief9", "red_herring": true},
	{"id": "l9b",   "name": "Centro de negocios","sub": "La empresa detrás",      "pos": Vector2(0.50, 0.30), "req": "done_l9a"},
	{"id": "fin9",  "name": "Clínica clausurada","sub": "Consentimientos falsos", "pos": Vector2(0.32, 0.68), "req": "clues4"},
	{"id": "cierre9","name": "Comisaría",        "sub": "Una farmacéutica",       "pos": Vector2(0.86, 0.24), "req": "cap9_completo"},
]
const CH9_STREET := ["Los ensayos ilegales", "El consentimiento falso"]

const CH10_LOCATIONS := [
	{"id": "brief10","name": "Comisaría",        "sub": "El logo de Nyxos",       "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l10a",  "name": "Laboratorio Nyxos", "sub": "La marca en todo",       "pos": Vector2(0.46, 0.26), "req": "done_brief10"},
	{"id": "rh10",  "name": "Un jefe de planta", "sub": "Grita mucho",            "pos": Vector2(0.64, 0.66), "req": "done_brief10", "red_herring": true},
	{"id": "l10b",  "name": "Marco, seguridad",  "sub": "Tu excompañero",         "pos": Vector2(0.24, 0.62), "req": "done_l10a"},
	{"id": "fin10", "name": "Planta de Nyxos",   "sub": "El lote humano",         "pos": Vector2(0.36, 0.30), "req": "clues4"},
	{"id": "cierre10","name": "Comisaría",       "sub": "Nyxos tiene nombre",     "pos": Vector2(0.86, 0.24), "req": "cap10_completo"},
]
const CH10_STREET := ["La marca Nyxos", "El lote humano"]

const CH11_LOCATIONS := [
	{"id": "brief11","name": "Comisaría",        "sub": "Nyxos compra poder",     "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l11a",  "name": "Barrio alto",       "sub": "Villas y dinero",        "pos": Vector2(0.30, 0.28), "req": "done_brief11"},
	{"id": "rh11",  "name": "Un concejal rival", "sub": "Demasiado ruidoso",      "pos": Vector2(0.62, 0.66), "req": "done_brief11", "red_herring": true},
	{"id": "l11b",  "name": "Inspector Rubén",   "sub": "Tu viejo mentor",        "pos": Vector2(0.22, 0.60), "req": "done_l11a"},
	{"id": "fin11", "name": "Centro de negocios","sub": "El concejal comprado",   "pos": Vector2(0.50, 0.30), "req": "clues4"},
	{"id": "cierre11","name": "Comisaría",       "sub": "La red institucional",   "pos": Vector2(0.86, 0.24), "req": "cap11_completo"},
]
const CH11_STREET := ["Los sobornos", "El concejal comprado"]

const CH12_LOCATIONS := [
	{"id": "brief12","name": "Comisaría",        "sub": "Alguien quiere hablar",  "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l12a",  "name": "Redacción",         "sub": "Vera y el informante",   "pos": Vector2(0.24, 0.36), "req": "done_brief12"},
	{"id": "rh12",  "name": "Un becario",        "sub": "Filtró por despecho",    "pos": Vector2(0.62, 0.66), "req": "done_brief12", "red_herring": true},
	{"id": "l12b",  "name": "Oficinas de Nyxos", "sub": "El memorándum",          "pos": Vector2(0.50, 0.28), "req": "done_l12a"},
	{"id": "fin12", "name": "Oficinas de Nyxos", "sub": "El informante calla",    "pos": Vector2(0.36, 0.66), "req": "clues4"},
	{"id": "cierre12","name": "Comisaría",       "sub": "Matan por esto",         "pos": Vector2(0.86, 0.24), "req": "cap12_completo"},
]
const CH12_STREET := ["El informante", "El memorándum interno"]

const CH13_LOCATIONS := [
	{"id": "brief13","name": "Comisaría",        "sub": "Los nombres de siempre", "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l13a",  "name": "Archivo médico",    "sub": "Sujetos de prueba",      "pos": Vector2(0.28, 0.40), "req": "done_brief13"},
	{"id": "rh13",  "name": "Un celador",        "sub": "Se pone nervioso",       "pos": Vector2(0.62, 0.66), "req": "done_brief13", "red_herring": true},
	{"id": "l13b",  "name": "Hospital · Diego",  "sub": "Tu hermano recae",       "pos": Vector2(0.20, 0.64), "req": "done_l13a"},
	{"id": "fin13", "name": "Hospital central",  "sub": "El código del proyecto", "pos": Vector2(0.50, 0.26), "req": "clues4"},
	{"id": "cierre13","name": "Comisaría",       "sub": "Proyecto Somnia",        "pos": Vector2(0.86, 0.24), "req": "cap13_completo"},
]
const CH13_STREET := ["Los sujetos de prueba", "El código del proyecto"]

const CH14_LOCATIONS := [
	{"id": "brief14","name": "Comisaría",        "sub": "Un cabo en la costa",    "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l14a",  "name": "Pueblo de la costa","sub": "Un balneario Nyxos",     "pos": Vector2(0.28, 0.34), "req": "done_brief14"},
	{"id": "rh14",  "name": "Un pescador",       "sub": "Vio demasiado... o no",  "pos": Vector2(0.62, 0.68), "req": "done_brief14", "red_herring": true},
	{"id": "l14b",  "name": "Balneario",         "sub": "Los del sur",            "pos": Vector2(0.44, 0.30), "req": "done_l14a"},
	{"id": "fin14", "name": "Costa · sanatorio", "sub": "Los desaparecidos del sur","pos": Vector2(0.34, 0.66), "req": "clues4"},
	{"id": "cierre14","name": "Comisaría",       "sub": "No es solo esta ciudad", "pos": Vector2(0.86, 0.24), "req": "cap14_completo"},
]
const CH14_STREET := ["El balneario", "Los desaparecidos del sur"]

const CH15_LOCATIONS := [
	{"id": "brief15","name": "Comisaría",        "sub": "Arriba, en la montaña",  "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l15a",  "name": "Pueblo de montaña", "sub": "Un sanatorio aislado",   "pos": Vector2(0.28, 0.32), "req": "done_brief15"},
	{"id": "rh15",  "name": "El ermitaño",       "sub": "Habla con los muertos",  "pos": Vector2(0.62, 0.66), "req": "done_brief15", "red_herring": true},
	{"id": "l15b",  "name": "Sanatorio",         "sub": "Una superviviente",      "pos": Vector2(0.44, 0.28), "req": "done_l15a"},
	{"id": "fin15", "name": "Montaña · sanatorio","sub": "La que escapó",         "pos": Vector2(0.34, 0.64), "req": "clues4"},
	{"id": "cierre15","name": "Comisaría",       "sub": "Un testigo vivo",        "pos": Vector2(0.86, 0.24), "req": "cap15_completo"},
]
const CH15_STREET := ["La superviviente", "El sanatorio de montaña"]

const CH16_LOCATIONS := [
	{"id": "brief16","name": "Comisaría",        "sub": "Otra ciudad, mismo mal", "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l16a",  "name": "Otra ciudad",       "sub": "La misma franquicia",    "pos": Vector2(0.30, 0.30), "req": "done_brief16"},
	{"id": "rh16",  "name": "Policía local",     "sub": "¿Aliado o cebo?",        "pos": Vector2(0.62, 0.66), "req": "done_brief16", "red_herring": true},
	{"id": "l16b",  "name": "Clara · en ruta",   "sub": "Tu ex vuelve a ayudar",  "pos": Vector2(0.22, 0.60), "req": "done_l16a"},
	{"id": "fin16", "name": "Sede regional",     "sub": "El patrón nacional",     "pos": Vector2(0.50, 0.30), "req": "clues4"},
	{"id": "cierre16","name": "Comisaría",       "sub": "Es un país entero",      "pos": Vector2(0.86, 0.24), "req": "cap16_completo"},
]
const CH16_STREET := ["La franquicia", "El patrón nacional"]

const CH17_LOCATIONS := [
	{"id": "brief17","name": "Comisaría",        "sub": "Te quieren comprar",     "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l17a",  "name": "El bar de Clara",   "sub": "Una copa y una oferta",  "pos": Vector2(0.26, 0.36), "req": "done_brief17"},
	{"id": "rh17",  "name": "Un abogado",        "sub": "Ofrece un pacto",        "pos": Vector2(0.62, 0.66), "req": "done_brief17", "red_herring": true},
	{"id": "l17b",  "name": "Marco, otra vez",   "sub": "Entre dos lealtades",    "pos": Vector2(0.24, 0.60), "req": "done_l17a"},
	{"id": "fin17", "name": "Oficinas de Nyxos", "sub": "El chantaje a Nora",     "pos": Vector2(0.50, 0.30), "req": "clues4"},
	{"id": "cierre17","name": "Comisaría",       "sub": "No se venden todos",     "pos": Vector2(0.86, 0.24), "req": "cap17_completo"},
]
const CH17_STREET := ["La oferta", "El chantaje a Nora"]

const CH18_LOCATIONS := [
	{"id": "brief18","name": "Comisaría",        "sub": "Sube al consejo",        "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l18a",  "name": "Sede de Nyxos",     "sub": "El acta que falta",      "pos": Vector2(0.46, 0.26), "req": "done_brief18"},
	{"id": "rh18",  "name": "Un consejero",      "sub": "Dimite de repente",      "pos": Vector2(0.62, 0.66), "req": "done_brief18", "red_herring": true},
	{"id": "l18b",  "name": "El contable vuelve","sub": "Sigue la votación",      "pos": Vector2(0.24, 0.60), "req": "done_l18a"},
	{"id": "fin18", "name": "Sala del consejo",  "sub": "La votación secreta",    "pos": Vector2(0.50, 0.30), "req": "clues4"},
	{"id": "cierre18","name": "Comisaría",       "sub": "Deciden juntos",         "pos": Vector2(0.86, 0.24), "req": "cap18_completo"},
]
const CH18_STREET := ["El acta secreta", "La votación del consejo"]

const CH19_LOCATIONS := [
	{"id": "brief19","name": "Comisaría",        "sub": "La directora",           "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l19a",  "name": "Despacho de Adler", "sub": "La cara de Nyxos",       "pos": Vector2(0.46, 0.26), "req": "done_brief19"},
	{"id": "rh19",  "name": "El relaciones públicas","sub": "Todo sonrisas",      "pos": Vector2(0.62, 0.66), "req": "done_brief19", "red_herring": true},
	{"id": "l19b",  "name": "Diego, a salvo",    "sub": "Rescatas a tu hermano",  "pos": Vector2(0.24, 0.60), "req": "done_l19a"},
	{"id": "fin19", "name": "Oficina de Nyxos",  "sub": "El proyecto Somnia",     "pos": Vector2(0.50, 0.30), "req": "clues4"},
	{"id": "cierre19","name": "Comisaría",       "sub": "Adler no está sola",     "pos": Vector2(0.86, 0.24), "req": "cap19_completo"},
]
const CH19_STREET := ["La directora Adler", "El proyecto Somnia"]

const CH20_LOCATIONS := [
	{"id": "brief20","name": "Comisaría",        "sub": "Todos contigo",          "pos": Vector2(0.84, 0.44), "req": "always"},
	{"id": "l20a",  "name": "Sala del consejo",  "sub": "La cúpula entera",       "pos": Vector2(0.46, 0.26), "req": "done_brief20"},
	{"id": "rh20",  "name": "Un chivo expiatorio","sub": "Nyxos ofrece un culpable","pos": Vector2(0.62, 0.66), "req": "done_brief20", "red_herring": true},
	{"id": "l20b",  "name": "Todos ayudan",      "sub": "Sonia, Clara, Vera, Rubén","pos": Vector2(0.24, 0.60), "req": "done_l20a"},
	{"id": "fin20", "name": "Azotea de Nyxos",   "sub": "La prueba definitiva",   "pos": Vector2(0.50, 0.30), "req": "clues4"},
	{"id": "cierre20","name": "Comisaría",       "sub": "Cae Nyxos",              "pos": Vector2(0.86, 0.24), "req": "cap20_completo"},
]
const CH20_STREET := ["La cúpula entera", "La prueba definitiva"]

# Mapa de capítulos. end_flag = bandera cuya activación pasa al capítulo siguiente.
const CHAPTERS := {
	0: {"title": "Tutorial · Cómo se juega",            "locations": CH0_LOCATIONS, "street": CH0_STREET, "complete_flag": "cap0_completo", "end_flag": "done_cierre0"},
	1: {"title": "Capítulo 1 · Desaparición en la iglesia", "locations": CH1_LOCATIONS, "street": CH1_STREET, "complete_flag": "cap1_completo", "end_flag": "done_comisaria"},
	2: {"title": "Capítulo 2 · Las campanas que faltan",    "locations": CH2_LOCATIONS, "street": CH2_STREET, "complete_flag": "cap2_completo", "end_flag": "done_cierre2"},
	3: {"title": "Capítulo 3 · El coleccionista",           "locations": CH3_LOCATIONS, "street": CH3_STREET, "complete_flag": "cap3_completo", "end_flag": "done_cierre3"},
	4: {"title": "Capítulo 4 · El heredero",                "locations": CH4_LOCATIONS, "street": CH4_STREET, "complete_flag": "cap4_completo", "end_flag": "done_cierre4"},
	5: {"title": "Capítulo 5 · La subasta",                 "locations": CH5_LOCATIONS, "street": CH5_STREET, "complete_flag": "cap5_completo", "end_flag": "done_cierre5"},
	6: {"title": "Capítulo 6 · La cúspide",                 "locations": CH6_LOCATIONS, "street": CH6_STREET, "complete_flag": "cap6_completo", "end_flag": "done_cierre6"},
	7: {"title": "Capítulo 7 · La receta",                  "locations": CH7_LOCATIONS, "street": CH7_STREET, "complete_flag": "cap7_completo", "end_flag": "done_cierre7"},
	8: {"title": "Capítulo 8 · El hermano",                 "locations": CH8_LOCATIONS, "street": CH8_STREET, "complete_flag": "cap8_completo", "end_flag": "done_cierre8"},
	9: {"title": "Capítulo 9 · La clínica fantasma",        "locations": CH9_LOCATIONS, "street": CH9_STREET, "complete_flag": "cap9_completo", "end_flag": "done_cierre9"},
	10: {"title": "Capítulo 10 · El laboratorio",           "locations": CH10_LOCATIONS, "street": CH10_STREET, "complete_flag": "cap10_completo", "end_flag": "done_cierre10", "map": "res://assets/backgrounds/mapa_centro.png"},
	11: {"title": "Capítulo 11 · El barrio alto",           "locations": CH11_LOCATIONS, "street": CH11_STREET, "complete_flag": "cap11_completo", "end_flag": "done_cierre11", "map": "res://assets/backgrounds/mapa_centro.png"},
	12: {"title": "Capítulo 12 · La filtración",            "locations": CH12_LOCATIONS, "street": CH12_STREET, "complete_flag": "cap12_completo", "end_flag": "done_cierre12"},
	13: {"title": "Capítulo 13 · El expediente",            "locations": CH13_LOCATIONS, "street": CH13_STREET, "complete_flag": "cap13_completo", "end_flag": "done_cierre13"},
	14: {"title": "Capítulo 14 · El pueblo de la costa",    "locations": CH14_LOCATIONS, "street": CH14_STREET, "complete_flag": "cap14_completo", "end_flag": "done_cierre14", "map": "res://assets/backgrounds/mapa_costa.png"},
	15: {"title": "Capítulo 15 · El pueblo de montaña",     "locations": CH15_LOCATIONS, "street": CH15_STREET, "complete_flag": "cap15_completo", "end_flag": "done_cierre15", "map": "res://assets/backgrounds/mapa_montana.png"},
	16: {"title": "Capítulo 16 · La otra ciudad",           "locations": CH16_LOCATIONS, "street": CH16_STREET, "complete_flag": "cap16_completo", "end_flag": "done_cierre16", "map": "res://assets/backgrounds/mapa_ciudad2.png"},
	17: {"title": "Capítulo 17 · La compra",                "locations": CH17_LOCATIONS, "street": CH17_STREET, "complete_flag": "cap17_completo", "end_flag": "done_cierre17"},
	18: {"title": "Capítulo 18 · El consejo",               "locations": CH18_LOCATIONS, "street": CH18_STREET, "complete_flag": "cap18_completo", "end_flag": "done_cierre18"},
	19: {"title": "Capítulo 19 · La directora",             "locations": CH19_LOCATIONS, "street": CH19_STREET, "complete_flag": "cap19_completo", "end_flag": "done_cierre19"},
	20: {"title": "Capítulo 20 · Nyxos",                    "locations": CH20_LOCATIONS, "street": CH20_STREET, "complete_flag": "cap20_completo", "end_flag": "done_cierre20"},
}

# --- Accesos al capítulo actual (Global.chapter) ---
static func chapter_data() -> Dictionary:
	return CHAPTERS.get(Global.chapter, CHAPTERS[1])

static func locations() -> Array:
	return chapter_data()["locations"]

static func street_clues() -> Array:
	return chapter_data()["street"]

static func chapter_title() -> String:
	return chapter_data()["title"]

static func chapter_map() -> String:
	return chapter_data().get("map", "res://assets/backgrounds/mapa.png")

static func complete_flag() -> String:
	return chapter_data()["complete_flag"]

static func end_flag() -> String:
	return chapter_data()["end_flag"]

static func is_last_chapter() -> bool:
	return not CHAPTERS.has(Global.chapter + 1)


# ---------------------------------------------------------------------------
#  ESTADO / DISPONIBILIDAD
# ---------------------------------------------------------------------------
static func street_clues_count() -> int:
	var n := 0
	var street := street_clues()
	for c in Global.clues:
		if c.title in street:
			n += 1
	return n


static func location_state(id: String) -> String:
	## "done"      -> ya resuelta (no aporta nada nuevo)
	## "locked"    -> aun no cumple el requisito
	## "available" -> se puede visitar
	var loc := _loc(id)
	if loc.is_empty():
		return "locked"
	var req := String(loc.get("req", "always"))
	match req:
		"always":
			pass
		"clues4":
			if street_clues_count() < street_clues().size():
				return "locked"
		_:
			# Requisito por bandera: "done_plaza", "cap1_completo", ...
			if not Global.has_flag(req):
				return "locked"
	if Global.has_flag("done_" + id):
		return "done"
	return "available"


static func locked_reason(id: String) -> String:
	var loc := _loc(id)
	var req := String(loc.get("req", "always"))
	if req == "clues4":
		return "Reúne las pistas del caso antes de continuar."
	return "Sigue el hilo de la investigación para llegar aquí."


static func _loc(id: String) -> Dictionary:
	for l in locations():
		if l.id == id:
			return l
	return {}


# ---------------------------------------------------------------------------
#  DIALOGOS
#   Devuelve el dialogo adecuado segun el estado (primera visita / repetida).
# ---------------------------------------------------------------------------
static func get_dialogue(id: String) -> Dictionary:
	var done := Global.has_flag("done_" + id)
	if Global.chapter == 0:
		return _ch_data_dialogue(id, done)   # tutorial (datos en S3)
	if Global.chapter == 7:
		return _ch7_dialogue(id, done)   # capítulo 7 ampliado al canon largo
	if Global.chapter >= 8:
		return _ch_data_dialogue(id, done)
	match Global.chapter:
		2: return _ch2_dialogue(id, done)
		3: return _ch3_dialogue(id, done)
		4: return _ch4_dialogue(id, done)
		5: return _ch5_dialogue(id, done)
		6: return _ch6_dialogue(id, done)
	# --- Capítulo 1 (por defecto) ---
	match id:
		"plaza":     return _dlg_plaza()
		"casa_marta":return _dlg_marta_house(done)
		"exnovio":   return _dlg_exnovio(done)
		"emilio":    return _dlg_emilio(done)
		"rosa":      return _dlg_rosa(done)
		"tomas":     return _dlg_tomas(done)
		"carmen":    return _dlg_carmen(done)
		"iglesia":   return _dlg_iglesia()
		"comisaria": return _dlg_comisaria()
	return {"bg": "plaza", "beats": [{"who": "narrador", "text": "No hay nada más que hacer aquí."}]}


static func _dlg_plaza() -> Dictionary:
	return {
		"bg": "plaza",
		"flag": "done_plaza",
		"beats": [
			{"who": "narrador", "text": "Barrio Viejo. Medianoche. La lluvia no da tregua desde que sonaron las campanas a rebato."},
			{"who": "detective", "text": "Así que aquí es. Una mujer se esfuma en plena misa y nadie ve nada. Curioso."},
			{"who": "detective", "text": "Marta Soler. Treinta y dos años. Entró en la iglesia... y no volvió a salir."},
			{"who": "narrador", "text": "El barrio duerme a medias tras las contraventanas. Alguien vio algo. Alguien siempre ve algo."},
			{"who": "detective", "text": "Marta Soler vivía a dos calles de aquí. Empezaré por su casa."},
			{"who": "detective", "text": "El barrio es mío esta noche."},
		],
	}


static func _dlg_marta_house(done: bool) -> Dictionary:
	if done:
		return {"bg": "casa_marta", "beats": [
			{"who": "narrador", "text": "La casa de Marta sigue vacía, como la dejaste. La taza fría, la cama sin hacer."},
			{"who": "detective", "text": "La cita sin nombre en su agenda. Y Don Emilio, que estaba en misa. Sigo por ahí."},
		]}
	return {
		"bg": "casa_marta",
		"clue": {"title": "La cita sin nombre", "text": "En la agenda de Marta, una cita sin nombre la noche en que desapareció."},
		"flag": "done_casa_marta",
		"beats": [
			{"who": "narrador", "text": "El portal cede a la primera. Ni forzado ni cerrado con llave: entornado, como si Marta hubiera salido a por pan y fuera a volver en cualquier momento. No va a volver."},
			{"who": "detective", "text": "Primera regla: la casa de una persona habla más que la persona. Veamos qué me cuenta la tuya, Marta."},
			{"who": "narrador", "text": "Un piso pequeño, ordenado con esmero de quien tiene poco y lo cuida. Una taza de té a medias sobre la mesa, con una película fría en la superficie. La cama sin hacer. Todo detenido a media frase."},
			{"who": "detective", "text": "El té sin terminar. La cama deshecha. Salió con prisa, de noche, sin pensar en volver a una taza. O sin poder."},
			{"who": "narrador", "text": "En la estantería, una foto: Marta y otra mujer muy parecida, abrazadas, riéndose en una playa gris. Detrás, escrito a bolígrafo: 'Hermanas, pase lo que pase'."},
			{"who": "detective", "text": "Una hermana. Alguien a quien esto le va a partir en dos. Tomo nota: hay que encontrarla."},
			{"who": "narrador", "text": "Sobre la mesa, la agenda abierta por la fecha de ayer. La mayoría de los días están en blanco. Solo la casilla de la noche tiene algo escrito, con letra nerviosa."},
			{"who": "detective", "text": "'23:00'. Una hora. Sin nombre. ¿A quién se cita una a las once de la noche y prefiere no escribir su nombre ni en su propia agenda?"},
			{"who": "detective", "text": "A alguien a quien se teme. O a alguien prohibido. A veces son la misma persona."},
			{"choices": [
				{"text": "Registrar los cajones", "then": [
					{"who": "narrador", "text": "En el cajón de la mesilla, bajo un rosario, un fajo de estampas religiosas de San Judas Tadeo. El de las causas perdidas. Y una, arrugada, con un número de teléfono a lápiz, casi borrado."},
					{"who": "detective", "text": "Rezaba a las causas perdidas y guardaba un número sin nombre. Marta, te estabas ahogando y no se lo dijiste a nadie."},
				]},
				{"text": "Mirar hacia la ventana", "then": [
					{"who": "narrador", "text": "La ventana da justo a la torre de San José, negra sobre el cielo eléctrico. Desde el alféizar, alguien ha estado mirándola mucho: hay un cerco de tazas y una silla girada hacia el cristal."},
					{"who": "detective", "text": "Se sentaba a mirar el campanario. Como si de allí viniera lo que temía. O lo que esperaba."},
				]},
			]},
			{"who": "narrador", "text": "Clavada en la pared de la cocina, una circular de la parroquia: 'Misa de las 23:00. Rogamos puntualidad'. La misma hora de la cita."},
			{"who": "detective", "text": "La cita y la misa a la misma hora. No fue a rezar: fue a encontrarse con alguien a cubierto de todo el barrio. Qué mejor coartada que estar entre cien testigos."},
			{"who": "detective", "text": "Necesito a alguien que estuviera dentro de esa misa y con los oídos bien puestos. Don Emilio, el vecino, no se pierde una. Empiezo por él."},
		],
	}


static func _dlg_emilio(done: bool) -> Dictionary:
	if done:
		return {"bg": "casa_emilio", "beats": [
			{"who": "emilio", "text": "Ya se lo conté todo, hija. Ese grito junto al altar... aún lo tengo metido en el oído."},
			{"who": "emilio", "text": "Hable con la Rosa, la del atrio. Ella vigilaba la puerta principal."},
		]}
	return {
		"bg": "casa_emilio",
		"clue": {"title": "El grito", "text": "Durante las campanas se oyó un grito junto al altar."},
		"flag": "done_emilio",
		"beats": [
			{"who": "narrador", "text": "El portal huele a humedad y a geranios muertos. Llamas dos veces antes de que una cadena chirríe y una rendija de luz amarilla se abra en la penumbra."},
			{"who": "emilio", "text": "¿Quién anda...? Ah. Usted es la detective de la ciudad. La estaba esperando, aunque no me lo crea."},
			{"who": "narrador", "text": "Don Emilio quita la cadena. Es un hombre menudo, encogido dentro de un jersey de lana que le viene grande. Le tiemblan las manos, pero no de miedo: de años."},
			{"who": "emilio", "text": "Pase, pase, que se está mojando y aquí dentro al menos hay caldo caliente. Siéntese. La silla buena es esa, la otra cojea."},
			{"who": "detective", "text": "Gracias. No le robaré mucho tiempo, Don Emilio."},
			{"who": "emilio", "text": "Tiempo es lo único que me sobra, hija. Lo que se me acaba es el sueño. Desde anoche no pego ojo."},
			{"who": "narrador", "text": "Sobre la cómoda, un retrato en blanco y negro de una mujer joven. Él sigue tu mirada y sonríe con tristeza."},
			{"who": "emilio", "text": "Mi Amparo. Cuarenta años juntos y dos viéndola marchar poco a poco. Por eso voy a misa cada noche. Ya no rezo por mí."},
			{"who": "detective", "text": "Anoche también estaba usted en la iglesia."},
			{"who": "emilio", "text": "En mi banco de siempre, el tercero por la izquierda. Desde ahí se ve el altar entero. Y se oye. Vaya si se oye."},
			{"who": "detective", "text": "Cuénteme la noche. Desde el principio, sin prisa."},
			{"who": "emilio", "text": "Llovía como ahora, o peor. El padre Ismael empezó tarde porque la gente entraba goteando. Estaba la iglesia llena, cosa rara en noche de tormenta."},
			{"who": "emilio", "text": "A media misa se soltó el viento y las campanas empezaron a batir solas, a rebato, como cuando yo era niño y avisaban de riada. Un estruendo que no dejaba oír ni el sermón."},
			{"who": "emilio", "text": "Y entonces, entre campanada y campanada... un grito. Uno solo. Corto, agudo. Junto al altar."},
			{"who": "narrador", "text": "Se le quiebra la voz. Aprieta el borde de la mesa con los nudillos blancos."},
			{"who": "emilio", "text": "Me giré. La muchacha, la Marta, estaba en la primera fila y de pronto ya no estaba. Como si el suelo se la hubiera tragado. Se me heló la sangre, detective. Se me heló."},
			{"choices": [
				{"text": "\"¿Reconoció la voz del grito?\"", "then": [
					{"who": "emilio", "text": "Era de mujer, joven. Eso lo juraría. Pero con aquel repique... no le sabría decir si dijo un nombre o solo gritó por gritar."},
					{"who": "emilio", "text": "Aunque... hubo algo. Antes del grito me pareció oír unos pasos rápidos por el lateral. Botas, no zapatos de domingo. Botas."},
					{"who": "detective", "text": "(Botas. Otra vez las botas.)", "side": "right"},
				]},
				{"text": "\"¿Vio salir a alguien por la puerta?\"", "then": [
					{"who": "emilio", "text": "No, no... yo miraba al altar, como todos. La puerta grande la vigilaba la Rosa, esa nunca se mueve de su sitio. Pregúntele a ella, que tiene mejor vista que yo."},
				]},
				{"text": "\"¿Notó algo raro en Marta esos días?\"", "then": [
					{"who": "emilio", "text": "La veía rezar mucho últimamente. Y mirar hacia atrás, hacia la puerta, como quien espera a alguien que no quiere que llegue."},
					{"who": "emilio", "text": "Una noche la vi santiguarse tres veces seguidas. Tres. Eso no lo hace quien está en paz."},
				]},
			]},
			{"who": "detective", "text": "¿Y cuando encendieron las luces? Después del revuelo."},
			{"who": "emilio", "text": "El padre Ismael mandó callar y buscar. Miramos por todas partes. Nada. Ni la chica ni una pista. Solo el banco vacío y el reclinatorio caído."},
			{"who": "emilio", "text": "La gente empezó a decir que había sido un milagro al revés. Yo no creo en esas cosas. Los milagros no dejan un reclinatorio tirado de una patada."},
			{"who": "detective", "text": "Es usted mejor detective que la mitad de los míos, Don Emilio."},
			{"who": "emilio", "text": "Soy viejo, que no es lo mismo, pero se le parece. Uno aprende a mirar lo que sobra en un sitio y lo que falta."},
			{"who": "emilio", "text": "Y esa noche, en el altar, faltaba una muchacha y sobraban unos pasos con botas. Apúntelo, hija. Apúntelo bien."},
			{"who": "detective", "text": "Un grito junto al altar, en plena tormenta. Lo apunto. Gracias, Don Emilio."},
			{"who": "emilio", "text": "No me las dé. Encuéntrela. Y si ya no se puede... que al menos alguien pague por el reclinatorio de una patada. Vaya a ver a la Rosa. Ella vigilaba la puerta."},
		],
	}


static func _dlg_rosa(done: bool) -> Dictionary:
	if done:
		return {"bg": "iglesia_ext", "beats": [
			{"who": "rosa", "text": "Le repito lo mismo: por la puerta principal no salió nadie. Nadie."},
			{"who": "rosa", "text": "Si quiere más, hable con Tomás, el del colmado. Ese lo ve todo desde el mostrador."},
		]}
	return {
		"bg": "iglesia_ext",
		"clue": {"title": "La puerta principal", "text": "Nadie salió por la puerta principal: alguien vigilaba."},
		"flag": "done_rosa",
		"beats": [
			{"who": "narrador", "text": "El atrio de San José es un arco de piedra ennegrecida donde la lluvia repica como metralla. Bajo él, una mujer de verde botella fuma con la espalda muy recta, sin quitar ojo a la puerta grande."},
			{"who": "rosa", "text": "La estaba viendo cruzar la plaza. Camina usted como quien busca algo. Usted es la de la ciudad, la detective."},
			{"who": "detective", "text": "Rosa, ¿verdad? Me han dicho que anoche estuvo aquí, en la puerta."},
			{"who": "rosa", "text": "Aquí estoy siempre. Vendo estampas y velas a la entrada y a la salida. Cuarenta años haciéndolo. Esta puerta la conozco mejor que a mi marido, que en paz descanse."},
			{"who": "narrador", "text": "Da una calada larga. La brasa ilumina un rostro duro, de pómulos afilados y ojos que no parpadean."},
			{"who": "detective", "text": "Entonces, si alguien hubiera salido durante la misa, usted lo habría visto."},
			{"who": "rosa", "text": "No 'si'. Lo habría visto. Y no salió nadie. Ni durante la misa ni durante el revuelo. Por esta puerta no salió Marta Soler ni el Espíritu Santo."},
			{"who": "detective", "text": "Es una afirmación muy rotunda para una noche de tormenta."},
			{"who": "rosa", "text": "Mire, hija. Cuando empezaron las campanas a batir solas se me pusieron los pelos de punta y me pegué al quicio como una lapa. No me moví ni para persignarme. Si hubiera salido una mosca, la habría contado."},
			{"choices": [
				{"text": "\"¿Y las otras puertas de la iglesia?\"", "then": [
					{"who": "rosa", "text": "La lateral, la de la sacristía, estaba cerrada con llave. Yo misma vi al padre echarla al empezar, que hay mucho desalmado que entra a robar el cepillo."},
					{"who": "rosa", "text": "Y luego está la del campanario. Pero por ahí no entra ni sale nadie en misa. Esa llave la lleva el sacristán colgada del cinto."},
					{"who": "detective", "text": "(La del campanario. Guardemos eso.)", "side": "right"},
				]},
				{"text": "\"¿Se distrajo en algún momento?\"", "then": [
					{"who": "rosa", "text": "Ni un segundo, ya se lo he dicho. Bueno... miento. Hubo uno."},
					{"who": "rosa", "text": "Cayó un rayo que iluminó la nave entera como si fuera de día, y todos, todos, levantamos la cabeza hacia las vidrieras. Un instante. Un parpadeo."},
					{"who": "detective", "text": "(Un instante puede bastar. Todos mirando arriba, y alguien moviéndose abajo.)", "side": "right"},
					{"who": "rosa", "text": "No me mire así. Un rayo es un rayo. Cualquiera mira."},
				]},
				{"text": "\"¿Conocía usted bien a Marta?\"", "then": [
					{"who": "rosa", "text": "Me compraba una vela cada noche. Blanca, la más barata. La encendía siempre en el mismo sitio: ante San José, el de los imposibles."},
					{"who": "rosa", "text": "Últimamente venía pálida, con ojeras. Y una noche me pidió una estampa de San Judas. El de las causas perdidas. Me dio no sé qué dársela."},
				]},
			]},
			{"who": "detective", "text": "Rosa, si nadie salió por delante y las laterales estaban cerradas... ¿cómo desaparece una mujer de una iglesia llena?"},
			{"who": "rosa", "text": "Eso pregúnteselo a Dios, o al diablo, que de los dos hay en este barrio. Yo solo sé lo que vi. Y lo que no vi salir."},
			{"who": "rosa", "text": "Si quiere ojos en la CALLE y no en la puerta, hable con Tomás, el del colmado de la esquina. Ese, desde su mostrador, ve hasta lo que uno piensa."},
			{"who": "detective", "text": "Si nadie salió por delante... salió por otro sitio. Y solo queda uno. Gracias, Rosa."},
		],
	}


static func _dlg_tomas(done: bool) -> Dictionary:
	if done:
		return {"bg": "tienda", "beats": [
			{"who": "tomas", "text": "El tipo del capuchón, sí. Discutió con Marta. Ojalá me equivoque, pero mala espina me dio."},
			{"who": "tomas", "text": "Los secretos viejos del barrio, Doña Carmen. Pásese por su balcón."},
		]}
	return {
		"bg": "tienda",
		"clue": {"title": "El encapuchado", "text": "Marta discutió ayer con un hombre encapuchado."},
		"flag": "done_tomas",
		"beats": [
			{"who": "narrador", "text": "El colmado de Tomás tiene la persiana a media asta y un tubo de neón que parpadea sobre latas de conserva. Huele a café rancio y a serrín mojado. El tendero frota el mostrador con un trapo aunque ya brilla."},
			{"who": "tomas", "text": "Cierro en diez minutos, deten... ah. Usted no viene a comprar. Se le nota. Viene por la Marta."},
			{"who": "detective", "text": "Se nota mucho, por lo visto."},
			{"who": "tomas", "text": "En este barrio, forastero que aparece de noche, o es cura nuevo o es problema. Y usted no tiene cara de cura. Siéntese en el taburete, que cojea menos que yo."},
			{"who": "narrador", "text": "Deja el trapo. Tiene las manos grandes, agrietadas, de descargar cajas toda una vida. Los ojos, en cambio, son rápidos, listos."},
			{"who": "tomas", "text": "Marta venía cada noche. Leche, tabaco rubio y, los viernes, una tableta de turrón aunque no fuera Navidad. Decía que el azúcar la ayudaba a dormir. Buena chica. De las que pagan y saludan."},
			{"who": "detective", "text": "¿Notó algo distinto en ella últimamente?"},
			{"who": "tomas", "text": "Estaba asustada. Y no de deber dinero, que ese miedo lo conozco. Era otro. Miraba la calle antes de entrar. Y una vez me pidió salir por la puerta de atrás, la del almacén."},
			{"who": "detective", "text": "¿Y usted la dejó?"},
			{"who": "tomas", "text": "Claro que la dejé. A una mujer con ese miedo en la cara no le niegas una puerta. Ojalá le hubiera preguntado de quién huía. No lo hice. Con eso cargo yo ahora."},
			{"who": "narrador", "text": "Golpea el mostrador, más con pena que con rabia."},
			{"who": "tomas", "text": "Y ayer lo vi. Aquí mismo, en la esquina, bajo la farola que no funciona. Discutía con un hombre. Alto. Con capucha. No le vi la cara, se cuidó de no dármela."},
			{"who": "tomas", "text": "Ella le decía 'déjame en paz, ya te dije que no'. Él la agarró del brazo, fuerte. Salí con la escoba, más por hacer ruido que por otra cosa, y cuando llegué a la puerta ya no estaba. Se lo tragó la lluvia."},
			{"choices": [
				{"text": "\"¿Le había visto antes por el barrio?\"", "then": [
					{"who": "tomas", "text": "Nunca. Y mire que yo conozco hasta a los gatos por su nombre. Ese no era de aquí. Olía a otra parte, ¿me entiende? A dinero y a ciudad."},
					{"who": "tomas", "text": "Los de aquí andan encogidos por la lluvia. Ese andaba recto, como si la lluvia fuera para los demás."},
				]},
				{"text": "\"¿Recuerda algún detalle suyo?\"", "then": [
					{"who": "tomas", "text": "Botas. Buenas botas, de cuero, de las caras. Y bajo la capucha un abrigo largo, de paño fino. Un señorito jugando a ser sombra."},
					{"who": "tomas", "text": "Ah, y un anillo. En la mano con que la agarró. Grande, de sello. Brilló un segundo con el neón. Oro, o algo que quería parecerlo."},
					{"who": "detective", "text": "(Botas caras. Un anillo de sello. No es un vecino: es alguien que baja al barrio.)", "side": "right"},
				]},
				{"text": "\"¿Por qué no avisó a la comisaría?\"", "then": [
					{"who": "tomas", "text": "¿A la comisaría? Ja. En este barrio, detective, la comisaría es donde van a morir las denuncias. Uno aprende a callar y a bajar la persiana."},
					{"who": "tomas", "text": "Aunque el sargento Núñez... ese es distinto. A ese sí le importaría. Si es que le dejan que le importe."},
				]},
			]},
			{"who": "detective", "text": "Un hombre de fuera, con dinero, que la agarra del brazo la víspera de desaparecer. Esto ya no huele a milagro."},
			{"who": "tomas", "text": "Nunca olió a milagro. Olió a lo de siempre: a alguien fuerte haciéndole daño a alguien que no puede defenderse."},
			{"who": "tomas", "text": "Si quiere entender el barrio de verdad, y quién puede entrar y salir sin que nadie chiste, hable con Doña Carmen. La del balcón de los geranios. Esa lo sabe todo antes de que pase."},
			{"who": "detective", "text": "Un encapuchado con botas caras y un anillo de sello. Lo apunto en negrita. Gracias, Tomás. Y baje la persiana esta noche."},
		],
	}


static func _dlg_carmen(done: bool) -> Dictionary:
	if done:
		return {"bg": "casa_carmen", "beats": [
			{"who": "carmen", "text": "El campanario, niña. Ya te lo dije. Todo lo que sube por ahí, baja por detrás."},
			{"who": "carmen", "text": "Ya tienes lo que necesitas. Entra en la iglesia de San José."},
		]}
	return {
		"bg": "casa_carmen",
		"clue": {"title": "El campanario", "text": "La puerta del campanario estaba abierta esa noche."},
		"flag": "done_carmen",
		"beats": [
			{"who": "narrador", "text": "No hace falta llamar. Doña Carmen ya está en el balcón, entre geranios que gotean, envuelta en un mantón negro. Te mira bajar la calle como quien lleva rato esperando a un invitado que se retrasa."},
			{"who": "carmen", "text": "Has tardado más de lo que pensaba, detective. Emilio, Rosa, el Tomás... todos antes que la vieja Carmen. Siempre igual. La última en la que piensan y la primera que sabe."},
			{"who": "detective", "text": "¿Y qué sabe la vieja Carmen?"},
			{"who": "carmen", "text": "Sube. La puerta está abierta. En esta casa las puertas siempre están abiertas para quien busca la verdad. Es a los mentirosos a los que se las cierro."},
			{"who": "narrador", "text": "El piso huele a membrillo y a tiempo detenido. Relojes por todas partes, ninguno a la misma hora. Ella se sienta en una mecedora frente a la ventana, desde la que se ve, justo enfrente, el campanario de San José."},
			{"who": "carmen", "text": "El Barrio Viejo guarda secretos, hija. Y yo los guardo todos, porque desde este balcón llevo cincuenta años viendo entrar y salir a los vivos y a los muertos."},
			{"who": "detective", "text": "Entonces guárdeme uno esta noche, Doña Carmen. El de la iglesia. El de Marta."},
			{"who": "carmen", "text": "Esa pobre criatura. ¿Sabes qué es lo que más miedo da de este barrio? Que aquí nadie desaparece del todo. Siempre queda quien lo vio y calla."},
			{"who": "narrador", "text": "Señala con un dedo torcido hacia la ventana, hacia la torre negra recortada contra los relámpagos."},
			{"who": "carmen", "text": "Esa noche, entre campanada y campanada, oí una que no tocaba. La campana pequeña, la del muerto, sonó a destiempo. Sola. Yo esa campana la conozco: solo suena si alguien pisa el suelo del campanario."},
			{"who": "carmen", "text": "Y nadie sube al campanario durante la misa, detective. Nadie. Salvo que quiera bajar por donde nadie mira."},
			{"who": "detective", "text": "¿La puerta del campanario estaba abierta?"},
			{"who": "carmen", "text": "Abierta de par en par. Lo vi con estos ojos cuando cesó la tormenta: un rectángulo negro en lo alto de la torre, como una boca. Por la mañana ya estaba cerrada otra vez. Alguien la cerró. Alguien con prisa y con llave."},
			{"choices": [
				{"text": "\"¿Quién tiene llave del campanario?\"", "then": [
					{"who": "carmen", "text": "Oficialmente, el sacristán. Ese pobre no rompería un plato. Pero las llaves, hija, se prestan. Se copian. Se roban."},
					{"who": "carmen", "text": "Pregunta en la comisaría, cuando tengas agallas. Y pregunta por quién MÁS tenía copia de esa llave. Ahí empieza lo gordo. Ahí es donde a la gente le entra la tos y cambia de tema."},
				]},
				{"text": "\"¿Vio usted a alguien en la torre?\"", "then": [
					{"who": "carmen", "text": "Una silueta. Un momento, contra el resplandor de un rayo. Cargaba con algo. Con alguien, quiero decir. Al hombro, como un saco."},
					{"who": "carmen", "text": "Y no era el jorobado del sacristán. Este iba recto. Alto. Con un abrigo largo que el viento levantaba como alas de cuervo."},
					{"who": "detective", "text": "(El encapuchado de Tomás. El mismo abrigo. El mismo hombre.)", "side": "right"},
				]},
				{"text": "\"¿Por qué me cuenta todo esto a mí?\"", "then": [
					{"who": "carmen", "text": "Porque Marta me subía la compra cuando me fallan las piernas, sin pedir nada. Porque era buena sin presumir de serlo, que es la única bondad que vale."},
					{"who": "carmen", "text": "Y porque tú, hija, no eres de las que se rinden. Se te ve en el paso. A los demás la lluvia los encoge; a ti te endereza. Encuentra a quien hizo esto."},
				]},
			]},
			{"who": "carmen", "text": "Una cosa más, y ya me callo. No es la primera. Hace años, otra muchacha. Otra tormenta. También dijeron milagro. También cerraron el caso rápido. Pregúntate por qué siempre llueve cuando desaparece una mujer en este barrio."},
			{"who": "detective", "text": "El campanario. Ahí está la salida que nadie vio. Ya tengo lo que necesito para entrar en la iglesia."},
			{"who": "carmen", "text": "Ve con Dios, o sin él, que para lo que vas a encontrar quizá sea mejor ir sola. Y abrígate, que la torre es fría y guarda más de un frío."},
		],
	}


static func _dlg_iglesia() -> Dictionary:
	return {
		"bg": "iglesia_ext",
		"clue": {"title": "El pañuelo", "text": "Un pañuelo con las iniciales M.S. junto a la escalera del campanario."},
		"flag": "cap1_completo",
		"beats": [
			{"who": "narrador", "text": "La puerta de San José pesa como una losa. Dentro, la nave está vacía y a oscuras, iluminada solo por el rojo tembloroso de las lamparillas votivas. Huele a incienso frío y a piedra mojada."},
			{"who": "detective", "text": "Cuatro pistas. Un grito junto al altar. Nadie por la puerta principal. Un encapuchado con anillo de sello. Y un campanario abierto a destiempo."},
			{"who": "detective", "text": "Todo apunta hacia arriba. A esa torre. Rosa vigilaba la puerta; nadie mentía. Es que Marta no salió por ninguna puerta que dé a la calle."},
			{"who": "narrador", "text": "Ante el altar, un reclinatorio sigue caído de lado. Nadie lo ha enderezado. La primera fila conserva una vela consumida hasta el metal, blanca, ante la imagen de San José."},
			{"who": "detective", "text": "Su vela. La encendió antes de morir... o antes de lo que fuera. Aquí estaba sentada. Aquí gritó."},
			{"who": "narrador", "text": "Junto al muro lateral, medio oculta tras un confesonario, una portezuela baja. Entornada. Del otro lado arranca una escalera de caracol que se pierde hacia arriba, en la negrura."},
			{"who": "detective", "text": "La puerta del campanario. Doña Carmen tenía razón. Subamos."},
			{"who": "narrador", "text": "Los peldaños de piedra están gastados y húmedos. La escalera cruje, sube y sube. A media altura, la linterna capta algo en el polvo del escalón: dos surcos paralelos.", "bg": "iglesia_int"},
			{"who": "detective", "text": "Marcas de arrastre. Talones. Alguien subió a un cuerpo por aquí, escalón a escalón. Un cuerpo que no colaboraba."},
			{"who": "narrador", "text": "Arriba, el campanario se abre a la noche. El viento entra por los arcos y hace oscilar las cuerdas de las campanas, que gimen bajito. La ciudad de neón late a lo lejos, indiferente."},
			{"who": "detective", "text": "Desde aquí se domina todo el barrio. Y hay una escala de servicio que baja por fuera, por detrás, al callejón. Por donde no mira nadie."},
			{"who": "narrador", "text": "En el suelo, junto al hueco de la escala exterior, algo blanco destaca contra la mugre. Te agachas. Un pañuelo de tela, bordado con esmero. En una esquina, dos iniciales: M. S."},
			{"who": "detective", "text": "Marta Soler. La subieron mientras el rayo cegaba a todos, la bajaron por la escala de atrás y se la llevaron por el callejón. Coartada de tormenta y salida de campanario."},
			{"choices": [
				{"text": "Examinar el hueco de la escala", "then": [
					{"who": "narrador", "text": "En el barandal metálico, enganchada, una hebra de paño oscuro, caro. Y una marca fresca: algo pesado rozó al bajar, hace poco."},
					{"who": "detective", "text": "Paño fino. El abrigo del encapuchado. No me cabe duda: es el mismo hombre que Tomás vio agarrarla del brazo."},
				]},
				{"text": "Mirar el pañuelo a la luz", "then": [
					{"who": "narrador", "text": "Bajo la linterna, junto a las iniciales, una mancha parda, seca. Y un olor tenue, dulzón, químico. No es sangre: es otra cosa."},
					{"who": "detective", "text": "Cloroformo, o algo parecido. No la mataron aquí. Se la llevaron viva. Eso cambia el reloj: puede que aún estemos a tiempo."},
				]},
			]},
			{"who": "detective", "text": "No fue una desaparición. Ni un milagro. Fue un secuestro planeado con frialdad de relojero, usando la misa como tapadera."},
			{"who": "narrador", "text": "Guardas el pañuelo en una bolsa. El primer nudo del caso está deshecho, pero el hilo sigue, y se hunde en algo mucho más grande y más negro que una sola noche de lluvia."},
			{"who": "detective", "text": "Quien planea así no improvisa, y no lo hace por primera vez. Necesito los archivos. Sargento Núñez. Es hora de una visita oficial a la comisaría."},
		],
	}


static func _dlg_comisaria() -> Dictionary:
	return {
		"bg": "comisaria",
		"flag": "done_comisaria",
		"beats": [
			{"who": "narrador", "text": "La comisaría del Barrio Viejo es un cuarto estrecho con una bombilla desnuda, un ventilador roto y expedientes apilados hasta el techo, amarilleando. Huele a tabaco viejo y a café quemado."},
			{"who": "nunez", "text": "Pase, detective, y cierre. Aquí las paredes oyen y algunas hasta cobran por lo que oyen."},
			{"who": "narrador", "text": "El sargento Núñez es un hombre grande, cansado, con la corbata floja y unos ojos que han visto demasiado archivo cerrado por orden de arriba."},
			{"who": "nunez", "text": "Así que subió al campanario. Buen ojo. Mis 'compañeros' pasaron por delante de esa puerta tres veces y anotaron 'sin novedad'. Sin novedad. Con las marcas de arrastre en el polvo."},
			{"who": "detective", "text": "Tengo un pañuelo con las iniciales de Marta, restos de cloroformo y una hebra del abrigo del hombre que la bajó por la escala trasera. No se desvaneció. Se la llevaron."},
			{"who": "nunez", "text": "Lo sé. Y le voy a contar algo que no está en ningún parte, porque en cuanto lo escribo, desaparece del archivo a la mañana siguiente."},
			{"who": "narrador", "text": "Se levanta, comprueba que el pasillo está vacío y vuelve a sentarse, bajando la voz."},
			{"who": "nunez", "text": "Marta Soler no es la primera. Es la tercera este mes. Tres mujeres. Tres noches de tormenta. Tres campanarios distintos del Barrio Viejo."},
			{"who": "detective", "text": "¿Tres? ¿Y por qué no consta ni una línea en ningún sitio?"},
			{"who": "nunez", "text": "Porque alguien de muy arriba quiere que no conste. Cada vez que abro uno de estos casos, me llega una llamada. Educada. Amable. 'Sargento, no se complique la jubilación'."},
			{"choices": [
				{"text": "\"¿Sospecha de alguien de dentro?\"", "then": [
					{"who": "nunez", "text": "Sospecho de todos y no puedo probar nada. Alguien avisa a ese hombre de cuándo hay misa multitudinaria. Alguien le consigue copia de las llaves de los campanarios. Eso no lo hace un forastero solo."},
					{"who": "nunez", "text": "Hay una mano dentro y una mano fuera. La de fuera es la del abrigo caro. La de dentro... la de dentro lleva placa, me temo."},
				]},
				{"text": "\"¿Qué tenían en común las tres?\"", "then": [
					{"who": "nunez", "text": "Jóvenes. Solas, sin familia que diera guerra. Y las tres, en las semanas previas, habían ido a pedir ayuda a la misma parroquia. A San José y a las otras dos."},
					{"who": "detective", "text": "(Iban a la iglesia a buscar refugio. Y el refugio era la trampa.)", "side": "right"},
				]},
				{"text": "\"¿Por qué me llama a mí y no a los suyos?\"", "then": [
					{"who": "nunez", "text": "Porque usted viene de fuera y no le deben nada a nadie de aquí. Porque a usted no la pueden llamar por teléfono a las tres de la mañana. Todavía."},
					{"who": "nunez", "text": "Y porque estoy viejo y harto de firmar 'sin novedad' sobre la vida de tres mujeres."},
				]},
			]},
			{"who": "narrador", "text": "Núñez desliza sobre la mesa una carpeta gris sin nombre. Dentro, dos fotografías más de dos mujeres que sonríen sin saber. Y dos pañuelos más, bordados, cada uno con sus iniciales."},
			{"who": "detective", "text": "Entonces esto no es un caso, sargento. Es una serie. Y alguien lleva meses cerrándola con carpetazo."},
			{"who": "nunez", "text": "Ahora ya somos dos los que lo sabemos. Cuídese, detective. A partir de esta noche, usted también es un cabo suelto para ellos."},
			{"who": "narrador", "text": "Guardas la carpeta bajo la gabardina. Fuera, la lluvia arrecia otra vez sobre el neón del Barrio Viejo."},
			{"who": "narrador", "text": "— FIN DEL CAPÍTULO 1 —  El campanario de San José calla. Pero en algún tejado, bajo la próxima tormenta que ya se forma, alguien afila el reloj para la cuarta."},
		],
	}


# ===========================================================================
#  CAPÍTULO 2 · Las campanas que faltan
# ===========================================================================
static func _ch2_dialogue(id: String, done: bool) -> Dictionary:
	match id:
		"brief":      return _dlg_brief(done)
		"archivo":    return _dlg_archivo(done)
		"voluntario": return _dlg_voluntario(done)
		"laura":      return _dlg_laura(done)
		"refugio": return _dlg_refugio(done)
		"capilla": return _dlg_capilla(done)
		"muelle":  return _dlg_muelle()
		"cierre2": return _dlg_cierre2()
	return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}


static func _dlg_brief(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "nunez", "text": "Ya tiene los tres nombres. Elena, Nadia, Marta. Empiece por el archivo del sótano, detective."},
		]}
	return {
		"bg": "comisaria",
		"flag": "done_brief",
		"beats": [
			{"who": "narrador", "text": "Amanece gris sobre el Barrio Viejo. La comisaría huele a café recalentado. Núñez ha extendido tres carpetas sobre la mesa, como quien reparte una mala mano de cartas."},
			{"who": "nunez", "text": "Antes de que se arrepienta: en cuanto toque estos papeles, ya no hay marcha atrás. Para ninguno de los dos."},
			{"who": "detective", "text": "Ya no había marcha atrás la noche que subí a ese campanario. Deme los nombres."},
			{"who": "nunez", "text": "Elena Ruiz, veintiocho. Desapareció hace tres semanas en Santa Rita, durante una tormenta. Nadia Kovac, veinticuatro, hace dos, en la ermita del Cristo. Y Marta. Tres iglesias, tres tormentas."},
			{"who": "detective", "text": "Un patrón perfecto. Demasiado perfecto. ¿Qué se hizo con estos casos?"},
			{"who": "nunez", "text": "Se cerraron en cuarenta y ocho horas. 'Abandono voluntario del domicilio'. Firmados por arriba. Yo solo pude quedarme las copias que ve, y porque las escondí."},
			{"choices": [
				{"text": "\"¿Quién los cerró?\"", "then": [
					{"who": "nunez", "text": "La firma es de la comisaría central. Un nombre con demasiados galones para que yo lo diga en voz alta dentro de este edificio."},
				]},
				{"text": "\"¿Por dónde empiezo?\"", "then": [
					{"who": "nunez", "text": "Por el archivo del sótano. Ahí está lo que no cabe en estas tres carpetas. Cruce las fechas, los barrios, los conocidos. Busque lo que se repite."},
				]},
			]},
			{"who": "detective", "text": "Tres mujeres, tres campanarios, una misma mano borrando el rastro. Al archivo. Si hay un hilo común, estará enterrado ahí abajo."},
		],
	}


static func _dlg_archivo(done: bool) -> Dictionary:
	if done:
		return {"bg": "archivo", "beats": [
			{"who": "detective", "text": "El hilo común: las tres pasaron por la Fundación Amparo. Y alguien pidió los horarios de misa. La hermana de Marta, Laura, era su contacto."},
		]}
	return {
		"bg": "archivo",
		"clue": {"title": "El hilo común", "text": "Las tres víctimas pasaron por la Fundación Amparo antes de desaparecer."},
		"flag": "done_archivo",
		"beats": [
			{"who": "narrador", "text": "El archivo es un sótano sin ventanas, con estanterías metálicas que se pierden en la penumbra y un zumbido de fluorescente moribundo. Décadas de barrio dormidas en cajas."},
			{"who": "detective", "text": "Bien. Aquí nadie me llama por teléfono. Crucemos los tres nombres y veamos qué comparten además de una tormenta."},
			{"who": "narrador", "text": "Horas de polvo. Fichas, denuncias archivadas, recibos. Poco a poco, tres carpetas distintas empiezan a repetir una misma palabra en los márgenes."},
			{"who": "detective", "text": "'Amparo'. Fundación Amparo. Las tres pidieron ayuda ahí en las semanas previas. Un comedor social, un refugio para mujeres. Elena, Nadia, Marta. Las tres."},
			{"choices": [
				{"text": "Revisar los movimientos internos", "then": [
					{"who": "narrador", "text": "En una bandeja de correspondencia interna, un memorándum sin firmar: alguien solicitó a las tres parroquias los horarios de las misas con más asistencia. Fechado justo antes de cada tormenta."},
					{"who": "detective", "text": "Alguien de dentro pidió los horarios. Para saber cuándo la iglesia estaría llena. La coartada se encarga por escrito."},
				]},
				{"text": "Buscar los contactos de las fichas", "then": [
					{"who": "narrador", "text": "En la ficha de Marta, una casilla de 'persona de contacto': Laura Soler. Hermana. Con una dirección al otro lado del canal."},
					{"who": "detective", "text": "Laura. La hermana de la foto de la playa. Si Marta se estaba ahogando, se lo contó a ella antes que a nadie."},
				]},
			]},
			{"who": "detective", "text": "El hilo común es la Fundación Amparo. Y el primer cabo que puedo tirar tiene nombre: Laura Soler. Voy a verla."},
		],
	}


static func _dlg_laura(done: bool) -> Dictionary:
	if done:
		return {"bg": "casa_laura", "beats": [
			{"who": "laura", "text": "Ya se lo dije: Marta ayudaba en el Amparo. Y ese 'benefactor' que la rondaba... vaya usted allí. Pregunte por él."},
		]}
	return {
		"bg": "casa_laura",
		"clue": {"title": "El voluntariado", "text": "Marta era voluntaria en Amparo; un 'benefactor' se había fijado en ella."},
		"flag": "done_laura",
		"beats": [
			{"who": "narrador", "text": "Laura Soler tiene los mismos ojos que su hermana en la foto de la playa, pero apagados. Abre la puerta con un pañuelo estrujado en la mano."},
			{"who": "laura", "text": "Usted es la que no ha firmado 'abandono voluntario'. Núñez me avisó. Pase. Perdone el desorden, ya no... ya no ordeno para nadie."},
			{"who": "detective", "text": "Siento lo de Marta, Laura. Necesito entenderla para encontrarla. ¿Qué era la Fundación Amparo para ella?"},
			{"who": "laura", "text": "Su refugio. Marta lo pasó mal, deudas, un novio de los que dejan marca. En Amparo le dieron comida, papeles, un sitio donde llorar. Ella lo devolvió haciéndose voluntaria. Era así."},
			{"who": "laura", "text": "Al principio le brillaban los ojos hablando de aquello. Después... después empezó a tener miedo otra vez. Y esta vez no era del novio."},
			{"choices": [
				{"text": "\"¿De qué tenía miedo?\"", "then": [
					{"who": "laura", "text": "De un hombre. Un 'benefactor', decía ella con retintín. Un señor rico que financiaba el refugio y que se había 'fijado en ella'. La invitaba a 'retiros'. Le regalaba cosas caras."},
					{"who": "laura", "text": "Marta no era tonta. Sabía que esa clase de generosidad siempre pasa factura. Quiso dejar el voluntariado. Y entonces empezaron las tormentas."},
				]},
				{"text": "\"¿Le dio algún nombre?\"", "then": [
					{"who": "laura", "text": "Nunca. Decía que era mejor que yo no lo supiera. Solo una vez soltó que llevaba 'un anillo de esos con escudo, como los marqueses de antes'."},
					{"who": "detective", "text": "(El anillo de sello. Otra vez. El encapuchado de Tomás y el 'benefactor' son el mismo hombre.)", "side": "right"},
				]},
			]},
			{"who": "narrador", "text": "Laura rebusca en un cajón y te tiende una tarjeta ajada: 'Fundación Amparo — Sr. Vidal, administrador'."},
			{"who": "laura", "text": "Esto lo dejó Marta. Encuentre a ese benefactor, detective. Y encuentre a mi hermana. Aunque sea para traérmela y enterrarla como Dios manda."},
			{"who": "detective", "text": "El voluntariado, el benefactor del anillo. Lo apunto. Empezaré por la Fundación. Gracias, Laura."},
		],
	}


static func _dlg_refugio(done: bool) -> Dictionary:
	if done:
		return {"bg": "refugio", "beats": [
			{"who": "vidal", "text": "Ya le he dicho todo lo que sé, detective. El benefactor es anónimo. Y la capilla de abajo... no es asunto suyo."},
			{"who": "detective", "text": "(La capilla de abajo. Justo lo que necesitaba oír.)", "side": "right"},
		]}
	return {
		"bg": "refugio",
		"clue": {"title": "El benefactor", "text": "Un mecenas anónimo con anillo de sello financia 'retiros' desde la Fundación."},
		"flag": "done_refugio",
		"beats": [
			{"who": "narrador", "text": "La Fundación Amparo ocupa un edificio restaurado con dinero que se nota: mármol nuevo, un logo dorado, calefacción. Demasiado caro para un comedor social. El Sr. Vidal te recibe con una sonrisa de dentífrico."},
			{"who": "vidal", "text": "¡Detective! Qué honor. Aquí solo hacemos el bien, ya lo ve. Damos de comer, damos cobijo. ¿En qué puedo ayudarla, aunque sea tarde?"},
			{"who": "detective", "text": "Marta Soler era voluntaria aquí. Y ha desaparecido. Como Elena Ruiz. Como Nadia Kovac. Las tres, de aquí."},
			{"who": "vidal", "text": "Terrible, terrible. Pero coincidencia, detective. Por aquí pasan cientos de personas. Que a tres les haya ido mal después no nos convierte en... en lo que insinúa."},
			{"who": "narrador", "text": "Sonríe, pero un músculo de la mandíbula le tiembla. Sobre su mesa, un folleto: 'Retiros de silencio — solo por invitación del patrono'."},
			{"choices": [
				{"text": "\"Hábleme del benefactor.\"", "then": [
					{"who": "vidal", "text": "El patrono desea el anonimato. Es un caballero de gran corazón que sostiene esta casa entero. No puedo, y no quiero, dar su nombre."},
					{"who": "vidal", "text": "Solo le diré que es un hombre de otra época. Con modales. Con... clase. Lleva siempre un anillo de familia. Un detalle encantador."},
					{"who": "detective", "text": "(Un anillo de familia. Encantador. Y el mismo que aprieta brazos en callejones.)", "side": "right"},
				]},
				{"text": "\"¿Qué son esos retiros?\"", "then": [
					{"who": "vidal", "text": "Un regalo del patrono a las voluntarias más... entregadas. Unos días de paz fuera de la ciudad. Marta estaba invitada al próximo, ¿sabe? Qué pena que no llegara a ir."},
					{"who": "detective", "text": "(Elegía a sus víctimas y las 'invitaba'. Vidal las servía en bandeja.)", "side": "right"},
				]},
			]},
			{"who": "narrador", "text": "Suena un teléfono en el despacho de al lado. Vidal se disculpa con demasiada prisa. Por una puerta entreabierta, al fondo, ves una escalera que baja: 'Capilla privada — Patronato'."},
			{"who": "detective", "text": "El benefactor con anillo, los 'retiros', y una capilla privada bajo tierra a la que Vidal no quiere que baje. Ahí abajo está la verdad. Voy a colarme."},
		],
	}


static func _dlg_capilla(done: bool) -> Dictionary:
	if done:
		return {"bg": "capilla", "beats": [
			{"who": "detective", "text": "El libro de la capilla lo dice todo: horarios de misa y un memo policial. La mano de dentro existe. Toca esperar en el muelle."},
		]}
	return {
		"bg": "capilla",
		"clue": {"title": "La agenda de misas", "text": "Un libro con los horarios de misa de las tres parroquias y una copia de un memo policial."},
		"flag": "done_capilla",
		"beats": [
			{"who": "narrador", "text": "La escalera desemboca en una capilla pequeña y fría, sin santos, con las paredes forradas de terciopelo rojo. No huele a incienso: huele a cerrado y a dinero. Sobre un atril, un libro grande, abierto."},
			{"who": "detective", "text": "Esto no es una capilla. Es el despacho privado de alguien que juega a ser dios. Veamos su libro de oraciones."},
			{"who": "narrador", "text": "No hay salmos. Hay columnas: fechas, parroquias, horas de misa concurrida. Santa Rita. El Cristo. San José. Y al lado de cada una, una marca de visto bueno."},
			{"who": "detective", "text": "La agenda de misas. Elegía la noche, la iglesia llena, la tormenta anunciada. Todo cuadrado como un horario de trenes."},
			{"choices": [
				{"text": "Buscar entre los papeles del atril", "then": [
					{"who": "narrador", "text": "Bajo el libro, una copia mecanografiada: un memorándum con membrete de la policía, autorizando 'no asignar patrullas' a esas zonas en esas fechas exactas."},
					{"who": "detective", "text": "Una orden para dejar el barrio sin vigilancia justo esas noches. Esto solo lo firma alguien con mando. La mano de dentro tiene despacho y placa."},
				]},
				{"text": "Fijarte en el motivo de la pared", "then": [
					{"who": "narrador", "text": "En el terciopelo, bordado en hilo de oro, un emblema: tres campanas bajo una corona. Y un lema: 'Lo que suena, es mío'."},
					{"who": "detective", "text": "Tres campanas. Un coleccionista. Para él no son mujeres: son piezas. Trofeos con nombre de iglesia."},
				]},
			]},
			{"who": "narrador", "text": "Arriba se oyen pasos y la voz nerviosa de Vidal despidiendo a alguien. Y otra voz, grave, tranquila, que ordena: 'Esta noche, en el muelle. La última carga'."},
			{"who": "detective", "text": "La última carga. Esta noche. En el muelle viejo. Si quiero atrapar al benefactor con las manos en la masa, es ahí y es ya."},
		],
	}


static func _dlg_muelle() -> Dictionary:
	return {
		"bg": "muelle",
		"clue": {"title": "La cuarta víctima", "text": "El benefactor prepara una cuarta. Su chófer lleva placa: hay un policía implicado."},
		"flag": "cap2_completo",
		"beats": [
			{"who": "narrador", "text": "El muelle viejo es un bosque de grúas muertas y neón reflejado en charcos de aceite. Bajo la lluvia, una furgoneta negra con el motor en marcha. Dos siluetas cargan un bulto largo, envuelto."},
			{"who": "detective", "text": "Un bulto del tamaño de una persona. La cuarta. Llegué a tiempo... o casi."},
			{"who": "narrador", "text": "Reconoces al más alto: abrigo de paño, capucha, y al girarse, el destello de un anillo de sello bajo una farola. El benefactor en persona."},
			{"who": "detective", "text": "¡Alto! ¡Policía! ¡Aparta de la furgoneta!"},
			{"who": "narrador", "text": "El encapuchado ni se inmuta. Hace un gesto seco al otro, que se vuelve hacia ti abriéndose la chaqueta: bajo ella, una pistola reglamentaria y, prendida al cinturón, una placa."},
			{"choices": [
				{"text": "Cubrirte y memorizar la matrícula", "then": [
					{"who": "narrador", "text": "Te tiras tras un contenedor mientras la furgoneta arranca chirriando. Alcanzas a grabar la matrícula y, en la puerta, un adhesivo oficial de vehículo municipal."},
					{"who": "detective", "text": "Vehículo municipal. Placa. El chófer del monstruo es uno de los nuestros. Por eso nunca hubo patrullas."},
				]},
				{"text": "Ir a por el encapuchado", "then": [
					{"who": "narrador", "text": "Corres, pero el del arma dispara al suelo, a tus pies, para frenarte. Cuando levantas la vista, las luces traseras ya se pierden en la lluvia. En el suelo, un mechero de plata caído."},
					{"who": "detective", "text": "Se me ha escapado. Pero se ha dejado algo. Un mechero con un escudo grabado: tres campanas y una corona. Su firma."},
				]},
			]},
			{"who": "detective", "text": "No he salvado a la cuarta. Pero ahora sé dos cosas: que hay un policía en esto, y que el benefactor colecciona. Y a los coleccionistas se les encuentra por su colección."},
			{"who": "narrador", "text": "Guardas la prueba, temblando de rabia y de agua. El hilo ya no se hunde en el barrio: sube, hacia arriba, hacia los despachos con galones."},
			{"who": "detective", "text": "Núñez tiene que ver esto. Aunque lo que voy a contarle le cueste la jubilación de verdad."},
		],
	}


static func _dlg_cierre2() -> Dictionary:
	return {
		"bg": "comisaria",
		"flag": "done_cierre2",
		"beats": [
			{"who": "narrador", "text": "De vuelta en la comisaría, de madrugada. Núñez escucha la grabación de la matrícula con la cara cada vez más gris."},
			{"who": "nunez", "text": "Ese vehículo... es de la central. Y esa matrícula la firma el parque móvil a nombre del despacho del comisario Bru."},
			{"who": "detective", "text": "¿Bru? ¿Su superior?"},
			{"who": "nunez", "text": "Mi superior. El que cierra los casos en cuarenta y ocho horas. El que me llama para que no me complique. Todo encaja, y ojalá no encajara."},
			{"who": "narrador", "text": "Suena el teléfono de la comisaría. Núñez descuelga, escucha, y cuelga muy despacio."},
			{"who": "nunez", "text": "Era de arriba. Me acaban de 'sugerir' que le retire a usted el acceso al caso. A estas horas. Justo ahora. ¿Entiende lo que significa?"},
			{"who": "detective", "text": "Que les hemos pisado la cola. Y que el benefactor no es un forastero rico: es alguien a quien la placa protege."},
			{"who": "nunez", "text": "No puedo darle una orden para lo que viene, detective. Oficialmente, a partir de ahora está usted sola. Extraoficialmente... el mechero lleva un escudo. Averigüe de qué familia es. Ahí está su hombre."},
			{"who": "narrador", "text": "— FIN DEL CAPÍTULO 2 —  El caso ya no cabe en una carpeta gris. Cabe en un apellido con escudo. Y la cuarta tormenta se acerca."},
		],
	}


# ===========================================================================
#  CAPÍTULO 3 · El coleccionista
# ===========================================================================
static func _ch3_dialogue(id: String, done: bool) -> Dictionary:
	match id:
		"aviso":   return _dlg_aviso(done)
		"soplo":   return _dlg_soplo(done)
		"mansion": return _dlg_mansion(done)
		"sotano":  return _dlg_sotano(done)
		"padre":   return _dlg_padre(done)
		"torre":   return _dlg_torre()
		"cierre3": return _dlg_cierre3()
	return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}


static func _dlg_aviso(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "nunez", "text": "El escudo es de los Bru. La mansión está junto al parque. Vaya con cuidado, que ya no la cubre nadie."},
		]}
	return {
		"bg": "comisaria",
		"flag": "done_aviso",
		"beats": [
			{"who": "narrador", "text": "Núñez te espera en el coche, en un callejón, con las luces apagadas. Ya no confía ni en su propia comisaría."},
			{"who": "nunez", "text": "El escudo del mechero: tres campanas y una corona. Es el blasón de los Bru. Una familia de toda la vida. Y el comisario es el último de la estirpe."},
			{"who": "detective", "text": "El benefactor con anillo y el comisario que cierra los casos son la misma persona."},
			{"who": "nunez", "text": "Eso creo. Y si tengo razón, ninguna orden mía vale ya nada contra él. Le he traído lo único que puedo darle: la dirección de su mansión, junto al parque."},
			{"who": "nunez", "text": "Escúcheme bien: si entra ahí, entra sola y sin placa que la respalde. Si algo sale mal, no habrá comisaría que la busque."},
			{"who": "detective", "text": "Hay una cuarta mujer en algún sitio y una tormenta subiendo por el río. No es momento de esperar una orden. Voy a esa mansión."},
		],
	}


static func _dlg_mansion(done: bool) -> Dictionary:
	if done:
		return {"bg": "mansion", "beats": [
			{"who": "detective", "text": "La sala de las campanas ya la he visto. Sus trofeos. Lo que importa está más abajo, en el sótano."},
		]}
	return {
		"bg": "mansion",
		"clue": {"title": "Las tres campanas", "text": "En la mansión de Bru, tres campanas de iglesia expuestas como trofeos con una placa por víctima."},
		"flag": "done_mansion",
		"beats": [
			{"who": "narrador", "text": "La mansión de los Bru se alza junto al parque, negra contra los relámpagos, con más vidrieras que muchas iglesias. Fuerzas una ventana de servicio y entras en un vestíbulo de retratos de antepasados severos."},
			{"who": "detective", "text": "Toda una vida de placas y galones colgada en las paredes. Y detrás, esto. Veamos qué colecciona el señor comisario."},
			{"who": "narrador", "text": "Una sala interior, iluminada como un museo. Sobre peanas de terciopelo, tres campanas de bronce de distinto tamaño. Bajo cada una, una placa grabada."},
			{"who": "detective", "text": "'Santa Rita'. 'El Cristo'. 'San José'. Una campana por iglesia. Una iglesia por mujer. Elena. Nadia. Marta."},
			{"choices": [
				{"text": "Leer las placas de cerca", "then": [
					{"who": "narrador", "text": "Cada placa lleva una fecha y una inicial. Y una cuarta peana, vacía, ya rotulada: 'La torre del reloj — esta noche'."},
					{"who": "detective", "text": "La cuarta peana ya tiene sitio. Y nombre de lugar: la torre del reloj. Es esta noche. Todavía puedo llegar."},
				]},
				{"text": "Registrar el escritorio", "then": [
					{"who": "narrador", "text": "En un secreter, correspondencia con el membrete de la Fundación Amparo y, en un cajón con cerradura forzada por ti, una llave de hierro antigua etiquetada: 'sótano'."},
					{"who": "detective", "text": "Una llave del sótano. En las casas así, lo que de verdad esconden nunca está en la planta noble. Está abajo."},
				]},
			]},
			{"who": "detective", "text": "Tres campanas, tres trofeos, y una cuarta peana esperando. Este hombre no mata: 'adquiere'. Y guarda. Si guarda campanas arriba... ¿qué guarda abajo? Al sótano."},
		],
	}


static func _dlg_sotano(done: bool) -> Dictionary:
	if done:
		return {"bg": "sotano", "beats": [
			{"who": "detective", "text": "Elena y Nadia están vivas ahí abajo. Y el párroco de San José sabe más de lo que dijo. Hay que apretarle."},
		]}
	return {
		"bg": "sotano",
		"clue": {"title": "Las cautivas", "text": "Elena y Nadia siguen vivas, encerradas en el sótano. Marta fue llevada a 'la torre'."},
		"flag": "done_sotano",
		"beats": [
			{"who": "narrador", "text": "La llave abre una puerta de hierro. Detrás, una escalera húmeda baja a un sótano abovedado. Al fondo, tras una reja, dos figuras se encogen al oír tus pasos."},
			{"who": "detective", "text": "Tranquilas. Soy policía. No voy a haceros daño. Estoy aquí para sacaros."},
			{"who": "narrador", "text": "Dos mujeres demacradas pero vivas. Una de ellas se aferra a la reja con manos temblorosas."},
			{"who": "detective", "text": "¿Elena? ¿Nadia? Estáis vivas... Gracias a Dios. ¿Dónde está Marta? ¿Dónde está la tercera?"},
			{"choices": [
				{"text": "\"¿Qué le pasó a Marta?\"", "then": [
					{"who": "narrador", "text": "Elena rompe a llorar. Nadia contesta con un hilo de voz, con acento del este."},
					{"who": "narrador", "text": "'Se la llevó anoche. Arriba, dijo. A la torre del reloj. Para la 'función final'. Dijo que Marta era... su pieza favorita.'"},
					{"who": "detective", "text": "(Todavía viva. Todavía a tiempo. La torre del reloj.)", "side": "right"},
				]},
				{"text": "\"¿Quién os trajo aquí?\"", "then": [
					{"who": "narrador", "text": "'Un cura', susurra Elena. 'Nos ganó la confianza en la parroquia. El padre Ismael. Él nos entregaba... llorando, pero nos entregaba.'"},
					{"who": "detective", "text": "(El párroco de San José. La mano que abría las puertas desde dentro de la fe.)", "side": "right"},
				]},
			]},
			{"who": "narrador", "text": "Cortas la cadena de la reja con una barra. Les das tu abrigo y tu teléfono para que llamen a Núñez, al número directo, al único limpio."},
			{"who": "detective", "text": "Salid por donde entré y no miréis atrás. Yo tengo que llegar a esa torre antes de que suene la campana. Y de paso, hacerle una visita a un párroco."},
		],
	}


static func _dlg_padre(done: bool) -> Dictionary:
	if done:
		return {"bg": "iglesia_ext", "beats": [
			{"who": "padre", "text": "Que Dios me perdone... suba a la torre del reloj. Y dese prisa, que la campana ya está montada."},
		]}
	return {
		"bg": "iglesia_ext",
		"clue": {"title": "El chantaje", "text": "El padre Ismael entregaba a las mujeres, chantajeado por Bru. La 'función' es en la torre del reloj."},
		"flag": "done_padre",
		"beats": [
			{"who": "narrador", "text": "San José, otra vez, bajo otra tormenta. El padre Ismael reza solo ante el altar. Se sobresalta al verte, y en su cara no hay sorpresa: hay alivio y terror a partes iguales."},
			{"who": "detective", "text": "Elena me lo ha contado, padre. Usted les ganaba la confianza. Usted abría las puertas. ¿Cómo pudo?"},
			{"who": "padre", "text": "¿Cree que no lo llevo clavado cada noche? Bru tiene cartas mías, detective. Pecados de hace treinta años que hundirían a la parroquia y a la gente que confía en ella. Me eligió por eso."},
			{"who": "padre", "text": "Me dijo que solo era 'ayudarlas a empezar de cero lejos'. Cuando entendí la verdad, ya era su cómplice. Y un cómplice con miedo es el mejor de los candados."},
			{"choices": [
				{"text": "\"Ayúdeme a pararlo ahora.\"", "then": [
					{"who": "padre", "text": "Sí. Sí. Es lo único que me queda. Marta está en la torre del reloj, la vieja, la del ayuntamiento. Ahí celebra su 'función final', cuando el reloj da las doce."},
					{"who": "padre", "text": "Tenga la llave del portón. Yo llamaré a todas las campanas del barrio para que alguien, por fin, mire hacia arriba."},
				]},
				{"text": "\"¿Por qué campanas? ¿Por qué así?\"", "then": [
					{"who": "padre", "text": "Dice que las campanas 'llaman a las almas' y que él las 'colecciona' en su mejor momento, el del miedo. Está loco, detective. Loco con dinero y con placa, que es la peor locura."},
				]},
			]},
			{"who": "detective", "text": "El chantaje, la torre del reloj, medianoche. Ya lo tengo todo. Ahora es una carrera contra un reloj de verdad. Voy a por Marta."},
		],
	}


static func _dlg_torre() -> Dictionary:
	return {
		"bg": "torre",
		"clue": {"title": "El coleccionista", "text": "El comisario Bru, detenido en la torre del reloj. Marta, viva."},
		"flag": "cap3_completo",
		"beats": [
			{"who": "narrador", "text": "La torre del reloj del viejo ayuntamiento se alza sobre la ciudad de neón. Subes los últimos peldaños con el corazón golpeando más fuerte que la tormenta. Arriba, entre engranajes gigantes, una figura elegante espera de espaldas."},
			{"who": "comisario", "text": "Detective. La estaba esperando. Reconozco el talento: ha llegado más lejos que nadie. Es usted casi digna de mi colección."},
			{"who": "narrador", "text": "Se vuelve. El comisario Bru, de esmoquin, con el anillo de sello en la mano. A su lado, atada a una silla junto a la maquinaria, Marta Soler, viva, con los ojos enormes de terror."},
			{"who": "detective", "text": "Se acabó, Bru. Elena y Nadia están fuera. El padre Ismael ha cantado. Y Núñez viene con los únicos policías de esta ciudad a los que usted no ha comprado."},
			{"who": "comisario", "text": "¿Comprado? Yo no compro, detective. Yo colecciono lo que el mundo tira: mujeres que nadie reclama. Les doy lo único eterno que existe: un instante perfecto, cuando suena la campana."},
			{"choices": [
				{"text": "Mantenerlo hablando y ganar tiempo", "then": [
					{"who": "detective", "text": "Un instante perfecto. Cuénteme más. A los hombres como usted les encanta explicar por qué son especiales."},
					{"who": "comisario", "text": "Porque estoy por encima. De la ley que redacto, del barrio que sostengo, de la moral de los pobres. Yo decido quién suena y quién calla."},
					{"who": "narrador", "text": "Mientras habla, ganas terreno. Faltan segundos para las doce. Cuando el gran engranaje se mueva, el ruido tapará todo."},
				]},
				{"text": "Fingir rendirte y acercarte", "then": [
					{"who": "detective", "text": "Tiene razón. Ha ganado. Solo... déjeme verla de cerca. Concédame ese instante perfecto a mí también."},
					{"who": "comisario", "text": "Ah. Por fin alguien que lo entiende. Acérquese, entonces. Sea parte de la obra."},
					{"who": "narrador", "text": "Das un paso, dos. Tu mano roza la palanca de freno del mecanismo del reloj."},
				]},
			]},
			{"who": "narrador", "text": "El reloj empieza a dar las doce. La campana atronadora ahoga el mundo. En ese estruendo que él tanto amaba, te lanzas."},
			{"who": "detective", "text": "¡El único instante perfecto de esta noche va a ser el de las esposas, Bru!"},
			{"who": "narrador", "text": "Forcejeo entre engranajes y campanadas. El anillo de sello rueda por el suelo de madera. A la última campanada, Bru está contra el suelo, tu rodilla en su espalda, y Marta respira, libre."},
			{"who": "comisario", "text": "No lo entiende... gente como yo no cae. Mañana estaré fuera. Siempre estoy fuera."},
			{"who": "detective", "text": "Puede ser. Pero esta noche, por una vez, la campana ha sonado por usted. Y hay tres mujeres vivas para contarlo."},
		],
	}


static func _dlg_cierre3() -> Dictionary:
	return {
		"bg": "comisaria",
		"flag": "done_cierre3",
		"beats": [
			{"who": "narrador", "text": "Amanece limpio por primera vez en semanas. La comisaría hierve de prensa y de caras nuevas de Asuntos Internos. Núñez, con una insignia recién ascendida que le sienta como un traje prestado, te tiende un café."},
			{"who": "nunez", "text": "Bru tenía razón en una cosa: gente como él rara vez cae. Pero con tres testigos vivas, el anillo, el mechero y el libro de la capilla... esta vez no se levanta. Va a caer entero."},
			{"who": "detective", "text": "¿Y usted? Ha quemado su jubilación en esto."},
			{"who": "nunez", "text": "La he cambiado por poder mirarme al espejo. Buen negocio, a mi edad. Marta ha preguntado por usted, por cierto. Ella y Laura. Quieren darle las gracias."},
			{"who": "detective", "text": "Dígales que las gracias, cuando encuentre a la persona, no a la detective. Hoy solo quiero dormir una semana."},
			{"who": "narrador", "text": "Recoges tus cosas. En el tablón, alguien ha colgado ya un mapa nuevo, con otro barrio, otras luces, otra lluvia esperando."},
			{"who": "nunez", "text": "Habrá más noches como esta, detective. Siempre las hay. Pero por hoy... el barrio es suyo. Y las campanas, por fin, callan en paz."},
			{"who": "narrador", "text": "— FIN DE LA TEMPORADA 1 —  Tres casos, tres tormentas, tres campanas que vuelven a su sitio. sOC."},
		],
	}


# ===========================================================================
#  PISTAS FALSAS (red herrings) de los capítulos 1-3
# ===========================================================================
static func _dlg_exnovio(done: bool) -> Dictionary:
	if done:
		return {"bg": "bar", "beats": [
			{"who": "nano", "text": "Que yo no fui, pesada. Estaba en el calabozo esa noche, pregúntale a tus colegas."},
		]}
	return {
		"bg": "bar",
		"clues": [
			{"title": "El exnovio", "text": "Nano, el ex violento de Marta, PARECÍA el culpable... pero pasó la noche en el calabozo.", "false": true},
			{"title": "El tendero fisgón", "text": "El tendero de la esquina presumía de 'saberlo todo'; solo repite chismes de mostrador.", "false": true},
			{"title": "El pretendiente celoso", "text": "Un vecino que rondaba a Marta; lloraba de pena, no de culpa.", "false": true},
			{"title": "El cobrador de deudas", "text": "Marta debía dinero; el prestamista la quería viva y pagando, no desaparecida.", "false": true},
			{"title": "El vagabundo del atrio", "text": "Un sintecho que dormía en la iglesia; ni se enteró del revuelo.", "false": true}],
		"flag": "done_exnovio",
		"beats": [
			{"who": "narrador", "text": "El bar del Nano huele a lejía y a cerveza rancia. Neones de marcas baratas parpadean sobre una barra pegajosa. Detrás, un tipo fornido con los nudillos marcados te mira como quien mira a la policía: con asco."},
			{"who": "detective", "text": "Nano. Fuiste el novio de Marta Soler. El que le dejó dos costillas rotas el invierno pasado."},
			{"who": "nano", "text": "Eso es agua pasada. Y si ha desaparecido, yo no tengo nada que ver. Me tenéis manía en este barrio."},
			{"who": "detective", "text": "Un hombre que pega a su pareja y luego ella se esfuma. Entenderás que empiece por ti."},
			{"who": "nano", "text": "Empieza por donde quieras, pero mira antes tu propio archivo. La noche de la misa yo estaba en TU calabozo, por una pelea en el 12. Veinticuatro horas. Firmado y sellado."},
			{"who": "narrador", "text": "Una llamada rápida a comisaría lo confirma: Nano pasó toda la noche de la desaparición entre rejas. Imposible que estuviera en la iglesia."},
			{"who": "detective", "text": "(Coartada de hierro. El sospechoso obvio nunca es el bueno. Tacho a Nano.)", "side": "right"},
			{"who": "narrador", "text": "En una esquina de la barra, un cliente fijo del Nano —el tendero de comestibles de la esquina— te hace señas con cara de tener un secreto que vender."},
			{"who": "detective", "text": "Me dicen que usted lo ve todo desde su mostrador. ¿Vio algo la noche de la desaparición?"},
			{"who": "narrador", "text": "El tendero se arranca con un torrente de chismes sin bajarse del taburete: que si la Marta debía en tres tiendas, que si un primo la vio en la estación, que si un coche negro... Nada que se sostenga al preguntar dos veces."},
			{"who": "detective", "text": "(Chismes de mostrador, uno encima de otro, ninguno con pies. El tendero no vende información: vende ruido.)", "side": "right"},
			{"who": "detective", "text": "Gracias por... todo esto. Cinco pistas fáciles y cinco callejones. El exnovio, el tendero, el pretendiente, el usurero, el vagabundo. Ninguno cuadra. Vuelvo al hilo que sí aguanta."},
		],
	}


static func _dlg_voluntario(done: bool) -> Dictionary:
	if done:
		return {"bg": "comedor", "beats": [
			{"who": "detective", "text": "El voluntario solo robaba del cepillo. Un ladronzuelo, no un secuestrador. Callejón sin salida."},
		]}
	return {
		"bg": "comedor",
		"clues": [
			{"title": "El voluntario nervioso", "text": "Un voluntario sudoroso PARECÍA implicado... pero solo sisaba de la caja.", "false": true},
			{"title": "La cocinera del comedor", "text": "Conocía a las tres víctimas; les daba de comer, nada más.", "false": true},
			{"title": "El donante anónimo menor", "text": "Un benefactor pequeño; da por desgravar impuestos, no por trata.", "false": true},
			{"title": "El de la furgoneta blanca", "text": "Reparte comida al refugio; su furgoneta no es la del muelle.", "false": true},
			{"title": "El predicador de la esquina", "text": "Grita que 'Amparo es cosa del diablo'; fanático, no testigo.", "false": true}],
		"flag": "done_voluntario",
		"beats": [
			{"who": "narrador", "text": "Un voluntario joven, con la camisa empapada de sudor pese al frío, no te sostiene la mirada. Cuando te acercas, tira sin querer una pila de folletos."},
			{"who": "detective", "text": "Tranquilo. Solo quiero hablar. Aunque quien no debe nada no suele temblar así."},
			{"who": "voluntario", "text": "Yo... yo no sé nada de las mujeres esas, lo juro. Yo solo... por favor, no se lo diga al Sr. Vidal."},
			{"who": "detective", "text": "¿Que no le diga qué?"},
			{"who": "voluntario", "text": "Lo de la caja. Cojo algo del cepillo, poco, para mi madre. Soy un miserable, lo sé, pero un ladrón de monedas, no... no lo otro."},
			{"who": "narrador", "text": "Le tiemblan las manos mientras vacía los bolsillos: calderilla, un fajo mísero. El miedo de un ratero, no de un asesino."},
			{"who": "detective", "text": "(Sudaba por unas monedas, no por tres vidas. Su pánico me despistó. Sigo.)", "side": "right"},
			{"who": "detective", "text": "Devuelve lo que has cogido y no lo repitas. Tu secreto no es el que yo busco."},
		],
	}


static func _dlg_soplo(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "detective", "text": "El soplo era un cebo. Nos querían mirando a la banda del río mientras el pez gordo respiraba tranquilo."},
		]}
	return {
		"bg": "comisaria",
		"clues": [
			{"title": "El soplo anónimo", "text": "Una nota anónima acusaba a la banda del río. Era un CEBO para desviar la investigación.", "false": true},
			{"title": "La banda del río", "text": "Contrabandistas de tabaco; esa noche estaban a kilómetros, con coartada.", "false": true},
			{"title": "El sacristán", "text": "Tenía llave del campanario; un pobre hombre incapaz de matar una mosca.", "false": true},
			{"title": "El fotógrafo de sucesos", "text": "Aparecía en cada escena; solo vende fotos morbosas a la prensa.", "false": true},
			{"title": "El vidente", "text": "Ofrece 'ver' dónde está Marta por dinero. Estafa de feria.", "false": true}],
		"flag": "done_soplo",
		"beats": [
			{"who": "narrador", "text": "Sobre tu mesa, alguien ha dejado un sobre sin remite. Dentro, una nota mecanografiada, sin firma."},
			{"who": "anonimo", "text": "«Buscad a la banda del río. Ellos se llevaron a las mujeres.»"},
			{"who": "detective", "text": "Qué oportuno. Una pista que llega sola, servida en bandeja, justo cuando aprieto por otro lado."},
			{"who": "narrador", "text": "Compruebas a la banda del río: contrabandistas de tabaco, sí, pero la noche de cada desaparición estaban a kilómetros, moviendo cajas en la otra punta del puerto. Coartadas cruzadas."},
			{"who": "detective", "text": "Nada. Ni una conexión real. Alguien mecanografió esto para que perdiera una semana persiguiendo fantasmas."},
			{"who": "detective", "text": "(Y quien puede plantar una nota en MI mesa está dentro de esta comisaría. El cebo dice más que la pista: me están vigilando.)", "side": "right"},
			{"who": "detective", "text": "Al cesto con el soplo. A veces una pista falsa es la mejor prueba de que vas por el camino bueno."},
		],
	}


# ===========================================================================
#  CAPÍTULO 4 · El heredero
# ===========================================================================
static func _ch4_dialogue(id: String, done: bool) -> Dictionary:
	match id:
		"brief4":    return _dlg_brief4(done)
		"escena4":   return _dlg_escena4(done)
		"chivato":   return _dlg_chivato(done)
		"falso4":    return _dlg_falso4(done)
		"redaccion": return _dlg_redaccion(done)
		"almacen":   return _dlg_almacen()
		"cierre4":   return _dlg_cierre4()
	return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}


static func _dlg_brief4(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "nunez", "text": "Bru sigue en su celda. Y aun así ha vuelto a pasar. Vaya a la iglesia de la Merced, detective."},
		]}
	return {"bg": "comisaria", "flag": "done_brief4", "beats": [
		{"who": "narrador", "text": "Meses después. Nora ya no es una intrusa: tiene mesa propia en la comisaría y a Núñez de jefe. Pero esta madrugada la cara de Núñez es la de siempre: la de las malas noticias."},
		{"who": "nunez", "text": "Otra. Anoche, tormenta, misa concurrida en la iglesia de la Merced. Una mujer, Sara Beltrán, se esfumó del banco. Mismo modus. Idéntico."},
		{"who": "detective", "text": "Imposible. Bru está encerrado. Lo metí yo en esa celda."},
		{"who": "nunez", "text": "Y ahí sigue, lo he comprobado tres veces. O tenemos un imitador... o el método de Bru no se ha ido con él."},
		{"who": "detective", "text": "Las dos cosas dan miedo. Si alguien copia hasta el último detalle, es que alguien se lo enseñó. Voy a la escena antes de que la lluvia borre lo poco que quede."},
	]}


static func _dlg_escena4(done: bool) -> Dictionary:
	if done:
		return {"bg": "iglesia_int", "beats": [
			{"who": "detective", "text": "El sello de lacre en el campanario. Un gremio, no un lobo solitario. Hay que preguntar en la calle."},
		]}
	return {"bg": "iglesia_int", "clue": {"title": "El método heredado", "text": "El secuestro repite el método de Bru al detalle, con una marca nueva: un sello de lacre."}, "flag": "done_escena4", "beats": [
		{"who": "narrador", "text": "La iglesia de la Merced es gemela de San José en lo esencial: nave, campanario, una puerta de servicio que da a un callejón. Subes la escalera de caracol con una sensación de déjà vu que hiela."},
		{"who": "detective", "text": "Marcas de arrastre. La escala trasera. El pañuelo... todo igual. Quien hizo esto tiene el manual de Bru abierto sobre las rodillas."},
		{"who": "narrador", "text": "Pero hay algo que Bru nunca dejaba: en el quicio de la puerta del campanario, un pegote de lacre rojo con un sello estampado. Una figura: una balanza con una campana en cada platillo."},
		{"who": "detective", "text": "Esto es nuevo. Bru firmaba con silencio. Este firma con un sello, como un gremio de artesanos orgulloso de su oficio."},
		{"choices": [
			{"text": "Examinar el sello de cerca", "then": [
				{"who": "narrador", "text": "Bajo la lupa, alrededor de la balanza, unas letras diminutas: 'C. del B.'"},
				{"who": "detective", "text": "Unas iniciales. Un emblema. Esto no es un imitador solitario: es una marca. Una firma de negocio."},
			]},
			{"text": "Buscar diferencias con los casos de Bru", "then": [
				{"who": "narrador", "text": "A diferencia de Bru, aquí no hay trofeo, no hay campana robada. Se llevaron a la mujer y punto: rápido, limpio, comercial."},
				{"who": "detective", "text": "Bru coleccionaba por amor enfermo. Este se la lleva por dinero. Ya no es un loco: es un proveedor."},
			]},
		]},
		{"who": "detective", "text": "El método heredado, con sello propio. Si es un negocio, en la calle alguien habrá oído hablar de él. Toca visitar a mis oídos del arroyo."},
	]}


static func _dlg_chivato(done: bool) -> Dictionary:
	if done:
		return {"bg": "callejon", "beats": [
			{"who": "detective", "text": "El 'Corredor'. Así llaman a quien mueve la mercancía. La periodista Vera Lang lleva meses tras él."},
		]}
	return {"bg": "callejon", "clue": {"title": "El corredor", "text": "En la calle hablan de un 'Corredor' que mueve mujeres por encargo; un intermediario."}, "flag": "done_chivato", "beats": [
		{"who": "narrador", "text": "El chivato te espera en la trastienda de siempre, medio a oscuras, mordiendo un palillo. No da nada gratis, pero esta noche está más pálido que de costumbre."},
		{"who": "chivato", "text": "Detective, esta vez no quiero su dinero. Quiero que esto pare, que me da hasta a mí repelús. Andan diciendo por ahí una palabra: el 'Corredor'."},
		{"who": "detective", "text": "¿El Corredor?"},
		{"who": "chivato", "text": "Un tipo que no roba, que no mata: transporta. Le encargas y él 'consigue'. Mujeres solas, sin familia. Dicen que trabaja para un gremio, gente de arriba con guantes limpios."},
		{"choices": [
			{"text": "\"¿Dónde lo encuentro?\"", "then": [
				{"who": "chivato", "text": "A él no se le encuentra. Él te encuentra a ti. Pero hay una periodista, la Lang, del diario, que lleva meses olfateándolo. Sabe más que yo. Y que usted."},
			]},
			{"text": "\"¿Para quién trabaja?\"", "then": [
				{"who": "chivato", "text": "Para el que paga. Y paga gente con anillos y apellidos. Bru era un cliente, ¿sabe? Uno más. Cuando cayó, el negocio ni se enteró."},
				{"who": "detective", "text": "(Bru no era la cabeza. Era un comprador. La cabeza sigue suelta.)", "side": "right"},
			]},
		]},
		{"who": "detective", "text": "El Corredor, un gremio, clientes con apellido. Esto es mucho más grande que un hombre. Voy a ver a esa periodista antes que la calle me la calle también a ella."},
	]}


static func _dlg_falso4(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "detective", "text": "El que se confesó culpable ni siquiera sabía por qué puerta salió la víctima. Un pobre diablo buscando fama."},
		]}
	return {"bg": "comisaria", "clues": [
		{"title": "El falso culpable", "text": "Un hombre se confesó autor de todo, pero desconocía detalles clave: mentía por notoriedad.", "false": true},
		{"title": "El sacristán nuevo", "text": "Recién llegado a la Merced; nervioso por novato, no por culpable.", "false": true},
		{"title": "El feligrés fanático", "text": "Habla de 'castigo divino'; devoto perturbado, no secuestrador.", "false": true},
		{"title": "El vendedor de velas", "text": "Estaba fuera esa noche; solo vio pasar una furgoneta con prisa.", "false": true},
		{"title": "El copión", "text": "Un imitador que 'reivindica' el crimen por internet; en su casa, sin coartada de talento.", "false": true}], "flag": "done_falso4", "beats": [
		{"who": "narrador", "text": "En la sala de interrogatorios, un hombre demacrado sonríe a las cámaras que no hay. 'Fui yo', repite. 'Yo me las llevé a todas.'"},
		{"who": "detective", "text": "Muy bien. Entonces dígame: ¿por qué puerta sacó a Sara Beltrán de la iglesia de la Merced?"},
		{"who": "narrador", "text": "El hombre duda, sonríe, improvisa: 'Por... por la puerta grande, la principal.' Error. Salió por el campanario, como todas."},
		{"who": "detective", "text": "Por la principal, dice. Con cien testigos mirando. Ya. ¿Y el sello de lacre? ¿De qué color?"},
		{"who": "narrador", "text": "Silencio. El hombre se derrumba: solo quería salir en los periódicos, sentirse alguien por una noche. No sabe nada."},
		{"who": "detective", "text": "(Cada caso sonado atrae a estos pobres diablos. Confiesan para existir. Descartado.)", "side": "right"},
		{"who": "detective", "text": "Que le den una manta y una tila. Y que nadie filtre su nombre: bastante castigo tiene con ser quien es."},
	]}


static func _dlg_redaccion(done: bool) -> Dictionary:
	if done:
		return {"bg": "redaccion", "beats": [
			{"who": "periodista", "text": "La marca del gremio: la balanza con dos campanas. Búscala en el almacén del muelle. Ahí guardan la 'mercancía'."},
		]}
	return {"bg": "redaccion", "clue": {"title": "La marca del gremio", "text": "El sello (balanza y dos campanas) es la marca de un gremio de trata; su almacén está en el muelle."}, "flag": "done_redaccion", "beats": [
		{"who": "narrador", "text": "La redacción del diario es un caos de humo, teclas y teléfonos. Vera Lang, la periodista, despeja una silla de un manotazo de recortes y te clava una mirada que ya lo sabe todo."},
		{"who": "periodista", "text": "La detective que metió a un comisario en la cárcel. Por fin. Llevo dos años escribiendo artículos que me tumban antes de imprimir. Igual juntas llegamos a algún sitio."},
		{"who": "detective", "text": "Me han hablado de un 'Corredor' y de un gremio. Y de un sello: una balanza con dos campanas."},
		{"who": "periodista", "text": "El 'Cónclave del Bronce', lo llaman ellos. Un club de señores muy respetables que 'coleccionan' personas. El Corredor es su recadero. Bru era un socio pequeño."},
		{"who": "periodista", "text": "Esa balanza es su marca de garantía. La estampan en la 'mercancía' y en los sitios donde la almacenan. Y sé dónde está uno: un almacén en el muelle viejo."},
		{"choices": [
			{"text": "\"¿Por qué no lo has publicado?\"", "then": [
				{"who": "periodista", "text": "Porque el dueño del periódico juega al golf con ellos. Cada vez que me acerco, me cambian de sección. A ti no te pueden cambiar de sección, detective. Por eso te ayudo."},
			]},
			{"text": "\"¿Qué encontraré en ese almacén?\"", "then": [
				{"who": "periodista", "text": "Registros. Fechas. Y si hay suerte, a alguien esperando el próximo 'envío'. Pero ve con cuidado y ve pronto: cuando huelen una redada, lo vacían en horas."},
			]},
		]},
		{"who": "detective", "text": "El Cónclave del Bronce. La marca del gremio. El almacén del muelle. Tres pistas y un nombre nuevo. Esta noche entro en ese almacén."},
	]}


static func _dlg_almacen() -> Dictionary:
	return {"bg": "almacen", "clue": {"title": "El libro de envíos", "text": "En el almacén, un registro de 'envíos' con fechas, sellos y un contacto: el Corredor."}, "flag": "cap4_completo", "beats": [
		{"who": "narrador", "text": "El almacén es una catedral de sombras y contenedores. Huele a salitre y a miedo viejo. Al fondo, jaulas vacías con la marca de la balanza grabada a fuego en la madera."},
		{"who": "detective", "text": "Jaulas. Con sello de calidad. Como si fueran cajas de fruta. Malditos sean."},
		{"who": "narrador", "text": "Sobre una mesa, un libro de contabilidad abierto: columnas de fechas, 'piezas', y una firma que se repite como responsable de logística: el Corredor."},
		{"who": "detective", "text": "Aquí está todo. Quién, cuándo, cuánto. Esto no lo tumba ningún dueño de periódico."},
		{"who": "narrador", "text": "Un ruido. Entre los contenedores, una figura enjuta con guantes recoge deprisa unos papeles y echa a correr hacia la salida de carga."},
		{"choices": [
			{"text": "Perseguir al Corredor", "then": [
				{"who": "narrador", "text": "Corres, pero el hombre conoce el laberinto mejor que tú. Se cuela por un hueco y desaparece en la lluvia. En el suelo, se le ha caído una tarjeta con la balanza."},
				{"who": "detective", "text": "Otra vez se me escapa el recadero. Pero se deja su tarjeta. Y su libro. Con esto ya no persigo rumores: persigo nombres."},
			]},
			{"text": "Asegurar el libro de envíos", "then": [
				{"who": "narrador", "text": "Dejas ir a la figura y agarras el libro con las dos manos. Vale más que diez detenciones: es el mapa entero del negocio."},
				{"who": "detective", "text": "Un recadero se sustituye en un día. Este libro, no. Prefiero el mapa al ratón."},
			]},
		]},
		{"who": "detective", "text": "Sara Beltrán no está aquí: ya la 'enviaron'. Pero por primera vez tengo la contabilidad del horror. Núñez tiene que verlo esta misma noche."},
	]}


static func _dlg_cierre4() -> Dictionary:
	return {"bg": "comisaria", "flag": "done_cierre4", "beats": [
		{"who": "narrador", "text": "Núñez y Vera Lang revisan el libro bajo la lámpara. Tres cabezas sobre las mismas cifras que valen vidas."},
		{"who": "nunez", "text": "Con esto podemos empapelar a medio gremio. Pero el Corredor sigue suelto, y por encima de él hay quien firma los cheques."},
		{"who": "periodista", "text": "El Cónclave del Bronce. Y hay una noche, una vez al mes, en que se reúnen a 'pujar'. Una subasta. Si damos con ella, damos con todos a la vez."},
		{"who": "detective", "text": "Entonces ya no perseguimos a un hombre. Perseguimos a un club entero. Y me voy a colar en su fiesta."},
		{"who": "narrador", "text": "— FIN DEL CAPÍTULO 4 —  El heredero no era una persona: era un negocio con socios, sello y contabilidad. Y una subasta esperando."},
	]}


# ===========================================================================
#  CAPÍTULO 5 · La subasta
# ===========================================================================
static func _ch5_dialogue(id: String, done: bool) -> Dictionary:
	match id:
		"brief5":     return _dlg_brief5(done)
		"contacto":   return _dlg_contacto(done)
		"falso5":     return _dlg_falso5(done)
		"salon":      return _dlg_salon(done)
		"trastienda": return _dlg_trastienda(done)
		"redada":     return _dlg_redada()
		"cierre5":    return _dlg_cierre5()
	return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}


static func _dlg_brief5(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "nunez", "text": "El Corredor mueve la mercancía por el muelle. Empiece por su contacto de allí."},
		]}
	return {"bg": "comisaria", "flag": "done_brief5", "beats": [
		{"who": "narrador", "text": "El libro de envíos es un mapa, pero está en clave. Núñez ha pasado la noche descifrando rutas con un café tras otro."},
		{"who": "nunez", "text": "Todos los 'envíos' pasan por el muelle antes de la subasta mensual. Hay un contacto allí, un tal Sisebuto, que carga y descarga. Asustadizo. Empiece por él."},
		{"who": "detective", "text": "Un mes. Tengo un mes hasta la próxima puja para meterme dentro. Y a Sara Beltrán quizá ya la estén 'exponiendo'."},
		{"who": "nunez", "text": "Cuídese, detective Vega. En cuanto el gremio note que husmea la subasta, dejará de mandarle notas falsas y empezará a mandarle otra cosa."},
		{"who": "detective", "text": "Que manden lo que quieran. Voy al muelle a apretarle las tuercas a ese tal Sisebuto."},
	]}


static func _dlg_contacto(done: bool) -> Dictionary:
	if done:
		return {"bg": "muelle", "beats": [
			{"who": "detective", "text": "Existe una lista de clientes con sus pujas. Y un salón, el de Madame Ourense, donde se cierran los tratos."},
		]}
	return {"bg": "muelle", "clue": {"title": "La lista de clientes", "text": "Existe una lista cifrada de clientes que pujan; los tratos se cierran en el salón de Madame Ourense."}, "flag": "done_contacto", "beats": [
		{"who": "narrador", "text": "Sisebuto resulta ser un cargador flaco que fuma con las dos manos. Cuando le enseñas la tarjeta del Corredor, se le cae el cigarro."},
		{"who": "chivato", "text": "No sé nada, no sé nada. Yo cargo cajas, no pregunto qué llevan. Es más sano así."},
		{"who": "detective", "text": "Las cajas que tú cargas llevan personas dentro. Eso ya no es sano de ninguna manera. Habla, y te saco de esto antes de que te conviertas en carga tú también."},
		{"who": "chivato", "text": "Está bien, está bien... Hay una lista. De clientes. Gente que puja por 'encargos concretos'. Yo he visto el sobre, no lo que hay dentro, se lo juro."},
		{"choices": [
			{"text": "\"¿Dónde se hacen las pujas?\"", "then": [
				{"who": "chivato", "text": "En un salón elegante, arriba en la ciudad. Lo lleva una tal Madame Ourense. Allí no entran cargadores como yo. Ni policías como usted, sin invitación."},
			]},
			{"text": "\"¿Y Sara Beltrán?\"", "then": [
				{"who": "chivato", "text": "¿La última? Sigue 'en catálogo'. No se ha vendido aún. Si va a hacer algo, hágalo antes de la próxima luna llena, que es cuando pujan."},
				{"who": "detective", "text": "(Viva. En catálogo. Tengo hasta luna llena.)", "side": "right"},
			]},
		]},
		{"who": "detective", "text": "Una lista de clientes y un salón con dueña. Si quiero la lista, tengo que encantar a Madame Ourense. Hora de vestirme de otra cosa."},
	]}


static func _dlg_falso5(done: bool) -> Dictionary:
	if done:
		return {"bg": "chatarreria", "beats": [
			{"who": "detective", "text": "El chatarrero solo vendía coches robados. Ruidoso, pero pez pequeño. Nada que ver con el gremio."},
		]}
	return {"bg": "chatarreria", "clues": [
		{"title": "El chatarrero", "text": "El jefe de la chatarrería parecía el pez gordo, pero solo trafica con coches robados.", "false": true},
		{"title": "El prestamista del puerto", "text": "Presta a usura a los estibadores; avaricia, no trata de personas.", "false": true},
		{"title": "El capitán borracho", "text": "Su barco cuadraba con las fechas; dormía la mona en cada una.", "false": true},
		{"title": "El tatuador", "text": "Marca a la gente del muelle; hace dibujos, no marca 'mercancía'.", "false": true},
		{"title": "La adivina del puerto", "text": "Dice leer 'quién no volverá del mar'; teatro para turistas.", "false": true}], "flag": "done_falso5", "beats": [
		{"who": "narrador", "text": "La chatarrería del Rubio tiene fama en el barrio: dinero, matones, coches que entran enteros y salen en piezas. El candidato perfecto a villano."},
		{"who": "detective", "text": "Mucho músculo para un desguace. A ver qué esconde el Rubio bajo tanta chapa."},
		{"who": "narrador", "text": "Registras, aprietas, amenazas. Aparecen coches robados, matrículas limadas, un alijo de tabaco... y nada más. Ni rastro de sellos, ni de listas, ni de mujeres."},
		{"who": "detective", "text": "Un ladrón de coches de manual. Ruidoso, sucio, evidente. Demasiado evidente para lo que busco."},
		{"who": "detective", "text": "(El gremio no hace ruido ni ostentación. Tiene guantes limpios y apellidos. El Rubio es un pez pequeño en un charco aparte.)", "side": "right"},
		{"who": "detective", "text": "Que Tráfico se ocupe del Rubio. Yo busco a monstruos que huelen a colonia cara, no a grasa de motor."},
	]}


static func _dlg_salon(done: bool) -> Dictionary:
	if done:
		return {"bg": "salon_privado", "beats": [
			{"who": "madame", "text": "Ya le dije lo que iba a decirle, encanto. El sello dorado es el pase. Lo demás, en la trastienda."},
		]}
	return {"bg": "salon_privado", "clue": {"title": "El sello de la casa", "text": "El acceso a la puja se controla con un sello dorado en la invitación; lo guarda Madame Ourense."}, "flag": "done_salon", "beats": [
		{"who": "narrador", "text": "El salón privado es terciopelo, champán y risas de gente que nunca ha pagado por nada. Madame Ourense te recibe midiéndote de arriba abajo como a una joya que no acaba de tasar."},
		{"who": "madame", "text": "Cara nueva. Y no del gremio, eso se huele. ¿Compradora, curiosa... o problema, querida?"},
		{"who": "detective", "text": "Coleccionista. Me han dicho que aquí se consiguen piezas que no están en ningún catálogo legal."},
		{"who": "madame", "text": "Aquí se consigue de todo, si se tienen dos cosas: dinero y un sello. El sello dorado en la invitación es lo que separa a los nuestros de la chusma curiosa."},
		{"choices": [
			{"text": "Seguir el juego de coleccionista", "then": [
				{"who": "detective", "text": "Dinero tengo. Y el gusto por lo exclusivo. ¿Cómo consigue una dama su sello?"},
				{"who": "madame", "text": "Con una recomendación... o con un descuido mío. Y yo esta noche estoy siendo muy descuidada con usted, no sé por qué. Me recuerda a alguien peligroso."},
			]},
			{"text": "Presionar con lo que sabes", "then": [
				{"who": "detective", "text": "Sé lo del Cónclave del Bronce. Sé lo de la balanza. Podría cerrarle el salón esta noche, Madame."},
				{"who": "madame", "text": "Podría. Pero entonces no vería la lista de clientes, ¿verdad? Y sin lista, solo tiene a una anfitriona vieja. Yo soy la puerta, no la casa."},
			]},
		]},
		{"who": "detective", "text": "El sello de la casa. La lista en la trastienda. Madame es una puerta, no la casa: necesito lo que guarda detrás. Voy a colarme en su trastienda."},
	]}


static func _dlg_trastienda(done: bool) -> Dictionary:
	if done:
		return {"bg": "trastienda", "beats": [
			{"who": "detective", "text": "El Corredor jefe tiene nombre en la lista. Y todo apunta a la subasta de luna llena. Ahí caerán todos."},
		]}
	return {"bg": "trastienda", "clue": {"title": "El corredor jefe", "text": "La lista revela al Corredor jefe y la fecha de la gran puja: luna llena en la casa de subastas."}, "flag": "done_trastienda", "beats": [
		{"who": "narrador", "text": "La trastienda de Madame es un despacho forrado de archivadores con cerradura. Con paciencia y una horquilla, el cajón bueno cede."},
		{"who": "detective", "text": "La lista de clientes. Apellidos que salen en los periódicos... en la sección de sociedad, no en la de sucesos."},
		{"who": "narrador", "text": "Junto a la lista, un organigrama. En la cima del transporte, un nombre subrayado dos veces: el Corredor jefe, con dirección y todo. Y una fecha en rojo: la gran puja, luna llena."},
		{"choices": [
			{"text": "Fotografiar la lista entera", "then": [
				{"who": "narrador", "text": "Disparas la cámara sobre cada página. Clientes, precios, 'piezas' pasadas y futuras. Sara Beltrán aparece con un número de lote."},
				{"who": "detective", "text": "Sara es un número de lote. Voy a convertir ese número en una detención y a estos apellidos en titulares."},
			]},
			{"text": "Buscar quién está por encima", "then": [
				{"who": "narrador", "text": "En el margen, una anotación de puño y letra de Madame: 'Consultar con A.V. antes de la puja'. Solo iniciales. A.V."},
				{"who": "detective", "text": "(A.V. Alguien a quien hasta el Corredor jefe consulta. La cima de verdad tiene esas dos letras.)", "side": "right"},
			]},
		]},
		{"who": "detective", "text": "El Corredor jefe, la lista, la fecha de la puja. Tengo la noche y el lugar. En la próxima luna llena, el Cónclave se reúne... y yo estaré dentro con Núñez detrás."},
	]}


static func _dlg_redada() -> Dictionary:
	return {"bg": "subasta", "clue": {"title": "El eslabón que canta", "text": "Cae la subasta y el Corredor jefe; para salvarse, delata a quien manda: las iniciales A.V."}, "flag": "cap5_completo", "beats": [
		{"who": "narrador", "text": "Noche de luna llena. La casa de subastas reluce como un teatro. Desde dentro, con un sello robado en la solapa, ves subir al estrado el horror disfrazado de puja elegante."},
		{"who": "detective", "text": "(Aguanta, Nora. Que suban todos a la vez. Que se confíen. Y entonces...)", "side": "right"},
		{"who": "narrador", "text": "Cuando el martillo canta el primer 'lote', das la señal. Las puertas revientan. Núñez y treinta agentes limpios inundan el salón entre gritos y copas rotas."},
		{"who": "detective", "text": "¡Cónclave del Bronce! ¡Quietos todos! Esta noche el lote que se subasta son ustedes."},
		{"who": "narrador", "text": "En la confusión, liberas a tres mujeres entre bambalinas. Una de ellas, temblando, susurra su nombre: Sara Beltrán. Viva."},
		{"who": "narrador", "text": "El Corredor jefe, acorralado contra el telón, levanta las manos y empieza a hablar atropelladamente para salvar su pellejo."},
		{"choices": [
			{"text": "\"Un nombre. El de arriba.\"", "then": [
				{"who": "corredor", "text": "¡Yo solo transporto! El que manda, el que protege a todos, el que era el dueño hasta de Bru... es Vaultier. Aristide Vaultier. ¡Yo solo cumplo órdenes!"},
				{"who": "detective", "text": "(A.V. Aristide Vaultier. El magnate intocable. Por fin la cima tiene cara.)", "side": "right"},
			]},
			{"text": "\"¿Dónde está Vaultier ahora?\"", "then": [
				{"who": "corredor", "text": "En su bufete, o en su mansión, rodeado de abogados y de jueces amigos. A él no lo tocará nunca. Es demasiado grande. Ustedes solo cazan recaderos."},
			]},
		]},
		{"who": "detective", "text": "Un recadero más entre rejas y una subasta reventada. Pero el que firma los cheques tiene nombre: Vaultier. Y contra un apellido así se necesita más que una redada."},
	]}


static func _dlg_cierre5() -> Dictionary:
	return {"bg": "comisaria", "flag": "done_cierre5", "beats": [
		{"who": "nunez", "text": "Aristide Vaultier. Constructoras, bancos, media ciudad le debe favores. Y ahora sabemos que era el dueño del Cónclave."},
		{"who": "detective", "text": "El que protegía a Bru. El que firma las órdenes de 'no patrullar'. La cabeza que buscábamos desde la primera tormenta."},
		{"who": "periodista", "text": "Contra Vaultier no vale una redada. Vale una prueba tan grande que ningún juez amigo pueda enterrarla. Y yo tengo un periódico esperándola."},
		{"who": "nunez", "text": "Un último caso, detective Vega. El más grande. Y probablemente el que nos entierre a todos si fallamos."},
		{"who": "detective", "text": "Entonces no fallemos. Voy a por Vaultier. Hasta la cúspide."},
		{"who": "narrador", "text": "— FIN DEL CAPÍTULO 5 —  Cayó la subasta, cayó el Corredor. Queda una sola silla en la cima, y un solo apellido: Vaultier."},
	]}


# ===========================================================================
#  CAPÍTULO 6 · La cúspide (final de la Temporada 2)
# ===========================================================================
static func _ch6_dialogue(id: String, done: bool) -> Dictionary:
	match id:
		"brief6":   return _dlg_brief6(done)
		"despacho": return _dlg_despacho(done)
		"falso6":   return _dlg_falso6(done)
		"contable": return _dlg_contable(done)
		"coartada": return _dlg_coartada(done)
		"azotea":   return _dlg_azotea()
		"cierre6":  return _dlg_cierre6()
	return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}


static func _dlg_brief6(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "nunez", "text": "Vaultier recibe en su bufete. Nadie le arranca nada allí. Pero es el único sitio por donde empezar."},
		]}
	return {"bg": "comisaria", "flag": "done_brief6", "beats": [
		{"who": "narrador", "text": "El nombre de Vaultier pesa tanto que en la comisaría lo pronuncian bajando la voz. Núñez cierra la puerta con llave antes de hablar."},
		{"who": "nunez", "text": "Aristide Vaultier. No existe expediente suyo porque cada vez que alguien abre uno, desaparece. Como las mujeres. Es el hombre más limpio de la ciudad sobre el papel."},
		{"who": "detective", "text": "Los más limpios sobre el papel son los que tienen a alguien limpiando. Voy a ir de frente: a su bufete, a mirarle a los ojos."},
		{"who": "nunez", "text": "No le sacará una confesión. Pero le hará saber que existe. A veces, con esta gente, que sepan que van a caer ya es empezar a empujarlos."},
		{"who": "detective", "text": "Que sepa que existo. Buen principio. Al bufete Vaultier."},
	]}


static func _dlg_despacho(done: bool) -> Dictionary:
	if done:
		return {"bg": "despacho", "beats": [
			{"who": "detective", "text": "Vaultier es la cima, sí. Pero es intocable sin dinero rastreable. Hay que seguir los pagos."},
		]}
	return {"bg": "despacho", "clue": {"title": "El nombre de arriba", "text": "Aristide Vaultier dirige el Cónclave; se sabe intocable y casi lo confiesa, seguro de su impunidad."}, "flag": "done_despacho", "beats": [
		{"who": "narrador", "text": "El bufete Vaultier ocupa la última planta de una torre de cristal. Desde el ventanal, la ciudad de neón parece un tablero suyo. Vaultier, elegantísimo, ni se levanta."},
		{"who": "magnate", "text": "La famosa detective Vega. Siéntese. Es usted una mujer notable: ha desmontado un negocio que llevaba décadas funcionando. Casi da pena."},
		{"who": "detective", "text": "Lo dice como si el negocio fuera suyo."},
		{"who": "magnate", "text": "Digo lo que quiero, aquí y donde sea. Esa es la diferencia entre usted y yo, detective. Usted persigue la verdad. Yo, sencillamente, decido cuál es."},
		{"choices": [
			{"text": "\"Sé lo del Cónclave. Y lo probaré.\"", "then": [
				{"who": "magnate", "text": "Pruébelo. Tiene un libro que ningún juez admitirá, la palabra de un recadero cobarde y la cara de una periodista a la que despediré con una llamada. Yo tengo la ciudad."},
				{"who": "detective", "text": "(Está tan seguro que casi lo admite. La soberbia es la grieta de los intocables.)", "side": "right"},
			]},
			{"text": "\"¿Por qué mujeres? ¿Por qué así?\"", "then": [
				{"who": "magnate", "text": "Porque puedo. Porque hay quien colecciona arte y quien colecciona poder sobre lo único que el dinero no debería comprar. A Bru lo movía el amor, pobre iluso. A mí, la certeza de que nada me alcanza."},
			]},
		]},
		{"who": "detective", "text": "El nombre de arriba, confesado por pura soberbia. Pero la soberbia no es prueba. Si él decide la verdad, yo tendré que traer uña que no pueda tapar: su dinero. Voy a seguir los pagos."},
	]}


static func _dlg_falso6(done: bool) -> Dictionary:
	if done:
		return {"bg": "despacho_secretario", "beats": [
			{"who": "detective", "text": "El 'trato' del secretario era una trampa para comprarme o grabarme. Ni de lejos."},
		]}
	return {"bg": "despacho_secretario", "clues": [
		{"title": "El trato", "text": "El secretario ofreció dinero y un cargo por abandonar el caso: un soborno-trampa, no una pista.", "false": true},
		{"title": "El chófer de Vaultier", "text": "Sabe rutas y horas; un empleado fiel y mudo, no un delator.", "false": true},
		{"title": "El jardinero", "text": "Ve entrar y salir a todos; solo le importan sus rosas.", "false": true},
		{"title": "La socia de fundación", "text": "Aparece en fotos benéficas con Vaultier; pantalla de caridad, sin poder real.", "false": true},
		{"title": "El juez amigo", "text": "Cena con Vaultier; corrupto, sí, pero no la cabeza de la trata.", "false": true}], "flag": "done_falso6", "beats": [
		{"who": "narrador", "text": "En el pasillo, un secretario impecable te intercepta con una sonrisa ensayada y un sobre grueso entre los dedos."},
		{"who": "detective", "text": "Déjeme adivinar. Dentro hay más de lo que gano en cinco años."},
		{"who": "narrador", "text": "'El Sr. Vaultier admira su talento', ronronea. 'Le ofrece una jefatura, un despacho como este, y el olvido de este malentendido. Solo tiene que firmar su traslado... y su silencio.'"},
		{"who": "detective", "text": "¿Y si en vez de firmar, me llevo el sobre como prueba de cohecho?"},
		{"who": "narrador", "text": "El secretario ni parpadea: 'Entonces jurará ante el juez que usted lo exigió. Somos tres testigos y usted, una. ¿Ve el problema?'"},
		{"who": "detective", "text": "(Un soborno que es una trampa. Acepto y me compran; me niego con el sobre y me hunden por extorsión. No hay pista aquí: hay una jaula.)", "side": "right"},
		{"who": "detective", "text": "Guárdese su sobre y su jaula. No todas las piezas de este tablero están a la venta. Empezando por mí."},
	]}


static func _dlg_contable(done: bool) -> Dictionary:
	if done:
		return {"bg": "gestoria", "beats": [
			{"who": "detective", "text": "Los pagos del Cónclave salían de una cuenta fantasma de Vaultier. El dinero sí deja huella."},
		]}
	return {"bg": "gestoria", "clue": {"title": "Los pagos", "text": "Una cuenta fantasma conecta a Vaultier con los pagos al Corredor y a los policías comprados."}, "flag": "done_contable", "beats": [
		{"who": "narrador", "text": "El contable del gremio, un hombrecito gris al que Vera Lang localizó, tiembla en un piso franco. Ha decidido hablar el día que ha entendido que él también es prescindible."},
		{"who": "detective", "text": "Vaultier dice que su dinero es invisible. Usted lo movía. Dígame que se equivoca."},
		{"who": "contable", "text": "Se equivoca en una cosa: creía que yo destruía los duplicados. Los guardé. Todos. Una cuenta en el extranjero, 'Fundación Bronce', desde la que se pagaba al Corredor, a los jueces, a los policías. Todo cuadra al céntimo."},
		{"choices": [
			{"text": "\"¿Puede probarse que es suya?\"", "then": [
				{"who": "contable", "text": "Con estos duplicados y su firma real en la apertura, sí. Es el único papel que Vaultier no pudo tocar porque no sabía que existía."},
			]},
			{"text": "\"¿Por qué me ayuda ahora?\"", "then": [
				{"who": "contable", "text": "Porque después de la subasta, oí a Vaultier dar mi nombre en una frase que terminaba en 'ocúpate'. Prefiero un juicio a un accidente de coche."},
			]},
		]},
		{"who": "detective", "text": "Los pagos. La cuenta fantasma con su firma. El dinero es la única verdad que Vaultier no puede reescribir. Ya casi lo tengo: solo me falta romper su coartada."},
	]}


static func _dlg_coartada(done: bool) -> Dictionary:
	if done:
		return {"bg": "mansion", "beats": [
			{"who": "detective", "text": "Su coartada de las noches de tormenta es falsa. Vaultier subía a su azotea a 'presidir'. Ahí lo espero."},
		]}
	return {"bg": "mansion", "clue": {"title": "La coartada rota", "text": "Las noches de los secuestros Vaultier no estaba en sus galas: subía a la azotea de su torre."}, "flag": "done_coartada", "beats": [
		{"who": "narrador", "text": "La mansión Vaultier presume de coartadas: fotos del magnate en galas benéficas cada noche de tormenta. Demasiado puntual para ser verdad."},
		{"who": "detective", "text": "Un hombre que aparece fotografiado en una gala EXACTAMENTE en cada desaparición. O es mala suerte... o es puesta en escena."},
		{"who": "narrador", "text": "Cotejas las fotos con Vera. En todas, el mismo esmoquin, la misma copa a medio llenar, el mismo ángulo. Fueron tomadas el mismo día y repartidas por noches."},
		{"choices": [
			{"text": "Interrogar al servicio", "then": [
				{"who": "narrador", "text": "Una doncella despedida sin carta habla por rencor: cada noche de tormenta, el señor subía solo a la azotea de su torre y prohibía molestarle. 'A ver llover', decía."},
				{"who": "detective", "text": "A ver llover. Desde la azotea más alta de la ciudad. Presidiendo su cosecha como un dios de pacotilla."},
			]},
			{"text": "Revisar los registros del ascensor", "then": [
				{"who": "narrador", "text": "El registro privado del ascensor de la torre no miente como las fotos: cada noche señalada, un único viaje a la azotea a las 23:00. Y bajada de madrugada."},
				{"who": "detective", "text": "El ascensor lo delata. A las once arriba, de madrugada abajo. Justo la hora de cada campana."},
			]},
		]},
		{"who": "detective", "text": "La coartada rota. El dinero, el testigo, la mentira de las fotos... lo tengo entero. Y sé dónde estará esta noche de tormenta: en su azotea. Voy a subir a por él."},
	]}


static func _dlg_azotea() -> Dictionary:
	return {"bg": "azotea", "clue": {"title": "La cúspide", "text": "Aristide Vaultier, detenido en su azotea con pruebas irrefutables. La cima, por fin, cae."}, "flag": "cap6_completo", "beats": [
		{"who": "narrador", "text": "La azotea de la torre Vaultier es el punto más alto de la ciudad. La tormenta azota los pararrayos como campanas invisibles. Vaultier, de esmoquin y sin paraguas, contempla su reino sin volverse."},
		{"who": "magnate", "text": "Sabía que subiría, detective. Todos los que me persiguen acaban aquí arriba, conmigo, viendo lo pequeño que es el mundo desde la cima. Casi ninguno vuelve a bajar."},
		{"who": "detective", "text": "Yo traigo compañía, Vaultier. Su contable. Sus cuentas. El registro de su ascensor. Y una periodista imprimiendo mientras hablamos. Esta vez la verdad la decido yo."},
		{"who": "magnate", "text": "Impresionante. De verdad. Pero mire abajo: mis jueces, mis periódicos, mis policías. ¿Cuánto cree que sobrevive su 'verdad' ahí abajo, en mi ciudad?"},
		{"choices": [
			{"text": "\"Esta noche no es su ciudad.\"", "then": [
				{"who": "narrador", "text": "Abajo, en la avenida, un río de luces azules rodea la torre. Núñez ha traído a los limpios, y a la prensa que Vera no pudo callar. Por una vez, el ruido no lo controla Vaultier."},
				{"who": "detective", "text": "Escuche las sirenas, Vaultier. No las manda usted. Su ciudad, esta noche, ha dejado de contestarle."},
			]},
			{"text": "Enseñarle las pruebas en la mano", "then": [
				{"who": "narrador", "text": "Alzas la carpeta a la luz de un relámpago: la firma de la cuenta fantasma, imposible de negar. Por primera vez, la sonrisa del magnate vacila."},
				{"who": "detective", "text": "Su firma, Vaultier. La única cosa de este mundo que no pudo comprar ni borrar: su propio nombre en el sitio equivocado."},
			]},
		]},
		{"who": "narrador", "text": "Por un instante, Vaultier mira el borde de la azotea, la caída, la salida elegante. Luego mira las esposas. Y elige, por cobardía o por soberbia, seguir vivo para pelear."},
		{"who": "magnate", "text": "Tendré a los mejores abogados del país, detective. Esto no ha terminado."},
		{"who": "detective", "text": "Puede. Pero por primera vez tendrá que pelear. Y las mujeres a las que convirtió en lotes tendrán, por fin, un juicio con su nombre en la portada. Vamos abajo. Llueve."},
	]}


static func _dlg_cierre6() -> Dictionary:
	return {"bg": "comisaria", "flag": "done_cierre6", "beats": [
		{"who": "narrador", "text": "El juicio de Vaultier llena las portadas durante semanas. El de Vera, sin censura por primera vez. La 'Fundación Bronce' se desmorona, apellido a apellido."},
		{"who": "nunez", "text": "No hemos limpiado la ciudad, detective Vega. Eso no pasa nunca. Pero le hemos quitado la cúspide. Y las que estaban 'en catálogo' están en casa."},
		{"who": "periodista", "text": "Sara, Elena, Nadia, y otras nueve. Nombres, no lotes. En mi periódico, en primera, con foto y apellido. Se lo debía a las que no llegamos a tiempo."},
		{"who": "detective", "text": "A esas también. Sobre todo a esas."},
		{"who": "narrador", "text": "Nora sale a la calle. Ha dejado de llover. Sobre el Barrio Viejo, por primera vez en mucho tiempo, las campanas suenan a las horas, y solo a las horas."},
		{"who": "nunez", "text": "Descanse, detective. Se lo ha ganado. Aunque los dos sabemos que en esta ciudad el descanso dura lo que tarda en formarse la próxima tormenta."},
		{"who": "detective", "text": "Que se forme. Cuando caiga, aquí estaré. El barrio es mío las noches que hagan falta."},
		{"who": "narrador", "text": "— FIN DE LA TEMPORADA 2 —  Seis casos. Seis tormentas. De una campana robada a una ciudad entera puesta del revés. sOC."},
	]}


# ===========================================================================
#  TEMPORADA 3 (Caps. 7-20) · dirigida por datos (S3). Un solo caso: Nyxos.
# ===========================================================================
static func _ch_data_dialogue(id: String, done: bool) -> Dictionary:
	if not S3.has(id):
		return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}
	var d: Dictionary = S3[id]
	if done:
		var rev: String = d.get("revisit", "Ya saqué lo que había aquí. Sigo el hilo.")
		return {"bg": d.get("bg", "comisaria"), "beats": [{"who": "detective", "text": rev}]}
	var out := {"bg": d.get("bg", "comisaria"), "beats": d.get("beats", [])}
	if d.has("clue"):
		out["clue"] = d["clue"]
	if d.has("clues"):
		out["clues"] = d["clues"]
	if d.has("flag"):
		out["flag"] = d["flag"]
	return out


# ---------------------------------------------------------------------------
#  INTERACCIONES (mini-escenas) — prototipos jugables del tutorial (Cap. 0)
#  Una localización con entrada aquí abre su VISTA interactiva en la PRIMERA
#  visita (en vez del diálogo). La revisita usa el diálogo/revisit de S3.
#  Cada vista aplica clue+flag y emite finished(result) igual que DialogueView.
# ---------------------------------------------------------------------------
const INTERACT := {
"l0a": {"type": "search", "bg": "plaza", "flag": "done_l0a", "show_marks": true,
	"intro": "MECANICA - BUSQUEDA: examina la PLAZA. Toca lo que te llame la atencion.",
	"clue": {"title": "Leer el escenario", "text": "Un charco reflejaba a alguien huyendo: se aprende a leer la escena."},
	"reveal": "Una pista! Se guarda sola en tu libreta (arriba a la derecha).",
	"hotspots": [
		{"pos": Vector2(0.47, 0.85), "r": 34, "target": true, "text": "En el gran charco se recorta una figura que se aleja. AQUI hay algo."},
		{"pos": Vector2(0.70, 0.53), "r": 28, "text": "Un farol de gas encendido. Luz, no pistas."},
		{"pos": Vector2(0.22, 0.66), "r": 28, "text": "Puestos con la persiana echada. Cerrado."},
		{"pos": Vector2(0.66, 0.63), "r": 26, "text": "Una ventana con luz roja. Nada util."}]},
"rh0": {"type": "examine", "bg": "callejon", "flag": "done_rh0",
	"intro": "MECÁNICA · EXAMINAR: usa +/− (o la rueda) para acercarte y arrastra. Busca el detalle.",
	"clue": {"title": "El detalle del callejón", "text": "Una marca grabada en la pared: el sello de una serpiente. Fácil de pasar por alto.", "false": false},
	"detail_pos": Vector2(0.60, 0.46), "detail_r": 74,
	"hint": "Hay algo grabado cerca del centro. Acércate.",
	"found": "Ahí: una marca grabada que a simple vista no se veía."},
"l0b": {"type": "puzzle", "bg": "tienda", "flag": "done_l0b",
	"intro": "MECÁNICA · PUZZLE: el cajón del mostrador está cerrado. Marca el código del recibo.",
	"clue": {"title": "Tirar del hilo", "text": "Dentro del cajón, el hilo que conecta el caso. Con esta ya tienes las dos pistas."},
	"kind": "keypad", "code": "427",
	"hint": "En el recibo pegado al mostrador: 4 · 2 · 7.",
	"solved": "¡Cajón abierto! Dentro, la pista que buscabas."},
"l0c": {"type": "present", "bg": "archivo", "flag": "done_l0c",
	"intro": "MECÁNICA · PRESENTAR PRUEBA: escucha al sospechoso y toca la frase que es MENTIRA.",
	"speaker": "sospechoso",
	"statements": [
		{"text": "Yo esa noche no pisé la plaza.", "lie": true},
		{"text": "No sé nada de ninguna investigación.", "lie": false},
		{"text": "Estuve en casa durmiendo.", "lie": false}],
	"evidence_needed": "Leer el escenario",
	"rebuttal": "¡Contradicción! Tu pista lo sitúa en la plaza. Se acabó el teatro.",
	"hint_wrong_statement": "Esa frase no choca con lo que sabes. Busca la que contradice una pista.",
	"hint_wrong_evidence": "Esa pista no desmiente su mentira. Prueba con otra."},
"fin0": {"type": "deduce", "bg": "archivo", "flag": "cap0_completo",
	"intro": "MECÁNICA · DEDUCCIÓN: une las pistas. ¿Qué se deduce de ellas?",
	"clues_shown": ["Leer el escenario", "Tirar del hilo"],
	"conclusions": ["Con estas pistas, el caso se resuelve aquí.", "Aún faltan pistas por reunir.", "No hay caso que resolver."],
	"solution": 0,
	"solved": "¡Deducción correcta! Caso de prácticas resuelto.",
	"wrong": "No cuadra con las pistas. Vuelve a mirarlas."},

# ===== ESCENAS DE BÚSQUEDA EN CASOS REALES (Temporada 1) =====
# Cada una añade una pista ATMOSFÉRICA (no cuenta para el gating de "clues4") y luego
# ENCADENA el diálogo de la localización (then_dialogue) para no perder la narrativa.
# El diálogo pone su done_<id>; la búsqueda pone su searched_<id> (no repite en revisitas).
"plaza": {"type": "search", "bg": "plaza", "flag": "searched_plaza", "then_dialogue": true,
	"intro": "Acabas de llegar. Lee la PLAZA antes de moverte: que desentona?",
	"clue": {"title": "El reflejo en el charco", "text": "En el gran charco del centro se recorta, borrosa, una figura que se aleja hacia el fondo: alguien cruzo la plaza con prisa esa noche."},
	"reveal": "Anotado. Alguien cruzo la plaza deprisa esa noche.",
	"hotspots": [
		{"pos": Vector2(0.47, 0.85), "r": 34, "target": true, "text": "En el charco, borrosa, una figura que se aleja. Alguien cruzo deprisa."},
		{"pos": Vector2(0.70, 0.53), "r": 28, "text": "Un farol de gas encendido. Luz, no pistas."},
		{"pos": Vector2(0.22, 0.66), "r": 28, "text": "Puestos con la persiana echada. Cerrado a esta hora."},
		{"pos": Vector2(0.66, 0.63), "r": 26, "text": "Una ventana con luz roja. Alguien en vela, nada mas."}]},
"casa_marta": {"type": "search", "bg": "casa_marta", "flag": "searched_casa_marta", "then_dialogue": true,
	"intro": "Estas en la CASA DE MARTA. Registrala con calma: algo se salio de la rutina.",
	"clue": {"title": "La taza a medias", "text": "Sobre la mesita, una taza de cafe a medias y ya fria, con papeles al lado. Marta salio sin terminarla, con prisa."},
	"reveal": "Anotado. Marta salio de casa con prisa y sin plan.",
	"hotspots": [
		{"pos": Vector2(0.47, 0.74), "r": 32, "target": true, "text": "Una taza a medias y fria sobre la mesita. Salio con prisa."},
		{"pos": Vector2(0.16, 0.30), "r": 28, "text": "Fotos enmarcadas en la pared. Emotivas, nada util."},
		{"pos": Vector2(0.85, 0.66), "r": 28, "text": "Un sillon junto a la ventana. Vacio."},
		{"pos": Vector2(0.10, 0.62), "r": 26, "text": "Una lampara de mesa. Apagada."}]},
"refugio": {"type": "search", "bg": "refugio", "flag": "searched_refugio", "then_dialogue": true,
	"intro": "FUNDACION AMPARO. Antes de que te acompanen, mira alrededor: no todo cuadra.",
	"clue": {"title": "El registro tachado", "text": "En el mostrador, un libro de acogidas abierto con varios nombres tachados con la misma tinta. Como si nunca hubieran estado."},
	"reveal": "Anotado. Alguien borra a personas del registro del refugio.",
	"hotspots": [
		{"pos": Vector2(0.62, 0.47), "r": 30, "target": true, "text": "Un libro de acogidas con nombres tachados, sobre el mostrador."},
		{"pos": Vector2(0.20, 0.33), "r": 28, "text": "Un tablon de carteles de caridad. Sonrisas de catalogo."},
		{"pos": Vector2(0.14, 0.60), "r": 28, "text": "Un sofa de espera, gastado. Vacio."},
		{"pos": Vector2(0.43, 0.62), "r": 26, "text": "Un atril con folletos. Propaganda."}]},
"capilla": {"type": "search", "bg": "capilla", "flag": "searched_capilla", "then_dialogue": true,
	"intro": "La CAPILLA PRIVADA bajo la Fundacion. Examinala: alguien ha estado aqui hace poco.",
	"clue": {"title": "Cera fresca", "text": "Los cirios de la pared aun gotean cera tibia. Esta capilla que dicen cerrada se usa a diario."},
	"reveal": "Anotado. La capilla cerrada se usa en secreto.",
	"hotspots": [
		{"pos": Vector2(0.14, 0.36), "r": 30, "target": true, "text": "Cirios en la pared con la cera aun tibia. Se han usado hoy."},
		{"pos": Vector2(0.50, 0.60), "r": 28, "text": "El altar de madera. Solemne y despejado."},
		{"pos": Vector2(0.86, 0.66), "r": 28, "text": "Bancos de terciopelo. Vacios."},
		{"pos": Vector2(0.45, 0.88), "r": 26, "text": "La alfombra roja, gastada. Nada debajo."}]},
"mansion": {"type": "search", "bg": "mansion", "flag": "searched_mansion", "then_dialogue": true,
	"intro": "La MANSION del mecenas. Fijate bien antes de que aparezca nadie.",
	"clue": {"title": "El cuadro torcido", "text": "Un cuadro cuelga torcido; detras asoma el rectangulo limpio, sin polvo, de otro que ya no esta. Falta una pieza de la coleccion."},
	"reveal": "Anotado. De la coleccion falta algo, y hace poco.",
	"hotspots": [
		{"pos": Vector2(0.11, 0.54), "r": 30, "target": true, "text": "Un cuadro torcido; detras, el hueco sin polvo de otro que falta."},
		{"pos": Vector2(0.50, 0.16), "r": 28, "text": "Una lampara de arana. Ostentacion pura."},
		{"pos": Vector2(0.34, 0.80), "r": 28, "text": "La escalinata principal, encerada. Impecable."},
		{"pos": Vector2(0.92, 0.55), "r": 26, "text": "Una lampara de sobremesa. Cara, inutil."}]},
"sotano": {"type": "search", "bg": "sotano", "flag": "searched_sotano", "then_dialogue": true,
	"intro": "EL SOTANO de la mansion. Con cuidado: aqui paso algo.",
	"clue": {"title": "Aranazos en la reja", "text": "En los barrotes de la reja, aranazos a la altura de unas manos por dentro. Aqui encerraron a alguien."},
	"reveal": "Anotado. Aqui retuvieron a alguien contra su voluntad.",
	"hotspots": [
		{"pos": Vector2(0.50, 0.62), "r": 32, "target": true, "text": "Aranazos por dentro de la reja, a la altura de unas manos."},
		{"pos": Vector2(0.25, 0.76), "r": 28, "text": "Cajas de embalaje. Vacias y podridas."},
		{"pos": Vector2(0.20, 0.55), "r": 28, "text": "Una reja pequena al muro. Oxidada, fija."},
		{"pos": Vector2(0.55, 0.90), "r": 26, "text": "Agua estancada. Solo refleja los barrotes."}]},

# ===== BUSQUEDA EN CASOS REALES - Temporada 2 y 3 (mismo patron: atmosfera + then_dialogue) =====
"escena4": {"type": "search", "bg": "iglesia_int", "flag": "searched_escena4", "then_dialogue": true,
	"intro": "La IGLESIA DE LA MERCED, aun acordonada. Recorrela: el metodo se repite, pero hay algo nuevo.",
	"clue": {"title": "El lacre en el suelo", "text": "En el suelo, al pie de la escalera, una gota de lacre rojo endurecido. Una firma nueva sobre un metodo viejo."},
	"reveal": "Anotado. El secuestrador ha dejado su sello propio.",
	"hotspots": [
		{"pos": Vector2(0.46, 0.91), "r": 34, "target": true, "text": "En el suelo, al pie de la escalera, lacre rojo endurecido. Reciente."},
		{"pos": Vector2(0.17, 0.62), "r": 28, "text": "Una hornacina con una vela. Devocion, nada mas."},
		{"pos": Vector2(0.72, 0.81), "r": 28, "text": "Una ventana enrejada. Cerrada por dentro."},
		{"pos": Vector2(0.42, 0.61), "r": 26, "text": "Una lampara que se balancea. Corriente de aire."}]},
"trastienda": {"type": "search", "bg": "trastienda", "flag": "searched_trastienda", "then_dialogue": true,
	"intro": "La TRASTIENDA del salon. Rapido, antes de que vuelvan: aqui se guarda lo que no se ensena.",
	"clue": {"title": "El cuaderno de pujas", "text": "Sobre el escritorio, medio tapado, un cuaderno con pujas y apodos. Nadie apunta esto por gusto."},
	"reveal": "Anotado. Hay un registro de la subasta y de quien puja.",
	"hotspots": [
		{"pos": Vector2(0.72, 0.58), "r": 30, "target": true, "text": "Un cuaderno de pujas medio tapado, sobre el escritorio."},
		{"pos": Vector2(0.22, 0.35), "r": 28, "text": "Estanterias de cajas archivadas. Facturas viejas."},
		{"pos": Vector2(0.85, 0.30), "r": 28, "text": "Mas cajas apiladas. Genero y embalajes."},
		{"pos": Vector2(0.45, 0.62), "r": 26, "text": "Un mueble de cajones. Vacios o atascados."}]},
"coartada": {"type": "search", "bg": "mansion", "flag": "searched_coartada", "then_dialogue": true,
	"intro": "La MANSION VAULTIER. Su coartada dice una cosa; la casa, quiza otra.",
	"clue": {"title": "La escalera a la azotea", "text": "La escalera privada que sube a la azotea tiene el polvo pisado: alguien sube ahi las noches senaladas, cuando dice estar en sus galas."},
	"reveal": "Anotado. Vaultier no estaba donde dice esas noches.",
	"hotspots": [
		{"pos": Vector2(0.34, 0.72), "r": 30, "target": true, "text": "La escalera privada a la azotea, con el polvo recien pisado."},
		{"pos": Vector2(0.11, 0.54), "r": 28, "text": "Un cuadro enmarcado. Ostentacion, nada mas."},
		{"pos": Vector2(0.50, 0.16), "r": 28, "text": "Una lampara de arana. Cristal y oro."},
		{"pos": Vector2(0.92, 0.55), "r": 26, "text": "Una lampara de sobremesa. Cara, inutil."}]},
"l7a": {"type": "search", "bg": "morgue", "flag": "searched_l7a", "then_dialogue": true,
	"intro": "La MORGUE. Mientras Sonia prepara el cuerpo, mira alrededor: algo no cuadra en el papeleo.",
	"clue": {"title": "El informe corregido", "text": "En el mostrador central, un informe de autopsia con una linea tachada y reescrita por otra mano."},
	"reveal": "Anotado. Alguien altero el informe forense.",
	"hotspots": [
		{"pos": Vector2(0.52, 0.60), "r": 30, "target": true, "text": "En el mostrador, un informe con una linea tachada y reescrita."},
		{"pos": Vector2(0.20, 0.62), "r": 28, "text": "Una mesa de autopsias. Limpia, vacia."},
		{"pos": Vector2(0.60, 0.45), "r": 28, "text": "Cajones de acero para cuerpos. Cerrados."},
		{"pos": Vector2(0.82, 0.68), "r": 26, "text": "Otra mesa, con una sabana. No la levantes aun."}]},
"l8a": {"type": "search", "bg": "piso_diego", "flag": "searched_l8a", "then_dialogue": true,
	"intro": "El PISO DE DIEGO. Con el corazon encogido, registra: necesitas saber hasta donde llega.",
	"clue": {"title": "Los blisters vacios", "text": "En el cajon de la mesilla, blisters de Somnia vacios, escondidos. Mas de los que un tratamiento explica."},
	"reveal": "Anotado. Diego consume mucho mas de lo recetado.",
	"hotspots": [
		{"pos": Vector2(0.73, 0.80), "r": 30, "target": true, "text": "El cajon de la mesilla: blisters de Somnia vacios, escondidos."},
		{"pos": Vector2(0.12, 0.68), "r": 28, "text": "Un televisor viejo encendido. Ruido de fondo."},
		{"pos": Vector2(0.14, 0.28), "r": 28, "text": "Recortes y posters. Cosas de siempre."},
		{"pos": Vector2(0.45, 0.82), "r": 26, "text": "La cama deshecha. Vive al dia."}]},
"l9a": {"type": "search", "bg": "bufete_clara", "flag": "searched_l9a", "then_dialogue": true,
	"intro": "El BUFETE DE CLARA. Entre sus papeles hay algo que ni ella sabe que guarda.",
	"clue": {"title": "El expediente sellado", "text": "Sobre el escritorio, un expediente abierto con el sello de consentimiento y una firma que no coincide con la del paciente."},
	"reveal": "Anotado. Los consentimientos estan falsificados.",
	"hotspots": [
		{"pos": Vector2(0.38, 0.84), "r": 28, "target": true, "text": "Un expediente abierto con una firma que no cuadra."},
		{"pos": Vector2(0.12, 0.50), "r": 28, "text": "Una lampara de banquero. Solo da luz."},
		{"pos": Vector2(0.72, 0.42), "r": 28, "text": "Diplomas enmarcados. Legitimos, suyos."},
		{"pos": Vector2(0.74, 0.72), "r": 26, "text": "El sillon de Clara. Vacio."}]},
"l10a": {"type": "search", "bg": "laboratorio", "flag": "searched_l10a", "then_dialogue": true,
	"intro": "El LABORATORIO NYXOS. Todo reluce. Fijate en lo que la limpieza no borro.",
	"clue": {"title": "El albaran interno", "text": "Sobre una mesa, un albaran con el logo de Nyxos: numera lotes... y uno lleva iniciales de personas."},
	"reveal": "Anotado. Nyxos etiqueta personas como lotes.",
	"hotspots": [
		{"pos": Vector2(0.30, 0.62), "r": 28, "target": true, "text": "Sobre la mesa, un albaran de Nyxos con iniciales humanas."},
		{"pos": Vector2(0.06, 0.55), "r": 28, "text": "Frascos de reactivo iluminados. Etiquetas correctas."},
		{"pos": Vector2(0.85, 0.55), "r": 28, "text": "Botellas alineadas. Inventario normal."},
		{"pos": Vector2(0.52, 0.55), "r": 26, "text": "Aparatos de analisis. Apagados."}]},
"l11a": {"type": "search", "bg": "barrio_alto", "flag": "searched_l11a", "then_dialogue": true,
	"intro": "El BARRIO ALTO. Tras las verjas, el dinero se mueve en silencio. Busca su rastro.",
	"clue": {"title": "El coche sin matricula", "text": "Un coche de gama alta parado en la calle sin matricula y con el capo tibio: alguien acaba de entregar algo en mano aqui."},
	"reveal": "Anotado. Reparten dinero a domicilio, sin nombres.",
	"hotspots": [
		{"pos": Vector2(0.53, 0.73), "r": 30, "target": true, "text": "Un coche de gama alta sin matricula, con el capo aun tibio."},
		{"pos": Vector2(0.25, 0.32), "r": 28, "text": "Ventanas encendidas de una villa. Cenas tardias."},
		{"pos": Vector2(0.80, 0.68), "r": 28, "text": "Una farola. Ilumina el asfalto mojado."},
		{"pos": Vector2(0.30, 0.60), "r": 26, "text": "Setos recortados. Jardineria cara."}]},
"l12a": {"type": "search", "bg": "redaccion", "flag": "searched_l12a", "then_dialogue": true,
	"intro": "La REDACCION. Vera confia en ti; su mesa, sin querer, cuenta mas.",
	"clue": {"title": "El post-it garabateado", "text": "Pegado bajo el monitor de Vera, un post-it con una hora y un muelle. Una cita a ciegas."},
	"reveal": "Anotado. Hay una cita secreta anotada al vuelo.",
	"hotspots": [
		{"pos": Vector2(0.80, 0.72), "r": 28, "target": true, "text": "Bajo el monitor de Vera, un post-it con una hora y un muelle."},
		{"pos": Vector2(0.18, 0.72), "r": 28, "text": "Ordenadores de la redaccion. Titulares a medias."},
		{"pos": Vector2(0.06, 0.42), "r": 28, "text": "Archivadores de recortes. Hemeroteca."},
		{"pos": Vector2(0.40, 0.80), "r": 26, "text": "Pilas de periodicos por el suelo. Caos habitual."}]},
"l13a": {"type": "search", "bg": "archivo_medico", "flag": "searched_l13a", "then_dialogue": true,
	"intro": "El ARCHIVO MEDICO. Filas de expedientes. Uno desentona por lo que le falta.",
	"clue": {"title": "La ficha sin nombre", "text": "En una caja del estante, una ficha clinica con numero de sujeto pero sin nombre. Alguien prefirio que no lo tuviera."},
	"reveal": "Anotado. Hay pacientes reducidos a un numero.",
	"hotspots": [
		{"pos": Vector2(0.20, 0.45), "r": 28, "target": true, "text": "Una caja con una ficha: numero de sujeto y sin nombre."},
		{"pos": Vector2(0.82, 0.40), "r": 28, "text": "Cajas de expedientes archivados. En orden."},
		{"pos": Vector2(0.15, 0.75), "r": 28, "text": "Cajas en el estante bajo. Polvo."},
		{"pos": Vector2(0.55, 0.45), "r": 26, "text": "Filas de archivadores. Interminables."}]},
"l14a": {"type": "search", "bg": "costa", "flag": "searched_l14a", "then_dialogue": true,
	"intro": "El PUEBLO DE LA COSTA. Aire salado y silencio de mas. Mira lo que nadie mira.",
	"clue": {"title": "La barca de mas", "text": "Una barca amarrada junto al muelle con correas y lonas nuevas, impropias de un pescador: aqui no se pesca, se transporta."},
	"reveal": "Anotado. Mueven carga -o personas- por mar.",
	"hotspots": [
		{"pos": Vector2(0.78, 0.83), "r": 30, "target": true, "text": "Una barca con amarres y lonas nuevas junto al muelle. No es de pesca."},
		{"pos": Vector2(0.68, 0.40), "r": 28, "text": "El caseron sobre la loma. Luces apagadas."},
		{"pos": Vector2(0.29, 0.42), "r": 28, "text": "Un mastil viejo. Cruje con el viento."},
		{"pos": Vector2(0.25, 0.88), "r": 26, "text": "Una barca de pesca varada. Vacia."}]},
"l15a": {"type": "search", "bg": "montana", "flag": "searched_l15a", "then_dialogue": true,
	"intro": "El PUEBLO DE MONTANA. Frio y aislado, perfecto para esconder. Registra con calma.",
	"clue": {"title": "El sanatorio de lo alto", "text": "En lo alto de la loma, un edificio aislado con una chimenea humeando toda la noche. De ese sanatorio nadie sale con el alta de verdad."},
	"reveal": "Anotado. El sanatorio esconde a quienes no salen.",
	"hotspots": [
		{"pos": Vector2(0.62, 0.25), "r": 32, "target": true, "text": "En lo alto, un edificio aislado con la chimenea humeando de noche."},
		{"pos": Vector2(0.30, 0.68), "r": 28, "text": "Cabanas con la luz encendida. Vida de pueblo."},
		{"pos": Vector2(0.55, 0.85), "r": 28, "text": "El camino nevado. Pisadas de siempre."},
		{"pos": Vector2(0.85, 0.45), "r": 26, "text": "Bosque de abetos. Solo nieve y silencio."}]},
"l16a": {"type": "search", "bg": "ciudad2", "flag": "searched_l16a", "then_dialogue": true,
	"intro": "OTRA CIUDAD, misma sombra. Compara lo que ves con lo que ya conoces.",
	"clue": {"title": "El mismo cartel", "text": "En una fachada, el mismo logotipo de Nyxos que en tu ciudad, con la serpiente. No es casualidad: es una cadena."},
	"reveal": "Anotado. Nyxos replica el mismo montaje en otras ciudades.",
	"hotspots": [
		{"pos": Vector2(0.68, 0.55), "r": 30, "target": true, "text": "Un rotulo con el logo de Nyxos, identico al de tu ciudad."},
		{"pos": Vector2(0.20, 0.72), "r": 28, "text": "Escaparates y maquinas. Comercio de barrio."},
		{"pos": Vector2(0.30, 0.35), "r": 28, "text": "Rascacielos con oficinas encendidas. Rutina."},
		{"pos": Vector2(0.90, 0.85), "r": 26, "text": "Un coche aparcado. Mojado, vacio."}]},
"l17a": {"type": "search", "bg": "bar_clara", "flag": "searched_l17a", "then_dialogue": true,
	"intro": "EL BAR DE CLARA. Una copa tranquila... o eso parece. Fijate en lo que sobra.",
	"clue": {"title": "La tarjeta olvidada", "text": "Bajo la barra, junto a las botellas, la tarjeta de un bufete que arregla problemas. Alguien la dejo para ti."},
	"reveal": "Anotado. Te estan tanteando con un intermediario.",
	"hotspots": [
		{"pos": Vector2(0.12, 0.80), "r": 28, "target": true, "text": "Bajo la barra, entre las botellas, una tarjeta de un bufete."},
		{"pos": Vector2(0.25, 0.62), "r": 28, "text": "Botellas alineadas al contraluz. Inventario."},
		{"pos": Vector2(0.85, 0.90), "r": 28, "text": "Reservados de cuero rojo. Vacios."},
		{"pos": Vector2(0.17, 0.16), "r": 26, "text": "Un farolillo rojo. Ambiente, nada mas."}]},
"l18a": {"type": "search", "bg": "oficina", "flag": "searched_l18a", "then_dialogue": true,
	"intro": "LA SEDE DE NYXOS. Pasillos de cristal. Lo que falta grita mas que lo que hay.",
	"clue": {"title": "El acta incompleta", "text": "Sobre un escritorio, un acta del consejo con un punto del orden del dia arrancado. Justo el que importaba."},
	"reveal": "Anotado. Han mutilado el acta del consejo.",
	"hotspots": [
		{"pos": Vector2(0.85, 0.70), "r": 28, "target": true, "text": "Sobre un escritorio, un acta con un punto del orden del dia arrancado."},
		{"pos": Vector2(0.12, 0.68), "r": 28, "text": "Puestos de trabajo. Pantallas en reposo."},
		{"pos": Vector2(0.35, 0.66), "r": 28, "text": "Mamparas de oficina. Vacias a esta hora."},
		{"pos": Vector2(0.50, 0.45), "r": 26, "text": "Ventanal a la ciudad. Vistas, no pistas."}]},
"l19a": {"type": "search", "bg": "oficina", "flag": "searched_l19a", "then_dialogue": true,
	"intro": "EL DESPACHO DE ADLER. La cara de Nyxos. Su despacho la delata mejor que sus palabras.",
	"clue": {"title": "La foto recortada", "text": "En el escritorio de Adler, una foto de grupo del consejo con una cara recortada a conciencia."},
	"reveal": "Anotado. Adler borra a alguien de la foto oficial.",
	"hotspots": [
		{"pos": Vector2(0.15, 0.70), "r": 28, "target": true, "text": "En el escritorio de Adler, una foto de grupo con una cara recortada."},
		{"pos": Vector2(0.85, 0.68), "r": 28, "text": "Un monitor encendido. Salvapantallas corporativo."},
		{"pos": Vector2(0.35, 0.66), "r": 28, "text": "Mamparas de oficina. Despejadas."},
		{"pos": Vector2(0.50, 0.45), "r": 26, "text": "El ventanal panoramico. La ciudad a sus pies."}]},
"l20a": {"type": "search", "bg": "consejo", "flag": "searched_l20a", "then_dialogue": true,
	"intro": "LA SALA DEL CONSEJO. La cupula al completo. Esta vez, que quede grabado.",
	"clue": {"title": "La grabadora oculta", "text": "Encajada bajo el borde de la mesa del consejo, una grabadora que alguien dejo corriendo. La prueba definitiva puede estar aqui."},
	"reveal": "Anotado. Puede que la prueba definitiva ya se este grabando.",
	"hotspots": [
		{"pos": Vector2(0.45, 0.88), "r": 30, "target": true, "text": "Bajo el borde de la mesa, una grabadora dejada corriendo."},
		{"pos": Vector2(0.50, 0.70), "r": 28, "text": "Carpetas repartidas por la mesa. Orden del dia."},
		{"pos": Vector2(0.65, 0.82), "r": 28, "text": "Una tablet encendida. Salvapantallas corporativo."},
		{"pos": Vector2(0.15, 0.72), "r": 26, "text": "Butacas de cuero. Vacias, por ahora."}]},
}

static func interact_data(id: String) -> Dictionary:
	return INTERACT.get(id, {})

static func has_interact(id: String) -> bool:
	return INTERACT.has(id)


const S3 := {
# --- Cap. 0 · TUTORIAL (enseña el bucle de juego) ---
"brief0": {"bg": "comisaria", "flag": "done_brief0", "beats": [
	{"who": "narrador", "text": "Bienvenido a sOC. Esto es el CAPÍTULO 0: el tutorial. Aquí vas a aprender a jugar paso a paso. Toca la pantalla (o haz clic) para pasar cada línea de texto."},
	{"who": "narrador", "text": "Estás en la COMISARÍA, tu base de operaciones. Alguien va a hablarte..."},
	{"who": "nunez", "text": "Buenas noches. Soy el sargento Núñez. Trabajo aquí, en la comisaría, y voy a ser tu apoyo durante todo el juego."},
	{"who": "narrador", "text": "» Ese es el SARGENTO NÚÑEZ. Cuando un personaje habla, ves su RETRATO a un lado de la pantalla y su NOMBRE encima del texto."},
	{"who": "detective", "text": "Y yo soy Nora Vega. Detective. La que se va a patear cada caso hasta el fondo, caiga quien caiga."},
	{"who": "narrador", "text": "» Ella es NORA VEGA, la PROTAGONISTA: a la que acompañas durante todo el juego. Su retrato aparece al OTRO lado cuando habla ella."},
	{"who": "nunez", "text": "El trabajo es fácil de entender: la ciudad es un MAPA con lugares marcados. Vas a un lugar, hablas con la gente y sacas PISTAS. Con las pistas, resuelves el caso."},
	{"who": "detective", "text": "Empecemos por lo básico. En cuanto cerremos esta charla, volverás al mapa. Yo te voy guiando."},
	{"who": "nunez", "text": "Y no te limitarás a leer: en cada sitio BUSCARÁS pistas en el escenario, EXAMINARÁS detalles de cerca, forzarás algún CANDADO, presentarás PRUEBAS para pillar una mentira y ATARÁS CABOS para deducir. Yo te guío en cada paso."},
	{"who": "narrador", "text": "» AHORA: al cerrar esto verás el MAPA. Habrá un punto que PARPADEA (la Plaza del Barrio). TÓCALO para ir allí. Arriba del todo, la barra de OBJETIVO te dirá siempre qué hacer."}], "revisit": "Tutorial: toca en el mapa el punto que parpadea. Arriba, la barra de objetivo te dice qué hacer."},
"l0a": {"bg": "plaza", "flag": "done_l0a", "clue": {"title": "Leer el escenario", "text": "Cada lugar que visitas abre una escena; lo que sacas en claro se anota como PISTA en tu libreta."}, "beats": [
	{"who": "narrador", "text": "Has llegado a la PLAZA. Esto es una LOCALIZACIÓN: una escena donde observas y hablas con la gente. Toca para avanzar el texto, como hasta ahora."},
	{"who": "detective", "text": "Aquí miro, escucho y ato cabos. Y cuando saco algo que de verdad importa, eso es una PISTA."},
	{"who": "narrador", "text": "» Cuando consigues una pista, se guarda sola en tu LIBRETA: el botón con el cuaderno, arriba a la DERECHA de la pantalla."},
	{"who": "detective", "text": "Tu primera pista ya es tuya: aprender a leer un escenario. No tienes que apuntar nada, el juego lo hace por ti."},
	{"who": "narrador", "text": "» Al cerrar esta escena verás la PISTA VOLAR hasta el icono de la libreta. Ahí quedan guardadas TODAS; pulsa el icono cuando quieras para releerlas."},
	{"who": "narrador", "text": "» Además, en el MAPA habrán aparecido lugares NUEVOS. Toca el siguiente punto que PARPADEE para continuar el tutorial."}], "revisit": "Aquí aprendí a leer un escenario. Cada visita deja una pista en la libreta (arriba a la derecha)."},
"rh0": {"bg": "callejon", "flag": "done_rh0", "clues": [
	{"title": "El gato del callejón", "text": "Un ruido tras los cubos de basura: solo un gato. No todo lo que asusta es una pista.", "false": true},
	{"title": "El borracho", "text": "Jura haber visto «algo raro»; ha visto el fondo de la botella.", "false": true},
	{"title": "La sombra en la pared", "text": "Una silueta amenazante que resultó ser la tuya bajo la farola.", "false": true},
	{"title": "El grafiti", "text": "Un símbolo pintado que parecía una clave y era el anuncio de un bar.", "false": true},
	{"title": "El coche mal aparcado", "text": "Sospechoso solo de multa; nada que ver con ningún caso.", "false": true}], "beats": [
	{"who": "narrador", "text": "Estás en un CALLEJÓN. Aquí aprendes algo clave: no todo lo que encuentras es una pista de verdad."},
	{"who": "detective", "text": "Mira: un gato, un borracho, una sombra, un grafiti, un coche mal aparcado... Sustos que no llevan a nada. Son PISTAS FALSAS."},
	{"who": "narrador", "text": "» Las pistas FALSAS el juego las DESCARTA solas: las verás salir hacia la libreta pero TACHADAS en ROJO, y NO se guardan. No cuentan para resolver el caso."},
	{"who": "detective", "text": "No pierdas el tiempo con ellas. Cinco sustos, cero pistas buenas. Volvamos al hilo que sí importa."},
	{"who": "narrador", "text": "» Vuelve al mapa y toca el siguiente punto que parpadee para seguir el tutorial."}], "revisit": "El callejón de las pistas falsas. El juego las descarta solas (en rojo); no cuentan para el caso."},
"l0b": {"bg": "tienda", "flag": "done_l0b", "clue": {"title": "Tirar del hilo", "text": "Cada caso necesita TODAS sus pistas de calle antes de abrir el lugar clave. El objetivo de arriba te avisa cuando ya las tienes."}, "beats": [
	{"who": "narrador", "text": "La TIENDA de la esquina. Aquí sacas tu SEGUNDA pista de verdad."},
	{"who": "detective", "text": "Con esta ya tengo las dos pistas que pedía este caso de prácticas."},
	{"who": "narrador", "text": "» REGLA IMPORTANTE: el LUGAR donde se resuelve el caso NO se abre hasta que tienes TODAS las pistas. Mira la barra de OBJETIVO arriba: ahora te dirá que vayas al lugar clave."},
	{"who": "narrador", "text": "» Vuelve al mapa y toca el ARCHIVO, el punto que se acaba de desbloquear."}], "revisit": "Con todas las pistas de calle se abre el lugar clave. La barra de objetivo (arriba) te guía."},
"l0c": {"bg": "archivo", "flag": "done_l0c", "beats": [
	{"who": "narrador", "text": "El interrogatorio: presentaste la prueba y lo pillaste en la mentira."}], "revisit": "Aquí desarmé al sospechoso: su mentira chocaba con una pista, y presentar la prueba correcta lo delató."},
"fin0": {"bg": "archivo", "flag": "cap0_completo", "clue": {"title": "Cerrar el caso", "text": "Con las pistas reunidas se llega al lugar clave y se resuelve el caso. Después, se informa en comisaría para abrir el siguiente."}, "beats": [
	{"who": "narrador", "text": "El ARCHIVO. Este es el LUGAR CLAVE del caso, y solo se abrió porque ya tenías todas las pistas."},
	{"who": "detective", "text": "Aquí se junta todo y el caso se resuelve. Esto es siempre lo último de cada caso."},
	{"who": "narrador", "text": "» Al resolverlo verás el aviso «Caso resuelto». Después SIEMPRE hay que volver a la COMISARÍA a informar: eso abre el caso siguiente."},
	{"who": "detective", "text": "Caso de prácticas: resuelto. No estaba mal para ser de mentira."},
	{"who": "narrador", "text": "» Vuelve al mapa por última vez y toca la COMISARÍA para terminar el tutorial."}], "revisit": "El lugar clave del tutorial. Con las pistas reunidas, el caso se cierra. Luego, informar en comisaría."},
"cierre0": {"bg": "comisaria", "flag": "done_cierre0", "beats": [
	{"who": "narrador", "text": "De vuelta en la comisaría. Fin del tutorial."},
	{"who": "nunez", "text": "Bien hecho. Ese es el oficio: recorre el MAPA, BUSCA y EXAMINA para sacar PISTAS, fuerza lo que se cierre, PRESENTA la prueba que pilla la mentira y DEDUCE para cerrar el caso. Luego, siempre, INFORMA en comisaría."},
	{"who": "narrador", "text": "» El juego GUARDA solo a cada paso. Puedes cerrar cuando quieras y pulsar «Continuar» en el menú principal para seguir donde lo dejaste."},
	{"who": "detective", "text": "Lo tengo. Mapa, pistas, libreta, lugar clave, informar. Vamos a lo de verdad."},
	{"who": "nunez", "text": "Se acabó el ensayo. Tu primer caso real: una desaparición en la iglesia de San José. Suerte ahí fuera, detective Vega."},
	{"who": "detective", "text": "El barrio es mío esta noche."},
	{"who": "narrador", "text": "» Empieza el CASO 1. A partir de aquí, tú decides. ¡Suerte!"}], "revisit": "Fin del tutorial. Empieza el primer caso real."},

# --- Cap. 7 · La receta ---
"brief7": {"bg": "comisaria", "flag": "done_brief7", "beats": [
	{"who": "nunez", "text": "Una de las mujeres del caso Vaultier apareció muerta en el río. Pero no se ahogó: la mató algo en la sangre. La forense quiere verla, detective."},
	{"who": "detective", "text": "Sonia nunca me llama por una sobredosis normal. Voy a la morgue."}]},
"l7a": {"bg": "morgue", "flag": "done_l7a", "clue": {"title": "El fármaco Somnia", "text": "En la sangre de la víctima, un fármaco experimental sin nombre comercial: 'Somnia'."}, "beats": [
	{"who": "narrador", "text": "La morgue municipal es fría y blanca. Sonia, tu mejor amiga desde la academia, te espera con dos cafés y una carpeta."},
	{"who": "sonia", "text": "Nora. Mira esto. Un compuesto que no está en ningún vademécum. Lo he llamado 'Somnia' porque literalmente apaga el cerebro sin apagar el cuerpo."},
	{"who": "sonia", "text": "Es lo que las tenía dóciles durante los secuestros. Y es carísimo de fabricar. Esto no lo cocina un camello en un garaje: esto sale de un laboratorio de verdad."},
	{"who": "detective", "text": "Un fármaco de diseño. Alguien con bata y presupuesto. El caso no se cerró con Vaultier: solo le vimos la punta."}], "revisit": "Somnia. Lo que las dormía. Sonia dice que sale de un laboratorio, no de un garaje."},
"rh7": {"bg": "comisaria", "flag": "done_rh7", "clues": [
	{"title": "El camello del puente", "text": "El camello del barrio: Somnia le queda grande, solo vende cosas de calle.", "false": true},
	{"title": "El veterinario", "text": "Un veterinario que compra sedantes a granel; eran para el ganado, todo en regla.", "false": true},
	{"title": "La enfermera despedida", "text": "Una enfermera con rencor al hospital; sisaba gasas, no fármacos de diseño.", "false": true},
	{"title": "El químico jubilado", "text": "Un viejo químico con laboratorio casero: solo destila orujo de contrabando.", "false": true},
	{"title": "El curandero", "text": "Un curandero que 'cura el sueño' con valeriana. Nada químico ni criminal.", "false": true}], "beats": [
	{"who": "narrador", "text": "La pizarra se llena de sospechosos fáciles para una droga rara. Nora los va tachando uno a uno en una tarde larga de teléfono."},
	{"who": "detective", "text": "El camello no llega, el veterinario está limpio, la enfermera roba gasas, el químico hace orujo y el curandero, valeriana."},
	{"who": "detective", "text": "Cinco callejones sin salida. Somnia no la fabrica un aficionado. Vuelvo al hilo bueno: el laboratorio."}], "revisit": "Cinco pistas fáciles, cinco callejones. Somnia sale de un laboratorio, no de un garaje."},
"l7b": {"bg": "hospital", "flag": "done_l7b", "clue": {"title": "El médico que receta", "text": "Un tal Dr. Kessler firmó recetas de un 'ansiolítico en pruebas' a varias de las víctimas."}, "beats": [
	{"who": "narrador", "text": "En el hospital central, cruzas los nombres de las víctimas con los archivos de farmacia. Un patrón salta: un médico repetido."},
	{"who": "detective", "text": "Dr. Kessler. Recetó a media docena de ellas un 'ansiolítico en fase de pruebas'. Antes de desaparecer. Todas."},
	{"who": "detective", "text": "El que reparte la droga es el que marca a las presas. Kessler es mi primer eslabón. A su clínica."}], "revisit": "Kessler firmaba las recetas. Es el primer eslabón de la cadena."},
"fin7": {"bg": "clinica_kessler", "flag": "cap7_completo", "clue": {"title": "El eslabón Kessler", "text": "Kessler admite que le pagaban por 'seleccionar pacientes' para un ensayo; no sabe de quién."}, "beats": [
	{"who": "narrador", "text": "La consulta del Dr. Kessler huele a desinfectante y a miedo. Cuando le enseñas los nombres, se le cae el bolígrafo."},
	{"who": "kessler", "text": "Yo solo... seleccionaba candidatas. Mujeres solas, ansiosas, sin familia. Me pagaban por cada 'derivación'. Nunca pregunté para qué."},
	{"who": "detective", "text": "Derivaba mujeres a un matadero por un sobre. ¿Quién le pagaba?"},
	{"who": "kessler", "text": "No lo sé, se lo juro. Todo por mensajeros. Solo una palabra en los sobres, un membrete: una serpiente enroscada en una copa. El símbolo de la medicina."},
	{"who": "detective", "text": "Una serpiente en una copa. Un eslabón que apunta hacia arriba, hacia gente de bata blanca. Núñez tiene que oír esto."}], "revisit": "Kessler seleccionaba a las víctimas por encargo. El hilo sube hacia un laboratorio."},
"cierre7": {"bg": "comisaria", "flag": "done_cierre7", "beats": [
	{"who": "nunez", "text": "Así que las desapariciones eran... ¿una cantera? ¿Se las llevaban para probar un fármaco?"},
	{"who": "detective", "text": "Eso parece. Vaultier vendía la 'materia prima'. Pero quien fabrica Somnia está por encima de todos ellos."},
	{"who": "detective", "text": "Y hay algo que no le he contado, Núñez. Ese fármaco... lo he visto antes. En casa de mi hermano Diego."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 7 —  El caso ya no son unas mujeres: es una droga. Y el hilo acaba de meterse en la propia familia de Nora."}]},

# --- Cap. 8 · El hermano ---
"brief8": {"bg": "comisaria", "flag": "done_brief8", "beats": [
	{"who": "narrador", "text": "La comisaría a las tres de la mañana es un pasillo de fluorescentes que zumban y cafés olvidados. Nora tiene sobre la mesa el folleto que sacó del sótano: 'Proyecto Somnia'. La misma palabra que su hermano lleva meses repitiendo sin darse cuenta."},
	{"who": "detective", "text": "Somnia. Lo he oído en mi propia familia. Diego, mi hermano pequeño, toma 'algo para dormir' desde el invierno. 'Unas pastillas nuevas, gratis', decía. Yo no escuché. Estaba en el caso."},
	{"who": "nunez", "text": "Detective Vega, párese un segundo. Si el nombre de su caso ha entrado en la casa de su hermano, esto ya no es una investigación: es una herida. Y con una herida abierta se cometen errores."},
	{"who": "detective", "text": "Lo sé. Por eso quiero hacerlo bien. Necesito ver a Diego, ver esas pastillas, y necesito que quede fuera de mi informe hasta que sepa qué es. Si esto es lo que temo, es un testigo. Y si es peor, es una víctima."},
	{"who": "nunez", "text": "Fuera del informe, de momento. Pero prométame una cosa: en cuanto la sangre le nuble la cabeza, me llama. No entra sola donde no debe."},
	{"choices": [
		{"text": "«Te lo prometo. Solo voy a hablar con mi hermano.»", "then": [
			{"who": "detective", "text": "Solo voy a hablar con mi hermano, Núñez. Todavía puedo hacerlo como hermana."},
			{"who": "nunez", "text": "Ojalá. Vaya. Y lleve el móvil cargado."}]},
		{"text": "«Si es Somnia, no prometo nada.»", "then": [
			{"who": "detective", "text": "Si lo que le están dando a Diego es lo que durmió a esas mujeres, no le prometo que me quede quieta."},
			{"who": "nunez", "text": "Me lo temía. Al menos avíseme antes de hacer una locura, no después."}]}]},
	{"who": "detective", "text": "(Cuarenta minutos en coche hasta su piso. Cuarenta minutos para decidir si voy a llamar a su puerta como policía o como su hermana mayor. No lo tengo claro, y eso ya me da miedo.)", "side": "right"}], "revisit": "Tengo que ver a Diego. Su 'medicación' tiene el nombre del caso: Somnia."},
"l8a": {"bg": "piso_diego", "flag": "done_l8a", "clue": {"title": "El paciente cero", "text": "Diego consume Somnia; se la dieron 'gratis' en un ensayo clínico para insomnes."}, "beats": [
	{"who": "narrador", "text": "El piso de Diego huele a cerrado y a café recalentado. Las persianas bajadas a mediodía, ropa por el suelo, un cerco de tazas en la mesa. Tu hermano pequeño tarda en abrir, y cuando lo hace, no es él: es una versión con diez años de más y las ojeras hasta el mentón."},
	{"who": "diego", "text": "¿Nora? Joder, ¿qué hora es? No... no es buen momento. Llevo una racha mala otra vez. Bueno, mala menos, desde las pastillas nuevas. Esas sí funcionan, hermana. Esas me apagan como a una lámpara."},
	{"who": "detective", "text": "Diego, mírame. ¿Cuándo dormiste de verdad por última vez sin ellas?"},
	{"who": "diego", "text": "No sé. ¿Septiembre? Da igual, ya no hace falta. Me metí en un ensayo para el insomnio. Gratis. Encima te pagan por ir a las revisiones. A mí, que no me llega el mes. Me pareció un regalo."},
	{"who": "detective", "text": "Enséñame el bote. Y el folleto. Todo lo que te dieran. Ahora, Diego."},
	{"who": "narrador", "text": "Rebusca en un cajón y te tiende un frasco ámbar sin etiqueta de farmacia, solo un código y un logo diminuto: una serpiente enroscada en una copa. El mismo que viste bordado en el terciopelo de la capilla."},
	{"who": "detective", "text": "(La serpiente en la copa. Aquí, en la mesilla de mi hermano. El caso ha estado durmiendo en esta casa todo el invierno y yo sin verlo.)", "side": "right"},
	{"who": "diego", "text": "Pones la cara de policía, Nora. No la de hermana. Me estás asustando. Son solo pastillas para dormir."},
	{"choices": [
		{"text": "Decírselo de golpe, sin adornos", "then": [
			{"who": "detective", "text": "Diego, esa droga es la que usaban para dormir a las mujeres que secuestraban. La misma. Te has metido en la boca del lobo y te han pagado por entrar."},
			{"who": "diego", "text": "No... no me jodas, Nora. Yo solo quería dormir. Fui a una clínica limpia, con batas blancas, con papeles. Firmé cosas. ¿Cómo iba a...?"},
			{"who": "detective", "text": "No es culpa tuya. Los eligieron así: gente cansada, sola, que firmaría lo que fuera por una noche de sueño. Escúchame: se acabaron las pastillas desde este segundo."}]},
		{"text": "Protegerlo primero, explicarle después", "then": [
			{"who": "detective", "text": "Necesito que confíes en mí y tires ese bote a la basura ahora mismo. Luego te lo explico entero. Pero no tomas una más."},
			{"who": "diego", "text": "¿Y si vuelven las noches en blanco? Tú no sabes lo que es, Nora. Es estar muerto pero despierto."},
			{"who": "detective", "text": "Lo sé mejor de lo que crees. Y aun así: ni una más. Prefiero verte sin dormir que no verte."}]}]},
	{"who": "diego", "text": "Vale. Vale. Me das miedo, pero te hago caso. Siempre te hago caso, hermana mayor."},
	{"who": "detective", "text": "Una cosa más. La dirección de esa clínica. La necesito. Y necesito que no vuelvas por allí ni para devolver el frasco."},
	{"who": "narrador", "text": "Diego copia una dirección en un papel con mano temblorosa. Al dártelo, te agarra la muñeca un segundo, como cuando era niño y había tormenta."},
	{"who": "diego", "text": "Cógelos, Nora. A los que hacen esto. Cógelos por mí y por todos los que firmaron pensando que era un regalo."}], "revisit": "Diego es, sin saberlo, un sujeto de prueba de Somnia. Mi propio hermano, paciente cero en mi propia casa."},
"rh8": {"bg": "tienda_dealer", "flag": "done_rh8", "clues": [
	{"title": "El fanfarrón", "text": "Un vendedor que presumía de surtir Somnia; solo revende vitaminas caras.", "false": true},
	{"title": "El compañero de piso", "text": "El compañero de piso de Diego, sospechoso por vivir con él; está más enganchado que nadie.", "false": true},
	{"title": "La web milagro", "text": "Una web que vende 'sueño profundo' por correo: azúcar glas en cápsulas.", "false": true},
	{"title": "El médico de guardia", "text": "El médico que ingresó a Diego una vez; ni recuerda su nombre.", "false": true},
	{"title": "El foro de insomnes", "text": "Un foro donde se recomiendan la 'pastilla mágica'; víctimas, no culpables.", "false": true}], "beats": [
	{"who": "narrador", "text": "Antes de la clínica, Nora tira de los hilos fáciles: los que cualquiera seguiría. Una trastienda de barrio que huele a incienso barato y a mentiras. El dueño vende de todo y sabe de nada."},
	{"who": "detective", "text": "Cinco pistas que apuntan a Somnia. Vamos a ver cuántas aguantan un empujón."},
	{"who": "narrador", "text": "El fanfarrón que presume de surtirla resulta que revende vitaminas caras en frascos bonitos. El compañero de piso de Diego, tan sospechoso por convivencia, está más roto por las pastillas que nadie: otra víctima."},
	{"who": "detective", "text": "La web milagro manda azúcar glas en cápsulas contra reembolso. El médico de guardia que ingresó a Diego una vez ni recuerda su cara. Y el foro de insomnes solo es un coro de desesperados recomendándose veneno."},
	{"who": "detective", "text": "Cinco puertas, cinco callejones. Ninguno FABRICA Somnia: todos la sufren o la imitan. El de la calle no es el proveedor."},
	{"who": "detective", "text": "El de verdad no vende en una trastienda. Está detrás de una bata blanca, en una clínica que no existe en ningún registro. Ahí es donde tengo que entrar."}], "revisit": "Cinco fuentes falsas. La buena es la clínica fantasma del ensayo de Diego."},
"l8b": {"bg": "clinica", "flag": "done_l8b", "clue": {"title": "La clínica fantasma", "text": "El 'ensayo' de Diego se hacía en una clínica que no consta en ningún registro sanitario."}, "beats": [
	{"who": "narrador", "text": "La dirección del folleto te lleva a un edificio pulcro en una calle sin vida: cristales espejados, jardinera nueva, un timbre sin nombre. Demasiado limpio para un barrio así. Y cerrado a cal y canto."},
	{"who": "detective", "text": "Sin placa, sin licencia a la vista, sin horario. Una clínica que hace ensayos con personas y no aparece en ningún registro sanitario. Fantasma. Igual que las mujeres."},
	{"who": "narrador", "text": "Pegas la cara al cristal. Dentro se adivinan camillas, un mostrador vacío, un pasillo que se hunde en negro. En la puerta, una pegatina medio arrancada: la serpiente en la copa."},
	{"who": "detective", "text": "Está ahí. Todo está ahí dentro. Y no puedo tocar el pomo."},
	{"choices": [
		{"text": "Forzar la entrada ya, sin orden", "then": [
			{"who": "detective", "text": "(Un empujón y estoy dentro. Y mañana un abogado de mil euros la hora tira todo lo que encuentre a la basura por 'prueba ilícita'. Justo lo que quieren.)", "side": "right"},
			{"who": "detective", "text": "No. Así no. Si entro sucia, salen limpios. Esta vez lo hago blindado."}]},
		{"text": "Llamar a Clara y hacerlo legal", "then": [
			{"who": "detective", "text": "Necesito una orden exprés y a alguien que sepa moverla entre jueces de guardia. Necesito a Clara."},
			{"who": "narrador", "text": "Marcas el número que juraste no volver a marcar. Tres tonos. Su voz, igual que la recordabas."},
			{"who": "clara", "text": "¿Nora? Son las cuatro de la mañana. O te has muerto o me necesitas para algo turbio. ¿Cuál de las dos?"},
			{"who": "detective", "text": "La segunda. Tengo una clínica fantasma llena de pruebas y ni un papel para entrar. ¿Me consigues la orden?"},
			{"who": "clara", "text": "...Dame dos horas y un juez que me deba un favor. Y, Nora: cuando esto acabe, tú y yo tenemos una conversación pendiente que no es sobre órdenes judiciales."}]}]},
	{"who": "detective", "text": "Dos horas. Que dentro no muevan nada. Voy a por lo único que puede tumbar a esta gente: hacerlo todo por el libro."}], "revisit": "La clínica del ensayo es un fantasma legal. Con la orden de Clara puedo entrar sin que se caiga en el juicio."},
"fin8": {"bg": "sala_ensayos", "flag": "cap8_completo", "clue": {"title": "Ensayos con personas", "text": "Dentro: historiales de decenas de 'voluntarios' insomnes, muchos ya desaparecidos."}, "beats": [
	{"who": "narrador", "text": "Con la orden en la mano y Clara detrás vigilando cada paso, la puerta se abre. Por fuera, clínica. Por dentro, laboratorio: camillas con correas, monitores apagados, neveras llenas de viales ámbar con la serpiente impresa."},
	{"who": "detective", "text": "Correas en las camillas. Para dormir a nadie hacen falta correas."},
	{"who": "narrador", "text": "En una sala trasera, un archivador metálico. Decenas de carpetas. Cada una, un 'voluntario': fotos de fichaje, dosis, fechas, y una columna final que a algunos les pone 'baja' con una cruz."},
	{"who": "detective", "text": "Insomnes, solitarios, gente que nadie echaría de menos. Los eligieron por eso. Cobayas humanas con nombre, apellido y una cruz cuando dejaban de servir."},
	{"choices": [
		{"text": "Fotografiarlo todo antes de tocar nada", "then": [
			{"who": "detective", "text": "Cadena de custodia. Primero foto, luego mano. Que ningún abogado pueda decir que me lo inventé."},
			{"who": "clara", "text": "Así me gusta. Cada carpeta, cada vial, cada correa. Esto ya no lo entierra nadie."}]},
		{"text": "Buscar la carpeta de Diego primero", "then": [
			{"who": "narrador", "text": "Tus dedos encuentran su nombre antes de que lo decidas: 'Vega, Diego'. Dosis crecientes. Y en la última línea, una anotación reciente: 'candidato a fase 2'."},
			{"who": "detective", "text": "Fase 2. Iban a subirlo de fase. A mi hermano. Un mes más y su carpeta tendría una cruz.", "side": "right"},
			{"who": "clara", "text": "Nora. Respira. Está vivo y está fuera. Ahora usa esa rabia para lo que sirve: para que esto no se caiga."}]}]},
	{"who": "narrador", "text": "Cotejas la lista con los archivos abiertos de la comisaría. Un tercio de esos 'voluntarios' constan como desaparecidos sin resolver. Los mismos nombres. Los mismos meses."},
	{"who": "detective", "text": "No secuestraban para vender. Secuestraban para PROBAR. Las desapariciones no eran el negocio: eran el residuo. El sótano sucio de un ensayo clínico con fachada de caridad."}], "revisit": "La clínica probaba Somnia con desaparecidos. Es un ensayo criminal con fachada médica, y un tercio de los sujetos son desaparecidos de mis archivos."},
"cierre8": {"bg": "comisaria", "flag": "done_cierre8", "beats": [
	{"who": "narrador", "text": "Amanece sobre las cajas de pruebas apiladas en la sala de reuniones. Núñez pasa una por una las carpetas, sin decir nada, hasta que llega a la de la cruz."},
	{"who": "detective", "text": "Diego está fuera del ensayo, vigilado y durmiendo mal, que es lo mejor que le podía pasar. Pero es uno de cientos, Núñez. Esto no lo monta un médico loco en un garaje."},
	{"who": "nunez", "text": "No. Neveras industriales, viales en serie, una clínica pantalla, una fundación que lava el dinero... Ensayos ilegales a esta escala solo los mueve una empresa con laboratorios. Una farmacéutica."},
	{"who": "detective", "text": "La serpiente en la copa no es el símbolo de un asesino. Es un logo corporativo. Alguien firma nóminas debajo de esa serpiente."},
	{"who": "clara", "text": "Y si es una empresa, tiene sociedades, contratos, consejo. Un rastro de papel que se puede seguir hasta arriba. Ahí sí sé nadar yo. Cuenta conmigo, Nora. De lleno."},
	{"who": "detective", "text": "Entonces dejamos de perseguir sombras en el barrio y empezamos a perseguir una firma. Buscamos la empresa detrás de la serpiente."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 8 —  El hermano de Nora era una cobaya. Detrás de la clínica fantasma ya no hay un monstruo: hay una empresa. Y las empresas dejan huellas."}]},

# --- Cap. 9 · La clínica fantasma ---
"brief9": {"bg": "comisaria", "flag": "done_brief9", "beats": [
	{"who": "narrador", "text": "Sobre la pizarra, Núñez ha escrito una sola palabra dentro de un círculo: EMPRESA. Alrededor, las carpetas de la clínica. Nora la mira como quien mira un muro demasiado alto."},
	{"who": "nunez", "text": "Para tocar a una farmacéutica que cotiza en bolsa no basta con una placa y buena voluntad. Necesita blindaje legal, detective Vega. Del bueno. Del que no se arruga ante un bufete de treinta abogados."},
	{"who": "detective", "text": "Sé lo que va a decir, Núñez, y la respuesta es no."},
	{"who": "nunez", "text": "Usted conoce a la mejor abogada de esta ciudad. Da igual que además sea su ex. Los papeles no saben de corazones rotos."},
	{"who": "detective", "text": "Clara. Cómo no. Nada como pedir favores a quien te dejó precisamente por esto, por elegir el trabajo antes que la cena de aniversario. Dos veces."},
	{"who": "nunez", "text": "Trague orgullo. Por las mujeres del archivo no le va a doler tanto."},
	{"who": "detective", "text": "(Hace catorce meses que no la llamo. Y voy a hacerlo para pedirle que me salve el caso. Muy propio de mí.)", "side": "right"}], "revisit": "Toca tragarme el orgullo y recurrir a Clara, mi ex. La mejor abogada que conozco."},
"l9a": {"bg": "bufete_clara", "flag": "done_l9a", "clue": {"title": "Los ensayos ilegales", "text": "Clara confirma que un ensayo sin consentimiento válido es delito grave y rastreable por la empresa promotora."}, "beats": [
	{"who": "narrador", "text": "El bufete de Clara huele a café bueno y a papel caro. Estanterías de tomos jurídicos, diplomas enmarcados, todo en orden. Ella te espera de pie tras la mesa, tan guapa y tan afilada como el día que se fue."},
	{"who": "clara", "text": "La detective Vega, en mi despacho, a plena luz. Debe de arder el mundo. O por fin has aprendido a pedir las cosas antes de que se rompan."},
	{"who": "detective", "text": "Arde, Clara. Ensayos con personas sin consentimiento, gente desaparecida, mi propio hermano de cobaya. Necesito saber a quién agarro y cómo, sin que un abogado caro lo tire todo en el juicio."},
	{"who": "clara", "text": "¿Diego? ¿Tu Diego?"},
	{"who": "detective", "text": "Mi Diego. Está fuera y a salvo. Pero por poco."},
	{"who": "narrador", "text": "Algo se ablanda un segundo en la cara de Clara. Luego vuelve la abogada, que es su forma de protegerse."},
	{"who": "clara", "text": "Escúchame bien. Un ensayo clínico sin consentimiento válido es delito grave, no una multa. Y toda la clave está en una palabra: 'promotor'. Hasta el ensayo más ilegal tiene una empresa que lo paga y lo diseña. Encuentra al promotor y tienes la cabeza, no la mano."},
	{"who": "detective", "text": "¿Y cómo llego al promotor si todo lo firma gente que no existe?"},
	{"who": "clara", "text": "Siguiendo el dinero y las firmas hacia arriba, capa por capa. Yo sé nadar en ese barro. Te ayudo."},
	{"choices": [
		{"text": "«Gracias, Clara. De verdad.»", "then": [
			{"who": "detective", "text": "Gracias. De verdad. Sé lo que te estoy pidiendo y a quién."},
			{"who": "clara", "text": "No lo hago por ti, que quede claro. Lo hago por las que no pudieron firmar un 'no'. Pero el papeleo, esta vez, lo mando yo. Tú no mueves un dedo sin decírmelo."}]},
		{"text": "«¿Por qué me ayudas, después de todo?»", "then": [
			{"who": "detective", "text": "¿Por qué me ayudas, Clara? Después de cómo acabamos."},
			{"who": "clara", "text": "Porque sigo siendo abogada antes que tu ex, y esto es un crimen enorme. Y porque, aunque me cueste admitirlo, sé que tú no vas a parar. Prefiero que no pares bien acompañada que sola y a lo loco."}]}]},
	{"who": "detective", "text": "Trato hecho. El promotor. Esa es la palabra. Sigamos al que paga."}], "revisit": "Clara me guía: todo ensayo tiene un 'promotor', la empresa que paga. Esa es la cabeza."},
"rh9": {"bg": "local_voluntario", "flag": "done_rh9", "clues": [
	{"title": "El voluntario profesional", "text": "Un voluntario que sale en cuatro ensayos; solo alquila su brazo por dinero.", "false": true},
	{"title": "El notario", "text": "El notario que valida los consentimientos: no existe, es un colegiado inventado.", "false": true},
	{"title": "La recepcionista", "text": "La recepcionista de la clínica fantasma; una temporal que no duró ni un mes.", "false": true},
	{"title": "El casero", "text": "El dueño del local de la clínica; alquiló a una sociedad pantalla y no preguntó.", "false": true},
	{"title": "El repartidor", "text": "El mensajero que llevaba las cajas; ni sabe qué transportaba.", "false": true}], "beats": [
	{"who": "narrador", "text": "El promotor se esconde tras un local de inscripción de voluntarios, de esos con cartel de buena gente y papeles de nadie. Con Clara al lado, Nora interroga a los cinco nombres que rodean la clínica."},
	{"who": "clara", "text": "Antes de subir, quitemos la hojarasca. Cinco personas parecen saber algo. Veamos si alguna es el hueso o si son todas cáscara."},
	{"who": "narrador", "text": "El voluntario profesional sale en cuatro ensayos distintos: alquila su brazo por dinero, no fabrica nada. El notario que valida los consentimientos, sencillamente, no existe: un colegiado inventado para estampar firmas."},
	{"who": "detective", "text": "La recepcionista fue una temporal que no duró ni un mes y no vio nada. El casero alquiló a una sociedad pantalla y no preguntó. El repartidor llevaba las cajas sin saber qué transportaba."},
	{"who": "clara", "text": "Capas de cebolla, Nora. Cada una puesta a propósito para que llores un poco y te rindas antes de llegar al centro. Ninguno es el promotor."},
	{"who": "detective", "text": "Cinco tapaderas. Pero toda cáscara protege un fruto. Las siglas del pie de página, N.P., ese es el hueso. Sigamos el papel, no a la gente."}], "revisit": "Cinco tapaderas alrededor de la clínica. El hueso es el promotor: unas siglas, N.P."},
"l9b": {"bg": "centro", "flag": "done_l9b", "clue": {"title": "El consentimiento falso", "text": "Los formularios de consentimiento están firmados por un notario inexistente y un promotor con siglas: N.P."}, "beats": [
	{"who": "narrador", "text": "En una oficina alquilada del centro de negocios, Clara despliega sobre la mesa decenas de consentimientos y los cruza con el registro mercantil. Trabaja rápido, como quien desactiva una bomba."},
	{"who": "clara", "text": "Mira esto. Los mismos folios, la misma letra, el mismo sello. Todos los consentimientos los 'valida' el mismo notario. Y ese notario no consta en ningún colegio del país. Fraude en cadena, industrial, con plantilla."},
	{"who": "detective", "text": "Firmas de humo. ¿Y quién paga la fiesta? ¿Quién es el promotor?"},
	{"who": "clara", "text": "Aquí, al pie, en letra de mosquito: 'Promotor: N.P.' Dos iniciales, nada más. Pero es un cabo de verdad, no una cáscara. Alguien registró estos papeles con esas siglas."},
	{"who": "detective", "text": "N.P. La clínica clausurada aún tiene cajas dentro. Si el promotor imprimió su nombre en algún sitio, fue en la mercancía. Vamos allí con esto."}], "revisit": "El promotor de los ensayos son unas siglas: N.P. Y los consentimientos son fraude puro, con notario inventado."},
"fin9": {"bg": "clinica_clausurada", "flag": "cap9_completo", "clue": {"title": "N.P. = Nyxos Pharma", "text": "En la clínica clausurada, cajas con el nombre completo del promotor: Nyxos Pharma."}, "beats": [
	{"who": "narrador", "text": "La clínica clausurada es un esqueleto de baldosas y polvo. Vaciaron a toda prisa, pero la prisa deja restos: en un cuarto trasero, media docena de cajas de material precintadas que no dio tiempo a llevarse."},
	{"who": "detective", "text": "N.P. en los papeles. A ver si aquí, en la caja, se atrevieron a escribirlo entero."},
	{"who": "narrador", "text": "Rasgas el precinto. En el cartón, impreso en serie, sin abreviar: el logotipo de la serpiente enroscada en la copa. Y debajo, un nombre completo. NYXOS PHARMA."},
	{"who": "detective", "text": "Nyxos Pharma. Por fin la serpiente tiene apellido. Ya no persigo a un encapuchado, ni a un mecenas, ni a un médico asustado: persigo a una empresa entera, con nombre, con logo y con nóminas."},
	{"choices": [
		{"text": "Sentir el peso de lo que empieza", "then": [
			{"who": "detective", "text": "(Llevo meses tirando de un hilo en la oscuridad y resulta que el hilo salía de un rascacielos con el logo iluminado. Qué pequeña me siento de repente.)", "side": "right"},
			{"who": "clara", "text": "Ese silencio tuyo lo conozco. Es el de antes de una guerra. Y esta la vas a empezar contra Nyxos."}]},
		{"text": "Ir a por ellos sin dudar", "then": [
			{"who": "detective", "text": "Grande o no, tiene un nombre. Y un nombre se lleva a un juez. Voy a por ellos."},
			{"who": "clara", "text": "Nora, escúchame. Nyxos cotiza en bolsa. Tiene más abogados que el Estado y amigos en sitios que ni imaginas. Esto no es un caso. Es una guerra."}]}]},
	{"who": "detective", "text": "Pues que sea guerra. Pero limpia, blindada y con papeles. Contigo delante y yo detrás rompiendo puertas solo cuando tú me digas."}], "revisit": "La serpiente tiene nombre: Nyxos Pharma. Una farmacéutica que cotiza en bolsa. Empieza la guerra."},
"cierre9": {"bg": "comisaria", "flag": "done_cierre9", "beats": [
	{"who": "narrador", "text": "En la comisaría, el nombre 'Nyxos' cae sobre la mesa como una piedra en un estanque. Núñez deja el café a medias."},
	{"who": "nunez", "text": "¿Nyxos? ¿La de los anuncios en los autobuses, la de las becas para chavales, la que patrocina el ala nueva del hospital? Detective Vega, en el consejo de esa empresa se sienta medio poder de esta ciudad."},
	{"who": "detective", "text": "Y aun así. Fabrican Somnia, promueven ensayos ilegales y se surten de las desaparecidas de nuestros propios archivos. El tamaño no cambia lo que son."},
	{"who": "clara", "text": "Pero cambia cómo hay que cazarlos. A una empresa no la esposas: la desmontas. Sociedad por sociedad, contrato por contrato, hasta llegar a quien firma de verdad. El siguiente paso son sus laboratorios."},
	{"who": "detective", "text": "Entonces a por los laboratorios. Quiero ver dónde fabrican la serpiente."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 9 —  La sombra tiene por fin nombre en un logo: Nyxos Pharma. Y es gigante. Nora acaba de declararle la guerra a media ciudad."}]},

# --- Cap. 10 · El laboratorio ---
"brief10": {"bg": "comisaria", "flag": "done_brief10", "beats": [
	{"who": "narrador", "text": "Sobre el mapa de la ciudad, Núñez clava una chincheta en el polígono nuevo, la zona de cristal y hormigón donde el dinero se pone corbata. El laboratorio central de Nyxos brilla ahí como un diente de oro."},
	{"who": "nunez", "text": "Ahí lo tiene. Laboratorio central de Nyxos. Legal hasta la última baldosa, con visitas guiadas y folletos. Pero un edificio que enseña tanto suele esconder un piso que no enseña."},
	{"who": "detective", "text": "Los ensayos no se hacen solos. En algún sitio fabrican el Somnia y en algún sitio guardan a los que lo prueban. Voy a colarme con una inspección de rutina y a mirar debajo de las batas blancas."},
	{"who": "clara", "text": "Inspección administrativa, Nora, no allanamiento. Tú miras lo que te enseñan y lo que quede a la vista. Nada de forzar. Si ven que buscas el sótano, te sacan y avisan a los de arriba."},
	{"who": "detective", "text": "Miro lo que quede a la vista. Y confío en que dejen a la vista más de lo que creen."}], "revisit": "El laboratorio central de Nyxos, en la zona de negocios. Legal por fuera; el sótano es lo que importa."},
"l10a": {"bg": "laboratorio", "flag": "done_l10a", "clue": {"title": "La marca Nyxos", "text": "El Somnia se fabrica en serie en el laboratorio; lotes numerados como 'producto'."}, "beats": [
	{"who": "narrador", "text": "El laboratorio de Nyxos es un templo de acero y luz blanca sin sombras. Batas, guantes, suelos que rechinan de limpios. Con la excusa de la inspección, una relaciones públicas de sonrisa perfecta te pasea por las plantas 'de visita'."},
	{"who": "detective", "text": "Producción en serie. Cintas, dosificadores, control de calidad, cámaras frigoríficas. Fabrican pastillas con la misma frialdad con que otros embotellan refrescos."},
	{"who": "narrador", "text": "En una cinta, cajas idénticas desfilan bajo un escáner. En cada una, la serpiente en la copa y un código: SOM-, seguido de un número de lote larguísimo."},
	{"who": "detective", "text": "Somnia. Etiquetado, numerado, trazado. Un fármaco que oficialmente no existe, fabricado a escala industrial. Nadie monta esta maquinaria para regalar pastillas a insomnes por bondad."},
	{"who": "detective", "text": "(Todo impecable, todo con papeles. El horror aquí no grita: susurra en letra de etiqueta. Y para leer el susurro tengo que bajar a donde no me llevan.)", "side": "right"}], "revisit": "Nyxos fabrica Somnia en serie, con lotes numerados como producto. Legal por fuera, injustificable a esa escala."},
"rh10": {"bg": "nave_industrial", "flag": "done_rh10", "clues": [
	{"title": "El jefe de planta", "text": "Un capataz gritón; solo aprieta tuercas y obedece la orden de producción.", "false": true},
	{"title": "El de mantenimiento", "text": "Un técnico con acceso a todo; solo arregla máquinas y no lee etiquetas.", "false": true},
	{"title": "La becaria de calidad", "text": "Firma los controles sin mirar; tiene miedo a que la echen, no culpa.", "false": true},
	{"title": "El transportista", "text": "Lleva los lotes a otras sedes; cree que son 'muestras médicas'.", "false": true},
	{"title": "El sindicalista", "text": "Denuncia a la empresa a gritos; por horas extra, no por los ensayos.", "false": true}], "beats": [
	{"who": "narrador", "text": "En la nave de producción, cinco trabajadores se ponen nerviosos al ver la placa. Nora los aparta uno a uno, entre el ruido de las máquinas."},
	{"who": "detective", "text": "Cuando la gente tiene algo que esconder, se le nota. Vamos a ver qué esconden estos cinco."},
	{"who": "narrador", "text": "El jefe de planta grita órdenes y aprieta tuercas: cumple la orden de producción y no pregunta qué produce. El de mantenimiento tiene llaves de todo y no lee una sola etiqueta. La becaria de calidad firma controles sin mirar, muerta de miedo a que la echen."},
	{"who": "detective", "text": "El transportista cree que lleva 'muestras médicas' a otras sedes. Y el sindicalista, que berrea contra la empresa, lo hace por las horas extra, no por lo que se fabrica."},
	{"who": "detective", "text": "Cinco personas, cinco ejecutores. Todos mueven la máquina; ninguno la diseñó. Piezas que no saben qué construyen. El mando no está en la planta."},
	{"who": "detective", "text": "El mando está arriba, en los despachos con vistas. Pero para subir necesito una puerta que alguien de dentro me deje entornada. Y creo que sé quién."}], "revisit": "Cinco empleados, cinco ejecutores que no deciden nada. El mando está arriba, no en la planta."},
"l10b": {"bg": "planta", "flag": "done_l10b", "clue": {"title": "El lote humano", "text": "Marco, seguridad de Nyxos, deja ver sin querer un registro: los 'lotes de prueba' llevan números de persona."}, "beats": [
	{"who": "narrador", "text": "En el control de seguridad, tras una pared de monitores, hay una cara que no esperabas: Marco. De tu misma promoción en la academia. Colgó la placa hace años por un sueldo que la placa no daba."},
	{"who": "marco", "text": "¿Nora Vega? No me jodas. La última persona que esperaba ver con un carnet de visitante colgado del cuello. Sabes que no debería dejarte pasar de este mostrador, ¿verdad?"},
	{"who": "detective", "text": "Y tú sabes qué se prueba en la casa que vigilas, ¿verdad, Marco? Ahí, en tu pantalla. Los 'lotes de prueba'. Esos números no empiezan por SOM como las cajas. Empiezan por PX. Paciente. Persona."},
	{"who": "narrador", "text": "Marco tapa la pantalla con el cuerpo, demasiado tarde. En su cara se pelean el uniforme y algo más viejo: el chaval que juró servir y proteger contigo."},
	{"who": "marco", "text": "Yo solo vigilo puertas, Nora. No miro lo que hay detrás de ellas. Es la única forma de cobrar a fin de mes y seguir durmiendo. No me pidas que mire, porque entonces ya no puedo cerrar los ojos."},
	{"choices": [
		{"text": "Apretarle la conciencia", "then": [
			{"who": "detective", "text": "¿Dormir? Marco, hay gente ahí abajo con un número en la muñeca que no va a volver a dormir en su vida. Tú y yo hicimos el mismo juramento el mismo día."},
			{"who": "marco", "text": "No es justo que uses eso."},
			{"who": "detective", "text": "Nada de esto es justo. Por eso estoy aquí."}]},
		{"text": "Darle tiempo, no forzarlo", "then": [
			{"who": "detective", "text": "No te pido que hagas nada hoy. Solo que sepas que, cuando ya no puedas cerrar los ojos, sabes dónde encontrarme."},
			{"who": "marco", "text": "...Vete, Nora. Por la salida de carga. Y no vuelvas por delante."}]}]},
	{"who": "detective", "text": "(Marco sabe. Y le pesa como una losa. Ese peso, algún día, lo pondrá de mi lado. Hoy solo me ha dejado una puerta entornada.)", "side": "right"}], "revisit": "Marco, en seguridad de Nyxos, sabe más de lo que dice. Los 'lotes de prueba' llevan números de persona."},
"fin10": {"bg": "planta", "flag": "cap10_completo", "clue": {"title": "Cobayas con número", "text": "En la planta baja, celdas-laboratorio: personas reducidas a números de lote de Nyxos."}, "beats": [
	{"who": "narrador", "text": "La puerta que Marco dejó entornada da a un montacargas de carga sin botones a la vista. Bajas más de lo que cabría esperar. Cuando se abre, el aire cambia: huele a desinfectante y a miedo. Una planta que no aparece en ningún plano."},
	{"who": "narrador", "text": "Filas de habitáculos de cristal, como peceras. Dentro, personas. Batas de papel, pulseras con un número, ojos que hace tiempo dejaron de esperar a nadie."},
	{"who": "detective", "text": "Personas. Vivas. Etiquetadas como mercancía de laboratorio, guardadas en estantes como reactivos.", "side": "right"},
	{"who": "detective", "text": "Nyxos no compra cobayas en el mercado negro. Es peor. Fabrica humanos-cobaya: los recoge de la calle, los borra del mundo y los archiva con un número de lote hasta que fallan."},
	{"choices": [
		{"text": "Grabarlo todo, rostro a rostro", "then": [
			{"who": "narrador", "text": "Sacas el teléfono y grabas despacio: los números, los rostros, el logo en cada puerta. Alguna mano se pega al cristal al verte, sin fuerza para golpear."},
			{"who": "detective", "text": "Voy a sacaros de aquí. A todos. Lo juro sobre esta grabación."}]},
		{"text": "Buscar una lista de nombres reales", "then": [
			{"who": "narrador", "text": "En un puesto de enfermería encuentras una tablet abierta: una tabla que cruza cada número PX con un nombre real. Los reconoces. Son los desaparecidos de tus propios archivos."},
			{"who": "detective", "text": "Tienen nombres. Todos tienen nombres. Y yo los tengo ahora en la mano."}]}]},
	{"who": "narrador", "text": "Una alarma silenciosa parpadea. En un monitor del pasillo, Marco ve tu punto rojo moverse por donde no debe. Cierra los ojos un segundo, y en vez de dar la voz, congela la cámara de la salida de carga tres minutos. Los justos."},
	{"who": "detective", "text": "Tengo vídeo de una planta de experimentación humana con el logo de Nyxos en cada puerta. Esto ya no lo entierra ningún abogado ni ningún cheque."}], "revisit": "Bajo el laboratorio de Nyxos hay personas usadas como lotes de prueba, con nombre y número. Lo grabé."},
"cierre10": {"bg": "comisaria", "flag": "done_cierre10", "beats": [
	{"who": "narrador", "text": "En la sala a oscuras, el vídeo se reproduce en bucle sobre la pared. Nadie dice nada durante un minuto largo. Núñez es el que rompe el silencio, con la voz ronca."},
	{"who": "detective", "text": "Nyxos tiene un piso que no está en ningún plano, lleno de personas con número de lote. Y una seguridad tan fina que solo un fallo humano me dejó bajar. Esto está protegido, Núñez. Blindado desde muy arriba."},
	{"who": "nunez", "text": "Protección política, detective Vega. Para operar así durante años hace falta que mucha gente con despacho mire a otro lado a cambio de algo. Permisos que se firman, inspecciones que no se hacen, denuncias que se pierden."},
	{"who": "clara", "text": "Y eso, por asqueroso que sea, deja rastro: presupuestos, donaciones, favores. El siguiente paso no es una nave. Es un barrio de despachos caros. Hay que averiguar quién les cubre las espaldas desde el poder."},
	{"who": "detective", "text": "Entonces subo. De la planta de las peceras a los despachos con vistas. Quiero los nombres de los que firman para no mirar."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 10 —  El laboratorio confirma el horror con rostro y número. Ahora Nora deja el subsuelo y sube a buscar a quienes lo protegen desde los despachos."}]},

# --- Cap. 11 · El barrio alto ---
"brief11": {"bg": "comisaria", "flag": "done_brief11", "beats": [
	{"who": "narrador", "text": "La comisaría amanece con olor a café quemado y a papel viejo. Sobre la pizarra, Núñez ha pegado un plano de la ciudad y ha dibujado flechas de tinta roja que salen del laboratorio de Nyxos y suben, todas, hacia el mismo rincón: la loma de las villas, el barrio alto, donde la lluvia parece caer más fina."},
	{"who": "nunez", "text": "Nyxos riega de dinero a media ciudad: becas, obras, campañas. Empiece por el barrio alto, donde viven los que firman sus permisos. Ahí no encontrará celdas ni viales, detective Vega. Encontrará algo peor: gente respetable que sonríe mientras firma."},
	{"who": "detective", "text": "El dinero limpio siempre huele a algo. Al barrio alto. Llevo toda la vida entrando en sótanos; ahora me toca subir a los salones, donde el crimen se sirve con canapés y no deja una sola mancha en la moqueta."},
	{"who": "nunez", "text": "Y por eso mismo tenga cuidado. En el barro de abajo, si mete la mano, se ensucia usted. En el de arriba, si mete la mano, la ensucian a usted. Cambian las pruebas por rumores y a los testigos por columnas de opinión."},
	{"choices": [
		{"text": "«Voy de frente. Que sepan que los miro.»", "then": [
			{"who": "detective", "text": "No pienso disimular, Núñez. Que me vean subir la cuesta con la placa por delante. Que se pongan nerviosos. La gente tranquila no comete errores; la gente asustada, sí."},
			{"who": "nunez", "text": "Es una forma. Peligrosa, pero suya de cabo a rabo. Solo le pido que apunte cada nombre y cada fecha. Contra esta gente, un cuaderno bien llevado vale más que una pistola."}]},
		{"text": "«Voy despacio. Primero miro quién cobra.»", "then": [
			{"who": "detective", "text": "Esta vez no rompo la puerta. La rodeo. Quiero saber quién cena con quién y quién paga la cuenta antes de llamar a ningún timbre."},
			{"who": "nunez", "text": "Así me gusta. Paciencia de pescador. Y si necesita a alguien que conozca ese barrio desde antes de que fuera caro, ya sabe a quién llamar. El viejo Rubén todavía respira."}]}]},
	{"who": "detective", "text": "(Núñez tiene razón. Nunca resolví nada sola, y menos voy a resolverlo sola allá arriba, entre gente que aprendió a mentir en colegios que yo no pude pagar. Necesito a alguien que hable su idioma.)", "side": "right"}], "revisit": "Nyxos compra permisos. La respuesta vive en el barrio alto."},
"l11a": {"bg": "barrio_alto", "flag": "done_l11a", "clue": {"title": "Los sobornos", "text": "Nyxos financia a través de una fundación las campañas de varios cargos que aprueban sus permisos."}, "beats": [
	{"who": "narrador", "text": "El barrio alto son villas con verja, setos recortados con regla y coches que valen pisos. Aquí la lluvia no ensucia: resbala por los cristales tintados y se va por desagües que nadie ve. Huele a césped mojado y a dinero que nunca ha tocado una cartera. Aquí Nyxos no secuestra a nadie: aquí invita a cenar."},
	{"who": "detective", "text": "La 'Fundación Nyxos' financia campañas, palcos en el estadio, viajes de estudios, un ala de la biblioteca. Todo con placa de bronce y foto en el periódico. Y casualmente los que cobran son los mismos que firman sus licencias de ensayo."},
	{"who": "narrador", "text": "Frente a una de las villas, un jardinero riega rosas que ya reluce la lluvia. En la verja, discreta, una placa: 'Rehabilitado con el mecenazgo de la Fundación Nyxos'. Cuentas la misma placa en tres portales de la misma calle."},
	{"who": "detective", "text": "Soborno con lazo de regalo. Nadie mete un fajo en un sobre; montan una fundación, la registran, pagan impuestos y llaman filantropía a lo que abajo llamaríamos comprar a un funcionario. Legal por fuera, podrido por dentro."},
	{"who": "detective", "text": "(He visto sobornos de barrio: un sobre grasiento bajo el mostrador de un bar. Esto es lo mismo, pero con abogados, notarios y una foto sonriente en la sección de sociedad. El asco es idéntico; el traje, mejor.)", "side": "right"},
	{"who": "detective", "text": "Necesito a alguien que conozca este barro desde hace décadas. Alguien que sepa qué mano firmó la planta de Nyxos y a cambio de qué. Y solo se me ocurre un nombre."}], "revisit": "Nyxos soborna con una fundación: paga campañas de quien le firma los permisos."},
"rh11": {"bg": "despacho_concejal", "flag": "done_rh11", "clues": [
	{"title": "El concejal rival", "text": "Ataca a Nyxos en prensa; solo busca titulares y votos, sin una prueba.", "false": true},
	{"title": "El constructor", "text": "Levantó la sede de Nyxos; cobró y calló, pero no sabe qué pasa dentro.", "false": true},
	{"title": "La asociación vecinal", "text": "Protesta por el ruido de las obras; nada que ver con los ensayos.", "false": true},
	{"title": "El del catastro", "text": "Aceleró un registro por un sobre; corrupción de calderilla, no de sangre.", "false": true},
	{"title": "El periodista comprado", "text": "Escribe elogios a Nyxos por dinero; vanidoso, no un cerebro.", "false": true}], "beats": [
	{"who": "narrador", "text": "El barrio alto está lleno de sospechosos de guante blanco. Ninguno tiene sangre en las manos; todos tienen tinta. Nora los va cruzando con Rubén, que conoce a cada uno por su nombre de pila, su apodo y su precio exacto."},
	{"who": "detective", "text": "Cinco nombres que rodean a Nyxos y huelen mal. Vamos a ver cuál aguanta un empujón y cuál es solo humo perfumado."},
	{"who": "ruben", "text": "El concejal rival hace ruido en los periódicos, pero es puro teatro: ataca a Nyxos para robarle votos, y no tiene ni un papel. El constructor levantó la sede, cobró su millonada y calló; ni sabe ni quiere saber qué pasa dentro de lo que edifica."},
	{"who": "ruben", "text": "La asociación vecinal protesta por el polvo y las grúas a las siete de la mañana, no por lo que se cuece en el sótano. El del catastro aceleró un registro por un sobre de nada: corrupción de calderilla. Y el plumilla ese escribe alabanzas a Nyxos por dinero, pero es un vanidoso, no un cerebro."},
	{"who": "detective", "text": "Cinco corrupciones pequeñas, puestas ahí como setos para que no veas la casa que hay detrás. Ninguno firmó la planta. Ninguno decide nada."},
	{"who": "detective", "text": "El pez gordo es el que firmó la planta en tiempo récord: el concejal Vela, el de Urbanismo. El resto son ramas; él es el tronco. A por el tronco."}], "revisit": "Cinco corruptelas de barrio alto. La grande es el concejal Vela, que firmó la planta."},
"l11b": {"bg": "cafe_ruben", "flag": "done_l11b", "clue": {"title": "El concejal comprado", "text": "Rubén, tu viejo mentor, señala al concejal de Urbanismo que aprobó en tiempo récord la planta de Nyxos."}, "beats": [
	{"who": "narrador", "text": "El café de Rubén es de los que ya casi no quedan: barra de zinc, un futbolín viejo, la cafetera echando vapor como una locomotora cansada. Huele a achicoria y a tabaco de otra época. El inspector Rubén, el hombre que te enseñó el oficio, está jubilado, pero conserva el olfato intacto y media agenda de la ciudad guardada en la cabeza."},
	{"who": "ruben", "text": "Nora, chiquilla. Cuánto pelo blanco te veo ya, igual que a mí. Siéntate, que las malas noticias se dan sentado. Sé lo que buscas antes de que abras la boca: se te nota en los ojos, como se me notaba a mí."},
	{"who": "detective", "text": "Necesito el nombre, Rubén. El que le abrió la puerta a Nyxos. El que convirtió dos años de expediente en un mes de trámite."},
	{"who": "ruben", "text": "El que le firmó a Nyxos la planta en cuatro semanas, cuando lo normal son dos años de informes, es Vela, el de Urbanismo. Firmó como quien firma la lista de la compra. Y a la semana siguiente, la Fundación Nyxos le pagaba la campaña. Casualidades que se cobran en euros."},
	{"who": "detective", "text": "¿Y por qué no salió nunca? ¿Cómo aguanta un tipo así tantos años a la vista de todos?"},
	{"who": "narrador", "text": "Rubén remueve el café despacio, sin mirarte, con la cucharilla tintineando contra la loza. Cuando levanta la vista, hay en ella algo que no le habías visto: no miedo, cansancio de haber tenido miedo demasiado tiempo."},
	{"who": "ruben", "text": "Porque cada vez que alguien lo intentó, lo trasladaron a un archivo, lo mandaron a un pueblo o lo jubilaron. A mí me jubilaron, Nora. No fue por la edad. Fue por preguntar por Vela una vez de más. Un día me llegó la carta de agradecimiento por mis servicios y se acabó."},
	{"choices": [
		{"text": "«No debiste callarte. Yo no voy a callarme.»", "then": [
			{"who": "detective", "text": "Debiste seguir, Rubén. Aunque doliera. Yo no pienso guardarme este nombre en un cajón como te lo guardaste tú."},
			{"who": "ruben", "text": "Lo sé. Y por eso te lo doy a ti y no me lo llevo a la tumba. Yo tenía una hipoteca y una hija en la universidad, chiquilla. Tú tienes otra clase de deudas, de las que no se pagan callando. Adelante. Pero ándate con más ojo que yo."}]},
		{"text": "«No te culpo. Tenías una familia que proteger.»", "then": [
			{"who": "detective", "text": "No te reprocho nada, Rubén. Tenías una hija, una casa, una vida. Cualquiera habría hecho lo mismo. Casi cualquiera."},
			{"who": "ruben", "text": "Eres buena chica, siempre lo fuiste. Pero no me consueles: los dos sabemos que callar tiene un precio, y lo llevo pagando veinte años. Págalo tú de otra manera. Ve a por Vela. Y no vayas sola a ningún sitio, ¿me oyes?"}]}]},
	{"who": "ruben", "text": "Una cosa más, y grábatela. Vela es un cobarde. Y los cobardes, cuando los acorralas, no pelean: señalan a otro para salvar el pellejo. Cuando lo aprietes, no te contará lo que hizo él. Te dirá quién está por encima."}], "revisit": "Rubén me lo dio: el concejal Vela aprobó la planta de Nyxos en tiempo récord. Comprado."},
"fin11": {"bg": "centro", "flag": "cap11_completo", "clue": {"title": "La red de favores", "text": "Vela confiesa a medias: Nyxos 'agradece' con dinero y con silencio a quien le facilita las cosas."}, "beats": [
	{"who": "narrador", "text": "El despacho del concejal Vela huele a ambientador caro y a sudor mal disimulado. Ventanales del centro, diplomas enmarcados, una foto suya estrechando la mano de gente importante. Acorralas a Vela contra su propia mesa, con los papeles de la Fundación Nyxos desplegados encima como una mano de cartas marcadas."},
	{"who": "sospechoso", "text": "Detective, esto es un atropello. Yo... agilicé un expediente, nada más. Todos lo hacen. Nyxos es un motor económico para esta ciudad, da empleo, paga impuestos, patrocina. Darles alas es bueno para todos. ¿Qué crimen hay en firmar rápido lo que es bueno?"},
	{"who": "detective", "text": "Firmó en cuatro semanas lo que a cualquier otro le cuesta dos años. Y a la semana la Fundación le pagaba la campaña. ¿También eso lo hacen todos, señor Vela?"},
	{"who": "sospechoso", "text": "La Fundación apoya muchas causas. Mi campaña era una causa. No hay nada escrito que diga 'firme esto y le pago'. Nunca lo hay. Así no funciona esto, detective. Aquí nadie pide nada; simplemente, se agradece."},
	{"who": "detective", "text": "Sus 'alas' tienen un sótano lleno de gente numerada como mercancía. Personas que respiran detrás de un cristal con una pulsera y un número de lote. ¿Sabía eso cuando cobró la campaña?"},
	{"who": "narrador", "text": "Vela se afloja el nudo de la corbata. Por un segundo, bajo el bronceado de despacho, asoma el hombre pequeño que hay debajo del cargo. Mira la puerta, mira el teléfono, mira sus propias manos."},
	{"who": "sospechoso", "text": "Yo no sé nada de sótanos. Se lo juro por mis hijos. Yo firmo papeles, detective, no bajo a ninguna parte. Si hay algo abajo, yo no lo puse ahí. Yo solo... facilité. Como me pidieron. Como se lo pidieron a otros antes que a mí."},
	{"who": "detective", "text": "¿Quién se lo pidió, Vela? Un nombre. Uno solo y salgo de aquí."},
	{"who": "sospechoso", "text": "No hay un nombre. ¿No lo entiende? Nunca hay uno. Le llega un correo, una llamada, una cena. Le dicen que sería 'conveniente'. Y usted firma, porque el que no firma desaparece del organigrama. Yo soy un mandado, como todos. Si quiere sótanos, pregunte arriba. Pregunte en el consejo de Nyxos."},
	{"choices": [
		{"text": "Apretarle con lo que ha visto abajo", "then": [
			{"who": "detective", "text": "Le voy a decir lo que hay 'arriba', Vela: hay una mujer que se sabe de memoria el número que le pintaron en la muñeca. Eso hay arriba de su firma. Duerma con eso esta noche, si puede."},
			{"who": "sospechoso", "text": "No es justo que me cargue eso a mí. Yo no elegí a nadie. Yo solo... firmé un papel entre mil papeles."},
			{"who": "detective", "text": "Ese papel entre mil era el que abría la puerta. Sin su firma no hay planta, sin planta no hay sótano. Usted es la bisagra, Vela. Y las bisagras también se llevan por delante."}]},
		{"text": "Dejarle una salida a cambio del consejo", "then": [
			{"who": "detective", "text": "Escúcheme bien. Si me da el hilo hacia el consejo, hay una manera de que usted salga de esto como testigo y no como acusado. Es la única puerta que le queda abierta, y se cierra rápido."},
			{"who": "sospechoso", "text": "¿Testigo? ¿Contra Nyxos? Usted no sabe lo que me está pidiendo. A los que hablan les pasan cosas, detective. Accidentes. Jubilaciones. O peor."},
			{"who": "detective", "text": "Lo sé mejor que usted. Pero también sé que el silencio no lo ha salvado a nadie de esta lista. Piénselo. Sabe dónde encontrarme antes de que lo encuentren a usted."}]}]},
	{"who": "detective", "text": "'Pregunte arriba.' Es lo que dicen todos justo antes de que el hilo suba un piso más. La red institucional existe, tiene nombres, cobra por firmar y calla por dinero. Y protege a Nyxos entera desde una altura donde mi placa ya casi no se ve."}], "revisit": "Vela admitió los favores a Nyxos. Y volvió a apuntar hacia arriba: el consejo."},
"cierre11": {"bg": "comisaria", "flag": "done_cierre11", "beats": [
	{"who": "narrador", "text": "De vuelta en la comisaría, la lluvia ha arreciado y golpea los cristales como si quisiera entrar. Nora deja los papeles de la Fundación sobre la mesa de Núñez, que los repasa uno a uno, en silencio, con las gafas en la punta de la nariz."},
	{"who": "detective", "text": "Nyxos compra permisos, campañas y silencios. Está enredada con media institución, Núñez. Vela firmó, cobró y ahora señala hacia arriba, como Marco, como todos. Cada uno es una pieza que jura que la culpa es de la de al lado."},
	{"who": "nunez", "text": "Así se blinda el poder, detective Vega: repartiendo la culpa en trozos tan pequeños que ninguno cabe en una condena. Contra eso no vale un concejal asustado ni un montón de facturas de fundación. Un juez le dirá que todo es legal."},
	{"who": "detective", "text": "Entonces dígame qué vale. Porque estoy subiendo escaleras y en cada rellano hay una puerta cerrada con un abogado detrás."},
	{"who": "nunez", "text": "Entonces necesitamos algo que ni el dinero calle: un testigo de dentro. Alguien que se siente en esa mesa, que conozca los nombres de verdad, y que esté dispuesto a hablar. Y justo esta mañana, detective Vega, alguien de Nyxos ha llamado pidiendo hablar. Antes de que se arrepienta, vaya."},
	{"who": "detective", "text": "Alguien de dentro. Por fin una grieta en el cristal. Voy antes de que el miedo se la vuelva a cerrar."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 11 —  Nyxos tiene comprada a la ciudad, firma a firma, cena a cena. Pero dentro del muro, por primera vez, alguien ha decidido hablar."}]},

# --- Cap. 12 · La filtración ---
"brief12": {"bg": "comisaria", "flag": "done_brief12", "beats": [
	{"who": "narrador", "text": "La comisaría a esa hora es un acuario de luz muerta. Núñez cuelga el teléfono despacio, como si pesara, y se queda mirando el auricular antes de girarse hacia Nora."},
	{"who": "nunez", "text": "El que quiere hablar es de dentro de Nyxos. No un becario ni un vigilante: un mando con despacho y con miedo. Ha llamado a la periodista, a Vera Lang, no a nosotros. Se fía más de una libreta que de una placa, y lo entiendo."},
	{"who": "detective", "text": "Un directivo arrepentido. Después de meses arañando cáscara, alguien de dentro abre la puerta él solo. Suena demasiado bien, Núñez."},
	{"who": "nunez", "text": "Por eso vaya rápido y vaya con cuidado. Esta gente no da segundas oportunidades: al que se arrepiente lo jubilan de forma definitiva. Si el hombre ha decidido hablar, ya está muerto de miedo, y con razón."},
	{"choices": [
		{"text": "«Voy a protegerlo antes que al caso.»", "then": [
			{"who": "detective", "text": "Lo primero es sacarlo entero, Núñez. El protocolo puede esperar; un testigo vivo, no. Si tengo que elegir entre el papel y el hombre, elijo al hombre."},
			{"who": "nunez", "text": "Esa es la detective Vega que quiero de vuelta. Pero llévese el móvil cargado y no se meta sola en ningún sótano. Me llama antes, no después."}]},
		{"text": "«Necesito ese protocolo como sea.»", "then": [
			{"who": "detective", "text": "Con el protocolo entero les corto la cabeza a todos de una vez. No pienso dejar que se me escurra por exceso de prudencia."},
			{"who": "nunez", "text": "Le entiendo el hambre. Pero un documento no vale un cadáver, detective Vega. Consiga las dos cosas: el papel y el hombre respirando. Las dos."}]}]},
	{"who": "detective", "text": "(Un mando intermedio. De los que firman sin mirar hasta que una noche, por fin, miran. Ojalá llegue yo antes que quien lo esté buscando.)", "side": "right"}], "revisit": "Hay un informante dentro de Nyxos. Vera Lang lo tiene. A la redacción."},
"l12a": {"bg": "redaccion", "flag": "done_l12a", "clue": {"title": "El informante", "text": "Un directivo intermedio de Nyxos, arrepentido, promete entregar el 'protocolo Somnia' completo."}, "beats": [
	{"who": "narrador", "text": "La redacción a medianoche es un campo de pantallas apagadas y ceniceros a escondidas. Vera Lang te espera en un cubículo del fondo, dos cafés fríos y las manos que no paran quietas. En su móvil, una grabación en bucle: una voz de hombre, distorsionada, que respira como si le costara."},
	{"who": "periodista", "text": "Escúchalo, Nora. No es un chalado ni un resentido. Es alguien acostumbrado a mandar que de repente tiene pánico. Dice que es un mando intermedio, que ha visto lo que hay debajo de los informes bonitos y que no puede dormir."},
	{"who": "detective", "text": "¿Y qué ofrece exactamente? Palabras las tiene cualquiera."},
	{"who": "periodista", "text": "El 'protocolo Somnia' entero. Qué hacen, a quién se lo hacen, qué dosis, qué pasa con los que ya no sirven. Y lo que más me quema: quién lo ordena. Nombres, no siglas. La cabeza, Nora, no la mano."},
	{"who": "detective", "text": "Eso es el caso servido en bandeja de plata. Demasiada bandeja, quizá. ¿Cuándo y dónde entrega?"},
	{"who": "periodista", "text": "Mañana, en el aparcamiento de las oficinas. Eligió él el sitio: subterráneo, sin cámaras que él no controle, dice. Tiene miedo hasta de su sombra. Me repitió una frase que no me quito de encima: que si lo pillan, no habrá cadáver que encontrar. Como las otras."},
	{"who": "detective", "text": "(No habrá cadáver. Lo dice un hombre que sabe cómo desaparece la gente en su empresa, porque habrá firmado alguna de esas desapariciones. Y aun así ha decidido hablar. O eso, o está más asustado de vivir consigo mismo que de morir.)", "side": "right"},
	{"who": "detective", "text": "Mañana estaré en ese aparcamiento antes que él. Y salimos los dos, Vera. Con el protocolo o sin él, pero los dos."}], "revisit": "Un directivo de Nyxos quiere entregar el 'protocolo Somnia'. Tiene pánico."},
"rh12": {"bg": "archivo_becario", "flag": "done_rh12", "clues": [
	{"title": "El becario dolido", "text": "Presume de filtrar a Nyxos; solo se llevó su finiquito y su rencor.", "false": true},
	{"title": "La limpiadora", "text": "Ve papeles cada noche; no sabe leer los informes, solo vaciar papeleras.", "false": true},
	{"title": "El hacker de foro", "text": "Dice tener 'los servidores de Nyxos'; son capturas falsas para presumir.", "false": true},
	{"title": "El competidor", "text": "Una farmacéutica rival filtra bulos para hundir a Nyxos en bolsa.", "false": true},
	{"title": "El vigilante nocturno", "text": "Oyó 'cosas raras'; era la caldera, no una conspiración.", "false": true}], "beats": [
	{"who": "narrador", "text": "En cuanto se huele una filtración, salen las moscas. Antes de llegar al informante de verdad, cinco voces se ofrecen a Vera y a Nora, cada una con su gran secreto que vender. Un cuartucho de archivo, café de máquina y humo de gente que quiere su minuto de gloria."},
	{"who": "periodista", "text": "Un becario al que echaron y ahora presume de haberlos hundido; solo se llevó el finiquito y el rencor. Una limpiadora que ve papeles cada noche pero solo sabe vaciar papeleras, no leerlas. Un hacker de foro con 'los servidores de Nyxos', que son capturas trucadas para presumir."},
	{"who": "detective", "text": "Y los dos de siempre: un competidor que suelta bulos para hundir a Nyxos en bolsa, y un vigilante nocturno que oyó 'cosas raras' que resultaron ser la caldera. Cinco tenores y ni una nota afinada."},
	{"who": "periodista", "text": "Todos quieren cámara, Nora. Ninguno tiene el documento. Ninguno tiembla de verdad."},
	{"who": "detective", "text": "Ese es el filtro. El bueno no presume ni cobra: tiene pánico y tiene un despacho dentro. Al que hay que llegar es al único que no quiere salir en ninguna foto."}], "revisit": "Cinco fuentes de pega. El informante bueno es un directivo aterrado de dentro."},
"l12b": {"bg": "oficina", "flag": "done_l12b", "clue": {"title": "El memorándum interno", "text": "El informante alcanza a pasar una hoja: un memo que ordena 'depurar sujetos no viables'. Firmado por la dirección."}, "beats": [
	{"who": "narrador", "text": "El aparcamiento subterráneo de Nyxos es un bosque de columnas de hormigón y tubos fluorescentes que parpadean. Huele a goma quemada y a frío de sótano. Tus pasos rebotan y vuelven, y no sabes si el eco es tuyo o de alguien más."},
	{"who": "narrador", "text": "El informante aparece entre dos coches, pálido, el traje caro arrugado como si hubiera dormido con él puesto. Trae un sobre pegado al pecho y los ojos por todas partes menos en los tuyos."},
	{"who": "detective", "text": "Tranquilo. Soy yo, la que esperaba. Deme lo que tiene y le saco de aquí ahora mismo, sin ruido. Tengo el coche a treinta metros."},
	{"choices": [
		{"text": "Sacarlo primero, coger el sobre después", "then": [
			{"who": "detective", "text": "El papel luego. Primero usted. Camine a mi lado, despacio, como si no pasara nada."},
			{"who": "narrador", "text": "Da un paso hacia ti y, en ese medio segundo, te alarga el sobre casi sin querer, como quien suelta lastre. Sus dedos están helados."}]},
		{"text": "Coger la prueba ya, por si acaso", "then": [
			{"who": "detective", "text": "(Si algo sale mal en los próximos segundos, que al menos no salga mal para nada.) Deme el sobre. Ahora. Luego corremos los dos."},
			{"who": "narrador", "text": "Te pone el sobre en la mano con una urgencia que da miedo, como si supiera que no va a haber un segundo intento."}]}]},
	{"who": "narrador", "text": "Dentro, una sola hoja. Un memorándum interno, membrete de Nyxos, lenguaje de oficina: ordena 'depurar a los sujetos no viables del proyecto Somnia'. Depurar. Como quien limpia un archivo. Personas."},
	{"who": "detective", "text": "'Sujetos no viables.' Lo escribieron así, con esa asepsia, para no tener que leer nunca la palabra personas. Esto no lo firma un loco: lo firma un comité en una reunión con café y galletas."},
	{"who": "narrador", "text": "Un chirrido de neumáticos rompe el silencio del sótano. Faros largos, de golpe, que te ciegan. El informante reacciona antes que tú: te empuja detrás de una columna con las dos manos, un instante antes del disparo. Seco. Único. De profesional."},
	{"who": "narrador", "text": "El coche ya no está cuando bajas la vista. Él sí. En el suelo, junto a la columna que te salvó, sin respirar. La hoja sigue en tu mano, arrugada por el empujón que te dejó viva."},
	{"who": "detective", "text": "(Me ha apartado. Con las últimas fuerzas que le quedaban, me ha apartado a mí. Un hombre al que no conocía de nada.)", "side": "right"},
	{"who": "detective", "text": "Lo han ejecutado por una hoja de papel. Pero la hoja la tengo yo. Y dice 'depurar', firmado por la dirección de Nyxos. No te has muerto para nada. Te lo juro."}], "revisit": "El informante murió por pasarme el memo: Nyxos ordena 'depurar' a los sujetos. Firmado arriba."},
"fin12": {"bg": "oficina", "flag": "cap12_completo", "clue": {"title": "Matan para tapar", "text": "El asesinato del informante confirma que la dirección de Nyxos mata para proteger el proyecto."}, "beats": [
	{"who": "narrador", "text": "Con la matrícula grabada en la retina, Nora rastrea el coche del sicario hasta un garaje anodino a nombre de una sociedad de Nyxos. Cuando llega, está vacío y apesta a lejía: alguien lo fregó de arriba abajo con la calma de quien ha hecho esto muchas veces."},
	{"who": "detective", "text": "Limpio. Demasiado limpio. Pero la prisa siempre se deja algo detrás."},
	{"who": "narrador", "text": "En una cámara del techo que olvidaron desconectar, la imagen: el coche, la matrícula entera y el conductor bajando un segundo con la cara descubierta. En la solapa, un logo pequeño bordado. La serpiente enroscada en la copa."},
	{"who": "detective", "text": "Seguridad corporativa de Nyxos. No un matón de callejón: un empleado con nómina, con seguro médico, con vacaciones pagadas. Aprieta un gatillo y luego ficha la salida. Matan como quien archiva."},
	{"choices": [
		{"text": "Cargar con la culpa", "then": [
			{"who": "detective", "text": "(Estaba vivo hace tres horas. Vino a hacer lo correcto por una vez en su vida y yo no supe sacarlo. Otro nombre para la lista de los que no salvé.)", "side": "right"},
			{"who": "narrador", "text": "Te apoyas en el capó frío del coche vacío. Por un momento no eres detective: solo eres alguien que ha visto morir a un hombre a un brazo de distancia y no ha podido hacer nada."}]},
		{"text": "Convertir el luto en rabia", "then": [
			{"who": "detective", "text": "No me voy a quedar llorando en un garaje con olor a lejía. Me apartó para que yo siguiera de pie. Pues sigo de pie, y con su papel en la mano."},
			{"who": "detective", "text": "Lo van a lamentar. No el hombre que apretó el gatillo: el despacho que escribió la orden.", "side": "right"}]}]},
	{"who": "detective", "text": "Ya no es solo experimentar con gente. Es asesinar para tapar los experimentos, con su propia gente de seguridad. Y el memo dice que la orden nace arriba, en la dirección."},
	{"who": "periodista", "text": "Publico lo del memo, Nora. Con el rostro tapado del sicario y todo. Aunque me cueste el puesto y algo peor. Se lo debo al hombre del aparcamiento, que se fió de una libreta antes que de nadie."},
	{"who": "detective", "text": "Publícalo bien blindado, Vera. Que cuando salga, ya no puedan depurarte a ti también."}], "revisit": "Nyxos mató al informante con su propia seguridad. El memo de 'depurar' es oro."},
"cierre12": {"bg": "comisaria", "flag": "done_cierre12", "beats": [
	{"who": "narrador", "text": "De vuelta en la comisaría, el memorándum descansa dentro de una funda de plástico sobre la mesa, como una cosa viva a la que hay que vigilar. Núñez lo lee tres veces sin tocar la funda. Fuera, la lluvia otra vez, insistente."},
	{"who": "detective", "text": "Tenemos un memo firmado por 'la dirección' y un cadáver en un aparcamiento para taparlo. Pero 'la dirección' sigue sin ser un nombre. Y sin un nombre, un juez me lo devuelve por la ventanilla."},
	{"who": "nunez", "text": "Piénselo al revés, detective Vega. Los memos no nacen de la nada: nacen de expedientes. Alguien decide que un sujeto es 'no viable' leyendo su historial. Y esos historiales tienen que estar guardados en algún sitio, con nombre y apellido."},
	{"who": "detective", "text": "En un archivo médico. Del hospital que Nyxos patrocina con tanto cariño para las fotos y los recortes de prensa."},
	{"who": "nunez", "text": "Ahí lo tiene. Los sujetos con cara, con nombre, con historia clínica. Deje de perseguir la firma un momento y vaya a por las víctimas: ellas le dirán quién decidió sobre sus vidas."},
	{"who": "detective", "text": "Nombres, no números. Se lo debo al hombre que me apartó de un balazo. Al archivo del hospital."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 12 —  Nyxos mata para callar. Y el siguiente hilo pasa por los expedientes de sus víctimas."}]},

# --- Cap. 13 · El expediente ---
"brief13": {"bg": "comisaria", "flag": "done_brief13", "beats": [
	{"who": "narrador", "text": "Llueve otra vez sobre la comisaría, esa lluvia fina que no moja pero cala. Sobre la mesa de Nora, una lista de nombres impresa se va emborronando bajo el vaho del café. Diecinueve desaparecidos. Diecinueve números de lote que Nyxos anotó como quien apunta cajas en un almacén."},
	{"who": "nunez", "text": "El hospital central guarda los historiales clínicos de todos esos 'sujetos'. Fechas de ingreso, tratamientos, altas que no fueron altas. Con eso, detective Vega, podemos ponerle cara y nombre a cada número de lote."},
	{"who": "detective", "text": "Nombres, Núñez. No números. Cada lote de esos era una persona que un día tuvo hambre, o insomnio, o miedo a morir sola. Nyxos los convirtió en un código de barras. Yo se lo pienso devolver del revés."},
	{"who": "nunez", "text": "Al archivo médico, entonces. Pero vaya con tiento: un historial clínico está protegido. Necesita a alguien de dentro que le abra las carpetas sin que salte una alarma."},
	{"who": "detective", "text": "Sonia. Es forense, tiene llave del archivo y es la única persona en esta ciudad en la que confío a ciegas. Ella me cruza los datos."},
	{"choices": [
		{"text": "«Voy a mirarlo como policía. Con la cabeza fría.»", "then": [
			{"who": "detective", "text": "Entro ahí como investigadora, no como nada más. Cruzo listas, ato lotes con nombres y salgo con un expediente que aguante en un juzgado. Sin sangre en los ojos."},
			{"who": "nunez", "text": "Así me gusta oírla. La cabeza fría es lo único que esta gente no sabe comprar. Guárdela bien."}]},
		{"text": "«Tengo un mal presentimiento con esta lista.»", "then": [
			{"who": "detective", "text": "Llevo toda la mañana con un peso en el pecho, Núñez. Como si supiera que en esa lista hay un nombre que no quiero leer. Y aun así tengo que leerla entera."},
			{"who": "nunez", "text": "Los presentimientos de los buenos policías suelen ser memoria disfrazada de miedo. Si algo le tira del estómago, no lo aparte: sígalo. Pero llámeme si escuece."}]}]},
	{"who": "detective", "text": "(Diecinueve nombres. He aprendido a mirar listas de muertos sin que me tiemble el pulso. Ojalá esta sea una más. Ojalá.)", "side": "right"}], "revisit": "Los historiales del hospital convierten los 'lotes' de Nyxos en personas con nombre."},
"l13a": {"bg": "archivo_medico", "flag": "done_l13a", "clue": {"title": "Los sujetos de prueba", "text": "Los historiales cruzan a los desaparecidos con un mismo 'estudio patrocinado' de Nyxos."}, "beats": [
	{"who": "narrador", "text": "El archivo médico del sótano del hospital es un laberinto de estanterías metálicas y olor a papel viejo y a formol. La luz cae de tubos que parpadean. Sonia camina delante entre las carpetas como por su casa, con una linterna entre los dientes y una carpeta bajo el brazo."},
	{"who": "sonia", "text": "Bienvenida a la memoria de la ciudad, Nora. Aquí abajo está todo el mundo que ha pasado por una camilla en cuarenta años. Y aquí abajo, si sabes mirar, también están los que alguien quiso borrar."},
	{"who": "detective", "text": "Mi lista tiene diecinueve nombres. Necesito su historial. Ingresos, tratamientos, quién los firmaba y adónde fueron a parar."},
	{"who": "narrador", "text": "Sonia despliega las carpetas sobre una mesa de acero, una junto a otra, como quien tiende cartas de una baraja marcada. Va marcando renglones con un rotulador rojo. Poco a poco, un mismo dibujo empieza a repetirse en todas."},
	{"who": "sonia", "text": "Aquí, mira. Y aquí. Y aquí. Todos tus desaparecidos pasaron por lo mismo antes de esfumarse: un 'estudio patrocinado'. Mismo código de protocolo, misma firma de patrocinador en el pie. Nyxos. Los diecinueve."},
	{"who": "detective", "text": "Cada número de lote es una persona con historia clínica, Sonia. Nyxos los reclutaba enfermos, insomnes, solos, gente que firmaba por una cama caliente y una promesa. Los devolvía al estudio... y del estudio ya no volvían."},
	{"who": "sonia", "text": "Fíjate en las fechas. Ingreso, 'estudio', y a las pocas semanas el historial se corta en seco. Ni alta, ni defunción, ni traslado. Se corta. Como si les hubieran arrancado el resto de la vida de la carpeta."},
	{"who": "detective", "text": "(Una carpeta que se corta a media frase. He visto expedientes de guerra menos fríos que estos. Los ordenaron con letra bonita y márgenes rectos. El horror con buena caligrafía.)", "side": "right"},
	{"who": "sonia", "text": "Y hay algo peor, Nora. Deja que termine de cruzar la última tanda de reclutados, la más reciente. Porque en esa... en esa hay un nombre que tú conoces. Y no sé cómo decírtelo."}], "revisit": "Los historiales atan a todos los desaparecidos a un mismo estudio de Nyxos."},
"rh13": {"bg": "morgue", "flag": "done_rh13", "clues": [
	{"title": "El celador dormilón", "text": "Muy nervioso; solo teme que lo pillen durmiendo en el turno de noche.", "false": true},
	{"title": "El informático", "text": "Digitalizó los historiales; no leyó ni uno, solo escaneó por lotes.", "false": true},
	{"title": "La auxiliar nueva", "text": "Se confunde de carpetas; torpeza de novata, no sabotaje.", "false": true},
	{"title": "El jefe de archivo", "text": "Firma todo sin mirar desde hace veinte años; vago, no cómplice.", "false": true},
	{"title": "El estudiante de prácticas", "text": "Sacó fotos a un historial... para un trabajo de clase.", "false": true}], "beats": [
	{"who": "narrador", "text": "Un pasillo comunica el archivo con la morgue, y allí, entre camillas vacías y el zumbido de las neveras, Sonia y Nora reciben de uno en uno a los cinco empleados con acceso al archivo. Cinco caras nerviosas bajo la luz verde de los fluorescentes. Cinco sospechosos de manual."},
	{"who": "sonia", "text": "El instinto dice que el que toca los papeles es el que los pudre. Vamos a ver si el instinto acierta o si solo estamos asustando a cinco pobres diablos."},
	{"who": "detective", "text": "El celador del turno de noche suda como si lo fueran a fusilar. Pero no teme por los muertos: teme que lo pillen echando la siesta en un sillón del sótano. Miedo de vago, no de cómplice."},
	{"who": "narrador", "text": "Desfilan los demás. El informático digitalizó miles de historiales sin leer uno solo, escaneando por lotes con la mirada perdida. La auxiliar nueva confunde carpetas por pura torpeza de novata. El jefe de archivo firma todo sin mirar desde hace veinte años. El estudiante de prácticas fotografió un historial... para un trabajo de clase."},
	{"who": "sonia", "text": "Dormilón, informático, novata, vago, estudiante. Cero intención criminal, Nora. Los cinco pasan las manos por esos papeles sin entender lo que sostienen. El mal no está en quien toca los papeles: está en quien los mandó crear."},
	{"who": "detective", "text": "Exacto. Ninguno de estos cinco decidió nada. El código del proyecto no lo firma un celador que ronca ni una novata que se traba con el alfabético. Ese código lleva hacia arriba, muy arriba, al consejo. Ahí es donde muerdo."}], "revisit": "Cinco empleados inocentes. El mal está en el código del proyecto, aprobado arriba."},
"l13b": {"bg": "hospital", "flag": "done_l13b", "clue": {"title": "Diego en la lista", "text": "Diego ha recaído y aparece de nuevo reclutado por Nyxos: lo usan para presionar a Nora."}, "beats": [
	{"who": "narrador", "text": "El nombre que Sonia no se atrevía a leer era el peor de todos. Nora sube tres plantas con la carpeta apretada contra el pecho y empuja una puerta de una habitación individual. En la cama, bajo una manta demasiado blanca, con una vía en el brazo y el sueño químico dibujado en la cara, está Diego. Otra vez. Otra vez con Somnia en las venas."},
	{"who": "detective", "text": "(Se me para el mundo en el umbral de esa puerta. Toda la ciudad, todo el caso, los diecinueve nombres... y de golpe solo veo a mi hermano pequeño respirando despacio en una cama que no eligió.)", "side": "right"},
	{"who": "diego", "text": "¿Nora...? No llores, anda, que se te pone cara de cuando éramos críos. Lo siento. Lo siento muchísimo. Vinieron ellos. Yo había recaído, estaba fatal, y aparecieron con batas y con papeles."},
	{"who": "detective", "text": "Diego, mírame. ¿Quiénes vinieron? ¿Qué te ofrecieron esta vez?"},
	{"who": "diego", "text": "Dijeron que si volvía al 'programa' me curaban gratis, con lo mejor que tienen. Y luego, muy amables, muy suaves, soltaron lo otro: que a ti te convenía que yo colaborase. Que una hermana tranquila trabaja mejor."},
	{"who": "detective", "text": "¿Te han usado para llegar a mí? ¿Nyxos te ha vuelto a meter en la máquina solo para tenerme cogida por donde más duele?"},
	{"who": "diego", "text": "Creo que sí, hermana. Me dieron un mensaje para ti, palabra por palabra, para que no se me olvidara: 'que la detective piense en su familia'. Me hicieron de cartero de mi propia condena. Perdóname. Otra vez soy tu punto débil."},
	{"choices": [
		{"text": "Abrazarlo y prometerle que esta vez no falla", "then": [
			{"who": "narrador", "text": "Nora deja la carpeta en la silla y se sienta en el borde de la cama. Le aparta el pelo sudado de la frente, igual que hacía su madre, igual que hizo ella la primera vez que lo sacó de un mal sitio. Diego se agarra a su manga."},
			{"who": "detective", "text": "No eres mi punto débil, Diego. Escúchame bien esto: eres la razón por la que voy a tirarles la torre encima. Te van a soltar, te van a limpiar la sangre de esa porquería, y ellos van a caer. Esta vez no fallo."},
			{"who": "diego", "text": "Te creo. Siempre te creo, hermana mayor. Es lo único que me ha sujetado en pie estos años."}]},
		{"text": "Contener la rabia y jurarles guerra en voz baja", "then": [
			{"who": "detective", "text": "(Podría gritar. Podría bajar al aparcamiento y romperle la cara al primer traje de Nyxos que encuentre. Y eso es exactamente lo que quieren: que pierda la cabeza y con ella el caso.)", "side": "right"},
			{"who": "detective", "text": "No van a verme temblar, Diego. Van a verme llegar. Han metido a mi hermano en esto pensando que me paralizaba. Se han equivocado de detective y de familia."},
			{"who": "diego", "text": "Esa voz. Esa voz baja tuya me daba miedo de pequeño. Ahora me da paz. Que se preparen."}]}]},
	{"who": "detective", "text": "Descansa. Núñez va a poner a un agente en esa puerta y no entra ni el médico sin que yo lo sepa. Se acabó que te usen. Ahora la que va a usar algo soy yo: este expediente, contra ellos."}], "revisit": "Nyxos ha vuelto a usar a Diego para presionarme. Han cruzado la última línea."},
"fin13": {"bg": "hospital", "flag": "cap13_completo", "clue": {"title": "El código del proyecto", "text": "Todos los historiales llevan un código: 'Proyecto SOMNIA — Nivel Consejo'. La orden viene del consejo de Nyxos."}, "beats": [
	{"who": "narrador", "text": "Con Diego dormido y custodiado, Nora y Sonia vuelven al archivo y exprimen los historiales hasta la última página. En un rincón de cada carpeta, estampada con un sello de tinta violeta, la misma etiqueta de máxima confidencialidad se repite como una firma del diablo."},
	{"who": "detective", "text": "Aquí está. En todas. 'Proyecto Somnia — autorización: Nivel Consejo'. Léelo, Sonia. No es una planta que se descontroló. No es un directivo suelto haciendo el loco. Lo aprueba el consejo de administración. La cúpula entera."},
	{"who": "sonia", "text": "El consejo, Nora. No un monstruo con colmillos: doce personas con firma, en una sala con moqueta buena y agua en botella de cristal. El horror no lo decidió un chalado en un sótano. Lo aprobó una reunión con orden del día."},
	{"who": "detective", "text": "Doce personas decidiendo, entre el café y las galletas, a cuánta gente experimentar y a cuánta 'depurar'. Levantaban la mano, se aprobaba el punto, y en algún sitio de la ciudad se apagaba una persona. El mal con acta y con secretario."},
	{"choices": [
		{"text": "Sentir el vértigo de contra quién va", "then": [
			{"who": "detective", "text": "(Doce firmas. Doce personas que esta noche cenarán en casa mientras mi hermano suda veneno en una cama. Y yo, con una carpeta y una placa gastada, voy a ir a por las doce.)", "side": "right"},
			{"who": "sonia", "text": "Conozco esa cara tuya. Es la de antes de una cuesta muy larga. No la subas sola, Nora. Para eso estamos los que te queremos: para que no la subas sola."}]},
		{"text": "Endurecerse y aceptar el tamaño del enemigo", "then": [
			{"who": "detective", "text": "Mejor. Si la orden nace de un consejo, entonces ya sé exactamente dónde clavar el hierro. No persigo a un culpable: desmonto una decisión colectiva. Y las decisiones dejan actas, y las actas dejan huella."},
			{"who": "sonia", "text": "Esa es mi Nora. Yo te firmo cada informe forense que haga falta, con nombre y apellidos. Que tiemblen los de la moqueta buena."}]}]},
	{"who": "detective", "text": "'Nivel Consejo'. Ya no busco al que aprieta la aguja. Busco a los doce que aprobaron que existiera la aguja. La orden nace arriba del todo, y hasta arriba del todo voy a subir."}], "revisit": "El proyecto Somnia se aprueba a 'nivel consejo'. La orden nace del consejo de Nyxos."},
"cierre13": {"bg": "comisaria", "flag": "done_cierre13", "beats": [
	{"who": "narrador", "text": "En la comisaría, el expediente ocupa media mesa: carpetas, fotocopias, el sello violeta repetido decenas de veces. Núñez lo hojea despacio, con las gafas en la punta de la nariz, y por primera vez en semanas no encuentra una pega."},
	{"who": "detective", "text": "El proyecto lo firma el consejo, Núñez. Lo tengo por escrito, con su código y su nivel de autorización. Pero conozco a los jueces: el primero me va a preguntar si esto pasa solo aquí. Si es un desmán local o una máquina."},
	{"who": "nunez", "text": "Y tiene razón el juez imaginario. Un consejo que aprueba esto no lo aprueba para una ciudad. Hay que demostrar que Nyxos hace lo mismo en otros sitios, que es sistemático. Que no es una herida: es un método."},
	{"who": "detective", "text": "Entonces necesito un segundo lugar. Otro archivo, otras carpetas, el mismo sello violeta a doscientos kilómetros de aquí."},
	{"who": "nunez", "text": "Corren rumores de un centro en la costa. Un 'balneario de salud' de Nyxos donde entra gente a curarse y no vuelve a salir. Coja unos días, detective Vega. Baje al sur y mire con sus propios ojos. Diego está a salvo aquí; de eso me encargo yo."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 13 —  La orden nace en el consejo de Nyxos. Y el rastro, ahora, se extiende más allá de la ciudad: hacia un pueblo de la costa donde el mar guarda otro secreto."}]},

# --- Cap. 14 · El pueblo de la costa ---
"brief14": {"bg": "comisaria", "flag": "done_brief14", "beats": [
	{"who": "narrador", "text": "La comisaría huele a café quemado y a expedientes que no cierran. Núñez despliega sobre la mesa un folleto satinado: cielo azul, batas blancas, un acantilado sobre el mar. En una esquina, pequeña, la serpiente enroscada en la copa."},
	{"who": "nunez", "text": "Un pueblo de la costa, tres horas al sur. Un 'balneario de salud' de Nyxos sobre el acantilado. Talasoterapia, dicen, aire de mar, curas de reposo. Y demasiada gente que sube a curarse y no vuelve a bajar."},
	{"who": "detective", "text": "Del neón al salitre. La misma serpiente, otro clima. ¿Qué le hace pensar que no es solo un balneario caro para viejos con dinero?"},
	{"who": "nunez", "text": "Que los que suben no tienen dinero. Son jubilados solos, enfermos crónicos del pueblo. Gente que allí llaman 'sin cargas'. Y que en el registro del ayuntamiento constan como 'trasladados' y nunca como 'vueltos'."},
	{"who": "detective", "text": "Sin cargas. Otra vez la misma palabra bonita para decir: nadie preguntará por ellos."},
	{"who": "nunez", "text": "Baje a mirar, detective Vega. Pero sin placa por si acaso. Allí abajo Nyxos no es una empresa que patrocina hospitales: es el que da los pocos empleos que quedan. Usted allí no tiene amigos."},
	{"choices": [
		{"text": "«Bajo como turista. Ojos abiertos, boca cerrada.»", "then": [
			{"who": "detective", "text": "Bajo como una señora cansada que busca aire de mar. Nadie desconfía de una mujer sola con maleta. Miro, escucho y no firmo nada."},
			{"who": "nunez", "text": "Así me gusta. Sea sombra hasta que tenga algo que aguante en un juzgado. Y llámeme cada noche, que la cobertura ahí baila."}]},
		{"text": "«Voy con rabia. Esto ya lo he visto en la ciudad.»", "then": [
			{"who": "detective", "text": "Ya sé lo que voy a encontrar, Núñez. Lo vi en la clínica, lo vi en el laboratorio. Solo cambia el papel de pared. Y me pone enferma saberlo de antemano."},
			{"who": "nunez", "text": "Precisamente por eso, cabeza fría. Si baja con la rabia por delante, la ven venir a un kilómetro. Rabia guardada, detective Vega. La necesitará entera para el final."}]}]},
	{"who": "detective", "text": "(Tres horas al sur. Tres horas para convencerme de que esta vez, quizá, solo sea un balneario. No me lo creo ni yo.)", "side": "right"}], "revisit": "En la costa hay un 'balneario' de Nyxos donde la gente entra y no sale."},
"l14a": {"bg": "costa", "flag": "done_l14a", "clue": {"title": "El balneario", "text": "El 'balneario de salud' de Nyxos en el pueblo costero es otro centro de ensayos encubierto."}, "beats": [
	{"who": "narrador", "text": "El pueblo de la costa es blanco y azul: casas encaladas, barcas varadas panza arriba, redes secándose. El mar es una lámina de plomo bajo un cielo que no acaba de llover. Y sobre el acantilado, dominándolo todo, un edificio nuevo, luminoso, con el logo de la serpiente recortado contra el gris."},
	{"who": "detective", "text": "Un balneario. Aire de yodo, batas blancas y precios de folleto. La misma fachada amable de siempre, solo que aquí huele a salitre en vez de a lluvia sucia."},
	{"who": "narrador", "text": "Subes el camino del acantilado. En la verja, un jardinero riega geranios que no necesitan agua. Dos ancianos toman el sol en sillas de ruedas, quietos como estatuas, vigilados por un celador demasiado corpulento para ser enfermero."},
	{"who": "detective", "text": "Esos dos no toman el sol: los han puesto al sol. Como se saca a airear la ropa. Y el enfermero tiene espaldas de portero de discoteca, no de cuidador."},
	{"who": "detective", "text": "Aquí no traen mujeres del Barrio Viejo. Aquí reclutan a jubilados solos, a enfermos crónicos del pueblo. Gente que ya estaba medio borrada del mundo. La misma cantera, otro paisaje."},
	{"who": "narrador", "text": "Una recepcionista de sonrisa ensayada te tiende un tríptico: 'Programa de bienestar prolongado. Plazas subvencionadas para vecinos sin recursos ni familia'. Lo dice como si fuera un premio."},
	{"who": "detective", "text": "'Sin recursos ni familia.' Lo ponen en el folleto, con orgullo, como si fuera caridad. Es el mismo filtro que en la ciudad: no eligen a los débiles. Eligen a los que nadie va a reclamar."}], "revisit": "El balneario de la costa es otra clínica-cantera de Nyxos, con jubilados y enfermos."},
"rh14": {"bg": "puerto_pesca", "flag": "done_rh14", "clues": [
	{"title": "El pescador chismoso", "text": "Jura ver 'barcos con cuerpos'; mezcla leyendas, faro y aguardiente.", "false": true},
	{"title": "El dueño del bar", "text": "Sabe de todo el pueblo; solo repite rumores para vender más vino.", "false": true},
	{"title": "El guardacostas", "text": "Vio luces raras de noche; eran barcos de pesca furtiva, no de Nyxos.", "false": true},
	{"title": "La bruja del pueblo", "text": "Dice que el balneario 'roba la vida'; superstición con parte de verdad.", "false": true},
	{"title": "El forastero", "text": "Un turista que hace demasiadas preguntas; solo es un periodista de viajes.", "false": true}], "beats": [
	{"who": "narrador", "text": "El puerto pesquero es un rosario de barcas, cabos podridos y gaviotas que gritan sobre las cajas de hielo. Aquí todo el mundo tiene una teoría sobre el balneario, y todas saben a vino peleón y a miedo viejo."},
	{"who": "detective", "text": "En un pueblo así, el chismorreo es el único periódico. Escucho a los cinco que más hablan. A ver cuántos aguantan de pie."},
	{"who": "narrador", "text": "El pescador chismoso jura, con la mirada perdida en el faro, que ha visto 'barcos que cargaban cuerpos de noche'. Pero mezcla la leyenda del ahogado, las luces del faro y media garrafa de aguardiente. El tabernero sabe de todo el pueblo y no sabe de nada: repite rumores para llenar vasos."},
	{"who": "detective", "text": "El guardacostas vio luces raras mar adentro, sí. Eran arrastreros furtivos faenando donde no deben, no lanchas de Nyxos. La 'bruja' del pueblo dice que el balneario 'roba la vida' por las ventanas: superstición, aunque la vieja no anda tan descaminada de fondo."},
	{"who": "detective", "text": "Y el forastero que hace demasiadas preguntas resulta ser un periodista de viajes buscando una crónica de pueblo con encanto. Cinco bocas, cinco callejones. Rumor, miedo y folclore. Ninguno prueba nada ante un juez."},
	{"who": "detective", "text": "Pero hay una cosa en este pueblo que no bebe, no delira y no inventa leyendas: el libro de bajas del ayuntamiento. Ahí, en negro sobre blanco, están los que no volvieron. La prueba no está en el puerto. Está en el registro."}], "revisit": "Cinco rumores de pueblo. La prueba está en el libro de bajas del ayuntamiento."},
"l14b": {"bg": "balneario", "flag": "done_l14b", "clue": {"title": "Los desaparecidos del sur", "text": "El registro del pueblo esconde una lista de vecinos 'trasladados a tratamiento' que nunca regresaron."}, "beats": [
	{"who": "narrador", "text": "El ayuntamiento del pueblo es un caserón de piedra medio dormido, con un reloj parado y un ficus polvoriento. Tras el mostrador, una funcionaria de mediana edad teclea con la cara de quien lleva veinte años tramitando el olvido de los demás."},
	{"who": "narrador", "text": "Le pides el registro de traslados a centros asistenciales. Ella te mira largo, calibrando si eres peligro o compañía. Luego, casi por rebeldía, saca un libro grande de tapas grises y lo deja caer sobre el mostrador con un golpe seco."},
	{"who": "narrador", "text": "—Usted no es de aquí —dice sin preguntar—. Los de aquí ya no preguntan. Mire la columna de la derecha. La de 'reingreso'. Y cuénteme cuántas fechas ve escritas."},
	{"who": "detective", "text": "Veinte nombres 'trasladados a tratamiento especial' en dos años. Y la columna de reingreso, veinte veces en blanco. Ni una fecha de vuelta. Ni una."},
	{"who": "narrador", "text": "La funcionaria pasa el dedo por los renglones, uno a uno, como quien reza un rosario que odia. Baja la voz aunque no hay nadie más en la sala."},
	{"who": "narrador", "text": "—Don Amaro, el del faro. La Pura, que vendía pescado. El maestro jubilado, que no tenía a nadie. Yo tramité sus papeles. Puse el sello. 'Traslado por bienestar.' Y nunca me atreví a preguntar por qué no volvía ninguno."},
	{"choices": [
		{"text": "Ser dura: «Usted lo sabía y firmó igual.»", "then": [
			{"who": "detective", "text": "Usted puso el sello veinte veces. Veinte personas. Y ni una llamada, ni una carta al forense. Eso también tiene un nombre, señora."},
			{"who": "narrador", "text": "La mujer no se defiende. Aprieta los labios y asiente, como si llevara años esperando que alguien se lo dijera a la cara."},
			{"who": "narrador", "text": "—Lo sé. Por eso he sacado el libro. Sáquelo del cajón, detective. Yo ya no puedo dormir; que al menos sirva de algo mi vergüenza."}]},
		{"text": "Ser humana: «No es usted quien los subió al acantilado.»", "then": [
			{"who": "detective", "text": "Usted no los subió al acantilado. Solo hizo su trabajo en un pueblo que mira para otro lado. El que hay que colgar está allá arriba, no en este mostrador."},
			{"who": "narrador", "text": "A la funcionaria se le quiebra algo en la garganta. Empuja el libro hacia ti unos centímetros más, como quien se quita un peso de encima."},
			{"who": "narrador", "text": "—Lléveselo. Copie lo que quiera. Yo no vi nada, ¿me entiende? Pero necesitaba que alguien lo viera por fin."}]}]},
	{"who": "detective", "text": "Veinte vecinos 'trasladados' y ninguno vuelto. Sin familia, sin denuncia, sin nadie que llame. Nyxos elige pueblos pequeños y gente sola por lo mismo que elegía mujeres solas en la ciudad: porque el silencio ya venía de fábrica.", "side": "right"}], "revisit": "Veinte vecinos 'trasladados' por Nyxos y nunca vueltos. El patrón se repite en el sur."},
"fin14": {"bg": "sanatorio_costa", "flag": "cap14_completo", "clue": {"title": "No es solo una ciudad", "text": "El balneario prueba que Nyxos replica el sistema por todo el país: es una red nacional."}, "beats": [
	{"who": "narrador", "text": "De madrugada, con el viento cortando salitre contra la cara, entras por la puerta de servicio del balneario. La planta noble huele a lavanda y a cera. Bajas una escalera de mármol que se vuelve hormigón, y la lavanda se convierte en desinfectante y en frío de nevera."},
	{"who": "detective", "text": "Arriba, balneario de folleto. Aquí abajo, el mismo hormigón que en el laboratorio de la ciudad. Como si hubieran fotocopiado el infierno y cambiado la dirección postal."},
	{"who": "narrador", "text": "El sótano se abre ante ti y es un déjà vu que hiela: habitáculos numerados con puertas de observación, neveras de viales ámbar con la serpiente impresa, camillas con correas, pulseras de plástico con códigos en vez de nombres. Idéntico. Hasta la disposición de las salas es la misma."},
	{"who": "detective", "text": "Idéntico. Copiado y pegado. No es una imitación torpe de un jefe local: es el mismo plano, el mismo protocolo, el mismo mobiliario. Un franquiciado del horror junto al mar."},
	{"who": "narrador", "text": "En una pared, un cuadro de organización con pestañas de colores. Y en la cabecera, impresa, una frase de manual corporativo: 'Centro Sur-3. Protocolo estándar de bienestar prolongado.'"},
	{"who": "detective", "text": "Sur-3. Un número. Si esto es el tres, hay un uno y un dos. Y detrás de un número siempre hay una lista, y un departamento que la gestiona, y un presupuesto anual. Esto ya no es un caso de una ciudad."},
	{"choices": [
		{"text": "Sentir el vértigo de lo que acaba de descubrir", "then": [
			{"who": "detective", "text": "(Creí que perseguía una herida en una ciudad. Y resulta que la herida está por todo el mapa, con su plano, su número y su hoja de cálculo. No lucho contra un crimen: lucho contra un modelo de negocio.)", "side": "right"},
			{"who": "detective", "text": "Nyxos no oculta desapariciones. Las industrializa. Producción en serie, sucursal a sucursal, con manual de instrucciones. Y el manual funciona porque nadie reclama la mercancía."}]},
		{"text": "Endurecerse y ponerse a trabajar", "then": [
			{"who": "detective", "text": "Nada de temblar ahora. Si es una red, la red deja rastro: facturas, transportes, nóminas de celadores, pedidos de viales. Todo lo que se replica, se documenta. Y todo lo que se documenta, se sigue."},
			{"who": "narrador", "text": "Fotografías el cuadro de organización pestaña por pestaña, el número, la frase de manual. Cada foto es un eslabón que ya no podrán fingir que no existe."}]}]},
	{"who": "detective", "text": "Es un sistema nacional, replicado pueblo a pueblo, con la eficiencia de quien fabrica jabón. La ciudad no era el centro del mundo. Era una sucursal más."},
	{"who": "narrador", "text": "Grabas, coges muestras y pulseras numeradas, y subes antes de que clareen las primeras barcas. Detrás de ti, el mar sigue golpeando el acantilado, plomo contra piedra, el único testigo que Nyxos nunca podrá comprar ni callar."}], "revisit": "El balneario es idéntico al laboratorio: Nyxos replica el sistema por todo el país."},
"cierre14": {"bg": "comisaria", "flag": "done_cierre14", "beats": [
	{"who": "narrador", "text": "En la comisaría, Nora vacía sobre la mesa una bolsa de pruebas: viales con la serpiente, pulseras numeradas, las fotos del cuadro de organización. Núñez las mira una a una y se sienta despacio, como si de repente le pesara la espalda."},
	{"who": "detective", "text": "Costa y ciudad, mismo hormigón, mismo protocolo, mismo logo. Y una etiqueta que lo dice todo: 'Centro Sur-3'. No es un desliz de una sucursal. Es una red nacional con numeración propia."},
	{"who": "nunez", "text": "Sur-3. Madre mía. Si numeran los centros, es que hay un mapa entero en algún despacho, con chinchetas. Y nosotros vamos descubriéndolos de uno en uno, tarde y a ciegas."},
	{"who": "detective", "text": "Veinte vecinos del sur trasladados a la nada, Núñez. Sin una sola denuncia. Y son solo los de un pueblo. Multiplique eso por cada chincheta del mapa."},
	{"who": "nunez", "text": "Si es nacional, los centros más sucios estarán en los sitios más escondidos. Se cuenta que hay uno en la montaña, un viejo sanatorio de tuberculosos reconvertido, lejos de toda carretera. Y allí, dicen, por primera vez, alguien salió con vida."},
	{"who": "detective", "text": "Un superviviente. Alguien que vio el sótano por dentro y respira para contarlo. Eso no es una pista, Núñez. Es la primera grieta de verdad en toda la pared."},
	{"who": "nunez", "text": "Si es que llegamos antes que ellos. Un testigo vivo es lo único que Nyxos no puede permitirse. Lo estarán buscando con el mismo mapa que nosotros."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 14 —  El mar guarda a los desaparecidos del sur. Y arriba, en la montaña, en un sanatorio olvidado, quizá respire todavía un testigo."}]},

# --- Cap. 15 · El pueblo de montaña ---
"brief15": {"bg": "comisaria", "flag": "done_brief15", "beats": [
	{"who": "narrador", "text": "La calefacción de la comisaría lleva días peleando contra una ola de frío que baja del norte. Sobre la mesa de Nora, un mapa de la sierra y una foto satélite: un edificio largo y blanco encaramado a una cumbre, con el logo nuevo de Nyxos pintado sobre piedra vieja. Debajo, una carpeta fina, casi vacía."},
	{"who": "nunez", "text": "Un sanatorio de montaña, detective Vega. Aislado por la nieve medio año. Nyxos lo compró hace dos inviernos y lo reabrió como 'unidad de cuidados paliativos'. El sitio perfecto para esconder lo que no debe verse."},
	{"who": "detective", "text": "Y para que, si alguien escapa, no le crea nadie. ¿Qué tenemos de dentro?"},
	{"who": "nunez", "text": "Nada firme. Rumores de pueblo. Suben 'enfermos' que caminan solos y bajan cajas cerradas. Y un parte antiguo de la Guardia Civil: hace meses una mujer bajó descalza por la nieve gritando que la mataban ahí arriba. La ingresaron por delirio. Nadie volvió a hablar de ella."},
	{"who": "detective", "text": "Una mujer que bajó por su propio pie. Viva. Núñez, eso no es un rumor: es un testigo."},
	{"who": "nunez", "text": "Un testigo al que ya etiquetaron de loca. Si la encuentra y no lo hace con cuidado, la palabra 'delira' se los come a los dos. A la montaña se sube con guantes, y en este caso lo digo en los dos sentidos."},
	{"choices": [
		{"text": "«Subo a escuchar, no a acusar. Con guantes.»", "then": [
			{"who": "detective", "text": "Subo a escuchar, Núñez. Nada de irrumpir con la placa por delante. Si esa mujer lleva meses sin que la crean, lo último que necesita es otro que llegue a decirle lo que vio."},
			{"who": "nunez", "text": "Así me gusta. La verdad de montaña no se arranca, se merece. Vaya despacio y llámeme desde el pueblo, que arriba no habrá cobertura."}]},
		{"text": "«Si hay alguien vivo ahí arriba, no espero al deshielo.»", "then": [
			{"who": "detective", "text": "Si hay una sola persona respirando en ese sitio, Núñez, no me quedo abajo esperando a que el juez se despierte de buen humor."},
			{"who": "nunez", "text": "Me lo temía. Suba, pero prométame que antes de forzar una puerta con nieve hasta la rodilla me lo piensa dos veces. Los mártires no declaran."}]}]},
	{"who": "detective", "text": "(Todos los que persigo desde hace meses son fotos, cruces en una carpeta, nombres apagados. Ahí arriba puede que haya una boca que aún habla. Una sola. Y voy a subir una montaña entera para no perderla.)", "side": "right"}], "revisit": "En un sanatorio de montaña de Nyxos quizá haya una superviviente."},
"l15a": {"bg": "montana", "flag": "done_l15a", "clue": {"title": "El sanatorio de montaña", "text": "El sanatorio de Nyxos en la montaña recibe 'pacientes terminales' que en realidad están sanos."}, "beats": [
	{"who": "narrador", "text": "El pueblo de montaña es piedra, humo de chimenea y un frío que corta la cara como un papel. Cuatro calles empinadas, un campanario, tejados con una cuarta de nieve. La gente mira de reojo desde las ventanas y no saluda. Sobre la cumbre, colgado del cielo gris, el sanatorio antiguo con el logo nuevo de Nyxos."},
	{"who": "detective", "text": "'Cuidados paliativos', dice el cartel de la carretera. Un sitio adonde la gente sube a morir en paz. Bonito. Piadoso. Inatacable."},
	{"who": "narrador", "text": "En la única taberna, un viejo que apura un orujo suelta la lengua cuando Nora paga la ronda. Baja la voz aunque no haya nadie más."},
	{"who": "detective", "text": "Cuénteme lo del sanatorio. Lo que se cuenta aquí, no lo que pone el folleto."},
	{"who": "narrador", "text": "El viejo señala la cumbre con el mentón. Dice que los enfermos que suben en la furgoneta suben andando, por su pie, con maleta. Que a veces saludan por la ventanilla, coloradotes, sanos como un roble. Y que lo único que baja de ahí son cajas. Cajas cerradas, del tamaño justo."},
	{"who": "detective", "text": "Suben sanos y bajan cajas. A un sitio de terminales no llega gente que camina y carga su equipaje. Eso no es un hospicio: es una puerta de un solo sentido con papeleo de caridad."},
	{"who": "detective", "text": "Aislamiento perfecto. Medio año incomunicados por la nieve. Aquí Nyxos hace, a plena luz de la montaña, lo que en la ciudad no se atreve ni en un sótano."}], "revisit": "El sanatorio de montaña de Nyxos recibe 'terminales' que suben sanos. Aislamiento total."},
"rh15": {"bg": "cabana_ermitano", "flag": "done_rh15", "clues": [
	{"title": "El ermitaño lunático", "text": "Jura que el sanatorio 'roba almas en frascos'; delira, aunque por miedo real.", "false": true},
	{"title": "El cazador", "text": "Vio camillas subir de noche; creyó que eran heridos de la nieve.", "false": true},
	{"title": "El cura del pueblo", "text": "Bendice el sanatorio; cobra un donativo y no pregunta.", "false": true},
	{"title": "La posadera", "text": "Aloja al personal; solo sabe que 'pagan bien y hablan poco'.", "false": true},
	{"title": "El niño del pueblo", "text": "Dice ver 'fantasmas en las ventanas'; son pacientes reales tras el cristal.", "false": true}], "beats": [
	{"who": "narrador", "text": "El pueblo tiene, como toda montaña, sus leyendas. Cinco voces se le acercan a Nora junto al fuego de una cabaña, cada una con su trozo de miedo. Fuera arrecia el viento; dentro, el humo pica en los ojos y las historias crecen con las llamas."},
	{"who": "detective", "text": "Cinco testigos de leyenda. Vamos a ver cuántos aguantan la luz del día."},
	{"who": "narrador", "text": "El ermitaño jura entre temblores que ahí arriba 'roban almas y las guardan en frascos'; delira, aunque su miedo sea de verdad. El cazador vio subir camillas de noche y creyó que eran heridos de la nieve. El cura bendice el sanatorio, cobra su donativo y mira para otro lado."},
	{"who": "detective", "text": "La posadera aloja al personal y solo sabe que 'pagan bien y hablan poco'. Y el niño ve 'fantasmas en las ventanas', que no son sino pacientes de carne y hueso pegados al cristal, mirando un pueblo al que ya no bajarán."},
	{"who": "detective", "text": "Ermitaño, cazador, cura, posadera, un crío asustado. Todo miedo, todo bruma. Pero el miedo no declara ante un juez, y una leyenda no tumba a una farmacéutica."},
	{"who": "detective", "text": "La única voz que vale es la de quien bajó de ahí con vida y en su sano juicio. Y hay una. Se llama Irene, y lleva meses escondida en una buhardilla de este pueblo, esperando a que alguien la crea."}], "revisit": "Cinco leyendas de montaña. La prueba viva es Irene, la que escapó del sanatorio."},
"l15b": {"bg": "sanatorio_montana", "flag": "done_l15b", "clue": {"title": "La superviviente", "text": "Una mujer que escapó del sanatorio, escondida en el pueblo, acepta hablar por primera vez."}, "beats": [
	{"who": "narrador", "text": "La buhardilla huele a leña húmeda y a miedo viejo. Bajo el alero, tapada con tres mantas pese al brasero, una mujer joven se encoge al oír los pasos en la escalera. Meses lleva así: la primera que salió del sanatorio por su propio pie y a la que el mundo entero decidió no escuchar."},
	{"who": "testigo", "text": "No se acerque de golpe. Por favor. Me llamo Irene. Subí ahí arriba por 'un tratamiento del sueño', gratis, con folleto y todo. Bajé descalza por la nieve, de noche, corriendo. Y desde entonces la única palabra que me devuelve la gente es 'delira'."},
	{"who": "detective", "text": "Yo no he subido a decirte que deliras, Irene. He subido una montaña entera para escucharte. Y te creo. Cada cosa que recuerdes es una grieta en algo muy grande."},
	{"who": "testigo", "text": "¿Me cree? Usted es la primera que no me mira como a una loca desde que puse un pie en este pueblo."},
	{"choices": [
		{"text": "«Tómate tu tiempo. No hay prisa que valga más que tú.»", "then": [
			{"who": "detective", "text": "No hay ninguna prisa, Irene. Cuéntamelo a tu ritmo. Llevo meses persiguiendo papeles y cruces en una lista. Tú eres la primera persona viva que puede ponerles nombre a esas cruces. Puedo esperar lo que haga falta."},
			{"who": "testigo", "text": "Nadie me había dicho eso. Todos querían el resumen rápido para volver a sus cosas. Está bien. Voy a contárselo entero, aunque tiemble."}]},
		{"text": "«Necesito el método. Cómo lo hacían, paso a paso.»", "then": [
			{"who": "detective", "text": "Sé que duele, y lo siento, pero necesito el método, Irene. Cómo funcionaba por dentro, paso a paso. Es lo único que un juez no puede llamar 'delirio': los detalles que solo sabe quien estuvo dentro."},
			{"who": "testigo", "text": "Los detalles los tengo grabados a fuego. Ojalá pudiera borrarlos. Escuche, entonces, y no me interrumpa, que si paro no vuelvo a empezar."}]}]},
	{"who": "testigo", "text": "Al entrar te quitan el nombre y te dan un número, cosido en la bata. Yo era la treinta y uno. Te dan una pastilla para dormir, dicen que es para el descanso: Somnia. Te duermen y te despiertan a horas raras para 'medir'. Luces, agujas, preguntas que no recuerdas haber contestado."},
	{"who": "testigo", "text": "Los que respondían 'bien' seguían arriba, dóciles, sonrientes, apagados. A los que no... a los que nos removíamos, nos poníamos difíciles, se nos llevaban de noche. Una camilla, un pasillo, una puerta al fondo. Nunca vi volver a nadie por esa puerta. Yo salí de una de esas noches, treinta y una, descalza, por la ventana del office. Corriendo hacia la única luz del valle."},
	{"who": "detective", "text": "(Los numeraban. Les quitaban el nombre para que doliera menos firmar la cruz. Y esta mujer, la treinta y uno, es la única que se salió del papel y bajó a contarlo.)", "side": "right"},
	{"who": "detective", "text": "Irene, escúchame bien. A partir de ahora no estás sola en esto. Todo lo que acabas de decir es exactamente lo que llevo meses sin poder probar. Tú eres la prueba."}], "revisit": "Irene, la superviviente, cuenta desde dentro cómo funciona el sanatorio. Un testigo de oro."},
"fin15": {"bg": "sanatorio_montana", "flag": "cap15_completo", "clue": {"title": "El testimonio vivo", "text": "Con la superviviente y las muestras, hay por fin un testigo humano contra el proyecto Somnia."}, "beats": [
	{"who": "narrador", "text": "Antes del alba, un coche camuflado saca a Irene del pueblo envuelta en una manta térmica, con Núñez esperándola abajo, lejos de cualquier mano de Nyxos. Arriba, el sanatorio ya olía la redada: lo evacuaron a toda prisa. Pero la prisa, otra vez, deja restos."},
	{"who": "narrador", "text": "Entre las habitaciones vacías quedan batas con números cosidos, hojas de 'medición', un frigorífico industrial con viales ámbar y la serpiente impresa, y una puerta al fondo del pasillo con un cerrojo por fuera. La puerta que Irene describió sin haberla vuelto a ver."},
	{"who": "detective", "text": "Todo encaja con su relato palabra por palabra. Los números, las dosis, la puerta de un solo sentido. Un testigo vivo que cuenta el método desde dentro, y una casa entera que le da la razón."},
	{"choices": [
		{"text": "Pensar en todos los números sin nombre", "then": [
			{"who": "detective", "text": "(La treinta y uno salió corriendo. ¿Y del uno al treinta? ¿Y del treinta y dos en adelante? Cada bata doblada en ese armario fue una persona a la que le quitaron hasta el nombre.)", "side": "right"},
			{"who": "detective", "text": "Irene sobrevivió para que las demás cuenten, aunque ya no puedan. Voy a hacer que su voz valga por todas las que se callaron tras esa puerta."}]},
		{"text": "Blindar el testimonio antes que nada", "then": [
			{"who": "detective", "text": "Lo primero es blindarla. Declaración grabada, forense que certifique que está lúcida, custodia de cada vial y cada bata. Que ningún abogado de mil euros la hora pueda volver a decir la palabra 'delira'."},
			{"who": "nunez", "text": "Ya está en marcha, detective Vega. Sonia le hará el informe médico y Clara le prepara la declaración blindada. Esta vez la loca del pueblo se sube al estrado con toda la casa de testigos detrás."}]}]},
	{"who": "detective", "text": "Un testigo humano, vivo y en su sano juicio, contra el proyecto Somnia. Documentos, viales, habitáculos con cerrojo por fuera. La palabra 'delira' ya no funciona contra esto. Ahora funciona la palabra 'Irene'."}], "revisit": "Irene es el testigo vivo que rompe la coartada de Nyxos. Está a salvo."},
"cierre15": {"bg": "comisaria", "flag": "done_cierre15", "beats": [
	{"who": "narrador", "text": "En la comisaría, con el radiador a tope y el café humeante, la declaración de Irene descansa sobre la mesa, firmada y grabada. Fuera sigue nevando el norte. Núñez la lee entera, despacio, y al terminar deja el papel como quien deja algo sagrado."},
	{"who": "detective", "text": "Tenemos superviviente lúcida, muestras, historiales y un patrón que se repite ciudad tras ciudad. Por fin una voz que aguanta un juicio."},
	{"who": "nunez", "text": "Y por eso mismo, prepárese. En cuanto esto salga, Nyxos dirá que el sanatorio era cosa de una 'filial rebelde'. Un capataz que se pasó de la raya. Casos aislados. La manzana podrida de siempre."},
	{"who": "detective", "text": "La franquicia loca que actuó por su cuenta. Lo veo venir. Cortan la rama y salvan el árbol."},
	{"who": "nunez", "text": "Entonces hay que probar que no es una rama: que es la MISMA mano en sitios distintos. Los mismos formularios, los mismos números, el mismo Somnia. Hay una filial de Nyxos en otra ciudad. Vaya, compare, y ate el nudo nacional."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 15 —  Por fin una voz que sobrevivió a la nieve. Y el mapa de Nyxos, lejos de cerrarse, se abre hacia otras ciudades."}]},

# --- Cap. 16 · La otra ciudad ---
"brief16": {"bg": "comisaria", "flag": "done_brief16", "beats": [
	{"who": "narrador", "text": "Cinco de la mañana. Sobre el mapa de la comisaría, Núñez ha clavado una chincheta nueva, cuatrocientos kilómetros al norte. Un hilo rojo la une con la ciudad de Nora, y el hilo tiembla cada vez que pasa un camión por la calle."},
	{"who": "nunez", "text": "La filial de Nyxos en la capital del norte, detective Vega. Llevo una semana pidiendo sus registros por lo bajo. Y me da miedo lo que veo: si esa filial opera igual que la de aquí, esto ya no es una ciudad podrida. Es un país."},
	{"who": "detective", "text": "Otra ciudad, la misma serpiente. Siempre pensé que subíamos por una escalera y resulta que subíamos por un ascensor con muchas plantas idénticas."},
	{"who": "nunez", "text": "Por eso no va sola. Clara la acompaña, por lo legal. Un paso en falso a cuatrocientos kilómetros de su placa y no la saca de allí ni Dios."},
	{"who": "detective", "text": "(Clara. Ocho horas de coche con Clara. Preferiría el interrogatorio de Adler.)", "side": "right"},
	{"choices": [
		{"text": "«Voy a por pruebas, no a hacer amigos.»", "then": [
			{"who": "detective", "text": "Voy a mirar sus papeles, Núñez. Si son los mismos formularios que aquí, los fotografío y me largo. No pienso simpatizar con nadie del norte."},
			{"who": "nunez", "text": "Así me gusta. Fría y rápida. Pero recuerde: allí usted no es la ley, es una turista con demasiadas preguntas. Dígalo con Clara delante siempre."}]},
		{"text": "«Si es la misma empresa, la tumbamos entera.»", "then": [
			{"who": "detective", "text": "Si demuestro que allí usan mi mismo protocolo, con mis mismos códigos, ya no persigo una filial: las persigo a todas de un tirón. Vale la pena el viaje."},
			{"who": "nunez", "text": "Eso es pensar en grande. Solo le pido que piense también en volver. Esta gente, cuando huele que quieres tirar la casa entera, deja de ser educada."}]}]},
	{"who": "detective", "text": "Otra ciudad, la misma serpiente. Vamos."}], "revisit": "La filial de Nyxos en otra ciudad. Si opera igual, es una trama nacional."},
"l16a": {"bg": "ciudad2", "flag": "done_l16a", "clue": {"title": "La franquicia", "text": "La filial del norte usa idénticos protocolos, formularios y códigos: es la misma organización."}, "beats": [
	{"who": "narrador", "text": "La otra ciudad es más gris, más grande, más fría. La lluvia cae aquí más recta, sin viento, como si hasta el clima tuviera prisa. Rascacielos distintos, avenidas más anchas, más solas. Y en el centro, coronando una plaza de granito mojado, otra torre de Nyxos con el mismo neón enfermo latiendo en lo alto: la serpiente en la copa, verde veneno contra el cielo de plomo."},
	{"who": "clara", "text": "Sabes lo que me revienta de esta ciudad, Nora? Que no me da miedo. Es demasiado ordenada para dar miedo. Y lo ordenado, en este caso, es lo que asusta de verdad."},
	{"who": "detective", "text": "Pedí ver un expediente de admisión en su balneario del norte, con una excusa. Míralo. Mismo formulario. Mismos campos. Mismo código de proyecto arriba, a la derecha, con la misma tipografía diminuta."},
	{"who": "narrador", "text": "Extiendes junto al papel una foto que sacaste en el sanatorio de tu ciudad. Los dos documentos, uno al lado del otro sobre el capó del coche bajo la llovizna, son gemelos. Cambia la dirección. Nada más."},
	{"who": "detective", "text": "Mismos formularios, mismos códigos de proyecto, mismo «notario» inexistente firmando abajo. No es una imitación: es la misma empresa copiándose a sí misma. Un calco. Una franquicia del horror."},
	{"who": "clara", "text": "Y eso, Nora, legalmente es la mina de oro. Una imitación se defiende: cada quien responde de lo suyo. Pero si demuestro que los protocolos son idénticos y bajan centralizados, del mismo sitio, entonces caen todos a la vez. No filial por filial, en diez juicios de diez años. Todos. De golpe."},
	{"who": "detective", "text": "(La miro explicarlo y por un segundo recuerdo por qué me enamoré de ella. Se le encienden los ojos con la ley como a mí con una puerta que ceder. Somos la misma clase de perro, cada uno mordiendo su hueso.)", "side": "right"},
	{"who": "detective", "text": "Entonces dejamos de fotografiar ciudades y empezamos a fotografiar el cordón que las une. Enséñame de dónde bajan estos papeles."}], "revisit": "La filial del norte es idéntica: misma organización, no una copia. Trama nacional."},
"rh16": {"bg": "puesto_policia", "flag": "done_rh16", "clues": [
	{"title": "El policía local", "text": "Se ofrece con prisa; honrado pero perdido, ni topo ni ayuda útil.", "false": true},
	{"title": "El taxista", "text": "Dice conocer 'todos los secretos'; solo conoce todos los atascos.", "false": true},
	{"title": "El político local", "text": "Promete colaborar ante las cámaras; desaparece cuando se apagan.", "false": true},
	{"title": "El detective privado", "text": "Vende un dossier sobre Nyxos; son recortes de periódico viejos.", "false": true},
	{"title": "La empleada resentida", "text": "Odia a la filial; por un ascenso negado, no por los crímenes.", "false": true}], "beats": [
	{"who": "narrador", "text": "El puesto de policía del distrito huele a café de máquina y a suelo recién fregado con lejía. En una ciudad nueva, donde nadie sabe quién eres, todos quieren venderte algo. En una hora, cinco supuestos aliados se acercan a Nora como polillas a la única bombilla forastera. Clara los recibe uno a uno y los pesa con ojo de abogada."},
	{"who": "clara", "text": "Vamos a jugar a mi juego preferido, Nora: descartar. El policía local se ofrece con prisa, honrado y perdido; sabe menos del caso que nosotras y encima nos frenaría. Ni topo ni ayuda: lastre bienintencionado."},
	{"who": "detective", "text": "El taxista jura que conoce todos los secretos de la ciudad. Lo único que conoce de verdad son todos los atascos. Y el político local promete el cielo delante de una cámara y se evapora en cuanto se apaga la luz roja."},
	{"who": "clara", "text": "Añade al detective privado que me quiere vender un dossier sobre Nyxos: recortes de periódico viejos que hasta yo tengo archivados. Y la empleada resentida, que odia a la filial. Pero la odia por un ascenso que le negaron, no por lo que hacen. Rabia de nómina, no de conciencia. En un juzgado no vale nada."},
	{"who": "detective", "text": "Cinco puertas y detrás de cada una, aire. Ruido de ciudad nueva, gente que huele forastera con dinero y acude. Nada sólido."},
	{"who": "clara", "text": "Lo sólido no charla, Nora. Lo sólido está impreso. Son los protocolos idénticos que atan esta filial a la casa madre. Un papel no cobra, no exagera, no se raja en el estrado. Persigamos el papel."}], "revisit": "Cinco aliados de pega. Lo sólido son los protocolos que atan la filial a la central."},
"l16b": {"bg": "ruta_clara", "flag": "done_l16b", "clue": {"title": "El patrón nacional", "text": "Clara ata las filiales a una única sede central: todas dependen del consejo de Nyxos."}, "beats": [
	{"who": "narrador", "text": "Un juzgado prestado, cedido a Clara por un colega que le debe favores. La sala de vistas está vacía y a media luz, y sobre la mesa alargada Clara despliega un organigrama enorme, dibujado a mano y corregido mil veces, que ha tardado semanas en levantar. Líneas, cajas, flechas. Un árbol de raíces enfermas."},
	{"who": "clara", "text": "Mira esto despacio, que me ha costado el sueño de un mes. Cada filial, cada balneario, cada sanatorio, cada clínica fantasma como la de tu hermano: todo cuelga de aquí arriba. De la misma sede central. Las órdenes, el dinero y el «protocolo Somnia» bajan de un único consejo. Doce sillas."},
	{"who": "detective", "text": "Entonces todo este tiempo he estado dando puñetazos a las ramas. Y la cabeza es una sola, con doce sillas y un logo."},
	{"who": "narrador", "text": "Sigues con el dedo una de las líneas, de una ciudad cualquiera hasta la caja de arriba. Todas las líneas mueren en el mismo punto. No hay una sola rama suelta. No hay filial rebelde. Es un cuerpo con un solo corazón."},
	{"choices": [
		{"text": "«Gracias, Clara. De verdad.»", "then": [
			{"who": "detective", "text": "No sé cómo agradecerte esto. Un mes sin dormir por un caso que ni siquiera es tuyo. Gracias, Clara. De verdad."},
			{"who": "clara", "text": "No lo hago por ti, Nora, que lo sepas. Lo hago porque he leído esos expedientes de admisión y no puedo dormir sabiendo lo que firmaba esa gente sin entenderlo. Que me sirvas para algo es casualidad."},
			{"who": "detective", "text": "(Miente fatal cuando quiere sonar dura. Siempre lo hizo. Y yo siempre se lo dejé pasar.)", "side": "right"}]},
		{"text": "«¿Por qué te metes en esto, Clara?»", "then": [
			{"who": "detective", "text": "Podrías estar cobrando fortunas defendiendo a esta misma gente, Clara. Eres la mejor. ¿Por qué te pones del otro lado, conmigo, gratis y de noche?"},
			{"who": "clara", "text": "Porque hace catorce meses me fui de tu casa jurando que no me arruinarías la vida con tus muertos. Y resulta que los tuyos me quitan el sueño más que mis vivos. Enhorabuena. Ganaste tú, como siempre."},
			{"who": "detective", "text": "No he ganado nada. Solo tengo un organigrama y una deuda contigo que no sé pagar."}]}]},
	{"who": "clara", "text": "Deja los sentimientos para el viaje de vuelta. Céntrate: por primera vez tienes cómo llevarlos a todos ante un juez a la vez. Solo te falta una cosa. Entrar en esa sede central, coger un papel firmado arriba del todo... y que no te compren o te maten antes de sacarlo."}], "revisit": "Todas las filiales dependen de un único consejo central. Clara lo ha probado."},
"fin16": {"bg": "sede_regional", "flag": "cap16_completo", "clue": {"title": "Una sola cabeza", "text": "Documentos de la filial confirman que el proyecto Somnia es nacional y centralizado en la sede de Nyxos."}, "beats": [
	{"who": "narrador", "text": "La sede regional del norte es un vestíbulo de mármol frío y ascensores silenciosos, tan pulcro que hasta la lluvia parece pedir permiso para entrar. Con una orden firmada por el juez de Clara en la mano, un archivero pálido te abre, contra su voluntad, el armario de las circulares internas. Carpetas grises, cientos, ordenadas por trimestre."},
	{"who": "detective", "text": "No me hace falta leerlas todas. Solo el membrete."},
	{"who": "narrador", "text": "Sacas una al azar. Y otra. Y otra de un año distinto, de un asunto distinto. En todas, arriba, la misma línea impresa: «Dirección Central — Consejo». La misma firma escaneada. La misma serpiente diminuta en la esquina."},
	{"choices": [
		{"text": "Fotografiar y cotejar con las circulares de su ciudad", "then": [
			{"who": "detective", "text": "Cadena de custodia. Primero foto de cada una, luego las coteja Clara con las que saqué en mi ciudad. Que ningún abogado pueda decir que las mezclé."},
			{"who": "clara", "text": "Idénticas, Nora. Palabra por palabra, salvo la dirección del pie. La misma orden bajó a tu ciudad y a esta el mismo día. Esto ya no lo entierra nadie."}]},
		{"text": "Buscar una circular sobre el protocolo Somnia", "then": [
			{"who": "narrador", "text": "Tus dedos encuentran una carpeta más gruesa: «Fase clínica — sujetos». Dentro, instrucciones de dosis, criterios de «baja», y el mismo pie de firma. La misma cruz en el margen de algunos nombres que ya viste en el archivo de tu hermano."},
			{"who": "detective", "text": "La misma mano que firmó lo de Diego firmó esto, a cuatrocientos kilómetros, para gente que no conozco. Una sola pluma para todo el país.", "side": "right"},
			{"who": "clara", "text": "Respira. Y no la sueltes. Esa carpeta es la soga entera, Nora. Solo hay que subir hasta el cuello que la sostiene."}]}]},
	{"who": "detective", "text": "Circulares nacionales. La misma firma para toda España. Ya no hay «filial rebelde» que valga: es la casa madre. La franquicia entera nace de una sola oficina."},
	{"who": "detective", "text": "Tengo el patrón nacional atado. Solo falta subir a la cima real y ponerle rostro a esas doce sillas."}], "revisit": "Las circulares nacionales de Nyxos vienen todas de la misma dirección central."},
"cierre16": {"bg": "comisaria", "flag": "done_cierre16", "beats": [
	{"who": "narrador", "text": "De vuelta en casa, la lluvia conocida vuelve a tener viento. Sobre la mesa de Nora, el organigrama de Clara y las circulares del norte, sujetos con un cenicero. Núñez los mira largo rato antes de hablar, y cuando lo hace, no levanta la voz."},
	{"who": "detective", "text": "Es una sola cabeza para todo el país, Núñez. Doce sillas, una firma, un protocolo. Y en cuanto sepan que lo sé, van a dejar de jugar limpio conmigo."},
	{"who": "nunez", "text": "Ya lo están jugando. Mientras usted volvía, llegó esto a jefatura. Han pedido una reunión «privada» con usted. Traje caro, sonrisas y un cheque de esos que se firman despacio. Vaya, detective Vega, y escuche mucho. Pero no firme nada. Nada."},
	{"who": "detective", "text": "(Primero intentaron enterrarme el caso. Luego asustarme. Ahora que no pueden, sacan la cartera. Es casi un halago.)", "side": "right"},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 16 —  Nyxos es una sola cabeza nacional. Y esa cabeza acaba de invitar a Nora a negociar."}]},

# --- Cap. 17 · La compra ---
"brief17": {"bg": "comisaria", "flag": "done_brief17", "beats": [
	{"who": "narrador", "text": "La comisaría a medianoche huele a café quemado y a lluvia colada por las juntas de las ventanas. Núñez deja sobre la mesa de Nora un estuche pequeño, negro, del tamaño de un mechero, y no aparta la mano de él enseguida."},
	{"who": "nunez", "text": "Escúcheme bien, que esto lo he visto otras veces y nunca acaba como usted cree. Cuando alguien como Nyxos no puede matarla sin hacer ruido, no se rinde: cambia de arma. Ya no mandan un coche sin luces a la salida del turno. Mandan un abogado con una carpeta y una sonrisa cara."},
	{"who": "detective", "text": "O sea, que he subido de categoría. De estorbo a inversión."},
	{"who": "nunez", "text": "No se ría, que es peor. A un estorbo lo apartan. A una inversión la compran, y si no se deja comprar, la amortizan. La reunión es esta noche, en el reservado del bar de Clara. Lleve esto encima."},
	{"who": "narrador", "text": "Empuja el estuche los últimos centímetros. Dentro, un micro del tamaño de una lenteja y un clip para la solapa."},
	{"who": "detective", "text": "Un micro. Muy analógico para lo que se juega."},
	{"who": "nunez", "text": "Lo analógico no se hackea ni se apaga desde un despacho. Y una cosa más, detective Vega, y por eso he insistido en dárselo yo en persona: quien la recibe es alguien que usted conoce."},
	{"who": "detective", "text": "¿Alguien que conozco? Vaya. Estos no fallan un solo detalle. Saben que a una cara conocida cuesta más decirle que no.", "side": "right"},
	{"choices": [
		{"text": "«Voy a dejar que hablen. Todo. Y que se graben solos.»", "then": [
			{"who": "detective", "text": "No voy a discutir con ellos, Núñez. Voy a dejarles hablar. Cuanto más ofrezcan, más largo queda el cabo con el que colgarlos. Yo solo tengo que sonreír y no tocar la carpeta."},
			{"who": "nunez", "text": "Esa es la detective Vega que necesito esta noche. Fría. La otra, la que rompe la mesa de un puñetazo, se la deja aquí guardada."}]},
		{"text": "«¿Y si la cara conocida me hace dudar?»", "then": [
			{"who": "detective", "text": "¿Y si me sientan delante a alguien a quien no puedo mirar mal? No todos los que trabajan para esta gente firmaron sabiendo lo que firmaban."},
			{"who": "nunez", "text": "Entonces se acuerda de las camillas con correas y del nombre de su hermano en una carpeta. Con eso vuelve a ver claro enseguida. Vaya, y grábelo todo."}]}]},
	{"who": "detective", "text": "Está bien. A que me compren. Nunca resolví nada sola; a lo mejor esta noche me resuelven ellos el caso a base de ofrecerme demasiado."}], "revisit": "Nyxos quiere comprarme. La reunión es esta noche, con una cara conocida."},
"l17a": {"bg": "bar_clara", "flag": "done_l17a", "clue": {"title": "La oferta", "text": "Nyxos ofrece a Nora dinero y un ascenso a cambio de 'reorientar' la investigación."}, "beats": [
	{"who": "narrador", "text": "El bar de Clara a esa hora es penumbra de terciopelo y hielo tintineando en vasos ajenos. En el reservado del fondo, la luz de una lámpara baja lo recorta todo: una carpeta cerrada sobre la mesa, dos copas que nadie ha tocado y un hombre de traje impecable que ya estaba sentado antes de que existiera el problema."},
	{"who": "sospechoso", "text": "Detective Vega. Siéntese, por favor. Le he pedido un rioja que le va a gustar, aunque intuyo que esta noche va a beber poco. Represento a un cliente que admira su trabajo. De verdad lo admira."},
	{"who": "detective", "text": "Déjeme adivinar el resto. Una cifra con muchos ceros, un cargo bonito y el consejo amable de que, a partir de mañana, mire hacia otro lado."},
	{"who": "narrador", "text": "El hombre sonríe como quien ha oído esa frase cien veces y siempre acaba ganando. Empuja la carpeta un dedo hacia ella, sin abrirla, como se ofrece un caramelo a un niño desconfiado."},
	{"who": "sospechoso", "text": "Qué visión tan pobre tiene de nosotros. No queremos que mire hacia otro lado. Queremos que mire mejor. Una jefatura nacional, detective. Su propia unidad, su presupuesto, su equipo elegido a dedo. Recursos que en esta comisaría de goteras no verá ni jubilándose."},
	{"who": "detective", "text": "¿Y a cambio de tanto amor?"},
	{"who": "sospechoso", "text": "A cambio de que reoriente su investigación. Hay culpables, detective, siempre los hay. Solo pedimos que sean los culpables adecuados. Gente más... manejable. Un par de mandos intermedios que ya han dejado de sernos útiles. Se los servimos en bandeja, con pruebas, con confesión. Usted cierra el caso del año y sube. Todos ganan."},
	{"who": "detective", "text": "Culpables manejables. Es decir, carne de usar y tirar, igual que la gente que metieron en sus camillas. Ustedes no cambian de método ni para sobornar a un policía: siempre alguien prescindible pagando por los de arriba."},
	{"who": "sospechoso", "text": "Lo llama usted feo. Yo lo llamo eficiencia. Piénselo despacio. La carpeta contiene la cifra. No hace falta que la abra ahora."},
	{"who": "detective", "text": "No la voy a abrir nunca. Pero siga, se lo ruego, que lo está haciendo usted muy bien. Explíquemelo todo otra vez, con calma, con nombres. Que lo estamos disfrutando los dos.", "side": "right"},
	{"who": "detective", "text": "Tres cosas, letrado. Una: no. Dos: no con más ceros. Y tres, la importante: la lenteja que llevo en la solapa lleva grabándole desde el «siéntese, por favor». Gracias por el rioja."}], "revisit": "Nyxos me ofreció una jefatura por 'reorientar' el caso. Lo grabé."},
"rh17": {"bg": "despacho_abogado", "flag": "done_rh17", "clues": [
	{"title": "El abogado mensajero", "text": "Hace la oferta pero es un bufete externo: lee guiones ajenos, no manda.", "false": true},
	{"title": "El relaciones públicas", "text": "Endulza la propuesta; maquilla, no decide.", "false": true},
	{"title": "El testaferro", "text": "Firma cuentas de Nyxos; una firma alquilada, sin idea del proyecto.", "false": true},
	{"title": "El guardaespaldas", "text": "Trae la amenaza velada; músculo a sueldo, no cerebro.", "false": true},
	{"title": "El asesor de imagen", "text": "Propone 'reconducir el relato'; vanidad corporativa, no una pista.", "false": true}], "beats": [
	{"who": "narrador", "text": "Para comprar a una persona con dignidad, Nyxos no manda a uno: manda a cinco. En las horas que siguen desfilan por el reservado, uno tras otro, cinco emisarios de guante blanco. Nora los deja hablar a todos y a todos les encuentra la costura por donde se descosen."},
	{"who": "detective", "text": "El abogado del traje caro solo lee un guion que le han escrito: si le pregunto quién decide, se le apaga la sonrisa. Un mensajero con colonia."},
	{"who": "detective", "text": "El de relaciones públicas endulza la cifra con palabras de folleto: maquilla el veneno, no lo fabrica. El testaferro que firma las cuentas ni sabe qué es Somnia; alquila su nombre por una nómina y una firma."},
	{"who": "detective", "text": "El guardaespaldas trae la parte fea, la amenaza dicha bajito: músculo a sueldo, cero cabeza. Y el asesor de imagen me propone, tan tranquilo, «reconducir el relato». Vanidad de empresa, no una pista."},
	{"who": "detective", "text": "Cinco caras, cinco máscaras de la misma cara que no da la cara. Ninguno decide nada. Ninguno me sirve para subir.", "side": "right"},
	{"who": "detective", "text": "Pero entre tanto guante blanco hay un uniforme viejo que conozco. Uno de dentro, de seguridad, que sí puede abrirme la puerta hacia los que deciden de verdad. Marco. Y esta noche Marco tiene mala cara: la cara del que está a punto de elegir bando."}], "revisit": "Cinco emisarios, cinco máscaras. La puerta a los que deciden me la abre Marco."},
"l17b": {"bg": "oficina", "flag": "done_l17b", "clue": {"title": "El chantaje a Nora", "text": "Ante tu negativa, Nyxos amenaza a Diego; Marco, asqueado, decide ayudarte desde dentro."}, "beats": [
	{"who": "narrador", "text": "En cuanto Nora dice que no por última vez, la sonrisa del letrado se cae como una máscara mal pegada. Recoge la carpeta sin prisa y, al ponerse el abrigo, deja caer la frase como quien no quiere la cosa."},
	{"who": "sospechoso", "text": "Es una pena, detective. Piense en su hermano antes de dormir. Diego, ¿verdad? La salud es tan frágil a su edad... Sería terrible que una recaída se lo llevara justo ahora que usted está tan ocupada."},
	{"who": "detective", "text": "(Ahí está. El puño dentro del guante. No han tardado ni diez segundos en pasar del soborno a la amenaza. Y han ido directos a lo único que me duele.)", "side": "right"},
	{"who": "narrador", "text": "Sale a un pasillo de servicio, entre cajas y neones parpadeantes, con el corazón golpeando de rabia más que de miedo. Y en la penumbra, apoyado en la pared como quien lleva un rato decidiéndose, la espera Marco. Uniforme de seguridad de Nyxos. Cara de no haber dormido."},
	{"who": "marco", "text": "Nora. Lo he oído todo por el pinganillo del servicio. Lo de tu hermano. Yo... llevo meses mirando para otro lado en esa sede porque me pagan por no mirar. Pero esto no. A la familia no."},
	{"who": "detective", "text": "Marco. Tú aquí. Claro que la cara conocida eras tú."},
	{"who": "marco", "text": "Entré por un sueldo, Nora. Custodiar puertas, no vender a la hermana de nadie. Cuando firmé no sabía lo que había detrás de esas puertas. Ahora lo sé. Y ya no puedo hacer como que no."},
	{"choices": [
		{"text": "«Ayúdame desde dentro, Marco. Es la única forma.»", "then": [
			{"who": "detective", "text": "Entonces ayúdame desde dentro. Es la única manera de proteger a Diego y de tumbarlos a la vez. Yo sola no entro en esa sede ni con orden; contigo, a lo mejor, sí."},
			{"who": "marco", "text": "Ya contaba con que me lo pedirías. Y ya contaba con decir que sí."}]},
		{"text": "«No te pido que te quemes por mí, Marco.»", "then": [
			{"who": "detective", "text": "No he venido a pedirte que te juegues el cuello por mí. Si me ayudas y te pillan, eres hombre muerto. No cargo con eso."},
			{"who": "marco", "text": "No lo haces tú, lo hago yo. Y no es por ti, es por mí. Por poder mirarme al espejo mañana. Déjame elegir bien por una vez, Nora."}]}]},
	{"who": "narrador", "text": "Marco saca una tarjeta blanca sin logo y un papel doblado en cuatro. Le tiemblan un poco las manos al ponérselos en la palma, como el que suelta algo que ya no va a poder recuperar."},
	{"who": "marco", "text": "Mi tarjeta de acceso. Y los turnos de seguridad de la sede central, semana entera, con los relevos y los puntos ciegos de las cámaras. Si descubren que ha salido de mí, soy hombre muerto, sin más. Pero prefiero eso a seguir siendo su perro. Por los viejos tiempos, Nora."},
	{"who": "detective", "text": "Por los viejos tiempos, Marco. No lo voy a desperdiciar. Y no vas a estar solo en esto: cuando caigan, caen ellos, no tú."}], "revisit": "Nyxos amenaza a Diego. Marco, harto, me da acceso a la sede central desde dentro."},
"fin17": {"bg": "oficina", "flag": "cap17_completo", "clue": {"title": "No se venden todos", "text": "La grabación de la oferta y el chantaje, más el acceso de Marco, abren la puerta a la sede central."}, "beats": [
	{"who": "narrador", "text": "Nora sale del edificio a una calle que la lluvia ha vuelto un espejo negro. En el bolsillo interior lleva tres cosas que valen más que la cifra de aquella carpeta: la grabación de la oferta, la grabación de la amenaza a Diego y la tarjeta blanca de Marco todavía tibia de su mano."},
	{"who": "detective", "text": "Primero intentaron comprarme. Luego, cuando vieron que no, intentaron asustarme por Diego. Ninguna de las dos les ha funcionado. Y por el camino me han regalado, sin querer, lo único que jamás me habrían dado por las buenas."},
	{"choices": [
		{"text": "Pensar en Marco, en la lealtad vieja", "then": [
			{"who": "detective", "text": "(Marco ha vuelto a ser policía por una noche, después de años de no serlo. Le ha costado el sueldo, puede que el cuello. La gente decente no se ha muerto del todo; solo estaba escondida esperando a que alguien le diera una razón.)", "side": "right"},
			{"who": "detective", "text": "No pienso desperdiciar lo que me ha dado. Se lo debo. Y se lo debo a Diego."}]},
		{"text": "Pensar en lo que acaban de demostrar de sí mismos", "then": [
			{"who": "detective", "text": "(Una empresa que soborna y, en el mismo aliento, amenaza a un enfermo para callar a su hermana. Ya sé exactamente qué son. Lo he tenido grabado en la solapa toda la noche.)", "side": "right"},
			{"who": "detective", "text": "La integridad no estaba en venta. Resulta que era lo único que no podían comprar, y por eso la necesitan muerta."}]}]},
	{"who": "detective", "text": "Una llave de su propia casa. Eso es lo que tengo ahora. La sede central de Nyxos, con los turnos, los relevos y los puntos ciegos. Hora de subir hasta donde se sientan los que deciden."}], "revisit": "Rechacé la compra y conseguí, vía Marco, acceso a la sede central de Nyxos."},
"cierre17": {"bg": "comisaria", "flag": "done_cierre17", "beats": [
	{"who": "narrador", "text": "En la comisaría, Nora deja sobre la mesa de Núñez la grabadora y la tarjeta blanca, una al lado de la otra, como dos cartas ganadoras. Fuera, la lluvia por fin afloja."},
	{"who": "detective", "text": "Tengo acceso a la sede central y tengo su voz confesándolo todo: el soborno, la jefatura, la amenaza a mi hermano. Intentaron comprarme y se les cayó la máscara solos. Es hora de subir al consejo."},
	{"who": "nunez", "text": "Con cuidado, detective Vega. Ahí arriba ya no hay recaderos ni matones de pasillo: están los que deciden. Y los que deciden no perdonan que alguien entre en su casa sin llamar a la puerta."},
	{"who": "detective", "text": "Precisamente por eso tengo una llave. No pienso llamar."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 17 —  No pudieron comprar a Nora. Y un viejo amigo, harto de ser el perro de alguien, le ha abierto la puerta del consejo."}]},

# --- Cap. 18 · El consejo ---
"brief18": {"bg": "comisaria", "flag": "done_brief18", "beats": [
	{"who": "narrador", "text": "Las tres de la madrugada en la comisaría. Sobre la mesa, la tarjeta de acceso de Marco brilla bajo el flexo como una moneda robada. Núñez la mira sin tocarla, igual que se mira una granada con la anilla floja."},
	{"who": "nunez", "text": "Con esa tarjeta puede entrar esta noche en la sede central de Nyxos. Pero óigame bien, detective Vega: no busque un despacho, ni un ordenador, ni una caja fuerte con billetes. Busque un papel. El acta del consejo donde se aprobó Somnia."},
	{"who": "detective", "text": "Un acta. Con lo que he visto ahí abajo, en los sótanos, en la carne de mi hermano, y usted me manda a por una hoja mecanografiada."},
	{"who": "nunez", "text": "Esa hoja vale más que mil testigos, y usted lo sabe. Un testigo se retracta, se compra, aparece flotando en el río. Un acta firmada por doce manos con nombre y apellido no se retracta. Es piedra."},
	{"who": "detective", "text": "Piedra que hunde a los de arriba, no a los peones. Los que aprietan el botón desde una silla con reposabrazos. Esos nunca se manchan; solo firman."},
	{"choices": [
		{"text": "«Entro limpia, solo a fotografiar.»", "then": [
			{"who": "detective", "text": "No toco nada, Núñez. Entro, fotografío cada página, salgo. Lo que traiga tiene que aguantar de pie ante un juez, no caerse por como lo cogí."},
			{"who": "nunez", "text": "Así se habla. La foto es suya, el original que se quede donde está. Y a las cinco quiero saber que ha salido de ahí con los dos pies."}]},
		{"text": "«¿Y si el acta ni existe?»", "then": [
			{"who": "detective", "text": "¿Y si son más listos que eso, Núñez? ¿Y si nunca lo pusieron por escrito?"},
			{"who": "nunez", "text": "Existe. Esta gente lo apunta todo, detective Vega. Necesitan repartir la culpa por escrito para que ninguno cargue con ella entera. Su vanidad burocrática es su talón de Aquiles. Vaya a buscarlo."}]}]},
	{"who": "detective", "text": "El acta que lo firma todo. A la sede de Nyxos, entonces. Con la tarjeta de Marco y sin hacer ruido.", "side": "right"}], "revisit": "Necesito el acta del consejo donde se aprobó Somnia. Con la tarjeta de Marco, entro."},
"l18a": {"bg": "oficina", "flag": "done_l18a", "clue": {"title": "El acta secreta", "text": "En la sede, un acta reservada aprueba el 'Proyecto Somnia' con presupuesto para 'gestión de sujetos'."}, "beats": [
	{"who": "narrador", "text": "De madrugada, la sede de Nyxos es una catedral de cristal apagada. La tarjeta de Marco parpadea en verde en cada torno y las puertas se abren solas, sin un guardia, como si el edificio entero te esperase. Subes en un ascensor de espejos hasta la planta noble."},
	{"who": "narrador", "text": "La sala del consejo huele a cera de muebles y a moqueta cara, esa que absorbe los pasos y las conciencias. Al fondo, un archivo blindado con teclado. Marco te dio también el código: seis dígitos y un chasquido metálico."},
	{"who": "detective", "text": "Carpetas de piel, lomos numerados, todo ordenado como en una notaría. El mal aquí no huele a sangre. Huele a ambientador de cítricos y a papel bueno.", "side": "right"},
	{"who": "narrador", "text": "Pasas los dedos por los lomos hasta que uno se detiene solo: un dossier gris, sin logo, con una pestaña roja. Dentro, mecanografiado y sellado, el documento que Núñez juró que existía."},
	{"who": "detective", "text": "'Acta reservada de la sesión del Consejo de Administración. Punto único del orden del día: aprobación del Proyecto Somnia.' Y aquí, la partida presupuestaria: 'gestión y depuración de sujetos'. Depuración. Escrito con todas las letras."},
	{"who": "detective", "text": "Depurar sujetos. Así llaman a matar personas cuando lo escribes en un renglón con una cifra al lado y un asterisco a pie de página. Le pusieron IVA a mi hermano."},
	{"who": "narrador", "text": "Al pie del acta, una columna de firmas. No garabatos anónimos: nombres completos, cargos, rúbricas de gente que preside galas benéficas y sale en las portadas de las revistas de economía."},
	{"who": "detective", "text": "Aquí está el mal por escrito, con presupuesto y firmas. No un rumor, no un soplo: un acta. Saco el móvil y fotografío cada página, cada firma, cada número. Que no se caiga ni una coma."}], "revisit": "El acta reservada aprueba Somnia con partida para 'depurar sujetos'. Firmada por el consejo."},
"rh18": {"bg": "despacho_consejero", "flag": "done_rh18", "clues": [
	{"title": "El consejero que dimite", "text": "Dimite de golpe simulando arrepentimiento; solo huye para salvarse.", "false": true},
	{"title": "El consejero enfermo", "text": "Alega demencia para no declarar; su firma en el acta es firme y reciente.", "false": true},
	{"title": "El consejero ausente", "text": "Dice que faltó a la reunión clave; el registro prueba que votó.", "false": true},
	{"title": "El consejero 'técnico'", "text": "Se declara mero asesor sin voto; su voto consta como los demás.", "false": true},
	{"title": "El consejero víctima", "text": "Se pinta como coaccionado; cobró primas por cada trimestre del proyecto.", "false": true}], "beats": [
	{"who": "narrador", "text": "La noticia de que hay un acta corriendo por ahí se filtra antes del amanecer, como se filtra todo entre los que tienen algo que perder. Para media mañana, cada consejero ha llamado a su abogado y ensaya, temblando, su coartada particular."},
	{"who": "detective", "text": "Huelen la caída y se pisan unos a otros por ser el primero en decir 'yo no fui'. Vamos a ver cuántas de esas coartadas aguantan un solo empujón contra el papel."},
	{"who": "narrador", "text": "El primero dimite de golpe, con un comunicado lloroso sobre su 'crisis de conciencia'; no se arrepiente, solo corre más rápido que los demás hacia la salida. El segundo, de pronto, alega una demencia que su firma reciente y firme desmiente sola."},
	{"who": "detective", "text": "El tercero jura que faltó a la reunión clave; el registro de asistencia lo sienta en su silla y le pone el voto en la mano. El cuarto se declara 'mero asesor técnico sin voto', pero su voto consta, negro sobre blanco, como los otros once."},
	{"who": "detective", "text": "Y la quinta se pinta de víctima coaccionada, pobrecita, obligada a firmar. Salvo que cobró una prima por cada trimestre que el proyecto siguió en marcha. Nadie coacciona a nadie a ingresar bonus."},
	{"who": "detective", "text": "El que dimite, el 'enfermo', el 'ausente', el 'técnico', la 'víctima'. Cinco excusas distintas para una sola culpa, y todas se estrellan contra el mismo renglón. El acta no escucha coartadas: aprobado. Doce firmas, doce responsables."}], "revisit": "Cinco coartadas de consejeros. El acta unánime no perdona a ninguno."},
"l18b": {"bg": "gestoria", "flag": "done_l18b", "clue": {"title": "La votación del consejo", "text": "El contable, ya testigo, aporta el registro de la votación: el consejo aprobó Somnia por unanimidad."}, "beats": [
	{"who": "narrador", "text": "La gestoría del piso protegido huele a café de sobre y a expedientes viejos. El contable de la vieja trama, el hombre gris que un día te ayudó a hundir a otros, ahora vive con nombre falso y persianas bajadas. Le pones el acta delante y algo en su cara se enciende y se apaga a la vez."},
	{"who": "contable", "text": "Este formato lo conozco de memoria, detective. Yo archivé cientos de actas así. La misma tipografía, el mismo pie de página, el mismo sello en seco. Y para cada acta como esta hay un documento hermano que casi nadie guarda: el registro de la votación."},
	{"who": "detective", "text": "¿Y usted lo tiene?"},
	{"who": "contable", "text": "Yo tengo copias de todo lo que pasó por mis manos. Es lo único que me mantiene vivo. Aquí está. Lo recuerdo como si fuera ayer: se votó por unanimidad. Doce a favor, cero en contra. Ni un solo 'me abstengo'."},
	{"who": "contable", "text": "Aprobaron experimentar con personas como quien aprueba el color de una moqueta. Sin debate, sin una voz temblorosa. Levantaron doce manos, alguien apuntó el resultado, y luego pasaron al café y a las pastas."},
	{"who": "detective", "text": "Unanimidad. Ninguno de los doce puede sentarse ante un juez y decir 'yo me opuse, yo voté en contra'. Es la coartada perfecta al revés: en lugar de un culpable que lo niega, doce culpables que no pueden negarlo.", "side": "right"},
	{"choices": [
		{"text": "«¿Cómo duerme uno después de firmar esto?»", "then": [
			{"who": "detective", "text": "Dígame una cosa. Usted los conoció. ¿Cómo duerme uno por la noche después de levantar la mano para esto?"},
			{"who": "contable", "text": "Duerme de maravilla, detective. Esa es la parte que no entenderá nunca. Cada uno se dice que su mano sola no decidió nada, que fue el consejo, que fue la mayoría, que fue el mercado. Reparten la culpa en doce trozos hasta que ninguno pesa lo suficiente para quitarle el sueño a nadie."},
			{"who": "detective", "text": "Doce trozos de nada que suman una montaña de muertos."}]},
		{"text": "«Con esto los tengo a los doce.»", "then": [
			{"who": "detective", "text": "El acta con las firmas y su registro de la votación. Con las dos cosas los tengo a los doce a la vez. Ninguno se escurre."},
			{"who": "contable", "text": "A los doce, sí. Pero le doy un consejo gratis, de viejo que ha visto caer a muchos: cuando tenga el paquete completo, no vaya a por los doce peones. Vaya a por quien firma en la cabecera. En un consejo siempre hay una silla que pesa más que las once juntas."}]}]},
	{"who": "contable", "text": "Esa es la gracia de un consejo, detective. Reparten la culpa hasta que no pesa en ninguna conciencia. Pero el papel sí pesa. Y ahora el papel lo tiene usted. Cuídelo mejor que ellos cuidaron a sus sujetos."}], "revisit": "El consejo aprobó Somnia por unanimidad: doce culpables, ninguno se opuso."},
"fin18": {"bg": "consejo", "flag": "cap18_completo", "clue": {"title": "Deciden juntos", "text": "El acta más la votación prueban que el consejo entero de Nyxos ordenó el proyecto: no hay un solo culpable, son todos."}, "beats": [
	{"who": "narrador", "text": "Vuelves de madrugada a la sala del consejo, vacía. La mesa de caoba se estira bajo la luz de emergencia, larga como un ataúd para doce. Cuentas las sillas: doce, altas, de respaldo capitoné, cada una con su carpeta de piel esperando a un dueño que ahora tiembla en su casa."},
	{"who": "detective", "text": "Coloco mentalmente cada firma en su silla. Aquí el que dimite, aquí la 'víctima' que cobraba primas, aquí el 'técnico sin voto'. Doce personas normales, con hijos y con hipoteca, sentadas en esta moqueta buena.", "side": "right"},
	{"who": "detective", "text": "No busco un monstruo con nombre, ni un encapuchado, ni un doctor loco. Busco a doce personas que, sentadas en estas sillas, con el café humeando, decidieron que unas cuantas vidas valían menos que una patente. Y ni siquiera discutieron."},
	{"who": "detective", "text": "El acta y la votación lo prueban juntas: lo decidieron juntos, a mano alzada, por unanimidad. Y juntos van a responder. Solo me falta una firma. La de más arriba de todo. La que preside la mesa."},
	{"who": "narrador", "text": "Pasas el dedo por la cabecera de cada acta, ahí donde el resto de firmas se ordenan debajo como súbditos. Un mismo cargo se repite, impreso, en todas las páginas: 'Presidenta del Consejo y Directora Científica'. Y al lado, un solo nombre. Adler."},
	{"who": "detective", "text": "Adler. La que firma arriba y la que diseña la ciencia abajo. Preside la mesa y dirige el laboratorio. La cara entera de Nyxos cabe en esas dos líneas."}], "revisit": "El consejo entero aprobó Somnia por unanimidad. Y lo preside una tal Adler."},
"cierre18": {"bg": "comisaria", "flag": "done_cierre18", "beats": [
	{"who": "detective", "text": "Lo aprobó el consejo entero, los doce, por unanimidad. Y en la cabecera de cada acta, presidiéndolo todo, una tal Dra. Adler. Presidenta del consejo y directora científica. La cara pública de Nyxos."},
	{"who": "nunez", "text": "Adler. La eminencia, la de los premios, la de las portadas y los discursos sobre el futuro de la medicina. La conozco de los periódicos como todo el mundo. Vaya a verla, detective Vega."},
	{"who": "detective", "text": "Por fin un rostro al que mirar a los ojos. Después de meses de sombras, de logos y de siglas, alguien a quien poder decirle a la cara lo que hicieron."},
	{"who": "nunez", "text": "Vaya. Pero llévese una idea puesta y no la suelte: una presidenta no es lo mismo que una dueña. Preside quien pone la firma; manda quien pone el dinero. Y no siempre son la misma persona."},
	{"who": "detective", "text": "¿Insinúa que Adler, con todo su poder, también firma por encargo de alguien?"},
	{"who": "nunez", "text": "Insinúo que mire bien esas dos líneas de la cabecera antes de creer que ha llegado al final. A veces la cara más visible es solo la que ponen delante para que dejemos de buscar. Vaya con cuidado."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 18 —  El consejo entero firmó, doce manos sobre la moqueta buena. Y al frente, un nombre por fin: la Dra. Adler. Aunque una presidenta no es lo mismo que una dueña."}]},

# --- Cap. 19 · La directora ---
"brief19": {"bg": "comisaria", "flag": "done_brief19", "beats": [
	{"who": "narrador", "text": "La orden judicial descansa sobre la mesa de Nora como un cuchillo recién afilado: fría, legal, capaz de abrir la única puerta de Nyxos que nunca se abre. Fuera, la lluvia lame los cristales de la comisaría. Dentro, Núñez le sirve un café que ninguno de los dos va a beber."},
	{"who": "nunez", "text": "La Dra. Adler la recibirá: le encanta que la admiren, aunque sea una detective con una orden. Sáquele todo lo que pueda. Y traiga a su hermano de vuelta si está allí."},
	{"who": "detective", "text": "Adler. La cara de Nyxos. La bata que sale en las portadas, la que da conferencias sobre el sueño mientras dormía a media ciudad para siempre. Y quizá donde tienen a Diego. Voy."},
	{"who": "nunez", "text": "Una cosa, detective Vega. Esa mujer no se parece a los matones que ha esposado hasta ahora. No grita, no amenaza, no se pone nerviosa. Le va a hablar como si le hiciera un favor con cada palabra. No se deje encantar."},
	{"choices": [
		{"text": "«Voy a por ella. Y a por mi hermano.»", "then": [
			{"who": "detective", "text": "Voy con la orden por delante y las manos limpias. Le saco lo que sepa y saco a Diego de ese sitio. En ese orden si puedo, en el otro si hace falta."},
			{"who": "nunez", "text": "En el orden que sea, pero salga entera. Y con papeles, no con astillas."}]},
		{"text": "«¿Y si Diego no está allí?»", "then": [
			{"who": "detective", "text": "¿Y si me planto delante de esa mujer y mi hermano no aparece por ninguna parte? ¿Y si ya es tarde, Núñez?"},
			{"who": "nunez", "text": "Entonces le arranca a ella dónde está. Pero no vaya pensando en un funeral. Vaya pensando en abrir una puerta. Una cada vez."}]}]},
	{"who": "detective", "text": "(He subido peldaño a peldaño toda la temporada: el barrio, la clínica, el laboratorio, el consejo. Y arriba del todo espera una mujer con premios en las paredes. La última cara antes del logo. O eso creo.)", "side": "right"}], "revisit": "La Dra. Adler preside Nyxos. Voy a por ella y a por Diego."},
"l19a": {"bg": "oficina", "flag": "done_l19a", "clue": {"title": "La directora Adler", "text": "Adler defiende Somnia como 'progreso necesario'; se cree por encima del bien y del mal, como Vaultier."}, "beats": [
	{"who": "narrador", "text": "El despacho de la Dra. Adler es blanco, minimalista, lleno de premios. Ni un papel fuera de sitio, ni una mota de polvo, ni una sombra que no esté prevista. Huele a flores caras y a desinfectante, como un quirófano que quisiera pasar por salón. Ella te recibe como una reina que concede audiencia."},
	{"who": "adler", "text": "Detective Vega. La mujer que no se deja comprar. Qué anticuada. Y qué valiosa habría sido para la ciencia. Siéntese. Tiene usted una orden judicial y toda mi atención: es más de lo que consiguen la mayoría de mis accionistas."},
	{"who": "detective", "text": "No he venido a sentarme, doctora. He venido a mirarla a los ojos mientras le nombro a las mujeres que numeraron y depuraron en sus ensayos. La ciencia que apaga cerebros y deja los cuerpos calientes para que hagan bulto. ¿Duerme bien? Ah, no: para eso tienen ustedes su droga."},
	{"who": "adler", "text": "Duermo perfectamente, gracias. Es una de las ventajas de tener la conciencia ordenada por números y no por sentimientos. Los sentimientos, detective, son un lujo que solo se permiten quienes no cargan con decisiones difíciles."},
	{"who": "adler", "text": "Somnia salvará a millones. ¿Qué son unos pocos frente a eso? Todo gran avance se pagó con cuerpos. La anestesia, las vacunas, cada fármaco que hoy le parece un milagro empezó en un cuarto que usted llamaría horror. Yo solo llevo la contabilidad con honestidad científica."},
	{"who": "detective", "text": "La contabilidad. Personas convertidas en asientos de un libro. ¿Y usted firma las bajas con la misma mano con la que recoge esos premios de la pared?"},
	{"who": "adler", "text": "Yo firmo lo que me ponen delante cuando los números cuadran. Ni una firma más, ni una menos. No soy una asesina, detective: soy una directora. Es una distinción que a usted, con su placa y su rabia, se le escapa."},
	{"who": "detective", "text": "(Ahí está. La misma soberbia glacial de Vaultier, pero con bata en vez de esmoquin. Se cree por encima del bien y del mal, un motor del progreso. Y sin embargo... escúchala. 'Firmo lo que me ponen delante.' 'Llevo la contabilidad.' Habla como quien ejecuta, no como quien manda del todo. No ha dicho una sola vez 'yo decido'.)", "side": "right"},
	{"who": "detective", "text": "Le voy a hacer una pregunta rara, doctora. Cuando se aprobó Somnia, cuando se decidió usar personas... ¿quién dijo que sí? ¿Usted, o alguien por encima de usted?"},
	{"who": "adler", "text": "Qué pregunta más impertinente. Y qué reveladora de su ingenuidad. Yo dirijo la ciencia, detective. La ciencia no manda: sirve. Pero eso no lo va a entender hoy. Registre lo que quiera. No encontrará una sola cosa que no esté, técnicamente, en regla."}], "revisit": "Adler defiende Somnia sin pestañear. Pero habla como quien ejecuta, no como quien manda del todo."},
"rh19": {"bg": "despacho_rrpp", "flag": "done_rh19", "clues": [
	{"title": "El jefe de prensa", "text": "Parece el titiritero; solo maquilla lo que otros deciden.", "false": true},
	{"title": "El secretario de Adler", "text": "Controla la agenda; sabe horarios, no decisiones.", "false": true},
	{"title": "El médico estrella", "text": "La cara pública de Somnia en congresos; un maniquí con bata.", "false": true},
	{"title": "La jefa de ventas", "text": "Coloca el fármaco a hospitales; vendedora, no diseñadora del horror.", "false": true},
	{"title": "El accionista visible", "text": "Sale en las fotos; testaferro de los accionistas reales, ocultos.", "false": true}], "beats": [
	{"who": "narrador", "text": "Fuera del despacho blanco, en la planta noble de Nyxos, la vida corporativa fluye pulcra y silenciosa. Alrededor de Adler orbitan cinco figuras que parecen mandar: saludan, sonríen, firman carpetas al vuelo. Nora las estudia una a una y comprende que son satélites, no sol."},
	{"who": "detective", "text": "Jefe de prensa, secretario, médico estrella de congresos, jefa de ventas, accionista de las fotos. Cinco personas que parecen tocar el poder con la punta de los dedos. Vamos a ver de qué están hechas."},
	{"who": "narrador", "text": "El jefe de prensa habla como si moviera los hilos del mundo, pero solo maquilla notas que le bajan ya escritas. El secretario domina cada minuto de la agenda de Adler y ni un solo gramo de sus decisiones. El médico estrella pone su cara guapa en los congresos: un maniquí con bata que repite un guion que no ha leído entero."},
	{"who": "detective", "text": "La jefa de ventas coloca Somnia en hospitales a golpe de comisión; vende el horror sin haberlo diseñado. Y el accionista que sale en todas las galas es un testaferro: presta su cara a unos accionistas de verdad que nunca se dejan fotografiar. Cinco puertas. Cinco reflejos. Todos brillan por la luz de otro."},
	{"who": "detective", "text": "Y aquí está lo que me hiela: la luz no está ni siquiera en Adler del todo. Ella también ejecuta. Por encima de su bata blanca hay un consejo que decide en nombre de los accionistas. El culpable de este caso no tiene cara. Tiene logo."}], "revisit": "Cinco satélites de Adler. Ni ella es el sol: por encima, el consejo y los accionistas."},
"l19b": {"bg": "piso_franco", "flag": "done_l19b", "clue": {"title": "El proyecto Somnia", "text": "Rescatas a Diego de una sala de Nyxos; entre sus papeles, el plan completo de Somnia... y una firma por encima de Adler."}, "beats": [
	{"who": "narrador", "text": "Al fondo de la planta, una puerta sin rótulo que la tarjeta de Marco abre con un chasquido seco. Dentro, penumbra y el zumbido de una máquina. En una camilla, bajo una manta térmica, un cuerpo delgado que sube y baja despacio. Nora conoce esa respiración: la ha oído en la habitación de al lado toda su infancia."},
	{"who": "detective", "text": "Diego. Diego, soy yo. Estoy aquí. Abre los ojos, hermano, por favor."},
	{"who": "narrador", "text": "Le aparta el pelo de la frente. Está sedado, lejos, pero vivo: la aguja de un gotero le entra en el brazo con la misma serpiente impresa en la bolsa. Le retira la vía con cuidado, como si desactivara una bomba, y lo incorpora contra su hombro."},
	{"who": "diego", "text": "¿Nora...? Sabía que vendrías. Siempre vienes. Aunque llegues tarde y de mal humor, siempre vienes. Coge... coge la carpeta azul. La escondí para ti, debajo del colchón. Es 'el plan entero'. Lo vi cuando creían que dormía. Yo escuchaba, hermana. Escuchaba con los ojos cerrados."},
	{"who": "detective", "text": "Te tengo, hermano. Ya está. No te esfuerces. Vamos a casa."},
	{"choices": [
		{"text": "Sacarlo ya, la carpeta después", "then": [
			{"who": "detective", "text": "La carpeta puede esperar. Tú no. Primero te saco de aquí, luego leo lo que haga falta."},
			{"who": "diego", "text": "No, Nora. Escúchame por una vez en tu vida. Coge la carpeta. Si me sacas a mí y dejas eso, mañana meten a otro en esta camilla. Yo salgo contigo o con la carpeta, pero la carpeta sale seguro."},
			{"who": "detective", "text": "(Está roto, sedado, y aun así piensa en los que vienen detrás. Mi hermano pequeño. Qué poco lo he mirado.) Está bien. Las dos cosas. No suelto ninguna."}]},
		{"text": "Prometerle que se acabó", "then": [
			{"who": "detective", "text": "Escúchame, Diego. Esta es la última camilla. La última aguja. Te lo juro por lo que quieras. No vuelves a estar solo ni una noche más."},
			{"who": "diego", "text": "No jures, Nora. Tú siempre juras y luego llega un caso. Solo... solo sácame. Y agárrate a esa carpeta como te agarrabas a mí cuando había tormenta."},
			{"who": "detective", "text": "Esta vez el caso y tú sois lo mismo. Por primera vez. Vamos."}]}]},
	{"who": "narrador", "text": "En la carpeta azul, el plan completo del Proyecto Somnia: fórmulas, fases, presupuestos, un mapa entero del horror con membrete corporativo. Y en la última página, sobre la firma de Adler, otra escrita a máquina, fría, sin rúbrica personal: 'Aprobado por el Consejo — en representación de los accionistas'."},
	{"who": "detective", "text": "Adler no es la dueña. Es la ejecutora. Por encima de ella está el consejo, y por encima del consejo... la propia empresa. Los accionistas. Nyxos entera."},
	{"who": "diego", "text": "Te lo dije, hermana. Yo escuchaba. Nadie mandaba. Todos... firmaban. Como si el horror fuera un formulario que va pasando de mesa en mesa hasta que ya no es de nadie."}], "revisit": "Rescaté a Diego y el plan de Somnia. Adler ejecuta; por encima está el consejo y los accionistas."},
"fin19": {"bg": "oficina", "flag": "cap19_completo", "clue": {"title": "Adler no está sola", "text": "El plan revela que Adler solo cumple: el proyecto Somnia lo sostiene y financia el consejo en nombre de los accionistas. El culpable es la corporación."}, "beats": [
	{"who": "narrador", "text": "Con Diego a salvo en manos de Marco al final del pasillo y la carpeta azul apretada contra el pecho, Nora vuelve a entrar en el despacho blanco. Adler no se ha movido de su sillón. Levanta la vista de un informe con la calma de quien ya sabe lo que va a oír."},
	{"who": "detective", "text": "Usted no inventó esto por maldad propia, doctora. Lo hizo porque el consejo lo aprobó, porque los accionistas lo exigían, porque a la empresa le salía a cuenta. Su firma es la penúltima. Encima hay otra, y esa no tiene nombre: tiene un sello."},
	{"who": "adler", "text": "...Por fin alguien lo entiende. Llevo veinte años esperando que alguien mire ese papel y lea la línea de arriba en vez de la mía. Yo soy sustituible, detective. Si caigo yo, mañana hay otra bata firmando lo mismo, en este mismo despacho, con mis mismos premios en la pared."},
	{"who": "adler", "text": "El proyecto no soy yo: es Nyxos. Siempre fue Nyxos. Yo pongo la cara, la ciencia y la firma. Pero la voluntad que sostiene todo esto no cabe en una persona. Es una máquina de decidir sin culpables. Ese es su verdadero enemigo, y no lo puede esposar."},
	{"who": "detective", "text": "(Quería una villana con nombre para poder odiarla y dormir tranquila. Y me dan una estructura. Una bestia sin cabeza que si le cortas una, le crece otra idéntica. Ella lo sabe. Y casi lo dice con alivio, como quien confiesa que nunca fue del todo suya la culpa.)", "side": "right"},
	{"who": "detective", "text": "Entonces no me llevo una cabeza, doctora. Me llevo a la bestia entera. Voy a hacer caer a la corporación, no a un chivo expiatorio con premios. A usted, al consejo, a los accionistas de las fotos y a los que no salen en ninguna. A Nyxos completa."},
	{"who": "adler", "text": "Ambiciosa. Como yo a su edad. Le deseo suerte, detective: la va a necesitar toda. Una corporación no se cae empujándola. Se cae con una jugada perfecta, ejecutada de golpe, sin darle tiempo a sus abogados a respirar. ¿Sabe usted hacer algo así? Yo, francamente, lo dudo."},
	{"who": "detective", "text": "Sola, no. Pero hace tiempo que dejé de hacer las cosas sola. Ese es el error que ustedes nunca entendieron: cuentan personas de una en una. Y yo tengo un equipo."}], "revisit": "Adler solo ejecuta. El verdadero culpable es Nyxos entera: consejo y accionistas."},
"cierre19": {"bg": "comisaria", "flag": "done_cierre19", "beats": [
	{"who": "narrador", "text": "De vuelta en la comisaría, Diego duerme por fin un sueño de verdad en un catre del fondo, tapado con la chaqueta de Núñez. Nora deja la carpeta azul sobre la mesa como quien deposita una bomba desactivada. El sargento la abre por la última página y lee la línea sobre la firma de Adler."},
	{"who": "detective", "text": "Adler caerá, pero es intercambiable. El culpable no es una persona: es Nyxos como estructura. Consejo, accionistas, una máquina de firmar horrores sin que nadie se manche. Y contra una corporación entera no me vale una orden más ni una redada más. Necesito una jugada perfecta."},
	{"who": "nunez", "text": "Entonces reúnalos a todos, detective Vega: sus pruebas, sus testigos, sus aliados. Un solo golpe, a la vez, que ningún abogado pueda deshacer. Mañana. En su propia casa."},
	{"who": "detective", "text": "Sonia con la ciencia, Clara con la ley, Vera con la portada, Rubén con la memoria, Marco con las llaves. Y Diego, vivo, como prueba de que sobrevivieron. Todos a la vez, o nada."},
	{"who": "narrador", "text": "— FIN DEL CAPÍTULO 19 —  El monstruo no tiene una cara: tiene un logo. Y Nora está lista para el golpe final."}]},

# --- Cap. 20 · Nyxos ---
"brief20": {"bg": "comisaria", "flag": "done_brief20", "beats": [
	{"who": "narrador", "text": "El día del golpe final amanece sin lluvia, y eso, después de tantos meses, casi asusta. La comisaría no huele a café rancio ni a expediente muerto: huele a gente. La sala de reuniones está llena por primera vez en veinte casos. Sonia despliega sus informes forenses en un abanico limpio. Clara ordena carpetas con lomo de bufete caro. Vera afila un lápiz sobre una maqueta de portada. Rubén, jubilado y castizo, ha traído su vieja agenda de tapas gastadas. Marco, todavía con el uniforme de seguridad de Nyxos, suda una lealtad que por fin ha cambiado de bando. Y en una silla, con una manta sobre las piernas, Diego se recupera y mira a su hermana como quien mira amanecer."},
	{"who": "detective", "text": "Nunca creí que diría esto en una comisaría, y menos con testigos: gracias. A todos. A cada uno. Hoy no entra Nora Vega en Nyxos. Hoy entramos todos, con todo lo que cada uno trae bajo el brazo."},
	{"who": "nunez", "text": "Doce sillas, una corporación, un país entero mirando por encima del hombro. Que no se nos escape ni una firma, ni una coma, ni un chivo expiatorio de última hora. Esta gente ha comprado jueces con menos. Adelante, detective. Es su golpe."},
	{"who": "ruben", "text": "A mí me jubilaron por preguntar demasiado, criatura. Veinte años callando en un banco del parque. Hoy vengo a ver cómo alguien acaba la pregunta que a mí me costó la placa. No me lo perdería por nada."},
	{"who": "detective", "text": "(Cinco personas en una sala, dispuestas a quemarse conmigo. Yo que empecé este hilo sola, con una campana robada y una tormenta. Nunca resolví nada sola. Hoy menos que nunca.)", "side": "right"},
	{"choices": [
		{"text": "«Vamos a hacerlo por el libro, hasta la última página.»", "then": [
			{"who": "detective", "text": "Escuchadme bien. Esta gente sobrevive a todo menos a un procedimiento perfecto. Nada de atajos, nada de puertas forzadas. Cada prueba blindada, cada firma en su sitio. Los tumbamos por el libro, hasta la última página."},
			{"who": "clara", "text": "Esa es la Nora que llevo catorce meses esperando oír. Por fin. Yo pongo las páginas. Tú, por una vez, no las rompas."}]},
		{"text": "«Que uno de esos doce entienda lo que hizo. Con eso me basta.»", "then": [
			{"who": "detective", "text": "No os voy a mentir. Quiero verlos caer, sí. Pero quiero algo más raro: que al menos uno de esos doce, cuando le pongamos las pruebas delante, entienda de verdad lo que firmó. Que no todo sea papeleo."},
			{"who": "sonia", "text": "Eso no lo garantiza ninguna cadena de custodia, detective. Pero mira a Marco. A veces pasa. A veces uno despierta."}]}]},
	{"who": "detective", "text": "Se acabó tirar del hilo en la oscuridad. Hoy encendemos todas las luces a la vez. Que Nyxos nos vea llegar."}], "revisit": "Hoy es el golpe final contra Nyxos. Con todos: Sonia, Clara, Vera, Rubén, Marco, Diego."},
"l20a": {"bg": "consejo", "flag": "done_l20a", "clue": {"title": "La cúpula entera", "text": "Con Marco dentro y Clara con la orden, se cita al consejo AL COMPLETO: por primera vez, los doce en una sala controlada."}, "beats": [
	{"who": "narrador", "text": "La sala del consejo de Nyxos es un templo de cristal ahumado y madera negra, treinta pisos sobre la ciudad. Doce sillones de piel rodean una mesa larga como un ataúd de reyes. En cada plaza, una carpeta con el logo grabado en seco: la serpiente enroscada en la copa. Fuera, la tormenta que faltaba empieza a amontonarse sobre los rascacielos. Dentro, huele a ambientador caro y a miedo educado."},
	{"who": "narrador", "text": "Uno a uno, los doce van entrando, convencidos de que vienen a negociar. Marco, con su tarjeta de acceso, ha dejado abiertas todas las puertas justas. Clara, con la citación firmada, ha cerrado todas las salidas."},
	{"who": "detective", "text": "Doce sillas. Doce firmas en el acta. Doce responsables sentados a la vez, por primera y última vez. Ninguno podrá levantarse mañana y señalar al de al lado, porque hoy están todos al alcance de la misma mano."},
	{"who": "marco", "text": "Los tengo controlados en la sala, Nora. Cámaras mías, puertas mías. Durante años abrí estas puertas para que entraran las víctimas. Hoy las abro para que no salga ni uno de ellos. Es lo menos que puedo hacer."},
	{"who": "clara", "text": "Legalmente, tenerlos a los doce en la misma sala con las pruebas encima de la mesa es la jugada de mi carrera. Un consejo entero, en cuerpo presente, notificado en regla. No dejes que ninguno se levante, Nora. Ni para ir al baño."},
	{"who": "detective", "text": "(Doce personas que decidieron por votación que unas vidas valían menos que un balance trimestral. Y ahí están, con sus relojes y sus corbatas, como si esto fuera otra junta de accionistas.)", "side": "right"},
	{"choices": [
		{"text": "Entrar en frío, institucional, de usted", "then": [
			{"who": "detective", "text": "Buenos días. Soy la detective Vega. Están todos citados en calidad de miembros del consejo de administración de Nyxos Pharma. Les ruego que no abandonen la sala. Lo que va a pasar aquí quedará grabado."},
			{"who": "clara", "text": "Perfecto. Fría, correcta, imposible de recusar. Que conste en acta cada palabra que digan a partir de ahora."}]},
		{"text": "Mirarlos a los ojos, uno por uno, antes de hablar", "then": [
			{"who": "narrador", "text": "Antes de decir nada, Nora recorre la mesa con la mirada, silla por silla, cara por cara. Doce pares de ojos que aprenden, despacio, que esto no es una negociación."},
			{"who": "detective", "text": "Quería veros las caras antes. Solo eso. Las caras de los que firman lo que otros ejecutan. Ya está. Ahora podemos empezar."}]}]}], "revisit": "Tengo al consejo entero de Nyxos reunido y localizado. Los doce, por fin, juntos."},
"rh20": {"bg": "oficina", "flag": "done_rh20", "clues": [
	{"title": "El directivo mártir", "text": "Un directivo 'confiesa' ser el único culpable; guion aprendido para salvar a Nyxos.", "false": true},
	{"title": "El científico loco", "text": "Ofrecen a Kessler como 'mente enferma aislada'; era un simple recadero.", "false": true},
	{"title": "La filial rebelde", "text": "Culpan a una filial 'descontrolada'; las órdenes venían de la central.", "false": true},
	{"title": "El error de sistema", "text": "Alegan un 'fallo de protocolo' sin responsables; el acta prueba lo contrario.", "false": true},
	{"title": "El difunto", "text": "Le cuelgan todo a Vaultier, ya caído; muerto el perro, viva la empresa.", "false": true}], "beats": [
	{"who": "narrador", "text": "En una antesala acristalada, mientras Clara prepara la notificación, los abogados de Nyxos abren su última defensa como quien reparte cartas marcadas. No niegan el crimen: ofrecen un culpable. Y luego otro. Y otro. Cinco figuras de usar y tirar, servidas en bandeja para que la máquina siga girando."},
	{"who": "detective", "text": "Miralos venir. Primero el directivo mártir, que sale con un guion aprendido y se declara único responsable de todo, como si un hombre solo pudiera montar esto. Luego Kessler, el científico loco, la mente enferma y aislada; el pobre Kessler, que no era más que un recadero con bata."},
	{"who": "detective", "text": "Después la filial rebelde, esa sucursal descontrolada que actuó por su cuenta; salvo que todas las órdenes salían de la central, con membrete. Luego el error de sistema, un fallo de protocolo sin nombre y sin cara; salvo que el acta lo firmaron doce manos. Y por último el difunto: le cuelgan todo a Vaultier, que ya está caído y no protesta. Muerto el perro, viva la empresa."},
	{"who": "clara", "text": "Es un manual, Nora. Se llama contención de daños. Te ofrecen una cabeza para que sueltes el cuerpo. Si muerdes cualquiera de las cinco, mañana Nyxos abre otra vez con nombre nuevo y logo nuevo."},
	{"who": "detective", "text": "No compro ninguno. Ni el mártir, ni el loco, ni la filial, ni el error, ni el muerto. Es el mismo truco que usaron con sus víctimas: convertir a una persona en el residuo de un sistema. Si acepto un culpable, mañana hay otro Somnia con otras siglas."},
	{"who": "detective", "text": "El acusado no es un hombre. Es la corporación entera. Y va a caer entera, del portero al presidente, sin un solo chivo expiatorio que le sirva de coartada."}], "revisit": "Cinco chivos expiatorios rechazados. El acusado es Nyxos entera, no un cabeza de turco."},
"l20b": {"bg": "comisaria", "flag": "done_l20b", "clue": {"title": "Todas las piezas", "text": "Cada aliado aporta su prueba: forense (Sonia), legal (Clara), prensa (Vera), testigo (Irene), interna (Marco). Juntas, son irrefutables."}, "beats": [
	{"who": "narrador", "text": "De vuelta en la comisaría, la mesa larga se llena de pruebas como un altar. Cada aliado deja lo suyo y explica lo suyo, y por primera vez las piezas no se contradicen: encajan. La lluvia empieza a golpear los cristales; nadie la oye."},
	{"who": "sonia", "text": "Lo forense es mío y es de hierro. Somnia, la misma molécula, en cada víctima analizada. Cadena de custodia impecable, sellada, cotejada dos veces. No hay perito en el mundo que la discuta sin quedar en ridículo. Que lo intenten."},
	{"who": "clara", "text": "Lo legal lo pongo yo. El acta del consejo, la votación unánime que aprobó 'depurar' el proyecto, los consentimientos falsos con notario inexistente, la trama que sube hasta el nivel nacional. Doce imputaciones, Nora, no una. Nombre por nombre, firma por firma."},
	{"who": "periodista", "text": "Lo público es cosa mía, y sale mañana a primera hora. Portada a cinco columnas. Y no la firmo yo sola: la firma Irene. La superviviente. Con su nombre, con su cara, contando lo que le hicieron. Se acabó lo de 'esa mujer delira'. Cuando media ciudad lea su nombre en el desayuno, ya no hay abogado que lo entierre."},
	{"who": "testigo", "text": "Nadie me creyó durante dos años, detective. Me llamaron loca, confundida, histérica. Mañana lo cuento yo, con mi nombre entero, y que me lean todos los que miraron para otro lado. Ya no tengo miedo. Usted me quitó el miedo."},
	{"who": "marco", "text": "Y lo de dentro lo firmo yo, con mi puño. Los accesos, los turnos, quién entraba y quién salía, y la orden. La orden de 'depurar', escrita, con su cadena de mando. Firmo mi declaración aquí y ahora, Nora. Me hundo con ellos si hace falta, pero vuelvo a ser de los buenos."},
	{"who": "detective", "text": "Cinco piezas, una sola imagen. Por separado, Nyxos las parte con un soplido: un perito, un recurso, una rueda de prensa. Juntas, ni todos sus abogados las levantan del suelo. Es la hora."},
	{"choices": [
		{"text": "Agradecer a Marco el paso que ha dado", "then": [
			{"who": "detective", "text": "Marco. Sé lo que te cuesta esa firma. Tu nómina, tu nombre, quince años de otra vida. No te lo pedí. Lo has hecho tú."},
			{"who": "marco", "text": "Me lo debía a mí, Nora. Y a toda la gente a la que abrí la puerta sin preguntar. Un hombre no puede pasarse la vida abriendo puertas equivocadas."}]},
		{"text": "Prometer a Irene que su nombre sale primero", "then": [
			{"who": "detective", "text": "Irene, escúcheme. En ese titular, el primer nombre no es Nyxos ni el mío. Es el suyo. Los demás son los que la creyeron tarde. Usted es la que sobrevivió para contarlo."},
			{"who": "testigo", "text": "Gracias. Durante dos años fui un número en un archivo. Mañana vuelvo a ser una persona con nombre. Eso ya no me lo quita nadie."}]}]},
	{"who": "detective", "text": "Cerrad las carpetas. Nos vamos a Nyxos. Es hora de que la serpiente vea de cerca a quienes convirtió en números."}], "revisit": "Cada aliado ha aportado su prueba. Juntas, son irrefutables contra Nyxos."},
"fin20": {"bg": "azotea_nyxos", "flag": "cap20_completo", "clue": {"title": "La prueba definitiva", "text": "En la azotea de Nyxos, ante la cúpula, Nora expone que el culpable es la corporación entera; con las pruebas de todos, cae Nyxos."}, "beats": [
	{"who": "narrador", "text": "La confrontación final no es en un sótano ni en un campanario: es en la azotea de la torre de Nyxos, treinta y dos pisos de acero mordidos por la última tormenta del arco. El viento arranca las palabras de la boca antes de decirlas. La lluvia cae de lado, plateada bajo los focos rojos de las antenas, y golpea los rostros de la cúpula como si también ella hubiera venido a acusar. Abajo, muy abajo, la ciudad entera late en luces mojadas: mil ventanas, mil testigos que no saben que lo son. Sobre la gran pantalla publicitaria de la fachada, apagada por primera vez, esperan las pruebas de todos."},
	{"who": "narrador", "text": "La Dra. Adler avanza hasta el borde, impecable pese al agua, el pelo pegado a la sien, la soberbia intacta. No huye. La gente como ella no huye: negocia."},
	{"who": "adler", "text": "¿Va a detenernos a todos, detective? ¿A una empresa entera? Piénselo bien. Una empresa no cabe en una celda. No tiene muñecas que esposar ni cuello que ahorcar. Nyxos es una idea, y las ideas no caben en sus calabozos."},
	{"who": "detective", "text": "No. Tiene razón. Una empresa no cabe en una celda. Pero cabe en un titular, cabe en un sumario y cabe, entera, en la ruina. Ustedes convirtieron a personas en números para que Nyxos ganara un punto en bolsa. Hoy Nyxos se convierte en el número de un caso. Cerrado."},
	{"who": "adler", "text": "Somnia era progreso. Dormir sin soñar, apagar el dolor. La historia me dará la razón cuando usted no sea ni una nota a pie de página."},
	{"who": "detective", "text": "Progreso. Diego, mi hermano, decía que Somnia lo apagaba como a una lámpara. Eso no es dormir, doctora. Eso es estar muerto sin el descanso de estarlo. Y usted lo sabía en cada acta que votó."},
	{"who": "narrador", "text": "Nora levanta la mano, y sobre la gran pantalla de la fachada, encarada a toda la ciudad, se enciende la imagen. Una a una, las pruebas suben a la luz bajo la lluvia: los informes de Sonia, el acta de Clara con las doce firmas, la portada de Vera con el nombre de Irene, los accesos de Marco, la cara serena de la superviviente. La cúpula entera, iluminada por sus propios crímenes, empieza a deshacerse. Uno afloja la corbata. Otro busca a su abogado con los ojos. Un tercero, sin más, se sienta en el suelo mojado."},
	{"who": "adler", "text": "No pueden probar que yo... que fue una decisión mía. Fue un órgano colegiado. Fue un voto. Fue de todos."},
	{"who": "detective", "text": "Exacto. Fue de todos. Ese es justo el punto, doctora. No busco a un monstruo con nombre. Nunca lo busqué. Durante veinte casos perseguí sombras: un mecenas, un párroco, un contable, un magnate. Y al final del hilo no había un hombre. Había una MÁQUINA. Y a las máquinas no se las convence ni se las detiene: se las para. Se acabó Somnia. Se acabó Nyxos."},
	{"choices": [
		{"text": "Dejar que la lluvia hable por ella", "then": [
			{"who": "narrador", "text": "Nora no dice nada más. Baja la mano, se sube el cuello del abrigo empapado y deja que la tormenta remate la frase. Los focos rojos parpadean sobre doce rostros que ya no gobiernan nada. La cúpula ha caído sin que nadie la empuje."},
			{"who": "detective", "text": "(Ya está. Ni un grito, ni una esposa de más. Solo hechos, y la lluvia lavándolo todo por una vez de verdad. Se lo debía a las del archivo. A todas.)", "side": "right"}]},
		{"text": "Mirar a Adler y darle la última palabra a las víctimas", "then": [
			{"who": "detective", "text": "Una última cosa, doctora. Las mujeres a las que llamó residuo tenían nombre. Irene tiene nombre. Y mañana lo va a leer usted en la portada, encima del suyo. Para siempre."},
			{"who": "adler", "text": "...Váyase al infierno, detective."},
			{"who": "detective", "text": "Ya vengo de ahí. Lo he tenido montado en su torre treinta pisos. Buenas noches, doctora."}]}]},
	{"who": "narrador", "text": "La lluvia arrecia sobre la azotea, limpiando por una vez de verdad. Los agentes de Núñez suben por las escaleras y rodean a la cúpula sin resistencia. Abajo, veinte casos, seis tormentas, un solo hilo tejido desde una campana robada hasta una corporación entera: por fin cortado de raíz, en lo más alto, bajo el agua."}], "revisit": "Cayó la cúpula de Nyxos en su azotea. El culpable no era un hombre: era la corporación."},
"cierre20": {"bg": "comisaria", "flag": "done_cierre20", "beats": [
	{"who": "narrador", "text": "Nyxos se desmorona en los tribunales durante meses, sociedad por sociedad, firma por firma, tal como prometió Clara. El proyecto Somnia se cancela y se destruye bajo control judicial. Los supervivientes recuperan su nombre en los registros; las familias, por fin, una tumba con letras de verdad y una verdad que no cabía en ningún parte de desaparición. La comisaría, esta noche, huele a papel cerrado y a algo que hacía años no se olía aquí: a final bueno."},
	{"who": "diego", "text": "Estoy limpio, Nora. De verdad esta vez. Sin pastillas, con noches malas de las normales, de las que se pasan durmiendo poco y viviendo mucho. Y es por ti. Perdón por haber sido tu talón de Aquiles todo este tiempo. Por haberte dado un motivo para que te comieran."},
	{"who": "detective", "text": "Nunca fuiste mi debilidad, Diego. Métetelo en la cabeza dura que tienes. Fuiste mi motivo. Cada vez que quise soltar el hilo y mirar para otro lado, estabas tú al final de él. Sin ti, quizá me habría comprado hace veinte casos."},
	{"who": "ruben", "text": "Veinte años me costó a mí no acabar la pregunta, criatura. A ti te ha costado veinte casos acabarla. Bien empleados están. Ahora hazme caso de viejo: no dejes que el trabajo te quite lo que acabas de recuperar."},
	{"who": "clara", "text": "Por una vez lo hiciste todo por el libro, Vega. Hasta la última página. No sabes lo raro que es verte ganar limpio. Casi me caes bien y todo."},
	{"who": "sonia", "text": "¿Y ahora qué, detective? ¿Descanso de verdad, o te busco otro cadáver para el lunes?"},
	{"who": "detective", "text": "Ahora una copa con vosotros, que os la debo desde hace seis tormentas. Sonia, Clara, Vera, Rubén, Marco, Diego. Escuchadme bien, porque no lo repito: nunca resolví nada sola. Ni un caso. Solo fui la que no se rindió mientras vosotros sosteníais todo lo demás. El hilo era mío. La red erais vosotros."},
	{"who": "periodista", "text": "Eso, detective, deja que lo escriba yo. Sin tu nombre en grande, si quieres. Pero que quede escrito."},
	{"who": "nunez", "text": "Descanse, detective Vega. Se lo ha ganado como pocos. Váyase a casa, apague el móvil, duerma sin nombre de caso en la cabeza. Hasta la próxima tormenta."},
	{"who": "detective", "text": "Hasta la próxima tormenta, sargento. Pero esta noche, que llueva donde quiera. Yo tengo una copa pendiente."},
	{"who": "narrador", "text": "— FIN —  Veinte casos. Un solo hilo, desde una campana robada hasta una corporación entera. Nora Vega apaga la luz de la comisaría y sale con los suyos. Fuera, por primera vez en mucho tiempo, no llueve. Sobre el asfalto seco, las farolas dibujan un camino que, por una noche, no lleva a ningún crimen. sOC."}]},

}


# ===========================================================================
#  CAPÍTULO 7 · La receta  (versión LARGA, canon ~5 min como los caps. 1-6)
# ===========================================================================
static func _ch7_dialogue(id: String, done: bool) -> Dictionary:
	match id:
		"brief7":  return _dlg_brief7(done)
		"l7a":     return _dlg_l7a(done)
		"rh7":     return _dlg_rh7(done)
		"l7b":     return _dlg_l7b(done)
		"fin7":    return _dlg_fin7()
		"cierre7": return _dlg_cierre7()
	return {"bg": "comisaria", "beats": [{"who": "narrador", "text": "Nada más que hacer aquí por ahora."}]}


static func _dlg_brief7(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "nunez", "text": "La chica del río, la del veneno raro en la sangre. Baje a la morgue: Sonia la sigue teniendo en la mesa esperándola a usted."},
		]}
	return {
		"bg": "comisaria",
		"flag": "done_brief7",
		"beats": [
			{"who": "narrador", "text": "Han pasado meses desde que la torre de Vaultier se llenó de sirenas. Nora ya no es la intrusa de la ciudad: tiene mesa, placa reconocida y una silla que no cojea. Pero la lluvia sigue siendo la misma, y la cara de Núñez esta mañana también."},
			{"who": "nunez", "text": "Buenos días, detective. Ojalá lo fueran. ¿Se acuerda de Rosa Marín, una de las mujeres que rescatamos del muelle en el caso Vaultier?"},
			{"who": "detective", "text": "La pelirroja. La que declaró con las manos temblando y luego no quiso protección. Claro que me acuerdo."},
			{"who": "nunez", "text": "Apareció anoche en el río. Y aquí viene lo que me quita el sueño: no se ahogó. Estaba muerta antes de tocar el agua."},
			{"who": "detective", "text": "¿Un ajuste de cuentas? ¿Alguien del Cónclave que quedó suelto, cerrando bocas?"},
			{"who": "nunez", "text": "Eso pensé yo. Pero la forense dice que no hay violencia. Ni un golpe, ni una marca de forcejeo. La mató algo que llevaba dentro. Un veneno que ella no reconoce."},
			{"who": "narrador", "text": "Núñez desliza sobre la mesa el informe preliminar. En el margen, con la letra apretada de Sonia, una sola palabra subrayada dos veces: 'DESCONOCIDO'."},
			{"who": "detective", "text": "Sonia no subraya 'desconocido' por una aspirina. Si ella no lo reconoce, es que no está en ningún libro."},
			{"choices": [
				{"text": "\"¿Por qué Rosa, y por qué ahora?\"", "then": [
					{"who": "nunez", "text": "No lo sé. Sobrevivió a lo peor y meses después aparece envenenada con algo que no existe. O es un cabo suelto de Vaultier... o es un caso nuevo que ni sabíamos que teníamos."},
					{"who": "detective", "text": "(Sobrevivió al muelle para morir en el río. Alguien no quería que Rosa siguiera respirando. La pregunta es qué llevaba en la sangre que valía una vida.)", "side": "right"},
				]},
				{"text": "\"¿Hay más como ella?\"", "then": [
					{"who": "nunez", "text": "Esa es la pregunta que no me atrevo a hacerme en voz alta, detective Vega. Porque si empiezo a cruzar autopsias con 'causa desconocida'... vaya usted a saber cuántos ríos abajo miran hacia otro lado."},
					{"who": "detective", "text": "Empecemos por una. Rosa merece que alguien mire de frente lo que a ella la mató."},
				]},
			]},
			{"who": "nunez", "text": "Baje a la morgue. Sonia la ha tenido en la mesa toda la noche esperándola. Dice que solo se lo enseña a usted, que del resto no se fía. Cosa de amigas, supongo."},
			{"who": "detective", "text": "Con Sonia siempre es cosa de amigas y de ciencia, en ese orden. A la morgue, pues. A ver qué mató a Rosa Marín."},
		],
	}


static func _dlg_l7a(done: bool) -> Dictionary:
	if done:
		return {"bg": "morgue", "beats": [
			{"who": "sonia", "text": "Ya lo tienes anotado, Nora: 'Somnia'. Un fármaco de laboratorio, no de garaje. Eso es lo que mató a Rosa. Sigue el hilo hacia quien lo fabrica."},
		]}
	return {
		"bg": "morgue",
		"clue": {"title": "El fármaco Somnia", "text": "En la sangre de Rosa, un fármaco experimental sin nombre comercial: 'Somnia'. De un laboratorio, no de la calle."},
		"flag": "done_l7a",
		"beats": [
			{"who": "narrador", "text": "La morgue municipal es el sitio más honesto de la ciudad: aquí no hay abogados, ni sobres, ni sonrisas. Solo acero, frío y la verdad tumbada bajo una sábana. Sonia te espera con dos cafés, uno para cada mano, como siempre."},
			{"who": "sonia", "text": "Vega. Llegas con esa cara de 'vengo a que me estropees el día'. Toma café, que vas a necesitar las dos manos para lo que traigo."},
			{"who": "detective", "text": "Diez años viéndote descubrir horrores con una sonrisa, Sonia. No sé cómo lo haces."},
			{"who": "sonia", "text": "Sonriendo. Es eso o volverme loca, y la locura no cotiza. Mira. Rosa Marín. Sin traumatismos, sin asfixia por agua, sin nada de lo que un río suele dejar."},
			{"who": "narrador", "text": "Sonia retira la sábana con el cuidado de quien respeta a los muertos más que a los vivos. Luego gira hacia ti una pantalla llena de picos y curvas."},
			{"who": "sonia", "text": "Su sangre, en cambio, es una fiesta química. Hay un compuesto que no está en ningún vademécum, en ninguna base de datos, en ningún manual que yo haya estudiado. Y he estudiado muchos."},
			{"who": "detective", "text": "¿Un veneno nuevo?"},
			{"who": "sonia", "text": "No exactamente. Es un sedante. Uno brutal, elegantísimo: apaga la conciencia sin apagar el cuerpo. Te deja despierta por fuera y ausente por dentro. Lo he bautizado 'Somnia', porque no tiene otro nombre."},
			{"who": "detective", "text": "Un sedante que deja el cuerpo dócil y la mente apagada... Sonia, eso es lo que usaban en los secuestros. Lo que las tenía quietas mientras se las llevaban."},
			{"who": "sonia", "text": "Exacto. Y aquí está lo que te va a quitar a TI el sueño: esto no lo cocina un camello en una bañera. Sintetizar Somnia requiere un laboratorio de verdad, reactivos caros, gente con doctorado. Es industria, Nora. No delincuencia de barrio."},
			{"choices": [
				{"text": "\"¿Pudo ser una sobredosis accidental?\"", "then": [
					{"who": "sonia", "text": "Ni de broma. La dosis en Rosa es quirúrgica, calculada para matar despacio y limpio, como quien apaga una vela para que no eche humo. Esto es una ejecución con bata blanca."},
					{"who": "detective", "text": "(Una ejecución con bata blanca. La mataron con el mismo fármaco que la esclavizó. Poético y monstruoso a la vez.)", "side": "right"},
				]},
				{"text": "\"¿Por qué no lo denunciaste antes?\"", "then": [
					{"who": "sonia", "text": "Porque hasta hoy solo lo había visto en trazas, en las supervivientes del muelle, y siempre me decían 'archívalo, no relevante'. Contigo enfrente por fin puedo decirlo en voz alta: alguien está haciendo esto en serie, y a alguien de arriba le conviene que yo escriba 'desconocido'."},
					{"who": "detective", "text": "Pues a partir de ahora lo escribes con mi nombre al lado. Si te tocan, me tocan."},
				]},
			]},
			{"who": "sonia", "text": "Una cosa más, y esta te la doy como amiga, no como forense. Ten cuidado, Nora. La gente que fabrica algo así no deja cabos. Rosa era un cabo. Tú, en cuanto tires del hilo, serás otro."},
			{"who": "detective", "text": "Somnia. Un fármaco de laboratorio en la sangre de una superviviente. Lo apunto. Y tranquila, Sonia: llevo años siendo un cabo suelto que no se deja cortar."},
			{"who": "sonia", "text": "Por eso te quiero, boba. Ahora vete, que tengo que devolverle a Rosa la dignidad de una sábana limpia. Y busca ese laboratorio."},
		],
	}


static func _dlg_rh7(done: bool) -> Dictionary:
	if done:
		return {"bg": "comisaria", "beats": [
			{"who": "detective", "text": "Cinco pistas fáciles, cinco callejones. Somnia sale de un laboratorio, no de la calle. Vuelvo al hilo bueno: quién la receta."},
		]}
	return {
		"bg": "comisaria",
		"flag": "done_rh7",
		"clues": [
			{"title": "El camello del puente", "text": "El camello del barrio: Somnia le queda grande, solo vende cosas de calle.", "false": true},
			{"title": "El veterinario", "text": "Un veterinario que compra sedantes a granel; eran para el ganado, todo en regla.", "false": true},
			{"title": "La enfermera despedida", "text": "Una enfermera con rencor al hospital; sisaba gasas, no fármacos de diseño.", "false": true},
			{"title": "El químico jubilado", "text": "Un viejo químico con laboratorio casero: solo destila orujo de contrabando.", "false": true},
			{"title": "El curandero", "text": "Un curandero que 'cura el sueño' con valeriana. Nada químico ni criminal.", "false": true},
		],
		"beats": [
			{"who": "narrador", "text": "De vuelta en comisaría, Nora hace lo que haría cualquier detective con prisa y sin pista: llenar la pizarra de sospechosos fáciles. Cinco nombres, cinco flechas, una tarde entera de teléfono y café malo."},
			{"who": "detective", "text": "Empecemos por lo obvio, aunque lo obvio casi nunca sea lo cierto. ¿Quién mueve sedantes raros en esta ciudad?"},
			{"who": "narrador", "text": "El primero, el camello del puente. Suda antes de sentarse."},
			{"who": "sospechoso", "text": "¿Somnia? Yo vendo pastillas de colores y grifa mala, detective. Lo que me describe es de película. Yo no llego a tanto, ni queriendo."},
			{"who": "detective", "text": "(Dice la verdad. Este no distingue un laboratorio de una farmacia.) Siguiente."},
			{"who": "narrador", "text": "Un veterinario que compra sedantes a granel: eran para el ganado, con factura. Una enfermera despedida con rencor: robaba gasas, no ciencia. Un químico jubilado con laboratorio casero: solo destila orujo. Un curandero que 'cura el sueño': valeriana en bolsitas."},
			{"who": "detective", "text": "Cinco flechas, cinco tachones. El camello no llega, el veterinario está limpio, la enfermera roba gasas, el químico hace orujo y el curandero, infusiones."},
			{"who": "detective", "text": "(Cinco callejones sin salida en una tarde. Casi un récord. Y en el fondo, lo agradezco: cada pista falsa me confirma lo que Sonia ya sabía.)", "side": "right"},
			{"who": "detective", "text": "Somnia no la fabrica un aficionado con mala suerte. La fabrica alguien con bata, presupuesto y firma. Fuera la pizarra fácil. Vuelvo al único hilo que aguanta un tirón: quién le recetó veneno a Rosa."},
		],
	}


static func _dlg_l7b(done: bool) -> Dictionary:
	if done:
		return {"bg": "hospital", "beats": [
			{"who": "detective", "text": "El Dr. Kessler firmó recetas de un 'ansiolítico en pruebas' a Rosa y a otras antes de desaparecer. Es el primer eslabón. A su clínica."},
		]}
	return {
		"bg": "hospital",
		"clue": {"title": "El médico que receta", "text": "Un tal Dr. Kessler firmó recetas de un 'ansiolítico en pruebas' a Rosa y a varias víctimas antes de desaparecer."},
		"flag": "done_l7b",
		"beats": [
			{"who": "narrador", "text": "El hospital central de noche es un animal dormido que respira por sus fluorescentes. Nora se cuela en el archivo de farmacia con una sonrisa y una placa, y empieza a cruzar nombres con la paciencia de un relojero."},
			{"who": "detective", "text": "Si Somnia sale de un laboratorio, en algún punto tuvo que tocar el sistema legal. Un ensayo, una receta, un formulario. La sangre limpia deja rastro en el papel sucio."},
			{"who": "narrador", "text": "Hora tras hora, un patrón emerge de la marea de historiales. Un nombre que se repite en la casilla de 'médico prescriptor', siempre asociado a un mismo fármaco críptico."},
			{"who": "detective", "text": "Dr. Kessler. Recetó a Rosa Marín un 'ansiolítico en fase de pruebas' tres semanas antes de que apareciera en el río. Y no solo a ella."},
			{"who": "narrador", "text": "Cruzas más fichas. El nombre de Kessler brota una y otra vez, siempre junto a mujeres que después figuran como desaparecidas o muertas de 'causa desconocida'."},
			{"who": "detective", "text": "Media docena, por lo menos. Todas pasaron por su consulta. Todas recibieron la misma 'medicación experimental'. Todas terminaron mal."},
			{"choices": [
				{"text": "\"¿Kessler las elegía... o solo las trataba?\"", "then": [
					{"who": "narrador", "text": "Repasas los ingresos: ninguna llegó a Kessler por casualidad. Todas fueron 'derivadas' a él con una nota idéntica: 'candidata a programa de sueño'."},
					{"who": "detective", "text": "(No las trataba: las seleccionaba. Kessler no es un médico que se equivoca. Es un cazador con recetario.)", "side": "right"},
				]},
				{"text": "\"¿Dónde está Kessler ahora?\"", "then": [
					{"who": "narrador", "text": "El hospital lo dio de baja hace un mes 'por motivos personales'. Pero conserva una consulta privada, discreta, en un edificio sin placa."},
					{"who": "detective", "text": "Un médico que reparte veneno y luego se esconde en una consulta sin nombre. Nada dice más alto 'culpable' que una puerta sin letrero."},
				]},
			]},
			{"who": "detective", "text": "El que reparte la droga es el que marca a las presas. Kessler es mi primer eslabón de verdad. El médico que receta. Lo apunto, y me presento en esa consulta sin nombre antes de que le dé por desaparecer a él también."},
		],
	}


static func _dlg_fin7() -> Dictionary:
	return {
		"bg": "clinica",
		"clue": {"title": "El eslabón Kessler", "text": "Kessler admite que le pagaban por 'seleccionar candidatas' para un ensayo; membrete: una serpiente enroscada en una copa. No sabe de quién."},
		"flag": "cap7_completo",
		"beats": [
			{"who": "narrador", "text": "La consulta privada del Dr. Kessler huele a desinfectante caro y a miedo barato. Él está detrás de una mesa impecable, con las manos demasiado quietas, como quien lleva semanas esperando que llamen a la puerta."},
			{"who": "kessler", "text": "Detective Vega. Sé quién es usted. La que no se deja... la que no para. Siéntese, por favor. Llevo tiempo sin dormir, así que perdone si voy directo: sabía que vendría alguien."},
			{"who": "detective", "text": "Rosa Marín. Elena. Nadia. Media docena de mujeres con su firma en la receta y Somnia en la sangre. Empiece por explicarme eso, doctor. Despacio."},
			{"who": "kessler", "text": "Yo... yo seleccionaba candidatas. Eso era todo, se lo juro. Mujeres solas, ansiosas, insomnes, sin familia que preguntara. Rellenaba una ficha, las 'derivaba a un programa', y me pagaban por cada una. Nunca pregunté para qué."},
			{"who": "detective", "text": "Derivaba mujeres a un matadero por un sobre y prefería no saber a qué matadero. Eso no le hace inocente, Kessler. Le hace cómplice con coartada moral."},
			{"who": "kessler", "text": "¿Cree que no lo sé? ¿Cree que duermo? Empecé por deudas. Un 'ensayo privado bien pagado', me dijeron. Para cuando entendí que las que derivaba no volvían, ya era suyo. Un médico endeudado es la marioneta más barata del mundo."},
			{"who": "narrador", "text": "Se le quiebra la voz. Abre un cajón con manos temblorosas y saca un sobre, uno de los muchos con los que le pagaban."},
			{"who": "kessler", "text": "Todo por mensajeros. Nunca vi una cara. Solo esto: el membrete que venía en cada sobre. Yo lo miraba y hacía como que no significaba nada."},
			{"who": "narrador", "text": "En el papel, grabado en relieve, un símbolo elegante y frío: una serpiente enroscada en una copa. El emblema clásico de la medicina, retorcido hasta parecer una amenaza."},
			{"who": "detective", "text": "La serpiente y la copa. El símbolo de curar, usado por los que envenenan. Qué sentido del humor tan enfermo."},
			{"choices": [
				{"text": "\"¿Quién le pagaba? Un nombre.\"", "then": [
					{"who": "kessler", "text": "¡No lo sé, se lo juro por lo que quiera! Nunca hubo un nombre. Solo el símbolo, y una vez, en una llamada, una voz que dijo 'el laboratorio agradece su colaboración'. Laboratorio. Esa fue la palabra. Gente de bata, como yo, pero arriba."},
					{"who": "detective", "text": "(Un laboratorio. Sonia tenía razón: es industria. Kessler es el eslabón más bajo de una cadena que sube hacia batas más limpias y manos más sucias.)", "side": "right"},
				]},
				{"text": "\"¿Reconoció a alguna de sus víctimas?\"", "then": [
					{"who": "kessler", "text": "A todas. Ese es mi castigo: recuerdo cada cara. Rosa venía con una foto de su sobrina, me hablaba de ella para no llorar. Y yo firmaba su sentencia con una sonrisa profesional. Deténgame, detective. Por favor. Se lo pido yo."},
					{"who": "detective", "text": "Lo detendré. Pero antes va a ayudarme a subir por esa cadena. Su cárcel puede empezar siendo útil."},
				]},
			]},
			{"who": "detective", "text": "Una serpiente en una copa. Un 'laboratorio' sin nombre que paga por seleccionar mujeres. Kessler es culpable, sí, pero es el peldaño de abajo. El hilo sube, y sube hacia gente con doctorado y presupuesto."},
			{"who": "narrador", "text": "Esposas al médico y precintas el sobre como oro. Fuera, la lluvia repica sobre la consulta sin placa. El caso ya no es una muerta en un río: es una droga con símbolo propio."},
			{"who": "detective", "text": "Núñez tiene que ver este membrete. Y hay algo que me quema por dentro y que aún no le he contado a nadie: esta serpiente... la he visto antes. En un frasco, en casa de mi hermano Diego."},
		],
	}


static func _dlg_cierre7() -> Dictionary:
	return {
		"bg": "comisaria",
		"flag": "done_cierre7",
		"beats": [
			{"who": "narrador", "text": "En comisaría, de madrugada, Núñez le da vueltas al sobre bajo la lámpara como si el símbolo fuera a confesar por sí solo."},
			{"who": "nunez", "text": "Así que las desapariciones de todos estos años... ¿eran una cantera? ¿Se las llevaban para probar una droga en ellas?"},
			{"who": "detective", "text": "Eso parece, sargento. Bru las coleccionaba, Vaultier las vendía, pero ninguno de los dos fabricaba nada. Solo eran proveedores. Quien fabrica Somnia está por encima de todos ellos, y no se ha movido de su laboratorio ni cuando cayó Vaultier."},
			{"who": "nunez", "text": "Un laboratorio con una serpiente por bandera. Podría ser cualquiera de las diez farmacéuticas de esta ciudad, detective Vega. Todas usan ese símbolo."},
			{"who": "detective", "text": "Todas menos una lo usan para curar. Voy a encontrar cuál lo usa para lo contrario."},
			{"who": "narrador", "text": "Núñez asiente, cansado, y se guarda el sobre. Nora se queda un momento a solas, mirando por la ventana la lluvia sobre el neón."},
			{"who": "detective", "text": "Hay algo que no le he dicho, Núñez, porque llevo dos años sin querer decírmelo ni a mí misma. Mi hermano Diego toma algo para dormir desde hace meses. Un frasco sin marca, con una serpiente en una copa."},
			{"who": "nunez", "text": "Detective Vega... si eso es lo que creo que es, su hermano no es un paciente. Es una prueba andando. Y usted acaba de convertir esto en algo personal."},
			{"who": "detective", "text": "Ya era personal cuando Rosa apareció en el río. Ahora es de familia. Mañana empiezo por Diego. Y por el frasco que ha tenido en su mesilla todo este tiempo."},
			{"who": "narrador", "text": "— FIN DEL CAPÍTULO 7 —  El caso ya no son unas mujeres: es una droga con símbolo de médico. Y el hilo acaba de meterse, sin avisar, en la propia sangre de Nora."},
		],
	}
