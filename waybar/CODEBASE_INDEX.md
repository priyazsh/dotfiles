# Codebase index

Generated: 2026-05-20

This repository contains Waybar configuration files and styling tokens.

## Top-level files

- [config.jsonc](config.jsonc) — main Waybar configuration (JSONC)
- [README.md](README.md) — repository README
- [style.css](style.css) — global stylesheet for widgets and layout

## modules/

Per-module configuration JSONC files used by Waybar:

- [modules/audio.jsonc](modules/audio.jsonc)
- [modules/battery.jsonc](modules/battery.jsonc)
- [modules/clock.jsonc](modules/clock.jsonc)
- [modules/connections.jsonc](modules/connections.jsonc)
- [modules/distro.jsonc](modules/distro.jsonc)
- [modules/groups.jsonc](modules/groups.jsonc)
- [modules/idle-ihibitor.jsonc](modules/idle-ihibitor.jsonc)
- [modules/power-profiles-daemon.jsonc](modules/power-profiles-daemon.jsonc)
- [modules/storage.jsonc](modules/storage.jsonc)
- [modules/system.jsonc](modules/system.jsonc)
- [modules/tray-notif.jsonc](modules/tray-notif.jsonc)
- [modules/workspace.jsonc](modules/workspace.jsonc)

## tokens/

CSS token files and widgets styles used across the bar:

- [tokens/batt-clock.css](tokens/batt-clock.css)
- [tokens/colors.css](tokens/colors.css)
- [tokens/slider.css](tokens/slider.css)
- [tokens/state.css](tokens/state.css)
- [tokens/widget.css](tokens/widget.css)
- [tokens/workspace.css](tokens/workspace.css)

## Notes

- To update this index, run a manual scan or ask the maintainer to regenerate it.
- These files are Waybar configuration fragments and styles — editing them requires reloading Waybar.
