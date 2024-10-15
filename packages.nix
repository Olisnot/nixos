{ pkgs, inputs, ... }:

let
  rebuild = import ./scripts/Rebuild.nix { inherit pkgs; };
  config = import ./scripts/Config.nix { inherit pkgs; };
  nvim = inputs.nixvim.packages."x86_64-linux".default;
in
{
	environment.systemPackages = with pkgs; [
#Utility
			killall
			util-linux
			htop
                        bottles
			lshw
			pavucontrol
			tree
			iwd
			iwgtk
			ripgrep
			opentabletdriver
                        blueman
                        usbutils
			pciutils
                        fzf

#General
			spotify
                        vesktop
			neofetch
			keymapp
			ranger
			wofi
			unzip
			dunst
			nemo
			mpv
			betterbird
                        slurp
                        grim
                        tectonic
                        mupdf
                        chatterino2
                        gpauth
                        gpclient

#UI
			waybar
			swww
			ags

#Coding
                        nvim
			git
			git-credential-manager
			alacritty
			obsidian
                        android-studio

#Coding Languages
			gcc
			python39
			lua

#Art
			gimp

#Fonts
			gucharmap
			font-awesome
                        nerdfonts
			material-design-icons
			cascadia-code
#Scripts
                        rebuild
                        config
			];
}
