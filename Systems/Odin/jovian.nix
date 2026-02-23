{ ... }:

{
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "oliver";
      desktopSession = "niri";
    };
    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
      enableGyroDsuService = true;
    };
    steamos.useSteamOSConfig = true;
    decky-loader = {
      enable = true;
      user = "oliver";
    };
    hardware.has.amd.gpu = true;
  };
}
