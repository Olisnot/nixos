{ lib, config, ... }:

{
  options = {
    bash.enable = lib.mkEnableOption "Enable Bash shell";
  };

  config = lib.mkIf config.bash.enable {
    programs.bash = {
      enable = true;

      bashrcExtra = ''
      parse_git_branch() {
        git symbolic-ref --short HEAD 2> /dev/null | sed -E 's/(.+)/ (\1)/g'
      }
      PS1='\n\[\033[1;32m\]\W$(parse_git_branch) -> \[\033[0m\]'
      GITSTATUS_LOG_LEVEL=DEBUG
      '';
    };
  };
}

