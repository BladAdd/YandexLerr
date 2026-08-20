# Downloads all external libraries locally into lib/ folder.
# Required for Yandex Games upload (external CDNs are forbidden there).
$ErrorActionPreference = "Stop"
$lib = "lib"

New-Item -ItemType Directory -Force -Path "$lib\fa\webfonts", "$lib\fonts" | Out-Null

Write-Host "== Tailwind (Play CDN, self-hosted) =="
Invoke-WebRequest -UseBasicParsing "https://cdn.tailwindcss.com" -OutFile "$lib\tailwind.js"

Write-Host "== three.js r128 =="
Invoke-WebRequest -UseBasicParsing "https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js" -OutFile "$lib\three.min.js"

Write-Host "== Tone.js 14.8.49 =="
Invoke-WebRequest -UseBasicParsing "https://cdnjs.cloudflare.com/ajax/libs/tone/14.8.49/Tone.js" -OutFile "$lib\Tone.js"

Write-Host "== Font Awesome 6.4.0 =="
Invoke-WebRequest -UseBasicParsing "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" -OutFile "$lib\fa\all.min.css"
Invoke-WebRequest -UseBasicParsing "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/fa-solid-900.woff2" -OutFile "$lib\fa\webfonts\fa-solid-900.woff2"
Invoke-WebRequest -UseBasicParsing "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/fa-regular-400.woff2" -OutFile "$lib\fa\webfonts\fa-regular-400.woff2"
Invoke-WebRequest -UseBasicParsing "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/webfonts/fa-brands-400.woff2" -OutFile "$lib\fa\webfonts\fa-brands-400.woff2"

Write-Host "== Google Fonts (Orbitron + Rajdhani) =="
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0 Safari/537.36"
$css = (Invoke-WebRequest -UseBasicParsing -UserAgent $ua "https://fonts.googleapis.com/css2?family=Orbitron:wght@400;500;700;900&family=Rajdhani:wght@400;500;600;700&display=swap").Content
$urls = [regex]::Matches($css, "url\((https://[^)]+)\)") | ForEach-Object { $_.Groups[1].Value }
if ($urls.Count -eq 0) { Write-Error "No font URLs received from Google Fonts" }
foreach ($u in $urls) {
    $name = Split-Path $u -Leaf
    Write-Host "  font: $name"
    Invoke-WebRequest -UseBasicParsing -UserAgent $ua $u -OutFile "$lib\fonts\$name"
    $css = $css.Replace($u, "$name")
}
[System.IO.File]::WriteAllText((Resolve-Path ".").Path + "\$lib\fonts\fonts.css", $css, [System.Text.Encoding]::UTF8)

Write-Host ""
Write-Host "Done. Sizes:"
Get-ChildItem -Recurse $lib | Select-Object FullName, Length | Format-Table -AutoSize