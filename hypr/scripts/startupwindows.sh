#!/bin/bash

hyprctl dispatch workspace 1
sleep 0.5

# LEFT BIG (empty)
kitty --title priyazsh@archlinux >/dev/null 2>&1 &
sleep 0.3

# TOP RIGHT (fastfetch)
kitty --title fastfetch -e sh -c "fastfetch; exec $SHELL" >/dev/null 2>&1 &
sleep 0.3

# MID RIGHT (htop)
kitty --title htop -e sh -c "htop; exec $SHELL" >/dev/null 2>&1 &
sleep 0.3

# SMALL LEFT (figlet)
kitty --title @priyazsh -e sh -c "figlet @priyazsh; exec $SHELL" >/dev/null 2>&1 &
sleep 0.3

# SMALL RIGHT (cmatrix)
kitty --title baarish -e sh -c "cmatrix -u 10 -b -C green -s; exec $SHELL" >/dev/null 2>&1 &
