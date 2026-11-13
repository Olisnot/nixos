{ ... }:

{
  imports = [ ../../nixosModules/networking/wireguard-client-lockdown.nix ];
  wireguardClientLockdown.enable = true;
  networking.wg-quick.interfaces.wg0.dns = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.wg-quick.interfaces.wg0.mtu = 1280;
  # The reusable module is imported through nixosModules/networking/default.nix.
  wireguardLink = {
    enable = true;
    address = "10.77.0.2";
    extraAddresses = [ "fd77:77::2/128" ];
    peerAddress = "10.77.0.1";
    peerAllowedIPs = [
      "0.0.0.0/0"
      "::/0"
    ];
    peerPublicKey = "ZAEdn9OvlAMOka7IuU2WnWn6l8TR9nYTZ6O08I/cqyM=";
    endpoint = "37.27.31.37:51820";
  };
}
