#!/bin/bash
#filename            	: install_dotfiles.sh
#description    	 	: This script is used to install the dotfiles of my github: https://github.com/Rsifff/dotfiles/
#author             	: Roman Le Page (Rsifff)
#date                	: 2020/07/31
#version             	: 1.0
#usage               	: $ chmod +x install_dotfiles.sh && sudo ./install_dotfiles.sh
#======================================================================================

function colorecho() {
 	BG='\033[1;32m'
	NC='\033[0m'
	echo -e "${BG}$@${NC}"
	sleep 1
}

function update() {
	colorecho "[+] Updating, upgrading, cleaning"
	apt -y update && apt -y install apt-utils && apt -y upgrade && apt -y autoremove && apt clean
}

	function apt_packages() {
	colorecho "[+] Installing APT packages"
	apt install -y ruby-full curl zsh python3-pip git tmux neofetch  
	gem install tmuxinator
}

function fonts() {
	colorecho "[+] Installing NerdFont"
	mkdir -p /usr/share/fonts/truetype/hack/
	wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -O /usr/share/fonts/truetype/hack/Hack-v3.003-ttf.zip
	wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -O /usr/share/fonts/truetype/hack/Hack_Reg_Nerdfont_Complete.ttf
	cd /usr/share/fonts/truetype/hack/
	unzip Hack-v3.003-ttf.zip
	fc-cache -v -f
}

function ohmyzsh() {
	colorecho "[+] Installing Oh-My-Zsh, config, aliases"

#Retrieving the path of the home files
	getent passwd | cut -d: -f6 | grep -w root >> listhomeuser
	getent passwd | cut -d: -f6 | grep home >>listhomeuser
	file=$(tail listhomeuser)

	for homeuser in $file ; do
		if [[ $homeuser = "/home/syslog" || $homeuser = "/home/cups-pk-helper" ]]; then
			echo " "
		else
			pathuser="$homeuser/"

			colorecho "[+] Installing Oh-My-Zsh"
			sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		
			colorecho "[+] Installation of configuration files"
			wget -O $pathuser.zprofile https://raw.githubusercontent.com/Rsifff/dotfiles/master/.zprofile
			wget -O $pathuser.tmux.conf https://raw.githubusercontent.com/Rsifff/dotfiles/master/.tmux.conf
			wget -O $pathuser.zshrc https://raw.githubusercontent.com/Rsifff/dotfiles/master/.zshrc
			if [[ $homeuser != "/root" ]]; then
				cp -r /root/.oh-my-zsh $pathuser.oh-my-zsh	#copy the .ohmyzsh file for all users
			fi
			#Install the theme and plugins
			git clone https://github.com/romkatv/powerlevel10k.git $pathuser.oh-my-zsh/themes/powerlevel10k
  			git clone https://github.com/zsh-users/zsh-autosuggestions.git $pathuser.oh-my-zsh/plugins/zsh-autosuggestions
			git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $pathuser.oh-my-zsh/plugins/zsh-syntax-highlighting
			git clone https://github.com/zsh-users/zsh-completions.git $pathuser.oh-my-zsh/plugins/zsh-completions
			source $pathuser.zshrc
		fi
	done	
	rm -f listhomeuser
}

function tools() {
	colorecho "[+] Installing tools "
	pip3 install lolcat
	wget https://github.com/Peltoche/lsd/releases/download/0.17.0/lsd_0.17.0_amd64.deb
    dpkg -i lsd_0.17.0_amd64.deb
    rm -f lsd_0.17.0_amd64.deb
}

function pluginszsh() {
	colorecho "[+] Installing Plugins"
	
	#Autojump	
	git clone https://github.com/wting/autojump.git
	apt install autojump
	python3 autojump/install.py
	rm -rf autojump
	
	#TheFuck
	pip3 install thefuck
}

function main() {
	update
	apt_packages
	fonts
	ohmyzsh
	tools
	pluginszsh
}

main "$@"
colorecho "\e"
colorecho "\e[5m                             End of installation 				   "
colorecho "================================================================================"
colorecho "   Replace your terminal's font with Hack Nerd Font Regular to get the icons" 
colorecho "================================================================================"
