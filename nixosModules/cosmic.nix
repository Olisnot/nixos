{ config, lib, ... }:

{
  options.cosmic.enable =
    lib.mkEnableOption "Enable the cosmic desktop environment";

  config = lib.mkIf config.cosmic.enable {
    services.desktopManager.cosmic.enable = true;
  };
}
