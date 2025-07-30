{lib, config, ...}:

{
  options = {
    fastfetch.enable = lib.mkEnableOption "Enable fastfetch";
  };

  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
    };
  };
}
