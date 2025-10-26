{ config, lib, pkgs, ... }:

{
  options = { chromium.enable = lib.mkEnableOption "Enable chromium"; };

  config = lib.mkIf config.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
