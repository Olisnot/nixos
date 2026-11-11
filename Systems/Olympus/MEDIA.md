# Olympus media stack

**qBittorrent egress update:** [MULLVAD.md](./MULLVAD.md) now confines qBittorrent
to a dedicated provider namespace with kill-switch/DNS isolation. Its private
Web UI URL is unchanged. Other applications keep normal routing.

## Access boundaries

| Application | Access | Backend / UI port |
| --- | --- | --- |
| Jellyfin | `https://jellyfin.opmsonline.org`, Caddy + Coraza | loopback 8096 |
| Seerr | `https://seerr.opmsonline.org`, Caddy + Coraza | loopback 5055 |
| Navidrome | `https://navidrome.opmsonline.org`, Caddy + Coraza | loopback 4533 |
| Sonarr | WireGuard `http://10.77.0.1:8989` | 8989 |
| Radarr | WireGuard `http://10.77.0.1:7878` | 7878 |
| Prowlarr | WireGuard `http://10.77.0.1:9696` | 9696 |
| Bazarr | WireGuard `http://10.77.0.1:6767` | 6767 |
| qBittorrent | WireGuard `http://10.77.0.1:8080` | 8080 |
| SABnzbd | WireGuard `http://10.77.0.1:8081` | 8081 |
| FlareSolverr | Local application API only, `http://127.0.0.1:8191` | 8191 |
| Recyclarr | Local scheduled job, no web UI | none |

All enrolled WireGuard peers, including phones, are now explicitly permitted
to reach those six private UI ports **on 10.77.0.1 only**. The phone's existing
block on SSH, Caddy admin, other phone/Zeus addresses, home networks and IPv6
forwarding remains. These are trusted administrative clients: application
administrators can configure powerful download/proxy integrations, so this
firewall policy is not a sandbox against misuse of those applications.

Public ingress remains TCP 22/80/443 and WireGuard UDP 51820. Do **not** open
the private UI ports, Jellyfin 8096/8920, Seerr 5055, Navidrome 4533, FlareSolverr 8191, or
torrent peer port 51413 in Hetzner's public firewall. Discovery and UPnP are not
needed on this VPS. The private UI listeners bind to the tunnel IPv4 address
and are ordered after wg0. They restart with wg0 when its peer list changes.

Torrent downloading now uses **Mullvad**, with provider setup and deployment
checks in [MULLVAD.md](./MULLVAD.md). Inbound torrent peering stays closed;
Mullvad does not provide port forwarding. Outbound peer connections work, but
inbound connectivity/seeding may be reduced. Recyclarr and FlareSolverr have no
public/private human UI.

Navidrome is configured separately in [NAVIDROME.md](./NAVIDROME.md), including
its private first-run setup and readiness marker. Lidarr, Transmission and Hermes
are not enabled on Olympus. Zeus's
existing services are unchanged: this is a fresh deployment, not a migration
of its users, settings, queues or libraries.

## Storage and state

The host uses native NixOS service modules rather than importing Zeus's
`arr.enable` bundle. That bundle opens backend ports and puts state under the
media directory; upstream nixarr also manages media POSIX permissions through
tmpfiles, which is inappropriate for this CIFS mount.

All application databases/configuration stay in their native **local**
`/var/lib/...` directories. Jellyfin's cache/transcode data stays under local
`/var/cache/jellyfin`; keep it local in the UI too. Recyclarr uses
`/var/lib/recyclarr`. Nothing puts SQLite databases on the Storage Box.

`media-layout.service` waits for the actual CIFS `/srv/media` mount and creates
only these folders with `mkdir -p` (no recursive chown/chmod):

```text
/srv/media/library/movies
/srv/media/library/shows
/srv/media/library/music
/srv/media/downloads/torrents/{complete,incomplete}
/srv/media/downloads/usenet/{complete,incomplete}
```

Existing files are not moved or deleted. Jellyfin, Navidrome, Sonarr, Radarr, Bazarr,
qBittorrent and SABnzbd run with the `media` group and require the mounted
layout before starting. They will not run against an empty local fallback.
Prowlarr, Seerr, FlareSolverr and Recyclarr do not need filesystem access to
the media library. Their state remains local too.

This is the main Storage Box account's entire backup share: media service users
can access other files in that share under the mount's group permissions. Use a
dedicated media sub-account/share if unrelated backups need isolation. Back up
local application state separately and securely; it contains credentials and is
not covered by snapshots of the media share.

Downloads are on the same remote share as the libraries to avoid filling the
VPS disk. Expect slower random I/O/unpacking than local storage. **Disable
hardlink imports** in Sonarr/Radarr unless you have verified your CIFS/server
combination supports them; prefer copy/import. Do not assume cross-filesystem
atomic moves or local POSIX semantics. Preserve torrent files while seeding;
imports may consume additional Storage Box capacity. Keep snapshots/backups.

If the share is unavailable, library services can fail/stop while SSH and the
VPS remain usable. After fixing/remounting storage, restart `media-layout`
and the affected services. Mount dependencies do not ensure continuous remote
availability during playback/downloads.

## Safe first deployment: public setup is gated

First-run Jellyfin/Seerr setup pages must not be claimable by internet users.
Their public routes therefore return **HTTP 503 "Service setup pending"** until
you create separate root-owned readiness markers after completing setup.
Certificates can still be issued while those routes are gated. Coraza runs
in **DetectionOnly**, not blocking mode; it is not a substitute for login.

1. Point **A** records for `jellyfin.opmsonline.org` and
   `seerr.opmsonline.org` to **37.27.31.37**. Remove/avoid AAAA records unless
   working public IPv6 is configured; Olympus currently has no IPv6 default
   route. Start with direct DNS rather than a CDN proxy. Preserve existing
   TCP 80/443 and UDP 51820 Hetzner rules; add no application firewall ports.
2. Review/build, then deploy normally from Zeus:

   ```sh
   rebuild olympus
   ```

3. Open an SSH tunnel from your own computer (keep this terminal running):

   ```sh
   ssh -N \
     -L 127.0.0.1:18096:127.0.0.1:8096 \
     -L 127.0.0.1:15055:127.0.0.1:5055 \
     olympus
   ```

   Visit `http://127.0.0.1:18096` and `http://127.0.0.1:15055`. Create your
   admin accounts and finish the setup wizards before publishing either app.
   Use strong unique passwords. Jellyfin trusts only loopback Caddy proxies
   initially; retain that restriction. Configure Seerr to trust the local
   reverse proxy in its network settings if needed for HTTPS/session handling.
4. In Jellyfin add Movies `/srv/media/library/movies` and TV
   `/srv/media/library/shows`. Do not save metadata/cache/transcodes to media
   folders unless that is intentional. Enable authenticated remote access as
   appropriate; disable public/anonymous access and unwanted admin privileges.
5. In Seerr use internal Jellyfin URL `http://127.0.0.1:8096` and external URL
   `https://jellyfin.opmsonline.org`. Connect Sonarr/Radarr using the tunnel-IP
   URLs above with their API keys and the matching root folders. Grant friends
   request permissions, not administration. Set the application URL to its
   public HTTPS hostname.
6. Release **each host only after its setup is complete**, on Olympus:

   ```sh
   sudo install -d -o root -g caddy -m 0750 /var/lib/caddy/public-ready
   sudo install -o root -g caddy -m 0640 /dev/null /var/lib/caddy/public-ready/jellyfin
   sudo install -o root -g caddy -m 0640 /dev/null /var/lib/caddy/public-ready/seerr
   ```

   No Caddy reload is needed; the markers are checked on requests. Removing a
   marker returns that host to maintenance. **Remove markers before deleting
   application state, resetting accounts or restoring an uninitialized backup.**

## Configure the private applications over WireGuard

Use the six `10.77.0.1` URLs from the table. Keep application authentication
enabled even over WireGuard. qBittorrent generates a temporary initial password
in its local service journal; retrieve it privately over SSH, set a new password
immediately, and never paste that journal into a report. The configuration merge
preserves UI-set credentials across service restarts while enforcing the bind
address, download paths, CSRF and auth settings. No credentials are in Git.

SABnzbd preserves runtime UI settings and credentials while declarative paths
and binding take precedence. Set its username/password, Usenet provider,
API key and categories in its UI. Use categories for Sonarr and Radarr with
the declared complete download directory. Usenet provider/indexer credentials
are not provided by this repository.

Leave SABnzbd's **Permissions for completed downloads** blank. The CIFS mount
already presents files as `0660` and directories as `0770`, with group `media`.
Setting a Unix permissions mask makes SABnzbd attempt unsupported `chmod`
operations on the Storage Box (including incomplete files), producing
"Cannot change permissions" errors. The Nix configuration enforces an empty
mask; do not work around these errors with recursive chmod/chown or mode 777.

In Sonarr/Radarr configure root folders, quality profiles and download clients
using `10.77.0.1:8080` and `10.77.0.1:8081`, with credentials/API keys and
separate TV/movie categories. Prowlarr should sync the selected indexers to
Sonarr/Radarr using their API keys and tunnel URLs; optionally use the local
FlareSolverr API for compatible indexers. Bazarr should use the same paths and
the Sonarr/Radarr URLs/API keys. Do not create public proxy routes for them.

Recyclarr's daily timer is enabled, but the job skips until both runtime key
files exist. Create `/etc/recyclarr` as root mode 700, then use a root editor to
put **only the corresponding API key** in each mode-600, root-owned file:

```text
/etc/recyclarr/sonarr-api-key
/etc/recyclarr/radarr-api-key
```

Do not put keys on shell command lines or in Nix settings. Systemd credentials
deliver them to the job. Then run `sudo systemctl start recyclarr.service` and
review its result privately. This initial config synchronizes series/movie
quality definitions; it does not invent indexers, copy Zeus's profiles, or
delete custom formats.

## Verification

Local checks:

```sh
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix build .#checks.x86_64-linux.olympus-proxy --no-link
nix build .#checks.x86_64-linux.wireguard-mobile --no-link
nix build .#checks.x86_64-linux.olympus-media --no-link
```

The proxy test validates the actual generated config with the Coraza binary,
checks DetectionOnly/blocking, safe logs and the readiness gate. The firewall
VM test covers private-port permission without opening those ports on the
public IP, and retains management/LAN/IPv6 isolation. The media VM smoke test
uses real service binaries and a **temporary local media filesystem**, not
your Storage Box or credentials. It checks application startup, actual
WireGuard access, blocked raw public backends and the two HTTPS gates.

After deploying, check mount/group permissions, `systemctl --failed`,
`systemctl status media-layout`, `ss -lntup`, both HTTPS certificates/redirects,
private URLs with and without WireGuard, and the qBittorrent password after
restart. Caddy's own 2019 API must stay loopback-only. Never disable the
firewall to troubleshoot a listening application.

Before enabling WAF blocking per host, test actual client login/logout,
WebSocket upgrade/reconnect where used, Seerr requests, Jellyfin direct play,
transcoding/HLS, downloads and seeking/Range responses on intended browsers,
phones and TVs. Review redacted rule IDs and tune narrowly as described in
[REVERSE-PROXY.md](./REVERSE-PROXY.md). Coraza does not inspect WebSocket frames
after upgrade, and response-body inspection remains off for streaming.
