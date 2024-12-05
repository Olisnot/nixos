{ ... }:

{
  programs = {
    bash.shellAliases = {
      c = "clear";
      sudovim = "sudo -E nvim .";
      vim = "nvim .";
      tb = "cd /mnt/1tb";
    };

    fish.shellAliases = {
      c = "clear";
      sudovim = "sudo -E nvim .";
      vim = "nvim .";
      tb = "cd /mnt/1tb";
    };
  };
}
