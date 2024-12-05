{ pkgs, lib, config, ... }:

{
  options = {
    zsh.enable = lib.mkEnableOption "Enable Z shell";
  };

  config = lib.mkIf config.zsh.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        c = "clear";
        sudovim = "sudo -E nvim .";
        vim = "nvim .";
        dev = "nix develop --command zsh";
        tb = "cd /mnt/1tb";
      };
    };

  };
}

