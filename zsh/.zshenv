# ~/.config/zsh/.zshenv

# 1. Enforce unique entries globally (preserves first occurrence)
typeset -gU path PATH

# 2. XDG Base Directory Specification (with fallback safety)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# 3. Toolchain XDG Overrides
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export BUN_INSTALL="$XDG_DATA_HOME/bun"
export PUB_CACHE="$XDG_DATA_HOME/pub-cache"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
export GOPATH="$XDG_DATA_HOME/go"
export GOBIN="$HOME/.local/bin"

# 4. GnuPG XDG Guard (Ensures strict 0700 permissions required by gpg)
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
[[ -d "$GNUPGHOME" ]] || mkdir -m 0700 -p "$GNUPGHOME"

# 5. Zsh History Location
export HISTFILE="$XDG_STATE_HOME/zsh/history"

# 6. Runtime & Environment
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export MANPAGER="nvim +Man!"
export BAT_THEME="tokyonight_night"
export XDG_CURRENT_DESKTOP="niri:GNOME"
export QT_QPA_PLATFORM="wayland"

# 7. Python / uv XDG Overrides
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export UV_CACHE_DIR="$XDG_CACHE_HOME/uv"
export UV_PYTHON_INSTALL_DIR="$XDG_DATA_HOME/uv/python"
export UV_TOOL_DIR="$XDG_DATA_HOME/uv/tools"
export UV_TOOL_BIN_DIR="$HOME/.local/bin"

# 8. Core Editors
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="$EDITOR"

path=(${path:#$HOME/.cargo/bin})

path=(
  $XDG_DATA_HOME/nvim/mason/bin
  $HOME/.local/bin
  $CARGO_HOME/bin
  $NPM_CONFIG_PREFIX/bin
  $BUN_INSTALL/bin
  $PUB_CACHE/bin
  $XDG_DATA_HOME/opencode/bin
  $HOME/.local/opt/kitty.app/bin
  $JAVA_HOME/bin
  /usr/local/go/bin
  /usr/local/bin
  /usr/bin
  /bin
  $path
)
