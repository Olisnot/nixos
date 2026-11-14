{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.freshrss = {
    enable = true;
    webserver = "caddy";
    virtualHost = "freshrss.opmsonline.org";
    baseUrl = "https://freshrss.opmsonline.org";
    defaultUser = "admin";
    authType = "form";
    database.type = "sqlite";
    dataDir = "/var/lib/freshrss";
    api.enable = true;
    passwordFile = "/etc/freshrss/admin-password";
  };

  systemd.services.freshrss-credentials = {
    description = "Generate a persistent FreshRSS bootstrap password once";
    before = [ "freshrss-config.service" ];
    path = [
      pkgs.coreutils
      pkgs.openssl
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
    };
    script = ''
      install -d -m0750 -o root -g freshrss /etc/freshrss
      if ! test -e /etc/freshrss/admin-password; then
        openssl rand -hex 32 > /etc/freshrss/admin-password
      fi
      test -s /etc/freshrss/admin-password
      chown root:freshrss /etc/freshrss/admin-password
      chmod 0640 /etc/freshrss/admin-password
    '';
  };
  systemd.services.freshrss-config = {
    requires = [ "freshrss-credentials.service" ];
    after = [ "freshrss-credentials.service" ];
  };

  # Install a new local SQLite instance, but never erase existing state or
  # reset an existing account's password on a subsequent rebuild.
  systemd.services.freshrss-config.script = lib.mkForce ''
    if ! test -s ${config.services.freshrss.dataDir}/config.php; then
      ./cli/prepare.php
      ./cli/do-install.php --default-user admin --auth-type form \
        --base-url ${lib.escapeShellArg config.services.freshrss.baseUrl} \
        --language en --db-type sqlite --api-enabled
    fi
    ${config.services.phpfpm.phpPackage}/bin/php -r '
      $c = require getenv("DATA_PATH") . "/config.php";
      if (($c["db"]["type"] ?? "") !== "sqlite") {
        fwrite(STDERR, "FreshRSS migration expects SQLite; stop and review the source database type.\n");
        exit(1);
      }
    '
    ./cli/reconfigure.php \
      --base-url ${lib.escapeShellArg config.services.freshrss.baseUrl} \
      --auth-type form --api-enabled
    if ! test -s ${config.services.freshrss.dataDir}/users/admin/config.php; then
      ./cli/create-user.php --user admin \
        --password "$(cat ${config.services.freshrss.passwordFile})"
    fi
  '';

  services.phpfpm.pools.freshrss.settings = {
    "pm.max_children" = lib.mkForce 4;
    "pm.min_spare_servers" = lib.mkForce 1;
    "pm.max_spare_servers" = lib.mkForce 2;
  };

  caddyReverseProxy.hosts."freshrss.opmsonline.org" = {
    # Native FreshRSS serves PHP via a Unix socket, not a public backend port.
    upstream = null;
    readyFile = "/var/lib/caddy/public-ready/freshrss";
    waf.mode = "DetectionOnly";
    extraConfig = ''
      @outsideFreshRSS not remote_ip 127.0.0.1 10.77.0.0/24
      respond @outsideFreshRSS "WireGuard required" 403
    '';
  };
}
