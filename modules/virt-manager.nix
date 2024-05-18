{ pkgs, config, libs, ... }:

{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
        };
    };

    users.users.oliver.extraGroups = [ "libvirtd" ];
}
