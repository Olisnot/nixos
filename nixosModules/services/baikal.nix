{ lib, config, ... }:

{
  options = {
    baikal.enable = lib.mkEnableOption "Enable baikal";
  };

  config = lib.mkIf config.baikal.enable {
    services.baikal.enable = true;
  };
}
