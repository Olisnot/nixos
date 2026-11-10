{ pkgs }:

let
  responder = pkgs.writeText "mock-mullvad.py" ''
    import http.server
    import socket
    import struct
    import threading

    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            body = self.client_address[0].encode()
            self.send_response(200)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *args):
            pass

    class V6Server(http.server.ThreadingHTTPServer):
        address_family = socket.AF_INET6

    for server in [http.server.ThreadingHTTPServer(("0.0.0.0", 8088), Handler), V6Server(("::", 8089), Handler)]:
        threading.Thread(target=server.serve_forever, daemon=True).start()
    dns = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    dns.bind(("0.0.0.0", 53))
    while True:
        packet, client = dns.recvfrom(4096)
        end = 12
        while packet[end]:
            end += packet[end] + 1
        end += 1
        kind = struct.unpack("!H", packet[end:end + 2])[0]
        question = packet[12:end + 4]
        if kind in (1, 28):
            data = socket.inet_aton("198.18.0.1") if kind == 1 else socket.inet_pton(socket.AF_INET6, "2001:db8:88::1")
            answer = b"\xc0\x0c" + struct.pack("!HHIH", kind, 1, 0, len(data)) + data
            response = packet[:2] + struct.pack("!HHHHH", 0x8180, 1, 1, 0, 0) + question + answer
        else:
            response = packet[:2] + struct.pack("!HHHHH", 0x8180, 1, 0, 0, 0) + question
        dns.sendto(response, client)
  '';
  profileWriter = pkgs.writeText "mock-mullvad-profile.py" ''
    import pathlib
    import subprocess

    key = pathlib.Path("/tmp/client-private").read_text().strip()
    public = subprocess.check_output(["wg", "pubkey"], input=pathlib.Path("/tmp/provider-private").read_bytes()).decode().strip()
    content = (
        "[Interface]\nPrivateKey = " + key + "\n"
        "Address = 10.64.0.2/32, fd00:64::2/128\nDNS = 10.64.0.1\n"
        "PostUp = touch /tmp/hook-must-not-run\n"
        "[Peer]\nPublicKey = " + public + "\n"
        "AllowedIPs = 0.0.0.0/0, ::/0\nEndpoint = 192.0.2.2:51821\nPersistentKeepalive = 1\n"
    )
    path = pathlib.Path("/etc/wireguard/mullvad.conf")
    path.parent.mkdir(mode=0o700, exist_ok=True)
    path.write_text(content)
    path.chmod(0o600)
  '';
in
pkgs.testers.runNixOSTest {
  name = "qbittorrent-mullvad";
  nodes.machine = { ... }: {
    imports = [ ./mullvad.nix ];
    virtualisation.memorySize = 1536;
    services.qbittorrent = {
      enable = true;
      serverConfig.Preferences = {
        "WebUI\\LocalHostAuth" = true;
        "WebUI\\AuthSubnetWhitelistEnabled" = false;
      };
    };
    qbittorrentMullvad = {
      webuiAddress = "127.0.0.1";
      accessService = null;
    };
    environment.systemPackages = [
      pkgs.wireguard-tools
      pkgs.iproute2
      pkgs.iptables
      pkgs.curl
      pkgs.python3
      pkgs.dig
      pkgs.util-linux
    ];
  };
  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.fail("systemctl is-active --quiet qbittorrent.service")
    machine.fail("test -e /run/netns/qbt-mullvad")
    # Invalid credentials fail before any namespace is created and cannot leak
    # a private input value into errors/journals.
    machine.succeed("install -d -m 700 /etc/wireguard; printf '%s\\n' '[Interface]' 'PrivateKey = PRIVATE-SENTINEL-DO-NOT-LOG' > /etc/wireguard/mullvad.conf; chmod 600 /etc/wireguard/mullvad.conf")
    machine.succeed("systemctl reset-failed")
    machine.fail("systemctl start qbt-mullvad.service")
    machine.fail("test -e /run/netns/qbt-mullvad")
    machine.fail("journalctl -u qbt-mullvad.service -o cat | grep -F PRIVATE-SENTINEL-DO-NOT-LOG")

    # A fake provider on an isolated network; no real account, keys, DNS or
    # Mullvad endpoint is used. The public host has its own working bypass route.
    machine.succeed("ip netns add provider; ip link add uplink type veth peer name provider0; ip link set provider0 netns provider")
    machine.succeed("ip addr add 192.0.2.1/30 dev uplink; ip link set uplink up; ip -6 addr add fd42:1::1/64 dev uplink nodad")
    machine.succeed("ip -n provider addr add 192.0.2.2/30 dev provider0; ip -n provider link set provider0 up; ip -n provider link set lo up")
    machine.succeed("ip -n provider -6 addr add fd42:1::2/64 dev provider0 nodad")
    machine.succeed("ip -n provider addr add 198.18.0.1/32 dev lo; ip -n provider -6 addr add 2001:db8:88::1/128 dev lo nodad")
    machine.succeed("ip route add 198.18.0.1/32 via 192.0.2.2; ip -6 route add 2001:db8:88::1/128 via fd42:1::2")
    machine.succeed("umask 077; wg genkey > /tmp/provider-private; wg genkey > /tmp/client-private")
    client_public = machine.succeed("wg pubkey < /tmp/client-private").strip()
    machine.succeed("ip -n provider link add wg-exit type wireguard; ip netns exec provider wg set wg-exit private-key /tmp/provider-private listen-port 51821 peer " + client_public + " allowed-ips 10.64.0.2/32,fd00:64::2/128")
    machine.succeed("ip -n provider addr add 10.64.0.1/24 dev wg-exit; ip -n provider -6 addr add fd00:64::1/64 dev wg-exit nodad; ip -n provider link set wg-exit up")
    machine.succeed("ip netns exec provider python ${responder} >/tmp/mock-provider.log 2>&1 &")
    machine.wait_until_succeeds("test $(curl -fsS --max-time 2 http://198.18.0.1:8088) = 192.0.2.1")
    machine.succeed("python ${profileWriter}")
    machine.succeed("systemctl reset-failed; systemctl start qbt-mullvad.service qbittorrent.service qbt-webui.socket")
    machine.wait_for_unit("qbittorrent.service")
    machine.succeed("pid=$(systemctl show qbittorrent.service -p MainPID --value); test $(stat -Lc %i /proc/$pid/ns/net) = $(stat -Lc %i /run/netns/qbt-mullvad)")
    # Resolve /etc symlinks inside the process mount namespace, not through
    # /proc/PID/root where absolute symlinks can reach the inspecting root.
    machine.succeed("pid=$(systemctl show qbittorrent.service -p MainPID --value); nsenter -t $pid -m -- grep -Fx 'nameserver 10.64.0.1' /etc/resolv.conf")
    machine.succeed("pid=$(systemctl show qbittorrent.service -p MainPID --value); nsenter -t $pid -m -- cat /etc/nsswitch.conf; nsenter -t $pid -m -- grep -Fx 'hosts: files dns' /etc/nsswitch.conf")
    machine.fail("test -e /tmp/hook-must-not-run")
    machine.wait_until_succeeds("curl -sS --max-time 3 -o /dev/null http://127.0.0.1:8080")
    # Probe with the same namespace, DNS mounts, daemon exclusions and UID as
    # qBittorrent, not a root shell that could borrow the host's DNS cache.
    probe = "systemd-run --quiet --wait --pipe --collect -p User=qbittorrent -p NetworkNamespacePath=/run/netns/qbt-mullvad -p 'BindReadOnlyPaths=/etc/netns/qbt-mullvad/resolv.conf:/etc/resolv.conf /etc/netns/qbt-mullvad/nsswitch.conf:/etc/nsswitch.conf' -p 'InaccessiblePaths=-/run/nscd -/run/nsncd -/run/systemd/resolve -/run/dbus/system_bus_socket' -p 'RestrictAddressFamilies=AF_INET AF_INET6 AF_NETLINK' "
    machine.wait_until_succeeds(probe + "${pkgs.curl}/bin/curl -fsS --max-time 4 http://vpn-only.test:8088 > /tmp/probe4")
    machine.succeed("test $(cat /tmp/probe4) = 10.64.0.2")
    machine.succeed(probe + "${pkgs.curl}/bin/curl -6 -fsS --max-time 4 http://vpn-only.test:8089 > /tmp/probe6")
    machine.succeed("test $(cat /tmp/probe6) = fd00:64::2")
    machine.succeed("test $(curl -fsS http://198.18.0.1:8088) = 192.0.2.1")
    machine.succeed("systemctl restart firewall.service")
    machine.succeed(probe + "${pkgs.curl}/bin/curl -fsS --max-time 4 http://vpn-only.test:8088 > /dev/null")

    # Provider outage: internet/DNS fail, private management still works.
    machine.succeed("ip -n provider link set wg-exit down")
    machine.fail(probe + "${pkgs.curl}/bin/curl -fsS --max-time 3 http://198.18.0.1:8088")
    machine.fail(probe + "${pkgs.curl}/bin/curl -fsS --max-time 3 http://vpn-only.test:8088")
    machine.succeed("curl -sS --max-time 3 -o /dev/null http://127.0.0.1:8080")
    machine.succeed("test $(curl -fsS http://198.18.0.1:8088) = 192.0.2.1")

    # Remove the device and deliberately install working host fallback routes.
    # Namespace firewall must still reject non-VPN traffic for both families.
    machine.succeed("ip -n qbt-mullvad link del mullvad0; ip -n qbt-mullvad route replace default via 169.254.77.1")
    machine.succeed("sysctl -w net.ipv4.ip_forward=1; iptables -P FORWARD ACCEPT; iptables -t nat -A POSTROUTING -s 169.254.77.2 -o uplink -j MASQUERADE")
    machine.fail(probe + "${pkgs.curl}/bin/curl -fsS --max-time 3 http://198.18.0.1:8088")
    machine.fail(probe + "${pkgs.dig}/bin/dig +time=1 +tries=1 @169.254.77.1 vpn-only.test")
    machine.succeed("ip -6 addr add fd42:77::1/64 dev qbt-mv-host nodad; ip -n qbt-mullvad -6 addr add fd42:77::2/64 dev qbt-mv-peer nodad; ip -n qbt-mullvad -6 route replace default via fd42:77::1")
    machine.succeed("sysctl -w net.ipv6.conf.all.forwarding=1; ip6tables -P FORWARD ACCEPT; ip -n provider -6 route add fd42:77::/64 via fd42:1::1")
    machine.fail(probe + "${pkgs.curl}/bin/curl -6 -fsS --max-time 3 'http://[2001:db8:88::1]:8089'")
    machine.succeed("curl -sS --max-time 3 -o /dev/null http://127.0.0.1:8080")

    # Restart restores an isolated, working tunnel without stale interfaces.
    machine.succeed("ip -n provider link set wg-exit up; systemctl restart qbt-mullvad.service")
    machine.wait_for_unit("qbittorrent.service")
    machine.wait_until_succeeds(probe + "${pkgs.curl}/bin/curl -fsS --max-time 4 http://vpn-only.test:8088 > /dev/null")
    machine.wait_until_succeeds("curl -sS --max-time 3 -o /dev/null http://127.0.0.1:8080")
    machine.succeed("systemctl stop qbt-mullvad.service")
    machine.fail("systemctl is-active --quiet qbittorrent.service")
    machine.fail("test -e /run/netns/qbt-mullvad")
    machine.fail("test -e /etc/netns/qbt-mullvad/resolv.conf")
    machine.fail("ip link show qbt-mv-host")
  '';
}
