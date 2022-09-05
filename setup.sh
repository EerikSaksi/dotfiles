#shell/term (first becuase .zshrc is overriden by oh-my-zsh)
sudo apt-get -y install zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
git clone https://github.com/kutsan/zsh-system-clipboard ~/.zsh/plugins/zsh-system-clipboard
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions/

#move config files and reload
cp -RT dotfiles .
regolith-look refresh
sudo sh -c 'curl https://raw.githubusercontent.com/rjekker/i3-battery-popup/master/i3-battery-popup > /usr/bin/i3-battery-popup'

curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh

#misc packages
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt-get -y install neovim curl i3xrocks-volume i3xrocks-weather i3xrocks-battery npm python3-pip cmake alacritty trash-cli imagemagick vlc evince postgresql subversion libreoffice mpv transmission

#docker
curl https://get.docker.com/ | sh

#chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
rm ./google-chrome-stable_current_amd64.deb

#rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#neovim/neovide
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
python3 -m pip install pynvim
sudo npm install -g neovim
echo 'set editing-mode vi' | sudo tee /etc/inputrc
echo 'set keymap vi-command' | sudo tee -a /etc/inputrc

#setup dotfiles repo, git configs, and then add all files I want to track in the future
git init --bare $HOME/.dotfiles
dotfiles config --local status.showUntrackedFiles no
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles remote add origin git@github.com:EerikSaksi/dotfiles.git
dotfiles add setup.sh
dotfiles add .zshrc
dotfiles add .alacritty.yml
dotfiles add Scripts
dotfiles add .config/coc/ultisnips/*
dotfiles add .config/nvim/init.vim
dotfiles add .config/nvim/coc-settings.json
dotfiles add .config/regolith/Xresources
dotfiles add .config/regolith/i3/config
dotfiles add .cache/vim-marks-overhaul

git config --global core.editor "nvim"
