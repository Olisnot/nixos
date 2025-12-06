{ config, lib, ... }:

{
  options.river.enable =
    lib.mkEnableOption "Enable River the wayland compositor";

  config = lib.mkIf config.river.enable {
    programs.river-classic = { enable = true; };
  };
}
