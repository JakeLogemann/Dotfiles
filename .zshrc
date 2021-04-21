# -----------------------------------------------------------------------------------
#         888888888888             88                                   
#                  ,88             88                                   
#                ,88"              88                                   
#              ,88"     ,adPPYba,  88,dPPYba,   8b,dPPYba,   ,adPPYba,  
#            ,88"       I8[    ""  88P'    "8a  88P'   "Y8  a8"     ""  
#          ,88"          `"Y8ba,   88       88  88          8b          
#         88"           aa    ]8I  88       88  88          "8a,   ,aa  
#         888888888888  `"YbbdP"'  88       88  88           `"Ybbd8"'  
# -----------------------------------------------------------------------------------
# Author: Jake Logemann (https://github.com/JakeLogemann) 
 
[[ -n "$zsh_dir" ]] || readonly zsh_dir="$XDG_CONFIG_DIR/zsh"
fpath=( "$zsh_dir/completions" "$zsh_dir/functions" $fpath )
path+=( "$HOME/.fzf/bin" "$HOME/.cargo/bin" "$HOME/.rbenv/bin" "$HOME/.rbenv/shims" "/usr/local/bin")

# Helper Functions                                                  {{{1
#=======================================================================
# Helper functions (for early-use)
function has_bin(){ for var in "$@"; do which $var 2>/dev/null >&2; done; }
function source_if_exists(){ for var in "$@"; do test ! -r "$var" || source "$var"; done; }
function maybe_run_bin(){ if has_bin "$1"; then eval "$@"; fi; }
function maybe_eval_bin(){ if has_bin "$1"; then eval "$($*)"; fi; }
function scp_to_same(){ scp -rp "$1" "$2:$1" ;}
function dotfiles::run-navi() {  BUFFER=" navi"; zle accept-line; }
function dotfiles::skim-files-in-directory() {  BUFFER=" sk --ansi -i -c 'grep -rI --color=always --line-number \"{}\" .'"; zle accept-line; }
function dotfiles::skim-directory() {  BUFFER=' vim -p $(find . -type f | sk -m)'; zle accept-line; }

# List all defined options, in a more pretty way.
function list-fpath(){ echo $fpath | tr " " "\n" | nl ;}
function list-path(){ echo $path | tr " " "\n" | nl ;}
function list-hosts(){ cat /etc/hosts |column -t ;}
function list-users(){ cat /etc/passwd |column -ts: | sort -nk3 ;}
function list-keybinds(){ bindkey |grep -v "magic-space"  |tr -d "\""| column -t ;}

function background() { # starts one or multiple args as programs in background
  for ((i=2;i<=$#;i++)); do ${@[1]} ${@[$i]} &> /dev/null &; done
}

function uuid() { # Usage: uuid
  C="89ab"
  for ((N=0;N<16;++N)); do
      B="$((RANDOM%256))"
      case "$N" in
          6)  printf '4%x' "$((B%16))" ;;
          8)  printf '%c%x' "${C:$RANDOM%${#C}:1}" "$((B%16))" ;;
          3|5|7|9) printf '%02x-' "$B" ;;
          *) printf '%02x' "$B" ;;
      esac
  done
  printf '\n'
}


typeset -a baliases; baliases=()  # blank aliases
typeset -a ialiases; ialiases=(); # ignored aliases
function balias() { alias $@; args="$@"; args=${args%%\=*}; baliases+=(${args##* }); }
function ialias() { alias $@; args="$@"; args=${args%%\=*}; ialiases+=(${args##* }); }
function expand-alias-space() {
  [[ $LBUFFER =~ "\<(${(j:|:)baliases})\$" ]]; insertBlank=$?
  if [[ ! $LBUFFER =~ "\<(${(j:|:)ialiases})\$" ]]; then zle _expand_alias; fi
  zle self-insert
  if [[ "$insertBlank" = "0" ]]; then zle backward-delete-char; fi
}


# Third-Party/Vendor Scripts                                        {{{1
#=======================================================================
source_if_exists "$HOME/.profile"
source_if_exists "$HOME/.rbenv/completions/rbenv.zsh"
maybe_eval_bin $HOME/.cargo/bin/starship init zsh
maybe_eval_bin $HOME/.cargo/bin/zoxide init --cmd="goto" zsh
maybe_eval_bin direnv hook zsh
maybe_eval_bin rbenv init -
maybe_eval_bin pyenv init -


if [[ -n "${SSH_CONNECTION}" && "$TERM" == "alacritty" ]]; then export TERM=xterm-256color; fi

# Standard ZSH Modules                                              {{{1
#=======================================================================
# load applicable zsh modules
zmodload \
  "zsh/attr" \
  "zsh/cap" \
  "zsh/clone" \
  "zsh/complete" \
  "zsh/complist" \
  "zsh/computil" \
  "zsh/curses" \
  "zsh/langinfo" \
  "zsh/mathfunc" \
  "zsh/parameter" \
  "zsh/regex" \
  "zsh/sched" \
  "zsh/system" \
  "zsh/termcap" \
  "zsh/terminfo" \
  "zsh/zle" \
  "zsh/zleparameter" \
  "zsh/zpty" \
  "zsh/zselect" \
  "zsh/zutil"

autoload -Uz promptinit colors; promptinit; colors;
autoload -Uz compinit bashcompinit && compinit && bashcompinit


# ZSH Style Configurations                                          {{{1
#=======================================================================
zstyle ':completion:*'                cache-path        "$zsh_dir/completion.cache"
zstyle ':completion:*'                completer         _complete _match _approximate _expand_alias
zstyle ':completion:*'                file-list         list=20 insert=10
zstyle ':completion:*'                squeeze-slashes   true
zstyle ':completion:*'                use-cache         on
zstyle ':completion:*:*:kill:*'       menu              yes select
zstyle ':completion:*:(all-|)files'   ignored-patterns  '(|*/)CVS'
zstyle ':completion:*:default'        list-dirs-first   true
zstyle ':completion:*:approximate:*'  max-errors        1 numeric
zstyle ':completion:*:cd:*'           ignore-parents    parent pwd
zstyle ':completion:*:cd:*'           ignored-patterns  '(*/)#CVS'
zstyle ':completion:*:functions'      ignored-patterns  '_*'
zstyle ':completion:*:kill:*'         force-list        always
zstyle ':completion:*:match:*'        original          only
zstyle ':completion:*:rm:*'           file-patterns     '*.log:log-files' '%p:all-files'

# Standard ZSH Options                                              {{{1
#=======================================================================
setopt cbases cprecedences
setopt autocd autopushd pushdsilent pushdignoredups pushdtohome
setopt cdablevars interactivecomments printexitvalue shortloops
setopt localloops localoptions localpatterns
setopt pipefail vi evallineno

# Autocompletion
setopt hashdirs hashcmds 
setopt aliases 
setopt automenu 
setopt autoparamslash 
setopt autoremoveslash 
setopt completealiases 
setopt promptbang promptcr promptsp promptpercent promptsubst transientrprompt 
setopt listambiguous 
setopt listpacked 
setopt listrowsfirst 
setopt autolist 
setopt markdirs

setopt banghist 
setopt histbeep 
setopt inc_append_history
setopt histexpiredupsfirst 
setopt histignorealldups 
setopt histnostore 
setopt histfcntllock 
setopt histfindnodups 
setopt histreduceblanks 
setopt histsavebycopy 
setopt histverify 
setopt sharehistory

# Shell History
HISTFILE="$HOME/.zhistory" 
SAVEHIST=50000  # Total lines to save in zsh history.
HISTSIZE=1000   # Lines of history to save to save from the current session.

unsetopt correct correctall flowcontrol 

# Job Control
unsetopt flowcontrol   #Disable ^S & ^Q.
setopt autocontinue autoresume bgnice checkjobs notify longlistjobs
setopt checkrunningjobs 

# Aliases                                                           {{{1
#=======================================================================
if has_bin lsd; then
  ialias l1='lsd -1'
  ialias l='lsd'
  ialias ll='lsd -Alh --date relative --size short --no-symlink'
  ialias ls='lsd -A'
  ialias lss='lsd -Alh --date relative --size short --no-symlink --sizesort'
  ialias lst='lsd -Alh --date relative --size short --no-symlink --timesort'
else
  ialias l1='ls -1'
  ialias l='ls'
  ialias ll='ls -Alh'
  ialias ls='ls -A'
  ialias lss='ls -Alh'
  ialias lst='ls -Alh'
fi

for e in "e" "nano" "pico" "vi" "edit"; do ialias $e="$EDITOR"; done

# Commands I just frequently have to type...
alias save-html='monolith -Isjf'
alias list-system-units='systemctl --no-pager --no-legend list-unit-files'
alias list-failed-system-units='systemctl --no-pager --no-legend list-unit-files'
ialias lsenv='env | sort | less'
ialias list-path='echo $PATH | tr ":" "\n" | less'
ialias manski="eval \$(apropos -w '*' | sk -mp 'manpages> ' | cut -d- -f1 | awk '{print \"man\",\$2,\$1,\"; \"}' | tr -d '\n()')"
alias covid-19='curl https://corona-stats.online | less -R'
alias CapsCtrl='setxkbmap -option ctrl:nocaps'
alias pacman='sudo pacman'
alias upgrade-system='topgrade -yk'
alias tmux-dir='tmux -2u new-session -ADs "$(basename $PWD)"'
alias select-system-service="systemctl --no-pager --no-legend list-unit-files | cut -d' ' -f1 | sk -mp 'system services> '"
alias select-user-service="systemctl --user --no-pager --no-legend list-unit-files | cut -d' ' -f1 | sk -mp 'user services> '"
alias systemctl-edit='sudo systemctl edit --full --force'
hash -d ".nvim"="$HOME/.config/nvim"
hash -d ".alacritty"="$HOME/.config/alacritty"
ialias rsdoc="rusty-man --viewer=rich"
ialias reload="clear && source $HOME/.zshrc"
ialias tmux="tmux -2u"
# alias -s toml='background brave'
# alias -s html='background brave'
# alias -s {pdf,PDF}='background mupdf'
# alias -s {mp4,MP4,mov,MOV}='background vlc'
# alias -s {zip,ZIP}="unzip -l"
alias dmesg='sudo dmesg'
alias tf='terraform'
alias dc='docker-compose'
ialias edit-alacritty.yml="$EDITOR $HOME/.config/alacritty/alacritty.yml"
ialias edit-bashrc="$EDITOR $HOME/.bashrc"
ialias edit-nvimrc="cd $XDG_CONFIG_DIR/nvim && nvim ."
ialias edit-profile="$EDITOR $HOME/.profile"
ialias edit-ssh-config="$EDITOR $HOME/.ssh/config"
ialias edit-vimrc='vim $HOME/.vimrc'
ialias edit-zshrc="edit $HOME/.zshrc"
ialias pacman-install='pacman -Sl | sk | cut -d\  -f2 | xargs sudo pacman -Syu --noconfirm --needed'
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
alias gs='git status -sb'
alias gt='git tag'
alias find-broken-symlinks='find -L . -type l 2>/dev/null'
alias rm-broken-symlinks='find -L . -type l -exec rm -fv {} \; 2>/dev/null'
# alias -s toml='background brave'
# alias -s html='background brave'
# alias -s {pdf,PDF}='background mupdf'
# alias -s {mp4,MP4,mov,MOV}='background vlc'
# alias -s {zip,ZIP}="unzip -l"
#
# Keybindings                                                       {{{1
#=======================================================================
source ~/.config/zsh/plugins/skim.zsh

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() { echoti smkx; }
  function zle-line-finish() { echoti rmkx; }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

autoload -U expand-alias-space && zle -N expand-alias-space
autoload -U select-word-style 
autoload -U edit-command-line  && zle -N edit-command-line
autoload -U up-line-or-beginning-search && zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search && zle -N down-line-or-beginning-search
zle -N dotfiles::run-navi
zle -N dotfiles::skim-files-in-directory
zle -N dotfiles::skim-directory

# Use bash-style word separators (such as dirs).
select-word-style bash


# Use emacs key bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi

# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word

# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion

# Edit the current command line in $EDITOR
bindkey '\C-x\C-e' edit-command-line
bindkey "\C-x\C-x" dotfiles::run-navi

# file rename magick
bindkey "^[m" copy-prev-shell-word

bindkey "^[e" edit-command-line
bindkey "^[d" dotfiles::skim-directory
bindkey "^[n" dotfiles::run-navi
bindkey "^[f" dotfiles::skim-files-in-directory

bindkey '\C-x\C-e'     edit-command-line
bindkey '\C-k'         up-line-or-history
bindkey '\C-j'         down-line-or-history
bindkey '\C-h'         backward-word
bindkey '\C-w'         backward-kill-word
bindkey '^[h'          run-help
bindkey '\C-b'         backward-word
bindkey '\C-a'         beginning-of-line
bindkey '\C-e'         end-of-line
bindkey '\C-f'         forward-word
bindkey '\C-l'         forward-word
bindkey " "            expand-alias-space
bindkey -M isearch " " magic-space

#                           Local Overrides                         {{{1
#=======================================================================
test ! -r ~/.zshrc.local || source ~/.zshrc.local
# vim: fdm=marker fen fdl=0 fdo=all fcl=all
