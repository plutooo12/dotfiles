PHASE 1 — Install Arch Linux

1. Boot Arch ISO from USB

2. Connect internet:

bashiwctl
station wlan0 connect "YourWiFiName"
exit

3. Run archinstall:
basharchinstall
Choose exactly:

Language: English
Mirror: Worldwide
Drive: your NVMe
Filesystem: ext4
Bootloader: GRUB
Hostname: archlinux
Root password: set one
User: plutoo12 with password
Profile: minimal
Audio: pipewire
Network: NetworkManager
Timezone: Asia/Kathmandu
No desktop environment

4. Reboot into terminal

PHASE 2 — NVIDIA Drivers

5. Enable multilib:
bashsudo nano /etc/pacman.conf

Uncomment:
[multilib]
Include = /etc/pacman.d/mirrorlist

6. Update and install headers first:
bashsudo pacman -Sy
sudo pacman -S linux-headers

7. Install NVIDIA:
bashsudo pacman -S nvidia-open-dkms nvidia-utils lib32-nvidia-utils libva-nvidia-driver libva-utils

8. Configure GRUB:
bashsudo nano /etc/default/grub
Change to:
GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia_drm.modeset=1"
GRUB_TIMEOUT=0
GRUB_TIMEOUT_STYLE=hidden

9. Configure mkinitcpio:
bashsudo nano /etc/mkinitcpio.conf
Find HOOKS and remove kms:
HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)
Leave MODULES empty:
MODULES=()

10. Rebuild:
bashsudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg

11. Set system environment:
bashsudo nano /etc/environment
Add:
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
WLR_NO_HARDWARE_CURSORS=1
MOZ_ENABLE_WAYLAND=1
MOZ_WEBRENDER=1
ELECTRON_OZONE_PLATFORM_HINT=auto
XDG_SESSION_TYPE=wayland

12. Reboot and verify:
bashreboot
nvidia-smi

PHASE 3 — Install All Software

13. Install yay:
bashsudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd .. && rm -rf yay

14. Install all packages:
bashsudo pacman -S hyprland uwsm sddm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk qt5-wayland qt6-wayland polkit-gnome waybar wofi swaync hypridle hyprlock kitty starship stow git wget nano btop fastfetch swaybg pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pamixer playerctl brightnessctl bluez bluez-utils networkmanager intel-media-driver intel-ucode sof-firmware gst-plugin-pipewire wpa_supplicant btrfs-progs efibootmgr linux-firmware linux-headers zram-generator yazi signal-desktop thunar imv

15. Install AUR packages:
bashyay -S firefox-bin prismlauncher-git

16. Enable services:
bashsudo systemctl enable sddm
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth

17. Disable unnecessary services:
bashsudo systemctl disable wpa_supplicant
sudo systemctl mask wpa_supplicant
sudo systemctl disable systemd-tpm2-setup
sudo systemctl disable systemd-tpm2-setup-early
sudo systemctl disable systemd-pcrproduct
sudo systemctl disable systemd-pcrmachine
sudo systemctl disable systemd-pcrphase
sudo systemctl disable systemd-rfkill

PHASE 4 — Restore Your Dotfiles

18. Clone your dotfiles:
bashgit clone git@github.com:plutooo12/dotfiles.git ~/dotfiles
Or if SSH not set up yet:
bashgit clone https://github.com/plutooo12/dotfiles.git ~/dotfiles

19. Apply with stow:
bashcd ~/dotfiles
stow hyprland waybar kitty wofi starship scripts

20. Create scripts folder:
bashmkdir -p ~/scripts
Stow creates symlinks automatically.

21. Create pictures folder and add wallpaper:
bashmkdir -p ~/pictures
Copy your wallpaper back from backup or download a new one.

PHASE 5 — Final Setup

22. Set up SSH for GitHub:
sudo pacman -S openssh
# Replace the email with your GitHub email
ssh-keygen -t ed25519 -C "your-email@example.com"
# Copy the output of this command to GitHub
cat ~/.ssh/id_ed25519.pub

23. Configure SDDM:
bashsudo mkdir -p /etc/sddm.conf.d
sudo nano /etc/sddm.conf.d/virtualkbd.conf
Add:
[General]
InputMethod=

24. Setup zram:
bashsudo nano /etc/systemd/zram-generator.conf
Add:
[zram0]
zram-size = ram / 2
compression-algorithm = zstd

25. Final reboot:
bashreboot

After reboot checklist:
bashnvidia-smi                    # NVIDIA working?
vainfo                        # Hardware decoding working?
systemctl --failed            # Any failed services?
systemd-analyze               # Boot time?
hyprctl monitors              # Display correct?
