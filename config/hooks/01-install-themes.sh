#!/bin/bash
set -euo pipefail

# Hook: 01-install-themes.sh
# Install WhiteSur GTK theme and icons (macOS-like)

chroot_dir="${1:-/}"
target_user="macuser"

echo "Installing WhiteSur theme and icons..."

# Install dependencies for theme building
chroot "$chroot_dir" apt-get update
chroot "$chroot_dir" apt-get install -y --no-install-recommends \
    git \
    sassc \
    libglib2.0-dev \
    libxml2-utils \
    inkscape \
    optipng \
    parallel

# Clone and install WhiteSur GTK Theme
cd /tmp
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
chroot "$chroot_dir" ./install.sh -c Dark -c Light -t all -i default --round --float
cd /tmp
rm -rf WhiteSur-gtk-theme

# Clone and install WhiteSur Icon Theme
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
chroot "$chroot_dir" ./install.sh -t all
cd /tmp
rm -rf WhiteSur-icon-theme

# Clone and install WhiteSur Cursors
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
chroot "$chroot_dir" ./install.sh
cd /tmp
rm -rf WhiteSur-cursors

# Install Kvantum theme for Qt apps
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-kde.git
cd WhiteSur-kde
chroot "$chroot_dir" ./install.sh
cd /tmp
rm -rf WhiteSur-kde

echo "Theme installation complete"