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
    };
  };
}
