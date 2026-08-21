import fs from 'fs';
const h = fs.readFileSync('index.html', 'utf8');
const lines = h.split(/\r?\n/);
let start = -1;
for (let i = 0; i < lines.length; i++) {
  if (lines[i].trim() === '<script>' && lines[i + 1] && lines[i + 1].trim() === '"use strict";') {
    start = i;
    break;
  }
}
let end = -1;
for (let i = start + 1; i < lines.length; i++) {
  if (lines[i].trim() === '</script>') { end = i; break; }
}
const body = lines.slice(start + 1, end).join('\n');
fs.writeFileSync('stage8_syntax.js', body);
console.log('synced', end - start - 1, 'lines');
