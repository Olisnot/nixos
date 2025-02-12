{ lib, config, ... }:

{
  options = {
    nushell.enable = lib.mkEnableOption "Enable nushell";
  };

  config = lib.mkIf config.nushell.enable {
    programs.nushell = {
      enable = true;
      shellAliases = {
        dev = "nix develop --command nu";
      };
    };
  };
}

