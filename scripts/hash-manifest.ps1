# 2025-08-18 — Brunosso hashing (compat)
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$pub  = Join-Path $root 'assets\public-previews'
if (-not (Test-Path $pub)) { New-Item -ItemType Directory -Path $pub -Force | Out-Null }

$manifestPath = Join-Path $pub 'MANIFEST.json'
$items = Get-ChildItem -Recurse -File -Path $pub -ErrorAction SilentlyContinue

$manifest = foreach ($i in $items) {
  $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $i.FullName).Hash.ToLower()
  [pscustomobject]@{
    path   = $i.FullName.Substring($root.Length + 1).Replace('\','/')
    sha256 = $hash
    bytes  = (Get-Item -LiteralPath $i.FullName).Length
    commit = (& git -C $root rev-parse HEAD 2>$null)
    date   = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
  }
}
$manifest | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $manifestPath -Encoding utf8

# Book hash (pick newest PDF)
$pdfDir = Join-Path $root 'book'
$pdf = Get-ChildItem -Path $pdfDir -Filter '*.pdf' -File -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($pdf) {
  (Get-FileHash -Algorithm SHA256 -LiteralPath $pdf.FullName).Hash.ToLower() |
    Out-File -LiteralPath (Join-Path $pdfDir 'hash.txt') -Encoding ascii
}
