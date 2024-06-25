{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		keymaps = [

		{
			action = "<cmd>Ex";
			key = "<leader>e";
			mode = [ "n" ];
		}

		];
	};
}
