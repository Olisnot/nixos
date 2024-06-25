{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		keymaps = [
		{
			action = "vim.cmd.Ex";
			key = "<leader>e";
			mode = [ "n" ];
			options = {
				silent = true;
			};
		];
		};
	};
}
