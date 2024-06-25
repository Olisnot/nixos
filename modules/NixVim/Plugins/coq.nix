{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			coq-nvim = {
				enable = true;
				settings = {
					keymap.recommended = true;
				};
			};
		};
	};
}
