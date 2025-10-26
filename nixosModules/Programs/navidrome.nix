{ config, lib, ... }:

{
  options = { navidrome.enable = lib.mkEnableOption "navidrome"; };

  config = lib.mkIf config.navidrome.enable {
    services.navidrome = {
      enable = true;
      openFirewall = true;
      user = "oliver";
      port = 4040;
      settings = { MusicFolder = "/mnt/1tb/Music/"; };
    };
  };
}
