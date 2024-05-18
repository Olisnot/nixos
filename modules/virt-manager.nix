{ pkgs, config, libs, ... }:

{
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;


}
