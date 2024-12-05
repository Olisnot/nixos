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

      initExtraFirst = ''
      if [[ -r "\$\{XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\$\{(%):-%n}.zsh" ]];
      then
        source -r "\$\{XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\$\{(%):-%n}.zsh"
      fi
      '';

      initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } 
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
    };

  };
}

