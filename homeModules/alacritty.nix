{ lib, config, ... }:

{
  options = {
    alacrittyConfig.enable = lib.mkEnableOption "Enable alacritty configuration";
  };

  config = lib.mkIf config.alacrittyConfig.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
