{ pkgs, inputs, ... }: 

{
	programs.nixvim = {
		plugins = {
			godot = {
				enable = true;
				godotPackage = pkgs.godot_4;
				settings = {
					executable = pkgs.godot_4;
				};
			};
		};
	};
}
