{ config, lib, ... }:

{
  assertions = [
    {
      assertion =
        config.romm.bridgeName == "br-romm"
        && (config.virtualisation.docker.daemon.settings."firewall-backend" or "iptables") == "iptables";
      message = "Olympus RomM isolation requires br-romm and Docker's iptables/DOCKER-USER backend; review the policy before changing them.";
    }
  ];
  # Docker's published-port rules otherwise run before the existing phone
  # FORWARD policy. Enforce that policy in Docker's supported early hook too.
  systemd.services.docker.after = [ "firewall.service" ];
  networking.firewall = {
    extraCommands = lib.mkOrder 1600 ''
      iptables -w -N DOCKER-USER 2>/dev/null || true
      iptables -w -N olympus-romm-forward 2>/dev/null || true
      iptables -w -F olympus-romm-forward
      iptables -w -A olympus-romm-forward -j wg-mobile-forward
      iptables -w -A olympus-romm-forward -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN
      # Host-origin Caddy traffic uses OUTPUT, not FORWARD. Reject direct
      # external/WireGuard routing into either container, including the DB.
      iptables -w -A olympus-romm-forward ! -i br-romm -o br-romm -j DROP
      iptables -w -A olympus-romm-forward -j RETURN
      iptables -w -C DOCKER-USER -j olympus-romm-forward 2>/dev/null || \
        iptables -w -I DOCKER-USER 1 -j olympus-romm-forward
    '';
    extraStopCommands = lib.mkBefore ''
      iptables -w -D DOCKER-USER -j olympus-romm-forward 2>/dev/null || true
      iptables -w -F olympus-romm-forward 2>/dev/null || true
      iptables -w -X olympus-romm-forward 2>/dev/null || true
    '';
  };
}
