{ lib, config, ... }:

let
  cfg = config.navidrome;
in
{
  options.navidrome = {
    enable = lib.mkEnableOption "Navidrome music server";

    musicFolder = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/library/music";
      description = "Directory containing the music library served by Navidrome.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4533;
      description = "Port for the Navidrome web interface.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the Navidrome web interface port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      openFirewall = cfg.openFirewall;
      settings = {
        Address = "0.0.0.0";
        Port = cfg.port;
        MusicFolder = cfg.musicFolder;
      };
    };
  };
}
