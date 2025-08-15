{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  options = {
    nixcord.enable = lib.mkEnableOption "Enables nixcord";
  };

  config = lib.mkIf config.nixcord.enable {
    programs.nixcord = {
        enable = true;          # Enable Nixcord (It also installs Discord)
        vesktop.enable = true;  # Vesktop
        quickCss = "some CSS";  # quickCSS file
        config = {
          useQuickCss = true;   # use out quickCSS
          notifyAboutUpdates = false;
          transparent = true;
          themeLinks = [        # or use an online theme
            "https://capnkitten.github.io/BetterDiscord/Themes/Translucence/css/source.css"
          ];
          frameless = true;                   # Set some Vencord options
        };
        extraConfig = {
        };
      };
  };
}
