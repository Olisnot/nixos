{ lib, config, ... }:

{
  options.open-webui = {
    enable = lib.mkEnableOption "Enable open-webui for self hosted AI chat";
    hostName = lib.mkOption {
      type = lib.types.str;
      example = "openwebui.example.org";
      description = "Hostname Caddy should serve Open WebUI on.";
    };
  };

  config = lib.mkIf config.open-webui.enable {
    services.open-webui = {
      enable = true;
      openFirewall = true;
      port = 8085;
    };

    nixpkgs.config.allowUnfreePackages = [
      "open-webui"
    ];
  };
}
