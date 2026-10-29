# ntfs-tool 🚀

> **Modern, Kext-less NTFS Read/Write Manager for macOS.**  
> Seamlessly mount, write, and manage Windows NTFS USB hard drives on macOS (Sonoma, Sequoia, Tahoe 26+) on Apple Silicon (M1/M2/M3/M4) & Intel Macs without disabling System Integrity Protection (SIP) or lowering kernel security.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%2013%2B%20%7C%20Apple%20Silicon%20%26%20Intel-black.svg)]()
[![Engine](https://img.shields.io/badge/FUSE-FUSE--T%20(Kext--less)-success.svg)](https://www.fuse-t.org/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 📌 The Problem with NTFS on Modern macOS

Starting with modern macOS versions (macOS 14 Sonoma, 15 Sequoia, and 26 Tahoe), Apple completely migrated the filesystem architecture to **FSKit** (User-Space Filesystem Kit). As a consequence:
1. **Built-in NTFS support is strictly Read-Only**: Apple’s internal drivers no longer offer any native write capabilities.
2. **The legacy `-o rw,nobrowse` mount option is permanently deprecated**.
3. **Traditional macFUSE requires Kernel Extensions (KEXTs)**: On Apple Silicon, loading kexts requires restarting into Recovery Mode, lowering system security to "Reduced Security," and permitting third-party kernel drivers.

### 💡 The Solution: `ntfs-tool` + FUSE-T

`ntfs-tool` bridges this gap using **[FUSE-T](https://www.fuse-t.org/)** and **NTFS-3G**:
- **Zero Kernel Extensions**: FUSE-T exposes the filesystem through a local NFS v4 loopback.
- **Full SIP & Startup Security Intact**: No need to downgrade your Mac's security policy.
- **Automated Workflow**: Unmounts the restrictive read-only FSKit mount, creates mount points, applies optimized flags, verifies write capability, and notifies you when ready.
- **Background Watcher**: Can run as a macOS `LaunchDaemon` to automatically detect and remount any connected NTFS drive on the fly!

```
┌────────────────────────────────────────────────────────┐
│                      macOS Finder                      │
└───────────────────────────▲────────────────────────────┘
                            │ (Read / Write)
┌───────────────────────────┴────────────────────────────┐
│              FUSE-T (Kext-less User Space)             │
├────────────────────────────────────────────────────────┤
│                        NTFS-3G                         │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│           External USB NTFS Hard Drive / SSD           │
└────────────────────────────────────────────────────────┘
```

---

## ✨ Features

- **Apple Silicon Ready**: Native support for M1, M2, M3, M4, and Intel architectures.
- **Kext-less Architecture**: 100% user-space filesystem driver via FUSE-T.
- **Dual Interface**:
  - **Interactive TUI**: Easy numbered terminal menu for casual users.
  - **CLI Mode**: Fast commands for power users, scripts, and automation.
- **Smart Auto-Detection**: Automatically identifies connected NTFS volumes, volume labels, and device nodes.
- **Safe Ejection**: Flushes disk caches (`sync`) before unmounting to prevent filesystem corruption.
- **Native Notifications**: Sends macOS desktop alerts when drives are mounted or detached.
- **LaunchDaemon Support**: Option to run in background mode for zero-click automatic NTFS mounting.

---

## 📋 Prerequisites

Before installing `ntfs-tool`, ensure you have [Homebrew](https://brew.sh) installed. Then install the two required open-source engines:

```bash
# 1. Tap and trust the required third-party repositories
brew tap macos-fuse-t/homebrew-cask
brew tap gromgit/fuse
brew trust gromgit/fuse macos-fuse-t/homebrew-cask

# 2. Install FUSE-T (Kext-less FUSE engine) and NTFS-3G
brew install --cask fuse-t
brew install ntfs-3g-mac
```

*(Note: You can also run `sudo ntfs-tool install-deps` after installing the tool to have it automatically configure and install these dependencies.)*

---

## ⚡ Quick Installation

Clone this repository and run the included installer:

```bash
git clone https://github.com/atilasevindi/ntfs-tool.git
cd ntfs-tool
sudo ./install.sh
```

To verify the installation:
```bash
ntfs-tool doctor
```

---

## 🛠️ Usage

### 1. Interactive Menu (TUI)
Simply run without any arguments:
```bash
sudo ntfs-tool
```

```
====================================================
   ntfs-tool — macOS NTFS Read/Write Manager        
   v1.0.0 | Apple Silicon & Intel (FUSE-T Engine) 
====================================================

  1) List Connected NTFS Drives
  2) Mount Drive in Read/Write Mode
  3) Safely Unmount / Eject Drive
  4) Run Dependency Doctor (Check FUSE-T & NTFS-3G)
  5) Install Missing Dependencies
  6) Start Auto-Mount Watcher (Terminal Loop)
  7) Install Background LaunchDaemon Service
  8) Uninstall Background LaunchDaemon Service
  0) Exit

Please enter your choice [0-8]:
```

---

### 2. Command Line Interface (CLI)

| Task | Command | Description |
| :--- | :--- | :--- |
| **List Drives** | `ntfs-tool list` | Scans and lists all connected NTFS volumes with mount status. |
| **Mount Read/Write** | `sudo ntfs-tool mount /dev/diskXsY` | Remounts specified disk in full Read/Write mode. *(Auto-detects disk if omitted)*. |
| **Safely Unmount** | `sudo ntfs-tool unmount /dev/diskXsY` | Flushes write cache, safely unmounts, and ejects the drive. |
| **Health Check** | `ntfs-tool doctor` | Validates Homebrew, FUSE-T, and NTFS-3G installations. |
| **Foreground Watcher** | `sudo ntfs-tool watch` | Monitors USB ports and automatically mounts any NTFS drive as Read/Write. |
| **Install Daemon** | `sudo ntfs-tool install-daemon` | Registers a macOS `LaunchDaemon` for seamless background auto-mounting. |
| **Remove Daemon** | `sudo ntfs-tool uninstall-daemon` | Removes the background `LaunchDaemon` service. |

---

## 🔌 Automatic Mounting via LaunchDaemon

To enable zero-touch automatic mounting whenever you connect an NTFS drive to your Mac:

```bash
sudo ntfs-tool install-daemon
```

This registers `/Library/LaunchDaemons/com.github.ntfs-tool.automount.plist`, which runs the lightweight watcher service continuously. Logs are saved to:
- `/var/log/ntfs_automount.log`
- `/var/log/ntfs_automount_err.log`

To disable the service at any time:
```bash
sudo ntfs-tool uninstall-daemon
```

---

## 🔍 Troubleshooting & FAQ

#### Q: Homebrew error: "Refusing to load formula gromgit/fuse/ntfs-3g-mac from untrusted tap"?
> **Answer**: Modern versions of Homebrew enforce a "Tap Trust" security policy for third-party taps. Authorize the tap by running:
> ```bash
> brew trust gromgit/fuse macos-fuse-t/homebrew-cask
> ```
> Then run `brew install ntfs-3g-mac`.

#### Q: "Operation not permitted" or permission errors when mounting?
> **Answer**: Filesystem mounting requires root privileges on macOS. Ensure you prepend commands with `sudo` (e.g., `sudo ntfs-tool mount`).

#### Q: The drive is labeled "Read-Only (Default macOS FSKit Driver)"?
> **Answer**: macOS natively mounts NTFS drives using FSKit in read-only mode upon connection. Run `sudo ntfs-tool mount` to safely unmount the FSKit instance and mount it with NTFS-3G in read/write mode.

#### Q: Do I need to disable SIP (System Integrity Protection)?
> **Answer**: **No!** Because `ntfs-tool` utilizes **FUSE-T** (which operates in user-space via a local NFS loopback), SIP and Apple Silicon Startup Security remain 100% active and untouched.

---

## 🗑️ Uninstallation

To cleanly remove `ntfs-tool` from your system:

```bash
cd ntfs-tool
sudo ./uninstall.sh
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/atilasevindi/ntfs-tool/issues) or read [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

Developed with ❤️ by **[Atila Sevindi](https://github.com/atilasevindi)**.
