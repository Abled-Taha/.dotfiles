notify-send -r 9910 -a "System" -i "battery" "Current Battery" "$(fastfetch | grep Battery | sed 's/^[[:space:]]*//')"
