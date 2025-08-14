{ ... }:

{
  programs.zed-editor = {
    userSettings = {
      "experimental.theme_overrides" = {
        "background.appearance" = "blurred";
        "background" = "#191724BB";
        "editor.background" = "#00000030";
        "editor.gutter.background" = "#00000030";
        "tab_bar.background" = "#00000030";
        "terminal.background" = "#00000030";
        "toolbar.background" = "#00000030";
        "tab.active_background" = "#28282820";
        "tab.inactive_background" = "#00000000";
        "status_bar.background" = "#00000030";
        "title_bar.background" = "#00000030";
        "panel.background" = "#00000030";
        "border.variant" = "#00000000";
        "scrollbar.track.border" = "#00000000";
        "editor.active_line.background" = "#00000000";
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
