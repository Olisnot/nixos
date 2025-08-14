{ lib, config, ... }:

{
  imports = [
    #./keybinds.nix
    #./languages.nix
    ./settings.nix
    ./extensions.nix
    ./ai.nix
  ];

  options = {
    zed-editor = {
      enable = lib.mkEnableOption "zed-editor";
    };
  };

  config = lib.mkIf config.zed-editor.enable {
    programs.zed-editor = {
      enable = true;
    };
    stylix.targets.zed-editor.enable = false;
  };  
}
