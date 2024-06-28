{ ... }: 

{
	programs.nixvim = {
		colorschemes.kanagawa = {
			enable = true;
			settings = {
				transparent = true;
				background.dark = "dragon";

				colors = {
					theme = {
						all = {
							ui = {
								bg_gutter = "none";
							};
						};
					};
				};
			};
		};
	};
}
