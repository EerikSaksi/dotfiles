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
export DEBUG='postgraphile:postgres:notice graphile-build:warn'

ZSH_THEME="robbyrussell"

if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi
source ~/.oh-my-zsh/oh-my-zsh.sh

openVimWithJump(){
  nvim -c ":OverhaulJump"; cd $(cat ~/.vim_last_used)
}
zle -N openVimWithJump
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/java
export PATH=$PATH:/usr/lib/postgresql/12/bin

plugins=(git) 
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=1"
bindkey -v 

if [ ! -f ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh ]; then
  git clone https://github.com/kutsan/zsh-system-clipboard ~/.zsh/plugins/zsh-system-clipboard
fi
source "$HOME/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"

if [ ! -f ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh ]; then
  git clone https://github.com/kutsan/zsh-system-clipboard ~/.zsh/plugins/zsh-system-clipboard
fi

if [ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions/
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

bindkey "\e" vi-cmd-mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd "t" openVimWithJump
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

[ -f "/home/eerik/.ghcup/env" ] && source "/home/eerik/.ghcup/env" # ghcup-env

function vi-yank-xclip {
   zle vi-yank
   echo "$CUTBUFFER" | xclip -selection clipboard
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
