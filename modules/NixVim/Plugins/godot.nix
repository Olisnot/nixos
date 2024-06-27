{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			godot = {
				enable = true;
				godotPackage = pkgs.godot_4;
			};
		};
	};
}
