{self, ... }: 

{
	programs.nixvim = {
		plugins = {
			telescope = {
				enable = true;
				keymaps = {
					"<leader>f" = "find_files";
				};
			};
		};
	};
}
