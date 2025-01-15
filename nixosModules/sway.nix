{ lib, config, ... }:

{
  options = {
    sway.enable = lib.mkEnableOption "Enable Sway Wayland compositor";
  };

  config = lib.mkIf config.sway.enable {
    programs.sway = {
      enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      xwayland.enable = true;
      wrapperFeatures = {
        gtk = true;
        base = true;
      };
    };
  };
}
