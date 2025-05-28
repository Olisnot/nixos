{ pkgs }:

pkgs.writeShellApplication {
  name = "config";
  text = /* bash */ ''
    cd /nixos || exit
    zellij --layout "$HOME"/.config/zellij/Layouts/config_layout.kdl attach NixOSConfig  -c
  '';
}
