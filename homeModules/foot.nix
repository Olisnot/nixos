{ lib, config, ...}:

{
  options.foot.enable = lib.mkOption "Enable the foot terminal emulator";

  config = lib.mkIf config.foot.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "Fira Code:size=10";
        };
      };
    };
  };
}
