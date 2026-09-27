// Stage 1b of the nonogram catalog build: asks a vision model (any
// OpenAI-compatible server with logprobs, e.g. LM Studio) how recognisable each
// picture is at each width, and picks the smallest width that still reads.
// Reads cache/candidates.jsonl, writes cache/judge.jsonl (resumable: answers
// are cached in cache/judge-answers.jsonl, so reruns only ask what's new).
//   node tools/nonogram/judge.mjs --api=http://192.168.2.33:1234/v1 --model=qwen/qwen3.8-27b [--parallel=8] [--limit=N]
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { Resvg } from '@resvg/resvg-js';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/(\w:)/, '$1'));
const args = Object.fromEntries(process.argv.slice(2).map((a) => a.replace(/^--/, '').split('=')));
const API = args.api ?? 'http://localhost:1234/v1';
const MODEL = args.model ?? 'qwen/qwen3.8-27b';
const PARALLEL = Number(args.parallel ?? 8);

export const MIN_WIDTH = 7;
/// A picture must reach this probability at its biggest size to be kept.
const MIN_TOP = 0.4;
/// Smallest width whose probability is at least this share of the best one
/// (and at least MIN_P).
const KNEE = 0.8;
const MIN_P = 0.35;
const OPTIONS = 8;
/// The model is a strict grader: fair names ("cow" for bison) get P(yes)
/// 0.2–0.5, wrong ones ("knife" for banana) under 0.15.
const MATCH_P = 0.2;
const LETTERS = 'ABCDEFGHIJKLMNOP';

const cacheDir = path.join(here, 'cache');
const answersPath = path.join(cacheDir, 'judge-answers.jsonl');
const answers = new Map();
if (fs.existsSync(answersPath)) {
  for (const l of fs.readFileSync(answersPath, 'utf8').split('\n')) {
    if (!l) continue;
    const a = JSON.parse(l);
    answers.set(a.key, a.p);
  }
}
const answersOut = fs.createWriteStream(answersPath, { flags: 'a' });

const nameOf = (id) => id.split(':')[1].replace(/-/g, ' ');
const hash = (s) => crypto.createHash('sha1').update(s).digest('hex').slice(0, 16);

/// Deterministic decoys from the same library, with no word shared with the
/// true name (so "bison head" can't compete with "bison").
function optionsFor(id, names) {
  const truth = nameOf(id);
  const words = new Set(truth.split(' '));
  let s = parseInt(hash(id).slice(0, 8), 16);
  const rnd = () => (s = (Math.imul(s, 1103515245) + 12345) >>> 0) / 2 ** 32;
  const opts = [truth];
  for (let tries = 0; opts.length < OPTIONS && tries < 1000; tries++) {
    const n = names[Math.floor(rnd() * names.length)];
    if (!opts.includes(n) && !n.split(' ').some((w) => words.has(w))) opts.push(n);
  }
  for (let i = opts.length - 1; i > 0; i--) {
    const j = Math.floor(rnd() * (i + 1));
    [opts[i], opts[j]] = [opts[j], opts[i]];
  }
  return opts;
}

/// Black (or palette) cells on white, 24 px per cell, with a margin.
function png(c, colors) {
  const S = 24;
  const pad = S * 2;
  let body = '';
  for (let i = 0; i < c.cells.length; i++) {
    const v = c.cells.charCodeAt(i) - 48;
    if (!v) continue;
    body += `<rect x="${(i % c.w) * S}" y="${Math.floor(i / c.w) * S}" width="${S}" height="${S}" fill="${colors ? colors[v - 1] : '#000'}"/>`;
  }
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${c.w * S + pad * 2}" height="${c.h * S + pad * 2}"><rect width="100%" height="100%" fill="#fff"/><g transform="translate(${pad},${pad})">${body}</g></svg>`;
  return new Resvg(svg).render().asPng();
}

/// One cached chat completion. [image]: PNG buffer or null. Returns the
/// message text and the first token's top logprobs.
async function chat(key, image, text, maxTokens) {
  if (answers.has(key)) return answers.get(key);
  const content = [{ type: 'text', text }];
  if (image) content.unshift({ type: 'image_url', image_url: { url: 'data:image/png;base64,' + image.toString('base64') } });
  const body = { model: MODEL, temperature: 0, max_tokens: maxTokens, reasoning_effort: 'none', logprobs: true, top_logprobs: 10, messages: [{ role: 'user', content }] };
  for (let attempt = 0; ; attempt++) {
    try {
      const r = await fetch(`${API}/chat/completions`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
      const j = await r.json();
      const ch = j.choices?.[0];
      if (!ch) throw new Error(JSON.stringify(j).slice(0, 200));
      const res = { text: (ch.message?.content ?? '').trim(), top: (ch.logprobs?.content?.[0]?.top_logprobs ?? []).map((t) => [t.token, t.logprob]) };
      answers.set(key, res);
      answersOut.write(JSON.stringify({ key, p: res }) + '\n');
      return res;
    } catch (e) {
      if (attempt >= 4) throw e;
      await new Promise((ok) => setTimeout(ok, 2000 * (attempt + 1)));
    }
  }
}

/// Probability of a first token spelling [word] (case-insensitive).
const probOf = (res, word) => Math.round(res.top.filter(([t]) => t.trim().toLowerCase() === word.toLowerCase()).reduce((s, [, lp]) => s + Math.exp(lp), 0) * 1000) / 1000;

/// Blind test: the model names the grid, then judges (text only) whether that
/// name counts as recognising the icon. Returns [passed, answer].
async function blindName(id, c, colors) {
  const q = 'This is low-resolution pixel art of one thing: an object, animal, person, symbol or scene. What does it show? Answer with 1-3 words only.';
  const guess = (await chat(hash(`${MODEL}|name3|${id}|${c.w}x${c.h}|${c.cells}`), png(c, colors), q, 12)).text.replace(/[.:\n].*$/s, '').trim();
  const truth = nameOf(id);
  const q2 = `A player looked at a small pixel-art picture of "${truth}" and said it shows "${guess}". Does that count as recognising it (the same thing, a synonym, or a very close relative, e.g. "cow" for "bison" or "car" for "sedan")? Answer yes or no.`;
  const res = await chat(hash(`${MODEL}|match|${truth}|${guess.toLowerCase()}`), null, q2, 1);
  return [probOf(res, 'yes') >= MATCH_P, guess];
}

/// Probability the model gives the right letter for grid [c].
async function judge(id, c, colors, opts) {
  const right = LETTERS[opts.indexOf(nameOf(id))];
  const q = 'This is low-resolution pixel art. Which option does it most likely show?\n' + opts.map((o, i) => `${LETTERS[i]}) ${o}`).join('\n') + '\nAnswer with the letter only.';
  return probOf(await chat(hash(`${MODEL}|${id}|${c.w}x${c.h}|${c.cells}|${opts.join(',')}`), png(c, colors), q, 1), right);
}

/// Best-fidelity candidate per width.
function bestPerWidth(cands) {
  const by = new Map();
  for (const c of cands) if (c.w >= MIN_WIDTH && (!by.has(c.w) || c.fid > by.get(c.w).fid)) by.set(c.w, c);
  return [...by.values()].sort((a, b) => a.w - b.w);
}

/// Scores the biggest size, then binary-searches the smallest width that
/// reaches the knee (recognisability grows with size, roughly).
async function processIcon(e, names) {
  const opts = optionsFor(e.id, names);
  const sizes = bestPerWidth(e.cands);
  if (!sizes.length) return { id: e.id, pick: null, why: 'no size' };
  const scores = {};
  const score = async (c) => (scores[c.w] ??= await judge(e.id, c, e.colors, opts));
  const top = await score(sizes[sizes.length - 1]);
  if (top < MIN_TOP) return { id: e.id, pick: null, why: 'not recognisable', scores };
  const target = Math.max(MIN_P, KNEE * top);
  let lo = 0;
  let hi = sizes.length - 1;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if ((await score(sizes[mid])) >= target) hi = mid;
    else lo = mid + 1;
  }
  // Blind naming at the picked size; if it fails, try bigger sizes.
  const guesses = {};
  for (let i = lo; i < sizes.length; i = i === sizes.length - 1 ? sizes.length : Math.min(i + 2, sizes.length - 1)) {
    const [ok, guess] = await blindName(e.id, sizes[i], e.colors);
    guesses[sizes[i].w] = guess;
    if (ok) return { id: e.id, pick: sizes[i].w, scores, guesses };
  }
  return { id: e.id, pick: null, why: 'not named', scores, guesses };
}

async function main() {
  const icons = fs.readFileSync(path.join(cacheDir, 'candidates.jsonl'), 'utf8').trim().split('\n').map(JSON.parse);
  const limit = args.limit ? Number(args.limit) : icons.length;
  const names = {};
  for (const e of icons) (names[e.id.split(':')[0]] ??= []).push(nameOf(e.id));
  const out = [];
  let next = 0;
  let done = 0;
  const t0 = Date.now();
  const todo = icons.slice(0, limit);
  await Promise.all(
    Array.from({ length: PARALLEL }, async () => {
      while (next < todo.length) {
        const e = todo[next++];
        out.push(await processIcon(e, names[e.id.split(':')[0]]));
        if (++done % 100 === 0) {
          const rate = done / ((Date.now() - t0) / 1000);
          console.log(`${done}/${todo.length} icons, ${rate.toFixed(2)}/s, ~${Math.round((todo.length - done) / rate / 60)} min left`);
        }
      }
    }),
  );
  out.sort((a, b) => a.id.localeCompare(b.id));
  fs.writeFileSync(path.join(cacheDir, 'judge.jsonl'), out.map((o) => JSON.stringify(o)).join('\n') + '\n');
  const kept = out.filter((o) => o.pick);
  const hist = {};
  for (const o of kept) hist[o.pick] = (hist[o.pick] ?? 0) + 1;
  console.log(`judged ${out.length} in ${((Date.now() - t0) / 1000).toFixed(0)} s: ${kept.length} recognisable; picked widths ${JSON.stringify(hist)}`);
  answersOut.end();
}

main();
