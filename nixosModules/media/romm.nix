{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.romm;
  docker = "${config.virtualisation.docker.package}/bin/docker";
in
{
  options.romm = {
    enable = lib.mkEnableOption "RomM game library manager";

    image = lib.mkOption {
      type = lib.types.str;
      default = "rommapp/romm:latest";
      description = "Container image to use for RomM.";
    };

    databaseImage = lib.mkOption {
      type = lib.types.str;
      default = "mariadb:latest";
      description = "Container image to use for the RomM MariaDB database.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/romm.env";
      description = "Environment file containing RomM and MariaDB secrets.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/.state/romm";
      description = "Host directory used for RomM state, database, resources, cache, assets, and config.";
    };

    libraryDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/1tb/Emulation";
      description = "Host directory mounted as the RomM library root.";
    };

    assetsDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.stateDir}/assets";
      defaultText = lib.literalExpression ''"${config.romm.stateDir}/assets"'';
      description = "Host directory where RomM stores uploaded saves, states, and other assets.";
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.stateDir}/config";
      defaultText = lib.literalExpression ''"${config.romm.stateDir}/config"'';
      description = "Host directory where RomM stores config.yml.";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = "Host port for the RomM web interface.";
    };

    databaseName = lib.mkOption {
      type = lib.types.str;
      default = "romm";
      description = "MariaDB database name used by RomM.";
    };

    databaseUser = lib.mkOption {
      type = lib.types.str;
      default = "romm-user";
      description = "MariaDB user used by RomM.";
    };

    networkName = lib.mkOption {
      type = lib.types.str;
      default = "romm";
      description = "Docker network used by the RomM containers.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the RomM web interface port in the local firewall.";
    };

    hasheousApiEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Hasheous metadata provider.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional or overriding environment variables for the RomM container.";
    };

    extraVolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional Docker volume mounts for the RomM container.";
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional options passed to docker run for the RomM container.";
    };

    databaseExtraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional options passed to docker run for the MariaDB container.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers = {
      "romm-db" = {
        image = cfg.databaseImage;
        autoStart = true;
        environment = {
          MARIADB_DATABASE = cfg.databaseName;
          MARIADB_USER = cfg.databaseUser;
        };
        environmentFiles = [ cfg.environmentFile ];
        volumes = [
          "${cfg.stateDir}/mysql:/var/lib/mysql"
        ];
        extraOptions = [
          "--network=${cfg.networkName}"
          "--health-cmd=healthcheck.sh --connect --innodb_initialized"
          "--health-start-period=30s"
          "--health-interval=10s"
          "--health-timeout=5s"
          "--health-retries=5"
        ]
        ++ cfg.databaseExtraOptions;
      };

      romm = {
        image = cfg.image;
        autoStart = true;
        dependsOn = [ "romm-db" ];
        environment = {
          DB_HOST = "romm-db";
          DB_NAME = cfg.databaseName;
          DB_USER = cfg.databaseUser;
          HASHEOUS_API_ENABLED = lib.boolToString cfg.hasheousApiEnabled;
        }
        // cfg.environment;
        environmentFiles = [ cfg.environmentFile ];
        ports = [
          "${toString cfg.webPort}:8080"
        ];
        volumes = [
          "${cfg.stateDir}/resources:/romm/resources"
          "${cfg.stateDir}/redis:/redis-data"
          "${cfg.libraryDir}:/romm/library"
          "${cfg.assetsDir}:/romm/assets"
          "${cfg.configDir}:/romm/config"
        ]
        ++ cfg.extraVolumes;
        extraOptions = [
          "--network=${cfg.networkName}"
        ]
        ++ cfg.extraOptions;
      };
    };

    systemd.services = {
      romm-docker-network = {
        description = "Create RomM Docker network";
        after = [ "docker.service" ];
        before = [
          "docker-romm-db.service"
          "docker-romm.service"
        ];
        requiredBy = [
          "docker-romm-db.service"
          "docker-romm.service"
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${docker} network inspect ${lib.escapeShellArg cfg.networkName} >/dev/null 2>&1 \
            || ${docker} network create ${lib.escapeShellArg cfg.networkName}
        '';
      };

      "docker-romm" = {
        after = [ "docker-romm-db.service" ];
        requires = [ "docker-romm-db.service" ];
        unitConfig.RequiresMountsFor = [ cfg.libraryDir ];
        preStart = ''
          attempts=0
          while [ "$attempts" -lt 60 ]; do
            status="$(${docker} inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' romm-db 2>/dev/null || true)"
            if [ "$status" = "healthy" ]; then
              exit 0
            fi
            attempts=$((attempts + 1))
            sleep 2
          done

          echo "Timed out waiting for romm-db to become healthy" >&2
          exit 1
        '';
      };

      romm-env-restart = {
        description = "Restart RomM after its environment file changes";
        serviceConfig.Type = "oneshot";
        script = ''
          ${pkgs.systemd}/bin/systemctl restart docker-romm.service
        '';
      };
    };

    systemd.paths.romm-env-restart = {
      description = "Watch RomM environment file for changes";
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathChanged = cfg.environmentFile;
        Unit = "romm-env-restart.service";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0755 root root -"
      "d ${cfg.stateDir}/mysql 0755 root root -"
      "d ${cfg.stateDir}/resources 0755 root root -"
      "d ${cfg.stateDir}/redis 0755 root root -"
      "d ${cfg.assetsDir} 0755 root root -"
      "d ${cfg.configDir} 0755 root root -"
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.webPort ];
  };
}
