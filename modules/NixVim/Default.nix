{ ... }: 

{
	imports = [
		#./kanagawa.nix
                ./one.nix
		./keymaps.nix
		./Plugins/Default.nix
	];
	programs.nixvim = {
		enable = true;
		enableMan = true;

		globalOpts = {
			relativenumber = true;
			conceallevel = 2;
		};


		globals.mapleader = " ";
	};
}
