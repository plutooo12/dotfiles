#!/usr/bin/env bash
# ── system-panel.sh ────────────────────────────────────────────────

# ── Time & Date ───────────────────────────────────────────────────
TIME=$(date +"%I:%M %p")
DATE=$(date +"%A, %B %d %Y")

# ── Battery ───────────────────────────────────────────────────────
BAT_PATH=$(ls /sys/class/power_supply/ 2>/dev/null | grep -iE "^BAT" | head -1)
if [ -n "$BAT_PATH" ]; then
    BAT_CAP=$(cat /sys/class/power_supply/$BAT_PATH/capacity 2>/dev/null || echo "?")
    BAT_STATUS=$(cat /sys/class/power_supply/$BAT_PATH/status 2>/dev/null || echo "?")
    case $BAT_STATUS in
        Charging)    BAT_ICON="󰂄" ;;
        Full)        BAT_ICON="󰁹" ;;
        *)           BAT_ICON="󰁹" ;;
    esac
    BAT_LINE="$BAT_ICON  Battery      ${BAT_CAP}%  ($BAT_STATUS)"
else
    BAT_LINE="󰂑  Battery      Not found"
fi

# ── Brightness ────────────────────────────────────────────────────
BL_DEV=""
BL_MAX_FOUND=0
for dev_path in /sys/class/backlight/*/; do
    [ -d "$dev_path" ] || continue
    max=$(cat "${dev_path}max_brightness" 2>/dev/null || echo 0)
    if [ "$max" -gt "$BL_MAX_FOUND" ]; then
        BL_MAX_FOUND=$max
        BL_DEV=$(basename "$dev_path")
    fi
done

if [ -n "$BL_DEV" ] && [ "$BL_MAX_FOUND" -gt 0 ]; then
    BL_CUR=$(cat /sys/class/power_supply/intel_backlight/brightness 2>/dev/null || cat /sys/class/backlight/$BL_DEV/brightness 2>/dev/null || echo 0)
    BRIGHT_PCT=$(( BL_CUR * 100 / BL_MAX_FOUND ))
    BRIGHT_LINE="󰃠  Brightness   ${BRIGHT_PCT}%"
else
    BRIGHT_LINE="󰃠  Brightness   ?%"
fi

# ── Volume ────────────────────────────────────────────────────────
VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume 0.00")
VOL=$(echo "$VOL_RAW" | awk '{printf "%d", $2 * 100}')
MUTED=$(echo "$VOL_RAW" | grep -c "MUTED" || echo 0)
[ "$MUTED" -gt 0 ] && VOL_ICON="󰝟 (muted)" || VOL_ICON="󰕾"
VOL_LINE="$VOL_ICON  Volume       ${VOL}%"

# ── Network ───────────────────────────────────────────────────────
# Query NetworkManager for the primary active connection type and name
ACTIVE_CONN=$(nmcli -t -f TYPE,NAME connection show --active | grep -E "802-11-wireless|802-3-ethernet" | head -n1)

if [[ "$ACTIVE_CONN" == *"802-11-wireless"* ]]; then
    # Extract Wi-Fi SSID
    WIFI_SSID=$(echo "$ACTIVE_CONN" | cut -d: -f2)
    NET_LINE="󰖩  WiFi         $WIFI_SSID"
elif [[ "$ACTIVE_CONN" == *"802-3-ethernet"* ]]; then
    # Ethernet is plugged in and active
    NET_LINE="󰈀  Ethernet     Connected"
else
    # No active network interfaces found
    NET_LINE="󰖪  Network      Disconnected"
fi

# ── Build wofi menu ───────────────────────────────────────────────
MENU=$(printf '%s\n' \
    "  $TIME" \
    "  $DATE" \
    "───────────────────────────────────────────────" \
    "$BAT_LINE" \
    "$BRIGHT_LINE" \
    "$VOL_LINE" \
    "$NET_LINE" \
    "───────────────────────────────────────────────" \
    "󰖩  WiFi Manager"
)

CHOICE=$(echo "$MENU" | wofi \
    --dmenu \
    --prompt "  System Status" \
    --width 620 \
    --height 380 \
    --cache-file /dev/null \
    --no-actions \
    --insensitive \
    --define=line_wrap=word)

# ── Act on choice ─────────────────────────────────────────────────
case "$CHOICE" in
    *"WiFi Manager"*)
        kitty --class float-nmtui -e nmtui ;;
esac
