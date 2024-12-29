{ pkgs, lib, inputs, ... }:


{
  imports = [
    ../../../../homeModules
    ./homePackages.nix
  ];
  home.username = "oliver";
  home.homeDirectory = "/home/oliver";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Custom home modules
  hyprlandConfig.enable = true;
  hyprlockConfig.enable = true;
  waybarConfig.enable = true;
  waypaper.enable = true;
  alacrittyConfig.enable = true;
  bash.enable = true;
  fish.enable = true;
  fastfetch.enable = true;
  starship.enable = true;
  dropbox.enable = true;
  otd.kamvas13.enable = true;
  gaming.mangohud.enable = true;
  gaming.emulation.enable = true;
  gaming.emulation.retroarch.enable = true;
  gaming.emulation.ds.enable = true;
  gaming.emulation.playstation2.enable = true;
  gaming.emulation.playstation3.enable = true;
  tmux.enable = true;

  services.hyprpaper.enable = lib.mkForce false; 
  stylix.targets.hyprpaper.enable = lib.mkForce false;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.fish.shellAliases = {
      c = "clear";
      sudovim = "sudo -E nvim .";
      vim = "nvim .";
      tb = "cd /mnt/1tb";
  };

  #virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  nixpkgs = {
    overlays = [
      inputs.nur.overlay
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = { enable = true; };
}
