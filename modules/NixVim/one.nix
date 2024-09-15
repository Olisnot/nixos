{ ... }: 

{
	programs.nixvim = {
		colorschemes.dracula-nvim = {
			enable = true;

                        settings = {
                          transparent_bg = true;
                        };
		};
	};
}
