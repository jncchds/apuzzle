// Contact sheets of the last build (cache/review.json) as PNGs:
// cache/sheet-<mode>-<difficulty>[-<page>].png, each picture's source icon next
// to its grid, sorted by difficulty score.
//   node tools/nonogram/sheet.mjs [--per=60]
import fs from 'node:fs';
import path from 'node:path';
import { Resvg } from '@resvg/resvg-js';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/(\w:)/, '$1'));
const args = Object.fromEntries(process.argv.slice(2).map((a) => a.replace(/^--/, '').split('=')));
const per = Number(args.per ?? 60);
const entries = JSON.parse(fs.readFileSync(path.join(here, 'cache', 'review.json'), 'utf8'));
const sets = {};
const setOf = (n) => (sets[n] ??= JSON.parse(fs.readFileSync(path.join(here, 'node_modules', '@iconify-json', n, 'icons.json'), 'utf8')));

const COLS = 6;
const TILE_W = 250;
const TILE_H = 140;
const ICON = 90;
const CELL = 6;

function tile(e, x, y) {
  const [name, id] = e.id.split(':');
  const set = setOf(name);
  const ic = set.icons[id];
  const w = ic.width ?? set.width ?? 16;
  const h = ic.height ?? set.height ?? 16;
  let s = `<svg x="${x + 6}" y="${y + 6}" width="${ICON}" height="${ICON}" viewBox="${ic.left ?? 0} ${ic.top ?? 0} ${w} ${h}" color="#111">${ic.body}</svg>`;
  const gx = x + ICON + 16;
  const gy = y + 6;
  s += `<rect x="${gx - 1}" y="${gy - 1}" width="${e.w * CELL + 2}" height="${e.h * CELL + 2}" fill="none" stroke="#ccc"/>`;
  for (let i = 0; i < e.cells.length; i++) {
    const v = e.cells.charCodeAt(i) - 48;
    if (!v) continue;
    const fill = e.colors.length ? e.colors[v - 1] : '#111';
    s += `<rect x="${gx + (i % e.w) * CELL}" y="${gy + Math.floor(i / e.w) * CELL}" width="${CELL}" height="${CELL}" fill="${fill}"/>`;
  }
  s += `<text x="${x + 6}" y="${y + TILE_H - 20}" font-size="11" font-family="Arial" fill="#333">${id.slice(0, 34)}</text>`;
  s += `<text x="${x + 6}" y="${y + TILE_H - 6}" font-size="11" font-family="Arial" fill="#888">${name} · ${e.w}×${e.h} · t${e.tier} · ${Math.round(e.score)}</text>`;
  return s;
}

const groups = {};
for (const e of entries) (groups[`${e.mode}-${e.difficulty}`] ??= []).push(e);
for (const [key, list] of Object.entries(groups)) {
  list.sort((a, b) => a.score - b.score);
  for (let p = 0; p * per < list.length; p++) {
    const page = list.slice(p * per, (p + 1) * per);
    const rows = Math.ceil(page.length / COLS);
    let body = `<rect width="100%" height="100%" fill="#fff"/>`;
    page.forEach((e, i) => (body += tile(e, (i % COLS) * TILE_W, Math.floor(i / COLS) * TILE_H)));
    const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${COLS * TILE_W}" height="${rows * TILE_H}">${body}</svg>`;
    const png = new Resvg(svg, { font: { loadSystemFonts: true } }).render().asPng();
    const file = path.join(here, 'cache', `sheet-${key}${p ? `-${p + 1}` : ''}.png`);
    fs.writeFileSync(file, png);
    console.log(path.relative(process.cwd(), file));
  }
}
