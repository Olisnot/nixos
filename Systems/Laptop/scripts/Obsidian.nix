{ pkgs }:

pkgs.writeShellApplication {
  name = "rebuild";
  text = /* bash */ ''
  cd /home/oliver/Obsidian
  tmux new-session -A -s Obsidian -n Editing
  tmux new-window -t Obsidian:2 -n Git
  tmux send-keys -t NixOSConfig:1 'nix develop' Enter
  tmux select-window -t Editing
  tmux a -t Obsidian
  '';
}
