#!/bin/bash
set -euo pipefail

# Hook: 06-system-config.sh
# System-level configuration

chroot_dir="${1:-/}"

echo "Configuring system settings..."

# Hostname
echo "maclike" > "$chroot_dir/etc/hostname"

# Hosts file
cat > "$chroot_dir/etc/hosts" << 'EOF'
127.0.0.1   localhost
127.0.1.1   maclike.local maclike

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

# Locale
cat > "$chroot_dir/etc/locale.gen" << 'EOF'
en_US.UTF-8 UTF-8
EOF
chroot "$chroot_dir" locale-gen

cat > "$chroot_dir/etc/default/locale" << 'EOF'
LANG=en_US.UTF-8
LANGUAGE=en_US:en
LC_ALL=en_US.UTF-8
EOF

# Timezone
echo "UTC" > "$chroot_dir/etc/timezone"
chroot "$chroot_dir" ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Keyboard
cat > "$chroot_dir/etc/default/keyboard" << 'EOF'
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOF

# NetworkManager configuration for better UX
mkdir -p "$chroot_dir/etc/NetworkManager/conf.d"
cat > "$chroot_dir/etc/NetworkManager/conf.d/20-maclike.conf" << 'EOF'
[main]
dns=systemd-resolved
rc-manager=systemd-resolved

[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
wifi.powersave=2
EOF

# systemd-resolved configuration
mkdir -p "$chroot_dir/etc/systemd/resolved.conf.d"
cat > "$chroot_dir/etc/systemd/resolved.conf.d/maclike.conf" << 'EOF'
[Resolve]
DNS=1.1.1.1 8.8.8.8
DNSOverTLS=yes
MulticastDNS=yes
LLMNR=yes
Cache=yes
EOF

# Disable root password (use sudo)
chroot "$chroot_dir" passwd -d root 2>/dev/null || true
chroot "$chroot_dir" passwd -l root 2>/dev/null || true

# Configure sudo for macuser (no password)
cat > "$chroot_dir/etc/sudoers.d/macuser" << 'EOF'
macuser ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 "$chroot_dir/etc/sudoers.d/macuser"

# Configure autologin for live user
mkdir -p "$chroot_dir/etc/systemd/system/getty@tty1.service.d"
cat > "$chroot_dir/etc/systemd/system/getty@tty1.service.d/override.conf" << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin macuser --noclear %I $TERM
EOF

# LightDM autologin (if using display manager)
mkdir -p "$chroot_dir/etc/lightdm/lightdm.conf.d"
cat > "$chroot_dir/etc/lightdm/lightdm.conf.d/50-autologin.conf" << 'EOF'
[Seat:*]
autologin-user=macuser
autologin-user-timeout=0
user-session=xfce
greeter-session=lightdm-gtk-greeter
EOF

# LightDM GTK greeter theme
mkdir -p "$chroot_dir/etc/lightdm"
cat > "$chroot_dir/etc/lightdm/lightdm-gtk-greeter.conf" << 'EOF'
[greeter]
theme-name = WhiteSur-Dark
icon-theme-name = WhiteSur-dark
cursor-theme-name = WhiteSur-cursors
cursor-theme-size = 24
font-name = SF Pro Display 11
background = /usr/share/backgrounds/macos-like/default.png
user-background = false
show-indicators = ~host;~spacer;~clock;~spacer;~layout;~session;~language;~a11y;~power
position = 50%,center 50%,center
panel-position = 0,0 100%,0
screensaver-timeout = 60
clock-format = %H:%M
keyboard = onboard
default-user-image = #ffffff
EOF

# Create default background
mkdir -p "$chroot_dir/usr/share/backgrounds/macos-like"
# Create a simple background using ImageMagick if available
chroot "$chroot_dir" which convert >/dev/null 2>&1 && \
    chroot "$chroot_dir" convert -size 1920x1080 gradient:'#1d1d1f'-'#161618' /usr/share/backgrounds/macos-like/default.png 2>/dev/null || \
    echo "Background image will be generated on first boot"

# Disable unnecessary services for faster boot
chroot "$chroot_dir" systemctl disable apt-daily.timer apt-daily-upgrade.timer 2>/dev/null || true
chroot "$chroot_dir" systemctl disable man-db.timer 2>/dev/null || true
chroot "$chroot_dir" systemctl disable motd-news.timer 2>/dev/null || true
chroot "$chroot_dir" systemctl disable e2scrub_all.timer 2>/dev/null || true

# Enable useful services
chroot "$chroot_dir" systemctl enable NetworkManager 2>/dev/null || true
chroot "$chroot_dir" systemctl enable bluetooth 2>/dev/null || true
chroot "$chroot_dir" systemctl enable cups 2>/dev/null || true
chroot "$chroot_dir" systemctl enable systemd-resolved 2>/dev/null || true
chroot "$chroot_dir" systemctl enable systemd-timesyncd 2>/dev/null || true
chroot "$chroot_dir" systemctl enable lightdm 2>/dev/null || true
chroot "$chroot_dir" systemctl enable vboxservice 2>/dev/null || true

# Configure lightdm to use XFCE
mkdir -p "$chroot_dir/etc/lightdm"
cat > "$chroot_dir/etc/lightdm/lightdm.conf" << 'EOF'
[LightDM]
run-directory=/run/lightdm
minimum-display-number=0
minimum-vt=7

[Seat:*]
type=local
autologin-user=macuser
autologin-user-timeout=0
pam-service=lightdm-autologin
pam-autologin-service=lightdm-autologin
greeter-session=lightdm-gtk-greeter
user-session=xfce
session-wrapper=/etc/X11/Xsession

[XDMCPServer]
enabled=false

[VNCServer]
enabled=false
EOF

echo "System configuration complete"