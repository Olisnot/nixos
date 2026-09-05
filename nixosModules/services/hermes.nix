{ lib, config, ... }:

{
  options.hermes.enable = lib.mkEnableOption "Enable Hermes Agent";
  config = lib.mkIf config.hermes.enable {
    services.hermes-agent = {
      enable = true;
      addToSystemPackages = true;
      environmentFiles = [ "/var/lib/hermes/env" ];
    };

    # The system-wide CLI uses the service's HERMES_HOME. Its state and
    # generated .env are only accessible to the hermes user and group.
    users.users.oliver.extraGroups = [ "hermes" ];
  };
}
