{ lib, config, ... }:

let
  caddyDomain = "opmsonline.org";
  caddyServices = {
    jellyfin = {
      enable = config.nixarr.jellyfin.enable;
      port = config.nixarr.jellyfin.port;
    };
    bazarr = {
      enable = config.nixarr.bazarr.enable;
      port = config.nixarr.bazarr.port;
    };
    lidarr = {
      enable = config.nixarr.lidarr.enable;
      port = config.nixarr.lidarr.port;
    };
    prowlarr = {
      enable = config.nixarr.prowlarr.enable;
      port = config.nixarr.prowlarr.port;
    };
    radarr = {
      enable = config.nixarr.radarr.enable;
      port = config.nixarr.radarr.port;
    };
    sonarr = {
      enable = config.nixarr.sonarr.enable;
      port = config.nixarr.sonarr.port;
    };
    seerr = {
      enable = config.nixarr.seerr.enable;
      port = config.nixarr.seerr.port;
    };
    qbittorrent = {
      enable = config.services.qbittorrent.enable;
      port = 8080;
    };
  };

  caddyHosts = lib.mapAttrs' (name: service: {
    name = "${name}.${caddyDomain}";
    value = {
      upstream = "127.0.0.1:${toString service.port}";
      useInternalTls = true;
    };
  }) (lib.filterAttrs (_name: service: service.enable) caddyServices);
in
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
      hosts = caddyHosts;
    };

    networking.firewall = {
      allowedTCPPorts = [
        8096
      ];
      checkReversePath = "loose";
    };
  };
}
