{ ... }:

{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;


    users.users.oliver.extraGroups = [ "libvirtd" ];

    boot.kernelParams = [
        "intel_iommu=on"
    ];
}
