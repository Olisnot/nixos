{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.olympusMobileVpn;
in
{
  config = lib.mkIf cfg.mullvad.enable {
    assertions = [
      {
        assertion = config.qbittorrentMullvad.enable;
        message = "Access-VPN Mullvad egress requires the existing isolated Mullvad namespace.";
      }
    ];
    qbittorrentMullvad.gatewayClients = cfg.egressIPv4Addresses;
    systemd.services.wg-mullvad-egress = {
      description = "Policy routing from access WireGuard into isolated Mullvad";
      wantedBy = [ "multi-user.target" ];
      requires = [
        "qbt-mullvad.service"
        "wg-quick-wg0.service"
      ];
      after = [
        "qbt-mullvad.service"
        "wg-quick-wg0.service"
      ];
      partOf = [
        "qbt-mullvad.service"
        "wg-quick-wg0.service"
      ];
      path = [ pkgs.iproute2 ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        RuntimeDirectory = "wg-mullvad-egress";
        RuntimeDirectoryMode = "0700";
        ExecStart = "${pkgs.python3}/bin/python3 ${./wireguard-mullvad-route.py} up";
        ExecStopPost = "${pkgs.python3}/bin/python3 ${./wireguard-mullvad-route.py} down";
      };
    };
  };
}
