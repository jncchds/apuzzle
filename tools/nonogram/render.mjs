// Stage 1 of the nonogram catalog build: renders every source icon and writes
// candidate grids (several sizes, scales, offsets and thresholds) with a
// fidelity score to cache/candidates.jsonl. Stage 2 (build.dart) grades them
// with the game's solver. See README.md.
//   node tools/nonogram/render.mjs [--sources=game-icons,twemoji] [--limit=N] [--sample=N]
import fs from 'node:fs';
import path from 'node:path';
import { Resvg } from '@resvg/resvg-js';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/(\w:)/, '$1'));
const args = Object.fromEntries(process.argv.slice(2).map((a) => a.replace(/^--/, '').split('=')));

/// Render resolution (px) of the icon's view box.
const R = 256;
export const MIN_SIDE = 5;
export const MAX_WIDTH = 15;
export const MAX_HEIGHT = 20;
/// Grid scale relative to the picture's bounding box (1 = tight).
const SCALES = [1.0, 1.12, 1.25];
/// Grid offsets, in cells.
const OFFSETS = [[0, 0], [-1 / 3, 0], [1 / 3, 0], [0, -1 / 3], [0, 1 / 3]];
/// Share of a cell that must be covered for it to be filled.
const THRESHOLDS = [0.3, 0.45, 0.6];
/// Candidates kept per width (best fidelity first).
const KEEP = 4;
/// Colour pictures: at most this many colours; merge colours closer than MERGE_DE.
const MAX_COLORS = 4;
const MERGE_DE = 22;
const MIN_SHARE = 0.03;

export const SOURCES = {
  'game-icons': {
    mode: 'mono',
    skip: /^(abstract-|3d-)/,
  },
  'material-symbols': {
    mode: 'mono',
    // Filled base glyphs only; most UI/text glyphs don't make pictures.
    skip: /-(outline|rounded|sharp|off)$|^(\d|format-|text-|align-|border-|arrow|keyboard-|signal-|battery-|network-|wifi-|stat-|counter-|filter-|timer-\d|looks-|exposure-|brightness-|view-|table-|data-|density-|line-|space-|vertical-|horizontal-|flip-|rotate-|swap-|sort|subdirectory|chevron|expand-|unfold|first-page|last-page|more-|menu|check-box|radio-button|toggle-|indeterminate|crop-|grid-|splitscreen|width|height|padding|margin|position-|move-|open-in|call-made|call-received|north|south|east|west|trending|double-arrow|keyboard|123|abc|\w-\w$)/,
  },
  twemoji: {
    mode: 'color',
    skip: /^(flag-|keycap|regional-indicator|.*-button$|.*-skin-tone|.*-sign$|input-|a-button|ab-button|b-button|o-button|squared-|japanese-|circled-|.*-circle$|.*-square$|.*-heart$|.*-arrow)/,
  },
  openmoji: {
    mode: 'color',
    skip: /^(flag-|keycap|regional-indicator|.*-button$|.*-skin-tone|.*-sign$|input-|a-button|ab-button|b-button|o-button|squared-|japanese-|circled-|.*-circle$|.*-square$|.*-heart$|.*-arrow|extras-|.*-tone\d?$)/,
  },
};

function loadSet(name) {
  return JSON.parse(fs.readFileSync(path.join(here, 'node_modules', '@iconify-json', name, 'icons.json'), 'utf8'));
}

export function iconSvg(set, id, size = R) {
  const ic = set.icons[id];
  const w = ic.width ?? set.width ?? 16;
  const h = ic.height ?? set.height ?? 16;
  const l = ic.left ?? 0;
  const t = ic.top ?? 0;
  const s = size / Math.max(w, h);
  return `<svg xmlns="http://www.w3.org/2000/svg" color="#000" width="${Math.round(w * s)}" height="${Math.round(h * s)}" viewBox="${l} ${t} ${w} ${h}">${ic.body}</svg>`;
}

// --- colour helpers --------------------------------------------------------

function srgbToLab(r, g, b) {
  const lin = (c) => ((c /= 255) <= 0.04045 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4);
  const [R_, G, B] = [lin(r), lin(g), lin(b)];
  const x = (0.4124 * R_ + 0.3576 * G + 0.1805 * B) / 0.95047;
  const y = 0.2126 * R_ + 0.7152 * G + 0.0722 * B;
  const z = (0.0193 * R_ + 0.1192 * G + 0.9505 * B) / 1.08883;
  const f = (v) => (v > 0.008856 ? Math.cbrt(v) : 7.787 * v + 16 / 116);
  return [116 * f(y) - 16, 500 * (f(x) - f(y)), 200 * (f(y) - f(z))];
}

const dist = (a, b) => Math.hypot(a[0] - b[0], a[1] - b[1], a[2] - b[2]);
const hex = (c) => '#' + c.map((v) => v.toString(16).padStart(2, '0')).join('');

/// Weighted k-means in Lab, seeded deterministically (heaviest colour, then
/// farthest by weight). Returns clusters {lab, rgb (most common member), w}.
function kmeans(colors, k) {
  const centers = [colors[0].lab];
  while (centers.length < k) {
    let best = null;
    let bestScore = -1;
    for (const c of colors) {
      const d = Math.min(...centers.map((m) => dist(m, c.lab)));
      const s = d * d * c.w;
      if (s > bestScore) [best, bestScore] = [c, s];
    }
    if (!best || bestScore === 0) break;
    centers.push(best.lab);
  }
  let assign = new Array(colors.length).fill(0);
  for (let it = 0; it < 20; it++) {
    assign = colors.map((c) => {
      let bi = 0;
      for (let i = 1; i < centers.length; i++) if (dist(centers[i], c.lab) < dist(centers[bi], c.lab)) bi = i;
      return bi;
    });
    for (let i = 0; i < centers.length; i++) {
      let sw = 0;
      const acc = [0, 0, 0];
      colors.forEach((c, j) => {
        if (assign[j] !== i) return;
        sw += c.w;
        for (let d = 0; d < 3; d++) acc[d] += c.lab[d] * c.w;
      });
      if (sw > 0) centers[i] = acc.map((v) => v / sw);
    }
  }
  const clusters = centers.map((lab) => ({ lab, w: 0, rgb: null, top: 0 }));
  let err = 0;
  let total = 0;
  colors.forEach((c, j) => {
    const cl = clusters[assign[j]];
    cl.w += c.w;
    if (c.w > cl.top) [cl.top, cl.rgb] = [c.w, c.rgb];
    err += dist(cl.lab, c.lab) * c.w;
    total += c.w;
  });
  return { clusters: clusters.filter((c) => c.w > 0), err: err / total };
}

/// Palette for a colour picture: the fewest clusters (2..MAX_COLORS) with a
/// small error, distinct colours, each a real share of the picture.
function palette(px, n) {
  const hist = new Map();
  for (let i = 0; i < n; i++) {
    if (px[i * 4 + 3] < 128) continue;
    // 5 bits per channel is plenty to group anti-aliasing shades.
    const key = ((px[i * 4] >> 3) << 10) | ((px[i * 4 + 1] >> 3) << 5) | (px[i * 4 + 2] >> 3);
    const e = hist.get(key);
    if (e) e.w++;
    else hist.set(key, { w: 1, rgb: [px[i * 4], px[i * 4 + 1], px[i * 4 + 2]] });
  }
  const colors = [...hist.values()].map((c) => ({ ...c, lab: srgbToLab(...c.rgb) })).sort((a, b) => b.w - a.w);
  if (colors.length === 0) return null;
  let pick = null;
  for (let k = 1; k <= MAX_COLORS; k++) {
    const res = kmeans(colors, k);
    pick = res;
    if (res.err < 10) break;
  }
  // Merge near-identical and tiny clusters into their nearest neighbour.
  let cl = pick.clusters.sort((a, b) => b.w - a.w);
  const total = cl.reduce((s, c) => s + c.w, 0);
  for (let changed = true; changed && cl.length > 1; ) {
    changed = false;
    for (let i = cl.length - 1; i > 0 && !changed; i--) {
      let near = 0;
      for (let j = 1; j < cl.length; j++) if (j !== i && dist(cl[j].lab, cl[i].lab) < dist(cl[near].lab, cl[i].lab)) near = j;
      if (near === i) near = 0;
      if (dist(cl[near].lab, cl[i].lab) < MERGE_DE || cl[i].w / total < MIN_SHARE) {
        cl[near].w += cl[i].w;
        cl.splice(i, 1);
        changed = true;
      }
    }
  }
  return cl;
}

// --- candidates ------------------------------------------------------------

/// Summed-area table of [f(i)] over a W×H image.
function sat(W, H, f) {
  const s = new Float64Array((W + 1) * (H + 1));
  for (let y = 0; y < H; y++) {
    let row = 0;
    for (let x = 0; x < W; x++) {
      row += f(y * W + x);
      s[(y + 1) * (W + 1) + x + 1] = s[y * (W + 1) + x + 1] + row;
    }
  }
  return s;
}

function box(s, W, x0, y0, x1, y1) {
  return s[y1 * (W + 1) + x1] - s[y0 * (W + 1) + x1] - s[y1 * (W + 1) + x0] + s[y0 * (W + 1) + x0];
}

/// Candidate grids for one rendered picture. [layers]: SAT per colour label
/// (index 0: any ink), [total]: ink sum; bbox in px.
function candidates(W, H, layers, total, bbox) {
  const clamp = (v, hi) => Math.max(0, Math.min(hi, Math.round(v)));
  const bw = bbox.x1 - bbox.x0;
  const bh = bbox.y1 - bbox.y0;
  const out = [];
  for (let w = MIN_SIDE; w <= MAX_WIDTH; w++) {
    const seen = new Set();
    const mine = [];
    for (const f of SCALES) {
      const s = (bw * f) / w;
      const h = Math.round((bh * f) / s);
      if (h < MIN_SIDE || h > MAX_HEIGHT) continue;
      for (const [ox, oy] of OFFSETS) {
        const gx = (bbox.x0 + bbox.x1) / 2 - (w * s) / 2 + ox * s;
        const gy = (bbox.y0 + bbox.y1) / 2 - (h * s) / 2 + oy * s;
        // Per-cell area, ink and ink per colour.
        const cells = [];
        for (let r = 0; r < h; r++) {
          for (let c = 0; c < w; c++) {
            const x0 = clamp(gx + c * s, W), x1 = clamp(gx + (c + 1) * s, W);
            const y0 = clamp(gy + r * s, H), y1 = clamp(gy + (r + 1) * s, H);
            const area = s * s;
            cells.push({ area, ink: box(layers[0], W, x0, y0, x1, y1), per: layers.slice(1).map((l) => box(l, W, x0, y0, x1, y1)) });
          }
        }
        for (const t of THRESHOLDS) {
          let inter = 0;
          let gridInk = 0;
          let both = 0;
          const vals = cells.map((cell) => {
            if (cell.ink < t * cell.area) return 0;
            let best = 0;
            for (let i = 1; i < cell.per.length; i++) if (cell.per[i] > cell.per[best]) best = i;
            gridInk += cell.area;
            both += cell.ink;
            inter += cell.per.length ? cell.per[best] : cell.ink;
            return best + 1;
          });
          const key = vals.join('');
          if (seen.has(key) || !vals.some((v) => v)) continue;
          seen.add(key);
          // Soft IoU of picture and grid (colours must match to count).
          const fid = inter / (total + gridInk - both);
          const fill = vals.filter((v) => v).length / vals.length;
          mine.push({ w, h, fid: Math.round(fid * 1000) / 1000, fill: Math.round(fill * 100) / 100, cells: key });
        }
      }
    }
    mine.sort((a, b) => b.fid - a.fid);
    out.push(...mine.slice(0, KEEP));
  }
  return out;
}

function processIcon(set, id, mode) {
  const svg = iconSvg(set, id);
  const img = new Resvg(svg, { background: 'rgba(0,0,0,0)' }).render();
  const W = img.width;
  const H = img.height;
  const px = img.pixels;
  const n = W * H;
  const alpha = (i) => px[i * 4 + 3] / 255;
  let bbox = { x0: W, y0: H, x1: 0, y1: 0 };
  for (let y = 0; y < H; y++) {
    for (let x = 0; x < W; x++) {
      if (alpha(y * W + x) <= 0.1) continue;
      bbox = { x0: Math.min(bbox.x0, x), y0: Math.min(bbox.y0, y), x1: Math.max(bbox.x1, x + 1), y1: Math.max(bbox.y1, y + 1) };
    }
  }
  if (bbox.x1 <= bbox.x0) return null;
  let colors = null;
  let layers;
  if (mode === 'mono') {
    layers = [sat(W, H, alpha)];
  } else {
    const pal = palette(px, n);
    if (!pal || pal.length < 2) return null;
    const label = new Int8Array(n).fill(-1);
    for (let i = 0; i < n; i++) {
      if (px[i * 4 + 3] < 128) continue;
      const lab = srgbToLab(px[i * 4], px[i * 4 + 1], px[i * 4 + 2]);
      let bi = 0;
      for (let k = 1; k < pal.length; k++) if (dist(pal[k].lab, lab) < dist(pal[bi].lab, lab)) bi = k;
      label[i] = bi;
    }
    layers = [sat(W, H, (i) => (label[i] >= 0 ? 1 : 0)), ...pal.map((_, k) => sat(W, H, (i) => (label[i] === k ? 1 : 0)))];
    colors = pal.map((c) => hex(c.rgb));
  }
  const total = box(layers[0], W, 0, 0, W, H);
  const cands = candidates(W, H, layers, total, bbox);
  if (!cands.length) return null;
  return { colors, cands };
}

function main() {
  const names = (args.sources ?? Object.keys(SOURCES).join(',')).split(',');
  const limit = args.limit ? Number(args.limit) : Infinity;
  const sample = args.sample ? Number(args.sample) : 0;
  const outDir = path.join(here, 'cache');
  fs.mkdirSync(outDir, { recursive: true });
  const out = fs.createWriteStream(path.join(outDir, 'candidates.jsonl'));
  for (const name of names) {
    const src = SOURCES[name];
    const set = loadSet(name);
    let ids = Object.keys(set.icons).filter((id) => !src.skip.test(id) && !set.icons[id].hidden).sort();
    // Evenly spaced sample, for quick looks.
    if (sample) ids = ids.filter((_, i) => i % Math.max(1, Math.floor(ids.length / sample)) === 0).slice(0, sample);
    ids = ids.slice(0, limit);
    const t0 = Date.now();
    let kept = 0;
    for (const id of ids) {
      const res = processIcon(set, id, src.mode);
      if (!res) continue;
      kept++;
      out.write(JSON.stringify({ id: `${name}:${id}`, mode: src.mode, ...res }) + '\n');
    }
    console.log(`${name}: ${kept}/${ids.length} icons in ${((Date.now() - t0) / 1000).toFixed(1)} s`);
  }
  out.end();
}

if (process.argv[1] && path.resolve(process.argv[1]) === path.resolve(here, 'render.mjs')) main();
