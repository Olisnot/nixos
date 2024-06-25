{self, ... }: 

{
	programs.nixvim = {
		plugins = {
			telescope = {
				enable = true;
				keymaps = {
					"<leader>f" = "find_files";
					"<leader>gr" = "builtin.grep_string({ search = vim.fn.input(\"Grep > \") }";
				};
			};
		};
	};
}
