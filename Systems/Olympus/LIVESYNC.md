# Obsidian Self-hosted LiveSync on Olympus

## Scope and versions

Native `services.couchdb`, not Docker. Locked nixpkgs revision
`02c087f3fe673c9e317f206a627cb6b910336dbe` supplies CouchDB **3.5.2**.
Verified module options against `nixos/modules/services/databases/couchdb.nix`
in that input. In particular, `adminPass` embeds a secret in the store and is
deliberately **not used**; `extraConfigFiles` can reference runtime files.

The existing pinned Caddy/Coraza build is unchanged: coraza-caddy 2.6.2,
Coraza 3.8.1, CRS 4.25.0. Only Olympus imports this service. No changes to Zeus,
WireGuard routing, Mullvad, Storage Box mounts, or existing public apps.

Upstream documentation/source reviewed at LiveSync commit
`daa450c6c780698ed5514fcb2d70899291193cfd`; latest published plugin was **1.0.50**.
Install that version on both clients initially; this repo does not install or
manage Obsidian community plugins. Normal CouchDB replication operations are
tested with the restricted account, not the actual plugin UI. Revalidate client
behaviour when upgrading; do not grant server-admin access to fix an unexplained
replication failure.

Sources:
- [Server guide](https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/setup_own_server.md)
- [Client guide](https://github.com/vrtmrz/obsidian-livesync/blob/main/docs/quick_setup.md)
- [Provisioning implementation](https://github.com/vrtmrz/obsidian-livesync/blob/daa450c6c780698ed5514fcb2d70899291193cfd/utils/couchdb/provision.ts)
- [CouchDB HTTP/CORS reference](https://docs.couchdb.org/en/stable/config/http.html)

## Storage, credentials and provisioning

- CouchDB listens on **127.0.0.1:5984**. No firewall opening, Docker publishing,
  or access-VPN port allowance is added for it. Local admin access is via SSH.
- Database files, view indexes, hashed CouchDB configuration and the Erlang cookie
  stay under **/var/lib/couchdb** on the VPS's persistent local root filesystem.
- Single-node mode and `cluster.n = 1`. Provisioning ensures `_users`,
  `_replicator`, `_global_changes`, and **obsidian-livesync** exist. A database
  already existing (HTTP 412) is accepted; no DELETE/reset/purge is performed.
- `livesync-credentials.service` generates secrets once using the same runtime
  generation pattern as Olympus RomM. `/etc/obsidian-livesync/credentials.json`
  is root-only 0600. `admin.ini` is root:couchdb 0640 in a 0750 directory;
  it is a **runtime secret**, not a Nix path literal containing secret contents.
  Do not add either file to Git. A restart/rebuild does not regenerate passwords.
  Missing credentials alongside existing `.couch` files causes a refusal to
  initialise: restore the original secrets, do not delete the database.
- `livesync-provision.service` uses systemd `LoadCredential`, in-memory Basic
  auth to loopback, and no credential-bearing command arguments or logs. It
  verifies an existing user's password instead of overwriting it every restart.
- `livesync-admin` is the server administrator. **obsidian-sync** has no global
  roles and is a database administrator/member of **only obsidian-livesync**.
  This allows ordinary documents, attachments, design documents, bulk replication,
  `_changes`, and local checkpoint documents, not global server configuration,
  creating arbitrary databases, or reading other protected vaults.

Normal sync uses **obsidian-sync**, never the server administrator. Upstream
server diagnostics/configuration changes and destructive database recreation
can require a server administrator. Initialisation guidance below keeps that
one-time operation separate from daily sync. Do not run the upstream provisioning
shell script here: it can change binding/configuration outside NixOS.

Keep credentials in a password manager. Retrieve only the required field locally
through your trusted administrative SSH session; avoid shared terminal capture,
shell tracing, pasted passwords in commands/history, and screenshots. The server
cannot recover your **vault E2EE passphrase**; it is never generated/stored here.
Credential rotation requires coordinated runtime CouchDB user/admin changes and
client updates; editing the JSON alone does not rotate an existing account.

No backup service is established on Olympus. This change therefore does **not**
claim to back up CouchDB. Do not live-rsync `.couch` files to the media share.
Before production use, arrange a consistent offline backup of `/var/lib/couchdb`
and `/etc/obsidian-livesync` (stop sync/provisioning and CouchDB, copy, then restart),
or a tested CouchDB-aware backup. Encrypt it before any Storage Box transfer:
the current `/srv/media` share is also accessible to media services. Store backup
keys separately and test restoration. Sync, E2EE, and a mirror are not backups.

## DNS/access decision before HTTPS activation

**As committed, `olympusLiveSync.hostname = null`: no new Caddy host exists and
there is no public database access.** Deploying the local service alone will not
make iPhone sync work. Choose a hostname and establish DNS before enabling it.
Suggested (not created): **obsidian.opmsonline.org**.

Recommended: normal public DNS plus **VPN-only application access**:

1. Create a Cloudflare **DNS-only A** record for the chosen hostname to
   **37.27.31.37**. Do not add AAAA until public IPv6 is working. Do not proxy
   through Cloudflare: Caddy deliberately uses the actual peer IP, not an
   untrusted `X-Forwarded-For` header, for the VPN restriction.
2. In `Systems/Olympus/configuration.nix`, set:
   ```nix
   olympusLiveSync = {
     hostname = "obsidian.opmsonline.org";
     access = "vpn";
   };
   ```
3. Rebuild/review before a separate deployment. Existing public TCP 80/443 lets
   Caddy obtain/renew a publicly trusted ACME certificate through HTTP/TLS
   challenges. This needs no private DNS, DNS-01 token, new Caddy plugin, or
   iPhone CA installation. ACME challenges remain public; the database does not.
4. Caddy accepts the application only from **10.77.0.0/24 or 127.0.0.1**.
   Existing WireGuard peers have exact allowed source IPs. The current phone
   policy already allows TCP 443, including the VPS public address; connecting
   to that address through the full tunnel is local to Olympus, not forwarded
   through Mullvad. Olympus remains reachable when Mullvad alone is down.
5. Keep the VPN connected on Linux/iPhone. Test the hostname from each device;
   DNS resolves the public IP but the request must arrive over WireGuard. A
   disconnected client gets **403 WireGuard required**, not database access.

The repo has no established private HTTPS host or combined Coraza/Cloudflare-DNS
plugin build. Binding to a private IP with DNS-01 is therefore **not** silently
introduced. If you prefer public authenticated access without VPN, explicitly
choose `access = "public"` after reviewing the exposure. The same trusted HTTPS
and CouchDB authentication remain mandatory, and 5984 remains loopback-only.
Public access is not enabled by the default or by merely setting a hostname.

## HTTP, CORS and WAF

For CouchDB 3.5.2, `enable_cors` belongs in **[chttpd]**, not the old [httpd]
section. Exact credentialed origins: `app://obsidian.md`,
`capacitor://localhost`, `http://localhost`; no wildcard origins. Methods:
GET/PUT/POST/HEAD/DELETE; headers: accept/authorization/content-type/origin/referer.
OPTIONS preflights are handled by CouchDB before authentication. Actual database
operations require authentication; CORS is not an access-control substitute.

Upstream limits: **4,294,967,296 bytes per HTTP request**, **50,000,000 bytes per
document**. Use LiveSync attachment chunking; these limits are not a promise that
a multi-GB request will fit VPS memory. Caddy imposes no lower request-body limit.
Streaming responses use `flush_interval -1` and no short upstream response timeout.

This host has its own Coraza instance in **DetectionOnly**, consistent with the
existing rollout. Only PUT/POST under `/obsidian-livesync` disable WAF body
buffering/parsing, since encrypted notes/attachments are opaque and CouchDB must
authenticate them. Header/URI processing remains. The exception and matching
body limits are local to this hostname, not global or applied to other apps.
Coraza accepts at most 1 GiB as its inspection-limit setting; the replicated
PUT/POST bodies bypass that inspection, with CouchDB enforcing the 4 GiB limit.
CORS/auth are not implemented twice at the proxy. Response-body inspection,
access logs, WAF audit/debug logs remain disabled by the existing secret-safe
proxy configuration. Do not switch this host to blocking mode without real
replication tests and narrowly justified exclusions.

## Build and separate deployment

```sh
nix build 'path:.#nixosConfigurations.olympus.config.system.build.toplevel' --no-link
nix build 'path:.#checks.x86_64-linux.olympus-livesync' --no-link
nix build 'path:.#checks.x86_64-linux.olympus-proxy' --no-link
```

`path:.` includes new files without staging them. Normal Git-flake builds require
new files to be tracked. Neither build deploys anything. Deployment, separately
approved and after the DNS decision, uses the existing `rebuild olympus` command.

After deployment on Olympus:

```sh
systemctl status couchdb livesync-provision --no-pager
sudo ss -lntp | grep 5984
sudo livesync-check
sudo livesync-check https://obsidian.opmsonline.org
```

The HTTPS check uses the real hostname, verifies the system-trusted certificate
(no `-k`), reads credentials locally without printing them, checks anonymous
vault rejection, authenticated read/write/delete, a `_changes` request, all
three credentialed CORS preflights, and rejection of global admin operations.
It creates/deletes one uniquely named diagnostic document; the deletion tombstone
remains. It does **not** run an actual Obsidian E2EE round trip.

For VPN mode the root HTTPS check on Olympus may need local resolution so it
connects from loopback, rather than the public IP (which is intentionally not in
the source allowlist). For example, a temporary `/etc/hosts` entry mapping the
hostname to 127.0.0.1 on **Olympus only**; remove it after the check. Certificate
verification still uses the real hostname. Do not widen the ACL for this test.

From Linux with WireGuard connected, unauthenticated vault access should return
401/403 (not 200); certificate verification must succeed:

```sh
curl --silent --output /dev/null --write-out '%{http_code}\n' \
  https://obsidian.opmsonline.org/obsidian-livesync
for origin in app://obsidian.md capacitor://localhost http://localhost; do
  curl --silent --include --request OPTIONS \
    https://obsidian.opmsonline.org/obsidian-livesync/_bulk_docs \
    --header "Origin: $origin" \
    --header 'Access-Control-Request-Method: POST' \
    --header 'Access-Control-Request-Headers: authorization,content-type'
done
```

Expect OPTIONS 200/204 with the exact echoed `Access-Control-Allow-Origin`,
`Access-Control-Allow-Credentials: true`, POST and allowed headers. Repeat with
GET and PUT when diagnosing a device. Test disconnected access separately: VPN
mode must return proxy 403. Do not pass passwords in `curl -u user:password` or URLs.
Use `livesync-check` for credentialed probes, or an interactive password prompt
with `curl --user obsidian-sync` on your private terminal when needed.

## Linux first device: E2EE before uploading notes

1. Back up the intended vault. Disable Obsidian Sync, iCloud, Syncthing and any
   other writer/sync tool for this same vault. Install **Self-hosted LiveSync
   1.0.50**, enable it, and keep other optional sync/customisation features off.
2. Open the `Welcome to Self-hosted LiveSync` notice → `I am setting this up for
   the first time` → `Configure a remote manually` → `Proceed with manual configuration`.
3. On `End-to-End Encryption`, **enable End-to-End Encryption**, choose a strong
   unique **vault encryption passphrase**, and enable **Obfuscate Properties**
   if desired. Save the passphrase in your password manager. Do this **before
   initial upload**, not as an afterthought on the second device.
4. Choose **CouchDB**. Fields for the final, daily-sync profile:

   | Plugin field | Value |
   |---|---|
   | Remote type | CouchDB |
   | CouchDB URL / URI | `https://obsidian.opmsonline.org` (your chosen hostname; no DB suffix) |
   | Database name | `obsidian-livesync` |
   | Username | `obsidian-sync` |
   | Password | `sync_password` from runtime credentials |
   | End-to-End Encryption | Enabled |
   | Encryption passphrase | Your vault passphrase, not the CouchDB password |
   | Obfuscate Properties | Choose on the first device; transfer unchanged via Setup URI |
   | Synchronisation preset | **LiveSync** / continuous sync |

5. **One-time initialisation exception:** the upstream new-vault wizard can
   delete/recreate the remote database and server diagnostics can edit server
   configuration. Those are **not ordinary replication** and must not be solved
   by promoting `obsidian-sync` to a server admin. For the known new empty remote,
   perform the first-device initialisation using **livesync-admin** temporarily
   on Linux only, preferably over an SSH tunnel:
   ```sh
   ssh -N -L 15984:127.0.0.1:5984 olympus
   ```
   Use `http://127.0.0.1:15984` as the temporary desktop URL, administrator user
   and `admin_password`. The HTTP hop is local and the network hop is SSH-encrypted;
   it is not suitable as the final iPhone URL. Do not export a Setup URI yet.
6. `Create or connect to database and continue` → `Restart and Initialise Server`.
   Read the overwrite warning and proceed **only for this known new remote**.
   For `No Synchronisation Settings Found`, choose `Use this device's settings`
   only on this intentionally new database. If any expected existing notes are
   present, cancel: never select overwrite to repair authentication.
7. After this deliberate one-time reset/initialisation, on Olympus run
   `sudo systemctl restart livesync-provision.service` to reapply `_security`
   to any recreated database. Pause syncing while changing the profile.
   Replace the temporary URL/admin credentials with **all final fields above**.
   Close the SSH tunnel, reconnect with WireGuard and verify a note uploads
   using **obsidian-sync**. Do not accept server-repair/reset prompts on that
   restricted account; ordinary replication should work on the pre-created DB.
8. Set the synchronisation preset to **LiveSync** (continuous) after onboarding
   if it is not already selected. Keep Obsidian open until sync is idle. Export
   settings only after verifying the profile no longer contains admin credentials.
   The server does not force client encryption: verify E2EE in the plugin.

## Empty iPhone vault via Setup URI

1. On the working Linux device, command palette → **Self-hosted LiveSync: Copy
   settings as a new Setup URI**. Set a **different Setup URI passphrase**.
   This protects the settings/credentials in the URI; it is not the vault E2EE
   passphrase. Transfer URI and passphrase through separate trusted channels.
   Never put them in Git, issues, server logs, or screenshots.
2. On iPhone, enable the Olympus WireGuard tunnel. Create a genuinely **empty
   local vault**, not an iCloud-synchronised vault. Install/enable the same plugin.
3. Welcome notice → `I am adding a device to an existing synchronisation setup`
   → `Use a Setup URI (Recommended)` → paste URI and its passphrase →
   `Test Settings and Continue` → `Restart and Fetch Data`.
4. For this empty vault, choose `Overwrite all with remote files`; the
   conservative extra-local-file choice is `Keep local files even if not on remote`.
   **Do not initialise/overwrite the server from the empty phone vault.**
5. Verify final HTTPS URL, database, **obsidian-sync** account, E2EE enabled and
   LiveSync mode. Keep Obsidian in the foreground until retrieval finishes.
   iOS suspends apps: "continuous" sync works while Obsidian is active, **not
   guaranteed always-on background sync while the app is suspended/force-closed**.

## Acceptance tests and limits of verification

- Linux creates `LiveSync acceptance.md`; wait until idle, then verify identical
  text on iPhone. Edit a different paragraph on iPhone and verify it returns to
  Linux. Repeat after disconnect/reconnect and after reopening the phone app.
- Add an image/PDF attachment (including one several MB in size) on Linux;
  verify it opens correctly on iPhone. Attach a phone photo and verify it opens
  on Linux. For downloaded files compare hashes/sizes where practical.
- Test one benign simultaneous edit and review conflict handling before relying
  on it for real work. Confirm no unexpected deletions and back up both vaults.
- Inspect a sample remote document locally with the admin tools: note bodies
  should not be readable plaintext when plugin E2EE is enabled. Avoid dumping
  the whole DB/secret-bearing response into logs. E2EE does not hide all metadata,
  access patterns or replace HTTPS/authentication.
- The Nix VM check exercises native CouchDB + pinned Caddy/Coraza, trusted
  fixture TLS, CORS, auth/scoping, bulk operations, attachments, checkpoints,
  `_changes` and preservation across service restart. It cannot prove public
  DNS/ACME issuance, Hetzner reachability, actual Obsidian E2EE behaviour, or
  iOS background/network behaviour. **Those require deployment and both devices.**
