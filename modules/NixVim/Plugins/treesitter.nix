{ ... }: 

{
	programs.nixvim = {
		plugins = {
			treesitter = {
				enable = true;
				ensure_installed = "all";
			};
		};
	};
}
