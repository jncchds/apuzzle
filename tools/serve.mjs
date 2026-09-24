#!/usr/bin/env node
// Minimal static file server: node tools/serve.mjs [dir=build/web] [port=8080]
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(process.argv[2] ?? 'build/web');
const port = Number(process.argv[3] ?? 8080);
const types = { '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript', '.json': 'application/json', '.css': 'text/css', '.png': 'image/png', '.svg': 'image/svg+xml', '.wasm': 'application/wasm', '.ico': 'image/x-icon', '.otf': 'font/otf', '.ttf': 'font/ttf', '.woff2': 'font/woff2' };

http.createServer((req, res) => {
  let p = path.join(root, decodeURIComponent(new URL(req.url, 'http://x').pathname));
  if (!p.startsWith(root)) { res.writeHead(403).end(); return; }
  if (fs.existsSync(p) && fs.statSync(p).isDirectory()) p = path.join(p, 'index.html');
  if (!fs.existsSync(p)) p = path.join(root, 'index.html');
  res.writeHead(200, { 'Content-Type': types[path.extname(p)] ?? 'application/octet-stream', 'Cache-Control': 'no-store' });
  fs.createReadStream(p).pipe(res);
}).listen(port, () => console.log(`serving ${root} on http://localhost:${port}`));
