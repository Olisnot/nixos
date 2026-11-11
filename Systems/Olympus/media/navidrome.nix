{ lib, ... }:

let
  musicFolder = "/srv/media/library/music";
in
{
  services.navidrome = {
    enable = true;
    group = "media";
    openFirewall = false;
    settings = {
      Address = "127.0.0.1";
      Port = 4533;
      MusicFolder = musicFolder;
      DataFolder = "/var/lib/navidrome";
      CacheFolder = "/var/cache/navidrome";
      LogLevel = "warn";
      EnableInsightsCollector = false;
    };
  };

  # The native module creates/manages MusicFolder via tmpfiles. Leave remote
  # directory creation to the mount-dependent media-layout unit instead: no
  # chown/chmod attempts or local fallback directories on an unavailable CIFS.
  systemd.tmpfiles.settings.navidromeDirs.${musicFolder} = lib.mkForce { };
}
