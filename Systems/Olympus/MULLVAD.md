# qBittorrent-only Mullvad egress

`media/mullvad.nix` enables an isolated network namespace for qBittorrent. It
uses the existing root-owned, mode-600 **`/etc/wireguard/mullvad.conf`** only at
runtime through systemd credentials. Nix never reads the profile or copies its
private key into the store. Never put the profile or account number in Git.

## Traffic boundaries

- qBittorrent runs in `qbt-mullvad`, with its torrent interface bound to
  **mullvad0**. Its IPv4/IPv6 default routes exist only inside this namespace.
- Both namespace firewalls default to DROP. They allow loopback, internet
  traffic through mullvad0, and private Web UI replies over a management veth.
  No management-link default gateway or general forwarding is configured.
- The WireGuard device is created on the host and then moved into the private
  namespace. Its encrypted UDP socket uses the host's normal routing; the
  unencrypted torrent sockets cannot use that routing table.
- DNS comes from the profile and travels through the VPN. The service gets its
  own resolv.conf/nsswitch.conf, and host resolver/cache/DBus sockets are hidden.
- An IPv6-enabled Mullvad profile can provide IPv6 internet egress even though
  the host has no IPv6 internet route: use an **IPv4 provider Endpoint**. With
  an IPv4-only profile, IPv6 is unavailable, not routed through the host.
- `10.77.0.1:8080` is still the private qBittorrent UI. A host socket proxy sends
  only these UI connections to `169.254.77.2:8080` over a dedicated /30 veth.
  No host FORWARD/NAT permission is added for that link. Existing WireGuard-only
  UI restrictions remain in place. Other services use the same UI URL/API.
- Login, CSRF protection and authentication requirements are retained. The
  backend sees the proxy's management-link source rather than the original
  client IP; this is **not** an authentication bypass.
- Jellyfin, Seerr, the arrs, SABnzbd, SSH, Caddy and phone internet egress keep
  their existing routing. Host-mounted Storage Box I/O also keeps using the
  host's encrypted CIFS connection, not Mullvad. This is torrent/socket
  confinement, not a claim that filesystem writes traverse the provider VPN.

Keep the private `169.254.77.0/30` control subnet and interface/namespace names
reserved for this module. Do not open public ports or make its veth trusted.
Mullvad does not provide inbound port forwarding; do not open port 51413 on
Hetzner expecting to expose it through Mullvad. Incoming peer connectivity and
seeding performance may therefore be limited; outbound peer connections work.

## Profile requirements and behaviour

Use a dedicated registered Mullvad WireGuard key, one `[Interface]`, one
`[Peer]`, explicit `Address`/`DNS`, and `AllowedIPs = 0.0.0.0/0` (plus `::/0`
when using an IPv6 tunnel address). The provider endpoint must use a literal
IP, not a hostname: this avoids bootstrapping provider DNS on the host. The VPS
currently needs an IPv4 endpoint. MTU is taken from the profile, or defaults
to 1280. A missing keepalive defaults to 25 seconds.

Downloaded wg-quick hooks (`PreUp`/`PostUp`/`PreDown`/`PostDown`) are **never
executed**. Profile DNS, routes and interface settings are handled by our own
helper; Table, FwMark, ListenPort and SaveConfig are not applied to the host.
The namespace's firewall replaces any downloaded kill-switch hooks.

Missing/invalid profiles cause setup to fail and prevent qBittorrent startup.
Errors deliberately suppress input values and command stderr because WireGuard
can quote malformed private keys. Runtime namespace/DNS resources are cleaned
up on failure/stop, without deleting unrelated network namespaces.

If Mullvad stops responding but the interface remains, torrents/DNS stall;
the private Web UI stays available. If the tunnel interface is deleted, the
namespace still has no non-VPN internet route and its firewall blocks fallback.
Stopping/restarting `qbt-mullvad.service` stops/restarts qBittorrent and its
private UI proxy, preserving the app's local state and credentials.

## Review and deploy

The real file's permissions were checked without reading its contents. Builds
and simulated-provider tests do not validate the real key, account status or
chosen exit server. No live changes were applied by the implementation.

After reviewing the diff, stop the old unconfined process **before** applying
the new configuration if it is running:

```sh
ssh olympus 'systemctl stop qbittorrent.service'
rebuild olympus
ssh olympus 'systemctl start qbt-mullvad.service qbittorrent.service qbt-webui.socket'
```

Do not enable the Mullvad app system-wide or run `wg-quick up mullvad` in the
host namespace. No change to the Hetzner inbound firewall is required. If its
outbound policy is restricted, permit UDP to the provider endpoint/port from
the downloaded profile, plus established replies. Preserve existing rules.

## Live verification

After deploying, on Olympus:

```sh
sudo systemctl status qbt-mullvad qbittorrent qbt-webui.socket --no-pager
sudo ip netns exec qbt-mullvad wg show mullvad0
sudo qb-vpn-check
```

`qbt-mullvad` is a oneshot unit: **active (exited) is normal but does not prove a
VPN handshake**. Expect a recent provider handshake and increasing counters.
`qb-vpn-check` confirms the running app's network namespace and probes Mullvad's
HTTPS IP-check API using the app UID and the same DNS mounts/resolver exclusions.
It must report `mullvad_exit_ip: true` and an exit IP different from the VPS's
normal `37.27.31.37`. Do not resume downloading until this succeeds.

From Zeus/your phone with the original WireGuard access VPN on, verify
`http://10.77.0.1:8080` and test the Sonarr/Radarr download-client connection.
Verify that the other services/SSH/public HTTPS still work normally. Provider
failure must not make them use Mullvad or take them offline.

For an optional live kill-switch check, first pause active downloads and keep
an SSH session open. On Olympus:

```sh
sudo ip -n qbt-mullvad link set mullvad0 down
sudo qb-vpn-check
```

The check must fail, while the Web UI stays reachable and normal host traffic
still works. Restore it, verify the handshake, then re-run the check:

```sh
sudo ip -n qbt-mullvad link set mullvad0 up
sudo qb-vpn-check
```

For a profile/server change, install the replacement outside Git with root
ownership and mode 600, then `sudo systemctl restart qbt-mullvad.service` and
validate again. Editing the file alone does not reload systemd credentials.
Do not use `wg showconf`, `wg ... dump`, print the profile or paste credentials
into troubleshooting output. A root `ip netns exec` shell is not the same as
the app's full systemd DNS sandbox; use `qb-vpn-check` for the egress check.

## Automated verification

```sh
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix build .#checks.x86_64-linux.qbittorrent-mullvad --no-link
```

The dedicated VM test uses disposable keys and a fake WireGuard provider with
HTTP/DNS responders. It verifies IPv4/IPv6 egress through the encrypted tunnel,
host routing independence, DNS, private Web UI access, missing/invalid profile
failure, suppressed private-input errors, ignored hooks, provider outage,
interface deletion, firewall restart, blocked forged fallback routes in both
address families, and namespace cleanup/recovery. It never contacts the real
provider or reads the real profile. The existing media VM test separately
covers the stack's direct startup with this provider feature disabled.
