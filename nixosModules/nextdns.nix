{lib, config, pkgs, ...}:

{
  options = {
    nextdns.enable = lib.mkEnableOption "nextdns";
  };

  config = lib.mkIf config.nextdns.enable {
    #nextdns
    environment.systemPackages = with pkgs; [ nextdns ];
    services.nextdns = {
      enable = true;
      arguments = [ "-config" (builtins.readFile /home/oliver/nextdns) "-cache-size" "10MB" ];
    };

    #activate nextdns on boot
    systemd.services.nextdns-activate = {
      script = ''
      /run/current-system/sw/bin/nextdns activate
      '';
      after = [ "nextdns.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
