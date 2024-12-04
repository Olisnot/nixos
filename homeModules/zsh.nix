{ lib, config, ... }:

{
  options = {
    zsh.enable = lib.mkEnableOption "Enable Z shell";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          { name = "sbugzu/gruvbox-zsh"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
    };

  };
}

