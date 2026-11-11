{ pkgs }:

let
  credentialCheck = pkgs.writeText "romm-credential-check.py" ''
    from pathlib import Path
    import runpy
    import tempfile
    initialize = runpy.run_path("${./init-credentials.py}", run_name="test")["initialize"]
    with tempfile.TemporaryDirectory(dir="/tmp") as temporary:
        root = Path(temporary)
        directory, database = root / "credentials", root / "mysql"
        initialize(directory, database)
        before = {p.name: p.read_bytes() for p in directory.iterdir()}
        initialize(directory, database)
        assert before == {p.name: p.read_bytes() for p in directory.iterdir()}
        (directory / "database.env").unlink()
        try:
            initialize(directory, database)
        except RuntimeError:
            pass
        else:
            raise AssertionError("Partial credentials must not be overwritten")
        assert (directory / "app.env").read_bytes() == before["app.env"]
        database.mkdir()
        (database / "existing-data").touch()
        try:
            initialize(root / "different-credentials", database)
        except RuntimeError:
            pass
        else:
            raise AssertionError("Existing database state must prevent fresh credentials")
        assert not (root / "different-credentials/app.env").exists()
  '';
  app = pkgs.writeText "mock-romm-server.py" ''
    import http.server
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            self.reply(b"mock-romm")
        def do_PUT(self):
            remaining = int(self.headers.get("Content-Length", "0"))
            total = 0
            while remaining:
                part = self.rfile.read(min(65536, remaining))
                if not part: break
                total += len(part)
                remaining -= len(part)
            self.reply(str(total).encode())
        def reply(self, body):
            self.send_response(200)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *args): pass
    http.server.ThreadingHTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
  '';
  files = pkgs.runCommand "romm-fixture-files" { } ''
    mkdir -p $out/app $out/bin $out/tmp
    cp ${app} $out/app/server.py
    printf '#!${pkgs.runtimeShell}\nexit 0\n' > $out/bin/healthcheck.sh
    chmod 755 $out/bin/healthcheck.sh
    chmod 1777 $out/tmp
  '';
  image = pkgs.dockerTools.buildLayeredImage {
    name = "romm-fixture";
    tag = "test";
    contents = [
      pkgs.busybox
      pkgs.python3
      files
    ];
    config = {
      Env = [ "PATH=/bin" ];
      Cmd = [
        "${pkgs.python3}/bin/python3"
        "/app/server.py"
      ];
    };
  };
in
pkgs.testers.runNixOSTest {
  name = "olympus-romm";
  nodes = {
    server = { lib, ... }: {
      imports = [
        ../../../nixosModules/networking/wireguard-link.nix
        ../../../nixosModules/services/caddy.nix
        ../wireguard-mobile.nix
        ./default.nix
      ];
      virtualisation.memorySize = 2048;
      virtualisation.diskSize = 8192;
      time.timeZone = "UTC";
      users.groups.media.gid = 993;
      romm.image = lib.mkForce "romm-fixture:test";
      romm.databaseImage = lib.mkForce "romm-fixture:test";
      virtualisation.oci-containers.containers = {
        romm.imageFile = image;
        romm-db = {
          imageFile = image;
          cmd = [
            "/bin/sh"
            "-c"
            "exec sleep 2147483647"
          ];
        };
      };
      wireguardLink = {
        enable = true;
        address = "10.77.0.1";
        peerAddress = "10.77.0.2";
        peerPublicKey = "cgFioflbrw7Jp9BxZK0kEbxcuUaxVOecMpt7vDTgRR8=";
        listenPort = 51820;
      };
      networking.wg-quick.interfaces.wg0.generatePrivateKeyFile = lib.mkForce true;
      olympusMobileVpn = {
        externalInterface = "uplink";
        clients = lib.mkForce [
          {
            address = "10.77.0.3";
            publicKey = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          }
        ];
      };
      virtualisation.fileSystems."/srv/media" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "mode=2770"
          "gid=993"
        ];
      };
      systemd.services.romm-library.script = lib.mkForce ''
        findmnt --noheadings --types tmpfs --mountpoint /srv/media >/dev/null
        mkdir -p /srv/media/library/roms
      '';
      caddyReverseProxy = {
        enable = true;
        openFirewall = true;
        waf.enable = true;
        hosts."romm.opmsonline.org".useInternalTls = lib.mkForce true;
      };
      environment.systemPackages = [
        pkgs.curl
        pkgs.python3
        pkgs.wireguard-tools
      ];
    };
    client = { ... }: {
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
    server.wait_for_unit("docker-romm.service")
    server.wait_for_unit("caddy.service")
    server.wait_until_succeeds("test $(curl -fsS http://127.0.0.1:8082) = mock-romm")
    server.succeed("python ${credentialCheck}")
    server.succeed("python - <<'PY'\nfrom pathlib import Path\nimport stat\np=Path('/etc/romm')\ndef env(name): return dict(line.split('=',1) for line in (p/name).read_text().splitlines())\na,b=env('app.env'),env('database.env')\nassert a['DB_PASSWD']==b['MARIADB_PASSWORD']\nassert len(a['ROMM_AUTH_SECRET_KEY'])==64\nassert 'MARIADB_ROOT_PASSWORD' not in a\nassert 'ROMM_AUTH_SECRET_KEY' not in b\nfor name in ['app.env','database.env']: assert stat.S_IMODE((p/name).stat().st_mode)==0o600\nPY")
    server.succeed("docker exec romm sh -c 'test $(id -u) = 1000; echo fixture > /romm/library/roms/upload-test.bin'")
    server.succeed("test -f /srv/media/library/roms/upload-test.bin")
    server_ip = json.loads(server.succeed("ip -j -4 addr show dev eth1"))[0]["addr_info"][0]["local"]
    url = "curl -ksS --resolve romm.opmsonline.org:443:" + server_ip
    assert client.succeed(url + " -o /dev/null -w '%{http_code}' https://romm.opmsonline.org/").strip() == "503"
    server.succeed("install -d -m 0755 /var/lib/caddy/public-ready; touch /var/lib/caddy/public-ready/romm")
    assert client.succeed(url + " https://romm.opmsonline.org/").strip() == "mock-romm"
    client.fail("curl -sS --connect-timeout 1 --max-time 2 http://" + server_ip + ":8082")

    # Real WireGuard client; direct access to the container IP is blocked too.
    server_key = server.succeed("wg show wg0 public-key").strip()
    client.succeed("umask 077; wg genkey > /tmp/client-private")
    client_key = client.succeed("wg pubkey < /tmp/client-private").strip()
    server.succeed("wg set wg0 peer " + shlex.quote(client_key) + " allowed-ips 10.77.0.3/32")
    romm_ip = server.succeed("docker inspect --format '{{(index .NetworkSettings.Networks \"romm-olympus\").IPAddress}}' romm").strip()
    db_ip = server.succeed("docker inspect --format '{{(index .NetworkSettings.Networks \"romm-olympus\").IPAddress}}' romm-db").strip()
    client.succeed("ip link add wg0 type wireguard; ip addr add 10.77.0.3/32 dev wg0")
    client.succeed("wg set wg0 private-key /tmp/client-private peer " + shlex.quote(server_key) + " endpoint " + server_ip + ":51820 allowed-ips 10.77.0.1/32,8.8.8.8/32," + romm_ip + "/32," + db_ip + "/32 persistent-keepalive 1")
    client.succeed("ip link set wg0 up; ip route add 10.77.0.1/32 dev wg0; ip route add 8.8.8.8/32 dev wg0")
    for address, port in [(romm_ip, 8080), (db_ip, 3306)]:
        client.succeed("ip route add " + address + "/32 dev wg0")
        client.fail("curl -sS --connect-timeout 1 --max-time 2 http://" + address + ":" + str(port))
        client.succeed("ip route replace " + address + "/32 via " + server_ip)
        client.fail("curl -sS --connect-timeout 1 --max-time 2 http://" + address + ":" + str(port))
    client.fail("curl -sS --connect-timeout 1 --max-time 2 http://10.77.0.1:8082")

    # Docker must not break the existing phone internet exit or container egress.
    server.succeed("ip netns add internet; ip link add uplink type veth peer name internet0; ip link set internet0 netns internet")
    server.succeed("ip addr add 192.0.2.1/30 dev uplink; ip link set uplink up")
    server.succeed("ip -n internet addr add 192.0.2.2/30 dev internet0; ip -n internet link set internet0 up; ip -n internet link set lo up; ip -n internet addr add 8.8.8.8/32 dev lo")
    server.succeed("ip route add 8.8.8.8/32 via 192.0.2.2; ip netns exec internet python ${app} >/tmp/internet.log 2>&1 &")
    client.wait_until_succeeds("test $(curl -fsS --max-time 3 http://8.8.8.8:8080) = mock-romm")
    server.succeed("docker exec romm python3 -c \"import urllib.request; assert urllib.request.urlopen('http://8.8.8.8:8080',timeout=3).read()==b'mock-romm'\"")
    server.succeed("systemctl restart firewall.service")
    server.succeed("iptables -C DOCKER-USER -j olympus-romm-forward")
    client.succeed("test $(curl -fsS --max-time 3 http://8.8.8.8:8080) = mock-romm")
    client.fail("curl -sS --connect-timeout 1 --max-time 2 http://" + romm_ip + ":8080")

    server.succeed("systemctl restart docker.service; systemctl start docker-romm.service")
    server.wait_until_succeeds("test $(curl -fsS http://127.0.0.1:8082) = mock-romm")
    server.succeed("iptables -C DOCKER-USER -j olympus-romm-forward")
    client.succeed("test $(curl -fsS --max-time 3 http://8.8.8.8:8080) = mock-romm")
    new_romm_ip = server.succeed("docker inspect --format '{{(index .NetworkSettings.Networks \"romm-olympus\").IPAddress}}' romm").strip()
    client.succeed("ip route replace " + new_romm_ip + "/32 via " + server_ip)
    client.fail("curl -sS --connect-timeout 1 --max-time 2 http://" + new_romm_ip + ":8080")
    server.succeed("chown 1234:1234 /var/lib/romm/mysql; systemd-tmpfiles --create /etc/tmpfiles.d/rommDirs.conf; test $(stat -c %u /var/lib/romm/mysql) = 1234")

    # A >13 MiB binary chunk passes without Coraza form/body buffering. The
    # pinned real app enforces upload authorization and a 64 MiB chunk cap;
    # this fixture tests proxy plumbing, not RomM application authorization.
    client.succeed("head -c 14680064 /dev/zero > /tmp/chunk")
    result = client.succeed(url + " -X PUT -H 'Content-Type: application/octet-stream' --data-binary @/tmp/chunk https://romm.opmsonline.org/api/roms/upload/00000000-0000-4000-8000-000000000001")
    assert result.strip() == "14680064"
    client.succeed("head -c 83886080 /dev/zero > /tmp/oversize")
    assert client.succeed(url + " -X PUT --data-binary @/tmp/oversize -o /dev/null -w '%{http_code}' https://romm.opmsonline.org/api/roms/upload/00000000-0000-4000-8000-000000000001").strip() == "413"
  '';
}
