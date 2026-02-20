#!/bin/bash

DIR="$HOME/Pictures/Screenshot"
FILE="$DIR/ss_$(date +%Y-%m-%d_%H-%M-%S).png"

case "$1" in
  select)
    grim -g "$(slurp)" - | tee "$FILE" | wl-copy
    ;;
  full)
    grim - | tee "$FILE" | wl-copy
    ;;
  active)
    GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    grim -g "$GEOM" - | tee "$FILE" | wl-copy
    ;;
esac

notify-send "Screenshot saved" "$FILE"
