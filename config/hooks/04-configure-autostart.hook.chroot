#!/bin/bash
set -euo pipefail

# Hook: 04-configure-autostart.sh
# Configure autostart applications

chroot_dir="${1:-/}"
target_user="macuser"
user_home="/home/$target_user"

echo "Configuring autostart applications..."

# Create autostart directory
chroot "$chroot_dir" mkdir -p "$user_home/.config/autostart"

# Plank dock
cat > "$chroot_dir$user_home/.config/autostart/plank.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Plank
Comment=MacOS-style Dock
Exec=plank
Terminal=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=XFCE;
StartupNotify=false
EOF

# Picom compositor
cat > "$chroot_dir$user_home/.config/autostart/picom.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Picom
Comment=Compositor for transparency and shadows
Exec=picom --config /home/macuser/.config/picom/picom.conf -b
Terminal=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=XFCE;
StartupNotify=false
EOF

# Rofi (optional, for keyboard shortcut)
cat > "$chroot_dir$user_home/.config/autostart/rofi.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Rofi Launcher
Comment=Spotlight-like application launcher
Exec=rofi -show drun -theme ~/.config/rofi/macos.rasi
Terminal=false
X-GNOME-Autostart-enabled=false
OnlyShowIn=XFCE;
StartupNotify=false
EOF

# NM Applet
cat > "$chroot_dir$user_home/.config/autostart/nm-applet.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Network
Comment=Network Manager Applet
Exec=nm-applet
Terminal=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=XFCE;
StartupNotify=false
EOF

# Blueman Applet
cat > "$chroot_dir$user_home/.config/autostart/blueman.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Bluetooth
Comment=Blueman Applet
Exec=blueman-applet
Terminal=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=XFCE;
StartupNotify=false
EOF

# Power Manager
cat > "$chroot_dir$user_home/.config/autostart/xfce4-power-manager.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=Power Manager
Comment=XFCE Power Manager
Exec=xfce4-power-manager
Terminal=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=XFCE;
StartupNotify=false
EOF

# Set ownership
chroot "$chroot_dir" chown -R "$target_user:$target_user" "$user_home/.config"

echo "Autostart configuration complete"