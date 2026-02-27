{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;

    loader = {
      limine = {
        enable = true;
        maxGenerations = 10;
      };

      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.tpm2.enable = false;

    extraModprobeConfig = ''
      options nvidia_modset vblank_sem_control=0
    '';

    # Kernel parameters
    kernelParams = [
      "nvidia-drm.modeset=1"
      "resume=/dev/mapper/luks-fc5d5e22-1901-416a-8164-5341e0866c69"
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "plymouth.use-simpledrm=1"
      "nvidia.NVreg_DynamicPowerManagement=0x02"
    ];

    plymouth = {
      enable = true;
      font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      theme = lib.mkDefault "abstract_ring";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "abstract_ring" ];
        })
      ];
    };
    # loader.timeout = 0;
  };
}
