{ pkgs, lib, ... }:

{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;

    loader = {
      limine.enable = true;
      limine.maxGenerations = 10;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.tpm2.enable = false;

    extraModprobeConfig = ''
      options nvidia_modset vblank_sem_control=0
    '';

    # Kernel parameters
    kernelParams = [
      "nvidia-drm.modeset=1"
      # "resume_offset=79960064"
      "resume=/dev/disk/by-uuid/8a5c0ac5-fca9-4460-8a27-c17c73c2a3b2"
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    plymouth = {
      enable = true;
      font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      theme = lib.mkDefault "lone";
      themePackages = with pkgs;
        [
          (adi1090x-plymouth-themes.override { selected_themes = [ "lone" ]; })
        ];
    };
    # loader.timeout = 0;
  };
}
