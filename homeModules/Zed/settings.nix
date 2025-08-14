{ ... }:


{
  programs.zed-editor = {
    userSettings = {
      "experimental.theme_overrides" = {
        "background.appearance" = "blurred";
        "background" = "#191724BB";
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
}
