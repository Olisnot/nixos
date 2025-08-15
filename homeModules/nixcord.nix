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
        enable = true;
        vesktop.enable = true;
        quickCss = ''
          --background-solid: #16192129;
          --background-solid-dark: #10121836;
          --background-solid-darker: #0c0e123c;
        '';  # quickCSS file

        config = {
          useQuickCss = true;   # use out quickCSS
          notifyAboutUpdates = false;
          transparent = true;
          frameless = true;                   # Set some Vencord options
        };
        extraConfig = {
        };
      };
  };
}
