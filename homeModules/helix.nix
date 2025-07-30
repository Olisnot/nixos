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
    };
  };
}
