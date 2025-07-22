{ lib, config, ... }:

{
  options = {
    zellij.enable = lib.mkEnableOption "Enable zellij terminal multiplexer";
  };

  imports = [
    ./Layouts
  ];

  config = lib.mkIf config.zellij.enable {
    stylix.targets.zellij.enable = true;
    programs.fish.shellAliases = { zj = "zellij"; };
    programs.zellij = {
      enable = true;
    };
    home.file."zellij_config.kdl" = {
      enable = true;
      target = "/home/oliver/.config/zellij/config.kdl";
      text = ''
      simplified_ui true
      pane_frames false
      show_startup_tips false
      '';
    };
  };
}
