{ lib, config, ... }:

{
  options.hermes.enable = lib.mkEnableOption "Enable Hermes Agent";
  config = lib.mkIf config.hermes.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
    };
  };
}
