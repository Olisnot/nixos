{ config, lib, ... }:

{
  imports = [
    ../../../nixosModules/media/romm.nix
    ./credentials.nix
    ./storage.nix
    ./firewall.nix
    ./proxy.nix
  ];

  romm = {
    enable = true;
    # Immutable upstream multi-architecture digests verified at the registry.
    image = "rommapp/romm:5.4.1@sha256:8677fb7b81b1d3db20b849e989a1dadc2a11159e51eb34a2acdcb01102274edf";
    databaseImage = "mariadb:11.4@sha256:d1891ede5a559f1086f55053bb8cc1569b0298338c4d72d71725a7f74f6ba620";
    environmentFile = "/etc/romm/app.env";
    databaseEnvironmentFile = "/etc/romm/database.env";
    stateDir = "/var/lib/romm";
    # Only the nested roms mount is remote; no access to movies/music is given.
    libraryDir = "/var/lib/romm/library";
    extraVolumes = [
      "/srv/media/library/roms:/romm/library/roms"
      "/var/lib/romm/tmp:/romm/tmp"
    ];
    webPort = 8082; # 8081 belongs to SABnzbd on Olympus.
    bindAddress = "127.0.0.1";
    openFirewall = false;
    networkName = "romm-olympus";
    bridgeName = "br-romm";
    # Upstream supports non-root execution. Keep its UID, using the real media
    # GID so both backend and nginx workers can access the CIFS ROM files.
    user = "1000:${toString config.users.groups.media.gid}";
    extraOptions = [
      "--cap-drop=ALL"
      "--security-opt=no-new-privileges:true"
    ];
    environment = {
      ROMM_BASE_URL = "https://romm.opmsonline.org";
      ROMM_TMP_PATH = "/romm/tmp";
      ROMM_SESSION_SECURE_COOKIE = "true";
      DISABLE_DOWNLOAD_ENDPOINT_AUTH = "false";
      DISABLE_CSRF_PROTECTION = "false";
      KIOSK_MODE = "false";
      IPV4_ONLY = "true";
      LOGLEVEL = "WARNING"; # Upstream also disables nginx access logs at this level.
      DISABLE_LOGS_VIEWER = "true";
      SCAN_WORKERS = "2";
      WEB_SERVER_CONCURRENCY = "2";
      TZ = config.time.timeZone;
    };
  };

  assertions = [
    {
      assertion =
        config.users.groups.media.gid != null
        && config.romm.bindAddress == "127.0.0.1"
        && !config.romm.openFirewall
        && !(builtins.elem config.romm.webPort config.networking.firewall.allowedTCPPorts);
      message = "Olympus RomM needs a fixed media GID and a loopback-only, closed backend port.";
    }
  ];
}
