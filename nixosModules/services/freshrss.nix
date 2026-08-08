{lib, config, ...}:

{
  options.freshrss.enable = lib.mkEnableOption "Enable freshrss service";

  config = lib.mkIf config.freshrss.enable {
    services.freshrss.enable = true;
  };
}
