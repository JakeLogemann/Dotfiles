alias dmesg='sudo dmesg'

# When I copy+pasta code.. I always mean use my normal editor.
alias e='$EDITOR'
alias nano='$EDITOR'
alias pico='$EDITOR'
alias vi='$EDITOR'
alias visudo='sudo EDITOR=$EDITOR visudo'
alias edit='$EDITOR'

# Editing configurations easier (thus more often!)
alias edit-acropolis-config.xml='ssh -t acropolis env TERM=xterm-256color vim -n /conf/config.xml'
alias edit-SpaceVim.d='nvim -n $HOME/.SpaceVim.d/init.toml'
alias edit-alacritty-config='edit $HOME/.config/alacritty/alacritty.yml'
alias edit-aliases='edit $HOME/.config/aliases.sh && reload-aliases'
alias edit-bashrc='edit $HOME/.bashrc'
alias edit-nvimrc='nvim -n $HOME/.config/nvim/init.vim'
alias nvim-config='cd $HOME/.config/nvim/ && nvim .'
alias edit-profile='edit $HOME/.profile'
alias edit-ssh-config='edit $HOME/.ssh/config'
alias edit-ssh-config='nvim -n $HOME/.ssh/config'
alias edit-vimrc='nvim -n $HOME/.vimrc'
alias edit-zshrc='edit $HOME/.zshrc'

# After editing configs, you should reload them..
alias reload-aliases='source $HOME/.config/aliases.sh'
alias reload-bashrc='source $HOME/.bashrc'
alias reload-profile='source $HOME/.profile'
alias reload-zshrc='source $HOME/.zshrc'

# Git commands
alias gamend='git commit --amend --no-edit'
alias gamendit='git commit --amend --edit'
alias gb='git branch'
alias ga='git add'
alias gci='git commit'
alias gcl='git clone'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline'
alias gpl='git pull'
alias gps='git push'
alias grb='git rebase'
alias grem='git remote'
alias grm='git rm'
alias gs='git status --short --branch'
alias gt='git tag'

# Finding and removing cruft from projects easily.
alias find-broken-symlinks='find -L . -type l 2>/dev/null'
alias rm-broken-symlinks='find -L . -type l -exec rm -fv {} \; 2>/dev/null'

# Getting/Saving Information.
alias save-html='monolith -Isjf'
alias list-system-units='systemctl --no-pager --no-legend list-unit-files'
alias list-failed-system-units='systemctl --no-pager --no-legend list-unit-files'
alias lsenv='env | sort | less'
alias list-path='echo $PATH | tr ":" "\n" | less'
alias manski="eval \$(apropos -w '*' | sk -mp 'manpages> ' | cut -d- -f1 | awk '{print \"man\",\$2,\$1,\"; \"}' | tr -d '\n()')"
alias covid-19='curl https://corona-stats.online | less -R'

if [[ -e ~/.cargo/bin/lsd ]]; then
  alias l1='lsd -1'
  alias l='lsd'
  alias ll='lsd -Alh --date relative --size short --no-symlink'
  alias ls='lsd -A'
  alias lss='lsd -Alh --date relative --size short --no-symlink --sizesort'
  alias lst='lsd -Alh --date relative --size short --no-symlink --timesort'
else
  alias l1='ls -1'
  alias l='ls'
  alias ll='ls -Alh'
  alias ls='ls -A'
  alias lss='ls -Alh'
  alias lst='ls -Alh'
fi

# Commands I just frequently have to type...
alias CapsCtrl='setxkbmap -option ctrl:nocaps'

# Package managers and updates.
alias pacman='sudo pacman'
alias upgrade-system='topgrade -yk'
alias tmux-dir='tmux -2u new-session -ADs "$(basename $PWD)"'

# System service management.
alias select-system-service="systemctl --no-pager --no-legend list-unit-files | cut -d' ' -f1 | sk -mp 'system services> '"
alias select-user-service="systemctl --user --no-pager --no-legend list-unit-files | cut -d' ' -f1 | sk -mp 'user services> '"
alias systemctl-edit='sudo systemctl edit --full --force'

# vim: ft=sh et sw=2 ts=2 ai noci nu nornu
