{ config, lib, ... }:

{
  options = {
    zed.enable = lib.mkEnableOption "zed";
  };

  config = lib.mkIf config.zed.enable {
    nixGL.vulkan.enable = true;
  };
}
