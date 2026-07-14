{ lib, config, ... }:

let
  cfg = config.soulsync;

  stateDirs = [
    "config"
    "logs"
    "downloads"
    "Staging"
    "scripts"
  ];

  mediaDirs = [
    "library"
    "MusicVideos"
    "Movies"
    "TV"
    "YouTube"
  ];

  owner = toString cfg.uid;
  group = toString cfg.gid;
in
{
  options.soulsync = {
    enable = lib.mkEnableOption "SoulSync media web UI";

    image = lib.mkOption {
      type = lib.types.str;
      default = "boulderbadgedad/soulsync:latest";
      description = "Container image to use for SoulSync.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/.state/soulsync";
      description = "Host directory used for SoulSync config, logs, downloads, and app state bind mounts.";
    };

    mediaDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media";
      description = "Host directory used for SoulSync media output bind mounts.";
    };

    musicDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/library/music";
      description = "Host directory mounted as SoulSync's music transfer output.";
    };

    uid = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = "User ID passed to SoulSync as PUID.";
    };

    gid = lib.mkOption {
      type = lib.types.int;
      default = 1000;
      description = "Group ID passed to SoulSync as PGID.";
    };

    umask = lib.mkOption {
      type = lib.types.str;
      default = "022";
      description = "UMASK passed to SoulSync.";
    };

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = config.time.timeZone;
      defaultText = lib.literalExpression "config.time.timeZone";
      description = "Timezone passed to SoulSync as TZ.";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 8008;
      description = "Host port for the SoulSync web interface.";
    };

    spotifyCallbackPort = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = "Host and container port for the Spotify OAuth callback.";
    };

    tidalCallbackPort = lib.mkOption {
      type = lib.types.port;
      default = 8889;
      description = "Host and container port for the Tidal OAuth callback.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open SoulSync ports in the local firewall.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional or overriding environment variables for the SoulSync container.";
    };

    extraVolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional Docker volume mounts for the SoulSync container.";
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional options passed to docker run for the SoulSync container.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers."soulsync-webui" = {
      image = cfg.image;
      autoStart = true;
      environment = {
        PUID = owner;
        PGID = group;
        UMASK = cfg.umask;
        PYTHONPATH = "/app";
        SOULSYNC_CONFIG_PATH = "/app/config/config.json";
        TZ = cfg.timeZone;
        SOULSYNC_SPOTIFY_CALLBACK_PORT = toString cfg.spotifyCallbackPort;
        SOULSYNC_TIDAL_CALLBACK_PORT = toString cfg.tidalCallbackPort;
      }
      // cfg.environment;
      ports = [
        "${toString cfg.webPort}:8008"
        "${toString cfg.spotifyCallbackPort}:${toString cfg.spotifyCallbackPort}"
        "${toString cfg.tidalCallbackPort}:${toString cfg.tidalCallbackPort}"
      ];
      volumes = [
        "${cfg.stateDir}/config:/app/config"
        "${cfg.stateDir}/logs:/app/logs"
        "${cfg.stateDir}/downloads:/app/downloads"
        "${cfg.stateDir}/Staging:/app/Staging"
        "${cfg.stateDir}/scripts:/app/scripts"
        "${cfg.musicDir}:/app/Transfer"
        "${cfg.mediaDir}/MusicVideos:/app/MusicVideos"
        "${cfg.mediaDir}/Movies:/media/movies"
        "${cfg.mediaDir}/TV:/media/tv"
        "${cfg.mediaDir}/YouTube:/media/youtube"
        "soulsync_database:/app/data"
      ]
      ++ cfg.extraVolumes;
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
        "--health-cmd=curl -f http://localhost:8008/ || exit 1"
        "--health-interval=30s"
        "--health-timeout=10s"
        "--health-retries=3"
        "--health-start-period=60s"
        "--cpus=2.0"
        "--memory=2g"
        "--memory-reservation=512m"
      ]
      ++ cfg.extraOptions;
    };

    systemd.tmpfiles.rules =
      (map (dir: "d ${cfg.stateDir}/${dir} 0755 ${owner} ${group} -") stateDirs)
      ++ (map (dir: "d ${cfg.mediaDir}/${dir} 0755 ${owner} ${group} -") mediaDirs)
      ++ [ "d ${cfg.musicDir} 0755 ${owner} ${group} -" ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.webPort
      cfg.spotifyCallbackPort
      cfg.tidalCallbackPort
    ];
  };
}
