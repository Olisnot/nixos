{ ... }: 

{
	programs.nixvim = {
		plugins = {
			coq-nvim = {
				enable = true;
				settings = {
					keymap.recommended = true;
					auto_start = true;
					xdg = true;
				};
			};
		};
	};
}
