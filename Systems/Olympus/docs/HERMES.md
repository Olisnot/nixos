# Hermes Agent: CLI-only, WireGuard SSH access

This installs the existing **locked Hermes Agent package** from `flake.lock`
(`3fa571a51a6bf1220dfe9a7a23fcd5bb9482a1af`). It does not update the input or
change Zeus's Hermes configuration. The upstream NixOS gateway module is not
enabled on Olympus: no browser dashboard, backend, messaging gateway, Caddy
hostname or new listening port is configured. No DNS record is needed.

## Deploy and connect

After review/build, deploy using the normal command:

```sh
rebuild olympus
```

On Zeus, with its Olympus WireGuard connection up:

```sh
ssh -i ~/.ssh/olympus hermes@10.77.0.1
cd ~/workspace
hermes setup
```

The account accepts the same public key(s) configured for Olympus root
administration, but **only with a WireGuard-subnet source address**. Use the
matching private key locally; never copy it to Olympus. Normal SSH host-key
verification still applies. If the IP is new to known_hosts, verify the server's
fingerprint through your existing administrative connection before accepting it.

The existing Olympus firewall permits SSH from Zeus (`10.77.0.2`); enrolled
phones' SSH block is deliberately unchanged. This does not grant mobile peers
root SSH access. The account's source restriction rejects public-WAN connections
even when a valid key is supplied. Existing root administrative SSH is unchanged.

## First-run configuration

Use the terminal setup wizard to select your provider/model and enter an API
key privately (or an upstream-supported device-code login). Skip messaging
platforms and do not install/start a gateway, dashboard or public tunnel. Do not
use `hermes setup --portal` for this CLI-only deployment. SSH forwarding is
disabled for this account, so provider logins requiring a forwarded localhost
callback need a different supported flow, such as an API key/device code.

Provider settings and auth are runtime user state, not Nix configuration. The
wrapper sets `HERMES_HOME=/var/lib/hermes/.hermes` and `umask 077`; the home,
Hermes state and workspace directories are mode 0700, owned by `hermes`.
Protect API keys, `.env`, auth tokens, conversation history and tool outputs.
Don't paste them into Git, chat, command arguments or shared logs. There is no
need to copy Zeus's Hermes state or credentials.

After setup, start an interactive session:

```sh
cd ~/workspace
hermes --tui
```

To keep the session running across SSH disconnects, first run:

```sh
tmux new -As hermes
```

Run Hermes inside that tmux session. Detach with **Ctrl+b**, then **d**; reconnect
over WireGuard and use the same tmux command to reattach. Closing the SSH client
does not stop a detached tmux session or its API usage. Stop the agent explicitly
when finished. Use Nix/this flake to update the installed package; do not run an
upstream installer or modify `/nix/store` to self-update.

## Isolation and limits

- Dedicated `hermes` account, no sudo rules or media/Docker group membership.
  No media mount, application credentials or SSH private keys are provided.
- SSH authentication is public-key-only. Both an account-level source allowlist
  and `from=` key options restrict login to `10.77.0.0/24`.
- Only `/etc/ssh/authorized_keys.d/hermes` (root-managed) is consulted for this
  account. Keys added by the agent to its own `~/.ssh/authorized_keys` do not
  bypass the policy. SSH agent/X11/TCP forwarding, user RC and user-supplied
  environment configuration are disabled; an interactive PTY is allowed.
- No inbound access outside the existing SSH service is enabled. Local/root
  administrators can still run `sudo -iu hermes`; this is a network access
  restriction, not a restriction on the VPS administrator.
- This is a native, unprivileged CLI account, **not a sandbox**. Terminal/file
  tools execute on Olympus with that user's permissions, can read world-readable
  host data and make outbound requests. Only grant it the files/tools it needs.
  Prompts/tool output may be sent to your chosen model provider; WireGuard does
  not prevent that or protect a VPS from its hosting administrator.
- Do not configure external chat gateways, public tunnels or extra web listeners
  and assume this SSH policy protects them. Such features need a separate access
  review. Existing SSH/proxy services and root administration are not changed.

## Verification

```sh
nix build 'path:.#nixosConfigurations.olympus.config.system.build.toplevel' --no-link
nix build 'path:.#checks.x86_64-linux.olympus-hermes' --no-link
nix build 'path:.#checks.x86_64-linux.olympus-hermes-cli' --no-link
```

The VM test uses real SSH and WireGuard with a fixture executable (no model
credentials/calls). It verifies WireGuard login succeeds, public login fails
with the same valid key, user-written keys do not bypass restrictions, remote
forwarding fails, root administration remains available, and gateway/backend
units are absent. A real installed CLI smoke test is separate from the network
fixture; actual provider authentication and chatting require deployment and your
provider credentials.

After deployment, confirm from Zeus:

```sh
ssh -i ~/.ssh/olympus hermes@10.77.0.1 'id; hermes --version'
```

Using the same identity against `hermes@37.27.31.37` from a machine whose packets
arrive outside WireGuard must fail. From a full-tunnel client, traffic to the
VPS's public IP can itself arrive over WireGuard, so the destination IP alone
does not prove you tested an off-VPN connection. Test from a genuinely off-VPN
client; don't disable Zeus's VPN kill switch merely to run this check.
