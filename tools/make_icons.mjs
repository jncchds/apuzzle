// Generates every launcher/app icon from one vector design (the "pixel A").
// No dependencies: rounded rectangles are rasterized with 8x8 supersampling
// and written as PNG (and ICO for Windows) with node's zlib.
//   node tools/make_icons.mjs
import fs from 'node:fs';
import path from 'node:path';
import zlib from 'node:zlib';

const root = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/(\w:)/, '$1')), '..');

const BG = '#1B1F3B';
const OFF = '#2A3060';
const ON = '#FFC857';
const BAR = '#FF6B6B';
const A = ['01110', '10001', '12221', '10001', '10001'];

// Design space is 120x120; the 5x5 grid spans 78 units (cells 14, pitch 16).
const GRID = 78;

function hex(c, alpha = 1) {
  const n = parseInt(c.slice(1), 16);
  return [(n >> 16) & 255, (n >> 8) & 255, n & 255, alpha];
}

/// Shapes for an icon of [size] px. [bg]: 'rounded' | 'square' | null.
/// [gridSide]: grid side in px. [mono]: white cells for Android themed icons.
function shapes(size, { bg, gridSide, mono = false }) {
  const out = [];
  const u = size / 120;
  if (bg === 'rounded') out.push({ x: 0, y: 0, w: size, h: size, r: 26 * u, c: hex(BG) });
  if (bg === 'square') out.push({ x: 0, y: 0, w: size, h: size, r: 0, c: hex(BG) });
  const k = gridSide / GRID;
  const x0 = (size - gridSide) / 2;
  A.forEach((row, y) => [...row].forEach((ch, x) => {
    const c = mono
      ? (ch === '0' ? [255, 255, 255, 0.3] : [255, 255, 255, 1])
      : hex(ch === '0' ? OFF : ch === '1' ? ON : BAR);
    out.push({ x: x0 + x * 16 * k, y: x0 + y * 16 * k, w: 14 * k, h: 14 * k, r: 3 * k, c });
  }));
  return out;
}

function inside(s, px, py) {
  if (px < s.x || py < s.y || px > s.x + s.w || py > s.y + s.h) return false;
  const r = s.r;
  const cx = Math.min(Math.max(px, s.x + r), s.x + s.w - r);
  const cy = Math.min(Math.max(py, s.y + r), s.y + s.h - r);
  return (px - cx) ** 2 + (py - cy) ** 2 <= r * r;
}

function render(size, opts) {
  const list = shapes(size, opts);
  const px = Buffer.alloc(size * size * 4);
  const N = 8;
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      let r = 0, g = 0, b = 0, a = 0;
      for (let sy = 0; sy < N; sy++) {
        for (let sx = 0; sx < N; sx++) {
          const fx = x + (sx + 0.5) / N, fy = y + (sy + 0.5) / N;
          // Painter's order, premultiplied "over".
          let cr = 0, cg = 0, cb = 0, ca = 0;
          for (const s of list) {
            if (!inside(s, fx, fy)) continue;
            const sa = s.c[3];
            cr = s.c[0] * sa + cr * (1 - sa);
            cg = s.c[1] * sa + cg * (1 - sa);
            cb = s.c[2] * sa + cb * (1 - sa);
            ca = sa + ca * (1 - sa);
          }
          r += cr; g += cg; b += cb; a += ca;
        }
      }
      const i = (y * size + x) * 4;
      const n = N * N;
      px[i + 3] = Math.round((a / n) * 255);
      if (a > 0) {
        px[i] = Math.round(r / a);
        px[i + 1] = Math.round(g / a);
        px[i + 2] = Math.round(b / a);
      }
    }
  }
  return px;
}

const CRC = new Int32Array(256).map((_, n) => {
  let c = n;
  for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
  return c;
});
function crc32(buf) {
  let c = -1;
  for (const byte of buf) c = CRC[(c ^ byte) & 255] ^ (c >>> 8);
  return (c ^ -1) >>> 0;
}

function png(size, rgba, opaque) {
  const ch = opaque ? 3 : 4;
  const raw = Buffer.alloc(size * (size * ch + 1));
  for (let y = 0; y < size; y++) {
    raw[y * (size * ch + 1)] = 0;
    for (let x = 0; x < size; x++) {
      for (let k = 0; k < ch; k++) raw[y * (size * ch + 1) + 1 + x * ch + k] = rgba[(y * size + x) * 4 + k];
    }
  }
  const chunk = (type, data) => {
    const len = Buffer.alloc(4);
    len.writeUInt32BE(data.length);
    const td = Buffer.concat([Buffer.from(type), data]);
    const crc = Buffer.alloc(4);
    crc.writeUInt32BE(crc32(td));
    return Buffer.concat([len, td, crc]);
  };
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(size, 0);
  ihdr.writeUInt32BE(size, 4);
  ihdr[8] = 8;
  ihdr[9] = opaque ? 2 : 6;
  return Buffer.concat([
    Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]),
    chunk('IHDR', ihdr),
    chunk('IDAT', zlib.deflateSync(raw, { level: 9 })),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}

function ico(images) {
  const head = Buffer.alloc(6 + images.length * 16);
  head.writeUInt16LE(1, 2);
  head.writeUInt16LE(images.length, 4);
  let offset = head.length;
  images.forEach(({ size, data }, i) => {
    const e = 6 + i * 16;
    head[e] = size >= 256 ? 0 : size;
    head[e + 1] = size >= 256 ? 0 : size;
    head.writeUInt16LE(1, e + 4);
    head.writeUInt16LE(32, e + 6);
    head.writeUInt32LE(data.length, e + 8);
    head.writeUInt32LE(offset, e + 12);
    offset += data.length;
  });
  return Buffer.concat([head, ...images.map((im) => im.data)]);
}

function write(rel, data) {
  const file = path.join(root, rel);
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, data);
  console.log(rel);
}

// Rounded tile with transparent corners, grid at design size.
const rounded = (size) => png(size, render(size, { bg: 'rounded', gridSide: size * GRID / 120 }), false);
// Full-bleed square; [gridShare] is the grid side as a share of the icon.
const square = (size, gridShare) => png(size, render(size, { bg: 'square', gridSide: size * gridShare }), true);

// Android: legacy icons + adaptive layers (108dp canvas, 66dp safe circle).
const dpi = { mdpi: 1, hdpi: 1.5, xhdpi: 2, xxhdpi: 3, xxxhdpi: 4 };
for (const [name, m] of Object.entries(dpi)) {
  write(`android/app/src/main/res/mipmap-${name}/ic_launcher.png`, rounded(48 * m));
  const fg = 108 * m;
  write(`android/app/src/main/res/mipmap-${name}/ic_launcher_foreground.png`,
    png(fg, render(fg, { bg: null, gridSide: 44 * m }), false));
  write(`android/app/src/main/res/mipmap-${name}/ic_launcher_monochrome.png`,
    png(fg, render(fg, { bg: null, gridSide: 44 * m, mono: true }), false));
}

// iOS: opaque squares, the system applies the corner mask.
const iosDir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
const contents = JSON.parse(fs.readFileSync(path.join(root, iosDir, 'Contents.json'), 'utf8'));
const done = new Set();
for (const im of contents.images) {
  if (!im.filename || done.has(im.filename)) continue;
  done.add(im.filename);
  const px = Math.round(parseFloat(im.size) * parseInt(im.scale));
  write(`${iosDir}/${im.filename}`, square(px, GRID / 120));
}

// Web: favicon, PWA icons, maskable icons (80% safe circle).
write('web/favicon.png', rounded(32));
write('web/icons/Icon-192.png', rounded(192));
write('web/icons/Icon-512.png', rounded(512));
write('web/icons/Icon-maskable-192.png', square(192, 0.55));
write('web/icons/Icon-maskable-512.png', square(512, 0.55));

// Windows.
write('windows/runner/resources/app_icon.ico',
  ico([16, 24, 32, 48, 64, 128, 256].map((s) => ({ size: s, data: rounded(s) }))));

// Splash: the bare A on a transparent canvas, centred on the navy background.
// Android below 12 (launch_background.xml, 96dp) and iOS (LaunchImage, 96pt).
// Android 12+ reuses ic_launcher_foreground (values-v31/styles.xml); the web
// splash is an inline SVG in web/index.html.
const glyph = (side) => png(side, render(side, { bg: null, gridSide: side }), false);
for (const [name, m] of Object.entries(dpi)) {
  write(`android/app/src/main/res/drawable-${name}/splash_a.png`, glyph(96 * m));
}
const launchDir = 'ios/Runner/Assets.xcassets/LaunchImage.imageset';
write(`${launchDir}/LaunchImage.png`, glyph(96));
write(`${launchDir}/LaunchImage@2x.png`, glyph(192));
write(`${launchDir}/LaunchImage@3x.png`, glyph(288));

// Preview for docs.
write('docs/icon.png', rounded(256));
