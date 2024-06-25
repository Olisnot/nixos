{ pkgs, config, libs, ... }:

{
    programs.bash.shellAliases = {
        c = "clear";
        sudovim = "sudo -E nvim .";
        vim = "nvim .";
        tb = "cd /mnt/1tb";
        config = "/nixos/OpenConfig.sh";
        rebuild = "/nixos/rebuild.sh";
        cleanGenerations = "/nixos/trim-generations.sh";
    };

}
