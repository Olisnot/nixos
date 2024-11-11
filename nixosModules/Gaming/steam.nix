{ lib, config, pkgs, ... }:

{
  options = {
    gaming.steam.enable = lib.mkEnableOption "Enables steam and any extras";
  };

  config = lib.mkIf config.gaming.steam.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        gamescopeSession.enable = true;

        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };
  };

}
