{ lib, config, ... }:

let
  cfg = config.baikal;
in
{
  options.baikal = {
    enable = lib.mkEnableOption "Enable Baikal";

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Hostname Caddy should serve Baikal on.";
      example = "baikal.example.org";
    };

    internalHost = lib.mkOption {
      type = lib.types.str;
      default = "baikal.internal";
      description = "Internal nginx virtual host name used by Baikal.";
    };

    backendPort = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "Localhost port where Baikal's nginx virtual host listens.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.baikal = {
      enable = true;
      virtualHost = cfg.internalHost;
    };

    services.nginx.virtualHosts.${cfg.internalHost}.listen = [
      {
        addr = "127.0.0.1";
        port = cfg.backendPort;
      }
    ];

    caddyReverseProxy = {
      enable = true;
      openFirewall = false;
      tailscaleOnly = true;
      cloudflareDns.enable = true;
      hosts.${cfg.hostName} = {
        upstream = "127.0.0.1:${toString cfg.backendPort}";
        reverseProxyExtraConfig = ''
          header_up Host ${cfg.internalHost}
        '';
      };
    };

    services.tailscale = {
      enable = true;
    };
  };
}
