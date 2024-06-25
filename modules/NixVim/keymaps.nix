{self, ... }: 

{
	programs.nixvim = {
		keymaps = [

		{
			action = "<cmd>Ex<CR>";
			key = "<leader>e";
			mode = [ "n" ];
		}
		{
			action = "<cmd> lua function() builtin.grep_string({ search = vim.fn.input(\"Grep > \") }); end <CR>";
			key = "<leader>gr";
			mode = [ "n" ];
		}
		];
	};
}
