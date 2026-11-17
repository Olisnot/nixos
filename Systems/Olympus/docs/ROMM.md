# Fresh RomM on Olympus

This is a **new installation**, not a state migration. Zeus's RomM is disabled
in its host configuration, but its old environment file, database, metadata,
library and saves are not copied or deleted. Apply Olympus first; rebuild Zeus
after the new instance is verified if you want to keep the old one running
until then.

## Deployment layout

- Public URL: **https://romm.opmsonline.org**, through Caddy/Coraza in
  **DetectionOnly** mode. A first-run readiness marker gates public access.
- Private backend: **127.0.0.1:8082** → container 8080. Port 8081 remains SABnzbd.
  Do not open 8082, 8080, 3306 or Redis ports publicly or on WireGuard.
- ROMs: **`/srv/media/library/roms`**, on the existing CIFS mount. This maps to
  **`/romm/library/roms`** in the container. Platform folders/files uploaded in
  the UI land here, without an extra `roms/roms` nesting.
- Other library content (including BIOS files), database, resources, cache,
  configuration, saves/assets and upload staging: **`/var/lib/romm`**, local to
  Olympus. The application does not receive access to music/movie folders.

The shared RomM module is reused with a deterministic `br-romm` bridge and
loopback-only Docker publishing. A mount-dependent library unit requires real
CIFS before starting RomM, never a local fallback directory. It creates only
the ROM directory with `mkdir -p`; no recursive chmod/chown of CIFS is used.

The application uses upstream's non-root UID 1000 and the existing media GID
**993**. That GID is now pinned to its already-existing value; no media ownership
change is intended. Local app directories are private, while the media group
permits writes to the ROM share. MariaDB's initialized ownership is retained
when tmpfiles runs again. Do not manually chown a live MariaDB directory.

## Images and secrets

RomM **5.4.1** and MariaDB **11.4 LTS** are pinned to immutable registry digests
in `romm/default.nix`; no `latest` pull is used on Olympus. Review release notes
and back up local state/secrets before changing either image. Initial deployment
pulls the real images from Docker Hub, which may take time and requires working
DNS/HTTPS egress.

`romm-credentials.service` creates fresh root-owned mode-600 files on the first
deployment, without displaying values or putting them in the Nix store:

```text
/etc/romm/app.env       DB_PASSWD and a fresh ROMM_AUTH_SECRET_KEY
/etc/romm/database.env  Matching MARIADB_PASSWORD and a distinct root password
```

The directory is root-owned mode 700. No file or credential is transferred from
Zeus. The app never receives the database root password. Later starts reuse the
same files; partial credentials, unsafe permissions, or nonempty DB state with
missing credentials cause initialization to refuse rather than generating
incompatible passwords. Do not delete/recreate secrets after the database has
initialized. Back up both files with `/var/lib/romm` securely; they are not
covered by Storage Box snapshots.

Hasheous is enabled as the credential-free metadata provider. Optional provider
keys can be added later to `app.env` using a root editor, retaining mode 600.
The environment-file watcher restarts RomM when that file changes. Do not copy
old credentials, paste the file into chat, put passwords on command lines or
dump container environments into logs. Do not change DB passwords just by
editing these files; a running database needs coordinated credential rotation.

## Firewall and upload handling

Docker forwarding can bypass ordinary host INPUT rules. This configuration
adds a `DOCKER-USER` hook that preserves the existing WireGuard phone-forwarding
policy and rejects new externally forwarded connections directly into RomM's
bridge, including direct container-IP access. Established replies remain
allowed for metadata downloads. Host-origin Caddy traffic uses OUTPUT and the
loopback published port; it does not need a public forwarding exception.
No Docker bridge is made trusted, and no user is added to the docker group.

RomM 5.4.1 uses authenticated **64 MiB chunk uploads** on
`PUT /api/roms/upload/<uuid>`. Only on that exact method/path does Coraza skip
request-body buffering/inspection of the binary chunk; URI/header checks still
run, and other routes keep normal body inspection. Caddy caps each such request
at **70 MB**, while RomM enforces its own 64 MiB cap, authenticated ownership and
write permission. Do not extend this exception to all API paths or disable the
whole WAF. Normal control requests, login and non-chunk routes are not exempt.

Chunk staging is on local disk under `/var/lib/romm/tmp`; completed files are
assembled onto CIFS. Monitor local free space: authenticated users can upload
multiple large games, and chunked total game size is not the same as the
per-request cap. Give ordinary users read/play access unless they need uploads.
Application/nginx access logging is reduced/disabled at WARNING, and Caddy's
existing redacted logging remains. Treat application error logs as potentially
sensitive and review before sharing.

## First deployment and admin setup

1. Create/update Cloudflare **A** record `romm` → **37.27.31.37**, **DNS only**
   (grey cloud), Auto TTL. Remove/avoid AAAA until public IPv6 is configured.
   Existing TCP 80/443 Hetzner ingress is enough; add no backend/database ports.
2. Review the diff and deploy Olympus from Zeus:

   ```sh
   rebuild olympus
   ```

3. Check startup privately over SSH:

   ```sh
   ssh olympus
   systemctl status romm-credentials romm-library docker-romm-db docker-romm --no-pager
   curl --fail http://127.0.0.1:8082/
   ```

   Image pulls/first database initialization can take time. The public hostname
   deliberately returns **503 "Service setup pending"** until the next steps.
4. Open the private setup tunnel from your own machine:

   ```sh
   ssh -N -L 127.0.0.1:18082:127.0.0.1:8082 olympus
   ```

   Visit **http://localhost:18082** and create the first admin account/finish the
   wizard. Use `localhost` for setup (modern browsers treat it as a secure local
   context); production session cookies are Secure. Do not disable secure
   cookies or CSRF protection to publish an unfinished instance.
5. Add/select platforms in RomM and upload ROMs through its UI. Verify files
   appear under `/srv/media/library/roms/<platform>/...`, the application can
   download/play them, and saves/metadata are local. No transfer from Zeus is
   required or performed.
6. Only after account setup is complete, release the public hostname:

   ```sh
   ssh olympus 'install -d -o root -g caddy -m 0750 /var/lib/caddy/public-ready'
   ssh olympus 'install -o root -g caddy -m 0640 /dev/null /var/lib/caddy/public-ready/romm'
   ```

   No Caddy reload is needed. Remove this marker before deleting/reinitializing
   the app database or restoring an instance without an administrator account.
7. Once verified, apply the Zeus-side removal locally:

   ```sh
   rebuild
   ```

   Old Zeus data is retained. This does not remove unrelated applications or
   shared Docker storage; do not use blanket Docker prune/delete commands.

## Verification limits and recovery

```sh
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.zeus.config.system.build.toplevel --no-link
nix build .#checks.x86_64-linux.olympus-proxy --no-link
nix build .#checks.x86_64-linux.olympus-romm --no-link
```

The Docker VM uses **fixture images and a temporary local library**, not the
real production images or Storage Box. It tests generated credential separation,
permissions/reuse/refusal cases, UID/group write access, loopback publishing,
WAF readiness gates, binary chunk forwarding/request-size limits, Docker/WireGuard
isolation, metadata/phone internet egress and firewall/Docker restarts. The
production digests were checked with the registry, and the real Caddyfile is
validated by the proxy check, but actual RomM/MariaDB startup is a live check.

After deployment, verify real image startup, database health, CIFS permissions,
DNS/certificates, account setup, uploads (including >13 MiB chunks), downloads,
saves, and browser emulation/WebSockets. Keep Coraza in DetectionOnly until those
clients work; tune precise rule/parameter exceptions before enabling blocking.

If secrets are missing while DB state exists, restore the matching secret files
from backup rather than deleting the database or generating new passwords.
Inspect `journalctl -u docker-romm -u docker-romm-db` and `docker logs` privately;
never share unreviewed output or `docker inspect` environment dumps. The old
Zeus instance/data remains available as a separate backup until you choose to
remove it.
