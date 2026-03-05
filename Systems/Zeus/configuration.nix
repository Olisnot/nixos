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
  ];

  #Custom module options
  nvidia.enable = true;
  gaming.enable = true;
  gaming.steam.enable = true;
  keymapp.enable = true;
  virt-manager.setup = true;
  fish.enable = true;
  syncthing.enable = true;
  navidrome.enable = true;
  spicetify.enable = true;

  #Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  networking.firewall = {
    allowedTCPPorts = [
      20
      21
      4533
      8000
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

  services.tailscale.enable = true;

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
      "--impure"
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
  time.timeZone = "Europe/Madrid";

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
    EDITOR = "nvim";
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
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];

  niri.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
      autoLogin.relogin = true;
      wayland.enable = true;
    };
    defaultSession = "niri";
    autoLogin.enable = true;
    autoLogin.user = "oliver";
  };

  # Set Laptop lid
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  bluetooth.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
