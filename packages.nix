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

#General
			firefox
			spotify
			neofetch
			keymapp
			ranger
			wofi
			unzip
			dunst
			flameshot
			pciutils
			element-desktop
			cinnamon.nemo
			mpv
			betterbird

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
			material-design-icons
			cascadia-code
			];
}
