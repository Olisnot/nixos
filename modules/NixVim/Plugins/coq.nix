{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			coq-nvim = {
				enable = true;
				settings = {
					auto_start = true;
					keymap.recommended = true;
				};
			};
		};
	};
}
