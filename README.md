# dotfiles

Hyprland on Debian.

## Install

```bash
sudo apt install stow
git clone <repo> ~/dotfiles
cd ~/dotfiles
stow */
```

## Theme

```bash
theme              # list themes
theme autumn       # switch colors and wallpaper everywhere
theme menu         # pick one with rofi, also on Super+Shift+T
```

A theme is a palette in `theme/.config/theme/palettes/`. Copy one to make your own.

## Not in git

- `~/.config/git/local` for name and email
- `~/.config/zsh/local.zsh` for keys
- todos in `~/.local/share/todo/`
- wallpapers in `theme/.config/theme/wallpapers/`, named like the theme (`autumn.jpg`). Without one, `wallpaper.example.png` is used.
