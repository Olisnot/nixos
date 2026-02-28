{
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  options.spicetify.enable = lib.mkEnableOption "Enable spicetify the spotify client";

  config = lib.mkIf config.spicetify.enable {
    programs.spicetify.enable = true;
  };
}
