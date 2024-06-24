{ pkgs, inputs, ... }: 

{
    programs.nixvim = {
        enable = true;
        enableMan = true;
        colorschemes.kanagawa.enable = true;

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
