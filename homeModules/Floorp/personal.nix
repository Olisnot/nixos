{ pkgs, ... }:
 
{
  programs.floorp.profiles.Personal = {
    name = "Personal";
    isDefault = true;
    search.default = "DuckDuckGo";
    bookmarks = [
      {
        toolbar = true;
        bookmarks = [
          {
            name = "YouTube";
            keyword = "youtube";
            url = "https://www.youtube.com/";
          }
          {
            name = "Twitch";
            keyword = "twitch";
            url = "http://www.twitch.tv/";
          }
          {
            name = "HiAnime";
            keyword = "anime";
            url = "https://hianime.to/home";
          }
          {
            name = "AniList";
            keyword = "anilist";
            url = "https://anilist.co/home";
          }
          {
            name = "Reddit";
            keyword = "reddit";
            url = "https://www.reddit.com/";
          }
          {
            name = "GitHub";
            keyword = "github";
            url = "https://github.com/";
          }
        ];
    }
    ];

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      ublock-origin
      steam-database
      youtube-recommended-videos
    ];

    settings = {
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.startup.page" = 3;
      "browser.newtabpage.pinned" = "[]";
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "floorp.browser.sidebar.useIconProvider" = "DuckDuckGo";
      "floorp.browser.sidebar2.data" = ''
      {"data":{"floorp__history":{"url":"floorp//history","width":415},"floorp__downloads":{"url":"floorp//downloads","width":415},"floorp__profiles":{"url":"about:profiles","width":400}},"index":["floorp__profiles", "floorp__history","floorp__downloads"]}
      '';

      "browser.uiCustomization.state" = ''
      {"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["back-button","forward-button","stop-reload-button","customizableui-special-spring1","urlbar-container","customizableui-special-spring2","save-to-pocket-button","downloads-button","unified-extensions-button","profile-manager","ublock0_raymondhill_net-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"],"statusBar":["screenshot-button","fullscreen-button","status-text"]},"seen":["developer-button","sidebar-reverse-position-toolbar","undo-closed-tab","profile-manager","workspaces-toolbar-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","statusBar","TabsToolbar","unified-extensions-area","toolbar-menubar","PersonalToolbar"],"currentVersion":20,"newElementCount":2}
      '';
    };
  };
}
