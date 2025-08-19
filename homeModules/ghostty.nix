{ lib, config, ... }:


{
  options = {
    ghostty.enable = lib.mkEnableOption "enable ghostty terminal";
  };

  config = lib.mkIf config.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        font-feature = [ "ss01" "ss08" "ss02"];
        background-opacity = 0.9;
        background-blur = true;
        theme = "Dark Modern";
      };
    };
  };
}
