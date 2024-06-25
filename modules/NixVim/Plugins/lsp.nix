{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			lsp = {
				enable = true;
				servers = {
					bashls.enable = true;
					cmake.enable = true;
					csharp-ls.enable = true;
					pylyzer = {
						enable = true;
						autostart = true;
					};
					rust-analyzer = { 
						enable = true;
						installCargo = true;
						installRustc = true;
					};
				};
			};
		};
	};
}
