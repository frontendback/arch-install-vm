# Mathisen's Arch Install Script for VMs

A fully interactive script to auto-install Arch Linux inside QEMU/KVM virtual machines with a beautiful ncurses interface.

## Features

### System
- Auto-detects UEFI or BIOS boot mode
- Auto-detects CPU (Intel/AMD) and installs appropriate microcode
- Reflector mirror selection with country picker (ncurses menu)
- Partitions entire disk automatically
- GRUB bootloader with automatic configuration

### Filesystem Options
- **ext4** - Traditional, stable, fast
- **Btrfs** - With subvolumes (@, @home, @snapshots, @var_log) and zstd compression

### Encryption
- Optional **LUKS** full disk encryption
- Automatic mkinitcpio and GRUB configuration for encrypted boot

### Desktop Environments
- **XFCE4** - Lightweight, traditional (LightDM)
- **GNOME** - Modern, full-featured (GDM)
- **KDE Plasma** - Feature-rich, customizable (SDDM)
- **Cinnamon** - Traditional, Windows-like (LightDM)
- **MATE** - Classic GNOME 2 fork (LightDM)
- **LXQt** - Lightweight Qt desktop (LightDM)
- **Budgie** - Modern, elegant (GDM)
- **i3** - Tiling window manager (no DM)
- **Sway** - i3-compatible Wayland compositor (no DM)
- **Hyprland** - Dynamic tiling Wayland compositor (SDDM)
- **None** - CLI only

### Hyprland Extras
- Full Hypr ecosystem (hyprpaper, hypridle, hyprlock, hyprpolkitagent)
- Waybar, wofi, foot terminal, mako notifications
- Screenshot tools (grim, slurp), clipboard (wl-clipboard, cliphist)
- **NVIDIA GPU detection** with automatic driver installation and configuration

### Shell Options
- **Bash** - Standard shell
- **Zsh** - Powerful shell with completions
- **Zsh + Oh-My-Zsh** - Pre-configured with agnoster theme and useful plugins

### Performance
- **zswap** - Compressed swap in RAM (zstd compression)
- **tmpfs** - /tmp as RAM disk (50% of RAM)
- Reflector timer for automatic mirror updates

### Audio
- **PipeWire** with PulseAudio compatibility
- pavucontrol for volume control

## Usage

Boot your QEMU VM from the Arch Linux live ISO, then run:

```bash
bash <(curl -sL https://raw.githubusercontent.com/mathisen99/arch-install-vm/main/arch-install.sh)
```

Or download and run manually:

```bash
curl -sLO https://raw.githubusercontent.com/mathisen99/arch-install-vm/main/arch-install.sh
chmod +x arch-install.sh
./arch-install.sh
```

## Interactive Prompts

The script uses ncurses dialogs for a user-friendly experience:

1. **Country** - For mirror selection (reflector)
2. **Filesystem** - ext4 or btrfs
3. **Encryption** - LUKS yes/no (with password if yes)
4. **Desktop Environment** - Choose from 10+ options
5. **Shell** - bash, zsh, or zsh with Oh-My-Zsh
6. **Disk** - Select target disk
7. **Hostname** - Name for your machine
8. **Timezone** - Region and city selection
9. **Locale** - Language setting (e.g., en_US)
10. **Keymap** - Console keyboard layout
11. **Root password** - With confirmation
12. **Username** - Regular user account
13. **User password** - With confirmation

## Installed Packages

### Base System
- `base`, `base-devel`, `linux`, `linux-firmware`
- `networkmanager`, `grub`, `sudo`, `nano`, `vim`
- `reflector`, `btrfs-progs` (if btrfs selected)
- CPU microcode (intel-ucode or amd-ucode)

### Desktop (varies by selection)
- Display server (Xorg or Wayland)
- Display manager (LightDM, GDM, SDDM, or none)
- Desktop environment packages
- PipeWire audio stack
- Firefox, file manager, fonts

### Extras
- `network-manager-applet`, `nm-connection-editor`
- `gvfs`, `gvfs-mtp`, `gvfs-smb`
- `file-roller`, `unzip`, `p7zip`
- `ttf-dejavu`, `ttf-liberation`, `noto-fonts`
- `xdg-user-dirs`, `xdg-utils`

## Requirements

- QEMU/KVM virtual machine (or bare metal)
- Arch Linux live ISO
- Internet connection
- At least 20GB disk space recommended

## After Installation

The system will reboot automatically. Depending on your choices:

- **With display manager**: Graphical login screen appears
- **i3**: Login and run `startx`
- **Sway**: Login and run `sway`
- **Hyprland**: SDDM login screen (select Hyprland session)
- **CLI only**: Text login, use `nmtui` for network

## NVIDIA Support

For Hyprland and Sway, the script detects NVIDIA GPUs and offers to install proprietary drivers with:
- `nvidia`, `nvidia-utils`, `nvidia-settings`
- `/etc/modprobe.d/nvidia.conf` with `modeset=1`
- Pacman hook for automatic initramfs rebuild
- Hyprland environment variables for NVIDIA

## License

Do whatever you want with it.
