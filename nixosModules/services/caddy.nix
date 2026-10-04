{
  lib,
  config,
  pkgs,
  ...
}:

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

    tailscaleOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only open HTTPS for Caddy on the Tailscale interface.";
    };

    tailscaleInterface = lib.mkOption {
      type = lib.types.str;
      default = "tailscale0";
      description = "Network interface used for Tailscale-only Caddy access.";
    };

    cloudflareDns = {
      enable = lib.mkEnableOption "Cloudflare DNS-01 ACME certificates for Caddy";

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = "/etc/caddy/cloudflare.env";
        description = "Environment file containing CLOUDFLARE_API_TOKEN for Caddy.";
      };
    };

    hosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              upstream = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                description = "Upstream address Caddy should reverse proxy to, or null for a virtual host managed by another module.";
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
      description = "Virtual hosts for Caddy to secure and optionally reverse proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = lib.mkIf cfg.cloudflareDns.enable (
        pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
          hash = "sha256-Oirb6ZtU/c6C/SfICWpfBAEGDTepWShPQdWW0LlhF20=";
        }
      );
      environmentFile = lib.mkIf cfg.cloudflareDns.enable cfg.cloudflareDns.environmentFile;
      virtualHosts = lib.mapAttrs (_host: proxy: {
        extraConfig = ''
          ${lib.optionalString proxy.useInternalTls "tls internal"}
          ${lib.optionalString (cfg.cloudflareDns.enable && !proxy.useInternalTls) ''
            tls {
              dns cloudflare {env.CLOUDFLARE_API_TOKEN}
              propagation_delay 60s
              propagation_timeout -1
              resolvers 1.1.1.1 1.0.0.1 8.8.8.8
            }
          ''}
          ${lib.optionalString (proxy.upstream != null) "reverse_proxy ${proxy.upstream}"}
          ${proxy.extraConfig}
        '';
      }) cfg.hosts;
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];

    networking.firewall.interfaces.${cfg.tailscaleInterface}.allowedTCPPorts =
      lib.mkIf cfg.tailscaleOnly
        [ 443 ];

    systemd.tmpfiles.rules = lib.mkIf cfg.cloudflareDns.enable [
      "d /etc/caddy 0750 root caddy -"
      "z /etc/caddy 0750 root caddy -"
    ];
  };
}
