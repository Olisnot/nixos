{ pkgs }:
pkgs.testers.runNixOSTest {
  name = "olympus-freshrss";
  nodes.machine = { config, lib, ... }: {
    imports = [
      ./freshrss.nix
      ../../nixosModules/services/caddy.nix
    ];
    virtualisation.memorySize = 2048;
    caddyReverseProxy = {
      enable = true;
      waf.enable = true;
      hosts."freshrss.opmsonline.org".useInternalTls = true;
    };
    networking.hosts."127.0.0.1" = [ "freshrss.opmsonline.org" ];
    services.caddy.virtualHosts."freshrss.opmsonline.org".listenAddresses = [ "127.0.0.1" ];
    # Avoid any external feed fetching in this fixture.
    systemd.timers.freshrss-updater.wantedBy = lib.mkForce [ ];
    environment.systemPackages = [
      pkgs.curl
      config.services.freshrss.package
    ];
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("caddy.service")
    machine.wait_for_unit("freshrss-config.service")
    machine.succeed("test -s /var/lib/freshrss/config.php; test -s /etc/freshrss/admin-password")
    machine.succeed("test $(stat -c %a /etc/freshrss/admin-password) = 640")
    machine.succeed("sha256sum /etc/freshrss/admin-password > /tmp/secret-before")
    machine.succeed("sha256sum /var/lib/freshrss/users/admin/config.php > /tmp/user-before")
    machine.succeed("systemctl restart freshrss-config phpfpm-freshrss")
    machine.wait_for_unit("phpfpm-freshrss.service")
    machine.succeed("sha256sum -c /tmp/user-before")
    machine.wait_until_succeeds("test -f /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt")
    curl="curl --silent --cacert /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt --output /dev/null --write-out '%{http_code}' "
    url="https://freshrss.opmsonline.org/"
    assert machine.succeed(curl+url).strip() == "503"
    machine.succeed("install -d -m0755 /var/lib/caddy/public-ready; touch /var/lib/caddy/public-ready/freshrss")
    assert machine.succeed(curl+url).strip() in ["200","302","303"]
    machine.succeed("ip addr add 10.88.0.1/32 dev lo")
    assert machine.succeed(curl+"--interface 10.88.0.1 --header 'X-Forwarded-For: 10.77.0.3' "+url).strip() == "403"
    machine.succeed("systemctl restart freshrss-credentials freshrss-config; sha256sum -c /tmp/user-before /tmp/secret-before")
    machine.succeed("journalctl -u freshrss-config -u freshrss-credentials --no-pager > /tmp/freshrss-journal")
    machine.fail("grep -F -f /etc/freshrss/admin-password /tmp/freshrss-journal")
  '';
}
