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
        font-feature = [
          "ss01"
          "ss08"
          "ss02"
        ];
      };
    };
  };
}
