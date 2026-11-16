{ pkgs, nixpkgs }:
let
  keys = import (nixpkgs + "/nixos/tests/ssh-keys.nix") pkgs;
  # Exercise account/network isolation without provider credentials or LLM calls.
  fixture = pkgs.writeShellScriptBin "hermes" ''
    echo "hermes-cli-fixture $HERMES_HOME"
  '';
in
pkgs.testers.runNixOSTest {
  name = "olympus-hermes-cli";
  nodes.machine = { ... }: {
    imports = [ ./hermes.nix ];
    _module.args.inputs.hermes-agent.packages.x86_64-linux.default = fixture;
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings.PasswordAuthentication = false;
    };
    users.users.root.openssh.authorizedKeys.keys = [ keys.snakeOilEd25519PublicKey ];
    networking.firewall.allowedUDPPorts = [ 51820 ];
    environment.systemPackages = [
      pkgs.wireguard-tools
      pkgs.openssh
    ];
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("sshd.service")
    machine.succeed("install -m0600 ${keys.snakeOilEd25519PrivateKey} /tmp/ssh-fixture-key")
    machine.succeed("ip netns add client; ip link add wan-host type veth peer name wan-peer; ip link set wan-peer netns client; ip addr add 192.0.2.1/30 dev wan-host; ip link set wan-host up; ip -n client addr add 192.0.2.2/30 dev wan-peer; ip -n client link set wan-peer up; ip -n client link set lo up")
    machine.succeed("umask 077; wg genkey > /tmp/server-wg-key; wg genkey > /tmp/client-wg-key")
    server_key=machine.succeed("wg pubkey < /tmp/server-wg-key").strip()
    client_key=machine.succeed("wg pubkey < /tmp/client-wg-key").strip()
    machine.succeed("ip link add wg0 type wireguard; wg set wg0 private-key /tmp/server-wg-key listen-port 51820 peer "+client_key+" allowed-ips 10.77.0.2/32; ip addr add 10.77.0.1/24 dev wg0; ip link set wg0 up")
    machine.succeed("ip -n client link add wg-client type wireguard; ip netns exec client wg set wg-client private-key /tmp/client-wg-key peer "+server_key+" allowed-ips 10.77.0.1/32 endpoint 192.0.2.1:51820; ip -n client addr add 10.77.0.2/32 dev wg-client; ip -n client link set wg-client up; ip -n client route add 10.77.0.1/32 dev wg-client")
    ssh="ip netns exec client ssh -i /tmp/ssh-fixture-key -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 "
    assert machine.succeed(ssh+"hermes@10.77.0.1 id -un").strip() == "hermes"
    assert machine.succeed(ssh+"hermes@10.77.0.1 hermes --version").strip() == "hermes-cli-fixture /var/lib/hermes/.hermes"
    machine.fail(ssh+"hermes@192.0.2.1 id -un")
    # No accidental restriction of Olympus's existing administration account.
    assert machine.succeed(ssh+"root@192.0.2.1 id -un").strip() == "root"
    machine.succeed("install -d -m0700 -o hermes -g hermes /var/lib/hermes/.ssh")
    machine.succeed("printf '%s\\n' '${keys.snakeOilEd25519PublicKey}' > /var/lib/hermes/.ssh/authorized_keys; chown hermes:hermes /var/lib/hermes/.ssh/authorized_keys")
    machine.fail(ssh+"hermes@192.0.2.1 id -un")
    machine.fail(ssh+"-o ExitOnForwardFailure=yes -N -R 18888:127.0.0.1:22 hermes@10.77.0.1")
    machine.succeed("test $(stat -c %a /var/lib/hermes/.hermes) = 700")
    machine.succeed("test $(id -Gn hermes) = hermes")
    machine.fail("systemctl cat hermes-agent.service")
    machine.fail("systemctl cat hermes-backend.service")
  '';
}
