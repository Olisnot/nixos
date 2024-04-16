{ pkgs, config, libs, ... }:

{
	environment.systemPackages = with pkgs; [
			#General
			firefox
			thunderbird
			feh
			lshw
			pavucontrol
			spotify
			tree

			#UI
			polybar
			picom
			libsForQt5.bismuth
			i3

			#Coding
			neovim
			git
			git-credential-manager
			tmux
			alacritty
			obsidian

			#Coding Languages
			dotnet-sdk_8
			rustc
			python3

			#Gaming
			steam
			lutris
			heroic
			protonup-qt

			#Fonts
			gnome.gucharmap
			font-awesome
			material-design-icons
	];
}
