{ config, lib, ... }:

let
  settings = builtins.fromJSON (builtins.readFile ./wireguard-mobile-settings.json);
  files = builtins.readDir ./wireguard-clients;
  cfg = config.olympusMobileVpn;
  enrolledClients =
    map (name: builtins.fromJSON (builtins.readFile (./wireguard-clients + "/${name}")))
      (
        builtins.filter (name: files.${name} == "regular" && lib.hasSuffix ".json" name) (
          builtins.attrNames files
        )
      );
  clients = cfg.clients;
  addresses = map (client: client.address) clients;
  keys = map (client: client.publicKey) clients;
  ipv6 = address: "fd77:77::${lib.last (lib.splitString "." address)}";
  # Includes LAN, tunnel, link-local/metadata, CGNAT, loopback and special-use space.
  deniedNetworks = [
    "0.0.0.0/8"
    "10.0.0.0/8"
    "100.64.0.0/10"
    "127.0.0.0/8"
    "169.254.0.0/16"
    "172.16.0.0/12"
    "192.0.0.0/24"
    "192.0.2.0/24"
    "192.168.0.0/16"
    "198.18.0.0/15"
    "198.51.100.0/24"
    "203.0.113.0/24"
    "224.0.0.0/4"
    "240.0.0.0/4"
  ];
in
{
  options.olympusMobileVpn = {
    allowedServicePorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ ];
      description = "Explicit private application TCP ports allowed on the VPS tunnel address for enrolled mobile peers.";
    };
    clients = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            address = lib.mkOption { type = lib.types.str; };
            publicKey = lib.mkOption { type = lib.types.str; };
          };
        }
      );
      default = enrolledClients;
      description = "Mobile peers, normally read from the public wireguard-clients JSON files.";
    };
    externalInterface = lib.mkOption {
      type = lib.types.strMatching "[a-zA-Z0-9_.:-]+";
      default = settings.externalInterface;
      description = "Verified public IPv4 egress interface.";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.networking.firewall.enable && !config.networking.nftables.enable;
        message = "Olympus mobile VPN policy requires the enabled iptables firewall; review the policy before changing backends.";
      }
      {
        assertion = lib.all (
          address:
          builtins.match "10\\.77\\.0\\.([3-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])" address != null
        ) addresses;
        message = "Mobile WireGuard addresses must be unique addresses in 10.77.0.3–10.77.0.254.";
      }
      {
        assertion =
          lib.length addresses == lib.length (lib.unique addresses)
          && lib.length keys == lib.length (lib.unique keys)
          && lib.all (
            key:
            builtins.match "[A-Za-z0-9+/]{43}=" key != null
            && key != config.wireguardLink.peerPublicKey
            && key != settings.serverPublicKey
          ) keys;
        message = "Mobile WireGuard peers must have unique, valid public keys distinct from Zeus and Olympus.";
      }
    ];

    wireguardLink = {
      extraAddresses = [ "fd77:77::1/128" ];
      extraPeers = map (client: {
        publicKey = client.publicKey;
        allowedIPs = [
          "${client.address}/32"
          "${ipv6 client.address}/128"
        ];
      }) clients;
    };

    networking.nat = {
      enable = clients != [ ];
      externalInterface = cfg.externalInterface;
      internalIPs = map (address: "${address}/32") addresses;
      # Do not NAT all of wg0: Zeus remains a split-tunnel peer.
      internalInterfaces = [ ];
      enableIPv6 = false;
    };

    # IPv6 is captured by client ::/0 and fails closed, not NATed or forwarded.
    # Olympus currently has no IPv6 default route.
    boot.kernel.sysctl = {
      "net.ipv4.conf.all.forwarding" = lib.mkDefault (clients != [ ]);
      "net.ipv4.conf.default.forwarding" = lib.mkDefault (clients != [ ]);
      "net.ipv6.conf.all.forwarding" = false;
    };

    networking.firewall = {
      extraCommands = lib.mkAfter ''
        # Owned chains and top-level jumps are idempotent across firewall reloads.
        for tool in iptables ip6tables; do
          for chain in wg-mobile-input wg-mobile-forward; do
            $tool -w -N "$chain" 2>/dev/null || true
            $tool -w -F "$chain"
          done
        done

        # Preserve Zeus's existing host access; all other tunnel sources may
        # access public web ports only, never SSH, Caddy admin, or other host ports.
        iptables -w -A wg-mobile-input -s 10.77.0.2/32 -j RETURN
        ${lib.concatMapStringsSep "\n" (address: ''
          iptables -w -A wg-mobile-input -s ${address}/32 -p tcp -m multiport --dports 80,443 -j ACCEPT
          ${lib.concatMapStringsSep "\n" (port: ''
            iptables -w -A wg-mobile-input -s ${address}/32 -d 10.77.0.1/32 -p tcp --dport ${toString port} -j ACCEPT
          '') cfg.allowedServicePorts}
        '') addresses}
        iptables -w -A wg-mobile-input -j DROP
        ip6tables -w -A wg-mobile-input -j DROP

        # Reject private destinations before any established-connection accept.
        ${lib.concatMapStringsSep "\n" (network: ''
          iptables -w -A wg-mobile-forward -i wg0 -d ${network} -j DROP
        '') deniedNetworks}
        ${lib.concatMapStringsSep "\n" (address: ''
          iptables -w -A wg-mobile-forward -i wg0 -o ${cfg.externalInterface} -s ${address}/32 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
          iptables -w -A wg-mobile-forward -i ${cfg.externalInterface} -o wg0 -d ${address}/32 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
        '') addresses}
        # No phone-to-phone, phone-to-Zeus, Zeus internet exit, or inbound forwarding.
        for tool in iptables ip6tables; do
          $tool -w -A wg-mobile-forward -i wg0 -j DROP
          $tool -w -A wg-mobile-forward -o wg0 -j DROP
          $tool -w -A wg-mobile-forward -j RETURN
          $tool -w -C INPUT -i wg0 -j wg-mobile-input 2>/dev/null || \
            $tool -w -I INPUT 1 -i wg0 -j wg-mobile-input
          $tool -w -C FORWARD -j wg-mobile-forward 2>/dev/null || \
            $tool -w -I FORWARD 1 -j wg-mobile-forward
        done
      '';

      extraStopCommands = lib.mkAfter ''
        for tool in iptables ip6tables; do
          $tool -w -D INPUT -i wg0 -j wg-mobile-input 2>/dev/null || true
          $tool -w -D FORWARD -j wg-mobile-forward 2>/dev/null || true
          for chain in wg-mobile-input wg-mobile-forward; do
            $tool -w -F "$chain" 2>/dev/null || true
            $tool -w -X "$chain" 2>/dev/null || true
          done
        done
      '';
    };
  };
}
