# Olympus

See [MULLVAD.md](./MULLVAD.md) for qBittorrent-only provider routing and leak
protection, retaining the private WireGuard Web UI.

See [MEDIA.md](./MEDIA.md) for the Jellyfin/Seerr public WAF routes, private
WireGuard-only arr/download interfaces, and required first-run setup gates.

See [STORAGEBOX.md](./STORAGEBOX.md) for the encrypted SMB media mount at
`/srv/media` and future service mount dependencies.

See [WIREGUARD.md](./WIREGUARD.md) for the point-to-point link with Zeus.
See [WIREGUARD-MOBILE.md](./WIREGUARD-MOBILE.md) for iPhone full-tunnel access
and secure local QR-code enrollment.

See [REVERSE-PROXY.md](./REVERSE-PROXY.md) for the prepared Caddy/Coraza HTTPS
edge, public-route rollout, privacy, firewall requirements and validation.

Minimal NixOS configuration for an **x86-64 Hetzner Cloud VPS**, installed with
nixos-anywhere. Media services are defined separately; public Jellyfin/Seerr
routes stay gated until their first-run setup is explicitly completed.

## Before installation

1. Create an x86-64 VPS (not an ARM/CAX instance) with public IPv4, a Linux
   image such as Ubuntu, and your SSH key. Allow inbound TCP port 22 in any
   Hetzner firewall. Use a machine with at least 2 GiB RAM for the installer.
   The configuration uses DHCP; IPv6-only and private-network-only setups
   require additional network configuration.
2. Add your **public** SSH key to
   `users.users.root.openssh.authorizedKeys.keys` in `configuration.nix`.
   An assertion blocks installation until a key is supplied. Password SSH login
   is disabled; this key is needed to log in after installation. Hetzner's
   image SSH keys are not automatically carried over to NixOS.
3. From this repository's root, check connectivity and the target disk:

   ```sh
   ssh root@SERVER_IP
   lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS
   exit
   ```

   Confirm the OS disk is `/dev/sda`, or update `device` in `disk-config.nix`.
   **Installation erases the entire selected disk.** Do not select an attached
   data volume.
4. Make the new files visible to Git-backed flakes (a commit is not required):

   ```sh
   git add flake.nix flake.lock Systems/Olympus
   ```

## Install

Run from the repository root, replacing `SERVER_IP`:

```sh
nix build .#nixosConfigurations.olympus.config.system.build.toplevel --no-link
nix run github:nix-community/nixos-anywhere -- \
  --flake .#olympus \
  --target-host root@SERVER_IP
```

If needed, pass `-i /path/to/private-key` to nixos-anywhere to select the SSH
identity. Keep the private key on your local machine, outside this repository.

The QEMU guest profile supplies the virtual hardware drivers, and disko defines
the filesystems, so no generated hardware configuration is needed for this VPS.
The disk layout supports both BIOS and UEFI boot.

## After installation

```sh
ssh root@SERVER_IP
```

The server's SSH host key changes during installation. If SSH reports a mismatch,
verify the new fingerprint via the Hetzner console before removing the old entry
with `ssh-keygen -R SERVER_IP` and reconnecting.

For future updates, use a normal rebuild rather than reinstalling:

```sh
nixos-rebuild switch --flake .#olympus --target-host root@SERVER_IP
```
