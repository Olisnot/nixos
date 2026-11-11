{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    {
      environment.systemPackages = [ pkgs.cifs-utils ];
      # Preserve Olympus's existing media GID, now also used inside RomM.
      users.groups.media.gid = 993;

      fileSystems."/srv/media" = {
        device = "//u715484.your-storagebox.de/backup";
        fsType = "cifs";
        options = [
          # Runtime secret, already provisioned on Olympus. Never import it into Nix.
          "credentials=/etc/storagebox/media.credentials"
          "seal"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.mount-timeout=30s"
          "gid=media"
          "forcegid"
          "file_mode=0660"
          "dir_mode=0770"
          # This is data storage, not a source of executable or device files.
          "nosuid"
          "nodev"
          "noexec"
        ];
      };
    }

    # Prepare access/dependencies without enabling Jellyfin or creating its user
    # before the service is explicitly configured on Olympus.
    (lib.mkIf config.services.jellyfin.enable {
      users.users.jellyfin.extraGroups = [ "media" ];
      systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/srv/media";
    })
  ];
}
