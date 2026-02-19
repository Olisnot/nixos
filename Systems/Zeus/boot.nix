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
      # "resume_offset=79960064"
      "resume=/dev/disk/by-uuid/0262d9b8-4da5-4ce9-8d67-92f19172185b"
      "quiet"
      "splash"
      "intremap=on"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "plymouth.use-simpledrm=1"
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
