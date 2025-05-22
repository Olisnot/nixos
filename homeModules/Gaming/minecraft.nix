{ pkgs, lib, config, ... }:

{
  options = {
    gaming.minecraft.enable = lib.mkEnableOption "Enable minecraft prism launcher";
  };

  config = lib.mkIf config.gaming.minecraft.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
