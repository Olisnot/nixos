{ lib, config, ... }:

{
  options = {
    tmuxConfig.enable = lib.mkEnableOption "Enables tmux configuration";
  };

  config = lib.mkIf config.tmuxConfig.enable {
    programs.tmux = {
        enable = true;

        extraConfig = ''
            set -g base-index 1
            setw -g pane-base-index 1
            set-window-option -g mode-keys vi
        '';
    };
  };
}
