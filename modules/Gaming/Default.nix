{ pkgs, ... }:

{
	imports =
		[ 
			./Steam.nix
			./aagl.nix
		];
	programs.gamemode.enable = true;

	environment.systemPackages = with pkgs; [
		lutris
			steam-run
			heroic
			protonup-qt
			mangohud
	];
}
