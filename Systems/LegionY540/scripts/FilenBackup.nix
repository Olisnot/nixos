{ pkgs }:

pkgs.writeShellApplication {
  name = "filen-backup";
  text = # bash
    ''
      set -euo pipefail

      timestamp() {
        date '+%M-%H-%d-%m-%Y'
      }

      if [ "$#" -lt 1 ]; then
      echo "Usage: $0 <dir1> [dir2 ...]"
      exit 1
      fi

      for dir in "$@"; do
          dir="''${dir%/}"

          if [ ! -d "$dir" ]; then
          echo "Skipping '$dir': directory does not exist."
          continue
          fi

          dirname=$(basename "$dir")
          parentdir=$(dirname "$dir")

          ts="$(timestamp)"
          archive="/tmp/''${dirname}-backup-''${ts}.tar.xz"

          echo "Backing up '$dir' to '$archive'..."

          tar -cJvf "$archive" -C "$parentdir" "$dirname"

          remotepath="Backups/''${dirname}/"

          echo "Uploading '$archive' to Filen at '$remotepath'..."
          filen upload "$archive" "$remotepath"

          echo "Done with '$dir'."
          echo
          done
    '';
}
