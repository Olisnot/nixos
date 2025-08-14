{ lib, config, ... }:

{
  imports = [
    #./keybinds.nix
    #./languages.nix
    ./settings.nix
    ./extensions.nix
  ];

  options = {
    zed-editor = {
      enable = lib.mkEnableOption "zed-editor";
    };
  };

  config = lib.mkIf config.programs.zed-editor.enable {
    programs.zed-editor = {
      enable = true;
    };
  };  
}
