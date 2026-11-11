{
  pkgs,
  defaultSource ? "/mnt/1tb/Music",
}:

let
  remoteScript = ''
    set -eu
    # Walking into the library triggers its automount and pins the working
    # directory to that filesystem. Never populate an unmounted local fallback.
    cd /srv/media/library/music
    if ! findmnt --noheadings --types cifs --target . >/dev/null; then
      echo "Storage Box is not mounted as CIFS; refusing the upload." >&2
      exit 1
    fi
    exec rsync "$@"
  '';
in
pkgs.writeShellApplication {
  name = "upload-music";
  runtimeInputs = with pkgs; [
    rsync
    openssh
    coreutils
  ];
  text = ''
    usage() {
      echo 'Usage: upload-music [--dry-run] [SOURCE_DIRECTORY]'
      echo 'Default source: ${defaultSource}'
      echo 'Destination: root@olympus:/srv/media/library/music/'
      echo 'Updates new/changed files; never deletes remote-only files.'
    }
    dry_run=false
    source_set=false
    source=${pkgs.lib.escapeShellArg defaultSource}
    while (( $# )); do
      case "$1" in
        --help|-h) usage; exit 0 ;;
        --dry-run) dry_run=true; shift ;;
        --) shift; break ;;
        -*) usage >&2; exit 2 ;;
        *)
          if [[ "$source_set" == true ]]; then usage >&2; exit 2; fi
          source=$1
          source_set=true
          shift
          ;;
      esac
    done
    if (( $# )); then
      if [[ "$source_set" == true ]] || (( $# != 1 )); then usage >&2; exit 2; fi
      source=$1
    fi
    if [[ ! -d "$source" ]]; then
      printf 'Source directory does not exist: %s\n' "$source" >&2
      exit 1
    fi
    source=$(realpath -e -- "$source")
    if [[ "$source" == / ]]; then
      echo 'Refusing to upload the filesystem root.' >&2
      exit 1
    fi

    flags=()
    if [[ "$dry_run" == true ]]; then flags+=(--dry-run); fi
    printf 'Uploading contents of %s/ to Olympus music library.\n' "$source"
    if [[ "$dry_run" == true ]]; then echo 'Dry run: no files will be changed.'; fi
    # No archive/permission flags: the CIFS mount controls ownership and modes.
    # Symlinks are not followed/copied; art, playlists and other regular files
    # in the music tree are included. Use SSH's existing olympus alias/key.
    rsync \
      --recursive --times --omit-dir-times \
      --no-perms --no-owner --no-group \
      --human-readable --info=progress2 --itemize-changes --stats \
      --partial --partial-dir=.rsync-partial \
      --exclude=.rsync-partial/ --exclude=.DS_Store \
      --protect-args --rsh=ssh \
      --rsync-path=${pkgs.lib.escapeShellArg "sh -c ${pkgs.lib.escapeShellArg remoteScript} sh"} \
      "''${flags[@]}" -- "$source/" root@olympus:./
    echo 'Upload complete. Trigger a Navidrome library scan or wait for its scheduled scan.'
  '';
}
