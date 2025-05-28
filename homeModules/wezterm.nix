{ lib, config, ... }:

{
  options = {
    wezterm.enable = lib.mkEnableOption "enable wezterm terminal emulator";
  };

  config = lib.mkIf config.wezterm.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
      return {
        enable_tab_bar = false,
        front_end = "WebGpu",
      }
      '';
    };
  };
}
