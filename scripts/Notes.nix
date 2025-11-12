{ pkgs }:

pkgs.writeShellApplication {
  name = "open-notes";
  text = # bash
    ''
      cd /home/oliver/nixos || exit
      tmux new -A -s NixOSConfig
    '';
}
