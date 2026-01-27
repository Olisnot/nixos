{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.librewolf.enable = lib.mkEnableOption "librewolf web browser";

  config = lib.mkIf config.librewolf.enable {
    programs.librewolf = {
      enable = true;
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
          "layout.css.devPixelsPerPx" = "1.25";
          # "font.minimum-size.x-western" = 16;
        };
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            vimium
            libredirect
            youtube-recommended-videos
          ];

          settings = {
            "uBlock0@raymondhill.net".settings = { };
          };
        };
        search = {
          default = "ecosia";
          engines = {
            ecosia = {
              name = "ecosia";
              urls = [
                {
                  template = "https://www.ecosia.org/search?q={searchTerms}";
                }
              ];
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
