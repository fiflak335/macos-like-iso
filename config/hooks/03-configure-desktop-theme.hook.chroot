#!/bin/bash
set -euo pipefail

# Hook: 03-configure-desktop-theme.sh
# Configure GTK, XFCE, and desktop theme settings

chroot_dir="${1:-/}"
target_user="macuser"
user_home="/home/$target_user"

echo "Configuring desktop theme..."

# GTK 3 settings
chroot "$chroot_dir" mkdir -p "$user_home/.config/gtk-3.0"
cat > "$chroot_dir$user_home/.config/gtk-3.0/settings.ini" << 'EOF'
[Settings]
gtk-theme-name = WhiteSur-Dark
gtk-icon-theme-name = WhiteSur-dark
gtk-font-name = SF Pro Display 11
gtk-cursor-theme-name = WhiteSur-cursors
gtk-cursor-theme-size = 24
gtk-toolbar-style = GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size = GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images = 1
gtk-menu-images = 1
gtk-enable-event-sounds = 1
gtk-enable-input-feedback-sounds = 1
gtk-xft-antialias = 1
gtk-xft-hinting = 1
gtk-xft-hintstyle = hintslight
gtk-xft-rgba = rgb
gtk-application-prefer-dark-theme = 1
gtk-decoration-layout = close,minimize,maximize:
EOF

# GTK 4 settings
chroot "$chroot_dir" mkdir -p "$user_home/.config/gtk-4.0"
cat > "$chroot_dir$user_home/.config/gtk-4.0/settings.ini" << 'EOF'
[Settings]
gtk-theme-name = WhiteSur-Dark
gtk-icon-theme-name = WhiteSur-dark
gtk-font-name = SF Pro Display 11
gtk-cursor-theme-name = WhiteSur-cursors
gtk-cursor-theme-size = 24
gtk-decoration-layout = close,minimize,maximize:
EOF

# XFCE settings
chroot "$chroot_dir" mkdir -p "$user_home/.config/xfce4/xfconf/xfce-perchannel-xml"

# XFCE appearance
cat > "$chroot_dir$user_home/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="WhiteSur-Dark"/>
    <property name="IconThemeName" type="string" value="WhiteSur-dark"/>
    <property name="CursorThemeName" type="string" value="WhiteSur-cursors"/>
    <property name="CursorThemeSize" type="int" value="24"/>
    <property name="FontName" type="string" value="SF Pro Display 11"/>
    <property name="MonospaceFontName" type="string" value="SF Mono 11"/>
    <property name="SoundThemeName" type="string" value="freedesktop"/>
    <property name="EnableEventSounds" type="bool" value="true"/>
    <property name="EnableInputFeedbackSounds" type="bool" value="true"/>
    <property name="DoubleClickTime" type="int" value="250"/>
    <property name="DoubleClickDistance" type="int" value="5"/>
  </property>
  <property name="Xft" type="empty">
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
    <property name="DPI" type="int" value="96"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="ButtonImages" type="bool" value="true"/>
    <property name="MenuImages" type="bool" value="true"/>
    <property name="ToolbarStyle" type="int" value="3"/>
    <property name="ToolbarIconSize" type="int" value="3"/>
    <property name="DecorationLayout" type="string" value="close,minimize,maximize:"/>
    <property name="ApplicationPreferDarkTheme" type="bool" value="true"/>
  </property>
</channel>
EOF

# XFCE window manager (window buttons on left like macOS)
cat > "$chroot_dir$user_home/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="WhiteSur-Dark"/>
    <property name="button_layout" type="string" value="CMH|"/>
    <property name="title_font" type="string" value="SF Pro Display Bold 11"/>
    <property name="title_alignment" type="string" value="center"/>
    <property name="title_shadow_active" type="bool" value="false"/>
    <property name="title_shadow_inactive" type="bool" value="false"/>
    <property name="click_to_focus" type="bool" value="true"/>
    <property name="focus_new" type="bool" value="true"/>
    <property name="raise_on_click" type="bool" value="true"/>
    <property name="raise_on_focus" type="bool" value="false"/>
    <property name="activate_action" type="string" value="maximize"/>
    <property name="borderless_maximize" type="bool" value="true"/>
    <property name="full_width_title" type="bool" value="true"/>
    <property name="workspace_count" type="int" value="4"/>
    <property name="wrap_workspaces" type="bool" value="true"/>
    <property name="wrap_windows" type="bool" value="true"/>
    <property name="zoom_desktop" type="bool" value="true"/>
    <property name="show_dock_shadow" type="bool" value="true"/>
  </property>
</channel>
EOF

# XFCE panel - make it look like a top bar
cat > "$chroot_dir$user_home/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="empty">
    <property name="panel-1" type="empty">
      <property name="size" type="uint" value="28"/>
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="background-style" type="uint" value="1"/>
      <property name="background-color" type="empty">
        <property name="red" type="uint" value="65535"/>
        <property name="green" type="uint" value="65535"/>
        <property name="blue" type="uint" value="65535"/>
        <property name="alpha" type="uint" value="60000"/>
      </property>
      <property name="enter-opacity" type="uint" value="99"/>
      <property name="leave-opacity" type="uint" value="99"/>
      <property name="autohide-behavior" type="uint" value="0"/>
      <property name="length-adjust" type="bool" value="true"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="empty">
      <property name="type" type="string" value="whiskermenu"/>
      <property name="name" type="string" value="Applications Menu"/>
      <property name="command" type="string" value="rofi -show drun"/>
    </property>
    <property name="plugin-2" type="empty">
      <property name="type" type="string" value="separator"/>
      <property name="expand" type="bool" value="false"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-3" type="empty">
      <property name="type" type="string" value="tasklist"/>
      <property name="show-only-minimized" type="bool" value="false"/>
      <property name="show-handle" type="bool" value="false"/>
      <property name="show-labels" type="bool" value="false"/>
      <property name="flat-buttons" type="bool" value="true"/>
      <property name="sort-order" type="uint" value="3"/>
    </property>
    <property name="plugin-4" type="empty">
      <property name="type" type="string" value="separator"/>
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="1"/>
    </property>
    <property name="plugin-5" type="empty">
      <property name="type" type="string" value="systray"/>
      <property name="names-visible" type="array"/>
      <property name="square-icons" type="bool" value="true"/>
      <property name="icon-size" type="uint" value="18"/>
    </property>
    <property name="plugin-6" type="empty">
      <property name="type" type="string" value="clock"/>
      <property name="format" type="string" value="%a %b %d, %H:%M"/>
      <property name="mode" type="uint" value="0"/>
      <property name="tooltip-format" type="string" value="%A, %B %d, %Y"/>
    </property>
  </property>
</channel>
EOF

# Thunar file manager settings
chroot "$chroot_dir" mkdir -p "$user_home/.config/Thunar"
cat > "$chroot_dir$user_home/.config/Thunar/thunarrc" << 'EOF'
[Configuration]
DefaultView=ThunarDetailsView
ShowHidden=false
ShowThumbnails=always
SingleClick=false
TreeViewExpandSingle=false
LastCompactViewZoomLevel=THUNAR_ZOOM_LEVEL_100_PERCENT
LastDetailsViewZoomLevel=THUNAR_ZOOM_LEVEL_100_PERCENT
LastDetailsViewColumnWidths=50,150,100,100,100,100
LastDetailsViewFixedColumns=false
LastDetailsViewColumnOrder=THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_DATE_ACCESSED,THUNAR_COLUMN_OWNER,THUNAR_COLUMN_GROUP,THUNAR_COLUMN_PERMISSIONS,THUNAR_COLUMN_MIME_TYPE
LastLocationBar=ThunarLocationEntry
LastShowHidden=false
LastWindowWidth=1000
LastWindowHeight=700
LastWindowMaximized=false
LastSplitView=false
LastSeparatorPosition=180
ShortcutsViewZoomLevel=THUNAR_ZOOM_LEVEL_100_PERCENT
TreeViewZoomLevel=THUNAR_ZOOM_LEVEL_100_PERCENT
RemovableDrivesAreHotkeys=false
AutoMountRemovable=true
AutoOpenRemovable=true
AutoRunRemovable=false
DeleteToTrash=true
FullPathInTitle=true
ShowMenuBar=true
ShowToolbar=true
ShowStatusbar=true
StatusbarVisible=true
SidebarWidth=180
MiscSingleClickTimeout=500
MiscDragThreshold=5
MiscFileSizeFormat=THUNAR_FILE_SIZE_FORMAT_ABBREVIATED
MiscDateStyle=THUNAR_DATE_STYLE_SIMPLE
MiscTimeStyle=THUNAR_TIME_STYLE_SIMPLE
MiscShowThumbnails=TRUE
MiscThumbnailSize=64
MiscTextBesideIcons=FALSE
MiscRememberGeometry=true
MiscRememberOpenTabs=false
MiscFullPathInTitle=TRUE
MiscCaseSensitive=FALSE
MiscFoldersFirst=TRUE
EOF

# Configure picom compositor for macOS-like effects
chroot "$chroot_dir" mkdir -p "$user_home/.config/picom"
cat > "$chroot_dir$user_home/.config/picom/picom.conf" << 'EOF'
backend = "glx";
vsync = true;

shadow = true;
shadow-radius = 12;
shadow-offset-x = 0;
shadow-offset-y = 4;
shadow-opacity = 0.3;
shadow-exclude = [
    "class_g = 'Plank'",
    "class_g = 'Rofi'",
    "_GTK_FRAME_EXTENTS@:c",
    "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'",
];

fade = true;
fade-delta = 4;
fade-in-step = 0.03;
fade-out-step = 0.03;

blur-background = true;
blur-background-frame = true;
blur-background-fixed = false;
blur-method = "dual_kawase";
blur-strength = 5;

corner-radius = 8;
rounded-corners-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'",
];

inactive-opacity = 0.95;
active-opacity = 1.0;
frame-opacity = 1.0;
inactive-opacity-override = false;

detect-rounded-corners = true;
detect-client-opacity = true;

mark-wmwin-focused = true;
mark-ovredir-focused = true;

use-ewmh-active-win = true;
detect-transient = true;
detect-client-leader = true;

glx-no-stencil = true;
glx-copy-from-front = false;
glx-use-copysubbuffermesa = true;
glx-no-rebind-pixmap = true;
glx-swap-method = "undefined";

xrender-sync-fence = true;

wintypes:
{
    tooltip = { fade = true; shadow = true; opacity = 0.9; focus = true; };
    menu = { shadow = true; };
    dropdown_menu = { shadow = true; };
    popup_menu = { shadow = true; };
    tooltip = { shadow = true; };
    notification = { shadow = true; };
    dock = { shadow = false; };
    desktop = { shadow = false; };
};
EOF

# Configure dunst notifications
chroot "$chroot_dir" mkdir -p "$user_home/.config/dunst"
cat > "$chroot_dir$user_home/.config/dunst/dunstrc" << 'EOF'
[global]
    monitor = 0
    follow = keyboard
    geometry = "350x5-20+50"
    indicate_hidden = yes
    shrink = no
    transparency = 10
    separator_height = 2
    padding = 12
    horizontal_padding = 12
    frame_width = 1
    frame_color = "#007AFF"
    separator_color = frame
    sort = yes
    idle_threshold = 120
    font = SF Pro Display 11
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    icon_position = left
    min_icon_size = 32
    max_icon_size = 64
    icon_path = /usr/share/icons/WhiteSur-dark:/usr/share/icons/hicolor
    sticky_history = yes
    history_length = 20
    browser = /usr/bin/firefox
    always_run_script = true
    title = Dunst
    class = Dunst
    startup_notification = false
    dmenu = /usr/bin/rofi -dmenu -p dunst:
    dmenu_max_lines = 10

[frame]
    width = 2
    color = "#007AFF"

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period

[urgency_low]
    background = "#1e1e1e"
    foreground = "#ffffff"
    timeout = 5

[urgency_normal]
    background = "#1e1e1e"
    foreground = "#ffffff"
    timeout = 10

[urgency_critical]
    background = "#1e1e1e"
    foreground = "#ff3b30"
    frame_color = "#ff3b30"
    timeout = 0

[script]
    script_path = /usr/local/bin/dunst-notify.sh
EOF

# Set ownership
chroot "$chroot_dir" chown -R "$target_user:$target_user" "$user_home/.config"

echo "Desktop theme configuration complete"