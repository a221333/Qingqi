$ErrorActionPreference = 'Stop'
$workspace = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $PSScriptRoot 'qingqi'
$packageRoot = Join-Path $workspace 'outputs\Qingqi-1.1'
$newExe = [IO.Path]::GetFullPath((Join-Path $packageRoot 'Qingqi.exe'))
$backupRoot = Join-Path $packageRoot ('previous-entrypoints-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
$runKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$previousStartup = Get-ItemPropertyValue -LiteralPath $runKey -Name Qingqi -ErrorAction SilentlyContinue
$shellObject = New-Object -ComObject WScript.Shell
$links = @()
$folders = @([Environment]::GetFolderPath('DesktopDirectory'),[Environment]::GetFolderPath('Programs'),(Join-Path $env:USERPROFILE 'Desktop')) | Select-Object -Unique
Write-Output '1/5 BACKUP existing launch entries'
foreach ($folder in $folders) {
    foreach ($file in @(Get-ChildItem -LiteralPath $folder -Filter '*Qingqi*.lnk' -ErrorAction SilentlyContinue)) {
        $shortcut = $shellObject.CreateShortcut($file.FullName)
        if ([IO.Path]::GetFileName($shortcut.TargetPath) -ine 'Qingqi.exe') { continue }
        $backup = Join-Path $backupRoot ($links.Count.ToString() + '-' + $file.Name)
        Copy-Item -LiteralPath $file.FullName -Destination $backup
        $links += [PSCustomObject]@{Path=$file.FullName;Backup=$backup;OldTarget=$shortcut.TargetPath}
    }
}
$state = [ordered]@{NewExecutable=$newExe;PreviousStartup=$previousStartup;StartupChanged=$false;Links=$links;Created=(Get-Date -Format 's')}
$receipt = Join-Path $backupRoot 'state.json'
$state | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $receipt -Encoding UTF8
Write-Output '2/5 UPDATE generated program copy'
$firstTest = Join-Path $PSScriptRoot 'first-test'
New-Item -ItemType Directory -Path $firstTest -Force | Out-Null
if (Test-Path -LiteralPath $newExe) { Copy-Item -LiteralPath $newExe -Destination (Join-Path $firstTest 'Qingqi.exe') -Force }
foreach ($process in @(Get-Process -Name Qingqi -ErrorAction SilentlyContinue)) {
    if ($process.Path -ne $newExe) { throw ('Unexpected active program: ' + $process.Path) }
    Stop-Process -Id $process.Id
    $process.WaitForExit(5000) | Out-Null
}
foreach ($name in @('Qingqi.exe','Qingqi.exe.config')) {
    Copy-Item -LiteralPath (Join-Path $sourceRoot ('build\' + $name)) -Destination (Join-Path $packageRoot $name) -Force
}
Copy-Item -LiteralPath (Join-Path $sourceRoot 'README.md') -Destination (Join-Path $packageRoot 'README.md') -Force
Write-Output '3/5 UPDATE existing shortcuts and existing login startup'
foreach ($entry in $links) {
    $shortcut = $shellObject.CreateShortcut($entry.Path)
    $shortcut.TargetPath = $newExe
    $shortcut.WorkingDirectory = $packageRoot
    $shortcut.IconLocation = $newExe + ',0'
    $shortcut.Save()
}
if ($previousStartup -match '^\s*"[^"\r\n]*Qingqi\.exe"(?<arguments>.*)$') {
    $newStartup = '"' + $newExe + '"' + $Matches.arguments
    Set-ItemProperty -LiteralPath $runKey -Name Qingqi -Value $newStartup
    $state.StartupChanged = $true
}
$state | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $receipt -Encoding UTF8
Set-Content -LiteralPath (Join-Path $packageRoot 'previous-entrypoints.json') -Value ($state | ConvertTo-Json -Depth 8) -Encoding UTF8
Write-Output '4/5 VERIFY executable, shortcuts and startup readback'
$sourceHash = (Get-FileHash -LiteralPath (Join-Path $sourceRoot 'build\Qingqi.exe') -Algorithm SHA256).Hash
if ((Get-FileHash -LiteralPath $newExe -Algorithm SHA256).Hash -ne $sourceHash) { throw 'Program hash readback failed.' }
foreach ($entry in $links) {
    if ($shellObject.CreateShortcut($entry.Path).TargetPath -ne $newExe) { throw ('Shortcut readback failed: ' + $entry.Path) }
}
if ($state.StartupChanged -and (Get-ItemPropertyValue -LiteralPath $runKey -Name Qingqi) -ne $newStartup) { throw 'Startup readback failed.' }
Write-Output '5/5 START updated program'
Start-Process -FilePath $newExe -ArgumentList '--background' -WorkingDirectory $packageRoot -WindowStyle Hidden
Write-Output ('PASS: shortcuts=' + $links.Count + '; startup updated=' + $state.StartupChanged + '; SHA256=' + $sourceHash)
Write-Output ('BACKUP: ' + $backupRoot)
