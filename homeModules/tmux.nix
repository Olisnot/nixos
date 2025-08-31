{ pkgs, lib, config, inputs, ... }:

{
  options = { tmux.enable = lib.mkEnableOption "Enable tmux"; };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
        { plugin = inputs.minimal-tmux.packages.${pkgs.system}.default; }
      ];
      extraConfig = ''
        set -g default-terminal "tmux-256color"
        set -g status-left-length 40
        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"
      '';
    };
    home.packages = with pkgs; [ tmux-sessionizer ];
  };
}
