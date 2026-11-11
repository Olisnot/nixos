{ pkgs, ... }:

let
  rebuild = import ./Rebuild.nix { inherit pkgs; };
  wireguardEnroll = import ./WireguardEnroll.nix { inherit pkgs; };
  uploadMusic = import ./UploadMusic.nix { inherit pkgs; };

in
{
  environment.systemPackages = [
    rebuild
    wireguardEnroll
    uploadMusic
  ];
}
