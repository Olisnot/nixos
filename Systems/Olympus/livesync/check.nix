{ pkgs }:
pkgs.testers.runNixOSTest {
  name = "olympus-livesync";
  nodes.machine = { ... }: {
    imports = [
      ./default.nix
      ../../../nixosModules/services/caddy.nix
    ];
    virtualisation.memorySize = 2048;
    olympusLiveSync.hostname = "livesync.test";
    caddyReverseProxy = {
      enable = true;
      waf.enable = true;
      hosts."livesync.test".useInternalTls = true;
    };
    services.caddy.virtualHosts."livesync.test".listenAddresses = [ "127.0.0.1" ];
    networking.hosts."127.0.0.1" = [ "livesync.test" ];
    environment.systemPackages = [
      pkgs.python3
      pkgs.curl
    ];
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("livesync-provision.service")
    machine.wait_for_unit("caddy.service")
    machine.succeed("livesync-check")
    machine.wait_until_succeeds("test -f /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt")
    machine.succeed("SSL_CERT_FILE=/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt livesync-check https://livesync.test")
    machine.succeed("python ${./test.py} ${./manage.py}")
    machine.succeed("ip addr add 10.88.0.1/32 dev lo")
    machine.succeed("test $(curl --silent --cacert /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt --interface 10.88.0.1 --header 'X-Forwarded-For: 10.77.0.3' --output /dev/null --write-out '%{http_code}' https://livesync.test/obsidian-livesync) = 403")
    machine.succeed("systemctl restart couchdb; systemctl start livesync-provision")
    machine.succeed("python ${./test.py} ${./manage.py} preserved")
    machine.succeed("livesync-check")
    machine.succeed("ss -lnt | grep -F 127.0.0.1:5984")
    machine.fail("ss -lnt | grep -E '(0.0.0.0|\\*|\\[::\\]):5984'")
  '';
}
