# 🌙 dotfiles

> Arch Linux + Hyprland daily driver — clean, fast, NVIDIA optimized

![preview](preview.png)

## 🖥️ Setup
| Component | Tool |
|-----------|------|
| OS | Arch Linux |
| WM | Hyprland |
| Bar | Waybar |
| Terminal | Kitty |
| Prompt | Starship |
| Launcher | Wofi |
| Notifications | Swaync |
| File Manager | Yazi |
| Theme | Catppuccin Mocha |

## ⚡ Hardware
- CPU: Intel i5-13500H
- GPU: NVIDIA RTX 4050 Laptop Max-Q
- RAM: 16GB
- Display: 1920x1200 @ 144Hz

## 📦 Install
```bash
# Install dependencies
sudo pacman -S stow git

# Clone
git clone https://github.com/YOURUSERNAME/dotfiles ~/dotfiles
cd ~/dotfiles

# Apply configs
stow hyprland waybar kitty wofi starship scripts
```

## ⌨️ Key Bindings
| Key | Action |
|-----|--------|
| SUPER + Return | Terminal (Kitty) |
| SUPER + B | Browser |
| SUPER + E | File Manager (Yazi) |
| SUPER + Space | Launcher (Wofi) |
| SUPER + W | Close window |
| SUPER + F | Float toggle |
| SUPER + Tab | Cycle windows |
| SUPER + SHIFT + L | Lock screen |
| SUPER + SHIFT + E | Exit |
| SUPER + 1-9 | Switch workspace |
| SUPER + SHIFT + 1-9 | Move to workspace |
| SUPER + minus | Scratchpad |
| SUPER + H/J/K/L | Vim focus movement |
| SUPER + CTRL + arrows | Resize window |

## 📝 Notes
- Optimized for NVIDIA Optimus laptops
- VAAPI hardware video decoding enabled
- Catppuccin Mocha color scheme throughout
- Smart gaps — no gaps when single window
