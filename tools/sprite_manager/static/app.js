const $ = (s) => document.querySelector(s);
const state = { folder: null, name: null, native: null, scale: 6, erasing: false };
let history = [];   // pila de estados (dataURL) del editor para Deshacer

function pushHistory() {
  try {
    if (!off.width) return;
    history.push(off.toDataURL("image/png"));
    if (history.length > 30) history.shift();
    $("#undo").disabled = false;
  } catch (e) { /* canvas vacio */ }
}

async function undo() {
  if (!state.name || !history.length) return;
  const url = history.pop();
  await new Promise((res) => {
    const im = new Image();
    im.onload = () => {
      off.width = im.width; off.height = im.height;
      octx.clearRect(0, 0, off.width, off.height); octx.drawImage(im, 0, 0);
      render(); res();
    };
    im.src = url;
  });
  await fetch("/api/save_image", { method: "POST", headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ path: `${state.folder}/${state.name}`, png: off.toDataURL("image/png") }) });
  refreshThumb();
  if (!history.length) $("#undo").disabled = true;
}

const editCanvas = $("#editCanvas");
const ectx = editCanvas.getContext("2d");
const off = document.createElement("canvas");
const octx = off.getContext("2d");

async function init() {
  const cfg = await (await fetch("/api/config")).json();
  const fdiv = $("#folders");
  cfg.folders.forEach((f, i) => {
    const b = document.createElement("button");
    b.textContent = f;
    b.onclick = () => selectFolder(f, b);
    fdiv.appendChild(b);
    if (i === 0) b._first = b;
  });
  const sel = $("#sheetSel");
  cfg.sheets.forEach((s) => {
    const o = document.createElement("option");
    o.value = s; o.textContent = s; sel.appendChild(o);
  });
  const cutSel = $("#cutSheet");
  (cfg.root_pngs || []).forEach((s) => {
    const o = document.createElement("option");
    o.value = s; o.textContent = s; cutSel.appendChild(o);
  });
  const pref = (cfg.root_pngs || []).find(x => x === "mainchar.png");
  if (pref) cutSel.value = pref;
  if (cfg.folders.length) selectFolder(cfg.folders.find(x => x === "people") || cfg.folders[0],
    [...fdiv.children].find(b => b.textContent === (cfg.folders.find(x => x === "people") || cfg.folders[0])));
  addMsg("ai", "Hola detective. Selecciona un sprite y dime que ajustar, o pulsa 'Preguntar' con el frame actual para que lo analice.");
}

async function selectFolder(folder, btn) {
  state.folder = folder;
  document.querySelectorAll(".folders button").forEach(b => b.classList.remove("active"));
  if (btn) btn.classList.add("active");
  const frames = await (await fetch(`/api/frames?folder=${folder}`)).json();
  const g = $("#gallery");
  g.innerHTML = "";
  frames.forEach(fr => {
    const cell = document.createElement("div");
    cell.className = "cell";
    cell.innerHTML = `<div class="chk"><img src="${fr.url}&t=${Date.now()}"></div><div class="nm">${fr.name.replace('.png','')}</div>`;
    cell.onclick = () => { document.querySelectorAll(".cell").forEach(c => c.classList.remove("sel")); cell.classList.add("sel"); loadFrame(folder, fr.name); };
    g.appendChild(cell);
  });
}

function loadFrame(folder, name, keepHistory) {
  state.folder = folder; state.name = name;
  if (!keepHistory) { history = []; $("#undo").disabled = true; }
  $("#pvname").textContent = `${folder}/${name}`;
  if ($("#saveFolder")) $("#saveFolder").value = folder;
  if ($("#saveName")) $("#saveName").value = name.replace(/\.png$/i, "");
  const im = new Image();
  im.onload = () => {
    off.width = im.width; off.height = im.height;
    octx.clearRect(0, 0, off.width, off.height);
    octx.drawImage(im, 0, 0);
    render();
  };
  im.src = `/img?path=${folder}/${name}&t=${Date.now()}`;
}

function render() {
  const s = state.scale;
  editCanvas.width = off.width * s;
  editCanvas.height = off.height * s;
  ectx.imageSmoothingEnabled = false;
  ectx.clearRect(0, 0, editCanvas.width, editCanvas.height);
  ectx.drawImage(off, 0, 0, editCanvas.width, editCanvas.height);
}

$("#zoom").oninput = (e) => { state.scale = +e.target.value; render(); };
$("#eraseMode").onchange = (e) => { state.erasing = e.target.checked; };

function eraseAt(ev) {
  if (!state.erasing || !state.name) return;
  const rect = editCanvas.getBoundingClientRect();
  const x = Math.floor((ev.clientX - rect.left) / state.scale);
  const y = Math.floor((ev.clientY - rect.top) / state.scale);
  const b = +$("#brush").value;
  octx.clearRect(x - (b >> 1), y - (b >> 1), b, b);
  render();
}
let down = false;
editCanvas.addEventListener("mousedown", (e) => { down = true; if (state.erasing) pushHistory(); eraseAt(e); });
editCanvas.addEventListener("mousemove", (e) => { if (down) eraseAt(e); });
window.addEventListener("mouseup", () => { down = false; });

async function editOp(op, params) {
  if (!state.name) return;
  pushHistory();
  const body = { path: `${state.folder}/${state.name}`, ops: [{ op, ...params }] };
  await fetch("/api/edit", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
  loadFrame(state.folder, state.name, true);
  refreshThumb();
}

$("#undo").onclick = undo;
$("#undo").disabled = true;
window.addEventListener("keydown", (e) => {
  if (!$("#cutter").classList.contains("hidden")) return;
  if (["INPUT", "TEXTAREA"].includes((document.activeElement || {}).tagName)) return;
  if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "z") { e.preventDefault(); undo(); }
});

document.querySelectorAll("[data-op]").forEach(btn => {
  btn.onclick = () => {
    const op = btn.dataset.op;
    if (op === "trim") editOp("trim", { top: +$("#tT").value, bottom: +$("#tB").value, left: +$("#tL").value, right: +$("#tR").value });
    else if (op === "removebg") editOp("removebg", { v: +$("#bgv").value, sat: +$("#bgsat").value });
    else if (op === "colorkey") editOp("colorkey", { tol: +$("#cktol").value });
    else if (op === "defringe") editOp("defringe", { passes: 1 });
    else editOp(op, {});
  };
});

$("#saveErase").onclick = async () => {
  if (!state.name) return;
  const png = off.toDataURL("image/png");
  await fetch("/api/save_image", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ path: `${state.folder}/${state.name}`, png }) });
  refreshThumb();
  addMsg("ai", "Guardado.");
};

$("#saveAs").onclick = async () => {
  if (!state.name) return;
  let folder = $("#saveFolder").value.trim() || state.folder;
  let name = $("#saveName").value.trim() || state.name.replace(/\.png$/i, "");
  if (!name.toLowerCase().endsWith(".png")) name += ".png";
  const path = `${folder}/${name}`;
  if (folder === "_staging") { alert("Elige una carpeta destino real (p. ej. detective_frames), no _staging."); return; }
  const overwriting = !(folder === state.folder && name === state.name);
  const png = off.toDataURL("image/png");
  const r = await (await fetch("/api/save_image", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ path, png }) })).json();
  if (r.error) { addMsg("err", r.error); return; }
  ensureFolderButton(folder);
  addMsg("ai", `Guardado en assets/${path}${overwriting ? " (original reemplazado)" : ""}. Reimporta en Godot para verlo.`);
  const btn = [...document.querySelectorAll(".folders button")].find(b => b.textContent === folder);
  if (btn) await selectFolder(folder, btn);
};

$("#reload").onclick = () => state.name && loadFrame(state.folder, state.name);

$("#delFrame").onclick = async () => {
  if (!state.name || !confirm(`Borrar ${state.name}?`)) return;
  await fetch("/api/delete", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ path: `${state.folder}/${state.name}` }) });
  selectFolder(state.folder, [...document.querySelectorAll(".folders button")].find(b => b.classList.contains("active")));
};

function refreshThumb() {
  const cell = document.querySelector(".cell.sel img");
  if (cell) cell.src = `/img?path=${state.folder}/${state.name}&t=${Date.now()}`;
}

$("#runSlice").onclick = async () => {
  const sheet = $("#sheetSel").value;
  const params = { defringe: +$("#apDefringe").value, bg_v: +$("#apBgv").value, bg_sat: +$("#apBgsat").value,
    min_w: +$("#apMinW").value, min_h: +$("#apMinH").value, tol: +$("#apTol").value };
  addMsg("ai", `Re-recortando ${sheet}...`);
  const r = await (await fetch("/api/autoslice", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ sheet, params }) })).json();
  if (r.error) return addMsg("err", r.error);
  addMsg("ai", `Hecho: ${r.count} frames en assets/${r.folder}.`);
  selectFolder(r.folder, [...document.querySelectorAll(".folders button")].find(b => b.textContent === r.folder));
};

$("#cleanTiles").onclick = async () => {
  if (!confirm("Borrar todos los tile_*.png de assets?")) return;
  const r = await (await fetch("/api/cleanup_tiles", { method: "POST" })).json();
  addMsg("ai", `Borrados ${r.removed} tile_*.png.`);
};

// --- Asistente IA ---
function addMsg(cls, text) {
  const d = document.createElement("div");
  d.className = "msg " + cls;
  d.textContent = text;
  $("#chat").appendChild(d);
  $("#chat").scrollTop = $("#chat").scrollHeight;
}

$("#ask").onclick = async () => {
  const prompt = $("#prompt").value.trim();
  if (!prompt && !$("#withImage").checked) return;
  addMsg("user", prompt || "(analiza el frame actual)");
  $("#prompt").value = "";
  const body = { prompt };
  if ($("#withImage").checked && state.name) body.image_path = `${state.folder}/${state.name}`;
  addMsg("ai", "…");
  const chat = $("#chat");
  const pending = chat.lastChild;
  try {
    const r = await (await fetch("/api/assistant", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) })).json();
    pending.remove();
    if (r.error) addMsg("err", r.error);
    else addMsg("ai", r.reply);
  } catch (e) { pending.remove(); addMsg("err", String(e)); }
};

// ---------------------------------------------------------------------------
//  Generar NPC por IA (NVIDIA FLUX) — corre en la maquina del usuario
// ---------------------------------------------------------------------------
const NPC_STYLE = "Top-down 2D ARPG pixel art character, dark noir urban night mood, warm rim lighting, rich pixel shading, in the exact style of a 'Pixel Perfect - Detective Collection' character pack. Full-body character reference sheet: the SAME character in four views left-to-right - FRONT, LEFT side, BACK, RIGHT side. Even spacing, same height, centered. Plain flat light-gray background color #d7d7d1, NO text, NO labels, NO grid, NO ground shadow, clean edges for cropping. Character: ";
const NPC_PRESETS = [
  { label: "Don Emilio (vecino anciano)", name: "npc_emilio",
    desc: "an elderly neighbourhood man ~75, slightly hunched, dark wool beret, worn brown overcoat, knitted scarf, round glasses, white moustache, leaning on a wooden cane, warm but frightened." },
  { label: "Rosa (vecina de verde)", name: "npc_rosa",
    desc: "a middle-aged woman ~40, long dark-green dress with a woollen shawl, hair in a bun, arms crossed, watchful distrustful expression." },
  { label: "Tomás (tendero)", name: "npc_tomas",
    desc: "a sturdy male shopkeeper ~50, bald with a short goatee, canvas shop apron over a rolled-up shirt, a cloth rag over one shoulder, friendly talkative." },
  { label: "Doña Carmen (anciana de luto)", name: "npc_carmen",
    desc: "a small elderly woman ~80 in black mourning clothes with a black headscarf/mantilla, holding a rosary, piercing knowing gaze." },
  { label: "Sargento Núñez (policía)", name: "npc_nunez",
    desc: "a male police sergeant ~45 in a dark navy-blue uniform with a peaked cap, badge and duty belt, serious tired expression, worn authority." },
];

function fillNpcPreset(i) {
  const p = NPC_PRESETS[i]; if (!p) return;
  $("#npcPrompt").value = NPC_STYLE + p.desc;
  $("#npcName").value = p.name;
}
(function initNpc() {
  const sel = $("#npcPreset");
  NPC_PRESETS.forEach((p, i) => { const o = document.createElement("option"); o.value = i; o.textContent = p.label; sel.appendChild(o); });
  sel.onchange = () => fillNpcPreset(+sel.value);
  fillNpcPreset(0);
})();

$("#npcGen").onclick = async () => {
  const prompt = $("#npcPrompt").value.trim();
  const name = $("#npcName").value.trim();
  if (!prompt) return;
  const st = $("#npcStatus");
  st.textContent = "Generando… (puede tardar ~30-60 s la primera vez)";
  $("#npcGen").disabled = true;
  try {
    const body = { prompt, name, size: +$("#npcSize").value, steps: +$("#npcSteps").value };
    const r = await (await fetch("/api/gen_image", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) })).json();
    if (r.error) { st.textContent = "❌ " + r.error; addMsg("err", r.error); return; }
    st.innerHTML = `✅ Guardado <b>${r.name}</b>. Ábrela en «Cortar hoja».`;
    addMsg("ai", `NPC generado: assets/${r.name}. Selecciónala en «Cortar hoja (ratón)» para recortar las 4 vistas.`);
    const cutSel = $("#cutSheet");
    if (![...cutSel.options].some(o => o.value === r.name)) {
      const o = document.createElement("option"); o.value = r.name; o.textContent = r.name; cutSel.appendChild(o);
    }
    cutSel.value = r.name;
  } catch (e) { st.textContent = "❌ " + e; addMsg("err", String(e)); }
  finally { $("#npcGen").disabled = false; }
};

// ---------------------------------------------------------------------------
//  Cortar hoja (raton): auto-detecta cajas y se ajustan con el raton
// ---------------------------------------------------------------------------
const cut = { sheet: null, img: null, w: 0, h: 0, scale: 1, boxes: [], sel: null };
const cutCanvas = $("#cutCanvas");
const cctx = cutCanvas.getContext("2d");
const cutBoxes = $("#cutBoxes");

$("#cutOpen").onclick = () => openCutter($("#cutSheet").value);
$("#cutClose").onclick = () => $("#cutter").classList.add("hidden");
$("#cutRedetect").onclick = () => detectBoxes();
$("#cutAdd").onclick = () => {
  const b = { x: Math.round(cut.w * 0.45), y: Math.round(cut.h * 0.45), w: 60, h: 80, name: "" };
  cut.boxes.push(b); renderBoxes(); selectBox(b);
};
$("#cutDel").onclick = () => {
  if (!cut.sel) return;
  cut.boxes = cut.boxes.filter(b => b !== cut.sel); cut.sel = null; renderBoxes();
};
$("#cutZoom").oninput = (e) => { cut.scale = +e.target.value; drawSheet(); renderBoxes(); };

// Dibujar una caja nueva arrastrando sobre zona vacia de la hoja
$("#cutWrap").addEventListener("pointerdown", (e) => {
  if (e.target.closest(".cbox")) return;              // sobre una caja: la maneja startDrag
  if (!cut.img) return;
  e.preventDefault();
  const wrap = $("#cutWrap").getBoundingClientRect();
  const s = () => cut.scale;
  const x0 = (e.clientX - wrap.left) / s(), y0 = (e.clientY - wrap.top) / s();
  const temp = document.createElement("div");
  temp.className = "cbox sel drawing"; cutBoxes.appendChild(temp);
  let box = null;
  const move = (ev) => {
    const x1 = (ev.clientX - wrap.left) / s(), y1 = (ev.clientY - wrap.top) / s();
    const x = Math.min(x0, x1), y = Math.min(y0, y1), w = Math.abs(x1 - x0), h = Math.abs(y1 - y0);
    temp.style.left = (x * s()) + "px"; temp.style.top = (y * s()) + "px";
    temp.style.width = (w * s()) + "px"; temp.style.height = (h * s()) + "px";
    box = { x: Math.round(x), y: Math.round(y), w: Math.round(w), h: Math.round(h) };
  };
  const up = () => {
    window.removeEventListener("pointermove", move); window.removeEventListener("pointerup", up);
    temp.remove();
    if (box && box.w >= 4 && box.h >= 4) {
      box.x = Math.max(0, Math.min(box.x, cut.w - 1)); box.y = Math.max(0, Math.min(box.y, cut.h - 1));
      box.w = Math.min(box.w, cut.w - box.x); box.h = Math.min(box.h, cut.h - box.y);
      box.name = ""; cut.boxes.push(box); renderBoxes(); selectBox(box);
    }
  };
  window.addEventListener("pointermove", move); window.addEventListener("pointerup", up);
});

// Enviar la caja seleccionada al editor manual (crop crudo en _staging)
$("#cutToEditor").onclick = async () => {
  if (!cut.sel) return alert("Selecciona o dibuja una caja primero.");
  const nm = (cut.sel.name || "crop");
  const body = { sheet: cut.sheet, out: "_staging", name: nm,
    box: { x: cut.sel.x, y: cut.sel.y, w: cut.sel.w, h: cut.sel.h } };
  const r = await (await fetch("/api/crop_raw", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) })).json();
  if (r.error) return alert(r.error);
  $("#cutter").classList.add("hidden");
  const btn = ensureFolderButton(r.folder);
  await selectFolder(r.folder, btn);
  loadFrame(r.folder, r.name);
  addMsg("ai", `Recorte en assets/${r.folder}/${r.name}. Ajústalo con Manual/Goma y guarda (Deshacer con Ctrl+Z).`);
};

function ensureFolderButton(folder) {
  const fdiv = $("#folders");
  let btn = [...fdiv.children].find((b) => b.textContent === folder);
  if (!btn) {
    btn = document.createElement("button");
    btn.textContent = folder;
    btn.onclick = () => selectFolder(folder, btn);
    fdiv.appendChild(btn);
  }
  return btn;
}

async function openCutter(sheet) {
  cut.sheet = sheet;
  $("#cutTitle").textContent = sheet;
  $("#cutter").classList.remove("hidden");
  const im = new Image();
  im.onload = async () => {
    cut.img = im; cut.w = im.width; cut.h = im.height;
    // escala inicial para caber a lo ancho del stage
    const avail = $("#cutStage").clientWidth - 40;
    cut.scale = Math.min(2, Math.max(0.3, avail / im.width));
    $("#cutZoom").value = cut.scale.toFixed(1);
    drawSheet();
    await detectBoxes();
  };
  im.src = `/img?path=${sheet}&t=${Date.now()}`;
}

function drawSheet() {
  cutCanvas.width = Math.round(cut.w * cut.scale);
  cutCanvas.height = Math.round(cut.h * cut.scale);
  cctx.imageSmoothingEnabled = false;
  cctx.clearRect(0, 0, cutCanvas.width, cutCanvas.height);
  if (cut.img) cctx.drawImage(cut.img, 0, 0, cutCanvas.width, cutCanvas.height);
}

async function detectBoxes() {
  const body = { sheet: cut.sheet, params: {} };
  const r = await (await fetch("/api/detect_boxes", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) })).json();
  if (r.error) { alert(r.error); return; }
  cut.boxes = (r.boxes || []).map((b, i) => ({ ...b, name: "" }));
  cut.sel = null;
  renderBoxes();
}

function renderBoxes() {
  cutBoxes.innerHTML = "";
  $("#cutCount").textContent = `${cut.boxes.length} cajas`;
  cut.boxes.forEach((b, i) => {
    const el = document.createElement("div");
    el.className = "cbox" + (b === cut.sel ? " sel" : "");
    el.style.left = (b.x * cut.scale) + "px";
    el.style.top = (b.y * cut.scale) + "px";
    el.style.width = (b.w * cut.scale) + "px";
    el.style.height = (b.h * cut.scale) + "px";
    const lab = document.createElement("div");
    lab.className = "cblabel";
    lab.textContent = (b.name ? b.name : "#" + i) + (b.flip ? " ⇄" : "");
    el.appendChild(lab);
    ["nw", "n", "ne", "e", "se", "s", "sw", "w"].forEach(h => {
      const hd = document.createElement("div"); hd.className = "h " + h; hd.dataset.h = h; el.appendChild(hd);
    });
    el.addEventListener("pointerdown", (ev) => startDrag(ev, b, el));
    el.addEventListener("dblclick", (ev) => { ev.stopPropagation(); renameBox(b, el); });
    b._el = el;
    cutBoxes.appendChild(el);
  });
}

function selectBox(b) { cut.sel = b; renderBoxes(); }

function renameBox(b, el) {
  selectBox(b);
  const inp = document.createElement("input");
  inp.className = "cbname"; inp.value = b.name || "";
  inp.placeholder = "nombre";
  b._el.appendChild(inp); inp.focus(); inp.select();
  const done = () => { b.name = inp.value.trim(); renderBoxes(); };
  inp.addEventListener("keydown", e => { if (e.key === "Enter") { e.preventDefault(); done(); } if (e.key === "Escape") renderBoxes(); });
  inp.addEventListener("blur", done);
  inp.addEventListener("pointerdown", e => e.stopPropagation());
}

function startDrag(ev, b, el) {
  ev.preventDefault(); ev.stopPropagation();
  selectBox(b);
  const handle = ev.target.dataset.h || null;
  const sx = ev.clientX, sy = ev.clientY;
  const o = { x: b.x, y: b.y, w: b.w, h: b.h };
  const move = (e) => {
    const dx = (e.clientX - sx) / cut.scale, dy = (e.clientY - sy) / cut.scale;
    let { x, y, w, h } = o;
    if (!handle) { x = o.x + dx; y = o.y + dy; }
    else {
      if (handle.includes("w")) { x = o.x + dx; w = o.w - dx; }
      if (handle.includes("e")) { w = o.w + dx; }
      if (handle.includes("n")) { y = o.y + dy; h = o.h - dy; }
      if (handle.includes("s")) { h = o.h + dy; }
    }
    w = Math.max(3, w); h = Math.max(3, h);
    x = Math.min(Math.max(0, x), cut.w - 3); y = Math.min(Math.max(0, y), cut.h - 3);
    w = Math.min(w, cut.w - x); h = Math.min(h, cut.h - y);
    b.x = Math.round(x); b.y = Math.round(y); b.w = Math.round(w); b.h = Math.round(h);
    const s = cut.scale;
    b._el.style.left = (b.x * s) + "px"; b._el.style.top = (b.y * s) + "px";
    b._el.style.width = (b.w * s) + "px"; b._el.style.height = (b.h * s) + "px";
  };
  const up = () => { window.removeEventListener("pointermove", move); window.removeEventListener("pointerup", up); };
  window.addEventListener("pointermove", move); window.addEventListener("pointerup", up);
}

document.addEventListener("keydown", (e) => {
  if ($("#cutter").classList.contains("hidden")) return;
  if (e.target.tagName === "INPUT") return;
  if ((e.key === "Delete" || e.key === "Backspace") && cut.sel) { e.preventDefault(); $("#cutDel").click(); }
  if (e.key.toLowerCase() === "f" && cut.sel) { cut.sel.flip = !cut.sel.flip; renderBoxes(); }
});

$("#cutExport").onclick = async () => {
  if (!cut.boxes.length) return alert("No hay cajas que exportar.");
  const opts = {
    removebg: $("#cutRmbg").checked, trim: $("#cutTrim").checked,
    cell_w: +$("#cutCW").value, cell_h: +$("#cutCH").value,
  };
  const boxes = cut.boxes.map((b, i) => ({ x: b.x, y: b.y, w: b.w, h: b.h, name: b.name || String(i), flip: !!b.flip }));
  const body = { sheet: cut.sheet, out: $("#cutOut").value.trim(), prefix: $("#cutPrefix").value, opts, boxes };
  const r = await (await fetch("/api/export_boxes", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) })).json();
  if (r.error) return alert(r.error);
  addMsg("ai", `Exportados ${r.count} frames a assets/${r.folder}: ${r.files.slice(0, 8).join(", ")}${r.files.length > 8 ? "…" : ""}`);
  const btn = [...document.querySelectorAll(".folders button")].find(x => x.textContent === r.folder);
  if (btn) selectFolder(r.folder, btn);
};

init();
