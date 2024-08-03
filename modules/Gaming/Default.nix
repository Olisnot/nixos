{ pkgs, ... }:

{
	imports =
		[ 
			./Steam.nix
                        #./aagl.nix
		];
	programs.gamemode.enable = true;
        hardware.xpadneo.enable = true;

	environment.systemPackages = with pkgs; [
                        lutris
			steam-run
			heroic
			protonup-qt
			mangohud

                        #Emulation
                        retroarch
                        rpcs3
	];
}
