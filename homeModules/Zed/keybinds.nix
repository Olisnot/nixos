{ ... }:
{
  programs.zed-editor = {
    userKeymap = [
      {
        "context" = "Workspace";
        "bindings" = {
          "ctrl-t" = "terminal_panel::ToggleFocus";
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
