# ⚙️ Cmd-Scripts Toolkit

A personal **PowerShell CLI toolkit** for everyday automation, media handling, and utilities — install everything with **one command**.

---

## 🚀 One-Line Install

```powershell
irm https://raw.githubusercontent.com/therajatshahare/cmd-scripts/main/install.ps1 | iex
```

> ⚠️ Restart PowerShell after installation.

---

## 📂 What This Does

* Installs all scripts to:

  ```
  $HOME\cmd-scripts
  ```
* Adds scripts to PATH
* Configures PowerShell profile automatically
* Installs required dependencies:

  * yt-dlp
  * ffmpeg
  * aria2
  * python
  * lyricsgenius

---

## 🧰 Available Commands

### 🎥 Media / YouTube

```powershell
ytvideo
vytvideo
ytaudio
```

### 🎵 Metadata / Lyrics

```powershell
showmeta
showformat
showlyrics
```

### 📁 File Utilities

```powershell
folders
hide
unhide
exifpic
```

### ⚡ System Utilities

```powershell
update-tools
upgrade-tools
aria
```

### 📸 Instagram

```powershell
insta <username> full
insta <username> update
```

### 🔁 Toolkit Update

```powershell
update-scripts
```

---

## 🎵 Lyrics Setup (Required for showlyrics)

```powershell
[Environment]::SetEnvironmentVariable("GENIUS_TOKEN", "your_token_here", "User")
```

Restart PowerShell after setting.

---

## 📦 Project Structure

```
cmd-scripts/
│
├── install.ps1
└── scripts/
    ├── ytvideo.ps1
    ├── vytvideo.ps1
    ├── ytaudio.ps1
    ├── showmeta.ps1
    ├── showlyrics.ps1
    ├── showformat.ps1
    ├── hide.ps1
    ├── unhide.ps1
    ├── update.ps1
    ├── upgrade.ps1
    ├── aria.ps1
    ├── exifpic.ps1
    ├── folders.ps1
    ├── insta.ps1
    └── lyrics.py
```

---

## 🧠 Design Philosophy

* One-command setup
* No admin required
* Portable across systems
* Self-healing configuration
* Minimal dependencies

---

## ⚠️ Notes

* Designed for Windows + PowerShell
* Works best without Administrator mode

---

## ⭐ Author

Rajat Shahare
https://github.com/therajatshahare

---

## 🛠️ License

Personal toolkit — use freely and modify as needed.
