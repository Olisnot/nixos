{ lib, config, ... }:

let
  cfg = config.caddyReverseProxy;
in
{
  options.caddyReverseProxy = {
    enable = lib.mkEnableOption "Enable Caddy reverse proxy";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open HTTP and HTTPS ports for Caddy.";
    };

    hosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              upstream = lib.mkOption {
                type = lib.types.str;
                description = "Upstream address Caddy should reverse proxy to.";
              };

              useInternalTls = lib.mkOption {
                type = lib.types.bool;
                default = lib.hasSuffix ".local" name;
                description = "Use Caddy's internal CA for local-only domains.";
              };

              extraConfig = lib.mkOption {
                type = lib.types.lines;
                default = "";
                description = "Extra Caddy directives for this virtual host.";
              };
            };
          }
        )
      );
      default = { };
      description = "Virtual hosts to reverse proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts = lib.mapAttrs (_host: proxy: {
        extraConfig = ''
          ${lib.optionalString proxy.useInternalTls "tls internal"}
          reverse_proxy ${proxy.upstream}
          ${proxy.extraConfig}
        '';
      }) cfg.hosts;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];
  };
}
