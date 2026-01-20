{ pkgs, ... }:

{
  imports = [
    ../../../../homeModules
    ./homePackages.nix
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
  librewolf.enable = true;
  fastfetch.enable = true;
  starship.enable = true;
  gaming.mangohud.enable = true;
  tmux.enable = true;
  foot.enable = true;
  waypaper.enable = true;
  waybarConfig.enable = true;
  dunst.enable = true;
  wofi.enable = true;
  btop.enable = true;
  niri.config.enable = true;
  walker.enable = true;
  opencode.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  stylix = {
    targets.waybar.enable = false;
    icons = {
      enable = true;
      package = pkgs.whitesur-icon-theme;
      dark = "WhiteSur";
    };
  };

  xdg.desktopEntries.pear-desktop = {
    name = "Pear Desktop";
    exec = "${pkgs.pear-desktop}/bin/pear-desktop";
    terminal = false;
    icon = "${pkgs.whitesur-icon-theme}/share/icons/WhiteSur-dark/apps/scalable/app.ytmdesktop.ytmdesktop.svg";
  };

  home.file.".local/share/applications/yourapp.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Name=YouTube Music
  Exec=${pkgs.pear-desktop}/bin/pear-desktop %U
  Icon=${pkgs.whitesur-icon-theme}/share/icons/WhiteSur-dark/apps/scalable/app.ytmdesktop.ytmdesktop.svg
  Categories=Utility;
  Terminal=false
  '';


  # nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
}
