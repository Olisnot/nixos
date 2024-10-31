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
    };
  };
}
