{ lib, config, pkgs, ... }:

{
  options.librewolf.enable = lib.mkEnableOption "librewolf web browser";

  config = lib.mkIf config.librewolf.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf-bin;
      profiles."default" = {
        name = "default";
        id = 0;
        settings = {
          "browser.startup.page" = 3;
          "browser.toolbars.bookmarks.visibility" = "never";
          "extensions.autoDisableScopes" = 0;
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            vimium
            libredirect
            youtube-recommended-videos
            proton-vpn
          ];

          settings = { "uBlock0@raymondhill.net".settings = { }; };
        };
        search = {
          default = "ecosia";
          engines = {
            ecosia = {
              name = "ecosia";
              urls = [{
                template = "https://www.ecosia.org/search?q={searchTerms}";
              }];
            };
          };
        };
      };
    };

    stylix.targets.librewolf = {
      enable = true;
      profileNames = [ "default" ];
    };
  };
}
