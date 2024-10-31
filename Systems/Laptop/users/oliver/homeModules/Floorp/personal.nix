{ inputs, ... }:
 
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
            name = "AllAnime";
            keyword = "anime";
            url = "https://allmanga.to/anime?tr=sub&cty=ALL";
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

    extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        steam-database
      ];

    settings = {
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.startup.page" = 3;
      "browser.newtabpage.pinned" = "[]";
      "extensions.formautofill.creditCards.enabled" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "floorp.browser.sidebar.useIconProvider" = "DuckDuckGo";
      "floorp.browser.sidebar2.data" = ''
      {"data":{"floorp__history":{"url":"floorp//history","width":415},"floorp__downloads":{"url":"floorp//downloads","width":415},"floorp__profiles":{"url":"about:profiles","width":550}},"index":["floorp__profiles", "floorp__history","floorp__downloads"]}
      '';
    };
  };
}
