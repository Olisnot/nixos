{ ... }:

{
  imports = [
    ../../nixosModules/networking/wireguard-link.nix
    ./wireguard-mobile.nix
    ./wireguard-mullvad.nix
  ];

  olympusMobileVpn.mullvad = {
    enable = true;
    includeZeus = true;
  };

  wireguardLink = {
    enable = true;
    address = "10.77.0.1";
    peerAddress = "10.77.0.2";
    peerPublicKey = "cgFioflbrw7Jp9BxZK0kEbxcuUaxVOecMpt7vDTgRR8=";
    peerAllowedIPs = [
      "10.77.0.2/32"
      "fd77:77::2/128"
    ];
    listenPort = 51820;
  };
}
