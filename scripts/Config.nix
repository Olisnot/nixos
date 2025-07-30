{ pkgs }:

pkgs.writeShellApplication {
  name = "config";
  text = /* bash */ ''
    cd /nixos || exit
    tmux new -A -s NixOSConfig
  '';
}
