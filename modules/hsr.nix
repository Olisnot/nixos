let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  imports = [
    aagl-gtk-on-nix.module
  ];

  programs.the-honkers-railway-launcher.enable = true;
}
