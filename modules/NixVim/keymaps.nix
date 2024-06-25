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
			action = "<cmd>Telescope live_grep<CR>";
			key = "<leader>gr";
			mode = [ "n" ];
		}
		];
	};
}
