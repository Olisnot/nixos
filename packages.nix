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

    nix.settings = {
        substituters = [ "https://ezkea.cachix.org" ];
        trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
    };
}
