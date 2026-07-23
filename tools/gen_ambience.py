# -*- coding: utf-8 -*-
"""Genera camas de ambiente por lugar con stable-audio-open-1.0 (diffusers).
GPU (fp16) si hay CUDA, con fallback a cpu_offload si la VRAM (4GB) se queda corta;
CPU (fp32) si no hay GPU. Reanudable: salta los .wav ya existentes.
Uso:
  python tools/gen_ambience.py                 -> todos
  python tools/gen_ambience.py comisaria       -> solo ese id
  env: STEPS (def 60), SECONDS (def 20), OFFLOAD (0/1)
Salida: build/ambientes/<id>.wav  (estereo 44.1kHz)
"""
import os, sys, time
import torch, soundfile as sf
from diffusers import StableAudioPipeline

MODEL = "stabilityai/stable-audio-open-1.0"
STEPS   = int(os.environ.get("STEPS", "60"))
SECONDS = float(os.environ.get("SECONDS", "20"))
OFFLOAD = os.environ.get("OFFLOAD", "0") == "1"
OUT = r"c:\ID\OneDrive\sOCProjects\sOCTheGame\build\ambientes"
os.makedirs(OUT, exist_ok=True)

AMB = [
 ("comisaria","police station at night, office ambience, distant ringing phones, keyboard typing, footsteps on tile, faint police radio chatter, fluorescent hum, room tone"),
 ("archivo_policial","police records basement archive, dense silence, low fluorescent hum, metal drawers sliding, paper rustling, distant water drip"),
 ("puesto_policia","small town police post, ceiling fan whirring, buzzing flies, occasional radio static, creaking chair, faint street outside window"),
 ("oficina_corporativa","modern corporate office, low air conditioning hum, distant printer, keyboards typing, muffled footsteps on carpet, faint voices behind glass"),
 ("sala_consejo","quiet corporate boardroom, ticking wall clock, creaking leather chairs, papers shuffling, very low ventilation hum, tense atmosphere"),
 ("despacho","private wood-paneled office, ticking clock, creaking wood, pen scratching on paper, muffled distant city behind closed window"),
 ("redaccion","busy newspaper newsroom, typewriters and computer keys, ringing phones, reporters murmuring, papers, constant background activity"),
 ("hospital","hospital corridor, distant heart monitor beeping, gurney wheels, muffled PA announcement, footsteps, swinging doors, sterile ambience"),
 ("morgue","cold morgue, low refrigeration hum, metallic dripping, tiled room echo, clinical eerie silence"),
 ("clinica","abandoned clinic in dim light, flickering fluorescent, electrical buzz, dripping, wind through broken window, tense silence"),
 ("laboratorio","pharmaceutical laboratory, machinery hum, bubbling liquids, pneumatic hiss, sterile ventilation, equipment beeps"),
 ("sala_ensayos","aseptic clinical trial room, medical equipment hum, rhythmic monitor beep, ventilator breathing, cold oppressive echo"),
 ("sanatorio","old isolated sanatorium, wind in empty corridors, banging shutter, creaking wood, distant echo, ghostly atmosphere"),
 ("casa_barrio","humble neighborhood home interior, wall clock ticking, humming fridge, creaking furniture, muffled street behind curtains"),
 ("piso_modesto","small messy apartment, dripping faucet, pipes, distant neighbor, faint traffic through window, fridge hum"),
 ("iglesia_int","church interior, cavernous reverberant echo, dripping, creaking wood, wind high in the bell tower, sacred silence"),
 ("capilla","small underground private chapel, damp echo, dripping, crackling candle flame, oppressive enclosed silence"),
 ("tienda","corner neighborhood shop, door bell chime, humming drinks fridge, low radio, faint street when door opens"),
 ("bar","neighborhood bar cafe, murmur of conversations, clinking cups and glasses, hissing espresso machine, distant background music, bar stools"),
 ("trastienda","closed storeroom backroom, silence, dragging boxes, paper, flickering fluorescent, stuffy atmosphere"),
 ("salon_subasta","elegant dim auction hall, restrained murmur of attendees, distant gavel, rustle of expensive clothes, whispering tension"),
 ("balneario","spa resort, softly running water, humid tiled echo, ventilation, faint ambient music, dripping"),
 ("tienda_dealer","sordid front shop, humming fridge, distant TV, flies, tension, muffled street outside"),
 ("sotano","dark damp mansion basement, constant dripping, stone echo, distant metal chains, silence"),
 ("almacen","empty industrial warehouse, huge metallic echo, expanding sheet metal, dripping, wind seeping in, distant resonant footsteps"),
 ("chatarreria","open scrapyard, settling metal, wind through scrap, distant barking dog, crane, desolate atmosphere"),
 ("torre","clock tower belfry, heavy turning gears, huge mechanical ticking, strong wind, pigeons, creaking wood at height"),
 ("cabana_ermitano","isolated mountain cabin, crackling fire, howling wind outside, creaking wood, high-altitude silence"),
 ("local_voluntario","modest parish hall, echo of large empty room, fluorescent, folding chairs, distant murmur, footsteps"),
 ("archivo_medico","medical records archive, fluorescent hum, metal shelves, paper, basement silence, stale air"),
 ("plaza_barrio","old neighborhood square at night, dripping fountain, distant footsteps, a dog, rolling shutter, city murmur and light rain"),
 ("iglesia_ext","church exterior on a stormy night, rain on stone, wind, distant deep bell, dripping gutter, far thunder"),
 ("callejon","dark damp alley, dripping pipe, echoing footsteps, fleeing cat, trash can, distant traffic, rain drops"),
 ("muelle","old dock at night, water lapping concrete, creaking ropes and metal, seagulls, distant ship horn, sea wind"),
 ("azotea","high rooftop at night, strong open wind, city humming far below, vibrating antennas, distant siren, sense of height"),
 ("barrio_alto","wealthy residential neighborhood, silence, crickets, sprinklers, a slow expensive car passing, gate, cushioned calm"),
 ("costa","coastal village, breaking waves, seagulls, sea wind, clanking rigging, distant buoy bell"),
 ("montana","cold mountain village, wind through pines, distant cowbells, stream, crow, thin air and silence"),
 ("ciudad2","downtown of a bigger city, continuous traffic, horns, crowd, distant siren, urban construction background"),
 ("ruta_clara","car interior on a night highway, steady engine, tire rolling noise, rain on windshield, turn signal, windshield wipers"),
 ("mapa_barrio","very faint nocturnal urban ambience bed, constant light rain, distant city, occasional low thunder, muffled distant traffic"),
 ("mapa_centro","faint big city rumble bed, distant continuous traffic, wind between buildings, very distant siren"),
 ("mapa_costa","soft coastal ambience bed, distant surf, occasional seagulls, sea breeze"),
 ("mapa_montana","mountain ambience bed, cold wind through pines, wide silence, distant bird of prey"),
 ("mapa_ciudad2","big city background bed, distant dense traffic, urban murmur, occasional sirens"),
 ("tablero_pistas","very subtle investigation desk ambience, handling paper, pushpin, tightening string, distant clock, pencil, focused silence"),
]

only = sys.argv[1] if len(sys.argv) > 1 else None
if only:
    AMB = [x for x in AMB if x[0] == only]

use_cuda = torch.cuda.is_available()
dtype = torch.float16 if use_cuda else torch.float32
torch.set_num_threads(os.cpu_count() or 8)

def build(offload):
    p = StableAudioPipeline.from_pretrained(MODEL, torch_dtype=dtype)
    if use_cuda:
        if offload:
            p.enable_model_cpu_offload()
        else:
            p.to("cuda")
    else:
        p.to("cpu")
    return p

print(f"cargando modelo... cuda={use_cuda} dtype={dtype} STEPS={STEPS} SECONDS={SECONDS} OFFLOAD={OFFLOAD}", flush=True)
pipe = build(OFFLOAD)
sr = pipe.vae.sampling_rate
print("modelo cargado. sr:", sr, flush=True)

def generate(prompt, seed):
    gen = torch.Generator("cpu").manual_seed(seed)
    return pipe(prompt, negative_prompt="Low quality, distorted",
                num_inference_steps=STEPS, audio_end_in_s=SECONDS,
                num_waveforms_per_prompt=1, generator=gen).audios

done = 0; t0 = time.time()
for i, (aid, prompt) in enumerate(AMB):
    path = os.path.join(OUT, aid + ".wav")
    if os.path.exists(path):
        continue
    ts = time.time()
    try:
        audio = generate(prompt, i)
    except torch.cuda.OutOfMemoryError:
        torch.cuda.empty_cache()
        if not OFFLOAD:
            print("OOM en GPU -> reconstruyo con cpu_offload y reintento", flush=True)
            OFFLOAD = True
            del pipe; torch.cuda.empty_cache()
            pipe = build(True)
            audio = generate(prompt, i)
        else:
            raise
    wav = audio[0].T.float().cpu().numpy()  # [N, 2]
    sf.write(path, wav, sr)
    done += 1
    dt = time.time() - ts
    print(f"[{i+1}/{len(AMB)}] {aid}.wav {dt:.0f}s", flush=True)

print(f"HECHO. generados={done} -> {OUT}  (total {(time.time()-t0)/60:.1f} min)", flush=True)
