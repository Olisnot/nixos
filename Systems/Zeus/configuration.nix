{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./fonts.nix
    ./boot.nix
    ./sound.nix
    ./users/oliver/user.nix
    ../../nixosModules
    ../../scripts
    inputs.silentSDDM.nixosModules.default
  ];

  #Custom module options
  nvidia.enable = true;
  gaming.enable = true;
  gaming.steam.enable = true;
  gaming.sunshine.enable = true;
  keymapp.enable = true;
  virt-manager.setup = true;
  fish.enable = true;
  syncthing.enable = true;
  gnupg.enable = true;
  programs.librepods.enable = true;
  arr.enable = true;
  navidrome.enable = true;
  slskd.enable = true;
  slskd.environmentFile = "/etc/slskd.env";
  soulsync.enable = true;
  freshrss.enable = true;
  romm = {
    enable = true;
    environmentFile = "/etc/romm.env";
    libraryDir = "/mnt/1tb/Emulation";
    webPort = 8081;
  };
  baikal = {
    enable = true;
    hostName = "baikal.opmsonline.org";
  };
  open-webui = {
    enable = true;
    hostName = "openwebui.opmsonline.org";
  };

  #Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  networking.firewall = {
    trustedInterfaces = [
      "docker0"
      "br+"
    ];
    allowedTCPPorts = [
      20
      21
      4533
      8000
      53317
    ];
    allowedUDPPorts = [
      53317
    ];
    checkReversePath = "loose";
  };
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 51000;
      to = 51999;
    }
  ];

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    userlist = [ "oliver" ];
    userlistEnable = true;
    extraConfig = ''
      pasv_enable=Yes
      pasv_min_port=51000
      pasv_max_port=51999
    '';
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "volantes_cursors";
    XCURSOR_SIZE = "24";
    WIFITUI_THEME = "/etc/wifitui/theme.toml";
  };

  environment.etc."wifitui/theme.toml".source = ./files/theme.toml;

  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--exit-node-allow-lan-access=true" ];
  };

  programs.kdeconnect.enable = true;

  systemd.tpm2.enable = false;

  # Garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable dynamically linked binaries
  programs.nix-ld.enable = true;
  #programs.nix-ld.libraries = with pkgs; [ ];

  powerManagement.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--print-build-logs"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  security.polkit.enable = true;
  security.protectKernelImage = false;

  environment.etc = {
    "/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla".text = ''
      [Re-enable hibernate by default in upower]
      Identity=unix-user:*
      Action=org.freedesktop.upower.hibernate
      ResultActive=yes

      [Re-enable hibernate by default in logind]
      Identity=unix-user:*
      Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
      ResultActive=yes
    '';
  };

  networking.hostName = "zeus"; # Define your hostname.
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.dpi = 96;
  environment.variables = {
    EDITOR = "hx";
    GDK_SCALE = "0.5";
    QT_STYLE_OVERRIDE = lib.mkDefault "kvantum";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = 1;
  };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  niri.enable = true;

  services.displayManager = {
    sddm = {
      autoLogin.relogin = lib.mkForce false;
      settings.General.MinimumVT = 1;
      wayland.enable = lib.mkDefault true;
    };
    defaultSession = lib.mkDefault "niri";
    autoLogin.enable = lib.mkDefault true;
    autoLogin.user = lib.mkDefault "oliver";
  };
  programs.silentSDDM = {
    enable = true;
    theme = "default";
    backgrounds = {
      "2114" = inputs.wallpapers + "/2114.jpg";
      "IMG_0001" = inputs.wallpapers + "/IMG_0001.JPG";
      windows-11-black =
        inputs.wallpapers + "/wallpaperswide.com-windows-11-black-background-wallpaper-2560x1440.jpg";
    };
    settings = {
      LoginScreen.background = "2114.jpg";
      LockScreen.background = "2114.jpg";
    };
    profileIcons.oliver = builtins.path {
      path = ./files/face.jpeg;
      name = "oliver-face";
    };
  };

  # environment.etc."oliver/face.jpeg".source = ./files/face.jpeg;

  # Set Laptop lid
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  bluetooth.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
    sddm.enableGnomeKeyring = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = false;

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
