{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.qbittorrentMullvad;
  port = toString config.services.qbittorrent.webuiPort;
  accessUnits = lib.optional (cfg.accessService != null) cfg.accessService;
  lifecycleUnits = [ "qbt-mullvad.service" ] ++ accessUnits;
  dnsMounts = [
    "/etc/netns/qbt-mullvad/resolv.conf:/etc/resolv.conf"
    "/etc/netns/qbt-mullvad/nsswitch.conf:/etc/nsswitch.conf"
  ];
  resolverBlocks = [
    "-/run/nscd"
    "-/run/nsncd"
    "-/run/systemd/resolve"
    "-/run/dbus/system_bus_socket"
  ];
  checkVpn = pkgs.writeShellApplication {
    name = "qb-vpn-check";
    runtimeInputs = [
      pkgs.systemd
      pkgs.coreutils
      pkgs.jq
    ];
    text = ''
      if (( EUID != 0 )); then
        echo 'Run this check as root on Olympus (sudo qb-vpn-check).' >&2
        exit 1
      fi
      pid=$(systemctl show qbittorrent.service -p MainPID --value)
      if [[ "$pid" == 0 ]] || [[ ! -e /run/netns/qbt-mullvad ]]; then
        echo 'qBittorrent or its VPN namespace is not running.' >&2
        exit 1
      fi
      if [[ $(stat -Lc %i "/proc/$pid/ns/net") != $(stat -Lc %i /run/netns/qbt-mullvad) ]]; then
        echo 'qBittorrent is not in the expected VPN namespace; do not download.' >&2
        exit 1
      fi
      result=$(systemd-run --quiet --wait --pipe --collect \
        --property=User=${config.services.qbittorrent.user} \
        --property=NetworkNamespacePath=/run/netns/qbt-mullvad \
        --property=${lib.escapeShellArg "BindReadOnlyPaths=${lib.concatStringsSep " " dnsMounts}"} \
        --property=${lib.escapeShellArg "InaccessiblePaths=${lib.concatStringsSep " " resolverBlocks}"} \
        --property='RestrictAddressFamilies=AF_INET AF_INET6 AF_NETLINK' \
        --property=NoNewPrivileges=yes \
        ${pkgs.curl}/bin/curl -q --noproxy '*' --fail --silent --show-error --max-time 20 \
        https://am.i.mullvad.net/json)
      if ! jq -e '.mullvad_exit_ip == true' <<< "$result" >/dev/null; then
        echo 'Probe did not confirm a Mullvad exit IP; do not download until investigated.' >&2
        exit 1
      fi
      jq '{ip, mullvad_exit_ip, mullvad_exit_ip_hostname, country, city}' <<< "$result"
    '';
  };
in
{
  options.qbittorrentMullvad = {
    enable = lib.mkEnableOption "isolating qBittorrent behind Mullvad" // {
      default = true;
    };
    configFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/wireguard/mullvad.conf";
      description = "Runtime Mullvad WireGuard configuration; never import its private contents into Nix.";
    };
    webuiAddress = lib.mkOption {
      type = lib.types.str;
      default = "10.77.0.1";
      description = "Host address for the private Web UI socket proxy.";
    };
    accessService = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "wg-quick-wg0.service";
      description = "Service providing the private Web UI address, or null for an independently available address.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.qbittorrent.webuiPort != null;
        message = "Mullvad-isolated qBittorrent requires a Web UI port for the host proxy.";
      }
    ];
    boot.kernelModules = [ "wireguard" ];
    environment.systemPackages = [ checkVpn ];

    systemd.services.qbt-mullvad = {
      description = "Isolated Mullvad network and kill switch for qBittorrent";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      path = [
        pkgs.iproute2
        pkgs.iptables
        pkgs.wireguard-tools
      ];
      environment.QBT_WEBUI_PORT = port;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        RuntimeDirectory = "qbt-mullvad";
        RuntimeDirectoryMode = "0700";
        LoadCredential = "wireguard:${cfg.configFile}";
        UMask = "0077";
        ExecStart = "${pkgs.python3}/bin/python3 ${./mullvad-network.py} up";
        # Also runs on failed setup. Cleanup requires our runtime ownership marker.
        ExecStopPost = "${pkgs.python3}/bin/python3 ${./mullvad-network.py} down";
      };
    };

    services.qbittorrent.serverConfig = {
      Preferences."WebUI\\Address" = lib.mkForce "169.254.77.2";
      BitTorrent."Session\\Interface" = "mullvad0";
    };
    systemd.services.qbittorrent = {
      requires = [ "qbt-mullvad.service" ];
      after = [ "qbt-mullvad.service" ];
      partOf = [ "qbt-mullvad.service" ];
      serviceConfig = {
        NetworkNamespacePath = "/run/netns/qbt-mullvad";
        # Enter the root-owned network namespace; retain the native unprivileged
        # user, capability restrictions and other filesystem/process hardening.
        PrivateUsers = lib.mkForce false;
        BindReadOnlyPaths = dnsMounts;
        # Prevent libc/Qt from using host resolver daemons over filesystem
        # sockets instead of the namespace's VPN-only DNS route.
        InaccessiblePaths = resolverBlocks;
      };
    };

    # Terminate the private connection on the host, rather than forwarding/NATing
    # wg0 packets into the namespace. This preserves existing wg0 isolation.
    systemd.sockets.qbt-webui = {
      description = "Private qBittorrent Web UI listener";
      wantedBy = [ "multi-user.target" ];
      # The tunnel address and namespace arrive after network-online. Avoid
      # sockets.target's normal before-basic ordering creating a boot cycle.
      unitConfig.DefaultDependencies = false;
      before = [ "shutdown.target" ];
      conflicts = [ "shutdown.target" ];
      requires = lifecycleUnits;
      after = lifecycleUnits;
      partOf = lifecycleUnits;
      socketConfig = {
        ListenStream = "${cfg.webuiAddress}:${port}";
        NoDelay = true;
      };
    };
    systemd.services.qbt-webui = {
      description = "Proxy private qBittorrent Web UI into its VPN namespace";
      requires = [ "qbittorrent.service" ];
      after = [ "qbittorrent.service" ];
      partOf = lifecycleUnits;
      serviceConfig = {
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 169.254.77.2:${port}";
        DynamicUser = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_UNIX"
        ];
      };
    };
  };
}
