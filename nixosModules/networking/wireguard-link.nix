{ config, lib, ... }:

let
  cfg = config.wireguardLink;
in
{
  options.wireguardLink = {
    enable = lib.mkEnableOption "a point-to-point WireGuard link on wg0";

    address = lib.mkOption {
      type = lib.types.str;
      description = "Local IPv4 tunnel address, without a CIDR suffix.";
    };

    peerAddress = lib.mkOption {
      type = lib.types.str;
      description = "Peer IPv4 tunnel address, without a CIDR suffix.";
    };

    peerPublicKey = lib.mkOption {
      type = lib.types.str;
      description = "WireGuard public key of the other machine.";
    };

    privateKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/wireguard/private.key";
      description = "Runtime path to the root-owned private key; never a Nix path literal.";
    };

    endpoint = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Peer's public host:port for the initiating side; null on the listener.";
    };

    listenPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = "Fixed UDP listener port to open, or null for an outbound client.";
    };

    extraAddresses = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional local tunnel addresses in CIDR notation.";
    };

    extraPeers = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "Additional peers, using the NixOS wg-quick peer options.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.wg-quick.interfaces.wg0 = {
      address = [ "${cfg.address}/32" ] ++ cfg.extraAddresses;
      inherit (cfg) privateKeyFile listenPort;
      # Keys were generated on each host. Never silently replace a missing key.
      generatePrivateKeyFile = false;
      peers = [
        {
          publicKey = cfg.peerPublicKey;
          allowedIPs = [ "${cfg.peerAddress}/32" ];
          inherit (cfg) endpoint;
          persistentKeepalive = if cfg.endpoint != null then 25 else null;
        }
      ]
      ++ cfg.extraPeers;
    };

    # Only the listener needs public UDP ingress. No application ports, trusted
    # interfaces, DNS changes, forwarding, NAT, or default routes are added.
    networking.firewall.allowedUDPPorts = lib.optional (cfg.listenPort != null) cfg.listenPort;
  };
}
