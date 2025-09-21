{ pkgs }:

pkgs.writeShellApplication {
  name = "rebuild";
  text = # bash
    ''
      cd /home/oliver/nixos  || exit
      git add .
      if ! git diff --cached --quiet; then
        git commit -m "rebuild-$(date +"%d-%m-%Y %H:%M:%S")"
      else
        echo "No changes to commit."
      fi
      sudo nixos-rebuild switch --impure --flake /home/oliver/nixos#legiony540
    '';
}
