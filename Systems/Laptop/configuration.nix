{ pkgs, inputs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ./packages.nix
    ./fonts.nix
    ./aliases.nix
    ./cachix.nix
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
xremap.mappings.enable = true;
fish.enable = true;

#Nix settings
nix.settings.experimental-features = ["nix-command" "flakes"];
nix.settings.auto-optimise-store = true;

nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

# Bootloader.
boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
  systemd-boot.configurationLimit = 5;
};

security.polkit.enable = true;

networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Kernel parameters
boot.kernelParams = [ "nvidia-drm.modeset=1" ];

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
  EDITOR = "nvim";
  GDK_SCALE = "0.5";
  XCURSOR_THEME = "graphite-cursors";
  QT_STYLE_OVERRIDE ="kvantum";
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
  NIXPKGS_ALLOW_UNFREE=1;
};

hardware = {
  graphics.enable = true;
  nvidia.modesetting.enable = true;
};

xdg.portal.enable = true;
xdg.portal.extraPortals = [
  pkgs.xdg-desktop-portal-gtk 
  pkgs.xdg-desktop-portal-hyprland
];

# Set Hyprland as defaultSession
services.displayManager.defaultSession = "hyprland";
services.xserver.displayManager.gdm = { 
  enable = true;
  wayland = true;
};

programs.spicetify.enable = true;

# Set Laptop lid
services.logind.lidSwitchExternalPower = "ignore";

# Configure keymap in X11
services.xserver = {
  xkb = {
    layout = "us, us";
    variant = ", dvorak";
    options = "grp:alt_shift_toggle";
  };
};

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

services.gnome.gnome-keyring.enable = true;

# Enable Hyprland
hyprland.enable = true;

virtualisation.waydroid.enable = true;

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
