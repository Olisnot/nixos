{ config, lib, ... }:

{
  services.navidrome = {
    enable = true;
    openFirewall = true;
    user = "oliver";
    port = 4040;
    settings = { MusicFolder = "/mnt/1tb/Music/"; };
  };
}
