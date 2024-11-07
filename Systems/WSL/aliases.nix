{ ... }:

{

  programs.bash.shellAliases = {
    c = "clear";
    sudovim = "sudo -E nvim .";
    vim = "nvim .";
  };
}
