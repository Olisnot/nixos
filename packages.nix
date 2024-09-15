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
			firefox
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
			cinnamon.nemo
			mpv
			betterbird
                        libreoffice-still
                        waypaper
                        slurp
                        grim
                        tectonic
                        mupdf
                        chatterino2

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

#Coding Languages
			rustc
			cargo
			rustup
			gcc
			cmake
			dotnetCorePackages.sdk_9_0
			python39
			lua

#Art
			blender
			krita
			gimp

#Fonts
			gnome.gucharmap
			font-awesome
                        nerdfonts
			material-design-icons
			cascadia-code
			];
}
