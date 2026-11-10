{ pkgs }:

# Test the actual firewall/NAT module using namespaces as decrypted tunnel/WAN
# links. This tests packet policy, not WireGuard cryptography or iOS behaviour.
pkgs.testers.runNixOSTest {
  name = "olympus-wireguard-mobile";
  nodes.machine = { ... }: {
    imports = [
      ../../nixosModules/networking/wireguard-link.nix
      ./wireguard-mobile.nix
    ];
    wireguardLink.peerPublicKey = "cgFioflbrw7Jp9BxZK0kEbxcuUaxVOecMpt7vDTgRR8=";
    olympusMobileVpn = {
      externalInterface = "uplink";
      clients = pkgs.lib.mkForce [
        {
          address = "10.77.0.3";
          publicKey = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }
      ];
    };
    networking.firewall.allowedTCPPorts = [
      80
      9090
    ];
    environment.systemPackages = [
      pkgs.python3
      pkgs.curl
      pkgs.iproute2
    ];
  };
  testScript = ''
    machine.start()
    machine.wait_for_unit("firewall.service")
    # Test the VPS public-IP INPUT path locally; never contact the real VPS.
    machine.succeed("ip addr add 37.27.31.37/32 dev lo")
    machine.succeed("ip netns add phone; ip netns add internet; ip netns add home")
    machine.succeed("ip link add wg0 type veth peer name phone0; ip link set phone0 netns phone")
    machine.succeed("ip link add uplink type veth peer name wan0; ip link set wan0 netns internet")
    machine.succeed("ip link add home0 type veth peer name lan0; ip link set lan0 netns home")
    machine.succeed("ip addr add 10.77.0.1/32 dev wg0; ip link set wg0 up")
    machine.succeed("ip route add 10.77.0.3/32 dev wg0")
    machine.succeed("ip -n phone addr add 10.77.0.3/32 dev phone0; ip -n phone link set phone0 up; ip -n phone link set lo up")
    machine.succeed("ip -n phone route add 10.77.0.1/32 dev phone0; ip -n phone route add default via 10.77.0.1")
    machine.succeed("ip addr add 192.168.100.1/24 dev uplink; ip link set uplink up")
    machine.succeed("ip -n internet addr add 192.168.100.2/24 dev wan0; ip -n internet link set wan0 up; ip -n internet link set lo up")
    machine.succeed("ip -n internet addr add 8.8.8.8/32 dev lo; ip route add 8.8.8.8/32 via 192.168.100.2")
    machine.succeed("ip addr add 192.168.99.1/24 dev home0; ip link set home0 up")
    machine.succeed("ip -n home addr add 192.168.99.2/24 dev lan0; ip -n home link set lan0 up; ip -n home link set lo up")
    machine.succeed("ip -n home addr add 10.77.0.2/32 dev lo; ip route add 10.77.0.2/32 via 192.168.99.2")
    machine.succeed("ip -n home route add default via 192.168.99.1")
    # No return route to the phone on the internet node: replies require NAT.
    machine.succeed("ip netns exec internet python -m http.server 8080 >/tmp/wan.log 2>&1 &")
    machine.succeed("ip netns exec home python -m http.server 8080 >/tmp/home.log 2>&1 &")
    machine.succeed("python -m http.server 80 >/tmp/web.log 2>&1 &")
    machine.succeed("python -m http.server 9090 >/tmp/admin.log 2>&1 &")
    machine.wait_until_succeeds("curl -fsS http://8.8.8.8:8080 >/dev/null")
    machine.wait_until_succeeds("curl -fsS http://10.77.0.2:8080 >/dev/null")
    machine.wait_until_succeeds("curl -fsS http://127.0.0.1:9090 >/dev/null")
    phone = "ip netns exec phone curl -fsS --connect-timeout 1 --max-time 2 "
    machine.succeed(phone + "http://8.8.8.8:8080 >/dev/null")
    machine.succeed("grep -F '192.168.100.1' /tmp/wan.log")
    machine.succeed(phone + "http://10.77.0.1 >/dev/null")
    machine.fail(phone + "http://10.77.0.1:9090")
    machine.fail(phone + "http://37.27.31.37:9090")
    machine.fail(phone + "http://10.77.0.2:8080")
    machine.fail(phone + "http://192.168.99.2:8080")
    machine.fail(phone + "http://169.254.169.254")
    # Even if IPv6 forwarding is later enabled, the firewall must fail closed.
    machine.succeed("ip -6 addr add fd77:77::1/64 dev wg0 nodad")
    machine.succeed("ip -n phone -6 addr add fd77:77::3/64 dev phone0 nodad; ip -n phone -6 route add default via fd77:77::1")
    machine.succeed("ip -6 addr add fd77:100::1/64 dev uplink nodad")
    machine.succeed("ip -n internet -6 addr add fd77:100::2/64 dev wan0 nodad; ip -n internet -6 addr add 2001:4860::8888/128 dev lo nodad")
    machine.succeed("ip -6 route add 2001:4860::8888/128 via fd77:100::2; sysctl -w net.ipv6.conf.all.forwarding=1")
    machine.fail("ip netns exec phone ping -6 -c 1 -W 1 2001:4860::8888")
    machine.fail("ip netns exec phone ping -6 -c 1 -W 1 fd77:77::1")
    machine.succeed("systemctl restart firewall.service")
    machine.succeed(phone + "http://8.8.8.8:8080 >/dev/null")
    machine.fail(phone + "http://10.77.0.1:9090")
    machine.succeed("test $(iptables -S INPUT | grep -c -- '-j wg-mobile-input') = 1")
    machine.succeed("test $(iptables -S FORWARD | grep -c -- '-j wg-mobile-forward') = 1")
  '';
}
