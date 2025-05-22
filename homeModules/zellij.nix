{ lib, config, ... }:

{
  options = {
    zellij.enable = lib.mkEnableOption "Enable zellij terminal multiplexer";
  };

  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "onedark";
        show_startup_tips = false;
      };
    };
  };
}
