# Node.js (fnm)
# Define the internal loader logic
function _load_fnm() {
  unfunction fnm node npm npx gemini 2>/dev/null
  
  # Initialize the env logic
  eval "$(fnm env --use-on-cd --shell zsh)"

  # Automatically activate the default node version
  # We redirect output to /dev/null to keep your terminal start clean
  fnm use default >/dev/null 2>&1

  rehash
}

# Create the "Stubs" for every command you use
function fnm()  { _load_fnm; command fnm "$@" }
function node() { _load_fnm; command node "$@" }
function npm()  { _load_fnm; command npm "$@" }
function npx()  { _load_fnm; command npx "$@" }
function gemini() { _load_fnm; command gemini "$@" }

# Python (pyenv)
# Python Suite
# function _load_pyenv() {
#   unfunction pyenv python pip python3
#   eval "$(command pyenv init - zsh)"
#   [[ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]] && eval "$(pyenv virtualenv-init -)"
# }
# function pyenv()   { _load_pyenv; pyenv "$@" }
# function python()  { _load_pyenv; python "$@" }
# function python3() { _load_pyenv; python3 "$@" }
# function pip()     { _load_pyenv; pip "$@" }

# Python (Conda)
function conda() {
  unfunction conda
  # Check common Fedora paths for conda.sh
  if [[ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
  elif [[ -f "/opt/anaconda/etc/profile.d/conda.sh" ]]; then
    source "/opt/anaconda/etc/profile.d/conda.sh"
  fi
  conda "$@"
}

# Flutter/Dart Suite
# function _load_flutter() {
#   unfunction flutter dart
#   # if (( $+commands[flutter] )); then
#   #   source <(flutter bash-completion)
#   # fi
# }
# function flutter() { _load_flutter; command flutter "$@" }
# function dart()    { _load_flutter; command dart "$@" }

# --- ZLE Widgets ---

# A better 'z' that lets you pick a directory via fzf and insert it into your current command
function zoxide_fzf() {
    local selection
    # Use 'zoxide query --list' to get your history, pipe to fzf
    selection=$(zoxide query --list | fzf --height 40% --reverse --border)
    
    # If a selection was made, append it to the current cursor position
    if [[ -n "$selection" ]]; then
        LBUFFER+="${(q)selection}" # (q) escapes spaces if the path has them
    fi
    
    zle reset-prompt
}

# Register the function as a ZLE widget
zle -N zoxide_fzf


function mkcd() {
	mkdir -p -- "$1" &&
		cd -P -- "$1"
}

function add-alias() {
  local alias_file="$HOME/.config/zsh/conf.d/aliases.zsh"

  # Prompt for alias name
  vared -p "Alias name: " -c alias_name

  # Prompt for command
  vared -p "Command for '$alias_name': " -c alias_cmd

  # Append to aliases file
  echo "alias $alias_name='$alias_cmd'" >> "$alias_file"

  echo "✅ Added: alias $alias_name='$alias_cmd' to $alias_file"

  # Reload aliases immediately
  source "$alias_file"
}

function colors() {
  color_vars=$(~/.config/kitty/colors $1)
  # Eval ensures that proper env variables are loaded in real time
  eval ${color_vars}
}

function gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}

_gitignoreio_get_command_list() {
  curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi

# --- Docker Utilities ---

# Find a docker image by name (replaces dkIf)
# Usage: dkf my-app
function dkf() {
    docker images -f "reference=*/*/$1*" -f "reference=*$1*"
}

# Clean up exited containers and dangling images
function dkclean() {
    echo "Removing exited containers..."
    docker rm $(docker ps -qaf status=exited) 2>/dev/null
    echo "Removing dangling images..."
    docker rmi $(docker images -qf dangling=true) 2>/dev/null
    echo "Removing dangling volumes..."
    docker volume rm $(docker volume ls -qf dangling=true) 2>/dev/null
}

# --- System Utilities ---

# FZF Man pages (replaces fman)
function fman() {
    compgen -c | fzf --prompt="Man > " | xargs man
}

# Update all Zsh plugins manually
function zsh-update-plugins() {
    find "$ZDOTDIR/plugins" -type d -name ".git" | while read repo; do
        echo "Updating $(dirname $repo)..."
        git -C "$(dirname $repo)" pull -q
    done
}

function zcompile_all() {
  local file

  # A. Cleanup orphaned .zwc files 
  # If a .zwc exists but its source .zsh is gone, delete it.
  for file in "$ZDOTDIR"/**/*.zwc(N) "$ZDOTDIR"/.z*.zwc(N); do
    [[ ! -f "${file%.zwc}" ]] && rm -f "$file"
  done

  # B. Core Configs
  for file in "$ZDOTDIR"/.zsh{rc,env}(N); do
    [[ "$file" -nt "$file.zwc" ]] && zcompile "$file"
  done

  # C. Modular Configs (conf.d)
  for file in "$ZDOTDIR"/conf.d/*.zsh(N); do
    [[ "$file" -nt "$file.zwc" ]] && zcompile "$file"
  done

  # D. Plugins
  for file in "$ZDOTDIR"/plugins/**/*.zsh(N); do
    [[ "$file" -nt "$file.zwc" ]] && zcompile "$file"
  done

  # E. Custom Completions
  for file in "$ZDOTDIR"/completions/_*(N); do
    [[ "$file" -nt "$file.zwc" ]] && zcompile "$file"
  done
  
  # echo "✅ Zsh compilation complete & orphaned binaries cleaned."
}

function make() {
  # If we see a node project but fnm hasn't loaded yet, load it!
  if [[ -f "package.json" ]] && (( $+functions[_load_fnm] )); then
    _load_fnm
  fi
  command make "$@"
}

# function gpu_monitor() {
#   watch -n 1 "
#     echo '--- Monitoring RX 580 (card1) ---';
#     echo -n 'Core Clock:    ';
#     cat /sys/class/drm/card1/device/pp_dpm_sclk 2>/dev/null | grep '*' | awk '{print \$2}';
#     echo -n 'Memory Clock: ';
#     cat /sys/class/drm/card1/device/pp_dpm_mclk 2>/dev/null | grep '*' | awk '{print \$2}';
#     echo -n 'Power Draw:    ';
#     cat /sys/class/drm/card1/device/hwmon/hwmon*/power1_input 2>/dev/null | awk '{print \$1/1000000 \" W\"}'
#   "
# }

function gpustat() {
  watch -n 1 "
    echo '--- Monitoring RX 580 (card1) ---';
    echo -n 'GPU Load:      '; [ -f /sys/class/drm/card1/device/gpu_busy_percent ] && cat /sys/class/drm/card1/device/gpu_busy_percent | awk '{print \$1 \"%\"}';
    echo -n 'Core Clock:    '; cat /sys/class/drm/card1/device/pp_dpm_sclk 2>/dev/null | grep '*' | awk '{print \$2}';
    echo -n 'Memory Clock:  '; cat /sys/class/drm/card1/device/pp_dpm_mclk 2>/dev/null | grep '*' | awk '{print \$2}';
    echo -n 'Temperature:   '; cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null | awk '{print \$1/1000 \"°C\"}';
    echo -n 'Power Draw:    '; cat /sys/class/drm/card1/device/hwmon/hwmon*/power1_input 2>/dev/null | awk '{print \$1/1000000 \" W\"}'
  "
}

# 1. THE PARSER: This handles the logic. 
# We define it separately so we don't have to deal with "quote soup".
# _mide_generator() {
#   local query="$1"
#   local prompt="$2"
#   local opts=()
#
#   # Determine if we are in "All" mode
#   if [[ "$prompt" =~ "All" ]]; then
#     opts=(--no-ignore --hidden)
#   fi
#
#   if [[ "$query" == /* ]]; then
#     # FILE MODE: List all files and let fzf fuzzy-find the stripped query
#     # We strip the / using ${query#/}
#     fd --type f --color=always "${opts[@]}" --exclude .git --exclude node_modules --exclude __pycache__ .
#   else
#     # GREP MODE: Search content
#     # If query is empty, just list files so the window isn't blank
#     if [[ -z "$query" ]]; then
#       fd --type f --color=always "${opts[@]}" --exclude .git --exclude node_modules --exclude __pycache__ .
#     else
#       rg --column --line-number --no-heading --color=always --smart-case "${opts[@]}" -- "$query" || true
#     fi
#   fi
# }
#
# # This is critical for Fedora/Zsh: fzf needs to see the function
# export -f _mide_generator 2>/dev/null || alias _mide_generator=_mide_generator

# 2. THE PICKER: The UI layer
function _fzf_mide_picker() {
  fzf --ansi --query "$1" \
    --prompt "Search > " \
    --header "ENTER: Edit | CTRL-V: View | CTRL-Y: Copy | CTRL-R: RM | CTRL-H: All | ?: Toggle | /: Find" \
    --expect=ctrl-r,ctrl-v,ctrl-y \
    --bind "start:reload(fzf-mide-gen '' 'Search > ')" \
    --bind "change:reload(fzf-mide-gen {q} \"\$FZF_PROMPT\")" \
    --bind "ctrl-h:transform: [[ \$FZF_PROMPT =~ 'All' ]] && \
          echo 'change-prompt(Search > )+reload(fzf-mide-gen {q} \"Search > \")' || \
          echo 'change-prompt(All > )+reload(fzf-mide-gen {q} \"All > \")'" \
    --bind "?:toggle-preview" \
    --preview "
        [[ -z {1} ]] && exit
        file=\$(echo {1} | cut -d: -f1)
        line=\$(echo {1} | cut -d: -f2)
        bat --color=always --style=numbers --highlight-line \"\$line\" \"\$file\" 2>/dev/null || bat --color=always --style=numbers \"\$file\"" \
    --preview-window 'right:60%:border-left'
}

# 3. THE MAIN FUNCTION: The Action layer
function f() {
  local selection=$(_fzf_mide_picker "$1")
  local key=$(echo "$selection" | sed -n '1p')
  local val=$(echo "$selection" | sed -n '2p')

  [[ -z "$val" ]] && return

  local file=$(echo "$val" | cut -d: -f1)
  local line=$(echo "$val" | cut -d: -f2)

  case "$key" in
    ctrl-y) echo -n "$file" | wl-copy && echo "📋 Copied: $file" ;;
    ctrl-r) rm -i "$file" ;;
    ctrl-v) [[ "$line" =~ ^[0-9]+$ ]] && bat --highlight-line "$line" "$file" || bat "$file" ;;
    *)      [[ "$line" =~ ^[0-9]+$ ]] && nvim +"$line" "$file" || nvim "$file" ;;
  esac
}

# function f() {
#   # 1. Define the search logic as a standalone string to avoid quote nesting issues
#   local search_cmd='
#     q={q}
#     if [[ "$q" == /* ]]; then
#       fd --type f --hidden --exclude .git --color=always "${q#/}"
#     else
#       rg --column --line-number --no-heading --color=always --smart-case -- "$q" || true
#     fi'
#
#   # 2. Define the preview logic
#   local preview_cmd='
#     q={q}
#     file=$(echo {1} | cut -d: -f1)
#     line=$(echo {1} | cut -d: -f2)
#     if [[ "$q" == /* ]]; then
#       bat --color=always --style=numbers "$file"
#     else
#       bat --color=always --style=numbers --highlight-line "$line" "$file" 2>/dev/null || bat --color=always --style=numbers "$file"
#     fi'
#
#   local selection=$(fzf --ansi --disabled --query "$1" \
#     --bind "start:reload(rg --column --line-number --no-heading --color=always --smart-case -- '')" \
#     --bind "change:reload:zsh -c '$search_cmd'" \
#     --preview "zsh -c '$preview_cmd'" \
#     --header "Type to GREP | Type / to FIND FILES" \
#     --preview-window 'right:60%:border-left')
#
#   # 3. Handle the selection and open in nvim
#   if [[ -n "$selection" ]]; then
#     local file=$(echo "$selection" | cut -d: -f1)
#     local line=$(echo "$selection" | cut -d: -f2)
#     
#     # If there is a line number (grep mode), jump to it in nvim
#     if [[ "$line" =~ ^[0-9]+$ ]]; then
#       nvim +"$line" "$file"
#     else
#       nvim "$file"
#     fi
#   fi
# }

# function f() {
#   local selection
#   
#   # 1. Add 'ctrl-y' to the expected keys
#   selection=$(_fzf_picker_logic "$1" --expect=ctrl-r,ctrl-v,ctrl-y)
#
#   local key=$(echo "$selection" | sed -n '1p')
#   local full_val=$(echo "$selection" | sed -n '2p')
#   
#   [[ -z "$full_val" ]] && return
#
#   local file=$(echo "$full_val" | cut -d: -f1)
#   local line=$(echo "$full_val" | cut -d: -f2)
#
#   case "$key" in
#     ctrl-y)
#       # Copy the filename to Wayland clipboard
#       echo -n "$file" | wl-copy
#       echo "📋 Copied: $file"
#       ;;
#     ctrl-r) 
#       rm -i "$file" 
#       ;;
#     ctrl-v) 
#       if [[ "$line" =~ ^[0-9]+$ ]]; then
#         bat --highlight-line "$line" "$file"
#       else
#         bat "$file"
#       fi
#       ;;
#     *)
#       if [[ "$line" =~ ^[0-9]+$ ]]; then
#          nvim +"$line" "$file"
#       else
#          nvim "$file"
#       fi
#       ;;
#   esac
# }

# function f() {
#   local selection
#   
#   # Call the picker logic and expect specific keys
#   selection=$(_fzf_picker_logic "$1" --expect=ctrl-r,ctrl-v,ctrl-y)
#
#   # fzf --expect outputs the key on the first line and the value on the second
#   local key=$(echo "$selection" | sed -n '1p')
#   local full_val=$(echo "$selection" | sed -n '2p')
#   
#   [[ -z "$full_val" ]] && return
#
#   # Parse file and line (works for both rg: file:line:col:text and fd: file)
#   local file=$(echo "$full_val" | cut -d: -f1)
#   local line=$(echo "$full_val" | cut -d: -f2)
#
#   case "$key" in
#     ctrl-y)
#       echo -n "$file" | wl-copy
#       echo "📋 Copied to clipboard: $file"
#       ;;
#     ctrl-r) 
#       # Using -i for safety as requested
#       rm -i "$file" 
#       ;;
#     ctrl-v) 
#       if [[ "$line" =~ ^[0-9]+$ ]]; then
#         bat --highlight-line "$line" "$file"
#       else
#         bat "$file"
#       fi
#       ;;
#     *)
#       # Default: Open in Neovim
#       if [[ "$line" =~ ^[0-9]+$ ]]; then
#          nvim +"$line" "$file"
#       else
#          nvim "$file"
#       fi
#       ;;
#   esac
# }

# function _fzf_picker_logic() {
#   # State tracking (Search vs All)
#   local search_mode="Search"
#   local INITIAL_QUERY="${*:-}"
#
#   # Define the dynamic command generator
#   # {q} is the current fzf query string
#   # +h triggers the 'All' mode by removing ignore flags
#   local cmd_logic='
#     if [[ "{q}" =~ ^/ ]]; then
#       # File Mode (fd)
#       query=$(echo "{q}" | sed "s|^/||")
#       if [[ "$FZF_PROMPT" == "All > " ]]; then
#         fd --hidden --no-ignore --type f --color=always "$query"
#       else
#         fd --type f --color=always "$query"
#       fi
#     else
#       # Grep Mode (rg)
#       if [[ "$FZF_PROMPT" == "All > " ]]; then
#         rg --column --line-number --no-heading --color=always --smart-case --hidden --no-ignore "{q}" || true
#       else
#         rg --column --line-number --no-heading --color=always --smart-case "{q}" || true
#       fi
#     fi'
#
#   fzf --ansi --disabled --query "$INITIAL_QUERY" \
#     --prompt "Search > " \
#     --header "C-h: Toggle All | ?: Preview | Enter: Nvim | C-v: Bat | C-y: Copy | C-r: Rm" \
#     --bind "start:reload($cmd_logic)" \
#     --bind "change:reload($cmd_logic)" \
#     --bind "ctrl-h:transform: [[ \$FZF_PROMPT == 'Search > ' ]] && echo 'change-prompt(All > )+reload($cmd_logic)' || echo 'change-prompt(Search > )+reload($cmd_logic)'" \
#     --bind "?:toggle-preview" \
#     --preview '
#       file=$(echo {} | cut -d: -f1)
#       line=$(echo {} | cut -d: -f2)
#       if [[ -f "$file" ]]; then
#         if [[ "$line" =~ ^[0-9]+$ ]]; then
#           bat --style=numbers --color=always --highlight-line "$line" "$file"
#         else
#           bat --style=numbers --color=always "$file"
#         fi
#       fi' \
#     --preview-window 'right:60%:hidden' \
#     "$@"
# }

# This helper does the heavy lifting without quote nesting issues
# _mide_generator() {
#     local query="$1"
#     local prompt="$2"
#     local opts=()
#
#     # Determine if we are in "All" mode
#     if [[ "$prompt" == "All > " ]]; then
#         opts=(--no-ignore --hidden)
#     fi
#
#     if [[ "$query" == /* ]]; then
#         # File Mode: Strip the / and run fd
#         fd --type f --color=always "${opts[@]}" --exclude .git --exclude node_modules --exclude __pycache__ "${query#/}"
#     else
#         # Grep Mode: Run rg
#         rg --column --line-number --no-heading --color=always --smart-case "${opts[@]}" --glob "!.git/*" -- "$query" || true
#     fi
# }

# if [[ -n "$ZSH_VERSION" ]]; then
#   autoload -Uz _mide_generator
# fi

# function _fzf_picker_logic() {
#     fzf --ansi --query "$1" "${@[2,-1]}" \
#         --prompt "Search > " \
#         --header "ENTER: Edit | CTRL-V: View | CTRL-Y: Copy | CTRL-R: RM | CTRL-H: Toggle All | ?: Toggle | /: Find" \
#         --bind "start:reload(zsh -ic '_mide_generator {q} \"Search > \"')" \
#         --bind "change:top+reload(zsh -ic '_mide_generator {q} \"\$FZF_PROMPT\"')" \
#         --bind "ctrl-h:transform: [[ \$FZF_PROMPT =~ 'All >' ]] && \
#               echo 'change-prompt(Search > )+reload(zsh -ic \"_mide_generator {q} \\\"Search > \\\" \")' || \
#               echo 'change-prompt(All > )+reload(zsh -ic \"_mide_generator {q} \\\"All > \\\" \")'" \
#         --bind "?:toggle-preview" \
#         --preview "zsh -ic '_mide_generator_preview {1} {q}'" \
#         --preview-window 'right:60%:border-left'
# }

# function _fzf_picker_logic() {
#   fzf --ansi --query "$1" "${@[2,-1]}" \
#     --prompt "Search > " \
#     --header "ENTER: Edit | CTRL-V: View | CTRL-Y: Copy | CTRL-R: RM | CTRL-H: Toggle All | ?: Toggle | /: Find" \
#     --bind "start:reload(fzf-mide-gen {q} 'Search > ')" \
#     --bind "change:top+reload(fzf-mide-gen {q} \"\$FZF_PROMPT\")" \
#     --bind "ctrl-h:transform: [[ \$FZF_PROMPT =~ 'All >' ]] && \
#           echo 'change-prompt(Search > )+reload(fzf-mide-gen {q} \"Search > \")' || \
#           echo 'change-prompt(All > )+reload(fzf-mide-gen {q} \"All > \")'" \
#     --bind "?:toggle-preview" \
#     --preview "fzf-mide-gen {q} \"\$FZF_PROMPT\" | head -n 100" \
#     --preview-window 'right:60%:border-left'
# }

# function _fzf_picker_logic() {
#   fzf --ansi --query "$1" "${@[2,-1]}" \
#     --prompt "Search > " \
#     --header "ENTER: Edit | CTRL-V: View | CTRL-Y: Copy | CTRL-R: RM | CTRL-H: Toggle All | ?: Toggle | /: Find" \
#     --bind "start:reload(rg --column --line-number --no-heading --color=always --smart-case -- '')" \
#     --bind "ctrl-h:transform: [[ \$FZF_PROMPT =~ 'All >' ]] && \
#           echo 'change-prompt(Search > )+reload(rg --column --line-number --no-heading --color=always --smart-case -- {q} || true)' || \
#           echo 'change-prompt(All > )+reload(rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden -- {q} || true)'" \
#     --bind "change:top+reload:
#         q={q}
#         opts=''
#         [ \"\$FZF_PROMPT\" = \"All > \" ] && opts='--no-ignore --hidden'
#         if [ \"\${q%\"\${q#?}\"}\" = \"/\" ]; then
#            fd --type f --color=always \$opts --exclude .git --exclude node_modules --exclude __pycache__ \"\${q#/}\"
#         else
#            rg --column --line-number --no-heading --color=always --smart-case \$opts -- \"\$q\" || true
#         fi" \
#     --bind "?:toggle-preview" \
#     --preview "
#         [ -z {1} ] && exit
#         file=\$(echo {1} | cut -d: -f1)
#         line=\$(echo {1} | cut -d: -f2)
#         if [ \"\$FZF_PROMPT\" = \"All > \" ]; then
#            bat --color=always --style=numbers \"\$file\"
#         else
#            bat --color=always --style=numbers --highlight-line \"\$line\" \"\$file\" 2>/dev/null || bat --color=always --style=numbers \"\$file\"
#         fi" \
#     --preview-window 'right:60%:border-left'
# }

# function _fzf_picker_logic() {
#   # We use a temp env variable to track 'hidden' state within the fzf session
#   fzf --ansi --query "$1" "${@[2,-1]}" \
#     --bind "start:reload(rg --column --line-number --no-heading --color=always --smart-case -- '')" \
#     --bind "ctrl-h:transform: [[ \$FZF_PROMPT =~ 'All >' ]] && \
#           echo 'change-prompt(Search > )+reload(rg --column --line-number --no-heading --color=always --smart-case -- {q})' || \
#           echo 'change-prompt(All > )+reload(rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden -- {q})'" \
#     --bind "change:top+reload:zsh -c '
#         q={q}
#         # Check the prompt state to decide if we use ignore files
#         opts=\"\"
#         [[ \"\$FZF_PROMPT\" == \"All > \" ]] && opts=\"--no-ignore --hidden\"
#         
#         if [[ \"\$q\" == /* ]]; then 
#            fd --type f --color=always \$opts --exclude .git --exclude node_modules --exclude __pycache__
#         else 
#            rg --column --line-number --no-heading --color=always --smart-case \$opts \
#               --glob \"!.git/*\" -- \"\$q\" || true
#         fi'" \
#     --bind "?:toggle-preview" \
#     --preview "zsh -c '
#         if [[ -z \"{1}\" ]]; then exit; fi
#         q={q}
#         file=\$(echo {1} | cut -d: -f1)
#         line=\$(echo {1} | cut -d: -f2)
#         if [[ \"\$q\" == /* ]]; then
#           bat --color=always --style=numbers \"\$file\"
#         else
#           bat --color=always --style=numbers --highlight-line \"\$line\" \"\$file\" 2>/dev/null || bat --color=always --style=numbers \"\$file\"
#         fi'" \
#     --header "ENTER: Edit | CTRL-V: View | CTRL-Y: Copy | CTRL-H: Toggle All | ?: Toggle | /: Find" \
#     --preview-window 'right:60%:border-left' \
#     --prompt "Search > "
# }

# The Widget: Injects the selection into your current command line
function fzf-insert-selection() {
  local selection=$(_fzf_picker_logic "$LBUFFER")
  if [[ -n "$selection" ]]; then
    # Strip grep line numbers for simple commands like rm/cat
    local file=$(echo "$selection" | cut -d: -f1)
    LBUFFER+="$file"
  fi
  zle reset-prompt
}

# function _fzf_picker_logic() {
#   # Pass through the query ($1) and any extra flags like --expect ($@[2,-1])
#   fzf --ansi --disabled --query "$1" "${@[2,-1]}" \
#     --bind "start:reload(rg --column --line-number --no-heading --color=always --smart-case -- '')" \
#     --bind "change:reload:zsh -c 'q={q}; if [[ \"\$q\" == /* ]]; then fd --type f --hidden --exclude .git --color=always \"\${q#/}\"; else rg --column --line-number --no-heading --color=always --smart-case -- \"\$q\" || true; fi'" \
#     --preview "zsh -c 'q={q}; file=\$(echo {1} | cut -d: -f1); line=\$(echo {1} | cut -d: -f2); if [[ \"\$q\" == /* ]]; then bat --color=always --style=numbers \"\$file\"; else bat --color=always --style=numbers --highlight-line \"\$line\" \"\$file\" 2>/dev/null || bat --color=always --style=numbers \"\$file\"; fi'" \
#     --header "ENTER: Edit | CTRL-V: View | CTRL-Y: Copy Path | CTRL-R: Remove | /: Find Files" \
#     --preview-window 'right:60%:border-left'
# }


# The core logic: Just the search and preview
# function _fzf_picker_logic() {
#   fzf --ansi --disabled --query "$1" "${@[2,-1]}" \
#     --bind "start:reload(rg --column --line-number --no-heading --color=always --smart-case -- '')" \
#     --bind "change:reload:zsh -c 'q={q}; if [[ \"\$q\" == /* ]]; then fd --type f --hidden --exclude .git --color=always \"\${q#/}\"; else rg --column --line-number --no-heading --color=always --smart-case -- \"\$q\" || true; fi'" \
#     --preview "zsh -c 'q={q}; file=\$(echo {1} | cut -d: -f1); line=\$(echo {1} | cut -d: -f2); if [[ \"\$q\" == /* ]]; then bat --color=always --style=numbers \"\$file\"; else bat --color=always --style=numbers --highlight-line \"\$line\" \"\$file\" 2>/dev/null || bat --color=always --style=numbers \"\$file\"; fi'" \
#     --header "Type to GREP | Type / to FIND FILES" \
#     --preview-window 'right:60%:border-left'
# }

# The Widget: Injects the selection into your current command line
# function fzf-insert-selection() {
#   local selection=$(_fzf_picker_logic "$LBUFFER")
#   if [[ -n "$selection" ]]; then
#     # Strip grep line numbers for simple commands like rm/cat
#     local file=$(echo "$selection" | cut -d: -f1)
#     LBUFFER+="$file"
#   fi
#   zle reset-prompt
# }

zle -N fzf-insert-selection
bindkey '^f' fzf-insert-selection # Ctrl-F to trigger

# Initialize a new project for Gemini
function gemini-init() {
    mkdir -p .gemini-cli/plans
    chmod -R 755 .gemini-cli/plans
    echo "Project plan directory initialized at $(pwd)/.gemini-cli/plans"
}

function csvview() {
  if [ -t 0 ]; then
    # Case 1: No pipe, filename provided (e.g., csvview file.csv)
    local file=$1
    column -t -s ',' "$file" | bat -l cmd --style=grid,header --file-name "$file"
  else
    # Case 2: Data is being piped in (e.g., head -n 11 file.csv | csvview)
    # We use 'head -n 1' to peek at the first line if you want, 
    # but since we can't easily guess the filename from a stream, 
    # we can set a generic label or pass it as an optional arg.
    column -t -s ',' | bat -l cmd --style=grid,header --file-name "${1:-Piped Data Output}"
  fi
}
