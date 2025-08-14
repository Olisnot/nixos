{ ... }:

{
  programs.zed-editor = {
    userSettings = {
      "experimental.theme_overrides" = {
        "renamed.background" = "#FFFFFF20";
        "search.match_background" = "#FFFFFF20";
        "ghost_element.background" = "#00000010";
        "ghost_element.hover" = "#00000099";
        "background.appearance" = "blurred";
        "background" = "#000000CC";
        "editor.background" = "#00000010";
        "editor.gutter.background" = "#00000010";
        "title_bar.background" = "#000000DF";
        "toolbar.background" = "#00000010";
        "terminal.background" = "#00000000";
        "status_bar.background" = "#000000DF";
        "tab.active_background" = "#000000";
        "tab.inactive_background" = "#00000000";
        "tab_bar.background" = "#00000010";
        "panel.background" = "#00000010";
        "border" = "#00000000";
        "border.variant" = "#00000000";
        "scrollbar.track.border" = "#00000000";
        "scrollbar.track.background" = "#00000000";
        "scrollbar.thumb.background" = "#00000000";
        "scrollbar.thumb.hover.background" = "#00000000";
        "scrollbar.thumb.active.background" = "#00000000";
        "scrollbar.thumb.border" = "#FFFFFF90";
        "editor.line_highlight" = "#00000000";
        "editor.active_line.background" = "#00000000";
        "editor.selection.background" = "#00000000";
        "editor.selection.foreground" = "#00000000";
        "editor.selection.border" = "#00000000";
        "editor.selection.inactive.foreground" = "#00000000";
        "editor.selection.inactive.border" = "#00000000";
        "editor.selection.active.background" = "#00000000";
        "editor.selection.active.foreground" = "#00000000";
        "editor.selection.active.border" = "#00000000";
        "editor.selection.inactive.background" = "#00000000";
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
