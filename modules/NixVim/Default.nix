{ pkgs, inputs, ... }: 

{
	imports = [
		./kanagawa.nix
		./keymaps.nix
		./Plugins/Default.nix
	];
	programs.nixvim = {
		enable = true;
		enableMan = true;

		globalOpts = {
			relativenumber = true;
		};

		localOpts = {
			conceallevel = 2;
		};

		globals.mapleader = " ";
	};
}
