{ ... }: 

{
	programs.nixvim = {
		plugins = {
			lsp = {
				enable = true;
                                keymaps = {
                                  diagnostic = {
                                    "<leader>i" = "open_float";
                                    "<leader>j" = "goto_next";
                                    "<leader>k" = "goto_prev";
                                  };
                                lspBuf = {
                                    K = "hover";
                                    gD = "references";
                                    gd = "definition";
                                    gi = "implementation";
                                    gt = "type_definition";
                                  };
                                };
				servers = {
					nil-ls.enable = true;

					bashls.enable = true;

					clangd.enable = true;

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
