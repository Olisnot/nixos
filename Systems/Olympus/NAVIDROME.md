# Navidrome on Olympus

Public URL: **https://navidrome.opmsonline.org**, through Caddy and Coraza in
**DetectionOnly** mode. The backend listens only on `127.0.0.1:4533`; no public
or WireGuard allowance for raw port 4533 is added.

## Library and state

- Music: **`/srv/media/library/music`**, on the existing Storage Box mount.
- Database/settings: **`/var/lib/navidrome`**, local and private to Navidrome.
- Cache/transcodes: **`/var/cache/navidrome`**, local, not on CIFS.

The mount-dependent `media-layout` service creates the music directory without
changing existing files or applying unsupported chmod/chown operations to CIFS.
Navidrome runs with the media group and waits for that layout and the actual
mount before starting. The native service binds the music folder read-only
inside its sandbox; database and cache paths remain writable. No music, users
or state are copied from Zeus, whose Navidrome configuration is unchanged.

Copy your music into the declared folder using your normal Storage Box access.
An empty library is expected until files are present and scanned. Do not put
the database on the Storage Box, recursively chmod the share, enable anonymous
access, or configure trusted proxy authentication headers to bypass login.

## DNS, deployment and first admin account

1. In Cloudflare create an **A** record: `navidrome` → **37.27.31.37**, **DNS
   only** (grey cloud). Use Auto TTL. Do not add AAAA until public IPv6 works.
   Existing TCP 80/443 rules are sufficient; do not open port 4533.
2. From Zeus, review the changes and deploy:

   ```sh
   rebuild olympus
   ```

   The shared media-layout unit changes to add the music folder. Its dependent
   media applications may briefly restart; their local state is retained.

3. Before the first account exists, the public hostname deliberately returns
   **503 "Service setup pending"**. Open a private setup tunnel from Zeus:

   ```sh
   ssh -N -L 127.0.0.1:14533:127.0.0.1:4533 olympus
   ```

   Visit **http://127.0.0.1:14533**, create the first admin account with a strong
   password, and confirm the library path. Create regular non-admin accounts
   for family/friends rather than sharing the administrator login.
4. Only after account setup, release this hostname:

   ```sh
   ssh olympus 'install -d -o root -g caddy -m 0750 /var/lib/caddy/public-ready'
   ssh olympus 'install -o root -g caddy -m 0640 /dev/null /var/lib/caddy/public-ready/navidrome'
   ```

   No Caddy reload or rebuild is needed. Existing Jellyfin/Seerr markers are
   untouched. Remove the Navidrome marker before deleting/reinitializing its
   database or restoring a backup without an administrator account.

## Verification

On Olympus check `systemctl status navidrome media-layout`, that `/srv/media`
is CIFS, and `curl --fail http://127.0.0.1:4533/ping`. From outside the VPS,
the raw port must remain unreachable; use only the HTTPS hostname.

The local build and checks validate the generated Caddyfile with the exact
Coraza binary. The media VM test checks real Navidrome startup, the loopback
health endpoint, blocked raw access from public/WireGuard interfaces, library
read access, and the HTTPS readiness gate. Its library is a temporary local
filesystem, not the real Storage Box.

Live checks still required: DNS/certificate issuance, reading actual music
from CIFS, login, browser and Subsonic-compatible clients, direct playback,
transcoding and seeking. Use `https://navidrome.opmsonline.org` as the client
server URL. Keep the WAF in DetectionOnly until those clients are verified;
tune narrowly before switching this hostname to `On`. Access/audit logging
remains disabled and rule-hit messages redacted so API tokens/passwords in
Subsonic query strings are not recorded by Caddy/Coraza. Do not enable raw
debug/access logs to investigate a real user's credentials.
