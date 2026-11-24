$ErrorActionPreference='Continue'
$ip='192.168.10.134'; $dev="$($ip):5555"
$bust=[DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$url="https://eghf26-png.github.io/wallboard/?v=$bust"
$adb=(Get-Command adb -ErrorAction SilentlyContinue).Source
if(-not $adb){ $p="$env:USERPROFILE\OneDrive - EGHF\Desktop\Frame\platform-tools\adb.exe"; if(Test-Path $p){$adb=$p} }
if(-not $adb){ $p2=Join-Path $env:TEMP 'framesetup\platform-tools\adb.exe'; if(Test-Path $p2){$adb=$p2} }
Write-Host "adb: $adb"
Write-Host "Resetting adb..."
& $adb kill-server 2>&1 | Out-Null
Start-Sleep 1
& $adb start-server 2>&1 | Out-Null

$ok=$false
for($i=1;$i -le 4;$i++){
  Write-Host "Connect attempt $i..."
  $r = & $adb connect $dev 2>&1
  Write-Host $r
  if($r -match 'connected'){ $ok=$true; break }
  Start-Sleep 3
}
Write-Host "`n== adb devices =="
& $adb devices | Write-Host

if($ok){
  & $adb -s $dev shell am force-stop de.ozerov.fully 2>&1 | Out-Null
  Start-Sleep 1
  & $adb -s $dev shell am start -a android.intent.action.VIEW -d "$url" -n de.ozerov.fully/de.ozerov.fully.MainActivity 2>&1 | Write-Host
  Write-Host "`nConnected and reloaded. Tap Sign in on the frame."
} else {
  Write-Host "`nCould not reach the frame at $ip. It may still be booting, or its IP may have changed."
  Write-Host "Check the frame is on and on Wi-Fi, wait 30s, and run this again."
}
