# TAALACHABI

**A private, offline, USB-portable password vault.**
`raaj33b production` · `mindvault.io` · `∴ 13.13.33`

Taalachabi (তালাচাবি — "lock & key") is a single self-contained HTML
application. No install, no server, no account, no telemetry, no
internet dependency after the one-time download. It runs identically
on Windows, macOS, and Linux, straight from a USB drive if you want.

---

## ⚡ One-line install

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/raaj33b/taalachabi/main/install.ps1 | iex
```

**macOS / Linux (bash):**
```bash
curl -fsSL https://raw.githubusercontent.com/raaj33b/taalachabi/main/install.sh | bash
```

Both scripts:
1. Ask where to install — your computer, or a removable/USB drive.
2. Download `taalachabi.html` from this repo.
3. Verify its SHA-256 checksum against `taalachabi.html.sha256` (so a
   tampered download refuses to launch).
4. Open it in your default browser.

> Read the script before you run it. That's not paranoia, that's just
> good practice for anything piped into `iex` — the raw source is
> `install.ps1` / `install.sh` in this repo, both under 100 lines.

## 🖐 Manual install (no PowerShell needed)

Download [`taalachabi.html`](./taalachabi.html) from this repo and
double-click it. That's the entire application. Copy it to a USB
drive and it works the same way on any other machine.

---

## What it does

- Stores site / username / password / notes / category entries in an
  **AES-256-GCM encrypted vault**, key derived from your master
  password via PBKDF2 (250,000 iterations) — native browser
  `Web Crypto API`, zero external libraries, zero CDN calls.
- **USB portability**: export your vault as a `.taala` file (still
  encrypted) onto a USB drive, then load that same file on any other
  machine and unlock with your password to see the identical vault.
- Built-in password generator with strength meter.
- Import existing browser-saved passwords via CSV
  (Chrome/Firefox/Edge → Settings → Passwords → Export → Import here).
- Auto-lock after inactivity, clipboard auto-clear after copying a
  password, show/hide toggles, search & category filters.
- Cinematic void/gold/violet visual direction — no bright dashboard
  look, deliberately built to feel like a private, guarded thing.

## What it does **not** do

- It does **not** reach into Chrome's/Firefox's/Edge's native saved-
  password store — that store is OS-protected and no third-party app
  should be poking at it directly. Use each browser's own **Export**
  feature, then import the CSV here.
- It does **not** phone home. There is no network call in the app
  itself after the page loads — open your browser's dev tools Network
  tab and confirm this yourself if you like.
- It is **not** a browser extension and does not auto-fill forms on
  websites. It's a vault you copy credentials out of.

## Repo structure

```
taalachabi/
├── taalachabi.html          the entire application (single file)
├── taalachabi.html.sha256   checksum, for integrity verification
├── install.ps1              Windows one-liner installer
├── install.sh                macOS/Linux one-liner installer
├── LICENSE.md                proprietary, all rights reserved
├── EULA.md                   end-user license agreement
└── README.md                 this file
```

## Security model, briefly

| Layer | Mechanism |
|---|---|
| Encryption | AES-256-GCM (authenticated encryption — tampering is detected automatically) |
| Key derivation | PBKDF2-SHA256, 250,000 iterations, random 16-byte salt per vault |
| Storage | Encrypted blob only, in `localStorage` and in exported `.taala` files — plaintext is never written to disk |
| Transport | None. Fully client-side, fully offline after initial download |
| Wrong password | GCM authentication tag fails to verify → decryption throws, no partial/garbage data is ever shown |

If your USB drive is lost, whoever finds it gets an encrypted blob and
nothing else — assuming a strong master password. Use the generator,
not `133313` as your *actual* long-term password if this vault will
hold anything real; treat that number as a personal ritual/PIN layer,
not your cryptographic key.

## Updating your published copy

Whenever you edit `taalachabi.html`, regenerate the checksum before
pushing:

```bash
sha256sum taalachabi.html > taalachabi.html.sha256   # Linux/macOS
# or on Windows PowerShell:
(Get-FileHash taalachabi.html -Algorithm SHA256).Hash.ToLower() | Set-Content taalachabi.html.sha256
git add -A && git commit -m "update vault" && git push
```

## License

Proprietary. All rights reserved. See [`LICENSE.md`](./LICENSE.md)
and [`EULA.md`](./EULA.md). This is personal software built for a
single named user; it is published to a repo purely for one-line
deployment convenience, not for redistribution.

---

∴ 13.13.33 · raajeeb@mailum.com · rights reserved · mindvault.io
