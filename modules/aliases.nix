{ ... }:

{
    programs.bash.shellAliases = {
        c = "clear";
        sudovim = "sudo -E nvim .";
        vim = "nvim .";
        tb = "cd /mnt/1tb";
        Obsidian = "cd /home/oliver/Obsidian && tmux new-session -A -s Obsidian";
    };
}
