{ pkgs, config, libs, inputs, ... }:

{
	environment.systemPackages = with pkgs; [
			#General
            killall
            util-linux
			firefox
			thunderbird
			feh
            htop
            vlc
			lshw
			pavucontrol
			spotify
			tree
            iwd
            neofetch
            keymapp
            ranger
            rofi
            wofi
            redshift
            unzip
            steam-run
            dunst
            flameshot
            pciutils
            element-desktop
            cinnamon.nemo
            swww

			#UI
			polybar
            waybar
			picom
            eww
            lxappearance
            libsForQt5.qt5ct
            libsForQt5.qtstyleplugin-kvantum
            kanagawa-gtk-theme
            kanagawa-icon-theme

			#Coding
			neovim
			git
			git-credential-manager
			tmux
			alacritty
			obsidian

			#Coding Languages
			rustc
            cmake
            cargo
            rustup
			python3
            gcc

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
