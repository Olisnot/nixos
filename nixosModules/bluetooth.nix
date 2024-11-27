{ lib, config, ... }:

{
  options = {
    bluetooth.enable = lib.mkEnableOption "Enable bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.enableAllFirmware = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
  };
}
