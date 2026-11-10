{ ... }:

{
  # The reusable module is imported through nixosModules/networking/default.nix.
  wireguardLink = {
    enable = true;
    address = "10.77.0.2";
    peerAddress = "10.77.0.1";
    peerPublicKey = "ZAEdn9OvlAMOka7IuU2WnWn6l8TR9nYTZ6O08I/cqyM=";
    endpoint = "37.27.31.37:51820";
  };
}
