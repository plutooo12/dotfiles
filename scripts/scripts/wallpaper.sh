#!/bin/bash
WALLPAPER_FILE="$HOME/.config/current-wallpaper"

if [ -n "$1" ]; then
    echo "$1" > "$WALLPAPER_FILE"
    pkill swaybg
    swaybg -i "$1" -m stretch &
else
    LAST=$(cat "$WALLPAPER_FILE" 2>/dev/null || echo "/home/plutoo12/pictures/car-1.png")
    swaybg -i "$LAST" -m stretch &
fi
