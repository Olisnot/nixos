{ ... }:

{
    programs.tmux = {
        enable = true;

        extraConfig = ''
            set -g base-index 1
            setw -g pane-base-index 1
            set-window-option -g mode-keys vi

            set-option -g status-position "bottom"
            set-option -g status-style bg=#404040,fg=#f0f0f0
            set-option -g status-left '#[bg=#404040,fg=#f0f0f0,bold]#{?client_prefix,,  tmux  }#[bg=#79a8ff,fg=#1e1e1e,bold]#{?client_prefix,  tmux  ,}'
            set-option -g status-right '#S'
            set-option -g window-status-format ' #I:#W '
            set-option -g window-status-current-format '#[bg=#79a8ff,fg=#1e1e1e] #I:#W#{?window_zoomed_flag,  , }'
        '';
    };
}
