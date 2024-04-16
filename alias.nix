{ pkgs, config, libs, ... }:

{
    programs.bash.shellAliases = {
        c = "clear";
        vim = "nvim .";
        tb = "cd /mnt/1tb";
    };

}
