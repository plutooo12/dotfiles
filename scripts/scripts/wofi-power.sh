#!/bin/bash
chosen=$(printf "󰐥 Shutdown\n󰜉 Restart\n󰒲 Sleep\n󰍃 Logout" | wofi --dmenu --prompt "Power" --width 200 --height 180 --lines 4)

case "$chosen" in
    "󰐥 Shutdown") systemctl poweroff ;;
    "󰜉 Restart")  systemctl reboot ;;
    "󰒲 Sleep")    systemctl suspend ;;
    "󰍃 Logout")   hyprctl dispatch exit ;;
esac
