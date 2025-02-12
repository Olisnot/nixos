{ lib, config, ... }:

{
  options = {
    fish.enable = lib.mkEnableOption "Enable friendly interactive shell";
  };

  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
      set fish_greeting # Disable greeting
      '';

      shellAliases = {
        dev = "nix develop --command fish";
      };
    };
  };
}

