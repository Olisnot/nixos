{ lib, config, ... }:

{
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

    services.sabnzbd.settings.misc.host_whitelist = lib.mkForce "zeus,sabnzbd.opmsonline.org";

    services.flaresolverr.enable = true;
    services.qbittorrent.enable = true;
    users.users.qbittorrent.extraGroups = [ "media" ];

    networking.firewall = {
      allowedTCPPorts = [
        8096
      ];
      checkReversePath = "loose";
    };
  };
}
