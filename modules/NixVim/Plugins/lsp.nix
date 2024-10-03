{ ... }: 

{
	programs.nixvim = {
		plugins = {
			lsp = {
				enable = true;
				servers = {
					nil-ls.enable = true;

					bashls.enable = true;

					clangd.enable = true;

					cmake.enable = true;

                                        csharp-ls.enable = true;

                                        #omnisharp.enable = true;

					pylyzer = {
						enable = true;
						autostart = true;
					};

					rust-analyzer = { 
						enable = true;
						installCargo = true;
						installRustc = true;
					};

					gdscript.enable = true;

					marksman.enable = true;

                                        texlab.enable =true;

                                        ltex.enable = true;

                                        kotlin-language-server = {
                                          enable = true;
                                          autostart = true;
                                        };

				};
			};
		};
	};
}
