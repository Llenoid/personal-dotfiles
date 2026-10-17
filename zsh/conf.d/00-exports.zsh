# Tool Environment  
export GOPATH="$HOME/Documents/go"
export CHROME_LOGIN_HELPER=gnome-keyring-daemon
export IGNOREEOF=2

# External Tool Evals  
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Rust Cargo (Safe sourcing)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
