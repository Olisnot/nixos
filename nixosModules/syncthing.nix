{ lib, config, ... }:

{
  options = { syncthing.enable = lib.mkEnableOption "Enable Syncthing"; };

  config = lib.mkIf config.syncthing.enable {
    services = {
      syncthing = {
        enable = true;
        group = "users";
        user = "oliver";
        dataDir = "/home/oliver/Documents/Syncthing";
        configDir = "/home/oliver/Documents/.config/syncthing";
      };
    };
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  };
}
