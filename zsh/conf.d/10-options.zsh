# ~/.config/zsh/conf.d/options.zsh

# Shell Behavior
setopt autocd              # Change directory by typing name
setopt extendedglob        # Enable pattern matching operators (#, ~, ^)
setopt nomatch             # Error if glob doesn't match
setopt interactive_comments # Allow # comments in interactive shell
unsetopt BEEP              # Disable audio/visual bell

# History Configuration (XDG Compliant)
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000000              # Keep 10 million lines in memory
SAVEHIST=10000000              # Save 10 million lines to disk

# History Options
setopt SHARE_HISTORY        # Synchronize history across sessions (subsumes INC_APPEND_HISTORY)
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE    # Do not record commands starting with space
