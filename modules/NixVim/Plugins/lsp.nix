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

                                        #csharp-ls.enable = true;

                                        omnisharp = {
                                          enable = true;
                                          settings = {
                                            callback = {
                                              __raw = ''
                                                function()
                                                print('nixvim')
                                                end
                                              '';
                                            };
                                            foo_bar = 42;
                                            hostname = "localhost:8080";
                                          };

                                        };

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
                                          filetypes = [ "kt" ];
                                        };

				};
			};
		};
	};
}
