{ lib, config, ... }:

{
  options.arr.enable = lib.mkEnableOption "Enable arr stack";

  config = lib.mkIf config.arr.enable {
    nixarr = {
      enable = true;
      mediaDir = "/data/media";
      stateDir = "/data/media/.state/nixarr";

      jellyfin = {
        enable = true;
        openFirewall = true;
      };
      bazarr.enable = true;
      lidarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      seerr.enable = true;
    };
    services.flaresolverr.enable = true;
    services.qbittorrent.enable = true;

    caddyReverseProxy = {
      enable = true;
      hosts."jellyfin.opmsonline.org" = {
        upstream = "127.0.0.1:8096";
        useInternalTls = true;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        8096
      ];
      checkReversePath = "loose";
    };
  };
}
