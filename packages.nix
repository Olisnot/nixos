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
			opentabletdriver
                        blueman
                        usbutils
			pciutils
                        fzf
                        waypaper

#General
			spotify
                        vesktop
			neofetch
			keymapp
			ranger
			wofi
			unzip
			dunst
			nemo
			mpv
			betterbird
                        slurp
                        grim
                        mupdf
                        chatterino2
                        gpauth
                        gpclient
                        libreoffice-qt6-fresh

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

#Coding Languages
			gcc
			python39
			lua

#Art
			gimp

#Fonts
			gucharmap
			font-awesome
                        nerdfonts
			material-design-icons
			cascadia-code
			];
}
