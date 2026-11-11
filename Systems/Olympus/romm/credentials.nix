{ config, pkgs, ... }:

{
  systemd.services.romm-credentials = {
    description = "Initialize fresh local RomM credentials without exposing them";
    before = [
      "docker-romm-db.service"
      "docker-romm.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      UMask = "0077";
      ExecStart = "${pkgs.python3}/bin/python3 ${./init-credentials.py} /etc/romm ${config.romm.stateDir}/mysql";
    };
  };
  systemd.services.docker-romm-db = {
    requires = [ "romm-credentials.service" ];
    after = [ "romm-credentials.service" ];
    partOf = [ "romm-credentials.service" ];
  };
  systemd.services.docker-romm = {
    requires = [ "romm-credentials.service" ];
    after = [ "romm-credentials.service" ];
    partOf = [ "romm-credentials.service" ];
  };
}
