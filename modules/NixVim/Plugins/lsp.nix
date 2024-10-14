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

					pylyzer = {
						enable = true;
						autostart = true;
					};

					marksman.enable = true;
				};
			};
		};
	};
}
