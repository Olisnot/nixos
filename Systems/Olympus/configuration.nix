{ modulesPath, config, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  networking = {
    hostName = "olympus";
    useDHCP = true;
    firewall.enable = true;
  };

  # Support both BIOS and UEFI boot. Disko supplies the GRUB disk device.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.qemuGuest.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINA62dZ7Ydm8LZ6cUmWxDl7/cpnqs68Zwwa3L9BCWOdO oliver@olympus"
  ];

  assertions = [
    {
      assertion = config.users.users.root.openssh.authorizedKeys.keys != [ ];
      message = "Olympus requires a root SSH public key in Systems/Olympus/configuration.nix before installation.";
    }
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Keep this at the initial installation's release for future rebuilds.
  system.stateVersion = "26.05";
}
