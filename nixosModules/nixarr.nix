{ lib, config, ... }:

{
  options.arr.enable = lib.mkEnableOption "Enable arr stack";

  config = lib.mkIf config.arr.enable {
    nixarr = {
      enable = true;
      mediaDir = "/data/media";
      stateDir = "/data/media/.state/nixarr";

      jellyfin.enable = true;
      bazarr.enable = true;
      lidarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      readarr.enable = true;
      sonarr.enable = true;
      jellyseerr.enable = true;
    };
    services.flaresolverr.enable = true;
    services.qbittorrent.enable = true;
  };
}
