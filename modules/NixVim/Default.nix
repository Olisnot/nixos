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

		globals.mapleader = " ";

		plugins = {
			lsp = {
				enable = true;
				servers = {
					bashls.enable = true;
				};
			};
			telescope = {
				enable = true;
				keymaps = {
					"<leader>f" = "find_files";
				};
			};
		};
	};
}
