{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
#Utility
			killall
			util-linux
			htop
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
#General
			ranger
			neofetch
			wofi
			unzip
			dunst
#Coding
			git
			git-credential-manager
			alacritty
#Coding Languages
			gcc
			python39
			lua
			];
}