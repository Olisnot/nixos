{ pkgs, config, libs, inputs, ... }:

{

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            gamescopeSession.enable = true;
    };
    
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
            lutris
            steam-run
			heroic
			protonup-qt
            mangohud
    ];
}
