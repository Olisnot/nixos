{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			harpoon = {
				enable = true;
			};
		};
	};
}
