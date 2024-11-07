{ pkgs }:

pkgs.writeShellApplication {
  name = "config";
  text = /* bash */ ''
    cd /nixos || exit
    tmux new-session -d -s NixOSConfig -n Rebuild
    tmux new-window -t NixOSConfig:2 -n NeoVim
    tmux send-keys -t NixOSConfig:2 'sudovim'
    tmux select-window -t Rebuild
    tmux a -t NixOSConfig
  '';
}
