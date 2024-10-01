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
			ripgrep
			iwgtk
			opentabletdriver
                        blueman
                        bottles
                        usbutils

#General
                        ani-cli
			spotify
                        vesktop
			neofetch
			keymapp
			ranger
			wofi
			unzip
			dunst
			pciutils
			element-desktop
			nemo
			mpv
			betterbird
                        libreoffice-still
                        waypaper
                        slurp
                        grim
                        tectonic
                        mupdf
                        chatterino2
                        gpauth
                        gpclient
                        pipe-viewer
                        gtk-pipe-viewer

#UI
			waybar
			swww
			ags

#Coding
			neovim
			git
			git-credential-manager
			alacritty
			obsidian
			godot_4
                        android-studio
                        unityhub

#Coding Languages
			rustc
			cargo
			rustup
			gcc
			cmake
                        dotnet-sdk_8
			python39
			lua

#Art
			blender
			krita
			gimp

#Fonts
			gucharmap
			font-awesome
                        nerdfonts
			material-design-icons
			cascadia-code
			];
}
