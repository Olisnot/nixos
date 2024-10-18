{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
#Utility
			killall
			util-linux
			htop
                        bottles
			lshw
			pavucontrol
			tree
			iwd
			iwgtk
			ripgrep
                        blueman
                        usbutils
			pciutils
                        fzf
                        waypaper

#General
			ranger
			spotify
                        vesktop
			neofetch
			wofi
			unzip
			dunst
			mpv
                        thunderbird
                        slurp
                        grim
                        mupdf
                        chatterino2
                        gpauth
                        gpclient
                        libreoffice-qt6-fresh
			keymapp

#UI
			waybar
			swww
			ags

#Coding
			git
			git-credential-manager
			alacritty
			obsidian
                        android-studio
                        unityhub

#Coding Languages
			gcc
			python39
			lua

#Art
			gimp


#Fonts
			gucharmap
			];
}
