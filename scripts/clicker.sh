#!/usr/bin/env bash
if pkill -f "ydotool click"; then
    echo "Stopped"
else
    echo "Started"
    while true; do
        ydotool click --repeat 5 --next-delay 1 0xC0
    done
fi
