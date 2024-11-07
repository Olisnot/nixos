{ lib, config, ... }:

{
  options = {
    dropbox.enable = lib.mkEnableOption "Enable dropbox";
  };

  config = lib.mkIf config.dropbox.enable {
    services.dropbox = {
      enable = true;
    };
  };
}
