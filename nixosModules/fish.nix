{ pkgs, lib, config, ... }:

{
  options = {
    fish.enable = lib.mkEnableOption "Enable friendly interactive shell";
  };

  config = lib.mkIf config.fish.enable {
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

  };
}

