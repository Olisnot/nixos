{ inputs, ... }:
 
{
  programs.firefox.profiles.Personal = {
    name = "Personal";
    isDefault = true;
    search.default = "DuckDuckGo";
    bookmarks = [
      {
        name = "YouTube";
        keyword = "youtube";
        toolbar = true;
        url = "https://www.youtube.com/";
      }
      {
        name = "Twitch";
        keyword = "twitch";
        toolbar = true;
        url = "http://www.twitch.tv/";
      }
      {
        name = "AllAnime";
        keyword = "anime";
        toolbar = true;
        url = "https://allmanga.to/anime?tr=sub&cty=ALL";
      }
      {
        name = "AniList";
        keyword = "anilist";
        toolbar = true;
        url = "https://anilist.co/home";
      }
      {
        name = "Reddit";
        keyword = "reddit";
        toolbar = true;
        url = "https://www.reddit.com/";
      }
      {
        name = "GitHub";
        keyword = "github";
        toolbar = true;
        url = "https://github.com/";
      }
    ];

    extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        youtube-shorts-block
      ];
  };
}
