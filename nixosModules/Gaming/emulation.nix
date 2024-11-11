{ lib, config, pkgs, ... }:

{
  options = {
  };

  config = lib.mkIf config.gaming.emulation.enable {
  };
}
