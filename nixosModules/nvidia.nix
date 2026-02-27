{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    nvidia.enable = lib.mkEnableOption "Enables Nvidia Drivers";
  };

  config = lib.mkIf config.nvidia.enable {
    environment.systemPackages = with pkgs; [ nvtopPackages.nvidia ];
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];

    hardware.nvidia = {

      modesetting.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = true;

      open = false;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };
}
