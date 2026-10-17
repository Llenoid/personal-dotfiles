# ~/.config/zsh/.zshrc
if [[ -n "$ZSH_BENCHMARK" ]]; then
  zmodload zsh/zprof
fi

# 1. P10k Instant Prompt (MUST remain at the absolute top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Ensure ZDOTDIR fallback
: "${ZDOTDIR:=$HOME/.config/zsh}"

# 3. Sequential Module Sourcing (00 through 60)
if [[ -d "$ZDOTDIR/conf.d" ]]; then
  for config_file in "$ZDOTDIR/conf.d"/*.zsh(N-.); do
    source "$config_file"
  done
  unset config_file
fi

# 4. Conditional Startup Profiling
# Run `ZSH_BENCHMARK=1 zsh -i -c exit` to view latency breakdown
if [[ -n "$ZSH_BENCHMARK" ]]; then
  zprof
fi

# kilo
export PATH=/home/brandon/.kilo/bin:$PATH

# opencode
export PATH=/home/brandon/.opencode/bin:$PATH
