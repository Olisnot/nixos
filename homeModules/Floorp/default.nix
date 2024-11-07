{ lib, config, ... }:

{

  imports = [ 
    ./personal.nix
    ./work.nix
  ];

  options = {
    floorp.enable = lib.mkEnableOption "Enable floorp, policies and profiles";
  };

  config = lib.mkIf config.floorp.enable {
    programs.floorp = {
      enable = true;
      policies = {
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        DisableFeedbackCommands = true;
        NewTabPage = false;
        PasswordManagerEnabled = false;
        OfferToSaveLogins = false;
        ShowHomeButton = false;
      };
    };
  };
}
