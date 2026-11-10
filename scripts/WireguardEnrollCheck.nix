{ pkgs, enroll }:

pkgs.runCommand "wireguard-enroll-check"
  {
    nativeBuildInputs = [
      enroll
      pkgs.jq
      pkgs.wireguard-tools
    ];
  }
  ''
    export WIREGUARD_REPO=$TMPDIR/repo
    export XDG_STATE_HOME=$TMPDIR/state
    peers=$WIREGUARD_REPO/Systems/Olympus/wireguard-clients
    mkdir -p "$peers"
    cp ${../Systems/Olympus/wireguard-mobile-settings.json} \
      "$WIREGUARD_REPO/Systems/Olympus/wireguard-mobile-settings.json"
    wireguard-enroll iphone > enrollment.log
    private=$XDG_STATE_HOME/wireguard/olympus/iphone
    test "$(stat -c %a "$private")" = 700
    test "$(stat -c %a "$private/iphone.conf")" = 600
    test "$(stat -c %a "$private/private.key")" = 600
    test "$(jq -r .address "$peers/iphone.json")" = 10.77.0.3
    test "$(jq -c 'keys | sort' "$peers/iphone.json")" = '["address","publicKey"]'
    test "$(jq -r .publicKey "$peers/iphone.json")" = "$(wg pubkey < "$private/private.key")"
    grep -Fx 'AllowedIPs = 0.0.0.0/0, ::/0' "$private/iphone.conf" > /dev/null
    grep -Fx 'Address = 10.77.0.3/32, fd77:77::3/128' "$private/iphone.conf" > /dev/null
    grep -F 'QR omitted' enrollment.log > /dev/null
    # Neither public files nor command logs may contain the private key.
    if grep -qFf "$private/private.key" "$peers/iphone.json" enrollment.log; then exit 1; fi
    if wireguard-enroll iphone > /dev/null 2>&1; then exit 1; fi
    if wireguard-enroll duplicate-address 3 > /dev/null 2>&1; then exit 1; fi
    if wireguard-enroll show iphone > /dev/null 2>&1; then exit 1; fi
    if wireguard-enroll ../escape > /dev/null 2>&1; then exit 1; fi
    if wireguard-enroll invalid 2 > /dev/null 2>&1; then exit 1; fi
    wireguard-enroll tablet 4 > /dev/null
    if XDG_STATE_HOME="$WIREGUARD_REPO/secrets" wireguard-enroll unsafe 5 > /dev/null 2>&1; then exit 1; fi
    # All generated test keys remain in the temporary build directory, not $out.
    touch $out
  ''
