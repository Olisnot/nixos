{ pkgs }:

pkgs.writeShellApplication {
  name = "config";
  text = /* bash */ ''
    cd /home/oliver/nixos || exit
    tmux new -A -s NixOSConfig
  '';
}
