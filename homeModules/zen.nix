{ inputs, lib, config, ... }:

{
  options = {
    zen-browser.enable = lib.mkEnableOption "Enable zen browser";
  };

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = lib.mkIf config.zen-browser.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        OfferToSaveLogins = false;
      };
    };
  };
}
