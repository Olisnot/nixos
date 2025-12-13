{ config, lib, ... }:

{
  imports = [ ./themes.nix ];

  options.walker.enable =
    lib.mkEnableOption "Enable walker application launcher";

  config = lib.mkIf config.walker.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      config = {
        theme = "stylix";
        placeholders."default" = {
          input = "Search";
          list = "Example";
        };
        providers.prefixes = [
          {
            provider = "websearch";
            prefix = "+";
          }
          {
            provider = "providerlist";
            prefix = "_";
          }
        ];
        keybinds.quick_activate = [ "F1" "F2" "F3" ];
      };
    };
  };
}
