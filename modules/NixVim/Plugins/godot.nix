{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			godot = {
				enable = true;
			};
		};
	};
}
