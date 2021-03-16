# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
source_if_exists(){ if [ -f "$1" ]; then . "$1"; fi; }
optional_export_path(){ if [ -d "$1" ]; then export PATH="$1:$PATH"; fi; }

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export XDG_CACHE_DIR="$HOME/.cache"
export XDG_CONFIG_DIR="$HOME/.config"
export XDG_DATA_DIR="$HOME/.local"

export EDITOR="nvim"
export BROWSER="firefox"
export TERMINAL="alacritty --class=terminal --no-live-config-reload -qq"
# export VISUAL="$TERMINAL -e $EDITOR"
export TERMINAL_CMD="$TERMINAL --command"

export CARGO_HOME="$HOME/.cargo"
export CARGO_INSTALL_ROOT="$CARGO_HOME"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export LESS='-BFfQrms -x2 -~ --quit-on-intr'
export MANWIDTH=999
export PAGER=less
export KUBECONFIG=$HOME/.kube/config
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_QPA_PLATFORMTHEME='qt5ct'
export FZF_CTRL_T_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND"
export FZF_DEFAULT_OPTS='--layout=reverse -m --min-height=100 --color=16 --ansi --tabstop=2 --cycle'
export SKIM_DEFAULT_OPTIONS='--layout=reverse -m --min-height=100 --color=16 --ansi --tabstop=2 --cycle --bind "ctrl-d:if-query-empty(abort)+delete-char"'
export SCCACHE_DIR="$XDG_CACHE_DIR/sccache"
export SCCACHE_CACHE_SIZE="100G"
export MANPAGER="$EDITOR -n +Man!"
export WINIT_UNIX_BACKEND=x11  # Force wayland
export NAVI_FINDER="skim" NAVI_TAG_WIDTH=8 NAVI_COMMENT_WIDTH=56

optional_export_path "$HOME/bin"
optional_export_path "$HOME/.local/bin"
optional_export_path "$HOME/.local/share/bin"
optional_export_path "$HOME/.cargo/bin"
optional_export_path "$HOME/.yarn/bin"
optional_export_path "$HOME/.rbenv/bin"
optional_export_path "$HOME/.npm/bin"
optional_export_path "$HOME/go/bin"
optional_export_path "/usr/local/go/bin"
optional_export_path "$XDG_CONFIG_DIR/nvim/plug/fzf/bin"

# if [ -n "$SSH_TTY" -a -z "$TMUX" ]; then
#   # the user is connected via SSH but not in a TMUX session.
#   case "$-" in
#     *i*)  # shell is interactive
#       if ! tmux has-session -t "$USER" 2>/dev/null; then
#         tmux -2u new-session -dPs "$USER" -n "vim" nvim
#       fi
#       exec tmux -2u attach-session -dt "$USER"
#       ;;
#     *) true ;;
#   esac
# fi

