{ pkgs }:

pkgs.writeShellApplication {
  name = "rebuild";
  text = /* bash */ ''
    cd /nixos  || exit
    sudo git add . 
    sudo git commit -m "rebuild-$(date +"%d-%m-%Y %H:%M:%S")"
    sudo nixos-rebuild switch --impure --flake /nixos#default
  '';
}
