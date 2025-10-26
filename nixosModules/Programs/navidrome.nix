{ config, lib, ... }:

{
  options = { navidrome.enable = lib.mkEnableOption "navidrome"; };

  config = lib.mkIf config.navidrome.enable {
    services.navidrome = {
      enable = true;
      openFirewall = true;
      user = "oliver";
      settings = { Address = "0.0.0.0"; MusicFolder = "/mnt/1tb/Music/"; };
    };
  };
}
