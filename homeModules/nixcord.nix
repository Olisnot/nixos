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
          @import url('https://DiscordStyles.github.io/DarkMatter/src/base.css');

          /* Variables */
          :root {
              --avatar-size: 32px;
              --home-image: url('https://i.imgur.com/233d55Y.gif');
              --background-solid: rgba(0, 15, 25, 0.3); /* Adjusted transparency */
              --background-solid-dark: rgba(0, 10, 20, 0.25); /* Adjusted transparency */
              --background-solid-darker: rgba(0, 5, 15, 0.2); /* Adjusted transparency */
              --accent: 37, 172, 232;
              --accent-alt: 29, 101, 134;
          }

          /* Apply transparent backgrounds to necessary elements */
          body, .app, .container, .container-3baos1, .layer, .layer-3QrUeG {
              background-color: var(--background-solid-dark) !important; /* Apply the darker transparent background */
          }

          .sidebar, .sidebar-1tnWFu, .channels, .members, .content, .container-2o3qEW {
              background-color: var(--background-solid-darker) !important; /* Apply the darkest transparent background */
          }

          /* Additional transparency for specific elements */
          .header, .header-2Mx0tC, .title, .title-3FQ39c {
              background-color: var(--background-solid) !important; /* Apply the solid transparent background */
          }

          /* Remove existing background images */
          body, .app, .container, .container-3baos1, .layer, .layer-3QrUeG,
          .sidebar, .sidebar-1tnWFu, .channels, .members, .content, .container-2o3qEW,
          .header, .header-2Mx0tC, .title, .title-3FQ39c {
              background-image: none !important;
          }
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
