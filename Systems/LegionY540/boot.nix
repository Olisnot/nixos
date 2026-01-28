{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

let
  theme = config.theme;
  themeWallpaper = {
    Nord = "${inputs.wallpapers}/nord.jpg";
    Gruvbox = "${inputs.wallpapers}/gruvbox.jpg";
    Catppuccin = "${inputs.wallpapers}/catppuccin.jpg";
    TokyoNight = "${inputs.wallpapers}/tokyo.png";
    Black = "${inputs.wallpapers}/black.jpg";
  };
in
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
        style = {
          wallpapers = [ themeWallpaper.${theme} ];
          graphicalTerminal.background = lib.mkDefault "FF2e3440";
        };
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
      "resume=/dev/disk/by-uuid/8a5c0ac5-fca9-4460-8a27-c17c73c2a3b2"
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
