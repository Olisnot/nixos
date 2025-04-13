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
                        gparted
                        zip
                        ffmpeg
#General
			ranger
			wofi
			unzip
#Coding
			git
			git-credential-manager
			alacritty
#Coding Languages
			gcc
			python314
			lua
			];
}
