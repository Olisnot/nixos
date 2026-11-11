{ pkgs, uploadMusic }:

pkgs.runCommand "upload-music-check"
  {
    nativeBuildInputs = [
      pkgs.rsync
      pkgs.python3
    ];
  }
  ''
    export UPLOAD_TEST_MOCKS=$TMPDIR/mocks
    export REMOTE_LIBRARY="$TMPDIR/Remote Library"
    export MUSIC_TEST_MOUNT=cifs
    mkdir -p "$UPLOAD_TEST_MOCKS" "$REMOTE_LIBRARY"
    # Only replace SSH transport and the mount probe. The sender and receiver
    # are real rsync processes, using a local fixture instead of any server.
    cat > "$UPLOAD_TEST_MOCKS/ssh" <<'PY'
    #!${pkgs.python3}/bin/python3
    import os
    import sys
    args = sys.argv[1:]
    index = args.index("olympus")
    command = " ".join(args[index + 1:])
    expected = "cd /srv/media/library/music"
    assert expected in command
    command = command.replace(expected, 'cd "$REMOTE_LIBRARY"')
    os.execvp("sh", ["sh", "-c", command])
    PY
    cat > "$UPLOAD_TEST_MOCKS/findmnt" <<'SH'
    #!${pkgs.runtimeShell}
    [[ "$MUSIC_TEST_MOUNT" == cifs ]]
    SH
    chmod +x "$UPLOAD_TEST_MOCKS/ssh" "$UPLOAD_TEST_MOCKS/findmnt"
    # Preserve the exact built script; prepend mocks after its runtime PATH.
    sed '/^export PATH=/a export PATH="$UPLOAD_TEST_MOCKS:$PATH"' \
      ${uploadMusic}/bin/upload-music > "$TMPDIR/upload-music"
    chmod +x "$TMPDIR/upload-music"
    uploader="$TMPDIR/upload-music"
    source="$TMPDIR/Música source"
    mkdir -p "$source/Artist One/Album"
    printf 'synthetic music\n' > "$source/Artist One/Album/track.flac"
    printf 'cover art\n' > "$source/Artist One/Album/cover.jpg"
    printf 'metadata\n' > "$source/.DS_Store"
    printf 'keep remote track\n' > "$REMOTE_LIBRARY/remote-only.flac"
    printf 'do not follow links\n' > "$TMPDIR/outside-source.flac"
    ln -s "$TMPDIR/outside-source.flac" "$source/external-link.flac"

    "$uploader" --help > /dev/null
    "$uploader" --dry-run "$source" > /dev/null
    test ! -e "$REMOTE_LIBRARY/Artist One"
    "$uploader" "$source" > /dev/null
    cmp "$source/Artist One/Album/track.flac" "$REMOTE_LIBRARY/Artist One/Album/track.flac"
    cmp "$source/Artist One/Album/cover.jpg" "$REMOTE_LIBRARY/Artist One/Album/cover.jpg"
    test -f "$REMOTE_LIBRARY/remote-only.flac"
    test ! -e "$REMOTE_LIBRARY/Música source"
    test ! -e "$REMOTE_LIBRARY/.DS_Store"
    test ! -e "$REMOTE_LIBRARY/external-link.flac"

    printf 'updated synthetic track with changed length\n' > "$source/Artist One/Album/track.flac"
    "$uploader" --dry-run "$source" > /dev/null
    if cmp -s "$source/Artist One/Album/track.flac" "$REMOTE_LIBRARY/Artist One/Album/track.flac"; then exit 1; fi
    "$uploader" -- "$source" > /dev/null
    cmp "$source/Artist One/Album/track.flac" "$REMOTE_LIBRARY/Artist One/Album/track.flac"
    test -f "$REMOTE_LIBRARY/remote-only.flac"

    printf 'must not upload\n' > "$source/refused.flac"
    if MUSIC_TEST_MOUNT=not-cifs "$uploader" "$source" > /dev/null 2>&1; then exit 1; fi
    test ! -e "$REMOTE_LIBRARY/refused.flac"
    if "$uploader" "$TMPDIR/nonexistent" > /dev/null 2>&1; then exit 1; fi
    if "$uploader" / > /dev/null 2>&1; then exit 1; fi
    if "$uploader" --delete "$source" > /dev/null 2>&1; then exit 1; fi
    if "$uploader" "$source" "$source" > /dev/null 2>&1; then exit 1; fi
    touch $out
  ''
