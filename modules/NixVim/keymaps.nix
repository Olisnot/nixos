{self, ... }: 

{
	programs.nixvim = {
		keymaps = [

		{
			action = "<cmd>Ex<CR>";
			key = "<leader>e";
			mode = [ "n" ];
		}
		];
	};
}
