{ lib, config, ... }:

{
  options.trilium.enable = lib.mkEnableOption "Enable trilium note taker server";

  config = lib.mkIf config.trilium.enable {
    services.trilium-server = {
      enable = true;
      port = 8083;
    };
  };
}
