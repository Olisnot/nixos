{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			treesitter = {
				enable = true;
				ensureInstalled = "all";
			};
		};
	};
}
