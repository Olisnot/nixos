{ config, lib, ... }:

{
  options = {
    zed.enable = lib.mkEnableOption "zed";
  };

  config = lib.mkIf config.zed.enable {
    programs.zed-editor = {
      enable = true;
      extensions = ["nix" "toml" "make" "catppuccin"];
      userSettings = {
        assistant = {
          enabled = true;
          version = "2";
          default_open_ai_model = null;
          default_model = { 
            provider = "zed.dev";
            model = "claude-3-5-sonnet-latest";
          };
        };
        hour_format = "hour24";
        auto_update = false;
        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          copy_on_select = false;
          dock = "bottom";
          detect_venv = {
            on = {
              directories = [".env" "env" ".venv" "venv"];
              activate_script = "default";
            };
          };
          env = {
            TERM = "ghostty";
          };
          font_family = "FiraCode Nerd Font";
          font_features = null;
          font_size = null;
          line_height = "comfortable";
          option_as_meta = false;
          button = false;
          shell = "system"; 
          toolbar = {
            title = true;
          };
          working_directory = "current_project_directory";
        };
        lsp = {
          rust-analyzer = {
            binary = {
              path_lookup = true;
            };
          };
          nix = { 
            binary = { 
              path_lookup = true; 
            }; 
          };
        };
        languages = { };
        vim_mode = true;
        load_direnv = "shell_hook";
        base_keymap = "VSCode";
        show_whitespaces = "all" ;
      };
    };
  };
}
