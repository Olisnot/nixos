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
            iwd
            neofetch

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
            cargo
            rustup
			python3

			#Fonts
			gnome.gucharmap
			font-awesome
			material-design-icons
	];
}
