#!/bin/bash

INFO=$(hyprctl activewindow 2>/dev/null)

# get class and title
CLASS=$(echo "$INFO" | grep "class:" | awk '{print $2}')
TITLE=$(echo "$INFO" | sed -n 's/.*title: //p')

# ---------- CLEAN TITLES ----------

if [[ "$CLASS" == "firefox" ]]; then
    TITLE=$(echo "$TITLE" | sed -E 's/[[:space:]]+[-—][[:space:]]+.*Firefox.*$//')
fi

if [[ "$CLASS" == "Code" || "$CLASS" == "code" ]]; then
    TITLE=$(echo "$TITLE" | sed -E 's/[[:space:]]+-[[:space:]]+Visual Studio Code$//')
fi

if [[ "$CLASS" == jetbrains-* ]]; then
    TITLE=$(echo "$TITLE" | sed -E 's/[[:space:]]+-[[:space:]]+.*$//')
fi

if [[ "$CLASS" == "vlc" ]]; then
    TITLE=$(echo "$TITLE" | sed -E 's/[[:space:]]+-[[:space:]]+VLC media player$//')
fi

# ---------- TRIM TITLE ----------

MAX_LEN=40

if [ ${#TITLE} -gt $MAX_LEN ]; then
    TITLE="${TITLE:0:$MAX_LEN}..."
fi

# ---------- ICON + NAME ----------

case "$CLASS" in
    firefox) ICON="󰈹"; NAME="Firefox" ;;
    kitty) ICON=""; NAME="kitty" ;;
    Code|code) ICON="󰨞"; NAME="Code" ;;
    jetbrains-*) ICON=""; NAME="IntelliJ" ;;
    vlc) ICON="󰕼"; NAME="VLC" ;;
    *) ICON=""; NAME="$CLASS" ;;
esac

# ---------- OUTPUT ----------

if [[ -z "$TITLE" ]]; then
    echo ""
else
    echo "$ICON   $TITLE | $NAME"
fi
