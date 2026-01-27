{ ... }:
{
  programs.zed-editor = {
    userKeymaps = [
      {
        "context" = "Workspace";
        "bindings" = {
          "ctrl-t" = "terminal_panel::ToggleFocus";
          "space e" = "workspace::ToggleLeftDock";
          "space space" = "file_finder:toggle";
        };
      }
      {
        "context" = "Terminal";
        "bindings" = {
          "ctrl-t" = "workspace::ToggleBottomDock";
          "ctrl-n" = "workspace::NewTerminal";
        };
      }
    ];
  };
}
