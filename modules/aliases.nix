{ config, lib, ... }:

{
  options = {
    aliases.enable = lib.mkEnableOption "Enables Bash aliases";
  };

  config = lib.mkIf config.aliases.enable {
    programs.bash.shellAliases = {
        c = "clear";
        sudovim = "sudo -E nvim .";
        vim = "nvim .";
        tb = "cd /mnt/1tb";
        Obsidian = "cd /home/oliver/Obsidian && tmux new-session -A -s Obsidian";
    };
  };
}
