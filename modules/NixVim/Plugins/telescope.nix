{self, ... }: 

{
	programs.nixvim = {
		plugins = {
			telescope = {
				enable = true;
				keymaps = {
					"<leader>f" = "find_files";
					"<leader>gr" = "<cmd>Telescope live_grep<CR>";
				};
			};
		};
	};
}
