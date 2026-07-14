{ lib, config, ... }:

let
  cfg = config.slskd;

  defaultSettings = {
    directories = {
      incomplete = cfg.incompleteDir;
      downloads = cfg.downloadsDir;
    };
    shares = {
      directories = cfg.shares;
      filters = [
        "\\.ini$"
        "Thumbs.db$"
        "\\.DS_Store$"
      ];
    };
    soulseek = {
      listen_port = cfg.listenPort;
      description = cfg.description;
    };
    web = {
      port = cfg.webPort;
      url_base = "/";
      https.disabled = true;
    };
  };
in
{
  options.slskd = {
    enable = lib.mkEnableOption "slskd Soulseek client";

    environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/slskd.env";
      description = "Environment file containing slskd credentials and API key secrets.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "oliver";
      description = "User account under which slskd runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "users";
      description = "Group under which slskd runs.";
    };

    musicDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/library/music";
      description = "Music library directory shared on Soulseek.";
    };

    downloadsDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/.state/soulsync/downloads";
      description = "Directory where completed slskd downloads are written.";
    };

    incompleteDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/.state/slskd/incomplete";
      description = "Directory where incomplete slskd downloads are written.";
    };

    shares = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "[Music]${cfg.musicDir}" ];
      defaultText = lib.literalExpression ''[ "[Music]${config.slskd.musicDir}" ]'';
      description = "Directories shared by slskd.";
    };

    webPort = lib.mkOption {
      type = lib.types.port;
      default = 5030;
      description = "Port for the slskd web interface.";
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 50300;
      description = "Soulseek listen port used for incoming peer connections.";
    };

    openWebFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the slskd web interface port in the firewall.";
    };

    openSoulseekFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the Soulseek listen port in the firewall.";
    };

    description = lib.mkOption {
      type = lib.types.str;
      default = "A slskd user. https://github.com/slskd/slskd";
      description = "Soulseek profile description.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Additional slskd settings merged into the generated configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.slskd = {
      enable = true;
      environmentFile = cfg.environmentFile;
      user = cfg.user;
      group = cfg.group;
      openFirewall = cfg.openSoulseekFirewall;
      settings = lib.recursiveUpdate defaultSettings cfg.settings;
    };

    systemd.tmpfiles.rules = [
      "d /data/media/library 0755 root root -"
      "d /data/media/.state/slskd 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.incompleteDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${cfg.downloadsDir} 0755 ${cfg.user} ${cfg.group} -"
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openWebFirewall [ cfg.webPort ];
  };
}
