{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.romm;
  privateAppDirs = [
    "resources"
    "redis"
    "assets"
    "config"
    "library"
    "tmp"
  ];
in
{
  # Replace this module's original root/0755 rules for the fresh installation.
  # MariaDB changes mysql's ownership itself; colon fields initialize it only,
  # rather than chowning a live database back to root on subsequent rebuilds.
  systemd.tmpfiles.settings.rommDirs = lib.mkForce (
    {
      ${cfg.stateDir}.d = {
        mode = "0700";
        user = "root";
        group = "root";
      };
      "${cfg.stateDir}/mysql".d = {
        mode = ":0700";
        user = ":root";
        group = ":root";
      };
    }
    // lib.genAttrs (map (name: "${cfg.stateDir}/${name}") privateAppDirs) (_: {
      d = {
        mode = "0700";
        user = "1000";
        group = "media";
      };
    })
  );

  systemd.services.romm-library = {
    description = "Prepare RomM ROM storage only on the mounted Storage Box";
    unitConfig.RequiresMountsFor = [ "/srv/media" ];
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
      mkdir -p /srv/media/library/roms
    '';
  };
  systemd.services.docker-romm = {
    requires = [ "romm-library.service" ];
    after = [ "romm-library.service" ];
    partOf = [ "romm-library.service" ];
    unitConfig.RequiresMountsFor = [ "/srv/media" ];
  };
}
