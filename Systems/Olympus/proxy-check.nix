{ host }:

let
  inherit (host) pkgs;
  caddy = host.config.services.caddy.package;
  # Only this test derivation enables these loopback-only fixture routes.
  testHost = host.extendModules {
    modules = [
      {
        caddyReverseProxy.hosts = pkgs.lib.mkForce (
          builtins.listToAttrs (
            map
              (fixture: {
                name = "http://127.0.0.1:${fixture.port}";
                value = {
                  upstream = "127.0.0.1:18082";
                  readyFile = if fixture.port == "18083" then "{$CADDY_READY_DIR}/fixture" else null;
                  waf = {
                    inherit (fixture) mode;
                    beforeRules = ''
                      SecRule REQUEST_URI "@beginsWith /waf-test" "id:1000001,phase:1,deny,status:403,log,msg:'fixture hit'"
                    '';
                  };
                };
              })
              [
                {
                  port = "18080";
                  mode = "DetectionOnly";
                }
                {
                  port = "18081";
                  mode = "On";
                }
                {
                  port = "18083";
                  mode = "DetectionOnly";
                }
              ]
          )
        );
        services.caddy.virtualHosts =
          pkgs.lib.genAttrs [ "http://127.0.0.1:18080" "http://127.0.0.1:18081" "http://127.0.0.1:18083" ]
            (_: {
              listenAddresses = [ "127.0.0.1" ];
            });
        services.caddy.extraConfig = ''
          http://127.0.0.1:18082 {
            bind 127.0.0.1
            respond "proxy fixture" 200
          }
        '';
      }
    ];
  };
in
pkgs.runCommand "olympus-proxy-check"
  {
    nativeBuildInputs = [
      caddy
      pkgs.curl
      pkgs.gnugrep
    ];
  }
  ''
    export HOME=$TMPDIR
    export XDG_DATA_HOME=$TMPDIR/data
    export XDG_CONFIG_HOME=$TMPDIR/config
    export CADDY_READY_DIR=$TMPDIR/public-ready
    caddy list-modules > modules.txt
    # Upstream calls the module http.handlers.waf, not http.handlers.coraza_waf.
    grep -Fx http.handlers.waf modules.txt
    caddy build-info > build-info.txt
    grep -E '^dep[[:space:]]+github.com/corazawaf/coraza-caddy/v2[[:space:]]+v2\.6\.2[[:space:]]*$' build-info.txt
    grep -E '^dep[[:space:]]+github.com/corazawaf/coraza-coreruleset/v4[[:space:]]+v4\.25\.0[[:space:]]*$' build-info.txt
    grep -E '^dep[[:space:]]+github.com/corazawaf/coraza/v3[[:space:]]+v3\.8\.1[[:space:]]*$' build-info.txt
    caddy validate --adapter caddyfile --config ${host.config.services.caddy.configFile}
    caddy validate --adapter caddyfile --config ${testHost.config.services.caddy.configFile}
    caddy run --adapter caddyfile --config ${testHost.config.services.caddy.configFile} >caddy.log 2>&1 &
    pid=$!
    trap 'kill "$pid" 2>/dev/null || true' EXIT
    for attempt in $(seq 1 100); do
      if curl --silent --fail http://127.0.0.1:18080/ > /dev/null; then
        break
      fi
      sleep 0.1
    done
    test "$(curl --silent --fail http://127.0.0.1:18080/)" = 'proxy fixture'
    test "$(curl --silent --fail http://127.0.0.1:18081/)" = 'proxy fixture'
    test "$(curl --silent -o /dev/null -w '%{http_code}' http://127.0.0.1:18083/)" = 503
    mkdir -p "$CADDY_READY_DIR"
    touch "$CADDY_READY_DIR/fixture"
    test "$(curl --silent --fail http://127.0.0.1:18083/)" = 'proxy fixture'
    rm "$CADDY_READY_DIR/fixture"
    test "$(curl --silent -o /dev/null -w '%{http_code}' http://127.0.0.1:18083/)" = 503
    test "$(curl --silent -o /dev/null -w '%{http_code}' \
      'http://127.0.0.1:18080/waf-test?api_key=DO_NOT_LOG_QUERY_SECRET' \
      -H 'Authorization: Bearer DO_NOT_LOG_HEADER_SECRET' \
      -H 'Cookie: session=DO_NOT_LOG_COOKIE_SECRET')" = 200
    test "$(curl --silent -o /dev/null -w '%{http_code}' \
      'http://127.0.0.1:18081/waf-test?api_key=DO_NOT_LOG_QUERY_SECRET')" = 403
    # Exercise embedded CRS too, rather than only our deterministic test rule.
    test "$(curl --silent -o /dev/null -w '%{http_code}' --get \
      --data-urlencode 'q=<script>alert(1)</script>' http://127.0.0.1:18080/)" = 200
    test "$(curl --silent -o /dev/null -w '%{http_code}' --get \
      --data-urlencode 'q=<script>alert(1)</script>' http://127.0.0.1:18081/)" = 403
    test "$(curl --silent -o /dev/null -w '%{http_code}' \
      --data-urlencode 'password=DO_NOT_LOG_BODY_SECRET' \
      --data-urlencode 'q=<script>alert(1)</script>' http://127.0.0.1:18080/)" = 200
    kill "$pid"
    wait "$pid"
    grep -F '"rule_id":1000001' caddy.log
    grep -E '"rule_id":941[0-9]+' caddy.log
    if grep -E 'DO_NOT_LOG_|api_key=|Bearer |session=' caddy.log; then
      echo 'Sensitive request data leaked into logs' >&2
      exit 1
    fi
    mkdir -p $out
    cp modules.txt build-info.txt caddy.log $out/
  ''
