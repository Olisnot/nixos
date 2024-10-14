{ inputs, ... }:

{
  programs.firefox.profiles.Work = {
    id = 1;
    name = "Work";
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
            name = "Blackboard";
            keyword = "blackboard";
            url = "https://blackboard.aber.ac.uk/ultra/course";
          }        
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
