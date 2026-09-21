#!/bin/bash
set -euo pipefail

# Hook: 05-grub-theme.sh
# Create macOS-like GRUB theme

chroot_dir="${1:-/}"

echo "Creating GRUB theme..."

# Create GRUB theme directory
mkdir -p "$chroot_dir/boot/grub/themes/macos-like"

# Copy background image (create a simple one using ImageMagick if available, or use a placeholder)
# For now, we'll create a simple SVG background
cat > "$chroot_dir/boot/grub/themes/macos-like/background.svg" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<svg width="1920" height="1080" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#1d1d1f;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#1a1a1c;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#161618;stop-opacity:1" />
    </linearGradient>
  </defs>
  <rect width="100%" height="100%" fill="url(#bg)"/>
  <circle cx="960" cy="540" r="300" fill="none" stroke="#007AFF" stroke-width="2" opacity="0.1"/>
  <circle cx="960" cy="540" r="250" fill="none" stroke="#007AFF" stroke-width="1" opacity="0.05"/>
  <text x="960" y="540" font-family="SF Pro Display, sans-serif" font-size="48" font-weight="bold" fill="#ffffff" text-anchor="middle" dominant-baseline="middle">macOS-like</text>
  <text x="960" y="600" font-family="SF Pro Display, sans-serif" font-size="18" fill="#8e8e93" text-anchor="middle" dominant-baseline="middle">Live System</text>
</svg>
EOF

# Convert SVG to PNG for GRUB (if ImageMagick available)
chroot "$chroot_dir" which convert >/dev/null 2>&1 && \
    chroot "$chroot_dir" convert /boot/grub/themes/macos-like/background.svg /boot/grub/themes/macos-like/background.png 2>/dev/null || \
    echo "ImageMagick not available, using SVG reference"

# Create GRUB theme file
cat > "$chroot_dir/boot/grub/themes/macos-like/theme.txt" << 'EOF'
# macOS-like GRUB Theme
# Inspired by Apple's boot loader aesthetic

# Global properties
title-text: "macOS-like Live System"
title-font: "SF Pro Display Bold 24"
title-color: "#ffffff"
title-align: "center"
title-position: "50%,10%"

# Background
+ boot_menu {
    left = 10%
    top = 25%
    width = 80%
    height = 60%
    background-color = "#1e1e1eE6"
    border = 2
    border-color = "#007AFF"
    border-radius = 16
    padding = 20
    
    item_font = "SF Pro Display 16"
    item_color = "#ffffff"
    selected_item_color = "#007AFF"
    selected_item_font = "SF Pro Display Bold 16"
    item_padding = 12
    item_spacing = 8
    item_icon_space = 16
    
    scrollbar = true
    scrollbar_thumb_color = "#007AFF"
    scrollbar_track_color = "#2d2d2d"
    scrollbar_width = 8
    
    timeout = 30
    timeout_font = "SF Pro Display 14"
    timeout_color = "#8e8e93"
    timeout_align = "center"
    timeout_position = "50%,90%"
}

# Progress bar (for kernel loading)
+ progress_bar {
    id = "__timeout__"
    left = 20%
    top = 88%
    width = 60%
    height = 6
    background_color = "#2d2d2d"
    border_color = "#3d3d3d"
    border = 1
    border_radius = 3
    foreground_color = "#007AFF"
    font = "SF Pro Display 12"
    text_color = "#ffffff"
    text = "@TIMEOUT_NOTIFICATION_LONG@"
}

# Help text
+ label {
    left = 50%
    top = 95%
    width = 80%
    align = "center"
    text = "Press Enter to boot, 'e' to edit, 'c' for command line"
    font = "SF Pro Display 12"
    color = "#6e6e73"
}

# Terminal (command line)
+ terminal {
    left = 10%
    top = 10%
    width = 80%
    height = 80%
    background_color = "#1e1e1eF0"
    border = 2
    border_color = "#007AFF"
    border_radius = 12
    padding = 20
    font = "SF Mono 12"
    color = "#ffffff"
    cursor_color = "#007AFF"
}

# Edit menu
+ boot_menu {
    name = "edit_menu"
    left = 10%
    top = 10%
    width = 80%
    height = 80%
    background_color = "#1e1e1eF0"
    border = 2
    border_color = "#007AFF"
    border_radius = 12
    padding = 20
    item_font = "SF Mono 12"
    item_color = "#ffffff"
    selected_item_color = "#007AFF"
    item_padding = 8
    item_spacing = 4
}
EOF

# Create a default.png symlink for compatibility
ln -sf background.png "$chroot_dir/boot/grub/themes/macos-like/default.png" 2>/dev/null || true

# Update GRUB configuration to use the theme
mkdir -p "$chroot_dir/etc/default"
cat > "$chroot_dir/etc/default/grub" << 'EOF'
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_TIMEOUT_STYLE=menu
GRUB_DISTRIBUTOR="macOS-like"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 systemd.show_status=0 rd.udev.log_level=3 vt.global_cursor_default=0"
GRUB_CMDLINE_LINUX=""
GRUB_THEME="/boot/grub/themes/macos-like/theme.txt"
GRUB_GFXMODE=1920x1080x32,1920x1080x24,1920x1080,1024x768x32,1024x768x24,1024x768,auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_OS_PROBER=true
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT=gfxterm
EOF

# Update GRUB
chroot "$chroot_dir" update-grub 2>/dev/null || true

echo "GRUB theme created"