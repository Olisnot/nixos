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

#Coding Languages
			rustc
			cargo
			rustup
			gcc
			cmake
                        dotnet-sdk_8
                        dotnetCorePackages.sdk_8_0_3xx
			python39
			lua
                        kotlin

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

#UNI
                        glpk
                        android-studio
                        unityhub
			];
}
