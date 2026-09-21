#!/bin/bash
set -euo pipefail

# Hook: 07-install-fonts.sh
# Install SF Pro-like fonts

chroot_dir="${1:-/}"

echo "Installing fonts..."

# Create fonts directory
mkdir -p "$chroot_dir/usr/local/share/fonts"

# Install Inter font (close to SF Pro, available in Debian)
chroot "$chroot_dir" apt-get update
chroot "$chroot_dir" apt-get install -y --no-install-recommends fonts-inter

# Download and install SF Pro Display / SF Mono alternatives
# Using Inter for SF Pro Display, JetBrains Mono for SF Mono
cd /tmp

# Install JetBrains Mono
wget -q https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip -O JetBrainsMono.zip
unzip -q JetBrainsMono.zip -d JetBrainsMono
cp JetBrainsMono/fonts/ttf/*.ttf "$chroot_dir/usr/local/share/fonts/"
rm -rf JetBrainsMono JetBrainsMono.zip

# Install Inter (additional weights)
wget -q https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip -O Inter.zip
unzip -q Inter.zip -d Inter
find Inter -name "*.ttf" -exec cp {} "$chroot_dir/usr/local/share/fonts/" \;
rm -rf Inter Inter.zip

# Create font aliases for SF Pro names
mkdir -p "$chroot_dir/etc/fonts/conf.d"
cat > "$chroot_dir/etc/fonts/conf.d/99-maclike-aliases.conf" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Alias SF Pro Display to Inter -->
  <alias binding="same">
    <family>SF Pro Display</family>
    <prefer>
      <family>Inter</family>
    </prefer>
  </alias>
  <alias binding="same">
    <family>SF Pro Text</family>
    <prefer>
      <family>Inter</family>
    </prefer>
  </alias>
  <alias binding="same">
    <family>SF Pro Rounded</family>
    <prefer>
      <family>Inter</family>
    </prefer>
  </alias>
  
  <!-- Alias SF Mono to JetBrains Mono -->
  <alias binding="same">
    <family>SF Mono</family>
    <prefer>
      <family>JetBrains Mono</family>
    </prefer>
  </alias>
  
  <!-- Default sans-serif -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Inter</family>
      <family>Noto Sans</family>
      <family>DejaVu Sans</family>
    </prefer>
  </alias>
  
  <!-- Default monospace -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>JetBrains Mono</family>
      <family>Noto Sans Mono</family>
      <family>DejaVu Sans Mono</family>
    </prefer>
  </alias>
</fontconfig>
EOF

# Rebuild font cache
chroot "$chroot_dir" fc-cache -f -v

echo "Fonts installed"