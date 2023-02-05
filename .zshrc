zmodload zsh/zprof
export ZSH="${HOME}/.oh-my-zsh"
alias py="python3"
alias v="nvim"
alias x="xsel -ib"
alias gc="git commit"
alias ss="sleep 3; gnome-screenshot -acf /tmp/test && cat /tmp/test | -i -selection clipboard -target image/png"
alias stop_it=docker stop $(docker ps -a -q)
alias update_dotfiles="dotfiles add .cache/vim-marks-overhaul/*; dotfiles add .config/coc/ultisnips/*; dotfiles commit -a -m \"Auto commit\"; dotfiles push"


alias rand='openssl rand -base64 60'

#export NEOVIDE_MULTIGRID=true

#git init --bare $HOME/.dotfiles
#dotfiles config --local status.showUntrackedFiles no
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias pip="python3 -m pip"
alias f="fuck"
alias gimme="sudo apt-get install"
alias yeet="sudo apt-get autoremove --purge"
alias lss='ls -rt'
source $HOME/.cargo/env
export DEBUG='postgraphile:postgres:notice graphile-build:warn'
export DISABLE_UPDATE_PROMPT=true

ZSH_THEME="robbyrussell"

source ~/.oh-my-zsh/oh-my-zsh.sh

openeovideWithJump(){
	v -c "OverhaulJump" 
}
zle -N openeovideWithJump
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/java
export PATH=$PATH:/usr/lib/postgresql/12/bin
export PATH=$PATH:~/.local/bin/
export PATH=$PATH:~/Scripts
export PATH=$PATH:~/miniconda3/bin:$PATH


plugins=(git) 
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
bindkey -v 

source "$HOME/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

bindkey "\e" vi-cmd-mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd "t" openeovideWithJump
export KEYTIMEOUT=1
bindkey '^j' autosuggest-accept
bindkey '^f' 'sdg'

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


function vi-yank-xclip {
   zle vi-yank
   echo "$CUTBUFFER" | xsel -ib 
}
function pdf() {
	evince "$1" &! exit
}

function compress() {
	ffmpeg -i $1 -vcodec libx265 -crf 28 output.mp4
}
 

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
[ -f "/home/eerik/.ghcup/env" ] && source "/home/eerik/.ghcup/env" # ghcup-env

EDITOR=nvim
bindkey -M vicmd '\t' edit-command-line

export PATH="$HOME/.pyenv/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
zmodload zsh/zprof
alias ls='ls --color=tty -rt'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/eerik/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/eerik/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/eerik/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/eerik/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<

alias rm="trash-put"
