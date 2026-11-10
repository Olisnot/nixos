{ pkgs }:

pkgs.writeShellApplication {
  name = "wireguard-enroll";
  runtimeInputs = with pkgs; [
    wireguard-tools
    qrencode
    coreutils
    jq
  ];
  text = ''
    usage() {
      echo "Usage: wireguard-enroll NAME [HOST_NUMBER] | wireguard-enroll show NAME" >&2
      exit 1
    }
    (( $# >= 1 && $# <= 2 )) || usage
    action=create
    if [[ "$1" == show ]]; then
      (( $# == 2 )) || usage
      action=show
      name=$2
    else
      name=$1
    fi
    [[ "$name" =~ ^[a-z][a-z0-9-]{0,31}$ ]] || usage

    repo=$(realpath -e "''${WIREGUARD_REPO:-/home/oliver/repos/nixos}")
    state_root=$(realpath -m "''${XDG_STATE_HOME:-$HOME/.local/state}/wireguard/olympus")
    case "$state_root/" in
      "$repo/"*) echo 'Private enrollment files must be outside the repository.' >&2; exit 1 ;;
    esac
    state="$state_root/$name"
    conf="$state/$name.conf"
    if [[ "$action" == create ]]; then
      number=''${2:-3}
      [[ "$number" =~ ^([3-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])$ ]] || usage
      address="10.77.0.$number"
      peers="$repo/Systems/Olympus/wireguard-clients"
      settings="$repo/Systems/Olympus/wireguard-mobile-settings.json"
      [[ -d "$peers" && -f "$settings" ]] || { echo 'Missing Olympus enrollment settings.' >&2; exit 1; }
      [[ ! -e "$state" && ! -L "$state" && ! -e "$peers/$name.json" && ! -L "$peers/$name.json" ]] || {
        echo 'Device already exists; use show to display its QR code. Nothing overwritten.' >&2
        exit 1
      }
      shopt -s nullglob
      for peer in "$peers"/*.json; do
        if [[ $(jq -r .address "$peer") == "$address" ]]; then
          echo 'Address already enrolled; choose another HOST_NUMBER (3–254).' >&2
          exit 1
        fi
      done
      endpoint=$(jq -er .endpoint "$settings")
      server_key=$(jq -er .serverPublicKey "$settings")
      dns=$(jq -er '.dns | join(", ")' "$settings")
      umask 077
      set -o noclobber
      install -d -m 700 "$state_root"
      mkdir -m 700 "$state"
      wg genkey > "$state/private.key"
      public_key=$(wg pubkey < "$state/private.key")
      {
        echo '[Interface]'
        printf 'PrivateKey = %s\n' "$(cat "$state/private.key")"
        printf 'Address = %s/32, fd77:77::%s/128\n' "$address" "$number"
        printf 'DNS = %s\n' "$dns"
        echo 'MTU = 1280'
        echo
        echo '[Peer]'
        printf 'PublicKey = %s\n' "$server_key"
        printf 'Endpoint = %s\n' "$endpoint"
        echo 'AllowedIPs = 0.0.0.0/0, ::/0'
        echo 'PersistentKeepalive = 25'
      } > "$conf"
      # Only this public information enters the repository; never the config/QR.
      jq -n --arg address "$address" --arg publicKey "$public_key" \
        '{address: $address, publicKey: $publicKey}' > "$peers/$name.json"
      printf 'Created public peer: %s\nPrivate config (keep secret): %s\n' "$peers/$name.json" "$conf"
      echo 'Review the public peer, then run rebuild olympus before enabling the tunnel.'
    fi

    [[ -f "$conf" && ! -L "$conf" ]] || { echo 'No private configuration for this device.' >&2; exit 1; }
    if [[ -t 1 ]]; then
      echo 'SECRET QR CODE: scan with WireGuard on your phone; do not screenshot or share.'
      qrencode -t ANSIUTF8 < "$conf"
    elif [[ "$action" == show ]]; then
      echo 'QR display requires an interactive terminal; refusing to send secrets to logs.' >&2
      exit 1
    else
      printf 'QR omitted from non-interactive output. Run locally: wireguard-enroll show %s\n' "$name"
    fi
  '';
}
