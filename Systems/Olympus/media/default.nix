{ ... }:

{
  imports = [
    ./services.nix
    ./navidrome.nix
    ./mullvad.nix
    ./storage.nix
    ./network.nix
    ./recyclarr.nix
  ];
}
