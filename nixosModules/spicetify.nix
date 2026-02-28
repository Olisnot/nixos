{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  options.spicetify.enable = lib.mkEnableOption "Enable spicetify the spotify client";

  config = lib.mkIf config.spicetify.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        theme = spicePkgs.themes.flow;
      };
  };
}
