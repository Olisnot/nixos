{ pkgs, lib, config, inputs, ...}:

{
  options = {
    anyrun.enable = lib.mkEnableOption "enable anyrun";
  };

  config = lib.mkIf config.anyrun.enable {
    programs.anyrun = {
      enable = true;
      config = {
        x = { fraction = 0.5; };
        y = { fraction = 0.3; };
        width = { fraction = 0.3; };
        hideIcons = false;
        ignoreExclusiveZones = true;
        layer = "top";
        hidePluginInfo = false;
        closeOnClick = false;
        showResultsImmediately = false;
        maxEntries = null;

        plugins = [
          inputs.anyrun.packages.${pkgs.system}.applications
          inputs.anyrun.packages.${pkgs.system}.dictionary
          inputs.anyrun.packages.${pkgs.system}.rink
        ];
      };
    };
  };
}
