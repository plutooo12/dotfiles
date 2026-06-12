# dotfiles 🏠

My personal Arch Linux setup — Intel i5 13th Gen + RTX 4050 + Hyprland

---

## ⚡ One command install (on a fresh Arch install)

```bash
git clone https://github.com/plutooo12/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && bash install.sh
```

That's it. The script handles everything below automatically.

---

## 📋 What's inside

| Folder | What it contains |
|--------|-----------------|
| `config/hypr/` | Hyprland config (Lua) + hypridle + hyprlock |
| `config/kitty/` | Kitty terminal + Catppuccin Mocha theme |
| `config/btop/` | Btop resource monitor + Catppuccin theme |
| `config/wofi/` | Wofi launcher styling |
| `config/gtk-3.0/` | GTK3 theme settings |
| `config/gtk-4.0/` | GTK4 theme + CSS |
| `config/starship.toml` | Starship shell prompt |
| `home/` | .bashrc, .bash_profile, .bash_logout |
| `local-bin/` | Custom scripts (system-panel.sh) |
| `wallpapers/` | Wallpaper collection |
| `packages/native.txt` | All official repo packages |
| `packages/aur.txt` | All AUR packages |

---

## 🔧 Manual setup (step by step)

### 1. Install base tools

```bash
sudo pacman -S --needed git base-devel
```

### 2. Install paru (AUR helper)

```bash
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
cd /tmp/paru && makepkg -si --noconfirm
cd ~ && rm -rf /tmp/paru
```

### 3. Install NVIDIA drivers (RTX 4050)

```bash
sudo pacman -S --needed \
  nvidia-dkms nvidia-utils lib32-nvidia-utils \
  nvidia-settings nvtop linux-headers
```

### 4. Install Intel iGPU drivers (hybrid graphics)

```bash
sudo pacman -S --needed \
  intel-media-driver libva-intel-driver \
  intel-gpu-tools mesa lib32-mesa
```

### 5. Configure NVIDIA for Hyprland

**Edit mkinitcpio:**
```bash
sudo nano /etc/mkinitcpio.conf
```
Find the `MODULES=()` line and change it to:
```
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```
Also find `HOOKS=` and **remove** the word `kms` from it.

Then rebuild:
```bash
sudo mkinitcpio -P
```

**Edit GRUB:**
```bash
sudo nano /etc/default/grub
```
Find `GRUB_CMDLINE_LINUX_DEFAULT` and add `nvidia_drm.modeset=1 nvidia_drm.fbdev=1` inside the quotes. Example:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 nvidia_drm.modeset=1 nvidia_drm.fbdev=1"
```
Then apply it:
```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 6. Install Hyprland + Wayland stack

```bash
sudo pacman -S --needed \
  hyprland xdg-desktop-portal-hyprland \
  wayland wayland-protocols xwayland \
  pipewire wireplumber pipewire-pulse pipewire-alsa \
  waybar wofi dunst \
  kitty \
  swww hyprlock hypridle \
  grim slurp \
  wl-clipboard cliphist \
  brightnessctl playerctl \
  network-manager-applet blueman \
  polkit-gnome \
  sddm
```

### 7. Install fonts

```bash
sudo pacman -S --needed \
  ttf-jetbrains-mono-nerd \
  ttf-nerd-fonts-symbols \
  noto-fonts noto-fonts-emoji noto-fonts-cjk
```

### 8. Install your saved packages

```bash
# Official packages
sudo pacman -S --needed - < ~/.dotfiles/packages/native.txt

# AUR packages
paru -S --needed - < ~/.dotfiles/packages/aur.txt
```

### 9. Link the configs

```bash
bash ~/.dotfiles/link.sh
```

This creates symlinks so your configs are active.

### 10. Enable services

```bash
sudo systemctl enable sddm          # Display manager (login screen)
sudo systemctl enable bluetooth     # Bluetooth
sudo systemctl enable NetworkManager
```

### 11. Reboot

```bash
sudo reboot
```

Log in → Hyprland should start automatically.

---

## 🚀 Performance tweaks (already applied by install.sh)

| Tweak | What it does |
|-------|-------------|
| `zram` | Compressed RAM swap — prevents freezing when RAM gets full |
| `vm.swappiness=10` | Keeps things in RAM longer, snappier feel |
| `ParallelDownloads=10` | Pacman downloads 10 packages at once |
| `makepkg -j$(nproc)` | AUR packages build using all CPU cores |
| `fstrim.timer` | Weekly SSD health maintenance |
| `nvidia_drm.modeset=1` | Required for Hyprland + NVIDIA to work |
| `NVreg_PreserveVideoMemoryAllocations=1` | Fixes black screen after sleep/wake |

---

## 🖥️ Hardware

- **CPU** — Intel Core i5 13th Gen
- **GPU** — NVIDIA RTX 4050 (hybrid with Intel iGPU)
- **WM** — Hyprland (Wayland)
- **Terminal** — Kitty
- **Shell** — Bash + Starship prompt
- **Theme** — Catppuccin Mocha

---

## 🆘 If something breaks

**Hyprland won't start:**
```bash
journalctl -b -u sddm     # check display manager logs
Hyprland                  # try starting manually from TTY
```

**NVIDIA not detected:**
```bash
nvidia-smi                # should show your GPU
dmesg | grep -i nvidia    # check for errors
```

**Black screen after sleep:**
```bash
# Make sure these are enabled:
sudo systemctl enable nvidia-suspend nvidia-resume nvidia-hibernate
```

**Wrong configs / want to relink:**
```bash
bash ~/.dotfiles/link.sh
```

---

## 🔄 Updating dotfiles

Run this any time you want to save your current configs back to the repo:

```bash
bash ~/.dotfiles/collect.sh plutooo12 dotfiles
cd ~/.dotfiles && git push origin main
```
