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

    backendPort = lib.mkOption {
      type = lib.types.port;
      default = 8082;
      description = "Localhost port where Baikal's nginx virtual host listens.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.baikal = {
      enable = true;
      virtualHost = cfg.hostName;
    };

    services.nginx.virtualHosts.${cfg.hostName}.listen = [
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
      };
    };

    services.tailscale = {
      enable = true;
    };
  };
}
