# Olympus–Zeus WireGuard link

**Current routing:** Zeus is now configured as a full-tunnel client, and access
devices exit through Mullvad. Follow [WIREGUARD-MULLVAD.md](./WIREGUARD-MULLVAD.md)
for the server-first cutover and client lockdown. The setup below describes the
original point-to-point link, not the current internet-egress policy.

For full-tunnel phones and QR enrollment, see
[WIREGUARD-MOBILE.md](./WIREGUARD-MOBILE.md). That separate extension adds
phone-specific NAT/forwarding and isolation; the original Zeus peer remains
split-tunnel. The point-to-point setup described below predates that extension.

Olympus is the VPS/server and will host the services. Zeus is the initiating
client, not a media backend for Olympus. This change establishes only the link;
it does not add applications or public HTTPS routes.

| Host | Tunnel address | Endpoint | Public UDP listener |
| --- | --- | --- | --- |
| Olympus | 10.77.0.1/32 | Learns Zeus's endpoint | 51820 |
| Zeus | 10.77.0.2/32 | 37.27.31.37:51820 | None opened |

The public IP comes from the local `olympus` SSH alias. Update Zeus's
`wireguard.nix` if the VPS address changes. Zeus sends a 25-second keepalive so
the tunnel survives home NAT. No home router port forward is needed.

Each peer has exactly the other tunnel IP in AllowedIPs (`/32`). No default
route, home subnet route, DNS change, NAT, IP forwarding or trusted-interface
rule is added. No new application TCP ports are opened. Existing firewall
allowances still apply, including SSH; this is not an isolation policy that
overrides existing permitted ports. Future private services should bind to
Olympus's tunnel address and have explicitly selected wg0 firewall permissions.
Public services can instead bind to loopback behind Caddy as previously planned.

## Keys and firewall prerequisite

Both machines must already have their own `/etc/wireguard/private.key`, as
generated earlier. The config references this runtime path as a string: private
keys are not read during evaluation, copied into the Nix store or committed.
Only public keys are in the host modules. Missing keys fail service startup
rather than generating keys that would not match the peer configuration.

On each host, verify permissions without displaying the private key:

```sh
sudo stat -c '%a %U:%G %n' /etc/wireguard /etc/wireguard/private.key
```

Expected: directory `700 root:root`, key `600 root:root`. Do not use
`wg showconf`, `wg show all dump`, or paste private keys into diagnostics.

In the Hetzner Cloud Firewall **attached to Olympus**, add inbound **UDP 51820**
separately from TCP 22/80/443. For Zeus alone, restrict its source to your home
public IP if stable; for roaming phones, allow their mobile sources too as
described in WIREGUARD-MOBILE.md. Keep existing SSH/web rules.
The NixOS listener rule is supplied by the module. Zeus needs outbound UDP to
the VPS, with established reply traffic allowed; no extra inbound port is opened
on Zeus by this change.

## Review, build, then deploy

From the repository root, make new files visible to Git-backed flakes:

```sh
git add nixosModules/networking Systems/Olympus/wireguard.nix Systems/Zeus/wireguard.nix
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.zeus.config.system.build.toplevel --no-link
```

After review and confirming the Hetzner rule/key files, deploy Olympus first,
then Zeus. Run from Zeus:

```sh
rebuild olympus
rebuild
```

Use normal rebuilds, **not nixos-anywhere**. Existing SSH access stays on its
current public address. The new interface is managed by `wg-quick-wg0.service`.

## Live validation

On Zeus after both deployments:

```sh
sudo systemctl status wg-quick-wg0 --no-pager
sudo wg show wg0
ip -4 address show dev wg0
ip -4 route get 10.77.0.1
ping -c 3 10.77.0.1
```

On Olympus (via the existing SSH alias):

```sh
ssh olympus 'systemctl status wg-quick-wg0 --no-pager'
ssh olympus 'wg show wg0'
ssh olympus 'ip -4 route get 10.77.0.2; ping -c 3 10.77.0.2'
```

Expect a recent handshake, matching public keys, transfer counters increasing,
peer routes through wg0, and successful pings. Existing NixOS firewalls permit
ping. `wg` is installed by the NixOS wg-quick module after deploying.
`active (exited)` for the oneshot service is normal: a live handshake is the
important connectivity check. Confirm `ip -4 route get 1.1.1.1` still uses the
normal internet interface in the original split-tunnel setup. With the current
full tunnel, expect wg0; use the Mullvad gateway verification guide instead.

If no handshake appears, check the Hetzner rule is attached to this VPS, its
source restriction matches the home public IP, the VPS endpoint is correct,
outbound UDP is permitted, and public keys match each host's private key.
Then inspect `sudo journalctl -u wg-quick-wg0 -b --no-pager`. Do not disable
either firewall or change AllowedIPs to `0.0.0.0/0` as a workaround.

Local builds do not prove the Hetzner UDP rule, key-file permissions, handshake
or live routing; these need the checks above after deployment.
