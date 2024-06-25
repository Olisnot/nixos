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
			action = function() builtin.grep_string({ search = vim.fn.input("Grep > ") }); end;
			key = "<leader>gg";
			mode = [ "n" ];
		}
		];
	};
}
