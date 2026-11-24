$ErrorActionPreference='Continue'
$ip='192.168.10.134'; $dev="$($ip):5555"
$bust=[DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$url="https://eghf26-png.github.io/wallboard/?v=$bust"
$adb=(Get-Command adb -ErrorAction SilentlyContinue).Source
if(-not $adb){ $p="$env:USERPROFILE\OneDrive - EGHF\Desktop\Frame\platform-tools\adb.exe"; if(Test-Path $p){$adb=$p} }
if(-not $adb){ $p2=Join-Path $env:TEMP 'framesetup\platform-tools\adb.exe'; if(Test-Path $p2){$adb=$p2} }
Write-Host "adb: $adb"
& $adb connect $dev | Write-Host
& $adb -s $dev shell am force-stop de.ozerov.fully 2>&1 | Out-Null
Start-Sleep 1
& $adb -s $dev shell am start -a android.intent.action.VIEW -d "$url" -n de.ozerov.fully/de.ozerov.fully.MainActivity 2>&1 | Write-Host
Write-Host "`nReloaded the board fresh. On the frame, tap Sign in."
