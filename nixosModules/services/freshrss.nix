{ lib, config, ... }:

{
  options.freshrss.enable = lib.mkEnableOption "Enable freshrss service";

  config = lib.mkIf config.freshrss.enable {
    services.freshrss = {
      enable = true;
      webserver = "caddy";
      virtualHost = "freshrss.opmsonline.org";
      baseUrl = "https://freshrss.opmsonline.org";
      passwordFile = "/etc/secrets/freshrss";
      api.enable = true;
      user = "freshrss";
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "freshrss" ];
      ensureUsers = [
        {
          name = "freshrss";
          ensureDBOwnership = true;
        }
      ];
    };

    caddyReverseProxy = {
      enable = true;
      openFirewall = false;
      tailscaleOnly = true;
      cloudflareDns.enable = true;
      hosts."freshrss.opmsonline.org".upstream = null;
    };
  };
}
