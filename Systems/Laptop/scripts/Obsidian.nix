{ pkgs }:

pkgs.writeShellApplication {
  name = "Obsidian";
  text = /* bash */ ''
  cd /home/oliver/Obsidian
  tmux new-session -d -s Obsidian -n Editing
  tmux new-window -t Obsidian:2 -n Git
  tmux send -t Obsidian:1 'nix develop' Enter
  tmux select-window -t Editing
  tmux a -t Obsidian
  '';
}
