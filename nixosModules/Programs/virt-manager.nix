{ lib, config, ... }:

{
  options = {
    virt-manager.setup = lib.mkEnableOption "Enable virt-manager and add kernelParams";
  };

  config = lib.mkIf config.virt-manager.setup {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;


    users.users.oliver.extraGroups = [ "libvirtd" ];

    boot.kernelParams = [
      "intel_iommu=on"
    ];
  };
}
