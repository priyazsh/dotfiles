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
class_lc="$(printf '%s' "$class" | tr '[:upper:]' '[:lower:]')"

case "$class_lc" in
  *firefox*) icon=""; app="Firefox" ;;
  *helium*) icon="󰖟"; app="helium" ;;
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

display_title="$title"
source_name="$app"
is_browser=0

case "$class_lc" in
  *helium*|*firefox*|*chromium*|*chrome*)
    is_browser=1
    display_title="$(printf '%s' "$display_title" |
      sed -E 's/^[Hh]elium[[:space:]]*[•-][[:space:]]*//; s/[[:space:]]+-[[:space:]]*(Helium|Mozilla Firefox|Firefox|Chromium|Google Chrome)$//')"
    ;;
esac

[ -n "$display_title" ] || display_title="$title"

short_display="$display_title"
if [ "${#short_display}" -gt 42 ]; then
  short_display="$(printf '%.39s...' "$short_display")"
fi

if [ "${#source_name}" -gt 18 ]; then
  source_name="$(printf '%.15s...' "$source_name")"
fi

jq -nc \
  --arg text "$(if [ "$is_browser" -eq 1 ]; then printf '%s  %s' "$icon" "$short_display"; else printf '%s  %s | %s' "$icon" "$short_display" "$source_name"; fi)" \
  --arg tooltip "App: $app
Class: $class
Title: $title
Display: $(if [ "$is_browser" -eq 1 ]; then printf '%s' "$display_title"; else printf '%s | %s' "$display_title" "$source_name"; fi)
Workspace: $workspace
Mode: $floating / $fullscreen
PID: $pid
Address: $address" \
  '{text: $text, tooltip: $tooltip, class: "active"}'
