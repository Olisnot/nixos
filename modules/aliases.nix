{ ... }:

{
    programs.bash.shellAliases = {
        c = "clear";
        sudovim = "sudo -E nvim .";
        vim = "nvim .";
        tb = "cd /mnt/1tb";
        config = "/nixos/OpenConfig.sh";
        rebuild = "/nixos/rebuild.sh";
        cleanGenerations = "/nixos/trim-generations.sh";
        Obsidian = "cd /home/oliver/Obsidian && tmux new-session -A -s Obsidian";
    };

}
