# Wall Board - frame setup
# Installs Fully Kiosk on the Dragon Touch frame and opens the board.
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ip  = '192.168.10.134'
$dev = "$($ip):5555"
$url = 'https://eghf26-png.github.io/wallboard/'
$work = Join-Path $env:TEMP 'framesetup'
New-Item -ItemType Directory -Force -Path $work | Out-Null

function Find-Adb {
  $c = Get-Command adb -ErrorAction SilentlyContinue
  if ($c) { return $c.Source }
  $p = "$env:USERPROFILE\OneDrive - EGHF\Desktop\Frame\platform-tools\adb.exe"
  if (Test-Path $p) { return $p }
  Write-Host "Getting adb..."
  $zip = Join-Path $work 'pt.zip'
  Invoke-WebRequest 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile $zip -UseBasicParsing
  Expand-Archive $zip -DestinationPath $work -Force
  return (Join-Path $work 'platform-tools\adb.exe')
}

$adb = Find-Adb
Write-Host "adb: $adb"
& $adb connect $dev | Write-Host

Write-Host "`n== WebView version on the frame =="
(& $adb -s $dev shell dumpsys webviewupdate 2>&1 | Select-String 'Current WebView package|versionName' | Select-Object -First 3) | ForEach-Object { Write-Host $_ }

Write-Host "`n== Downloading Fully Kiosk =="
$apk = Join-Path $work 'fully.apk'
if (-not (Test-Path $apk)) {
  Invoke-WebRequest 'https://www.fully-kiosk.com/files/2026/10/Fully-Kiosk-Browser-v1.61.4.apk' -OutFile $apk -UseBasicParsing
}
Write-Host ("Downloaded: {0:N1} MB" -f ((Get-Item $apk).Length/1MB))

Write-Host "`n== Installing on the frame =="
& $adb -s $dev install -r "$apk" 2>&1 | Write-Host

Write-Host "`n== Opening the board on the frame =="
& $adb -s $dev shell am start -a android.intent.action.VIEW -d "$url" -n de.ozerov.fully/de.ozerov.fully.MainActivity 2>&1 | Write-Host

Write-Host "`nDONE. The frame should now show Fully Kiosk opening the board."
