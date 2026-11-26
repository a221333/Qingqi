$ErrorActionPreference = 'Stop'
$state = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'previous-entrypoints.json') -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($entry in $state.Links) {
    if (-not (Test-Path -LiteralPath $entry.Backup)) { throw ('Missing shortcut backup: ' + $entry.Backup) }
}
foreach ($process in @(Get-Process -Name Qingqi -ErrorAction SilentlyContinue)) {
    if ($process.Path -eq $state.NewExecutable) { Stop-Process -Id $process.Id; $process.WaitForExit(5000) | Out-Null }
}
foreach ($entry in $state.Links) { Copy-Item -LiteralPath $entry.Backup -Destination $entry.Path -Force }
if ($state.StartupChanged) {
    Set-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name Qingqi -Value $state.PreviousStartup
}
$previousExe = @($state.Links | Where-Object { Test-Path -LiteralPath $_.OldTarget } | Select-Object -First 1).OldTarget
if ($previousExe) { Start-Process -FilePath $previousExe -ArgumentList '--background' -WindowStyle Hidden }
Write-Output 'Restored previous launch entries. Original program and existing configuration were retained.'
