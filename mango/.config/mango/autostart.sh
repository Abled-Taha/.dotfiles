#!/usr/bin/env bash

# Start the wallpaper manager
swaybg -i ~/.dotfiles/wallpapers/1.jpg >/dev/null 2>&1 &

# Update DBus and Systemd environments
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

# Start background authentication and mounting daemons
gnome-keyring-daemon --start --components=secrets,ssh,pkcs11 &
udiskie &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Themes
QT_QPA_PLATFORM=wayland copyq --start-server &
