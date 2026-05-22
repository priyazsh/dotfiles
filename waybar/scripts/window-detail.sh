#!/usr/bin/env sh

desktop() {
  jq -nc \
    --arg text "󰖯  Desktop" \
    --arg tooltip "No active window" \
    '{text: $text, tooltip: $tooltip, class: "empty"}'
}

if ! command -v hyprctl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  desktop
  exit 0
fi

window_json="$(hyprctl activewindow -j 2>/dev/null)"

if [ -z "$window_json" ] || [ "$window_json" = "{}" ] || ! printf '%s' "$window_json" | jq empty >/dev/null 2>&1; then
  desktop
  exit 0
fi

class="$(printf '%s' "$window_json" | jq -r '.class // .initialClass // ""')"
title="$(printf '%s' "$window_json" | jq -r '.title // .initialTitle // ""')"
workspace="$(printf '%s' "$window_json" | jq -r '.workspace.name // (.workspace.id | tostring) // "unknown"')"
floating="$(printf '%s' "$window_json" | jq -r 'if .floating then "Floating" else "Tiled" end')"
fullscreen="$(printf '%s' "$window_json" | jq -r 'if (.fullscreen == true or .fullscreen == 1) then "Fullscreen" else "Windowed" end')"
pid="$(printf '%s' "$window_json" | jq -r '.pid // "unknown"')"
address="$(printf '%s' "$window_json" | jq -r '.address // "unknown"')"

app="$class"
icon="󰣆"

case "$(printf '%s' "$class" | tr '[:upper:]' '[:lower:]')" in
  *firefox*) icon=""; app="Firefox" ;;
  *code*|*codium*) icon="󰨞"; app="Code" ;;
  *obsidian*) icon="󰹕"; app="Obsidian" ;;
  *spotify*) icon=""; app="Spotify" ;;
  *kitty*) icon="󰆍"; app="Kitty" ;;
  *thunar*|*nautilus*|*yazi*) icon=""; app="Files" ;;
  *discord*) icon=""; app="Discord" ;;
  *vlc*|*mpv*) icon="󰕼"; app="Player" ;;
esac

[ -n "$app" ] || app="Window"
[ -n "$title" ] || title="$app"

short_title="$title"
if [ "${#short_title}" -gt 54 ]; then
  short_title="$(printf '%.51s...' "$short_title")"
fi

jq -nc \
  --arg text "$icon  $app  •  $short_title" \
  --arg tooltip "App: $app
Class: $class
Title: $title
Workspace: $workspace
Mode: $floating / $fullscreen
PID: $pid
Address: $address" \
  '{text: $text, tooltip: $tooltip, class: "active"}'
