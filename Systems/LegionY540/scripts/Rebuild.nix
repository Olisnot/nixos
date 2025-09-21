{ pkgs }:

pkgs.writeShellApplication {
  name = "rebuild";
  text = # bash
    ''
      cd /home/oliver/nixos  || exit
      git add .
      git commit -m "rebuild-$(date +"%d-%m-%Y %H:%M:%S")"
      sudo nixos-rebuild switch --impure --flake /home/oliver/nixos#legiony540
    '';
}
