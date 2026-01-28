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
  ghostty.enable = true;
  btop.enable = true;
  opencode.enable = true;
  zed-editor.enable = true;
  helix.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  stylix = {
    targets.waybar.enable = false;
    icons = {
      enable = true;
      package = pkgs.numix-icon-theme-square;
      dark = "Numix Square";
    };
  };

  xdg.desktopEntries."com.github.th_ch.youtube_music" = {
    name = "YouTube Music";
    exec = "${pkgs.pear-desktop}/bin/pear-desktop %u";
    icon = "${pkgs.numix-icon-theme-square}/share/icons/Numix-Square/48/apps/youtube-to-mp3.svg";
    categories = [ "AudioVideo" ];
  };

  # nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };
}
