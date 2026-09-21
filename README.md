# macOS-like Live ISO Builder

Builds a ~3GB Debian-based Live ISO with macOS-inspired UI:
- **Plank Dock** (bottom, macOS-style)
- **Rofi Launcher** (Super+Space, Spotlight-like)
- **Thunar File Manager** (Finder-like with sidebar)
- **WhiteSur GTK/Icon/Cursor Theme** (macOS Big Sur/Monterey/Ventura aesthetic)
- **XFCE Desktop** (lightweight, highly customizable)
- **Picom Compositor** (transparency, shadows, blur)
- **SF Pro-like Fonts** (Inter + JetBrains Mono)
- **GRUB Theme** (macOS-style boot screen)

## Requirements

- **Docker** (Desktop for Windows/macOS, Engine for Linux)
- **~15GB free disk space** (build cache + ISO)
- **8GB+ RAM** recommended

## Quick Start

### Windows/macOS (Docker Desktop)

```bash
# Clone or navigate to this directory
cd macos-like-iso

# Build the ISO (takes 30-60 minutes)
docker build -t macos-like-iso .
docker run --rm -v ${PWD}/output:/build/output macos-like-iso
```

### Linux (Native Docker)

```bash
cd macos-like-iso
docker build -t macos-like-iso .
docker run --rm -v $(pwd)/output:/build/output macos-like-iso
```

### With more resources (faster build)

```bash
docker run --rm \
  --cpus=4 \
  --memory=8g \
  -v ${PWD}/output:/build/output \
  macos-like-iso
```

## Output

The ISO will be in `./output/`:
```
output/
└── live-image-amd64.hybrid.iso   (~2.8-3.2 GB)
```

## Using in VirtualBox

1. **Create New VM**:
   - Type: Linux → Debian (64-bit)
   - Memory: 4096 MB (minimum 2048 MB)
   - Disk: 25 GB+ (VDI, dynamically allocated)

2. **Settings → System**:
   - Enable EFI (for UEFI boot)
   - Processor: 2+ CPUs
   - Enable PAE/NX

3. **Settings → Display**:
   - Video Memory: 128 MB
   - Enable 3D Acceleration
   - Graphics Controller: VMSVGA

4. **Settings → Storage**:
   - Attach the ISO to Optical Drive

5. **Settings → Network**:
   - Adapter 1: Bridged Adapter (for internet)
   - Or: NAT (default works)

6. **Boot** → Press Enter at GRUB menu

## Default Login

- **User**: `macuser`
- **Password**: *(none - auto-login enabled)*
- **Sudo**: No password required

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super` (Win/Cmd) | Whisker Menu (app launcher) |
| `Super` + `Space` | Rofi (Spotlight-like search) |
| `Super` + `Return` | Terminal |
| `Super` + `E` | File Manager (Finder) |
| `Super` + `L` | Lock Screen |
| `Print` | Screenshot (Flameshot) |
| `Super` + `Shift` + `S` | Area Screenshot |

## Dock (Plank)

- **Bottom center** - auto-hides intelligently
- **Right-click** items for options
- **Drag & drop** to rearrange
- **Default apps**: Finder, Terminal, Browser, Settings, Software

## Customization

### Modify Packages

Edit `config/package-lists/desktop.list.chroot`:
```bash
# Add packages (one per line)
firefox
libreoffice
gimp
# build-essential
# docker.io
```

### Change Theme

Edit hooks in `config/hooks/`:
- `01-install-themes.sh` - GTK/Icon/Cursor themes
- `03-configure-desktop-theme.sh` - XFCE/GTK/Qt settings
- `05-grub-theme.sh` - Boot screen

### Add User Files

Place files in `config/includes.chroot/etc/skel/`:
```
config/includes.chroot/etc/skel/
├── .bashrc
├── .profile
├── .xsessionrc
├── .config/
│   ├── starship.toml
│   ├── plank/
│   ├── rofi/
│   └── ...
```

### Persistent Storage (Live USB)

For USB with persistence:
```bash
# After writing ISO to USB, create persistence partition
# Then add to GRUB: persistence persistence-media=/dev/sdX
```

## Build Architecture

```
macos-like-iso/
├── Dockerfile                 # Build container
├── auto/build                 # live-build wrapper
├── config/
│   ├── package-lists/         # Package selections
│   │   └── desktop.list.chroot
│   ├── hooks/                 # Customization scripts (run in chroot)
│   │   ├── 01-install-themes.sh
│   │   ├── 02-configure-dock-launcher.sh
│   │   ├── 03-configure-desktop-theme.sh
│   │   ├── 04-configure-autostart.sh
│   │   ├── 05-grub-theme.sh
│   │   ├── 06-system-config.sh
│   │   ├── 07-install-fonts.sh
│   │   └── 08-firstboot.sh
│   └── includes.chroot/       # Files copied to /etc/skel/
│       └── etc/skel/
└── README.md
```

## Troubleshooting

### Build Fails with "No space left"
```bash
# Clean Docker
docker system prune -a --volumes
# Or increase Docker disk image size (Docker Desktop → Settings → Resources)
```

### ISO Won't Boot in VirtualBox
- Enable **EFI** in VM Settings → System
- Try **VMSVGA** graphics controller
- Increase video memory to 128MB

### Dock/Theme Not Applied
- Reboot (first boot runs setup script)
- Check `~/.config/plank/dock1/settings`
- Run `plank --preferences` to configure

### Network Not Working
```bash
# In VM terminal:
sudo systemctl restart NetworkManager
nmcli device connect <interface>
```

## License

- Build scripts: MIT
- WhiteSur Theme: GPL-3.0 (by vinceliuice)
- Debian packages: Various (see individual packages)
- **Not affiliated with Apple Inc.**

## Credits

- [WhiteSur GTK Theme](https://github.com/vinceliuice/WhiteSur-gtk-theme)
- [WhiteSur Icon Theme](https://github.com/vinceliuice/WhiteSur-icon-theme)
- [WhiteSur Cursors](https://github.com/vinceliuice/WhiteSur-cursors)
- [Plank Dock](https://launchpad.net/plank)
- [Rofi](https://github.com/davatorium/rofi)
- [Picom](https://github.com/yshui/picom)
- [Inter Font](https://github.com/rsms/inter)
- [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono)