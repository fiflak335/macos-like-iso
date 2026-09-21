#!/bin/bash
set -euo pipefail

# Hook: 08-firstboot.sh
# First boot setup script

chroot_dir="${1:-/}"
target_user="macuser"
user_home="/home/$target_user"

echo "Creating first-boot setup..."

# Create first-boot service
mkdir -p "$chroot_dir/etc/systemd/system"
cat > "$chroot_dir/etc/systemd/system/maclike-firstboot.service" << 'EOF'
[Unit]
Description=macOS-like First Boot Setup
After=graphical.target network-online.target
Wants=network-online.target
ConditionPathExists=!/home/macuser/.config/maclike-firstboot-done

[Service]
Type=oneshot
ExecStart=/usr/local/bin/maclike-firstboot.sh
RemainAfterExit=yes
StandardOutput=journal+console

[Install]
WantedBy=graphical.target
EOF

# Create first-boot script
mkdir -p "$chroot_dir/usr/local/bin"
cat > "$chroot_dir/usr/local/bin/maclike-firstboot.sh" << 'EOF'
#!/bin/bash
set -euo pipefail

USER_HOME="/home/macuser"
DONE_FILE="$USER_HOME/.config/maclike-firstboot-done"

# Wait for graphical session
sleep 3

# Generate wallpaper if not exists
if [ ! -f /usr/share/backgrounds/macos-like/default.png ]; then
    if command -v convert >/dev/null 2>&1; then
        convert -size 1920x1080 gradient:'#1d1d1f'-'#161618' /usr/share/backgrounds/macos-like/default.png 2>/dev/null || true
    fi
fi

# Set wallpaper for XFCE
if command -v xfconf-query >/dev/null 2>&1; then
    sudo -u macuser xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s /usr/share/backgrounds/macos-like/default.png 2>/dev/null || true
    sudo -u macuser xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 5 2>/dev/null || true
fi

# Create welcome notification
if command -v notify-send >/dev/null 2>&1; then
    sudo -u macuser DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send \
        "Welcome to macOS-like" \
        "Press Super+Space for Spotlight-like search\nSuper+Return for Terminal\nDock at bottom for apps" \
        -i preferences-system -t 10000 2>/dev/null || true
fi

# Mark as done
mkdir -p "$(dirname "$DONE_FILE")"
touch "$DONE_FILE"
chown macuser:macuser "$DONE_FILE"

# Disable this service
systemctl disable maclike-firstboot.service 2>/dev/null || true

exit 0
EOF

chmod +x "$chroot_dir/usr/local/bin/maclike-firstboot.sh"

# Enable the service
chroot "$chroot_dir" systemctl enable maclike-firstboot.service 2>/dev/null || true

echo "First boot setup created"