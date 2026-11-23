#!/usr/bin/env bash

FILE="$HOME/.dotfiles/quickshell/.config/quickshell/services/Wallpaper.qml"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <wallpaper-path>"
  exit 1
fi

if [[ ! -f "$FILE" ]]; then
  echo "Error: Wallpaper.qml not found: $FILE"
  exit 1
fi

REPLACEMENT="$HOME/.dotfiles/wallpapers/$1"

sed -i -E \
  "s|/home/[^/]*/\.dotfiles/wallpapers/[^\"']*|$REPLACEMENT|g" \
  "$FILE"

echo "Wallpaper paths updated to: $REPLACEMENT"
