{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			neoscroll = {
				enable = true;
			};
		};
	};
}
