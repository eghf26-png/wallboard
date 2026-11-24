$ErrorActionPreference='Continue'
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
$ip='192.168.10.134'; $dev="$($ip):5555"; $url='https://eghf26-png.github.io/wallboard/'
$adb=(Get-Command adb -ErrorAction SilentlyContinue).Source
if(-not $adb){ $p="$env:USERPROFILE\OneDrive - EGHF\Desktop\Frame\platform-tools\adb.exe"; if(Test-Path $p){$adb=$p} }
if(-not $adb){ $p2=Join-Path $env:TEMP 'framesetup\platform-tools\adb.exe'; if(Test-Path $p2){$adb=$p2} }
Write-Host "adb: $adb"
& $adb connect $dev | Write-Host

Write-Host "`n== what's on screen now =="
(& $adb -s $dev shell dumpsys activity activities 2>&1 | Select-String 'mResumedActivity|topResumedActivity') | ForEach-Object { Write-Host $_ }

Write-Host "`n== reloading the board =="
& $adb -s $dev shell am force-stop de.ozerov.fully 2>&1 | Out-Null
Start-Sleep 1
& $adb -s $dev logcat -c 2>&1 | Out-Null
& $adb -s $dev shell am start -a android.intent.action.VIEW -d "$url" -n de.ozerov.fully/de.ozerov.fully.MainActivity 2>&1 | Write-Host
Start-Sleep 7

Write-Host "`n== browser log (for diagnosis) =="
(& $adb -s $dev logcat -d 2>&1 | Select-String 'chromium|SyntaxError|Uncaught|TypeError|msal|login.microsoftonline|device|Console' | Select-Object -Last 40) | ForEach-Object { Write-Host $_ }
Write-Host "`nDONE"
