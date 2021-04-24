export ZSH="/home/eerik/.oh-my-zsh"
alias py="python3"
alias x="xclip -selection clipboard"
alias gc="git commit"
alias v="nvim"
alias rm="trash-put"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias pip="python3 -m pip"
alias f="fuck"
alias gimme="sudo apt-get install"
alias yeet="sudo apt-get autoremove --purge"
alias lss='ls -t'
ZSH_THEME="robbyrussell"
eval $(thefuck --alias)


openVimWithJump(){
  nvim -c ":OverhaulJump"; cd $(cat ~/.vim_last_used)
}
zle -N openVimWithJump
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/java
export PATH=$PATH:/usr/lib/postgresql/12/bin

plugins=(git) 
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
bindkey -v 
source $ZSH/oh-my-zsh.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
bindkey "\e" vi-cmd-mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd "t" openVimWithJump
export KEYTIMEOUT=1
bindkey '^j' autosuggest-accept
bindkey '^f' 'sdg'

function x11-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift

    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi

        zle -N $widget _x11-clip-wrapped-$widget
    done
}


local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)

# NB: can atm. only wrap native widgets
x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste  $paste_widgets

function zle-keymap-select zle-line-init zle-line-finish {
  case $KEYMAP in
    vicmd)      print -n -- "\E]50;CursorShape=0\C-G";; # block cursor
    viins|main) print -n -- "\E]50;CursorShape=1\C-G";; # line cursor
  esac

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

function precmd()
{
    emulate -L zsh
    (( $#jobstates == 1 )) || return
    local -i PID=${${${(s.:.)${(v)jobstates[1]}}[3]}%\=*}
    cd $(readlink /proc/$PID/cwd)
}
