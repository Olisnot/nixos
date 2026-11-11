{
  config,
  lib,
  pkgs,
  ...
}:

let
  libraryServices = [
    "jellyfin"
    "navidrome"
    "sonarr"
    "radarr"
    "bazarr"
    "qbittorrent"
    "sabnzbd"
  ];
  privateServices = builtins.attrNames (import ./ports.nix);
in
{
  # Never use tmpfiles/chown/chmod recursively on the CIFS library. mkdir only,
  # after a real mount is available, prevents writing into a local fallback.
  # Keep application state private even though library access uses media group.
  systemd.tmpfiles.rules = [
    "d ${config.services.qbittorrent.profileDir} 0700 qbittorrent media -"
  ];
  systemd.services = lib.mkMerge [
    {
      media-layout = {
        description = "Create media library and download folders on the Storage Box";
        wantedBy = [ "multi-user.target" ];
        unitConfig = {
          RequiresMountsFor = "/srv/media";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          UMask = "0007";
        };
        path = [
          pkgs.util-linux
          pkgs.coreutils
        ];
        script = ''
          findmnt --noheadings --types cifs --mountpoint /srv/media >/dev/null
          mkdir -p /srv/media/library/movies /srv/media/library/shows /srv/media/library/music \
            /srv/media/downloads/torrents/complete /srv/media/downloads/torrents/incomplete \
            /srv/media/downloads/usenet/complete /srv/media/downloads/usenet/incomplete
        '';
      };
    }
    (lib.genAttrs libraryServices (_: {
      requires = [ "media-layout.service" ];
      after = [ "media-layout.service" ];
      # Changing the layout (for example adding this music folder) must bring
      # its dependent applications back up, not only stop them via Requires.
      partOf = [ "media-layout.service" ];
      unitConfig.RequiresMountsFor = [ "/srv/media" ];
      serviceConfig = {
        UMask = lib.mkForce "0007";
        StateDirectoryMode = "0700";
      };
    }))
    (lib.genAttrs privateServices (_: {
      requires = [ "wg-quick-wg0.service" ];
      after = [ "wg-quick-wg0.service" ];
      partOf = [ "wg-quick-wg0.service" ];
    }))
  ];
}
