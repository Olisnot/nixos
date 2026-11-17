# Access WireGuard → Mullvad internet egress

## Current routing

```text
iPhone / enrolled full-tunnel clients ─┐
                                    ├─ WireGuard wg0 → Olympus → Mullvad → internet
Zeus (now a full-tunnel client) ──────┘
```

qBittorrent and access-VPN forwarding share the **same isolated provider
namespace and WireGuard interface**, not the qBittorrent application itself.
This uses the existing `/etc/wireguard/mullvad.conf` and its one registered
Mullvad device/key. Do not bring up a second concurrent interface with that
same key; there is no new account/profile/device to create for this change.

- Enrolled IPv4 clients and Zeus (`10.77.0.2`) are forwarded only through
  `qbt-mv-host` into `qbt-mullvad`, then NATed onto `mullvad0` inside the namespace.
- Access to Olympus's own addresses/services is local and stays available
  without going out through the provider. Existing private UI permissions and
  the phone's ban on SSH/Caddy admin stay in place.
- Peer/home LAN/private/metadata forwarding is still blocked. Only explicitly
  enrolled source addresses can use the exit, not an entire trusted wg0 subnet.
- IPv6 is **still captured and blocked** for access clients, not allowed to
  bypass Mullvad. IPv6-only sites are unavailable; dual-stack sites use IPv4.
  qBittorrent's own provider IPv6 capability is unchanged.
- Phone DNS stays `1.1.1.1`/`1.0.0.1`; those queries now travel through Mullvad.
  Do not set phone DNS to Mullvad's private `10.64...` resolver: private-range
  forwarding is deliberately blocked. The namespace's own DNS remains separate.
- Olympus's own SSH, Caddy, media/metadata services, Docker egress and encrypted
  Storage Box connection retain normal VPS routing. No host default route is
  replaced. This forwarding is not inspected by Caddy/Coraza; the WAF continues
  to protect the configured application HTTPS hostnames.

Existing QR-enrolled phone configurations already contain full-tunnel routes
and do not need new keys, QR codes, or changes. Zeus does need its local rebuild.

## Failure protections

The VPS installs policy rule **11000** for packets arriving on wg0, using reserved
table **51821**. Its default routes point only to the isolated gateway, with an
unreachable fallback if the veth disappears. The existing root forwarding
firewall independently rejects physical-WAN fallback, even if the policy unit
cannot start or is stopped. Direct VPS SNAT for access clients is disabled.

The namespace has a default-DROP forwarding policy, exact client return routes,
provider-only forwarding and per-client SNAT. It rechecks private destinations.
TCP MSS is clamped for the provider MTU, and related IPv4 ICMP errors can return
to clients, avoiding a small-requests-work/large-transfers-stall failure.

Provider loss or removal of `mullvad0` blocks client internet rather than falling
back to the VPS public IP. Access WireGuard and private VPS services can remain
available. The historical service/namespace names still contain `qbt`; stopping
qBittorrent alone does not stop the gateway, but restarting `qbt-mullvad.service`
briefly interrupts qBittorrent and VPN-client internet together.

## Zeus client routing and kill switch

Zeus's peer now has `AllowedIPs = 0.0.0.0/0, ::/0`, an IPv6 tunnel address,
MTU 1280 and exclusive WireGuard DNS servers. These are client routes: the
server still assigns Zeus only its exact tunnel addresses, never 0.0.0.0/0.

Client table **51820** and rule priorities **900–903** place the full tunnel
before Tailscale's default/exit rules. WireGuard's own marked UDP transport uses
the main physical route to the literal VPS endpoint. RFC1918 LAN routes and
Tailscale's private overlay prefixes are preserved; another VPN's public default
must not silently win. There are currently no conflicting rules at these
priorities on Zeus. Do not reuse these reserved priorities/tables for another
policy without adjusting this configuration.

Zeus's OUTPUT/FORWARD lockdown allows wg0, loopback, its marked encrypted UDP
transport to `37.27.31.37:51820`, DHCP broadcasts and the declared private LAN/
overlay/link-local exceptions. Public traffic is dropped if wg0 goes away.
Non-tunnel DNS/DoT is blocked even to a LAN resolver, preventing fallback to
home/ISP DNS; this also means Tailscale MagicDNS cannot override the selected
VPN DNS. Ordinary multicast/private LAN access is not a promise that arbitrary
globally addressed IPv6 LAN routes or other VPN configurations will still work.

The lockdown remains active if you manually stop wg0: **Zeus's public internet
then intentionally stops**, unless you explicitly enable the manual WAN
override below. Local LAN management remains available. Changing
the VPS endpoint requires updating both the WireGuard endpoint and the
lockdown's endpoint exception. Do not disable the firewall as a workaround.

### Manual emergency WAN access on Zeus

After rebuilding Zeus, use these root-only commands from a local/LAN terminal:

```sh
sudo wg-wan enable   # Explicitly allow direct ISP internet and DNS
sudo wg-wan status
sudo wg-wan disable  # Restore VPN-only routing and kill switch
```

The override works both with wg0 disconnected and with wg0 still connected but
Mullvad unavailable. It bypasses only the client egress lockdown, not the host's
inbound firewall or Olympus's server-side protections. Public IPv4/IPv6 traffic
and DNS may now use your normal connection and expose your ISP IP; VPN DNS
addresses are retained but queried over WAN. It does not automatically select
ISP-provided DNS or repair a failed WAN/DNS service. Pause privacy-sensitive
applications before enabling it.

Private Olympus host addresses remain routed through WireGuard when available;
LAN/private-overlay routes are retained. The override survives firewall and
WireGuard restarts, but **resets to VPN-only on reboot**. It never turns itself
on because a connection fails. Disabling it immediately restores the public
internet/DNS restrictions; internet requires working WireGuard and Mullvad again.
Existing application connections may need reopening after either change.

The override uses root-owned state under `/run/wg-client-wan` and reserves
policy priorities **890–892**. Use the command rather than editing state/rules.
On an iPhone, manually turning the WireGuard tunnel off already restores the
phone's ordinary cellular/Wi-Fi WAN access.

Services reached through Zeus's public-WAN/NAT port forwards may also lose
their old return path. No public-WAN reply bypass is added here: use Olympus,
LAN/private-overlay access, or explicitly design a separate inbound policy if
you still need to host services on Zeus's ISP address.

## Safe deployment order

No live routing changes have been applied by this implementation. Build/review
first, then deploy the server before changing the desktop:

```sh
rebuild olympus
```

The server rebuild may briefly reconnect access WireGuard and restart the
shared provider namespace/qBittorrent. It does not remount `/srv/media` or change
Storage Box settings. Verify the server and the existing iPhone first:

```sh
ssh olympus 'systemctl status wg-mullvad-egress qbt-mullvad wg-quick-wg0 --no-pager'
ssh olympus qb-vpn-check
```

With the phone tunnel enabled, visit `https://am.i.mullvad.net` or Mullvad's
connection-check page. Its public IPv4 must be a Mullvad exit, **not
37.27.31.37**. Verify Olympus's private service URLs still work. A green
WireGuard icon only proves the first hop, not the provider/gateway's health.

Only after that, apply Zeus's full tunnel **from a local console or LAN SSH**,
not a public-WAN SSH session into Zeus:

```sh
rebuild
```

Expect existing internet connections to reconnect when routing changes. On
Zeus, verify:

```sh
sudo wg show wg0
ip -4 route get 1.1.1.1
cat /etc/resolv.conf
curl --fail https://am.i.mullvad.net/json
```

Expect the route through wg0, VPN DNS entries and `mullvad_exit_ip: true`, with
the same provider exit as qBittorrent. Test normal browsing, DNS, large downloads,
private VPS services and LAN access. Check no public IPv6 escapes while the
tunnel is enabled. Phones can need a tunnel toggle/app reconnect to discard
existing connections from the previous direct-VPS exit.

No new Hetzner ingress rules are required. The existing UDP 51820 access listener
and provider UDP egress/established replies remain sufficient.

## Recovery and deliberate outage testing

If only Mullvad/gateway is down, the access tunnel can still reach Olympus for
repair. Inspect provider handshake/counters with
`sudo ip netns exec qbt-mullvad wg show mullvad0`, the `wg-mullvad-egress` unit,
`ip -4 rule show`, and `ip -4 route show table 51821`. Provider setup and policy
units are oneshots; active/exited is normal but not proof of internet egress.

If Zeus's access interface is down, use the local/LAN console to restart
`wg-quick-wg0.service`; its literal IP endpoint does not need DNS. If a bad
configuration prevents reconnection, a previous NixOS generation can be restored
offline with `sudo nixos-rebuild switch --rollback`. That deliberately restores
the old routing/lockdown policy and may restore direct ISP internet: stop
privacy-sensitive applications first. Do not reset Git, delete keys or widen
server AllowedIPs to fix a client route problem.

For a planned kill-switch test, pause sensitive transfers and keep local/LAN
management access. Taking the provider interface down must stop both clients'
internet while private VPS access still works. Stopping Zeus's wg0 must also
block public internet and off-tunnel DNS locally. Restore the provider/client
and validate the exit again before resuming transfers.

## Automated checks

```sh
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.zeus.config.system.build.toplevel --no-link
nix build .#checks.x86_64-linux.wireguard-mullvad --no-link
nix build .#checks.x86_64-linux.qbittorrent-mullvad --no-link
```

The new three-VM test uses real access WireGuard clients and a fake provider,
not real keys or accounts. It covers both client types, DNS/provider egress,
unchanged server egress, private access, large TCP transfers, an old VPN's default
route, Docker/firewall interactions, provider/device/veth/policy loss, recovery,
and Zeus's client-side internet/DNS lockdown. Real provider/cellular/client-app
behaviour still needs the live checks above after deployment.
