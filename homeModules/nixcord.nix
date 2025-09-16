{ config, pkgs, lib, inputs, ... }:

{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  options = { nixcord.enable = lib.mkEnableOption "Enables nixcord"; };

  config = lib.mkIf config.nixcord.enable {
    programs.nixcord = {
      enable = true; # Enable Nixcord (It also installs Discord)
      vesktop.enable = true; # Vesktop
      quickCss = ''
        :root {
            --background-solid: none; /* Adjusted transparency */
            --background-solid-dark: none; /* Adjusted transparency */
            --background-solid-darker: none; /* Adjusted transparency */
        }
      ''; # quickCSS file
      config = {
        useQuickCss = true; # use out quickCSS
        notifyAboutUpdates = false;
        transparent = true;
        themeLinks = [ # or use an online theme
        ];
        frameless = true; # Set some Vencord options
      };
      extraConfig = { };
    };
  };
}
