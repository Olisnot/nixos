{ pkgs }:

let
  responder = pkgs.writeText "mock-access-vpn-internet.py" ''
    import http.server
    import os
    import socket
    import struct
    import threading
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_POST(self):
            body=self.rfile.read(int(self.headers.get("Content-Length","0")))
            reply=str(len(body)).encode()
            self.send_response(200)
            self.send_header("Content-Length",str(len(reply)))
            self.end_headers()
            self.wfile.write(reply)
        def do_GET(self):
            body = b"x" * 10485760 if self.path == "/large" else self.client_address[0].encode()
            self.send_response(200)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *args): pass
    class V6(http.server.ThreadingHTTPServer):
        address_family = socket.AF_INET6
    for server in [http.server.ThreadingHTTPServer(("0.0.0.0",8088),Handler), V6(("::",8089),Handler)]:
        threading.Thread(target=server.serve_forever,daemon=True).start()
    def serve_dns(address):
        dns=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
        dns.bind((address,53))
        while True:
            data,client=dns.recvfrom(4096)
            end=12
            while data[end]: end+=data[end]+1
            end+=1
            kind=struct.unpack("!H",data[end:end+2])[0]
            question=data[12:end+4]
            if kind in (1,28):
                payload=socket.inet_aton("8.8.8.8") if kind==1 else socket.inet_pton(socket.AF_INET6,"2001:db8:88::1")
                answer=b"\xc0\x0c"+struct.pack("!HHIH",kind,1,0,len(payload))+payload
                reply=data[:2]+struct.pack("!HHHHH",0x8180,1,1,0,0)+question+answer
            else:
                reply=data[:2]+struct.pack("!HHHHH",0x8180,1,0,0,0)+question
            dns.sendto(reply,client)
    for address in os.environ.get("DNS_BIND_ADDRESSES","0.0.0.0").split(","):
        threading.Thread(target=serve_dns,args=(address,),daemon=True).start()
    threading.Event().wait()
  '';
  profile = pkgs.writeText "mock-access-mullvad-profile.py" ''
    from pathlib import Path
    import subprocess
    private=Path("/tmp/provider-client-private").read_text().strip()
    public=subprocess.check_output(["wg","pubkey"],input=Path("/tmp/provider-private").read_bytes()).decode().strip()
    path=Path("/etc/wireguard/mullvad.conf")
    path.parent.mkdir(mode=0o700,exist_ok=True)
    path.write_text("[Interface]\nPrivateKey = "+private+"\nAddress = 10.64.0.2/32, fd00:64::2/128\nDNS = 10.64.0.1\n[Peer]\nPublicKey = "+public+"\nAllowedIPs = 0.0.0.0/0, ::/0\nEndpoint = 192.0.2.2:51821\nPersistentKeepalive = 1\n")
    path.chmod(0o600)
  '';
  clientConfig = address: lockdown: { lib, ... }: {
    imports = [
      ../../nixosModules/networking/wireguard-link.nix
      ../../nixosModules/networking/wireguard-client-lockdown.nix
    ];
    wireguardLink = {
      enable = true;
      inherit address;
      extraAddresses = [ "fd77:77::${lib.last (lib.splitString "." address)}/128" ];
      peerAddress = "10.77.0.1";
      peerPublicKey = "ZAEdn9OvlAMOka7IuU2WnWn6l8TR9nYTZ6O08I/cqyM=";
      peerAllowedIPs = [
        "0.0.0.0/0"
        "::/0"
      ];
      endpoint = "37.27.31.37:51820";
    };
    networking.wg-quick.interfaces.wg0 = {
      # Configure keys/routes before starting: never contact the real VPS.
      autostart = false;
      generatePrivateKeyFile = lib.mkForce true;
      dns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      mtu = 1280;
    };
    wireguardClientLockdown.enable = lockdown;
    environment.systemPackages = [
      pkgs.curl
      pkgs.wireguard-tools
      pkgs.dig
    ];
  };
in
pkgs.testers.runNixOSTest {
  name = "wireguard-mullvad-egress";
  nodes = {
    gateway = { lib, ... }: {
      imports = [
        ../../nixosModules/networking/wireguard-link.nix
        ../../nixosModules/media/romm.nix
        ./romm/firewall.nix
        ./wireguard-mobile.nix
        ./wireguard-mullvad.nix
        ./media/mullvad.nix
      ];
      virtualisation.memorySize = 1536;
      # Exercise the Docker forwarding integration without pulling any images.
      virtualisation.docker.enable = true;
      romm.bridgeName = "br-romm";
      services.qbittorrent.enable = true;
      qbittorrentMullvad = {
        webuiAddress = "127.0.0.1";
        accessService = null;
      };
      wireguardLink = {
        enable = true;
        address = "10.77.0.1";
        peerAddress = "10.77.0.2";
        peerAllowedIPs = [
          "10.77.0.2/32"
          "fd77:77::2/128"
        ];
        peerPublicKey = "cgFioflbrw7Jp9BxZK0kEbxcuUaxVOecMpt7vDTgRR8=";
        listenPort = 51820;
      };
      networking.wg-quick.interfaces.wg0.generatePrivateKeyFile = lib.mkForce true;
      olympusMobileVpn = {
        mullvad = {
          enable = true;
          includeZeus = true;
        };
        allowedServicePorts = [ 8087 ];
        clients = lib.mkForce [
          {
            address = "10.77.0.3";
            publicKey = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          }
        ];
      };
      networking.firewall = {
        interfaces.wg0.allowedTCPPorts = [ 8087 ];
        allowedTCPPorts = [
          8088
          8089
        ];
        allowedUDPPorts = [ 53 ]; # Test-only LAN DNS, which Zeus must not use.
      };
      environment.systemPackages = [
        pkgs.curl
        pkgs.python3
        pkgs.wireguard-tools
        pkgs.dig
      ];
    };
    zeus = clientConfig "10.77.0.2" true;
    phone = clientConfig "10.77.0.3" false;
  };
  testScript = ''
    import json
    start_all()
    gateway.wait_for_unit("wg-quick-wg0.service")
    gateway.wait_for_unit("docker.service")
    gateway_ip=json.loads(gateway.succeed("ip -j -4 addr show dev eth1"))[0]["addr_info"][0]["local"]
    gateway_v6=next(a["local"] for a in json.loads(gateway.succeed("ip -j -6 addr show dev eth1"))[0]["addr_info"] if a["scope"]=="global")
    gateway.succeed("ip addr add 37.27.31.37/32 dev lo")
    gateway.succeed("ip netns add provider; ip link add uplink type veth peer name provider0; ip link set provider0 netns provider")
    gateway.succeed("ip addr add 192.0.2.1/30 dev uplink; ip link set uplink up; ip -n provider addr add 192.0.2.2/30 dev provider0; ip -n provider link set provider0 up; ip -n provider link set lo up")
    gateway.succeed("ip -n provider addr add 8.8.8.8/32 dev lo; ip -n provider addr add 1.1.1.1/32 dev lo; ip -n provider addr add 1.0.0.1/32 dev lo; ip route add 8.8.8.8/32 via 192.0.2.2")
    gateway.succeed("ip -n provider -6 addr add 2001:db8:88::1/128 dev lo nodad")
    gateway.succeed("umask 077; wg genkey > /tmp/provider-private; wg genkey > /tmp/provider-client-private")
    public=gateway.succeed("wg pubkey < /tmp/provider-client-private").strip()
    gateway.succeed("ip -n provider link add wg-exit type wireguard; ip netns exec provider wg set wg-exit private-key /tmp/provider-private listen-port 51821 peer "+public+" allowed-ips 10.64.0.2/32,fd00:64::2/128")
    gateway.succeed("ip -n provider addr add 10.64.0.1/24 dev wg-exit; ip -n provider -6 addr add fd00:64::1/64 dev wg-exit nodad; ip -n provider link set wg-exit up")
    gateway.succeed("DNS_BIND_ADDRESSES=1.1.1.1,1.0.0.1,10.64.0.1 ip netns exec provider python ${responder} >/tmp/provider.log 2>&1 &")
    gateway.wait_until_succeeds("test $(curl -fsS http://8.8.8.8:8088) = 192.0.2.1")
    gateway.succeed("python ${profile}; systemctl reset-failed; systemctl start qbt-mullvad qbittorrent qbt-webui.socket wg-mullvad-egress")
    gateway.wait_for_unit("wg-mullvad-egress.service")
    gateway.succeed("python ${./wireguard-mullvad-route.py} up") # idempotent owned rules
    gateway.succeed("mkdir -p /tmp/private-site; echo private-service > /tmp/private-site/index.html; python -m http.server 8087 --bind 10.77.0.1 --directory /tmp/private-site >/tmp/private-http.log 2>&1 &")
    gateway.succeed("python ${responder} >/tmp/lan-dns.log 2>&1 &")
    gateway.wait_until_succeeds("dig +time=1 +tries=1 @127.0.0.1 vpn-only.test | grep -F 8.8.8.8")
    server_key=gateway.succeed("wg show wg0 public-key").strip()
    for client,address in [(zeus,"10.77.0.2"),(phone,"10.77.0.3")]:
        client.wait_for_unit("multi-user.target")
        client.succeed("ip route add 37.27.31.37/32 via "+gateway_ip)
        client.succeed("systemctl start wg-quick-wg0.service")
        key=client.succeed("wg show wg0 public-key").strip()
        gateway.succeed("wg set wg0 peer "+key+" allowed-ips "+address+"/32,fd77:77::"+address.rsplit(".",1)[1]+"/128")
        client.succeed("wg set wg0 peer ZAEdn9OvlAMOka7IuU2WnWn6l8TR9nYTZ6O08I/cqyM= remove; wg set wg0 peer "+server_key+" allowed-ips 0.0.0.0/0,::/0 endpoint 37.27.31.37:51820 persistent-keepalive 1")
        client.wait_until_succeeds("test $(curl -4 -fsS --max-time 4 http://vpn-only.test:8088) = 10.64.0.2")
        client.succeed("test $(curl -fsS http://10.77.0.1:8087) = private-service")
        client.fail("curl -6 -fsS --max-time 2 http://vpn-only.test:8089")
    # Old Tailscale-style default routing must not outrank the full tunnel.
    zeus.succeed("ip route add default via "+gateway_ip+" table 52; ip rule add pref 5270 lookup 52")
    zeus.succeed("test $(curl -4 -fsS --max-time 4 http://vpn-only.test:8088) = 10.64.0.2")
    zeus.succeed("ip link set wg0 mtu 1420; curl -4 -fsS --max-time 15 http://vpn-only.test:8088/large -o /tmp/large; test $(stat -c %s /tmp/large) = 10485760")
    zeus.succeed("test $(curl -4 -fsS --max-time 15 --data-binary @/tmp/large http://vpn-only.test:8088/) = 10485760")
    gateway.succeed("test $(curl -fsS http://8.8.8.8:8088) = 192.0.2.1")
    gateway.succeed("ip netns exec qbt-mullvad curl -fsS http://8.8.8.8:8088 | grep -Fx 10.64.0.2")
    gateway.succeed("systemctl restart firewall.service")
    zeus.succeed("test $(curl -4 -fsS --max-time 4 http://vpn-only.test:8088) = 10.64.0.2")

    gateway.succeed("ip -n provider link set wg-exit down")
    for client in [zeus,phone]:
        client.fail("curl -4 -fsS --max-time 3 http://8.8.8.8:8088")
        client.fail("curl -4 -fsS --max-time 3 http://vpn-only.test:8088")
        client.succeed("test $(curl -fsS http://10.77.0.1:8087) = private-service")
    gateway.succeed("ip -n provider link set wg-exit up; ip -n qbt-mullvad link del mullvad0")
    zeus.fail("curl -4 -fsS --max-time 3 http://8.8.8.8:8088")
    gateway.succeed("ip link del qbt-mv-host")
    gateway.fail("ip -4 route get 8.8.8.8 from 10.77.0.2 iif wg0") # unreachable, no RPDB fall-through
    zeus.fail("curl -4 -fsS --max-time 3 http://8.8.8.8:8088")
    gateway.succeed("systemctl restart qbt-mullvad.service; systemctl start wg-mullvad-egress.service")
    zeus.wait_until_succeeds("test $(curl -4 -fsS --max-time 4 http://vpn-only.test:8088) = 10.64.0.2")
    gateway.succeed("systemctl stop wg-mullvad-egress.service; iptables -Z wg-mobile-forward")
    zeus.fail("curl -4 -fsS --max-time 3 http://8.8.8.8:8088")
    gateway.succeed("iptables -nvxL wg-mobile-forward | awk '$3 == \"DROP\" && $6 == \"wg0\" && $1 > 0 {found=1} END {exit !found}'")
    zeus.succeed("test $(curl -fsS http://10.77.0.1:8087) = private-service")
    gateway.succeed("systemctl start wg-mullvad-egress.service")
    zeus.wait_until_succeeds("test $(curl -4 -fsS --max-time 4 http://vpn-only.test:8088) = 10.64.0.2")

    # Client kill switch survives deliberate client disconnection and a working
    # physical fallback route. Private LAN access remains, LAN DNS is blocked.
    zeus.succeed("systemctl stop wg-quick-wg0.service; ip route add 8.8.8.8/32 via "+gateway_ip)
    zeus.fail("curl -4 -fsS --max-time 3 http://8.8.8.8:8088")
    zeus.succeed("curl -fsS --max-time 3 http://"+gateway_ip+":8088 >/dev/null")
    zeus.fail("dig +time=1 +tries=1 @"+gateway_ip+" vpn-only.test")
    gateway.succeed("curl -g -6 -fsS --max-time 3 'http://["+gateway_v6+"]:8089' >/dev/null")
    zeus.fail("curl -g -6 -fsS --max-time 3 'http://["+gateway_v6+"]:8089'")
    zeus.succeed("systemctl restart firewall.service")
    zeus.fail("curl -4 -fsS --max-time 3 http://8.8.8.8:8088")
  '';
}
