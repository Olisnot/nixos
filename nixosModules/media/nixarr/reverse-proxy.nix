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
    sabnzbd = {
      enable = config.nixarr.sabnzbd.enable;
      port = config.nixarr.sabnzbd.guiPort;
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
  config = lib.mkIf config.arr.enable {
    caddyReverseProxy = {
      enable = true;
      hosts = caddyHosts;
    };
  };
}
