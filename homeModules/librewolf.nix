{ lib, config, pkgs, ... }:

{
  options.librewolf.enable = lib.mkEnableOption "librewolf web browser";

  config = lib.mkIf config.librewolf.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf-bin;
    };

    stylix.targets.librewolf = {
      enable = true;
      profileNames = [ "default" ];
    };
  };
}
