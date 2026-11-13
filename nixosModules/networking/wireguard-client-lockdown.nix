{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.wireguardClientLockdown;
  wanControl = pkgs.writeShellApplication {
    name = "wg-wan";
    runtimeInputs = [
      pkgs.python3
      pkgs.iproute2
      pkgs.iptables
    ];
    text = ''
      exec ${pkgs.python3}/bin/python3 ${./wireguard-wan.py} \
        ${lib.escapeShellArg (builtins.toJSON cfg.privateVpsAddresses)} "$@"
    '';
  };
in
{
  options.wireguardClientLockdown = {
    enable = lib.mkEnableOption "WireGuard full-tunnel client egress lockdown";
    endpointAddress = lib.mkOption {
      type = lib.types.strMatching "[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+";
      default = "37.27.31.37";
    };
    endpointPort = lib.mkOption {
      type = lib.types.port;
      default = 51820;
    };
    privateVpsAddresses = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "10.77.0.1/32"
        "fd77:77::1/128"
      ];
      description = "Private VPS host addresses retained on WireGuard during explicit WAN override.";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ wanControl ];
    assertions = [
      {
        assertion = config.networking.firewall.enable && !config.networking.nftables.enable;
        message = "WireGuard client lockdown requires the enabled iptables firewall.";
      }
    ];
    networking.firewall = {
      checkReversePath = lib.mkDefault "loose";
      extraCommands = lib.mkAfter ''
        for tool in iptables ip6tables; do
          $tool -w -N wg-client-output 2>/dev/null || true
          $tool -w -F wg-client-output
          $tool -w -A wg-client-output -o lo -j RETURN
          $tool -w -A wg-client-output -o wg0 -j RETURN
        done
        # Only WireGuard's encrypted transport may leave directly for the VPS.
        iptables -w -A wg-client-output -p udp -d ${cfg.endpointAddress} --dport ${toString cfg.endpointPort} -m mark --mark 51820 -j RETURN
        iptables -w -A wg-client-output -p udp --sport 68 --dport 67 -m addrtype --dst-type BROADCAST -j RETURN
        for tool in iptables ip6tables; do
          $tool -w -A wg-client-output -p udp --dport 53 -j DROP
          $tool -w -A wg-client-output -p tcp -m multiport --dports 53,853 -j DROP
        done
        # Preserve local LAN/private-overlay access, not public WAN fallback.
        for network in 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 100.64.0.0/10 224.0.0.0/24 239.0.0.0/8 255.255.255.255/32; do
          iptables -w -A wg-client-output -d "$network" -j RETURN
        done
        for network in fc00::/7 fe80::/10 ff02::/16; do
          ip6tables -w -A wg-client-output -d "$network" -j RETURN
        done
        for tool in iptables ip6tables; do
          $tool -w -A wg-client-output -j DROP
          for chain in OUTPUT FORWARD; do
            $tool -w -C "$chain" -j wg-client-output 2>/dev/null || $tool -w -I "$chain" 1 -j wg-client-output
          done
        done
        # A root-only manual choice survives firewall reloads, never reboot.
        ${wanControl}/bin/wg-wan restore
      '';
      extraStopCommands = lib.mkBefore ''
        for tool in iptables ip6tables; do
          for chain in OUTPUT FORWARD; do
            $tool -w -D "$chain" -j wg-client-output 2>/dev/null || true
          done
          $tool -w -F wg-client-output 2>/dev/null || true
          $tool -w -X wg-client-output 2>/dev/null || true
        done
      '';
    };
    # Put unmarked internet traffic ahead of Tailscale's RPDB rules, while
    # keeping encrypted WireGuard transport on the physical main-table route.
    networking.wg-quick.interfaces.wg0 = {
      table = "51820";
      postUp = "${pkgs.python3}/bin/python3 ${./wireguard-client-policy.py} up";
    };
    systemd.services.wg-quick-wg0 = {
      path = [
        pkgs.iproute2
        pkgs.wireguard-tools
      ];
      serviceConfig = {
        RuntimeDirectory = "wg-client-policy";
        RuntimeDirectoryMode = "0700";
        ExecStopPost = "${pkgs.python3}/bin/python3 ${./wireguard-client-policy.py} down";
      };
    };
  };
}
