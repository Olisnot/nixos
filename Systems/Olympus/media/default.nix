{ ... }:

{
  imports = [
    ./services.nix
    ./mullvad.nix
    ./storage.nix
    ./network.nix
    ./recyclarr.nix
  ];
}
