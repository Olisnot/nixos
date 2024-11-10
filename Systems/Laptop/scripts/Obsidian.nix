{ pkgs }:

pkgs.writeShellApplication {
  name = "Obsidian";
  text = /* bash */ ''
  cd /home/oliver/Obsidian
  tmux new-session -A -s Obsidian -n Editing
  tmux send-keys 'nix develop'
  tmux split-window -v
  '';
}
