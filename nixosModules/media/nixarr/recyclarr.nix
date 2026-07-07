{ lib, config, ... }:

{
  config = lib.mkIf config.arr.enable {
    nixarr.recyclarr.configuration = {
      sonarr = {
        series = {
          base_url = "http://localhost:8989";
          api_key = "!env_var SONARR_API_KEY";
          quality_definition = {
            type = "series";
          };
          delete_old_custom_formats = true;
          custom_formats = [
            {
              trash_ids = [
                "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
                "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
              ];
              assign_scores_to = [
                {
                  name = "WEB-DL (1080p)";
                  score = -10000;
                }
              ];
            }
          ];
        };
      };
      radarr = {
        movies = {
          base_url = "http://localhost:7878";
          api_key = "!env_var RADARR_API_KEY";
          quality_definition = {
            type = "movie";
          };
          delete_old_custom_formats = true;
          custom_formats = [
            {
              trash_ids = [
                "570bc9ebecd92723d2d21500f4be314c" # Remaster
                "eca37840c13c6ef2dd0262b141a5482f" # 4K Remaster
              ];
              assign_scores_to = [
                {
                  name = "HD Bluray + WEB";
                  score = 25;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
