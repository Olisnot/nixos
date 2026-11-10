{ ... }:

{
  services.recyclarr = {
    enable = true;
    configuration = {
      sonarr.main = {
        base_url = "http://10.77.0.1:8989";
        api_key._secret = "/etc/recyclarr/sonarr-api-key";
        quality_definition.type = "series";
        delete_old_custom_formats = false;
      };
      radarr.main = {
        base_url = "http://10.77.0.1:7878";
        api_key._secret = "/etc/recyclarr/radarr-api-key";
        quality_definition.type = "movie";
        delete_old_custom_formats = false;
      };
    };
  };

  # First bootstrap the applications and create root-only API-key files on the
  # server. Skip scheduled sync rather than failing when secrets aren't ready.
  systemd.services.recyclarr = {
    serviceConfig = {
      StateDirectoryMode = "0700";
      UMask = "0077";
    };
    unitConfig.ConditionPathExists = [
      "/etc/recyclarr/sonarr-api-key"
      "/etc/recyclarr/radarr-api-key"
    ];
    wants = [
      "sonarr.service"
      "radarr.service"
    ];
    after = [
      "sonarr.service"
      "radarr.service"
    ];
  };
}
