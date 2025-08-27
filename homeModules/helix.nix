{ pkgs, lib, config, ... }:

{
  options = {
    helix.enable = lib.mkEnableOption "enable helix text editor";
  };

  config = lib.mkIf config.helix.enable {
    programs.helix = {
      enable = true;
      package = pkgs.evil-helix;
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
        keys.normal = {
          Z.Z = ":wq";
        };
      };
      languages = {
        language-server.nixd = {
          command = "nixd";
          formatting = {
            command = ["alejandra"];
          };
          nixpkgs.expr = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs { }";
          options.nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.bld0.options";
        };
      };
    };
  };
}
