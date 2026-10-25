#!/usr/bin/env bash

# Check if the internal display is currently on/accessible via DPMS
# wlopm output matches the names eDP-1 and DP-2
if wlopm | grep -q "eDP-1 off"; then
  # If they are off, wake them both up safely
  wlopm --on eDP-1
  wlopm --on DP-2
else
  # If they are on, send them to sleep/standby mode
  wlopm --off eDP-1
  wlopm --off DP-2
fi
