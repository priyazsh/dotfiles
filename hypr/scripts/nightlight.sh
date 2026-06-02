#!/bin/bash

STATE_FILE="/tmp/hyprsunset-temp"

# Default temperature
if [ ! -f "$STATE_FILE" ]; then
  echo 6500 >"$STATE_FILE"
fi

TEMP=$(cat "$STATE_FILE")

case "$1" in
up)
  TEMP=$((TEMP - 500))
  ;;
down)
  TEMP=$((TEMP + 500))
  ;;
esac

# Clamp values
if [ "$TEMP" -lt 2500 ]; then
  TEMP=2500
fi

if [ "$TEMP" -gt 6500 ]; then
  TEMP=6500
fi

echo "$TEMP" >"$STATE_FILE"

hyprctl hyprsunset temperature "$TEMP"

swayosd-client --custom-message "  Night Light: ${TEMP}K"
