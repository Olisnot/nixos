{ lib, config, ... }:

let
  caddyDomain = "opmsonline.org";
  caddyServices = {
    jellyfin = {
      enable = config.nixarr.jellyfin.enable;
      port = config.nixarr.jellyfin.port;
    };
    navidrome = {
      enable = config.navidrome.enable;
      port = config.navidrome.port;
    };
    bazarr = {
      enable = config.nixarr.bazarr.enable;
      port = config.nixarr.bazarr.port;
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
    romm = {
      enable = config.romm.enable;
      port = config.romm.webPort;
    };
    soulsync = {
      enable = config.soulsync.enable;
      port = config.soulsync.webPort;
    };
    openwebui = {
      enable = config.open-webui.enable;
      port = config.services.open-webui.port;
    };
    trilium = {
      enable = config.trilium.enable;
      port = config.services.trilium-server.port;
    };
    sunshine = {
      enable = config.gaming.sunshine.enable;
      upstream = null;
      extraConfig = ''
        reverse_proxy https://127.0.0.1:47990 {
          transport http {
            tls_insecure_skip_verify
          }
        }
      '';
    };
    # freshrss = {
    #   enable = config.freshrss.enable;
    #   port = ;
    # };
  };

  caddyHosts = lib.mapAttrs' (name: service: {
    name = "${name}.${caddyDomain}";
    value = {
      upstream = service.upstream or "127.0.0.1:${toString service.port}";
      extraConfig = service.extraConfig or "";
    };
  }) (lib.filterAttrs (_name: service: service.enable) caddyServices);
in
{
  config = lib.mkIf config.arr.enable {
    caddyReverseProxy = {
      enable = true;
      openFirewall = false;
      tailscaleOnly = true;
      cloudflareDns.enable = true;
      hosts = caddyHosts;
    };
  };
}
