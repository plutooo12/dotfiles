#!/bin/bash
# Wallpaper picker using yad
PICTURES_DIR="$HOME/pictures"
WALLPAPER_FILE="$HOME/.config/current-wallpaper"

SELECTED=$(yad --file-selection \
    --title="Pick Wallpaper" \
    --filename="$PICTURES_DIR/" \
    --file-filter="Images|*.png *.jpg *.jpeg *.webp" \
    --width=800 --height=500 \
    2>/dev/null)

if [ -n "$SELECTED" ]; then
    echo "$SELECTED" > "$WALLPAPER_FILE"
    pkill swaybg
    swaybg -i "$SELECTED" -m stretch &
    notify-send "Wallpaper" "Changed successfully!" -t 2000
fi
