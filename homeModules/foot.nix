{ lib, config, ...}:

{
  options.foot.enable = lib.mkEnableOption "Enable the foot terminal emulator";

  config = lib.mkIf config.foot.enable {
    programs.foot = { enable = true; };
  };
}
