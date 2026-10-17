# Navigation & File Operations
alias ls='lsd --color=auto'
alias la='lsd -al --color=auto'
alias lsa='lsd -al --color=auto'
alias mk="mkdir -p"
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'
alias open='xdg-open'
alias wlc="wl-copy"

# Shell & Terminal
alias cl="clear"
alias claer="clear"
alias clera="clear"
alias xit="exit"
alias tm="tmux"
alias srz="source $ZDOTDIR/.zshrc"
alias cfz="nvim $ZDOTDIR/.zshrc"

# Resource Monitoring
alias df='df -h'
alias free='free -m'
alias psmem='ps auxf | sort -nr -k 4 | head -5'
alias pscpu='ps auxf | sort -nr -k 3 | head -5'

# Security & Services
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias mach_list_systemctl="systemctl list-unit-files --state=enabled"
alias warpc="warp-cli connect"
alias warpdc="warp-cli disconnect"

# Editor Shortcuts
alias n='nvim'
alias v='nvim'
alias vim='nvim'
alias nvi='nvim'
alias nivm='nvim'
alias nvimrc='nvim ~/.config/nvim/'
alias nvimconf="nvim ~/.config/nvim/"
alias l="NVIM_APPNAME=nvim_test nvim"
alias k="NVIM_APPNAME=nvim-kickstart nvim"
alias idea="/home/brandon/Downloads/idea-IC-243.22562.218/idea-IC-243.22562.218/bin/idea"

# Languages & Runtimes
alias py="python"
alias got='go test -v'
alias golive="live-server --no-browser --no-css-inject"

# Data & Backend
alias cat="bat"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias mongo="mongod"
alias mongosh="/home/brandon/.applications/mongosh-2.4.2-linux-x64-openssl3/bin/mongosh"
alias compass="mongodb-compass"
alias redis-cli="valkey-cli"
alias tl="tasklite"

# Apps & UI
alias vivaldi='flatpak run com.vivaldi.Vivaldi'
alias gradia='flatpak run be.alexandervanhee.gradia'
alias lorien='/home/brandon/Downloads/Lorien_v0.6.0_Linux/Lorien.x86_64 </dev/null &>/dev/null &'
alias icat="kitty +kitten icat"
alias love='~/.applications/love2d/love2d.appimage'

# General Docker
alias dk='docker'
alias dka='docker attach'
alias dkb='docker build'
alias dkd='docker diff'
alias dkdf='docker system df'
alias dke='docker exec'
alias dkE='docker exec -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t'
alias dkh='docker history'
alias dki='docker images'
alias dkin='docker inspect'
alias dkk='docker kill'
alias dkl='docker logs'
alias dkL='docker logs -f'
alias dkls='docker ps'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dkr='docker run'
alias dkR='docker run -e COLUMNS=`tput cols` -e LINES=`tput lines` -i -t --rm'
alias dkRM='docker system prune'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dks='docker start'
alias dkS='docker restart'
alias dkss='docker stats'
alias dkx='docker stop'

# Docker Compose
alias dc='docker compose'
alias dkc='docker compose'
alias dkcb='docker compose build'
alias dkcd='docker compose down'
alias dkce='docker compose exec -e COLUMNS=`tput cols` -e LINES=`tput lines`'
alias dkcl='docker compose logs'
alias dkcL='docker compose logs -f'
alias dkcps='docker compose ps'
alias dkcu='docker compose up'
alias dkcU='docker compose up -d'

# CleanUp Logic
alias dkrmC='docker rm $(docker ps -qaf status=exited)'
alias dkrmI='docker rmi $(docker images -qf dangling=true)'
alias dkrmV='docker volume rm $(docker volume ls -qf dangling=true)'

# Git workflow
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git checkout"
alias chkout="git checkout"
alias gcm="git commit -m"
alias commit="git commit"
alias gp="git pull"
alias gpull="git pull"
alias gpus="git push"
alias gpush="git push"
alias gd="git diff"
alias gclo="git clone"
alias gcl="git clone"
alias gsh='git stash'
alias gss="git stash save"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gr="git restore"
alias gma="git merge --abort"
alias gbn="git branch --show-current"

# Logging
alias gl='git log --graph --color=always --decorate'
alias glog="git log"
alias glgp="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glgpa="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"

# Delete all compiled Zsh binaries
alias zclean="rm -f $ZDOTDIR/**/*.zwc"

# alias gpustat="watch -n 1 \"echo 'Core: ' && cat /sys/class/drm/card1/device/pp_dpm_sclk 2>/dev/null | grep '*' | awk '{print \$2}' && echo 'Power: ' && cat /sys/class/drm/card1/device/hwmon/hwmon*/power1_input 2>/dev/null | awk '{print \$1/1000000 \\\" W\\\"}'\""
# alias win-off="virsh --connect qemu:///system shutdown win10-base-clone"
# alias win-kill="virsh --connect qemu:///system destroy win10-base-clone"
# alias list-vms="virsh --connect qemu:///system list --all"
# # alias csvview='column -t -s "," | bat -l cmd --style=grid,header'
# # bat -l cmd --style=grid,header --file-name 
# alias win-on='virsh --connect qemu:///system start win10-base-clone'
# alias win-view='virt-viewer --connect qemu:///system --attach --full-screen win10-base-clone'
# alias win-start='win-on && win-view'
alias wlc='wl-copy'
alias y='yazi'
