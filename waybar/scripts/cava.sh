#!/usr/bin/env sh

baseline="▁▁▁▁▁▁▁▁"

runtime_dir="${XDG_RUNTIME_DIR:-/tmp}"
[ -d "$runtime_dir" ] && [ -w "$runtime_dir" ] || runtime_dir="/tmp"

config_file="$runtime_dir/waybar-cava.conf"
fifo_file="$runtime_dir/waybar-cava.fifo"
lock_file="$runtime_dir/waybar-cava.lock"

cava_pid=""

cleanup() {
  [ -n "$cava_pid" ] && kill "$cava_pid" 2>/dev/null || true
  [ -p "$fifo_file" ] && rm -f "$fifo_file"
}

trap cleanup EXIT INT TERM HUP

exec 9>"$lock_file"

if ! flock -n 9; then
  exit 0
fi

emit() {
  jq -nc \
    --arg text "$1" \
    --arg class "$2" \
    '{
      text: $text,
      tooltip: "CAVA audio visualizer",
      class: $class
    }'
}

if ! command -v cava >/dev/null 2>&1 || \
   ! command -v jq >/dev/null 2>&1; then
  emit "$baseline" "silent"
  exit 0
fi

if command -v playerctl >/dev/null 2>&1; then
  status="$(playerctl status 2>/dev/null || true)"

  if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
    emit "$baseline" "silent"
    exit 0
  fi
fi

if ! cat > "$config_file" <<EOF
[general]
framerate = 30
bars = 8
autosens = 1
sensitivity = 120
sleep_timer = 2

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 0
EOF
then
  emit "$baseline" "silent"
  exit 0
fi

emit "$baseline" "silent"

pkill -u "$(id -u)" -f "cava -p $config_file" 2>/dev/null || true
rm -f "$fifo_file"

if ! mkfifo "$fifo_file"; then
  emit "$baseline" "silent"
  exit 0
fi

cava -p "$config_file" > "$fifo_file" 2>/dev/null &
cava_pid="$!"

while IFS= read -r frame; do
  bars="$(printf '%s' "$frame" | sed \
    's/0/▁/g;
     s/1/▂/g;
     s/2/▃/g;
     s/3/▄/g;
     s/4/▅/g;
     s/5/▆/g;
     s/6/▇/g;
     s/7/█/g')"

  if [ -z "$bars" ]; then
    emit "$baseline" "silent"
  else
    emit "$bars" "updated"
  fi
done < "$fifo_file"

emit "$baseline" "silent"
