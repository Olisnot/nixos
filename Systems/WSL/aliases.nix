{ ... }:

{

  programs.bash.shellAliases = {
    c = "clear";
    sudovim = "sudo -E nvim .";
    vim = "nvim .";
    wslp = "wsl.exe --shutdown";
  };
}
