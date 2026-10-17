# ~/.config/zsh/conf.d/30-keybindings.zsh

# Enable Vi mode
bindkey -v
export KEYTIMEOUT=1

# Standard terminal key fixes (Home, End, Delete, Backspace)
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^?" backward-delete-char

# Incremental search in Vi mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
# ~/.config/zsh/conf.d/keybindings.zsh

# Keymap mode
bindkey -e                  # Default to Emacs keybindings
zle_highlight=('paste:none') # Disable paste highlighting

# Shift-Tab reverse completion menu navigation
bindkey '^[[Z' reverse-menu-complete

# Disable Ctrl+D terminal exit
bindkey -r '^D'

# Bind Alt+Z to zoxide_fzf (safely check widget existence)
if zle -la | grep -q 'zoxide_fzf'; then
  bindkey '^[z' zoxide_fzf
fi
