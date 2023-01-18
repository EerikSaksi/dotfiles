zsh () {
	sudo apt install curl 
	#shell/term (first becuase .zshrc is overriden by oh-my-zsh)
	sudo apt-get -y install zsh
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
	git clone https://github.com/kutsan/zsh-system-clipboard ~/.zsh/plugins/zsh-system-clipboard
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions/
	cd ~
	cp -RT dotfiles .
}

i3wm () {
	sudo apt remove regolith-i3-gnome regolith-i3-session regolith-i3-base-launchers 
}


nodejs() {
	curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
	sudo bash /tmp/nodesource_setup.sh
}

rust (){
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	cargo install cargo-watch git-delta
}

misc (){
	#misc packages
	sudo add-apt-repository ppa:aslatter/ppa -y
	sudo apt-get -y install i3xrocks-volume i3xrocks-weather i3xrocks-battery python3-pip cmake alacritty trash-cli imagemagick evince postgresql subversion xsel

	#docker
	curl https://get.docker.com/ | sh

	#chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo apt install ./google-chrome-stable_current_amd64.deb
	rm ./google-chrome-stable_current_amd64.deb
}

neovim() {
	curl 'https://objects.githubusercontent.com/github-production-release-asset-2e65be/16408992/36cdf4e1-bd1b-4736-af2f-de68ecbe44a4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20221203%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221203T135314Z&X-Amz-Expires=300&X-Amz-Signature=fdf73f6a89ef9f4e2e156dd462ee033bd4cddfb39c39fb12146b25e35d1d1ef1&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=16408992&response-content-disposition=attachment%3B%20filename%3Dnvim.appimage&response-content-type=application%2Foctet-stream' \
		-H 'authority: objects.githubusercontent.com' \
		-H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
		-H 'accept-language: en-US,en;q=0.9,fi;q=0.8' \
		-H 'referer: https://github.com/neovim/neovim/releases' \
		-H 'sec-ch-ua: "Not?A_Brand";v="8", "Chromium";v="108", "Google Chrome";v="108"' \
		-H 'sec-ch-ua-mobile: ?0' \
		-H 'sec-ch-ua-platform: "Linux"' \
		-H 'sec-fetch-dest: document' \
		-H 'sec-fetch-mode: navigate' \
		-H 'sec-fetch-site: cross-site' \
		-H 'sec-fetch-user: ?1' \
		-H 'upgrade-insecure-requests: 1' \
		-H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36' \
		--compressed > nvim.appimage
	sudo apt-get install -y libfuse2
	chmod +x nvim.appimage
	sudo mv nvim.appimage /usr/bin/nvim
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	python3 -m pip install pynvim
	sudo npm install -g neovim

	echo 'set editing-mode vi' | sudo tee /etc/inputrc
	echo 'set keymap vi-command' | sudo tee -a /etc/inputrc
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

}


dotfiles () {
	#setup dotfiles repo, git configs, and then add all files I want to track in the future
	git init --bare $HOME/.dotfiles
	dotfiles config --local status.showUntrackedFiles no
	alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
	dotfiles remote add origin git@github.com:EerikSaksi/dotfiles.git
	dotfiles add setup.sh
	dotfiles add .zshrc
	dotfiles add .alacritty.yml
	dotfiles add Scripts
	dotfiles add .config/nvim/coc-settings.json
	dotfiles add .cache/vim-marks-overhaul
	git config --global core.editor "nvim"
}
#* * * * * cmp --silent /usr/bin/block /etc/hosts || (cp /usr/bin/block /etc/hosts && killall google-chrome)
