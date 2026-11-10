# Olympus HTTPS edge and WAF

**Current media deployment:** [MEDIA.md](./MEDIA.md) configures the approved
Jellyfin and Seerr hostnames with first-run readiness gates. The preparation
notes below describe the initial no-routes rollout; other example routes remain
inactive. Private arr/download interfaces are available only over WireGuard.

## Scope and layout

- `reverse-proxy.nix` enables only the reusable Caddy proxy module on Olympus.
- `../../nixosModules/services/caddy.nix` owns hostnames and upstreams.
- `caddy-coraza.nix` adds the WAF, privacy-conscious logging, and per-host tuning.
- `caddy-coraza-package.nix` pins the plugin and its dependency hash.
- `proxy-check.nix` checks the generated configuration and isolated HTTP fixtures.

**No public virtual hosts are enabled yet**, as requested. Consequently Caddy
does not serve a public site or request public certificates yet. The NixOS web
firewall ports are prepared. The proxy module enables no media server, Seerr,
or admin service and does not change Zeus's existing private proxies. The
separate [WireGuard link](./WIREGUARD.md) connects Zeus as a client to Olympus;
services are intended to run on Olympus, not on Zeus behind this tunnel.

The lock file's nixpkgs revision `02c087f3fe673c9e317f206a627cb6b910336dbe`
supplies Caddy 2.11.7 and `caddy.withPlugins { plugins;
hash; }` (`pkgs/by-name/ca/caddy/plugins.nix`). Coraza Caddy is pinned to v2.6.2,
which depends on Coraza v3.8.1 and embedded CRS v4.25.0. No unpinned ruleset is
downloaded at runtime. The fixed-output dependency hash covers the complete
xcaddy module/vendor tree; changing Caddy, plugins, or nixpkgs requires rebuilding
and verifying that hash again. Keep upstream install checks enabled.

The package applies one fail-closed, build-time source substitution to Coraza's
logging callback: it replaces raw `ErrorLog()` messages with numeric `rule_id`
and generated `transaction_id` fields. This does not alter rule evaluation.
Caddy's standard filter encoder cannot redact its fundamental `msg` field;
the JSON encoders therefore omit messages entirely, retaining structured rule
IDs for review. The substitution must still match when upgrading the plugin.

Reference: [Coraza Caddy documentation](https://github.com/corazawaf/coraza-caddy/tree/v2.6.2).
The upstream module's registered ID is **`http.handlers.waf`**, not
`http.handlers.coraza_waf`; `coraza_waf` is its Caddyfile directive. Do not confuse
the names when checking `list-modules` or structured log namespaces.

## Add an explicitly approved route

Existing candidate names are `jellyfin.opmsonline.org` and
`navidrome.opmsonline.org`, from Zeus's media proxy module. Its loopback upstreams
refer to **Zeus**, not Olympus. Do not reuse them on Olympus unless the service
has actually moved there. Confirm the service's port and listening address.

After confirming the upstream, add an entry to `caddyReverseProxy.hosts` in
`reverse-proxy.nix`. This example is documentation only; **do not paste the
placeholder as an actual address**:

```nix
hosts."jellyfin.opmsonline.org" = {
  upstream = "CONFIRMED_PRIVATE_BACKEND_IP:PORT";
  waf.mode = "DetectionOnly"; # default; do not enable blocking initially
};
```

For a service on Olympus, bind it to `127.0.0.1`/`::1` and proxy to that address.
Do not open its service port publicly. For a home service, first configure and
test WireGuard separately, then use its explicit peer tunnel IP and service port.
Do not proxy to arbitrary LAN/public hostnames or expose entire home subnets.
Restrict WireGuard AllowedIPs to the required peer addresses, and restrict the
home firewall to the Olympus tunnel peer and the selected service ports. Avoid
NAT/forwarding unless there is an explicit need. Ensure the home application
trusts the correct proxy address and generates HTTPS URLs.

Caddy handles WebSocket upgrades and HTTP Range requests without special
header overrides. Responses are not buffered by the reverse proxy by default.
WAF response-body inspection is explicitly off to avoid buffering video/audio;
request inspection and CRS still apply. This is not full response-content DLP.
WebSocket frames after the upgrade are not HTTP requests and are not CRS-inspected.

**Keep Sonarr, Radarr, Prowlarr, Bazarr, qBittorrent, SABnzbd and the Hermes admin
interface private.** Do not copy Zeus's full `caddyServices` list to Olympus.
Seerr stays private unless explicitly approved. No wildcard/catch-all proxy is
configured. The Caddy admin API remains on its default loopback address, not on
a public listener; do not open port 2019.

## DNS and both firewalls

Before activating a hostname:

1. Point its DNS A record to Olympus's public IPv4. Add AAAA only after working
   public IPv6 is configured and tested; a stale AAAA can break clients/ACME.
   Use direct DNS (not a CDN proxy) for this initial rollout. No Cloudflare
   credentials are needed for Caddy's default HTTP/TLS ACME challenges.
2. In the **Hetzner Cloud Firewall attached to Olympus**, allow inbound TCP 80
   and 443 from `0.0.0.0/0` and `::/0` if serving IPv6. Keep the existing SSH
   TCP 22 rule and its existing source restrictions. Do not replace that rule.
3. NixOS opens TCP 80/443 via `caddyReverseProxy.openFirewall`. The existing
   OpenSSH module continues to open SSH. No backend ports are added.
4. HTTP/3 is disabled: UDP 443 is not needed. The separately configured WireGuard
   listener uses **UDP 51820**, with its own Hetzner and NixOS firewall rules;
   see [WIREGUARD.md](./WIREGUARD.md). Restrict the Hetzner rule to the home
   endpoint where feasible. This is unrelated to public web ingress.
5. If outbound traffic is restricted at Hetzner, permit DNS, ACME HTTPS, and
   the selected private upstream/WireGuard traffic. Preserve required ICMP/
   ICMPv6 for network operation and path MTU discovery.

No DNS or Hetzner firewall changes have been made by this configuration.

## Observe, tune, then block one hostname at a time

The include order follows upstream: `load_owasp_crs`, then
`@coraza.conf-recommended`, `@crs-setup.conf.example`, runtime exclusions,
`@owasp_crs/*.conf`, configure-time exclusions, and finally the selected
`SecRuleEngine` mode. Every configured host starts in **DetectionOnly**.

Review on Olympus after a separately approved deployment:

```sh
sudo journalctl -u caddy --since '1 hour ago' -o cat
sudo journalctl -u caddy --since '1 hour ago' -o cat | grep '"rule_id":'
```

Matched-rule events retain numeric rule IDs and generated transaction IDs. Audit/debug logs and
per-host access logs are disabled; request objects, raw URIs, and raw error
strings are removed from runtime logs. This deliberately sacrifices detailed
diagnostics to avoid logging media API keys, cookies, auth headers, passwords,
query strings, and matched request bodies. Do not turn on Caddy debug,
`log_credentials`, Coraza audit logs, or raw WAF messages to investigate a real
user session. Use controlled requests with synthetic credentials. No automatic
redactor can make arbitrary new custom log fields safe: review logging after
plugin upgrades or adding custom rules. Normal Caddy event messages are also
omitted, so use status codes, rule IDs, timestamps and client-side diagnostics.
Use a controlled request to one hostname at a time to associate a rule ID with
its host/path; raw per-user URLs are intentionally unavailable in the journal.

Reproduce a false positive with a known synthetic request, identify the exact
rule and parameter, and use the narrowest exclusion on **that host**. Example
only (the rule, path and argument must match a confirmed false positive):

```nix
hosts."jellyfin.opmsonline.org".waf.beforeRules = ''
  SecRule REQUEST_FILENAME "@streq /api/search" "id:1001001,phase:1,pass,nolog,ctl:ruleRemoveTargetById=942100;ARGS:searchTerm"
'';
```

For a parameter exclusion applying to an entire hostname, use a configure-time
exclusion **after** CRS instead:

```nix
hosts."jellyfin.opmsonline.org".waf.afterRules = ''
  SecRuleUpdateTargetById 942100 "!ARGS:searchTerm"
'';
```

Allocate unique local rule IDs, record why each exclusion exists, retest it,
and review it after upgrades. Do not disable the whole engine for media paths
or globally remove entire categories of rules as a first response.

Before switching a media host to `waf.mode = "On"`, test with **actual clients**:

- Login/logout, invalid-login handling, browsing/search, and application API
  authentication; include Jellyfin API-key URLs and Navidrome/Subsonic clients.
- WebSocket connection/upgrade and reconnection where the application uses it.
- Direct play and transcoding/HLS; audio/video start, pause, resume, long sessions.
- Seeking forward/backward and Range/206 responses, downloads, large libraries.
- All intended browsers, TVs/mobile apps/music clients, both IPv4 and IPv6 if used.
- No false positives or secret-bearing logs; correct HTTPS redirect/certificates.

Then enable blocking for just that hostname, monitor, and leave others in
DetectionOnly. Revert its mode to DetectionOnly and rebuild if legitimate
requests are blocked. DetectionOnly is observation, **not attack blocking**;
the application still needs authentication, updates and least-privilege access.
Request parser/body limits may still affect clients, so test uploads too.

## Local verification and later deployment

From the repo root (new files must be tracked for normal Git-backed flakes):

```sh
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix build .#checks.x86_64-linux.olympus-proxy --no-link
```

The check uses the exact service binary, verifies the plugin pin and module,
validates the real generated Caddyfile, then validates and runs test-only
loopback fixtures. It tests proxying, DetectionOnly versus blocking, numeric
rule-hit logging, and absence of synthetic token/header/cookie/body secrets in logs.
It does not activate routes in Olympus and does not contact the live VPS.

Building/checking does not switch the VPS. Review the diff before any later
`rebuild olympus`. Live DNS, ACME certificate issuance, public reachability,
Hetzner firewall state, private backend reachability, and actual media-client
behaviour cannot be certified by these local checks. Never rerun nixos-anywhere
for this update: use a normal rebuild after approval.

### Verification for the initial proxy change (2026-11-10, before WireGuard)

- Full `nixosConfigurations.olympus.config.system.build.toplevel` build passed.
- Pinned dependency tree hash independently confirmed with `nix hash path`:
  `sha256-ml37bn1Utbtr9ZmJZNSedG91XTkMtzgpegHgZ1la4Lo=`.
- Service binary lists `http.handlers.waf`; its build info confirms plugin
  v2.6.2, Coraza v3.8.1 and CRS v4.25.0. The requested spelling
  `http.handlers.coraza_waf` is not an upstream registered module ID.
- Real generated Caddyfile and fixture Caddyfile validated with that binary.
- Loopback proxy fixtures and WAF mode/CRS/privacy checks passed.
- Evaluated firewall: TCP `[22, 80, 443]`, no UDP ingress added; no active public
  virtual hosts. SSH remains `PermitRootLogin = prohibit-password`.
- Zeus still evaluates with its existing Cloudflare DNS plugin, WAF disabled,
  and no public TCP 80/443 opening introduced by this change.
- Formatting and `git diff --check` passed. No live deployment or external
  DNS/firewall/backend changes were performed.

Checks used `path:/home/oliver/repos/nixos#...` to include new files without
altering the Git index. Stage the new files before using normal `.#...` flakes.
