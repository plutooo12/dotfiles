# Package Lists

| File | Contents |
|------|----------|
| `native.txt` | Explicit official-repo packages (`pacman -Qqen`) |
| `aur.txt` | AUR / foreign packages (`pacman -Qqem`) |

## Restore on a fresh install

```bash
# Native packages
sudo pacman -S --needed - < native.txt

# AUR (with paru)
paru -S --needed - < aur.txt
```
