export ZSH="/home/eerik/.oh-my-zsh"
alias p="python3.7"
alias v="neovide"
 
alias pi="pip3.7"
alias rm="trash-put"
alias x="xclip -selection clipboard"
alias ls="ls -t"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
ZSH_THEME="robbyrussell"

export ANDROID_HOME=$HOME/Android/Sdk
export PTH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/java
plugins=(git  )
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
bindkey -v 
source $ZSH/oh-my-zsh.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "\e" vi-cmd-mode
bindkey -M vicmd '?' history-incremental-search-backward
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

