{ ... }:

{
  imports = [
    ../../nixosModules/networking/wireguard-link.nix
    ./wireguard-mobile.nix
  ];

  wireguardLink = {
    enable = true;
    address = "10.77.0.1";
    peerAddress = "10.77.0.2";
    peerPublicKey = "cgFioflbrw7Jp9BxZK0kEbxcuUaxVOecMpt7vDTgRR8=";
    listenPort = 51820;
  };
}
