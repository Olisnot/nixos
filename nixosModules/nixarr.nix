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
      sabnzbd.enable = true;
      recyclarr.enable = true;
    };
    services.flaresolverr.enable = true;
    services.qbittorrent.enable = true;
    users.users.qbittorrent.extraGroups = [ "media" ];

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

    nixarr.recyclarr.configuration = {
      sonarr = {
        series = {
          base_url = "http://localhost:8989";
          api_key = "!env_var SONARR_API_KEY";
          quality_definition = {
            type = "series";
          };
          delete_old_custom_formats = true;
          custom_formats = [
            {
              trash_ids = [
                "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
                "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
              ];
              assign_scores_to = [
                {
                  name = "WEB-DL (1080p)";
                  score = -10000;
                }
              ];
            }
          ];
        };
      };
      radarr = {
        movies = {
          base_url = "http://localhost:7878";
          api_key = "!env_var RADARR_API_KEY";
          quality_definition = {
            type = "movie";
          };
          delete_old_custom_formats = true;
          custom_formats = [
            {
              trash_ids = [
                "570bc9ebecd92723d2d21500f4be314c" # Remaster
                "eca37840c13c6ef2dd0262b141a5482f" # 4K Remaster
              ];
              assign_scores_to = [
                {
                  name = "HD Bluray + WEB";
                  score = 25;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
