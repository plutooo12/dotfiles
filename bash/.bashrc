#
# ~/.bashrc — plutooo12
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qqdt) 2>/dev/null && sudo paccache -rk2'
alias dotfiles='cd ~/dotfiles'
alias scripts='cd ~/scripts'
alias cfg='cd ~/.config'

# Better history
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups

# Starship prompt
eval "$(starship init bash)"

# Fastfetch on terminal open
fastfetch

