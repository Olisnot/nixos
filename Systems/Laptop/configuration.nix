{ pkgs, inputs, lib, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.default
      ./hardware-configuration.nix
      ./packages.nix
      ./fonts.nix
      ./users/oliver/user.nix
      ../../nixosModules
      ./scripts
    ];

#Custom module options
nvidia.enable = true;
gaming.enable = true;
gaming.steam.enable = true;
opentabletdriverudev.enable = true;
ollama.enable = true;
keymapp.enable = true;
virt-manager.setup = true;
fish.enable = true;
#nextdns.enable = true;
syncthing.enable = true;

#Nix settings
nix.settings.experimental-features = ["nix-command" "flakes"];
nix.settings.auto-optimise-store = true;

nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

# Bootloader.
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
  systemd-boot.configurationLimit = 10;
};

# Garbage collector
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
};

# Enable dynamically linked binaries
programs.nix-ld.enable = true;
programs.nix-ld.libraries = with pkgs; [
];

boot.resumeDevice = "/dev/disk/by-uuid/a357b12d-bc51-4745-9898-4f7bdc59d327";

powerManagement.enable = true;

boot.extraModprobeConfig = ''
options nvidia_modset vblank_sem_control=0
'';

swapDevices = [
  {
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB in MB
  }
];

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

networking.hostName = "zeus"; # Define your hostname.
# networking.wireless.enable = true;  #Enables wireless support via wpa_supplicant.

# Kernel parameters
boot.kernelParams = [ "nvidia-drm.modeset=1" "resume_offset=79960064" ];

# Enable IWD
networking.wireless.iwd.enable = true;
networking.wireless.iwd.settings = {
  IPv6 = {
    Enabled = true;
  };
  Settings = {
    AutoConnect = true;
  };
};

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
  NIXPKGS_ALLOW_UNFREE=1;
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
  xdg-desktop-portal-hyprland
];

# Enable Hyprland
hyprland.enable = true;

# Set Hyprland as defaultSession
services.displayManager.defaultSession = "hyprland";
services.displayManager.gdm = {
  enable = true;
  wayland = true;
};

# Set Laptop lid
services.logind.lidSwitchExternalPower = "ignore";

# Enable CUPS to print documents.
services.printing.enable = true;

# Enable sound with pipewire.
security.rtkit.enable = true;
services.pulseaudio.enable = false;
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  jack.enable = true;
};

# Enable Bluetooth
bluetooth.enable = true;

programs.kdeconnect.enable = true;

services.gnome.gnome-keyring.enable = true;

# Allow unfree packages
nixpkgs.config.allowUnfree = true;
nixpkgs.overlays = [
  inputs.millennium.overlays.default
];

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
