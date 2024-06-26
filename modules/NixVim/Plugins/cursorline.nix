{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			cursorline = {
				enable = true;
				cursorline = {
					enable = false;
				};
				cursorword = {
					enable = true;
				};
			};
		};
	};
}
