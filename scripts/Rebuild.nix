{ pkgs }:

pkgs.writeShellApplication {
  name = "rebuild";
  text = # bash
    ''
      if (( $# > 1 )); then
        echo "Usage: rebuild [olympus]" >&2
        exit 1
      fi

      remote=false
      if (( $# == 0 )); then
        host=$(hostname)
        rebuild=(sudo nixos-rebuild switch)
      elif [[ "$1" == "olympus" ]]; then
        host=olympus
        remote=true
        # Resolve the VPS address through the olympus alias in ~/.ssh/config.
        export NIX_SSHOPTS="''${NIX_SSHOPTS:+$NIX_SSHOPTS }-i $HOME/.ssh/olympus -o IdentitiesOnly=yes"
        rebuild=(nixos-rebuild switch --target-host root@olympus)
      else
        echo "Unknown remote host: $1. Usage: rebuild [olympus]" >&2
        exit 1
      fi

      cd /home/oliver/repos/nixos
      git add .
      if ! "''${rebuild[@]}" --flake ".#$host"; then
        echo "Build failed for $host." >&2
        exit 1
      fi

      if ! git diff --cached --quiet; then
        if [[ "$remote" == true ]]; then
          profile=$(ssh -i "$HOME/.ssh/olympus" -o IdentitiesOnly=yes root@olympus \
            readlink /nix/var/nix/profiles/system)
        else
          profile=$(readlink /nix/var/nix/profiles/system)
        fi
        generation=''${profile##*/}
        generation=''${generation#system-}
        generation=''${generation%-link}
        git commit -m "$host-Generation-$generation"
      else
        echo "No changes to commit."
      fi
    '';
}
