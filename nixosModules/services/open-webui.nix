{ lib, config, ... }:

{
  options.open-webui.enable = lib.mkEnableOption "Enable open-webui for self hosted AI chat";

  config = lib.mkIf config.open-webui.enable {
    services.open-webui.enable = true;

    nixpkgs.config.allowUnfreePackages = [
      "open-webui"
    ];
  };
}
