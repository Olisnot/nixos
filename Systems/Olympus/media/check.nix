{ pkgs }:

let
  testPkgs = import pkgs.path {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfreePredicate = package: pkgs.lib.getName package == "unrar";
  };
in
testPkgs.testers.runNixOSTest {
  name = "olympus-media";
  nodes = {
    server = { lib, ... }: {
      imports = [
        ../../../nixosModules/networking/wireguard-link.nix
        ../wireguard-mobile.nix
        ../reverse-proxy.nix
        ./default.nix
      ];
      virtualisation.memorySize = 4096;
      virtualisation.cores = 2;
      virtualisation.diskSize = 8192;
      users.groups.media.gid = 1000;
      # Provider isolation and failure behaviour have a separate simulated-VPN
      # test. This test retains the original direct private UI for app startup.
      qbittorrentMullvad.enable = lib.mkForce false;
      wireguardLink = {
        enable = true;
        address = "10.77.0.1";
        peerAddress = "10.77.0.2";
        peerPublicKey = "cgFioflbrw7Jp9BxZK0kEbxcuUaxVOecMpt7vDTgRR8=";
        listenPort = 51820;
      };
      networking.wg-quick.interfaces.wg0.generatePrivateKeyFile = lib.mkForce true;
      olympusMobileVpn.clients = lib.mkForce [
        {
          address = "10.77.0.3";
          publicKey = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        }
      ];
      # Storage credentials and the real Storage Box are never used by this
      # smoke test. Live CIFS permission/performance checks are still required.
      virtualisation.fileSystems."/srv/media" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "mode=2770"
          "gid=1000"
        ];
      };
      systemd.services.media-layout.script = lib.mkForce ''
        findmnt --noheadings --types tmpfs --mountpoint /srv/media >/dev/null
        mkdir -p /srv/media/library/{movies,shows} \
          /srv/media/downloads/{torrents,usenet}/{complete,incomplete}
      '';
      caddyReverseProxy.hosts = {
        "jellyfin.opmsonline.org".useInternalTls = lib.mkForce true;
        "seerr.opmsonline.org".useInternalTls = lib.mkForce true;
      };
      environment.systemPackages = [
        pkgs.curl
        pkgs.python3
        pkgs.wireguard-tools
      ];
    };
    client = { pkgs, ... }: {
      environment.systemPackages = [
        pkgs.curl
        pkgs.wireguard-tools
      ];
    };
  };
  testScript = ''
    import json
    import shlex
    start_all()
    server.wait_for_unit("wg-quick-wg0.service")
    server.wait_for_unit("media-layout.service")
    for service in ["jellyfin", "seerr", "sonarr", "radarr", "prowlarr", "bazarr", "qbittorrent", "sabnzbd", "flaresolverr", "caddy"]:
        server.wait_for_unit(service + ".service")
    server_ip = json.loads(server.succeed("ip -j -4 addr show dev eth1"))[0]["addr_info"][0]["local"]
    server_key = server.succeed("wg show wg0 public-key").strip()
    client.succeed("umask 077; wg genkey > /tmp/wg-test-private")
    client_key = client.succeed("wg pubkey < /tmp/wg-test-private").strip()
    server.succeed("wg set wg0 peer " + shlex.quote(client_key) + " allowed-ips 10.77.0.3/32")
    client.succeed("ip link add wg0 type wireguard; ip addr add 10.77.0.3/32 dev wg0")
    client.succeed("wg set wg0 private-key /tmp/wg-test-private peer " + shlex.quote(server_key) + " allowed-ips 10.77.0.1/32 endpoint " + server_ip + ":51820 persistent-keepalive 1")
    client.succeed("ip link set wg0 up; ip route add 10.77.0.1/32 dev wg0")
    for port in [6767, 7878, 8080, 8081, 8989, 9696]:
        server.wait_for_open_port(port, "10.77.0.1")
        # Authentication errors/redirects are fine; a failed TCP connection isn't.
        client.wait_until_succeeds("curl -sS --max-time 3 -o /dev/null http://10.77.0.1:" + str(port))
        client.fail("curl -sS --connect-timeout 1 --max-time 2 -o /dev/null http://" + server_ip + ":" + str(port))
    server.wait_until_succeeds("curl -fsS http://127.0.0.1:8096/System/Info/Public >/dev/null")
    server.wait_until_succeeds("curl -fsS http://127.0.0.1:5055/api/v1/status >/dev/null")
    server.wait_until_succeeds("curl -fsS http://127.0.0.1:8191/health >/dev/null")
    for port in [8096, 5055, 8191]:
        client.fail("curl -sS --connect-timeout 1 --max-time 2 -o /dev/null http://" + server_ip + ":" + str(port))
        client.fail("curl -sS --connect-timeout 1 --max-time 2 -o /dev/null http://10.77.0.1:" + str(port))
    for app, endpoint in [("jellyfin", "/System/Info/Public"), ("seerr", "/api/v1/status")]:
        host = app + ".opmsonline.org"
        request = "curl -ksS --resolve " + host + ":443:" + server_ip + " -o /dev/null -w '%{http_code}' https://" + host + endpoint
        assert client.succeed(request).strip() == "503"
        server.succeed("install -d -m 0755 /var/lib/caddy/public-ready; touch /var/lib/caddy/public-ready/" + app)
        assert client.succeed(request).strip() == "200"
    for user in ["jellyfin", "sonarr", "radarr", "bazarr", "qbittorrent", "sabnzbd"]:
        server.succeed("su -s /bin/sh " + user + " -c 'test -w /srv/media/library/movies'")
    server.fail("su -s /bin/sh jellyfin -c 'test -r /var/lib/qBittorrent/qBittorrent/config/qBittorrent.conf'")
    # Recyclarr must skip cleanly until runtime API keys are provisioned.
    server.succeed("systemctl start recyclarr.service")
    assert server.succeed("systemctl show recyclarr.service -p ConditionResult --value").strip() == "no"
    server.succeed("systemctl restart qbittorrent.service")
    server.wait_for_open_port(8080, "10.77.0.1")
  '';
}
