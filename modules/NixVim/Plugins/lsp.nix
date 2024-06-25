{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			lsp = {
				enable = true;
				servers = {
					bashls.enable = true;
				};
			};
		};
	};
}
