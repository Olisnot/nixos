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
        zoxide init fish | source
        starship init fish | source
      '';

      shellAliases = {
        dev = "nix develop --command fish";
        ls = "eza -l --icons --time-style=long-iso --group-directories-first";
      };
    };
  };
}
