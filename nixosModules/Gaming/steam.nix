{ lib, config, pkgs, inputs, ... }:

{
  options = {
    gaming.steam.enable = lib.mkEnableOption "Enables steam and any extras";
  };


  config = lib.mkIf config.gaming.steam.enable {
    programs = {
      steam = {
        enable = true;
        package = inputs.millennium.packages."x86_64-linux".default;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        #gamescopeSession.enable = true;

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
