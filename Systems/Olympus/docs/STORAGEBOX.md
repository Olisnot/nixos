# Hetzner Storage Box media mount

The [media stack](./MEDIA.md) now enables Jellyfin and the importing/downloading
services, using the group and mount dependencies described here.

`storagebox.nix` mounts `//u715484.your-storagebox.de/backup` at `/srv/media`
using SMB/CIFS. This is the main account's **entire backup share**, not an
isolated media sub-account. Only Olympus gets this mount.

The existing `/etc/storagebox/media.credentials` on Olympus must contain the
main account's `username=` and `password=` on separate lines. Its contents are
never read by Nix or committed. Keep the file root-owned with mode `600` and
its directory root-owned with mode `700`. Do not print the file in diagnostics.

## Behaviour and permissions

- `seal` requires SMB encryption; the normal dialect negotiation can select
  SMB3. It must not silently fall back to an unencrypted connection.
- `nolease` disables SMB leases/oplocks to avoid the reproduced `EINVAL` on
  concurrent opens of hard-linked download and library paths. Server inode
  identity and hard-link detection remain enabled. This reduces local caching
  and may increase network I/O. Changing only `cache=none` did not fix the
  concurrent-open failure in isolated read-only tests on kernel 6.18.57.
- `_netdev`, `nofail` and `x-systemd.automount` make this a network automount.
  Unavailability does not make boot depend on a successful remote mount.
  Access to `/srv/media` triggers the real mount, with a 30-second mount-job
  timeout. This timeout is **not** a bound on every file operation during a
  later SMB outage; service I/O may still block or fail if storage goes away.
- Files are presented with group `media`, mode `0660`; directories use `0770`.
  `forcegid` keeps the local group mapping consistent. Server-side account
  permissions still apply. Members of `media` can write/delete data where
  the Storage Box account permits it; membership is not read-only access.
- `nosuid`, `nodev` and `noexec` treat this as data storage. No local normal
  user or service is automatically added to the group yet.
- No inbound firewall port is added. If Hetzner egress is restricted, permit
  DNS and outbound **TCP 445** to the Storage Box (and established replies).
  Do not expose inbound TCP 445 on the VPS. WireGuard phone forwarding policy
  is unchanged; the mount belongs to the VPS, not directly to phone peers.

Confirm **SMB support** is enabled in the Storage Box settings. If Hetzner's
reachability restrictions prevent access from this VPS, review the Storage Box
settings; do not disable encryption to work around connectivity problems.

## Deploy and verify

From Zeus, after reviewing the changes:

```sh
rebuild olympus
```

Then verify using the existing SSH alias:

```sh
ssh olympus
stat -c '%a %U:%G %n' /etc/storagebox /etc/storagebox/media.credentials
systemctl status srv-media.automount --no-pager
ls -la /srv/media
findmnt -t cifs --target /srv/media -o TARGET,SOURCE,FSTYPE,OPTIONS
systemctl status srv-media.mount --no-pager
getent group media
stat -c '%U:%G %a %n' /srv/media
```

Expect the credentials file to be `600 root:root`, the real filesystem type to
be `cifs`, the configured Storage Box source, `seal` in the options, and group
`media` on the mount, with `nolease` enabled. Before the first directory access, an `autofs` entry is
normal and does not by itself prove the CIFS mount succeeded. A successful
build also does not verify remote credentials, networking or SMB access.

If mounting fails, review:

```sh
journalctl -u srv-media.mount -b --no-pager
journalctl -k -b --no-pager | grep -i cifs
```

When changing lease options on an active mount, stop the dependent media
services and automount, unmount normally, and start the updated mount before
restoring previously active services. Do not force/lazy-unmount it. A file probe
alone is insufficient for this issue: verify both hard-linked paths can be
opened/read simultaneously, then repeat after the downloader and Jellyfin are
running. Do not delete/re-download media or break hardlinks to work around it.

Do not paste credentials or unreviewed secret-bearing output into a report.
Do not populate `/srv/media` while the remote mount is unavailable, and do not
create local fallback library directories there.

## When adding media services

Jellyfin is **not enabled** by this change. When it is explicitly enabled,
the storage module automatically adds its service user to `media` and sets:

```nix
systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/srv/media";
```

This makes startup require the actual mount rather than scanning/writing an
empty local fallback directory. Apply the same pattern explicitly to each
future import/download service: add its real service user to `media` and set
`RequiresMountsFor` on the unit that reads/writes the library. Do not add admin
or unrelated service users by default. Restart services after changing their
supplementary groups. A mount dependency guards startup; it does not guarantee
continuous storage availability during a running service's lifetime.

Keep Jellyfin configuration, database, cache and transcoding temporary files
on the VPS's local disk; use the remote share for media content. A CIFS share
is not a general replacement for local POSIX storage, and cross-filesystem
hardlinks/atomic moves from local download directories will not work. Plan
download/import paths before enabling those services. Storage Box snapshots
and a separate backup policy should protect against accidental deletion.

Reference: [Hetzner SMB/CIFS documentation](https://docs.hetzner.com/storage/storage-box/access/access-samba-cifs).
