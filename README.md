<![CDATA[<div align="center">

```
   _____                .__      ___________                                                                           
  /  _  \_______   ____ |  |__   \_   _____/____    _________.__.                                                      
 /  /_\  \_  __ \_/ ___\|  |  \   |    __)_\__  \  /  ___<   |  |                                                      
/    |    \  | \/\  \___|   Y  \  |        \/ __ \_\___ \ \___  |                                                      
\____|__  /__|    \___  >___|  / /_______  (____  /____  >/ ____|                                                      
        \/            \/     \/          \/     \/     \/ \/                                                           
```

# 🐧 Mathisen's Arch Install Script

**A fully interactive, ncurses-based Arch Linux installer**

[![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?style=flat&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License](https://img.shields.io/badge/License-WTFPL-brightgreen?style=flat)](http://www.wtfpl.net/)

*Works on virtual machines and bare metal hardware*

</div>

---

## ⚠️ Important Warning

> **🔴 BACKUP YOUR DATA BEFORE USING THIS SCRIPT**
>
> This script was primarily designed and tested for **virtual machines** where data loss is not a concern. While it does work on bare metal hardware, **results may vary** depending on your specific hardware configuration, existing partitions, and system setup.
>
> **By using this script, you acknowledge that:**
> - You have backed up all important data
> - The author is **NOT responsible** for any data loss or system damage
> - You are using this script **at your own risk**
> - Complex hardware setups (RAID, multiple drives, unusual partition layouts) may cause unexpected behavior
>
> **Recommended use cases:**
> - ✅ Fresh VM installations (primary target)
> - ✅ Bare metal with a dedicated disk and no important data
> - ✅ Test environments
> - ⚠️ Dual-boot setups (proceed with caution, backup Windows first!)
> - ❌ Production systems with critical data (not recommended without full backup)

---

## ⚡ Quick Start

Boot from the Arch Linux live ISO, then run:

```bash
bash <(curl -sL https://raw.githubusercontent.com/mathisen99/arch-install-vm/main/arch-install.sh)
```

<details>
<summary>📥 Alternative: Download and run manually</summary>

```bash
curl -sLO https://raw.githubusercontent.com/mathisen99/arch-install-vm/main/arch-install.sh
chmod +x arch-install.sh
./arch-install.sh
```

</details>

---

## ✨ Features

<table>
<tr>
<td width="50%" valign="top">

### 🖥️ Installation Modes
- **Clean Install** — Wipes disk and installs fresh
- **Dual-Boot** — Auto-detects Windows and installs alongside

### 💾 Filesystem Options
| Option | Description |
|--------|-------------|
| `ext4` | Traditional, stable, fast |
| `btrfs` | Subvolumes, snapshots, zstd compression |

### 🔐 Security
- Optional **LUKS** full disk encryption
- Automatic mkinitcpio & GRUB configuration
- Proper sudo configuration for wheel group

</td>
<td width="50%" valign="top">

### ⚙️ Auto-Detection
- **Boot Mode** — UEFI or BIOS (GPT/MBR)
- **CPU** — Intel/AMD microcode installation
- **RAM** — For tmpfs sizing
- **GPU** — NVIDIA detection for Wayland compositors
- **Windows** — EFI Boot Manager & NTFS partitions

### 🚀 Performance
- **zswap** — Compressed swap in RAM (zstd, 25% pool)
- **tmpfs** — `/tmp` as RAM disk (50% of RAM)
- **Reflector** — Auto mirror updates via timer

</td>
</tr>
</table>

---

## 🖼️ Desktop Environments

| Desktop | Type | Display Manager | Notes |
|---------|------|-----------------|-------|
| **XFCE4** | Traditional | LightDM | Lightweight, goodies included |
| **GNOME** | Modern | GDM | Tweaks & extensions |
| **KDE Plasma** | Feature-rich | SDDM | Full meta packages |
| **Cinnamon** | Windows-like | LightDM | Nemo file manager |
| **MATE** | Classic | LightDM | GNOME 2 fork |
| **LXQt** | Lightweight | LightDM | Qt-based |
| **Budgie** | Elegant | GDM | Modern desktop |
| **i3** | Tiling WM | None | `startx` to launch |
| **Sway** | Wayland Tiling | None | `sway` to launch |
| **Hyprland** | Dynamic Tiling | SDDM | Full Hypr ecosystem |
| **None** | CLI Only | — | Server/minimal setup |

<details>
<summary>🌟 <b>Hyprland Extras</b></summary>

The Hyprland installation includes the complete ecosystem:

| Category | Packages |
|----------|----------|
| **Core** | hyprland, xdg-desktop-portal-hyprland, xdg-desktop-portal-gtk |
| **Hypr Tools** | hyprpaper, hypridle, hyprlock, hyprpolkitagent |
| **Bar & Launcher** | waybar, wofi |
| **Terminal** | foot |
| **Notifications** | mako |
| **Screenshots** | grim, slurp |
| **Clipboard** | wl-clipboard, cliphist |
| **Controls** | brightnessctl, playerctl, pamixer |
| **Qt Support** | qt5-wayland, qt6-wayland |

</details>

---

## 🐚 Shell Options

| Option | Description |
|--------|-------------|
| **Bash** | Standard shell (default) |
| **Zsh** | Powerful shell with completions |
| **Zsh + Oh-My-Zsh** | Pre-configured with `agnoster` theme and plugins (`git`, `sudo`, `history`, `archlinux`) |

---

## 🔧 Interactive Configuration

The script uses ncurses dialogs for a smooth experience:

```
┌─────────────────────────────────────────────────────────────┐
│  1. 🌍 Country          Mirror selection (reflector)        │
│  2. 💾 Filesystem       ext4 or btrfs                       │
│  3. 🔐 Encryption       LUKS yes/no (+ password)            │
│  4. 🖥️  Desktop          11 options to choose from           │
│  5. 🐚 Shell            bash, zsh, or zsh + Oh-My-Zsh       │
│  6. 💿 Disk             Target disk selection               │
│  7. 🏠 Hostname         Machine name                        │
│  8. 🕐 Timezone         Region and city                     │
│  9. 🌐 Locale           Language (e.g., en_US)              │
│ 10. ⌨️  Keymap           Console keyboard layout             │
│ 11. 🔑 Root Password    With confirmation                   │
│ 12. 👤 Username         Regular user account                │
│ 13. 🔑 User Password    With confirmation                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 💻 Dual-Boot with Windows

The script automatically detects Windows by checking for:
- ✅ Windows EFI Boot Manager
- ✅ NTFS partitions

```
┌──────────────────────────────────────────────────────────────┐
│  ⚠️  IMPORTANT: Before dual-boot installation                 │
│                                                              │
│  1. Boot into Windows                                        │
│  2. Open Disk Management                                     │
│  3. Shrink your Windows partition                            │
│  4. Leave at least 20GB of unallocated space                 │
│  5. Boot from Arch ISO and run this script                   │
└──────────────────────────────────────────────────────────────┘
```

> **Note:** LUKS encryption is not supported with dual-boot mode.

---

## 📦 Installed Packages

<details>
<summary><b>Base System</b></summary>

| Package | Purpose |
|---------|---------|
| `base`, `base-devel` | Core system |
| `linux`, `linux-firmware` | Kernel & firmware |
| `networkmanager` | Network management |
| `grub`, `efibootmgr` | Bootloader |
| `sudo`, `nano`, `vim` | Essential tools |
| `btop`, `terminator`, `tmux`, `kitty` | Terminal utilities |
| `reflector` | Mirror management |
| `os-prober`, `ntfs-3g` | Dual-boot support |
| `btrfs-progs` | Btrfs tools (if selected) |
| `intel-ucode` / `amd-ucode` | CPU microcode |

</details>

<details>
<summary><b>Audio Stack</b></summary>

| Package | Purpose |
|---------|---------|
| `pipewire` | Modern audio server |
| `pipewire-alsa` | ALSA compatibility |
| `pipewire-pulse` | PulseAudio compatibility |
| `wireplumber` | Session manager |
| `pavucontrol` | Volume control GUI |
| `alsa-utils` | ALSA utilities |

</details>

<details>
<summary><b>Desktop Extras</b></summary>

| Package | Purpose |
|---------|---------|
| `network-manager-applet` | System tray network |
| `nm-connection-editor` | Network GUI |
| `gvfs`, `gvfs-mtp`, `gvfs-smb` | Virtual filesystem |
| `file-roller`, `unzip`, `p7zip` | Archive tools |
| `firefox` | Web browser |
| `ttf-dejavu`, `ttf-liberation`, `noto-fonts` | Fonts |
| `xdg-user-dirs`, `xdg-utils` | XDG utilities |

</details>

---

## 🎮 NVIDIA Support

For **Hyprland** and **Sway**, the script detects NVIDIA GPUs and offers proprietary driver installation:

```
┌─────────────────────────────────────────────────────────────┐
│  📦 Packages: nvidia, nvidia-utils, nvidia-settings         │
│                                                             │
│  ⚙️  Configuration:                                          │
│     • /etc/modprobe.d/nvidia.conf (modeset=1, fbdev=1)      │
│     • NVIDIA modules added to initramfs                     │
│     • Pacman hook for automatic initramfs rebuild           │
│                                                             │
│  🌊 Hyprland Environment Variables:                         │
│     • LIBVA_DRIVER_NAME=nvidia                              │
│     • XDG_SESSION_TYPE=wayland                              │
│     • GBM_BACKEND=nvidia-drm                                │
│     • __GLX_VENDOR_LIBRARY_NAME=nvidia                      │
│     • NVD_BACKEND=direct                                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Requirements

| Requirement | Details |
|-------------|---------|
| **Environment** | Arch Linux live ISO |
| **Connection** | Internet required |
| **Disk Space** | Minimum 20GB (or free space for dual-boot) |
| **Platform** | Virtual machines (QEMU/KVM, VirtualBox, VMware) or bare metal |

> **Note:** This script is optimized for simple single-disk setups. Complex configurations (multiple drives, existing RAID arrays, unusual partition schemes) may require manual intervention or produce unexpected results.

---

## 🚀 After Installation

The system reboots automatically. What happens next depends on your choices:

| Setup | What to Expect |
|-------|----------------|
| **With Display Manager** | Graphical login screen |
| **i3** | Login → run `startx` |
| **Sway** | Login → run `sway` |
| **Hyprland** | SDDM login → select Hyprland session |
| **CLI Only** | Text login, use `nmtui` for network |
| **Dual-boot** | GRUB menu shows Arch & Windows |
| **LUKS Encrypted** | Password prompt at boot |

---

## 🗂️ Btrfs Subvolume Layout

When btrfs is selected, the following subvolumes are created:

```
/           → @
/home       → @home
/.snapshots → @snapshots
/var/log    → @var_log
```

Mount options: `noatime,compress=zstd,space_cache=v2,discard=async`

---

## 📜 License

```
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.
```

---

<div align="center">

**Made with ☕ by [Mathisen](https://github.com/mathisen99)**

*Ideas & contributions by [frontendback](https://github.com/frontendback)*

*If this helped you, consider giving it a ⭐*

</div>