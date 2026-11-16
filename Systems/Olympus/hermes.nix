{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  package = inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;
  cli = pkgs.writeShellApplication {
    name = "hermes";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      if [[ $(id -un) != hermes ]]; then
        echo 'Use the WireGuard-only hermes SSH account, or sudo -iu hermes locally.' >&2
        exit 1
      fi
      umask 077
      export HERMES_HOME=/var/lib/hermes/.hermes
      exec ${package}/bin/hermes "$@"
    '';
  };
in
{
  # CLI only: do not import/enable the upstream gateway/backend service module.
  # In particular there are no Telegram/Discord gateways or HTTP listeners.
  users.groups.hermes = { };
  users.users.hermes = {
    isSystemUser = true;
    group = "hermes";
    home = "/var/lib/hermes";
    homeMode = "0700";
    createHome = true;
    shell = pkgs.bashInteractive;
    packages = [ pkgs.tmux ];
    openssh.authorizedKeys.keys = map (
      key: ''from="10.77.0.0/24",restrict,pty ${key}''
    ) config.users.users.root.openssh.authorizedKeys.keys;
  };
  environment.systemPackages = [ cli ];
  systemd.tmpfiles.rules = [
    "d /var/lib/hermes 0700 hermes hermes -"
    "d /var/lib/hermes/.hermes 0700 hermes hermes -"
    "d /var/lib/hermes/workspace 0700 hermes hermes -"
  ];

  # The source restriction applies to this account, not root/other SSH users.
  # Ignore user-writable ~/.ssh/authorized_keys so an agent cannot accidentally
  # install a less restricted key. Keep the root-managed from= restriction too.
  services.openssh.extraConfig = ''
    Match User hermes
      AllowUsers hermes@10.77.0.0/24
      AuthenticationMethods publickey
      AuthorizedKeysFile /etc/ssh/authorized_keys.d/%u
      DisableForwarding yes
      PermitUserRC no
    Match all
  '';
  assertions = [
    {
      assertion = config.users.users.root.openssh.authorizedKeys.keys != [ ];
      message = "The Hermes CLI account requires the existing Olympus administration public key.";
    }
  ];
}
