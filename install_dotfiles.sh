
  #!/bin/bash

function colorecho() {
  BG='\033[1;32m'
  NC='\033[0m'
  echo -e "${BG}$@${NC}"
  sleep 2
}
function update() {
  	colorecho "[+] Updating, upgrading, cleaning"
  	apt -y update && apt -y install apt-utils && apt -y upgrade && apt -y autoremove && apt clean
}
function apt_packages() {
	colorecho "[+] Installing APT packages"
	apt install -y curl zsh python3-pip git tmux neofetch
}
function nerdfont() {
	colorecho "[+] Installing NerdFont"
	wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -O ~/hack.ttf
	mkdir -p ~/.local/share/fonts/hack
	sudo mv hack.ttf ~/.local/share/fonts/hack
	fc-cache -v -f
}
function ohmyzsh() {
  	colorecho "[+] Installing oh-my-zsh, config, history, aliases"
  	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh -l::g' | sed 's:chsh -s .*$::g')"
 	rm -rf /etc/zsh/zshrc /etc/zsh/zsh_history /etc/zsh/zprofile
	wget -O /etc/zsh/zprofile https://raw.githubusercontent.com/Rsifff/-dotfiles/master/.zprofile
   	wget -O /etc/.tmux.conf https://raw.githubusercontent.com/Rsifff/-dotfiles/master/.tmux.conf
  	wget -O /etc/zsh/zshrc https://raw.githubusercontent.com/Rsifff/-dotfiles/master/.zshrc
  	wget -O /etc/zsh/zsh_history https://raw.githubusercontent.com/ShutdownRepo/Exegol/master/confs/zsh/history
        git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
  	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions
  	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
  	git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/plugins/zsh-completions
   	source ~/.zshrc
}
function lolcat() {
	colorecho "[+] Installing lolcat"
	pip3 install lolcat
}
function autojump() {
	colorecho "[+] Installing autojump"
	git clone https://github.com/wting/autojump.git
	apt install autojump
	python3 autojump/install.py
	rm -rf autojump
}

function thefuck() {
	colorecho "[+] Installing thefuck"
	pip3 install thefuck
}
function main() {
	update
	apt_packages
	nerdfont
	ohmyzsh
	lolcat
	autojump
	thefuck
}
main "$@"
colorecho "Restart Terminal"
