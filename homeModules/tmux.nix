{ pkgs, lib, config, ... }:

{
  options = {
    tmux.enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [ resurrect ];
      extraConfig = ''
      set -g status-left-length 40
      '';
    };
  };
}

