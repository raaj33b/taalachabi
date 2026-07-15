<#
  TAALACHABI — one-line installer (Windows PowerShell)
  Usage:
    irm https://raw.githubusercontent.com/raaj33b/taalachabi/main/install.ps1 | iex

  raaj33b production . mindvault.io . 13.13.33
  This script downloads the ONE html file (taalachabi.html) — the entire
  app — into a folder you choose (this PC, or a removable/USB drive),
  verifies its SHA-256 checksum, creates a desktop shortcut (optional),
  and opens it. No data ever leaves your machine; the script does not
  read, upload, or transmit any of your vault contents.
#>

$ErrorActionPreference = 'Stop'

# ---- EDIT THIS after you push your repo to GitHub ----
$RepoRaw = "https://raw.githubusercontent.com/raaj33b/taalachabi/main"
$AppFile = "taalachabi.html"
$HashFile = "taalachabi.html.sha256"
# --------------------------------------------------------

function Show-Banner {
    Write-Host ""
    Write-Host "  T A A L A C H A B I" -ForegroundColor DarkYellow
    Write-Host "  ------------------------------------" -ForegroundColor DarkGray
    Write-Host "  private, offline, USB-portable vault" -ForegroundColor DarkGray
    Write-Host "  raaj33b production . mindvault.io" -ForegroundColor DarkGray
    Write-Host "  ------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}

Show-Banner

Write-Host "Where should taalachabi be installed?" -ForegroundColor Yellow
Write-Host "  [1] This PC   ($env:USERPROFILE\Taalachabi)"
Write-Host "  [2] Removable / USB drive"
$choice = Read-Host "Choose 1 or 2 (default 1)"

$dest = "$env:USERPROFILE\Taalachabi"

if ($choice -eq '2') {
    $removables = Get-Volume | Where-Object { $_.DriveType -eq 'Removable' -and $_.DriveLetter }
    if (-not $removables) {
        Write-Host "No removable drive detected right now. Falling back to This PC." -ForegroundColor Red
    } else {
        Write-Host ""
        Write-Host "Removable drives found:" -ForegroundColor DarkGray
        $removables | ForEach-Object {
            Write-Host ("   [{0}]  {1}" -f $_.DriveLetter, $_.FileSystemLabel)
        }
        $letter = Read-Host "Enter the drive letter to install to (e.g. E)"
        if ($letter) { $dest = "${letter}:\Taalachabi" }
    }
}

New-Item -ItemType Directory -Force -Path $dest | Out-Null

Write-Host ""
Write-Host "Downloading vault application from GitHub..." -ForegroundColor DarkGray
try {
    Invoke-WebRequest -Uri "$RepoRaw/$AppFile" -OutFile "$dest\$AppFile" -UseBasicParsing
} catch {
    Write-Host "Download failed. Check your internet connection or the repo URL in this script." -ForegroundColor Red
    exit 1
}

Write-Host "Verifying integrity (SHA-256)..." -ForegroundColor DarkGray
try {
    $expected = (Invoke-WebRequest -Uri "$RepoRaw/$HashFile" -UseBasicParsing).Content.Trim().ToLower()
    $actual = (Get-FileHash "$dest\$AppFile" -Algorithm SHA256).Hash.ToLower()
    if ($expected -and $expected -ne $actual) {
        Write-Host "CHECKSUM MISMATCH. The downloaded file does not match the published hash." -ForegroundColor Red
        Write-Host "Refusing to launch. Delete $dest\$AppFile and try again, or verify manually." -ForegroundColor Red
        exit 1
    }
    Write-Host "Checksum verified OK." -ForegroundColor Green
} catch {
    Write-Host "(Could not verify checksum — hash file not reachable. Proceeding anyway.)" -ForegroundColor DarkYellow
}

if ($choice -ne '2') {
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Taalachabi.lnk")
        $Shortcut.TargetPath = "$dest\$AppFile"
        $Shortcut.IconLocation = "shell32.dll,48"
        $Shortcut.Save()
        Write-Host "Desktop shortcut created." -ForegroundColor DarkGray
    } catch {
        Write-Host "(Could not create desktop shortcut — not critical, continuing.)" -ForegroundColor DarkYellow
    }
}

Write-Host ""
Write-Host "Deployed successfully to:" -ForegroundColor Green
Write-Host "  $dest\$AppFile" -ForegroundColor Green
Write-Host ""
Write-Host "Opening your vault..." -ForegroundColor DarkGray
Start-Process "$dest\$AppFile"

Write-Host ""
Write-Host "Set your master password on first screen. Then go to Settings ->" -ForegroundColor DarkGray
Write-Host "Export .taala to Drive to save an encrypted backup onto your USB." -ForegroundColor DarkGray
Write-Host ""
Write-Host "  rights reserved . mindvault.io . 13.13.33" -ForegroundColor DarkGray
Write-Host ""
