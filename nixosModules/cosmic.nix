{ config, lib, pkgs, ... }:

{
  options.cosmic.enable =
    lib.mkEnableOption "Enable the cosmic desktop environment";

  config = lib.mkIf config.cosmic.enable {
    services.desktopManager.cosmic.enable = true;
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-player
      cosmic-edit
      cosmic-icons
      cosmic-term
    ];
  };
}
