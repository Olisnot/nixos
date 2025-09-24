{ ... }:

{
  webapps = {
    enable = true;
    apps = {
      chatgpt = {
        name = "ChatGPT";
        url = "https://chatgpt.com";
        icon =
          "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/openai-light.png";
      };
      invidious = {
        name = "Invidious";
        url = "https://inv.nadeko.net";
      };
    };
  };
}
