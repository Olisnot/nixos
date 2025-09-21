{ ... }:

{
  imports = [
    ../../../../homeModules
    ./homePackages.nix
    ./stylix.nix
    ./virt-manager.nix
    ./fishAliases.nix
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
  bash.enable = true;
  fish.enable = true;
  fastfetch.enable = true;
  starship.enable = true;
  otd.kamvas13.enable = true;
  gaming = {
    mangohud.enable = true;
    minecraft.enable = true;
  };
  tmux.enable = true;
  ghostty.enable = true;
  zen-browser.enable = true;
  helix.enable = true;
  zed-editor.enable = true;
  waypaper.enable = true;
  nixcord.enable = true;
  waybarConfig.enable = true;
  dunst.enable = true;
  hyprlandConfig.enable = true;
  hyprlockConfig.enable = true;
  mpd.enable = true;
  rmpc.enable = true;
  wofi.enable = true;

  home.sessionVariables = { EDITOR = "nvim"; };

  nixpkgs = { config = { allowUnfree = true; }; };

  # Let Home Manager install and manage itself.
  programs.home-manager = { enable = true; };
}
