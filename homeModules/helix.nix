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
        language = [
            {
              name = "nix";
              auto-format = true;
            }
        ];
        language-server.nixd = {
          command = "nixd";
          args = [ "--semantic-tokens=true"];
          formatting = {
            command = ["nixfmt"];
          };
        config.nixd =
            let
              myFlake = "(builtins.getFlake (toString /home/brisingr/nixos-config))";
              nixosOpts = "${myFlake}.nixosConfigurations.manin.options";
            in
            {
              nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { }";
              formatting.command = [ "nixfmt" ];
              options = {
                nixos.expr = nixosOpts;
                home-manager.expr = "${nixosOpts}.home-manager.users.type.getSubOptions []";
              };
            };
        };
      };
    };
  };
}
