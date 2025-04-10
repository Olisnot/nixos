{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
#Utility
			killall
			util-linux
			btop
			lshw
			pavucontrol
			tree
			iwd
			iwgtk
			ripgrep
                        blueman
                        usbutils
			pciutils
                        inetutils
                        fzf
                        filezilla
                        wl-clipboard
#General
			ranger
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
