{ ... }:

{
  programs.zed-editor = {
    userSettings = {
      hour_format = "hour24";
      auto_update = false;
      terminal = {
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        dock = "bottom";
        detect_venv = {
          on = {
            directories = [
              ".env"
              "env"
              ".venv"
              "venv"
            ];
            activate_script = "default";
          };
        };
        env = {
          TERM = "foot";
        };
        # font_family = "FiraCode Nerd Font";
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
      vim = {
        use_system_clipboard = "never";
        toggle_relative_line_numbers = true;
      };

      load_direnv = "shell_hook";
      base_keymap = "VSCode";
      show_whitespaces = "all";
    };
  };
}
