#!/bin/bash
set -euo pipefail

# Hook: 02-configure-dock-launcher.sh
# Configure Plank dock and Rofi launcher

chroot_dir="${1:-/}"
target_user="macuser"
user_home="/home/$target_user"

echo "Configuring Plank dock and Rofi launcher..."

# Create Plank configuration directory
chroot "$chroot_dir" mkdir -p "$user_home/.config/plank/dock1/launchers"

# Configure Plank dock settings
cat > "$chroot_dir$user_home/.config/plank/dock1/settings" << 'EOF'
[PlankDockPreferences]
Alignment=0
AutoPinning=true
CurrentWorkspaceOnly=false
DockItems=[]
HideDelay=0
HideMode=2
IconSize=48
IndicatorSize=8
ItemsAlignment=0
LockItems=false
Monitor=0
Offset=0
Position=1
PressureReveal=false
ShowDockItem=false
Theme=Transparent
TooltipsEnabled=true
UnhideDelay=0
ZoomEnabled=true
ZoomPercent=150
EOF

# Create launchers for common apps
create_launcher() {
    local name="$1"
    local exec="$2"
    local icon="$3"
    cat > "$chroot_dir$user_home/.config/plank/dock1/launchers/$name.dockitem" << EOF
[PlankItemsDockItemPreferences]
Launcher=file://$user_home/.local/share/applications/$name.desktop
EOF
}

# Ensure applications directory exists
chroot "$chroot_dir" mkdir -p "$user_home/.local/share/applications"

# Create desktop entries for dock
cat > "$chroot_dir$user_home/.local/share/applications/finder.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Finder
Comment=File Manager
Exec=thunar
Icon=folder
Terminal=false
Categories=System;FileManager;
StartupNotify=true
EOF

cat > "$chroot_dir$user_home/.local/share/applications/terminal.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Command Line
Exec=xfce4-terminal
Icon=utilities-terminal
Terminal=false
Categories=System;TerminalEmulator;
StartupNotify=true
EOF

cat > "$chroot_dir$user_home/.local/share/applications/browser.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Browser
Comment=Web Browser
Exec=firefox
Icon=firefox
Terminal=false
Categories=Network;WebBrowser;
StartupNotify=true
EOF

cat > "$chroot_dir$user_home/.local/share/applications/settings.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Settings
Comment=System Settings
Exec=xfce4-settings-manager
Icon=preferences-system
Terminal=false
Categories=Settings;System;
StartupNotify=true
EOF

cat > "$chroot_dir$user_home/.local/share/applications/appstore.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Software
Comment=Install Applications
Exec=software-center
Icon=org.gnome.Software
Terminal=false
Categories=System;PackageManager;
StartupNotify=true
EOF

# Configure Rofi (Spotlight-like launcher)
chroot "$chroot_dir" mkdir -p "$user_home/.config/rofi"

cat > "$chroot_dir$user_home/.config/rofi/config.rasi" << 'EOF'
configuration {
    modi: "drun,run,window,ssh";
    show-icons: true;
    icon-theme: "WhiteSur-dark";
    font: "SF Pro Display 12";
    theme: "macos";
    width: 60;
    lines: 10;
    columns: 1;
    fixed-num-lines: true;
    sidebar-mode: false;
    terminal: "xfce4-terminal";
    ssh-client: "ssh";
    drun-display-format: "{name}";
    window-format: "{w}  {t}";
}

@theme "macos"
EOF

# Create macOS-like Rofi theme
cat > "$chroot_dir$user_home/.config/rofi/macos.rasi" << 'EOF'
* {
    background-color: #1e1e1eE6;
    text-color: #ffffff;
    border-color: #007AFF;
    selected-bg: #007AFF;
    selected-fg: #ffffff;
    font: "SF Pro Display 12";
}

window {
    border: 2px;
    border-radius: 12px;
    padding: 20px;
    location: center;
    anchor: center;
    fullscreen: false;
    width: 600px;
}

mainbox {
    children: [inputbar, listview];
}

inputbar {
    children: [prompt, entry];
    padding: 10px;
    border-radius: 8px;
    background-color: #2d2d2d;
}

prompt {
    text-color: #888888;
    padding: 0 10px;
}

entry {
    placeholder: "Search applications, files, settings...";
    text-color: #ffffff;
    background-color: transparent;
}

listview {
    lines: 8;
    columns: 1;
    fixed-height: true;
    scrollbar: false;
    dynamic: true;
}

element {
    padding: 12px 16px;
    border-radius: 8px;
}

element selected {
    background-color: #007AFF;
    text-color: #ffffff;
}

element-icon {
    size: 24px;
    padding: 0 12px 0 0;
}

element-text {
    vertical-align: 0.5;
}
EOF

# Set ownership
chroot "$chroot_dir" chown -R "$target_user:$target_user" "$user_home/.config" "$user_home/.local"

echo "Dock and launcher configuration complete"