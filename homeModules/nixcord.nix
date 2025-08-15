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
        quickCss = ''
          :root {
              --background-solid: rgba(0, 15, 25, 0.3); /* Adjusted transparency */
              --background-solid-dark: rgba(0, 10, 20, 0.25); /* Adjusted transparency */
              --background-solid-darker: rgba(0, 5, 15, 0.2); /* Adjusted transparency */
          }
        '';  # quickCSS file
        config = {
          useQuickCss = true;   # use out quickCSS
          notifyAboutUpdates = false;
          transparent = true;
          themeLinks = [        # or use an online theme
          ];
          frameless = true;                   # Set some Vencord options
        };
        extraConfig = {
        };
      };
  };
}
