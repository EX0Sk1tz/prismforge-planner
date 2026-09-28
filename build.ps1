# Builds index.html from src\index.template.html and Prismforge's segment catalog.
#   powershell -ExecutionPolicy Bypass -File build.ps1 [-Catalog <path to SegmentCatalog.json>]
# Run it again whenever the catalog in the Prismforge repository changes.
param(
    [string]$Catalog = (Join-Path $PSScriptRoot '..\R2PrismRuntime-Development\Data\SegmentCatalog.json')
)
$ErrorActionPreference = 'Stop'

$rows = Get-Content $Catalog -Raw -Encoding UTF8 | ConvertFrom-Json
$compact = @($rows | ForEach-Object {
    [ordered]@{ row = $_.row; name = $_.name; kind = $_.kind; category = $_.category; description = $_.description }
})
$json = ConvertTo-Json $compact -Compress -Depth 3
# Keep "</script>" or similar out of the inline script.
$json = $json.Replace('</', '<\/')

$template = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'src\index.template.html'))
if (-not $template.Contains('/*CATALOG*/[]')) { throw 'Placeholder /*CATALOG*/[] not found in the template.' }
$html = $template.Replace('/*CATALOG*/[]', $json)
[IO.File]::WriteAllText((Join-Path $PSScriptRoot 'index.html'), $html, (New-Object Text.UTF8Encoding $false))
"index.html written: $($compact.Count) catalog rows."
