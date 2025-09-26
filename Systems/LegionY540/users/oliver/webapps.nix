{ ... }:

{
  webapps = {
    enable = true;
    apps = {
      chatgpt = {
        name = "ChatGPT";
        url = "https://chatgpt.com";
      };
      invidious = {
        name = "Invidious";
        url = "https://inv.nadeko.net";
      };
      duolingo = {
        name = "Duolingo";
        url = "https://www.duolingo.com";
      };
    };
  };
}
