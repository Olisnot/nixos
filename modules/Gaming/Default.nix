{ pkgs, config, libs, inputs, ... }:

{
	imports =
		[ 
          ./Steam.nix
          ./aagl.nix
		];
}
