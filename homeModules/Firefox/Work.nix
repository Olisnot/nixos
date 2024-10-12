{ inputs, ... }:

{
  programs.firefox.profiles.Work = {
    name = "Work";
    search.default = "DuckDuckGo";
    bookmarks = [
      {
        toolbar = true;
        bookmarks = [
        ];
    }
    ];

    extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
        youtube-shorts-block
      ];

    settings = {
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.startup.page" = 3;
    };
  };
}
