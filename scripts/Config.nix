{ pkgs }:

pkgs.writeShellApplication {
  name = "nixconf";
  text = /* bash */ ''
    cd /nixos || exit
    tmux new -A -s NixOSConfig
  '';
}
