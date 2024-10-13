{ pkgs, inputs, ... }:


{
	imports =
		[ # Include the results of the hardware scan.
		        inputs.home-manager.nixosModules.default
			inputs.nixvim.nixosModules.nixvim
			./hardware-configuration.nix
			./packages.nix
			./cachix.nix
			./users/oliver.nix
			./modules/Default.nix
		];

	nix.settings.experimental-features = ["nix-command" "flakes"];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.loader.systemd-boot.configurationLimit = 5;

	networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Kernel parameters
		boot.kernelParams = [ "nvidia-drm.modeset=1" ];

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
                XCURSOR_THEME = "graphite-cursors";
		QT_STYLE_OVERRIDE ="kvantum";
		WLR_NO_HARDWARE_CURSORS = "1";
		NIXOS_OZONE_WL = "1";
                DOTNET_CLI_TELEMETRY_OPTOUT = "1";
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
	services.xserver.displayManager = { 
		gdm.enable = true;
	};

# Enable Plasma
	services.desktopManager.plasma6.enable = true;


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
	hardware.pulseaudio.enable = false;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

# Enable Bluetooth
        hardware.enableAllFirmware = true;
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        services.blueman.enable = true;

# Enable Hyprland
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

# Use hyprlock for lock screen
        programs.hyprlock.enable = true;

        virtualisation.waydroid.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;


# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

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
	services.openssh.enable = true;

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
