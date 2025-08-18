# 2025-08-18 — Brunosso hashing (fixed)
$root = Split-Path -Parent (Resolve-Path (Join-Path $PSScriptRoot '..'))
$pub  = Join-Path $root 'assets\public-previews'
if (-not (Test-Path $pub)) { New-Item -ItemType Directory -Path $pub -Force | Out-Null }
$manifestPath = Join-Path $pub 'MANIFEST.json'
$items = Get-ChildItem -Recurse -File -Path $pub -ErrorAction SilentlyContinue
$manifest = @()
foreach ($i in $items) {
  $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $i.FullName).Hash.ToLower()
  $rel  = $i.FullName.Substring($root.Length + 1).Replace('\','/')
  try { $commit = (git -C $root rev-parse HEAD) } catch { $commit = '' }
  $manifest += [pscustomobject]@{
    path   = $rel
    sha256 = $hash
    bytes  = (Get-Item $i.FullName).Length
    commit = $commit
    date   = (Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssZ')
  }
}
$manifest | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $manifestPath -Encoding utf8

$pdfDir = Join-Path $root 'book'
$pdf = Get-ChildItem -Path $pdfDir -Filter '*.pdf' -File -ErrorAction SilentlyContinue |
       Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($pdf) {
  (Get-FileHash -Algorithm SHA256 -LiteralPath $pdf.FullName).Hash.ToLower() |
    Out-File -LiteralPath (Join-Path $pdfDir 'hash.txt') -Encoding ascii
}
