# prompt
PROMPT='%B%F{#8aadf4}%n%f%b%B%F{#cad3f5}@%f%b%B%F{#c6a0f6}%m%f%b %F{#a6da95}%~%f %# '

# history
mkdir -p ~/.local/state/zsh ~/.cache/zsh
HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# ctrl+left/right
bindkey ';5D' backward-word
bindkey ';5C' forward-word

# completion
autoload -Uz compinit
compinit -d "$HOME/.cache/zsh/zcompdump"

# nvm, julia
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
[ -f "$HOME/.julia/juliaup/completions/zsh.zsh" ] && . "$HOME/.julia/juliaup/completions/zsh.zsh"

# private stuff, not in git
[ -f "$ZDOTDIR/local.zsh" ] && . "$ZDOTDIR/local.zsh"

# has to be last
[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
