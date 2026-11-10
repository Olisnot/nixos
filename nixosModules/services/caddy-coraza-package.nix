{ pkgs }:

# withPlugins is provided by the repository's locked nixpkgs Caddy package.
# CRS v4.25.0 and Coraza v3.8.1 are embedded dependencies of this plugin pin.
(pkgs.caddy.withPlugins {
  plugins = [ "github.com/corazawaf/coraza-caddy/v2@v2.6.2" ];
  hash = "sha256-ml37bn1Utbtr9ZmJZNSedG91XTkMtzgpegHgZ1la4Lo=";
}).overrideAttrs
  (old: {
    postPatch = (old.postPatch or "") + ''
      # Caddy's filter encoder cannot redact the fundamental `msg` field.
      # Emit only safe structured metadata instead of Coraza's raw ErrorLog(),
      # which includes matched request values and potentially credentials.
      substituteInPlace vendor/github.com/corazawaf/coraza-caddy/v2/coraza.go \
        --replace-fail 'logMsg := mr.ErrorLog()' \
          'logMsg := "WAF rule matched"; logger := logger.With(zap.Int("rule_id", mr.Rule().ID()), zap.String("transaction_id", mr.TransactionID()))'
    '';
  })
