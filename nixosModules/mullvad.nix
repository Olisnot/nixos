{ pkgs, config, lib, ... }:

let
  mullvad-autostart = pkgs.makeAutostartItem {
    name = "mullvad-vpn";
    package = pkgs.mullvad-vpn;
  };
in
{
  options.mullvad.enable = lib.mkEnableOption "mullvad-vpn";

  config = lib.mkIf config.mullvad.enable {
    environment.systemPackages = [ mullvad-autostart ];
  };
}
