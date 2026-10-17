# ~/.config/zsh/conf.d/60-plugins.zsh

# 1. Zsh Autosuggestions
if [[ -f "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# 2. Fast Syntax Highlighting (Must load AFTER autosuggestions to wrap ZLE widgets properly)
if [[ -f "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
  source "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fi

# 3. Powerlevel10k Configuration & Theme (Config MUST be loaded BEFORE theme)
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"

if [[ -f "$ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme"
fi
