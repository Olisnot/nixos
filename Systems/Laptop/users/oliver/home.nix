{ pkgs, ... }:


{
	imports = [
		./homeModules/default.nix
                ../../modules/homeModules/default.nix
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "neovim";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.graphite-cursors;
    name = "graphite-dark";
    size = 16;
  };

  gtk = {
	  enable = true;
	  theme = {
		  package = pkgs.graphite-gtk-theme;
		  name = "Graphite-Dark";
	  };
	  iconTheme = {
		  package = pkgs.tela-circle-icon-theme;
		  name = "Tela-circle-dark";
	  };

          cursorTheme = {
                  package = pkgs.graphite-cursors;
                  name = "graphite-dark";
                  size = 16;
          };

	  gtk3.extraConfig = {
		  Settings = ''
			  gtk-application-prefer-dark-theme=1
			  '';
	  };

	  gtk4.extraConfig = {
		  Settings = ''
			  gtk-application-prefer-dark-theme=1
			  '';
	  };

  };

  #virt-manager
  dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
      };

      "org/gnome/desktop/background" = {
        picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
      };

      "org/gnome/desktop/interface" = {
	      color-scheme = "prefer-dark";
      };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
  	enable = true;
  };

}
