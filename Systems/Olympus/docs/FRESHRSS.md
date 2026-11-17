# Fresh FreshRSS instance on Olympus

The configuration now creates a fresh instance; no Zeus state transfer is needed.
These changes do not themselves deploy or change DNS.
Olympus serves `https://freshrss.opmsonline.org` through the existing Caddy/Coraza
stack in DetectionOnly mode, restricted to WireGuard client source addresses
(`10.77.0.0/24`) and local loopback. No new TCP port, Cloudflare DNS plugin or
Storage Box dependency is added. Use a Cloudflare **DNS-only A** record pointing
to `37.27.31.37`, without AAAA until public IPv6 works. The public 80/443 listeners
allow normal trusted ACME certificate issuance; application access requires VPN.

Build checks (these do not deploy or transfer data):
```sh
nix build 'path:.#nixosConfigurations.olympus.config.system.build.toplevel' --no-link
nix build 'path:.#nixosConfigurations.zeus.config.system.build.toplevel' --no-link
nix build 'path:.#checks.x86_64-linux.olympus-freshrss' --no-link
nix build 'path:.#checks.x86_64-linux.olympus-proxy' --no-link
```

FreshRSS 1.30.1 uses local SQLite storage under `/var/lib/freshrss` on Olympus.
Nothing is reset/deleted if existing state is present. A fresh installation
creates the `admin` account; subsequent rebuilds do not reset its password.

## Deployment and first login

1. Save the one feed's URL from Zeus (or export its OPML) before retiring the
   old service. No databases, old users, article/read/starred history or bootstrap
   passwords need to be copied for this fresh setup. Zeus's files remain intact.
2. Run `rebuild olympus`. This replaces the previous migration-only guard that
   reported "FreshRSS migration pending". Empty state left by that failed start
   is sufficient; **do not delete any directory** to retry.
3. On Olympus, verify services and retrieve the new bootstrap password privately:
   ```sh
   sudo systemctl status freshrss-config phpfpm-freshrss freshrss-updater.timer --no-pager
   sudo less /etc/freshrss/admin-password
   ```
   Username: **admin**. Press `q` to leave the viewer. Store the password in a
   password manager, never in Git/chat/shared logs. The runtime file is generated
   once, root:freshrss 0640 inside a 0750 directory; it never enters the Nix store.
   The old `/etc/secrets/freshrss` is not used on Olympus. If you later change the
   password in the UI, that UI password takes precedence: the bootstrap file
   is not automatically updated, and rebuilds do not reset the account.
4. After the service has created the admin account successfully, release the
   readiness gate on Olympus:
   ```sh
   sudo install -d -m 0755 /var/lib/caddy/public-ready
   sudo touch /var/lib/caddy/public-ready/freshrss
   ```
   Until then HTTP 503 is intentional. The gate does not change the VPN restriction.
5. Point `freshrss.opmsonline.org` at Olympus using the DNS-only A record above.
   With WireGuard connected, log in at `https://freshrss.opmsonline.org`, add the
   feed URL (or import OPML), and confirm an update fetches its articles. Verify
   disconnected access is rejected with 403, not a FreshRSS page.
6. For mobile API clients, set an individual API password in the FreshRSS profile
   and keep WireGuard connected. Old Zeus API credentials are not migrated.
7. Once the new instance works, run `rebuild` on Zeus to disable its FreshRSS.
   Old `/var/lib/freshrss` and PostgreSQL files are retained, not deleted; the
   unused old PostgreSQL service is disabled along with the old module.

Before DNS cutover, after opening the readiness gate, Linux on WireGuard can test
the destination explicitly (once Caddy has a valid certificate):
```sh
curl --resolve freshrss.opmsonline.org:443:37.27.31.37 \
  --silent --output /dev/null --write-out '%{http_code}\n' \
  https://freshrss.opmsonline.org/
```
Expect a login page or login redirect. Certificate issuance may require DNS
cutover first; don't disable certificate checks to call the migration complete.

## Rollback

Keep the old state on Zeus. If verification fails, remove Olympus's readiness
marker and restore the old DNS. Re-enable `freshrss.enable` on Zeus and rebuild
if its old instance has already been disabled. New Olympus-only changes are not
present on Zeus. Never delete either instance's data as a troubleshooting step.
