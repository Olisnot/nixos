{ ... }:
{
  programs.zed-editor = {
    userTasks = [
      {
        label = "Rust: Bacon";
        command = "bacon";
        args = [ "$ZED_WORKTREE_ROOT" ];
        reveal = "always";
        panel = "right";
      }
    ];
  };
}
