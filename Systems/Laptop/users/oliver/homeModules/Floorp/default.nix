{ ... }:
 
{
  
  imports = [ 
    ./personal.nix
    ./work.nix
  ];
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
      OfferToSaveLoginsDefault = false;
      ShowHomeButton = false;
    };
  };
}
