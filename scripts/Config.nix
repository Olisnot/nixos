{ pkgs }:

pkgs.writeShellApplication {
  name = "config";
  text = /* bash */ ''
    cd /nixos || exit
    tmux new-session -d -s NixOSConfig -n Config
    tmux send-keys -t NixOSConfig:1 'vim' Enter
    tmux a -t NixOSConfig
  '';
}
