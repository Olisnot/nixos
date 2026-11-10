{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.caddyReverseProxy;
in
{
  options.caddyReverseProxy.waf.enable = lib.mkEnableOption "Coraza with embedded OWASP CRS for every configured proxy hostname";

  config = lib.mkIf (cfg.enable && cfg.waf.enable) {
    assertions = [
      {
        assertion = !cfg.cloudflareDns.enable;
        message = "Coraza's verified plugin build does not include Cloudflare DNS. A combined plugin build needs its own verified dependency hash.";
      }
    ];

    services.caddy = {
      package = import ./caddy-coraza-package.nix { inherit pkgs; };
      globalConfig = ''
        order coraza_waf first
        # HTTP/3 is deliberately disabled; only TCP 80/443 is opened.
        servers {
          protocols h1 h2
        }
        log waf {
          include http.handlers.waf
          level INFO
          output stderr
          format filter {
            wrap json {
              message_key ""
              stacktrace_key ""
            }
            fields {
              uri delete
              request delete
              error delete
              client_ip delete
              hostname delete
            }
          }
        }
      '';

      # The plugin's error callback includes matched values in the message.
      # Keep it out of the default logger, including in blocking mode.
      logFormat = lib.mkForce ''
        exclude http.handlers.waf
        level INFO
        output stderr
        format filter {
          wrap json {
            message_key ""
            stacktrace_key ""
          }
          fields {
            request delete
            uri delete
            error delete
          }
        }
      '';

      virtualHosts = lib.mapAttrs (_hostname: host: {
        # NixOS enables per-host access logs by default; explicitly disable them.
        logFormat = lib.mkForce null;
        extraConfig = lib.mkBefore ''
          coraza_waf {
            load_owasp_crs
            directives `
              Include @coraza.conf-recommended
              Include @crs-setup.conf.example
              ${host.waf.beforeRules}
              Include @owasp_crs/*.conf
              ${host.waf.afterRules}
              SecRuleEngine ${host.waf.mode}
              SecAuditEngine Off
              SecDebugLogLevel 0
              # Do not buffer/inspect large media responses or range responses.
              SecResponseBodyAccess Off
            `
          }
        '';
      }) cfg.hosts;
    };
  };
}
