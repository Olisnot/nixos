{ pkgs, ... }:

let
  rebuild = import ./scripts/Rebuild.nix { inherit pkgs; };
in
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
			pciutils

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
			gimp

#Fonts
			gucharmap
			font-awesome
                        nerdfonts
			material-design-icons
			cascadia-code
#Scripts
                        rebuild

#UNI
                        android-studio
                        unityhub
			];
}
