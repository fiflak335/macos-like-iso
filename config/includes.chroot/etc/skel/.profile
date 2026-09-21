# ~/.profile: executed by the command interpreter for login shells.

# Set PATH
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Set default editor
export EDITOR="geany"
export VISUAL="geany"

# Set GTK theme
export GTK_THEME=WhiteSur-Dark

# Qt theme
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=kvantum

# Fix for Qt apps in Wayland
export QT_QPA_PLATFORM=xcb

# Default browser
export BROWSER=firefox

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Start XFCE if on tty1
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startxfce4
fi