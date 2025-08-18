# 2025-08-18 — Brunosso hashing (PowerShell)
Set-Location (Split-Path System.Management.Automation.InvocationInfo.MyCommand.Path)
 = Resolve-Path ""..""
 = Get-ChildItem -Recurse ""/assets/public-previews"" -File -ErrorAction SilentlyContinue
 = Join-Path ""/assets/public-previews"" ""MANIFEST.json""
 = @()

foreach ( in ) {
   = (Get-FileHash .FullName -Algorithm SHA256).Hash.ToLower()
   += [pscustomobject]@{
    path   = (.FullName.Replace(.Path + ""\"","""")).Replace(""\"",""/"")
    sha256 = 
    bytes  = (Get-Item .FullName).Length
    commit = (git -C .Path rev-parse HEAD)
    date   = Get-Date -Format ""yyyy-MM-ddTHH:mm:ssK""
  }
}

if (!(Test-Path (Split-Path ))) { New-Item -ItemType Directory -Path (Split-Path ) | Out-Null }
 | ConvertTo-Json -Depth 5 | Out-File  -Encoding UTF8

 = Get-ChildItem ""/book"" -Filter *.pdf -File -ErrorAction SilentlyContinue | Select-Object -First 1
if () { (Get-FileHash .FullName -Algorithm SHA256).Hash.ToLower() | Out-File ""/book/hash.txt"" -Encoding ASCII }
Write-Host ""Manifest and book hash written.""
