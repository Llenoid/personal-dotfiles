# ~/.config/zsh/conf.d/20-completions.zsh

# 1. Standardize cache path in XDG_CACHE_HOME
local zcompdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
local zcompdump="$zcompdump_dir/zcompdump-${ZSH_VERSION}"
local zcompdump_zwc="$zcompdump.zwc"

[[ -d "$zcompdump_dir" ]] || mkdir -p "$zcompdump_dir"

# Ensure custom completions are in fpath before compinit
fpath=("$ZDOTDIR/completions" $fpath)

autoload -Uz compinit

# 2. Fast Path: Use bytecode dump if compiled image exists and is newer than text dump
if [[ -f "$zcompdump_zwc" && "$zcompdump" -nt "$zcompdump_zwc" ]]; then
  # Re-compile stale bytecode asynchronously
  zcompile -R "$zcompdump_zwc" "$zcompdump" 2>/dev/null
fi

if [[ -s "$zcompdump" ]]; then
  # -C bypasses compaudit AND prevents implicit compdump writes
  compinit -C -d "$zcompdump"
else
  # Cold boot execution (runs only when dump does not exist)
  compinit -i -d "$zcompdump"
  zcompile -R "$zcompdump_zwc" "$zcompdump"
fi

# 3. Asynchronous background cache refresh (24h threshold)
# Eliminates synchronously blocking interactive shells on cache rebuilds
if [[ -n "$zcompdump"(#qN.m+1) ]]; then
  (
    autoload -Uz compinit
    compinit -i -d "$zcompdump"
    zcompile -R "$zcompdump.zwc" "$zcompdump"
  ) &!
fi

zmodload zsh/complist

# 4. Completion Engine Options
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose true
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{blue}== %d ==%f'

_comp_options+=(globdots)
