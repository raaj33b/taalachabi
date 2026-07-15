#!/usr/bin/env bash
# TAALACHABI — one-line installer (macOS / Linux)
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/raaj33b/taalachabi/main/install.sh | bash
#
# raaj33b production . mindvault.io . 13.13.33

set -e

REPO_RAW="https://raw.githubusercontent.com/raaj33b/taalachabi/main"
APP_FILE="taalachabi.html"
HASH_FILE="taalachabi.html.sha256"

echo ""
echo "  T A A L A C H A B I"
echo "  ------------------------------------"
echo "  private, offline, USB-portable vault"
echo "  raaj33b production . mindvault.io"
echo "  ------------------------------------"
echo ""

echo "Where should taalachabi be installed?"
echo "  [1] This computer (\$HOME/Taalachabi)"
echo "  [2] Custom path (e.g. a mounted USB drive)"
read -p "Choose 1 or 2 (default 1): " choice

if [ "$choice" = "2" ]; then
  read -p "Enter full destination path: " dest
  dest="${dest:-$HOME/Taalachabi}"
else
  dest="$HOME/Taalachabi"
fi

mkdir -p "$dest"

echo ""
echo "Downloading vault application from GitHub..."
curl -fsSL "$REPO_RAW/$APP_FILE" -o "$dest/$APP_FILE"

echo "Verifying integrity (SHA-256)..."
if curl -fsSL "$REPO_RAW/$HASH_FILE" -o "/tmp/taalachabi.sha256" 2>/dev/null; then
  expected=$(cat /tmp/taalachabi.sha256 | tr -d '[:space:]')
  if command -v shasum >/dev/null 2>&1; then
    actual=$(shasum -a 256 "$dest/$APP_FILE" | awk '{print $1}')
  else
    actual=$(sha256sum "$dest/$APP_FILE" | awk '{print $1}')
  fi
  if [ "$expected" != "$actual" ]; then
    echo "CHECKSUM MISMATCH — refusing to launch. Verify the file manually."
    exit 1
  fi
  echo "Checksum verified OK."
else
  echo "(Could not verify checksum — hash file not reachable. Proceeding anyway.)"
fi

echo ""
echo "Deployed successfully to: $dest/$APP_FILE"
echo "Opening your vault..."

if command -v open >/dev/null 2>&1; then
  open "$dest/$APP_FILE"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$dest/$APP_FILE"
else
  echo "Open this file manually in your browser: $dest/$APP_FILE"
fi

echo ""
echo "Set your master password on first screen. Then go to Settings ->"
echo "Export .taala to Drive to save an encrypted backup onto your USB."
echo ""
echo "  rights reserved . mindvault.io . 13.13.33"
echo ""
