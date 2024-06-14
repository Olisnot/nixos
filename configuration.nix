
{ config, lib, pkgs, inputs, ... }:


{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		./packages.nix
        ./alias.nix
        ./cachix.nix
        ./users/oliver.nix
		./modules/nvidia.nix
        ./modules/tmux.nix
        ./modules/virt-manager.nix
        ./modules/hsr.nix
		inputs.home-manager.nixosModules.default
		];

nix.settings.experimental-features = ["nix-command" "flakes"];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
		#networking.networkmanager.enable = true;
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
		GDK_SCALE = "0.5";
        QT_STYLE_OVERRIDE ="kvantum";
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
	};

    hardware = {
        opengl.enable = true;

        nvidia.modesetting.enable = true;
    };

    #xdg.portal.enable = true;
    #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


# Enable and Configure Redshift
    location.provider = "geoclue2";
    services.redshift = {
        enable = true;
        brightness = {
            day = "1";
            night = "1";
        };
        temperature = {
            day = 5500;
            night = 3700;
        };
    };


# Enable Gnome
	services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    

# Enable i3WM
	services.xserver.windowManager.i3.enable = true;

# Set Laptop lid
	services.logind.lidSwitchExternalPower = "ignore";

# Configure keymap in X11
	services.xserver = {
		layout = "us";
		xkbVariant = "";
	};

# Enable CUPS to print documents.
	services.printing.enable = true;

# Enable sound with pipewire.
	sound.enable = true;
	security.rtkit.enable = true;
    hardware.pulseaudio.enable = false;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
        jack.enable = true;
    };

# Enable Hyprland
    programs.hyprland = {
        enable = true;
        #nvidiaPatches = true;
        xwayland.enable = true;
    };

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;


# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
# $ nix search wget

# Enable flatpak
services.flatpak.enable = true;


# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?
}
