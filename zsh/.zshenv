export ZDOTDIR="$HOME/.config/zsh"

typeset -U path
path=("$HOME/.local/bin" "$HOME/.juliaup/bin" $path)
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
export ANDROID_HOME="$HOME/Android/Sdk"
path+=("$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools")
