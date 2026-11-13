{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.olympusLiveSync;
in
{
  imports = [ ./proxy.nix ];
  options.olympusLiveSync = {
    hostname = lib.mkOption {
      type = lib.types.nullOr (lib.types.strMatching "[a-z0-9][a-z0-9.-]*\\.[a-z]+");
      default = null;
      description = "HTTPS hostname; null leaves CouchDB local pending DNS/access approval.";
    };
    access = lib.mkOption {
      type = lib.types.enum [
        "vpn"
        "public"
      ];
      default = "vpn";
      description = "VPN source restriction, or explicitly approved public authenticated access.";
    };
  };
  config = {
    services.couchdb = {
      enable = true;
      bindAddress = "127.0.0.1";
      port = 5984;
      databaseDir = "/var/lib/couchdb";
      viewIndexDir = "/var/lib/couchdb";
      adminPass = null; # Never interpolate credentials into a Nix derivation.
      extraConfigFiles = [ "/etc/obsidian-livesync/admin.ini" ];
      extraConfig = {
        couchdb = {
          single_node = true;
          max_document_size = 50000000;
        };
        cluster.n = 1;
        chttpd = {
          enable_cors = true; # CouchDB >= 3.2: NOT [httpd].
          require_valid_user = true;
          max_http_request_size = 4294967296;
          bind_address = "127.0.0.1";
        };
        chttpd_auth.require_valid_user = true;
        httpd = {
          bind_address = "127.0.0.1";
          "WWW-Authenticate" = "Basic realm=\"couchdb\"";
        };
        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = true;
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET, PUT, POST, HEAD, DELETE";
          max_age = 3600;
        };
        log.level = "warning";
      };
    };
    systemd.services.livesync-credentials = {
      description = "Create persistent LiveSync runtime credentials once";
      before = [ "couchdb.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        UMask = "0077";
        ExecStart = "${pkgs.python3}/bin/python3 ${./manage.py} credentials";
      };
    };
    systemd.services.couchdb = {
      requires = [ "livesync-credentials.service" ];
      after = [ "livesync-credentials.service" ];
      environment.ERL_EPMD_ADDRESS = "127.0.0.1";
      serviceConfig.UMask = "0077";
    };
    systemd.services.livesync-provision = {
      description = "Ensure LiveSync databases, scoped user and security (never reset data)";
      wantedBy = [ "multi-user.target" ];
      requires = [ "couchdb.service" ];
      after = [ "couchdb.service" ];
      partOf = [ "couchdb.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        UMask = "0077";
        LoadCredential = "credentials.json:/etc/obsidian-livesync/credentials.json";
        ExecStart = "${pkgs.python3}/bin/python3 ${./manage.py} provision";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "livesync-check";
        text = ''
          exec ${pkgs.python3}/bin/python3 ${./manage.py} check "$@"
        '';
      })
    ];
    assertions = [
      {
        assertion =
          config.services.couchdb.bindAddress == "127.0.0.1"
          && !(builtins.elem 5984 config.networking.firewall.allowedTCPPorts);
        message = "LiveSync CouchDB must remain loopback-only with port 5984 closed.";
      }
    ];
  };
}
