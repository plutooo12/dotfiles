#!/bin/bash
WALLPAPER_FILE="$HOME/.config/current-wallpaper"
DEFAULT="$HOME/pictures/car-1.png"

if [ -n "$1" ]; then
    echo "$1" > "$WALLPAPER_FILE"
    pkill swaybg 2>/dev/null
    swaybg -i "$1" -m stretch &
else
    LAST=$(cat "$WALLPAPER_FILE" 2>/dev/null)
    if [ -z "$LAST" ] || [ ! -f "$LAST" ]; then
        LAST="$DEFAULT"
    fi
    pkill swaybg 2>/dev/null
    swaybg -i "$LAST" -m stretch &
fi
