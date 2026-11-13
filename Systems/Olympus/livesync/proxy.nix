{ config, lib, ... }:
let
  cfg = config.olympusLiveSync;
in
{
  config = lib.mkIf (cfg.hostname != null) {
    caddyReverseProxy.hosts.${cfg.hostname} = {
      upstream = null;
      waf = {
        mode = "DetectionOnly";
        # CouchDB authenticates replication writes. Avoid buffering/parsing
        # encrypted documents/attachments as forms; retain header/URI rules.
        # These rules exist ONLY in this hostname's Coraza instance.
        beforeRules = ''
          # Coraza's configuration ceiling is 1 GiB. Replication bodies below
          # bypass inspection entirely; CouchDB enforces its upstream 4 GiB cap.
          SecRequestBodyLimit 1073741824
          SecRequestBodyNoFilesLimit 1073741824
          SecRule REQUEST_METHOD "@rx ^(?:PUT|POST)$" "id:1200001,phase:1,pass,nolog,chain"
            SecRule REQUEST_FILENAME "@rx ^/obsidian-livesync(?:/|$)" "ctl:requestBodyAccess=Off"
        '';
      };
      extraConfig = ''
        route {
          ${lib.optionalString (cfg.access == "vpn") ''
            @outside not remote_ip 127.0.0.1 10.77.0.0/24
            respond @outside "WireGuard required" 403
          ''}
          reverse_proxy 127.0.0.1:5984 {
            flush_interval -1
          }
        }
      '';
    };
  };
}
