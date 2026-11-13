#!/usr/bin/env node
// Extract every Script/LocalScript/ModuleScript from a binary Roblox place (.rbxl)
// into a folder tree mirroring the Explorer, plus a hierarchy summary.
// Usage: node extract_rbxl.js ODDLINGS.rbxl ../src ../docs/HIERARCHY_FULL.md
// Requires Node >= 22.15 (built-in zstd). Read-only: the place file is never modified.
const fs = require('fs'), path = require('path'), zlib = require('zlib');
const [, , placeFile, outSrc, outTree] = process.argv;
const d = fs.readFileSync(placeFile);
if (d.slice(0, 8).toString('latin1') !== '<roblox!') throw new Error('not a binary place file');

function lz4Block(src, outLen) {
  const out = Buffer.alloc(outLen); let i = 0, o = 0;
  while (i < src.length) {
    const tok = src[i++]; let lit = tok >> 4;
    if (lit === 15) { let b; do { b = src[i++]; lit += b; } while (b === 255); }
    src.copy(out, o, i, i + lit); i += lit; o += lit;
    if (i >= src.length) break;
    const off = src[i] | (src[i + 1] << 8); i += 2;
    let ml = tok & 15;
    if (ml === 15) { let b; do { b = src[i++]; ml += b; } while (b === 255); }
    ml += 4;
    for (let k = 0; k < ml; k++) { out[o] = out[o - off]; o++; }
  }
  return out;
}

const chunks = [];
let p = 32;
while (p < d.length) {
  const name = d.slice(p, p + 4).toString('latin1').replace(/\0/g, '');
  const cl = d.readUInt32LE(p + 4), ul = d.readUInt32LE(p + 8);
  const raw = d.slice(p + 16, p + 16 + (cl || ul));
  let body = raw;
  if (cl) {
    body = raw.slice(0, 4).equals(Buffer.from([0x28, 0xb5, 0x2f, 0xfd])) ? zlib.zstdDecompressSync(raw) : lz4Block(raw, ul);
  }
  chunks.push({ name, body });
  p += 16 + (cl || ul);
  if (name === 'END') break;
}

function readInterleavedI32(buf, off, n) {
  const out = new Array(n);
  for (let k = 0; k < n; k++) {
    let v = (buf[off + k] << 24) | (buf[off + n + k] << 16) | (buf[off + 2 * n + k] << 8) | buf[off + 3 * n + k];
    v = v >>> 0; out[k] = (v >>> 1) ^ -(v & 1);
  }
  return out;
}
function readRefs(buf, off, n) { const v = readInterleavedI32(buf, off, n); for (let k = 1; k < n; k++) v[k] += v[k - 1]; return v; }

const classes = {}, objs = {};
for (const c of chunks) if (c.name === 'INST') {
  const b = c.body; let o = 0;
  const id = b.readUInt32LE(o); o += 4;
  const nl = b.readUInt32LE(o); o += 4; const cname = b.slice(o, o + nl).toString('utf8'); o += nl;
  o += 1; const count = b.readUInt32LE(o); o += 4;
  const refs = readRefs(b, o, count);
  classes[id] = { cname, refs };
  for (const r of refs) objs[r] = { ref: r, cls: cname, props: {}, children: [], parent: null };
}
for (const c of chunks) if (c.name === 'PROP') {
  const b = c.body; let o = 0;
  const id = b.readUInt32LE(o); o += 4;
  const nl = b.readUInt32LE(o); o += 4; const pname = b.slice(o, o + nl).toString('utf8'); o += nl;
  const type = b[o]; o += 1;
  if (type !== 0x01 || (pname !== 'Name' && pname !== 'Source')) continue;
  for (const r of classes[id].refs) {
    const l = b.readUInt32LE(o); o += 4;
    objs[r].props[pname] = b.slice(o, o + l).toString('utf8'); o += l;
  }
}
for (const c of chunks) if (c.name === 'PRNT') {
  const b = c.body; const n = b.readUInt32LE(1);
  const kids = readRefs(b, 5, n), pars = readRefs(b, 5 + 4 * n, n);
  for (let k = 0; k < n; k++) { const ch = objs[kids[k]]; ch.parent = pars[k]; if (pars[k] >= 0 && objs[pars[k]]) objs[pars[k]].children.push(ch); }
}

const EXT = { Script: '.server.lua', LocalScript: '.client.lua', ModuleScript: '.lua' };
const safe = s => s.replace(/[<>:"/\\|?*]/g, '_');
const roots = Object.values(objs).filter(o => o.parent === -1 || o.parent === null);
const lines = []; let n = 0;
function walk(o, pth, depth) {
  const nm = o.props.Name ?? o.cls;
  const descendants = (x => { let c = 0; const st = [...x.children]; while (st.length) { const y = st.pop(); c++; st.push(...y.children); } return c; })(o);
  if (depth <= 3 || EXT[o.cls]) lines.push(`${'  '.repeat(depth)}- ${nm} (${o.cls}${descendants ? ', ' + descendants + ' descendants' : ''})`);
  if (EXT[o.cls]) {
    const dir = path.join(outSrc, ...pth.map(safe)); fs.mkdirSync(dir, { recursive: true });
    fs.writeFileSync(path.join(dir, safe(nm) + EXT[o.cls]), o.props.Source ?? ''); n++;
  }
  for (const c of o.children) walk(c, [...pth, nm], depth + 1);
}
for (const r of roots) walk(r, [], 0);
fs.writeFileSync(outTree, '# Full place hierarchy (generated from the place file)\n\n```\n' + lines.join('\n') + '\n```\n');
console.log(`exported ${n} scripts, ${Object.keys(objs).length} instances`);
