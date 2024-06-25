{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		colorschemes.kanagawa = {
			enable = true;
			settings = {
				transparent = true;
				theme = "dragon";
				background.dark = "dragon"
			};
		};
	};
}
