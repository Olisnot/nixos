{ pkgs, config, libs, ... }:

{
    programs.tmux = {
        enable = true;

        extraConfig = ''
            set -g base-index 1
            setw -g pane-base-index 1
            set-window-option -g mode-keys vi
        '';
    };
}
