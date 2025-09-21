{ ... }:

{
  programs.fish.shellAliases = {
    c = "clear";
    sudovim = "sudo -E nvim .";
    vim = "nvim .";
    tb = "cd /mnt/1tb";
    zed = "zeditor .";
  };
}
